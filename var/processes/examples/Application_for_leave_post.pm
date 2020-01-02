# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::processes::examples::Application_for_leave_post;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::processes::examples::Base);

our @ObjectDependencies = ();

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

    $Response{Success} = $Self->SystemConfigurationUpdate(
        ProcessName => 'Application For Leave',
        Data        => \@Data,
    );

    return %Response;
}

1;
