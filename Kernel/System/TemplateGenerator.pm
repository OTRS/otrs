# --
# Kernel/System/TemplateGenerator.pm - generate salutations, signatures and responses
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TemplateGenerator;

use strict;
use warnings;

use Kernel::System::HTMLUtils;
use Kernel::System::Salutation;
use Kernel::System::Signature;
use Kernel::System::SystemAddress;
use Kernel::System::StandardResponse;
use Kernel::System::Notification;
use Kernel::System::AutoResponse;
use Kernel::Language;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

use vars qw(@ISA);

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
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::User;
    use Kernel::System::Ticket;
    use Kernel::System::CustomerUser;
    use Kernel::System::Queue;
    use Kernel::System::TemplateGenerator;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        EncodeObject => $EncodeObject,
        GroupObject  => $GroupObject,              # if given
        CustomerUserObject => $CustomerUserObject, # if given
        QueueObject        => $QueueObject,        # if given
    );
    my $CustomerUserObject = Kernel::System::CustomerUser->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );
    my $QueueObject = Kernel::System::Queue->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        GroupObject  => $GroupObject, # if given
        CustomerGroupObject => $CustomerGroupObject, # if given
    );
    my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
        ConfigObject       => $ConfigObject,
        EncodeObject       => $EncodeObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        TimeObject         => $TimeObject,
        UserObject         => $UserObject,
        CustomerUserObject => $CustomerUserObject,
        QueueObject        => $QueueObject,
        TicketObject       => $TicketObject,
        MainObject         => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(DBObject ConfigObject LogObject TicketObject CustomerUserObject QueueObject UserObject MainObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{RichText} = $Self->{ConfigObject}->Get('Frontend::RichText');

    $Self->{HTMLUtilsObject}        = Kernel::System::HTMLUtils->new(%Param);
    $Self->{SalutationObject}       = Kernel::System::Salutation->new(%Param);
    $Self->{SignatureObject}        = Kernel::System::Signature->new(%Param);
    $Self->{SystemAddressObject}    = Kernel::System::SystemAddress->new(%Param);
    $Self->{StandardResponseObject} = Kernel::System::StandardResponse->new(%Param);
    $Self->{NotificationObject}     = Kernel::System::Notification->new(%Param);
    $Self->{AutoResponseObject}     = Kernel::System::AutoResponse->new(%Param);
    $Self->{DynamicFieldObject}     = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}          = Kernel::System::DynamicField::Backend->new(
        TimeObject => $Self->{TicketObject}->{TimeObject},
        %Param
    );

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

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
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get salutation
    my %Queue = $Self->{QueueObject}->QueueGet(
        ID => $Ticket{QueueID},
    );
    my %Salutation = $Self->{SalutationObject}->SalutationGet(
        ID => $Queue{SalutationID},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Salutation{ContentType} =~ /text\/plain/i ) {
        $Salutation{ContentType} = 'text/html';
        $Salutation{Text}        = $Self->{HTMLUtilsObject}->ToHTML(
            String => $Salutation{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Salutation{ContentType} =~ /text\/html/i ) {
        $Salutation{ContentType} = 'text/plain';
        $Salutation{Text}        = $Self->{HTMLUtilsObject}->ToAscii(
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
        $SalutationText = $Self->{HTMLUtilsObject}->LinkQuote(
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
    );

or

    my $Signature = $TemplateGeneratorObject->Signature(
        QueueID => 123,
        UserID  => 123,
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # need ticket id or queue id
    if ( !$Param{TicketID} && !$Param{QueueID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID or QueueID!' );
        return;
    }

    # get salutation ticket based
    my %Queue;
    if ( $Param{TicketID} ) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
        );
        %Queue = $Self->{QueueObject}->QueueGet(
            ID => $Ticket{QueueID},
        );
    }

    # get salutation queue based
    else {
        %Queue = $Self->{QueueObject}->QueueGet(
            ID => $Param{QueueID},
        );
    }

    # get signature
    my %Signature = $Self->{SignatureObject}->SignatureGet(
        ID => $Queue{SignatureID},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Signature{ContentType} =~ /text\/plain/i ) {
        $Signature{ContentType} = 'text/html';
        $Signature{Text}        = $Self->{HTMLUtilsObject}->ToHTML(
            String => $Signature{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Signature{ContentType} =~ /text\/html/i ) {
        $Signature{ContentType} = 'text/plain';
        $Signature{Text}        = $Self->{HTMLUtilsObject}->ToAscii(
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
        $SignatureText = $Self->{HTMLUtilsObject}->LinkQuote(
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

    John Doe at Super Support <support@example.com>

and it returns the quoted real name if necessary

    "John Doe, Support" <support@example.tld>

=cut

sub Sender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw( UserID QueueID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get sender attributes
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Param{QueueID} );

    # check config for agent real name
    my $UseAgentRealName = $Self->{ConfigObject}->Get('Ticket::DefineEmailFrom');
    if ( $UseAgentRealName && $UseAgentRealName =~ /^(AgentName|AgentNameSystemAddressName)$/ ) {

        # get data from current agent
        my %UserData = $Self->{UserObject}->GetUserData(
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
                my $Separator = ' ' . $Self->{ConfigObject}->Get('Ticket::DefineEmailFromSeparator')
                    || '';
                $Address{RealName} = $UserData{UserFirstname} . ' ' . $UserData{UserLastname}
                    . $Separator . ' ' . $Address{RealName};
            }
        }

    }

    # prepare realname quote
    if ( $Address{RealName} =~ /(,|@|\(|\)|:)/ && $Address{RealName} !~ /^("|')/ ) {
        $Address{RealName} =~ s/"/\"/g;
        $Address{RealName} = '"' . $Address{RealName} . '"';
    }
    my $Sender = "$Address{RealName} <$Address{Email}>";

    return $Sender;
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
    StandardResponse
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
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get salutation
    my %Queue = $Self->{QueueObject}->QueueGet(
        ID => $Ticket{QueueID},
    );
    my %Response = $Self->{StandardResponseObject}->StandardResponseGet(
        ID => $Param{ResponseID},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Response{ContentType} =~ /text\/plain/i ) {
        $Response{ContentType} = 'text/html';
        $Response{Response}    = $Self->{HTMLUtilsObject}->ToHTML(
            String => $Response{Response},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Response{ContentType} =~ /text\/html/i ) {
        $Response{ContentType} = 'text/plain';
        $Response{Response}    = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Response{Response},
        );
    }

    # replace place holder stuff
    my $ResponseText = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $Response{Response} || '',
        TicketID => $Param{TicketID},
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

    my $Salutation = $Self->Salutation(%Param);

    my $Signature = $Self->Signature(%Param);

    return (
        StandardResponse => $ResponseText,
        StdResponse      => $ResponseText,
        Salutation       => $Salutation,
        Signature        => $Signature,
    );
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get queue
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # prepare subject ...
    $Param{Data}->{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get ticket
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get auto default responses
    my %AutoResponse = $Self->{AutoResponseObject}->AutoResponseGetByTypeQueueID(
        QueueID => $Ticket{QueueID},
        Type    => $Param{AutoResponseType},
    );

    return if !%AutoResponse;

    # get old article for quoting
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
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
            for my $Line (@Lines) {
                $Line =~ s/(^>.+|.{4,86})(?:\s|\z)/$1\n/gm;
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

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $AutoResponse{ContentType} =~ /text\/plain/i ) {
        $AutoResponse{ContentType} = 'text/html';
        $AutoResponse{Text}        = $Self->{HTMLUtilsObject}->ToHTML(
            String => $AutoResponse{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $AutoResponse{ContentType} =~ /text\/html/i ) {
        $AutoResponse{ContentType} = 'text/plain';
        $AutoResponse{Text}        = $Self->{HTMLUtilsObject}->ToAscii(
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
    );

    # prepare subject (insert old subject)
    my $Subject = $Param{OrigHeader}->{Subject} || '';
    $Subject = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Subject,
    );
    if ( $AutoResponse{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/ ) {
        my $SubjectChar = $1;
        $Subject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $AutoResponse{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Subject/g;
    }
    $AutoResponse{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $AutoResponse{Subject},
        Type         => 'New',
        NoCleanup    => 1,
    );

    # get sender attributes based on auto response type
    if ( $AutoResponse{SystemAddressID} ) {
        my %Address = $Self->{SystemAddressObject}->SystemAddressGet(
            ID => $AutoResponse{SystemAddressID},
        );
        $AutoResponse{SenderAddress}  = $Address{Name};
        $AutoResponse{SenderRealname} = $Address{Realname};
    }

    # get sender attributes based on queue
    else {
        my %Address = $Self->{QueueObject}->GetSystemAddress(
            QueueID => $Ticket{QueueID},
        );
        $AutoResponse{SenderAddress}  = $Address{Email};
        $AutoResponse{SenderRealname} = $Address{RealName};
    }

    # add urls and verify to be full html document
    if ( $Self->{RichText} ) {

        $AutoResponse{Text} = $Self->{HTMLUtilsObject}->LinkQuote(
            String => $AutoResponse{Text},
        );

        $AutoResponse{Text} = $Self->{HTMLUtilsObject}->DocumentComplete(
            Charset => $AutoResponse{Charset},
            String  => $AutoResponse{Text},
        );
    }

    return %AutoResponse;
}

=item NotificationAgent()

generate response

NotificationAgent
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
        RecipientID => 123,
        UserID      => 123,
    );

=cut

sub NotificationAgent {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Type RecipientID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get ticket
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # get old article for quoting
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    for (qw(From To Cc Subject Body)) {
        if ( !$Param{CustomerMessageParams}->{$_} ) {
            $Param{CustomerMessageParams}->{$_} = $Article{$_} || '';
        }
        chomp $Param{CustomerMessageParams}->{$_};
    }

    # format body (only if longer the 86 chars)
    if ( $Param{CustomerMessageParams}->{Body} ) {
        if ( length $Param{CustomerMessageParams}->{Body} > 86 ) {
            my @Lines = split /\n/, $Param{CustomerMessageParams}->{Body};
            for my $Line (@Lines) {
                $Line =~ s/(^>.+|.{4,86})(?:\s|\z)/$1\n/gm;
            }
            $Param{CustomerMessageParams}->{Body} = join '', @Lines;
        }
    }

    # fill up required attributes
    for (qw(Subject Body)) {
        if ( !$Param{CustomerMessageParams}->{$_} ) {
            $Param{CustomerMessageParams}->{$_} = "No $_";
        }
    }

    # get recipient
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $Param{RecipientID},
        Valid  => 1,
    );

    # get user language
    my $Language = $User{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';

    # get notification data
    my %Notification = $Self->{NotificationObject}->NotificationGet(
        Name => $Language . '::Agent::' . $Param{Type},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Notification{ContentType} =~ /text\/plain/i ) {
        $Notification{ContentType} = 'text/html';
        $Notification{Body}        = $Self->{HTMLUtilsObject}->ToHTML(
            String => $Notification{Body},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Notification{ContentType} =~ /text\/html/i ) {
        $Notification{ContentType} = 'text/plain';
        $Notification{Body}        = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Notification{Body},
        );
    }

    # get notify texts
    for (qw(Subject Body)) {
        if ( !$Notification{$_} ) {
            $Notification{$_} = "No Notification $_ for $Param{Type} found!";
        }
    }

    # replace place holder stuff
    $Notification{Body} = $Self->_Replace(
        RichText            => $Self->{RichText},
        Text                => $Notification{Body},
        RecipientID         => $Param{RecipientID},
        Data                => $Param{CustomerMessageParams},
        TicketID            => $Param{TicketID},
        UserID              => $Param{UserID},
        Language            => $Language,
        LastCustomerArticle => \%Article,
    );
    $Notification{Subject} = $Self->_Replace(
        RichText    => 0,
        Text        => $Notification{Subject},
        RecipientID => $Param{RecipientID},
        Data        => $Param{CustomerMessageParams},
        TicketID    => $Param{TicketID},
        UserID      => $Param{UserID},
        Language    => $Language,
    );

    # prepare subject (insert old subject)
    $Param{CustomerMessageParams}->{Subject} = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Ticket{TicketNumber},
        Subject => $Param{CustomerMessageParams}->{Subject} || '',
    );
    if ( $Notification{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/ ) {
        my $SubjectChar = $1;
        $Param{CustomerMessageParams}->{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;

        $Notification{Subject}
            =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Param{CustomerMessageParams}->{Subject}/g;
    }
    $Notification{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Notification{Subject} || '',
        Type         => 'New',
    );

    # add urls and verify to be full html document
    if ( $Self->{RichText} ) {

        $Notification{Body} = $Self->{HTMLUtilsObject}->LinkQuote(
            String => $Notification{Body},
        );

        $Notification{Body} = $Self->{HTMLUtilsObject}->DocumentComplete(
            Charset => $Notification{Charset},
            String  => $Notification{Body},
        );
    }

    return %Notification;
}

=item NotificationCustomer()

generate response

NotificationCustomer
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

    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    my %Queue;
    if ( $Param{QueueID} ) {
        %Queue = $Self->{QueueObject}->QueueGet( ID => $Param{QueueID} );
    }

    my %User;

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

    $Notification{ContentType} = 'text/plain';

    # replace place holder stuff
    for (qw(Subject Body)) {
        $Notification{$_} = $Self->_Replace(
            RichText => 0,
            Text     => $Notification{$_},
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            Language => $Language,
        );
    }

    # get sender attributes
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );
    $Notification{SenderAddress}  = $Address{Email};
    $Notification{SenderRealname} = $Address{RealName};

    return %Notification;
}

=begin Internal:

=cut

sub _Replace {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Text RichText Data UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Start = '<';
    my $End   = '>';
    if ( $Param{RichText} ) {
        $Start = '&lt;';
        $End   = '&gt;';
        $Param{Text} =~ s/(\n|\r)//g;
    }

    my %Ticket;
    if ( $Param{TicketID} ) {
        %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 1,
        );
    }

    # translate ticket values if needed
    if ( $Param{Language} ) {
        my $LanguageObject = Kernel::Language->new(
            MainObject   => $Self->{MainObject},
            ConfigObject => $Self->{ConfigObject},
            EncodeObject => $Self->{EncodeObject},
            LogObject    => $Self->{LogObject},
            UserLanguage => $Param{Language},
        );
        for my $Field (qw(Type State StateType Lock Priority)) {
            $Ticket{$Field} = $LanguageObject->Get( $Ticket{$Field} );
        }
    }

    my %Queue;
    if ( $Param{QueueID} ) {
        %Queue = $Self->{QueueObject}->QueueGet( ID => $Param{QueueID} );
    }

    # replace config options
    my $Tag = $Start . 'OTRS_CONFIG_';
    $Param{Text} =~ s{$Tag(.+?)$End}{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';
    if ( $Param{RecipientID} ) {
        my %Recipient = $Self->{UserObject}->GetUserData(
            UserID        => $Param{RecipientID},
            NoOutOfOffice => 1,
        );

        # html quoting of content
        if ( $Param{RichText} ) {
            for ( sort keys %Recipient ) {
                next if !$Recipient{$_};
                $Recipient{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Recipient{$_},
                );
            }
        }

        # replace it
        for ( sort keys %Recipient ) {
            next if !defined $Recipient{$_};
            $Param{Text} =~ s/$Tag$_$End/$Recipient{$_}/gi;
        }
    }

    # get owner data and replace it with <OTRS_OWNER_...
    $Tag = $Start . 'OTRS_OWNER_';
    if ( $Ticket{OwnerID} ) {
        my %Owner = $Self->{UserObject}->GetUserData(
            UserID        => $Ticket{OwnerID},
            NoOutOfOffice => 1,
        );

        # html quoting of content
        if ( $Param{RichText} ) {
            for ( sort keys %Owner ) {
                next if !$Owner{$_};
                $Owner{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Owner{$_},
                );
            }
        }

        # replace it
        for ( sort keys %Owner ) {
            next if !defined $Owner{$_};
            $Param{Text} =~ s/$Tag$_$End/$Owner{$_}/gi;
        }
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    # get owner data and replace it with <OTRS_RESPONSIBLE_...
    $Tag = $Start . 'OTRS_RESPONSIBLE_';
    if ( $Ticket{ResponsibleID} ) {
        my %Responsible = $Self->{UserObject}->GetUserData(
            UserID        => $Ticket{ResponsibleID},
            NoOutOfOffice => 1,
        );

        # html quoting of content
        if ( $Param{RichText} ) {
            for ( sort keys %Responsible ) {
                next if !$Responsible{$_};
                $Responsible{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Responsible{$_},
                );
            }
        }

        # replace it
        for ( sort keys %Responsible ) {
            next if !defined $Responsible{$_};
            $Param{Text} =~ s/$Tag$_$End/$Responsible{$_}/gi;
        }
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2        = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $Self->{UserObject}->GetUserData(
        UserID        => $Param{UserID},
        NoOutOfOffice => 1,
    );

    # html quoting of content
    if ( $Param{RichText} ) {
        for ( sort keys %CurrentUser ) {
            next if !$CurrentUser{$_};
            $CurrentUser{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $CurrentUser{$_},
            );
        }
    }

    # replace it
    for ( sort keys %CurrentUser ) {
        next if !defined $CurrentUser{$_};
        $Param{Text} =~ s/$Tag$_$End/$CurrentUser{$_}/gi;
        $Param{Text} =~ s/$Tag2$_$End/$CurrentUser{$_}/gi;
    }

    # replace other needed stuff
    $Param{Text} =~ s/$Start OTRS_FIRST_NAME $End/$CurrentUser{UserFirstname}/gxms;
    $Param{Text} =~ s/$Start OTRS_LAST_NAME $End/$CurrentUser{UserLastname}/gxms;

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;
    $Param{Text} =~ s/$Tag2.+?$End/-/gi;

    # ticket data
    $Tag = $Start . 'OTRS_TICKET_';

    # html quoting of content
    if ( $Param{RichText} ) {
        for ( sort keys %Ticket ) {
            next if !$Ticket{$_};
            $Ticket{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Ticket{$_},
            );
        }
    }

    # Dropdown, Checkbox and MultipleSelect DynamicFields, can store values (keys) that are
    # different from the the values to display
    # <OTRS_TICKET_DynamicField_NameX> returns the stored key
    # <OTRS_TICKET_DynamicField_NameX_Value> returns the display value

    # to store all the DynamicField display values
    my %DynamicFieldDisplayValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $LanguageObject;

        # translate values if needed
        if ( $Param{Language} ) {
            $LanguageObject = Kernel::Language->new(
                MainObject   => $Self->{MainObject},
                ConfigObject => $Self->{ConfigObject},
                EncodeObject => $Self->{EncodeObject},
                LogObject    => $Self->{LogObject},
                UserLanguage => $Param{Language},
            );
        }

        # get the display value for each dynamic field
        my $DisplayValue = $Self->{BackendObject}->ValueLookup(
            DynamicFieldConfig => $DynamicFieldConfig,
            Key                => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            LanguageObject     => $LanguageObject,
        );

        # get the readable value (value) for each dynamic field
        my $DisplayValueStrg = $Self->{BackendObject}->ReadableValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $DisplayValue,
        );

        # fill the DynamicFielsDisplayValues
        if ($DisplayValueStrg) {
            $DynamicFieldDisplayValues{ 'DynamicField_' . $DynamicFieldConfig->{Name} . '_Value' }
                = $DisplayValueStrg->{Value};
        }

        # get the readable value (key) for each dynamic field
        my $ValueStrg = $Self->{BackendObject}->ReadableValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
        );

        # replace ticket content with the value from ReadableValueRender (if any)
        if ( IsHashRefWithData($ValueStrg) ) {
            $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $ValueStrg->{Value};
        }
    }

    # replace it
    for ( sort keys %Ticket ) {
        next if !defined $Ticket{$_};
        $Param{Text} =~ s/$Tag$_$End/$Ticket{$_}/gi;
    }
    for ( sort keys %DynamicFieldDisplayValues ) {
        next if !defined $DynamicFieldDisplayValues{$_};
        $Param{Text} =~ s/$Tag$_$End/$DynamicFieldDisplayValues{$_}/gi;
    }

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

    # get customer params and replace it with <OTRS_CUSTOMER_...
    my %Data = %{ $Param{Data} };

    # html quoting of content
    if ( $Param{RichText} ) {
        for ( sort keys %Data ) {
            next if !$Data{$_};
            $Data{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Data{$_},
            );
        }
    }
    if (%Data) {

        # check if original content isn't text/plain, don't use it
        if ( $Data{'Content-Type'} && $Data{'Content-Type'} !~ /(text\/plain|\btext\b)/i ) {
            $Data{Body} = '-> no quotable message <-';
        }

        # replace <OTRS_CUSTOMER_*> tags
        $Tag = $Start . 'OTRS_CUSTOMER_';
        for ( sort keys %Data ) {
            next if !defined $Data{$_};
            $Param{Text} =~ s/$Tag$_$End/$Data{$_}/gi;
        }

        # replace <OTRS_CUSTOMER_BODY> and <OTRS_COMMENT> tags
        for my $Key (qw(OTRS_CUSTOMER_BODY OTRS_COMMENT)) {
            $Tag = $Start . $Key;
            if ( $Param{Text} =~ /$Tag$End(\n|\r|)/g ) {
                my $Line       = 2500;
                my @Body       = split( /\n/, $Data{Body} );
                my $NewOldBody = '';
                for ( my $i = 0; $i < $Line; $i++ ) {
                    if ( $#Body >= $i ) {

                        # add no quote char, do it later by using DocumentCleanup()
                        if ( $Param{RichText} ) {
                            $NewOldBody .= $Body[$i];
                        }

                        # add "> " as quote char
                        else {
                            $NewOldBody .= "> $Body[$i]";
                        }

                        # add new line
                        if ( $i < ( $Line - 1 ) ) {
                            $NewOldBody .= "\n";
                        }
                    }
                    else {
                        last;
                    }
                }
                chomp $NewOldBody;

                # html quoting of content
                if ( $Param{RichText} && $NewOldBody ) {

                    # remove trailing new lines
                    for ( 1 .. 10 ) {
                        $NewOldBody =~ s/(<br\/>)\s{0,20}$//gs;
                    }

                    # add quote
                    $NewOldBody = "<blockquote type=\"cite\">$NewOldBody</blockquote>";
                    $NewOldBody = $Self->{HTMLUtilsObject}->DocumentCleanup(
                        String => $NewOldBody,
                    );
                }

                # replace tag
                $Param{Text} =~ s/$Tag$End/$NewOldBody/g;
            }
        }

        # replace <OTRS_CUSTOMER_EMAIL[]> tags
        $Tag = $Start . 'OTRS_CUSTOMER_EMAIL';
        if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {

            # This tag should include the message body
            # of the last customer message.
            #
            # In $Data{Body} it may happen that
            # the currents article Body gets passed down here.
            #
            # So we have to use the Body of the $Param{Article}
            # hash holding the article of the last customer message.
            my $CustomerEmailBody = $Data{Body};

            if (
                $Param{LastCustomerArticle}
                && ref $Param{LastCustomerArticle} eq 'HASH'
                && $Param{LastCustomerArticle}->{Body}
                && length $Param{LastCustomerArticle}->{Body}
                )
            {
                $CustomerEmailBody = $Param{LastCustomerArticle}->{Body};
            }

            my $Line       = $1;
            my @Body       = split( /\n/, $CustomerEmailBody );
            my $NewOldBody = '';
            for ( my $i = 0; $i < $Line; $i++ ) {

                # 2002-06-14 patch of Pablo Ruiz Garcia
                # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
                if ( $#Body >= $i ) {

                    # add no quote char, do it later by using DocumentCleanup()
                    if ( $Param{RichText} ) {
                        $NewOldBody .= $Body[$i];
                    }

                    # add "> " as quote char
                    else {
                        $NewOldBody .= "> $Body[$i]";
                    }

                    # add new line
                    if ( $i < ( $Line - 1 ) ) {
                        $NewOldBody .= "\n";
                    }
                }
            }
            chomp $NewOldBody;

            # html quoting of content
            if ( $Param{RichText} && $NewOldBody ) {

                # remove trailing new lines
                for ( 1 .. 10 ) {
                    $NewOldBody =~ s/(<br\/>)\s{0,20}$//gs;
                }

                # add quote
                $NewOldBody = "<blockquote type=\"cite\">$NewOldBody</blockquote>";
                $NewOldBody = $Self->{HTMLUtilsObject}->DocumentCleanup(
                    String => $NewOldBody,
                );
            }

            # replace tag
            $Param{Text} =~ s/$Tag\[.+?\]$End/$NewOldBody/g;
        }

        # replace <OTRS_CUSTOMER_SUBJECT[]> tags
        $Tag = $Start . 'OTRS_CUSTOMER_SUBJECT';
        if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {
            my $SubjectChar = $1;
            my $Subject     = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Ticket{TicketNumber},
                Subject      => $Data{Subject},
            );
            $Subject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
            $Param{Text} =~ s/$Tag\[.+?\]$End/$Subject/g;
        }

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

    # get and prepare realname
    $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
    if ( $Param{Text} =~ /$Tag$End/i ) {
        my $From = '';
        if ( $Ticket{CustomerUserID} ) {
            $From = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $Ticket{CustomerUserID}
            );
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

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';
    if ( $Ticket{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );

        # html quoting of content
        if ( $Param{RichText} ) {
            for ( sort keys %CustomerUser ) {
                next if !$CustomerUser{$_};
                $CustomerUser{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $CustomerUser{$_},
                );
            }
        }

        # replace it
        for my $Key ( sort keys %CustomerUser ) {
            next if !defined $CustomerUser{$Key};
            $Param{Text} =~ s/$Tag$Key$End/$CustomerUser{$Key}/gi;
            $Param{Text} =~ s/$Tag2$Key$End/$CustomerUser{$Key}/gi;
        }
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Param{Text} =~ s/$Tag.+?$End/-/gi;
    $Param{Text} =~ s/$Tag2.+?$End/-/gi;

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
