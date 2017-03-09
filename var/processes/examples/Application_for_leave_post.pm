# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::processes::examples::Application_for_leave_post;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Response = (
        Success => 1,
    );

    my @Data = (
        {
            'Ticket::Frontend::AgentTicketZoom' => {
                'ProcessWidgetDynamicFieldGroups' => {
                    'Application for Leave - Approval and HR data' =>
                        'PreProcApprovedSuperior,PreProcApplicationRecorded,PreProcVacationInfo',
                    'Application for Leave - Request Data' =>
                        'PreProcVacationStart,PreProcVacationEnd,PreProcDaysUsed,PreProcDaysRemaining,' .
                        'PreProcEmergencyTelephone,PreProcRepresentationBy',
                },
                'ProcessWidgetDynamicField' => {
                    'PreProcApplicationRecorded' => '1',
                    'PreProcDaysRemaining'       => '1',
                    'PreProcVacationStart'       => '1',
                    'PreProcVacationEnd'         => '1',
                    'PreProcDaysUsed'            => '1',
                    'PreProcEmergencyTelephone'  => '1',

                    # 'PreProcRepresentationBy'     => '1',
                    # 'PreProcProcessStatus'        => '1',
                    'PreProcApprovedSuperior' => '1',
                    'PreProcVacationInfo'     => '1',
                },
            },
        }
    );

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @UpdatedSettings;

    for my $Item (@Data) {
        my $ItemName     = ( keys %{$Item} )[0];
        my $CurrentValue = $ConfigObject->Get($ItemName);

        for my $Key ( sort keys %{ $Item->{$ItemName} } ) {

            for my $InnerKey ( sort keys %{ $Item->{$ItemName}->{$Key} } ) {

                my $Value = $Item->{$ItemName}->{$Key}->{$InnerKey};

                if (
                    !$CurrentValue->{$Key}->{$InnerKey}
                    || $CurrentValue->{$Key}->{$InnerKey} ne $Value
                    )
                {
                    $CurrentValue->{$Key}->{$InnerKey} = $Value;
                }
            }

            my $SettingName = $ItemName . '###' . $Key;

            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                Name   => $SettingName,
                Force  => 1,
                UserID => 1,
            );

            my %Result = $SysConfigObject->SettingUpdate(
                Name              => $SettingName,
                IsValid           => 1,
                EffectiveValue    => $CurrentValue->{$Key},
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );

            push @UpdatedSettings, $SettingName;
        }

        $ConfigObject->Set(
            Key   => $ItemName,
            Value => $CurrentValue,
        );
    }

    my $Success = $SysConfigObject->ConfigurationDeploy(
        Comments      => "Deployed by 'Application For Leave' process setup",
        UserID        => 1,
        Force         => 1,
        DirtySettings => \@UpdatedSettings,
    );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was unable to deploy settings needed for 'Application For Leave' process!"
        );
    }

    return %Response;
}

1;
