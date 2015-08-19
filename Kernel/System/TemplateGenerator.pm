# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TemplateGenerator;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use Kernel::Language;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AutoResponse',
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
    'Kernel::System::User',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::JSON',

);

=head1 NAME

Kernel::System::TemplateGenerator - signature lib

=head1 SYNOPSIS

All signature functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
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

=item Salutation()

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

    # get  queue
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get salutation
    my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
        ID => $Ticket{QueueID},
    );
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

    # replace place holder stuff
    my $SalutationText = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $Salutation{Text},
        TicketID => $Param{TicketID},
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

    # add urls
    if ( $Self->{RichText} ) {
        $SalutationText = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $SalutationText,
        );
    }

    return $SalutationText;
}

=item Signature()

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

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # get salutation ticket based
    my %Queue;
    if ( $Param{TicketID} ) {

        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
        );

        %Queue = $QueueObject->QueueGet(
            ID => $Ticket{QueueID},
        );
    }

    # get salutation queue based
    else {
        %Queue = $QueueObject->QueueGet(
            ID => $Param{QueueID},
        );
    }

    # get signature
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

    # replace place holder stuff
    my $SignatureText = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $Signature{Text},
        TicketID => $Param{TicketID} || '',
        Data     => $Param{Data},
        QueueID  => $Param{QueueID},
        UserID   => $Param{UserID},
    );

    # add urls
    if ( $Self->{RichText} ) {
        $SignatureText = $Kernel::OM->Get('Kernel::System::HTMLUtils')->LinkQuote(
            String => $SignatureText,
        );
    }

    return $SignatureText;
}

=item Sender()

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
            if ( $UserData{UserLastname} && $UserData{UserFirstname} ) {

                # rewrite RealName
                $Address{RealName} = "$UserData{UserFirstname} $UserData{UserLastname}";
            }
        }

        # set real name with user name
        if ( $UseAgentRealName eq 'AgentNameSystemAddressName' ) {

            # check for user data
            if ( $UserData{UserLastname} && $UserData{UserFirstname} ) {

                # rewrite RealName
                my $Separator = ' ' . $ConfigObject->Get('Ticket::DefineEmailFromSeparator')
                    || '';
                $Address{RealName} = $UserData{UserFirstname} . ' ' . $UserData{UserLastname}
                    . $Separator . ' ' . $Address{RealName};
            }
        }
    }

    # prepare realname quote
    if ( $Address{RealName} =~ /(,|@|\(|\)|:)/ && $Address{RealName} !~ /^("|')/ ) {
        $Address{RealName} =~ s/"//g;    # remove any quotes that are already present
        $Address{RealName} = '"' . $Address{RealName} . '"';
    }
    my $Sender = "$Address{RealName} <$Address{Email}>";

    return $Sender;
}

=item Template()

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

    # replace place holder stuff
    my $TemplateText = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $Template{Template} || '',
        TicketID => $Param{TicketID} || '',
        Data     => $Param{Data} || {},
        UserID   => $Param{UserID},
    );

    return $TemplateText;
}

