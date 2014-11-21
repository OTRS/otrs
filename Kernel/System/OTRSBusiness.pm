# --
# Kernel/System/OTRSBusiness.pm - OTRSBusiness deployment backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::OTRSBusiness;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CloudService',
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::SystemData',
    'Kernel::System::Time',
);

# If we cannot connect to cloud.otrs.com for more than the first period, show a warning.
my $NoConnectWarningPeriod = 60 * 60 * 24 * 5;    # 5 days

# If we cannot connect to cloud.otrs.com for more than the second period, show an error.
my $NoConnectErrorPeriod = 60 * 60 * 24 * 15;     # 15 days

# If the contract is about to expire in less than this time, show a hint
my $ContractExpiryWarningPeriod = 60 * 60 * 24 * 30;

=head1 NAME

Kernel::System::OTRSBusiness - OTRSBusiness deployment backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');


=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    #$Self->{APIVersion} = 1;

    # Get OTRSBusiness::ReleaseChannel from SysConfig (Stable = 1, Development = 0)
    $Self->{OnlyStable} = $Kernel::OM->Get('Kernel::Config')->Get('OTRSBusiness::ReleaseChannel') // 1;

    return $Self;
}

=item OTRSBusinessIsInstalled()

checks if OTRSBusiness is installed in the current system.
That does not necessarily mean that it is also active, for
example if the package is only on the database but not on
the file system.

=cut

sub OTRSBusinessIsInstalled {
    my ( $Self, %Param ) = @_;

    return $Self->_GetOTRSBusinessPackageFromRepository() ? 1 : 0;
}

=item OTRSBusinessIsAvailable()

checks with cloud.otrs.com if OTRSBusiness is available for the current framework.

=cut

sub OTRSBusinessIsAvailable {
    my ( $Self, %Param ) = @_;

    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');
    my $RequestResult      = $CloudServiceObject->Request(
        RequestData => {
            OTRSBusiness => [
                {
                    Operation => 'BusinessVersionCheck',
                    Data      => {
                        OnlyStable => $Self->{OnlyStable},
                    },
                },
            ],
        },
    );

    my $OperationResult;
    if ( IsHashRefWithData($RequestResult) ) {
        $OperationResult = $CloudServiceObject->OperationResultGet(
            RequestResult => $RequestResult,
            CloudService  => 'OTRSBusiness',
            Operation     => 'BusinessVersionCheck',
        );

        if ( $OperationResult->{Success} ) {
            $Self->HandleBusinessVersionCheckCloudServiceResult(
                OperationResult => $OperationResult,
            );

            if ( $OperationResult->{Data}->{LatestVersionForCurrentFramework} ) {
                return 1;
            }
        }
    }
    return;
}

=item OTRSBusinessIsAvailableOffline()

retrieves the latest result of the BusinessVersionCheck cloud service
that was stored in the system_data table.

returns 1 if available.

=cut

sub OTRSBusinessIsAvailableOffline {
    my ( $Self, %Param ) = @_;

    my %BusinessVersionCheck = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group => 'OTRSBusiness',
    );

    return $BusinessVersionCheck{LatestVersionForCurrentFramework} ? 1 : 0;
}

=item OTRSBusinessIsCorrectlyDeployed()

checks if the OTRSBusiness package is correctly
deployed or if it needs to be reinstalled.

=cut

sub OTRSBusinessIsCorrectlyDeployed {
    my ( $Self, %Param ) = @_;

    my $Package = $Self->_GetOTRSBusinessPackageFromRepository();

    # Package not found -> return failure
    return if !$Package;

    return $Kernel::OM->Get('Kernel::System::Package')->DeployCheck(
        Name    => $Package->{Name}->{Content},
        Version => $Package->{Version}->{Content},
    );
}

=item OTRSBusinessIsReinstallable()

checks if the OTRSBusiness package can be reinstalled
(if it supports the current framework version). If not,
an update might be needed.

=cut

sub OTRSBusinessIsReinstallable {
    my ( $Self, %Param ) = @_;

    my $Package = $Self->_GetOTRSBusinessPackageFromRepository();

    # Package not found -> return failure
    return if !$Package;

    return $Kernel::OM->Get('Kernel::System::Package')->_CheckFramework(
        Framework => $Package->{Framework},
    );
}

=item OTRSBusinessIsUpdateable()

checks with cloud.otrs.com if the OTRSBusiness package is available in a newer version
than the one currently installed. The result of this check will be stored in the
system_data table for offline usage.

=cut

