# --
# DB.pm - the global database wrapper to support different databases 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.2 2001-12-05 18:41:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB;

use strict;
use DBI;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    
    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{DEBUG} = 2;
    
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
    if ($Self->{DEBUG} > 2) {
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
    if ($Self->{DEBUG} > 2) {
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
    if ($Self->{DEBUG} > 0) {
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
    if ($Self->{DEBUG} > 1) {
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
sub DESTROY {
    my $Self = shift;
    $Self->Disconnect();
}
# --

1;

