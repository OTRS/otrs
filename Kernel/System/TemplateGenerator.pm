# --
# Kernel/System/TemplateGenerator.pm - generate salutations, signatures and responses
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TemplateGenerator.pm,v 1.2 2009-03-09 23:34:47 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TemplateGenerator;

use strict;
use warnings;

use Kernel::System::Salutation;
use Kernel::System::Signature;
use Kernel::System::StdResponse;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::TemplateGenerator - signature lib

=head1 SYNOPSIS

All signature functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::TemplateGenerator;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject   = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TicketObject CustomerUserObject QueueObject UserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SalutationObject} = Kernel::System::Salutation->new(%Param);
    $Self->{SignatureObject}  = Kernel::System::Signature->new(%Param);
    $Self->{StdResponseObject}   = Kernel::System::StdResponse->new(%Param);

    return $Self;
}

=item Salutation()

generate salutation

    my %Salutation = $TemplateGeneratorObject->Salutation(
        TicketID => 123,
        UserID   => 123,
    );

returns
    Text
    ContentType

=cut

sub Salutation {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get  queue
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get salutation
    my %Queue = $Self->{QueueObject}->QueueGet(
        ID => $Ticket{QueueID},
    );
    my %Salutation = $Self->{SalutationObject}->SalutationGet(
        ID => $Queue{SalutationID},
    );

    # replace place holder stuff
    my $SalutationText = $Self->_Replace(
        Text     => $Salutation{Text},
        TicketID => $Param{TicketID},
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

#    $Salutation{ContentType} = 'text/plain';

    return $SalutationText;
}

=item Signature()

generate salutation

    my $Signature = $TemplateGeneratorObject->Signature(
        TicketID => 123,
        UserID   => 123,
    );

returns
    Text
    ContentType

=cut

sub Signature {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get  queue
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get salutation
    my %Queue = $Self->{QueueObject}->QueueGet(
        ID => $Ticket{QueueID},
    );
    my %Signature = $Self->{SignatureObject}->SignatureGet(
        ID => $Queue{SignatureID},
    );

#    my %Signature = $Self->{QueueObject}->GetSignature(
#
#    );

    # replace place holder stuff
    my $SignatureText = $Self->_Replace(
        Text     => $Signature{Text},
        TicketID => $Param{TicketID},
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

#    $Signature{ContentType} = 'text/plain';

    return $SignatureText;
}

=item Response()

generate response

    my %Response = $TemplateGeneratorObject->Response(
        TicketID   => 123,
        ArticleID  => 123,
        ResponseID => 123
        UserID     => 123,
    );

returns
    StdResponse
    Salutation
    Signature

=cut

sub Response {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ResponseID Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get  queue
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get salutation
    my %Queue = $Self->{QueueObject}->QueueGet(
        ID => $Ticket{QueueID},
    );
    my %Response = $Self->{StdResponseObject}->StdResponseGet(
        ID => $Param{ResponseID},
    );

    # replace place holder stuff
    my $ResponseText = $Self->_Replace(
        Text     => $Response{Response} || '-',
        TicketID => $Param{TicketID},
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

    my $Salutation = $Self->Salutation( %Param );

    my $Signature = $Self->Signature( %Param );

#    $Response{ContentType} = 'text/plain';

    return (
        StdResponse => $ResponseText,
        Salutation  => $Salutation,
        Signature   => $Signature,
    );
}

=item Attributes()

generate attributes

    my %Attributes = $TemplateGeneratorObject->Attributes(
        TicketID   => 123,
        ArticleID  => 123,
        ResponseID => 123
        UserID     => 123,
    );

returns
    StdResponse
    Salutation
    Signature

=cut

sub Attributes {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get  queue
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # prepare subject ...
    $Param{Data}->{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Param{Data}->{Subject} || '',
    );

    # get sender attributes
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );

    # prepare realname quote
    if ( $Address{RealName} =~ /(,|@|\(|\)|:)/ && $Address{RealName} !~ /^("|')/ ) {
        $Address{RealName} =~ s/"/\"/g;
        $Address{RealName} = '"' . $Address{RealName} . '"';
    }
    $Param{Data}->{SenderAddress}  = $Address{Email};
    $Param{Data}->{SenderRealname} = $Address{RealName};
    $Param{Data}->{From}           = "$Address{RealName} <$Address{Email}>";

    return %{ $Param{Data} };
}

=item AutoResponse()

generate response

AutoResponse
    TicketID
        Owner
        Responsible
        CUSTOMER_DATA
    ArticleID
        CUSTOMER_SUBJECT
        CUSTOMER_EMAIL
    UserID

    To
    Cc
    Bcc
    Subject
    Body
    ContentType

    my %AutoResponse = $TemplateGeneratorObject->AutoResponse(
        TicketID   => 123,
        ArticleID  => 123,
        AutoResponseType => '',
        UserID     => 123,
    );

=cut

sub AutoResponse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID AutoResponseType UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get  queue
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get auto default responses
    my %AutoResponse = $Self->{AutoResponse}->AutoResponseGetByTypeQueueID(
        QueueID => $Ticket{QueueID},
        Type    => $Param{AutoResponseType},
    );

    # replace place holder stuff
    $AutoResponse{Text} = $Self->_Replace( Text => $AutoResponse{AutoResponse} );

    $AutoResponse{ContentType} = 'text/plain';

    # get sender attributes
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );
    $AutoResponse{SenderAddress}  = $Address{Email};
    $AutoResponse{SenderRealname} = $Address{RealName};

    return %AutoResponse;
}

=item NotificationAgent()

generate response

NotifcationAgent
    TicketID
        Owner
        Responsible
        CUSTOMER_DATA
    ArticleID
        CUSTOMER_SUBJECT
        CUSTOMER_EMAIL
    UserID

    To
    Cc
    Bcc
    Subject
    Body
    ContentType
    SenderAddress
    SenderRealname

    my %NotificationAgent = $TemplateGeneratorObject->NotificationAgent(
        Type        => 'Move', # notification types, see database
        TicketID    => 123,
        ArticleID   => 123,
        RecipientID => 123,
        UserID      => 123,
    );

=cut

sub NotificationAgent {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Type UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %User = ();

    # get user language
    my $Language = $User{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';

    # get notification data
    my %Notification = $Self->{NotificationObject}->NotificationGet(
        Name => $Language . '::Agent::' . $Param{Type},
    );

    # get notify texts
    for (qw(Subject Body)) {
        if ( !$Notification{$_} ) {
            $Notification{$_} = "No Notification $_ for $Param{Type} found!";
        }
    }

    # replace place holder stuff
    for (qw(Subject Body)) {
        $Notification{$_} = $Self->_Replace( Text => $Notification{$_} );
    }

    $Notification{ContentType} = 'text/plain';

    return %Notification;
}

=item NotificationCustomer()

generate response

NotifcationCustomer
    TicketID
        Owner
        Responsible
        CUSTOMER_DATA
    ArticleID
        CUSTOMER_SUBJECT
        CUSTOMER_EMAIL
    UserID

    To
    Cc
    Bcc
    Subject
    Body
    ContentType
    SenderAddress
    SenderRealname

    my %NotificationCustomer = $TemplateGeneratorObject->NotificationCustomer(
        Type       => 'Move', # notification types, see database
        TicketID   => 123,
        ArticleID  => 123,
        NotificationCustomerID => 123
        UserID     => 123,
    );

=cut

sub NotificationCustomer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Type UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    my %User = ();

    # get user language
    my $Language = $User{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';

    # get notification data
    my %Notification = $Self->{NotificationObject}->NotificationGet(
        Name => $Language . '::Customer::' . $Param{Type},
    );

    # get notify texts
    for (qw(Subject Body)) {
        if ( !$Notification{$_} ) {
            $Notification{$_} = "No Notification $_ for $Param{Type} found!";
        }
    }

    # replace place holder stuff
    for (qw(Subject Body)) {
        $Notification{$_} = $Self->_Replace( Text => $Notification{$_} );
    }

    $Notification{ContentType} = 'text/plain';

    # get sender attributes
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );
    $Notification{SenderAddress}  = $Address{Email};
    $Notification{SenderRealname} = $Address{RealName};

    return %Notification;
}

sub _Replace {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Text TicketID Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Ticket;
    if ( $Param{TicketID} ) {
        %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );
    }

    # replace config options
    $Param{Text} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Param{Text} =~ s/<OTRS_CONFIG_.+?>/-/gi;

    # get owner data and replace it with <OTRS_OWNER_...
    if ( $Ticket{OwnerID} ) {
        my %Owner = $Self->{UserObject}->GetUserData(
            UserID => $Ticket{OwnerID},
        );
        for ( keys %Owner ) {
            if ( $Owner{$_} ) {
                $Param{Text} =~ s/<OTRS_OWNER_$_>/$Owner{$_}/gi;
            }
        }
    }

    # cleanup
    $Param{Text} =~ s/<OTRS_OWNER_.+?>/-/gi;

    # get owner data and replace it with <OTRS_RESPONSIBLE_...
    if ( $Ticket{ResponsibleID} ) {
        my %Responsible = $Self->{UserObject}->GetUserData(
            UserID => $Ticket{ResponsibleID},
        );
        for ( keys %Responsible ) {
            if ( $Responsible{$_} ) {
                $Param{Text} =~ s/<OTRS_RESPONSIBLE_$_>/$Responsible{$_}/gi;
            }
        }
    }

    # cleanup
    $Param{Text} =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;

    my %CurrentUser = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );
    for ( keys %CurrentUser ) {
        if ( $CurrentUser{$_} ) {
            $Param{Text} =~ s/<OTRS_Agent_$_>/$CurrentUser{$_}/gi;
            $Param{Text} =~ s/<OTRS_CURRENT_$_>/$CurrentUser{$_}/gi;
        }
    }

    # replace other needed stuff
    $Param{Text} =~ s/<OTRS_FIRST_NAME>/$CurrentUser{UserFirstname}/g;
    $Param{Text} =~ s/<OTRS_LAST_NAME>/$CurrentUser{UserLastname}/g;

    # cleanup
    $Param{Text} =~ s/<OTRS_CURRENT_.+?>/-/gi;

