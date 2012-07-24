# --
# NotificationEvent.t - NotificationEvent tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: NotificationEvent.t,v 1.1 2012-07-24 23:05:51 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::NotificationEvent;
use Kernel::System::Time;
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

# set UserID
my $UserID = 1;

my $ConfigObject = Kernel::Config->new();

# create common objects
my $TimeObject = Kernel::System::Time->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# Make sure that Kernel::System::Ticket::new() does not create it's own QueueObject.
# This will interfere with caching.
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    TimeObject   => $TimeObject,
    QueueObject  => $QueueObject,
    ConfigObject => $ConfigObject,
);

my $NotificationEventObject = Kernel::System::NotificationEvent->new(
    %{$Self},
    TicketObject => $TicketObject,
    TimeObject   => $TimeObject,
    QueueObject  => $QueueObject,
    ConfigObject => $ConfigObject,
);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,

    #    RestoreSystemConfiguration => 1,
);

my $RandomID = $HelperObject->GetRandomID();

my $TestNumber = 1;

my @Tests = (

    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Name    => 'JobName' . $RandomID,
            Subject => 'JobName',
            Body    => 'JobName',
            Type    => 'text/plain',
            Charset => 'iso-8895-1',
            Comment => 'Just something for test',
            Data    => {
                Events => [ 'TicketQueueUpdate', ],
                Queue  => [ 'SomeQueue', ],
            },
            ValidID => 1,
        },

        #        Update => {
        #            Name    => 'JobName',
        #            Subject => 'JobName',
        #            Body    => 'JobName',
        #            Type    => 'text/plain',
        #            Charset => 'iso-8895-1',
        #            Data => {
        #                Events => [ 'TicketQueueUpdate', ],
        #                Queue => [ 'SomeQueue', ],
        #            },
        #            ValidID => 1,
        #        },
    },
);

