# --
# Kernel/Modules/AgentTicketMerge.pm - to merge tickets
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketMerge.pm,v 1.26 2009-03-09 13:09:35 martin Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.26 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # get lock state && write (lock) permissions
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->LockIsTicketLocked( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            if (
                $Self->{TicketObject}->OwnerSet(
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
                my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{Number} );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to be the owner to do this action!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
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
            Data => { %Param, %Ticket, },
        );
    }

    # merge action
    if ( $Self->{Subaction} eq 'Merge' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $MainTicketNumber = $Self->{ParamObject}->GetParam( Param => 'MainTicketNumber' );
        my $MainTicketID = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $MainTicketNumber,
        );

        # check permissions
        my $Access = $Self->{TicketObject}->Permission(
            Type     => $Self->{Config}->{Permission},
            TicketID => $MainTicketID,
            UserID   => $Self->{UserID}
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
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketMerge',
                Data => { %Param, %Ticket },
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {

            # get params
            for (qw(From To Subject Body InformSender)) {
                $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
            }

            # check forward email address
            for my $Email ( Mail::Address->parse( $Param{BounceTo} ) ) {
                my $Address = $Email->address();
                if ( $Self->{SystemAddress}->SystemAddressIsLocalAddress( Address => $Address ) ) {

                    # error page
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Can't forward ticket to $Address! It's a local "
                            . "address! You need to move it!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }

            # send customer info?
            if ( $Param{InformSender} ) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
                $Param{Body} =~ s/<OTRS_TICKET>/$Ticket{TicketNumber}/g;
                $Param{Body} =~ s/<OTRS_MERGE_TO_TICKET>/$MainTicketNumber/g;
                my $ArticleID = $Self->{TicketObject}->ArticleSend(
                    ArticleType    => 'email-external',
                    SenderType     => 'agent',
                    TicketID       => $Self->{TicketID},
                    HistoryType    => 'SendAnswer',
                    HistoryComment => "Merge info to '$Param{To}'.",
                    From           => $Param{From},
                    Email          => $Param{Email},
                    To             => $Param{To},
                    Subject        => $Param{Subject},
                    UserID         => $Self->{UserID},
                    Body           => $Param{Body},
                    Type           => 'text/plain',
                    Charset        => $Self->{LayoutObject}->{UserCharset},
                );
                if ( !$ArticleID ) {

                    # error page
                    return $Self->{LayoutObject}->ErrorScreen();
                }
            }

            # redirect to merged ticket
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTicketZoom&TicketID=$MainTicketID"
            );
        }
    }
    else {

        # get last article
        my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
            TicketID => $Self->{TicketID},
        );

        # merge box
        my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # prepare salutation
        my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );
        $Param{Salutation} = $TemplateGenerator->Salutation(
            TicketID   => $Self->{TicketID},
            ArticleID  => $Article{ArticleID},
            Data       => \%Param,
            UserID     => $Self->{UserID},
        );

        # prepare signature
        $Param{Signature} = $TemplateGenerator->Signature(
            TicketID   => $Self->{TicketID},
            ArticleID  => $Article{ArticleID},
            Data       => \%Param,
            UserID     => $Self->{UserID},
        );

        # put & get attributes like sender address
        %Param = $TemplateGenerator->Attributes(
            TicketID   => $Self->{TicketID},
            ArticleID  => $Article{ArticleID},
            Data       => \%Param,
            UserID     => $Self->{UserID},
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketMerge',
            Data => { %Param, %Ticket },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
