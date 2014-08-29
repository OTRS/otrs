# --
# scripts/test/ObjectManager/Dummy.pm - Dummy object to test ObjectManager
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::ObjectManager::Dummy;    ## no critic

use strict;
use warnings;

use Kernel::System::ObjectManager;

## nofilter(TidyAll::Plugin::OTRS::Perl::ObjectDependencies)
our @ObjectDependencies = ();    # we want to use an undeclared dependency for testing

sub new {
    my ( $Class, %Param ) = @_;

    bless \%Param, $Class;
}

sub Data {
    my ($Self) = @_;
    return $Self->{Data};
}

sub DESTROY {

    # Request this object (undeclared dependency) in the desctructor.
    #   This will create it again in the OM to test that ObjectsDiscard will still work.
    $Kernel::OM->Get('scripts::test::ObjectManager::Dummy2');
}

1;