sub OTRSBusinessIsUpdateable {
    my ( $Self, %Param ) = @_;

    my $Package = $Self->_GetOTRSBusinessPackageFromRepository();
    return if !$Package;

    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');
    my $RequestResult      = $CloudServiceObject->Request(
        RequestData => {
            OTRSBusiness => [
                {
                    Operation => 'BusinessVersionCheck',
                    Data      => {
                        OnlyStable => $Self->{OnlyStable},
                    },
                },
            ],
        },
    );

    my $OperationResult;
    if ( IsHashRefWithData($RequestResult) ) {
        $OperationResult = $CloudServiceObject->OperationResultGet(
            RequestResult => $RequestResult,
            CloudService  => 'OTRSBusiness',
            Operation     => 'BusinessVersionCheck',
        );

        if ( $OperationResult && $OperationResult->{Success} ) {

            $Self->HandleBusinessVersionCheckCloudServiceResult( OperationResult => $OperationResult );

            if ( $OperationResult->{Data}->{LatestVersionForCurrentFramework} ) {
                return $Kernel::OM->Get('Kernel::System::Package')->_CheckVersion(
                    VersionNew       => $OperationResult->{Data}->{LatestVersionForCurrentFramework},
                    VersionInstalled => $Package->{Version}->{Content},
                    Type             => 'Max',
                );
            }
        }
    }

    return 0;
}

=item OTRSBusinessVersionCheckOffline()

retrieves the latest result of the BusinessVersionCheck cloud service
that was stored in the system_data table.

    my %Result = $OTRSBusinessObject->OTRSBusinessVersionCheckOffline();

returns

    $Result = (
        OTRSBusinessUpdateAvailable      => 1,  # if applicable
        FrameworkUpdateAvailable         => 1,  # if applicable
    );

=cut

sub OTRSBusinessVersionCheckOffline {
    my ( $Self, %Param ) = @_;

    my $Package = $Self->_GetOTRSBusinessPackageFromRepository();
    return if !$Package;

    my %EntitlementData = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group => 'OTRSBusiness',
    );

    my %Result = (
        FrameworkUpdateAvailable => $EntitlementData{FrameworkUpdateAvailable} // '',
    );

    if ( $EntitlementData{LatestVersionForCurrentFramework} ) {
        $Result{OTRSBusinessUpdateAvailable} = $Kernel::OM->Get('Kernel::System::Package')->_CheckVersion(
            VersionNew       => $EntitlementData{LatestVersionForCurrentFramework},
            VersionInstalled => $Package->{Version}->{Content},
            Type             => 'Max',
        );
    }

    return %Result;
}

=item OTRSBusinessGetDependencies()

checks if there are any active dependencies on OTRSBusiness.

=cut

sub OTRSBusinessGetDependencies {
    my ( $Self, %Param ) = @_;

    my @Packages = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList();

    my @DependentPackages;
    for my $Package (@Packages) {
        my $Dependencies = $Package->{PackageRequired} // [];
        for my $Dependency ( @{$Dependencies} ) {
            if ( $Dependency->{Content} eq 'OTRSBusiness' ) {
                push @DependentPackages, {
                    Name        => $Package->{Name}->{Content},
                    Vendor      => $Package->{Vendor}->{Content},
                    Version     => $Package->{Version}->{Content},
                    Description => $Package->{Description},
                };
            }
        }
    }
    return \@DependentPackages;
}

=item OTRSBusinessEntitlementCheck()

determines the OTRSBusiness entitlement status of this system as reported by cloud.otrs.com
and stores it in the system_data cache.

Returns 1 if the cloud call was successful.

=cut

sub OTRSBusinessEntitlementCheck {
    my ( $Self, %Param ) = @_;

    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');
    my $RequestResult      = $CloudServiceObject->Request(
        RequestData => {
            OTRSBusiness => [
                {
                    Operation => 'BusinessPermission',
                    Data      => {},
                },
            ],
        },
    );

    my $OperationResult;
    if ( IsHashRefWithData($RequestResult) ) {
        $OperationResult = $CloudServiceObject->OperationResultGet(
            RequestResult => $RequestResult,
            CloudService  => 'OTRSBusiness',
            Operation     => 'BusinessPermission',
        );
    }

    # OK, so we got a successful cloud call result. Then we will use it and remember it.
    if ( IsHashRefWithData($OperationResult) && $OperationResult->{Success} ) {

        # Store it in the SystemData so that it is also available for the notification modules,
        #   even before the first run of RegistrationUpdate.
        $Self->HandleBusinessPermissionCloudServiceResult(
            OperationResult => $OperationResult,
        );
        return 1;
    }

    if ( !IsHashRefWithData($RequestResult) || !$RequestResult->{Success} ) {
        my $Message = "BusinessPermission - Can't contact cloud.otrs.com server";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message
        );
    }

    if ( !IsHashRefWithData($OperationResult) || !$OperationResult->{Success} ) {
        my $Message = "BusinessPermission - could not perform BusinessPermission check";
        if ( IsHashRefWithData($OperationResult) ) {
            $Message .= $OperationResult->{ErrorMessage};
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message
        );
    }

    return 0;
}