my %NotificationIDs;
for my $Test (@Tests) {

    # Add NotificationEvent
    my $NotificationID = $NotificationEventObject->NotificationAdd(
        %{ $Test->{Add} },
        UserID => $UserID,
    );

    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $NotificationID,
            "$Test->{Name} - NotificationEventAdd()",
        );
        next;
    }
    else {
        $Self->True(
            $NotificationID,
            "$Test->{Name} - NotificationEventAdd()",
        );
    }

    # remember ID to verify it later
    $NotificationIDs{$NotificationID} = $Test->{Add}->{Name};

    # get NotificationEvent
    my %NotificationEvent = $NotificationEventObject->NotificationGet(
        Name => $Test->{Add}->{Name},
    );

    my %NotificationEventByID = $NotificationEventObject->NotificationGet(
        ID => $NotificationID,
    );

    $Self->IsDeeply(
        \%NotificationEvent,
        \%NotificationEventByID,
        "$Test->{Name} - NotificationEventGet() - By name and by ID",
    );

    # verify NotificationEvent
    $Self->Is(
        1,
        IsHashRefWithData( \%NotificationEvent ),
        "$Test->{Name} - NotificationEventGet() - Right structure",
    );

    $Self->Is(
        $NotificationID,
        $NotificationEvent{ID},
        "$Test->{Name} - NotificationEventGet() - ID",
    );

    $Self->Is(
        $Test->{Add}->{Name},
        $NotificationEvent{Name},
        "$Test->{Name} - NotificationEventGet() - Name",
    );

    $Self->Is(
        $Test->{Add}->{Body},
        $NotificationEvent{Body},
        "$Test->{Name} - NotificationEventGet() - Body",
    );

    $Self->Is(
        $Test->{Add}->{Charset},
        $NotificationEvent{Charset},
        "$Test->{Name} - NotificationEventGet() - Charset",
    );

    $Self->Is(
        $Test->{Add}->{Comment},
        $NotificationEvent{Comment},
        "$Test->{Name} - NotificationEventGet() - Comment",
    );

    $Self->Is(
        $Test->{Add}->{Subject},
        $NotificationEvent{Subject},
        "$Test->{Name} - NotificationEventGet() - Subject",
    );

    $Self->Is(
        $Test->{Add}->{Type},
        $NotificationEvent{Type},
        "$Test->{Name} - NotificationEventGet() - Type",
    );

    $Self->Is(
        $Test->{Add}->{ValidID},
        $NotificationEvent{ValidID},
        "$Test->{Name} - NotificationEventGet() - ValidID",
    );

    $Self->IsDeeply(
        $Test->{Add}->{Data},
        $NotificationEvent{Data},
        "$Test->{Name} - NotificationEventGet() - Data",
    );

    $Self->True(
        $NotificationEvent{ChangeTime},
        "$Test->{Name} - NotificationEventGet() - ChangeTime",
    );

    $Self->True(
        $NotificationEvent{CreateTime},
        "$Test->{Name} - NotificationEventGet() - CreateTime",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{ChangeBy},
        "$Test->{Name} - NotificationEventGet() - ChangeBy",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{CreateBy},
        "$Test->{Name} - NotificationEventGet() - CreateBy",
    );

    # update NotificationEvent
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }

    # include ID on update data
    $Test->{Update}->{ID} = $NotificationID;

    my $SuccessUpdate = $NotificationEventObject->NotificationUpdate(
        %{ $Test->{Update} },
        UserID => $UserID,
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $SuccessUpdate,
            "$Test->{Name} - NotificationEventUpdate() False",
        );
        next;
    }
    else {
        $Self->True(
            $SuccessUpdate,
            "$Test->{Name} - NotificationEventUpdate() True",
        );
    }

    # get NotificationEvent
    %NotificationEvent = $NotificationEventObject->NotificationGet(
        Name => $Test->{Update}->{Name},
    );

    %NotificationEventByID = $NotificationEventObject->NotificationGet(
        ID => $NotificationID,
    );

    $Self->IsDeeply(
        \%NotificationEvent,
        \%NotificationEventByID,
        "$Test->{Name} - NotificationEventGet() - By name and by ID",
    );

    # verify NotificationEvent
    $Self->Is(
        1,
        IsHashRefWithData( \%NotificationEvent ),
        "$Test->{Name} - NotificationEventGet() - Right structure",
    );

    $Self->Is(
        $NotificationID,
        $NotificationEvent{ID},
        "$Test->{Name} - NotificationEventGet() - ID",
    );

    $Self->Is(
        $Test->{Update}->{Name},
        $NotificationEvent{Name},
        "$Test->{Name} - NotificationEventGet() - Name",
    );

    $Self->Is(
        $Test->{Update}->{Body},
        $NotificationEvent{Body},
        "$Test->{Name} - NotificationEventGet() - Body",
    );

    $Self->Is(
        $Test->{Update}->{Charset},
        $NotificationEvent{Charset},
        "$Test->{Name} - NotificationEventGet() - Charset",
    );

    $Self->Is(
        $Test->{Update}->{Comment},
        $NotificationEvent{Comment},
        "$Test->{Name} - NotificationEventGet() - Comment",
    );

    $Self->Is(
        $Test->{Update}->{Subject},
        $NotificationEvent{Subject},
        "$Test->{Name} - NotificationEventGet() - Subject",
    );

    $Self->Is(
        $Test->{Update}->{Type},
        $NotificationEvent{Type},
        "$Test->{Name} - NotificationEventGet() - Type",
    );

    $Self->Is(
        $Test->{Update}->{ValidID},
        $NotificationEvent{ValidID},
        "$Test->{Name} - NotificationEventGet() - ValidID",
    );

    $Self->IsDeeply(
        $Test->{Update}->{Data},
        $NotificationEvent{Data},
        "$Test->{Name} - NotificationEventGet() - Data",
    );

    $Self->True(
        $NotificationEvent{ChangeTime},
        "$Test->{Name} - NotificationEventGet() - ChangeTime",
    );

    $Self->True(
        $NotificationEvent{CreateTime},
        "$Test->{Name} - NotificationEventGet() - CreateTime",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{ChangeBy},
        "$Test->{Name} - NotificationEventGet() - ChangeBy",
    );

    $Self->Is(
        $UserID,
        $NotificationEvent{CreateBy},
        "$Test->{Name} - NotificationEventGet() - CreateBy",
    );

}

# list check from DB
my %NotificationList = $NotificationEventObject->NotificationList();
for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->Is(
        $NotificationIDs{$NotificationID},
        $NotificationList{$NotificationID},
        "NotificationList() from DB found NotificationEvent $NotificationID",
    );

    # delete entry
    my $SuccesDelete = $NotificationEventObject->NotificationDelete(
        ID     => $NotificationID,
        UserID => $UserID,
    );

    $Self->True(
        $SuccesDelete,
        "NotificationDelete() - $NotificationID",
    );
}

# list check deleted entries
%NotificationList = $NotificationEventObject->NotificationList();
for my $NotificationID ( sort keys %NotificationIDs ) {
    $Self->False(
        $NotificationList{$NotificationID},
        "NotificationList() deleted entry - $NotificationID",
    );
}

1;
