# --
# Kernel/Config/ModulesCustom.pm - config file of all custom used modules
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ModulesCustom.pm,v 1.3 2002-11-15 13:10:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Config::ModulesCustom;

use strict;
use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
# allow modules - Action=? (regexpr)
# --
$Kernel::Config::ModulesCustom::Allow = "^(Test|Report)";

# --
# all custom modules 
# --
use Kernel::Modules::Test;

# --
# common needed objects
# (so you can access this modules in Kernel::Modules::* with 
# $Self->{Key})
# --
$Kernel::Config::ModulesCustom::CommonObject = {
    # key => module
    Test => 'Kernel::Modules::Test',
};
# --
# common needed params
# (so you can access this params in Kernel::Modules::* with
# $Self->{Key})
# --
$Kernel::Config::ModulesCustom::Param = {
    # param => default value
#    QueueID => 0,
};
# --

1; 
