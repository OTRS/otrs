# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::FrameworkVersionCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::FrameworkVersionCheck - Checks required framework version for update.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # load RELEASE file
    if ( -e !"$Home/RELEASE" ) {
        die "Error: $Home/RELEASE does not exist!";
    }
    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {    ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        die "Error: Can't read $Home/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Error: No OTRS system found"
    }
    if ( $Version !~ /^6\.0(.*)$/ ) {

        die "Error: You are trying to run this script on the wrong framework version $Version!"
    }

    return 1;
}

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # load RELEASE file
    if ( -e !"$Home/RELEASE" ) {
        print "Error: $Home/RELEASE does not exist!";
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
