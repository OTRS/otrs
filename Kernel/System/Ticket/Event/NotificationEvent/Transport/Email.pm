# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent::Transport::Email;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
## nofilter(TidyAll::Plugin::OTRS::Perl::ParamObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

use base qw(Kernel::System::Ticket::Event::NotificationEvent::Transport::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::Email',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
    'Kernel::System::Ticket',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
    'Kernel::System::Crypt::PGP',
    'Kernel::System::Crypt::SMIME',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

=head1 NAME

Kernel::System::Ticket::Event::NotificationEvent::Transport::Email - email transport layer

=head1 SYNOPSIS

Notification event transport layer.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a notification transport object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new('');
    my $TransportObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent::Transport::Email');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub SendNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID UserID Notification Recipient)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need $Needed!',
            );
            return;
        }
    }

    # cleanup event data
    $Self->{EventData} = undef;

    # get needed objects
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get recipient data
    my %Recipient = %{ $Param{Recipient} };

    # Verify a customer have an email
    if ( $Recipient{Type} eq 'Customer' && $Recipient{UserID} && !$Recipient{UserEmail} ) {

        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Recipient{UserID},
        );

        if ( !$CustomerUser{UserEmail} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Send no customer notification because of missing "
                    . "customer email (CustomerUserID=$CustomerUser{CustomerUserID})!",
            );
            return;
        }

        # Set calculated email.
        $Recipient{UserEmail} = $CustomerUser{UserEmail};
    }

    return if !$Recipient{UserEmail};

    return if $Recipient{UserEmail} !~ /@/;

    my $IsLocalAddress = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
        Address => $Recipient{UserEmail},
    );

    return if $IsLocalAddress;

    # create new array to prevent attachment growth (see bug#5114)
    my @Attachments = @{ $Param{Attachments} };

    my %Notification = %{ $Param{Notification} };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if ( $Param{Notification}->{ContentType} && $Param{Notification}->{ContentType} eq 'text/html' ) {

        # Get configured template with fallback to Default.
        my $EmailTemplate = $Param{Notification}->{Data}->{TransportEmailTemplate}->[0] || 'Default';

        my $Home              = $Kernel::OM->Get('Kernel::Config')->Get('Home');
        my $TemplateDir       = "$Home/Kernel/Output/HTML/Templates/Standard/NotificationEvent/Email";
        my $CustomTemplateDir = "$Home/Custom/Kernel/Output/HTML/Templates/Standard/NotificationEvent/Email";

        if ( !-r "$TemplateDir/$EmailTemplate.tt" && !-r "$CustomTemplateDir/$EmailTemplate.tt" ) {
            $EmailTemplate = 'Default';
        }

        # generate HTML
        $Notification{Body} = $LayoutObject->Output(
            TemplateFile => "NotificationEvent/Email/$EmailTemplate",
            Data         => {
                TicketID => $Param{TicketID},
                Body     => $Notification{Body},
                Subject  => $Notification{Subject},
            },
        );
    }

    # send notification
    if ( $Recipient{Type} eq 'Agent' ) {

        my $FromEmail = $ConfigObject->Get('NotificationSenderEmail');

        # send notification
        my $From = $ConfigObject->Get('NotificationSenderName') . ' <'
            . $FromEmail . '>';

        # security part
        my $SecurityOptions = $Self->SecurityOptionsGet( %Param, FromEmail => $FromEmail );
        return if !$SecurityOptions;

        # get needed objects
        my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

        my $Sent = $EmailObject->Send(
            From       => $From,
            To         => $Recipient{UserEmail},
            Subject    => $Notification{Subject},
            MimeType   => $Notification{ContentType},
            Type       => $Notification{ContentType},
            Charset    => 'utf-8',
            Body       => $Notification{Body},
            Loop       => 1,
            Attachment => $Param{Attachments},
            %{$SecurityOptions},
        );

        if ( !$Sent ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "'$Notification{Name}' notification could not be sent to agent '$Recipient{UserEmail} ",
            );

            return;
        }

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent agent '$Notification{Name}' notification to '$Recipient{UserEmail}'.",
        );

        # set event data
        $Self->{EventData} = {
            Event => 'ArticleAgentNotification',
            Data  => {
                TicketID => $Param{TicketID},
            },
            UserID => $Param{UserID},
        };
    }
    else {

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        my $QueueID;

        # get article
        my %Article = $TicketObject->ArticleLastCustomerArticle(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
        );

        # set "From" address from Article if exist, otherwise use ticket information, see bug# 9035
        if (%Article) {
            $QueueID = $Article{QueueID};
        }
        else {

            # get ticket data
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $Param{TicketID},
            );
            $QueueID = $Ticket{QueueID};
        }

        my %Address = $QueueObject->GetSystemAddress( QueueID => $QueueID );

        # get queue
        my %Queue = $QueueObject->QueueGet(
            ID => $QueueID,
        );

        # security part
        my $SecurityOptions = $Self->SecurityOptionsGet(
            %Param,
            FromEmail => $Address{Email},
            Queue     => \%Queue
        );
        return if !$SecurityOptions;

        my $ArticleType = 'email-notification-ext';

        if ( IsArrayRefWithData( $Param{Notification}->{Data}->{NotificationArticleTypeID} ) ) {

            # get notification article type
            $ArticleType = $TicketObject->ArticleTypeLookup(
                ArticleTypeID => $Param{Notification}->{Data}->{NotificationArticleTypeID}->[0],
            );
        }

        my $ArticleID = $TicketObject->ArticleSend(
            ArticleType    => $ArticleType,
            SenderType     => 'system',
            TicketID       => $Param{TicketID},
            HistoryType    => 'SendCustomerNotification',
            HistoryComment => "\%\%$Recipient{UserEmail}",
            From           => "$Address{RealName} <$Address{Email}>",
            To             => $Recipient{UserEmail},
            Subject        => $Notification{Subject},
            Body           => $Notification{Body},
            MimeType       => $Notification{ContentType},
            Type           => $Notification{ContentType},
            Charset        => 'utf-8',
            UserID         => $Param{UserID},
            Loop           => 1,
            Attachment     => $Param{Attachments},
            %{$SecurityOptions},
        );

        if ( !$ArticleID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "'$Notification{Name}' notification could not be sent to customer '$Recipient{UserEmail} ",
            );

            return;
        }

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent customer '$Notification{Name}' notification to '$Recipient{UserEmail}'.",
        );

        # set event data
        $Self->{EventData} = {
            Event => 'ArticleCustomerNotification',
            Data  => {
                TicketID  => $Param{TicketID},
                ArticleID => $ArticleID,
            },
            UserID => $Param{UserID},
        };
    }

    return 1;
}

