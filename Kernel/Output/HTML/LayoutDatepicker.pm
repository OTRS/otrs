# --
# Kernel/Output/HTML/LayoutDatepicker.pm - provides generic HTML output
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: LayoutDatepicker.pm,v 1.1 2010-06-15 12:59:02 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutDatepicker;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    foreach my $Month ( keys %{$TimeVacationDays} ) {
        foreach my $Day ( keys %{ $TimeVacationDays->{$Month} } ) {
            $TimeVacationDays->{$Month}->{$Day} = $Self->{LanguageObject}->Get( $TimeVacationDays->{$Month}->{$Day} );
        }
    }

    foreach my $Year ( keys %{$TimeVacationDaysOneTime} ) {
        foreach my $Month ( keys %{ $TimeVacationDaysOneTime->{$Year} } ) {
            foreach my $Day ( keys %{ $TimeVacationDaysOneTime->{$Year}->{$Month} } ) {
                $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day}
                    = $Self->{LanguageObject}->Get( $TimeVacationDaysOneTime->{$Year}->{$Month}->{$Day} );
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
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2010-06-15 12:59:02 $

=cut
