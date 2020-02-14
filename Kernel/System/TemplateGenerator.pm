# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::TemplateGenerator;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

use strict;
use warnings;

use Kernel::Language;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AutoResponse',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::Salutation',
    'Kernel::System::Signature',
    'Kernel::System::StandardTemplate',
    'Kernel::System::SystemAddress',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::TemplateGenerator - signature lib

=head1 DESCRIPTION

All signature functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{RichText} = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::RichText');

    return $Self;
}

=head2 Salutation()

generate salutation

    my $Salutation = $TemplateGeneratorObject->Salutation(
        TicketID => 123,
        UserID   => 123,
        Data     => $ArticleHashRef,
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # Get ticket.
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # Get queue.
    my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
        ID => $Ticket{QueueID},
    );

    # Get salutation.
    my %Salutation = $Kernel::OM->Get('Kernel::System::Salutation')->SalutationGet(
        ID => $Queue{SalutationID},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Salutation{ContentType} =~ /text\/plain/i ) {
        $Salutation{ContentType} = 'text/html';
        $Salutation{Text}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
            String => $Salutation{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Salutation{ContentType} =~ /text\/html/i ) {
        $Salutation{ContentType} = 'text/plain';
        $Salutation{Text}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Salutation{Text},
        );
    }

    # get list unsupported tags for standard template
    my @ListOfUnSupportedTag = qw(OTRS_AGENT_SUBJECT OTRS_AGENT_BODY OTRS_CUSTOMER_BODY OTRS_CUSTOMER_SUBJECT);

    my $SalutationText = $Self->_RemoveUnSupportedTag(
        Text                 => $Salutation{Text} || '',
        ListOfUnSupportedTag => \@ListOfUnSupportedTag,
    );

    # replace place holder stuff
    $SalutationText = $Self->_Replace(
        RichText   => $Self->{RichText},
        Text       => $SalutationText,
        TicketData => \%Ticket,
        Data       => $Param{Data},
        UserID     => $Param{UserID},
    );

    # add urls
    if ( $Self->{RichText} ) {
        $SalutationText = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $SalutationText,
        );
    }

    return $SalutationText;
}

=head2 Signature()

generate salutation

    my $Signature = $TemplateGeneratorObject->Signature(
        TicketID => 123,
        UserID   => 123,
        Data     => $ArticleHashRef,
    );

or

    my $Signature = $TemplateGeneratorObject->Signature(
        QueueID => 123,
        UserID  => 123,
        Data    => $ArticleHashRef,
    );

returns
    Text
    ContentType

=cut

sub Signature {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # need ticket id or queue id
    if ( !$Param{TicketID} && !$Param{QueueID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID or QueueID!'
        );
        return;
    }

    # Get ticket data.
    my %Ticket;
    if ( $Param{TicketID} ) {
        %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 1,
        );
    }

    # Get queue.
    my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
        ID => $Ticket{QueueID} || $Param{QueueID},
    );

    # Get signature.
    my %Signature = $Kernel::OM->Get('Kernel::System::Signature')->SignatureGet(
        ID => $Queue{SignatureID},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Signature{ContentType} =~ /text\/plain/i ) {
        $Signature{ContentType} = 'text/html';
        $Signature{Text}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
            String => $Signature{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Signature{ContentType} =~ /text\/html/i ) {
        $Signature{ContentType} = 'text/plain';
        $Signature{Text}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Signature{Text},
        );
    }

    # get list unsupported tags for standard template
    my @ListOfUnSupportedTag = qw(OTRS_AGENT_SUBJECT OTRS_AGENT_BODY OTRS_CUSTOMER_BODY OTRS_CUSTOMER_SUBJECT);

    my $SignatureText = $Self->_RemoveUnSupportedTag(
        Text                 => $Signature{Text} || '',
        ListOfUnSupportedTag => \@ListOfUnSupportedTag,
    );

    # replace place holder stuff
    $SignatureText = $Self->_Replace(
        RichText   => $Self->{RichText},
        Text       => $SignatureText,
        TicketData => \%Ticket,
        Data       => $Param{Data},
        QueueID    => $Param{QueueID},
        UserID     => $Param{UserID},
    );

    # add urls
    if ( $Self->{RichText} ) {
        $SignatureText = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $SignatureText,
        );
    }

    return $SignatureText;
}

=head2 Sender()

generate sender address (FROM string) for emails

    my $Sender = $TemplateGeneratorObject->Sender(
        QueueID    => 123,
        UserID     => 123,
    );

returns:

    John Doe at Super Support <service@example.com>

and it returns the quoted real name if necessary

    "John Doe, Support" <service@example.tld>

=cut

