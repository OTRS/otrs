# --
# ProcessDump.t - ProcessManagement DB ProcessDump tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: ProcessDump.t,v 1.2 2012-07-20 06:07:04 cr Exp $
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
use Kernel::System::UnitTest::Helper;

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

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

my $ProcessID = $ProcessObject->ProcessAdd(
    EntityID      => 'PTest1',
    Name          => 'Process 1',
    StateEntityID => 'S1',
    Layout        => {},
    Config        => {
        Description         => 'a Description',
        StartActivity       => 'ATest1',
        StartActivityDialog => 'ADTest1',
        Path                => {                  # New way:
            'ATest1' => {
                'TTest1' => {
                    'ActivityID' => 'ATest2',
                    'Action'     => [
                        'TA1',
                        'TA2',
                        'TA3',
                    ],
                },
                'TTest2' => {
                    'ActivityID' => 'ATest3',
                },
            },
        },
    },
    UserID => 1,
);

$Self->IsNot(
    $ProcessID,
    undef,
    "ProcessADD() | ProcessID is not undef",
);

my $ActivityID = $ActivityObject->ActivityAdd(
    EntityID => 'ATest1',
    Name     => 'Activity 1',
    Config   => {
        ActivityDialog => {
            1 => 'ADTest1',
            2 => {
                ActivityDialogID => 'ADTest2',
                Overwrite        => {
                    FieldOrder => [ 1, 2, 4, 3 ],
                },
            },
        },
    },
    UserID => 1,
);

$Self->IsNot(
    $ActivityID,
    undef,
    "ActivityADD() | ActivityID is not undef",
);

my $ActivityDialogID = $ActivityDialogObject->ActivityDialogAdd(
    EntityID => 'ADTest1',
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
    UserID => 1,
);

$Self->IsNot(
    $ActivityDialogID,
    undef,
    "ActivityDialogADD() | DialogID is not undef",
);

my $Output = $ProcessObject->ProcessDump( UserID => 1 );

#print $Output;

$Self->IsNot(
    $Output,
    undef,
    "ProcessOutput() | Output is not undef",
);

my $Success = $ProcessObject->ProcessDelete(
    ID     => $ProcessID,
    UserID => 1,
);

$Self->IsNot(
    $Success,
    undef,
    "ProcessDelete() | Success is not undef",
);

$Success = $ActivityObject->ActivityDelete(
    ID     => $ActivityID,
    UserID => 1,
);

$Self->IsNot(
    $Success,
    undef,
    "ActivityDelete() | Success is not undef",
);

$Success = $ActivityDialogObject->ActivityDialogDelete(
    ID     => $ActivityDialogID,
    UserID => 1,
);

$Self->IsNot(
    $Success,
    undef,
    "ActivityDialogDelete() | Success is not undef",
);

1;
