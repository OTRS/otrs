# --
# Kernel/Modules/AgentTicketHistory.pm - ticket history
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketHistory;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

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
    for my $Data (@Lines) {

        # replace text
        if ( $Data->{Name} && $Data->{Name} =~ m/^%%/x ) {
            my %Info = ();
            $Data->{Name} =~ s/^%%//xg;
            my @Values = split( /%%/x, $Data->{Name} );
            $Data->{Name} = '';
            for my $Value (@Values) {
                if ( $Data->{Name} ) {
                    $Data->{Name} .= "\", ";
                }
                $Data->{Name} .= "\"$Value";
            }
            if ( !$Data->{Name} ) {
                $Data->{Name} = '" ';
            }
            $Data->{Name} = $Self->{LayoutObject}->{LanguageObject}->Get(
                'History::' . $Data->{HistoryType} . '", ' . $Data->{Name}
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
