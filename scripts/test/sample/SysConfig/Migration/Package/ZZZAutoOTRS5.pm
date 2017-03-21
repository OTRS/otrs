# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Backups::ZZZAutoOTRS5;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
sub Load {
    my ($File, $Self) = @_;

$Self->{'Ticket::Hook'} = 'TicketTestMigrated#';

$Self->{'Frontend::Module'}->{'AgentTicketQueue'} =  {
  'Description' => 'Overview of all open Tickets. Migrated.',
  'Group' => [
    'admin'
  ],
  'Loader' => {
    'CSS' => [
      'Core.AgentTicketQueue.css',
      'Core.AllocationList.css'
    ],
    'JavaScript' => [
      'Core.UI.AllocationList.js',
      'Core.Agent.TableFilters.js'
    ]
  },
  'NavBar' => [
    {
      'AccessKey' => 'o',
      'Block' => '',
      'Description' => 'Overview of all open Tickets. Migrated.',
      'Link' => 'Action=AgentTicketQueue',
      'LinkOption' => '',
      'Name' => 'Queue view',
      'NavBar' => 'Ticket',
      'Prio' => '100',
      'Type' => ''
    },
    {
      'AccessKey' => 't',
      'Block' => 'ItemArea',
      'Description' => 'Test Migrated',
      'Link' => 'Action=AgentTicketQueue',
      'LinkOption' => '',
      'Name' => 'Tickets',
      'NavBar' => 'Ticket',
      'Prio' => '200',
      'Type' => 'Menu'
    }
  ],
  'NavBarName' => 'Ticket',
  'Title' => 'QueueView'
};

}

1;
