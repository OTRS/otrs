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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
my $HelperObject           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
my $QueueObject            = $Kernel::OM->Get('Kernel::System::Queue');

my $QueueRand = 'Some::Queue' . int( rand(1000000) );
my $QueueID   = $QueueObject->QueueAdd(
    Name                => $QueueRand,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

$Self->True(
    $QueueID,
    "QueueAdd() - $QueueRand, $QueueID",
);

my @IDs;

push( @IDs, $QueueID );

my $QueueIDWrong = $QueueObject->QueueAdd(
    Name                => $QueueRand,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

$Self->False(
    $QueueIDWrong,
    'QueueAdd() - Try to add new queue with existing queue name',
);

my %QueueGet = $QueueObject->QueueGet( ID => $QueueID );

$Self->True(
    $QueueGet{Name} eq $QueueRand,
    'QueueGet() - Name',
);
$Self->True(
    $QueueGet{ValidID} eq 1,
    'QueueGet() - ValidID',
);
$Self->True(
    $QueueGet{Calendar} eq '',
    'QueueGet() - Calendar',
);
$Self->True(
    $QueueGet{Comment} eq 'Some Comment',
    'QueueGet() - Comment',
);
$Self->True(
    $QueueGet{FirstResponseTime} eq 30,
    'QueueGet() - FirstResponseTime',
);
$Self->True(
    $QueueGet{FirstResponseNotify} eq 70,
    'QueueGet() - FirstResponseNotify',
);

$Self->True(
    $QueueGet{UpdateTime} eq 240,
    'QueueGet() - UpdateTime',
);
$Self->True(
    $QueueGet{UpdateNotify} eq 80,
    'QueueGet() - UpdateNotify',
);

$Self->True(
    $QueueGet{SolutionTime} eq 2440,
    'QueueGet() - SolutionTime',
);
$Self->True(
    $QueueGet{SolutionNotify} eq 90,
    'QueueGet() - SolutionNotify',
);

my $Queue = $QueueObject->QueueLookup( QueueID => $QueueID );

$Self->True(
    $Queue eq $QueueRand,
    'QueueLookup() by ID',
);

my $QueueIDLookup = $QueueObject->QueueLookup( Queue => $Queue );

$Self->True(
    $QueueID eq $QueueIDLookup,
    'QueueLookup() by Name',
);

# a real scenario from AdminQueue.pm
# for more information see 3139
my $QueueUpdate2 = $QueueObject->QueueUpdate(
    QueueID             => $QueueID,
    Name                => $QueueRand . "2",
    ValidID             => 1,
    GroupID             => 1,
    Calendar            => '',
    FirstResponseTime   => '',
    FirstResponseNotify => '',
    UpdateTime          => '',
    UpdateNotify        => '',
    SolutionTime        => '',
    SolutionNotify      => '',
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    FollowUpID          => 1,
    UserID              => 1,
    Comment             => 'Some Comment2',
    DefaultSignKey      => '',
    UnlockTimeOut       => '',
    FollowUpLock        => 1,
    ParentQueueID       => '',
);

$Self->True(
    $QueueUpdate2,
    'QueueUpdate() - a real scenario from AdminQueue.pm',
);

my $QueueUpdate1Name = $QueueRand . '1',;
my $QueueUpdate1     = $QueueObject->QueueUpdate(
    QueueID             => $QueueID,
    Name                => $QueueUpdate1Name,
    ValidID             => 2,
    GroupID             => 1,
    Calendar            => '1',
    FirstResponseTime   => 60,
    FirstResponseNotify => 60,
    UpdateTime          => 480,
    UpdateNotify        => 70,
    SolutionTime        => 4880,
    SolutionNotify      => 80,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    FollowUpID          => 1,
    UserID              => 1,
    Comment             => 'Some Comment1',
);

$Self->True(
    $QueueUpdate1,
    'QueueUpdate()',
);

#add another queue for testing update queue with existing name
my $Queue2Rand = 'Some::Queue2' . int( rand(1000000) );
my $QueueID2   = $QueueObject->QueueAdd(
    Name            => $Queue2Rand,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    Comment         => 'Some Comment',
);

$Self->True(
    $QueueID2,
    "QueueAdd() - $Queue2Rand, $QueueID2",
);

push( @IDs, $QueueID2 );

#add subqueue
my $SubQueueName = '::SubQueue' . int( rand(1000000) );
my $SubQueue1    = $Queue2Rand . $SubQueueName;
my $QueueID3     = $QueueObject->QueueAdd(
    Name            => $SubQueue1,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    Comment         => 'Some Comment',
);

$Self->True(
    $QueueID3,
    "QueueAdd() - $SubQueue1, $QueueID3",
);

push( @IDs, $QueueID3 );

#add subqueue with name that exists in another parent queue
my $SubQueue2 = $QueueUpdate1Name . $SubQueueName;
my $QueueID4  = $QueueObject->QueueAdd(
    Name            => $SubQueue2,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    Comment         => 'Some Comment',
);

$Self->True(
    $QueueID4,
    "QueueAdd() - $SubQueue2, $QueueID4",
);

push( @IDs, $QueueID4 );

#add subqueue with name that exists in the same parent queue
$QueueIDWrong = $QueueObject->QueueAdd(
    Name            => $SubQueue2,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => 1,
    Comment         => 'Some Comment',
);

$Self->False(
    $QueueIDWrong,
    "QueueAdd() - $SubQueue2",
);

#try to update subqueue with existing name
my $QueueUpdateExist = $QueueObject->QueueUpdate(
    Name            => $SubQueue1,
    QueueID         => $QueueID4,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    FollowUpID      => 1,
    UserID          => 1,
    Comment         => 'Some Comment1',
);

$Self->False(
    $QueueUpdateExist,
    "QueueUpdate() - update subqueue with existing name",
);

#try to update queue with existing name
$QueueUpdateExist = $QueueObject->QueueUpdate(
    Name            => $QueueRand . '1',
    QueueID         => $QueueID2,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    FollowUpID      => 1,
    UserID          => 1,
    Comment         => 'Some Comment1',
);

$Self->False(
    $QueueUpdateExist,
    "QueueUpdate() - update queue with existing name",
);

# check function NameExistsCheck()
# check does it exist a queue with certain Name or
# check is it possible to set Name for queue with certain ID
my $Exist = $QueueObject->NameExistsCheck(
    Name => $Queue2Rand,
);

$Self->True(
    $Exist,
    "NameExistsCheck() - A queue with \'$Queue2Rand\' already exists!",
);

# there is a queue with certain name, now check if there is another one
$Exist = $QueueObject->NameExistsCheck(
    Name => "$Queue2Rand",
    ID   => $QueueID2,
);

$Self->False(
    $Exist,
    "NameExistsCheck() - Another queue \'$Queue2Rand\' for ID=$QueueID2 does not exists!",
);

$Exist = $QueueObject->NameExistsCheck(
    Name => $Queue2Rand,
    ID   => $QueueID,
);

$Self->True(
    $Exist,
    "NameExistsCheck() - Another queue \'$Queue2Rand\' for ID=$QueueID already exists!",
);

#check for subqueue
$Exist = $QueueObject->NameExistsCheck(
    Name => $SubQueue2,
);

$Self->True(
    $Exist,
    "NameExistsCheck() - Another subqueue \'$SubQueue2\' already exists!",
);

$Exist = $QueueObject->NameExistsCheck(
    Name => $SubQueue2,
    ID   => $QueueID4,
);

$Self->False(
    $Exist,
    "NameExistsCheck() - Another subqueue \'$SubQueue2\' for ID=$QueueID4 does not exists!",
);

$Exist = $QueueObject->NameExistsCheck(
    Name => $SubQueue2,
    ID   => $QueueID3,
);

$Self->True(
    $Exist,
    "NameExistsCheck() - Another subqueue \'$SubQueue2\' for ID=$QueueID3 already exists!",
);

# check is there a queue whose name has been updated in the meantime
$Exist = $QueueObject->NameExistsCheck(
    Name => $QueueRand,
);

$Self->False(
    $Exist,
    "NameExistsCheck() - A queue with \'$QueueRand\' does not exists!",
);

$Exist = $QueueObject->NameExistsCheck(
    Name => $QueueRand,
    ID   => $QueueID,
);

$Self->False(
    $Exist,
    "NameExistsCheck() - Another queue \'$QueueRand\' for ID=$QueueID does not exists!",
);

# lookup the queue name for $QueueID
my $LookupQueueName = $QueueObject->QueueLookup( QueueID => $QueueID );

$Self->Is(
    $LookupQueueName,
    $QueueRand . '1',
    "QueueLookup() - lookup the queue name for ID $QueueID",
);

# lookup the queue id for $QueueRand . '1'
my $LookupQueueID = $QueueObject->QueueLookup( Queue => $QueueRand . '1' );

$Self->Is(
    $LookupQueueID,
    $QueueID,
    "QueueLookup() - lookup the queue ID for queue name " . $QueueRand . '1',
);

# lookup the queue id for $QueueRand, this should be undef, because this queue was renamed meanwhile!
$LookupQueueID = $QueueObject->QueueLookup( Queue => $QueueRand );

$Self->Is(
    $LookupQueueID,
    undef,
    "QueueLookup() - lookup the queue ID for queue name " . $QueueRand,
);

%QueueGet = $QueueObject->QueueGet( ID => $QueueID );

$Self->True(
    $QueueGet{Name} eq $QueueRand . "1",
    'QueueGet() - Name',
);
$Self->True(
    $QueueGet{ValidID} eq 2,
    'QueueGet() - ValidID',
);
$Self->True(
    $QueueGet{Calendar} eq 1,
    'QueueGet() - Calendar',
);
$Self->True(
    $QueueGet{Comment} eq 'Some Comment1',
    'QueueGet() - Comment',
);

$Self->True(
    $QueueGet{FirstResponseTime} eq 60,
    'QueueGet() - FirstResponseTime',
);
$Self->True(
    $QueueGet{FirstResponseNotify} eq 60,
    'QueueGet() - FirstResponseNotify',
);

$Self->True(
    $QueueGet{UpdateTime} eq 480,
    'QueueGet() - UpdateTime',
);
$Self->True(
    $QueueGet{UpdateNotify} eq 70,
    'QueueGet() - UpdateNotify',
);

$Self->True(
    $QueueGet{SolutionTime} eq 4880,
    'QueueGet() - SolutionTime',
);
$Self->True(
    $QueueGet{SolutionNotify} eq 80,
    'QueueGet() - SolutionNotify',
);

$Queue = $QueueObject->QueueLookup( QueueID => $QueueID );

$Self->True(
    $Queue eq $QueueRand . "1",
    'QueueLookup() by ID',
);

$QueueIDLookup = $QueueObject->QueueLookup( Queue => $Queue );

$Self->True(
    $QueueID eq $QueueIDLookup,
    'QueueLookup() by Name',
);

# get normal tenpolates
my %Templates = $QueueObject->QueueStandardTemplateMemberList( QueueID => 1 );
$Self->True(
    IsHashRefWithData( \%Templates ),
    "QueueStandardTemplateMemberList() for QueueID 1 is a Hash with data",
);

# check cache
my $CacheKey = "StandardTemplates::1::0";
my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
    Type => 'Queue',
    Key  => $CacheKey,
);
$Self->IsDeeply(
    \%Templates,
    $Cache,
    "QueueStandardTemplateMemberList() cache for QueueID 1",
);

# get responses by template type
my %TemplatesByType = $QueueObject->QueueStandardTemplateMemberList(
    QueueID       => 1,
    TemplateTypes => 1,
);

$Self->True(
    IsHashRefWithData( \%TemplatesByType ),
    "QueueStandardTemplateMemberList() for QueueID 1 using TemplateTypes is a Hash with data",
);

# check cache
$CacheKey = "StandardTemplates::1::1";
$Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
    Type => 'Queue',
    Key  => $CacheKey,
);
$Self->IsDeeply(
    \%TemplatesByType,
    $Cache,
    "QueueStandardTemplateMemberList() cache for QueueID 1 using TeemplateType",
);

