# --
# ProcessDump.t - ProcessManagement DB ProcessDump tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use utf8;

use Kernel::Config;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::ActivityDialog;
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::ProcessManagement::DB::TransitionAction;
use Kernel::System::UnitTest::Helper;

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $UserID   = 1;

my $ConfigObject = Kernel::Config->new();

my $ProcessObject = Kernel::System::ProcessManagement::DB::Process->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ActivityObject = Kernel::System::ProcessManagement::DB::Activity->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ActivityDialogObject = Kernel::System::ProcessManagement::DB::ActivityDialog->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TransitionObject = Kernel::System::ProcessManagement::DB::Transition->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TransitionActionObject = Kernel::System::ProcessManagement::DB::TransitionAction->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# Add process Parts
my $ProcessID = $ProcessObject->ProcessAdd(
    EntityID      => 'P-Test1',
    Name          => 'Process 1',
    StateEntityID => 'S1',
    Layout        => {},
    Config        => {
        Description         => 'a Description',
        StartActivity       => 'ATest1',
        StartActivityDialog => 'ADTest1',
        Path                => {                  # New way:
            'A-Test1' => {
                'T-Test1' => {
                    'ActivityID' => 'A-Test2',
                    'Action'     => [
                        'TA-Test1',
                        'TA-Test2',
                        'TA-Test3',
                    ],
                },
                'T-Test2' => {
                    'ActivityID' => 'A-Test3',
                },
            },
        },
    },
    UserID => $UserID,
);

$Self->IsNot(
    $ProcessID,
    undef,
    "ProcessADD() | ProcessID is not undef",
);

my $ActivityID = $ActivityObject->ActivityAdd(
    EntityID => 'A-Test1',
    Name     => 'Activity 1',
    Config   => {
        ActivityDialog => {
            1 => 'AD-Test1',
            2 => {
                ActivityDialogID => 'AD-Test2',
                Overwrite        => {
                    FieldOrder => [ 1, 2, 4, 3 ],
                },
            },
        },
    },
    UserID => $UserID,
);

$Self->IsNot(
    $ActivityID,
    undef,
    "ActivityADD() | ActivityID is not undef",
);

my $ActivityDialogID = $ActivityDialogObject->ActivityDialogAdd(
    EntityID => 'AD-Test1',
    Name     => 'Activity Dialog 1',
    Config   => {
        DescriptionShort => 'Short description',
        DescriptionLong  => 'Longer description',
        Fields           => {
            DynamicField_Marke => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 2,
            },
            DynamicField_VWModell => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 2,
            },
            DynamicField_PeugeotModell => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
            },
            Title => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 2,
                DefaultValue     => 'Default title',
            },
            PriorityID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 1,
            },
            StateID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 1,
            },
            QueueID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 1,
            },
            Lock => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 'unlock',
            },
            CustomerID => {
                DescriptionShort => 'Short description',
                DescriptionLong  => 'Longer description',
                Display          => 0,
                DefaultValue     => 12345,
            },

        },
        FieldOrder => [
            'StateID',
            'DynamicField_Marke',
            'DynamicField_PeugeotModell',
            'DynamicField_PeugeotModell',
        ],
        Permission       => 'ro',
        RequiredLock     => '1',
        SubmitAdviceText => 'Waring test...',
        SubmitButtonText => 'Submit äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    UserID => $UserID,
);

$Self->IsNot(
    $ActivityDialogID,
    undef,
    "ActivityDialogADD() | ActivityDialogID is not undef",
);

my $TransitionID = $TransitionObject->TransitionAdd(
    EntityID => 'T-Test1',
    Name     => 'Transition 1',
    Config   => {
        Condition => {
            Type  => 'and',
            Cond1 => {
                Type   => 'and',
                Fields => {
                    DynamicField_Marke => {
                        Type  => 'String',
                        Match => 'Teststring',
                    },
                    DynamicField_VWModell => ['1'],
                    DynamicField_Regex    => {
                        Type  => 'Regexp',
                        Match => 'My[ ]Regexp',
                    },
                    DynamicField_Regex2 => {
                        Type  => 'Regexp',
                        Match => '.*',
                    },
                    DynamicField_String => {
                        Type  => 'String',
                        Match => 'Teststring',
                    },
                },
            },
            Cond2 => {
                DynamicField_Marke         => ['2'],
                DynamicField_PeugeotModell => ['1'],
            },
        },
    },
    UserID => $UserID,
);

