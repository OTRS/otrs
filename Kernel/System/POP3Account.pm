# --
# Kernel/System/POP3Account.pm - lib for POP3 accounts
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: POP3Account.pm,v 1.8 2004-02-02 23:27:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::POP3Account;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
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
sub POP3AccountAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Login Password Host ValidID Trusted DispatchingBy QueueID UserID)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "$_ not defined!");
        return;
      }
    }
    foreach (qw(Login Password Host ValidID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if dispatching is by From
    if ($Param{DispatchingBy} eq 'From') {
        $Param{QueueID} = 0;
    }
    elsif ($Param{DispatchingBy} eq 'Queue' && !$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID for dispatching!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "INSERT INTO pop3_account (login, pw, host, valid_id, comments, queue_id, " .
        " trusted, create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Login}', '$Param{Password}', '$Param{Host}', $Param{ValidID}, " .
        " '$Param{Comment}', $Param{QueueID}, $Param{Trusted}, " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        my $Id = 0;
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM pop3_account WHERE ".
              "login = '$Param{Login}' AND host = '$Param{Host}'",
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Id = $Row[0];
        }
        return $Id;
    }
    else {
        return;
    }
}
# --
sub POP3AccountGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql 
    my $SQL = "SELECT login, pw, host, queue_id, trusted, comments, valid_id " .
        " FROM " .
        " pop3_account " .
        " WHERE " . 
        " id = $Param{ID}";

    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    my %Data = ();
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        %Data = ( 
            ID => $Param{ID}, 
            Login => $Data[0],
            Password => $Data[1],
            Host => $Data[2],
            QueueID => $Data[3],
            Trusted => $Data[4],
            Comment => $Data[5],
            ValidID => $Data[6],
        );
    }
    if ($Data{QueueID} == 0) {
        $Data{DispatchingBy} = 'From';
    }
    else {
        $Data{DispatchingBy} = 'Queue';
    }
    return %Data;
}
# --
sub POP3AccountUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Login Password Host ValidID Trusted DispatchingBy QueueID UserID)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if dispatching is by From
    if ($Param{DispatchingBy} eq 'From') {
        $Param{QueueID} = 0;
    }
    elsif ($Param{DispatchingBy} eq 'Queue' && !$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID for dispatching!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "UPDATE pop3_account SET login = '$Param{Login}', pw = '$Param{Password}', ".
        " host = '$Param{Host}', comments = '$Param{Comment}', ".
        " trusted = $Param{Trusted}, valid_id = $Param{ValidID}, ".
        " change_time = current_timestamp, change_by = $Param{UserID}, queue_id = $Param{QueueID} " .
        " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub POP3AccountList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = $Param{Valid} || 0;
    return $Self->{DBObject}->GetTableData(
        What => 'id, login, host',
        Valid => $Valid,
        Clamp => 1,
        Table => 'pop3_account',
    );
}
# --

1;
