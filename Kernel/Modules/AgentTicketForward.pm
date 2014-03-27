# --
# Kernel/Modules/AgentTicketForward.pm - to forward a message
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketForward.pm,v 1.97.2.12 2012-05-26 01:36:15 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketForward;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::State;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::Web::UploadCache;
use Kernel::System::TemplateGenerator;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.97.2.12 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # some new objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);

    # get params
    for (
        qw(From To Cc Bcc Subject Body InReplyTo References ComposeStateID ArticleTypeID
        ArticleID TimeUnits Year Month Day Hour Minute FormID)
        )
    {
        my $Value = $Self->{ParamObject}->GetParam( Param => $_ );
        if ( defined $Value ) {
            $Self->{GetParam}->{$_} = $Value;
        }
    }

    # create form id
    if ( !$Self->{GetParam}->{FormID} ) {
        $Self->{GetParam}->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    if ( $Self->{Subaction} eq 'SendEmail' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Output = $Self->SendEmail();
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        $Output = $Self->AjaxUpdate();
    }
    else {
        $Output = $Self->Form();
    }
    return $Output;
}

sub Form {
    my ( $Self, %Param ) = @_;

    my %Error;
    my %GetParam = %{ $Self->{GetParam} };

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Got no TicketID!",
            Comment => 'System Error!',
        );
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get lock state
    my $Output = '';
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {

            # set owner
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # set lock
            my $Lock = $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );

            # show lock state
            if ($Lock) {
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $Self->{LayoutObject}->Header(
                    Type => 'Small',
                );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => 'Sorry, you need to be the owner to do this action!',
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer(
                    Type => 'Small',
                );
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketBack',
                    Data => { %Param, TicketID => $Self->{TicketID}, },
                );
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => { %Param, TicketID => $Self->{TicketID}, },
        );
    }

    # get last customer article or selected article
    my %Data;
    if ( $GetParam{ArticleID} ) {
        %Data = $Self->{TicketObject}->ArticleGet( ArticleID => $GetParam{ArticleID}, );

        # Check if article is from the same TicketID as we checked permissions for.
        if ( $Data{TicketID} ne $Self->{TicketID} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Article does not belong to ticket $Self->{TicketID}!",
            );
        }
    }
    else {
        %Data = $Self->{TicketObject}->ArticleLastCustomerArticle( TicketID => $Self->{TicketID}, );
    }

    # prepare signature
    my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );
    $Data{Signature} = $TemplateGenerator->Signature(
        TicketID  => $Self->{TicketID},
        ArticleID => $Data{ArticleID},
        Data      => \%Data,
        UserID    => $Self->{UserID},
    );

    # body preparation for plain text processing
    $Data{Body} = $Self->{LayoutObject}->ArticleQuote(
        TicketID           => $Data{TicketID},
        ArticleID          => $Data{ArticleID},
        FormID             => $Self->{GetParam}->{FormID},
        UploadCacheObject  => $Self->{UploadCacheObject},
        AttachmentsInclude => 1,
    );

    if ( $Self->{LayoutObject}->{BrowserRichText} ) {

        # prepare body, subject, ReplyTo ...
        $Data{Body} = '<br/>' . $Data{Body};
        if ( $Data{Created} ) {
            $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get('Date') .
                ": $Data{Created}<br/>" . $Data{Body};
        }
        for my $Key (qw( Subject ReplyTo Reply-To Cc To From )) {
            if ( $Data{$Key} ) {
                my $KeyText = $Self->{LayoutObject}->{LanguageObject}->Get($Key);

                my $Value = $Self->{LayoutObject}->Ascii2RichText(
                    String => $Data{$Key},
                );
                $Data{Body} = "$KeyText: $Value<br/>" . $Data{Body};
            }
        }

        my $Quote = $Self->{LayoutObject}->Ascii2RichText(
            String => $Self->{ConfigObject}->Get('Ticket::Frontend::Quote') || '',
        );
        if ($Quote) {

            # quote text
            $Data{Body} = "<blockquote type=\"cite\">$Data{Body}</blockquote>\n";

            # cleanup not compat. tags
            $Data{Body} = $Self->{LayoutObject}->RichTextDocumentCleanup(
                String => $Data{Body},
            );
        }
        else {
            $Data{Body} = "<br/>" . $Data{Body};
        }
        my $From = $Self->{LayoutObject}->Ascii2RichText(
            String => $Data{From},
        );

        my $ForwardedMessageFrom
            = $Self->{LayoutObject}->{LanguageObject}->Get('Forwarded message from');
        my $EndForwardedMessage
            = $Self->{LayoutObject}->{LanguageObject}->Get('End forwarded message');

        $Data{Body} = "<br/>---- $ForwardedMessageFrom $From ---<br/><br/>" . $Data{Body};
        $Data{Body} .= "<br/>---- $EndForwardedMessage ---<br/>";
        $Data{Body} = $Data{Signature} . $Data{Body};

        $Data{ContentType} = 'text/html';
    }
    else {

        # prepare body, subject, ReplyTo ...
        $Data{Body} =~ s/\t/ /g;
        my $Quote = $Self->{ConfigObject}->Get('Ticket::Frontend::Quote');
        if ($Quote) {
            $Data{Body} =~ s/\n/\n$Quote /g;
            $Data{Body} = "\n$Quote " . $Data{Body};
        }
        else {
            $Data{Body} = "\n" . $Data{Body};
        }
        if ( $Data{Created} ) {
            $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get('Date') .
                ": $Data{Created}\n" . $Data{Body};
        }
        for (qw(Subject ReplyTo Reply-To Cc To From)) {
            if ( $Data{$_} ) {
                $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get($_) .
                    ": $Data{$_}\n" . $Data{Body};
            }
        }

        my $ForwardedMessageFrom
            = $Self->{LayoutObject}->{LanguageObject}->Get('Forwarded message from');
        my $EndForwardedMessage
            = $Self->{LayoutObject}->{LanguageObject}->Get('End forwarded message');

        $Data{Body} = "\n---- $ForwardedMessageFrom $Data{From} ---\n\n" . $Data{Body};
        $Data{Body} .= "\n---- $EndForwardedMessage ---\n";
        $Data{Body} = $Data{Signature} . $Data{Body};
    }

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $GetParam{FormID},
    );

    # check some values
    for (qw(To Cc Bcc)) {
        if ( $Data{$_} ) {
            delete $Data{$_};
        }
    }

    # put & get attributes like sender address
    %Data = $TemplateGenerator->Attributes(
        TicketID   => $Self->{TicketID},
        ArticleID  => $GetParam{ArticleID},
        ResponseID => $GetParam{ResponseID},
        Data       => \%Data,
        UserID     => $Self->{UserID},
        Action     => 'Forward',
    );

    # run compose modules
    if ( ref( $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') ) eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

            # get params
            for ( $Object->Option( %Data, %GetParam, Config => $Jobs{$Job} ) ) {
                $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            }

            # run module
            $Object->Run( %Data, %GetParam, Config => $Jobs{$Job} );

            # get errors
            %Error = ( %Error, $Object->Error( %GetParam, Config => $Jobs{$Job} ) );
        }
    }

    # get free text config options
    my %TicketFreeText;
    for my $Count ( 1 .. 16 ) {
        $TicketFreeText{"TicketFreeKey$Count"} = $Self->{TicketObject}->TicketFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => "TicketFreeKey$Count",
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
        $TicketFreeText{"TicketFreeText$Count"} = $Self->{TicketObject}->TicketFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => "TicketFreeText$Count",
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );

        # If Key has value 2, this means that the freetextfield is required
        if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
            $TicketFreeText{Required}->{$Count} = 1;
        }
    }
    my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
        Ticket => \%Ticket,
        Config => \%TicketFreeText,
    );

    # get ticket free time params
    for my $Count ( 1 .. 6 ) {
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Used' } = 1;
        }
    }

    # free time
    my %TicketFreeTime;
    for my $Count ( 1 .. 6 ) {
        $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
        $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Used' }
            = $GetParam{ 'TicketFreeTime' . $Count . 'Used' };

        if ( $Ticket{ 'TicketFreeTime' . $Count } ) {
            (
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Secunde' },
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Minute' },
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Hour' },
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Day' },
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Month' },
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Year' }
                )
                = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $Ticket{ 'TicketFreeTime' . $Count },
                ),
                );
            $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Used' } = 1;
        }

        if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
            $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Required' } = 1;
        }
    }
    my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%TicketFreeTime, );

    # get article free text default selections
    my %ArticleFreeDefault;
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $ArticleFreeDefault{$Key} = $GetParam{$Key}
            || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
        $ArticleFreeDefault{$Text} = $GetParam{$Text}
            || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
    }

    # article free text
    my %ArticleFreeText;
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => $Key,
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
        $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => $Text,
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );

        # If Key has value 2, this means that the ArticleFreeText is required
        if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
            $ArticleFreeText{Required}->{$Count} = 1;
        }
    }
    my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
        Config => \%ArticleFreeText,
        Article => { %GetParam, %ArticleFreeDefault, },
    );

    # build view ...
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header(
        Value => $Ticket{TicketNumber},
        Type  => 'Small',
    );
    $Output .= $Self->_Mask(
        TicketNumber      => $Ticket{TicketNumber},
        TicketID          => $Self->{TicketID},
        QueueID           => $Ticket{QueueID},
        NextStates        => $Self->_GetNextStates(),
        TimeUnitsRequired => (
            $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            ? 'Validate_Required'
            : ''
        ),
        Errors      => \%Error,
        Attachments => \@Attachments,
        %Data,
        %GetParam,
        InReplyTo  => $Data{MessageID},
        References => "$Data{References} $Data{MessageID}",
        %TicketFreeTextHTML,
        %TicketFreeTimeHTML,
        %ArticleFreeTextHTML,
    );
    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );

    return $Output;
}

