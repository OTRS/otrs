# --
# Kernel/System/Stats/Static/StateAction.pm - static stat for ticket history
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Static::StateAction;

use strict;
use warnings;

use Date::Pcalc qw(Days_in_Month Day_of_Week Day_of_Week_Abbreviation);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    return $Self;
}

sub Param {
    my $Self = shift;

    # get current time
    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    # get one month before
    my $SelectedYear  = $M == 1 ? $Y - 1 : $Y;
    my $SelectedMonth = $M == 1 ? 12     : $M - 1;

    # create possible time selections
    my %Year = map { $_ => $_; } ( $Y - 10 .. $Y );
    my %Month = map { $_ => sprintf( "%02d", $_ ); } ( 1 .. 12 );

    my @Params = (
        {
            Frontend   => 'Year',
            Name       => 'Year',
            Multiple   => 0,
            Size       => 0,
            SelectedID => $SelectedYear,
            Data       => \%Year,
        },
        {
            Frontend   => 'Month',
            Name       => 'Month',
            Multiple   => 0,
            Size       => 0,
            SelectedID => $SelectedMonth,
            Data       => \%Month,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Year  = $Param{Year};
    my $Month = $Param{Month};
    my $Day   = Days_in_Month( $Year, $Month );

    my %States = $Self->_GetHistoryTypes();
    my @PossibleStates;
    for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
        $States{$StateID} =~ s/^(.{18}).*$/$1\.\.\./;
        push @PossibleStates, $States{$StateID};
    }

    # build x_lable
    my $DayCounter = 0;
    my @Data;
    my @Days      = ();
    my %StateDate = ();
    while ( $Day >= $DayCounter + 1 ) {

        $DayCounter++;
        my $Dow = Day_of_Week( $Year, $Month, $DayCounter );
        $Dow = Day_of_Week_Abbreviation($Dow);
        my $Text = "$Dow $DayCounter";
        push @Days, $Text;
        my @Row = ();
        for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
            my $Count = $Self->_GetDBDataPerDay(
                Year    => $Year,
                Month   => $Month,
                Day     => $DayCounter,
                StateID => $StateID,
            );
            push @Row, $Count;

            $StateDate{$Text}->{$StateID} = ( $StateDate{$Text}->{$StateID} || 0 ) + $Count;
        }
    }
    for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
        my @Row = ( $States{$StateID} );
        for my $Day (@Days) {
            my %Hash = %{ $StateDate{$Day} };
            push @Row, $Hash{$StateID};
        }
        push @Data, \@Row;
    }

    my $Title = "$Year-$Month";
    return ( [$Title], [ 'Days', @Days ], @Data );
}

sub _GetHistoryTypes {
    my $Self = shift;

    my $SQL = 'SELECT id, name FROM ticket_history_type WHERE valid_id = 1';
    $Self->{DBObject}->Prepare( SQL => $SQL );

    my %Stats;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Stats{ $Row[0] } = $Row[1];
    }

    return %Stats;
}

sub _GetDBDataPerDay {
    my ( $Self, %Param ) = @_;

    my $Start = "$Param{Year}-$Param{Month}-$Param{Day} 00:00:01";
    my $End   = "$Param{Year}-$Param{Month}-$Param{Day} 23:59:59";
    my $SQL   = 'SELECT count(*) FROM ticket_history '
        . 'WHERE history_type_id = ? AND create_time >= ? AND create_time <= ?';

    $Self->{DBObject}->Prepare( SQL => $SQL, Bind => [ \$Param{StateID}, \$Start, \$End ] );

    my $DayData = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $DayData = $Row[0];
    }
    return $DayData;
}

1;
