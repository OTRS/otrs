# --
# Kernel/Modules/Installer.pm - provides the DB installer
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Installer.pm,v 1.33 2005-05-01 18:45:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

# Note: this is the first version to support mysql. More databases 
# later.

package Kernel::Modules::Installer;

use strict;
use DBI;

use vars qw($VERSION %INC);
$VERSION = '$Revision: 1.33 $';
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
    $Dist{Webserver} = "restart your webserver";
    if (-f "/etc/SuSE-release") {
        $Dist{Vendor} = "SuSE";
        if (exists $ENV{MOD_PERL}) {
            eval "require mod_perl";
            if (defined $mod_perl::VERSION) {
                if ($mod_perl::VERSION >= 1.99) {
                    $Dist{Webserver} = "rcapache2 restart";
                }
                else {
                    $Dist{Webserver} = "rcapache restart";
                }
            }
        }
        else {
            $Dist{Webserver} = "";
        }
    }
    elsif (-f "/etc/redhat-release") {
        $Dist{Vendor} = "Redhat";
        $Dist{Webserver} = "service httpd restart";
    }
    else {
        if (exists $ENV{MOD_PERL}) {
            eval "require mod_perl";
            if (defined $mod_perl::VERSION) {
                if ($mod_perl::VERSION >= 1.99) {
                    $Dist{Webserver} = "Apache2 + mod_perl2";
                }
                else {
                    $Dist{Webserver} = "Apache + mod_perl";
                }
            }
        }
    }
    # check if Apache::Reload is loaded
    foreach my $Module (keys %INC) {
        $Module =~ s/\//::/g;
        $Module =~ s/\.pm$//g;
        if ($Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload') {
            $Dist{Vendor} = '';
            $Dist{Webserver} = '';
        }
    }
    if ($Dist{Webserver}) {
        $Self->{LayoutObject}->Block(
            Name => 'restart',
            Data => {
                %Dist,
            },
        );
    }
    # --
    # print form
    # --
    if (!$Self->{Subaction}) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'License');
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'InstallerBody',
            Data => {
                Item => 'License',
                Step => '1/4',
                Body => $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerLicense',
                    Data => {},
                ),
            }
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
           $Output .= $Self->{LayoutObject}->Output(
               TemplateFile => 'InstallerBody',
               Data => {
                    Item => 'Create Database',
                    Step => '2/4',
                    Body => $Self->{LayoutObject}->Output(
                        TemplateFile => 'InstallerStart',
                        Data => { },
                    ),
               }
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
        # connect to database
        my $DBH = DBI->connect(
            "DBI:mysql:database=;host=$DB{DatabaseHost};",
            $DB{User},
            $DB{Password},
        );
        if (!$DBH) {
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Can't connect to database, read comment!",
                Comment => "$DBI::errstr",
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        my $SetupOutput = '';

        if ($DB{DBAction} eq 'Create') {
          # FIXME !!! use $DB{Type}!!!
            # --
            # create db
            # --
            $SetupOutput .= "<table border='0' width='100%'>";
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Createing database '$DB{Database}':</b></td><td>";
            if (!$DBH->do("CREATE DATABASE $DB{Database}")) {
                $SetupOutput .= "<font color='red'><b>false! :-(</b></font></td></tr>";
                $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerBody',
                    Data => {
                        Item => 'Create Database',
                        Step => '2/4',
                        Body => $SetupOutput,
                    }
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<font color='green'><b>done.</b></font></td></tr>";
            }
            # --
            # create db tables
            # --
            # read otrs-schema.mysql.sql and process stuff
            my @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-schema.mysql.sql");
            $DBH->do("use $DB{Database}");
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Createing tables 'otrs-schema.mysql.sql':</B></td><td>";
            foreach (@SQL) {
                if (!$DBH->do($_)) {
                    $SetupOutput .= "<font color='red'><b>false! :-(</b></font></td></tr>";
                    $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'InstallerBody',
                        Data => {
                            Item => 'Create Database',
                            Step => '2/4',
                            Body => $SetupOutput,
                        },
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $SetupOutput .= "<font color='green'><b>done.</b></font></td>";
            $SetupOutput .= "</tr>";
            # --
            # inital insert
            # - read initial_insert.sql and process stuff -
            # --
            @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/initial_insert.sql");
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Inserting Inital inserts 'initial_insert.sql':</b></td><td>";
            foreach (@SQL) {
                if (!$DBH->do($_)) {
                    $SetupOutput .= "<font color='red'><b>false! :-(</b></font></td></tr>";
                    $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'InstallerBody',
                        Data => {
                            Item => 'Create Database',
                            Step => '2/4',
                            Body => $SetupOutput,
                        },
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $SetupOutput .= "<font color='green'><b>done.</b></font></td>";
            $SetupOutput .= "</tr>";
            # --
            # foreign key
            # - read otrs-schema-post.mysql.sql and process stuff -
            # --
            @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-schema-post.mysql.sql");
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Foreign Keys 'otrs-schema-post.mysql.sql':</b></td><td>";
            foreach (@SQL) {
                if (!$DBH->do($_)) {
                    $SetupOutput .= "<font color='red'><b>false! :-(</b></font></td></tr>";
                    $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'InstallerBody',
                        Data => {
                            Item => 'Create Database',
                            Step => '2/4',
                            Body => $SetupOutput,
                        },
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $SetupOutput .= "<font color='green'><b>done.</b></font></td>";
            $SetupOutput .= "</tr>";
            # --
            # user add
            # --
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Createing database user '$DB{DatabaseUser}\@$DB{NewHost}':</b></td><td>";
            if (!$DBH->do("GRANT ALL PRIVILEGES ON $DB{Database}.* TO $DB{DatabaseUser}\@$DB{NewHost} IDENTIFIED BY '$DB{DatabasePw}' WITH GRANT OPTION")) {
                $SetupOutput .= "<font color='red'><b>false! :-(</b></font></td></tr>";
                $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerBody',
                    Data => {
                        Item => 'Create Database',
                        Step => '2/4',
                        Body => $SetupOutput,
                    }
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<font color='green'><b>done.</b></font></td>";
                $SetupOutput .= "</tr>";
            }
            # --
            # Reload the grant tables of your mysql-daemon
            # --
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Reloading grant tables:</b></td><td>";
            if (!$DBH->do("FLUSH PRIVILEGES")) {
                $SetupOutput .= "<font color='red'><b>false! :-(</b></font></td></tr>";
                $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerBody',
                    Data => {
                        Item => 'Create Database',
                        Step => '2/4',
                        Body => $SetupOutput,
                    }
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<font color='green'><b>done.</b></font></td>";
                $SetupOutput .= "</tr>";
                $SetupOutput .= "</table>";
            }
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
                $SetupOutput .= "<p> ---==> <b><font color='green'>Database setup successful!</font></b></p>";
                $SetupOutput .= "<p><a href='installer.pl?Subaction=System'>Next Step</a></p>";
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerBody',
                    Data => {
                        Item => 'Create Database',
                        Step => '2/4',
                        Body => $SetupOutput,
                    }
                );
            }

        }
        elsif ($DB{DBAction} eq 'Delete') {
          # FIXME !!! use $DB{Type}!!!
            # --
            # drop database
            # --
            $SetupOutput .= "<table border='0' width='100%'>";
            $SetupOutput .= "<tr>";
            $SetupOutput .= "<td><b>Drop database '$DB{Database}':</b></td><td>";
            if (!$DBH->do("DROP DATABASE $DB{Database}")) {
                $SetupOutput .= "<font color='red'><b>false</b>.</font></td></tr>";
                $SetupOutput .= "</table><br> ---==> $DBI::errstr";
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerBody',
                    Data => {
                        Item => 'Drop Database',
                        Step => '4/4',
                        Body => $SetupOutput,
                    }
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $SetupOutput .= "<b><font color='green'>done.</font></b></td></tr>";
                $SetupOutput .= "</table><br>";
                $SetupOutput .= " ---==> <b><font color='green'>Database deleted.</font></b>";
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'InstallerBody',
                Data => {
                    Item => 'Drop Database',
                    Step => '4/4',
                    Body => $SetupOutput,
                }
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
        my %SystemIDs = ();
        foreach (1..99) {
            my $Tmp = sprintf("%02d", $_);
            $SystemIDs{"$Tmp"} = "$Tmp";
        }
        $Param{SystemIDString} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%SystemIDs,
            Name => 'SystemID',
            SelectedID => $Self->{ConfigObject}->Get('SystemID'),
        );
        $Param{LanguageString} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
            Name => 'DefaultLanguage',
            HTMLQuote => 0,
            SelectedID => $Self->{LayoutObject}->{UserLanguage},
        );
        $Param{LogModuleString} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                'Kernel::System::Log::SysLog' => 'Syslog',
                'Kernel::System::Log::File' => 'File',
            }, 
            Name => 'LogModule',
            HTMLQuote => 0,
            SelectedID => $Self->{ConfigObject}->Get('LogModule'),
        );
# it mysql 4.1 is stable, we use this:
#        if ($Self->{LayoutObject}->{LanguageObject}->GetRecommendedCharset() eq 'utf-8') {
#            $Param{DefaultCharset} = 'utf-8';
#        }
#        else {
#            $Param{DefaultCharset} = 'iso-8859-1';
#        }
        $Param{DefaultCharset} = $Self->{ConfigObject}->Get('DefaultCharset') || 'iso-8859-1';
        $Output .= $Self->{LayoutObject}->Header(Title => 'System Settings');
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'InstallerBody',
            Data => {
                Item => 'System Settings',
                Step => '3/4',
                Body => $Self->{LayoutObject}->Output(
                    TemplateFile => 'InstallerSystem',
                    Data => \%Param,
                ),
            }
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
          Ticket::Hook Ticket::NumberGenerator DefaultCharset DefaultLanguage CheckMXRecord)) {
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
           $Output .= $Self->{LayoutObject}->Output(
               TemplateFile => 'InstallerBody',
               Data => {
                   Item => 'Finished',
                   Step => '4/4',
                   Body => $Self->{LayoutObject}->Output(
                       TemplateFile => 'InstallerFinish',
                       Data => {
                           OTRSHandle => $OTRSHandle,
                           %Dist,
                       },
                   ),
               }
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
                if ($Param{$_} =~ /^[0-9]+$/ && $Param{$_} !~ /^0/) {
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
sub ParseSQLFile {
    my $Self = shift;
    my $File = shift; 
    my @SQL = ();
    if (open(IN, "< $File")) {
        my $SQLEnd = 0;
        my $SQLSingel = '';
        while (<IN>) {
            if ($_ !~ /^(#|--)/) {
                if ($_ =~ /^(.*)(;|;\s)$/ || $_ =~ /^(\));/) {
                    $SQLSingel .= $1;
                    $SQLEnd = 1;
                }
                else {
                    $SQLSingel .= $_;
                }
            }
            if ($SQLEnd) {
                push (@SQL, $SQLSingel);
                $SQLEnd = 0;
                $SQLSingel = '';
            }
        }
        close (IN);
    }
    else {
        die "Can't open $File: $!\n";
    }
    return @SQL;
}
# --
1;
