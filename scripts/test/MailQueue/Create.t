# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CreateMailQueueElement = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my %ElementData     = (
        Sender    => 'mailqueue.test@otrs.com',
        Recipient => 'mailqueue.test@otrs.com',
        Message   => {
            'Key1' => 'Value1',
            'Key2' => 'Value2',
        },
    );

    return $MailQueueObject->Create(
        %ElementData,
        %Param,
    );
};

# START THE TESTS

# Ensure check mail addresses is enabled.
$HelperObject->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# Disable MX record check.
$HelperObject->ConfigSettingChange(
    Key   => 'CheckMXRecord',
    Value => 0,
);

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

# Pass no params.
$Result = $MailQueueObject->Create();
$Self->False(
    $Result,
    'Trying to create a queue element without passing params.',
);

# Pass an invalid sender address
$Result = $CreateMailQueueElement->(
    Sender => 'dummy',
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid sender.',
);

# Pass an invalid Recipient address
$Result = $CreateMailQueueElement->(
    Recipient => 'dummy',
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid recipient.',
);

# Pass an invalid Recipient address (array)
$Result = $CreateMailQueueElement->(
    Recipient => [ 'mailqueue.test@otrs.com', 'dummy' ],
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid recipient (array).',
);

# Simple recipient
$Result = $CreateMailQueueElement->();
$Self->True(
    $Result,
    'Trying to create a queue element with simple recipient.',
);

# ArrayRef recipient
$Result = $CreateMailQueueElement->(
    Recipient => [ 'mailqueue.test@otrs.com', 'mailqueue.test@otrs.com' ],
);
$Self->True(
    $Result,
    'Trying to create a queue element with arrayref recipient.',
);

for my $Idx ( 0 .. 1 ) {
    $Result = $CreateMailQueueElement->(
        ArticleID => 1,
        MessageID => 'dummy',
    );
    my $TestType = $Idx ? 'False' : 'True';
    $Self->$TestType(
        $Result,
        'Trying to create a queue element to article-id 1, attempt ' . ( $Idx + 1 ),
    );
}

# Check if communication-log lookup was created.
my $Item = $MailQueueObject->Get(
    ArticleID => 1,
);
my $CommunicationLogDBObj = $Kernel::OM->Get(
    'Kernel::System::CommunicationLog::DB',
);
my $ComLookupInfo = $CommunicationLogDBObj->ObjectLookupGet(
    TargetObjectType => 'MailQueueItem',
    TargetObjectID   => $Item->{ID},
) || {};

$Self->True(
    $ComLookupInfo->{ObjectLogID},
    'Found communication-log lookup information for the queue element.',
);

# restore to the previous state is done by RestoreDatabase

1;