sub Sender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw( UserID QueueID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get sender attributes
    my %Address = $Kernel::OM->Get('Kernel::System::Queue')->GetSystemAddress(
        QueueID => $Param{QueueID},
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check config for agent real name
    my $UseAgentRealName = $ConfigObject->Get('Ticket::DefineEmailFrom');
    if ( $UseAgentRealName && $UseAgentRealName =~ /^(AgentName|AgentNameSystemAddressName)$/ ) {

        # get data from current agent
        my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID        => $Param{UserID},
            NoOutOfOffice => 1,
        );

        # set real name with user name
        if ( $UseAgentRealName eq 'AgentName' ) {

            # check for user data
            if ( $UserData{UserFullname} ) {

                # rewrite RealName
                $Address{RealName} = "$UserData{UserFullname}";
            }
        }

        # set real name with user name
        if ( $UseAgentRealName eq 'AgentNameSystemAddressName' ) {

            # check for user data
            if ( $UserData{UserFullname} ) {

                # rewrite RealName
                my $Separator = ' ' . $ConfigObject->Get('Ticket::DefineEmailFromSeparator')
                    || '';
                $Address{RealName} = $UserData{UserFullname} . $Separator . ' ' . $Address{RealName};
            }
        }
    }

    # prepare realname quote
    if ( $Address{RealName} =~ /([.]|,|@|\(|\)|:)/ && $Address{RealName} !~ /^("|')/ ) {
        $Address{RealName} =~ s/"//g;    # remove any quotes that are already present
        $Address{RealName} = '"' . $Address{RealName} . '"';
    }
    my $Sender = "$Address{RealName} <$Address{Email}>";

    return $Sender;
}

=head2 Template()

generate template

    my $Template = $TemplateGeneratorObject->Template(
        TemplateID => 123
        TicketID   => 123,                  # Optional
        Data       => $ArticleHashRef,      # Optional
        UserID     => 123,
    );

Returns:

    $Template =>  'Some text';

=cut

sub Template {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TemplateID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my %Template = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateGet(
        ID => $Param{TemplateID},
    );

    # do text/plain to text/html convert
    if (
        $Self->{RichText}
        && $Template{ContentType} =~ /text\/plain/i
        && $Template{Template}
        )
    {
        $Template{ContentType} = 'text/html';
        $Template{Template}    = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
            String => $Template{Template},
        );
    }

    # do text/html to text/plain convert
    if (
        !$Self->{RichText}
        && $Template{ContentType} =~ /text\/html/i
        && $Template{Template}
        )
    {
        $Template{ContentType} = 'text/plain';
        $Template{Template}    = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Template{Template},
        );
    }

    # Get user language.
    my $Language;
    my %Ticket;
    if ( defined $Param{TicketID} ) {

        # Get ticket data.
        %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 1,
        );

        # Get recipient.
        my %User = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );
        $Language = $User{UserLanguage};
    }

    # If template type is 'Create' and there is customer user information, treat it as a ticket param in order to
    # correctly replace customer user tags. See bug#14455.
    if ( $Template{TemplateType} eq 'Create' && $Param{CustomerUserID} ) {
        $Ticket{CustomerUserID} = $Param{CustomerUserID};
    }

    # if customer language is not defined, set default language
    $Language //= $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';

    # get list unsupported tags for standard template
    my @ListOfUnSupportedTag = qw(OTRS_AGENT_SUBJECT OTRS_AGENT_BODY OTRS_CUSTOMER_BODY OTRS_CUSTOMER_SUBJECT);

    my %SupportedTypes = (
        Answer  => 1,
        Forward => 1,
        Note    => 1,
    );

    my $TemplateText = $Template{Template} || '';
    my $TemplateType = $Template{TemplateType};

    # Remove unsupported tags only for some template types.
    if ( !$SupportedTypes{ $Template{TemplateType} } ) {
        $TemplateText = $Self->_RemoveUnSupportedTag(
            Text                 => $Template{Template} || '',
            ListOfUnSupportedTag => \@ListOfUnSupportedTag,
        );

        # Reset template type for unsupported tag.
        $TemplateType = '';
    }

    # replace place holder stuff
    $TemplateText = $Self->_Replace(
        RichText   => $Self->{RichText},
        Text       => $TemplateText || '',
        TicketData => \%Ticket,
        Data       => $Param{Data} || {},
        UserID     => $Param{UserID},
        Language   => $Language,
        Template   => $TemplateType,
    );

    if ( $Self->{RichText} ) {
        $TemplateText =~ s/&lt;/</g;
        $TemplateText =~ s/&gt;/>/g;
        $TemplateText =~ s/&quot;/"/g;
        $TemplateText =~ s/&apos;/'/g;
        $TemplateText =~ s/&nbsp;/ /g;
    }

    return $TemplateText;
}

=head2 GenericAgentArticle()

generate internal or external notes

    my $GenericAgentArticle = $TemplateGeneratorObject->GenericAgentArticle(
        Notification    => $NotificationDataHashRef,
        TicketID        => 123,
        UserID          => 123,
        Data            => $ArticleHashRef,             # Optional
    );

=cut

sub GenericAgentArticle {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Notification UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my %Template = %{ $Param{Notification} };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Get ticket data.
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # do text/plain to text/html convert
    if (
        $Self->{RichText}
        && $Template{ContentType} =~ /text\/plain/i
        && $Template{Body}
        )
    {
        $Template{ContentType} = 'text/html';
        $Template{Body}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
            String => $Template{Body},
        );
    }

    # do text/html to text/plain convert
    if (
        !$Self->{RichText}
        && $Template{ContentType} =~ /text\/html/i
        && $Template{Body}
        )
    {
        $Template{ContentType} = 'text/plain';
        $Template{Body}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Template{Body},
        );
    }

    # replace place holder stuff
    $Template{Body} = $Self->_Replace(
        RichText   => $Self->{RichText},
        Text       => $Template{Body},
        Recipient  => $Param{Recipient},
        Data       => $Param{Data} || {},
        TicketData => \%Ticket,
        UserID     => $Param{UserID},
    );
    $Template{Subject} = $Self->_Replace(
        RichText   => 0,
        Text       => $Template{Subject},
        Recipient  => $Param{Recipient},
        Data       => $Param{Data} || {},
        TicketData => \%Ticket,
        UserID     => $Param{UserID},
    );

    $Template{Subject} = $TicketObject->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Template{Subject} || '',
        Type         => 'New',
    );

    # add URLs and verify to be full HTML document
    if ( $Self->{RichText} ) {

        $Template{Body} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $Template{Body},
        );
    }

    return %Template;
}

=head2 Attributes()

generate attributes

    my %Attributes = $TemplateGeneratorObject->Attributes(
        TicketID   => 123,
        ArticleID  => 123,
        ResponseID => 123
        UserID     => 123,
        Action     => 'Forward', # Possible values are Reply and Forward, Reply is default.
    );

returns
    StandardResponse
    Salutation
    Signature

=cut

sub Attributes {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Data UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get queue
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # prepare subject ...
    $Param{Data}->{Subject} = $TicketObject->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Param{Data}->{Subject} || '',
        Action       => $Param{Action} || '',
    );

    # get sender address
    $Param{Data}->{From} = $Self->Sender(
        QueueID => $Ticket{QueueID},
        UserID  => $Param{UserID},
    );

    return %{ $Param{Data} };
}

=head2 AutoResponse()

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
        TicketID         => 123,
        OrigHeader       => {},
        AutoResponseType => 'auto reply',
        UserID           => 123,
    );

=cut