sub SendEmail {
    my ( $Self, %Param ) = @_;

    my %Error;
    my %GetParam = %{ $Self->{GetParam} };

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    my $QueueID   = $Self->{QueueID};
    my %StateData = ();

    if ( $GetParam{ComposeStateID} ) {
        %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $GetParam{ComposeStateID},
        );
    }

    my $NextState = $StateData{Name};

    # check pending date
    if ( $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
        if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
            $Error{'DateInvalid'} = 'ServerError';
        }
        if (
            $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
            < $Self->{TimeObject}->SystemTime()
            )
        {
            $Error{'DateInvalid'} = 'ServerError';
        }
    }

    # check To
    if ( !$GetParam{To} ) {
        $Error{'ToInvalid'} = 'ServerError';
    }

    # check body
    if ( !$GetParam{Body} ) {
        $Error{'BodyInvalid'} = 'ServerError';
    }

    # check subject
    if ( !$GetParam{Subject} ) {
        $Error{'SubjectInvalid'} = 'ServerError';
    }

    if (
        $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
        && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
        && $GetParam{TimeUnits} eq ''
        )
    {
        $Error{'TimeUnitsInvalid'} = 'ServerError';
    }

    # prepare subject
    my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup( TicketID => $Self->{TicketID} );
    $GetParam{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
        TicketNumber => $TicketNumber,
        Action       => 'Forward',
        Subject      => $GetParam{Subject} || '',
    );

    # prepare free text
    my %TicketFree;
    for my $Count ( 1 .. 16 ) {
        $TicketFree{"TicketFreeKey$Count"}
            = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$Count" );
        $TicketFree{"TicketFreeText$Count"}
            = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$Count" );
    }

    # get free text config options
    my %TicketFreeText;
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $TicketFreeText{"TicketFreeKey$Count"} = $Self->{TicketObject}->TicketFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => $Key,
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
        $TicketFreeText{"TicketFreeText$Count"} = $Self->{TicketObject}->TicketFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => $Text,
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );

        # If Key has value 2, this means that the freetextfield is required
        if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
            $TicketFreeText{Required}->{$Count} = 1;
        }

        # check required FreeTextField (if configured)
        if (
            $Self->{Config}->{TicketFreeText}->{$Count} == 2
            && $GetParam{$Text} eq ''
            )
        {
            $TicketFreeText{Error}->{$Count} = 1;
            $Error{$Text} = 'ServerError';
        }

    }
    my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
        Config => \%TicketFreeText,
        Ticket => \%TicketFree,
    );

    # get ticket free time params
    for my $Count ( 1 .. 6 ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ 'TicketFreeTime' . $Count . $Type }
                = $Self->{ParamObject}->GetParam( Param => 'TicketFreeTime' . $Count . $Type );
        }
        $GetParam{ 'TicketFreeTime' . $Count . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Used' } = 1;
        }

        if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Required' } = 1;
        }

    }

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
        );
    }

    # transform free time, time stamp based on user time zone
    for my $Count ( 1 .. 6 ) {
        my $Prefix = 'TicketFreeTime' . $Count;
        next if !defined $GetParam{ $Prefix . 'Year' };
        next if !defined $GetParam{ $Prefix . 'Month' };
        next if !defined $GetParam{ $Prefix . 'Day' };
        next if !defined $GetParam{ $Prefix . 'Hour' };
        next if !defined $GetParam{ $Prefix . 'Minute' };
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
            Prefix => $Prefix
        );
    }

    my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam, );

    # get article free text params
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # article free text
    my %ArticleFreeText;
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => $Key,
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
        $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
            TicketID => $Self->{TicketID},
            Type     => $Text,
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );

        # If Key has value 2, this means that the field is required
        if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
            $ArticleFreeText{Required}->{$Count} = 1;
        }

        # check required ArticleTextField (if configured)
        if (
            $Self->{Config}->{ArticleFreeText}->{$Count} == 2
            && $GetParam{$Text} eq ''
            )
        {
            $ArticleFreeText{Error}->{$Count} = 1;
            $Error{$Text} = 'ServerError';
        }
    }

    my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
        Config  => \%ArticleFreeText,
        Article => \%GetParam,
    );

    # check some values
    for my $Line (qw(To Cc Bcc)) {
        next if !$GetParam{$Line};
        for my $Email ( Mail::Address->parse( $GetParam{$Line} ) ) {
            if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                $Error{ "$Line" . "Invalid" } = 'ServerError';
            }
            my $IsLocal = $Self->{SystemAddress}->SystemAddressIsLocalAddress(
                Address => $Email->address()
            );
            if ($IsLocal) {
                $Error{ "$Line" . "Invalid" } = 'ServerError';
            }
        }
    }

    # run compose modules
    my %ArticleParam;
    if ( ref( $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') ) eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

            # get params
            for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            }

            # run module
            $Object->Run( %GetParam, Config => $Jobs{$Job} );

            # ticket params
            %ArticleParam = (
                %ArticleParam,
                $Object->ArticleOption( %GetParam, Config => $Jobs{$Job} ),
            );

            # get errors
            %Error = (
                %Error,
                $Object->Error( %GetParam, Config => $Jobs{$Job} ),
            );
        }
    }

    # attachment delete
    for my $Count ( 1 .. 32 ) {
        my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
        next if !$Delete;
        %Error = ();
        $Error{AttachmentDelete} = 1;
        $Self->{UploadCacheObject}->FormIDRemoveFile(
            FormID => $GetParam{FormID},
            FileID => $Count,
        );
    }

    # attachment upload
    if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
        %Error = ();
        $Error{AttachmentUpload} = 1;
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );
        $Self->{UploadCacheObject}->FormIDAddFile(
            FormID => $GetParam{FormID},
            %UploadStuff,
        );
    }

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $GetParam{FormID},
    );

    # check if there is an error
    if (%Error) {

        my $QueueID = $Self->{TicketObject}->TicketQueueID( TicketID => $Self->{TicketID} );
        my $Output = $Self->{LayoutObject}->Header(
            Value => $TicketNumber,
            Type  => 'Small',
        );
        $Output .= $Self->_Mask(
            TicketNumber => $TicketNumber,
            TicketID     => $Self->{TicketID},
            QueueID      => $QueueID,
            NextStates   => $Self->_GetNextStates(),
            Errors       => \%Error,
            Attachments  => \@Attachments,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # replace <OTRS_TICKET_STATE> with next ticket state name
    if ($NextState) {
        $GetParam{Body} =~ s/(&lt;|<)OTRS_TICKET_STATE(&gt;|>)/$NextState/g;
    }

    # get pre loaded attachments
    my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
        FormID => $GetParam{FormID},
    );

    # get submit attachment
    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
        Param  => 'FileUpload',
        Source => 'String',
    );
    if (%UploadStuff) {
        push @AttachmentData, \%UploadStuff;
    }

    my $MimeType = 'text/plain';
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $MimeType = 'text/html';

        # remove unused inline images
        my @NewAttachmentData;
        for my $Attachment (@AttachmentData) {
            my $ContentID = $Attachment->{ContentID};
            if ( $ContentID && ( $Attachment->{ContentType} =~ /image/i ) ) {
                my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                    Text => $ContentID,
                );

                # workaround for link encode of rich text editor, see bug#5053
                my $ContentIDLinkEncode = $Self->{LayoutObject}->LinkEncode($ContentID);
                $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                # ignore attachment if not linked in body
                next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
            }

            # remember inline images and normal attachments
            push @NewAttachmentData, \%{$Attachment};
        }
        @AttachmentData = @NewAttachmentData;

        # verify html document
        $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
            String => $GetParam{Body},
        );
    }

    # send email
    my $To = '';
    for my $Key (qw(To Cc Bcc)) {
        next if !$GetParam{$Key};
        if ($To) {
            $To .= ', ';
        }
        $To .= $GetParam{$Key}
    }
    my $ArticleID = $Self->{TicketObject}->ArticleSend(
        ArticleTypeID  => $Self->{GetParam}->{ArticleTypeID},
        SenderType     => 'agent',
        TicketID       => $Self->{TicketID},
        HistoryType    => 'Forward',
        HistoryComment => "\%\%$To",
        From           => $GetParam{From},
        To             => $GetParam{To},
        Cc             => $GetParam{Cc},
        Bcc            => $GetParam{Bcc},
        Subject        => $GetParam{Subject},
        UserID         => $Self->{UserID},
        Body           => $GetParam{Body},
        InReplyTo      => $GetParam{InReplyTo},
        References     => $GetParam{References},
        Charset        => $Self->{LayoutObject}->{UserCharset},
        MimeType       => $MimeType,
        Attachment     => \@AttachmentData,
        %ArticleParam,
    );

    # error page
    if ( !$ArticleID ) {
        return $Self->{LayoutObject}->ErrorScreen( Comment => 'Please contact the admin.', );
    }

    # time accounting
    if ( $GetParam{TimeUnits} ) {
        $Self->{TicketObject}->TicketAccountTime(
            TicketID  => $Self->{TicketID},
            ArticleID => $ArticleID,
            TimeUnit  => $GetParam{TimeUnits},
            UserID    => $Self->{UserID},
        );
    }

    # update ticket free text
    for ( 1 .. 16 ) {
        my $FreeKey   = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$_" );
        my $FreeValue = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$_" );
        if ( defined $FreeKey && defined $FreeValue ) {
            $Self->{TicketObject}->TicketFreeTextSet(
                Key      => $FreeKey,
                Value    => $FreeValue,
                Counter  => $_,
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID},
            );
        }
    }

    # set ticket free time
    for my $Count ( 1 .. 6 ) {
        my $Prefix = 'TicketFreeTime' . $Count;
        next if !defined $GetParam{ $Prefix . 'Year' };
        next if !defined $GetParam{ $Prefix . 'Month' };
        next if !defined $GetParam{ $Prefix . 'Day' };
        next if !defined $GetParam{ $Prefix . 'Hour' };
        next if !defined $GetParam{ $Prefix . 'Minute' };

        # set time stamp to NULL if field is not used/checked
        if ( !$GetParam{ $Prefix . 'Used' } ) {
            $GetParam{ $Prefix . 'Year' }   = 0;
            $GetParam{ $Prefix . 'Month' }  = 0;
            $GetParam{ $Prefix . 'Day' }    = 0;
            $GetParam{ $Prefix . 'Hour' }   = 0;
            $GetParam{ $Prefix . 'Minute' } = 0;
        }

        # set free time
        $Self->{TicketObject}->TicketFreeTimeSet(
            %GetParam,
            Prefix   => 'TicketFreeTime',
            TicketID => $Self->{TicketID},
            Counter  => $Count,
            UserID   => $Self->{UserID},
        );
    }

    # set article free text
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        if ( defined $GetParam{$Key} ) {
            $Self->{TicketObject}->ArticleFreeTextSet(
                TicketID  => $Self->{TicketID},
                ArticleID => $ArticleID,
                Key       => $GetParam{$Key},
                Value     => $GetParam{$Text},
                Counter   => $Count,
                UserID    => $Self->{UserID},
            );
        }
    }

    # set state
    if ($NextState) {
        $Self->{TicketObject}->TicketStateSet(
            TicketID  => $Self->{TicketID},
            ArticleID => $ArticleID,
            State     => $NextState,
            UserID    => $Self->{UserID},
        );
    }

    # should I set an unlock?
    if ( $StateData{TypeName} =~ /^close/i ) {
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'unlock',
            UserID   => $Self->{UserID},
        );
    }

    # set pending time
    elsif ( $StateData{TypeName} =~ /^pending/i ) {

        # set pending time
        $Self->{TicketObject}->TicketPendingTimeSet(
            UserID   => $Self->{UserID},
            TicketID => $Self->{TicketID},
            %GetParam,
        );
    }

    # remove pre submited attachments
    $Self->{UploadCacheObject}->FormIDRemove( FormID => $GetParam{FormID} );

    # redirect
    if ( $StateData{TypeName} =~ /^close/i ) {
        return $Self->{LayoutObject}->PopupClose(
            URL => ( $Self->{LastScreenView} || 'Action=AgentDashboard' ),
        );
    }

    return $Self->{LayoutObject}->PopupClose(
        URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID",
    );
}

