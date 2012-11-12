# --
# Process.t - Process module testscript
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Process.t,v 1.5 2012-11-12 17:51:40 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars qw($Self);

use Kernel::Config;
use Kernel::System::UnitTest::Helper;
use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::Ticket;

use Kernel::System::VariableCheck qw(:all);

# create local objects
my $ConfigObject = Kernel::Config->new();

my $ActivityObject = Kernel::System::ProcessManagement::Activity->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TransitionActionObject = Kernel::System::ProcessManagement::TransitionAction->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TransitionObject = Kernel::System::ProcessManagement::Transition->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ProcessObject = Kernel::System::ProcessManagement::Process->new(
    %{$Self},
    ConfigObject           => $ConfigObject,
    TicketObject           => $TicketObject,
    ActivityObject         => $ActivityObject,
    TransitionObject       => $TransitionObject,
    TransitionActionObject => $TransitionActionObject,
);

my $TicketID = $TicketObject->TicketCreate(
    Title    => 'Process Unittest Testticket',
    Queue    => 'Raw',                           # or QueueID => 123,
    Lock     => 'unlock',
    Priority => '3 normal',                      # or PriorityID => 2,
    State    => 'new',                           # or StateID => 5,
    OwnerID  => 1,
    UserID   => 1,
);
$Self->True(
    $TicketID || 0,
    "TicketCreate() Testticket for Unittests created",
);

