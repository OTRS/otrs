# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::webservices::examples::Base;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
);

=head1 NAME

var::webservices::examples::Base - common methods used during example web service import

=head1 SYNOPSIS

All _pre.pm and _post.pm files can use helper methods defined in this class.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item DynamicFieldsAdd()

Creates dynamic fields according to provided configurations.

    my %Result = $SysConfigObject->DynamicFieldsAdd(
        DynamicFieldList => [                                # (required) List of dinamic field configuration
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
