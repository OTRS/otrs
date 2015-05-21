# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::Installer;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)
## nofilter(TidyAll::Plugin::OTRS::Perl::Print)

use strict;
use warnings;

use DBI;
use Net::Domain qw(hostfqdn);

our $ObjectManagerDisabled = 1;

use vars qw(%INC);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check env directories
    $Self->{Path} = $ConfigObject->Get('Home');
    if ( !-d $Self->{Path} ) {
        $LayoutObject->FatalError(
            Message => "Directory '$Self->{Path}' doesn't exist!",
            Comment => 'Configure Home in Kernel/Config.pm first!',
        );
    }
    if ( !-f "$Self->{Path}/Kernel/Config.pm" ) {
        $LayoutObject->FatalError(
            Message => "File '$Self->{Path}/Kernel/Config.pm' not found!",
            Comment => 'Contact your Admin!',
        );
    }

    # check/get sql schema dir
    my $DirOfSQLFiles = $Self->{Path} . '/scripts/database';
    if ( !-d $DirOfSQLFiles ) {
        $LayoutObject->FatalError(
            Message => "Directory '$DirOfSQLFiles' not found!",
            Comment => 'Contact your Admin!',
        );
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # read installer.json if it exists
    # it contains options set by Windows Installer
    if ( -f "$Self->{Path}/var/tmp/installer.json" ) {
        my $JSONString = $MainObject->FileRead(
            Location => "$Self->{Path}/var/tmp/installer.json",
        );
        $Self->{Options} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $$JSONString,
        );
    }

    # check if License option needs to be skipped
    if ( $Self->{Subaction} eq 'License' && $Self->{Options}->{SkipLicense} ) {
        $Self->{Subaction} = 'Start';
    }

    # check if Database option needs to be skipped
    if ( $Self->{Subaction} eq 'Start' && $Self->{Options}->{DBType} ) {
        $Self->{Subaction} = 'DBCreate';
    }

    $Self->{Subaction} = 'Intro' if !$Self->{Subaction};

    # build steps
    my @Steps = qw(License Database General Finish);
    my $StepCounter;

    # no license step needed if defined in .json file
    shift @Steps if $Self->{Options}->{SkipLicense};

    # build header - but only if we're not in AJAX mode
    if ( $Self->{Subaction} ne 'CheckRequirements' ) {
        $LayoutObject->Block(
            Name => 'Steps',
            Data => {
                Steps => scalar @Steps,
            },
        );

        # mapping of subactions to steps
        my %Steps = (
            Intro         => 'Intro',
            License       => 'License',
            Start         => 'Database',
            DB            => 'Database',
            DBCreate      => 'Database',
            ConfigureMail => 'General',
            System        => 'General',
            Finish        => 'Finish',
        );

        # on the intro screen no steps should be highlighted
        my $Highlight = ( $Self->{Subaction} eq 'Intro' ) ? '' : 'Highlighted NoLink';

        my $Counter;

        for my $Step (@Steps) {
            $Counter++;

            # is the current step active?
            my $Active = ( $Steps{ $Self->{Subaction} } eq $Step ) ? 'Active' : '';
            $LayoutObject->Block(
                Name => 'Step' . $Step,
                Data => {
                    Step      => $Counter,
                    Highlight => $Highlight,
                    Active    => $Active,
                },
            );

            # if this is the actual step
            if ( $Steps{ $Self->{Subaction} } eq $Step ) {

                # no more highlights from now on
                $Highlight = '',

                    # step calculation: 2/5 etc.
                    $StepCounter = $Counter . "/" . scalar @Steps;
            }
        }
    }

    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # print intro form
    my $Title = $LayoutObject->{LanguageObject}->Translate('Install OTRS');
    if ( $Self->{Subaction} eq 'Intro' ) {
        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('Intro')
            );
        $LayoutObject->Block(
            Name => 'Intro',
            Data => {}
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # print license from
    elsif ( $Self->{Subaction} eq 'License' ) {
        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('License')
            );
        $LayoutObject->Block(
            Name => 'License',
            Data => {
                Item => 'License',
                Step => $StepCounter,
            },
        );
        $LayoutObject->Block(
            Name => 'LicenseText',
            Data => {},
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # database selection screen
    elsif ( $Self->{Subaction} eq 'Start' ) {
        if ( !-w "$Self->{Path}/Kernel/Config.pm" ) {
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate('Error')
                );
            $Output .= $LayoutObject->Warning(
                Message => "Kernel/Config.pm isn't writable!",
                Comment => 'If you want to use the installer, set the '
                    . 'Kernel/Config.pm writable for the webserver user! '
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        my %Databases = (
            mysql      => "MySQL",
            postgresql => "PostgreSQL",
            mssql      => "SQL Server (Microsoft)",
            oracle     => "Oracle",
        );

        # OTRS can only run on SQL Server if OTRS is on Windows as well
        if ( $^O ne 'MSWin32' ) {
            delete $Databases{mssql};
        }

        # build the select field for the InstallerDBStart.dtl
        $Param{SelectDBType} = $LayoutObject->BuildSelection(
            Data       => \%Databases,
            Name       => 'DBType',
            Size       => scalar keys %Databases,
            SelectedID => 'mysql',
        );

        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('Database Selection')
            );
        $LayoutObject->Block(
            Name => 'DatabaseStart',
            Data => {
                Item         => 'Database Selection',
                Step         => $StepCounter,
                SelectDBType => $Param{SelectDBType},
                }
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # check different requirements (AJAX)
    elsif ( $Self->{Subaction} eq 'CheckRequirements' ) {
        my $CheckMode = $ParamObject->GetParam( Param => 'CheckMode' );
        my %Result;

        # check DB requirements
        if ( $CheckMode eq 'DB' ) {
            my %DBCredentials;
            for my $Param (
                qw(DBUser DBPassword DBHost DBType DBPort DBSID DBName InstallType OTRSDBUser OTRSDBPassword)
                )
            {
                $DBCredentials{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
            }

            %Result = $Self->CheckDBRequirements(
                %DBCredentials,
            );
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
        my $OutputJSON = $LayoutObject->JSONEncode( Data => \%Result );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset='
                . $LayoutObject->{Charset},
            Content => $OutputJSON,
            Type    => 'inline',
            NoCache => 1,
        );
    }

    elsif ( $Self->{Subaction} eq 'DB' ) {

        my $DBType        = $ParamObject->GetParam( Param => 'DBType' );
        my $DBInstallType = $ParamObject->GetParam( Param => 'DBInstallType' );

        # use MainObject to generate a password
        my $GeneratedPassword = $MainObject->GenerateRandomString();

        if ( $DBType eq 'mysql' ) {
            my $PasswordExplanation = $DBInstallType eq 'CreateDB'
                ? $LayoutObject->{LanguageObject}->Translate(
                'If you have set a root password for your database, it must be entered here. If not, leave this field empty.',
                )
                : $LayoutObject->{LanguageObject}->Translate('Enter the password for the database user.');
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate('Database') . ' MySQL'
                );
            $LayoutObject->Block(
                Name => 'DatabaseMySQL',
                Data => {
                    Item                => 'Configure MySQL',
                    Step                => $StepCounter,
                    InstallType         => $DBInstallType,
                    DefaultDBUser       => $DBInstallType eq 'CreateDB' ? 'root' : 'otrs',
                    PasswordExplanation => $PasswordExplanation,
                },
            );
            if ( $DBInstallType eq 'CreateDB' ) {
                $LayoutObject->Block(
                    Name => 'DatabaseMySQLCreate',
                    Data => {
                        Password => $GeneratedPassword,
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabaseMySQLUseExisting',
                );
            }

            $Output .= $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Configure MySQL',
                    Step => $StepCounter,
                    }
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
        elsif ( $DBType eq 'mssql' ) {
            my $PasswordExplanation = $DBInstallType eq 'CreateDB'
                ? $LayoutObject->{LanguageObject}->Get('Enter the password for the administrative database user.')
                : $LayoutObject->{LanguageObject}->Get('Enter the password for the database user.');
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate('Database')
                    . ' Microsoft SQL Server'
                );
            $LayoutObject->Block(
                Name => 'DatabaseMSSQL',
                Data => {
                    Item          => 'Database',
                    Step          => $StepCounter,
                    InstallType   => $DBInstallType,
                    DefaultDBUser => $DBInstallType eq 'CreateDB' ? 'sa' : 'otrs',
                },
            );

            if ( $DBInstallType eq 'CreateDB' ) {
                $LayoutObject->Block(
                    Name => 'DatabaseMSSQLCreate',
                    Data => {
                        Password => $GeneratedPassword,
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabaseMSSQLUseExisting',
                );
            }

            $Output .= $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item        => 'Configure Microsoft SQL Server',
                    Step        => $StepCounter,
                    InstallType => $DBInstallType,
                    }
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
        elsif ( $DBType eq 'postgresql' ) {
            my $PasswordExplanation = $DBInstallType eq 'CreateDB'
                ? $LayoutObject->{LanguageObject}->Get('Enter the password for the administrative database user.')
                : $LayoutObject->{LanguageObject}->Get('Enter the password for the database user.');
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate('Database') . ' PostgreSQL'
                );
            $LayoutObject->Block(
                Name => 'DatabasePostgreSQL',
                Data => {
                    Item          => 'Database',
                    Step          => $StepCounter,
                    InstallType   => $DBInstallType,
                    DefaultDBUser => $DBInstallType eq 'CreateDB' ? 'postgres' : 'otrs',
                },
            );
            if ( $DBInstallType eq 'CreateDB' ) {
                $LayoutObject->Block(
                    Name => 'DatabasePostgreSQLCreate',
                    Data => {
                        Password => $GeneratedPassword,
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabasePostgreSQLUseExisting',
                );
            }

            $Output .= $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Configure PostgreSQL',
                    Step => $StepCounter,
                    }
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        elsif ( $DBType eq 'oracle' ) {
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate('Database') . ' Oracle'
                );
            $LayoutObject->Block(
                Name => 'DatabaseOracle',
                Data => {
                    Item => 'Database',
                    Step => $StepCounter,
                },
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Configure Oracle',
                    Step => $StepCounter,
                    }
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        else {
            $LayoutObject->FatalError(
                Message => "Unknown database type '$DBType'.",
                Comment => 'Please go back',
            );
        }
    }

    # do database settings
    elsif ( $Self->{Subaction} eq 'DBCreate' ) {

        my %DBCredentials;
        for my $Param (
            qw(DBUser DBPassword DBHost DBType DBName DBSID DBPort InstallType OTRSDBUser OTRSDBPassword)
            )
        {
            $DBCredentials{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }
        %DBCredentials = %{ $Self->{Options} } if $Self->{Options}->{DBType};

        # get and check params and connect to DB
        my %Result = $Self->ConnectToDB(%DBCredentials);

        my %DB;
        my $DBH;
        if ( ref $Result{DB} ne 'HASH' || !$Result{DBH} ) {
            $LayoutObject->FatalError(
                Message => $Result{Message},
                Comment => $Result{Comment},
            );
        }
        else {
            %DB  = %{ $Result{DB} };
            $DBH = $Result{DBH};
        }

        my $Output = $LayoutObject->Header(
            Title => $Title . '-'
                . $LayoutObject->{LanguageObject}->Translate(
                'Create Database'
                )
        );

        $LayoutObject->Block(
            Name => 'DatabaseResult',
            Data => {
                Item => 'Create Database',
                Step => $StepCounter,
            },
        );

        my @Statements;

        # create database, add user
        if ( $DB{DBType} eq 'mysql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {

                # determine current host for MySQL account
                my $ConnectionID;
                my $StatementHandle = $DBH->prepare("select connection_id()");
                $StatementHandle->execute();
                while ( my @Row = $StatementHandle->fetchrow_array() ) {
                    $ConnectionID = $Row[0];
                }

                $StatementHandle = $DBH->prepare("show processlist");
                $StatementHandle->execute();
                PROCESSLIST:
                while ( my @Row = $StatementHandle->fetchrow_array() ) {
                    if ( $Row[0] eq $ConnectionID ) {
                        $DB{Host} = $Row[2];
                        last PROCESSLIST;
                    }
                }

                # strip off port, i.e. 'localhost:14962' should become 'localhost'
                $DB{Host} =~ s{:\d*\z}{}xms;

                @Statements = (
                    "CREATE DATABASE `$DB{DBName}` charset utf8",
                    "GRANT ALL PRIVILEGES ON `$DB{DBName}`.* TO `$DB{OTRSDBUser}`\@`$DB{Host}` IDENTIFIED BY '$DB{OTRSDBPassword}' WITH GRANT OPTION;",
                    "FLUSH PRIVILEGES",
                );
            }

            # set DSN for Config.pm
            $DB{ConfigDSN} = 'DBI:mysql:database=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:mysql:database=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'mssql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {
                @Statements = (
                    "CREATE DATABASE [$DB{DBName}]",
                    "CREATE LOGIN [$DB{OTRSDBUser}] WITH PASSWORD = '$DB{OTRSDBPassword}'",
                    "USE [$DB{DBName}]",
                    "CREATE USER  [$DB{OTRSDBUser}] FOR LOGIN [$DB{OTRSDBUser}]",
                    "exec sp_addrolemember 'db_owner', '$DB{OTRSDBUser}'",
                    "exec sp_defaultdb '$DB{OTRSDBUser}', '$DB{DBName}'",
                );
            }

            # set DSN for Config.pm
            $DB{ConfigDSN} = 'DBI:ODBC:driver={SQL Server};Database=$Self->{Database};Server=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:ODBC:driver={SQL Server};Database=$DB{DBName};Server=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'postgresql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {
                @Statements = (
                    "CREATE ROLE \"$DB{OTRSDBUser}\" WITH LOGIN PASSWORD '$DB{OTRSDBPassword}'",
                    "CREATE DATABASE \"$DB{DBName}\" OWNER=\"$DB{OTRSDBUser}\" ENCODING 'utf-8'",
                );
            }

            # set DSN for Config.pm
            $DB{ConfigDSN} = 'DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:Pg:dbname=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'oracle' ) {

            # set DSN for Config.pm
            $DB{ConfigDSN} = 'DBI:Oracle://$Self->{DatabaseHost}:' . $DB{DBPort} . '/$Self->{Database}';
            $DB{DSN}       = "DBI:Oracle://$DB{DBHost}:$DB{DBPort}/$DB{DBSID}";
            $ConfigObject->Set(
                Key   => 'Database::Connect',
                Value => "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS'",
            );
        }

        # execute database statements
        for my $Statement (@Statements) {
            my @Description = split( ' ', $Statement );

            # prevent unitilialized variables
            for my $Index ( 0 .. 2 ) {
                $Description[$Index] //= '';
            }

            $LayoutObject->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "$Description[0] $Description[1] $Description[2]" },
            );
            if ( !$DBH->do($Statement) ) {
                $LayoutObject->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => {},
                );
                $LayoutObject->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => $DBI::errstr,
                    },
                );
                $LayoutObject->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'Installer',
                    Data         => {},
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => {},
                );
            }
        }

        # ReConfigure Config.pm
        my $ReConfigure;
        if ( $DB{DBType} eq 'oracle' ) {
            $ReConfigure = $Self->ReConfigure(
                DatabaseDSN  => $DB{ConfigDSN},
                DatabaseHost => $DB{DBHost},
                Database     => $DB{DBSID},
                DatabaseUser => $DB{OTRSDBUser},
                DatabasePw   => $DB{OTRSDBPassword},
            );
        }
        else {
            $ReConfigure = $Self->ReConfigure(
                DatabaseDSN  => $DB{ConfigDSN},
                DatabaseHost => $DB{DBHost},
                Database     => $DB{DBName},
                DatabaseUser => $DB{OTRSDBUser},
                DatabasePw   => $DB{OTRSDBPassword},
            );
        }

        if ($ReConfigure) {
            my $Output =
                $LayoutObject->Header(
                Title => 'Install OTRS - Error'
                );
            $Output .= $LayoutObject->Warning(
                Message => "Kernel/Config.pm isn't writable!",
                Comment => 'If you want to use the installer, set the '
                    . 'Kernel/Config.pm writable for the webserver user!',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::DB'] );

        # we need a database object to be able to parse the XML
        # connect to database using given credentials
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::DB' => {
                DatabaseDSN  => $DB{DSN},
                DatabaseUser => $DB{OTRSDBUser},
                DatabasePw   => $DB{OTRSDBPassword},
                Type         => $DB{DBType},
            },
        );
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # create database tables and insert initial values
        my @SQLPost;
        for my $SchemaFile (qw(otrs-schema otrs-initial_insert)) {
            if ( !-f "$DirOfSQLFiles/$SchemaFile.xml" ) {
                $LayoutObject->FatalError(
                    Message => "File '$DirOfSQLFiles/$SchemaFile.xml' not found!",
                    Comment => 'Contact your Admin!',
                );
            }

            $LayoutObject->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Processing $SchemaFile" },
            );

            my $XML = $MainObject->FileRead(
                Directory => $DirOfSQLFiles,
                Filename  => $SchemaFile . '.xml',
            );
            my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse(
                String => $XML,
            );

            my @SQL = $DBObject->SQLProcessor(
                Database => \@XMLArray,
            );

            # if we parsed the schema, catch post instructions
            @SQLPost = $DBObject->SQLProcessorPost() if $SchemaFile eq 'otrs-schema';

            for my $SQL (@SQL) {
                $DBObject->Do( SQL => $SQL );
            }

            $LayoutObject->Block(
                Name => 'DatabaseResultItemDone',
            );

        }

        # execute post SQL statements (indexes, constraints)

        $LayoutObject->Block(
            Name => 'DatabaseResultItem',
            Data => { Item => "Processing post statements" },
        );

        for my $SQL (@SQLPost) {
            $DBObject->Do( SQL => $SQL );
        }

        $LayoutObject->Block(
            Name => 'DatabaseResultItemDone',
        );

        # if running under PerlEx, reload the application (and thus the configuration)
        if (
            exists $ENV{'GATEWAY_INTERFACE'}
            && $ENV{'GATEWAY_INTERFACE'} eq "CGI-PerlEx"
            )
        {
            PerlEx::ReloadAll();
        }

        $LayoutObject->Block(
            Name => 'DatabaseResultSuccess',
        );
        $LayoutObject->Block(
            Name => 'DatabaseResultNext',
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # show system settings page, pre-install packages
    elsif ( $Self->{Subaction} eq 'System' ) {

        if ( !$Kernel::OM->Get('Kernel::System::DB') ) {
            $LayoutObject->FatalError();
        }

        # take care that default config file is existing
        if ( !$SysConfigObject->WriteDefault() ) {
            return $LayoutObject->FatalError();
        }

        # install default files
        if ( $MainObject->Require('Kernel::System::Package') ) {
            my $PackageObject = Kernel::System::Package->new( %{$Self} );
            if ($PackageObject) {
                $PackageObject->PackageInstallDefaultFiles();
            }
        }

        my @SystemIDs = map { sprintf "%02d", $_ } ( 0 .. 99 );

        $Param{SystemIDString} = $LayoutObject->BuildSelection(
            Data       => \@SystemIDs,
            Name       => 'SystemID',
            SelectedID => $SystemIDs[ int( rand(100) ) ],    # random system ID
        );
        $Param{LanguageString} = $LayoutObject->BuildSelection(
            Data       => $ConfigObject->Get('DefaultUsedLanguages'),
            Name       => 'DefaultLanguage',
            HTMLQuote  => 0,
            SelectedID => $LayoutObject->{UserLanguage},
        );

        # build the selection field for the MX check
        $Param{SelectCheckMXRecord} = $LayoutObject->BuildSelection(
            Data => {
                1 => 'Yes',
                0 => 'No',
            },
            Name       => 'CheckMXRecord',
            SelectedID => '1',
        );

        # read FQDN using Net::Domain and prepopulate the field
        $Param{FQDN} = hostfqdn();

        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('System Settings')
            );

        $LayoutObject->Block(
            Name => 'System',
            Data => {
                Item => 'System Settings',
                Step => $StepCounter,
                %Param,
            },
        );

        if ( !$Self->{Options}->{SkipLog} ) {
            $Param{LogModuleString} = $LayoutObject->BuildSelection(
                Data => {
                    'Kernel::System::Log::SysLog' => 'Syslog',
                    'Kernel::System::Log::File'   => 'File',
                },
                Name       => 'LogModule',
                HTMLQuote  => 0,
                SelectedID => $ConfigObject->Get('LogModule'),
            );
            $LayoutObject->Block(
                Name => 'LogModule',
                Data => \%Param,
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # do system settings action
    elsif ( $Self->{Subaction} eq 'ConfigureMail' ) {

        if ( !$Kernel::OM->Get('Kernel::System::DB') ) {
            $LayoutObject->FatalError();
        }

        # take care that default config file is existing
        if ( !$SysConfigObject->WriteDefault() ) {
            return $LayoutObject->FatalError();
        }

        for my $Key (
            qw(SystemID FQDN AdminEmail Organization LogModule LogModule::LogFile
            DefaultLanguage CheckMXRecord)
            )
        {
            my $Value = $ParamObject->GetParam( Param => $Key );

            # update config item via sys config object
            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Key,
                Value => $Value,
            );
        }

        # get mail account object and check available backends
        my $MailAccount  = $Kernel::OM->Get('Kernel::System::MailAccount');
        my %MailBackends = $MailAccount->MailAccountBackendList();

        my $OutboundMailTypeSelection = $LayoutObject->BuildSelection(
            Data => {
                sendmail => 'Sendmail',
                smtp     => 'SMTP',
                smtps    => 'SMTPS',
                smtptls  => 'SMTPTLS',
            },
            Name => 'OutboundMailType',
        );
        my $OutboundMailDefaultPorts = $LayoutObject->BuildSelection(
            Class => 'Hidden',
            Data  => {
                sendmail => '25',
                smtp     => '25',
                smtps    => '465',
                smtptls  => '587',
            },
            Name => 'OutboundMailDefaultPorts',
        );

        my $InboundMailTypeSelection = $LayoutObject->BuildSelection(
            Data => \%MailBackends,
            Name => 'InboundMailType',
        );

        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('Configure Mail')
            );
        $LayoutObject->Block(
            Name => 'ConfigureMail',
            Data => {
                Item             => 'Mail Configuration',
                Step             => $StepCounter,
                InboundMailType  => $InboundMailTypeSelection,
                OutboundMailType => $OutboundMailTypeSelection,
                OutboundPorts    => $OutboundMailDefaultPorts,
            },
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'Finish' ) {

        # make sure the default config file exists
        if ( !$SysConfigObject->WriteDefault() ) {
            return $LayoutObject->FatalError();
        }

        # update config item via sysconfig object
        my $Result = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SecureMode',
            Value => 1,
        );
        if ( !$Result ) {
            $LayoutObject->FatalError(
                Message => "Can't write Config file!"
            );
        }

        # 'rebuild' the configuration to prevent duplicate rows in ZZZAuto.pm
        $SysConfigObject->WriteDefault();

        # if running under PerlEx, reload the application (and thus the configuration)
        if (
            exists $ENV{'GATEWAY_INTERFACE'}
            && $ENV{'GATEWAY_INTERFACE'} eq "CGI-PerlEx"
            )
        {
            PerlEx::ReloadAll();
        }

        # set a generated password for the 'root@localhost' account
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $Password = $UserObject->GenerateRandomPassword( Size => 16 );
        $UserObject->SetPassword(
            UserLogin => 'root@localhost',
            PW        => $Password,
        );

        # remove installer file with preconfigured options
        if ( -f "$Self->{Path}/var/tmp/installer.json" ) {
            unlink "$Self->{Path}/var/tmp/installer.json";
        }

        # check web server - is a restart needed?
        my $Webserver;

        # only if we have mod_perl we have to restart
        if ( exists $ENV{MOD_PERL} ) {
            eval 'require mod_perl';    ## no critic
            if ( defined $mod_perl::VERSION ) {    ## no critic
                $Webserver = 'Apache2 + mod_perl';
                if ( -f '/etc/SuSE-release' ) {
                    $Webserver = 'rcapache2 restart';
                }
                elsif ( -f '/etc/redhat-release' ) {
                    $Webserver = 'service httpd restart';
                }
            }
        }

        # check if Apache::Reload is loaded
        for my $Module ( sort keys %INC ) {
            $Module =~ s/\//::/g;
            $Module =~ s/\.pm$//g;

            if ( $Module eq 'Apache2::Reload' ) {
                $Webserver = '';
            }
        }

        my $OTRSHandle = $ENV{SCRIPT_NAME};
        $OTRSHandle =~ s/\/(.*)\/installer\.pl/$1/;
        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('Finished')
            );
        $LayoutObject->Block(
            Name => 'Finish',
            Data => {
                Item       => 'Finished',
                Step       => $StepCounter,
                Host       => $ENV{HTTP_HOST} || $ConfigObject->Get('FQDN'),
                OTRSHandle => $OTRSHandle,
                Webserver  => $Webserver,
                Password   => $Password,
            },
        );
        if ($Webserver) {
            $LayoutObject->Block(
                Name => 'Restart',
                Data => {
                    Webserver => $Webserver,
                },
            );
        }
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # else error!
    $LayoutObject->FatalError(
        Message => "Unknown Subaction $Self->{Subaction}!",
        Comment => 'Please contact your administrator',
    );
}