sub AutoResponse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID AutoResponseType OrigHeader UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Get ticket data.
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # get auto default responses
    my %AutoResponse = $Kernel::OM->Get('Kernel::System::AutoResponse')->AutoResponseGetByTypeQueueID(
        QueueID => $Ticket{QueueID},
        Type    => $Param{AutoResponseType},
    );

    return if !%AutoResponse;

    # get old article for quoting
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my @ArticleList   = $ArticleObject->ArticleList(
        TicketID   => $Param{TicketID},
        SenderType => 'customer',
        OnlyLast   => 1,
    );

    if ( !@ArticleList ) {
        @ArticleList = $ArticleObject->ArticleList(
            TicketID             => $Param{TicketID},
            IsVisibleForCustomer => 1,
            OnlyLast             => 1,
        );
    }

    if (@ArticleList) {
        my %Article = $ArticleObject->BackendForArticle( %{ $ArticleList[0] } )->ArticleGet( %{ $ArticleList[0] } );

        for (qw(From To Cc Subject Body)) {
            if ( !$Param{OrigHeader}->{$_} ) {
                $Param{OrigHeader}->{$_} = $Article{$_} || '';
            }
            chomp $Param{OrigHeader}->{$_};
        }
    }

    # format body (only if longer than 86 chars)
    if ( $Param{OrigHeader}->{Body} ) {
        if ( length $Param{OrigHeader}->{Body} > 86 ) {
            my @Lines = split /\n/, $Param{OrigHeader}->{Body};
            LINE:
            for my $Line (@Lines) {
                my $LineWrapped = $Line =~ s/(^>.+|.{4,86})(?:\s|\z)/$1\n/gm;

                next LINE if $LineWrapped;

                # if the regex does not match then we need
                # to add the missing new line of the split
                # else we will lose e.g. empty lines of the body.
                # (bug#10679)
                $Line .= "\n";
            }
            $Param{OrigHeader}->{Body} = join '', @Lines;
        }
    }

    # fill up required attributes
    for (qw(Subject Body)) {
        if ( !$Param{OrigHeader}->{$_} ) {
            $Param{OrigHeader}->{$_} = "No $_";
        }
    }

    # get recipient
    my %User = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Ticket{CustomerUserID},
    );

    # get user language
    my $Language = $User{UserLanguage} || $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $AutoResponse{ContentType} =~ /text\/plain/i ) {
        $AutoResponse{ContentType} = 'text/html';
        $AutoResponse{Text}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
            String => $AutoResponse{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $AutoResponse{ContentType} =~ /text\/html/i ) {
        $AutoResponse{ContentType} = 'text/plain';
        $AutoResponse{Text}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $AutoResponse{Text},
        );
    }

    # replace place holder stuff
    $AutoResponse{Text} = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $AutoResponse{Text},
        Data     => {
            %{ $Param{OrigHeader} },
            From => $Param{OrigHeader}->{To},
            To   => $Param{OrigHeader}->{From},
        },
        TicketData      => \%Ticket,
        UserID          => $Param{UserID},
        Language        => $Language,
        AddTimezoneInfo => {
            AutoResponse => 1,
        },
    );
    $AutoResponse{Subject} = $Self->_Replace(
        RichText => 0,
        Text     => $AutoResponse{Subject},
        Data     => {
            %{ $Param{OrigHeader} },
            From => $Param{OrigHeader}->{To},
            To   => $Param{OrigHeader}->{From},
        },
        TicketData      => \%Ticket,
        UserID          => $Param{UserID},
        Language        => $Language,
        AddTimezoneInfo => {
            AutoResponse => 1,
        },
    );

    $AutoResponse{Subject} = $TicketObject->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $AutoResponse{Subject},
        Type         => 'New',
        NoCleanup    => 1,
    );

    # get sender attributes based on auto response type
    if ( $AutoResponse{SystemAddressID} ) {

        my %Address = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressGet(
            ID => $AutoResponse{SystemAddressID},
        );

        $AutoResponse{SenderAddress}  = $Address{Name};
        $AutoResponse{SenderRealname} = $Address{Realname};
    }

    # get sender attributes based on queue
    else {

        my %Address = $Kernel::OM->Get('Kernel::System::Queue')->GetSystemAddress(
            QueueID => $Ticket{QueueID},
        );

        $AutoResponse{SenderAddress}  = $Address{Email};
        $AutoResponse{SenderRealname} = $Address{RealName};
    }

    # add urls and verify to be full html document
    if ( $Self->{RichText} ) {

        $AutoResponse{Text} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $AutoResponse{Text},
        );

        $AutoResponse{Text} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentComplete(
            Charset => 'utf-8',
            String  => $AutoResponse{Text},
        );
    }

    return %AutoResponse;
}

=head2 NotificationEvent()

replace all OTRS smart tags in the notification body and subject

    my %NotificationEvent = $TemplateGeneratorObject->NotificationEvent(
        TicketData            => $TicketDataHashRef,
        Recipient             => $UserDataHashRef,          # Agent or Customer data get result
        Notification          => $NotificationDataHashRef,
        CustomerMessageParams => $ArticleHashRef,           # optional
        UserID                => 123,
    );

=cut