sub GetTransportRecipients {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Notification)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
        }
    }

    my @Recipients;

    # get recipients by RecipientEmail
    if ( $Param{Notification}->{Data}->{RecipientEmail} ) {
        if ( $Param{Notification}->{Data}->{RecipientEmail}->[0] ) {
            my $RecipientEmail = $Param{Notification}->{Data}->{RecipientEmail}->[0];

            # replace OTRSish attributes in recipient email
            $RecipientEmail = $Self->_ReplaceTicketAttributes(
                Ticket => $Param{Ticket},
                Field  => $RecipientEmail,
            );

            my %Recipient;
            $Recipient{Realname}  = '';
            $Recipient{Type}      = 'Customer';
            $Recipient{UserEmail} = $RecipientEmail;

            # check if we have a specified article type
            if ( $Param{Notification}->{Data}->{NotificationArticleTypeID} ) {
                $Recipient{NotificationArticleType} = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleTypeLookup(
                    ArticleTypeID => $Param{Notification}->{Data}->{NotificationArticleTypeID}->[0]
                ) || 'email-notification-ext';
            }

            # check recipients
            if ( $Recipient{UserEmail} && $Recipient{UserEmail} =~ /@/ ) {
                push @Recipients, \%Recipient;
            }
        }
    }

    return @Recipients;
}

