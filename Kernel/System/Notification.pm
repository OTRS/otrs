# --
# Kernel/System/Notification.pm - lib for notifications
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Notification.pm,v 1.11 2007-01-20 23:11:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Notification;

use strict;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    return $Self;
}

sub NotificationGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Name!");
        return;
    }
    my ($Language, $Type);
    if ($Param{Name} =~ /^(.+?)::(.*)/) {
        $Language = $Self->{DBObject}->Quote($1);
        $Type = $Self->{DBObject}->Quote($2);
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "SELECT id, notification_type, notification_charset, ".
        " notification_language, subject, text ".
        " FROM ".
        " notifications ".
        " WHERE ";
    if ($Param{ID}) {
        $SQL .= " id = $Param{ID}";
    }
    else {
        $SQL .= " notification_type = '$Type' AND ".
            "notification_language = '$Language'";
    }
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    my %Data = ();
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        if ($Self->{EncodeObject}->EncodeInternalUsed()) {
            # convert body
            $Data[5] = $Self->{EncodeObject}->Convert(
                Text => $Data[5],
                From => $Data[2],
                To => $Self->{EncodeObject}->EncodeInternalUsed(),
                Force => 1,
            );
            # convert subject
            $Data[3] = $Self->{EncodeObject}->Convert(
                Text => $Data[3],
                From => $Data[2],
                To => $Self->{EncodeObject}->EncodeInternalUsed(),
                Force => 1,
            );
            # set new charset
            $Data[2] = $Self->{EncodeObject}->EncodeInternalUsed();
        }
        # fix some bad stuff from some browsers (Opera)!
        $Data[5] =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;
        %Data = (
            Type => $Data[1],
            Charset => $Data[2],
            Language => $Data[3],
            Subject => $Data[4],
            Body => $Data[5],
        );
    }
    if (!%Data && !$Param{Loop}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Can't find notification for $Type and $Language, try it again with en!",
        );
        return $Self->NotificationGet(%Param, Name => "en::$Type", Loop => $Language);
    }
    elsif (!%Data && $Param{Loop}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't find notification for $Type and $Language!",
        );
        return;
    }
    else {
        return ( %Data, Language => $Param{Loop} || $Language );
    }
}

sub NotificationList {
    my $Self = shift;
    my %Param = @_;
    # sql
    my $SQL = "SELECT id, notification_type, notification_charset, ".
        " notification_language ".
        " FROM ".
        " notifications";
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    # get languages
    my %Languages = %{$Self->{ConfigObject}->{DefaultUsedLanguages}};
    # get possible notification types
    my %Types = ();
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        $Types{$Data[1]} = 1;
    }
    foreach (qw(NewTicket FollowUp LockTimeout OwnerUpdate AddNote Move PendingReminder Escalation)) {
        $Types{'Agent::'.$_} = 1;
    }
    foreach (qw(QueueUpdate OwnerUpdate StateUpdate)) {
        $Types{'Customer::'.$_} = 1;
    }
    # create list
    my %List = ();
    foreach my $Language (keys %Languages) {
        foreach my $Type (keys %Types) {
            $List{$Language.'::'.$Type} = $Language."::$Type";
        }
    }
    # get real list
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        $List{$Data[3].'::'.$Data[1]} = "$Data[3]::$Data[1]";
    }
    return %List;
}

sub NotificationUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Type Charset Language Subject Body UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # fix some bad stuff from some browsers (Opera)!
    $Param{Body} =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;
    # db quote
    foreach (qw(Type Charset Language Subject Body)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    $Self->{DBObject}->Prepare(SQL => "DELETE FROM notifications WHERE notification_type = '$Param{Type}' AND notification_language = '$Param{Language}'");
    # sql
    my $SQL = "INSERT INTO notifications ".
        " (notification_type, notification_charset, notification_language, subject, text, ".
        " create_time, create_by, change_time, change_by)".
        " VALUES ".
        " ('$Param{Type}', '$Param{Charset}', '$Param{Language}', '$Param{Subject}', '$Param{Body}', ".
        " current_timestamp, $Param{UserID}, current_timestamp,  $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

1;