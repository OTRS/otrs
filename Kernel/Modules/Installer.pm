# --
# Installer.pm - provides the DB installer
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Installer.pm,v 1.2 2002-02-03 18:16:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

# Note: this is the first version to support mysql. More databases 
# later.

package Kernel::Modules::Installer;

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

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach ('ParamObject', 'DBObject', 'LayoutObject', 'LogObject', 'ConfigObject') {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Subaction = $Self->{Subaction} || ''; 
    my $DirOfSQLFiles = '/usr/share/doc/packages/otrs/install/database/';

    # print form
    if ($Subaction eq '' || !$Subaction) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->InstallerStart();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # do select
    elsif ($Subaction eq 'DB') {
        $Output .= $Self->{LayoutObject}->Header();
        # get params
        my %DB = ();
        $DB{User} = $Self->{ParamObject}->GetParam(Param => 'DBUser') || '';
        $DB{Password} = $Self->{ParamObject}->GetParam(Param => 'DBPassword') || '';
        $DB{DatabaseHost} = $Self->{ParamObject}->GetParam(Param => 'DBHost') || '';
        $DB{Type} = $Self->{ParamObject}->GetParam(Param => 'DBType') || '';
        $DB{Database} = $Self->{ParamObject}->GetParam(Param => 'DBName') || ''; 
        $DB{DBAction} = $Self->{ParamObject}->GetParam(Param => 'DBAction') || '';
        $DB{DatabaseUser} = $Self->{ParamObject}->GetParam(Param => 'OpenTRSDBUser') || '';
        $DB{DatabasePw} = $Self->{ParamObject}->GetParam(Param => 'OpenTRSDBPassword') || '';
        $DB{NewHost} = $Self->{ParamObject}->GetParam(Param => 'OpenTRSDBConnectHost') || '';
        # check params
        foreach (keys %DB) {
            if (!$DB{$_} && $_ ne 'Password') {
                $Output .= $Self->{LayoutObject}->Error(
                   Message => "You need '$_'!!",
                   Comment => 'Please go back');
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        my $SetupOutput = '';
        my $MYCMD = "mysql -u $DB{User} ";
        $MYCMD .= " -p $DB{Password} " if ($DB{Password});
        $MYCMD .= " -h $DB{DatabaseHost}  ";

        if ($DB{DBAction} eq 'Create') {
          # FIXME !!! use $DB{Type}!!!
            # db
            my $CMD = $MYCMD . " -e 'create database $DB{Database}'";
            $SetupOutput .= "<pre>CMD: $CMD <br>";
            $SetupOutput .= $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "false.";
                $Output .= $SetupOutput . $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "done.";
            }
            $SetupOutput .= "</pre>";
            # tables
            $CMD = $MYCMD . " $DB{Database} < $DirOfSQLFiles/OpenTRS-schema.sql";
            $SetupOutput .= "<pre>CMD: $CMD <br>";
            $SetupOutput .= $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "false.";
                $SetupOutput .= $SetupOutput . $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "done.";
            } 
            $SetupOutput .= "</pre>";

            # inital insert
            $CMD = $MYCMD . " $DB{Database} < $DirOfSQLFiles/initial_insert.sql";

            $SetupOutput .= "<pre>CMD: $CMD <br>";
            $SetupOutput .= $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "false.";
                $Output .= $SetupOutput . $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "done.";
            }
            $SetupOutput .= "</pre>";

            # user add
            $CMD = $MYCMD . " -e \"GRANT ALL PRIVILEGES ON $DB{Database}.* TO ".
                  " $DB{DatabaseUser}\@$DB{NewHost} IDENTIFIED BY '$DB{DatabasePw}' WITH GRANT OPTION\" ";
            $SetupOutput .= "<pre>CMD: $CMD <br>";
            $SetupOutput .= $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "false.";
                $Output .= $SetupOutput . $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "done.";
            }
            $SetupOutput .= "</pre>";


            # --
            # ReConfigure Config.pm
            # --
            if ($Self->ReConfigure(%DB)) {
                $SetupOutput .= "Can't write Config.pm - please do some changes:<br>";
                $SetupOutput .= "\$Self->{DatabaseHost} = '$DB{DatabaseHost}';<br>";
                $SetupOutput .= "\$Self->{Database} = '$DB{Database}';<br>";
                $SetupOutput .= "\$Self->{DatabaseUser} = '$DB{DatabaseUser}';<br>";
                $SetupOutput .= "\$Self->{DatabasePw} = '$DB{DatabasePw}';<br>";
                $SetupOutput .= "\$Self->{SecureMode} = 1;<br>";

            }
            else {
                $SetupOutput .= "Config.pm updated.<br>";
                $SetupOutput .= "Your config ist finished. Pleace run shell> /opt/OpenTRS/bin/CheckPerm.sh";
            }

            $Output .= $Self->{LayoutObject}->InstallerFinish(Ready => 1, Setup => $SetupOutput, %DB);

        }
        elsif ($DB{DBAction} eq 'Delete') {
          # FIXME !!! use $DB{Type}!!!
            # drop database
            my $CMD .=  $MYCMD . " -e 'drop database $DB{Database}'"; 
            $SetupOutput .= "CMD: $CMD <br>";
            $SetupOutput .= $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "false.";
                $Output .= $SetupOutput . $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "done.";
            }
            # user delete

            $Output .= $Self->{LayoutObject}->InstallerFinish(Setup => $SetupOutput, %DB);
        }
        else {
            $Output .= $Self->{LayoutObject}->Error(
                   Message => "Unknown DBAction '$DB{DBAction}'!!",
                   Comment => 'Please go back');
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # else! error!
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
                Message => "Unknown Subaction $Subaction!",
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
    }

    return $Output;
}
# --
sub SystemCall {
    my $Self = shift;
    my $CMD = shift;
    $Self->{$CMD} = 0;
    my $Output = '';
    open (INDATA, " ($CMD | sed -e 's/^/stdout: /')  2>&1 |") || return "Can't open $CMD: $!";
    while (<INDATA>) {
        $Output .= $_;
    }
    close (INDATA);
    if ($Output !~ /stdout:/ && $Output !~ /ERROR/) {
        $Self->{$CMD} = 1;
    }
    return $Output;
}
# --
sub ReConfigure {
    my $Self = shift;
    my %Param = @_;
    my $Config = '';
    open (IN, "< ../../Kernel/Config.pm") || return "Can't open ../../Kernel/Config.pm: $!";
    while (<IN>) {
        $Config .= $_;
    }
    close (IN);
    $Config =~ s/(\$Self->{DatabaseHost}.*=.*');/\$Self->{DatabaseHost} = '$Param{DatabaseHost}';/g;  
    $Config =~ s/(\$Self->{Database}.*=.*');/\$Self->{Database} = '$Param{Database}';/g;
    $Config =~ s/(\$Self->{DatabaseUser}.*=.*');/\$Self->{DatabaseUser} = '$Param{DatabaseUser}';/g;
    $Config =~ s/(\$Self->{DatabasePw}.*=.*');/\$Self->{DatabasePw} = '$Param{DatabasePw}';/g;
    $Config =~ s/(\$Self->{SecureMode}.*=.*);/\$Self->{SecureMode} = 1;/g;

    open (OUT, "> ../../Kernel/Config.pm") || return "Can't open ../../Kernel/Config.pm: $!";
    print $Config;
    close (OUT); 

    return;
}
# --

1;

