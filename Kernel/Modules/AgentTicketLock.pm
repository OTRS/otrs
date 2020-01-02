# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketLock;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Can\'t lock Ticket, no TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'lock',
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

    # start with actions
    if ( $Self->{Subaction} eq 'Unlock' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check if I'm the owner
        my ( $OwnerID, $OwnerLogin ) = $TicketObject->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ( $OwnerID != $Self->{UserID} ) {
            my $Output = $LayoutObject->Header(
                Title => Translatable('Error'),
                Type  => 'Small',
            );
            $Output .= $LayoutObject->Warning(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Sorry, the current owner is %s!', $OwnerLogin ),
                Comment => Translatable('Please become the owner first.'),
            );
            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # set unlock
        my $Lock = $TicketObject->TicketLockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'unlock',
            UserID   => $Self->{UserID},
        );

        if ( !$Lock ) {
            return $LayoutObject->ErrorScreen();
        }

        my $PreviousOwner = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'PreviousOwner' );

        if ($PreviousOwner) {

            my $OwnerSet = $TicketObject->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $PreviousOwner,
            );

            if ( !$OwnerSet ) {
                return $LayoutObject->ErrorScreen();
            }
        }

    }
    else {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check if the agent is able to lock the ticket
        if ( $TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            my ( $OwnerID, $OwnerLogin ) = $TicketObject->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            my $Output = $LayoutObject->Header(
                Title => Translatable('Error'),
                Type  => 'Small',
            );
            $Output .= $LayoutObject->Warning(
                Message => $LayoutObject->{LanguageObject}
                    ->Translate( 'Ticket (ID=%s) is locked by %s!', $Self->{TicketID}, $OwnerLogin ),
                Comment => Translatable('Change the owner!'),
            );
            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # set lock
        if (
            !$TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            )
            ||

            # set user id
            !$TicketObject->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )
            )
        {
            return $LayoutObject->ErrorScreen();
        }
    }

    # redirect
    if ( $Self->{QueueID} ) {
        return $LayoutObject->Redirect( OP => ";QueueID=$Self->{QueueID}" );
    }
    return $LayoutObject->Redirect(
        OP => "Action=AgentTicketZoom;TicketID=$Self->{TicketID}",
    );
}

1;
