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

# get cloud service object
my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Configuration');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my @Tests = (
    {
        Name          => 'test 1',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'SMSCloudService',
                Description => 'Cloud Service for sending SMS requests.',
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config => {
                Name        => 'SMSCloudServiceUpdate',
                Description => 'Cloud Service Update for sending SMS requests.',
            },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 2',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'SMSCloudService',
                Description => '!"§$%&/()=?Ü*ÄÖL:L@,.-.',
            },
            ValidID => 2,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 3',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => { 1 => 1 },
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 4',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'SMSCloudService',
                Description => 'Cloud Service for sending SMS requests 2.'
                    . "\nasdkaosdkoa\tsada\n",
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the name must be 'test 4', because the purpose if that it fails on
    {
        Name          => 'test 4',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'SMSCloudService',
                Description => 'Cloud Service for sending SMS requests 2.',
            },
            ValidID => 2,
            UserID  => 1,
        },
        Update => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 5 - Invalid Config Add (Undef)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config  => undef,
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 6 - Invalid Config Add (String)',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config  => 'Something',
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 7 - Invalid Config Update (string Config)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Description => 'Cloud Service for sending SMS requests 2.',
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => 'string',
            ValidID => 1,
            UserID  => 1,
        },
    },
    {
        Name          => 'test 8 - Invalid Config Update (empty Config)',
        SuccessAdd    => 1,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Description => 'Cloud Service for sending SMS requests 2.',
            },
            ValidID => 1,
            UserID  => 1,
        },
        Update => {
            Config  => {},
            ValidID => 1,
            UserID  => 1,
        },
    },
);

my @CloudServiceIDs;
TEST:
for my $Test (@Tests) {

    # add config
    my $CloudServiceID = $CloudServiceObject->CloudServiceAdd(
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Add} }
    );
    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $CloudServiceID,
            "$Test->{Name} - CloudServiceAdd()",
        );
        next TEST;
    }
    else {
        $Self->True(
            $CloudServiceID,
            "$Test->{Name} - CloudServiceAdd()",
        );
    }

    # remember id to delete it later
    push @CloudServiceIDs, $CloudServiceID;

    # get config
    my $CloudService = $CloudServiceObject->CloudServiceGet(
        ID => $CloudServiceID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $CloudService->{Name},
        "$Test->{Name} - CloudServiceGet()",
    );
    $Self->IsDeeply(
        $CloudService->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - CloudServiceGet() - Config",
    );

    my $CloudServiceByName = $CloudServiceObject->CloudServiceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$CloudServiceByName,
        \$CloudService,
        "$Test->{Name} - CloudServiceGet() with Name parameter result",
    );

    # get config from cache
    my $CloudServiceFromCache = $CloudServiceObject->CloudServiceGet(
        ID => $CloudServiceID,
    );

    # verify config from cache
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $CloudServiceFromCache->{Name},
        "$Test->{Name} - CloudServiceGet() from cache",
    );
    $Self->IsDeeply(
        $CloudServiceFromCache->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - CloudServiceGet() from cache- Config",
    );

    $Self->IsDeeply(
        $CloudService,
        $CloudServiceFromCache,
        "$Test->{Name} - CloudServiceGet() - Cache and DB",
    );

    my $CloudServiceByNameFromCache = $CloudServiceObject->CloudServiceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$CloudServiceByNameFromCache,
        \$CloudServiceFromCache,
        "$Test->{Name} - CloudServiceGet() with Name parameter result from cache",
    );

    # update config with a modification
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }
    my $Success = $CloudServiceObject->CloudServiceUpdate(
        ID   => $CloudServiceID,
        Name => $Test->{Name} . ' ' . $RandomID,
        %{ $Test->{Update} }
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $Success,
            "$Test->{Name} - CloudServiceUpdate() False",
        );
        next TEST;
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} - CloudServiceUpdate() True",
        );
    }

    # get config
    $CloudService = $CloudServiceObject->CloudServiceGet(
        ID     => $CloudServiceID,
        UserID => 1,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . ' ' . $RandomID,
        $CloudService->{Name},
        "$Test->{Name} - CloudServiceGet()",
    );
    $Self->IsDeeply(
        $CloudService->{Config},
        $Test->{Update}->{Config},
        "$Test->{Name} - CloudServiceGet() - Config",
    );

    $CloudServiceByName = $CloudServiceObject->CloudServiceGet(
        Name => $Test->{Name} . ' ' . $RandomID,
    );

    $Self->IsDeeply(
        \$CloudServiceByName,
        \$CloudService,
        "$Test->{Name} - CloudServiceGet() with Name parameter result",
    );

    # verify if cache was also updated
    if ( $Test->{SuccessUpdate} ) {
        my $CloudServiceUpdateFromCache = $CloudServiceObject->CloudServiceGet(
            ID     => $CloudServiceID,
            UserID => 1,
        );

        # verify config from cache
        $Self->Is(
            $Test->{Name} . ' ' . $RandomID,
            $CloudServiceUpdateFromCache->{Name},
            "$Test->{Name} - CloudServiceGet() from cache",
        );
        $Self->IsDeeply(
            $CloudServiceUpdateFromCache->{Config},
            $Test->{Update}->{Config},
            "$Test->{Name} - CloudServiceGet() from cache- Config",
        );
    }
}

# list check from DB
my $CloudServiceList = $CloudServiceObject->CloudServiceList( Valid => 0 );
for my $CloudServiceID (@CloudServiceIDs) {
    $Self->True(
        scalar $CloudServiceList->{$CloudServiceID},
        "CloudServiceList() from DB found CloudService $CloudServiceID",
    );

}

# list check from cache
$CloudServiceList = $CloudServiceObject->CloudServiceList( Valid => 0 );
for my $CloudServiceID (@CloudServiceIDs) {
    $Self->True(
        scalar $CloudServiceList->{$CloudServiceID},
        "CloudServiceList() from Cache found CloudService $CloudServiceID",
    );
}

# delete config
for my $CloudServiceID (@CloudServiceIDs) {
    my $Success = $CloudServiceObject->CloudServiceDelete(
        ID     => $CloudServiceID,
        UserID => 1,
    );
    $Self->True(
        $Success,
        "CloudServiceDelete() deleted CloudService $CloudServiceID",
    );
    $Success = $CloudServiceObject->CloudServiceDelete(
        ID     => $CloudServiceID,
        UserID => 1,
    );
    $Self->False(
        $Success,
        "CloudServiceDelete() deleted CloudService $CloudServiceID",
    );
}

# list check from DB
$CloudServiceList = $CloudServiceObject->CloudServiceList( Valid => 0 );
for my $CloudServiceID (@CloudServiceIDs) {
    $Self->False(
        scalar $CloudServiceList->{$CloudServiceID},
        "CloudServiceList() did not find cloud service $CloudServiceID",
    );
}

# list check from cache
$CloudServiceList = $CloudServiceObject->CloudServiceList( Valid => 0 );
for my $CloudServiceID (@CloudServiceIDs) {
    $Self->False(
        scalar $CloudServiceList->{$CloudServiceID},
        "CloudServiceList() from cache did not find cloud service $CloudServiceID",
    );
}

# cleanup done by RestoreDatabase

1;