# get template types from config
my $TemplateTypes = $ConfigObject->Get("StandardTemplate::Types");

for my $TemplateType ( sort keys %TemplatesByType ) {
    $Self->True(
        $TemplateTypes->{$TemplateType},
        "Template Type '$TemplateType' exists in the system configuration",
    );

    $Self->True(
        IsHashRefWithData( $TemplatesByType{$TemplateType} ),
        "QueueStandardTemplateMemberList() Type '$TemplateType' for QueueID 1 is a Hash with data",
    );
}

# QueueStandardTemplateMemeberAdd() tests
my $UserID   = 1;
my $RandomID = $HelperObject->GetRandomID();

# create a new template
my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
    Name         => 'New Standard Template' . $RandomID,
    Template     => 'Thank you for your email.',
    ContentType  => 'text/plain; charset=utf-8',
    TemplateType => 'Answer',
    ValidID      => 1,
    UserID       => $UserID,
);

$Self->IsNot(
    $TemplateID,
    undef,
    "StandardTemplateAdd() for QueueStandardTemplateMemeberAdd() | Template ID should not be undef",
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name    => 'Empty Config',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing QueueID',
        Config => {
            QueueID            => undef,
            StandardTemplateID => $TemplateID,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Missing StandardTemplateID',
        Config => {
            QueueID            => 1,
            StandardTemplateID => undef,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            QueueID            => 1,
            StandardTemplateID => $TemplateID,
            UserID             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Correct Relation',
        Config => {
            QueueID            => 1,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Relation (removal)',
        Config => {
            QueueID            => 1,
            StandardTemplateID => $TemplateID,
            Active             => 0,
            UserID             => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $QueueObject->QueueStandardTemplateMemberAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} QueueStandardTemplateMemberAdd() with true",
        );

        # get assigned templates
        my %Templates = $QueueObject->QueueStandardTemplateMemberList(
            QueueID => $Test->{Config}->{QueueID},
        );

        if ( $Test->{Config}->{Active} ) {
            $Self->IsNot(
                $Templates{$TemplateID} || '',
                '',
                "$Test->{Name} QueueStandardTemplateMemberList() | $TemplateID should be assingned"
                    . " and must have a value",
            );
        }
        else {
            $Self->Is(
                $Templates{$TemplateID} || '',
                '',
                "$Test->{Name} QueueStandardTemplateMemberList() | $TemplateID should not be"
                    . " assingned and must not have a value",
            );
        }
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} QueueStandardTemplateMemberAdd() with false",
        );
    }
}

# cleanup
my $Success = $StandardTemplateObject->StandardTemplateDelete(
    ID => $TemplateID,
);

$Self->True(
    $Success,
    "StandardTemplateDelete() for QueueStandardTemplateMemeberAdd() | with True",
);

# Since there are no tickets that rely on our test queues, we can remove them again
# from the DB.
for my $ID (@IDs) {
    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM queue_preferences WHERE queue_id = $ID",
    );
    $Self->True(
        $Success,
        "QueueDelete preferences - $ID",
    );

    $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM queue WHERE id = $ID",
    );
    $Self->True(
        $Success,
        "QueueDelete - $ID",
    );
}

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'Queue',
);

1;
