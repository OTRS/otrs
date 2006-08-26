# --
# scripts/test/Stats.t - stats module testscript
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Stats.t,v 1.2 2006-08-26 17:36:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Stats;
use Kernel::System::Group;
use Kernel::System::User;
use Kernel::System::Main;
$Self->{UserID} = 1;
$Self->{GroupObject}    = Kernel::System::Group    ->new(%{$Self});
$Self->{UserObject}     = Kernel::System::User     ->new(%{$Self});
$Self->{MainObject}     = Kernel::System::Main     ->new(%{$Self});
$Self->{StatsObject}    = Kernel::System::Stats    ->new(%{$Self});

# check the StatsAddfunction
my $StatID1 = $Self->{StatsObject}->StatsAdd();
my $StatID2 = $Self->{StatsObject}->StatsAdd();

$Self->True(
    $StatID1 > 0,
    'StatsAdd() first StatID > 0',
);

$Self->True(
    $StatID2 > 0,
    'StatsAdd() second StatID > 0',
);

$Self->True(
    $StatID2 > $StatID1,
    'StatsAdd() first StatID < second StatID',
);

# check the stats update function
$Self->True(
    $Self->{StatsObject}->StatsUpdate(
        StatID => $StatID1,
        Hash   => {
            Title => 'TestTitle from UnitTest.pl',
            Description=> 'some Description'
        }
    ),
    "StatsUpdate() Update StatID1",
);
$Self->False(
    $Self->{StatsObject}->StatsUpdate(
        StatID => ($StatID2+1),
        Hash   => {
            Title => 'TestTitle from UnitTest.pl',
            Description=> 'some Description'
        }
    ),
    "StatsUpdate() try to update a invalid stat id (Ignore the Tracebacks on the top)",
);

# check get function
my $Stat = $Self->{StatsObject}->StatsGet(
    StatID => $StatID1,
);

$Self->Is(
    $Stat->{Title},
    'TestTitle from UnitTest.pl',
    'StatsGet() check the Title'
);

# check completenesscheck
my @Notify = $Self->{StatsObject}->CompletenessCheck(
    StatData => $Stat,
    Section  => 'All',
);
$Self->Is(
    $Notify[0]{Priority},
    'Error',
    'CompletenessCheck() check the checkfunctions'
);

# check StatsList
my $ArrayRef = $Self->{StatsObject}->GetStatsList(
    OrderBy   => 'StatID',
    Direction => 'ASC',
);

my $Counter = 0;
foreach (@{$ArrayRef}) {
    if ($_ eq $StatID1 || $_ eq $StatID2) {
        $Counter++;
    }
}

$Self->Is(
    $Counter,
    '2',
    'GetStatsList() check if StatID1 and StatID2 available in the statslist'
);

# check the available DynamicFiles
my $DynamicArrayRef = $Self->{StatsObject}->GetDynamicFiles();
$Self->{LogObject}->Dumper($DynamicArrayRef);
$Self->True(
    $DynamicArrayRef,
    'GetDynamicFiles() check if dynamic files available',
);

# check the sumbuild function
my @StatArray = @{$Self->{StatsObject}->SumBuild(
    Array => [
        ['Title'],
        ['SomeText', 'Column1','Column2','Column3','Column4','Column5'],
        ['Row1', 1,1,1,1,1],
        ['Row1', 2,2,2,2,2],
        ['Row1', 3,3,3,3,3],
    ],
    SumRow => 1,
    SumCol => 1,
)};

my @SubStatArray = @{$StatArray[$#StatArray]};
$Counter = $SubStatArray[$#SubStatArray];
$Self->Is(
    $Counter,
    '30',
    'GetStatsList() check if StatID1 and StatID2 available in the statslist'
);

# export StatID 1
my $ExportFile =  $Self->{StatsObject}->Export(StatID => $StatID1);
$Self->True(
    $ExportFile->{Content},
    'Export() check if Exportfile has a content',
);

# import the exportet stat
my $StatID3 = $Self->{StatsObject}->Import(
    Content  => $ExportFile->{Content},
);
$Self->True(
    $StatID3,
    'Import() is StatID3 true',
);

# check the imported stat
my $Stat3 = $Self->{StatsObject}->StatsGet(
    StatID => $StatID3,
);

$Self->Is(
    $Stat3->{Title},
    'TestTitle from UnitTest.pl',
    'StatsGet() check importet stat'
);

# check delete stat function
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID1),
    'StatsDelete() delete StatID1',
);
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID2),
    'StatsDelete() delete StatID2',
);
$Self->True(
    $Self->{StatsObject}->StatsDelete(StatID => $StatID3),
    'StatsDelete() delete StatID3',
);


