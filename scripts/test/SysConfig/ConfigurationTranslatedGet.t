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
direction: ziel
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
addnote: notiz hinzugefügt (%s)
archiveflagupdate: \'archivstatus geändert: "%s"\'
bounce: bounced an "%s".
customerupdate: \'aktualisiert: %s\'
emailagent: e-mail an kunden versandt.
emailcustomer: e-mail hinzugefügt. %s
escalationresponsetimenotifybefore: eskalation "antwortzeit" vorgewarnt
escalationresponsetimestart: eskalation "antwortzeit" aktiv
escalationresponsetimestop: eskalation "antwortzeit" abgelaufen
escalationsolutiontimenotifybefore: eskalation "lösungszeit" vorgewarnt
escalationsolutiontimestart: eskalation "lösungszeit" aktiv
escalationsolutiontimestop: eskalation "lösungszeit" abgelaufen
escalationupdatetimenotifybefore: eskalation "aktualisierungszeit" vorgewarnt
escalationupdatetimestart: eskalation "aktualisierungszeit" aktiv
escalationupdatetimestop: eskalation "aktualisierungszeit" abgelaufen
followup: followup für [%s]. %s
forward: weitergeleitet an "%s".
lock: ticket gesperrt.
loopprotection: loop-protection! keine auto-antwort versandt an "%s".
misc: \'%s\'
move: ticket verschoben in queue "%s" (%s) von queue "%s" (%s).
newticket: neues ticket [%s] erstellt (q=%s;p=%s;s=%s).
ownerupdate: neuer besitzer ist "%s" (id=%s).
phonecallagent: kunden angerufen.
phonecallcustomer: kunde hat angerufen.
priorityupdate: priorität aktualisiert von "%s" (%s) nach "%s" (%s).
remove: \'%s\'
responsibleupdate: neuer verantwortlicher ist "%s" (id=%s).
slaupdate: sla aktualisiert "%s" (id=%s).
sendagentnotification: \'"%s"-benachrichtigung versandt an "%s" von "%s".\'
sendanswer: e-mail versandt an "%s".
sendautofollowup: autofollowup an "%s" versandt.
sendautoreject: autoreject an "%s" versandt.
sendautoreply: autoreply an "%s" versandt.
sendcustomernotification: benachrichtigung versandt an "%s".
serviceupdate: service aktualisiert "%s" (id=%s).
setpendingtime: \'aktualisiert: %s\'
stateupdate: \'alt: "%s" neu: "%s"\'
subscribe: abo für benutzer "%s" eingetragen.
systemrequest: systemanfrage (%s).
ticketdynamicfieldupdate: \'aktualisiert: %s=%s;%s=%s;%s=%s;\'
ticketlinkadd: verknüpfung zu "%s" hergestellt.
ticketlinkdelete: verknüpfung zu "%s" gelöscht.
timeaccounting: \'%s zeiteinheit(en) gezählt. insgesamt %s zeiteinheit(en).\'
titleupdate: \'titel geändert: alt: "%s", neu: "%s"\'
typeupdate: typ aktualisiert "%s" (id=%s).
unlock: ticketsperre aufgehoben.
unsubscribe: abo für benutzer "%s" ausgetragen.
webrequestcustomer: kunde stellte anfrage über web.
kontrolliert wie die ticket-historie in lesbaren werten dargestellt wird.',
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
