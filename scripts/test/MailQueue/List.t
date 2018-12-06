# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

my $CreateTestData = sub {
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

    my %Elements = (
        'Article::1' => {
            %ElementData,
            ArticleID => 1,
            MessageID => 'dummy',
        },

        'Attempts::3' => {
            %ElementData,
            Attempts => 3,
        },

        'Recipient::mailqueue.test2@otrs.com' => {
            %ElementData,
            Recipient => 'mailqueue.test2@otrs.com',
        }
    );

    for my $Key ( sort keys %Elements ) {
        my $Result = $MailQueueObject->Create( %{ $Elements{$Key} } );
        $Self->True(
            $Result,
            sprintf( 'Created the mail queue element "%s" successfuly.', $Key, ),
        );
    }

    return scalar( keys %Elements );
};

my $TotalTestRecords = $CreateTestData->();

# START THE TESTS

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

my %BaseSearch = (
    Sender => 'mailqueue.test@otrs.com',
);

my $TestMessage = sub {
    return sprintf( q{Get all the records for the sender '%s'%s.}, $BaseSearch{Sender}, ( shift || '' ), );
};

# Get all records for the sender X
$Result = $MailQueueObject->List(%BaseSearch);
$Self->True(
    $Result && scalar( @{$Result} ) == $TotalTestRecords,
    $TestMessage->(),
);

# Get all the records for the sender X and recipient Y
$Result = $MailQueueObject->List( %BaseSearch, Recipient => 'mailqueue.test2@otrs.com' );
$Self->True(
    $Result && scalar( @{$Result} ) == 1,
    $TestMessage->(q{ and recipient 'mailqueue.test2@otrs.com'}),
);

# Get all the records for the sender X and attempts 3
$Result = $MailQueueObject->List( %BaseSearch, Attempts => 3 );
$Self->True(
    $Result && scalar( @{$Result} ) == 1,
    $TestMessage->(q{ and attempts '3'}),
);

# Get all the records for the sender X and article-id 1
$Result = $MailQueueObject->List( %BaseSearch, ArticleID => 1 );
$Self->True(
    $Result && scalar( @{$Result} ) == 1,
    $TestMessage->(q{ and article-id '1'}),
);

# Get all the records for the sender X and recipent that match '@otrs.com'
$Result = $MailQueueObject->List( %BaseSearch, Recipient => '@otrs.com' );
$Self->True(
    $Result && scalar( @{$Result} ) == $TotalTestRecords,
    $TestMessage->(q{ and recipent that match '@otrs.com'}),
);

# Get all the records for the sender that match 'mailqueue.test'
$Result = $MailQueueObject->List( Sender => 'mailqueue.test@' );
$Self->True(
    $Result && scalar( @{$Result} ) == $TotalTestRecords,
    q{Get all the records where sender match 'mailqueue.test@'.},
);

# restore to the previous state is done by RestoreDatabase

1;
