# --
# Kernel/System/ProcessManagement/Process.pm - all ticket functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::Process;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::DynamicField::Backend;
use Kernel::System::DynamicField;

=head1 NAME

Kernel::System::ProcessManagement::Process - process lib

=head1 SYNOPSIS

All ProcessManagement Process functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::ProcessManagement::Activity;
    use Kernel::System::ProcessManagement::ActivityDialog;
    use Kernel::System::ProcessManagement::Transition;
    use Kernel::System::ProcessManagement::TransitionAction;
    use Kernel::System::ProcessManagement::Process;
    use Kernel::System::Time;
    use Kernel::System::Ticket;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $ActivityObject = Kernel::System::ProcessManagement::Activity->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $ActivityDialogObject = Kernel::System::ProcessManagement::ActivityDialog->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TransitionActionObject = Kernel::System::ProcessManagement::TransitionAction->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TransitionObject = Kernel::System::ProcessManagement::Transition->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
        GroupObject        => $GroupObject,        # if given
        CustomerUserObject => $CustomerUserObject, # if given
        QueueObject        => $QueueObject,        # if given
    );
    my $ProcessObject = Kernel::System::ProcessManagement::Process->new(
        ConfigObject           => $ConfigObject,
        LogObject              => $LogObject,
        TicketObject           => $TicketObject,
        ActivityObject         => $ActivityObject,
        ActivityDialogObject   => $ActivityDialogObject,
        TransitionObject       => $TransitionObject,
        TransitionActionObject => $TransitionActionObject,
        EncodeObject           => $EncodeObject,
        DBObject               => $DBObject,
        MainObject             => $MainObject,
        TimeObject             => $TimeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for my $Needed (
        qw(
        ConfigObject LogObject TicketObject TransitionObject ActivityObject ActivityDialogObject
        TransitionActionObject EncodeObject MainObject DBObject TimeObject
        )
        )
    {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new( %{$Self} );

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    return $Self;
}

=item ProcessGet()

    Get process info

    my $Process = $ProcessObject->ProcessGet(
        ProcessEntityID => 'P1',
    );

    Returns:

    $Process = {
        'Name' => 'Process1',
        'CreateBy'            => '1',
        'CreateTime'          => '16-02-2012 13:37:00',
        'ChangeBy'            => '1',
        'ChangeTime'          => '17-02-2012 13:37:00',
        'State'               => 'Active',
        'StartActivityDialog' => 'AD1',
        'StartActivity'       => 'A1',
        'Path' => {
            'A2' => {
                'T3' => {
                    ActivityEntityID => 'A4',
                },
            },
            'A1' => {
                'T1' => {
                    ActivityEntityID => 'A2',
                },
                'T2' => {
                    ActivityEntityID => 'A3',
                },
            },
        },
    };

=cut

sub ProcessGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessEntityID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Process = $Self->{ConfigObject}->Get('Process');

    if ( !IsHashRefWithData($Process) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Process config!',
        );
        return;
    }

    if ( !IsHashRefWithData( $Process->{ $Param{ProcessEntityID} } ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Data for Process '$Param{ProcessEntityID}' found!",
        );
        return;
    }
    return $Process->{ $Param{ProcessEntityID} };
}

=item ProcessList()

    Get a list of all Processes

    my $ProcessList = $ProcessObject->ProcessList(
        ProcessState => ['Active'],           # Active, FadeAway, Inactive
        Interface    => ['AgentInterface'],   # optional, ['AgentInterface'] or ['CustomerInterface'] or ['AgentInterface', 'CustomerInterface'] or 'all'
    );

    Returns:

    $ProcessList = {
        'P1' => 'Process 1',
        'P2' => 'Process 2',
        'P3' => '',
    };

=cut

sub ProcessList {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessState)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{ProcessState} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need at least one ProcessState!',
        );
        return;
    }

    my $Processes = $Self->{ConfigObject}->Get('Process');
    if ( !IsHashRefWithData($Processes) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Process config!',
        );
        return;
    }

    # get only processes with the requested ProcessState(s)
    my %ProcessList;
    for my $ProcessEntityID ( sort keys %{$Processes} ) {
        if ( grep { $_ eq $Processes->{$ProcessEntityID}{State} } @{ $Param{ProcessState} } ) {
            $ProcessList{$ProcessEntityID} = $Processes->{$ProcessEntityID}{Name} || '';
        }
    }

    # set Interface parameter to 'all' by default if parameter was not set
    if ( !defined $Param{Interface} ) {
        $Param{Interface} = 'all';
    }

    # if Interface is 'all' return all processes without interface restrictions
    if ( $Param{Interface} eq 'all' ) {
        return \%ProcessList;
    }

    # otherwise return only processes where the initial activity dialog matches given interface
    my %ReducedProcessList;
    PROCESS:
    for my $ProcessEntityID ( sort keys %ProcessList ) {

        # get process start point for each process we already got
        my $Start = $Self->ProcessStartpointGet( ProcessEntityID => $ProcessEntityID );

        # skip processes if they does not have a valid start point
        next PROCESS if !IsHashRefWithData($Start);
        next PROCESS if !IsStringWithData( $Start->{ActivityDialog} );

        # try to get the start ActivityDialog for the given interface
        my $ActivityDialog = $Self->{ActivityDialogObject}->ActivityDialogGet(
            ActivityDialogEntityID => $Start->{ActivityDialog},
            Interface              => $Param{Interface},
            Silent                 => 1,
        );

        # skip process if first activity dialog could not be got for the given interface
        next PROCESS if !IsHashRefWithData($ActivityDialog);

        $ReducedProcessList{$ProcessEntityID} = $ProcessList{$ProcessEntityID};
    }

    return \%ReducedProcessList;
}

