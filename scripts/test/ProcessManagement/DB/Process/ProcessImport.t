# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $DynamicFieldObject     = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ActivityObject         = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
my $ActivityDialogObject   = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
my $ProcessObject          = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
my $TransitionObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
my $TransitionActionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
my $YAMLObject             = $Kernel::OM->Get('Kernel::System::YAML');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# define needed variables
my $RandomID = $Helper->GetRandomID();
my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $UserID   = 1;

# get a list of current processes and it parts
my $OriginalProcessList = $ProcessObject->ProcessList(
    UserID => 1,
);
my $OriginalActivityList = $ActivityObject->ActivityList(
    UserID => 1,
);
my $OriginalActivityDialogList = $ActivityDialogObject->ActivityDialogList(
    UserID => 1,
);
my $OriginalTransitionList = $TransitionObject->TransitionList(
    UserID => 1,
);
my $OriginalTransitionActionList = $TransitionActionObject->TransitionActionList(
    UserID => 1,
);

my %PartNameMap = (
    Activity         => 'Activities',
    ActivityDialog   => 'ActivityDialogs',
    Transition       => 'Transitions',
    TransitionAction => 'TransitionActions'
);

# this function appends a Random number to all process parts so they can be located later as they
#    will be different form any other test and from the ones already stored in the system
my $UpdateNames = sub {
    my %Param = @_;

    my $ProcessData = $Param{ProcessData};
    my $RandomID    = $Param{RandomID};

    $ProcessData->{Process}->{Name} = $ProcessData->{Process}->{Name} . $RandomID;

    my $Counter;

    for my $PartName (qw(Activity ActivityDialog Transition TransitionAction)) {
        $Counter = 1;
        for my $PartEntityID ( sort keys %{ $ProcessData->{ $PartNameMap{$PartName} } } ) {
            $ProcessData->{ $PartNameMap{$PartName} }->{$PartEntityID}->{Name}
                .= " $Counter-$RandomID";
            $Counter++;
        }
    }

    return $ProcessData;
};

