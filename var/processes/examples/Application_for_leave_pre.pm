# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::processes::examples::Application_for_leave_pre;
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

    %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
