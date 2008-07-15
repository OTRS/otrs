# --
# Kernel/Output/HTML/NavBarCustomerCompany.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: NavBarCustomerCompany.pm,v 1.1 2008-07-15 19:35:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::NavBarCustomerCompany;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if frontend module is registared
    return if !$Self->{ConfigObject}->Get('Frontend::Module')->{AdminCustomerCompany};

    # check if customer company feature is active
    for my $Item ('', 1..10) {
        my $CustomerMap = $Self->{ConfigObject}->Get( 'CustomerUser' . $Item );
        next if !$CustomerMap;

        # return if CustomerCompany feature is used
        return if $CustomerMap->{CustomerCompanySupport};
    }

    # reset nav bar item
    my %Return = ();
    $Return{'0009100'} = {};
    return %Return;
}

1;