# this function check that the process and its parts where imported correctly, normally the
#   EntityIDs changes for the imported processes then is needed to locate them by its name
my $CheckProcess = sub {
    my %Param = @_;

    my $ProcessData = $Param{ProcessData};
    my $ProcessID   = $Param{ProcessID};

    my $Process = $ProcessObject->ProcessGet(
        ID     => $ProcessID,
        UserID => $UserID,
    );

    # get all process parts
    my $ActivityListGet         = $ActivityObject->ActivityListGet( UserID => $UserID );
    my $ActivityDialogListGet   = $ActivityDialogObject->ActivityDialogListGet( UserID => $UserID );
    my $TransitionListGet       = $TransitionObject->TransitionListGet( UserID => $UserID );
    my $TransitionActionListGet = $TransitionActionObject->TransitionActionListGet( UserID => $UserID );

    # check process start activity and start activity dialog
    for my $PartName (qw(Activity ActivityDialog)) {
        my $OriginalPartEntityID = $ProcessData->{Process}->{Config}->{"Start$PartName"} || '';
        my $PartObject           = $ActivityObject;
        if ( $PartName eq 'ActivityDialog' ) {
            $PartObject = $ActivityDialogObject;
        }
        my $PartGetFunction = $PartName . 'Get';
        if ($OriginalPartEntityID) {
            my $Part = $PartObject->$PartGetFunction(
                EntityID => $Process->{Config}->{"Start$PartName"},
                UserID   => 1,
            );
            $Self->Is(
                $Part->{Name},
                $ProcessData->{ $PartNameMap{$PartName} }->{$OriginalPartEntityID}->{Name},
                "ProcessImport() $Param{TestName} - Start $PartName name check:",
            );
        }
    }

    # check layout (check for left and right values)
    for my $OriginalActivityEntityID ( sort keys %{ $ProcessData->{Process}->{Layout} } ) {
        my $ActivityName = $ProcessData->{Activities}->{$OriginalActivityEntityID}->{Name};

        ACTIVITY:
        for my $Activity ( @{$ActivityListGet} ) {
            next ACTIVITY if $Activity->{Name} ne $ActivityName;
            $Self->IsDeeply(
                $Process->{Layout}->{ $Activity->{EntityID} },
                $ProcessData->{Process}->{Layout}->{$OriginalActivityEntityID},
                "ProcessImport() $Param{TestName} - Layout Activity ($Activity->{EntityID}) "
                    . "content check:",
            );
            last ACTIVITY;
        }
    }

    # check path
    # a typical path looks like:
    #   Path {
    #       A1 => {
    #           T1 => {
    #               ActivityEntityID => A2,
    #               TransitionAction => [TA1, TA2,],
    #           },
    #       },
    #       #...
    #    },
    # locate the activity and its name
    for my $OriginalActivityEntityID ( sort keys %{ $ProcessData->{Process}->{Config}->{Path} } ) {
        my $ActivityName = $ProcessData->{Activities}->{$OriginalActivityEntityID}->{Name};

        # search added activities for the activity name
        ACTIVITY:
        for my $Activity ( @{$ActivityListGet} ) {
            next ACTIVITY if $Activity->{Name} ne $ActivityName;

            # locate the transition and its name
            my $OriginalTransitions = $ProcessData->{Process}->{Config}->{Path}->{$OriginalActivityEntityID};
            for my $OriginalTransitionEntityID ( sort keys %{$OriginalTransitions} ) {
                my $TransitionName = $ProcessData->{Transitions}->{$OriginalTransitionEntityID}->{Name};

                # search added translation for the transition name
                TRANSITION:
                for my $Transition ( @{$TransitionListGet} ) {
                    next TRANSITION if $Transition->{Name} ne $TransitionName;

                    # locate the destination activity and its name
                    my $OriginalDestinationActivityEntityID
                        = $OriginalTransitions->{$OriginalTransitionEntityID}->{ActivityEntityID};
                    my $DestinationActivityName = $ProcessData->{Activities}->{$OriginalDestinationActivityEntityID}
                        ->{Name};

                    # search added activities for the destination activity name
                    DESTINATIONACTIVITY:
                    for my $DestinationActivity ( @{$ActivityListGet} ) {
                        next DESTINATIONACTIVITY
                            if $DestinationActivity->{Name} ne $DestinationActivityName;

                        # test if entities match
                        $Self->Is(
                            $Process->{Config}->{Path}->{ $Activity->{EntityID} }
                                ->{ $Transition->{EntityID} }->{ActivityEntityID},
                            $DestinationActivity->{EntityID},
                            "ProcessImport() $Param{TestName} - Path Activity "
                                . "($Activity->{EntityID}) -> Transition ($Transition->{EntityID}) "
                                . "-> ActivityEntity value check:",
                        );
                        last DESTINATIONACTIVITY;
                    }

                    # locate each transition action and its names
                    my $OriginalTransitionActions
                        = $OriginalTransitions->{$OriginalTransitionEntityID}->{TransitionAction};
                    my @ExpectedTrasitionActionEntityIDs;
                    for my $OriginalTransitionActionEntityID ( @{$OriginalTransitionActions} ) {
                        my $TransitionActionName = $ProcessData->{TransitionActions}
                            ->{$OriginalTransitionActionEntityID}->{Name};

                        # search added transition actions for the transition name and remember it
                        #   in the same order
                        TRANSITIONACTION:
                        for my $TransitionAction ( @{$TransitionActionListGet} ) {
                            next TRANSITIONACTION
                                if $TransitionAction->{Name} ne $TransitionActionName;
                            push @ExpectedTrasitionActionEntityIDs, $TransitionAction->{EntityID};
                            last TRANSITIONACTION;
                        }
                    }

                    # test if transition actions entities match
                    my $CurrentTransitionActions = $Process->{Config}->{Path}->{ $Activity->{EntityID} }
                        ->{ $Transition->{EntityID} }->{TransitionAction} || [];
                    $Self->IsDeeply(
                        $CurrentTransitionActions,
                        \@ExpectedTrasitionActionEntityIDs,
                        "ProcessImport() $Param{TestName} - Path Activity ($Activity->{EntityID}) "
                            . "-> Transition ($Transition->{EntityID}) -> TransitionAction "
                            . "value check:",
                    );
                    last TRANSITION;
                }
            }
            last ACTIVITY;
        }
    }

    # now check each part of the process
    # check activities
    # locate activity and its name
    for my $OriginalActivityEntityID ( sort keys %{ $ProcessData->{Activities} } ) {
        my $OriginalActivityName = $ProcessData->{Activities}->{$OriginalActivityEntityID}->{Name};

        # search added activities for the activity name
        ACTIVITY:
        for my $Activity ( @{$ActivityListGet} ) {
            next ACTIVITY if $Activity->{Name} ne $OriginalActivityName;

            # locate each activity dialog and its names
            my $OriginalActivityDialogs = $ProcessData->{Activities}->{$OriginalActivityEntityID}->{Config}
                ->{ActivityDialog};
            my %ExpectedActivityDialogEntityIDs;
            for my $OrderKey ( sort keys %{$OriginalActivityDialogs} ) {
                my $ActivityDialogName = $ProcessData->{ActivityDialogs}->{ $OriginalActivityDialogs->{$OrderKey} }
                    ->{Name};

                # search added activity dialogs for the activity dialog name and remember it
                #   in the same order
                ACTIVITYDIALOG:
                for my $ActivityDialog ( @{$ActivityDialogListGet} ) {
                    next ACTIVITYDIALOG if $ActivityDialog->{Name} ne $ActivityDialogName;
                    $ExpectedActivityDialogEntityIDs{$OrderKey} = $ActivityDialog->{EntityID};
                    last ACTIVITYDIALOG;
                }
            }

            # test if activity dialog entities match
            my $CurrentActivityDialogs = $Activity->{Config}->{ActivityDialog} || {};
            $Self->IsDeeply(
                $CurrentActivityDialogs,
                \%ExpectedActivityDialogEntityIDs,
                "ProcessImport() $Param{TestName} - Activity ($Activity->{EntityID}) -> Config "
                    . "-> ActivityDialog value check:",
            );

            last ACTIVITY;
        }
    }

    # check the rest of the process parts
    my %PartListGetMap = (
        ActivityDialog   => $ActivityDialogListGet,
        Transition       => $TransitionListGet,
        TransitionAction => $TransitionActionListGet,
    );
    for my $PartName (qw(ActivityDialog Transition TransitionAction)) {

        # locate process part and its name
        for my $OriginalPartEntityID ( sort keys %{ $ProcessData->{ $PartNameMap{$PartName} } } ) {
            my $OriginalPartName = $ProcessData->{ $PartNameMap{$PartName} }->{$OriginalPartEntityID}->{Name};

            # search added parts for the part name
            PART:
            for my $Part ( @{ $PartListGetMap{$PartName} } ) {
                next PART if $Part->{Name} ne $OriginalPartName;

                # test part config
                $Self->IsDeeply(
                    $Part->{Config},
                    $ProcessData->{ $PartNameMap{$PartName} }->{$OriginalPartEntityID}->{Config},
                    "ProcessImport() $Param{TestName} - $PartName ($Part->{EntityID}) "
                        . "-> Config value check:",
                );
                last PART;
            }
        }
    }
};

