# --
# Kernel/System/Notification.pm - lib for notifications
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Notification;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Notification - notification functions

=head1 SYNOPSIS

This module is managing notifications.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $NotificationObject = $Kernel::OM->Get('Kernel::System::Notification');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item NotificationGet()

get notification attributes

    my %Notification = $NotificationObject->NotificationGet(
        Name => 'de::NewTicket',
    );

=cut

sub NotificationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!'
        );
        return;
    }

    my ( $Language, $Type ) = $Param{Name} =~ m{^(.+?)::(.*)}smx;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => 'SELECT id, notification_type, notification_charset, '
            . ' notification_language, subject, text, content_type '
            . ' FROM notifications WHERE '
            . ' notification_type = ? AND notification_language = ?',
        Bind  => [ \$Type, \$Language, ],
        Limit => 1,
    );

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # convert body
        $Data[5] = $EncodeObject->Convert(
            Text  => $Data[5],
            From  => $Data[2],
            To    => 'utf-8',
            Force => 1,
        );

        # convert subject
        $Data[3] = $EncodeObject->Convert(
            Text  => $Data[4],
            From  => $Data[2],
            To    => 'utf-8',
            Force => 1,
        );

        # set new charset
        $Data[2] = 'utf-8';

        # fix some bad stuff from some browsers (Opera)!
        $Data[5] =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;
        %Data = (
            Type        => $Data[1],
            Charset     => $Data[2],
            Language    => $Data[3],
            Subject     => $Data[4],
            Body        => $Data[5],
            ContentType => $Data[6] || 'text/plain',
        );
    }

    if ( !%Data && !$Param{Loop} ) {

        return $Self->NotificationGet(
            %Param,
            Name => 'en::' . $Type,
            Loop => $Language,
        );
    }
    elsif ( !%Data && $Param{Loop} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't find notification for $Type and $Language!",
        );
        return;
    }

    return ( %Data, Language => $Param{Loop} || $Language );
}

=item NotificationList()

get notification list

    my %List = $NotificationObject->NotificationList();

=cut

sub NotificationList {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, notification_type, notification_charset, '
            . ' notification_language FROM notifications',
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get languages
    my %Languages = %{ $ConfigObject->{DefaultUsedLanguages} };

    # get possible notification types
    my %Types;
    TYPE:
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # do not use customer notifications this way anymore (done by notification event now)
        next TYPE if $Data[1] =~ /Customer::(Owner|Queue|State)Update/;
        $Types{ $Data[1] } = 1;
    }
    for (qw(NewTicket FollowUp LockTimeout OwnerUpdate AddNote Move PendingReminder Escalation)) {
        $Types{ 'Agent::' . $_ } = 1;
    }

    # create list
    my %List;
    for my $Language ( sort keys %Languages ) {

        for my $Type ( sort keys %Types ) {
            $List{ $Language . '::' . $Type } = $Language . '::' . $Type;
        }
    }

    # get real list
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, notification_type, notification_charset, '
            . ' notification_language FROM notifications',
    );

    TYPE:
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # do not use customer notifications this way anymore (done by notification event now)
        next TYPE if $Data[1] =~ /Customer::(Owner|Queue|State)Update/;

        # remember list
        $List{ $Data[3] . '::' . $Data[1] } = $Data[3] . '::' . $Data[1];
    }
    return %List;
}

=item NotificationUpdate()

update notification attributes

    $NotificationObject->NotificationUpdate(
        Type        => 'NewTicket',
        Charset     => 'utf-8',
        Language    => 'en',
        Subject     => 'Some Subject with <OTRS_TAGS>',
        Body        => 'Some Body with <OTRS_TAGS>',
        ContentType => 'text/plain',
        UserID      => 123,
    );

=cut

sub NotificationUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Charset Language Subject Body ContentType UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # fix some bad stuff from some browsers (Opera)!
    $Param{Body} =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    $DBObject->Do(
        SQL => 'DELETE FROM notifications WHERE notification_type = ? '
            . 'AND notification_language = ?',
        Bind => [
            \$Param{Type}, \$Param{Language},
        ],
    );

    # sql
    return if !$DBObject->Prepare(
        SQL => 'INSERT INTO notifications '
            . '(notification_type, notification_charset, notification_language, subject, text, '
            . 'content_type, create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Type}, \$Param{Charset},     \$Param{Language}, \$Param{Subject},
            \$Param{Body}, \$Param{ContentType}, \$Param{UserID},   \$Param{UserID},
        ],
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
