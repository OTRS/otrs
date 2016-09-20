# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
                    'PreProcTravelPerDiem'                 => '1',
                    'PreProcExpenseReceiptsRequired'       => '1',
                    'PreProcTravelExpensesProcessState'    => '1',
                    'PreProcTravelApprovalYesNo'           => '1',
                    'PreProcFlightClass'                   => '1',
                    'PreProcFlightDepartureLocationFromTo' => '1',
                    'PreProcFlightStopoverLocation'        => '1',
                    'PreProcFlightReturnLocationFromTo'    => '1',
                    'PreProcFlightTotalCosts'              => '1',
                    'PreProcLocalTravelReimbursementPerKm' => '1',
                    'PreProcLocalDepartureLocationFromTo'  => '1',
                    'PreProcLocalReturnLocationFromTo'     => '1',
                    'PreProcLocalTotalCosts'               => '1',
                    'PreProcAccommodationDatesFrom'        => '1',
                    'PreProcAccommodationDatesTo'          => '1',
                    'PreProcAccomodationTotalCosts'        => '1',
                    'PreProcAccomodationTotalCosts'        => '1',
                    'PreProcAccomodationTotalCosts'        => '1',
                    'PreProcAccomodationTotalCosts'        => '1',
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

        my $S = $SysConfigObject->ConfigItemUpdate(
            Valid        => 1,
            Key          => $ItemName,
            Value        => $CurrentValue,
            NoValidation => 1,
        );
    }

    return %Response;
}

1;
