# --
# Kernel/Modules/Installer.pm - provides the DB installer
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Installer.pm,v 1.24 2003-04-13 22:24:30 martin Exp $
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
$VERSION = '$Revision: 1.24 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    # find fs dir (because of mod_perl2)
    $Self->{Path} = $ENV{SCRIPT_FILENAME};
    $Self->{Path} =~ s/^(.*\/).+?$/$1/;

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # get sql source
    # --
    my $DirOfSQLFiles = $Self->{Path}.'../../scripts/database';
    if (! -d $DirOfSQLFiles) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
               Message => "Directory '$DirOfSQLFiles' not found!",
               Comment => 'Contact your Admin!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    } 
    elsif (! -f "$DirOfSQLFiles/otrs-schema.xml") {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
               Message => "File '$DirOfSQLFiles/otrs-schema.xml' not found!",
               Comment => 'Contact your Admin!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    if (! -f "$Self->{Path}../../Kernel/Config.pm") {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
               Message => "File '$Self->{Path}../../Kernel/Config.pm' not found!",
               Comment => 'Contact your Admin!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check dist
    # --
    my %Dist = ();
    $Dist{Vendor} = "Unix/Linux";
    $Dist{Webserver} = "no webserver detected, restart your webserver";
    if (-f "/etc/SuSE-release") {
        $Dist{Vendor} = "SuSE";
        $Dist{Webserver} = "rcapache restart";
    } 
    if (-f "/etc/redhat-release") {
        $Dist{Vendor} = "Redhat";
        $Dist{Webserver} = "service httpd restart";
    } 
    
    # --
    # print form
    # --
    if (!$Self->{Subaction}) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'License');
        $Output .= $Self->{LayoutObject}->InstallerBody(
            Item => 'License',
            Step => '1/4',
            Body => $Self->{LayoutObject}->Output(
                TemplateFile => 'InstallerLicense', 
                Data => {},
            ),
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # do dem settings
    # --
    elsif ($Self->{Subaction} eq 'Start') {
        if ($Self->ReConfigure()) {
           $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
           $Output .= $Self->{LayoutObject}->Warning(
               Message => "Kernel/Config.pm isn't writable!",
               Comment => 'If you want to use the installer, set the '.
                 'Kernel/Config.pm writable for the werserver user!',
           );
           $Output .= $Self->{LayoutObject}->Footer();
        }
        else { 
           $Output .= $Self->{LayoutObject}->Header(Title => 'Create Database');
           $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $Self->{LayoutObject}->Output(
                        TemplateFile => 'InstallerStart',
                        Data => { },
                    ),
           );
           $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # do dem settings
    # --
    elsif ($Self->{Subaction} eq 'DB') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Installer');
        # get params
        my %DB = ();
        $DB{User} = $Self->{ParamObject}->GetParam(Param => 'DBUser') || '';
        $DB{Password} = $Self->{ParamObject}->GetParam(Param => 'DBPassword') || '';
        $DB{DatabaseHost} = $Self->{ParamObject}->GetParam(Param => 'DBHost') || '';
        $DB{Type} = $Self->{ParamObject}->GetParam(Param => 'DBType') || '';
        $DB{Database} = $Self->{ParamObject}->GetParam(Param => 'DBName') || ''; 
        $DB{DBAction} = $Self->{ParamObject}->GetParam(Param => 'DBAction') || '';
        $DB{DatabaseUser} = $Self->{ParamObject}->GetParam(Param => 'OTRSDBUser') || '';
        $DB{DatabasePw} = $Self->{ParamObject}->GetParam(Param => 'OTRSDBPassword') || '';
        $DB{NewHost} = $Self->{ParamObject}->GetParam(Param => 'OTRSDBConnectHost') || '';
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
        $MYCMD .= " -p$DB{Password} " if ($DB{Password});
        $MYCMD .= " -h $DB{DatabaseHost}  ";

        if ($DB{DBAction} eq 'Create') {
          # FIXME !!! use $DB{Type}!!!
            # --
            # create db
            # --
            my $CMD = $MYCMD . " -e 'create database $DB{Database}'";
            $SetupOutput .= "<table border='0' width='100%'>";
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td colspan=\"2\"><b>Create database CMD:</b></td></tr>";

            $SetupOutput .= "<tr><td>$CMD</td>";
            my $CMDReturn = $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "<td><font color='red'><b>false! :-(</b></font></td>";
                $SetupOutput .= "</table>";
                $SetupOutput .= "$CMDReturn";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $SetupOutput,
                ); 
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<td><font color='green'><b>done.</b></font></td>";
            }
            $SetupOutput .= "</tr>";
            # --
            # create db tables
            # --
            $CMD = $MYCMD . " $DB{Database} < $DirOfSQLFiles/otrs-schema.mysql.sql";
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td colspan=\"2\"><b>Create tables CMD:</B></td></tr>";
            $SetupOutput .= "<tr><td>$CMD</td>";
            $CMDReturn = $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "<td><font color='red'><b>false! :-(</b></font></td>";
                $SetupOutput .= "</table>";
                $SetupOutput .= "$CMDReturn";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $SetupOutput,
                ); 
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<td><font color='green'><b>done.</b></font></td>";
            } 
            $SetupOutput .= "</tr>";
            # --
            # inital insert
            # --
            $CMD = $MYCMD . " $DB{Database} < $DirOfSQLFiles/initial_insert.sql";

            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td colspan=\"2\"><b>Inital inserts CMD:</b></td></tr>";
            $SetupOutput .= "<tr><td>$CMD </td>";
            $CMDReturn = $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "<td><font color='red'><b>false! :-(</b></font></td>";
                $SetupOutput .= "</table>";
                $SetupOutput .= "$CMDReturn";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $SetupOutput,
                ); 
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<td><font color='green'><b>done.</b></font></td>";
            }
            $SetupOutput .= "</tr>";
            # --
            # user add
            # --
            $CMD = $MYCMD . " -e \"GRANT ALL PRIVILEGES ON $DB{Database}.* TO ".
                  " $DB{DatabaseUser}\@$DB{NewHost} IDENTIFIED BY '$DB{DatabasePw}' WITH GRANT OPTION\" ";
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td colspan=\"2\"><b>Create db user CMD:</b></td></tr>";
            $SetupOutput .= "<tr><td>$CMD </td>";
            $CMDReturn = $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "<td><font color='red'><b>false! :-(</b></font></td>";
                $SetupOutput .= "</table>";
                $SetupOutput .= "$CMDReturn";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $SetupOutput,
                ); 
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<td><font color='green'><b>done.</b></font></td>";
            }
            $SetupOutput .= "</tr>";
            # --
            # Reload the grant tables of your mysql-daemon
            # --
            my $MYReloadCMD = "mysqladmin -u $DB{User} ";
            $MYReloadCMD .= " -p$DB{Password} " if ($DB{Password});
            $MYReloadCMD .= " -h $DB{DatabaseHost}  ";
            $MYReloadCMD .= " reload ";

            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td colspan=\"2\"><b>Reload the grant tables CMD:</b></td></tr>";
            $SetupOutput .= "<tr><td>$MYReloadCMD </td>";
            $CMDReturn = $Self->SystemCall($MYReloadCMD);
            if (!$Self->{$MYReloadCMD}) {
                $SetupOutput .= "<td><font color='red'><b>false! :-(</b></font></td>";
                $SetupOutput .= "</table>";
                $SetupOutput .= "$CMDReturn";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $SetupOutput,
                ); 
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<td><font color='green'><b>done.</b></font></td>";
            }
            $SetupOutput .= "</tr>";
            $SetupOutput .= "</table>";

            # --
            # ReConfigure Config.pm
            # --
            if ($Self->ReConfigure(
                DatabaseHost => $DB{DatabaseHost},
                Database => $DB{Database},
                DatabaseUser => $DB{DatabaseUser},
                DatabasePw => $DB{DatabasePw},
            )) {
                $SetupOutput .= "<u>Can't write Config.pm!!! Fatal Error!:</u><br>";
                $Output .= $SetupOutput;
            }
            else {
                $SetupOutput .= "<p><b><font color='green'>Database setup successful!</font></b></p>";
                $SetupOutput .= "<p><a href='installer.pl?Subaction=System'>Next Step</a></p>";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $SetupOutput,
                ); 
            }

        }
        elsif ($DB{DBAction} eq 'Delete') {
          # FIXME !!! use $DB{Type}!!!
            # --
            # drop database
            # --
            my $CMD .=  $MYCMD . " -e 'drop database $DB{Database}'"; 
            $SetupOutput .= "<b>Drop database CMD:</b> $CMD ";
            $SetupOutput .= $Self->SystemCall($CMD);
            if (!$Self->{$CMD}) {
                $SetupOutput .= "<font color='red'><b>false</b>.</font>";
                $Output .= $Self->{LayoutObject}->InstallerBody(
                    Item => 'Drop Database',
                    Step => '4/4',
                    Body => $SetupOutput,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<b>done.</b><br><br> <b>Database deleted.</b>";
            }
           $Output .= $Self->{LayoutObject}->InstallerBody(
               Item => 'Drop Database',
               Step => '4/4',
               Body => $SetupOutput,
           );
        }
        else {
            $Output .= $Self->{LayoutObject}->Error(
                   Message => "Unknown DBAction '$DB{DBAction}'!!",
                   Comment => 'Please go back');
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # --
    # do system settings
    # --
    elsif ($Self->{Subaction} eq 'System') {
           $Output .= $Self->{LayoutObject}->Header(Title => 'System Settings');
           $Output .= $Self->{LayoutObject}->InstallerBody(
               Item => 'System Settings',
               Step => '3/4',
               Body => $Self->{LayoutObject}->InstallerSystem(),
           );
           $Output .= $Self->{LayoutObject}->Footer();
    }
    # --
    # do system settings action
    # --
    elsif ($Self->{Subaction} eq 'Finish') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Finished');
        # --
        # ReConfigure Config.pm
        # --
        my %Config = ();
        foreach (qw(SystemID FQDN AdminEmail Organization LogModule LogModule::LogFile 
          TicketHook TicketNumberGenerator DefaultCharset DefaultLanguage CheckMXRecord)) {
            my $Value = $Self->{ParamObject}->GetParam(Param => $_);
            $Config{$_} = defined $Value ? $Value : ''; 
        }
        if ($Self->ReConfigure(
            %Config,
            SecureMode => 1,
        )) {
             $Output .= "<u>Can't write Config.pm - Fatal Error!</u><br>";
        }
        else {
#           my $SetPermission = $ENV{SCRIPT_FILENAME} || '/opt/otrs/bin/SetPermissions.sh';
#           $SetPermission =~ s/(.+?)\/cgi-bin\/installer.pl/$1\/SetPermissions.sh/g;
#           my $BaseDir = $SetPermission;
#           $BaseDir =~ s/(.*\/)bin\/SetPermissions.sh/$1/;
           my $OTRSHandle = $ENV{SCRIPT_NAME};
           $OTRSHandle =~ s/\/(.*)\/installer\.pl/$1/;
           $Output .= $Self->{LayoutObject}->InstallerBody(
               Item => 'Finished',
               Step => '4/4',
               Body => $Self->{LayoutObject}->Output(
                   TemplateFile => 'InstallerFinish',
                   Data => {
                       OTRSHandle => $OTRSHandle,
                       %Dist,
                   },
               ),
           );
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # --
    # else! error!
    # --
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
                Message => "Unknown Subaction $Self->{Subaction}!",
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
    # --
    # perl quote
    # --
    foreach (keys %Param) {
        if ($Param{$_}) {
            $Param{$_} =~ s/'/\\'/g;
        }
    }
    # --
    # read config file
    # --
    open (IN, "< $Self->{Path}/../../Kernel/Config.pm") || 
        return "Can't open $Self->{Path}/../../Kernel/Config.pm: $!";
    while (<IN>) {
        if ($_ =~ /^#/) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;
            # --
            # replace config with %Param
            # --
            foreach (keys %Param) {
                if ($Param{$_} =~ /^[0-9]+$/) {
                    $NewConfig =~ s/(\$Self->{$_} =.+?);/\$Self->{$_} = $Param{$_};/g;  
                }
                else {
                    $NewConfig =~ s/(\$Self->{$_} =.+?');/\$Self->{$_} = '$Param{$_}';/g;  
                }
            }
            $Config .= $NewConfig;
        }
    }
    close (IN);
    # add new config settings
    foreach (sort keys %Param) {
        if ($Config !~ /\$Self->{$_} =.+?;/) {
            if ($Param{$_} =~ /^[0-9]+$/) {
                $Config =~ s/\$DIBI\$/\$DIBI\$\n    \$Self->{$_} = $Param{$_};/g;  
            }
            else {
                $Config =~ s/\$DIBI\$/\$DIBI\$\n    \$Self->{$_} = '$Param{$_}';/g;  
            }
        }
    }
    # --
    # write new config file
    # --
    open (OUT, "> $Self->{Path}/../../Kernel/Config.pm") || 
        return "Can't open $Self->{Path}/../../Kernel/Config.pm: $!";
    print OUT $Config;
    close (OUT); 

    return;
}
# --

1;
