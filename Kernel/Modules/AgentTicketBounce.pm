# --
# Kernel/Modules/AgentTicketBounce.pm - to bounce articles of tickets
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketBounce;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Mail::Address;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get article ID
    $Self->{ArticleID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ArticleID' ) || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    for my $Needed (qw(ArticleID TicketID QueueID)) {
        if ( !defined $Self->{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => "$Needed is needed!",
                Comment => 'Please contact your administrator',
            );
        }
    }

    # get ticket data
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => $Config->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    # get lock state && write (lock) permissions
    if ( $Config->{RequiredLock} ) {
        if ( !$TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            if (
                $TicketObject->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $Self->{UserID},
                )
                )
            {

                $LayoutObject->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
            }
        }
        else {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $LayoutObject->Header(
                    Value     => $Ticket{Number},
                    Type      => 'Small',
                    BodyClass => 'Popup',
                );
                $Output .= $LayoutObject->Warning(
                    Message => $LayoutObject->{LanguageObject}
                        ->Get('Sorry, you need to be the ticket owner to perform this action.'),
                    Comment => $LayoutObject->{LanguageObject}->Get('Please change the owner first.'),
                );
                $Output .= $LayoutObject->Footer(
                    Type => 'Small',
                );
                return $Output;
            }
            else {
                $LayoutObject->Block(
                    Name => 'TicketBack',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                TicketID => $Self->{TicketID},
            },
        );
    }

    # ------------------------------------------------------------ #
    # show screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # check if plain article exists
        if ( !$TicketObject->ArticlePlain( ArticleID => $Self->{ArticleID} ) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Plain article not found for article $Self->{ArticleID}!",
            );
        }

        # get article data
        my %Article = $TicketObject->ArticleGet(
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );

        # Check if article is from the same TicketID as we checked permissions for.
        if ( $Article{TicketID} ne $Self->{TicketID} ) {
            return $LayoutObject->ErrorScreen(
                Message => "Article does not belong to ticket $Self->{TicketID}!",
            );
        }

        # prepare to (ReplyTo!) ...
        if ( $Article{ReplyTo} ) {
            $Article{To} = $Article{ReplyTo};
        }
        else {
            $Article{To} = $Article{From};
        }

        # get template generator object
        my $TemplateGenerator = $Kernel::OM->ObjectParamAdd(
            'Kernel::System::TemplateGenerator' => { %{$Self} }
        );
        $TemplateGenerator = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

        # prepare salutation
        $Param{Salutation} = $TemplateGenerator->Salutation(
            TicketID  => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            Data      => \%Param,
            UserID    => $Self->{UserID},
        );

        # prepare signature
        $Param{Signature} = $TemplateGenerator->Signature(
            TicketID  => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            Data      => \%Param,
            UserID    => $Self->{UserID},
        );

        # prepare bounce text
        $Param{BounceText} = $ConfigObject->Get('Ticket::Frontend::BounceText') || '';

        # make sure body is rich text
        if ( $LayoutObject->{BrowserRichText} ) {

            # prepare bounce tags
            $Param{BounceText} =~ s/<OTRS_TICKET>/&lt;OTRS_TICKET&gt;/g;
            $Param{BounceText} =~ s/<OTRS_BOUNCE_TO>/&lt;OTRS_BOUNCE_TO&gt;/g;

            $Param{BounceText} = $LayoutObject->Ascii2RichText(
                String => $Param{BounceText},
            );
        }

        # build InformationFormat
        if ( $LayoutObject->{BrowserRichText} ) {
            $Param{InformationFormat} = "$Param{Salutation}<br/>
<br/>
$Param{BounceText}<br/>
<br/>
$Param{Signature}";
        }
        else {
            $Param{InformationFormat} = "$Param{Salutation}

$Param{BounceText}

$Param{Signature}";
        }

        # prepare sender of bounce email
        my %Address = $Kernel::OM->Get('Kernel::System::Queue')->GetSystemAddress(
            QueueID => $Article{QueueID},
        );
        $Article{From} = "$Address{RealName} <$Address{Email}>";

        # get next states
        my %NextStates = $TicketObject->TicketStateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );

        # build next states string
        if ( !$Config->{StateDefault} ) {
            $NextStates{''} = '-';
        }
        $Param{NextStatesStrg} = $LayoutObject->BuildSelection(
            Data          => \%NextStates,
            Name          => 'BounceStateID',
            SelectedValue => $Config->{StateDefault},
        );

        # add rich text editor
        if ( $LayoutObject->{BrowserRichText} ) {

            # use height/width defined for this screen
            $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
            $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

            $LayoutObject->Block(
                Name => 'RichText',
                Data => \%Param,
            );
        }

        # print form ...
        my $Output = $LayoutObject->Header(
            Value     => $Ticket{TicketNumber},
            Type      => 'Small',
            BodyClass => 'Popup',
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTicketBounce',
            Data         => {
                %Param,
                %Article,
                TicketID     => $Self->{TicketID},
                ArticleID    => $Self->{ArticleID},
                TicketNumber => $Ticket{TicketNumber},
            },
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # ------------------------------------------------------------ #
    # bounce
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get params
        for my $Parameter (qw(From BounceTo To Subject Body InformSender BounceStateID)) {
            $Param{$Parameter}
                = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Parameter ) || '';
        }

        my %Error;

        # check forward email address
        if ( !$Param{BounceTo} ) {
            $Error{'BounceToInvalid'} = 'ServerError';
            $LayoutObject->Block( Name => 'BounceToCustomerGenericServerErrorMsg' );
        }

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        for my $Email ( Mail::Address->parse( $Param{BounceTo} ) ) {
            my $Address = $Email->address();
            if ( $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress( Address => $Address ) )
            {
                $LayoutObject->Block( Name => 'BounceToCustomerGenericServerErrorMsg' );
                $Error{'BounceToInvalid'} = 'ServerError';
            }

            # check email address
            elsif ( !$CheckItemObject->CheckEmail( Address => $Address ) ) {
                my $BounceToErrorMsg =
                    'BounceTo'
                    . $CheckItemObject->CheckErrorType()
                    . 'ServerErrorMsg';
                $LayoutObject->Block( Name => $BounceToErrorMsg );
                $Error{'BounceToInvalid'} = 'ServerError';
            }
        }

        if ( $Param{InformSender} ) {
            if ( !$Param{To} ) {
                $Error{'ToInvalid'} = 'ServerError';
                $LayoutObject->Block( Name => 'ToCustomerGenericServerErrorMsg' );
            }
            else {

                # check email address(es)
                for my $Email ( Mail::Address->parse( $Param{To} ) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                        my $ToErrorMsg =
                            'To'
                            . $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $LayoutObject->Block( Name => $ToErrorMsg );
                        $Error{'ToInvalid'} = 'ServerError';
                    }
                }
            }

            if ( !$Param{Subject} ) {
                $Error{'SubjectInvalid'} = 'ServerError';
            }
            if ( !$Param{Body} ) {
                $Error{'BodyInvalid'} = 'ServerError';
            }
        }

        #check for error
        if (%Error) {

            # get next states
            my %NextStates = $TicketObject->TicketStateList(
                Action   => $Self->{Action},
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID},
            );

            # build next states string
            if ( !$Config->{StateDefault} ) {
                $NextStates{''} = '-';
            }
            $Param{NextStatesStrg} = $LayoutObject->BuildSelection(
                Data       => \%NextStates,
                Name       => 'BounceStateID',
                SelectedID => $Param{BounceStateID},
            );

            # add rich text editor
            if ( $LayoutObject->{BrowserRichText} ) {

                # use height/width defined for this screen
                $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
                $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

                $LayoutObject->Block(
                    Name => 'RichText',
                );
            }

            # prepare bounce tags if body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {

                # prepare bounce tags
                $Param{Body} =~ s/&lt;OTRS_TICKET&gt;/&amp;lt;OTRS_TICKET&amp;gt;/gi;
                $Param{Body} =~ s/&lt;OTRS_BOUNCE_TO&gt;/&amp;lt;OTRS_BOUNCE_TO&amp;gt;/gi;
            }

            $Param{InformationFormat} = $Param{Body};
            $Param{InformSenderChecked} = $Param{InformSender} ? 'checked="checked"' : '';

            my $Output = $LayoutObject->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AgentTicketBounce',
                Data         => {
                    %Param,
                    %Error,
                    TicketID  => $Self->{TicketID},
                    ArticleID => $Self->{ArticleID},

                },
            );
            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        my $Bounce = $TicketObject->ArticleBounce(
            TicketID    => $Self->{TicketID},
            ArticleID   => $Self->{ArticleID},
            UserID      => $Self->{UserID},
            To          => $Param{BounceTo},
            From        => $Param{From},
            HistoryType => 'Bounce',
        );

        # error page
        if ( !$Bounce ) {
            return $LayoutObject->ErrorScreen(
                Message => "Can't bounce email!",
                Comment => 'Please contact the admin.',
            );
        }

        # send customer info?
        if ( $Param{InformSender} ) {

            # set mime type
            my $MimeType = 'text/plain';
            if ( $LayoutObject->{BrowserRichText} ) {
                $MimeType = 'text/html';

                # verify html document
                $Param{Body} = $LayoutObject->RichTextDocumentComplete(
                    String => $Param{Body},
                );
            }

            # replace placeholders
            $Param{Body} =~ s/(&lt;|<)OTRS_TICKET(&gt;|>)/$Ticket{TicketNumber}/g;
            $Param{Body} =~ s/(&lt;|<)OTRS_BOUNCE_TO(&gt;|>)/$Param{BounceTo}/g;

            # send
            my $ArticleID = $TicketObject->ArticleSend(
                ArticleType    => 'email-external',
                SenderType     => 'agent',
                TicketID       => $Self->{TicketID},
                HistoryType    => 'Bounce',
                HistoryComment => "Bounced info to '$Param{To}'.",
                From           => $Param{From},
                Email          => $Param{Email},
                To             => $Param{To},
                Subject        => $Param{Subject},
                UserID         => $Self->{UserID},
                Body           => $Param{Body},
                Charset        => $LayoutObject->{UserCharset},
                MimeType       => $MimeType,
            );

            # error page
            if ( !$ArticleID ) {
                return $LayoutObject->ErrorScreen(
                    Message => "Can't send email!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # check if there is a chosen bounce state id
        if ( $Param{BounceStateID} ) {

            # set state
            my %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
                ID => $Param{BounceStateID},
            );
            $TicketObject->TicketStateSet(
                TicketID  => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
                StateID   => $Param{BounceStateID},
                UserID    => $Self->{UserID},
            );

            # should i set an unlock?
            if ( $StateData{TypeName} =~ /^close/i ) {
                $TicketObject->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # redirect
            if ( $StateData{TypeName} =~ /^close/i ) {
                return $LayoutObject->PopupClose(
                    URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
                );
            }
        }
        return $LayoutObject->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$Self->{ArticleID}",
        );
    }
    return $LayoutObject->ErrorScreen(
        Message => 'Wrong Subaction!!',
        Comment => 'Please contact your administrator',
    );
}

1;
