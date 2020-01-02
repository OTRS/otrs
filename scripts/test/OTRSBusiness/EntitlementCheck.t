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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users', ],
);
my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::Output::HTML::Notification::AgentOTRSBusiness' => {
        UserID => $UserID,
    },
    'Kernel::Output::HTML::Notification::CustomerOTRSBusiness' => {
        UserID => $UserID,
    },
);
my $AgentNotificationObject    = $Kernel::OM->Get('Kernel::Output::HTML::Notification::AgentOTRSBusiness');
my $CustomerNotificationObject = $Kernel::OM->Get('Kernel::Output::HTML::Notification::CustomerOTRSBusiness');
my $SystemDataObject           = $Kernel::OM->Get('Kernel::System::SystemData');

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name                         => 'OB not installed',
        CurrentTime                  => '2016-09-30 12:00:00',
        OTRSBusinessIsInstalled      => 0,
        SystemData                   => {},
        AgentNotificationResultAgent => '',
        AgentNotificationResultAdmin => '<!-- start Notify -->
<div class="MessageBox Info">
    <p>
            <a href="No-$ENV{"SCRIPT_NAME"}?Action=AdminOTRSBusiness"> Upgrade to <b>OTRS Business Solution</b>™ now! </a>
    </p>
</div>
<!-- end Notify -->
',
        CustomerNotificationResult => '',
    },
    {
        Name                    => 'OB installed, everything ok',
        CurrentTime             => '2016-09-30 12:00:00',
        OTRSBusinessIsInstalled => 1,
        SystemData              => {
            'OTRSBusiness::ExpiryDate'                       => '2016-10-30 12:00:00',
            'OTRSBusiness::LastUpdateTime'                   => '2016-09-30 12:00:00',
            'OTRSBusiness::BusinessPermission'               => '1',
            'OTRSBusiness::FrameworkUpdateAvailable'         => '0',
            'OTRSBusiness::LatestVersionForCurrentFramework' => '0.0.0',
            'Registration::State'                            => 'registered',
        },
        AgentNotificationResultAgent => '',
        AgentNotificationResultAdmin => '',
        CustomerNotificationResult   => '',
    },
    {
        Name                    => 'OB installed, expiry warning',
        CurrentTime             => '2016-09-30 12:00:00',
        OTRSBusinessIsInstalled => 1,
        SystemData              => {
            'OTRSBusiness::ExpiryDate'                       => '2016-10-10 12:00:00',
            'OTRSBusiness::LastUpdateTime'                   => '2016-09-30 12:00:00',
            'OTRSBusiness::BusinessPermission'               => '1',
            'OTRSBusiness::FrameworkUpdateAvailable'         => '0',
            'OTRSBusiness::LatestVersionForCurrentFramework' => '0.0.0',
            'Registration::State'                            => 'registered',
        },
        AgentNotificationResultAgent => '',
        AgentNotificationResultAdmin => '<!-- start Notify -->
<div class="MessageBox Notice">
    <p>
            The license for your <b>OTRS Business Solution</b>™ is about to expire. Please make contact with sales@otrs.com to renew your contract!
    </p>
</div>
<!-- end Notify -->
',
        CustomerNotificationResult => '',
    },
    {
        Name                    => 'OB installed, LastUpdateTime outdated, show warning',
        CurrentTime             => '2016-09-30 12:00:00',
        OTRSBusinessIsInstalled => 1,
        SystemData              => {
            'OTRSBusiness::ExpiryDate'                       => '2016-10-30 12:00:00',
            'OTRSBusiness::LastUpdateTime'                   => '2016-09-20 12:00:00',
            'OTRSBusiness::BusinessPermission'               => '1',
            'OTRSBusiness::FrameworkUpdateAvailable'         => '0',
            'OTRSBusiness::LatestVersionForCurrentFramework' => '0.0.0',
            'Registration::State'                            => 'registered',
        },
        AgentNotificationResultAgent => '',
        AgentNotificationResultAdmin => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.
    </p>
</div>
<!-- end Notify -->
',
        CustomerNotificationResult => '',
    },
    {
        Name                    => 'OB installed, LastUpdateTime outdated, show error',
        CurrentTime             => '2016-09-30 12:00:00',
        OTRSBusinessIsInstalled => 1,
        SystemData              => {
            'OTRSBusiness::ExpiryDate'                       => '2016-10-30 12:00:00',
            'OTRSBusiness::LastUpdateTime'                   => '2016-09-10 12:00:00',
            'OTRSBusiness::BusinessPermission'               => '1',
            'OTRSBusiness::FrameworkUpdateAvailable'         => '0',
            'OTRSBusiness::LatestVersionForCurrentFramework' => '0.0.0',
            'Registration::State'                            => 'registered',
        },
        AgentNotificationResultAgent => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            This system uses the <b>OTRS Business Solution</b>™ without a proper license! Please make contact with sales@otrs.com to renew or activate your contract!
    </p>
</div>
<!-- end Notify -->
',
        AgentNotificationResultAdmin => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            This system uses the <b>OTRS Business Solution</b>™ without a proper license! Please make contact with sales@otrs.com to renew or activate your contract!
    </p>
</div>
<!-- end Notify -->
',
        CustomerNotificationResult => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            This system uses the <b>OTRS Business Solution</b>™ without a proper license! Please make contact with sales@otrs.com to renew or activate your contract!
    </p>
</div>
<!-- end Notify -->
',
    },
    {
        Name                    => 'OB installed, LastUpdateTime outdated, block system',
        CurrentTime             => '2016-09-30 12:00:00',
        OTRSBusinessIsInstalled => 1,
        SystemData              => {
            'OTRSBusiness::ExpiryDate'                       => '2016-10-30 12:00:00',
            'OTRSBusiness::LastUpdateTime'                   => '2016-09-01 12:00:00',
            'OTRSBusiness::BusinessPermission'               => '1',
            'OTRSBusiness::FrameworkUpdateAvailable'         => '0',
            'OTRSBusiness::LatestVersionForCurrentFramework' => '0.0.0',
            'Registration::State'                            => 'registered',
        },
        AgentNotificationResultAgent => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            This system uses the <b>OTRS Business Solution</b>™ without a proper license! Please make contact with sales@otrs.com to renew or activate your contract!
<script>
if (!window.location.search.match(/^[?]Action=(AgentOTRSBusiness|Admin.*)/)) {
    window.location.search = "Action=AgentOTRSBusiness;Subaction=BlockScreen";
}
</script>
    </p>
</div>
<!-- end Notify -->
',
        AgentNotificationResultAdmin => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            This system uses the <b>OTRS Business Solution</b>™ without a proper license! Please make contact with sales@otrs.com to renew or activate your contract!
<script>
if (!window.location.search.match(/^[?]Action=(AgentOTRSBusiness|Admin.*)/)) {
    window.location.search = "Action=AgentOTRSBusiness;Subaction=BlockScreen";
}
</script>
    </p>
</div>
<!-- end Notify -->
',
        CustomerNotificationResult => '<!-- start Notify -->
<div class="MessageBox Error">
    <p>
            This system uses the <b>OTRS Business Solution</b>™ without a proper license! Please make contact with sales@otrs.com to renew or activate your contract!
    </p>
</div>
<!-- end Notify -->
',
    },
);

