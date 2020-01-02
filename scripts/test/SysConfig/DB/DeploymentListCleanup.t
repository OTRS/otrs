# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        #RestoreDatabase => 1
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $DeploymentAdd = sub {
    my %Param = @_;

    my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

    return if !$DBObject->Do(
        SQL => '
                INSERT INTO sysconfig_deployment
                    (comments, effective_value, create_time, create_by)
                VALUES
                    (?, ?, ?, ?)',
        Bind => [
            \$Param{Comments}, \$Param{EffectiveValueStrg}, \$TimeStamp, \$Param{UserID},
        ],
    );

    # Get deployment ID.
    return if !$DBObject->Prepare(
        SQL => "
            SELECT id
            FROM sysconfig_deployment
            WHERE create_by = ?
                AND comments = ?
                AND user_id IS NULL
            ORDER BY id DESC",
        Bind  => [ \$Param{UserID}, \$Param{Comments} ],
        Limit => 1,
    );

    # Fetch the deployment ID.
    my $DeploymentID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DeploymentID = $Row[0];
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentUserList',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentList',
    );
    $CacheObject->Delete(
        Type => 'SysConfigDeployment',
        Key  => 'DeploymentGetLast',
    );

    return $DeploymentID;
};

my $DeploymentExists = sub {
    my %Param = @_;

    my $DeploymentID;
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM sysconfig_deployment
            WHERE id =?',
        Bind => [ \$Param{DeploymentID} ],
    );

    my @DeploymentID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DeploymentID = $Row[0];
    }

    return if !$DeploymentID;

    return 1;
};

my @Tests = (
    {
        Name => 'Invalid Deployment Old style',
        Add  => {
            Comments           => 'Comments',
            EffectiveValueStrg => 'Invalid',
            UserID             => 1,
        },
    },
    {
        Name => 'Invalid Deployment New style',
        Add  => {
            Comments           => 'OTRSInvalid-123',
            EffectiveValueStrg => 'Some content',
            UserID             => 1,
        },
    },
);

$Helper->FixedTimeSet();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

for my $Test (@Tests) {

    my $DeploymentID = $DeploymentAdd->( %{ $Test->{Add} } );
    $Self->True(
        $DeploymentID,
        "DeploymentID $DeploymentID is added",
    );

    my $Success = $SysConfigDBObject->DeploymentListCleanup();
    $Self->True(
        $Success,
        "$Test->{Name} DeploymentListCleanup() immediately",
    );

    my $Exists = $DeploymentExists->( DeploymentID => $DeploymentID );
    $Self->True(
        $Exists,
        "$Test->{Name} Deployment exists after DeploymentListCleanup() immediately",
    );

    $Helper->FixedTimeAddSeconds(21);

    $Success = $SysConfigDBObject->DeploymentListCleanup();
    $Self->True(
        $Success,
        "$Test->{Name} DeploymentListCleanup() after 21 secs",
    );

    $Exists = $DeploymentExists->( DeploymentID => $DeploymentID );
    $Self->False(
        $Exists,
        "$Test->{Name} Deployment exists after DeploymentListCleanup() after 21 secs with false",
    );
}

1;
