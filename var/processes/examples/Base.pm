# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::processes::examples::Base;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

var::processes::examples::Base - base class for ready to process examples

=head1 DESCRIPTION

This is a base class for example processes and should not be instantiated directly.

All _pre.pm and _post.pm files can use helper methods defined in this class.

    package var::processes::examples::MyProcessExample;
    use strict;
    use warnings;

    use parent qw(var::processes::examples::Base);

    # methods go here

=cut

=head1 PUBLIC INTERFACE

=head2 DynamicFieldsAdd()

Creates dynamic fields according to provided configurations.

    my %Result = $ProcessExampleObject->DynamicFieldsAdd(
        DynamicFieldList => [                                # (required) List of dynamic field configuration
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
            ...
        ],
    );

Result:
    %Result = (
        Success => 1,
        Error   => undef,
    );

=cut

sub DynamicFieldsAdd {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(DynamicFieldList)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Response = (
        Success => 1,
    );

    if ( ref $Param{DynamicFieldList} ne 'ARRAY' ) {
        %Response = (
            Success => 0,
            Error   => "DynamicFieldList is not an array!"
        );

        return %Response;
    }

    # add Dynamic Fields
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    DYNAMIC_FIELD:
    for my $DynamicField ( @{ $Param{DynamicFieldList} } ) {

        # check if already exists
        my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicField->{Name},
        );

        if ( IsHashRefWithData($DynamicFieldData) ) {

            if (
                $DynamicFieldData->{ObjectType} ne $DynamicField->{ObjectType}
                || $DynamicFieldData->{FieldType} ne $DynamicField->{FieldType}
                )
            {
                $Response{Success} = 0;
                $Response{Error}   = $Kernel::OM->Get('Kernel::Language')->Translate(
                    "Dynamic field %s already exists, but definition is wrong.",
                    $DynamicField->{Name},
                );
                last DYNAMIC_FIELD;
            }

            next DYNAMIC_FIELD;
        }

        my $ID = $DynamicFieldObject->DynamicFieldAdd(
            %{$DynamicField},
            ValidID => 1,
            UserID  => 1,
        );

        if ($ID) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "System created Dynamic field ($DynamicField->{Name})!"
            );
        }
        else {
            $Response{Success} = 0;
            $Response{Error}   = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Dynamic field %s couldn't be created.",
                $DynamicField->{Name},
            );
        }
    }

    return %Response;
}

=head2 SystemConfigurationUpdate()

Updates system configuration according with the provided data.

    my $Success = $ProcessExampleObject->SystemConfigurationUpdate(
        ProcessName => 'Some Process',
        Data => [
            {
                'Ticket::Frontend::AgentTicketZoom' => {
                    'ProcessWidgetDynamicFieldGroups' => {
                        'Some Group' => 'SomeField1, SomeField2,',
                        # ...
                    },
                    'ProcessWidgetDynamicField' => {
                    'SomeField1' => '1',
                    'SomeFeld2'  => '1',
                    # ...
                },
            },
        ],
    );

=cut

sub SystemConfigurationUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessName Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );

            return;
        }
    }

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @UpdatedSettings;

    for my $Item ( @{ $Param{Data} } ) {
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

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "Deployed by '$Param{ProcessName}' process setup",
        UserID        => 1,
        Force         => 1,
        DirtySettings => \@UpdatedSettings,
    );
    if ( !$DeploymentResult{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was unable to deploy settings needed for '$Param{ProcessName}' process!"
        );
    }

    return $DeploymentResult{Success};

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
