# --
# 100-AdminSelectBox.t - frontend tests for AdminSQL
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: 100-AdminSelectBox.t,v 1.2 2010-12-22 11:19:57 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Selenium;
use Kernel::System::UnitTest::Helper;
use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    my $sel = Kernel::System::UnitTest::Selenium->new(
        Verbose        => 1,
        UnitTestObject => $Self,
        %{$SeleniumScenario},
    );

    $sel->Login(
        Type     => 'Agent',
        User     => 'root@localhost',
        Password => 'root',
    );

    my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

    $sel->open_ok("${ScriptAlias}index.pl?Action=AdminSelectBox");
    $sel->wait_for_page_to_load_ok("30000");
    $sel->type_ok( "SQL", "SELECT * FROM valid" );
    $sel->click_ok("css=button#Run");
    $sel->wait_for_page_to_load_ok("30000");

    $sel->table_is( "//table.0.0", "1" );
    $sel->table_is( "//table.0.1", "valid" );
    $sel->table_is( "//table.1.0", "2" );
    $sel->table_is( "//table.1.1", "invalid" );
    $sel->table_is( "//table.2.0", "3" );
    $sel->table_is( "//table.2.1", "invalid-temp[...]" );
}

1;
