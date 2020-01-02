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
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
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

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );
my $ArticleID            = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'user@example.com',
    To                   => 'customer@example.com',
    Subject              => 'Some Subject',
    Body                 => 'Some Body',
    MimeType             => 'plain/text',
    Charset              => 'utf-8',
    Queue                => 'raw',
    HistoryType          => 'AddNote',
    HistoryComment       => '%%',
    UserID               => 1,
);
$Self->True(
    $ArticleID,
    "ArticleCreate()",
);

my %ArticleData = $ArticleBackendObject->ArticleGet(
    TicketID      => $TicketID,
    ArticleID     => $ArticleID,
    DynamicFields => 1,
    UserID        => 1,
);

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
        Request => "Action=someaction;Subaction=somesubaction;ArticleID=$ArticleID",
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
        },
        Request => "Action=someaction;Subaction=somesubaction;ArticleID=$ArticleID",
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            UserID => 1,
        },
        Request => "Action=someaction;Subaction=somesubaction;ArticleID=$ArticleID",
        Success => 0,
    },
    {
        Name   => 'Missing ArticleID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request => "Action=someaction;Subaction=somesubaction;",
        Success => 0,
    },
    {
        Name   => 'Wrong ArticleID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ArticleID=-1",
        Success       => 1,
        ExectedResult => {
            ObjectID => -1,
            Data     => {},
        },
    },
    {
        Name   => 'Wrong ArticleID and TicketID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ArticleID=-1;TicketID=-1",
        Success       => 1,
        ExectedResult => {
            ObjectID => -1,
            Data     => {},
        },
    },
    {
        Name   => 'Correct Article with wrong TicketID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ArticleID=$ArticleID;TicketID=-1",
        Success       => 1,
        ExectedResult => {
            ObjectID => $ArticleID,
            Data     => {},
        },
    },
    {
        Name   => 'Correct Article without TicketID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ArticleID=$ArticleID",
        Success       => 1,
        ExectedResult => {
            ObjectID => $ArticleID,
            Data     => \%ArticleData,
        },
    },
    {
        Name   => 'Correct Article with TicketID in the request',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfig,
            UserID             => 1,
        },
        Request       => "Action=someaction;Subaction=somesubaction;ArticleID=$ArticleID;TicketID=$TicketID",
        Success       => 1,
        ExectedResult => {
            ObjectID => $ArticleID,
            Data     => \%ArticleData,
        },
    },
);

my $ObjectHandlerObject = $Kernel::OM->Get('Kernel::System::DynamicField::ObjectType::Article');

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