=item Attributes()

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

    # get ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get auto default responses
    my %AutoResponse = $Kernel::OM->Get('Kernel::System::AutoResponse')->AutoResponseGetByTypeQueueID(
        QueueID => $Ticket{QueueID},
        Type    => $Param{AutoResponseType},
    );

    return if !%AutoResponse;

    # get old article for quoting
    my %Article = $TicketObject->ArticleLastCustomerArticle(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    for (qw(From To Cc Subject Body)) {
        if ( !$Param{OrigHeader}->{$_} ) {
            $Param{OrigHeader}->{$_} = $Article{$_} || '';
        }
        chomp $Param{OrigHeader}->{$_};
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
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
        Language => $Language,
    );
    $AutoResponse{Subject} = $Self->_Replace(
        RichText => 0,
        Text     => $AutoResponse{Subject},
        Data     => {
            %{ $Param{OrigHeader} },
            From => $Param{OrigHeader}->{To},
            To   => $Param{OrigHeader}->{From},
        },
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
        Language => $Language,
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

=item NotificationEvent()

replace all OTRS smart tags in the notification body and subject

    my %NotificationEvent = $TemplateGeneratorObject->NotificationEvent(
        TicketID              => 123,
        Recipient             => $UserDataHashRef,          # Agent or Customer data get result
        Notification          => $NotificationDataHashRef,
        CustomerMessageParams => $ArticleHashRef,           # optional
        UserID                => 123,
    );

=cut

sub NotificationEvent {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID Notification Recipient UserID)) {
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

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get last article from customer
    my %Article = $TicketObject->ArticleLastCustomerArticle(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get last article from agent
    my @ArticleBoxAgent = $TicketObject->ArticleGet(
        TicketID      => $Param{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    my %ArticleAgent;

    ARTICLE:
    for my $Article ( reverse @ArticleBoxAgent ) {

        next ARTICLE if $Article->{SenderType} ne 'agent';

        %ArticleAgent = %{$Article};

        last ARTICLE;
    }

    # get ID for customer and agent articles
    my $CustomerArticleID = $Article{ArticleID}      || '';
    my $AgentArticleID    = $ArticleAgent{ArticleID} || '';

    # get articles for later use
    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID                   => $Param{TicketID},
        DynamicFields              => 0,
        UserID                     => $Param{UserID},
        StripPlainBodyAsAttachment => 2,
    );

    ARTICLEBOX:
    for my $ArticleItem ( reverse @ArticleBox ) {

        if ( $CustomerArticleID ne $ArticleItem->{ArticleID} && $AgentArticleID ne $ArticleItem->{ArticleID} ) {
            next ARTICLEBOX;
        }

        if ( $ArticleItem->{AttachmentIDOfHTMLBody} ) {

            # get a attachment
            my %Data = $TicketObject->ArticleAttachment(
                ArticleID => $ArticleItem->{ArticleID},
                FileID    => $ArticleItem->{AttachmentIDOfHTMLBody},
                UserID    => $Param{UserID},
            );

            # get charset and convert content to internal charset
            my $Charset;
            if ( $Data{ContentType} =~ m/.+?charset=("|'|)(.+)/ig ) {
                $Charset = $2;
                $Charset =~ s/"|'//g;
            }
            if ( !$Charset ) {
                $Charset = 'us-ascii';
                $Data{ContentType} .= '; charset="us-ascii"';
            }

            # convert charset
            if ($Charset) {
                $Data{Content} = $Kernel::OM->Get('Kernel::System::Encode')->Convert(
                    Text => $Data{Content},
                    From => $Charset,
                    To   => 'utf-8',
                );

                # replace charset in content
                $Data{ContentType} =~ s/\Q$Charset\E/utf-8/gi;
                $Data{Content} =~ s/(charset=("|'|))\Q$Charset\E/$1utf-8/gi;
            }

            $Data{Content} =~ s/&amp;/&/g;
            $Data{Content} =~ s/&lt;/</g;
            $Data{Content} =~ s/&gt;/>/g;
            $Data{Content} =~ s/&quot;/"/g;

            # strip head, body and meta elements
            my $HTMLBody = $Kernel::OM->Get('Kernel::System::HTMLUtils')->DocumentStrip(
                String => $Data{Content},
            );

            # set HTML body for customer article
            if ( $CustomerArticleID eq $ArticleItem->{ArticleID} ) {
                $Param{CustomerMessageParams}->{HTMLBody} = $HTMLBody;
            }

            # set HTML body for agent article
            if ( $AgentArticleID eq $ArticleItem->{ArticleID} ) {
                $ArticleAgent{HTMLBody} = $HTMLBody;
            }
        }
    }

    # get  HTMLUtils object
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    # set the accounted time as part of the articles information
    ARTICLE:
    for my $ArticleData ( \%Article, \%ArticleAgent ) {

        next ARTICLE if !$ArticleData->{ArticleID};

        # get accounted time
        my $AccountedTime = $TicketObject->ArticleAccountedTimeGet(
            ArticleID => $ArticleData->{ArticleID},
        );

        $ArticleData->{TimeUnit} = $AccountedTime;
    }

    # get system default language
    my $DefaultLanguage = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';

    # get user language
    my $Language = $Param{Recipient}->{UserLanguage} || $DefaultLanguage;

    # make sure a message in the user language exists
    if ( !$Notification{Message}->{$Language} ) {

        # otherwise use default language
        $Language = $DefaultLanguage;

        # if no message exists in default language, then take the first available language
        if ( !$Notification{Message}->{$Language} ) {
            my @Languages = sort keys %{ $Notification{Message} };
            $Language = $Languages[0];
        }
    }

    # copy the correct language message attributes to a flat structure
    for my $Attribute (qw(Subject Body ContentType)) {
        $Notification{$Attribute} = $Notification{Message}->{$Language}->{$Attribute};
    }

    # convert values to HTML to get correct line breaks etc.
    if ( $Notification{ContentType} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %{ $Param{CustomerMessageParams} || {} } ) {
            next KEY if !$Param{CustomerMessageParams}->{$Key};

            # convert HTMLBody to HTML is not needed
            next KEY if $Key eq 'HTMLBody';
            $Param{CustomerMessageParams}->{$Key} = $HTMLUtilsObject->ToHTML(
                String => $Param{CustomerMessageParams}->{$Key},
            );
        }
    }

    for my $Key (qw(From To Cc Subject Body ContentType ArticleType)) {
        if ( !$Param{CustomerMessageParams}->{$Key} ) {
            $Param{CustomerMessageParams}->{$Key} = $Article{$Key} || '';
        }
        chomp $Param{CustomerMessageParams}->{$Key};
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
            $Param{CustomerMessageParams}->{$Text} = "No $Text";
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

        $Notification{Body} =~ s/${Start}OTRS_CUSTOMER_DATA_$Key${End}/$Param{CustomerMessageParams}->{$Key}/gi;
        $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$Key>/$Param{CustomerMessageParams}->{$Key}{$_}/gi;
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
        RichText  => $Self->{RichText},
        Text      => $Notification{Body},
        Recipient => $Param{Recipient},
        Data      => $Param{CustomerMessageParams},
        DataAgent => \%ArticleAgent,
        TicketID  => $Param{TicketID},
        UserID    => $Param{UserID},
        Language  => $Language,
    );
    $Notification{Subject} = $Self->_Replace(
        RichText  => 0,
        Text      => $Notification{Subject},
        Recipient => $Param{Recipient},
        Data      => $Param{CustomerMessageParams},
        DataAgent => \%ArticleAgent,
        TicketID  => $Param{TicketID},
        UserID    => $Param{UserID},
        Language  => $Language,
    );

    $Notification{Subject} = $TicketObject->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
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
    if ( $Param{TicketID} ) {
        %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 1,
        );
    }

    # translate ticket values if needed
    if ( $Param{Language} ) {
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Param{Language},
        );
        for my $Field (qw(Type State StateType Lock Priority)) {
            $Ticket{$Field} = $LanguageObject->Translate( $Ticket{$Field} );
        }
    }

    my %Queue;
    if ( $Param{QueueID} ) {
        %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
            ID => $Param{QueueID},
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # replace config options
    my $Tag = $Start . 'OTRS_CONFIG_';
    $Param{Text} =~ s{$Tag(.+?)$End}{$ConfigObject->Get($1)}egx;

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

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';
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

        # use notification recipient
        my $RecipientTag = 'NOTIFICATION_RECIPIENT_';

        # replace it
        ATTRIBUTE:
        for my $Attribute ( sort keys %Recipient ) {
            next ATTRIBUTE if !defined $Recipient{$Attribute};
            $Param{Text} =~ s/$Tag$Attribute$End/$Recipient{$Attribute}/gi;

            # include more readable tag
            $Param{Text} =~ s/$RecipientTag$Attribute$End/$Recipient{$Attribute}/gi;
        }
    }

    # get owner data and replace it with <OTRS_OWNER_...
    $Tag = $Start . 'OTRS_OWNER_';

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

        # replace it
        ATTRIBUTE:
        for my $Attribute ( sort keys %Owner ) {
            next ATTRIBUTE if !defined $Owner{$Attribute};
            $Param{Text} =~ s/$Tag$Attribute$End/$Owner{$Attribute}/gi;
        }
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    my $HashGlobalReplace = sub {
        my ( $Tag, %H ) = @_;

        # Generate one single matching string for all keys to save performance.
        my $Keys = join '|', map {quotemeta} grep { defined $H{$_} } keys %H;

        # Add all keys also as lowercase to be able to match case insensitive,
        #   e. g. <OTRS_CUSTOMER_From> and <OTRS_CUSTOMER_FROM>.
        for my $Key ( sort keys %H ) {
            $H{ lc $Key } = $H{$Key};
        }

        $Param{Text} =~ s/(?:$Tag)($Keys)$End/$H{ lc $1 }/ieg;
    };

    # get owner data and replace it with <OTRS_RESPONSIBLE_...
    $Tag = $Start . 'OTRS_RESPONSIBLE_';
    if ( $Ticket{ResponsibleID} ) {
        my %Responsible = $UserObject->GetUserData(
            UserID        => $Ticket{ResponsibleID},
            NoOutOfOffice => 1,
        );

        # html quoting of content
        if ( $Param{RichText} ) {

            ATTRIBUTE:
            for my $Attribute ( sort keys %Responsible ) {
                next ATTRIBUTE if !$Responsible{$Attribute};
                $Responsible{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $Responsible{$Attribute},
                );
            }
        }

        # replace it
        $HashGlobalReplace->( $Tag, %Responsible );
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2        = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $UserObject->GetUserData(
        UserID        => $Param{UserID},
        NoOutOfOffice => 1,
    );

    # html quoting of content
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
        }

        # get the readable value (key) for each dynamic field
        my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
        );

        # replace ticket content with the value from ReadableValueRender (if any)
        if ( IsHashRefWithData($ValueStrg) ) {
            $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $ValueStrg->{Value};
        }
    }

    # replace it
    $HashGlobalReplace->( $Tag, %Ticket, %DynamicFieldDisplayValues );

    # COMPAT
    $Param{Text} =~ s/$Start OTRS_TICKET_ID $End/$Ticket{TicketID}/gixms;
    $Param{Text} =~ s/$Start OTRS_TICKET_NUMBER $End/$Ticket{TicketNumber}/gixms;
    if ( $Param{TicketID} ) {
        $Param{Text} =~ s/$Start OTRS_QUEUE $End/$Ticket{Queue}/gixms;
    }
    if ( $Param{QueueID} ) {
        $Param{Text} =~ s/$Start OTRS_TICKET_QUEUE $End/$Queue{Name}/gixms;
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    # get customer and agent params and replace it with <OTRS_CUSTOMER_... or <OTRS_AGENT_...
    my %ArticleData = (
        'OTRS_CUSTOMER_' => $Param{Data}      || {},
        'OTRS_AGENT_'    => $Param{DataAgent} || {},
    );

    # use a list to get customer first
    for my $DataType (qw(OTRS_CUSTOMER_ OTRS_AGENT_)) {
        my %Data = %{ $ArticleData{$DataType} };

        # html quoting of content
        if (
            $Param{RichText}
            && !$Data{HTMLBody}
            && ( !$Data{ContentType} || $Data{ContentType} !~ /application\/json/ )
            )
        {

            ATTRIBUTE:
            for my $Attribute ( sort keys %Data ) {
                next ATTRIBUTE if !$Data{$Attribute};

                $Data{$Attribute} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
                    String => $Data{$Attribute},
                );
            }
        }
        if (%Data) {

            # Check if content type is JSON
            if ( $Data{'ContentType'} && $Data{'ContentType'} =~ /application\/json/ ) {

                # if article is chat related
                if ( $Data{'ArticleType'} =~ /chat/ ) {

                    # remove spaces
                    $Data{Body} =~ s/\n/ /gms;

                    my $Body = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                        Data => $Data{Body},
                    );

                    # replace body with html text
                    $Data{Body} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
                        TemplateFile => "ChatDisplay",
                        Data         => {
                            ChatMessages => $Body,
                        },
                    );
                }
            }

            # check if original content isn't text/plain, don't use it
            if ( $Data{'Content-Type'} && $Data{'Content-Type'} !~ /(text\/plain|\btext\b)/i ) {
                $Data{Body} = '-> no quotable message <-';
            }

            # replace <OTRS_CUSTOMER_*> and <OTRS_AGENT_*> tags
            $Tag = $Start . $DataType;
            $HashGlobalReplace->( $Tag, %Data );

            # prepare body (insert old email) <OTRS_CUSTOMER_EMAIL[n]>, <OTRS_CUSTOMER_NOTE[n]>
            #   <OTRS_CUSTOMER_BODY[n]>, <OTRS_AGENT_EMAIL[n]>..., <OTRS_COMMENT>
            if ( $Param{Text} =~ /$Start(?:(?:$DataType(EMAIL|NOTE|BODY)\[(.+?)\])|(?:OTRS_COMMENT))$End/g ) {

                my $Line = $2 || 2500;
                my $NewOldBody = '';
                if ( $Data{HTMLBody} ) {

                    # comment
                    my $CharactersPerLine = $ConfigObject->Get('Notification::CharactersPerLine') || 80;
                    my $CharactersLong = $Line * $CharactersPerLine; # 80 is a fixed value for testing, it should change

                    $NewOldBody = $Kernel::OM->Get('Kernel::System::HTMLUtils')->HTMLTruncate(
                        String   => $Data{HTMLBody},
                        Chars    => $CharactersLong,
                        Ellipsis => '...',
                        UTF8Mode => 1,
                        OnSpace  => 1,
                    );
                }
                else {
                    my @Body = split( /\n/, $Data{Body} );
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

                $Param{Text}
                    =~ s/$Start(?:(?:$DataType(EMAIL|NOTE|BODY)\[(.+?)\])|(?:OTRS_COMMENT))$End/$NewOldBody/g;
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

                # Arnold Ligtvoet - otrs@ligtvoet.org
                # get <OTRS_EMAIL_DATE[]> from body and replace with received date
                use POSIX qw(strftime);
                $Tag = $Start . 'OTRS_EMAIL_DATE';

                if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {

                    my $TimeZone = $1;
                    my $EmailDate = strftime( '%A, %B %e, %Y at %T ', localtime );    ## no critic
                    $EmailDate .= "($TimeZone)";
                    $Param{Text} =~ s/$Tag\[.+?\]$End/$EmailDate/g;
                }
            }
        }

        if ( $DataType eq 'OTRS_CUSTOMER_' ) {

            # get and prepare realname
            $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
            if ( $Param{Text} =~ /$Tag$End/i ) {

                my $From = '';

                if ( $Ticket{CustomerUserID} ) {

                    $From = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                        UserLogin => $Ticket{CustomerUserID}
                    );
                }

                # try to get the real name directly from the data
                $From //= $Recipient{RealName};

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

        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
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

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
