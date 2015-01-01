# --
# TransitionAction.t - Transition Action module testscript
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use Kernel::System::VariableCheck qw(:all);

use utf8;
use Kernel::Config;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::UnitTest::Helper;

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);
my $ConfigObject = Kernel::Config->new();

my $TransitionActionObject = Kernel::System::ProcessManagement::TransitionAction->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# define needed variables
my $RandomID = $HelperObject->GetRandomID();

# TransitionActionGet() tests
my @Tests = (
    {
        Name              => 'No Parameters',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config  => {},
        Success => 0,
    },
    {
        Name              => 'No TransitionActionEntityID',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            Other => 1,
        },
        Success => 0,
    },
    {
        Name              => 'Wrong TransitionActionEntityID',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            TransitionActionEntityID => 'Notexisiting' . $RandomID,
        },
        Success => 0,
    },
    {
        Name              => 'No TransitionActions Configuration',
        TransitionActions => {},
        Config            => {
            TransitionActionEntityID => 'TA1' . $RandomID,
        },
        Success => 0,
    },
    {
        Name              => 'Wrong Module',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::NotExistingModule',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            TransitionActionEntityID => 'TA1' . $RandomID,
        },
        Success => 0,
    },
    {
        Name              => 'Correct ASCII',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            TransitionActionEntityID => 'TA1' . $RandomID,
        },
        Success => 1,
    },
    {
        Name              => 'Correct UTF8',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Raw',
                },
            },
        },
        Config => {
            TransitionActionEntityID => 'TA1' . $RandomID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # set transition action config
    $ConfigObject->Set(
        Key   => 'Process::TransitionAction',
        Value => $Test->{TransitionActions},
    );

    # get transition action descrived in test
    my $TransitionAction = $TransitionActionObject->TransitionActionGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $TransitionAction,
            undef,
            "TransitionActionGet() Test:'$Test->{Name}' | should not be undef"
        );
        $Self->Is(
            ref $TransitionAction,
            'HASH',
            "TransitionActionGet() Test:'$Test->{Name}' | should be a HASH"
        );
        $Self->IsDeeply(
            $TransitionAction,
            $Test->{TransitionActions}->{ $Test->{Config}->{TransitionActionEntityID} },
            "TransitionActionGet() Test:'$Test->{Name}' | comparison"
        );
    }
    else {
        $Self->Is(
            $TransitionAction,
            undef,
            "TransitionActionGet() Test:'$Test->{Name}' | should be undef"
        );
    }
}

# TransitionActionList() tests
@Tests = (
    {
        Name              => 'No Params',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config  => {},
        Success => 0,
    },
    {
        Name              => 'No TransitionActionEntityID',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            Other => 1,
        },
        Success => 0,
    },
    {
        Name              => 'Wrong TransitionActionEntityID format',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            TransitionActionEntityID => 'TA1' . $RandomID,
        },
        Success => 0,
    },
    {
        Name              => 'Wrong TransitionActionEntityID',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            TransitionActionEntityID => [ 'NotExistent' . $RandomID ],
        },
        Success => 0,
    },
    {
        Name              => 'Wrong TransitionAction Module',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::NotExisiting',
                Config => {
                    Queue => 'Misc',
                },
            },
        },
        Config => {
            TransitionActionEntityID => [ 'TA1' . $RandomID ],
        },
        Success => 0,
    },
    {
        Name              => 'Correct Single',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
            'TA2' . $RandomID => {
                Name   => 'Customer Set',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet',
                Config => {
                    Param1 => 1,
                },
            },
            'TA3' . $RandomID => {
                Name => 'Article Create',
                Module =>
                    'Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate',
                Config => {
                    Param1 => 1,
                },
            },
        },
        Config => {
            TransitionActionEntityID => [ 'TA1' . $RandomID ],
        },
        Success => 1,
    },
    {
        Name              => 'Correct Multiple 2TA',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
            'TA2' . $RandomID => {
                Name   => 'Customer Set',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet',
                Config => {
                    Param1 => 1,
                },
            },
            'TA3' . $RandomID => {
                Name => 'Article Create',
                Module =>
                    'Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate',
                Config => {
                    Param1 => 1,
                },
            },
        },
        Config => {
            TransitionActionEntityID => [
                'TA2' . $RandomID,
                'TA1' . $RandomID,
            ],
        },
        Success => 1,
    },
    {
        Name              => 'Correct Multiple 3TA',
        TransitionActions => {
            'TA1' . $RandomID => {
                Name   => 'Queue Move',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                Config => {
                    Queue => 'Misc',
                },
            },
            'TA2' . $RandomID => {
                Name   => 'Customer Set',
                Module => 'Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet',
                Config => {
                    Param1 => 1,
                },
            },
            'TA3' . $RandomID => {
                Name => 'Article Create',
                Module =>
                    'Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate',
                Config => {
                    Param1 => 1,
                },
            },
        },
        Config => {
            TransitionActionEntityID => [
                'TA1' . $RandomID,
                'TA2' . $RandomID,
                'TA3' . $RandomID,
            ],
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # set activity config
    $ConfigObject->Set(
        Key   => 'Process::TransitionAction',
        Value => $Test->{TransitionActions},
    );

    # list get transtion actions
    my $TransitionActionList = $TransitionActionObject->TransitionActionList( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $TransitionActionList,
            undef,
            "TransitionActionList() Test:'$Test->{Name}' | should not be undef"
        );
        $Self->Is(
            ref $TransitionActionList,
            'ARRAY',
            "TransitionActionList() Test:'$Test->{Name}' | should be an ARRAY"
        );

        my @ExpectedTransitionActions;
        for my $TransitionActionEntityID ( @{ $Test->{Config}->{TransitionActionEntityID} } ) {
            next if !$TransitionActionEntityID;

            # get the transition action form test config
            my %TransitionAction = %{ $Test->{TransitionActions}->{$TransitionActionEntityID} };

            # add the entity ID
            $TransitionAction{TransitionActionEntityID} = $TransitionActionEntityID;
            push @ExpectedTransitionActions, \%TransitionAction;
        }

        $Self->IsDeeply(
            $TransitionActionList,
            \@ExpectedTransitionActions,
            "TransitionActionList() Test:'$Test->{Name}' | comparison"
        );
    }
    else {
        $Self->Is(
            $TransitionActionList,
            undef,
            "TransitionActionList() Test:'$Test->{Name}' | should be undef"
        );
    }
}

1;
