# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Layout::Datepicker;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Datepicker - Datepicker data

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item DatepickerGetVacationDays()

Returns a hash of all vacation days defined in the system.

    $LayoutObject->DatepickerGetVacationDays();

=cut

sub DatepickerGetVacationDays {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get the defined vacation days
    my $TimeVacationDays        = $ConfigObject->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $ConfigObject->Get('TimeVacationDaysOneTime');
    if ( $Param{Calendar} ) {
        if ( $ConfigObject->Get( "TimeZone::Calendar" . $Param{Calendar} . "Name" ) ) {
            $TimeVacationDays        = $ConfigObject->Get( "TimeVacationDays::Calendar" . $Param{Calendar} );
            $TimeVacationDaysOneTime = $ConfigObject->Get(
                "TimeVacationDaysOneTime::Calendar" . $Param{Calendar}
            );
        }
    }

    # translate the vacation description if possible
    for my $Month ( sort keys %{$TimeVacationDays} ) {
        for my $Day ( sort keys %{ $TimeVacationDays->{$Month} } ) {
            $TimeVacationDays->{$Month}->{$Day}
                = $Self->{LanguageObject}->Translate( $TimeVacationDays->{$Month}->{$Day} );
        }
    }

    for my $Year ( sort keys %{$TimeVacationDaysOneTime} ) {
        for my $Month ( sort keys %{ $TimeVacationDaysOneTime->{$Year} } ) {
            for my $Day ( sort keys %{ $TimeVacationDaysOneTime->{$Year}->{$Month} } ) {
                $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} = $Self->{LanguageObject}->Translate(
                    $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
                );
            }
        }
    }
    return {
        'TimeVacationDays'        => $TimeVacationDays,
        'TimeVacationDaysOneTime' => $TimeVacationDaysOneTime,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
