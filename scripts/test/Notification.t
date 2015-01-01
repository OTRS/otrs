# --
# Notification.t - Notification tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::Notification;

# set UserID
my $UserID = 1;

my $NotificationObject = Kernel::System::Notification->new( %{$Self} );

# workaround for oracle
# oracle databases can't determine the difference between NULL and ''
my $IsNotOracle = 1;
if ( $Self->{DBObject}->GetDatabaseFunction('Type') eq 'oracle' ) {
    $IsNotOracle = 0;
}

# set test counter
my $TestNumber = 1;

# define test cases
my @Tests = (

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type        => 'NewTicket',
            Language    => 'en',
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
            ContentType => 'text/plain',
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
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
            Body        => 'Some Body with a tag',
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
            Subject     => 'Some Subject with a tag',
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
            Subject  => 'Some Subject with a tag',
            Body     => 'Some Body with a tag',
        },
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => $IsNotOracle,
        SuccessUpdate => 1,
        Add           => {
            Type        => '',
            Charset     => 'utf-8',
            Language    => 'de',
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
            ContentType => 'text/plain',
        },
    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => $IsNotOracle,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => '',
            Language    => 'en',
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
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
    #            Subject     => 'Some Subject with a tag',
    #            Body        => 'Some Body with a tag',
    #            ContentType => 'text/plain',
    #        },
    #    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => $IsNotOracle,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => '',
            Body        => 'Some Body with a tag',
            ContentType => 'text/plain',
        },
    },
    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => $IsNotOracle,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with a tag',
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
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
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
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
            ContentType => 'text/plain',
        },
        Update => {
            Type        => 'NewTicket',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with a tag',
            Body        => 'Some Body with a tag',
            ContentType => 'text/plain',
        },
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Type        => 'NewTicket-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject with a tag-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Body        => 'Some Body with a tag-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            ContentType => 'text/plain',
        },
        Update => {
            Type        => 'NewTicket - Modified - äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Charset     => 'utf-8',
            Language    => 'en',
            Subject     => 'Some Subject modified with a tag-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Body        => 'Some Body modified with a tag-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            ContentType => 'text/plain',
        },
    },
);

# Notification names should be stored,
# for deleting they later
my @NotificationNames;
for my $Test (@Tests) {

    # Add notification
    my $SuccessAdd = $NotificationObject->NotificationUpdate(
        %{ $Test->{Add} },
        UserID => $UserID,
    );

    # if add test should or not be successful
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

    # join language and type for creating Notification's name
    my $NotificationName = $Test->{Add}->{Language} . '::' . $Test->{Add}->{Type};

    # remember name to verify and delete it later
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

    # check if retrieved result match with the expected one
    $Self->IsDeeply(
        $Test->{Add},
        \%Notification,
        "$Test->{Name} - NotificationGet() - Complete result",
    );

    # get info from Add data if Update is not set
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }

    # perform notification update
    my $SuccessUpdate = $NotificationObject->NotificationUpdate(
        %{ $Test->{Update} },
        UserID => $UserID,
    );

    # if add test should or not be successful
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

    # join language and type for creating Notification's name, from Update data
    $NotificationName = $Test->{Update}->{Language} . '::' . $Test->{Update}->{Type};

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

    # check if retrieved result match with the expected one
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