my @AddedFieldIDs;

# this function creates missing dynamic fields required by imported processes and store its ID for
#    removal on test end
my $CreateDyanmicFields = sub {
    my %Param = @_;

    my $ProcessData = $Param{ProcessData};

    # collect all used fields
    my @UsedDynamicFields;
    for my $ActivityDialog ( sort keys %{ $ProcessData->{ActivityDialogs} } ) {
        for my $FieldName (
            sort
            keys %{ $ProcessData->{ActivityDialogs}->{$ActivityDialog}->{Config}->{Fields} }
            )
        {
            if ( $FieldName =~ s{DynamicField_(\w+)}{$1}xms ) {
                push @UsedDynamicFields, $FieldName;
            }
        }
    }

    # get all present dynamic fields and check if the fields used in the config are beyond them
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldList(
        ResultType => 'HASH',
    );
    my @PresentDynamicFieldNames = values %{$DynamicFieldList};

    my @MissingDynamicFieldNames;
    for my $UsedDynamicFieldName (@UsedDynamicFields) {
        if ( !grep { $_ eq $UsedDynamicFieldName } @PresentDynamicFieldNames ) {
            push @MissingDynamicFieldNames, $UsedDynamicFieldName;
        }
    }

    my %NewAddedDynamicFields;

    DYNAMICFIELDNAME:
    for my $DynamicFieldName (@MissingDynamicFieldNames) {
        next DYNAMICFIELDNAME if $NewAddedDynamicFields{$DynamicFieldName};
        my $ID = $DynamicFieldObject->DynamicFieldAdd(
            InternalField => 0,
            Name          => $DynamicFieldName,
            Label         => $DynamicFieldName,
            FieldOrder    => 10000,
            FieldType     => 'Text',
            ObjectType    => 'Ticket',
            Config        => {
                DefaultValue => '',
            },
            Reorder => 0,
            ValidID => 1,
            UserID  => $UserID,
        );
        if ($ID) {
            push @AddedFieldIDs, $ID;
            $NewAddedDynamicFields{$DynamicFieldName} = 1;
        }
        $Self->True(
            $ID,
            "DynamicField() $Param{TestName} - Added needed DynamicField ($DynamicFieldName) "
                . "with true",
        );
    }
};

