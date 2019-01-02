# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
        ArticleID => 1,
        MessageID => 'dummy',
        ID        => -99,
    );

    my $Result = $MailQueueObject->Create( %ElementData, );
    $Self->True(
        $Result,
        'Created the test element successfuly.'
    );

    return \%ElementData;
};

my $Test = sub {
    my %Param = @_;

    my $Filters = $Param{Filters};
    my $Test    = $Param{Test};

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Result;

    my $TestBaseMessage = sprintf(
        'Delete records that match "%s"',
        join( ',', map { $_ . '=' . $Filters->{$_} } sort( keys( %{$Filters} ) ) ),
    );

    $Result = $MailQueueObject->Delete( %{$Filters} );
    $Self->True( $Result, $TestBaseMessage, );

    # Ensure record doesn't exist.
    $Result = $MailQueueObject->List( %{$Filters} );
    $Self->True(
        $Result && scalar( @{$Result} ) == 0,
        $TestBaseMessage . ', records not found.',
    );

    return;
};

my $TestDeleteByID = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Element         = $CreateTestData->();
    $Test->(
        Filters => {
            ID => $Element->{ID},
        },
    );

    return;
};

my $TestDeleteByArticleID = sub {
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Element         = $CreateTestData->();
    $Test->(
        Filters => {
            ArticleID => $Element->{ArticleID},
        },
    );

    return;
};

my $TestDeleteByMultipleColumns = sub {
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Element         = $CreateTestData->();
    $Test->(
        Filters => {
            ArticleID => $Element->{ArticleID},
            Sender    => 'mailqueue.test@otrs.com',
        },
    );

    return;
};

# START THE TESTS

$TestDeleteByID->();
$TestDeleteByArticleID->();
$TestDeleteByMultipleColumns->();

# restore to the previous state is done by RestoreDatabase

1;
