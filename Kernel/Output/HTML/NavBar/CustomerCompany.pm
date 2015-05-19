# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBar::CustomerCompany;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if frontend module is registared
    my $Config = $ConfigObject->Get('Frontend::Module')->{AdminCustomerCompany};
    return if !$Config;

    # check if customer company support feature is active
    SOURCE:
    for my $Item ( '', 1 .. 10 ) {
        my $CustomerMap = $ConfigObject->Get( 'CustomerUser' . $Item );
        next SOURCE if !$CustomerMap;

        # return if CustomerCompany feature is used
        return if $CustomerMap->{CustomerCompanySupport};
    }

    # frontend module is enabled but not customer company support feature, then remove the menu entry
    my $NavBarName = $Config->{NavBarName};
    my %Return     = %{ $Param{NavBar}->{Sub} };

    # remove CustomerCompany from the CustomerMenu
    delete $Return{$NavBarName}->{ItemArea0009100};

    return ( Sub => \%Return );
}

1;
