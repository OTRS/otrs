# --
# Kernel/System/POP3Account.pm - lib for POP3 accounts
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: POP3Account.pm,v 1.2 2003-01-03 00:30:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::POP3Account;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    # --
    # check needed stuff
    # --
    foreach (qw(Login Password Host ValidID Trusted QueueID UserID)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db quote
    # --
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # --
    # sql
    # --
    my $SQL = "INSERT INTO pop3_account (login, pw, host, valid_id, comment, queue_id, " .
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
    # --
    # check needed stuff
    # --
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # --
    # sql 
    # --
    my $SQL = "SELECT login, pw, host, queue_id, trusted, comment, valid_id " .
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
    return %Data;
}
# --
sub POP3AccountUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ID Login Password Host ValidID Trusted QueueID UserID)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db quote
    # --
    foreach (keys %Param) {
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # --
    # sql
    # --
    my $SQL = "UPDATE pop3_account SET login = '$Param{Login}', pw = '$Param{Password}', " .
        " host = '$Param{Host}', comment = '$Param{Comment}', valid_id = $Param{ValidID}, " .
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
