#!/usr/bin/perl
# --
# scripts/apache-perl-startup.pl - to load the modules if mod_perl is used
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# Make sure we are in a sane environment.
$ENV{MOD_PERL} =~ /mod_perl/ || die "MOD_PERL not used!";

BEGIN {
    # switch to unload_package_xs, the PP version is broken in Perl 5.10.1.
    # see http://rt.perl.org/rt3//Public/Bug/Display.html?id=72866
    $ModPerl::Util::DEFAULT_UNLOAD_METHOD = 'unload_package_xs';    ## no critic

    # set $0 to index.pl if it is not an existing file:
    # on Fedora, $0 is not a path which would break OTRS.
    # see bug # 8533
    if ( !-e $0 ) {
        $0 = '/opt/otrs/bin/cgi-bin/index.pl';
    }
}

use Apache2::RequestRec;
use ModPerl::Util;

use lib "/opt/otrs/";
use lib "/opt/otrs/Kernel/cpan-lib";
use lib "/opt/otrs/Custom";

# Preload frequently used modules to speed up client spawning.
use CGI ();
CGI->compile(':cgi');
use CGI::Carp ();

use Apache::DBI;

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
use Kernel::System::EventHandler;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::Cache;
use Kernel::System::CacheInternal;
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
use Kernel::Modules::AgentTicketWatchView;
use Kernel::Modules::AgentTicketEscalationView;
use Kernel::Modules::AgentTicketLockedView;
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
use Kernel::Modules::AdminTemplate;
use Kernel::Modules::AdminQueueTemplates;
use Kernel::Modules::AdminAttachment;
use Kernel::Modules::AdminTemplateAttachment;
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
use Kernel::Modules::CustomerTicketOverview;
use Kernel::Modules::CustomerTicketZoom;

# frontend modules
use Kernel::Output::HTML::Layout;
use Kernel::Output::HTML::LayoutTicket;
use Kernel::Output::HTML::PreferencesGeneric;
use Kernel::Output::HTML::PreferencesLanguage;
use Kernel::Output::HTML::PreferencesPassword;
use Kernel::Output::HTML::PreferencesTheme;
use Kernel::Output::HTML::NavBarModuleAdmin;
use Kernel::Output::HTML::NotificationUIDCheck;
use Kernel::Output::HTML::NotificationAgentOnline;
use Kernel::Output::HTML::NotificationCustomerOnline;
use Kernel::Output::HTML::TicketMenuGeneric;
use Kernel::Output::HTML::TicketMenuLock;
use Kernel::Output::HTML::ToolBarTicketLocked;
use Kernel::Output::HTML::ToolBarTicketResponsible;
use Kernel::Output::HTML::ToolBarTicketWatcher;
use Kernel::Output::HTML::ToolBarGeneric;
use Kernel::Output::HTML::ToolBarTicketSearchProfile;
use Kernel::Output::HTML::ArticleAttachmentDownload;
use Kernel::Output::HTML::ArticleAttachmentHTMLViewer;

1;