sub AjaxUpdate {
    my ( $Self, %Param ) = @_;

    my %GetParam = %{ $Self->{GetParam} };

    my @ExtendedData;

    # run compose modules
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );

            my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

            # get params
            for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
            }

            # run module
            my %Data = $Object->Data( %GetParam, Config => $Jobs{$Job} );

            my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );
            if ($Key) {
                push(
                    @ExtendedData,
                    {
                        Name        => $Key,
                        Data        => \%Data,
                        SelectedID  => $GetParam{$Key},
                        Translation => 1,
                        Max         => 100,
                    }
                );
            }
        }
    }
    my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
        [
            @ExtendedData,
        ],
    );
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    # get next states
    my %NextStates = $Self->{TicketObject}->TicketStateList(
        Action   => $Self->{Action},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    return \%NextStates;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # add none selection to the list
    $Param{NextStates}->{''} = '-';

    # build next states string
    my %State;
    if ( !$Param{ComposeStateID} ) {
        $State{SelectedValue} = $Self->{Config}->{StateDefault};
    }
    else {
        $State{SelectedID} = $Param{ComposeStateID};
    }

    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => $Param{NextStates},
        Name => 'ComposeStateID',
        %State,
    );
    my %ArticleTypes;
    my @ArticleTypesPossible = @{ $Self->{Config}->{ArticleTypes} };
    for (@ArticleTypesPossible) {
        $ArticleTypes{ $Self->{TicketObject}->ArticleTypeLookup( ArticleType => $_ ) } = $_;
    }
    if ( $Self->{GetParam}->{ArticleTypeID} ) {
        $Param{ArticleTypesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ArticleTypes,
            Name       => 'ArticleTypeID',
            SelectedID => $Self->{GetParam}->{ArticleTypeID},
        );
    }
    else {
        $Param{ArticleTypesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data          => \%ArticleTypes,
            Name          => 'ArticleTypeID',
            SelectedValue => $Self->{Config}->{ArticleTypeDefault},
        );
    }

    # build customer search autocomplete field
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
        Data => {
            ActiveAutoComplete  => $AutoCompleteConfig->{Active},
            minQueryLength      => $AutoCompleteConfig->{MinQueryLength} || 2,
            queryDelay          => $AutoCompleteConfig->{QueryDelay} || 100,
            typeAhead           => $AutoCompleteConfig->{TypeAhead} || 'false',
            maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
        },
    );

    # prepare errors!
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        Format           => 'DateInputFormatLong',
        DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class            => $Param{Errors}->{DateInvalid} || ' ',
        Validate         => 1,
        ValidateDateInFuture => 1,
    );

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Self->{Config}->{'TicketFreeText'}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText',
            Data => {
                TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                %Param,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeText' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{'TicketFreeTime'}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime',
            Data => {
                TicketFreeTimeKey => $Param{ 'TicketFreeTimeKey' . $Count },
                TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                Count             => $Count,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }

    # article free text
    for my $Count ( 1 .. 3 ) {
        next if !$Self->{Config}->{ArticleFreeText}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText',
            Data => {
                ArticleFreeKeyField  => $Param{ 'ArticleFreeKeyField' . $Count },
                ArticleFreeTextField => $Param{ 'ArticleFreeTextField' . $Count },
                Count                => $Count,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    my $ShownOptionsBlock;

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {},
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show address book
    if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {},
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'AddressBook',
            Data => {},
        );
    }

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        if (
            $Attachment->{ContentID}
            && $Self->{LayoutObject}->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            )
        {
            next;
        }

        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # create & return output
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketForward', Data => \%Param );
}

1;
