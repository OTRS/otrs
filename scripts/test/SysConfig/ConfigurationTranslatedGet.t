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
            'Category'    => 'OTRS',
            'IsInvisible' => '0',
            'Metadata'    => "ticket::frontend::agentticketqueue###sortby::default--- alter
definiert die standardmäßig eingestellten sortierkriterien für alle in der queue-ansicht angezeigten queues."
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketQueue###Order::Default',
        ExpectedValue => {
            'Category'    => 'OTRS',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::agentticketqueue###order::default--- auf
definiert die standardmäßig eingestellten sortierkriterien für alle in der queue-ansicht angezeigten queues, nachdem nach priorität sortiert wurde.'
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketService###SortBy::Default',
        ExpectedValue => {
            'Category'    => 'OTRS',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::agentticketservice###sortby::default--- alter
definiert die standardmäßig eingestellten sortierkriterien für alle in der service-ansicht angezeigten services.'
        },
    },
    {
        Name          => 'Ticket::Frontend::AgentTicketSearch###SearchCSVData',
        ExpectedValue => {
            'Category'    => 'OTRS',
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
            'Category'    => 'OTRS',
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
            'Category'    => 'OTRS',
            'IsInvisible' => 0,
            'Metadata'    => 'ticket::frontend::historytypes###000-framework---
addnote: added note (%s).
archiveflagupdate: changed archive state to "%s".
bounce: bounced to "%s".
customerupdate: changed customer to "%s".
emailagent: sent email to customer.
emailcustomer: added email. %s
emailresend: resent email to "%s".
escalationresponsetimenotifybefore: notified about response time escalation.
escalationresponsetimestart: started response time escalation.
escalationresponsetimestop: stopped response time escalation.
escalationsolutiontimenotifybefore: notified about solution time escalation.
escalationsolutiontimestart: started solution time escalation.
escalationsolutiontimestop: stopped solution time escalation.
escalationupdatetimenotifybefore: notified about update time escalation.
escalationupdatetimestart: started update time escalation.
escalationupdatetimestop: stopped update time escalation.
followup: added follow-up to ticket [%s]. %s
forward: forwarded to "%s".
lock: locked ticket.
loopprotection: \'loop protection: no auto-response sent to "%s".\'
merged: merged ticket (%s/%s) to (%s/%s).
misc: \'%s\'
move: changed queue to "%s" (%s) from "%s" (%s).
newticket: created ticket [%s] in "%s" with priority "%s" and state "%s".
ownerupdate: changed owner to "%s" (%s).
phonecallagent: added phone call to customer.
phonecallcustomer: added phone call from customer.
priorityupdate: changed priority from "%s" (%s) to "%s" (%s).
remove: \'%s\'
responsibleupdate: changed responsible to "%s" (%s).
slaupdate: changed sla to "%s" (%s).
sendagentnotification: sent "%s" notification to "%s" via "%s".
sendanswer: sent email to "%s".
sendautofollowup: sent auto follow-up to "%s".
sendautoreject: sent auto reject to "%s".
sendautoreply: sent auto reply to "%s".
sendcustomernotification: sent notification to "%s".
serviceupdate: changed service to "%s" (%s).
setpendingtime: changed pending time to "%s".
stateupdate: changed state from "%s" to "%s".
subscribe: added subscription for user "%s".
systemrequest: added system request (%s).
ticketdynamicfieldupdate: changed dynamic field %s from "%s" to "%s".
ticketlinkadd: added link to ticket "%s".
ticketlinkdelete: deleted link to ticket "%s".
timeaccounting: added %s time unit(s), for a total of %s time unit(s).
titleupdate: changed title from "%s" to "%s".
typeupdate: changed type from "%s" (%s) to "%s" (%s).
unlock: unlocked ticket.
unsubscribe: removed subscription for user "%s".
webrequestcustomer: added web request from customer.
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

# cleanup cache
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->CleanUp(
    Type => 'SysConfigDefault',
);
$CacheObject->CleanUp(
    Type => 'SysConfigDefaultListGet',
);
$CacheObject->CleanUp(
    Type => 'SysConfigDefaultList',
);
my %Languages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
for my $Language ( sort keys %Languages ) {
    $CacheObject->Delete(
        Type => 'SysConfig',
        Key  => "ConfigurationTranslatedGet::$Language",
    );
}

1;