sub ReConfigure {
    my ( $Self, %Param ) = @_;

    # perl quote and set via ConfigObject
    for my $Key ( sort keys %Param ) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => $Key,
            Value => $Param{$Key},
        );
        if ( $Param{$Key} ) {
            $Param{$Key} =~ s/'/\\'/g;
        }
    }

    # read config file
    my $ConfigFile = "$Self->{Path}/Kernel/Config.pm";
    ## no critic
    open( my $In, '<', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    ## use critic
    my $Config = '';
    while (<$In>) {

        # skip empty lines or comments
        if ( !$_ || $_ =~ /^\s*#/ || $_ =~ /^\s*$/ ) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;

            # replace config with %Param
            for my $Key ( sort keys %Param ) {

                # database passwords can contain characters like '@' or '$' and should be single-quoted
                # same goes for database hosts which can be like 'myserver\instance name' for MS SQL
                if ( $Key eq 'DatabasePw' || $Key eq 'DatabaseHost' ) {
                    $NewConfig =~
                        s/(\$Self->{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = '$Param{$Key}';/g;
                }
                else {
                    $NewConfig =~
                        s/(\$Self->{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = "$Param{$Key}";/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close $In;

    # write new config file
    ## no critic
    open( my $Out, '>:utf8', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    print $Out $Config;
    ## use critic
    close $Out;

    return;
}

sub ConnectToDB {
    my ( $Self, %Param ) = @_;

    # check params
    my @NeededKeys = qw(DBType DBHost DBUser DBPassword);

    if ( $Param{InstallType} eq 'CreateDB' ) {
        push @NeededKeys, qw(OTRSDBUser OTRSDBPassword);
    }

    # for Oracle we require DBSID and DBPort
    if ( $Param{DBType} eq 'oracle' ) {
        push @NeededKeys, qw(DBSID DBPort);
    }

    # for existing databases we require the database name
    if ( $Param{DBType} ne 'oracle' && $Param{InstallType} eq 'UseDB' ) {
        push @NeededKeys, 'DBName';
    }

    for my $Key (@NeededKeys) {
        if ( !$Param{$Key} && $Key !~ /^(DBPassword)$/ ) {
            return (
                Successful => 0,
                Message    => "You need '$Key'!!",
                DB         => undef,
                DBH        => undef,
            );
        }
    }

    # if we do not need to create a database for OTRS OTRSDBuser equals DBUser
    if ( $Param{InstallType} ne 'CreateDB' ) {
        $Param{OTRSDBUser}     = $Param{DBUser};
        $Param{OTRSDBPassword} = $Param{DBPassword};
    }

    # create DSN string for backend
    if ( $Param{DBType} eq 'mysql' && $Param{InstallType} eq 'CreateDB' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'mysql' && $Param{InstallType} eq 'UseDB' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};database=$Param{DBName}";
    }
    elsif ( $Param{DBType} eq 'mssql' && $Param{InstallType} eq 'CreateDB' ) {
        $Param{DSN} = "DBI:ODBC:driver={SQL Server};Server=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'mssql' && $Param{InstallType} eq 'UseDB' ) {
        $Param{DSN} = "DBI:ODBC:driver={SQL Server};Server=$Param{DBHost};Database=$Param{DBName}";
    }
    elsif ( $Param{DBType} eq 'postgresql' && $Param{InstallType} eq 'CreateDB' ) {
        $Param{DSN} = "DBI:Pg:host=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'postgresql' && $Param{InstallType} eq 'UseDB' ) {
        $Param{DSN} = "DBI:Pg:host=$Param{DBHost};dbname=$Param{DBName}";
    }
    elsif ( $Param{DBType} eq 'oracle' ) {
        $Param{DSN} = "DBI:Oracle://$Param{DBHost}:$Param{DBPort}/$Param{DBSID}";
    }

    # extract driver to load for install test
    my ($Driver) = ( $Param{DSN} =~ /^DBI:(.*?):/ );
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'DBD::' . $Driver ) ) {
        return (
            Successful => 0,
            Message    => "Can't connect to database, Perl module DBD::$Driver not installed!",
            Comment    => "",
            DB         => undef,
            DBH        => undef,
        );
    }

    my $DBH = DBI->connect(
        $Param{DSN}, $Param{DBUser}, $Param{DBPassword},
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

    # if we use an existing database, check if it already contains tables
    if ( $Param{InstallType} ne 'CreateDB' ) {

        my $Data = $DBH->selectall_arrayref('SELECT * FROM valid');
        if ($Data) {
            return (
                Successful => 0,
                Message    => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
                    ->Get("Database already contains data - it should be empty!"),
                Comment => "",
                DB      => undef,
                DBH     => undef,
            );
        }
    }

    return (
        Successful => 1,
        Message    => '',
        Comment    => '',
        DB         => \%Param,
        DBH        => $DBH,
    );
}

sub CheckDBRequirements {
    my ( $Self, %Param ) = @_;

    my %Result = $Self->ConnectToDB(
        %Param,
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # if mysql, check some more values
    if ( $Param{DBType} eq 'mysql' && $Result{Successful} == 1 ) {

        # max_allowed_packed
        my $MySQLMaxAllowedPacket            = 0;
        my $MySQLMaxAllowedPacketRecommended = 20;

        my $Data = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'max_allowed_packet'");
        $MySQLMaxAllowedPacket = $Data->[0]->[1] / 1024 / 1024;

        if ( $MySQLMaxAllowedPacket < $MySQLMaxAllowedPacketRecommended ) {
            $Result{Successful} = 0;
            $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                "Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.",
                $MySQLMaxAllowedPacketRecommended, $MySQLMaxAllowedPacket
            );
        }
    }

    if ( $Param{DBType} eq 'mysql' && $Result{Successful} == 1 ) {

        # innodb_log_file_size
        my $MySQLInnoDBLogFileSize            = 0;
        my $MySQLInnoDBLogFileSizeMinimum     = 256;
        my $MySQLInnoDBLogFileSizeRecommended = 512;

        my $Data = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'innodb_log_file_size'");
        $MySQLInnoDBLogFileSize = $Data->[0]->[1] / 1024 / 1024;

        if ( $MySQLInnoDBLogFileSize < $MySQLInnoDBLogFileSizeMinimum ) {
            $Result{Successful} = 0;
            $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                "Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.",
                $MySQLInnoDBLogFileSizeMinimum,
                $MySQLInnoDBLogFileSize,
                $MySQLInnoDBLogFileSizeRecommended,
                'http://dev.mysql.com/doc/refman/5.6/en/innodb-data-log-reconfiguration.html',
            );
        }
    }

    # delete not necessary key/value pairs
    delete $Result{DB};
    delete $Result{DBH};

    return %Result;
}

sub CheckMailConfiguration {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # first check outbound mail config
    my $OutboundMailType =
        $ParamObject->GetParam( Param => 'OutboundMailType' );
    my $SMTPHost = $ParamObject->GetParam( Param => 'SMTPHost' );
    my $SMTPPort = $ParamObject->GetParam( Param => 'SMTPPort' );
    my $SMTPAuthUser =
        $ParamObject->GetParam( Param => 'SMTPAuthUser' );
    my $SMTPAuthPassword =
        $ParamObject->GetParam( Param => 'SMTPAuthPassword' );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # if chosen config option is SMTP, set some Config params
    if ( $OutboundMailType && $OutboundMailType ne 'sendmail' ) {
        $ConfigObject->Set(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::' . uc($OutboundMailType),
        );
        $ConfigObject->Set(
            Key   => 'SendmailModule::Host',
            Value => $SMTPHost,
        );
        $ConfigObject->Set(
            Key   => 'SendmailModule::Port',
            Value => $SMTPPort,
        );
        if ($SMTPAuthUser) {
            $ConfigObject->Set(
                Key   => 'SendmailModule::AuthUser',
                Value => $SMTPAuthUser,
            );
        }
        if ($SMTPAuthPassword) {
            $ConfigObject->Set(
                Key   => 'SendmailModule::AuthPassword',
                Value => $SMTPAuthPassword,
            );
        }
    }

    # if sendmail, set config to sendmail
    else {
        $ConfigObject->Set(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Sendmail',
        );
    }

    # if config option smtp and no smtp host given, return with error
    if ( $OutboundMailType ne 'sendmail' && !$SMTPHost ) {
        return (
            Successful => 0,
            Message    => 'No SMTP Host given!'
        );
    }

    # check outbound mail configuration
    my $SendObject = $Kernel::OM->Get('Kernel::System::Email');
    my %Result     = $SendObject->Check();

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # if smtp check was successful, write data into config
    my $SendmailModule = $ConfigObject->Get('SendmailModule');
    if (
        $Result{Successful}
        && $SendmailModule ne 'Kernel::System::Email::Sendmail'
        )
    {
        my %NewConfigs = (
            'SendmailModule'       => $SendmailModule,
            'SendmailModule::Host' => $SMTPHost,
            'SendmailModule::Port' => $SMTPPort,
        );

        for my $Key ( sort keys %NewConfigs ) {
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

            for my $Key ( sort keys %NewConfigs ) {
                $SysConfigObject->ConfigItemUpdate(
                    Valid => 1,
                    Key   => $Key,
                    Value => $NewConfigs{$Key},
                );
            }
        }
    }

    # if sendmail check was successful, write data into config
    elsif (
        $Result{Successful}
        && $SendmailModule eq 'Kernel::System::Email::Sendmail'
        )
    {
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => $ConfigObject->Get('SendmailModule'),
        );
    }

    # now check inbound mail config. return if the outbound config threw an error
    if ( !$Result{Successful} ) {
        return %Result;
    }

    # check inbound mail config
    my $MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount');

    for (qw(InboundUser InboundPassword InboundHost)) {
        if ( !$ParamObject->GetParam( Param => $_ ) ) {
            return (
                Successful => 0,
                Message    => "Missing parameter: $_!"
            );
        }
    }

    my $InboundUser = $ParamObject->GetParam( Param => 'InboundUser' );
    my $InboundPassword =
        $ParamObject->GetParam( Param => 'InboundPassword' );
    my $InboundHost = $ParamObject->GetParam( Param => 'InboundHost' );
    my $InboundMailType =
        $ParamObject->GetParam( Param => 'InboundMailType' );

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
        my $ID = $MailAccount->MailAccountAdd(
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

        if ( !$ID ) {
            return (
                Successful => 0,
                Message    => 'Error while adding mail account!'
            );
        }
    }

    return %Result;
}

1;
