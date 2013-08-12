# --
# Kernel/Modules/AgentTicketBounce.pm - to bounce articles of tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketBounce;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::TemplateGenerator;
use Kernel::System::VariableCheck qw(:all);
use Mail::Address;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    # needed objects
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{ArticleID}          = $Self->{ParamObject}->GetParam( Param => 'ArticleID' ) || '';
    $Self->{Config}             = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ArticleID TicketID QueueID)) {
        if ( !defined $Self->{$Needed} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "$Needed is needed!",
                Comment => 'Please contact your administrator',
            );
        }
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

    # get ACL restrictions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL restrictions exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    # get lock state && write (lock) permissions
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            if (
                $Self->{TicketObject}->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $Self->{UserID},
                )
                )
            {

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
                    Value => $Ticket{Number},
                    Type  => 'Small',
                );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => $Self->{LayoutObject}->{LanguageObject}
                        ->Get('Sorry, you need to be the ticket owner to perform this action.'),
                    Comment => $Self->{LayoutObject}->{LanguageObject}
                        ->Get('Please change the owner first.'),
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

    # ------------------------------------------------------------ #
    # show screen
    # ------------------------------------------------------------ #
    if ( !$Self->{Subaction} ) {

        # check if plain article exists
        if ( !$Self->{TicketObject}->ArticlePlain( ArticleID => $Self->{ArticleID} ) ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get article data
        my %Article = $Self->{TicketObject}->ArticleGet(
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 0,
        );

        # Check if article is from the same TicketID as we checked permissions for.
        if ( $Article{TicketID} ne $Self->{TicketID} ) {
            return $Self->{LayoutObject}->ErrorScreen(
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

        # prepare salutation
        my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );
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
        $Param{BounceText} = $Self->{ConfigObject}->Get('Ticket::Frontend::BounceText') || '';

        # make sure body is rich text
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {

            # prepare bounce tags
            $Param{BounceText} =~ s/<OTRS_TICKET>/&lt;OTRS_TICKET&gt;/g;
            $Param{BounceText} =~ s/<OTRS_BOUNCE_TO>/&lt;OTRS_BOUNCE_TO&gt;/g;

            $Param{BounceText} = $Self->{LayoutObject}->Ascii2RichText(
                String => $Param{BounceText},
            );
        }

        # build InformationFormat
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
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
        my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Article{QueueID}, );
        $Article{From} = "$Address{RealName} <$Address{Email}>";

        # get next states
        my %NextStates = $Self->{TicketObject}->TicketStateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );

        # build next states string
        if ( !$Self->{Config}->{StateDefault} ) {
            $NextStates{''} = '-';
        }
        $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data          => \%NextStates,
            Name          => 'BounceStateID',
            SelectedValue => $Self->{Config}->{StateDefault},
        );

        # add rich text editor
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {

            # use height/width defined for this screen
            $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
            $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

            $Self->{LayoutObject}->Block(
                Name => 'RichText',
                Data => \%Param,
            );
        }

        # print form ...
        my $Output = $Self->{LayoutObject}->Header(
            Value => $Ticket{TicketNumber},
            Type  => 'Small',
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketBounce',
            Data         => {
                %Param,
                %Article,
                TicketID     => $Self->{TicketID},
                ArticleID    => $Self->{ArticleID},
                TicketNumber => $Ticket{TicketNumber},
            },
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # ------------------------------------------------------------ #
    # bounce
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        for my $Parameter (qw(From BounceTo To Subject Body InformSender BounceStateID)) {
            $Param{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        my %Error;

        # check forward email address
        if ( !$Param{BounceTo} ) {
            $Error{'BounceToInvalid'} = 'ServerError';
            $Self->{LayoutObject}->Block( Name => 'BounceToCustomerGenericServerErrorMsg' );
        }
        for my $Email ( Mail::Address->parse( $Param{BounceTo} ) ) {
            my $Address = $Email->address();
            if ( $Self->{SystemAddress}->SystemAddressIsLocalAddress( Address => $Address ) ) {
                $Self->{LayoutObject}->Block( Name => 'BounceToCustomerGenericServerErrorMsg' );
                $Error{'BounceToInvalid'} = 'ServerError';
            }

            # check email address
            elsif ( !$Self->{CheckItemObject}->CheckEmail( Address => $Address ) ) {
                my $BounceToErrorMsg =
                    'BounceTo'
                    . $Self->{CheckItemObject}->CheckErrorType()
                    . 'ServerErrorMsg';
                $Self->{LayoutObject}->Block( Name => $BounceToErrorMsg );
                $Error{'BounceToInvalid'} = 'ServerError';
            }
        }

        if ( $Param{InformSender} ) {
            if ( !$Param{To} ) {
                $Error{'ToInvalid'} = 'ServerError';
                $Self->{LayoutObject}->Block( Name => 'ToCustomerGenericServerErrorMsg' );
            }
            else {

                # check email address(es)
                for my $Email ( Mail::Address->parse( $Param{To} ) ) {
                    if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                        my $ToErrorMsg =
                            'To'
                            . $Self->{CheckItemObject}->CheckErrorType()
                            . 'ServerErrorMsg';
                        $Self->{LayoutObject}->Block( Name => $ToErrorMsg );
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
            my %NextStates = $Self->{TicketObject}->TicketStateList(
                Action   => $Self->{Action},
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID},
            );

            # build next states string
            if ( !$Self->{Config}->{StateDefault} ) {
                $NextStates{''} = '-';
            }
            $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%NextStates,
                Name       => 'BounceStateID',
                SelectedID => $Param{BounceStateID},
            );

            # add rich text editor
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {

                # use height/width defined for this screen
                $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
                $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

                $Self->{LayoutObject}->Block(
                    Name => 'RichText',
                );
            }

            # prepare bounce tags if body is rich text
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {

                # prepare bounce tags
                $Param{Body} =~ s/&lt;OTRS_TICKET&gt;/&amp;lt;OTRS_TICKET&amp;gt;/gi;
                $Param{Body} =~ s/&lt;OTRS_BOUNCE_TO&gt;/&amp;lt;OTRS_BOUNCE_TO&amp;gt;/gi;
            }

            $Param{InformationFormat} = $Param{Body};
            $Param{InformSenderChecked} = $Param{InformSender} ? 'checked="checked"' : '';

            my $Output = $Self->{LayoutObject}->Header(
                Type => 'Small',
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketBounce',
                Data         => {
                    %Param,
                    %Error,
                    TicketID  => $Self->{TicketID},
                    ArticleID => $Self->{ArticleID},

                },
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        my $Bounce = $Self->{TicketObject}->ArticleBounce(
            TicketID    => $Self->{TicketID},
            ArticleID   => $Self->{ArticleID},
            UserID      => $Self->{UserID},
            To          => $Param{BounceTo},
            From        => $Param{From},
            HistoryType => 'Bounce',
        );

        # error page
        if ( !$Bounce ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Can't bounce email!",
                Comment => 'Please contact the admin.',
            );
        }

        # send customer info?
        if ( $Param{InformSender} ) {

            # set mime type
            my $MimeType = 'text/plain';
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $MimeType = 'text/html';

                # verify html document
                $Param{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                    String => $Param{Body},
                );
            }

            # replace placeholders
            $Param{Body} =~ s/(&lt;|<)OTRS_TICKET(&gt;|>)/$Ticket{TicketNumber}/g;
            $Param{Body} =~ s/(&lt;|<)OTRS_BOUNCE_TO(&gt;|>)/$Param{BounceTo}/g;

            # send
            my $ArticleID = $Self->{TicketObject}->ArticleSend(
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
                Charset        => $Self->{LayoutObject}->{UserCharset},
                MimeType       => $MimeType,
            );

            # error page
            if ( !$ArticleID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Can't send email!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # check if there is a chosen bounce state id
        if ( $Param{BounceStateID} ) {

            # set state
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $Param{BounceStateID},
            );
            $Self->{TicketObject}->TicketStateSet(
                TicketID  => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
                StateID   => $Param{BounceStateID},
                UserID    => $Self->{UserID},
            );

            # should i set an unlock?
            if ( $StateData{TypeName} =~ /^close/i ) {
                $Self->{TicketObject}->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # redirect
            if ( $StateData{TypeName} =~ /^close/i ) {
                return $Self->{LayoutObject}->PopupClose(
                    URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
                );
            }
        }
        return $Self->{LayoutObject}->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$Self->{ArticleID}",
        );
    }
    return $Self->{LayoutObject}->ErrorScreen(
        Message => 'Wrong Subaction!!',
        Comment => 'Please contact your administrator',
    );
}

1;
