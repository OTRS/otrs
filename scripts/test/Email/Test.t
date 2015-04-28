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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# do not really send emails
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

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
    my ( $Header, $Body ) = $EmailObject->Send(
        From    => 'john.smith@example.com',
        To      => 'john.smith2@example.com',
        Subject => 'some subject',
        Body    => 'Some Body',
        Type    => 'text/html',
        Charset => 'utf8',
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
