# --
# Maint/Sessions/Commands.t - command tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my %NewSessionData = (
    UserLogin => 'root',
    UserEmail => 'root@example.com',
    UserType  => 'User',
);

my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

my $SessionID = $SessionObject->CreateSessionID(%NewSessionData);

$Self->True(
    $SessionID,
    "SessionID created",
);

my ( $Result, $ExitCode );

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

1;
