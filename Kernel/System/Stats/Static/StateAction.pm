# --
# Kernel/System/Stats/Static/StateAction.pm - static stat for ticket history
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Static::StateAction;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use Time::Piece;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject DBObject MainObject TimeObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
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

    my %States = $Self->_GetHistoryTypes();
    my @PossibleStates;
    for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
        $States{$StateID} =~ s/^(.{18}).*$/$1\.\.\./;
        push @PossibleStates, $States{$StateID};
    }

    # build x axis

    # first take epoch for 12:00 on the 1st of given month
    # create Time::Piece object for this time
    my $SystemTime = $Self->{TimeObject}->Date2SystemTime(
        Year   => $Param{Year},
        Month  => $Param{Month},
        Day    => 1,
        Hour   => 12,
        Minute => 0,
        Second => 0,
    );
    my $TimePiece = localtime($SystemTime);    ## no critic

    my @Data;
    my @Days      = ();
    my %StateDate = ();

    # execute for all days of this month
    while ( $TimePiece->mon() == $Param{Month} ) {

        # x-label is of format 'Mon 1, Tue 2,' etc
        my $Text = $TimePiece->wdayname() . ' ' . $TimePiece->mday();

        push @Days, $Text;
        my @Row = ();
        for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
            my $Count = $Self->_GetDBDataPerDay(
                Year    => $Year,
                Month   => $Month,
                Day     => $TimePiece->mday(),
                StateID => $StateID,
            );
            push @Row, $Count;

            $StateDate{$Text}->{$StateID} = ( $StateDate{$Text}->{$StateID} || 0 ) + $Count;
        }

        # move to next day
        $TimePiece += ( 3600 * 24 );
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
