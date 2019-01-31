# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Set Default Language.
my $Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$Self->True(
    $Success,
    "Set default language to English",
);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create test ticket.
my $TicketNumber = $TicketObject->TicketCreateNumber();
my $TicketID     = $TicketObject->TicketCreate(
    TN           => $TicketNumber,
    Title        => 'UnitTest ticket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerID   => '12345',
    CustomerUser => 'test@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "Ticket is created - TicketID $TicketID",
);

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Phone',
);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <otrs@example.com>',
    To                   => 'Suplier<suplier@example.com>',
    Subject              => 'Email for suplier',
    Body                 => "Line1\nLine2\nLine3",
    Charset              => 'utf8',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
);
$Self->True(
    $ArticleID,
    "ArticleID $ArticleID is created"
);

# Get ticket and article data for tests.
my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);
my %ArticleData = $ArticleBackendObject->ArticleGet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
);
my %Data = ( %TicketData, %ArticleData );

my @Tests = (
    {
        Name           => 'Test supported tag - <OTRS_CONFIG_ScriptAlias>',
        TemplateText   => 'Thank you for your email. <OTRS_CONFIG_ScriptAlias>',
        ExpectedResult => 'Thank you for your email. ' . $ConfigObject->Get('ScriptAlias'),
    },
    {
        Name           => 'Test unsupported tags',
        TemplateText   => 'Test: <OTRS_AGENT_SUBJECT> <OTRS_AGENT_BODY> <OTRS_CUSTOMER_BODY> <OTRS_CUSTOMER_SUBJECT>',
        ExpectedResult => 'Test: - - - -',
    },
    {
        Name => 'Test unsupported tags with [n]',
        TemplateText =>
            'Test: <OTRS_AGENT_SUBJECT[2]> <OTRS_AGENT_BODY[2]> <OTRS_CUSTOMER_BODY[2]> <OTRS_CUSTOMER_SUBJECT[2]>',
        ExpectedResult => 'Test: - - - -',
        TicketID       => $TicketID,
        Data           => \%Data,
    },
    {
        Name => 'Test supported tags - <OTRS_TICKET_*> without TicketID',
        TemplateText =>
            'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>)',
        ExpectedResult => 'Options of the ticket data (e. g. -, -, -)',
    },
    {
        Name => 'Test supported tags - <OTRS_TICKET_*>  with TicketID',
        TemplateText =>
            'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        ExpectedResult => "Options of the ticket data (e. g. $TicketNumber, $TicketID, Raw, open)",
        TicketID       => $TicketID,
    },
);

my $StandardTemplateObject  = $Kernel::OM->Get('Kernel::System::StandardTemplate');
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

for my $Test (@Tests) {

    # Create standard template.
    my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
        Name         => $Helper->GetRandomID() . '-StandardTemplate',
        Template     => $Test->{TemplateText},
        ContentType  => 'text/plain; charset=utf-8',
        TemplateType => 'Answer',
        ValidID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TemplateID,
        "StandardTemplate is created - ID $TemplateID",
    );

    my $Template = $TemplateGeneratorObject->Template(
        TemplateID => $TemplateID,
        TicketID   => $Test->{TicketID} // '',
        Data       => $Test->{Data} // {},
        UserID     => 1,
    );

    # Check template text.
    $Self->Is(
        $Template,
        $Test->{ExpectedResult},
        $Test->{Name},
    );

}

# Cleanup is done by RestoreDatabase.

1;
