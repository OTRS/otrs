# --
# Kernel/System/ProcessManagement/TransitionAction.pm - all transition action functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction - action lib

=head1 SYNOPSIS

All Process Management Transition Action functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::ProcessManagement::TransitionAction;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TransitionActionObject = Kernel::System::ProcessManagement::TransitionAction->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject MainObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item TransitionActionGet()

    Get transition action info

    my $TransitionAction = $TransitionActionObject->TransitionActionGet(
        TransitionActionEntityID => 'TA1',
    );

    Returns:

    $TransitionAction = {
          'Name'       => 'TransitionAction 1'
          'CreateBy'   => '2',
          'CreateTime' => '07-02-2012 13:37:00',
          'ChangeBy'   => '3',
          'ChangeTime' => '08-02-2012 13:37:00',
          'Module'     => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
          'Config'     => {
            # Config hash including all parameters
            # that can submitted to that module
          },
    };

=cut

sub TransitionActionGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TransitionActionEntityID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $TransitionAction = $Self->{ConfigObject}->Get('Process::TransitionAction');

    if ( !IsHashRefWithData($TransitionAction) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need TransitionAction config!',
        );
        return;
    }

    if ( !IsHashRefWithData( $TransitionAction->{ $Param{TransitionActionEntityID} } ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Data for TransitionAction '$Param{TransitionActionEntityID}' found!",
        );
        return;
    }

    if (
        !$TransitionAction->{ $Param{TransitionActionEntityID} }{Module}
        || !$Self->{MainObject}->Require(
            $TransitionAction->{ $Param{TransitionActionEntityID} }{Module}
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Module for TransitionAction: $Param{TransitionActionEntityID} missing or"
                . " not found!",
        );
        return;
    }

    return $TransitionAction->{ $Param{TransitionActionEntityID} };
}

=item TransitionActionList()

    Get action config for dedicated TransitionActionEntityIDs

    my $TransitionActionList = $TransitionActionObject->TransitionActionList(
        TransitionActionEntityID => ['TA1', 'TA2', 'TA3',],
    );

    Returns:

    $TransitionActions = [
        {
          'TransitionActionEntityID' => 'TA1',
          'Name'                     => 'TransitionAction1'
          'CreateBy'                 => '2',
          'ChangeBy'                 => '3',
          'CreateTime'               => '25-04-2012 13:37:00',
          'ChangeTime'               => '24-04-2012 13:37:00',
          'Module'                   => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
          'Config'                   => {
                                            # Config hash including all parameters
                                            # that can submitted to that module
           },
        },
        {
          'TransitionActionEntityID' => 'TA2',
          'Name'                     => 'TransitionAction2'
          'CreateBy'                 => '2',
          'ChangeBy'                 => '3',
          'CreateTime'               => '25-04-2012 13:37:00',
          'ChangeTime'               => '24-04-2012 13:37:00',
          'Module'                   => 'Kernel::System::ProcessManagement::TransitionAction::StatusUpdate',
          'Config'                   => {
                                            # Config hash including all parameters
                                            # that can submitted to that module
          },
        },
        {
          'TransitionActionEntityID' => 'TA3',
          'Name'                     => 'TransitionAction3'
          'CreateBy'                 => '2',
          'ChangeBy'                 => '3',
          'CreateTime'               => '25-04-2012 13:37:00',
          'ChangeTime'               => '24-04-2012 13:37:00',
          'Module'                   => 'Kernel::System::ProcessManagement::TransitionAction::NotifyOwner',
          'Config'                   => {
                                            # Config hash including all parameters
                                            # that can submitted to that module
          },
        },
    ];

=cut

sub TransitionActionList {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TransitionActionEntityID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{TransitionActionEntityID} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'No TransitionActionEntityID Array submitted calling TransitionActionList!',
        );
        return;
    }

    my $TransitionAction = $Self->{ConfigObject}->Get('Process::TransitionAction');

    my $TransitionActionConfigs;
    for my $TransitionActionEntityID ( @{ $Param{TransitionActionEntityID} } ) {
        if ( !IsHashRefWithData( $TransitionAction->{$TransitionActionEntityID} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No Data for TransitionAction '$TransitionActionEntityID'"
                    . " found!",
            );
            return;
        }

        if (
            !$TransitionAction->{$TransitionActionEntityID}{Module}
            || !$Self->{MainObject}->Require(
                $TransitionAction->{$TransitionActionEntityID}{Module}
            )
            )
        {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Module for TransitionAction: $TransitionActionEntityID"
                    . " missing or not found!",
            );
            return;
        }

        push @{$TransitionActionConfigs}, {
            TransitionActionEntityID => $TransitionActionEntityID,
            %{ $TransitionAction->{$TransitionActionEntityID} },
        };
    }
    return $TransitionActionConfigs;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
