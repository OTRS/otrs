# --
# Notification.t - Notification tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Notification.t,v 1.1 2012-07-23 23:06:37 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::Notification;

# set UserID
my $UserID = 1;

my $NotificationObject = Kernel::System::Notification->new( %{$Self} );

my $TestNumber = 1;

my @Tests = (

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type        => 'NewTicket',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type     => 'NewTicket',
            Charset  => 'utf-8',
            Language => 'en',
            Subject  => 'Some Subject with <OTRS_TAGS>',
            Body     => 'Some Body with <OTRS_TAGS>',
        },
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => '',
            Charset     => 'utf-8',
            Language    => 'de',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => '',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },

    # Type and Language should be not empty
    #    {
    #        Name          => 'Test ' . $TestNumber++,
    #        SuccessAdd    => 1,
    #        SuccessUpdate => 1,
    #        Add           => {
    #            Type        => 'NewTicket' . $TestNumber,
    #            Charset     => 'utf-8',
    #            Language    => '',
    #            Subject     => 'Some Subject with <OTRS_TAGS>',
    #            Body        => 'Some Body with <OTRS_TAGS>',
    #            ContentType => 'text/plain',
    #        },
    #    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => '',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => '',
            ContentType => 'text/plain',
        },
    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => '',
        },
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
        Update => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with <OTRS_TAGS>',
            Body        => 'Some Body with <OTRS_TAGS>',
            ContentType => 'text/plain',
        },
    },
);

my @NotificationNames;
for my $Test (@Tests) {

    # Add notification
    my $SuccessAdd = $NotificationObject->NotificationUpdate(
        %{ $Test->{Add} },
        UserID => $UserID,
    );

    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $SuccessAdd,
            "$Test->{Name} - NotificationAdd()",
        );
        next;
    }
    else {
        $Self->True(
            $SuccessAdd,
            "$Test->{Name} - NotificationAdd()",
        );
    }

    my $NotificationName = $Test->{Add}->{Language} . '::' . $Test->{Add}->{Type};

    # remember name to verify it later
    push @NotificationNames, $NotificationName;

    # get notification
    my %Notification = $NotificationObject->NotificationGet(
        Name => $NotificationName,
    );

    # fix ContentType
    $Test->{Add}->{ContentType} = 'text/plain' if !$Test->{Add}->{ContentType};

    # fix Charset
    $Test->{Add}->{Charset} = 'utf-8' if !$Test->{Add}->{Charset};

    # verify notification
    $Self->Is(
        $Notification{Language} . '::' . $Notification{Type},
        $NotificationName,
        "$Test->{Name} - NotificationGet()",
    );

    $Self->IsDeeply(
        $Test->{Add},
        \%Notification,
        "$Test->{Name} - NotificationGet() - Complete result",
    );

    # update notification
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }

    my $SuccessUpdate = $NotificationObject->NotificationUpdate(
        %{ $Test->{Update} },
        UserID => $UserID,
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $SuccessUpdate,
            "$Test->{Name} - NotificationUpdate() False",
        );
        next;
    }
    else {
        $Self->True(
            $SuccessUpdate,
            "$Test->{Name} - NotificationUpdate() True",
        );
    }

    # get notification
    %Notification = $NotificationObject->NotificationGet(
        Name => $NotificationName,
    );

    # fix ContentType
    $Test->{Update}->{ContentType} = 'text/plain' if !$Test->{Update}->{ContentType};

    # fix Charset
    $Test->{Update}->{Charset} = 'utf-8' if !$Test->{Update}->{Charset};

    # verify notification
    $Self->Is(
        $Notification{Language} . '::' . $Notification{Type},
        $NotificationName,
        "$Test->{Name} - NotificationGet() - Update",
    );

    $Self->IsDeeply(
        $Test->{Update},
        \%Notification,
        "$Test->{Name} - NotificationGet() - Update - Complete result",
    );

}

# list check from DB
my %NotificationList = $NotificationObject->NotificationList();
for my $NotificationName (@NotificationNames) {
    $Self->True(
        scalar $NotificationList{$NotificationName},
        "NotificationList() from DB found Notification $NotificationName",
    );
}

1;
