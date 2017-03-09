# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Config;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::Language' => {
        UserLanguage => 'de',
    },
);

my $LanguageObject  = $Kernel::OM->Get('Kernel::Language');
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my %Result = $SysConfigObject->ConfigurationTranslatedGet();

my @Tests = (
    {
        Name          => 'Ticket::Frontend::AgentTicketQueue###SortBy::Default',
        ExpectedValue => {
            'Category'    => 'OTRSFree',
            'IsInvisible' => '0',
            'Metadata'    => "ticket::frontend::agentticketqueue###sortby::default--- alter
definiert die standardmäßig eingestellten sortierkriterien für alle in der queue-ansicht angezeigten queues."
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketQueue###Order::Default',
        ExpectedValue => {
            'Category'    => 'OTRSFree',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::agentticketqueue###order::default--- auf
definiert die standardmäßig eingestellten sortierkriterien für alle in der queue-ansicht angezeigten queues, nachdem nach priorität sortiert wurde.'
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketService###SortBy::Default',
        ExpectedValue => {
            'Category'    => 'OTRSFree',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::agentticketservice###sortby::default--- alter
definiert die standardmäßig eingestellten sortierkriterien für alle in der service-ansicht angezeigten services.'
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketSearch###SearchCSVData',
        ExpectedValue => {
            'Category'    => 'OTRSFree',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::agentticketsearch###searchcsvdata---
- ticketnumber
- age
- created
- closed
- firstlock
- firstresponse
- state
- priority
- queue
- lock
- owner
- userfirstname
- userlastname
- customerid
- customername
- from
- subject
- accountedtime
- articletree
- solutioninmin
- solutiondiffinmin
- firstresponseinmin
- firstresponsediffinmin
daten die verwendet werden um das suchergebnis im csv-format zu exportieren.'
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketPhone###SplitLinkType',
        ExpectedValue => {
            'Category'    => 'OTRSFree',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::agentticketphone###splitlinktype---
direction: target
linktype: parentchild
bestimmt den standard-linktyp für geteilte tickets im agentenbereich.'
        },
    },
    {
        Name          => 'Ticket::Frontend::HistoryTypes###000-Framework',
        ExpectedValue => {
            'Category'    => 'OTRSFree',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::historytypes###000-framework---
addnote: added note (%s)
archiveflagupdate: \'archive state changed: "%s"\'
bounce: bounced to "%s".
customerupdate: \'updated: %s\'
emailagent: email sent to customer.
emailcustomer: added email. %s
escalationresponsetimenotifybefore: escalation response time forewarned
escalationresponsetimestart: escalation response time in effect
escalationresponsetimestop: escalation response time finished
escalationsolutiontimenotifybefore: escalation solution time forewarned
escalationsolutiontimestart: escalation solution time in effect
escalationsolutiontimestop: escalation solution time finished
escalationupdatetimenotifybefore: escalation update time forewarned
escalationupdatetimestart: escalation update time in effect
escalationupdatetimestop: escalation update time finished
followup: followup for [%s]. %s
forward: forwarded to "%s".
lock: locked ticket.
loopprotection: loop-protection! no auto-response sent to "%s".
misc: \'%s\'
move: ticket moved into queue "%s" (%s) from queue "%s" (%s).
newticket: new ticket [%s] created (q=%s;p=%s;s=%s).
ownerupdate: new owner is "%s" (id=%s).
phonecallagent: agent called customer.
phonecallcustomer: customer called us.
priorityupdate: changed priority from "%s" (%s) to "%s" (%s).
remove: \'%s\'
responsibleupdate: new responsible is "%s" (id=%s).
slaupdate: updated sla to %s (id=%s).
sendagentnotification: \'"%s" notification was sent to "%s" by "%s".\'
sendanswer: email sent to "%s".
sendautofollowup: autofollowup sent to "%s".
sendautoreject: autoreject sent to "%s".
sendautoreply: autoreply sent to "%s".
sendcustomernotification: notification sent to "%s".
serviceupdate: updated service to %s (id=%s).
setpendingtime: \'updated: %s\'
stateupdate: \'old: "%s" new: "%s"\'
subscribe: added subscription for user "%s".
systemrequest: system request (%s).
ticketdynamicfieldupdate: \'updated: %s=%s;%s=%s;%s=%s;\'
ticketlinkadd: added link to ticket "%s".
ticketlinkdelete: deleted link to ticket "%s".
timeaccounting: \'%s time unit(s) accounted. now total %s time unit(s).\'
titleupdate: \'title updated: old: "%s", new: "%s"\'
typeupdate: updated type to %s (id=%s).
unlock: unlocked ticket.
unsubscribe: removed subscription for user "%s".
webrequestcustomer: customer request via web.
kontrolliert wie die ticket-historie in lesbaren werten dargestellt wird.'
        },
    },
);

for my $Test (@Tests) {

    $Self->IsDeeply(
        $Result{ $Test->{Name} },
        $Test->{ExpectedValue},
        "ConfigurationTranslatedGet() - Check $Test->{Name}",
    );
}

1;
