# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Static::StateAction;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 1,
    );

    return %Behaviours;
}

sub Param {
    my $Self = shift;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # get one month before
    $DateTimeObject->Subtract( Months => 1 );
    my $DateTimeSettings = $DateTimeObject->Get();

    # create possible time selections
    my %Year  = map { $_ => $_; } ( $DateTimeSettings->{Year} - 10 .. $DateTimeSettings->{Year} );
    my %Month = map { $_ => sprintf( "%02d", $_ ); } ( 1 .. 12 );

    my @Params = (
        {
            Frontend   => 'Year',
            Name       => 'Year',
            Multiple   => 0,
            Size       => 0,
            SelectedID => $DateTimeSettings->{Year},
            Data       => \%Year,
        },
        {
            Frontend   => 'Month',
            Name       => 'Month',
            Multiple   => 0,
            Size       => 0,
            SelectedID => $DateTimeSettings->{Month},
            Data       => \%Month,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{Year} || !$Param{Month};

    # get language object
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my $Year  = $Param{Year};
    my $Month = $Param{Month};

    my %States = $Self->_GetHistoryTypes();
    my @PossibleStates;
    for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
        $States{$StateID} = $LanguageObject->Translate( $States{$StateID} );
        push @PossibleStates, $States{$StateID};
    }

    # build x axis

    # first take epoch for 12:00 on the 1st of given month
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year   => $Param{Year},
            Month  => $Param{Month},
            Day    => 1,
            Hour   => 12,
            Minute => 0,
            Second => 0,
        },
    );
    my $DateTimeValues = $DateTimeObject->Get();

    my @Data;
    my @Days      = ();
    my %StateDate = ();

    # execute for all days of this month
    while ( $DateTimeValues->{Month} == int $Param{Month} ) {

        # x-label is of format 'Mon 1, Tue 2,' etc
        my $Text = $LanguageObject->Translate( $DateTimeValues->{DayAbbr} ) . ' ' . $DateTimeValues->{Day};

        push @Days, $Text;
        my @Row = ();
        for my $StateID ( sort { $States{$a} cmp $States{$b} } keys %States ) {
            my $Count = $Self->_GetDBDataPerDay(
                Year    => $Year,
                Month   => $Month,
                Day     => $DateTimeValues->{Day},
                StateID => $StateID,
            );
            push @Row, $Count;

            $StateDate{$Text}->{$StateID} = ( $StateDate{$Text}->{$StateID} || 0 ) + $Count;
        }

        # move to next day
        $DateTimeObject->Add( Days => 1 );
        $DateTimeValues = $DateTimeObject->Get();
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
    return ( [$Title], [ $LanguageObject->Translate('Days'), @Days ], @Data );
}

sub _GetHistoryTypes {
    my $Self = shift;

    my $SQL      = 'SELECT id, name FROM ticket_history_type WHERE valid_id = 1';
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Prepare( SQL => $SQL );

    my %Stats;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => [ \$Param{StateID}, \$Start, \$End ]
    );

    my $DayData = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DayData = $Row[0];
    }
    return $DayData;
}

1;
