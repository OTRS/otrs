# --
# Kernel/Config/GenericAgentOTRSEscalationEvents.pm - config file of generic agent
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: GenericAgentOTRSEscalationEvents.pm,v 1.1 2011-02-28 09:41:23 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Config::GenericAgentOTRSEscalationEvents;

use strict;
use warnings;

use base qw(Exporter);

use vars qw($VERSION @EXPORT %Jobs);
@EXPORT = qw(%Jobs);
$VERSION = qw($Revision: 1.1 $) [1];

# %Jobs will be available in the users namespace
%Jobs = (

    # GenericAgent-job that triggers escaltion forewarn and escalation start events
    'trigger escalation events' => {
        Escalation => 1,

        # new ticket properties
        New => {
            Module => 'Kernel::System::GenericAgent::TriggerEscalationStartEvents',
        },
    },
);

1;
