# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::processes::examples::Application_for_leave_pre;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
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

    # Dynamic fields definition
    my @DynamicFields = (
        {
            Name       => 'PreProcApplicationRecorded',
            Label      => 'Application Recorded',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'no'  => 'no',
                    'yes' => 'yes',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcDaysRemaining',
            Label      => 'Days Remaining',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
            },
        },
        {
            Name       => 'PreProcVacationStart',
            Label      => 'Vacation Start',
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            FieldOrder => 10002,
            Config     => {
                DateRestriction => 'DisablePastDates',
            },
        },
        {
            Name       => 'PreProcVacationEnd',
            Label      => 'Vacation End',
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            FieldOrder => 10003,
            Config     => {
                DateRestriction => 'DisablePastDates',
            },
        },
        {
            Name       => 'PreProcDaysUsed',
            Label      => 'Days Used',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10004,
            Config     => {
            },
        },
        {
            Name       => 'PreProcEmergencyTelephone',
            Label      => 'Emergency Telephone',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10005,
            Config     => {
            },
        },
        {
            Name       => 'PreProcRepresentationBy',
            Label      => 'Representation By',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10006,
            Config     => {
                Rows => 10,
                Cols => 80,
            },
        },
        {
            Name       => 'PreProcProcessStatus',
            Label      => 'Process Status',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10007,
            Config     => {
            },
        },
        {
            Name       => 'PreProcApprovedSuperior',
            Label      => 'Approved Superior',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10008,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'no'  => 'no',
                    'yes' => 'yes',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcVacationInfo',
            Label      => 'Vacation Info',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10009,
            Config     => {
                Rows => 10,
                Cols => 80,
            },
        },
    );

    # add Dynamic Fields
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    for my $DynamicField (@DynamicFields) {

        my $ID = $DynamicFieldObject->DynamicFieldAdd(
            %{$DynamicField},
            ValidID => 1,
            UserID  => 1,
        );

        if ( $ID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "System created Dynamic field ($DynamicField->{Name})!"
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "System couldn't create Dynamic field ($DynamicField->{Name})!"
            );
        }
    }

    return 1;
}

1;