#    # replace it with given user params
#    for ( keys %User ) {
#        if ( $User{$_} ) {
#            $Notification{Body}    =~ s/<OTRS_$_>/$User{$_}/gi;
#            $Notification{Subject} =~ s/<OTRS_$_>/$User{$_}/gi;
#        }
#    }

    # ticket data
    if ( $Param{TicketID} ) {
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );
        for ( keys %Ticket ) {
            if ( defined $Ticket{$_} ) {
                $Param{Text} =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
            }
        }
    }

    # cleanup
    $Param{Text} =~ s/<OTRS_TICKET_.+?>/-/gi;

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    if ( $Ticket{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );

        # replace customer stuff with tags
        for ( keys %CustomerUser ) {
            if ( $CustomerUser{$_} ) {
                $Param{Text} =~ s/<OTRS_CUSTOMER_$_>/$CustomerUser{$_}/gi;
                $Param{Text} =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
            }
        }
    }

    # get and prepare realname
    if ( $Param{Text} =~ /<OTRS_CUSTOMER_REALNAME>/ ) {
        my $From = '';
        if ( $Ticket{CustomerUserID} ) {
            $From = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $Ticket{CustomerUserID}
            );
        }
        if ( !$From ) {
            $From = $Param{Data}->{To} || '';
            $From =~ s/<.*>|\(.*\)|\"|;|,//g;
            $From =~ s/( $)|(  $)//g;
        }
        $Param{Text} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Param{Text} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
    $Param{Text} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

    return $Param{Text};
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2009-03-09 23:34:47 $

=cut
