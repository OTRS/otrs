# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Work around a Perl bug that is triggered in Carp
#   (Bizarre copy of HASH in list assignment at /usr/share/perl5/vendor_perl/Carp.pm line 229).
#
#   See https://rt.perl.org/Public/Bug/Display.html?id=52610 and
#   http://rt.perl.org/rt3/Public/Bug/Display.html?id=78186

no warnings 'redefine';    ## no critic
use Carp;
local *Carp::caller_info = sub { };    ## no critic # no-op
use warnings 'redefine';

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TargetDirectory = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/tmp';

# Cleanup from previous tests.
my @SupportFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
    Directory => '/var/tmp',
    Filter    => 'SupportBundle_*.tar.gz',
);
foreach my $File (@SupportFiles) {
    unlink $File;
}

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::SupportBundle::Generate');

# Run the console command and get its exit code as a result.
my $ExitCode = $CommandObject->Execute( '--target-directory', $TargetDirectory );

$Self->Is(
    $ExitCode,
    0,
    'Maint::SupportBundle::Generate exit code'
);

@SupportFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
    Directory => $TargetDirectory,
    Filter    => 'SupportBundle_*.tar.gz',
);

$Self->Is(
    scalar @SupportFiles,
    1,
    'Support bundle generated'
);

# Remove generated support files.
foreach my $File (@SupportFiles) {
    unlink $File;
}

# Cleanup cache is done by RestoreDatabase.

1;