=item ProcessStartpointGet()

    Get process startpoint

    my $Start = $ProcessObject->ProcessStartpointGet(
        ProcessEntityID => 'P1',
    );

    Returns:

    $Start = {
        Activity        => 'A1',
        ActivityDialog  => 'AD1',
    };

=cut

sub ProcessStartpointGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessEntityID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Process = $Self->ProcessGet( ProcessEntityID => $Param{ProcessEntityID} );
    if ( $Process->{State} ne 'Active' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't get 'StartActivity' for Process '$Param{ProcessEntityID}', State"
                . " is '$Process->{State}'!",
        );
        return;
    }

    if ( !$Process->{StartActivity} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No 'StartActivity' for Process '$Param{ProcessEntityID}' found!",
        );
        return;
    }

    if ( !$Process->{StartActivity} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No 'StartActivity' for Process '$Param{ProcessEntityID}' found!",
        );
        return;
    }

    if ( !$Process->{StartActivityDialog} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No 'StartActivityDialog' for Process '$Param{ProcessEntityID}' found!",
        );
        return;
    }
    return {
        Activity       => $Process->{StartActivity},
        ActivityDialog => $Process->{StartActivityDialog}
    };
}

=item ProcessTransition()

    Check valid Transitions and Change Ticket's Activity
    if a Transition was positively checked

    my $ProcessTransition = $ProcessObject->ProcessTransition(
        ProcessEntityID  => 'P1',
        ActivityEntityID => 'A1',
        TicketID         => 123,
        UserID           => 123,
        CheckOnly        => 1,             # optional
        Data             => {              # optional
            Queue         => 'Raw',
            DynamicField1 => 'Value',
            Subject       => 'Testsubject',
            #...
        },
    );

    Returns:
    $Success = 1; # undef # if "CheckOnly" is NOT set
    1 if Transition was executed and Ticket->ActivityEntityID updated
    undef if no Transition matched or check failed otherwise

    $ProcessTransition = {  # if option "CheckOnly" is set
        'T1' => {
            ActivityEntityID => 'A1',
            TransitionAction => [
                'TA1',
                'TA2',
                'TA3',
            ],
        },
    };

=cut

