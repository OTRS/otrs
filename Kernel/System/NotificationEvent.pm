# --
# Kernel/System/NotificationEvent.pm - notification system module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::NotificationEvent;

use strict;
use warnings;

use Kernel::System::Valid;

=head1 NAME

Kernel::System::NotificationEvent - to manage the notifications

=head1 SYNOPSIS

All functions to manage the notification and the notification jobs.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::Queue;
    use Kernel::System::Ticket;
    use Kernel::System::NotificationEvent;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $QueueObject = Kernel::System::Queue->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );
    my $NotificationEventObject = Kernel::System::NotificationEvent->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        TimeObject   => $TimeObject,
        TicketObject => $TicketObject,
        QueueObject  => $QueueObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(DBObject ConfigObject LogObject TimeObject TicketObject QueueObject MainObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=item NotificationList()

returns a hash of all notifications

    my %List = $NotificationEventObject->NotificationList();

=cut

sub NotificationList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM notification_event' );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }
    return %Data;
}

=item NotificationGet()

returns a hash of the notification data

    my %Notification = $NotificationEventObject->NotificationGet( Name => 'NotificationName' );

    my %Notification = $NotificationEventObject->NotificationGet( ID => 123 );

=cut

sub NotificationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} && !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name or ID!' );
        return;
    }
    if ( $Param{Name} ) {
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT id, name, subject, text, content_type, charset, valid_id, '
                . 'comments, create_time, create_by, change_time, change_by '
                . 'FROM notification_event WHERE name = ?',
            Bind => [ \$Param{Name} ],
        );
    }
    else {
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT id, name, subject, text, content_type, charset, valid_id, '
                . 'comments, create_time, create_by, change_time, change_by '
                . 'FROM notification_event WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
    }
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ID}         = $Row[0];
        $Data{Name}       = $Row[1];
        $Data{Subject}    = $Row[2];
        $Data{Body}       = $Row[3];
        $Data{Type}       = $Row[4];
        $Data{Charset}    = $Row[5];
        $Data{ValidID}    = $Row[6];
        $Data{Comment}    = $Row[7];
        $Data{CreateTime} = $Row[8];
        $Data{CreateBy}   = $Row[9];
        $Data{ChangeTime} = $Row[10];
        $Data{ChangeBy}   = $Row[11];
    }
    return if !%Data;

    $Self->{DBObject}->Prepare(
        SQL => 'SELECT event_key, event_value FROM notification_event_item ' .
            ' WHERE notification_id = ?',
        Bind => [ \$Data{ID} ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data{Data}->{ $Row[0] } }, $Row[1];
    }
    return %Data;
}

=item NotificationAdd()

adds a new notification to the database

    my $ID = $NotificationEventObject->NotificationAdd(
        Name    => 'JobName',
        Subject => 'JobName',
        Body    => 'JobName',
        Type    => 'text/plain',
        Charset => 'iso-8895-1',
        Data => {
            Events => [ 'TicketQueueUpdate', ],
            ...
            Queue => [ 'SomeQueue', ],
        },
        Comment => 'An optional comment', # Optional
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub NotificationAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name Subject Body Type Charset Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if job name already exists
    my %Check = $Self->NotificationGet( Name => $Param{Name} );
    if (%Check) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't add notification '$Param{Name}', notification already exists!",
        );
        return;
    }

    # fix some bad stuff from some browsers (Opera)!
    $Param{Body} =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;

    # insert data into db
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO notification_event '
            . '(name, subject, text, content_type, charset, valid_id, comments, '
            . 'create_time, create_by, change_time, change_by) VALUES '
            . '(?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name},    \$Param{Subject}, \$Param{Body},
            \$Param{Type},    \$Param{Charset}, \$Param{ValidID},
            \$Param{Comment}, \$Param{UserID},  \$Param{UserID},
        ],
    );

    # get id
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM notification_event WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return if !$ID;

    for my $Key ( sort keys %{ $Param{Data} } ) {
        for my $Item ( @{ $Param{Data}->{$Key} } ) {
            next if !defined $Item;
            next if $Item eq '';
            $Self->{DBObject}->Do(
                SQL => 'INSERT INTO notification_event_item '
                    . '(notification_id, event_key, event_value) VALUES (?, ?, ?)',
                Bind => [ \$ID, \$Key, \$Item ],
            );
        }
    }

    return $ID;
}

=item NotificationUpdate()

update a notification in database

    my $Ok = $NotificationEventObject->NotificationUpdate(
        ID      => 123,
        Name    => 'JobName',
        Subject => 'JobName',
        Body    => 'JobName',
        Type    => 'text/plain',
        Charset => 'utf8',
        Data => {
            Queue => [ 'SomeQueue', ],
            ...
            Valid => [ 1, ],
        },
        UserID => 123,
    );

=cut

sub NotificationUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name Subject Body Type Charset Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # fix some bad stuff from some browsers (Opera)!
    $Param{Body} =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;

    # update data in db
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE notification_event SET '
            . 'name = ?, subject = ?, text = ?, content_type = ?, charset = ?, '
            . 'valid_id = ?, comments = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name},    \$Param{Subject}, \$Param{Body},
            \$Param{Type},    \$Param{Charset}, \$Param{ValidID},
            \$Param{Comment}, \$Param{UserID},  \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM notification_event_item WHERE notification_id = ?',
        Bind => [ \$Param{ID} ],
    );
    for my $Key ( sort keys %{ $Param{Data} } ) {
        for my $Item ( @{ $Param{Data}->{$Key} } ) {
            next if !defined $Item;
            next if $Item eq '';
            $Self->{DBObject}->Do(
                SQL => 'INSERT INTO notification_event_item '
                    . '(notification_id, event_key, event_value) VALUES (?, ?, ?)',
                Bind => [ \$Param{ID}, \$Key, \$Item ],
            );
        }
    }

    return 1;
}

=item NotificationDelete()

deletes an notification from the database

    $NotificationEventObject->NotificationDelete(
        ID     => 123,
        UserID => 123,
    );

=cut

sub NotificationDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if job name exists
    my %Check = $Self->NotificationGet( ID => $Param{ID} );
    if ( !%Check ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete notification '$Check{Name}', notification does not exist",
        );
        return;
    }

    # delete notification
    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM notification_event_item WHERE notification_id = ?',
        Bind => [ \$Param{ID} ],
    );
    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM notification_event WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "NotificationEvent notification '$Check{Name}' deleted (UserID=$Param{UserID}).",
    );
    return 1;
}

=item NotificationEventCheck()

returns array of notification affected by event

    my @IDs = $NotificationEventObject->NotificationEventCheck( Event => 'ArticleCreate' );

=cut

sub NotificationEventCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Event} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name!' );
        return;
    }
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT DISTINCT(nei.notification_id) FROM ' .
            'notification_event ne, notification_event_item nei WHERE ' .
            'ne.id = nei.notification_id AND ' .
            "ne.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} ) AND " .
            'nei.event_key = \'Events\' AND nei.event_value = ?',
        Bind => [ \$Param{Event} ],
    );

    my @IDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @IDs, $Row[0];
    }
    return @IDs;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