my @Tests = (

    # Get on no config
    {
        ProcessGet => {
            Config          => {},
            ProcessEntityID => 'unknown123',
            Message         => 'ProcessGet() (No Config)',
            TestType        => 'False',
            }
    },

    # Get on no ProcessEntityID
    {
        ProcessGet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'unknown123',
            Message         => 'ProcessGet() (No ProcessEntityID)',
            TestType        => 'False',
            }
    },

    # Get on invalid ProcessEntityID
    {
        ProcessGet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'unknown123',
            Message         => 'ProcessGet() (unknown ProcessEntityID)',
            TestType        => 'False',
            }
    },

    # Get on valid ProcessEntityID
    {
        ProcessGet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            Message         => 'ProcessGet() (known ProcessEntityID)',
            TestType        => 'Result',
            Result          => {
                Name                => 'Book Orders',
                CreateTime          => '16-02-2012 13:37:00',
                CreateBy            => '1',
                ChangeTime          => '17-02-2012 13:37:00',
                ChangeBy            => '1',
                State               => 'Active',
                StartActivity       => 'A1',
                StartActivityDialog => 'AD1',
                Path                => {
                    'A1' => {
                        'T1' => {
                            ActivityEntityID => 'A2',
                        },
                        'T2' => {
                            ActivityEntityID => 'A3',
                        },
                    },
                    'A2' => {
                        'T3' => {
                            ActivityEntityID => 'A4',
                        },
                    },
                },
            },
        },
    },

    # Get on valid ProcessEntityID UTF8
    {
        ProcessGet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name =>
                            'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            Message         => 'ProcessGet() (known ProcessEntityID UTF8)',
            TestType        => 'Result',
            Result          => {
                Name =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                CreateTime          => '16-02-2012 13:37:00',
                CreateBy            => '1',
                ChangeTime          => '17-02-2012 13:37:00',
                ChangeBy            => '1',
                State               => 'Active',
                StartActivity       => 'A1',
                StartActivityDialog => 'AD1',
                Path                => {
                    'A1' => {
                        'T1' => {
                            ActivityEntityID => 'A2',
                        },
                        'T2' => {
                            ActivityEntityID => 'A3',
                        },
                    },
                    'A2' => {
                        'T3' => {
                            ActivityEntityID => 'A4',
                        },
                    },
                },
            },
        },
    },

    # List on invalid Config
    {
        ProcessList => {
            Config => {
                'Process' => {
                },
            },
            ProcessEntityID => 'P1',
            ProcessState    => [ 'Active', 'FadeAway', 'Inactive' ],
            Message         => 'ProcessList() (invalid Config)',
            TestType        => 'False',
            }
    },

    # List on valid Config, missing ProcessState
    {
        ProcessList => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            ProcessState    => [],
            Message         => 'ProcessList() (valid Config, missing ProcessState)',
            TestType        => 'False',
        },
    },

    # List on valid Config, right ProcessState
    {
        ProcessList => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            ProcessState    => [ 'Active', 'FadeAway', 'Inactive' ],
            Message         => 'ProcessList() (valid Config, right ProcessState)',
            TestType        => 'Result',
            Result          => {
                'P1' => 'Book Orders'
            },
        },
    },

    # List on valid Config, wrong ProcessState
    {
        ProcessList => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            ProcessState    => [ 'FadeAway', 'Inactive' ],
            Message         => 'ProcessList() (valid Config, wrong ProcessState)',
            TestType        => 'Result',
            Result          => {},
        },
    },

    # ProcessStartpointGet on invalid Config
    {
        ProcessStartpointGet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name       => 'Book Orders',
                        CreateTime => '16-02-2012 13:37:00',
                        CreateBy   => '1',
                        ChangeTime => '17-02-2012 13:37:00',
                        ChangeBy   => '1',
                        State      => 'Active',
                        Path       => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            Message         => 'ProcessStartpointGet() (invalid Start)',
            TestType        => 'False',
        },
    },

    # ProcessStartpointGet on valid Config
    {
        ProcessStartpointGet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            Message         => 'ProcessStartpointGet() (valid Start)',
            TestType        => 'Result',
            Result          => {
                Activityset    => 'A1',
                ActivityDialog => 'AD1',
            },
        },
    },

    # Transition on missing ProcessEntityID
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                },
            },
            ProcessEntityID  => undef,
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            Message          => 'ProcessTransition() (missing ProcessEntityID)',
            TestType         => 'False',
            }
    },

    # Transition on missing ActivityEntityID
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => undef,
            TicketID         => $TicketID,
            UserID           => 1,
            Message          => 'ProcessTransition() (missing ActivityDialogEntityID)',
            TestType         => 'False',
            }
    },

    # Transition on missing TicketID
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => undef,
            UserID           => 1,
            Message          => 'ProcessTransition() (missing TicketID)',
            TestType         => 'False',
            }
    },

    # Transition on missing UserID
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => undef,
            Message          => 'ProcessTransition() (missing UserID)',
            TestType         => 'False',
            }
    },

    # Transition on invalid TicketID
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => 0,
            UserID           => 1,
            Message          => 'ProcessTransition() (invalid TicketID)',
            TestType         => 'False',
            }
    },

    # Transition on invalid Process Configuration
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                        },
                        }
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            Message          => 'ProcessTransition() (invalid Process Configuration)',
            TestType         => 'False',
            }
    },

    # Transition on missing Activitsets in Process->Path
    {
        ProcessTransition => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '16-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            Message          => 'ProcessTransition() (missing required Activity in Path Config)',
            TestType         => 'False',
            Debug            => 1,
            }
    },

    # Transition on no matching Transition
    {
        ProcessTransition => {
            Config => {
                'Process::Transition' => {
                    'T1' => {
                        Name      => 'Transition 1',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => '99999999999999999999',
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                    'T2' => {
                        Name      => 'Transition 2',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => '99999999999999999999',
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                },
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            Message          => 'ProcessTransition() (no matching Transition)',
            TestType         => 'False',
            Debug            => 1,
            }
    },

    # Transition on matching Transition Check Only
    {
        ProcessTransition => {
            Config => {
                'Process::Transition' => {
                    'T1' => {
                        Name      => 'Transition 1',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => '99999999999999999999',
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                    'T2' => {
                        Name      => 'Transition 2',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => $TicketID,
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                },
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A2' => {
                        Name           => 'Activity 2 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A3' => {
                        Name           => 'Activity 3 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A4' => {
                        Name           => 'Activity 4 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            CheckOnly        => 1,
            Message          => 'ProcessTransition() (matching Transition Check Only)',
            TestType         => 'Result',
            Result           => {
                'T2' => {
                    ActivityEntityID => 'A3',
                },
            },
        },
    },

    # Transition on matching Transition change ActivityEntityID on Ticket
    {
        ProcessTransition => {
            Config => {
                'Process::Transition' => {
                    'T1' => {
                        Name      => 'Transition 1',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => '99999999999999999999',
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                    'T2' => {
                        Name      => 'Transition 2',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => $TicketID,
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                },
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A2' => {
                        Name           => 'Activity 2 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A3' => {
                        Name           => 'Activity 3 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A4' => {
                        Name           => 'Activity 4 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            CheckOnly        => 0,
            Message          => 'ProcessTransition() (matching Transition change ActivityEntityID)',
            TestType         => 'True',
            }
    },

    # ProcessTicketActivitySet on no ActivityEntityID
    {
        ProcessTicketActivitySet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => 'A2',
                                'T2' => 'A3',
                            },
                            'A2' => {
                                'T3' => 'A4',
                            },
                        },
                        }
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => undef,
            TicketID         => $TicketID,
            UserID           => 1,
            Message =>
                'ProcessTicketActivitySet() (Set ActivityEntityID on Ticket with no ActivityEntityID)',
            TestType => 'False',
            }
    },

    # ProcessTicketActivitySet on no ProcessEntityID
    {
        ProcessTicketActivitySet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => 'A2',
                                'T2' => 'A3',
                            },
                            'A2' => {
                                'T3' => 'A4',
                            },
                        },
                        }
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => undef,
            ActivityEntityID => 'A3',
            TicketID         => $TicketID,
            UserID           => 1,
            Message =>
                'ProcessTicketActivitySet() (Set ActivityEntityID on Ticket with no ProcessEntityID)',
            TestType => 'False',
            }
    },

    # ProcessTicketActivitySet on no TicketID
    {
        ProcessTicketActivitySet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => 'A2',
                                'T2' => 'A3',
                            },
                            'A2' => {
                                'T3' => 'A4',
                            },
                        },
                        }
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A3',
            TicketID         => undef,
            UserID           => 1,
            Message =>
                'ProcessTicketActivitySet() (Set ActivityEntityID on Ticket with no TicketID)',
            TestType => 'False',
            }
    },

    # ProcessTicketActivitySet on invalid ActivityEntityID
    {
        ProcessTicketActivitySet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => 'A2',
                                'T2' => 'A3',
                            },
                            'A2' => {
                                'T3' => 'A4',
                            },
                        },
                        }
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A3',
            TicketID         => $TicketID,
            UserID           => 1,
            Message =>
                'ProcessTicketActivitySet() (Set ActivityEntityID on Ticket with invalid ActivityEntityID)',
            TestType => 'False',
            }
    },

    # ProcessTicketActivitySet on invalid ProcessEntityID
    {
        ProcessTicketActivitySet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P2',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            Message =>
                'ProcessTicketActivitySet() (Set ActivityEntityID on Ticket with invalid ProcessEntityID)',
            TestType => 'False',
            }
    },

    # ProcessTicketActivitySet on valid Config
    {
        ProcessTicketActivitySet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            Message =>
                'ProcessTicketActivitySet() (Set ActivityEntityID on Ticket with valid Config)',
            TestType => 'True',
            }
    },

    # ProcessTicketProcessSet on invalid Config
    {
        ProcessTicketProcessSet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P17',
            TicketID        => $TicketID,
            UserID          => 1,
            Message =>
                'ProcessTicketProcessSet() (Set ProcessEntityID on Ticket with invalid ProcessEntityID)',
            TestType => 'False',
        },
    },

    # ProcessTicketProcessSet on invalid TicketID
    {
        ProcessTicketProcessSet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            TicketID        => undef,
            UserID          => 1,
            Message =>
                'ProcessTicketProcessSet() (Set ProcessEntityID on Ticket with invalid TicketID)',
            TestType => 'False',
        },
    },

    # ProcessTicketProcessSet on valid Config
    {
        ProcessTicketProcessSet => {
            Config => {
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
            },
            ProcessEntityID => 'P1',
            TicketID        => $TicketID,
            UserID          => 1,
            Message =>
                'ProcessTicketProcessSet() (Set ProcessEntityID on Ticket with valid Config)',
            TestType => 'True',
        },
    },

  # Transition + QueueMove TransitionAction on matching Transition change ActivityEntityID on Ticket
  # and move it to Queue Misc
    {
        ProcessTransition => {
            Config => {
                'Process::Transition' => {
                    'T1' => {
                        Name      => 'Transition 1',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => '99999999999999999999',
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                    'T2' => {
                        Name      => 'Transition 2',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => $TicketID,
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                },
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                    TransitionAction => ['TA1'],
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                        },
                    },
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A2' => {
                        Name           => 'Activity 2 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A3' => {
                        Name           => 'Activity 3 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A4' => {
                        Name           => 'Activity 4 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
                'Process::TransitionAction' => {
                    'TA1' => {
                        Name   => 'Queue Move',
                        Module => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
                        Config => {
                            TargetQueue => 'Misc',
                        },

                    },
                    'TA2' => {
                        Name   => 'Queue Move',
                        Module => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
                        Config => {
                            TargetQueue => 'Junk',
                        },

                    },
                    'TA3' => {
                        Name   => 'Queue Move',
                        Module => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
                        Config => {
                            TargetQueue => 'Raw',
                        },

                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A1',
            TicketID         => $TicketID,
            UserID           => 1,
            CheckOnly        => 0,
            Message =>
                'ProcessTransition() (matching Transition change ActivityEntityID and Action Queue Move to Misc)',
            TestType => 'True',
            }
    },

# Transition + QueueMove TransitionAction on matching Transition change ActivityEntityID on Ticket 1
# back to A1 and move it back to Raw Queue
    {
        ProcessTransition => {
            Config => {
                'Process::Transition' => {
                    'T1' => {
                        Name      => 'Transition 1',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => '99999999999999999999',
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                    'T2' => {
                        Name      => 'Transition 2',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => $TicketID,
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                    'T4' => {
                        Name      => 'Transition 4',
                        Condition => {
                            Cond1 => {
                                Fields => {
                                    TicketID => $TicketID,
                                    Title    => 'Process Unittest Testticket',
                                    TypeID   => '1',
                                },
                            },
                        },
                    },
                },
                'Process' => {
                    'P1' => {
                        Name                => 'Book Orders',
                        CreateTime          => '16-02-2012 13:37:00',
                        CreateBy            => '1',
                        ChangeTime          => '17-02-2012 13:37:00',
                        ChangeBy            => '1',
                        State               => 'Active',
                        StartActivity       => 'A1',
                        StartActivityDialog => 'AD1',
                        Path                => {
                            'A1' => {
                                'T1' => {
                                    ActivityEntityID => 'A2',
                                },
                                'T2' => {
                                    ActivityEntityID => 'A3',
                                    TransitionAction => ['TA1'],
                                },
                            },
                            'A2' => {
                                'T3' => {
                                    ActivityEntityID => 'A4',
                                },
                            },
                            'A3' => {
                                'T4' => {
                                    ActivityEntityID => 'A1',
                                    TransitionAction => ['TA3'],
                                    }
                                }
                        },
                    },
                },
                'Process::Activity' => {
                    'A1' => {
                        Name           => 'Activity 1 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A2' => {
                        Name           => 'Activity 2 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A3' => {
                        Name           => 'Activity 3 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                    'A4' => {
                        Name           => 'Activity 4 optional',
                        CreateTime     => '16-02-2012 13:37:00',
                        CreateBy       => '1',
                        ChangeTime     => '17-02-2012 13:37:00',
                        ChangeBy       => '1',
                        ActivityDialog => [
                            'AD1',
                            'AD2',
                        ],
                    },
                },
                'Process::TransitionAction' => {
                    'TA1' => {
                        Name   => 'Queue Move',
                        Module => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
                        Config => {
                            TargetQueue => 'Misc',
                        },

                    },
                    'TA2' => {
                        Name   => 'Queue Move',
                        Module => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
                        Config => {
                            TargetQueue => 'Junk',
                        },

                    },
                    'TA3' => {
                        Name   => 'Queue Move',
                        Module => 'Kernel::System::ProcessManagement::TransitionAction::QueueMove',
                        Config => {
                            TargetQueue => 'Raw',
                        },

                    },
                },
            },
            ProcessEntityID  => 'P1',
            ActivityEntityID => 'A3',
            TicketID         => $TicketID,
            UserID           => 1,
            CheckOnly        => 0,
            Message =>
                'ProcessTransition() (matching Transition change ActivityEntityID and TransitionAction Queue Move to Raw)',
            TestType => 'True',
            }
    },
);
for my $Test (@Tests) {
    if ( $Test->{ProcessTransition} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessTransition}{Config} ) ) {
            for my $Config ( keys %{ $Test->{ProcessTransition}{Config} } ) {
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => {},
                );
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => $Test->{ProcessTransition}{Config}{$Config},
                );
            }
        }

        # If we have a test with debug on, we need a new ProcessObject
        # with Debug turned on
        if ( $Test->{ProcessTransition}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
                Debug                  => $Test->{ProcessTransition}{Debug},
            );
        }

        # excute process object call
        my $Result = $ProcessObject->ProcessTransition( %{ $Test->{ProcessTransition} } );

        if ( $Test->{ProcessTransition}{TestType} eq 'False' ) {

            # ProcessTransition - Check on False
            $Self->False(
                $Result,
                $Test->{ProcessTransition}{Message},
            );
        }
        elsif ( $Test->{ProcessTransition}{TestType} eq 'True' ) {

            # ProcessTransition - Check on True
            $Self->True(
                $Result,
                $Test->{ProcessTransition}{Message},
            );
        }
        elsif ( $Test->{ProcessTransition}{TestType} eq 'Result' ) {
            my $ExpectedResult = $Test->{ProcessTransition}{Result};

            # ProcessList - Check given and expected result
            $Self->IsDeeply(
                $Result,
                $ExpectedResult,
                $Test->{ProcessTransition}{Message},
            );
        }

        # If we had a test with debug on, restore ProcessObject to default
        if ( $Test->{ProcessTransition}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
            );
        }
    }
    elsif ( $Test->{ProcessTicketProcessSet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessTicketProcessSet}{Config} ) ) {
            for my $Config ( keys %{ $Test->{ProcessTicketProcessSet}{Config} } ) {
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => {},
                );
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => $Test->{ProcessTicketProcessSet}{Config}{$Config},
                );
            }
        }

        # If we have a test with debug on, we need a new ProcessObject
        # with Debug turned on
        if ( $Test->{ProcessTicketProcessSet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
                Debug                  => $Test->{ProcessTicketProcessSet}{Debug},
            );
        }

        # execute process object call
        my $Result
            = $ProcessObject->ProcessTicketProcessSet( %{ $Test->{ProcessTicketProcessSet} } );

        if ( $Test->{ProcessTicketProcessSet}{TestType} eq 'False' ) {

            # ProcessTicketProcessSet - Check on False
            $Self->False(
                $Result,
                $Test->{ProcessTicketProcessSet}{Message},
            );
        }
        elsif ( $Test->{ProcessTicketProcessSet}{TestType} eq 'True' ) {

            # ProcessTicketProcessSet - Check on True
            $Self->True(
                $Result,
                $Test->{ProcessTicketProcessSet}{Message},
            );
        }

        # If we had a test with debug on, restore ProcessObject to default
        if ( $Test->{ProcessTicketProcessSet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
            );
        }
    }
    elsif ( $Test->{ProcessTicketActivitySet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessTicketActivitySet}{Config} ) ) {
            for my $Config ( keys %{ $Test->{ProcessTicketActivitySet}{Config} } ) {
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => {},
                );
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => $Test->{ProcessTicketActivitySet}{Config}{$Config},
                );
            }
        }

        # If we have a test with debug on, we need a new ProcessObject
        # with Debug turned on
        if ( $Test->{ProcessTicketActivitySet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
                Debug                  => $Test->{ProcessTicketActivitySet}{Debug},
            );
        }

        # execute process object call
        my $Result
            = $ProcessObject->ProcessTicketActivitySet( %{ $Test->{ProcessTicketActivitySet} } );

        if ( $Test->{ProcessTicketActivitySet}{TestType} eq 'False' ) {

            # ProcessTicketActivitySet - Check on False
            $Self->False(
                $Result,
                $Test->{ProcessTicketActivitySet}{Message},
            );
        }
        elsif ( $Test->{ProcessTicketActivitySet}{TestType} eq 'True' ) {

            # ProcessTicketActivitySet - Check on True
            $Self->True(
                $Result,
                $Test->{ProcessTicketActivitySet}{Message},
            );
        }

        # If we had a test with debug on, restore ProcessObject to default
        if ( $Test->{ProcessTicketActivitySet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
            );
        }
    }
    elsif ( $Test->{ProcessList} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessList}{Config} ) ) {
            for my $Config ( keys %{ $Test->{ProcessList}{Config} } ) {
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => {},
                );
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => $Test->{ProcessList}{Config}{$Config},
                );
            }
        }

        # If we have a test with debug on, we need a new ProcessObject
        # with Debug turned on
        if ( $Test->{ProcessList}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
                Debug                  => $Test->{ProcessList}{Debug},
            );
        }

        # execute process object call
        my $Result = $ProcessObject->ProcessList( %{ $Test->{ProcessList} } );

        if ( $Test->{ProcessList}{TestType} eq 'False' ) {

            # ProcessList - Check on False
            $Self->False(
                $Result,
                $Test->{ProcessList}{Message},
            );
        }
        elsif ( $Test->{ProcessList}{TestType} eq 'True' ) {

            # ProcessList - Check on True
            $Self->True(
                $Result,
                $Test->{ProcessList}{Message},
            );
        }
        elsif ( $Test->{ProcessList}{TestType} eq 'Result' ) {
            my $ExpectedResult = $Test->{ProcessList}{Result};

            # ProcessList - Check given and expected result
            $Self->IsDeeply(
                $Result,
                $ExpectedResult,
                $Test->{ProcessList}{Message},
            );
        }

        # If we had a test with debug on, restore ProcessObject to default
        if ( $Test->{ProcessList}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
            );
        }
    }
    elsif ( $Test->{ProcessGet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessGet}{Config} ) ) {
            for my $Config ( keys %{ $Test->{ProcessGet}{Config} } ) {
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => {},
                );
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => $Test->{ProcessGet}{Config}{$Config},
                );
            }
        }

        # If we have a test with debug on, we need a new ProcessObject
        # with Debug turned on
        if ( $Test->{ProcessGet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
                Debug                  => $Test->{ProcessGet}{Debug},
            );
        }

        # execute process object call
        my $Result = $ProcessObject->ProcessGet( %{ $Test->{ProcessGet} } );

        if ( $Test->{ProcessGet}{TestType} eq 'False' ) {

            # ProcessGet - Check on False
            $Self->False(
                $Result,
                $Test->{ProcessGet}{Message},
            );
        }
        elsif ( $Test->{ProcessGet}{TestType} eq 'True' ) {

            # ProcessGet - Check on True
            $Self->True(
                $Result,
                $Test->{ProcessGet}{Message},
            );
        }
        elsif ( $Test->{ProcessGet}{TestType} eq 'Result' ) {
            my $ExpectedResult = $Test->{ProcessGet}{Result};

            # ProcessGet - Check given and expected result
            $Self->IsDeeply(
                $Result,
                $ExpectedResult,
                $Test->{ProcessGet}{Message},
            );
        }

        # If we had a test with debug on, restore ProcessObject to default
        if ( $Test->{ProcessList}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
            );
        }
    }
    elsif ( $Test->{ProcessStartpointGet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessStartpointGet}{Config} ) ) {
            for my $Config ( keys %{ $Test->{ProcessStartpointGet}{Config} } ) {
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => {},
                );
                $ConfigObject->Set(
                    Key   => $Config,
                    Value => $Test->{ProcessStartpointGet}{Config}{$Config},
                );
            }
        }

        # If we have a test with debug on, we need a new ProcessObject
        # with Debug turned on
        if ( $Test->{ProcessStartpointGet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionActionObject => $TransitionActionObject,
                Debug                  => $Test->{ProcessStartpointGet}{Debug},
            );
        }

        # execute process object call
        my $Result = $ProcessObject->ProcessStartpointGet( %{ $Test->{ProcessStartpointGet} } );

        if ( $Test->{ProcessStartpointGet}{TestType} eq 'False' ) {

            # ProcessStartpointGet - Check on False
            $Self->False(
                $Result,
                $Test->{ProcessStartpointGet}{Message},
            );
        }
        elsif ( $Test->{ProcessStartpointGet}{TestType} eq 'True' ) {

            # ProcessStartpointGet - Check on True
            $Self->True(
                $Result,
                $Test->{ProcessStartpointGet}{Message},
            );
        }

        # If we had a test with debug on, restore ProcessObject to default
        if ( $Test->{ProcessStartpointGet}{Debug} ) {
            $ProcessObject = undef;
            $ProcessObject = Kernel::System::ProcessManagement::Process->new(
                %{$Self},
                ConfigObject           => $ConfigObject,
                TicketObject           => $TicketObject,
                ActivityObject         => $ActivityObject,
                TransitionObject       => $TransitionObject,
                TransitionActionObject => $TransitionActionObject,
            );
        }
    }
}

if ($TicketID) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Success || 0,
        "TicketDelete() Test ticket for Unit tests deleted",
    );
}

1;