sub ProcessTransition {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessEntityID ActivityEntityID TicketID UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Data;

    # Get Ticket Data
    %Data = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
        UserID        => $Param{UserID},
    );

    # Check if we got a Ticket
    if ( !IsHashRefWithData( \%Data ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid TicketID: $Param{TicketID}!",
        );
        return;
    }

    # If we have Data lay it over the current %Data
    # to check Ticket + Additional Data
    if ( $Param{Data} ) {
        %Data = ( %Data, %{ $Param{Data} } );
    }

    my $Process = $Self->ProcessGet( ProcessEntityID => $Param{ProcessEntityID} );

    if ( !$Process->{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't process Transition for Process '$Param{ProcessEntityID}', can't"
                . " get State out of the config!",
        );
        return;
    }

    if ( $Process->{State} eq 'Inactive' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't process Transition for Process '$Param{ProcessEntityID}',"
                . " ProcessState is '$Process->{State}'!",
        );
        return;
    }

    # We need the Processes Config
    # and the Config for the process the Ticket is in
    # and the Process has to have the 'Path' Hash set
    if (
        !IsHashRefWithData($Process)
        || !IsHashRefWithData( $Process->{Path} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Path for ProcessEntityID $Param{ProcessEntityID}!",
        );
        return;
    }

    # Check if our ActivitySet has a path configured
    # if it hasn't we got nothing to do -> print debuglog if desired and return
    if ( !IsHashRefWithData( $Process->{Path}{ $Param{ActivityEntityID} } ) ) {
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => 'No Path configured for Process with ID: '
                    . "$Param{ProcessEntityID} and ActivityEntityID: $Param{ActivityEntityID}!",
            );
        }
        return;
    }

    # %Transitions Hash for easier reading
    # contains all possible Transitions for the current Activity
    my %Transitions = %{ $Process->{Path}{ $Param{ActivityEntityID} } };

    # Handle all possible TransitionEntityID's for the Process->Path's->ActivityEntityID down to
    # Transition.pm's TransitionCheck for validation
    # will return undef if nothing matched or the first matching TransitionEntityID
    my $TransitionEntityID = $Self->{TransitionObject}->TransitionCheck(
        TransitionEntityID => [ sort { $a cmp $b } keys %Transitions ],
        Data => \%Data,
    );

    # if we didn't get a TransitionEntityID
    # no check was successful -> return nothing
    if ( !$TransitionEntityID || !length $TransitionEntityID ) {
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => 'No Transition matched for TicketID: '
                    . "$Param{TicketID} ProcessEntityID: $Param{ProcessEntityID} "
                    . "ActivityEntityID: $Param{ActivityEntityID}!",
            );
        }
        return;
    }

    # If we have a Transition without valid FutureActivitySet we have to complain
    if (
        !IsHashRefWithData( $Transitions{$TransitionEntityID} )
        || !$Transitions{$TransitionEntityID}{ActivityEntityID}
        || !IsHashRefWithData(
            $Self->{ActivityObject}->ActivityGet(
                Interface        => 'all',
                ActivityEntityID => $Transitions{$TransitionEntityID}{ActivityEntityID}
                )
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Target Activity for Process with "
                . "ProcessEntityID: $Param{ProcessEntityID} ActivityEntityID:"
                . " $Param{ActivityEntityID} TransitionEntityID: $TransitionEntityID!",
        );
        return;
    }

    # If we should just check what Transition matched
    # return a hash containing
    # { TransitionEntityID => FutureActivityEntityID }
    if ( $Param{CheckOnly} ) {
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Transition with ID $TransitionEntityID matched for "
                    . "TicketID: $Param{TicketID} ProcessEntityID: $Param{ProcessEntityID} "
                    . "ActivityEntityID: $Param{ActivityEntityID}!",
            );
        }
        return { $TransitionEntityID => $Transitions{$TransitionEntityID} };
    }

    # Set the new ActivityEntityID on the Ticket
    my $Success = $Self->ProcessTicketActivitySet(
        ProcessEntityID  => $Param{ProcessEntityID},
        ActivityEntityID => $Transitions{$TransitionEntityID}{ActivityEntityID},
        TicketID         => $Param{TicketID},
        UserID           => $Param{UserID},
    );

    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Failed setting ActivityEntityID of Ticket: $Param{TicketID} to "
                . $Transitions{$TransitionEntityID}{ActivityEntityID}
                . " after successful Transition: $TransitionEntityID!",
        );
        return;
    }

    # if we don't have Actions on that transition,
    # return 1 for successful transition
    if ( !$Transitions{$TransitionEntityID}{TransitionAction} ) {
        return 1;
    }

    # if we have Transition Action and it isn't an array return
    if ( !IsArrayRefWithData( $Transitions{$TransitionEntityID}{TransitionAction} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Defective Process configuration: 'Action' must be an array in "
                . "Process: $Param{ProcessEntityID} -> Path -> "
                . "ActivityEntityID: $Param{ActivityEntityID} -> Transition: $TransitionEntityID!",
        );
        return;
    }

    my $TransitionActions
        = $Self->{TransitionActionObject}->TransitionActionList(
        TransitionActionEntityID => $Transitions{$TransitionEntityID}{TransitionAction}
        );

    if ( !IsArrayRefWithData($TransitionActions) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Getting TransitionActionList for Process: $Param{ProcessEntityID},"
                . " Transition: $TransitionEntityID failed.",
        );
        return;
    }

    for my $TransitionAction ( @{$TransitionActions} ) {
        my $TransitionActionModuleObject =
            $TransitionAction->{Module}->new(
            ConfigObject => $Self->{ConfigObject},
            LogObject    => $Self->{LogObject},
            EncodeObject => $Self->{EncodeObject},
            MainObject   => $Self->{MainObject},
            DBObject     => $Self->{DBObject},
            MainObject   => $Self->{MainObject},
            TimeObject   => $Self->{TimeObject},
            TicketObject => $Self->{TicketObject},
            );
        my $Success = $TransitionActionModuleObject->Run(
            UserID                   => $Param{UserID},
            Ticket                   => \%Data,
            ProcessEntityID          => $Param{ProcessEntityID},
            ActivityEntityID         => $Param{ActivityEntityID},
            TransitionEntityID       => $TransitionEntityID,
            TransitionActionEntityID => $TransitionAction->{TransitionActionEntityID},
            Config                   => $TransitionAction->{Config} || {},
        );
    }

    return 1;

}

