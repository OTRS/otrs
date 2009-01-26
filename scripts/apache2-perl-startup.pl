#!/usr/bin/perl -w
# --
# scripts/apache-perl-startup.pl - to load the modules if mod_perl is used
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: apache2-perl-startup.pl,v 1.33 2009-01-26 15:26:57 mh Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

use strict;
use warnings;

# make sure we are in a sane environment.
#$ENV{GATEWAY_INTERFACE} =~ /^CGI-Perl/ or die "GATEWAY_INTERFACE not Perl!";
# check $ENV{MOD_PERL}, $ENV{GATEWAY_INTERFACE} is deprecated for mod_perl2
$ENV{MOD_PERL} =~ /mod_perl/ or die "MOD_PERL not used!";

# set otrs lib path!
use lib "/opt/otrs/";
use lib "/opt/otrs/Kernel/cpan-lib";

# pull in things we will use in most requests so it is read and compiled
# exactly once

#use CGI (); CGI->compile(':all');
use CGI ();
CGI->compile(':cgi');
use CGI::Carp ();

#use Apache::DBI ();
#Apache::DBI->connect_on_init('DBI:mysql:otrs', 'otrs', 'some-pass');
use DBI ();

# enable this if you use mysql
#use DBD::mysql ();
#use Kernel::System::DB::mysql;

# enable this if you use postgresql
#use DBD::Pg ();
#use Kernel::System::DB::postgresql;

# enable this if you use oracle
#use DBD::Oracle ();
#use Kernel::System::DB::oracle;

# core modules
use Kernel::Config;
use Kernel::System::Web::InterfaceAgent;
use Kernel::System::Web::InterfaceCustomer;
use Kernel::System::Web::InterfacePublic;
use Kernel::System::Web::Request;
use Kernel::System::Web::UploadCache;
use Kernel::System::DB;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Auth;
use Kernel::System::Auth::DB;
use Kernel::System::AuthSession;
use Kernel::System::AuthSession::DB;
use Kernel::System::User;
use Kernel::System::User::Preferences::DB;
use Kernel::System::XML;
use Kernel::System::Log;
use Kernel::System::Ticket;
use Kernel::System::Ticket::Number::DateChecksum;
use Kernel::System::Queue;
use Kernel::System::Lock;
use Kernel::System::State;
use Kernel::System::Priority;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerGroup;
use Kernel::System::CustomerAuth;
use Kernel::System::CheckItem;
use Kernel::System::AutoResponse;
use Kernel::System::Notification;
use Kernel::System::Email;
use Kernel::System::Stats;

# optional core modules
#use Kernel::System::Auth::LDAP;
#use Kernel::System::AuthSession::IPC;
#use Kernel::System::AuthSession::FS;
#use Kernel::System::PDF;
#use Kernel::System::Log::SysLog;
#use Kernel::System::Log::File;
#use Kernel::System::Ticket::ArticleStorageDB;
#use Kernel::System::Ticket::ArticleStorageFS;
#use Kernel::System::Ticket::IndexAccelerator::RuntimeDB;
#use Kernel::System::Ticket::IndexAccelerator::StaticDB;
#use Kernel::System::Ticket::Number::Date;
#use Kernel::System::Ticket::Number::AutoIncrement;
#use Kernel::System::Ticket::Number::Random;
#use Kernel::System::CustomerUser::DB;
#use Kernel::System::CustomerUser::LDAP;
#use Kernel::System::CustomerAuth::DB;
#use Kernel::System::CustomerAuth::LDAP;

# web agent middle ware modules
use Kernel::Modules::AgentTicketQueue;
use Kernel::Modules::AgentTicketStatusView;
use Kernel::Modules::AgentTicketMove;
use Kernel::Modules::AgentTicketZoom;
use Kernel::Modules::AgentTicketAttachment;
use Kernel::Modules::AgentTicketPrint;
use Kernel::Modules::AgentTicketPlain;
use Kernel::Modules::AgentTicketNote;
use Kernel::Modules::AgentTicketLock;
use Kernel::Modules::AgentTicketPriority;
use Kernel::Modules::AgentTicketFreeText;
use Kernel::Modules::AgentTicketClose;
use Kernel::Modules::AgentTicketPending;
use Kernel::Modules::AgentTicketSearch;
use Kernel::Modules::AgentTicketCompose;
use Kernel::Modules::AgentTicketForward;
use Kernel::Modules::AgentTicketBounce;
use Kernel::Modules::AgentTicketCustomer;
use Kernel::Modules::AgentTicketOwner;
use Kernel::Modules::AgentTicketHistory;
use Kernel::Modules::AgentTicketBulk;
use Kernel::Modules::AgentTicketPhone;
use Kernel::Modules::AgentTicketEmail;
use Kernel::Modules::AgentSpelling;
use Kernel::Modules::AgentBook;
use Kernel::Modules::AgentLinkObject;
use Kernel::Modules::AgentPreferences;
use Kernel::Modules::AgentStats;

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
use Kernel::Modules::AdminMailAccount;
use Kernel::Modules::AdminPGP;
use Kernel::Modules::AdminSMIME;
use Kernel::Modules::AdminPostMasterFilter;
use Kernel::Modules::AdminState;
use Kernel::Modules::AdminNotification;
use Kernel::Modules::AdminEmail;
use Kernel::Modules::AdminSysConfig;
use Kernel::Modules::AdminPackageManager;
use Kernel::Modules::AdminCustomerUser;
use Kernel::Modules::AdminCustomerUserGroup;
use Kernel::Modules::AdminRole;
use Kernel::Modules::AdminRoleUser;
use Kernel::Modules::AdminRoleGroup;

# web customer middle ware modules
use Kernel::Modules::CustomerPreferences;
use Kernel::Modules::CustomerTicketAttachment;
use Kernel::Modules::CustomerTicketMessage;
use Kernel::Modules::CustomerTicketOverView;
use Kernel::Modules::CustomerTicketZoom;
use Kernel::Modules::CustomerZoom;

# frontend modules
use Kernel::Output::HTML::Layout;
use Kernel::Output::HTML::LayoutTicket;
use Kernel::Output::HTML::PreferencesGeneric;
use Kernel::Output::HTML::PreferencesLanguage;
use Kernel::Output::HTML::PreferencesPassword;
use Kernel::Output::HTML::PreferencesTheme;
use Kernel::Output::HTML::NavBarModuleAdmin;
use Kernel::Output::HTML::NotificationUIDCheck;
use Kernel::Output::HTML::NotificationCharsetCheck;
use Kernel::Output::HTML::NotificationAgentOnline;
use Kernel::Output::HTML::NotificationCustomerOnline;
use Kernel::Output::HTML::NotificationAgentTicket;
use Kernel::Output::HTML::NotificationAgentTicketSeen;
use Kernel::Output::HTML::TicketMenuGeneric;
use Kernel::Output::HTML::TicketMenuLock;
use Kernel::Output::HTML::NavBarLockedTickets;
use Kernel::Output::HTML::ArticleAttachmentDownload;
use Kernel::Output::HTML::ArticleAttachmentHTMLViewer;

1;