sub TransportSettingsDisplayGet {
    my ( $Self, %Param ) = @_;

    KEY:
    for my $Key (qw(RecipientEmail)) {
        next KEY if !$Param{Data}->{$Key};
        next KEY if !defined $Param{Data}->{$Key}->[0];
        $Param{$Key} = $Param{Data}->{$Key}->[0];
    }

    my $Home              = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $TemplateDir       = "$Home/Kernel/Output/HTML/Templates/Standard/NotificationEvent/Email";
    my $CustomTemplateDir = "$Home/Custom/Kernel/Output/HTML/Templates/Standard/NotificationEvent/Email";

    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $TemplateDir,
        Filter    => '*.tt',
    );
    if ( -d $CustomTemplateDir ) {
        push @Files, $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $CustomTemplateDir,
            Filter    => '*.tt',
        );
    }

    # for deduplication
    my %Templates;

    for my $File (@Files) {
        $File =~ s{^.*/([^/]+)\.tt}{$1}smxg;
        $Templates{$File} = $File;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Display article types for article creation if notification is sent
    # only use 'email-notification-*'-type articles
    my %NotificationArticleTypes = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleTypeList( Result => 'HASH' );
    for my $NotifArticleTypeID ( sort keys %NotificationArticleTypes ) {
        if ( $NotificationArticleTypes{$NotifArticleTypeID} !~ /^email-notification-/ ) {
            delete $NotificationArticleTypes{$NotifArticleTypeID};
        }
    }
    $Param{NotificationArticleTypesStrg} = $LayoutObject->BuildSelection(
        Data        => \%NotificationArticleTypes,
        Name        => 'NotificationArticleTypeID',
        Translation => 1,
        SelectedID  => $Param{Data}->{NotificationArticleTypeID},
        Class       => 'Modernize W50pc',
    );

    $Param{TransportEmailTemplateStrg} = $LayoutObject->BuildSelection(
        Data        => \%Templates,
        Name        => 'TransportEmailTemplate',
        Translation => 0,
        SelectedID  => $Param{Data}->{TransportEmailTemplate},
        Class       => 'Modernize W50pc',
    );

    # security fields

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %SecuritySignEncryptOptions;

    if ( $ConfigObject->Get('PGP') ) {
        $SecuritySignEncryptOptions{'PGPSign'}      = Translatable('PGP sign only');
        $SecuritySignEncryptOptions{'PGPCrypt'}     = Translatable('PGP encrypt only');
        $SecuritySignEncryptOptions{'PGPSignCrypt'} = Translatable('PGP sign and encrypt');
    }

    if ( $ConfigObject->Get('SMIME') ) {
        $SecuritySignEncryptOptions{'SMIMESign'}      = Translatable('SMIME sign only');
        $SecuritySignEncryptOptions{'SMIMECrypt'}     = Translatable('SMIME encrypt only');
        $SecuritySignEncryptOptions{'SMIMESignCrypt'} = Translatable('SMIME sign and encrypt');
    }

    # set security settings enabled
    $Param{EmailSecuritySettings} = ( $Param{Data}->{EmailSecuritySettings} ? 'checked="checked"' : '' );
    $Param{SecurityDisabled} = 0;

    if ( $Param{EmailSecuritySettings} eq '' ) {
        $Param{SecurityDisabled} = 1;
    }

    if ( !IsHashRefWithData( \%SecuritySignEncryptOptions ) ) {
        $Param{EmailSecuritySettings} = 'disabled="disabled"';
        $Param{EmailSecurityInfo}     = Translatable('PGP and SMIME not enabled.');
    }

    # create security methods field
    $Param{EmailSigningCrypting} = $LayoutObject->BuildSelection(
        Data         => \%SecuritySignEncryptOptions,
        Name         => 'EmailSigningCrypting',
        SelectedID   => $Param{Data}->{EmailSigningCrypting},
        Class        => 'Security Modernize W50pc',
        Multiple     => 0,
        Translation  => 1,
        PossibleNone => 1,
        Disabled     => $Param{SecurityDisabled},
    );

    # create missing signing actions field
    $Param{EmailMissingSigningKeys} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'Skip',
                Value => Translatable('Skip notification delivery'),
            },
            {
                Key   => 'Send',
                Value => Translatable('Send unsigned notification'),
            },
        ],
        Name        => 'EmailMissingSigningKeys',
        SelectedID  => $Param{Data}->{EmailMissingSigningKeys},
        Class       => 'Security Modernize W50pc',
        Multiple    => 0,
        Translation => 1,
        Disabled    => $Param{SecurityDisabled},
    );

    # create missing crypting actions field
    $Param{EmailMissingCryptingKeys} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'Skip',
                Value => Translatable('Skip notification delivery'),
            },
            {
                Key   => 'Send',
                Value => Translatable('Send unencrypted notification'),
            },
        ],
        Name        => 'EmailMissingCryptingKeys',
        SelectedID  => $Param{Data}->{EmailMissingCryptingKeys},
        Class       => 'Security Modernize W50pc',
        Multiple    => 0,
        Translation => 1,
        Disabled    => $Param{SecurityDisabled},
    );

    # generate HTML
    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminNotificationEventTransportEmailSettings',
        Data         => \%Param,
    );

    return $Output;
}

