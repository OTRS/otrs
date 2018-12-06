# OTRS config file (automatically generated)
# VERSION:1.1
package scripts::test::sample::SysConfig::Migration::ZZZAutoOTRS5;
use strict;
use warnings;
no warnings 'redefine';
use utf8;

## nofilter(TidyAll::Plugin::OTRS::Perl::PerlTidy)

sub Load {
    my ($File, $Self) = @_;

# yes/no
$Self->{'Ticket::Frontend::ZoomCollectMeta'} =  '0';

# hash-of-hash + defaultcolumns
$Self->{'LinkObject::ComplexTable'}->{'Ticket'} =  {
  'DefaultColumns' => {
    'Age' => '1',
    'Changed' => '1',
    'Created' => '2',
    'CustomerID' => '1',
    'CustomerName' => '1',
    'CustomerUserID' => '1',
    'EscalationResponseTime' => '1',
    'EscalationSolutionTime' => '1',
    'EscalationTime' => '1',
    'EscalationUpdateTime' => '1',
    'Lock' => '1',
    'Owner' => '1',
    'PendingTime' => '1',
    'Priority' => '1',
    'Queue' => '2',
    'Responsible' => '1',
    'SLA' => '1',
    'Service' => '1',
    'State' => '2',
    'TicketNumber' => '2',
    'Title' => '2',
    'Type' => '1'
  },
  'Module' => 'Kernel::Output::HTML::LinkObject::Ticket.pm',
  'Priority' => {
    'Age' => '110',
    'Changed' => '120',
    'Created' => '310',
    'CustomerID' => '240',
    'CustomerName' => '250',
    'CustomerUserID' => '260',
    'EscalationResponseTime' => '160',
    'EscalationSolutionTime' => '150',
    'EscalationTime' => '140',
    'EscalationUpdateTime' => '170',
    'Lock' => '200',
    'Owner' => '220',
    'PendingTime' => '130',
    'Priority' => '300',
    'Queue' => '210',
    'Responsible' => '230',
    'SLA' => '290',
    'Service' => '280',
    'State' => '190',
    'TicketNumber' => '100',
    'Title' => '180',
    'Type' => '270'
  }
};
# array-of-string
$Self->{'LinkObject::ComplexTable::SettingsVisibility'}->{'Ticket'} =  [
  'AgentTicketZoom'
];
# string
$Self->{'Ticket::Frontend::DefaultSenderDisplayType'} =  'Realname';
# module
$Self->{'Frontend::NavBarModule'}->{'7-AgentTicketService'} =  {
  'Module' => 'Kernel::Output::HTML::NavBar::AgentTicketService'
};
# defaultcolumns
$Self->{'Ticket::Frontend::AgentTicketService'}->{'DefaultColumns'} =  {
  'Age' => '2',
  'Changed' => '1',
  'Created' => '1',
  'CustomerCompanyName' => '1',
  'CustomerID' => '2',
  'CustomerName' => '1',
  'CustomerUserID' => '1',
  'EscalationResponseTime' => '1',
  'EscalationSolutionTime' => '1',
  'EscalationTime' => '1',
  'EscalationUpdateTime' => '1',
  'Lock' => '2',
  'Owner' => '2',
  'PendingTime' => '1',
  'Priority' => '1',
  'Queue' => '2',
  'Responsible' => '1',
  'SLA' => '1',
  'Service' => '2',
  'State' => '2',
  'TicketNumber' => '2',
  'Title' => '2',
  'Type' => '1'
};
# hash
$Self->{'StandardTemplate::Types'} =  {
  'Answer' => 'Answer',
  'Create' => 'Create',
  'Email' => 'Email',
  'Forward' => 'Forward',
  'Note' => 'Note',
  'PhoneCall' => 'Phone call'
};
# nummeric
$Self->{'Ticket::Frontend::AgentTicketMerge'}->{'RichTextHeight'} =  '100';
$Self->{'Ticket::Frontend::AgentTicketMerge'}->{'RichTextWidth'} =  '620';
# dynamic fields
$Self->{'Ticket::Frontend::CustomerTicketSearch'}->{'SearchCSVDynamicField'} =  {};
$Self->{'Ticket::Frontend::CustomerTicketSearch'}->{'DynamicField'} =  {};
$Self->{'Ticket::Frontend::AgentTicketSearch'}->{'SearchCSVDynamicField'} =  {};
$Self->{'Ticket::Frontend::AgentTicketSearch'}->{'Defaults'}->{'DynamicField'} =  {};
# disable a setting with two sub levels
delete $Self->{'Ticket::Frontend::AgentTicketSearch'}->{'Defaults'}->{'Fulltext'};
$Self->{'Ticket::Frontend::CustomerTicketZoom'}->{'FollowUpDynamicField'} =  {};
# hash with module
$Self->{'DynamicFields::Driver'}->{'Multiselect'} =  {
  'ConfigDialog' => 'AdminDynamicFieldMultiselect',
  'DisplayName' => 'Multiselect',
  'ItemSeparator' => ', ',
  'Module' => 'Kernel::System::DynamicField::Driver::Multiselect'
};
# frontend module
$Self->{'Frontend::Module'}->{'AdminDynamicFieldMultiselect'} =  {
  'Description' => 'This module is part of the admin area of OTRS.',
  'Group' => [
    'admin'
  ],
  'Loader' => {
    'CSS' => [
      'Core.Agent.Admin.DynamicField.css'
    ],
    'JavaScript' => [
      'Core.Agent.Admin.DynamicField.js',
      'Core.Agent.Admin.DynamicFieldMultiselect.js'
    ]
  },
  'Title' => 'Dynamic Fields Multiselect Backend GUI'
};
# hash with hash
$Self->{'PreferencesGroups'}->{'DynamicFieldsOverviewPageShown'} =  {
  'Active' => '0',
  'Column' => 'Other Settings',
  'Data' => {
    '10' => '10',
    '15' => '15',
    '20' => '20',
    '25' => '25',
    '30' => '30',
    '35' => '35'
  },
  'DataSelected' => '25',
  'Key' => 'Dynamic fields limit per page for Dynamic Fields Overview',
  'Label' => 'Dynamic Fields Overview Limit',
  'Module' => 'Kernel::Output::HTML::Preferences::Generic',
  'PrefKey' => 'AdminDynamicFieldsOverviewPageShown',
  'Prio' => '8000'
};
# frontend module
$Self->{'Frontend::Module'}->{'AdminDynamicField'} =  {
  'Description' => 'This module is part of the admin area of OTRS.',
  'Group' => [
    'admin',
    'users'
  ],
  'Loader' => {
    'CSS' => [
      'Core.Agent.Admin.DynamicField.css'
    ],
    'JavaScript' => [
      'Core.Agent.Admin.DynamicField.js'
    ]
  },
  'NavBar' => [
    {
      'AccessKey' => '',
      'Block' => 'ItemArea',
      'Description' => 'Changed the dynamic field.',
      'Link' => 'Action=AdminDynamicField;Nav=Agent',
      'LinkOption' => '',
      'Name' => 'Dynamic Field Administration',
      'NavBar' => 'Ticket',
      'Prio' => '9000',
      'Type' => ''
    }
  ],
  'NavBarModule' => {
    'Block' => 'Ticket',
    'Description' => 'Create and manage dynamic fields (other description).',
    'Module' => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
    'Name' => 'Dynamic Fields',
    'Prio' => '1000'
  },
  'NavBarName' => 'Admin',
  'Title' => 'Dynamic Fields GUI'
};
# frontend module with disabled nav bar item
$Self->{'Frontend::Module'}->{'AgentTicketEscalationView'} =  {
  'Description' => 'Overview of all escalated tickets.',
  'Loader' => {
    'CSS' => [
      'Core.AllocationList.css'
    ],
    'JavaScript' => [
      'Core.UI.AllocationList.js',
      'Core.Agent.TableFilters.js'
    ]
  },
  'NavBar' => [],
  'NavBarName' => 'Ticket',
  'Title' => 'Escalation view'
};
# frontend module with already changed nav bar module
$Self->{'Frontend::Module'}->{'AdminCustomerUser'} =  {
  'Description' => 'Edit Customer Users.',
  'Group' => [
    'admin',
    'users'
  ],
  'GroupRo' => [],
  'Loader' => {
    'JavaScript' => [
      'Core.Agent.TicketAction.js'
    ]
  },
  'NavBar' => [
    {
      'AccessKey' => '',
      'Block' => 'ItemArea',
      'Description' => 'Changed the description.',
      'Link' => 'Action=AdminCustomerUser;Nav=Agent',
      'LinkOption' => '',
      'Name' => 'Customer User Administration',
      'NavBar' => 'Customers',
      'Prio' => '9000',
      'Type' => ''
    }
  ],
  'NavBarModule' => {
    'Block' => 'Customer',
    'Description' => 'Create and manage customer users.',
    'Module' => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
    'Name' => 'Customer User',
    'Prio' => '300'
  },
  'NavBarName' => 'Customers',
  'Title' => 'Customer Users'
};
# yes/no
$Self->{'Ticket::Frontend::ZoomRichTextForce'} =  '1';
# nummeric
$Self->{'Ticket::Frontend::MaxArticlesPerPage'} =  '1000';
# array of string
$Self->{'LinkObject::IgnoreLinkedTicketStateTypes'} =  [
  'merged',
  'removed'
];
# regex
$Self->{'SendNoAutoResponseRegExp'} =  '(MAILER-DAEMON|postmaster|abuse)@.+?\\..+?';
# text
$Self->{'PostMaster::PreFilterModule::NewTicketReject::Body'} =  '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
';
# module
$Self->{'LoopProtectionModule'} =  'Kernel::System::PostMaster::LoopProtection::DB';
# acl actions
$Self->{'ACLKeysLevel3::Actions'}->{'100-Default'} =  [
  'AgentTicketBounce',
  'AgentTicketClose',
  'AgentTicketCompose',
  'AgentTicketCustomer',
  'AgentTicketForward',
  'AgentTicketEmailOutbound',
  'AgentTicketFreeText',
  'AgentTicketHistory',
  'AgentTicketLink',
  'AgentTicketLock',
  'AgentTicketMerge',
  'AgentTicketMove',
  'AgentTicketNote',
  'AgentTicketOwner',
  'AgentTicketPending',
  'AgentTicketPhone',
  'AgentTicketPhoneInbound',
  'AgentTicketPhoneOutbound',
  'AgentTicketPlain',
  'AgentTicketPrint',
  'AgentTicketPriority',
  'AgentTicketProcess',
  'AgentTicketResponsible',
  'AgentTicketSearch',
  'AgentTicketWatcher',
  'AgentTicketZoom',
  'AgentLinkObject',
  'CustomerTicketProcess'
];
# customer module
$Self->{'CustomerFrontend::Module'}->{'CustomerTicketOverview'} =  {
  'Description' => 'Overview of customer tickets.',
  'NavBar' => [
    {
      'AccessKey' => 'm',
      'Block' => '',
      'Description' => 'Tickets.',
      'Link' => 'Action=CustomerTicketOverview;Subaction=MyTickets',
      'LinkOption' => '',
      'Name' => 'Tickets',
      'NavBar' => 'Ticket',
      'Prio' => '100',
      'Type' => 'Menu'
    },
    {
      'AccessKey' => '',
      'Block' => '',
      'Description' => 'My Tickets.',
      'Link' => 'Action=CustomerTicketOverview;Subaction=MyTickets',
      'LinkOption' => '',
      'Name' => 'My Tickets',
      'NavBar' => 'Ticket',
      'Prio' => '110',
      'Type' => 'Submenu'
    },
    {
      'AccessKey' => 'M',
      'Block' => '',
      'Description' => 'Company Tickets.',
      'Link' => 'Action=CustomerTicketOverview;Subaction=CompanyTickets',
      'LinkOption' => '',
      'Name' => 'Company Tickets',
      'NavBar' => 'Ticket',
      'Prio' => '120',
      'Type' => 'Submenu'
    }
  ],
  'NavBarName' => 'Ticket',
  'Title' => 'Overview'
};
# notification
$Self->{'PreferencesGroups'}->{'NotificationEvent'} =  {
  'Active' => '1',
  'Column' => 'Notification Settings',
  'Desc' => 'Choose for which kind of ticket changes you want to receive notifications.',
  'Label' => 'Ticket notifications',
  'Module' => 'Kernel::Output::HTML::Preferences::NotificationEvent',
  'PrefKey' => 'AdminNotifcationEventTransport',
  'Prio' => '8000'
};
# frontend module + js
$Self->{'Frontend::Module'}->{'AdminGenericAgent'} =  {
  'Description' => 'This module is part of the admin area of OTRS.',
  'Group' => [
    'admin'
  ],
  'Loader' => {
    'JavaScript' => [
      'Core.Agent.Admin.GenericAgent.js'
    ]
  },
  'NavBarModule' => {
    'Block' => 'System',
    'Description' => 'Manage tasks triggered by event or time based execution.',
    'Module' => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
    'Name' => 'GenericAgent',
    'Prio' => '300'
  },
  'NavBarName' => 'Admin',
  'Title' => 'GenericAgent'
};
# fontend module + css + js
$Self->{'Frontend::Module'}->{'AgentTicketZoom'} =  {
  'Description' => 'Ticket Zoom.',
  'Loader' => {
    'CSS' => [
      'Core.Agent.TicketProcess.css',
      'Core.Agent.TicketMenuModuleCluster.css',
      'Core.AllocationList.css'
    ],
    'JavaScript' => [
      'thirdparty/jquery-tablesorter-2.0.5/jquery.tablesorter.js',
      'Core.Agent.TicketZoom.js',
      'Core.UI.AllocationList.js',
      'Core.UI.Table.Sort.js',
      'Core.Agent.TableFilters.js',
      'Core.Agent.LinkObject.js'
    ]
  },
  'NavBarName' => 'Ticket',
  'Title' => 'Zoom'
};
# empty
$Self->{'CustomerFrontend::CommonParam'}->{'TicketID'} =  '';
# statetype
$Self->{'Ticket::Frontend::CustomerTicketZoom'}->{'StateType'} =  [
  'open',
  'closed'
];
# false test entry
$Self->{'UnitTestTestEntry'}->{'TestiTest'} = '1';
# skip loader
$Self->{'CustomerPreferencesView'} =  [
  'User Profile',
  'Other Settings'
];
# skip removed
$Self->{'Loader::Customer::CommonCSS'}->{'000-Framework'} =  [
  'Core.Reset.css',
  'Core.Default.css',
  'Core.Form.css',
  'Core.Dialog.css',
  'Core.Tooltip.css',
  'Core.Login.css',
  'Core.Control.css',
  'Core.Table.css',
  'Core.TicketZoom.css',
  'Core.InputFields.css',
  'Core.Print.css',
  'thirdparty/fontawesome/font-awesome.css'
];
# yes/no
$Self->{'Ticket::Frontend::AgentTicketService'}->{'StripEmptyLines'} =  '0';
# module
$Self->{'Cache::Module'} =  'Kernel::System::Cache::FileStorable';
# name
$Self->{'ProductName'} =  'OTRS 5s';
# numeric
$Self->{'CalendarWeekDayStart'} =  '1';
# queue
$Self->{'DashboardEventsTicketCalendar'}->{'Queues'} =  [
  'Raw'
];
# dashboard backend
$Self->{'DashboardBackend'}->{'0110-TicketEscalation'} =  {
  'Attributes' => 'TicketEscalationTimeOlderMinutes=1;SortBy=EscalationTime;OrderBy=Down;',
  'Block' => 'ContentLarge',
  'CacheTTLLocal' => '0.5',
  'Default' => '1',
  'DefaultColumns' => {
    'Age' => '2',
    'Changed' => '1',
    'Created' => '1',
    'CustomerCompanyName' => '1',
    'CustomerID' => '1',
    'CustomerName' => '1',
    'CustomerUserID' => '1',
    'EscalationResponseTime' => '1',
    'EscalationSolutionTime' => '1',
    'EscalationTime' => '1',
    'EscalationUpdateTime' => '1',
    'Lock' => '1',
    'Owner' => '1',
    'PendingTime' => '1',
    'Priority' => '1',
    'Queue' => '1',
    'Responsible' => '1',
    'SLA' => '1',
    'Service' => '1',
    'State' => '1',
    'TicketNumber' => '2',
    'Title' => '2',
    'Type' => '1'
  },
  'Description' => 'All escalated tickets',
  'Filter' => 'All',
  'Group' => '',
  'Limit' => '10',
  'Module' => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
  'Permission' => 'rw',
  'Time' => 'EscalationTime',
  'Title' => 'Escalated Tickets'
};
# state
$Self->{'Ticket::Frontend::AgentTicketCompose'}->{'StateDefault'} =  'open';
# cron
$Self->{'Daemon::SchedulerCronTaskManager::Task'}->{'RenewCustomerSMIMECertificates'} =  {
  'Function' => 'Execute',
  'MaximumParallelInstances' => '1',
  'Module' => 'Kernel::System::Console::Command::Maint::SMIME::CustomerCertificate::Renew',
  'Params' => [],
  'Schedule' => '02 02 * * *',
  'TaskName' => 'RenewCustomerSMIMECertificates'
};
# cron + params
$Self->{'Daemon::SchedulerCronTaskManager::Task'}->{'CoreCacheCleanup'} =  {
  'Function' => 'CleanUp',
  'MaximumParallelInstances' => '1',
  'Module' => 'Kernel::System::Cache',
  'Params' => [
    'Expired',
    '1'
  ],
  'Schedule' => '20 0 * * 0',
  'TaskName' => 'CoreCacheCleanup'
};
# commonJS
$Self->{'Loader::Customer::CommonJS'}->{'000-Framework'} =  [
  'thirdparty/jquery-2.1.4/jquery.js',
  'thirdparty/jquery-browser-detection/jquery-browser-detection.js',
  'thirdparty/jquery-validate-1.14.0/jquery.validate.js',
  'thirdparty/jquery-ui-1.11.4/jquery-ui.js',
  'thirdparty/stacktrace-0.6.4/stacktrace.js',
  'thirdparty/jquery-pubsub/pubsub.js',
  'thirdparty/jquery-jstree-3.1.1/jquery.jstree.js',
  'Core.Debug.js',
  'Core.Exception.js',
  'Core.Data.js',
  'Core.JSON.js',
  'Core.JavaScriptEnhancements.js',
  'Core.Config.js',
  'Core.App.js',
  'Core.App.Responsive.js',
  'Core.AJAX.js',
  'Core.UI.js',
  'Core.UI.InputFields.js',
  'Core.UI.Accessibility.js',
  'Core.UI.Dialog.js',
  'Core.UI.RichTextEditor.js',
  'Core.UI.Datepicker.js',
  'Core.UI.Popup.js',
  'Core.UI.TreeSelection.js',
  'Core.UI.Autocomplete.js',
  'Core.Form.js',
  'Core.Form.ErrorTooltips.js',
  'Core.Form.Validate.js',
  'Core.Customer.js',
  'Core.Customer.Responsive.js'
];
# renamed to 'Frontend::NotifyModule###8000-Daemon-Check'
$Self->{'Frontend::NotifyModule'}->{'800-Daemon-Check'} =  {
  'Module' => 'Kernel::Output::HTML::Notification::DaemonCheck'
};
# renamed setting in package to 'SessionAgentOnlineThreshold'
$Self->{'ChatEngine::AgentOnlineThreshold'} =  '10';
# disabled
delete $Self->{'PreferencesGroups'}->{'Comment'};
# deleted
delete $Self->{'PreferencesGroups'}->{'SpellDict'};
# calendar
$Self->{'TimeWorkingHours::Calendar9'} =  {
  'Fri' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ],
  'Mon' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ],
  'Sat' => [],
  'Sun' => [],
  'Thu' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ],
  'Tue' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ],
  'Wed' => [
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20'
  ]
};
$Self->{'TimeVacationDaysOneTime::Calendar9'} =  {
  '2004' => {
    '1' => {
      '1' => 'test'
    }
  }
};
$Self->{'TimeVacationDays::Calendar9'} =  {
  '1' => {
    '1' => 'New Year\'s Day'
  },
  '12' => {
    '24' => 'Christmas Eve',
    '25' => 'First Christmas Day',
    '26' => 'Second Christmas Day',
    '31' => 'New Year\'s Eve'
  },
  '5' => {
    '1' => 'International Workers\' Day'
  }
};
$Self->{'CalendarWeekDayStart::Calendar9'} =  '1';
$Self->{'TimeZone::Calendar9'} =  '0';
$Self->{'TimeZone::Calendar9Name'} =  'カレンダー9';
$Self->{'CustomerCompany::EventModulePost'}->{'100-UpdateCustomerUsers'} =  {
  'Event' => 'CustomerCompanyUpdate',
  'Module' => 'Kernel::System::CustomerCompany::Event::CustomerUserUpdate',
  'Transaction' => '0'
};
$Self->{'CustomerCompany::EventModulePost'}->{'110-UpdateTickets'} =  {
  'Event' => 'CustomerCompanyUpdate',
  'Module' => 'Kernel::System::CustomerCompany::Event::TicketUpdate',
  'Transaction' => '0'
};
$Self->{'CustomerCompany::EventModulePost'}->{'1000-GenericInterface'} =  {
  'Event' => '',
  'Module' => 'Kernel::GenericInterface::Event::Handler',
  'Transaction' => '1'
};
$Self->{'CustomerUser::EventModulePost'}->{'100-UpdateSearchProfiles'} =  {
  'Event' => 'CustomerUserUpdate',
  'Module' => 'Kernel::System::CustomerUser::Event::SearchProfileUpdate',
  'Transaction' => '0'
};
$Self->{'CustomerUser::EventModulePost'}->{'100-UpdateServiceMembership'} =  {
  'Event' => 'CustomerUserUpdate',
  'Module' => 'Kernel::System::CustomerUser::Event::ServiceMemberUpdate',
  'Transaction' => '0'
};
$Self->{'CustomerUser::EventModulePost'}->{'1000-GenericInterface'} =  {
  'Event' => '',
  'Module' => 'Kernel::GenericInterface::Event::Handler',
  'Transaction' => '1'
};
$Self->{'Frontend::NotifyModule'}->{'100-CloudServicesDisabled'} =  {
  'Group' => 'admin',
  'Module' => 'Kernel::Output::HTML::Notification::AgentCloudServicesDisabled'
};
$Self->{'Frontend::NotifyModule'}->{'100-OTRSBusiness'} =  {
  'Group' => 'admin',
  'Module' => 'Kernel::Output::HTML::Notification::AgentOTRSBusiness'
};
$Self->{'Frontend::NotifyModule'}->{'200-UID-Check'} =  {
  'Module' => 'Kernel::Output::HTML::Notification::UIDCheck'
};
$Self->{'Frontend::NotifyModule'}->{'250-AgentSessionLimit'} =  {
  'Module' => 'Kernel::Output::HTML::Notification::AgentSessionLimit'
};
$Self->{'Frontend::NotifyModule'}->{'500-OutofOffice-Check'} =  {
  'Module' => 'Kernel::Output::HTML::Notification::OutofOfficeCheck'
};
$Self->{'Frontend::NotifyModule'}->{'600-SystemMaintenance-Check'} =  {
  'Module' => 'Kernel::Output::HTML::Notification::SystemMaintenanceCheck'
};
delete $Self->{'Ticket::EventModulePost'}->{'900-GenericAgent'};
$Self->{'Frontend::ToolBarModule'}->{'1-Ticket::AgentTicketQueue'} =  {
  'AccessKey' => 'q',
  'Action' => 'AgentTicketQueue',
  'CssClass' => 'QueueView',
  'Icon' => 'fa fa-folder',
  'Link' => 'Action=AgentTicketQueue',
  'Module' => 'Kernel::Output::HTML::ToolBar::Link',
  'Name' => 'Queue view',
  'Priority' => '1010010'
};
$Self->{'Frontend::ToolBarModule'}->{'2-Ticket::AgentTicketStatus'} =  {
  'AccessKey' => 'o',
  'Action' => 'AgentTicketStatusView',
  'CssClass' => 'StatusView',
  'Icon' => 'fa fa-list-ol',
  'Link' => 'Action=AgentTicketStatusView',
  'Module' => 'Kernel::Output::HTML::ToolBar::Link',
  'Name' => 'Status view',
  'Priority' => '1010020'
};
$Self->{'Frontend::ToolBarModule'}->{'3-Ticket::AgentTicketEscalation'} =  {
  'AccessKey' => 'w',
  'Action' => 'AgentTicketEscalationView',
  'CssClass' => 'EscalationView',
  'Icon' => 'fa fa-exclamation',
  'Link' => 'Action=AgentTicketEscalationView',
  'Module' => 'Kernel::Output::HTML::ToolBar::Link',
  'Name' => 'Escalation view',
  'Priority' => '1010030'
};
$Self->{'Frontend::ToolBarModule'}->{'4-Ticket::AgentTicketPhone'} =  {
  'AccessKey' => '',
  'Action' => 'AgentTicketPhone',
  'CssClass' => 'PhoneTicket',
  'Icon' => 'fa fa-phone',
  'Link' => 'Action=AgentTicketPhone',
  'Module' => 'Kernel::Output::HTML::ToolBar::Link',
  'Name' => 'New phone ticket',
  'Priority' => '1020010'
};
$Self->{'Frontend::ToolBarModule'}->{'5-Ticket::AgentTicketEmail'} =  {
  'AccessKey' => 'l',
  'Action' => 'AgentTicketEmail',
  'CssClass' => 'EmailTicket',
  'Icon' => 'fa fa-envelope',
  'Link' => 'Action=AgentTicketEmail',
  'Module' => 'Kernel::Output::HTML::ToolBar::Link',
  'Name' => 'New email ticket',
  'Priority' => '1020020'
};
$Self->{'Frontend::ToolBarModule'}->{'6-Ticket::AgentTicketProcess'} =  {
  'AccessKey' => '',
  'Action' => 'AgentTicketProcess',
  'CssClass' => 'ProcessTicket',
  'Icon' => 'fa fa-th-large',
  'Link' => 'Action=AgentTicketProcess',
  'Module' => 'Kernel::Output::HTML::ToolBar::Link',
  'Name' => 'New process ticket',
  'Priority' => '1020030'
};
$Self->{'Frontend::ToolBarModule'}->{'7-Ticket::TicketResponsible'} =  {
  'AccessKey' => 'r',
  'AccessKeyNew' => '',
  'AccessKeyReached' => '',
  'CssClass' => 'Responsible',
  'CssClassNew' => 'Responsible New',
  'CssClassReached' => 'Responsible Reached',
  'Icon' => 'fa fa-user',
  'IconNew' => 'fa fa-user',
  'IconReached' => 'fa fa-user',
  'Module' => 'Kernel::Output::HTML::ToolBar::TicketResponsible',
  'Priority' => '1030010'
};
$Self->{'Frontend::ToolBarModule'}->{'8-Ticket::TicketWatcher'} =  {
  'AccessKey' => '',
  'AccessKeyNew' => '',
  'AccessKeyReached' => '',
  'CssClass' => 'Watcher',
  'CssClassNew' => 'Watcher New',
  'CssClassReached' => 'Watcher Reached',
  'Icon' => 'fa fa-eye',
  'IconNew' => 'fa fa-eye',
  'IconReached' => 'fa fa-eye',
  'Module' => 'Kernel::Output::HTML::ToolBar::TicketWatcher',
  'Priority' => '1030020'
};
$Self->{'Frontend::ToolBarModule'}->{'9-Ticket::TicketLocked'} =  {
  'AccessKey' => 'k',
  'AccessKeyNew' => '',
  'AccessKeyReached' => '',
  'CssClass' => 'Locked',
  'CssClassNew' => 'Locked New',
  'CssClassReached' => 'Locked Reached',
  'Icon' => 'fa fa-lock',
  'IconNew' => 'fa fa-lock',
  'IconReached' => 'fa fa-lock',
  'Module' => 'Kernel::Output::HTML::ToolBar::TicketLocked',
  'Priority' => '1030030'
};
$Self->{'Frontend::ToolBarModule'}->{'10-Ticket::AgentTicketService'} =  {
  'CssClass' => 'ServiceView',
  'Icon' => 'fa fa-wrench',
  'Module' => 'Kernel::Output::HTML::ToolBar::TicketService',
  'Priority' => '1030035'
};
$Self->{'Frontend::ToolBarModule'}->{'11-Ticket::TicketSearchProfile'} =  {
  'Module' => 'Kernel::Output::HTML::ToolBar::TicketSearchProfile',
  'Name' => 'Search template',
  'MaxWidth' =>40,
  'Priority' => '1990010'
};
$Self->{'Frontend::ToolBarModule'}->{'12-Ticket::TicketSearchFulltext'} =  {
  'Module' => 'Kernel::Output::HTML::ToolBar::Generic',
  'Name' => 'Fulltext search',
  'Block'=> 'ToolBarSearchFulltext',
  'Size' => 10,
  'CSS' =>'Core.Agent.Toolbar.FulltextSearch.css',
  'Priority' => '1990010'
};
$Self->{'Frontend::ToolBarModule'}->{'13-CICSearchCustomerID'} =  {
  'Module' => 'Kernel::Output::HTML::ToolBar::Generic',
  'Name' => 'CustomerID search',
  'Block'=> 'ToolBarCICSearchCustomerID',
  'Size' => 10,
  'CSS' =>'Core.Agent.Toolbar.CICSearch.css',
  'Priority' => '1990030'
};
$Self->{'Frontend::ToolBarModule'}->{'14-CICSearchCustomerUser'} =  {
  'Module' => 'Kernel::Output::HTML::ToolBar::Generic',
  'Name' => 'Customer user search',
  'Block'=> 'ToolBarCICSearchCustomerUser',
  'Size' => 10,
  'CSS' =>'Core.Agent.Toolbar.CICSearch.css',
  'Priority' => '1990040'
};
$Self->{'Ticket::Frontend::OverviewSmall'}->{'ColumnHeader'} =  'LastCustomerSubject';
$Self->{'PostMaster::PreFilterModule'}->{'1-Match'} =  {
  'Match' => {
    'From' => 'noreply@'
  },
  'Module' => 'Kernel::System::PostMaster::Filter::Match',
  'Set' => {
    'X-OTRS-ArticleType' => 'email-internal',
    'X-OTRS-FollowUp-ArticleType' => 'email-external',
    'X-OTRS-Ignore' => 'yes'
  },
};
$Self->{'PostMaster::PreCreateFilterModule'}->{'000-FollowUpArticleTypeCheck'} =  {
  'ArticleType' => 'email-internal',
  'Module' => 'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck',
  'SenderType' => 'customer',
  'X-OTRS-ArticleType' => 'email-internal',
  'X-OTRS-FollowUp-ArticleType' => 'email-external'
};
$Self->{'PostMaster::CheckFollowUpModule'}->{'0100-Subject'} =  {
  'ArticleType' => 'email-external',
  'Module' => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
  'SenderType' => 'customer',
  'X-OTRS-ArticleType' => 'email-internal',
  'X-OTRS-FollowUp-ArticleType' => 'email-external'
};

$Self->{'Ticket::Frontend::AgentTicketQueue'}->{'HighlightAge1'} = '1234';

$Self->{'Test'}->{'HighlightAge2'} = '5678';

}

1;
