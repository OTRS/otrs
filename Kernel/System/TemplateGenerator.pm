# --
# Kernel/System/TemplateGenerator.pm - generate salutations, signatures and responses
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TemplateGenerator.pm,v 1.18 2009-07-14 13:36:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::TemplateGenerator;

use strict;
use warnings;

use Kernel::System::HTML2Ascii;
use Kernel::System::Salutation;
use Kernel::System::Signature;
use Kernel::System::StdResponse;
use Kernel::System::Notification;
use Kernel::System::AutoResponse;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

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
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        TimeObject         => $TimeObject,
        UserObject         => $UserObject,
        CustomerUserObject => $CustomerUserObject,
        QueueObject        => $QueueObject,
        TicketObject       => $TicketObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TicketObject CustomerUserObject QueueObject UserObject))
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{RichText} = $Self->{ConfigObject}->Get('Frontend::RichText');

    $Self->{HTML2AsciiObject}   = Kernel::System::HTML2Ascii->new(%Param);
    $Self->{SalutationObject}   = Kernel::System::Salutation->new(%Param);
    $Self->{SignatureObject}    = Kernel::System::Signature->new(%Param);
    $Self->{StdResponseObject}  = Kernel::System::StdResponse->new(%Param);
    $Self->{NotificationObject} = Kernel::System::Notification->new(%Param);
    $Self->{AutoResponseObject} = Kernel::System::AutoResponse->new(%Param);

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

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Salutation{ContentType} =~ /text\/plain/i ) {
        $Salutation{ContentType} = 'text/html';
        $Salutation{Text}        = $Self->{HTML2AsciiObject}->ToHTML(
            String => $Salutation{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Salutation{ContentType} =~ /text\/html/i ) {
        $Salutation{ContentType} = 'text/plain';
        $Salutation{Text}        = $Self->{HTML2AsciiObject}->ToAscii(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need TicketID or QueueID!" );
        return;
    }

    my %Queue;
    if ( $Param{TicketID} ) {

        # get  queue
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

        # get salutation
        %Queue = $Self->{QueueObject}->QueueGet(
            ID => $Ticket{QueueID},
        );
    }
    else {

        # get salutation
        %Queue = $Self->{QueueObject}->QueueGet(
            ID => $Param{QueueID},
        );
    }
    my %Signature = $Self->{SignatureObject}->SignatureGet(
        ID => $Queue{SignatureID},
    );

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Signature{ContentType} =~ /text\/plain/i ) {
        $Signature{ContentType} = 'text/html';
        $Signature{Text}        = $Self->{HTML2AsciiObject}->ToHTML(
            String => $Signature{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Signature{ContentType} =~ /text\/html/i ) {
        $Signature{ContentType} = 'text/plain';
        $Signature{Text}        = $Self->{HTML2AsciiObject}->ToAscii(
            String => $Signature{Text},
        );
    }

    # replace place holder stuff
    my $SignatureText = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $Signature{Text},
        TicketID => $Param{TicketID} || '',
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

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

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $Response{ContentType} =~ /text\/plain/i ) {
        $Response{ContentType} = 'text/html';
        $Response{Response}    = $Self->{HTML2AsciiObject}->ToHTML(
            String => $Response{Response},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Response{ContentType} =~ /text\/html/i ) {
        $Response{ContentType} = 'text/plain';
        $Response{Response}    = $Self->{HTML2AsciiObject}->ToAscii(
            String => $Response{Response},
        );
    }

    # replace place holder stuff
    my $ResponseText = $Self->_Replace(
        RichText => $Self->{RichText},
        Text     => $Response{Response} || '-',
        TicketID => $Param{TicketID},
        Data     => $Param{Data},
        UserID   => $Param{UserID},
    );

    my $Salutation = $Self->Salutation(%Param);

    my $Signature = $Self->Signature(%Param);

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
        Subject => $Param{Data}->{Subject} || '',
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
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get auto default responses
    my %AutoResponse = $Self->{AutoResponseObject}->AutoResponseGetByTypeQueueID(
        QueueID => $Ticket{QueueID},
        Type    => $Param{AutoResponseType},
    );

    return if !%AutoResponse;

    # get old article for quoteing
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
        TicketID => $Param{TicketID},
    );

    # format body
    $Article{Body} =~ s/(^>.+|.{4,72})(?:\s|\z)/$1\n/gm;

    for (qw(From To Cc Subject Body)) {
        if ( !$Param{OrigHeader}->{$_} ) {
            $Param{OrigHeader}->{$_} = $Article{$_} || '';
        }
        chomp $Param{OrigHeader}->{$_};
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
        $AutoResponse{Text}        = $Self->{HTML2AsciiObject}->ToHTML(
            String => $AutoResponse{Text},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $AutoResponse{ContentType} =~ /text\/html/i ) {
        $AutoResponse{ContentType} = 'text/plain';
        $AutoResponse{Text}        = $Self->{HTML2AsciiObject}->ToAscii(
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
    if ( $AutoResponse{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/ ) {
        my $SubjectChar = $1;
        $Param{OrigHeader}->{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $AutoResponse{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Param{OrigHeader}->{Subject}/g;
    }
    $AutoResponse{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $AutoResponse{Subject} || '',
        Type         => 'New',
    );

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
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    # get old article for quoteing
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle( TicketID => $Param{TicketID} );

    # format body
    $Article{Body} =~ s/(^>.+|.{4,72})(?:\s|\z)/$1\n/gm;

    for (qw(From To Cc Subject Body)) {
        if ( !$Param{CustomerMessageParams}->{$_} ) {
            $Param{CustomerMessageParams}->{$_} = $Article{$_} || '';
        }
        chomp $Param{CustomerMessageParams}->{$_};
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
        Cached => 1,
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
        $Notification{Body}        = $Self->{HTML2AsciiObject}->ToHTML(
            String => $Notification{Body},
        );
    }

    # do text/html to text/plain convert
    if ( !$Self->{RichText} && $Notification{ContentType} =~ /text\/html/i ) {
        $Notification{ContentType} = 'text/plain';
        $Notification{Body}        = $Self->{HTML2AsciiObject}->ToAscii(
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
        RichText    => $Self->{RichText},
        Text        => $Notification{Body},
        RecipientID => $Param{RecipientID},
        Data        => $Param{CustomerMessageParams},
        TicketID    => $Param{TicketID},
        UserID      => $Param{UserID},
    );
    $Notification{Subject} = $Self->_Replace(
        RichText    => 0,
        Text        => $Notification{Subject},
        RecipientID => $Param{RecipientID},
        Data        => $Param{CustomerMessageParams},
        TicketID    => $Param{TicketID},
        UserID      => $Param{UserID},
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

    $Notification{ContentType} = 'text/plain';

    # replace place holder stuff
    for (qw(Subject Body)) {
        $Notification{$_} = $Self->_Replace(
            RichText => 0,
            Text     => $Notification{$_},
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );
    }

    # get sender attributes
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );
    $Notification{SenderAddress}  = $Address{Email};
    $Notification{SenderRealname} = $Address{RealName};

    return %Notification;
}

sub _Replace {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Text RichText Data UserID)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Start   = '<';
    my $End     = '>';
    my $NewLine = "\n";
    if ( $Param{RichText} ) {
        $Start   = '&lt;';
        $End     = '&gt;';
        $NewLine = "<br\/>\n";
        $Param{Text} =~ s/(\n|\r)//g;
    }

    my %Ticket;
    if ( $Param{TicketID} ) {
        %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );
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
            UserID => $Param{RecipientID},
            Cached => 1,
        );
        for ( keys %Recipient ) {
            if ( $Recipient{$_} ) {
                $Param{Text} =~ s/$Tag$_$End/$Recipient{$_}/gi;
            }
        }
    }

    # get owner data and replace it with <OTRS_OWNER_...
    $Tag = $Start . 'OTRS_OWNER_';
    if ( $Ticket{OwnerID} ) {
        my %Owner = $Self->{UserObject}->GetUserData(
            UserID => $Ticket{OwnerID},
        );
        for ( keys %Owner ) {
            if ( $Owner{$_} ) {
                $Param{Text} =~ s/$Tag$_$End/$Owner{$_}/gi;
            }
        }
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    # get owner data and replace it with <OTRS_RESPONSIBLE_...
    $Tag = $Start . 'OTRS_RESPONSIBLE_';
    if ( $Ticket{ResponsibleID} ) {
        my %Responsible = $Self->{UserObject}->GetUserData(
            UserID => $Ticket{ResponsibleID},
        );
        for ( keys %Responsible ) {
            if ( $Responsible{$_} ) {
                $Param{Text} =~ s/$Tag$_$End/$Responsible{$_}/gi;
            }
        }
    }

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2 = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );
    for ( keys %CurrentUser ) {
        if ( $CurrentUser{$_} ) {
            $Param{Text} =~ s/$Tag$_$End/$CurrentUser{$_}/gi;
            $Param{Text} =~ s/$Tag2$_$End/$CurrentUser{$_}/gi;
        }
    }

    # replace other needed stuff
    $Param{Text} =~ s/$Start OTRS_FIRST_NAME $End/$CurrentUser{UserFirstname}/gxms;
    $Param{Text} =~ s/$Start OTRS_LAST_NAME $End/$CurrentUser{UserLastname}/gxms;

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;
    $Param{Text} =~ s/$Tag2.+?$End/-/gi;

    # ticket data
    $Tag = $Start . 'OTRS_TICKET_';
    for ( keys %Ticket ) {
        if ( defined $Ticket{$_} ) {
            $Param{Text} =~ s/$Tag$_$End/$Ticket{$_}/gi;
        }
    }

    # COMPAT
    $Param{Text} =~ s/$Start OTRS_TICKET_ID $End/$Ticket{TicketID}/gixms;
    $Param{Text} =~ s/$Start OTRS_TICKET_NUMBER $End/$Ticket{TicketNumber}/gixms;
    $Param{Text} =~ s/$Start OTRS_QUEUE $End/$Ticket{Queue}/gixms;

    # cleanup
    $Param{Text} =~ s/$Tag.+?$End/-/gi;

    # get customer params and replace it with <OTRS_CUSTOMER_...
    $Tag = $Start . 'OTRS_CUSTOMER_';
    if ( $Param{Data} ) {
        for ( keys %{ $Param{Data} } ) {
            if ( defined $Param{Data}->{$_} ) {
                $Param{Text} =~ s/$Tag$_$End/$Param{Data}->{$_}/gi;
            }
        }

        # check if original content isn't text/plain, don't use it
        if (
            $Param{Data}->{'Content-Type'}
            && $Param{Data}->{'Content-Type'} !~ /(text\/plain|\btext\b)/i
            )
        {
            $Param{Data}->{Body} = '-> no quotable message <-';
        }

        # replace <OTRS_CUSTOMER_EMAIL[]> tags
        my $Tag = $Start . 'OTRS_CUSTOMER_EMAIL';
        if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {
            my $Line       = $1;
            my @Body       = split( /\n/, $Param{Data}->{Body} );
            my $NewOldBody = '';
            for ( my $i = 0; $i < $Line; $i++ ) {

                # 2002-06-14 patch of Pablo Ruiz Garcia
                # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
                if ( $#Body >= $i ) {
                    $NewOldBody .= "$End $Body[$i]";
                    if ( $i < ( $Line - 1 ) ) {
                        $NewOldBody .= $NewLine;
                    }
                }
            }
            chomp $NewOldBody;
            $Param{Text} =~ s/$Tag\[.+?\]$End/$NewOldBody/g;
        }

        # replace <OTRS_CUSTOMER_SUBJECT[]> tags
        $Tag = $Start . 'OTRS_CUSTOMER_SUBJECT';
        if ( $Param{Text} =~ /$Tag\[(.+?)\]$End/g ) {
            my $SubjectChar = $1;
            my $Subject     = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Ticket{TicketNumber},
                Subject      => $Param{Data}->{Subject},
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
            my $EmailDate = strftime( '%A, %B %e, %Y at %T ', localtime );
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
        if ( !$From ) {
            $From = $Param{Data}->{To} || '';
            $From =~ s/<.*>|\(.*\)|\"|;|,//g;
            $From =~ s/( $)|(  $)//g;
        }
        $Param{Text} =~ s/$Tag$End/$From/g;
    }

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';
    if ( $Ticket{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );

        # replace customer stuff with tags
        for my $Key ( keys %CustomerUser ) {
            if ( defined $CustomerUser{$Key} ) {
                $Param{Text} =~ s/$Tag$Key$End/$CustomerUser{$Key}/gi;
                $Param{Text} =~ s/$Tag2$Key$End/$CustomerUser{$Key}/gi;
            }
        }
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Param{Text} =~ s/$Tag.+?$End/-/gi;
    $Param{Text} =~ s/$Tag2.+?$End/-/gi;

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

$Revision: 1.18 $ $Date: 2009-07-14 13:36:23 $

=cut
