# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::processes::examples::Application_for_leave_post;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
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
        }

        $ConfigObject->Set(
            Key   => $ItemName,
            Value => $CurrentValue,
        );

        $SysConfigObject->ConfigItemUpdate(
            Valid        => 1,
            Key          => $ItemName,
            Value        => $CurrentValue,
            NoValidation => 1,
        );
    }

    return %Response;
}

1;