my @Tests = (
    {
        Name    => 'Missing parameters',
        Config  => {},
        Success => 0,
    },
    {
        Name        => 'Missing UserID',
        Config      => {},
        ProcessFile => 'EmptyProcess.yml',
        Success     => 0,
    },
    {
        Name   => 'Missing Content',
        Config => {
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Empty Process',
        Config => {
            UserID => $UserID,
        },
        ProcessFile => 'EmptyProcess.yml',
        Success     => 1,
    },
    {
        Name   => 'Complex 1',
        Config => {
            UserID => $UserID,
        },
        ProcessFile => 'Complex1.yml',
        Success     => 1,
    },
    {
        Name   => 'Complex 2 Missing DF',
        Config => {
            UserID => $UserID,
        },
        ProcessFile => 'Complex2.yml',
        Success     => 0,
    },
    {
        Name   => 'Complex 2 Creating DFs',
        Config => {
            UserID => $UserID,
        },
        ProcessFile         => 'Complex2.yml',
        CreateDynamicFields => 1,
        Success             => 1,
    },
    {
        Name   => 'Complex 3 Creating DFs',
        Config => {
            UserID => $UserID,
        },
        ProcessFile         => 'Complex3.yml',
        CreateDynamicFields => 1,
        Success             => 1,
    },
    {
        Name   => 'Complex 4',
        Config => {
            UserID => $UserID,
        },
        ProcessFile => 'Complex4.yml',
        Success     => 1,
    },
    {
        Name   => 'Complex 5 Creating DFs',
        Config => {
            UserID => $UserID,
        },
        ProcessFile         => 'Complex5.yml',
        CreateDynamicFields => 1,
        Success             => 1,
    },
    {
        Name   => 'Complex 6 Creating DFs',
        Config => {
            UserID => $UserID,
        },
        ProcessFile         => 'Complex6.yml',
        CreateDynamicFields => 1,
        Success             => 1,
    },
    {
        Name   => 'GUID 1 OverwriteExistingEntities',
        Config => {
            UserID                    => $UserID,
            OverwriteExistingEntities => 1
        },
        ProcessFile         => 'GUID1.yml',
        CreateDynamicFields => 1,
        Success             => 1,
    },
    {
        Name   => 'GUID 1 UPDATED OverwriteExistingEntities',
        Config => {
            UserID                    => $UserID,
            OverwriteExistingEntities => 1
        },
        ProcessFile         => 'GUID1Updated.yml',
        CreateDynamicFields => 1,
        Success             => 1,
    },
);

for my $Test (@Tests) {

    my $ProcessData;

    # read process for YAML file if needed
    my $FileRef;
    if ( $Test->{ProcessFile} ) {
        $FileRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Home . '/scripts/test/sample/ProcessManagement/' . $Test->{ProcessFile},
        );
        my $RandomID = $Helper->GetRandomID();

        # convert process to Perl for easy handling
        $ProcessData = $YAMLObject->Load( Data => $$FileRef );
    }

    # update all process names for easy search
    if ( IsHashRefWithData($ProcessData) ) {
        $ProcessData = $UpdateNames->(
            ProcessData => $ProcessData,
            RandomID    => $RandomID,
        );
    }

    # convert process back to YAML and set it as part of the config
    my $Content = $YAMLObject->Dump( Data => $ProcessData );
    $Test->{Config}->{Content} = $Content;

    # create missing dynamic fields for the process if needed
    if ( $Test->{CreateDynamicFields} ) {
        $CreateDyanmicFields->(
            ProcessData => $ProcessData,
            TestName    => $Test->{Name},
        );
    }

    # call import function
    my %ProcessImport = $ProcessObject->ProcessImport( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $ProcessImport{Success},
            "ProcessImport() $Test->{Name} - return value with true",
        );

        # get CurrentProcessID
        my $CurrentProcessList = $ProcessObject->ProcessListGet(
            UserID => 1,
        );

        my @ProcessTest      = grep { $_->{Name} eq $ProcessData->{Process}->{Name} } @{$CurrentProcessList};
        my $CurrentProcessID = $ProcessTest[0]->{ID};

        $Self->IsNot(
            $CurrentProcessID,
            undef,
            "ProcessImport() $Test->{Name} - Process found by name, ProcessID must not be undef",
        );

        # run matching tests
        $CheckProcess->(
            ProcessData => $ProcessData,
            ProcessID   => $CurrentProcessID,
            TestName    => $Test->{Name},
        );
    }
    else {
        $Self->False(
            $ProcessImport{Success},
            "ProcessImport() $Test->{Name} - return value with false",
        );
    }
}

# cleanup is done by RestoreDatabase

1;