sub TransportParamSettingsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(GetParam)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
        }
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    PARAMETER:
    for my $Parameter (
        qw(RecipientEmail NotificationArticleTypeID TransportEmailTemplate
        EmailSigningCrypting EmailMissingSigningKeys EmailMissingCryptingKeys
        EmailSecuritySettings)
        )
    {
        my @Data = $ParamObject->GetArray( Param => $Parameter );
        next PARAMETER if !@Data;
        $Param{GetParam}->{Data}->{$Parameter} = \@Data;
    }

    # Note: Example how to set errors and use them
    # on the normal AdminNotificationEvent screen
    # # set error
    # $Param{GetParam}->{$Parameter.'ServerError'} = 'ServerError';

    return 1;
}

sub IsUsable {
    my ( $Self, %Param ) = @_;

    # define if this transport is usable on
    # this specific moment
    return 1;
}

sub SecurityOptionsGet {
    my ( $Self, %Param ) = @_;

    # Verify security options are enabled.
    my $EnableSecuritySettings = $Param{Notification}->{Data}->{EmailSecuritySettings}->[0] || '';

    # Return empty hash ref to continue with email sending (without security options).
    return {} if !$EnableSecuritySettings;

    # Verify if the notification has to be signed or encrypted
    my $SignEncryptNotification = $Param{Notification}->{Data}->{EmailSigningCrypting}->[0] || '';

    # Return empty hash ref to continue with email sending (without security options).
    return {} if !$SignEncryptNotification;

    my %Queue = %{ $Param{Queue} || {} };

    # Define who is going to be the sender (from the given parameters)
    my $NotificationSenderEmail = $Param{FromEmail};

    # Define security options container
    my %SecurityOptions;
    my @SignKeys;
    my @EncryptKeys;
    my $KeyField;
    my $Method;
    my $Subtype = 'Detached';

    # Get private and public keys for the given backend (PGP or SMIME)
    if ( $SignEncryptNotification =~ /^PGP/i ) {
        @SignKeys = $Kernel::OM->Get('Kernel::System::Crypt::PGP')->PrivateKeySearch(
            Search => $NotificationSenderEmail,
        );

        # take just valid keys
        @SignKeys = grep { $_->{Status} eq 'good' } @SignKeys;

        # get public keys
        @EncryptKeys = $Kernel::OM->Get('Kernel::System::Crypt::PGP')->PublicKeySearch(
            Search => $Param{Recipient}->{UserEmail},
        );

        # Get PGP method (Detached or In-line).
        if ( !$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{BrowserRichText} ) {
            $Subtype = $Kernel::OM->Get('Kernel::Config')->Get('PGP::Method') || 'Detached';
        }
        $Method   = 'PGP';
        $KeyField = 'Key';
    }
    elsif ( $SignEncryptNotification =~ /^SMIME/i ) {
        @SignKeys = $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->PrivateSearch(
            Search => $NotificationSenderEmail,
        );

        @EncryptKeys = $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->CertificateSearch(
            Search => $Param{Recipient}->{UserEmail},
        );

        $Method   = 'SMIME';
        $KeyField = 'Filename';
    }

    # Initialize sign key container
    my %SignKey;

    # Initialize crypt key container
    my %EncryptKey;

    # Get default signing key from the queue (if applies).
    if ( $Queue{DefaultSignKey} ) {

        my $DefaultSignKey;

        # Convert legacy stored default sign keys.
        if ( $Queue{DefaultSignKey} =~ m{ (?: Inline|Detached ) }msx ) {
            my ( $Type, $SubType, $Key ) = split /::/, $Queue{DefaultSignKey};
            $DefaultSignKey = $Key;
        }
        else {
            my ( $Type, $Key ) = split /::/, $Queue{DefaultSignKey};
            $DefaultSignKey = $Key;
        }

        if ( grep { $_->{$KeyField} eq $DefaultSignKey } @SignKeys ) {
            $SignKey{$KeyField} = $DefaultSignKey;
        }
    }

    # Otherwise take the first signing key available.
    if ( !%SignKey ) {
        SIGNKEY:
        for my $SignKey (@SignKeys) {
            %SignKey = %{$SignKey};
            last SIGNKEY;
        }
    }

    # Also take the first encryption key available.
    CRYPTKEY:
    for my $EncryptKey (@EncryptKeys) {
        %EncryptKey = %{$EncryptKey};
        last CRYPTKEY;
    }

    my $OnMissingSigningKeys = $Param{Notification}->{Data}->{EmailMissingSigningKeys}->[0] || '';

    # Add options to sign the notification
    if ( $SignEncryptNotification =~ /Sign/i ) {

        # Take an action if there are missing signing keys.
        if ( !IsHashRefWithData( \%SignKey ) ) {

            my $Message
                = "Could not sign notification '$Param{Notification}->{Name}' due to missing $Method sign key for '$NotificationSenderEmail'";

            if ( $OnMissingSigningKeys eq 'Skip' ) {

                # Log skipping notification (return nothing to stop email sending).
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => $Message . ', skipping notification distribution!',
                );

                return;
            }

            # Log sending unsigned notification.
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => $Message . ', sending unsigned!',
            );
        }

        # Add signature option if a sign key is available
        else {
            $SecurityOptions{Sign} = {
                Type    => $Method,
                SubType => $Subtype,
                Key     => $SignKey{$KeyField},
            };
        }
    }

    my $OnMissingEncryptionKeys = $Param{Notification}->{Data}->{EmailMissingCryptingKeys}->[0] || '';

    # Add options to encrypt the notification
    if ( $SignEncryptNotification =~ /Crypt/i ) {

        # Take an action if there are missing encryption keys.
        if ( !IsHashRefWithData( \%EncryptKey ) ) {

            my $Message
                = "Could not encrypt notification '$Param{Notification}->{Name}' due to missing $Method encryption key for '$Param{Recipient}->{UserEmail}'";

            if ( $OnMissingEncryptionKeys eq 'Skip' ) {

                # Log skipping notification (return nothing to stop email sending).
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => $Message . ', skipping notification distribution!',
                );

                return;
            }

            # Log sending unencrypted notification.
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => $Message . ', sending unencrypted!',
            );
        }

        # Add encrypt option if a encrypt key is available
        else {
            $SecurityOptions{Crypt} = {
                Type    => $Method,
                SubType => $Subtype,
                Key     => $EncryptKey{$KeyField},
            };
        }
    }

    return \%SecurityOptions;

}