$Self->IsNot(
    $TransitionID,
    undef,
    "TransitionADD() | TransitionID is not undef",
);

my $TransitionActionID = $TransitionActionObject->TransitionActionAdd(
    EntityID => 'TA-Test1',
    Name     => 'Queue Move',
    Config   => {
        Module => 'Kernel::System::Process::Transition::Action::QueueMove',
        Config => {
            TargetQueue => 'Raw',
            NewOwner    => 'root@localhost',
        },
    },
    UserID => $UserID,
);

$Self->IsNot(
    $TransitionActionID,
    undef,
    "TransitionActionADD() | TransitionActionID is not undef",
);

my $ExpectedResult;

$ExpectedResult->{Transition} = {
    'T-Test1' => {
        Name      => 'Transition 1',
        Condition => {
            Type  => 'and',
            Cond1 => {
                Type   => 'and',
                Fields => {
                    DynamicField_Marke => {
                        Type  => 'String',
                        Match => 'Teststring',
                    },
                    DynamicField_VWModell => ['1'],
                    DynamicField_Regex    => {
                        Type  => 'Regexp',
                        Match => 'My[ ]Regexp',
                    },
                    DynamicField_Regex2 => {
                        Type  => 'Regexp',
                        Match => '.*',
                    },
                    DynamicField_String => {
                        Type  => 'String',
                        Match => 'Teststring',
                    },
                },
            },
            Cond2 => {
                DynamicField_Marke         => ['2'],
                DynamicField_PeugeotModell => ['1'],
            },
        },
    },
};

# actual tests
my $ConfigHash = $ProcessObject->ProcessDump(
    ResultType => 'HASH',
    UserID     => 1,
);

$Self->Is(
    ref $ConfigHash,
    'HASH',
    "ProcessDump() HASH | Output is a hash",
);

# remove elements for easy compare
delete $ConfigHash->{Transition}->{'T-Test1'}->{CreateTime};
delete $ConfigHash->{Transition}->{'T-Test1'}->{ChangeTime};

$Self->IsDeeply(
    $ConfigHash->{Transition}->{'T-Test1'},
    $ExpectedResult->{Transition}->{'T-Test1'},
    "ProcessDump() HASH | Transition Expected result",
);

my $Output = $ProcessObject->ProcessDump( UserID => $UserID );

$Self->IsNot(
    length $Output,
    0,
    "ProcessDump() STRING | Output lenght",
);

for my $Part (
    qw(
    Process Process::Activity Process::ActivityDialog Process::Transition Process::TransitionAction
    )
    )
{
    my $Success;
    if ( $Output =~ m{ \$Self->\{ '$Part' \} \s+?  = \s+? \{ }msx ) {
        $Success = 1;
    }
    $Self->True(
        $Success,
        "ProcessDump() STRING | contains \$Self->{$Part} = { with True",
    );
}

for my $Entity (qw(P-Test1 A-Test1 AD-Test1 T-Test1 TA-Test1)) {
    my $Success;
    if ( $Output =~ m{'$Entity' \s+? =\> \s+? \{ }msx ) {
        $Success = 1;
    }
    $Self->True(
        $Success,
        "ProcessDump() STRING | contains $Entity => { with True",
    );
}

# clean the system
my $Success = $ProcessObject->ProcessDelete(
    ID     => $ProcessID,
    UserID => $UserID,
);

$Self->IsNot(
    $Success,
    undef,
    "ProcessDelete() | Success is not undef",
);

$Success = $ActivityObject->ActivityDelete(
    ID     => $ActivityID,
    UserID => $UserID,
);

$Self->IsNot(
    $Success,
    undef,
    "ActivityDelete() | Success is not undef",
);

$Success = $ActivityDialogObject->ActivityDialogDelete(
    ID     => $ActivityDialogID,
    UserID => $UserID,
);

$Self->IsNot(
    $Success,
    undef,
    "ActivityDialogDelete() | Success is not undef",
);

$Success = $TransitionObject->TransitionDelete(
    ID     => $TransitionID,
    UserID => $UserID,
);

$Self->IsNot(
    $Success,
    undef,
    "TransitionDelete() | Success is not undef",
);

$Success = $TransitionActionObject->TransitionActionDelete(
    ID     => $TransitionActionID,
    UserID => $UserID,
);

$Self->IsNot(
    $Success,
    undef,
    "TransitionActionDelete() | Success is not undef",
);

1;