for my $Test (@Tests) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{CurrentTime},
        }
    );
    my $SystemTime = $DateTimeObject->ToEpoch();

    $Helper->FixedTimeSet($SystemTime);

    use Kernel::System::OTRSBusiness;

    no warnings 'redefine';    ## no critic

    local *Kernel::System::OTRSBusiness::OTRSBusinessIsInstalled = sub {
        return $Test->{OTRSBusinessIsInstalled};
    };

    for my $Key ( sort keys %{ $Test->{SystemData} } ) {
        $SystemDataObject->SystemDataDelete(
            Key    => $Key,
            UserID => 1,
        );
        $SystemDataObject->SystemDataAdd(
            Key    => $Key,
            Value  => $Test->{SystemData}->{$Key},
            UserID => 1,
        );
    }

    $Self->Is(
        scalar $AgentNotificationObject->Run(
            Type => 'Admin',
        ),
        $Test->{AgentNotificationResultAdmin},
        "$Test->{Name} - admin notification result",
    );

    my $OldPermissionCheck = \&Kernel::System::Group::PermissionCheck;

    # Pretend user is not a member of the admin group;
    use Kernel::System::Group;
    local *Kernel::System::Group::PermissionCheck = sub {
        my ( $Self, %Param ) = @_;
        if ( $Param{GroupName} eq 'admin' ) {
            return 0;
        }
        return $OldPermissionCheck->(@_);
    };

    $Self->Is(
        scalar $AgentNotificationObject->Run(
            Type => 'Agent',
        ),
        $Test->{AgentNotificationResultAgent},
        "$Test->{Name} - agent notification result",
    );

    $Self->Is(
        scalar $CustomerNotificationObject->Run(),
        $Test->{CustomerNotificationResult},
        "$Test->{Name} - customer notification result",
    );
}

# Cleanup is done by RestoreDatabase.

1;
