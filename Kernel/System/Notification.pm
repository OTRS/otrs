# --
# Kernel/System/Notification.pm - lib for notifications
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Notification.pm,v 1.3 2004-02-01 21:02:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Notification;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
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

    return $Self;
}
# --
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
        $Language = $1;
        $Type = $2;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
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
#print STDERR "SQL: $SQL\n";
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    my %Data = ();
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
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
# --
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
my @Type = (qw(NewTicket FollowUp LockTimeout OwnerUpdate AddNote Move PendingReminder));
    foreach (@Type) {
        $Types{'Agent::'.$_} = 1;
    }
    # create list
    my %List = ();
    foreach my $Language (keys %Languages) {
        foreach my $Type (keys %Types) {
            $List{$Language.'::'.$Type} = $Language."::$Type";
#print STDERR "ddd $Language :: $Type\n";
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
# --
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
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
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
#print STDERR "SQL: $SQL\n";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --

1;
