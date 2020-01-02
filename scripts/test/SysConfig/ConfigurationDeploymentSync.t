# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Do not use database restore in this one as ConfigurationDeploymentSync discards Kernel::Config
#   and a new DB object will created (because of discard cascade) the new object will not be in
#   transaction mode
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Location = "$Home/Kernel/Config/Files/ZZZAAuto.pm";

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $UpdateFile = sub {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $Location,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    $Self->Is(
        ref $ContentSCALARRef,
        'SCALAR',
        "$Location FileRead() for UpdateFile() is SCALAR ref",
    );

    my $Content = ${ $ContentSCALARRef || \'' };

    if ( defined $Param{Value} ) {
        $Content =~ s{ (\{'CurrentDeploymentID'\} [ ] = [ ] ')\d+(') }{$1$Param{Value}$2}msx;
    }
    if ( defined $Param{Remove} ) {
        $Content =~ s{ (\{'CurrentDeploymentID)('\})  }{$1Invalid$2}msx;
    }

    my $FileLocation = $MainObject->FileWrite(
        Location => $Location,
        Content  => \$Content,
        Mode     => 'utf8',
    );

};

my $ReadDeploymentID = sub {
    my %Param = @_;

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $Location,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    $Self->Is(
        ref $ContentSCALARRef,
        'SCALAR',
        "$Location FileRead() for ReadDeploymentID() is SCALAR ref",
    );

    my $Content = ${$ContentSCALARRef};

    my $CurrentDeploymentID;
    if ( $Content =~ m{ \{'CurrentDeploymentID'\} [ ] = [ ] '(-?\d+)' }msx ) {
        $CurrentDeploymentID = $1;
    }

    return $CurrentDeploymentID;
};

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Check system, provide more visibility to unit tests.
$Self->True(
    -e "$Home/Kernel/Config/Files/ZZZAAuto.pm" ? 1 : 0,
    "ZZZAAUto.pm exists",
);
my @List = $SysConfigDBObject->DeploymentListGet();
$Self->IsNotDeeply(
    \@List,
    [],
    "Initial DeploymentListGet() is not empty",
);

my %LastDeployment   = $SysConfigDBObject->DeploymentGetLast();
my $LastDeploymentID = $LastDeployment{DeploymentID};

# Make sure deployment is in sync before tests.
my $Success = $SysConfigObject->ConfigurationDeploySync();
$Self->Is(
    $Success // 0,
    1,
    "Initial ConfigurationDeploymentSync() result",
);

my @Tests = (
    {
        Name   => 'Global No changes',
        Config => {
            Type => 'Global',
        },
        DeploymentIDBefore => $LastDeploymentID,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to 0',
        Config => {
            Value => 0,
            Type  => 'Global',
        },
        DeploymentIDBefore => 0,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to -1',
        Config => {
            Value => -1,
            Type  => 'Global',
        },
        DeploymentIDBefore => -1,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },

    {
        Name   => 'Global Set DeploymentID to empty',
        Config => {
            Value => '',
            Type  => 'Global',
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Remove DeploymentID',
        Config => {
            Remove => 1,
            Type   => 'Global',
        },
        DeploymentIDBefore => '',
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to be greater',
        Config => {
            Value => $LastDeploymentID + 1,
            Type  => 'Global',
        },
        DeploymentIDBefore => $LastDeploymentID + 1,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
    {
        Name   => 'Global Set DeploymentID to be latest from DB',
        Config => {
            Value => $LastDeploymentID,
            Type  => 'Global',
        },
        DeploymentIDBefore => $LastDeploymentID,
        DeploymentIDAfter  => $LastDeploymentID,
        Success            => 1,
    },
);

TEST:
for my $Test (@Tests) {
    $UpdateFile->( %{ $Test->{Config} } );

    my $FileDeploymentID = $ReadDeploymentID->( %{ $Test->{Config} } );
    $Self->Is(
        $FileDeploymentID // '',
        $Test->{DeploymentIDBefore},
        "$Test->{Name} DeploymentID before ConfigurationDeploymentSync()",
    );

    my $Success = $SysConfigObject->ConfigurationDeploySync();
    $Self->Is(
        $Success // 0,
        $Test->{Success},
        "$Test->{Name} ConfigurationDeploymentSync() result",
    );

    $FileDeploymentID = $ReadDeploymentID->( %{ $Test->{Config} } );
    $Self->Is(
        $FileDeploymentID,
        $Test->{DeploymentIDAfter},
        "$Test->{Name} DeploymentID after ConfigurationDeploymentSync()",
    );
}

$Success = $SysConfigObject->ConfigurationDeploySync();
$Self->Is(
    $Success // 0,
    1,
    "Finish ConfigurationDeploymentSync() result",
);

1;
