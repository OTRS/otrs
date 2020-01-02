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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# disable rich text editor
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 0,
);
$Self->True(
    $Success,
    "Disable RichText with true",
);

# set Default Language
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$Self->True(
    $Success,
    "Set default language to English",
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketObject            = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject           = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $QueueObject             = $Kernel::OM->Get('Kernel::System::Queue');
my $SignatureObject         = $Kernel::OM->Get('Kernel::System::Signature');
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    UserID => 1,
);

my @Tests = (
    {
        Name      => 'Test supported tags -  <OTRS_CURRENT_UserFirstname> and <OTRS_CURRENT_UserLastname>',
        Signature => "Your OTRS-Team

    <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>

    --
    Super Support Company Inc. - Waterford Business Park
    5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA
    Email: hot\@florida.com - Web: http://hot.florida.com/
    --",
        ExpectedResult => "Your OTRS-Team

    $User{UserFirstname} $User{UserLastname}

    --
    Super Support Company Inc. - Waterford Business Park
    5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA
    Email: hot\@florida.com - Web: http://hot.florida.com/
    --",
    },
    {
        Name           => 'Test unsupported tags',
        Signature      => 'Test: <OTRS_AGENT_SUBJECT> <OTRS_AGENT_BODY> <OTRS_CUSTOMER_BODY> <OTRS_CUSTOMER_SUBJECT>',
        ExpectedResult => 'Test: - - - -',
    },
    {
        Name => 'Test supported tags - <OTRS_TICKET_*> without TicketID',
        Signature =>
            'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_State>)',
        ExpectedResult => 'Options of the ticket data (e. g. -, -, -)',
    },
    {
        Name => 'Test supported tags - <OTRS_TICKET_*>  with TicketID',
        Signature =>
            'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_State>)',
    },
);

# check signature text without TicketID or QueueID
my $Signature = $TemplateGeneratorObject->Signature(
    Data   => {},
    UserID => 1,
);
$Self->False(
    $Signature,
    'Template Signature() - without TicketID or QueueID.',
);

for my $Test (@Tests) {

    # add signature
    my $SignatureID = $SignatureObject->SignatureAdd(
        Name => $Helper->GetRandomID() . '-Signature',
        ,
        Text        => $Test->{Signature},
        ContentType => 'text/plain; charset=iso-8859-1',
        Comment     => 'some comment',
        ValidID     => 1,
        UserID      => 1,
    );
    $Self->True(
        $SignatureID,
        "Signature is created - ID $SignatureID",
    );

    my $QueueID = $QueueObject->QueueAdd(
        Name            => $Helper->GetRandomID() . '-Queue',
        ValidID         => 1,
        GroupID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => $SignatureID,
        UserID          => 1,
        Comment         => 'Selenium Test',
    );
    $Self->True(
        $QueueID,
        "Queue is created - ID $QueueID",
    );
    $Test->{QueueID} = $QueueID;

    # create test ticket
    my $TicketNumber = $TicketObject->TicketCreateNumber();
    my $TicketID     = $TicketObject->TicketCreate(
        TN           => $TicketNumber,
        Title        => 'UnitTest ticket',
        QueueID      => $QueueID,
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
        "Ticket is created - ID $TicketID",
    );

    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

    # create test email article
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 1,
        SenderType           => 'customer',
        Subject              => 'some short description',
        Body                 => 'the message text',
        Charset              => 'ISO-8859-15',
        MimeType             => 'text/plain',
        HistoryType          => 'EmailCustomer',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
    );
    $Self->True(
        $ArticleID,
        "Article is created - ID $ArticleID",
    );

    # get last article
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    if ( !defined $Test->{ExpectedResult} ) {
        $Test->{ExpectedResult} = "Options of the ticket data (e. g. $TicketNumber, $TicketID, open)";
        $Test->{TicketID}       = $TicketID;
        $Test->{QueueID}        = '';
    }

    my $Signature = $TemplateGeneratorObject->Signature(
        TicketID => $Test->{TicketID},
        QueueID  => $Test->{QueueID},
        Data     => {%Article},
        UserID   => 1,
    );

    # check signature text
    $Self->Is(
        $Signature,
        $Test->{ExpectedResult},
        $Test->{Name},
    );

}

# Cleanup is done by RestoreDatabase.

1;
