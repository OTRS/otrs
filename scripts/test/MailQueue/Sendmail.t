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

use List::Util qw();
use vars (qw($Self));

use Kernel::System::Email::Sendmail;

no strict 'refs';    ## no critic

my $Home           = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my %SendmailAction = (
    Success => '-s',
    Failed  => '-f',
);
my $Action = 'Success';

# Overwrite the OTRS Email::Sendmail check method to use our fake sendmail client,
#   but make this change local to the unit test scope, as you can see, it also
#   makes use of the %FakeSendmailEnv.
local *{'Kernel::System::Email::Sendmail::Check'} = sub {
    my ( $Self, %Param ) = @_;

    return (
        Success  => 1,
        Sendmail => "$Home/scripts/test/sample/PostMaster/SendmailTest.sh $SendmailAction{$Action}",
    );
};

use strict 'refs';

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$HelperObject->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$HelperObject->ConfigSettingChange(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Sendmail',
);

my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

# delete possible messages from mail queue
my $Success = $MailQueueObject->Delete();

$Self->True(
    $Success,
    'Delete possible messages from mail queue!',
);

my $SendEmail = sub {
    my %Param = @_;

    # Generate the mail and queue it.
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();

    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    return ( $LastItem, $MailQueueObject->Send( %{$LastItem} ) );
};

my $MailQueueSend = sub {

    # Send the queued emails.

    my @Processed = ();
    my $Items     = $MailQueueObject->List();

    for my $Item ( @{$Items} ) {
        $MailQueueObject->Send(
            %{$Item},
            Force => 1,
        );
        push @Processed, $Item;
    }

    return \@Processed;
};

my $CheckForQueueItem = sub {
    my %Param = @_;

    my $MessageName       = $Param{MessageName};
    my $MailQueueItemSent = $Param{MailQueueItemSent};
    my $StillInQueue      = $Param{StillInQueue};

    # Check for the queue item.
    my $MailQueueItems = $MailQueueObject->List(
        ID => $MailQueueItemSent->{ID},
    );

    $Self->$StillInQueue(
        scalar @{$MailQueueItems},
        sprintf(
            '%s, %s in queue',
            $MessageName,
            $StillInQueue eq 'True' ? 'still' : 'not',
        ),
    );

    return;
};

my @Tests = (
    {
        Name               => 'Email success test 1',
        Action             => 'Success',
        ExpectedSendStatus => 'Success',
        StillInQueue       => 'False',
    },
    {
        Name               => 'Email fail test 1',
        Action             => 'Failed',
        ExpectedSendStatus => 'Failed',
        StillInQueue       => 'True',
    },
    {
        Name               => 'Email success test 2',
        Action             => 'Success',
        ExpectedSendStatus => 'Success',
        StillInQueue       => 'False',
    },
    {
        Name               => 'Email fail test 2',
        Action             => 'Failed',
        ExpectedSendStatus => 'Failed',
        StillInQueue       => 'True',
    },
    {
        Name               => 'Email success test 3',
        Action             => 'Success',
        ExpectedSendStatus => 'Success',
        StillInQueue       => 'False',
    },
    {
        Name               => 'Email fail test 3',
        Action             => 'Failed',
        ExpectedSendStatus => 'Failed',
        StillInQueue       => 'True',
    },
);

TEST:
for my $Test (@Tests) {

    $Action = $Test->{Action};

    # Just try to send a simple mail.
    my ( $ItemSent, $SendResult ) = $SendEmail->(
        From     => 'john.smith@example.com',
        To       => 'john.smith2@example.com',
        Subject  => 'some subject',
        Body     => 'Some Body',
        MimeType => 'text/html',
        Charset  => 'utf8',
    );

    $Self->True(
        $SendResult->{Status} eq $Test->{ExpectedSendStatus},
        $Test->{Name},
    );

    $CheckForQueueItem->(
        MessageName       => $Test->{Name},
        StillInQueue      => $Test->{StillInQueue},
        MailQueueItemSent => $ItemSent,
    );

    next TEST if $Action eq 'Success';

    # second attempt
    my $MailQueueItemsSent = $MailQueueSend->();
    $CheckForQueueItem->(
        MessageName       => $Test->{Name},
        MailQueueItemSent => $MailQueueItemsSent->[0],
        StillInQueue      => 'True',
    );

    # last attempt
    $MailQueueItemsSent = $MailQueueSend->();
    $CheckForQueueItem->(
        MessageName       => $Test->{Name},
        MailQueueItemSent => $MailQueueItemsSent->[0],
        StillInQueue      => 'False',
    );
}

# restore to the previous state is done by RestoreDatabase

1;
