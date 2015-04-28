# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ProcessManagement::Process;

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create common objects to be used in ActivityDialog object creation
my %CommonObject;
$CommonObject{ActivityObject}         = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity');
$CommonObject{ActivityDialogObject}   = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');
$CommonObject{TransitionObject}       = $Kernel::OM->Get('Kernel::System::ProcessManagement::Transition');
$CommonObject{TransitionActionObject} = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction');
$CommonObject{TicketObject}           = $Kernel::OM->Get('Kernel::System::Ticket');

my $ProcessObject = Kernel::System::ProcessManagement::Process->new();

my $RandomID = $HelperObject->GetRandomID();

# create some queues in the system
my %QueueData1 = (
    Name            => 'Queue1' . $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

my %QueueData2 = (
    Name            => 'Queue2' . $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

my %QueueData3 = (
    Name            => 'Queue3' . $RandomID,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

my $QueueID1 = $QueueObject->QueueAdd(%QueueData1);

# sanity check
$Self->IsNot(
    $QueueID1,
    undef,
    "QueueAdd() - Added queue '$QueueData1{Name}' for ACL check - should not be undef"
);

my $QueueID2 = $QueueObject->QueueAdd(%QueueData2);

# sanity check
$Self->IsNot(
    $QueueID2,
    undef,
    "QueueAdd() - Added queue '$QueueData2{Name}' for ACL check - should not be undef"
);

my $QueueID3 = $QueueObject->QueueAdd(%QueueData3);

# sanity check
$Self->IsNot(
    $QueueID3,
    undef,
    "QueueAdd() - Added queue '$QueueData3{Name}' for ACL check - should not be undef"
);

my $TicketID = $CommonObject{TicketObject}->TicketCreate(
    Title    => 'Process Unittest Testticket',
    Queue    => $QueueData3{Name},               # or QueueID => 123,
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

    # List on valid Config, wrong interface
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
                'Process::ActivityDialog' => {
                    'AD1' => {
                        Interface        => ['CustomerInterface'],
                        Name             => 'Activity Dialog 1',
                        DescriptionShort => 'AD1 Process Short',
                        DescriptionLong  => 'AD1 Process Long description',
                        CreateTime       => '07-02-2012 13:37:00',
                        CreateBy         => '2',
                        ChangeTime       => '08-02-2012 13:37:00',
                        ChangeBy         => '3',
                        Fields           => {
                            DynamicField_Make => {
                                Display          => 2,
                                DescriptionLong  => 'Make Long',
                                DescriptionShort => 'Make Short',
                            },
                        },
                        FieldOrder => [
                            'DynamicField_Make',
                        ],
                        SubmitAdviceText => 'NOTE: If you submit the form ...',
                        SubmitButtonText => 'Make an inquiry',
                    },
                    }
            },
            ProcessEntityID => 'P1',
            ProcessState    => ['Active'],
            Interface       => ['AgentInterface'],
            Message         => 'ProcessList() (valid Config, wrong Interface)',
            TestType        => 'Result',
            Result          => {},
        },
    },

    # List on valid Config, right interface
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
                'Process::ActivityDialog' => {
                    'AD1' => {
                        Interface        => ['AgentInterface'],
                        Name             => 'Activity Dialog 1',
                        DescriptionShort => 'AD1 Process Short',
                        DescriptionLong  => 'AD1 Process Long description',
                        CreateTime       => '07-02-2012 13:37:00',
                        CreateBy         => '2',
                        ChangeTime       => '08-02-2012 13:37:00',
                        ChangeBy         => '3',
                        Fields           => {
                            DynamicField_Make => {
                                Display          => 2,
                                DescriptionLong  => 'Make Long',
                                DescriptionShort => 'Make Short',
                            },
                        },
                        FieldOrder => [
                            'DynamicField_Make',
                        ],
                        SubmitAdviceText => 'NOTE: If you submit the form ...',
                        SubmitButtonText => 'Make an inquiry',
                    },
                    }
            },
            ProcessEntityID => 'P1',
            ProcessState    => ['Active'],
            Interface       => ['AgentInterface'],
            Message         => 'ProcessList() (valid Config, right Interface)',
            TestType        => 'Result',
            Result          => { 'P1' => 'Book Orders' },
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
    # and move it to Queue1
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
                        Name => 'Queue Move',
                        Module =>
                            'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                        Config => {
                            Queue => $QueueData1{Name},
                        },

                    },
                    'TA2' => {
                        Name => 'Queue Move',
                        Module =>
                            'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                        Config => {
                            Queue => $QueueData2{Name},
                        },

                    },
                    'TA3' => {
                        Name => 'Queue Move',
                        Module =>
                            'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                        Config => {
                            Queue => $QueueData3{Name},
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
    # back to A1 and move it back to Queue3
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
                        Name => 'Queue Move',
                        Module =>
                            'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                        Config => {
                            Queue => $QueueData1{Name},
                        },

                    },
                    'TA2' => {
                        Name => 'Queue Move',
                        Module =>
                            'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                        Config => {
                            Queue => $QueueData2{Name},
                        },

                    },
                    'TA3' => {
                        Name => 'Queue Move',
                        Module =>
                            'Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet',
                        Config => {
                            Queue => $QueueData3{Name},
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
            for my $Config ( sort keys %{ $Test->{ProcessTransition}{Config} } ) {
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
                %CommonObject,
                ConfigObject => $ConfigObject,
                Debug        => $Test->{ProcessTransition}{Debug},
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

            # ProcessTransition - Check given and expected result
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
                %CommonObject,
                ConfigObject => $ConfigObject,
            );
        }
    }
    elsif ( $Test->{ProcessTicketProcessSet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessTicketProcessSet}{Config} ) ) {
            for my $Config ( sort keys %{ $Test->{ProcessTicketProcessSet}{Config} } ) {
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
                %CommonObject,
                ConfigObject => $ConfigObject,
                Debug        => $Test->{ProcessTicketProcessSet}{Debug},
            );
        }

        # execute process object call
        my $Result = $ProcessObject->ProcessTicketProcessSet( %{ $Test->{ProcessTicketProcessSet} } );

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
                %CommonObject,
                ConfigObject => $ConfigObject,
            );
        }
    }
    elsif ( $Test->{ProcessTicketActivitySet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessTicketActivitySet}{Config} ) ) {
            for my $Config ( sort keys %{ $Test->{ProcessTicketActivitySet}{Config} } ) {
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
                %CommonObject,
                ConfigObject => $ConfigObject,
                Debug        => $Test->{ProcessTicketActivitySet}{Debug},
            );
        }

        # execute process object call
        my $Result = $ProcessObject->ProcessTicketActivitySet( %{ $Test->{ProcessTicketActivitySet} } );

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
                %CommonObject,
                ConfigObject => $ConfigObject,
            );
        }
    }
    elsif ( $Test->{ProcessList} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessList}{Config} ) ) {
            for my $Config ( sort keys %{ $Test->{ProcessList}{Config} } ) {
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
                %CommonObject,
                ConfigObject => $ConfigObject,
                Debug        => $Test->{ProcessList}{Debug},
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
                %CommonObject,
                ConfigObject => $ConfigObject,
            );
        }
    }
    elsif ( $Test->{ProcessGet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessGet}{Config} ) ) {
            for my $Config ( sort keys %{ $Test->{ProcessGet}{Config} } ) {
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
                %CommonObject,
                ConfigObject => $ConfigObject,
                Debug        => $Test->{ProcessGet}{Debug},
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
                %CommonObject,
                ConfigObject => $ConfigObject,
            );
        }
    }
    elsif ( $Test->{ProcessStartpointGet} ) {

        # Set Config
        if ( IsHashRefWithData( $Test->{ProcessStartpointGet}{Config} ) ) {
            for my $Config ( sort keys %{ $Test->{ProcessStartpointGet}{Config} } ) {
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
                %CommonObject,
                ConfigObject => $ConfigObject,
                Debug        => $Test->{ProcessStartpointGet}{Debug},
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
                %CommonObject,
                ConfigObject => $ConfigObject,
            );
        }
    }
}

# queue
my $Success = $QueueObject->QueueUpdate(
    %QueueData1,
    QueueID    => $QueueID1,
    FollowUpID => 1,
    ValidID    => 2,
);

$Self->True(
    $Success,
    "QueueUpdate() - Invalidate queue '$QueueData1{Name}' for ACL check."
);

$Success = $QueueObject->QueueUpdate(
    %QueueData2,
    QueueID    => $QueueID2,
    FollowUpID => 1,
    ValidID    => 2,
);

$Self->True(
    $Success,
    "QueueUpdate() - Invalidate queue '$QueueData2{Name}' for ACL check."
);

$Success = $QueueObject->QueueUpdate(
    %QueueData2,
    QueueID    => $QueueID2,
    FollowUpID => 1,
    ValidID    => 2,
);

$Self->True(
    $Success,
    "QueueUpdate() - Invalidate queue '$QueueData3{Name}' for ACL check."
);

if ($TicketID) {
    my $Success = $CommonObject{TicketObject}->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Success || 0,
        "TicketDelete() Test ticket for Unit tests deleted",
    );
}

1;
