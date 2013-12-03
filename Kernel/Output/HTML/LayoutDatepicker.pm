# --
# Kernel/Output/HTML/LayoutDatepicker.pm - provides generic HTML output
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutDatepicker;

use strict;
use warnings;

=head1 NAME

Kernel::Output::HTML::LayoutDatepicker - Datepicker data

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

    # get the defined vacation days
    my $TimeVacationDays        = $Self->{ConfigObject}->Get('TimeVacationDays');
    my $TimeVacationDaysOneTime = $Self->{ConfigObject}->Get('TimeVacationDaysOneTime');

    # translate the vacation description if possible
    for my $Month ( sort keys %{$TimeVacationDays} ) {
        for my $Day ( sort keys %{ $TimeVacationDays->{$Month} } ) {
            $TimeVacationDays->{$Month}->{$Day}
                = $Self->{LanguageObject}->Get( $TimeVacationDays->{$Month}->{$Day} );
        }
    }

    for my $Year ( sort keys %{$TimeVacationDaysOneTime} ) {
        for my $Month ( sort keys %{ $TimeVacationDaysOneTime->{$Year} } ) {
            for my $Day ( sort keys %{ $TimeVacationDaysOneTime->{$Year}->{$Month} } ) {
                $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} = $Self->{LanguageObject}->Get(
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
