#! /usr/bin/perl
use strict;

# make sure we are in a sane environment.
$ENV{GATEWAY_INTERFACE} =~ /^CGI-Perl/ or die "GATEWAY_INTERFACE not Perl!";

# --
# set otrs lib path!
# --
use lib "/opt/otrs/";
use lib "/opt/otrs/Kernel/cpan-lib";

# pull in things we will use in most requests so it is read and compiled
# exactly once

#use CGI (); CGI->compile(':all');
use CGI (); CGI->compile(':cgi');
use CGI::Carp ();

#use Apache ();
#use Apache::DBI ();
#Apache::DBI->connect_on_init('DBI:mysql:otrs', 'otrs', 'some-pass');
use DBI ();
use DBD::mysql ();

use Kernel::Config;
use Kernel::Config::Modules;
use Kernel::Config::ModulesCustomerPanel;

use Kernel::System::WebRequest;
use Kernel::System::DB;
use Kernel::System::Auth;
use Kernel::System::Auth::DB;
#use Kernel::System::Auth::LDAP;
use Kernel::System::AuthSession;
use Kernel::System::AuthSession::IPC;
#use Kernel::System::AuthSession::DB;
#use Kernel::System::AuthSession::FS;
use Kernel::System::User;
use Kernel::System::User::Preferences::DB;
use Kernel::System::Permission;
use Kernel::System::User::Preferences::DB;
use Kernel::System::Log;
use Kernel::System::Log::SysLog;
#use Kernel::System::Log::File;

use Kernel::System::Ticket;
use Kernel::System::Ticket::ArticleStorageDB;
#use Kernel::System::Ticket::ArticleStorageFS;
use Kernel::System::Ticket::IndexAccelerator::RuntimeDB;
#use Kernel::System::Ticket::IndexAccelerator::StaticDB;
use Kernel::System::Ticket::Number::DateChecksum;
#use Kernel::System::Ticket::Number::Date;
#use Kernel::System::Ticket::Number::AutoIncrement;
#use Kernel::System::Ticket::Number::Random;

use Kernel::System::Queue;
use Kernel::System::Lock;
use Kernel::System::State;
use Kernel::System::CustomerUser;
#use Kernel::System::CustomerUser::DB;
#use Kernel::System::CustomerUser::LDAP;
use Kernel::System::CustomerAuth;
#use Kernel::System::CustomerAuth::DB;
#use Kernel::System::CustomerAuth::LDAP;
use Kernel::System::CheckItem;
use Kernel::System::AutoResponse;

use Kernel::Output::HTML::Generic;

# web agent middle ware modules
use Kernel::Modules::AgentQueueView;
use Kernel::Modules::AgentStatusView;
use Kernel::Modules::AgentMove;
use Kernel::Modules::AgentZoom;
use Kernel::Modules::AgentAttachment;
use Kernel::Modules::AgentTicketPrint;
use Kernel::Modules::AgentPlain;
use Kernel::Modules::AgentNote;
use Kernel::Modules::AgentLock;
use Kernel::Modules::AgentPriority;
use Kernel::Modules::AgentFreeText;
use Kernel::Modules::AgentClose;
use Kernel::Modules::AgentPending;
use Kernel::Modules::AgentUtilities;
use Kernel::Modules::AgentCompose;
use Kernel::Modules::AgentForward;
use Kernel::Modules::AgentPreferences;
use Kernel::Modules::AgentMailbox;
use Kernel::Modules::AgentOwner;
use Kernel::Modules::AgentHistory;
use Kernel::Modules::AgentPhone;
use Kernel::Modules::AgentBounce;
use Kernel::Modules::AgentCustomer;
use Kernel::Modules::AgentSpelling;

# web admin middle ware modules
use Kernel::Modules::Admin;
use Kernel::Modules::AdminLog;
use Kernel::Modules::AdminSession;
use Kernel::Modules::AdminSelectBox;
use Kernel::Modules::AdminResponse;
use Kernel::Modules::AdminQueueResponses;
use Kernel::Modules::AdminAttachment;
use Kernel::Modules::AdminResponseAttachment;
use Kernel::Modules::AdminQueue;
use Kernel::Modules::AdminAutoResponse;
use Kernel::Modules::AdminQueueAutoResponse;
use Kernel::Modules::AdminSalutation;
use Kernel::Modules::AdminSignature;
use Kernel::Modules::AdminUser;
use Kernel::Modules::AdminGroup;
use Kernel::Modules::AdminUserGroup;
use Kernel::Modules::AdminSystemAddress;
use Kernel::Modules::AdminPOP3;
use Kernel::Modules::AdminCharset;
use Kernel::Modules::AdminState;
use Kernel::Modules::AdminEmail;
use Kernel::Modules::AdminCustomerUser;

# web customer middle ware modules
use Kernel::Modules::CustomerAttachment;
use Kernel::Modules::CustomerMessage;
use Kernel::Modules::CustomerPreferences;
use Kernel::Modules::CustomerTicketOverView;
use Kernel::Modules::CustomerZoom;

# web stats module
use Kernel::Modules::SystemStats;

1;
