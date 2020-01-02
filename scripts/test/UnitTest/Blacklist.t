# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::UnitTest::Run');

my @Tests = (
    {
        Name   => "UnitTest 'User.t' (blacklisted)",
        Test   => 'User',
        Config => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => ['User.t'],
        },
        TestExecuted => 0,
    },
    {
        Name   => "UnitTest 'User.t' (whitelisted)",
        Test   => 'User',
        Config => {
            Valid => 1,
            Key   => 'UnitTest::Blacklist###1000-UnitTest' . $RandomID,
            Value => [],
        },
        TestExecuted => 1,
    },
);

for my $Test (@Tests) {

    $Helper->ConfigSettingChange(
        %{ $Test->{Config} },
    );

    my $Result;
    my $ExitCode;

    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;

        $ExitCode = $CommandObject->Execute( '--test', $Test->{Test} );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    chomp $Result;

    # Check for executed tests message.
    my $Success = $Result =~ m{ No \s+ tests \s+ executed\. }xms;

    if ( $Test->{TestExecuted} ) {

        $Self->False(
            $Success,
            $Test->{Name} . ' - executed successfully.',
        );
    }
    else {

        $Self->True(
            $Success,
            $Test->{Name} . ' - not executed.',
        );
    }
}

1;
