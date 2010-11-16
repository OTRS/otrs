# --
# 000-login.t - frontend tests for login
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: 000-login.t,v 1.1 2010-11-16 13:32:54 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Selenium;
use Time::HiRes qw(sleep);

my $sel = Kernel::System::UnitTest::Selenium->new(
    verbose  => 1,
    UnitTest => $Self,
);

$sel->open_ok("/otrs30-dev/index.pl");
$sel->type_ok( "User",     "root\@localhost" );
$sel->type_ok( "Password", "root" );
$sel->click_ok("//button[\@id='LoginButton']");
$sel->wait_for_page_to_load_ok("30000");
$sel->click_ok("//a[\@id='LogoutButton']");
$sel->wait_for_page_to_load_ok("30000");

# $sel->_ok();

1;
