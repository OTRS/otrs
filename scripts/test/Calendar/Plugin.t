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

# get needed objects
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
my $PluginObject      = $Kernel::OM->Get('Kernel::System::Calendar::Plugin');
my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');
my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject        = $Kernel::OM->Get('Kernel::System::User');
my $TicketObject      = $Kernel::OM->Get('Kernel::System::Ticket');

# get registered plugin modules
my $PluginConfig = $ConfigObject->Get("AppointmentCalendar::Plugin");
my $PluginCount  = scalar keys %{$PluginConfig};

my $PluginList = $PluginObject->PluginList();

$Self->True(
    $PluginList,
    'Plugin list loaded',
);

$Self->Is(
    scalar keys %{$PluginList},
    $PluginCount,
    'Registered plugin count',
);

my $PluginKeyTicket;

# check all registered plugin modules
PLUGIN:
for my $PluginKey ( sort keys %{$PluginConfig} ) {

    my $GenericModule = $PluginConfig->{$PluginKey}->{Module};
    next PLUGIN if !$GenericModule;

    if ( $GenericModule eq 'Kernel::System::Calendar::Plugin::Ticket' ) {
        $PluginKeyTicket = $PluginKey;
    }

    # check if module can be required
    $Self->True(
        $MainObject->Require($GenericModule),
        "Required '$GenericModule' plugin module",
    );

    my $PluginModule = $GenericModule->new( %{$Self} );

    # check if module has been loaded
    $Self->True(
        $PluginModule,
        "Plugin module loaded successfully",
    );

    # check class name
    $Self->True(
        $PluginModule->isa($GenericModule),
        'Plugin module has correct package name',
    );

    # check required methods
    for my $MethodName (qw(LinkAdd LinkList Search)) {
        $Self->True(
            $PluginModule->can($MethodName),
            "Plugin module implements $MethodName()",
        );
    }

    my $PluginURL = $PluginConfig->{$PluginKey}->{URL};

    # check if URL contains ID placeholder
    $Self->True(
        scalar $PluginURL =~ /%s/,
        'Plugin module URL contains ID placeholder',
    );
}

# check ticket plugin if registered
if ($PluginKeyTicket) {

    # create test group
    my $GroupName = 'test-calendar-group-' . $Helper->GetRandomID();
    my $GroupID   = $GroupObject->GroupAdd(
        Name    => $GroupName,
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $GroupID,
        "Test group $GroupID created",
    );

    # create test user
    my ( $UserLogin, $UserID ) = $Helper->TestUserCreate(
        Groups => [ 'users', $GroupName ],
    );

    $Self->True(
        $UserID,
        "Test user $UserID created",
    );

    my $RandomID = $Helper->GetRandomID();

    # create a test ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Test Ticket ' . $RandomID,
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => $UserID,
        UserID       => $UserID,
    );
    $Self->True(
        $TicketID,
        "TicketCreate() - $TicketID",
    );
    my $TicketNumber = $TicketObject->TicketNumberLookup(
        TicketID => $TicketID,
        UserID   => $UserID,
    );
    $Self->True(
        $TicketNumber,
        "TicketNumberLookup() - $TicketNumber",
    );

    # crete test calendar
    my %Calendar = $CalendarObject->CalendarCreate(
        CalendarName => 'Test Calendar ' . $RandomID,
        Color        => '#3A87AD',
        GroupID      => $GroupID,
        UserID       => $UserID,
    );

    $Self->True(
        $Calendar{CalendarID},
        "CalendarCreate() - $Calendar{CalendarID}",
    );

    # create test appointment
    my $AppointmentID = $AppointmentObject->AppointmentCreate(
        CalendarID => $Calendar{CalendarID},
        Title      => 'Test appointment ' . $RandomID,
        StartTime  => '2016-01-01 12:00:00',
        EndTime    => '2016-01-01 13:00:00',
        TimezoneID => 0,
        UserID     => $UserID,
    );

    $Self->True(
        $AppointmentID,
        "AppointmentCreate() - $AppointmentID",
    );

    # search the ticket via ticket number
    my $ResultList = $PluginObject->PluginSearch(
        Search    => $TicketNumber,
        PluginKey => $PluginKeyTicket,
        UserID    => $UserID,
    );

    $Self->IsDeeply(
        $ResultList,
        {
            $TicketID => "$TicketNumber Test Ticket $RandomID",
        },
        'PluginSearch() - Search results (by ticket number)'
    );

    # search the ticket via ticket id
    $ResultList = $PluginObject->PluginSearch(
        ObjectID  => $TicketID,
        PluginKey => $PluginKeyTicket,
        UserID    => $UserID,
    );

    $Self->IsDeeply(
        $ResultList,
        {
            $TicketID => "$TicketNumber Test Ticket $RandomID",
        },
        'PluginSearch() - Search results (by ticket ID)'
    );

    # link appointment with the ticket
    my $Success = $PluginObject->PluginLinkAdd(
        AppointmentID => $AppointmentID,
        PluginKey     => $PluginKeyTicket,
        PluginData    => $TicketID,
        UserID        => $UserID,
    );

    $Self->True(
        $Success,
        'PluginLinkAdd() - Link appointment to the ticket',
    );

    # verify link
    my $LinkList = $PluginObject->PluginLinkList(
        AppointmentID => $AppointmentID,
        PluginKey     => $PluginKeyTicket,
        UserID        => $UserID,
    );

    $Self->True(
        $LinkList->{$TicketID},
        'PluginLinkList() - Verify link to the ticket'
    );

    $Self->Is(
        $LinkList->{$TicketID}->{LinkID},
        $TicketID,
        'TicketID',
    );

    # check URL
    $Self->True(
        $LinkList->{$TicketID}->{LinkURL} =~ /TicketID=$TicketID/,
        'Ticket URL contains ticket ID'
    );

    # link name
    $Self->Is(
        $LinkList->{$TicketID}->{LinkName},
        "$TicketNumber Test Ticket $RandomID",
        'Link name'
    );

    # delete links
    $Success = $PluginObject->PluginLinkDelete(
        AppointmentID => $AppointmentID,
        UserID        => $UserID,
    );

    $Self->True(
        $Success,
        'PluginLinkDelete() - Links deleted'
    );

    # verify links have been deleted
    $LinkList = $PluginObject->PluginLinkList(
        AppointmentID => $AppointmentID,
        PluginKey     => $PluginKeyTicket,
        UserID        => $UserID,
    );

    $Self->IsDeeply(
        $LinkList,
        {},
        'PluginLinkList() - Empty link list',
    );
}

1;