sub NotificationEvent {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketData Notification Recipient UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !IsHashRefWithData( $Param{Notification} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Notification is invalid!",
        );
        return;
    }

    my %Notification = %{ $Param{Notification} };

    # exchanging original reference prevent it to grow up
    if ( ref $Param{CustomerMessageParams} && ref $Param{CustomerMessageParams} eq 'HASH' ) {
        my %LocalCustomerMessageParams = %{ $Param{CustomerMessageParams} };
        $Param{CustomerMessageParams} = \%LocalCustomerMessageParams;
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Get last article from customer.
    my @CustomerArticles = $ArticleObject->ArticleList(
        TicketID   => $Param{TicketData}->{TicketID},
        SenderType => 'customer',
        OnlyLast   => 1,
    );

    my %CustomerArticle;

    ARTICLE:
    for my $Article (@CustomerArticles) {
        next ARTICLE if !$Article->{ArticleID};

        %CustomerArticle = $ArticleObject->BackendForArticle( %{$Article} )->ArticleGet(
            %{$Article},
            DynamicFields => 0,
        );
    }

    # Get last article from agent.
    my @AgentArticles = $ArticleObject->ArticleList(
        TicketID   => $Param{TicketData}->{TicketID},
        SenderType => 'agent',
        OnlyLast   => 1,
    );

    my %AgentArticle;

    AGENTARTICLE:
    for my $Article (@AgentArticles) {
        next AGENTARTICLE if !$Article->{ArticleID};

        %AgentArticle = $ArticleObject->BackendForArticle( %{$Article} )->ArticleGet(
            %{$Article},
            DynamicFields => 0,
        );

        # Include the transmission status, if article is an email.
        my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
            ChannelID => $Article->{CommunicationChannelID},
        );
        if ( $CommunicationChannel{ChannelName} eq 'Email' ) {
            my $TransmissionStatus = $ArticleObject->BackendForArticle( %{$Article} )->ArticleTransmissionStatus(
                ArticleID => $Article->{ArticleID},
            );
            if ( $TransmissionStatus && $TransmissionStatus->{Message} ) {
                $AgentArticle{TransmissionStatusMessage} = $TransmissionStatus->{Message};
            }
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    ARTICLE:
    for my $ArticleData ( \%CustomerArticle, \%AgentArticle ) {
        next ARTICLE if !$ArticleData->{TicketID};
        next ARTICLE if !$ArticleData->{ArticleID};

        # Get article preview in plain text and store it as Body key.
        $ArticleData->{Body} = $LayoutObject->ArticlePreview(
            TicketID   => $ArticleData->{TicketID},
            ArticleID  => $ArticleData->{ArticleID},
            ResultType => 'plain',
            UserID     => $Param{UserID},
        );

        # get accounted time
        my $AccountedTime = $ArticleObject->ArticleAccountedTimeGet(
            ArticleID => $ArticleData->{ArticleID},
        );

        # set the accounted time as part of the articles information
        $ArticleData->{TimeUnit} = $AccountedTime;
    }

    # Populate the hash 'CustomerMessageParams' with all the customer-article data
    # and overwrite it with 'CustomerMessageParams' passed in the Params (bug #13325).
    $Param{CustomerMessageParams} = {
        %CustomerArticle,
        %{ $Param{CustomerMessageParams} || {} },
    };

    # get system default language
    my $DefaultLanguage = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';

    my $Languages = [ $Param{Recipient}->{UserLanguage}, $DefaultLanguage, 'en' ];

    my $Language;
    LANGUAGE:
    for my $Item ( @{$Languages} ) {
        next LANGUAGE if !$Item;
        next LANGUAGE if !$Notification{Message}->{$Item};

        # set language
        $Language = $Item;
        last LANGUAGE;
    }

    # if no language, then take the first one available
    if ( !$Language ) {
        my @NotificationLanguages = sort keys %{ $Notification{Message} };
        $Language = $NotificationLanguages[0];
    }

    # copy the correct language message attributes to a flat structure
    for my $Attribute (qw(Subject Body ContentType)) {
        $Notification{$Attribute} = $Notification{Message}->{$Language}->{$Attribute};
    }

    # Get customer article fields.
    my %CustomerArticleFields;

    if (%CustomerArticle) {
        %CustomerArticleFields = $LayoutObject->ArticleFields(
            TicketID  => $CustomerArticle{TicketID},
            ArticleID => $CustomerArticle{ArticleID},
            UserID    => $Param{UserID},
        );
    }

    ARTICLE_FIELD:
    for my $ArticleField ( sort keys %CustomerArticleFields ) {
        next ARTICLE_FIELD if !defined $CustomerArticleFields{$ArticleField}->{Value};

        if ( !defined $Param{CustomerMessageParams}->{$ArticleField} ) {
            $Param{CustomerMessageParams}->{$ArticleField} = $CustomerArticleFields{$ArticleField}->{Value};
        }
        chomp $Param{CustomerMessageParams}->{$ArticleField};
    }

    # format body (only if longer the 86 chars)
    if ( $Param{CustomerMessageParams}->{Body} ) {
        if ( length $Param{CustomerMessageParams}->{Body} > 86 ) {
            my @Lines = split /\n/, $Param{CustomerMessageParams}->{Body};
            LINE:
            for my $Line (@Lines) {
                my $LineWrapped = $Line =~ s/(^>.+|.{4,86})(?:\s|\z)/$1\n/gm;

                next LINE if $LineWrapped;

                # if the regex does not match then we need
                # to add the missing new line of the split
                # else we will lose e.g. empty lines of the body.
                # (bug#10679)
                $Line .= "\n";
            }
            $Param{CustomerMessageParams}->{Body} = join '', @Lines;
        }
    }

    # fill up required attributes
    for my $Text (qw(Subject Body)) {
        if ( !$Param{CustomerMessageParams}->{$Text} ) {

            # Set to last customer article attribute if it is empty string.
            # For example, if Body is empty string (not undef!), it is maybe sent from NotificationOwnerUpdate event
            # and overrides last customer article body (in %CustomerArticle) above - see bug#14678.
            $Param{CustomerMessageParams}->{$Text} = $CustomerArticle{$Text} || "No $Text";
        }
    }

    my $Start = '<';
    my $End   = '>';
    if ( $Notification{ContentType} =~ m{text\/html} ) {
        $Start = '&lt;';
        $End   = '&gt;';
    }

    # replace <OTRS_CUSTOMER_DATA_*> tags early from CustomerMessageParams, the rests will be replaced
    # by ticket customer user
    KEY:
    for my $Key ( sort keys %{ $Param{CustomerMessageParams} || {} } ) {

        next KEY if !$Param{CustomerMessageParams}->{$Key};

        $Notification{Body}    =~ s/${Start}OTRS_CUSTOMER_DATA_$Key${End}/$Param{CustomerMessageParams}->{$Key}/gi;
        $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$Key>/$Param{CustomerMessageParams}->{$Key}{$Key}/gi;
    }

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Notification{ContentType} =~ /text\/plain/i ) {
        $Notification{ContentType} = 'text/html';
        $Notification{Body}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
            String => $Notification{Body},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Notification{ContentType} =~ /text\/html/i ) {
        $Notification{ContentType} = 'text/plain';
        $Notification{Body}        = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Notification{Body},
        );
    }

    # get notify texts
    for my $Text (qw(Subject Body)) {
        if ( !$Notification{$Text} ) {
            $Notification{$Text} = "No Notification $Text for $Param{Type} found!";
        }
    }

    # replace place holder stuff
    $Notification{Body} = $Self->_Replace(
        RichText        => $Self->{RichText},
        Text            => $Notification{Body},
        Recipient       => $Param{Recipient},
        Data            => $Param{CustomerMessageParams},
        DataAgent       => \%AgentArticle,
        TicketData      => $Param{TicketData},
        UserID          => $Param{UserID},
        Language        => $Language,
        AddTimezoneInfo => {
            NotificationEvent => 1,
        },
    );

    $Notification{Subject} = $Self->_Replace(
        RichText        => 0,
        Text            => $Notification{Subject},
        Recipient       => $Param{Recipient},
        Data            => $Param{CustomerMessageParams},
        DataAgent       => \%AgentArticle,
        TicketData      => $Param{TicketData},
        UserID          => $Param{UserID},
        Language        => $Language,
        AddTimezoneInfo => {
            NotificationEvent => 1,
        },
    );

    # Keep the "original" (unmodified) subject and body for later use.
    $Notification{OriginalSubject} = $Notification{Subject};
    $Notification{OriginalBody}    = $Notification{Body};

    $Notification{Subject} = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSubjectBuild(
        TicketNumber => $Param{TicketData}->{TicketNumber},
        Subject      => $Notification{Subject} || '',
        Type         => 'New',
    );

    # add URLs and verify to be full HTML document
    if ( $Self->{RichText} ) {

        $Notification{Body} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $Notification{Body},
        );
    }

    return %Notification;
}

=begin Internal:

=cut

