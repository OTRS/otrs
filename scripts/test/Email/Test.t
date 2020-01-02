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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# do not really send emails
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

my $SendEmail = sub {
    my %Param = @_;

    my $EmailObject     = $Kernel::OM->Get('Kernel::System::Email');
    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

    # Delete mail queue
    $MailQueueObject->Delete();

    # Generate the mail and queue it
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();
    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    my $Result = $MailQueueObject->Send( %{$LastItem} );

    return (
        \$LastItem->{Message}->{Header},
        \$LastItem->{Message}->{Body},
    );
};

# get test email backed object
my $TestBackendObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

# get email object
my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

for ( 1 .. 2 ) {

    # call Send and get results
    my ( $Header, $Body ) = $SendEmail->(
        From     => 'john.smith@example.com',
        To       => 'john.smith2@example.com',
        Subject  => 'some subject',
        Body     => 'Some Body',
        MimeType => 'text/html',
        Charset  => 'utf8',
    );

    $Self->True(
        $Body,
        "Email delivered to backend",
    );
}

my $Emails = $TestBackendObject->EmailsGet();

$Self->Is(
    scalar @{$Emails},
    2,
    "Emails fetched from backend",
);

for my $Index ( 0 .. 1 ) {
    $Self->Is(
        $Emails->[$Index]->{From},
        'john.smith@example.com',
        "From header",
    );
    $Self->IsDeeply(
        $Emails->[$Index]->{ToArray},
        ['john.smith2@example.com'],
        "To header",
    );
    $Self->True(
        $Emails->[$Index]->{Header},
        "Header field",
    );
    $Self->True(
        $Emails->[$Index]->{Body},
        "Body field",
    );
}

$Success = $TestBackendObject->CleanUp();
$Self->True(
    $Success,
    'Final cleanup',
);

$Self->IsDeeply(
    $TestBackendObject->EmailsGet(),
    [],
    'Test backend empty after final cleanup',
);

1;