=item ProcessTicketActivitySet()

    Set Ticket's ActivityEntityID

    my $Success = $ProcessObject->ProcessTicketActivitySet(
        ProcessEntityID  => 'P1',
        ActivityEntityID => 'A1',
        TicketID         => 123,
        UserID           => 123,
    );

    Returns:
    $Success = 1; # undef
    1 if setting the Activity was executed
    undef if setting failed

=cut

sub ProcessTicketActivitySet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessEntityID ActivityEntityID TicketID UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check on Valid ActivityEntityID
    my $Success = $Self->{ActivityObject}->ActivityGet(
        Interface        => 'all',
        ActivityEntityID => $Param{ActivityEntityID},
    );
    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Process->ProcessTicketActivitySet called on "
                . "non existing ActivityEntityID: $Param{ActivityEntityID}!",
        );
        return;
    }

    # Check on valid State
    my $Process = $Self->ProcessGet( ProcessEntityID => $Param{ProcessEntityID} );

    if ( !$Process->{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't set ActivitySet for Process '$Param{ProcessEntityID}', cat get"
                . " State out of the config!",
        );
        return;
    }

    if ( $Process->{State} eq 'Inactive' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't set ActivitySet for Process '$Param{ProcessEntityID}', State is"
                . " '$Process->{State}'!",
        );
        return;
    }

    # Get DynamicField Name that's used for storing the ActivityEntityID per ticket
    my $DynamicFieldTicketActivityEntityID
        = $Self->{ConfigObject}->Get('Process::DynamicFieldProcessManagementActivityID');
    if ( !$DynamicFieldTicketActivityEntityID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need DynamicFieldProcessManagementActivityID config "
                . "for storing of ActivityEntityID on TicketID: $Param{TicketID}!",
        );
        return;
    }

    # Grep the Field out of the config of all Ticket DynamicFields
    my @DynamicFieldConfig
        = grep { $_->{Name} eq $DynamicFieldTicketActivityEntityID } @{ $Self->{DynamicField} };

    # if the DynamicField isn't there, return 0 and log
    if ( !IsHashRefWithData( $DynamicFieldConfig[0] ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "DynamicField: $DynamicFieldTicketActivityEntityID not configured!",
        );
        return;
    }

    # If Ticket Update to the new ActivityEntityID was successful return 1
    if (
        $Self->{BackendObject}->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig[0],
            ObjectID           => $Param{TicketID},
            Value              => $Param{ActivityEntityID},
            UserID             => $Param{UserID}
        )
        )
    {
        return 1;
    }
    return;
}

=item ProcessTicketProcessSet()

    Set Ticket's ProcessEntityID

    my $Success = $ProcessObject->ProcessTicketProcessSet(
        ProcessEntityID => 'P1',
        TicketID        => 123,
        UserID          => 123,
    );

    Returns:
    $Success = 1; # undef
    1 if setting the Activity was executed
    undef if setting failed

=cut

sub ProcessTicketProcessSet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ProcessEntityID TicketID UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check on valid ProcessEntityID
    my $Process = $Self->ProcessGet( ProcessEntityID => $Param{ProcessEntityID} );

    if ( !$Process->{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't set Process '$Param{ProcessEntityID}' for TicketID"
                . " '$Param{TicketID}', cat get State out of the config!",
        );
        return;
    }

    if ( $Process->{State} ne 'Active' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't set Process '$Param{ProcessEntityID}' for TicketID"
                . " '$Param{TicketID}', State is '$Process->{State}'!",
        );
        return;
    }

    # Get DynamicField Name that's used for storing the ActivityEntityID per ticket
    my $DynamicFieldTicketProcessID
        = $Self->{ConfigObject}->Get('Process::DynamicFieldProcessManagementProcessID');
    if ( !$DynamicFieldTicketProcessID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need DynamicFieldProcessManagementProcessID config "
                . "for storing of ProcesID on TicketID: $Param{TicketID}!",
        );
        return;
    }

    # Grep the Field out of the config of all Ticket DynamicFields
    my @DynamicFieldConfig
        = grep { $_->{Name} eq $DynamicFieldTicketProcessID } @{ $Self->{DynamicField} };

    # if the DynamicField isn't there, return 0 and log
    if ( !IsHashRefWithData( $DynamicFieldConfig[0] ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "DynamicField: $DynamicFieldTicketProcessID not configured!",
        );
        return;
    }

    # If Ticket Update to the new ActivityEntityID was successful return 1
    if (
        $Self->{BackendObject}->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig[0],
            ObjectID           => $Param{TicketID},
            Value              => $Param{ProcessEntityID},
            UserID             => $Param{UserID},
        )
        )
    {
        return 1;
    }

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
