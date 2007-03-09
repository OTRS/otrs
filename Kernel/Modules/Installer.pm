# --
# Kernel/Modules/Installer.pm - provides the DB installer
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Installer.pm,v 1.45 2007-03-09 13:15:12 martin Exp $
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
$VERSION = '$Revision: 1.45 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # check env directories
    $Self->{Path} = $Self->{ConfigObject}->Get('Home');
    if (! -d $Self->{Path}) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Directory '$Self->{Path}' doesn't exist!",
            Comment => 'Configure Home in Kernel/Config.pm first!',
        );
    }
    if (! -f "$Self->{Path}/Kernel/Config.pm") {
        return $Self->{LayoutObject}->Error(
            Message => "File '$Self->{Path}/Kernel/Config.pm' not found!",
            Comment => 'Contact your Admin!',
        );
    }
    # check/get sql source files
    my $DirOfSQLFiles = $Self->{Path}.'/scripts/database';
    if (! -d $DirOfSQLFiles) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Directory '$DirOfSQLFiles' not found!",
            Comment => 'Contact your Admin!',
        );
    }
    elsif (! -f "$DirOfSQLFiles/otrs-schema.xml") {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "File '$DirOfSQLFiles/otrs-schema.xml' not found!",
            Comment => 'Contact your Admin!',
        );
    }
    # check dist
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

    # print form
    if (!$Self->{Subaction}) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'License');
        $Self->{LayoutObject}->Block(
            Name => 'License',
            Data => {
                Item => 'License',
                Step => '1/4',
            }
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data => { },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # do database settings
    elsif ($Self->{Subaction} eq 'Start') {
        if ($Self->ReConfigure()) {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Kernel/Config.pm isn't writable!",
                Comment => 'If you want to use the installer, set the '.
                    'Kernel/Config.pm writable for the werserver user! '.
                    $Self->ReConfigure(),
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Create Database');
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseStart',
                Data => {
                    Item => 'Create Database',
                    Step => '2/4',
                }
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data => { },
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # do database settings
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
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "You need '$_'!!",
                    Comment => 'Please go back',
                );
            }
        }
        # connect to database
        my $DBH = DBI->connect(
            "DBI:mysql:database=;host=$DB{DatabaseHost};",
            $DB{User},
            $DB{Password},
        );
        if (!$DBH) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Can't connect to database, read comment!",
                Comment => "$DBI::errstr",
            );
        }

        if ($DB{DBAction} eq 'Create') {
            # FIXME !!! use $DB{Type}!!!
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResult',
                Data => {
                    Item => 'Create Database',
                    Step => '2/4',
                },
            );

            # create db
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Creating database '$DB{Database}'",
                },
            );
            if (!$DBH->do("CREATE DATABASE $DB{Database}")) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => { },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => $DBI::errstr,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => { },
                );
            }

            # create db tables
            # read otrs-schema.mysql.sql and process stuff
            my @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-schema.mysql.sql");
            $DBH->do("use $DB{Database}");
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Creating tables 'otrs-schema.mysql.sql'",
                },
            );
            foreach (@SQL) {
                if (!$DBH->do($_)) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemFalse',
                        Data => { },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemMessage',
                        Data => {
                            Message => $DBI::errstr,
                        },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultBack',
                        Data => { },
                    );
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'Installer',
                        Data => { },
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
                Data => { },
            );

            # initial insert
            # - read otrs-initial_insert.mysql.sql and process stuff -
            @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-initial_insert.mysql.sql");
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Inserting Inital inserts 'otrs-initial_insert.mysql.sql'",
                },
            );
            foreach (@SQL) {
                if (!$DBH->do($_)) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemFalse',
                        Data => { },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemMessage',
                        Data => {
                            Message => $DBI::errstr,
                        },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultBack',
                        Data => { },
                    );
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'Installer',
                        Data => { },
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
                Data => { },
            );

            # foreign key
            # - read otrs-schema-post.mysql.sql and process stuff -
            @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-schema-post.mysql.sql");
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Foreign Keys 'otrs-schema-post.mysql.sql'",
                },
            );
            foreach (@SQL) {
                if (!$DBH->do($_)) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemFalse',
                        Data => { },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemMessage',
                        Data => {
                            Message => $DBI::errstr,
                        },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultBack',
                        Data => { },
                    );
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'Installer',
                        Data => { },
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
                Data => { },
            );

            # user add
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Creating database user '$DB{DatabaseUser}\@$DB{NewHost}'",
                },
            );
            if (!$DBH->do("GRANT ALL PRIVILEGES ON $DB{Database}.* TO $DB{DatabaseUser}\@$DB{NewHost} IDENTIFIED BY '$DB{DatabasePw}' WITH GRANT OPTION;")) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => { },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => $DBI::errstr,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => { },
                );
            }

            # Reload the grant tables of your mysql-daemon
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Reloading grant tables",
                },
            );
            if (!$DBH->do("FLUSH PRIVILEGES")) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => { },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => $DBI::errstr,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => { },
                );
            }

            # ReConfigure Config.pm
            if ($Self->ReConfigure(
                DatabaseHost => $DB{DatabaseHost},
                Database => $DB{Database},
                DatabaseUser => $DB{DatabaseUser},
                DatabasePw => $DB{DatabasePw},
            )) {
                $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Kernel/Config.pm isn't writable!",
                    Comment => 'If you want to use the installer, set the '.
                        'Kernel/Config.pm writable for the webserver user!',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => "Database setup successful!",
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultNext',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data => { },
                );
            }
        }
        elsif ($DB{DBAction} eq 'Delete') {
            # drop database
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResult',
                Data => {
                    Item => 'Database',
                    Step => '2/4',
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => {
                    Item => "Drop database '$DB{Database}'",
                },
            );
            if (!$DBH->do("DROP DATABASE $DB{Database}")) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => { },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => $DBI::errstr,
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data => { },
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => { },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => "Database deleted.",
                    },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => { },
                );
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data => {
                    Item => 'Drop Database',
                    Step => '4/4',
                }
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Unknown DBAction '$DB{DBAction}'!!",
                Comment => 'Please go back',
            );
        }
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # do system settings
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
        $Self->{LayoutObject}->Block(
            Name => 'System',
            Data => {
                Item => 'System Settings',
                Step => '3/4',
                %Param,
            }
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data => { },
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }

    # do system settings action
    elsif ($Self->{Subaction} eq 'Finish') {

        # ReConfigure Config.pm
        my %Config = ();
        foreach (qw(SystemID FQDN AdminEmail Organization LogModule LogModule::LogFile
            DefaultCharset DefaultLanguage CheckMXRecord)
        ) {
            my $Value = $Self->{ParamObject}->GetParam(Param => $_);
            $Config{$_} = defined $Value ? $Value : '';
        }
        if ($Self->ReConfigure(
            %Config,
            SecureMode => 1,
        )) {
            $Self->{LayoutObject}->FatalError(
                Message => "Can't write Kernel/Config.pm!",
            );
        }
        else {
#           my $SetPermission = $ENV{SCRIPT_FILENAME} || '/opt/otrs/bin/SetPermissions.sh';
#           $SetPermission =~ s/(.+?)\/cgi-bin\/installer.pl/$1\/SetPermissions.sh/g;
#           my $BaseDir = $SetPermission;
#           $BaseDir =~ s/(.*\/)bin\/SetPermissions.sh/$1/;
            my $OTRSHandle = $ENV{SCRIPT_NAME};
            $OTRSHandle =~ s/\/(.*)\/installer\.pl/$1/;
            $Output .= $Self->{LayoutObject}->Header(Title => 'Finished');
            $Self->{LayoutObject}->Block(
                Name => 'Finish',
                Data => {
                    Item => 'Finished',
                    Step => '4/4',
                    OTRSHandle => $OTRSHandle,
                    %Dist,
                },
            );
            if ($Dist{Webserver}) {
                $Self->{LayoutObject}->Block(
                    Name => 'Restart',
                    Data => {
                        %Dist,
                    },
                );
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data => { }
            );
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }

    # else! error!
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Unknown Subaction $Self->{Subaction}!",
            Comment => 'Please contact your admin',
        );
    }

    return $Output;
}