sub _ReplaceTicketAttributes {
    my ( $Self, %Param ) = @_;

    return if !$Param{Field};

    # get needed objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # replace ticket attributes such as <OTRS_Ticket_DynamicField_Name1> or
    # <OTRS_TICKET_DynamicField_Name1>
    # <OTRS_Ticket_*> is deprecated and should be removed in further versions of OTRS
    my $Count = 0;
    REPLACEMENT:
    while (
        $Param{Field}
        && $Param{Field} =~ m{<OTRS_TICKET_([A-Za-z0-9_]+)>}msxi
        && $Count++ < 1000
        )
    {
        my $TicketAttribute = $1;

        if ( $TicketAttribute =~ m{DynamicField_(\S+?)_Value} ) {
            my $DynamicFieldName = $1;

            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );
            next REPLACEMENT if !$DynamicFieldConfig;

            # get the display value for each dynamic field
            my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                DynamicFieldConfig => $DynamicFieldConfig,
                Key                => $Param{Ticket}->{"DynamicField_$DynamicFieldName"},
            );

            my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $DisplayValue,
            );

            $Param{Field} =~ s{<OTRS_TICKET_$TicketAttribute>}{$DisplayValueStrg->{Value} // ''}ige;

            next REPLACEMENT;
        }

        # if ticket value is scalar substitute all instances (as strings)
        # this will allow replacements for "<OTRS_TICKET_Title> <OTRS_TICKET_Queue"
        if ( !ref $Param{Ticket}->{$TicketAttribute} ) {
            $Param{Field} =~ s{<OTRS_TICKET_$TicketAttribute>}{$Param{Ticket}->{$TicketAttribute} // ''}ige;
        }
        else {
            # if the value is an array (e.g. a multiselect dynamic field) set the value directly
            # this unfortunately will not let a combination of values to be replaced
            $Param{Field} = $Param{Ticket}->{$TicketAttribute};
        }
    }

    return $Param{Field};
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
