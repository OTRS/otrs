# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Disable email address checks
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Use DoNotSendEmail email backend
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my %TicketCreateTemplate = (
    Title          => 'Some Ticket_Title',
    Queue          => 'Raw',
    Lock           => 'unlock',
    Priority       => '3 normal',
    State          => 'closed successful',
    CustomerID     => 'example.com',
    CustomerUserID => 'customer@email.com',
    OwnerID        => 1,
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create a new ticket
my $TicketID = $TicketObject->TicketCreate(
    %TicketCreateTemplate,
    UserID => 1,
);

$Self->True(
    $TicketID,
    "TicketCreate()",
);

my %TicketData = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    Extended      => 1,
    UserID        => 1,
);
for my $Attribute (
    qw(Age EscalationDestinationIn EscalationDestinationTime  EscalationSolutionTime EscalationTime EscalationTimeWorkingTime RealTillTimeNotUsed SolutionTime SolutionTimeDestinationTime SolutionTimeEscalation SolutionTimeWorkingTime UnlockTimeout UntilTime)
    )
{
    delete $TicketData{$Attribute};
}

# Build a test Dynamic field Config.
my $DynamicFieldConfig = {
    ID         => 123,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
};

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Request => "Action=someaction;Subaction=somesubaction;TicketID=$TicketID",
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
        },
        Request => "Action=someaction;Subaction=somesubaction;TicketID=$TicketID",
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            UserID => 1,
        },
        Request => "Action=someaction;Subaction=somesubaction;TicketID=$TicketID",
        Success => 0,
    },
    {
        Name   => 'Missing TicketID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request => "Action=someaction;Subaction=somesubaction;",
        Success => 0,
    },
    {
        Name   => 'Wrong TicketID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;TicketID=-1",
        Success       => 1,
        ExectedResult => {
            ObjectID => -1,
            Data     => {},
        },
    },
    {
        Name   => 'Correct Ticket',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;TicketID=$TicketID",
        Success       => 1,
        ExectedResult => {
            ObjectID => $TicketID,
            Data     => \%TicketData,
        },
    },

);

my $ObjectHandlerObject = $Kernel::OM->Get('Kernel::System::DynamicField::ObjectType::Ticket');

TEST:
for my $Test (@Tests) {

    local %ENV = (
        REQUEST_METHOD => 'GET',
        QUERY_STRING   => $Test->{Request} // '',
    );

    CGI->initialize_globals();
    my $Request = Kernel::System::Web::Request->new();

    my %ObjectData = $ObjectHandlerObject->ObjectDataGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \%ObjectData,
            {},
            "$Test->{Name} - ObjectDataGet() unsuccessful",
        );
        next TEST;
    }

    $Self->IsDeeply(
        \%ObjectData,
        $Test->{ExectedResult},
        "$Test->{Name} ObjectDataGet()",
    );
}
continue {
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', ],
    );
}

# cleanup is done by RestoreDatabase

1;
