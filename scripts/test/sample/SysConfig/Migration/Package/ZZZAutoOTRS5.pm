# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Backups::ZZZAutoOTRS5;
use strict;
use warnings;
no warnings 'redefine';
use utf8;

sub Load {
    my ( $File, $Self ) = @_;

    $Self->{'Ticket::Hook'} = 'TicketTestMigrated#';

    $Self->{'Frontend::Module'}->{'AgentTicketQueue'} = {
        'Description' => 'Overview of all open Tickets. Migrated.',
        'Group'       => [
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
                'AccessKey'   => 'o',
                'Block'       => '',
                'Description' => 'Overview of all open Tickets. Migrated.',
                'Link'        => 'Action=AgentTicketQueue',
                'LinkOption'  => '',
                'Name'        => 'Queue view',
                'NavBar'      => 'Ticket',
                'Prio'        => '100',
                'Type'        => ''
            },
            {
                'AccessKey'   => 't',
                'Block'       => 'ItemArea',
                'Description' => 'Test Migrated',
                'Link'        => 'Action=AgentTicketQueue',
                'LinkOption'  => '',
                'Name'        => 'Tickets',
                'NavBar'      => 'Ticket',
                'Prio'        => '200',
                'Type'        => 'Menu'
            }
        ],
        'NavBarName' => 'Ticket',
        'Title'      => 'QueueView'
    };

    $Self->{'Frontend::Module'}->{'AgentTicketProcess'} = {
        'Description' => 'Create new process ticket.',
        'Loader'      => {
            'CSS' => [
                'Core.Agent.TicketProcess.css'
            ],
            'JavaScript' => [
                'Core.Agent.CustomerSearch.js',
                'Core.Agent.TicketAction.js',
                'Core.Agent.TicketProcess.js'
            ]
        },
        'NavBar' => [
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Create New process ticket.',
                'Link'        => 'Action=AgentTicketProcess',
                'LinkOption'  => '',
                'Name'        => 'New process ticket',
                'NavBar'      => 'Ticket',
                'Prio'        => '220',
                'Type'        => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start new vacation process.',
                'Group'       => [
                    'users',
                ],
                'GroupRo'    => [],
                'Link'       => 'Action=AgentTicketProcess;Process=111',
                'LinkOption' => '',
                'Name'       => 'Start new vacation process',
                'NavBar'     => 'Ticket',
                'Prio'       => '230',
                'Type'       => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start sick process.',
                'Group'       => [],
                'GroupRo'     => [
                    'users',
                ],
                'Link'       => 'Action=AgentTicketProcess;Process=999',
                'LinkOption' => '',
                'Name'       => 'Start sick process',
                'NavBar'     => 'Ticket',
                'Prio'       => '240',
                'Type'       => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start special process.',
                'Link'        => 'Action=AgentTicketProcess;Process=555',
                'LinkOption'  => '',
                'Name'        => 'Start special process',
                'NavBar'      => 'Ticket',
                'Prio'        => '250',
                'Type'        => ''
            },
        ],
        'NavBarName' => 'Ticket',
        'Title'      => 'New process ticket'
    };

    $Self->{'PostMaster::PreFilterModule'}->{'1-TestPackage-Match'} = {
        'Match' => {
            'From' => 'noreply@'
        },
        'Module' => 'Kernel::System::PostMaster::Filter::Match',
        'Set'    => {
            'X-OTRS-ArticleType'          => 'email-internal',
            'X-OTRS-FollowUp-ArticleType' => 'email-external',
            'X-OTRS-Ignore'               => 'yes'
        },
    };
    $Self->{'PostMaster::PreCreateFilterModule'}->{'000-TestPackage-FollowUpArticleVisibilityCheck'} = {
        'ArticleType'                 => 'email-internal',
        'Module'                      => 'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck',
        'SenderType'                  => 'customer',
        'X-OTRS-ArticleType'          => 'email-internal',
        'X-OTRS-FollowUp-ArticleType' => 'email-external'
    };
    $Self->{'PostMaster::CheckFollowUpModule'}->{'0100-TestPackage-Subject'} = {
        'ArticleType'                 => 'email-external',
        'Module'                      => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
        'SenderType'                  => 'customer',
        'X-OTRS-ArticleType'          => 'email-internal',
        'X-OTRS-FollowUp-ArticleType' => 'email-external'
    };

}

1;
