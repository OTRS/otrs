# --
# 100-AdminSQL.t - frontend tests for AdminSQL
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: 100-AdminSQL.t,v 1.2 2010-12-20 14:16:33 mg Exp $
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

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

# use local Config object because it will be modified
my $ConfigObject = Kernel::Config->new();

my $sel = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

$sel->Login(
    Type     => 'Agent',
    User     => 'root@localhost',
    Password => 'root',
);

my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

$sel->open_ok("${ScriptAlias}index.pl?Action=AdminSelectBox");
$sel->wait_for_page_to_load_ok("30000");
$sel->type_ok( "SQL", "SELECT * FROM valid" );
$sel->click_ok("//button[\@value='Run Query']");
$sel->wait_for_page_to_load_ok("30000");
$sel->body_text_is("valid");

1;
