# --
# Kernel/Modules/AgentTicketHistory.pm - ticket history
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketHistory.pm,v 1.14 2009-02-16 11:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketHistory;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject TicketObject LayoutObject LogObject UserObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
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
        !$Self->{TicketObject}->Permission(
            Type     => 'ro',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    my @Lines = $Self->{TicketObject}->HistoryGet(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    my $Tn = $Self->{TicketObject}->TicketNumberLookup( TicketID => $Self->{TicketID} );

    # get shown user info
    my @NewLines = ();
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::HistoryOrder') eq 'reverse' ) {
        @NewLines = reverse(@Lines);
    }
    else {
        @NewLines = @Lines;
    }
    my $Table   = '';
    my $Counter = 1;
    for my $DataTmp (@NewLines) {
        $Counter++;
        my %Data = %{$DataTmp};

        # replace text
        if ( $Data{Name} && $Data{Name} =~ /^%%/ ) {
            my %Info = ();
            $Data{Name} =~ s/^%%//g;
            my @Values = split( /%%/, $Data{Name} );
            $Data{Name} = '';
            for (@Values) {
                if ( $Data{Name} ) {
                    $Data{Name} .= "\", ";
                }
                $Data{Name} .= "\"$_";
            }
            if ( !$Data{Name} ) {
                $Data{Name} = '" ';
            }
            $Data{Name} = $Self->{LayoutObject}->{LanguageObject}->Get(
                'History::' . $Data{HistoryType} . '", ' . $Data{Name}
            );

            # remove not needed place holder
            $Data{Name} =~ s/\%s//g;
        }

        # seperate each searchresult line by using several css
        if ( $Counter % 2 ) {
            $Data{css} = 'searchpassive';
        }
        else {
            $Data{css} = 'searchactive';
        }
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {%Data},
        );
    }

    # build page
    my $Output = $Self->{LayoutObject}->Header( Value => $Tn );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketHistory',
        Data         => {
            TicketNumber => $Tn,
            TicketID     => $Self->{TicketID},
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
