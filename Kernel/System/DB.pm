# --
# DB.pm - the global database wrapper to support different databases 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.4 2001-12-30 00:41:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB;

use strict;
use DBI;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    
    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{Debug} = 0;
    
    # get config data
    my $ConfigObject = $Param{ConfigObject};
    $Self->{HOST} = $ConfigObject->Get('DatabaseHost');
    $Self->{DB}   = $ConfigObject->Get('Database');
    $Self->{USER} = $ConfigObject->Get('DatabaseUser');
    $Self->{PW}   = $ConfigObject->Get('DatabasePw');
    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');

    # get log object
    $Self->{LogObject} = $Param{LogObject} || die "Got no LogObject!";
   
    # do db connect 
    $Self->Connect();
    
    return $Self;
}
# --
sub Connect {
    my $Self = shift;

    # debug
    if ($Self->{Debug} > 2) {
        $Self->{LogObject}->Log(
          Priority => 'debug', 
          MSG => "DB.pm->Connect: DB: $Self->{DB}, User: $Self->{USER}, Pw: $Self->{PW}",
        );
    }
    
    # db connect
    $Self->{dbh} = DBI->connect("$Self->{DSN}:$Self->{DB}", $Self->{USER}, $Self->{PW});

    return $Self->{dbh};
}
# --
sub Disconnect {
    my $Self = shift;

    # debug
    if ($Self->{Debug} > 2) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => "DB.pm->Disconnect",
        );
    }

    # do disconnect
    $Self->{dbh}->disconnect();

    return 1;
}
# --
sub Quote {
    my $Self = shift;
    my $Text = shift;
    $Text =~ s/'/\\'/g;
    return $Text;
}
# --
sub Do {
    my $Self = shift;
    my %Param = @_;
    my $SQL = $Param{SQL};

    # debug
    if ($Self->{Debug} > 0) {
        $Self->{DoCounter}++;
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => 'DB.pm->Do (' . $Self->{DoCounter} . ') SQL: ' . $SQL,
        );
    }

    # doing
    $Self->{dbh}->do($SQL);

    return 1;
}
# --
sub Prepare {
    my $Self = shift;
    my %Param = @_;
    my $SQL = $Param{SQL};
    my $Limit = $Param{Limit} || '';

    # build finally select query
    if ($Limit) {
        if ($Self->{DSN} =~ /mysql/i) {
            $SQL .= " LIMIT $Limit";
        }
        elsif ($Self->{DSN} =~ /db2/i) {
            $SQL .= " fetch $Limit first row";
        }
        else {
            $SQL .= " LIMIT $Limit";
        }
    }

    # debug
    if ($Self->{Debug} > 1) {
        $Self->{PrepareCounter}++;
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => 'DB.pm->Prepare ('.$Self->{PrepareCounter}.' / '.time().') SQL: '.$SQL,
        );
    }

    # do
    $Self->{Curser} = $Self->{dbh}->prepare($SQL);
    $Self->{Curser}->execute();
    return 1;
}
# --
sub FetchrowArray {
    my $Self = shift;
    my @RowTmp = $Self->{Curser}->fetchrow_array();
    return @RowTmp;
}
# --
sub FetchrowHashref {
    my $Self = shift;
    my $Data = $Self->{Curser}->fetchrow_hashref();
    return $Data;
}
# --
sub GetTableData {
    my $Self = shift;
    my %Param = @_;
    my $Table = $Param{Table};
    my $What = $Param{What};
    my $Whare = $Param{Where} || '';
    my $Valid = $Param{Valid} || '';
    my $Clamp = $Param{Clamp} || '';
    my %Data;
    my $SQL = "SELECT $What FROM $Table ";
    $SQL .= " WHERE " . $Whare if ($Whare);
    $SQL .= " WHERE valid_id in ( ${\(join ', ', $Self->GetValidIDs())} )" if ((!$Whare) && ($Valid));
    $Self->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->FetchrowArray()) {
        if ($RowTmp[2]) {
            if ($Clamp) {
                $Data{$RowTmp[0]} = $RowTmp[1] ." (". $RowTmp[2] . ")";
            }
            else {
                $Data{$RowTmp[0]} = $RowTmp[1] ." ". $RowTmp[2];
            }
        }
        else {
            $Data{$RowTmp[0]} = $RowTmp[1];
        }
    }
    return %Data;
}
# --
sub GetValidIDs {
    my $Self = shift;
    my %Param = @_;
    my @ValidIDs;
    if ($Self->{ValidIDs}) {
        my $ValidIDsTmp = $Self->{ValidIDs};
        @ValidIDs = @$ValidIDsTmp;
    }
    else {
        $Self->Prepare(SQL => "SELECT id FROM valid WHERE name = 'valid'");
        while (my @RowTmp = $Self->FetchrowArray()) {
            push(@ValidIDs, $RowTmp[0]);
        }
        $Self->{ValidIDs} = \@ValidIDs;
    }
    return @ValidIDs;
}
# --
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID};
    my @LockIDs = (2);
    my %Data;

    $Self->Prepare(
       SQL => "SELECT ar.id as ca, st.name, ti.id, ar.create_by" .
              " FROM " .
              " ticket ti, article ar, article_sender_type st" .
              " WHERE " .
              " ti.user_id = $UserID " .
              " AND " .
              " ti.ticket_lock_id in ( ${\(join ', ', @LockIDs)} )" .
              " AND " .
              " ar.ticket_id = ti.id " .
              " AND " .
              " st.id = ar.article_sender_type_id " .
              " ORDER BY ar.create_time DESC",
    );

    while (my @RowTmp = $Self->FetchrowArray()) {
        if (!$Data{"ID$RowTmp[2]"}) {
          $Data{'Count'}++;
          if ($RowTmp[1] ne 'agent' || $RowTmp[3] ne $UserID) {
            $Data{'ToDo'}++;
          }
        }
        $Data{"ID$RowTmp[2]"} = 1;
    }
    return %Data;
}
# --
sub DESTROY {
    my $Self = shift;
    $Self->Disconnect();
}
# --

1;