=item OTRSBusinessEntitlementStatus()

Returns the current entitlement status.

    my $Status = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
        CallCloudService => 1,  # 0 or 1, call the cloud service before looking at the cache
    );

    $Status = 'entitled';   # everything is OK
    $Status = 'warning';    # last check was OK, and we are in the waiting period
    $Status = 'forbidden';  # not entitled

=cut

sub OTRSBusinessEntitlementStatus {
    my ( $Self, %Param ) = @_;

    if ( $Param{CallCloudService} ) {
        $Self->OTRSBusinessEntitlementCheck();
    }

    # If the system is not registered, it cannot have an OB permission.
    #   Also, the BusinessPermissionChecks will not work any more, so the permission
    #   would expire after our waiting period. But in this case we can immediately deny
    #   the permission.
    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    );
    if ( !$RegistrationState || $RegistrationState ne 'registered' ) {
        return 'forbidden';
    }

    # OK. Let's look at the system_data cache now and use it if appropriate
    my %EntitlementData = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group => 'OTRSBusiness',
    );

    if ( !%EntitlementData || !$EntitlementData{BusinessPermission} ) {
        return 'forbidden';
    }

    my $LastUpdateSystemTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
        String => $EntitlementData{LastUpdateTime},
    );

    my $SecondsSinceLastUpdate = $Kernel::OM->Get('Kernel::System::Time')->SystemTime() - $LastUpdateSystemTime;

    if ( $SecondsSinceLastUpdate > $NoConnectErrorPeriod ) {
        return 'forbidden';
    }
    if ( $SecondsSinceLastUpdate > $NoConnectWarningPeriod ) {
        return 'warning';
    }

    return 'entitled';
}

=item OTRSBusinessContractExpiryDateCheck()

checks for the warning period before the contract expires

    my $ExpiryDate = $OTRSBusinessObject->OTRSBusinessContractExpiryDateCheck();

returns the ExpiryDate if a warning should be displayed

    $ExpiryDate = undef;                    # everything is OK, no warning
    $ExpiryDate = '2012-12-12 12:12:12'     # contract is about to expire, issue warning

=cut

sub OTRSBusinessContractExpiryDateCheck {
    my ( $Self, %Param ) = @_;

    if ( $Param{CallCloudService} ) {
        $Self->OTRSBusinessEntitlementCheck();
    }

    # OK. Let's look at the system_data cache now and use it if appropriate
    my %EntitlementData = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group => 'OTRSBusiness',
    );

    if ( !%EntitlementData || !$EntitlementData{ExpiryDate} ) {
        return;
    }

    my $ExpiryDateSystemTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
        String => $EntitlementData{ExpiryDate},
    );

    my $SecondsUntilExpiryDate = $ExpiryDateSystemTime - $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    if ( $SecondsUntilExpiryDate < $ContractExpiryWarningPeriod ) {
        return $EntitlementData{ExpiryDate};
    }

    return;
}

sub HandleBusinessPermissionCloudServiceResult {
    my ( $Self, %Param ) = @_;

    my $OperationResult = $Param{OperationResult};

    return if !$OperationResult->{Success};

    my %StoreData = (
        BusinessPermission => $OperationResult->{Data}->{BusinessPermission} // 0,
        ExpiryDate         => $OperationResult->{Data}->{ExpiryDate}         // '',
        LastUpdateTime     => $Kernel::OM->Get('Kernel::System::Time')->SystemTime2TimeStamp(
            SystemTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime()
        ),
    );

    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    for my $Key ( sort keys %StoreData ) {
        my $FullKey = 'OTRSBusiness::' . $Key;

        if ( defined $SystemDataObject->SystemDataGet( Key => $FullKey ) ) {
            $SystemDataObject->SystemDataUpdate(
                Key    => $FullKey,
                Value  => $StoreData{$Key},
                UserID => 1,
            );
        }
        else {
            $SystemDataObject->SystemDataAdd(
                Key    => $FullKey,
                Value  => $StoreData{$Key},
                UserID => 1,
            );
        }
    }

    return 1;
}

