# --
# Kernel/Modules/AgentTicketMerge.pm - to merge tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketMerge;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::TemplateGenerator;
use Kernel::System::SystemAddress;
use Kernel::System::CheckItem;
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

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;
    my %Error;
    my %GetParam;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

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

    # check if ACL resctictions if exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

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

                # show lock state
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID}, },
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

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );
        }
    }
    else {

        # show back link
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => { %Param, TicketID => $Self->{TicketID} },
        );
    }

    # merge action
    if ( $Self->{Subaction} eq 'Merge' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get all parameters
        for my $Parameter (qw( From To Subject Body InformSender MainTicketNumber )) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # rewrap body if no rich text is used
        if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{Body} = $Self->{LayoutObject}->WrapPlainText(
                MaxCharacters => $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote'),
                PlainText     => $GetParam{Body},
            );
        }

        # removing blank spaces from the ticket number
        $Self->{CheckItemObject}->StringClean(
            StringRef => \$GetParam{'MainTicketNumber'},
            TrimLeft  => 1,
            TrimRight => 1,
        );

        # check some stuff
        my $MainTicketID = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $GetParam{'MainTicketNumber'},
        );

        # check for errors
        if ( !$MainTicketID ) {
            $Error{'MainTicketNumberInvalid'} = 'ServerError';
        }

        if ( $GetParam{InformSender} ) {
            for my $Parameter (qw( To Subject Body )) {
                if ( !$GetParam{$Parameter} ) {
                    $Error{ $Parameter . 'Invalid' } = 'ServerError';
                }
            }

            # check forward email address(es)
            if ( $GetParam{To} ) {
                for my $Email ( Mail::Address->parse( $GetParam{To} ) ) {
                    my $Address = $Email->address();
                    if (
                        $Self->{SystemAddress}->SystemAddressIsLocalAddress( Address => $Address )
                        )
                    {
                        $Self->{LayoutObject}->Block( Name => 'ToCustomerGenericServerErrorMsg' );
                        $Error{'ToInvalid'} = 'ServerError';
                    }

                    # check email address
                    elsif ( !$Self->{CheckItemObject}->CheckEmail( Address => $Address ) ) {
                        my $ToErrorMsg =
                            'To'
                            . $Self->{CheckItemObject}->CheckErrorType()
                            . 'ServerErrorMsg';
                        $Self->{LayoutObject}->Block( Name => $ToErrorMsg );
                        $Error{'ToInvalid'} = 'ServerError';
                    }
                }
            }
            else {
                $Self->{LayoutObject}->Block( Name => 'ToCustomerGenericServerErrorMsg' );
            }
        }

        if (%Error) {
            my $Output = $Self->{LayoutObject}->Header(
                Type => 'Small',
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

            $Param{InformSenderChecked} = $GetParam{InformSender} ? 'checked="checked"' : '';

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketMerge',
                Data => { %Param, %GetParam, %Ticket, %Error },
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check permissions
        my $Access = $Self->{TicketObject}->TicketPermission(
            Type     => $Self->{Config}->{Permission},
            TicketID => $MainTicketID,
            UserID   => $Self->{UserID},
        );

        # error screen, don't show ticket
        if ( !$Access ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }

        # check errors
        if (
            $Self->{TicketID} == $MainTicketID
            || !$Self->{TicketObject}->TicketMerge(
                MainTicketID  => $MainTicketID,
                MergeTicketID => $Self->{TicketID},
                UserID        => $Self->{UserID},
            )
            )
        {
            my $Output .= $Self->{LayoutObject}->Header(
                Type => 'Small',
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

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketMerge',
                Data => { %Param, %Ticket },
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }
        else {

            # send customer info?
            if ( $GetParam{InformSender} ) {
                my $MimeType = 'text/plain';
                if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                        String => $GetParam{Body},
                    );
                }
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
                $GetParam{Body} =~ s/(&lt;|<)OTRS_TICKET(&gt;|>)/$Ticket{TicketNumber}/g;
                $GetParam{Body}
                    =~ s/(&lt;|<)OTRS_MERGE_TO_TICKET(&gt;|>)/$GetParam{'MainTicketNumber'}/g;
                my $ArticleID = $Self->{TicketObject}->ArticleSend(
                    ArticleType    => 'email-external',
                    SenderType     => 'agent',
                    TicketID       => $Self->{TicketID},
                    HistoryType    => 'SendAnswer',
                    HistoryComment => "Merge info to '$GetParam{To}'.",
                    From           => $GetParam{From},
                    Email          => $GetParam{Email},
                    To             => $GetParam{To},
                    Subject        => $GetParam{Subject},
                    UserID         => $Self->{UserID},
                    Body           => $GetParam{Body},
                    Charset        => $Self->{LayoutObject}->{UserCharset},
                    MimeType       => $MimeType,
                );
                if ( !$ArticleID ) {

                    # error page
                    return $Self->{LayoutObject}->ErrorScreen();
                }
            }

            # redirect to merged ticket
            return $Self->{LayoutObject}->PopupClose(
                URL => "Action=AgentTicketZoom;TicketID=$MainTicketID",
            );
        }
    }
    else {

        # get last article
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
            TicketID      => $Self->{TicketID},
            DynamicFields => 1,
        );

        # merge box
        my $Output = $Self->{LayoutObject}->Header(
            Value => $Ticket{TicketNumber},
            Type  => 'Small',
        );

        # prepare salutation
        my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );
        my $Salutation        = $TemplateGenerator->Salutation(
            TicketID  => $Self->{TicketID},
            ArticleID => $Article{ArticleID},
            Data      => {%Article},
            UserID    => $Self->{UserID},
        );

        # prepare signature
        my $Signature = $TemplateGenerator->Signature(
            TicketID  => $Self->{TicketID},
            ArticleID => $Article{ArticleID},
            Data      => {%Article},
            UserID    => $Self->{UserID},
        );

        # prepare subject ...
        $Article{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Article{TicketNumber},
            Subject => $Article{Subject} || '',
        );

        # prepare from ...
        $Article{To} = $Article{From};
        my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Ticket{QueueID} );
        $Article{From} = "$Address{RealName} <$Address{Email}>";

        # add salutation and signature to body
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            my $Body = $Self->{LayoutObject}->Ascii2RichText(
                String => $Self->{ConfigObject}->Get('Ticket::Frontend::MergeText'),
            );
            $Article{Body} = $Salutation
                . '<br/><br/>'
                . $Body
                . '<br/><br/>'
                . $Signature;
        }
        else {
            $Article{Body} = $Salutation
                . "\n\n"
                . $Self->{ConfigObject}->Get('Ticket::Frontend::MergeText')
                . "\n\n"
                . $Signature;
        }

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

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketMerge',
            Data => { %Param, %Ticket, %Article, }
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }
}

1;
