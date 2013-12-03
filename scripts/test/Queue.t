# --
# Queue.t - Queue tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Queue;
use Kernel::System::StandardTemplate;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);
my $QueueObject            = Kernel::System::Queue->new( %{$Self} );
my $StandardTemplateObject = Kernel::System::StandardTemplate->new( %{$Self} );

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
    'QueueAdd()',
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

# a real szenario from AdminQueue.pm
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
    'QueueUpdate() - a real szenario from AdminQueue.pm',
);

my $QueueUpdate1 = $QueueObject->QueueUpdate(
    QueueID             => $QueueID,
    Name                => $QueueRand . '1',
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

my %Responses = $QueueObject->GetStandardResponses( QueueID => 1 );
$Self->IsDeeply(
    \%Templates,
    \%Responses,
    "QueueStandardTemplateMemberList() and GetStandardResponse() for QueueID 1",
);

# check cache
my $CacheKey = "StandardTemplates::1::0";
my $Cache = $QueueObject->{CacheInternalObject}->Get( Key => $CacheKey );
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

my %ResponsesTemplateType = $QueueObject->GetStandardResponses(
    QueueID       => 1,
    TemplateTypes => 1,
);
$Self->IsDeeply(
    \%TemplatesByType,
    \%ResponsesTemplateType,
    "QueueStandardTemplateMemberList() and GetStandardResponse() for QueueID 1 using TemplateType",
);

# check cache
$CacheKey = "StandardTemplates::1::1";
$Cache = $QueueObject->{CacheInternalObject}->Get( Key => $CacheKey );
$Self->IsDeeply(
    \%TemplatesByType,
    $Cache,
    "QueueStandardTemplateMemberList() cache for QueueID 1 using TeemplateType",
);

# get template types from config
my $TemplateTypes = $Self->{ConfigObject}->Get("StandardTemplate::Types");

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

1;
