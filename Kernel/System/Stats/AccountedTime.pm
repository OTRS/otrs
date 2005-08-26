# --
# Kernel/System/Stats/AccountedTime.pm - stats module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AccountedTime.pm,v 1.3 2005-08-26 15:55:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Stats::AccountedTime;

use strict;
use Date::Pcalc qw(Days_in_Month);
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject TicketObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{CustomerObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Param {
    my $Self = shift;
    my @Params = ();
    # get current time
    my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    # get one month bevore
    if ($M == 1) {
        $M = 12;
        $Y = $Y - 1;
    }
    else {
        $M = $M -1;
    }
    # create possible time selections
    my %Year = ();
    foreach ($Y-10..$Y+1) {
        $Year{$_} = $_;
    }
    my %Month = ();
    foreach (1..12) {
        my $Tmp = sprintf("%02d", $_);
        $Month{$_} = $Tmp;
    }

    push (@Params, {
            Frontend => 'Year',
            Name => 'Year',
            Multiple => 0,
            Size => 0,
            SelectedID => $Y,
            Data => {
                %Year,
            },
        },
    );
    push (@Params, {
            Frontend => 'Month',
            Name => 'Month',
            Multiple => 0,
            Size => 0,
            SelectedID => $M,
            Data => {
                %Month,
            },
        },
    );
    return @Params;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    $Param{Month} = sprintf("%02d", $Param{Month});
    my $Title = "$Param{Year}-$Param{Month}";
    my @HeadData = ('Customer', 'CustomerID', 'Ticket#', 'Time');
    my @Data = ();
    # get accounted time
    my $Days = Days_in_Month($Param{Year},$Param{Month});
    my @Tickets = ();
    my $SQL = "SELECT ticket_id, sum(time_unit) FROM ".
        " time_accounting ".
        " WHERE ".
        " create_time >= '$Param{Year}-$Param{Month}-01 00:00:01'".
        " AND " .
        " create_time <= '$Param{Year}-$Param{Month}-$Days 23:59:59'".
        " GROUP BY ticket_id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@Tickets, \@Row);
    }
    # get customers
    my %Accounted = ();
    foreach my $Row (@Tickets) {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Row->[0]);
        if (!defined($Ticket{CustomerID})) {
            $Ticket{CustomerID} = '-';
        }
        if (!defined($Ticket{CustomerUserID})) {
            $Ticket{CustomerUserID} = '-';
        }
        my $Customer = $Self->{CustomerObject}->CustomerName(
            UserLogin => $Ticket{CustomerUserID},
        ) || '-';

        $Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{Time} = ($Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{Time}||0) + $Row->[1];
        $Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{CustomerID} = $Ticket{CustomerID};
        $Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{Customer} = $Customer;
        if ($Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{Ticket}) {
            $Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{Ticket} .= ", ";
        }
        $Accounted{"$Ticket{CustomerUserID}::$Ticket{CustomerID}"}->{Ticket} .= $Ticket{TicketNumber};
    }
    foreach (sort keys %Accounted) {
        if ($Accounted{$_}->{Time}) {
        push (@Data, [
                $Accounted{$_}->{Customer},
                $Accounted{$_}->{CustomerID},
                $Accounted{$_}->{Ticket},
                $Accounted{$_}->{Time},
            ],
        );
        }
    }

    return ([$Title],[@HeadData], @Data);
}
# --
1;
