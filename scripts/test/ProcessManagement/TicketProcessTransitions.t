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

my $DynamicFieldObject   = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ProcessObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
my $YAMLObject           = $Kernel::OM->Get('Kernel::System::YAML');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Define needed variables.
my $RandomID = $Helper->GetRandomID();
my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);

my %PartNameMap = (
    Activity         => 'Activities',
    ActivityDialog   => 'ActivityDialogs',
    Transition       => 'Transitions',
    TransitionAction => 'TransitionActions'
);

# This function appends a Random number to all process parts so they can be located later as they
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

my @Tests = (
    {
        Name   => 'Empty Process',
        Config => {
            UserID => $UserID,
        },
        ProcessFile => 'TestProcess.yml',
    },
);

for my $Test (@Tests) {

    my $ProcessData;

    # Read process for YAML file if needed.
    my $FileRef;
    if ( $Test->{ProcessFile} ) {
        $FileRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Home . '/scripts/test/sample/ProcessManagement/' . $Test->{ProcessFile},
        );
        my $RandomID = $Helper->GetRandomID();

        # Convert process to Perl for easy handling.
        $ProcessData = $YAMLObject->Load( Data => $$FileRef );
    }

    # Update all process names for easy search.
    if ( IsHashRefWithData($ProcessData) ) {
        $ProcessData = $UpdateNames->(
            ProcessData => $ProcessData,
            RandomID    => $RandomID,
        );
    }

    # Convert process back to YAML and set it as part of the config.
    my $Content = $YAMLObject->Dump( Data => $ProcessData );
    $Test->{Config}->{Content} = $Content;

    my %ProcessImport = $ProcessObject->ProcessImport( %{ $Test->{Config} } );

    $Self->True(
        $ProcessImport{Success},
        "ProcessImport() $Test->{Name} - return value with true",
    );

    # Get CurrentProcessID.
    my $CurrentProcessList = $ProcessObject->ProcessListGet(
        UserID => $UserID,
    );

    my @ProcessTest      = grep { $_->{Name} eq $ProcessData->{Process}->{Name} } @{$CurrentProcessList};
    my $CurrentProcessID = $ProcessTest[0]->{ID};

    $Self->IsNot(
        $CurrentProcessID,
        undef,
        "ProcessImport() $Test->{Name} - Process found by name, ProcessID must not be undef",
    );

    my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZProcessManagement.pm';

    my $ProcessDump = $ProcessObject->ProcessDump(
        ResultType => 'FILE',
        Location   => $Location,
        UserID     => $UserID,
    );

    $Self->True(
        $ProcessDump,
        "ProcessDump() - is done",
    );

    my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity')->EntitySyncStatePurge(
        UserID => $UserID,
    );

    $Self->True(
        $Success,
        "ProcessSync is done",
    );

    # Create ticket.
    my %TicketTemplate = (
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerID   => "123465$RandomID",
        CustomerUser => 'customer@example.com',
        OwnerID      => $UserID,
        UserID       => $UserID,
    );
    my $TicketID = $TicketObject->TicketCreate(
        %TicketTemplate,
        Title => "Test1 $RandomID",
    );
    $Self->IsNot(
        $TicketID,
        undef,
        'TicketCrete()'
    );

    # Create article.
    my %ArticleTemplate = (
        SenderType           => 'agent',
        IsVisibleForCustomer => 1,
        Subject              => 'some short description',
        Body                 => 'Ticket Original',
        ContentType          => 'text/plain; charset=UTF8',
        HistoryComment       => 'Created new ticket',
        HistoryType          => 'AddNote',
        UserID               => $UserID,
    );
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        %ArticleTemplate,
        TicketID => $TicketID,
    );
    $Self->IsNot(
        $ArticleID,
        undef,
        'ArticleCrete()'
    );

    # Get Dynamic Fields Configuration
    my $ProcessIDDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID'),
    );
    my $ActivityIDDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID'),
    );

    # Get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Get Process list.
    my $List = $ProcessObject->ProcessList(
        UseEntities    => 1,
        StateEntityIDs => ['S1'],
        UserID         => $UserID,
    );

    # Get Process entity.
    my %ListReverse = reverse %{$List};

    my $ProcessEntityID = $ListReverse{ 'TestProcess' . $RandomID };
    my $Process         = $ProcessObject->ProcessGet(
        EntityID => $ProcessEntityID,
        UserID   => $UserID,
    );

    # Enroll Ticket into process
    my $Sucess = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $ProcessIDDynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => $ProcessEntityID,
        UserID             => $UserID,
    );
    $Self->True(
        $Sucess,
        "Process Enrollment DynamicField ValueSet() for Process for TicketID $TicketID"
    );
    $Sucess = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $ActivityIDDynamicFieldConfig,
        ObjectID           => $TicketID,
        Value              => $Process->{Activities}->[0],
        UserID             => 1,
    );
    $Self->True(
        $Sucess,
        "Process Enrollment DynamicField ValueSet() for Activity for TicketID $TicketID"
    );

    $Success = $ProcessObject->ProcessDelete(
        ID     => $Process->{ID},
        UserID => $UserID,
    );

    $Self->True(
        $Success,
        'ProcessDelete()',
    );

    $Helper->ConfigSettingChange(
        Valid => 1,
        Key   => 'Ticket::EventModulePost###9800-TicketProcessTransitions',
        Value => {
            Event       => 'TicketQueueUpdate',
            Module      => 'Kernel::System::Ticket::Event::TicketProcessTransitions',
            Transaction => 0,
        },
    );

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
    $LogObject->CleanUp();

    # Ticket queue update in order to trigger TicketProcessTransitions event.
    my $QueueID        = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => 'Junk' );
    my $TicketQueueSet = $TicketObject->TicketQueueSet(
        QueueID  => $QueueID,
        TicketID => $TicketID,
        UserID   => $UserID,
    );

    $Self->True(
        $TicketQueueSet,
        'TicketQueueSet()',
    );

    # Check if processing of transition throws error for tickets assigned to unknown, deleted  or invalid processes.
    # See more in the bug#15016.
    $Self->True(
        index( $LogObject->GetLog(), "No Data for Process \'$ProcessEntityID\' found!" ) == -1,
        "There are no error log for TicketProcessTransitions event after deleting proccess",
    );
}

# Cleanup is done by RestoreDatabase.

1;
