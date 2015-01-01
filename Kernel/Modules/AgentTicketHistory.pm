# --
# Kernel/Modules/AgentTicketHistory.pm - ticket history
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketHistory;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DBObject TicketObject LayoutObject LogObject UserObject ConfigObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Self->{TicketID} ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can\'t show history, no TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    if (
        !$Self->{TicketObject}->TicketPermission(
            Type     => 'ro',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $Self->{TicketObject}->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL restrictions exist
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    my @Lines = $Self->{TicketObject}->HistoryGet(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    my $Tn = $Self->{TicketObject}->TicketNumberLookup( TicketID => $Self->{TicketID} );

    # get shown user info
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::HistoryOrder') eq 'reverse' ) {
        @Lines = reverse(@Lines);
    }

    # Get mapping of history types to readable strings
    my %HistoryTypes;
    my %HistoryTypeConfig = %{ $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::HistoryTypes') // {} };
    for my $Entry ( sort keys %HistoryTypeConfig ) {
        %HistoryTypes = (
            %HistoryTypes,
            %{ $HistoryTypeConfig{$Entry} },
        );
    }

    for my $Data (@Lines) {

        # replace text
        if ( $Data->{Name} && $Data->{Name} =~ m/^%%/x ) {
            $Data->{Name} =~ s/^%%//xg;
            my @Values = split( /%%/x, $Data->{Name} );
            $Data->{Name} = $Self->{LayoutObject}->{LanguageObject}->Translate(
                $HistoryTypes{ $Data->{HistoryType} },
                @Values,
            );

            # remove not needed place holder
            $Data->{Name} =~ s/\%s//xg;
        }

        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => $Data,
        );

        if ( $Data->{ArticleID} ne "0" ) {
            $Self->{LayoutObject}->Block(
                Name => 'ShowLinkZoom',
                Data => $Data,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoLinkZoom',
            );

        }
    }

    # build page
    my $Output = $Self->{LayoutObject}->Header(
        Value => $Tn,
        Type  => 'Small',
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketHistory',
        Data         => {
            TicketNumber => $Tn,
            TicketID     => $Self->{TicketID},
            Title        => $Ticket{Title},
        },
    );
    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