sub HandleBusinessVersionCheckCloudServiceResult {
    my ( $Self, %Param ) = @_;

    my $OperationResult = $Param{OperationResult};

    return if !$OperationResult->{Success};

    my %StoreData = (
        LatestVersionForCurrentFramework => $OperationResult->{Data}->{LatestVersionForCurrentFramework} // '',
        FrameworkUpdateAvailable         => $OperationResult->{Data}->{FrameworkUpdateAvailable}         // '',
    );

    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    for my $Key ( sort keys %StoreData ) {
        my $FullKey = 'OTRSBusiness::' . $Key;

        if ( defined $SystemDataObject->SystemDataGet( Key => $FullKey ) ) {
            $SystemDataObject->SystemDataUpdate(
                Key    => $FullKey,
                Value  => $StoreData{$Key},
                UserID => 1,
            );
        }
        else {
            $SystemDataObject->SystemDataAdd(
                Key    => $FullKey,
                Value  => $StoreData{$Key},
                UserID => 1,
            );
        }
    }

    return 1;
}

sub _OTRSBusinessFileGet {
    my ( $Self, %Param ) = @_;

    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');
    my $RequestResult      = $CloudServiceObject->Request(
        RequestData => {
            OTRSBusiness => [
                {
                    Operation => 'BusinessFileGet',
                    Data      => {
                        OnlyStable => $Self->{OnlyStable},
                    },
                },
            ],
        },
    );

    my $OperationResult;
    if ( IsHashRefWithData($RequestResult) ) {
        $OperationResult = $CloudServiceObject->OperationResultGet(
            RequestResult => $RequestResult,
            CloudService  => 'OTRSBusiness',
            Operation     => 'BusinessFileGet',
        );

        if ( $OperationResult->{Success} && $OperationResult->{Data}->{Package} ) {
            return $OperationResult->{Data}->{Package};
        }
    }

    return;
}

=item OTRSBusinessInstall()

downloads and installs OTRSBusiness.

=cut

sub OTRSBusinessInstall {
    my ( $Self, %Param ) = @_;

    my $PackageString = $Self->_OTRSBusinessFileGet();
    return if !$PackageString;

    return $Kernel::OM->Get('Kernel::System::Package')->PackageInstall(
        String    => $PackageString,
        FromCloud => 1,
    );
}

=item OTRSBusinessReinstall()

reinstalls OTRSBusiness from local repository.

=cut

sub OTRSBusinessReinstall {
    my ( $Self, %Param ) = @_;

    my $Package = $Self->_GetOTRSBusinessPackageFromRepository();

    # Package not found -> return failure
    return if !$Package;

    my $PackageString = $Kernel::OM->Get('Kernel::System::Package')->RepositoryGet(
        Name    => $Package->{Name}->{Content},
        Version => $Package->{Version}->{Content},
    );

    return $Kernel::OM->Get('Kernel::System::Package')->PackageReinstall(
        String => $PackageString,
    );
}

=item OTRSBusinessUpdate()

downloads and updates OTRSBusiness.

=cut

sub OTRSBusinessUpdate {
    my ( $Self, %Param ) = @_;

    my $PackageString = $Self->_OTRSBusinessFileGet();
    return if !$PackageString;

    return $Kernel::OM->Get('Kernel::System::Package')->PackageUpgrade(
        String    => $PackageString,
        FromCloud => 1,
    );
}

=item OTRSBusinessUninstall()

removes OTRSBusiness from the system.

=cut

sub OTRSBusinessUninstall {
    my ( $Self, %Param ) = @_;

    my $Package = $Self->_GetOTRSBusinessPackageFromRepository();

    # Package not found -> return failure
    return if !$Package;

    my $PackageString = $Kernel::OM->Get('Kernel::System::Package')->RepositoryGet(
        Name    => $Package->{Name}->{Content},
        Version => $Package->{Version}->{Content},
    );

    return $Kernel::OM->Get('Kernel::System::Package')->PackageUninstall(
        String => $PackageString,
    );
}

sub _GetOTRSBusinessPackageFromRepository {
    my ( $Self, %Param ) = @_;

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my @RepositoryList = $PackageObject->RepositoryList();

    for my $Package (@RepositoryList) {
        return $Package if $Package->{Name}->{Content} eq 'OTRSBusiness';
    }

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
