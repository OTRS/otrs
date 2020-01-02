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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my %NewSessionData = (
    UserLogin => 'root',
    UserEmail => 'root@example.com',
    UserType  => 'User',
);

# get session object
my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

my $SessionID = $SessionObject->CreateSessionID(%NewSessionData);

$Self->True(
    $SessionID,
    "SessionID created",
);

my ( $Result, $ExitCode );

# get ListAll command object
my $ListAllCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::ListAll');
{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListAllCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListAll exit code",
);

$Self->True(
    scalar $Result =~ m{$SessionID}xms,
    "SessionID is listed",
);

# get DeleteAll command object
my $DeleteAllCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::DeleteAll');

$ExitCode = $DeleteAllCommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "DeleteAll exit code",
);

$Self->Is(
    scalar $SessionObject->GetAllSessionIDs(),
    0,
    "Sessions removed",
);

undef $Result;

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListAllCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListAll exit code",
);

$Self->True(
    scalar $Result !~ m{$SessionID}xms,
    "SessionID is no longer listed",
);

$SessionID = $SessionObject->CreateSessionID(%NewSessionData);

# get DeleteExpired command object
my $DeleteExpiredCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::DeleteExpired');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SessionMaxTime',
    Value => 10000
);

$ExitCode = $DeleteExpiredCommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "DeleteExpired exit code",
);

$Self->Is(
    scalar $SessionObject->GetAllSessionIDs(),
    1,
    "Sessions still alive",
);

undef $Result;

# get ListExpired command object
my $ListExpiredCommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::ListExpired');
{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListExpiredCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListExpired exit code",
);

$Self->True(
    scalar $Result !~ m{$SessionID}xms,
    "SessionID is not listed as expired",
);

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SessionMaxTime',
    Value => -1
);

undef $Result;

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $ListExpiredCommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "ListExpired exit code",
);

$Self->True(
    scalar $Result =~ m{$SessionID}xms,
    "SessionID is listed as expired",
);

$ExitCode = $DeleteExpiredCommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "DeleteExpired exit code",
);

$Self->Is(
    scalar $SessionObject->GetAllSessionIDs(),
    0,
    "Expired sessions deleted",
);

# cleanup cache is done by RestoreDatabase

1;
