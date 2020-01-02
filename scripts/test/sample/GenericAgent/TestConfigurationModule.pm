# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::test::sample::GenericAgent::TestConfigurationModule;

use strict;
use warnings;
use utf8;

use vars qw(@ISA @EXPORT %Jobs);
use Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw(%Jobs);

%Jobs = (

    'set priority very high' => {

        # get all tickets with these properties
        Title => 'UnitTestSafeToDelete',
        New   => {

            # new priority
            PriorityID => 5,
        },
    },

    'set state open' => {

        # get all tickets with these properties
        Title => 'UnitTestSafeToDelete',
        New   => {

            # new state
            State => 'open',
        },
    },
);
1;