sub _Replace {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Text RichText Data UserID)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check for mailto links
    # since the subject and body of those mailto links are
    # uri escaped we have to uri unescape them, replace
    # possible placeholders and then re-uri escape them
    $Param{Text} =~ s{
        (href="mailto:[^\?]+\?)([^"]+")
    }
    {
        my $MailToHref        = $1;
        my $MailToHrefContent = $2;

        $MailToHrefContent =~ s{
            ((?:subject|body)=)(.+?)("|&)
        }
        {
            my $SubjectOrBodyPrefix  = $1;
            my $SubjectOrBodyContent = $2;
            my $SubjectOrBodySuffix  = $3;

            my $SubjectOrBodyContentUnescaped = URI::Escape::uri_unescape $SubjectOrBodyContent;

            my $SubjectOrBodyContentReplaced = $Self->_Replace(
                %Param,
                Text     => $SubjectOrBodyContentUnescaped,
                RichText => 0,
            );

            my $SubjectOrBodyContentEscaped = URI::Escape::uri_escape_utf8 $SubjectOrBodyContentReplaced;

            $SubjectOrBodyPrefix . $SubjectOrBodyContentEscaped . $SubjectOrBodySuffix;
        }egx;

        $MailToHref . $MailToHrefContent;
    }egx;

    my $Start = '<';
    my $End   = '>';
    if ( $Param{RichText} ) {
        $Start = '&lt;';
        $End   = '&gt;';
        $Param{Text} =~ s/(\n|\r)//g;
    }

    my %Ticket;
    if ( $Param{TicketData} ) {
        %Ticket = %{ $Param{TicketData} };
    }

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # Determine recipient's timezone if needed.
    my $RecipientTimeZone;
    if ( $Param{AddTimezoneInfo} ) {
        $RecipientTimeZone = $Kernel::OM->Create('Kernel::System::DateTime')->OTRSTimeZoneGet();

        my %CustomerUser;
        if ( IsHashRefWithData( \%Ticket ) && $Ticket{CustomerUserID} ) {
            %CustomerUser = $CustomerUserObject->CustomerUserDataGet( User => $Ticket{CustomerUserID} );
        }

        my %UserPreferences;

        if ( $Param{AddTimezoneInfo}->{NotificationEvent} && $Param{Recipient}->{Type} eq 'Agent' ) {
            %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
                UserID => $Param{Recipient}->{UserID},
            );
        }
        elsif (
            $Param{AddTimezoneInfo}->{NotificationEvent}
            && $Param{Recipient}->{Type} eq 'Customer'
            && $Param{Recipient}->{UserID}
            )
        {
            %UserPreferences = $CustomerUserObject->GetPreferences(
                UserID => $Param{Recipient}->{UserID},
            );
        }
        elsif (
            $Param{AddTimezoneInfo}->{AutoResponse}
            && $Ticket{CustomerUserID}
            && IsHashRefWithData( \%CustomerUser )
            )
        {
            %UserPreferences = $CustomerUserObject->GetPreferences(
                UserID => $Ticket{CustomerUserID},
            );
        }

        if ( $UserPreferences{UserTimeZone} ) {
            $RecipientTimeZone = $UserPreferences{UserTimeZone};
        }
    }

    # Replace Unix time format tags.
    # If language is defined, they will be converted into a correct format in below IF statement.
    for my $UnixFormatTime (
        qw(RealTillTimeNotUsed EscalationResponseTime EscalationUpdateTime EscalationSolutionTime)
        )
    {
        if ( $Ticket{$UnixFormatTime} ) {
            $Ticket{$UnixFormatTime} = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Epoch => $Ticket{$UnixFormatTime},
                },
            )->ToString();
        }
    }

    # translate ticket values if needed
    if ( $Param{Language} ) {

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Param{Language},
        );

        # Translate the different values.
        for my $Field (qw(Type State StateType Lock Priority)) {
            $Ticket{$Field} = $LanguageObject->Translate( $Ticket{$Field} );
        }

        # Transform the date values from the ticket data (but not the dynamic field values).
        ATTRIBUTE:
        for my $Attribute ( sort keys %Ticket ) {
            next ATTRIBUTE if $Attribute =~ m{ \A DynamicField_ }xms;
            next ATTRIBUTE if !$Ticket{$Attribute};

            if ( $Ticket{$Attribute} =~ m{\A(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)\z}xi ) {

                # Change time to recipient's timezone if needed
                # and later append timezone information.
                # For more information,
                # see bug#13865 (https://bugs.otrs.org/show_bug.cgi?id=13865)
                # and bug#14270 (https://bugs.otrs.org/show_bug.cgi?id=14270).
                if ($RecipientTimeZone) {
                    my $DateTimeObject = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $Ticket{$Attribute},
                        },
                    );
                    $DateTimeObject->ToTimeZone( TimeZone => $RecipientTimeZone );
                    $Ticket{$Attribute} = $DateTimeObject->ToString();
                }

                $Ticket{$Attribute} = $LanguageObject->FormatTimeString(
                    $Ticket{$Attribute},
                    'DateFormat',
                    'NoSeconds',
                );

                # Append timezone information if needed.
                if ($RecipientTimeZone) {
                    $Ticket{$Attribute} .= " ($RecipientTimeZone)";
                }
            }
        }

        my $LocalLayoutObject = Kernel::Output::HTML::Layout->new(
            Lang => $Param{Language},
        );

        # Convert tags in seconds to more readable appropriate format if language is defined.
        for my $TimeInSeconds (
            qw(UntilTime EscalationTimeWorkingTime EscalationTime FirstResponseTimeWorkingTime FirstResponseTime UpdateTimeWorkingTime
            UpdateTime SolutionTimeWorkingTime SolutionTime)
            )
        {
            if ( $Ticket{$TimeInSeconds} ) {
                $Ticket{$TimeInSeconds} = $LocalLayoutObject->CustomerAge(
                    Age   => $Ticket{$TimeInSeconds},
                    Space => ' '
                );
            }
        }
    }

    my %Queue;
    if ( $Param{QueueID} ) {
        %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
            ID => $Param{QueueID},
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Replace config options.
    my $Tag = $Start . 'OTRS_CONFIG_';
    $Param{Text} =~ s{$Tag(.+?)$End}{
        my $Key   = $1;
        my $Value = $ConfigObject->Get($Key) // '';

        # Mask sensitive config options.
        my $Replace = $Self->_MaskSensitiveValue(
            Key      => $Key,
            Value    => $Value,
            IsConfig => 1,
        );

        $Replace;
    }egx;

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    my %Recipient = %{ $Param{Recipient} || {} };

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    if ( !%Recipient && $Param{RecipientID} ) {

        %Recipient = $UserObject->GetUserData(
            UserID        => $Param{RecipientID},
            NoOutOfOffice => 1,
        );
    }

    my $HashGlobalReplace = sub {
        my ( $Tag, %H ) = @_;

        # Generate one single matching string for all keys to save performance.
        my $Keys = join '|', map {quotemeta} grep { defined $H{$_} } keys %H;

        # Set all keys as lowercase to be able to match case insensitive,
        #   e. g. <OTRS_CUSTOMER_From> and <OTRS_CUSTOMER_FROM>.
        #   Also mask any values containing sensitive data.
        %H = map {
            lc $_ => $Self->_MaskSensitiveValue(
                Key   => $_,
                Value => $H{$_},
            )
        } sort keys %H;

        # If tag is 'OTRS_CUSTOMER_' add the body alias 'email/note' to be replaced.
        if ( $Tag =~ m/OTRS_(CUSTOMER|AGENT)_/ ) {
            KEY:
            for my $Key (qw( email note )) {
                my $Value = $H{$Key};
                next KEY if defined($Value);

                $H{$Key} = $H{'body'};
                $Keys .= '|' . ucfirst $Key;
            }
        }

        $Param{Text} =~ s/(?:$Tag)($Keys)$End/$H{ lc $1 }/ieg;
    };

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';

    # include more readable tag <OTRS_NOTIFICATION_RECIPIENT
    my $RecipientTag = $Start . 'OTRS_NOTIFICATION_RECIPIENT_';

    if (%Recipient) {

        # HTML quoting of content
        if ( $Param{RichText} ) {
            ATTRIBUTE:
            for my $Attribute ( sort keys %Recipient ) {
                next ATTRIBUTE if !$Recipient{$Attribute};
                $Recipient{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $Recipient{$Attribute},
                );
            }
        }

        $HashGlobalReplace->( "$Tag|$RecipientTag", %Recipient );
    }

    # cleanup
    $Param{Text} =~ s/$RecipientTag.+?$End/-/gi;

    # get owner data and replace it with <OTRS_OWNER_...
    $Tag = $Start . 'OTRS_OWNER_';

    # include more readable version <OTRS_TICKET_OWNER
    my $OwnerTag = $Start . 'OTRS_TICKET_OWNER_';

    if ( $Ticket{OwnerID} ) {

        my %Owner = $UserObject->GetUserData(
            UserID        => $Ticket{OwnerID},
            NoOutOfOffice => 1,
        );

        # html quoting of content
        if ( $Param{RichText} ) {

            ATTRIBUTE:
            for my $Attribute ( sort keys %Owner ) {
                next ATTRIBUTE if !$Owner{$Attribute};
                $Owner{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $Owner{$Attribute},
                );
            }
        }

        $HashGlobalReplace->( "$Tag|$OwnerTag", %Owner );
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;
    $Param{Text} =~ s/$OwnerTag.+?$End/-/gi;

    # get owner data and replace it with <OTRS_RESPONSIBLE_...
    $Tag = $Start . 'OTRS_RESPONSIBLE_';

    # include more readable version <OTRS_TICKET_RESPONSIBLE
    my $ResponsibleTag = $Start . 'OTRS_TICKET_RESPONSIBLE_';

    if ( $Ticket{ResponsibleID} ) {
        my %Responsible = $UserObject->GetUserData(
            UserID        => $Ticket{ResponsibleID},
            NoOutOfOffice => 1,
        );

        # HTML quoting of content
        if ( $Param{RichText} ) {

            ATTRIBUTE:
            for my $Attribute ( sort keys %Responsible ) {
                next ATTRIBUTE if !$Responsible{$Attribute};
                $Responsible{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $Responsible{$Attribute},
                );
            }
        }

        $HashGlobalReplace->( "$Tag|$ResponsibleTag", %Responsible );
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;
    $Param{Text} =~ s/$ResponsibleTag.+?$End/-/gi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2        = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $UserObject->GetUserData(
        UserID        => $Param{UserID},
        NoOutOfOffice => 1,
    );

    # HTML quoting of content
    if ( $Param{RichText} ) {

        ATTRIBUTE:
        for my $Attribute ( sort keys %CurrentUser ) {
            next ATTRIBUTE if !$CurrentUser{$Attribute};
            $CurrentUser{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                String => $CurrentUser{$Attribute},
            );
        }
    }

    $HashGlobalReplace->( "$Tag|$Tag2", %CurrentUser );

    # replace other needed stuff
    $Param{Text} =~ s/$Start OTRS_FIRST_NAME $End/$CurrentUser{UserFirstname}/gxms;
    $Param{Text} =~ s/$Start OTRS_LAST_NAME $End/$CurrentUser{UserLastname}/gxms;

    # cleanup
    $Param{Text} =~ s/$Tag2.+?$End/-/gi;

    # ticket data
    $Tag = $Start . 'OTRS_TICKET_';

    # html quoting of content
    if ( $Param{RichText} ) {

        ATTRIBUTE:
        for my $Attribute ( sort keys %Ticket ) {
            next ATTRIBUTE if !$Ticket{$Attribute};
            $Ticket{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                String => $Ticket{$Attribute},
            );
        }
    }

    # Dropdown, Checkbox and MultipleSelect DynamicFields, can store values (keys) that are
    # different from the the values to display
    # <OTRS_TICKET_DynamicField_NameX> returns the stored key
    # <OTRS_TICKET_DynamicField_NameX_Value> returns the display value

    my %DynamicFields;

    # For systems with many Dynamic fields we do not want to load them all unless needed
    # Find what Dynamic Field Values are requested
    while ( $Param{Text} =~ m/$Tag DynamicField_(\S+?)(_Value)? $End/gixms ) {
        $DynamicFields{$1} = 1;
    }

    # to store all the required DynamicField display values
    my %DynamicFieldDisplayValues;

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get the dynamic fields for ticket object
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    ) || [];

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # we only load the ones requested
        next DYNAMICFIELD if !$DynamicFields{ $DynamicFieldConfig->{Name} };

        my $LanguageObject;

        # translate values if needed
        if ( $Param{Language} ) {
            $LanguageObject = Kernel::Language->new(
                UserLanguage => $Param{Language},
            );
        }

        my $DateTimeObject;

        # Change DateTime DF value for ticket if needed.
        if (
            defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
            && $DynamicFieldConfig->{FieldType} eq 'DateTime'
            && $RecipientTimeZone
            )
        {
            $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                },
            );
            $DateTimeObject->ToTimeZone( TimeZone => $RecipientTimeZone );
            $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $DateTimeObject->ToString();
        }

        # get the display value for each dynamic field
        my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
            DynamicFieldConfig => $DynamicFieldConfig,
            Key                => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            LanguageObject     => $LanguageObject,
        );

        # get the readable value (value) for each dynamic field
        my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $DisplayValue,
        );

        # fill the DynamicFielsDisplayValues
        if ($DisplayValueStrg) {
            $DynamicFieldDisplayValues{ 'DynamicField_' . $DynamicFieldConfig->{Name} . '_Value' }
                = $DisplayValueStrg->{Value};

            # Add timezone info if needed.
            if (
                defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                && length $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                && $DynamicFieldConfig->{FieldType} eq 'DateTime'
                && $RecipientTimeZone
                )
            {
                $DynamicFieldDisplayValues{ 'DynamicField_' . $DynamicFieldConfig->{Name} . '_Value' }
                    .= " ($RecipientTimeZone)";
            }
        }

        # get the readable value (key) for each dynamic field
        my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
        );

        # replace ticket content with the value from ReadableValueRender (if any)
        if ( IsHashRefWithData($ValueStrg) ) {
            $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $ValueStrg->{Value};

            # Add timezone info if needed.
            if (
                defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                && length $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                && $DynamicFieldConfig->{FieldType} eq 'DateTime'
                && $RecipientTimeZone
                )
            {
                $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } .= " ($RecipientTimeZone)";
            }
        }
    }

    # replace it
    $HashGlobalReplace->( $Tag, %Ticket, %DynamicFieldDisplayValues );

    # COMPAT
    $Param{Text} =~ s/$Start OTRS_TICKET_ID $End/$Ticket{TicketID}/gixms;
    $Param{Text} =~ s/$Start OTRS_TICKET_NUMBER $End/$Ticket{TicketNumber}/gixms;
    if ( $Ticket{TicketID} ) {
        $Param{Text} =~ s/$Start OTRS_QUEUE $End/$Ticket{Queue}/gixms;
    }
    if ( $Param{QueueID} ) {
        $Param{Text} =~ s/$Start OTRS_TICKET_QUEUE $End/$Queue{Name}/gixms;
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    # Follow-up for bug#10825.
    # Set data for replacing of specific tags in Templates:
    # - OTRS_AGENT_SUBJECT, OTRS_AGENT_BODY - subject/body of the CURRENT/LATEST agent article
    # - OTRS_CUSTOMER_SUBJECT, OTRS_CUSTOMER_BODY - subject/body of the CURRENT/LATEST customer article
    # - OTRS_AGENT_SUBJECT[n]    - first n characters of the subject of the CURRENT/LATEST agent article
    # - OTRS_AGENT_BODY[n]       - first n lines of the body of the CURRENT/LATEST agent article
    # - OTRS_CUSTOMER_SUBJECT[n] - first n characters of the subject of the CURRENT/LATEST customer article
    # - OTRS_CUSTOMER_BODY[n]    - first n lines of the body of the CURRENT/LATEST customer article
    #
    # For Note template we need the last article.
    # For Answer, $Param{Data} has selected or last article data, depends whether ArticleID is sent or not.
    # For Forward, $Param{Data} has the following article data:
    # - if ArticleID is sent, data is from selected article.
    # - if ArticleID is not sent, data is from last customer/agent/any article.
    if ( $Param{Template} && $Ticket{TicketID} ) {
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        if ( $Param{Template} eq 'Note' ) {

            # Get last article from agent.
            my @AgentArticles = $ArticleObject->ArticleList(
                TicketID   => $Param{TicketData}->{TicketID},
                SenderType => 'agent',
                OnlyLast   => 1,
            );

            my %AgentArticle = $ArticleObject->BackendForArticle( %{ $AgentArticles[0] } )->ArticleGet(
                %{ $AgentArticles[0] },
                DynamicFields => 0,
            );

            # Get last article from customer.
            my @CustomerArticles = $ArticleObject->ArticleList(
                TicketID   => $Param{TicketData}->{TicketID},
                SenderType => 'customer',
                OnlyLast   => 1,
            );

            my %CustomerArticle = $ArticleObject->BackendForArticle( %{ $CustomerArticles[0] } )->ArticleGet(
                %{ $CustomerArticles[0] },
                DynamicFields => 0,
            );

            $Param{DataAgent}->{Subject} = $AgentArticle{Subject};
            $Param{DataAgent}->{Body}    = $AgentArticle{Body};
            $Param{Data}->{Subject}      = $CustomerArticle{Subject};
            $Param{Data}->{Body}         = $CustomerArticle{Body};
        }
        elsif ( $Param{Template} eq 'Answer' || $Param{Template} eq 'Forward' ) {

            # If $Param{Data} has agent article data, we will set subject and body in $Param{DataAgent}
            # to values from $Param{Data} in order to right replacing of OTRS_AGENT_SUBJECT/BODY tags.
            if ( $Param{Data}->{SenderType} && $Param{Data}->{SenderType} eq 'agent' ) {
                $Param{DataAgent}->{Subject} = $Param{Data}->{Subject};
                $Param{DataAgent}->{Body}    = $Param{Data}->{Body};
            }
        }
    }

    # get customer and agent params and replace it with <OTRS_CUSTOMER_... or <OTRS_AGENT_...
    my %ArticleData = (
        'OTRS_CUSTOMER_' => $Param{Data}      || {},
        'OTRS_AGENT_'    => $Param{DataAgent} || {},
    );

    # use a list to get customer first
    for my $DataType (qw(OTRS_CUSTOMER_ OTRS_AGENT_)) {
        my %Data = %{ $ArticleData{$DataType} };

        # HTML quoting of content
        if ( $Param{RichText} ) {

            ATTRIBUTE:
            for my $Attribute ( sort keys %Data ) {
                next ATTRIBUTE if !$Data{$Attribute};

                $Data{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $Data{$Attribute},
                );
            }
        }

        if (%Data) {

            # replace <OTRS_CUSTOMER_*> and <OTRS_AGENT_*> tags
            $Tag = $Start . $DataType;
            $HashGlobalReplace->( $Tag, %Data );

            # prepare body (insert old email) <OTRS_CUSTOMER_EMAIL[n]>, <OTRS_CUSTOMER_NOTE[n]>
            #   <OTRS_CUSTOMER_BODY[n]>, <OTRS_AGENT_EMAIL[n]>..., <OTRS_COMMENT>

            # Changed this to a 'while' to allow the same key/tag multiple times and different number of lines.
            while (
                $Param{Text} =~ /$Start(?:$DataType(EMAIL|NOTE|BODY)\[(.+?)\])$End/
                ||
                $Param{Text} =~ /$Start(?:OTRS_COMMENT(\[(.+?)\])?)$End/
                )
            {

                my $Line       = $2 || 2500;
                my $NewOldBody = '';
                my @Body       = split( /\n/, $Data{Body} );

                for my $Counter ( 0 .. $Line - 1 ) {

                    # 2002-06-14 patch of Pablo Ruiz Garcia
                    # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
                    if ( $#Body >= $Counter ) {

                        # add no quote char, do it later by using DocumentCleanup()
                        if ( $Param{RichText} ) {
                            $NewOldBody .= $Body[$Counter];
                        }

                        # add "> " as quote char
                        else {
                            $NewOldBody .= "> $Body[$Counter]";
                        }

                        # add new line
                        if ( $Counter < ( $Line - 1 ) ) {
                            $NewOldBody .= "\n";
                        }
                    }
                    $Counter++;
                }

                chomp $NewOldBody;

                # HTML quoting of content
                if ( $Param{RichText} && $NewOldBody ) {

                    # remove trailing new lines
                    for ( 1 .. 10 ) {
                        $NewOldBody =~ s/(<br\/>)\s{0,20}$//gs;
                    }

                    # add quote
                    $NewOldBody = "<blockquote type=\"cite\">$NewOldBody</blockquote>";
                    $NewOldBody = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentCleanup(
                        String => $NewOldBody,
                    );
                }

                # replace tag
                $Param{Text}
                    =~ s/$Start(?:(?:$DataType(EMAIL|NOTE|BODY)\[(.+?)\]|(?:OTRS_COMMENT(\[(.+?)\])?)))$End/$NewOldBody/;
            }

            # replace <OTRS_CUSTOMER_SUBJECT[]>  and  <OTRS_AGENT_SUBJECT[]> tags
            $Tag = "$Start$DataType" . 'SUBJECT';
            if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {

                my $SubjectChar = $1;
                my $Subject     = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSubjectClean(
                    TicketNumber => $Ticket{TicketNumber},
                    Subject      => $Data{Subject},
                );

                $Subject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
                $Param{Text} =~ s/$Tag\[.+?\]$End/$Subject/g;
            }

            if ( $DataType eq 'OTRS_CUSTOMER_' ) {

                # Get <OTRS_EMAIL_DATE[]> from body and replace with received date.
                # This tag will be able to use with supported OTRS time zones
                #   ( e.g. <OTRS_EMAIL_DATE[Europe/Berlin]>, <OTRS_EMAIL_DATE[Asia/Tokyo]>,
                #   <OTRS_EMAIL_DATE[America/Denver]> , ...).
                # If you use tag without time in simple format as <OTRS_EMAIL_DATE>,
                #  time will be transformed into OTRS SystemTimeZone.
                $Tag = $Start . 'OTRS_EMAIL_DATE';

                my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
                my $SystemTimeZone = $DateTimeObject->OTRSTimeZoneGet();
                while ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {
                    my $TimeZone      = $1;
                    my $TimeZoneValid = $DateTimeObject->IsTimeZoneValid( TimeZone => $TimeZone );
                    if ($TimeZoneValid) {
                        $DateTimeObject->ToTimeZone( TimeZone => $TimeZone );
                    }
                    else {
                        $TimeZone = $SystemTimeZone;
                    }

                    my $EmailDate = $DateTimeObject->Format( Format => '%A, %B %e, %Y at %T ' );
                    $EmailDate .= "($TimeZone)";
                    $Param{Text} =~ s/$Tag\[$1\]$End/$EmailDate/g;
                }

                if ( $Param{Text} =~ /$Tag$End/g ) {
                    my $TimeZone = $SystemTimeZone;
                    $DateTimeObject->ToTimeZone( TimeZone => $TimeZone );

                    my $EmailDate = $DateTimeObject->Format( Format => '%A, %B %e, %Y at %T ' );
                    $EmailDate .= "($TimeZone)";
                    $Param{Text} =~ s/$Tag$End/$EmailDate/g;
                }
            }
        }

        if ( $DataType eq 'OTRS_CUSTOMER_' ) {

            # get and prepare realname
            $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
            if ( $Param{Text} =~ /$Tag$End/i ) {

                my $From;

                if ( $Ticket{CustomerUserID} ) {

                    $From = $CustomerUserObject->CustomerName(
                        UserLogin => $Ticket{CustomerUserID}
                    );
                }

                # try to get the real name directly from the data
                $From //= $Recipient{Realname};

                # get real name based on reply-to
                if ( !$From && $Data{ReplyTo} ) {

                    $From = $Data{ReplyTo};

                    # remove email addresses
                    $From =~ s/&lt;.*&gt;|<.*>|\(.*\)|\"|&quot;|;|,//g;

                    # remove leading/trailing spaces
                    $From =~ s/^\s+//g;
                    $From =~ s/\s+$//g;
                }

                # generate real name based on sender line
                if ( !$From ) {
                    $From = $Data{To} || '';

                    # remove email addresses
                    $From =~ s/&lt;.*&gt;|<.*>|\(.*\)|\"|&quot;|;|,//g;

                    # remove leading/trailing spaces
                    $From =~ s/^\s+//g;
                    $From =~ s/\s+$//g;
                }

                # replace <OTRS_CUSTOMER_REALNAME> with from
                $Param{Text} =~ s/$Tag$End/$From/g;
            }
        }
    }

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';

    if ( $Ticket{CustomerUserID} || $Param{Data}->{CustomerUserID} ) {

        my $CustomerUserID = $Param{Data}->{CustomerUserID} || $Ticket{CustomerUserID};

        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUserID,
        );

        # HTML quoting of content
        if ( $Param{RichText} ) {

            ATTRIBUTE:
            for my $Attribute ( sort keys %CustomerUser ) {
                next ATTRIBUTE if !$CustomerUser{$Attribute};
                $CustomerUser{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $CustomerUser{$Attribute},
                );
            }
        }

        # replace it
        $HashGlobalReplace->( "$Tag|$Tag2", %CustomerUser );
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Param{Text} =~ s/(?:$Tag|$Tag2).+?$End/-/gi;

    # cleanup all not needed <OTRS_AGENT_ tags
    $Tag = $Start . 'OTRS_AGENT_';
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    return $Param{Text};
}

