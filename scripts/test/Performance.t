# --
# scripts/test/Performance.t - a performance testscript
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Performance.t,v 1.18 2011-02-17 14:55:52 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

# declare externally defined variables to avoid errors under 'use strict'
use vars qw( $Self %Param );
use Time::HiRes qw(gettimeofday tv_interval);

#----------------------------------#
# use - load classes
#----------------------------------#
my $StartUse = [ gettimeofday() ];

use Kernel::System::AuthSession;
use Kernel::System::Web::Request;
use Kernel::System::Group;
use Kernel::System::Queue;
use Kernel::System::User;
use Kernel::System::Ticket;
use Kernel::Output::HTML::Layout;
use Kernel::Modules::AgentTicketQueue;

my $DiffTime = tv_interval($StartUse);
$Self->True(
    1,
    "$DiffTime seconds - for all 'use' calls.",
);

#-----------------------------------#
# generate new objects - first part
#-----------------------------------#
#my $StartNew = [gettimeofday];

# create local objects
my $SessionObject = Kernel::System::AuthSession->new( %{$Self} );

my $ParamObject = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => $Param{WebRequest} || 0,
);

my $QueueObject = Kernel::System::Queue->new( %{$Self} );
my $GroupObject = Kernel::System::Group->new( %{$Self} );
my $UserObject  = Kernel::System::User->new(
    %{$Self},
    GroupObject => $GroupObject,
);

#-----------------------------------------#
# find the user with the most privileges
#-----------------------------------------#

my $StartMostImportantUser = [ gettimeofday() ];
my %UserList               = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

my $GroupsCount = 0;
for my $UserID ( keys %UserList ) {
    my %Groups = $GroupObject->GroupMemberList(
        UserID => $UserID,
        Type   => 'rw',
        Result => 'HASH',
    );
    if ( $GroupsCount < scalar keys %Groups ) {
        $GroupsCount = scalar keys %Groups;
        $Self->{UserID} = $UserID;
    }
}
$DiffTime = tv_interval($StartMostImportantUser);
$Self->True(
    1,
    "$DiffTime seconds - find the user with the most privileges ($UserList{$Self->{UserID}}). To get an useful user for the following tests.",
);

#-----------------------------------#
# generate new objects - second part
#-----------------------------------#

my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
);

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    %{$Self},
    SessionObject => $SessionObject,
    ParamObject   => $ParamObject,
    TicketObject  => $TicketObject,
    GroupObject   => $GroupObject,
    QueueObject   => $QueueObject,
    UserObject    => $UserObject,
    SessionID     => 1234,
    Action        => 'AgentTicketQueue',
    UserID        => 2,
    Lang          => 'de',
);

#$QueueObject = Kernel::System::Queue->new( %{$Self} );

my $AgentTicketQueueObject = Kernel::Modules::AgentTicketQueue->new(
    %{$Self},
    ParamObject  => $ParamObject,
    LayoutObject => $LayoutObject,
    QueueObject  => $QueueObject,
    GroupObject  => $GroupObject,
    UserObject   => $UserObject,
);

#$DiffTime = tv_interval($StartNew);
#$Self->True(
#    1,
#    "$DiffTime seconds - to handle all new() calls." ,
#);

#----------------------------------#
# GetOverTimeTickets
#----------------------------------#
my $StartGetOverTimeTickets = [ gettimeofday() ];
my @EscalationTickets = $TicketObject->GetOverTimeTickets( UserID => 1 );

# this check is only to display how long it had take
$DiffTime = tv_interval($StartGetOverTimeTickets);
$Self->True(
    1,
    "$DiffTime seconds - to handle GetOverTimeTickets.",
);

#----------------------------------#
# NavigationBar
#----------------------------------#
my $StartNavigationBar = [ gettimeofday() ];
my $Output             = $LayoutObject->NavigationBar();
$DiffTime = tv_interval($StartNavigationBar);
$Self->True(
    1,
    "$DiffTime seconds - to handle NavigationBar.",
);

#-----------------------------------------------------#
# ShowTicket - especially to test the pre module time
#-----------------------------------------------------#
my @TicketIDs = $TicketObject->TicketSearch(
    Result    => 'ARRAY',
    Limit     => 15,
    StateType => 'Open',
    UserID    => 1,
);
my $StartShowTicket = [ gettimeofday() ];

{
    my $STDOUT;

    # redirect STDOUT to empty variable, it is not needed
    local *STDOUT;
    open STDOUT, '>:utf8', \$STDOUT;

    $LayoutObject->TicketListShow(
        TicketIDs => \@TicketIDs,
        Total     => 40,
        Env       => {
            %{$Self},
            ParamObject  => $ParamObject,
            LayoutObject => $LayoutObject,
            QueueObject  => $QueueObject,
            GroupObject  => $GroupObject,
            UserObject   => $UserObject,
            TicketObject => $TicketObject,
        },
        View       => 'Preview',
        TitleName  => 'Queue',
        TitleValue => 'SelectedQueue',
        LinkPage   => 'LinkPage',
        LinkSort   => 'LinkSort',
    );
}

$DiffTime = tv_interval($StartShowTicket);

$Self->True(
    1,
    "$DiffTime seconds - to handle TicketListShow, View->Preview.",
);

#----------------------------------#
# All tests
#----------------------------------#
$DiffTime = tv_interval($StartUse);
$Self->True(
    1,
    "$DiffTime seconds - to handle all functions.",
);

1;