sub ReConfigure {
    my $Self = shift;
    my %Param = @_;
    my $Config = '';

    # perl quote
    foreach (keys %Param) {
        if ($Param{$_}) {
            $Param{$_} =~ s/'/\\'/g;
        }
    }

    # read config file
    open (IN, "< $Self->{Path}/Kernel/Config.pm") ||
        return "Can't open $Self->{Path}/Kernel/Config.pm: $!";
    while (<IN>) {
        if ($_ =~ /^#/) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;
            # replace config with %Param
            foreach (keys %Param) {
                if ($Param{$_} =~ /^[0-9]+$/ && $Param{$_} !~ /^0/) {
                    $NewConfig =~ s/(\$Self->{$_} =.+?);/\$Self->{'$_'} = $Param{$_};/g;
                }
                else {
                    $NewConfig =~ s/(\$Self->{$_} =.+?');/\$Self->{'$_'} = '$Param{$_}';/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close (IN);
    # add new config settings
    foreach (sort keys %Param) {
        if ($Config !~ /\$Self->{$_} =.+?;/ && $Config !~ /\$Self->{'$_'} =.+?;/) {
            if ($Param{$_} =~ /^[0-9]+$/ && $Param{$_} !~ /^0/) {
                $Config =~ s/\$DIBI\$/\$DIBI\$\n    \$Self->{'$_'} = $Param{$_};/g;
            }
            else {
                $Config =~ s/\$DIBI\$/\$DIBI\$\n    \$Self->{'$_'} = '$Param{$_}';/g;
            }
        }
    }
    # write new config file
    open (OUT, "> $Self->{Path}/Kernel/Config.pm") ||
        return "Can't open $Self->{Path}/Kernel/Config.pm: $!";
    print OUT $Config;
    close (OUT);

    return;
}

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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Can't open $File: $!");
        }
    }
    return @SQL;
}

1;
