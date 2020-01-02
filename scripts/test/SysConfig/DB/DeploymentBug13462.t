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

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $CacheType = 'UnitTestTicketCounter';

my $ChildCount = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::TicketCreateNumber::ChildCount') || 5;

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my $TestUserLogin1 = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
) || die "Did not get test user";
my $TestUserID1 = $UserObject->UserLookup(
    UserLogin => $TestUserLogin1,
);
my $TestUserLogin2 = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
) || die "Did not get test user";
my $TestUserID2 = $UserObject->UserLookup(
    UserLogin => $TestUserLogin2,
);
my $TestUserLogin3 = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
) || die "Did not get test user";
my $TestUserID3 = $UserObject->UserLookup(
    UserLogin => $TestUserLogin3,
);

my $FileBase = << 'EOF';
# OTRS config file (automatically generated)
# VERSION:2.0
package Kernel::Config::Files::User::0;
use strict;
use warnings;
no warnings 'redefine'; ## no critic
use utf8;
 sub Load {
    my ($File, $Self) = @_;
$Self->{'Ticket::Frontend::AgentTicketQueue'}->{'Blink'} =  '1';
    return;
}
1;
EOF

for my $TargetUserID ( $TestUserID1, $TestUserID2, $TestUserID3 ) {

    my $UserFile = $FileBase;
    $UserFile =~ s{0}{$TargetUserID}gmxi;

    for my $ChildIndex ( 1 .. $ChildCount ) {

        # Disconnect database before fork.
        $DBObject->Disconnect();

        # Create a fork of the current process
        #   parent gets the PID of the child
        #   child gets PID = 0
        my $PID = fork;
        if ( !$PID ) {

            # Destroy objects.
            $Kernel::OM->ObjectsDiscard();

            my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

            my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
                Comments            => 'Some Comments',
                EffectiveValueStrg  => \$UserFile,
                TargetUserID        => $TargetUserID,
                DeploymentTimeStamp => '1977-12-12 12:00:00',
                UserID              => 1,
            );

            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $CacheType,
                Key   => "${TargetUserID}::${ChildIndex}",
                Value => {
                    DeploymentID => $DeploymentID,

                    #TicketID     => $TicketID,
                },
                TTL => 60 * 10,
            );

            exit 0;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my %ChildData;

    my $Wait = 1;
    while ($Wait) {
        CHILDINDEX:
        for my $ChildIndex ( 1 .. $ChildCount ) {

            next CHILDINDEX if $ChildData{$ChildIndex};

            my $Cache = $CacheObject->Get(
                Type => $CacheType,
                Key  => "${TargetUserID}::${ChildIndex}",
            );

            next CHILDINDEX if !$Cache;
            next CHILDINDEX if ref $Cache ne 'HASH';

            $ChildData{$ChildIndex} = $Cache;
        }
    }
    continue {
        my $GotDataCount = scalar keys %ChildData;
        if ( $GotDataCount == $ChildCount ) {
            $Wait = 0;
        }
        sleep 1;
    }

    my %DeploymentIDs;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    CHILDINDEX:
    for my $ChildIndex ( 1 .. $ChildCount ) {

        my %Data = %{ $ChildData{$ChildIndex} };
        next CHILDINDEX if !$Data{DeploymentID};

        $Self->Is(
            $DeploymentIDs{ $Data{DeploymentID} } || 0,
            0,
            "DeploymentID from child $ChildIndex '$Data{DeploymentID}' with $TargetUserID assigned multiple times",
        );

        $DeploymentIDs{ $Data{DeploymentID} } = 1;

        my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentDelete(
            DeploymentID => $Data{DeploymentID},
            UserID       => 1,
        );

        $Self->True(
            $Success,
            "DeploymentDelete for $Data{DeploymentID}",
        );
    }
    $CacheObject->CleanUp(
        Type => $CacheType,
    );
}

1;
