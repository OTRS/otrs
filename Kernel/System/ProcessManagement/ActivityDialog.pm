# --
# Kernel/System/ProcessManagement/ActivityDialog.pm - all activity dialog functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::ActivityDialog;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);

=head1 NAME

Kernel::System::ProcessManagement::ActivityDialog - activity dialog lib

=head1 SYNOPSIS

All Process Management Activity Dialog functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::ProcessManagement::ActivityDialog;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $ActivityDialogObject = Kernel::System::ProcessManagement::ActivityDialog->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item ActivityDialogGet()

    Get activity dialog info

    my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
        ActivityDialogEntityID => 'AD1',
        Interface              => ['AgentInterface'],   # ['AgentInterface'] or ['CustomerInterface'] or ['AgentInterface', 'CustomerInterface'] or 'all'
        Silent                 => 1,    # 1 or 0, default 0, if set to 1, will not log errors about not matching interfaces
    );

    Returns:

    $ActivityDialog = {
        Name             => 'UnitTestActivity',
        Interface        => 'CustomerInterface',   # 'AgentInterface', 'CustomerInterface', ['AgentInterface'] or ['CustomerInterface'] or ['AgentInterface', 'CustomerInterface']
        DescriptionShort => 'AD1 Process Short',
        DescriptionLong  => 'AD1 Process Long description',
        CreateTime       => '07-02-2012 13:37:00',
        CreateBy         => '2',
        ChangeTime       => '08-02-2012 13:37:00',
        ChangeBy         => '3',
        Fields => {
            DynamicField_Make => {
                Display          => 2,
                DescriptionLong  => 'Make Long',
                DescriptionShort => 'Make Short',
            },
            DynamicField_VWModel => {
                Display          => 2,
                DescriptionLong  => 'VWModel Long',
                DescriptionShort => 'VWModel Short',
            },
            DynamicField_PeugeotModel => {
                Display          => 0,
                DescriptionLong  => 'PeugeotModel Long',
                DescriptionShort => 'PeugeotModel Short',
            },
            StateID => {
               Display          => 1,
               DescriptionLong  => 'StateID Long',
               DescriptionShort => 'StateID Short',
            },
        },
        FieldOrder => [
            'StateID',
            'DynamicField_Make',
            'DynamicField_VWModelModel',
            'DynamicField_PeugeotModel'
        ],
        SubmitAdviceText => 'NOTE: If you submit the form ...',
        SubmitButtonText => 'Make an inquiry',
    };

=cut

sub ActivityDialogGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ActivityDialogEntityID Interface)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( $Param{Interface} ne 'all' && ref $Param{Interface} ne 'ARRAY' ) {
        $Param{Interface} = [ $Param{Interface} ];
    }

    my $ActivityDialog = $Self->{ConfigObject}->Get('Process::ActivityDialog');

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ActivityDialog config!' );
        return;
    }

    if ( !IsHashRefWithData( $ActivityDialog->{ $Param{ActivityDialogEntityID} } ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Data for ActivityDialog '$Param{ActivityDialogEntityID}' found!"
        );
        return;
    }

    if (
        $Param{Interface} ne 'all'
        && !IsArrayRefWithData(
            $ActivityDialog->{ $Param{ActivityDialogEntityID} }->{Interface}
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Interface for ActivityDialog '$Param{ActivityDialogEntityID}' found!"
        );
    }

    if ( $Param{Interface} ne 'all' ) {
        my $Success;
        INTERFACE:
        for my $CurrentInterface ( @{ $Param{Interface} } ) {
            if (
                grep { $CurrentInterface eq $_ }
                @{ $ActivityDialog->{ $Param{ActivityDialogEntityID} }->{Interface} }
                )
            {
                $Success = 1;
                last INTERFACE;
            }
        }

        if ( !$Success ) {
            if ( !$Param{Silent} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Not permitted Interface(s) '"
                        . join( '\', \'', @{ $Param{Interface} } )
                        . "' for ActivityDialog '$Param{ActivityDialogEntityID}'!"
                );
            }
            return;
        }
    }

    return $ActivityDialog->{ $Param{ActivityDialogEntityID} };
}

=item ActivityDialogCompletedCheck()

    Checks if an activity dialog is completed

    my $Completed = $ActivityDialogObject->ActivityDialogCompletedCheck(
        ActivityDialogEntityID => 'AD1',
        Data                   => {
            Queue         => 'Raw',
            DynamicField1 => 'Value',
            Subject       => 'Testsubject',
            # ...
        },
    );

    Returns:

    $Completed = 1; # 0

=cut

sub ActivityDialogCompletedCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ActivityDialogEntityID Data)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    my $ActivityDialog
        = $Self->ActivityDialogGet(
        ActivityDialogEntityID => $Param{ActivityDialogEntityID},
        Interface              => 'all',
        );
    if ( !$ActivityDialog ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't get ActivtyDialog '$Param{ActivityDialogEntityID}'!",
        );
        return;
    }

    if ( !$ActivityDialog->{Fields} || ref $ActivityDialog->{Fields} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't get fields for ActivtyDialog '$Param{ActivityDialogEntityID}'!",
        );
        return;
    }

    # loop over the fields of the config activity dialog to check if the required fields are filled
    FIELDLOOP:
    for my $Field ( sort keys %{ $ActivityDialog->{Fields} } ) {

        # Checks if Field was invisible
        next FIELDLOOP if ( !$ActivityDialog->{Fields}{$Field}{Display} );

        # Checks if Field was visible but not required
        next FIELDLOOP if ( $ActivityDialog->{Fields}{$Field}{Display} == 1 );

        # checks if $Data->{Field} is defined and not an empty string
        return if ( !IsStringWithData( $Param{Data}->{$Field} ) );
    }

    return 1;
}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