#    use Kernel::System::Ticket;#
#
#    $Self->{UserObject}     = Kernel::System::User     ->new(%{$Self});
#    # get random user
#    my %UserHash = $Self->{UserObject}->UserList(Type => 'Long', Valid => 1); # Short
#    my @User     = keys(%UserHash);
#    $Self->{UserID} = $User[int(rand($#User))];
#    $Self->{TicketObject}   = Kernel::System::Ticket   ->new(%{$Self});
#    $Self->{GroupObject}    = Kernel::System::Group    ->new(%{$Self});
#    $Self->{MainObject}     = Kernel::System::Main     ->new(%{$Self});
#    $Self->{StateObject}    = Kernel::System::State    ->new(%{$Self});
#    $Self->{QueueObject}    = Kernel::System::Queue    ->new(%{$Self});
#    $Self->{PriorityObject} = Kernel::System::Priority ->new(%{$Self});
#    $Self->{LockObject}     = Kernel::System::Lock     ->new(%{$Self});
#
#    # Complex test scenario#
#
#    # At first delete the old tables
##    $Self->{DBObject}->Do(SQL => "DELETE FROM ticket_history");
##    $Self->{DBObject}->Do(SQL => "DELETE FROM article");
##    $Self->{DBObject}->Do(SQL => "DELETE FROM article_attachment");
##    $Self->{DBObject}->Do(SQL => "DELETE FROM article_plain");
##    $Self->{DBObject}->Do(SQL => "DELETE FROM time_accounting");
##    $Self->{DBObject}->Do(SQL => "DELETE FROM ticket");
#
#    my $TimeZone = 16000; #16000
#    while ($TimeZone > 50) { #50
#        my %CommonObject = ();
#        $TimeZone -= int(rand(300)*3600)/3600;
#        # create objects
#        $CommonObject{ConfigObject}     = Kernel::Config->new(%CommonObject);
#        # set time offset
#        $CommonObject{ConfigObject}->Set(Key => 'TimeZone', Value => -$TimeZone);
#        $CommonObject{LogObject} = Kernel::System::Log->new(%CommonObject);
#        $CommonObject{TimeObject}     = Kernel::System::Time     ->new(%CommonObject);
#        $CommonObject{DBObject}       = Kernel::System::DB       ->new(%CommonObject);
#        $CommonObject{TicketObject}   = Kernel::System::Ticket   ->new(%CommonObject);
#        $CommonObject{UserObject}     = Kernel::System::User     ->new(%CommonObject);
#        $CommonObject{GroupObject}    = Kernel::System::Group    ->new(%CommonObject);
#        $CommonObject{MainObject}     = Kernel::System::Main     ->new(%CommonObject);
#        $CommonObject{StateObject}    = Kernel::System::State    ->new(%CommonObject);
#        $CommonObject{QueueObject}    = Kernel::System::Queue    ->new(%CommonObject);
#        $CommonObject{PriorityObject} = Kernel::System::Priority ->new(%CommonObject);
#        $CommonObject{LockObject}     = Kernel::System::Lock     ->new(%CommonObject);#
#
#        my $CreateUser  = $User[int(rand($#User))];
#        my %StateHash   = $CommonObject{StateObject}   ->StateList   (UserID => $CreateUser);
#        my %QueuesHash  = $CommonObject{QueueObject}   ->GetAllQueues(UserID => $CreateUser, Type => 'rw');
#        my %PriorityIDs = $CommonObject{PriorityObject}->PriorityList(UserID => $CreateUser);
#        my %LockHash    = $CommonObject{LockObject}    ->LockList    (UserID => 1);
#        my @Lock        = values(%LockHash);
#        my @State       = values(%StateHash);
 #       my @Queue       = values(%QueuesHash);
#        my @Priority    = values(%PriorityIDs);
#
#        my $TicketID = $CommonObject{TicketObject}->TicketCreate(
#            TN            => $CommonObject{TicketObject}->TicketCreateNumber(),
#            Title         => 'Some Ticket Title AAAAAAA',
#            Queue         => $Queue[int(rand($#Queue + 1))],,
#            Lock          => $Lock[int(rand($#Lock + 1))],
#            Priority      => $Priority[int(rand($#Priority + 1))],
#            State         => $State[int(rand($#State + 1))],
#            CustomerNo    => '123465',
#            CustomerUser  => 'customer@example.com',
#            OwnerID       => $User[int(rand($#User + 1))],
#            ResponsibleID => $User[int(rand($#User + 1))],
#            UserID        => $CreateUser,
#        );
#        my $ArticleID = $CommonObject{TicketObject}->ArticleCreate(
#            TicketID       => $TicketID,
#            ArticleType    => 'note-internal',
#            SenderType     => 'agent',
#            From           => 'Some Agent AAAAA',
#            Subject        => 'alla',
#            Body           => 'hello',
#            ContentType    => 'text/plain; charset=ISO-8859-15',
#            HistoryType    => 'OwnerUpdate',
#            HistoryComment => 'Some free text!',
#            UserID         => $CreateUser,
#            NoAgentNotify  => 1,            # if you don't want to send agent notifications
#        );
#    }
1;