=head2 _RemoveUnSupportedTag()

cleanup all not supported tags

    my $Text = $TemplateGeneratorObject->_RemoveUnSupportedTag(
        Text => $SomeTextWithTags,
        ListOfUnSupportedTag => \@ListOfUnSupportedTag,
    );

=cut

sub _RemoveUnSupportedTag {

    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(Text ListOfUnSupportedTag)) {
        if ( !defined $Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    my $Start = '<';
    my $End   = '>';
    if ( $Self->{RichText} ) {
        $Start = '&lt;';
        $End   = '&gt;';
        $Param{Text} =~ s/(\n|\r)//g;
    }

    # Cleanup all not supported tags with and without number, e.g. OTRS_CUSTOMER_BODY and OTRS_CUSTOMER_BODY[n].
    # See https://bugs.otrs.org/show_bug.cgi?id=14369 and https://bugs.otrs.org/show_bug.cgi?id=10825.
    my $NotSupportedTag = $Start . "(?:" . join( "|", @{ $Param{ListOfUnSupportedTag} } ) . ")(\\[.*?\\])?" . $End;
    $Param{Text} =~ s/$NotSupportedTag/-/gi;

    return $Param{Text};

}

=head2 _MaskSensitiveValue()

Mask sensitive value, i.e. a password, a security token, etc.

    my $MaskedValue = $Self->_MaskSensitiveValue(
        Key      => 'DatabasePassword', # (required) Name of the field/key.
        Value    => 'secretvalue',      # (optional) Value to potentially mask.
        IsConfig => 1,                  # (optional) Whether the value is a config option, default: 0.
    );

Returns masked value, in case the key is matched:

   $MaskedValue = 'xxx';

=cut

sub _MaskSensitiveValue {
    my ( $Self, %Param ) = @_;

    return '' if !$Param{Key} || !defined $Param{Value};

    # Skip masking sensitive values for Dynamic Fields.
    return $Param{Value} if $Param{Key} =~ qr{ dynamicfield }xi;

    # Match general key names, i.e. from the user preferences.
    my $Match = qr{ config|secret|passw|userpw|auth|token }xi;

    # Match forbidden config keys.
    if ( $Param{IsConfig} ) {
        $Match = qr{ (?:password|pw) \d* $ }smxi;
    }

    return $Param{Value} if $Param{Key} !~ $Match;

    return 'xxx';
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
