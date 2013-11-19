# --
# Kernel/Modules/Installer.pm - provides the DB installer
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: Installer.pm,v 1.86 2010-11-12 11:14:24 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::Installer;

use strict;
use warnings;

use DBI;
use Kernel::System::SysConfig;
use Kernel::System::Email;
use Kernel::System::MailAccount;

use vars qw($VERSION %INC);
$VERSION = qw($Revision: 1.86 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check env directories
    $Self->{Path} = $Self->{ConfigObject}->Get('Home');
    if ( !-d $Self->{Path} ) {
        $Self->{LayoutObject}->FatalError(
            Message => "Directory '$Self->{Path}' doesn't exist!",
            Comment => 'Configure Home in Kernel/Config.pm first!',
        );
    }
    if ( !-f "$Self->{Path}/Kernel/Config.pm" ) {
        $Self->{LayoutObject}->FatalError(
            Message => "File '$Self->{Path}/Kernel/Config.pm' not found!",
            Comment => 'Contact your Admin!',
        );
    }

    # check/get sql source files
    my $DirOfSQLFiles = $Self->{Path} . '/scripts/database';
    if ( !-d $DirOfSQLFiles ) {
        $Self->{LayoutObject}->FatalError(
            Message => "Directory '$DirOfSQLFiles' not found!",
            Comment => 'Contact your Admin!',
        );
    }
    elsif ( !-f "$DirOfSQLFiles/otrs-schema.xml" ) {
        $Self->{LayoutObject}->FatalError(
            Message => "File '$DirOfSQLFiles/otrs-schema.xml' not found!",
            Comment => 'Contact your Admin!',
        );
    }

    # check dist
    my %Dist;
    $Dist{Vendor}    = 'Unix/Linux';
    $Dist{Webserver} = 'restart your webserver';
    if ( -f '/etc/SuSE-release' ) {
        $Dist{Vendor} = 'SuSE';
        if ( exists $ENV{MOD_PERL} ) {
            eval 'require mod_perl';
            if ( defined $mod_perl::VERSION ) {
                $Dist{Webserver} = 'rcapache2 restart';
            }
        }
        else {
            $Dist{Webserver} = '';
        }
    }
    elsif ( -f '/etc/redhat-release' ) {
        $Dist{Vendor}    = 'Redhat';
        $Dist{Webserver} = 'service httpd restart';
    }
    else {
        if ( exists $ENV{MOD_PERL} ) {
            eval 'require mod_perl';
            if ( defined $mod_perl::VERSION ) {
                $Dist{Webserver} = 'Apache2 + mod_perl2';
            }
        }
    }

    # check if Apache::Reload is loaded
    for my $Module ( keys %INC ) {
        $Module =~ s/\//::/g;
        $Module =~ s/\.pm$//g;
        if ( $Module eq 'Apache2::Reload' ) {
            $Dist{Vendor}    = '';
            $Dist{Webserver} = '';
        }
    }

    # print intro form
    if ( !$Self->{Subaction} ) {
        my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Intro' );
        $Self->{LayoutObject}->Block(
            Name => 'Intro',
            Data => {}
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # print license from
    elsif ( $Self->{Subaction} eq 'License' ) {
        my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - License' );
        $Self->{LayoutObject}->Block(
            Name => 'License',
            Data => {
                Item => 'License',
                Step => '1/4',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'LicenseText',
            Data => {},
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # do database settings
    elsif ( $Self->{Subaction} eq 'Start' ) {
        if ( !-w "$Self->{Path}/Kernel/Config.pm" ) {
            my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Error' );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Kernel/Config.pm isn't writable!",
                Comment => 'If you want to use the installer, set the '
                    . 'Kernel/Config.pm writable for the webserver user! '
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # build the select field for the InstallerDBStart.dtl
        $Param{SelectDBType} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                MySQL => 'MySQL',
            },
            Name       => 'DBType',
            SelectedID => 'MySQL',
        );

        my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Create Database' );
        $Self->{LayoutObject}->Block(
            Name => 'DatabaseStart',
            Data => {
                Item         => 'Create Database',
                Step         => '2/4',
                SelectDBType => $Param{SelectDBType},
                }
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # check different requirements (AJAX)
    elsif ( $Self->{Subaction} eq 'CheckRequirements' ) {
        my $CheckMode = $Self->{ParamObject}->GetParam( Param => 'CheckMode' );
        my %Result;

        # check DB requirements
        if ( $CheckMode eq 'DB' ) {
            %Result = $Self->CheckDBRequirements();
        }

        # check mail configuration
        elsif ( $CheckMode eq 'Mail' ) {
            %Result = $Self->CheckMailConfiguration();
        }

        # no adequate check method found
        else {
            %Result = (
                Successful => 0,
                Message    => 'Unknown Check!',
                Comment    => "The check '$CheckMode' doesn't exist!"
            );
        }

        # return JSON-String because of AJAX-Mode
        my $OutputJSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # do database settings
    elsif ( $Self->{Subaction} eq 'DB' ) {

        # get and check params and connect to DB
        my %Result = $Self->ConnectToDB();
        my %DB;
        my $DBH;
        if ( ref $Result{DB} ne 'HASH' || !$Result{DBH} ) {
            $Self->{LayoutObject}->FatalError(
                Message => $Result{Message},
                Comment => $Result{Comment},
            );
        }
        else {
            %DB  = %{ $Result{DB} };
            $DBH = $Result{DBH};
        }

        if ( $DB{DBAction} eq 'Create' ) {

            my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Create Database' );

            # FIXME !!! use $DB{Type}!!!
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResult',
                Data => {
                    Item => 'Create Database',
                    Step => '2/4',
                },
            );

            # create db
            my $DBCreate = '';
            $DBCreate = " CREATE DATABASE $DB{Database} charset utf8";

            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Creating database '$DB{Database}'", },
            );
            if ( !$DBH->do($DBCreate) ) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => {},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => { Message => $DBI::errstr, },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data         => {},
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => {},
                );
            }

            # create db tables
            # read otrs-schema.mysql.sql and process stuff
            my @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-schema.mysql.sql");
            $DBH->do("use $DB{Database}");
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Creating tables 'otrs-schema.mysql.sql'", },
            );
            for (@SQL) {
                if ( !$DBH->do($_) ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemFalse',
                        Data => {},
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemMessage',
                        Data => { Message => $DBI::errstr, },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultBack',
                        Data => {},
                    );
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'Installer',
                        Data         => {},
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
                Data => {},
            );

            # initial insert
            # - read otrs-initial_insert.mysql.sql and process stuff -
            @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-initial_insert.mysql.sql");
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Inserting initial inserts 'otrs-initial_insert.mysql.sql'", },
            );
            for (@SQL) {
                if ( !$DBH->do($_) ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemFalse',
                        Data => {},
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemMessage',
                        Data => { Message => $DBI::errstr, },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultBack',
                        Data => {},
                    );
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'Installer',
                        Data         => {},
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
                Data => {},
            );

            # foreign key
            # - read otrs-schema-post.mysql.sql and process stuff -
            @SQL = $Self->ParseSQLFile("$DirOfSQLFiles/otrs-schema-post.mysql.sql");
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Foreign Keys 'otrs-schema-post.mysql.sql'", },
            );
            for (@SQL) {
                if ( !$DBH->do($_) ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemFalse',
                        Data => {},
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultItemMessage',
                        Data => { Message => $DBI::errstr, },
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'DatabaseResultBack',
                        Data => {},
                    );
                    print STDERR "ERR: $DBI::errstr - $_\n";
                    $Output .= $Self->{LayoutObject}->Output(
                        TemplateFile => 'Installer',
                        Data         => {},
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
            }
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
                Data => {},
            );

            # user add
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Creating database user '$DB{DatabaseUser}\@$DB{NewHost}'", },
            );
            if (
                !$DBH->do(
                    "GRANT ALL PRIVILEGES ON $DB{Database}.* TO $DB{DatabaseUser}\@$DB{NewHost} IDENTIFIED BY '$DB{DatabasePw}' WITH GRANT OPTION;"
                )
                )
            {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => {},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => { Message => $DBI::errstr, },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data         => {},
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => {},
                );
            }

            # Reload the grant tables of your mysql-daemon
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => 'Reloading grant tables', },
            );
            if ( !$DBH->do('FLUSH PRIVILEGES') ) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => {},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => { Message => $DBI::errstr, },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data         => {},
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => {},
                );
            }

            # ReConfigure Config.pm
            my $ReConfigure = $Self->ReConfigure(
                DatabaseHost => $DB{DatabaseHost},
                Database     => $DB{Database},
                DatabaseUser => $DB{DatabaseUser},
                DatabasePw   => $DB{DatabasePw},
            );

            if ($ReConfigure) {
                my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Error' );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Kernel/Config.pm isn't writable!",
                    Comment => 'If you want to use the installer, set the '
                        . 'Kernel/Config.pm writable for the webserver user!',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }

            # set default charset to utf8 it configured
            $Self->ReConfigure( DefaultCharset => 'utf-8', );

            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemMessage',
                Data => { Message => 'Database setup successful!', },
            );
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultNext',
                Data => {},
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data         => {},
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        elsif ( $DB{DBAction} eq 'Delete' ) {

            my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Database' );

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
                Data => { Item => "Drop database '$DB{Database}'", },
            );
            if ( !$DBH->do("DROP DATABASE $DB{Database}") ) {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => {},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => { Message => $DBI::errstr, },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'Installer',
                    Data         => {},
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => {},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => { Message => 'Database deleted.', },
                );
                $Self->{LayoutObject}->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Drop Database',
                    Step => '4/4',
                    }
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        $Self->{LayoutObject}->FatalError(
            Message => "Unknown DBAction '$DB{DBAction}'!!",
            Comment => 'Please go back',
        );
    }

    # do system settings
    elsif ( $Self->{Subaction} eq 'System' ) {

        # save config values in DB
        $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
        if ( !$Self->{DBObject} ) {
            $Self->{LayoutObject}->FatalError();
        }

        # create sys config object
        my $SysConfigObject = Kernel::System::SysConfig->new(
            %{$Self}
        );

        # take care that default config file is existing
        if ( !$SysConfigObject->WriteDefault() ) {
            return $Self->{LayoutObject}->FatalError();
        }

        # install default files
        if ( $Self->{MainObject}->Require('Kernel::System::Package') ) {
            my $PackageObject = Kernel::System::Package->new(
                %{$Self}
            );
            if ($PackageObject) {
                $PackageObject->PackageInstallDefaultFiles();
            }
        }

        my %SystemIDs;
        for ( 1 .. 99 ) {
            my $Tmp = sprintf( "%02d", $_ );
            $SystemIDs{"$Tmp"} = "$Tmp";
        }
        $Param{SystemIDString} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%SystemIDs,
            Name       => 'SystemID',
            SelectedID => $Self->{ConfigObject}->Get('SystemID'),
        );
        $Param{LanguageString} = $Self->{LayoutObject}->BuildSelection(
            Data       => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
            Name       => 'DefaultLanguage',
            HTMLQuote  => 0,
            SelectedID => $Self->{LayoutObject}->{UserLanguage},
        );
        $Param{LogModuleString} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Kernel::System::Log::SysLog' => 'Syslog',
                'Kernel::System::Log::File'   => 'File',
            },
            Name       => 'LogModule',
            HTMLQuote  => 0,
            SelectedID => $Self->{ConfigObject}->Get('LogModule'),
        );
        $Param{DefaultCharset} = 'utf-8';

        # build the select field for the InstallerDBStart.dtl
        $Param{SelectCheckMXRecord} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                1 => 'Yes',
                0 => 'No',
            },
            Name       => 'CheckMXRecord',
            SelectedID => '1',
        );

        my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - System Settings' );
        $Self->{LayoutObject}->Block(
            Name => 'System',
            Data => {
                Item => 'System Settings',
                Step => '3/4',
                %Param,
            },
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # do system settings action
    elsif ( $Self->{Subaction} eq 'ConfigureMail' ) {

        # save config values in DB
        $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
        if ( !$Self->{DBObject} ) {
            $Self->{LayoutObject}->FatalError();
        }

        # create sys config object
        my $SysConfigObject = Kernel::System::SysConfig->new(
            %{$Self}
        );

        # take care that default config file is existing
        if ( !$SysConfigObject->WriteDefault() ) {
            return $Self->{LayoutObject}->FatalError();
        }

        for my $Key (
            qw(SystemID FQDN AdminEmail Organization LogModule LogModule::LogFile
            DefaultLanguage CheckMXRecord)
            )
        {
            my $Value = $Self->{ParamObject}->GetParam( Param => $Key );

            # update config item via sys config object
            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Key,
                Value => $Value,
            );
        }

        # get mail account object and check available backends
        my $MailAccount  = Kernel::System::MailAccount->new( %{$Self} );
        my %MailBackends = $MailAccount->MailAccountBackendList();

        my $OutboundMailTypeSelection = $Self->{LayoutObject}->BuildSelection(
            Data => {
                sendmail => 'Sendmail',
                smtp     => 'SMTP',
                smtps    => 'SMTPS',
                smtptls  => 'SMTPTLS',
            },
            Name => 'OutboundMailType',
        );
        my $OutboundMailDefaultPorts = $Self->{LayoutObject}->BuildSelection(
            Class => 'Hidden',
            Data  => {
                sendmail => '25',
                smtp     => '25',
                smtps    => '465',
                smtptls  => '587',
            },
            Name => 'OutboundMailDefaultPorts',
        );

        my $InboundMailTypeSelection = $Self->{LayoutObject}->BuildSelection(
            Data => \%MailBackends,
            Name => 'InboundMailType',
        );

        my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Configure Mail' );
        $Self->{LayoutObject}->Block(
            Name => 'ConfigureMail',
            Data => {
                Item             => 'Mail Configuration',
                Step             => '3/4',
                InboundMailType  => $InboundMailTypeSelection,
                OutboundMailType => $OutboundMailTypeSelection,
                OutboundPorts    => $OutboundMailDefaultPorts,
            },
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'Finish' ) {
        $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );

        # create sys config object
        my $SysConfigObject = Kernel::System::SysConfig->new(
            %{$Self}
        );

        # take care that default config file is existing
        if ( !$SysConfigObject->WriteDefault() ) {
            return $Self->{LayoutObject}->FatalError();
        }

        # update config item via sys config object
        my $Result = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SecureMode',
            Value => 1,
        );
        if ( !$Result ) {
            $Self->{LayoutObject}->FatalError( Message => "Can't write Config file!" );
        }

        my $OTRSHandle = $ENV{SCRIPT_NAME};
        $OTRSHandle =~ s/\/(.*)\/installer\.pl/$1/;
        my $Output = $Self->{LayoutObject}->Header( Title => 'Install OTRS - Finished' );
        $Self->{LayoutObject}->Block(
            Name => 'Finish',
            Data => {
                Item       => 'Finished',
                Step       => '4/4',
                OTRSHandle => $OTRSHandle,
                %Dist,
            },
        );
        if ( $Dist{Webserver} ) {
            $Self->{LayoutObject}->Block(
                Name => 'Restart',
                Data => \%Dist,,
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # else! error!
    $Self->{LayoutObject}->FatalError(
        Message => "Unknown Subaction $Self->{Subaction}!",
        Comment => 'Please contact your administrator',
    );
}

sub ReConfigure {
    my ( $Self, %Param ) = @_;

    # perl quote
    for my $Key ( keys %Param ) {
        if ( $Param{$Key} ) {
            $Param{$Key} =~ s/'/\\'/g;
        }
    }

    # read config file
    my $ConfigFile = "$Self->{Path}/Kernel/Config.pm";
    open( my $In, '<', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    my $Config = '';
    while (<$In>) {
        if ( $_ =~ /^#/ ) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;

            # replace config with %Param
            for my $Key ( keys %Param ) {
                if ( $Param{$Key} =~ /^[0-9]+$/ && $Param{$Key} !~ /^0/ ) {
                    $NewConfig
                        =~ s/(\$Self->{("|'|)$Key("|'|)} =.+?);/\$Self->{'$Key'} = $Param{$Key};/g;
                }
                else {
                    $NewConfig
                        =~ s/(\$Self->{("|'|)$Key("|'|)} =.+?');/\$Self->{'$Key'} = '$Param{$Key}';/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close $In;

    # add new config settings
    for my $Key ( sort keys %Param ) {
        if ( $Config !~ /\$Self->{("|'|)$Key("|'|)} =.+?;/ ) {
            if ( $Param{$Key} =~ /^[0-9]+$/ && $Param{$Key} !~ /^0/ ) {
                $Config =~ s/\$DIBI\$/\$DIBI\$\n    \$Self->{'$Key'} = $Param{$Key};/g;
            }
            else {
                $Config =~ s/\$DIBI\$/\$DIBI\$\n    \$Self->{'$Key'} = '$Param{$Key}';/g;
            }
        }
    }

    # write new config file
    open( my $Out, '>', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    print $Out $Config;
    close $Out;

    return;
}

sub ParseSQLFile {
    my ( $Self, $File ) = @_;

    my @SQL;
    if ( open( my $In, '<', $File ) ) {
        my $SQLEnd    = 0;
        my $SQLSingel = '';
        while (<$In>) {
            if ( $_ !~ /^(#|--)/ ) {
                if ( $_ =~ /^(.*)(;|;\s)$/ || $_ =~ /^(\));/ ) {
                    $SQLSingel .= $1;
                    $SQLEnd = 1;
                }
                else {
                    $SQLSingel .= $_;
                }
            }
            if ($SQLEnd) {
                push @SQL, $SQLSingel;
                $SQLEnd    = 0;
                $SQLSingel = '';
            }
        }
        close $In;
    }
    else {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Can't open $File: $!" );
        }
    }
    return @SQL;
}

sub ConnectToDB {
    my ( $Self, %Param ) = @_;

    my %DB;
    $DB{User}         = $Self->{ParamObject}->GetParam( Param => 'DBUser' )            || '';
    $DB{Password}     = $Self->{ParamObject}->GetParam( Param => 'DBPassword' )        || '';
    $DB{DatabaseHost} = $Self->{ParamObject}->GetParam( Param => 'DBHost' )            || '';
    $DB{Type}         = $Self->{ParamObject}->GetParam( Param => 'DBType' )            || '';
    $DB{Database}     = $Self->{ParamObject}->GetParam( Param => 'DBName' )            || '';
    $DB{DBAction}     = $Self->{ParamObject}->GetParam( Param => 'DBAction' )          || '';
    $DB{DatabaseUser} = $Self->{ParamObject}->GetParam( Param => 'OTRSDBUser' )        || '';
    $DB{DatabasePw}   = $Self->{ParamObject}->GetParam( Param => 'OTRSDBPassword' )    || '';
    $DB{NewHost}      = $Self->{ParamObject}->GetParam( Param => 'OTRSDBConnectHost' ) || '';

    # check params
    for my $Key ( keys %DB ) {
        if ( !$DB{$Key} && $Key !~ /^(Password)$/ ) {
            return (
                Successful => 0,
                Message    => "You need '$Key'!!",
                Comment    => 'Please go back',
                DB         => undef,
                DBH        => undef,
            );
        }
    }

    # connect to database
    my $DBH = DBI->connect(
        "DBI:mysql:database=;host=$DB{DatabaseHost};", $DB{User}, $DB{Password},
    );
    if ( !$DBH ) {
        return (
            Successful => 0,
            Message    => "Can't connect to database, read comment!",
            Comment    => "$DBI::errstr",
            DB         => undef,
            DBH        => undef,
        );
    }

    return (
        Successful => 1,
        Message    => '',
        Comment    => '',
        DB         => \%DB,
        DBH        => $DBH,
    );
}

sub CheckDBRequirements {
    my ( $Self, %Param ) = @_;

    my %Result = $Self->ConnectToDB();

    # delete not necessary key/value pairs
    delete $Result{DB};
    delete $Result{DBH};

    return %Result;
}

sub CheckMailConfiguration {
    my ( $Self, %Param ) = @_;

    # first check outbound mail config
    my $OutboundMailType = $Self->{ParamObject}->GetParam( Param => 'OutboundMailType' );
    my $SMTPHost         = $Self->{ParamObject}->GetParam( Param => 'SMTPHost' );
    my $SMTPPort         = $Self->{ParamObject}->GetParam( Param => 'SMTPPort' );
    my $SMTPAuthUser     = $Self->{ParamObject}->GetParam( Param => 'SMTPAuthUser' );
    my $SMTPAuthPassword = $Self->{ParamObject}->GetParam( Param => 'SMTPAuthPassword' );

    # if chosen config option is SMTP, set some Config params
    if ( $OutboundMailType && $OutboundMailType ne 'sendmail' ) {
        $Self->{ConfigObject}->Set(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::' . uc($OutboundMailType),
        );
        $Self->{ConfigObject}->Set(
            Key   => 'SendmailModule::Host',
            Value => $SMTPHost,
        );
        $Self->{ConfigObject}->Set(
            Key   => 'SendmailModule::Port',
            Value => $SMTPPort,
        );
        if ($SMTPAuthUser) {
            $Self->{ConfigObject}->Set(
                Key   => 'SendmailModule::AuthUser',
                Value => $SMTPAuthUser,
            );
        }
        if ($SMTPAuthPassword) {
            $Self->{ConfigObject}->Set(
                Key   => 'SendmailModule::AuthPassword',
                Value => $SMTPAuthPassword,
            );
        }
    }

    # if sendmail, set config to sendmail
    else {
        $Self->{ConfigObject}->Set(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Sendmail',
        );
    }

    # if config option smtp and no smtp host given, return with error
    if ( $OutboundMailType ne 'sendmail' && !$SMTPHost ) {
        return ( Successful => 0, Message => 'No SMTP Host given!' );
    }

    # check outbound mail configuration
    $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
    my $SendObject = Kernel::System::Email->new(
        %{$Self}
    );
    my %Result = $SendObject->Check();

    my $SysConfigObject = Kernel::System::SysConfig->new(
        %{$Self}
    );

    # if smtp check was successful, write data into config
    my $SendmailModule = $Self->{ConfigObject}->Get('SendmailModule');
    if ( $Result{Successful} && $SendmailModule ne 'Kernel::System::Email::Sendmail' ) {
        my %NewConfigs = (
            'SendmailModule'       => $SendmailModule,
            'SendmailModule::Host' => $SMTPHost,
            'SendmailModule::Port' => $SMTPPort,
        );

        for my $Key ( keys %NewConfigs ) {
            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Key,
                Value => $NewConfigs{$Key},
            );
        }

        if ( $SMTPAuthUser && $SMTPAuthPassword ) {
            %NewConfigs = (
                'SendmailModule::AuthUser'     => $SMTPAuthUser,
                'SendmailModule::AuthPassword' => $SMTPAuthPassword,
            );

            for my $Key ( keys %NewConfigs ) {
                $SysConfigObject->ConfigItemUpdate(
                    Valid => 1,
                    Key   => $Key,
                    Value => $NewConfigs{$Key},
                );
            }
        }
    }

    # if sendmail check was successful, write data into config
    elsif ( $Result{Successful} && $SendmailModule eq 'Kernel::System::Email::Sendmail' ) {
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => $Self->{ConfigObject}->Get('SendmailModule'),
        );
    }

    # now check inbound mail config. if outbound config threw error, theres no need to carry on
    if ( !$Result{Successful} ) {
        return %Result;
    }

    # check inbound mail config
    my $MailAccount = Kernel::System::MailAccount->new(
        %{$Self}
    );

    for (qw(InboundUser InboundPassword InboundHost)) {
        if ( !$Self->{ParamObject}->GetParam( Param => $_ ) ) {
            return ( Successful => 0, Message => "Missing parameter: $_!" );
        }
    }

    my $InboundUser     = $Self->{ParamObject}->GetParam( Param => 'InboundUser' );
    my $InboundPassword = $Self->{ParamObject}->GetParam( Param => 'InboundPassword' );
    my $InboundHost     = $Self->{ParamObject}->GetParam( Param => 'InboundHost' );
    my $InboundMailType = $Self->{ParamObject}->GetParam( Param => 'InboundMailType' );

    %Result = $MailAccount->MailAccountCheck(
        Login    => $InboundUser,
        Password => $InboundPassword,
        Host     => $InboundHost,
        Type     => $InboundMailType,
        Timeout  => '60',
        Debug    => '0',
    );

    # if successful, add mail account to DB
    if ( $Result{Successful} ) {
        my $Id = $MailAccount->MailAccountAdd(
            Login         => $InboundUser,
            Password      => $InboundPassword,
            Host          => $InboundHost,
            Type          => $InboundMailType,
            ValidID       => 1,
            Trusted       => 0,
            DispatchingBy => 'From',
            QueueID       => 1,
            UserID        => 1,
        );

        if ( !$Id ) {
            return ( Successful => 0, Message => 'Error while adding mail account!' );
        }
    }

    return %Result;
}

1;
