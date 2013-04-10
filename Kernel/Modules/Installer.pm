# --
# Kernel/Modules/Installer.pm - provides the DB installer
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::Installer;

use strict;
use warnings;

use DBI;
use Net::Domain qw(hostfqdn);

use Kernel::System::DB;
use Kernel::System::Email;
use Kernel::System::JSON;
use Kernel::System::MailAccount;
use Kernel::System::ReferenceData;
use Kernel::System::SysConfig;
use Kernel::System::User;
use Kernel::System::XML;

use vars qw(%INC);

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

    # create additional object
    $Self->{JSONObject} = Kernel::System::JSON->new( %{$Self} );

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

    # check/get sql schema dir
    my $DirOfSQLFiles = $Self->{Path} . '/scripts/database';
    if ( !-d $DirOfSQLFiles ) {
        $Self->{LayoutObject}->FatalError(
            Message => "Directory '$DirOfSQLFiles' not found!",
            Comment => 'Contact your Admin!',
        );
    }

    # read installer.json if it exists
    # it contains options set by Windows Installer
    if ( -f "$Self->{Path}/var/tmp/installer.json" ) {
        my $JSONString = $Self->{MainObject}->FileRead(
            Location => "$Self->{Path}/var/tmp/installer.json",
        );
        $Self->{Options} = $Self->{JSONObject}->Decode(
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

    # if the user skipped the mail configuration dialog, we don't walk through the registration
    # because we don't have enough data
    if ( $Self->{Subaction} eq 'Registration' && $Self->{ParamObject}->GetParam( Param => 'Skip' ) )
    {
        $Self->{Subaction} = 'Finish';
    }

    $Self->{Subaction} = 'Intro' if !$Self->{Subaction};

    # build steps
    my @Steps = qw ( License Database General Registration Finish );
    my $StepCounter;

    # no license step needed if defined in .json file
    shift @Steps if $Self->{Options}->{SkipLicense};

    # build header - but only if we're not in AJAX mode
    if ( $Self->{Subaction} ne 'CheckRequirements' ) {
        $Self->{LayoutObject}->Block(
            Name => 'Steps',
            Data => { Steps => scalar @Steps, },
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
            Registration  => 'Registration',
            Finish        => 'Finish',
        );

        # on the intro screen no steps should be highlighted
        my $Highlight = ( $Self->{Subaction} eq 'Intro' ) ? '' : 'Highlighted NoLink';

        my $Counter;

        for my $Step (@Steps) {
            $Counter++;

            # is the current step active?
            my $Active = ( $Steps{ $Self->{Subaction} } eq $Step ) ? 'Active' : '';
            $Self->{LayoutObject}->Block(
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

    # print intro form
    my $Title = $Self->{LayoutObject}->{LanguageObject}->Get('Install OTRS');
    if ( $Self->{Subaction} eq 'Intro' ) {
        my $Output =
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('Intro')
            );
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
        my $Output =
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('License')
            );
        $Self->{LayoutObject}->Block(
            Name => 'License',
            Data => {
                Item => 'License',
                Step => $StepCounter,
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

    # database selection screen
    elsif ( $Self->{Subaction} eq 'Start' ) {
        if ( !-w "$Self->{Path}/Kernel/Config.pm" ) {
            my $Output =
                $Self->{LayoutObject}->Header(
                Title => "$Title - "
                    . $Self->{LayoutObject}->{LanguageObject}->Get('Error')
                );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Kernel/Config.pm isn't writable!",
                Comment => 'If you want to use the installer, set the '
                    . 'Kernel/Config.pm writable for the webserver user! '
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        my %Databases = (
            mysql      => "MySQL",
            postgresql => "PostgreSQL",
            mssql      => "SQL Server (Microsoft)",

            #            oracle     => "Oracle",
        );

        # OTRS can only run on SQL Server if OTRS is on Windows as well
        if ( $^O ne 'MSWin32' ) {
            delete $Databases{mssql};
        }

        # build the select field for the InstallerDBStart.dtl
        $Param{SelectDBType} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%Databases,
            Name       => 'DBType',
            Size       => scalar keys %Databases,
            SelectedID => 'mysql',
        );

        my $Output =
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('Database Selection')
            );
        $Self->{LayoutObject}->Block(
            Name => 'DatabaseStart',
            Data => {
                Item         => 'Database Selection',
                Step         => $StepCounter,
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
            my %DBCredentials;
            for my $Param (qw ( DBUser DBPassword DBHost DBType DBName OTRSDBUser OTRSDBPassword ))
            {
                $DBCredentials{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
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
        my $OutputJSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset='
                . $Self->{LayoutObject}->{Charset},
            Content => $OutputJSON,
            Type    => 'inline',
            NoCache => 1,
        );
    }

    elsif ( $Self->{Subaction} eq 'DB' ) {

        my $DBType = $Self->{ParamObject}->GetParam( Param => 'DBType' );

        # use non-instantiated module to generate a password
        my $GeneratedPassword = Kernel::System::User->GenerateRandomPassword( Size => 16 );

        if ( $DBType eq 'mysql' ) {
            my $Output =
                $Self->{LayoutObject}->Header(
                Title => "$Title - "
                    . $Self->{LayoutObject}->{LanguageObject}->Get('Database') . ' MySQL'
                );
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseMySQL',
                Data => {
                    Item     => 'Configure MySQL',
                    Step     => $StepCounter,
                    Password => $GeneratedPassword,
                },
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Configure MySQL',
                    Step => $StepCounter,
                    }
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        elsif ( $DBType eq 'mssql' ) {
            my $Output =
                $Self->{LayoutObject}->Header(
                Title => "$Title - "
                    . $Self->{LayoutObject}->{LanguageObject}->Get('Database')
                    . ' Microsoft SQL Server'
                );
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseMSSQL',
                Data => {
                    Item     => 'Database',
                    Step     => $StepCounter,
                    Password => $GeneratedPassword,
                },
            );

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Configure Microsoft SQL Server',
                    Step => $StepCounter,
                    }
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        elsif ( $DBType eq 'postgresql' ) {
            my $Output =
                $Self->{LayoutObject}->Header(
                Title => "$Title - "
                    . $Self->{LayoutObject}->{LanguageObject}->Get('Database') . ' PostgreSQL'
                );
            $Self->{LayoutObject}->Block(
                Name => 'DatabasePostgreSQL',
                Data => {
                    Item     => 'Database',
                    Step     => $StepCounter,
                    Password => $GeneratedPassword,
                },
            );

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => 'Configure PostgreSQL',
                    Step => $StepCounter,
                    }
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            $Self->{LayoutObject}->FatalError(
                Message => "Unknown database type '$DBType'.",
                Comment => 'Please go back',
            );
        }
    }

    # do database settings
    elsif ( $Self->{Subaction} eq 'DBCreate' ) {

        my %DBCredentials;
        for my $Param (qw ( DBUser DBPassword DBHost DBType DBName OTRSDBUser OTRSDBPassword )) {
            $DBCredentials{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }
        %DBCredentials = %{ $Self->{Options} } if $Self->{Options}->{DBType};

        # get and check params and connect to DB
        my %Result = $Self->ConnectToDB(%DBCredentials);
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

        my $Output = $Self->{LayoutObject}->Header(
            Title => $Title . '-'
                . $Self->{LayoutObject}->{LanguageObject}->Get(
                'Create Database'
                )
        );

        $Self->{LayoutObject}->Block(
            Name => 'DatabaseResult',
            Data => {
                Item => 'Create Database',
                Step => $StepCounter,
            },
        );

        my @Statements;

        # create database, add user
        if ( $DB{DBType} eq 'mysql' ) {

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
            $DB{Host} =~ s{:\d*$}{}xms;

            @Statements = (
                "CREATE DATABASE $DB{DBName} charset utf8",
                "GRANT ALL PRIVILEGES ON $DB{DBName}.* TO $DB{OTRSDBUser}\@$DB{Host} IDENTIFIED BY '$DB{OTRSDBPassword}' WITH GRANT OPTION;",
                "FLUSH PRIVILEGES",
            );

            # set DSN for Config.pm
            $DB{ConfigDSN} = 'DBI:mysql:database=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:mysql:database=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'mssql' ) {

            @Statements = (
                "CREATE DATABASE [$DB{DBName}]",
                "CREATE LOGIN [$DB{OTRSDBUser}] WITH PASSWORD = '$DB{OTRSDBPassword}'",
                "USE [$DB{DBName}]",
                "CREATE USER  [$DB{OTRSDBUser}] FOR LOGIN [$DB{OTRSDBUser}]",
                "exec sp_addrolemember 'db_owner', '$DB{OTRSDBUser}'",
                "exec sp_defaultdb '$DB{OTRSDBUser}', '$DB{DBName}'",
            );

            # set DSN for Config.pm
            $DB{ConfigDSN}
                = 'DBI:ODBC:driver={SQL Server};Database=$Self->{Database};Server=$Self->{DatabaseHost},1433';
            $DB{DSN} = "DBI:ODBC:driver={SQL Server};Database=$DB{DBName};Server=$DB{DBHost},1433";
        }
        elsif ( $DB{DBType} eq 'postgresql' ) {

            @Statements = (
                "CREATE ROLE \"$DB{OTRSDBUser}\" WITH LOGIN PASSWORD '$DB{OTRSDBPassword}'",
                "CREATE DATABASE \"$DB{DBName}\" OWNER=\"$DB{OTRSDBUser}\" ENCODING 'utf-8'",
            );

            # set DSN for Config.pm
            $DB{ConfigDSN}
                = 'DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN} = "DBI:Pg:dbname=$DB{DBName};host=$DB{DBHost}";
        }

        # execute database statements
        for my $Statement (@Statements) {
            my @Description = split( ' ', $Statement );
            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "$Description[0] $Description[1] $Description[2]" },
            );
            if ( !$DBH->do($Statement) ) {
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
        }

        # ReConfigure Config.pm
        my $ReConfigure = $Self->ReConfigure(
            DatabaseDSN  => $DB{ConfigDSN},
            DatabaseHost => $DB{DBHost},
            Database     => $DB{DBName},
            DatabaseUser => $DB{OTRSDBUser},
            DatabasePw   => $DB{OTRSDBPassword},
        );

        if ($ReConfigure) {
            my $Output =
                $Self->{LayoutObject}->Header(
                Title => 'Install OTRS - Error'
                );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Kernel/Config.pm isn't writable!",
                Comment => 'If you want to use the installer, set the '
                    . 'Kernel/Config.pm writable for the webserver user!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # we need a database object to be able to parse the XML
        # connect to database using given credentials
        $Self->{DBObject} = Kernel::System::DB->new(
            %{$Self},
            DatabaseDSN  => $DB{DSN},
            DatabaseUser => $DB{OTRSDBUser},
            DatabasePw   => $DB{OTRSDBPassword},
            Type         => $DB{DBType},
        );
        $Self->{XMLObject} = Kernel::System::XML->new( %{$Self} );

        # create database tables and insert initial values
        my @SQLPost;
        for my $SchemaFile (qw ( otrs-schema otrs-initial_insert )) {
            if ( !-f "$DirOfSQLFiles/$SchemaFile.xml" ) {
                $Self->{LayoutObject}->FatalError(
                    Message => "File '$DirOfSQLFiles/$SchemaFile.xml' not found!",
                    Comment => 'Contact your Admin!',
                );
            }

            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Processing $SchemaFile" },
            );

            my $XML = $Self->{MainObject}->FileRead(
                Directory => $DirOfSQLFiles,
                Filename  => $SchemaFile . '.xml',
            );
            my @XMLArray = $Self->{XMLObject}->XMLParse(
                String => $XML,
            );

            my @SQL = $Self->{DBObject}->SQLProcessor(
                Database => \@XMLArray,
            );

            # if we parsed the schema, catch post instructions
            @SQLPost = $Self->{DBObject}->SQLProcessorPost() if $SchemaFile eq 'otrs-schema';

            for my $SQL (@SQL) {
                $Self->{DBObject}->Do( SQL => $SQL );
            }

            $Self->{LayoutObject}->Block(
                Name => 'DatabaseResultItemDone',
            );

        }

        # execute post SQL statements (indexes, constraints)

        $Self->{LayoutObject}->Block(
            Name => 'DatabaseResultItem',
            Data => { Item => "Processing post statements" },
        );

        for my $SQL (@SQLPost) {
            $Self->{DBObject}->Do( SQL => $SQL );
        }

        $Self->{LayoutObject}->Block(
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

        $Self->{LayoutObject}->Block(
            Name => 'DatabaseResultSuccess',
        );
        $Self->{LayoutObject}->Block(
            Name => 'DatabaseResultNext',
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # show system settings page, pre-install packages
    elsif ( $Self->{Subaction} eq 'System' ) {

        # create new DB object in order to setup sysconfig object

        $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
        if ( !$Self->{DBObject} ) {
            $Self->{LayoutObject}->FatalError();
        }

        # create sys config object
        my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );

        # take care that default config file is existing
        if ( !$SysConfigObject->WriteDefault() ) {
            return $Self->{LayoutObject}->FatalError();
        }

        # install default files
        if ( $Self->{MainObject}->Require('Kernel::System::Package') ) {
            my $PackageObject = Kernel::System::Package->new( %{$Self} );
            if ($PackageObject) {
                $PackageObject->PackageInstallDefaultFiles();
            }
        }

        my @SystemIDs = map { sprintf "%02d", $_ } ( 0 .. 99 );

        $Param{SystemIDString} = $Self->{LayoutObject}->BuildSelection(
            Data       => \@SystemIDs,
            Name       => 'SystemID',
            SelectedID => $SystemIDs[ int( rand(100) ) ],    # random system ID
        );
        $Param{LanguageString} = $Self->{LayoutObject}->BuildSelection(
            Data       => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
            Name       => 'DefaultLanguage',
            HTMLQuote  => 0,
            SelectedID => $Self->{LayoutObject}->{UserLanguage},
        );

        # build the selection field for the MX check
        $Param{SelectCheckMXRecord} = $Self->{LayoutObject}->BuildSelection(
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
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('System Settings')
            );

        $Self->{LayoutObject}->Block(
            Name => 'System',
            Data => {
                Item => 'System Settings',
                Step => $StepCounter,
                %Param,
            },
        );

        if ( !$Self->{Options}->{SkipLog} ) {
            warn "Skipping log";
            $Param{LogModuleString} = $Self->{LayoutObject}->BuildSelection(
                Data => {
                    'Kernel::System::Log::SysLog' => 'Syslog',
                    'Kernel::System::Log::File'   => 'File',
                },
                Name       => 'LogModule',
                HTMLQuote  => 0,
                SelectedID => $Self->{ConfigObject}->Get('LogModule'),
            );
            $Self->{LayoutObject}->Block(
                Name => 'LogModule',
                Data => \%Param,
            );
        }

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
        my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );

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

        my $Output =
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('Configure Mail')
            );
        $Self->{LayoutObject}->Block(
            Name => 'ConfigureMail',
            Data => {
                Item             => 'Mail Configuration',
                Step             => $StepCounter,
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

    # print registration from
    elsif ( $Self->{Subaction} eq 'Registration' ) {
        my $Output =
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('Registration')
            );

        $Self->{LayoutObject}->Block(
            Name => 'Registration',
            Data => {
                Item => 'Register your OTRS',
                Step => $StepCounter,
            },
        );

        $Self->{ReferenceDataObject} = Kernel::System::ReferenceData->new( %{$Self} );
        my $CountryList = $Self->{ReferenceDataObject}->CountryList();
        my $CountryStr  = $Self->{LayoutObject}->BuildSelection(
            Data => { %$CountryList, },
            Name => 'Country',
            ID   => 'Country',
            Sort => 'AlphanumericValue',
        );

        $Self->{LayoutObject}->Block(
            Name => 'CountryStr',
            Data => { CountryStr => $CountryStr, },
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

        # create sysconfig object
        my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );

        # take care that default config file exists
        if ( !$SysConfigObject->WriteDefault() ) {
            return $Self->{LayoutObject}->FatalError();
        }

        # update config item via sysconfig object
        my $Result = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SecureMode',
            Value => 1,
        );
        if ( !$Result ) {
            $Self->{LayoutObject}->FatalError(
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

        # check if the user wants to register
        my $DoRegistration   = 1;
        my $RegistrationDone = 0;
        my %RegistrationInfo;
        my @FieldsMandatory = qw(Lastname Firstname Organization Email);
        for my $Key (
            qw(Lastname Firstname Organization Position Email Country Phone Skip)
            )
        {
            $RegistrationInfo{$Key} =
                $Self->{ParamObject}->GetParam( Param => $Key );
        }

        if ( $RegistrationInfo{Skip} ) {

            $DoRegistration = 0;
        }
        else {

            MANDATORYFIELD:
            for my $Field (@FieldsMandatory) {

                if ( $RegistrationInfo{$Field} eq '' ) {
                    $DoRegistration = 0;
                    last MANDATORYFIELD;
                }
            }
        }

        if ($DoRegistration) {

            my $Mailtext = <<"MAILTEXT";

A user wants to register at OTRS. He/she provided the following data:

Lastname: $RegistrationInfo{Lastname}
Firstname: $RegistrationInfo{Firstname}
Organization: $RegistrationInfo{Organization}
Position: $RegistrationInfo{Position}
Email: $RegistrationInfo{Email}
Country: $RegistrationInfo{Country}
Phone: $RegistrationInfo{Phone}

OS: $^O

MAILTEXT

            eval {

                $Self->{DBObject} = Kernel::System::DB->new( %{$Self} );
                my $SendObject = Kernel::System::Email->new( %{$Self} );
                my $From
                    = "$RegistrationInfo{Firstname} $RegistrationInfo{Lastname} <$RegistrationInfo{Email}>";
                my $RegistrationDone = $SendObject->Send(
                    From     => $From,
                    To       => 'register@otrs.com',
                    Subject  => 'New user registration from the OTRS installer',
                    Charset  => 'utf-8',
                    MimeType => 'text/plain',
                    Body     => $Mailtext,
                );
            };
        }

        # set a generated password for the 'root@localhost' account
        $Self->{UserObject} = Kernel::System::User->new( %{$Self} );
        my $Password = $Self->{UserObject}->GenerateRandomPassword( Size => 16 );
        $Self->{UserObject}->SetPassword(
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
            $Self->{LayoutObject}->Header(
            Title => "$Title - "
                . $Self->{LayoutObject}->{LanguageObject}->Get('Finished')
            );
        $Self->{LayoutObject}->Block(
            Name => 'Finish',
            Data => {
                Item       => 'Finished',
                Step       => $StepCounter,
                Host       => $ENV{HTTP_HOST} || $Self->{ConfigObject}->Get('FQDN'),
                OTRSHandle => $OTRSHandle,
                Webserver  => $Webserver,
                Password   => $Password,
            },
        );
        if ($Webserver) {
            $Self->{LayoutObject}->Block(
                Name => 'Restart',
                Data => {
                    Webserver => $Webserver,
                },
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # else error!
    $Self->{LayoutObject}->FatalError(
        Message => "Unknown Subaction $Self->{Subaction}!",
        Comment => 'Please contact your administrator',
    );
}

sub ReConfigure {
    my ( $Self, %Param ) = @_;

    # perl quote and set via ConfigObject
    for my $Key ( sort keys %Param ) {
        $Self->{ConfigObject}->Set(
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
                if ( $Key eq 'DatabasePw' ) {
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
    open( my $Out, '>', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    print $Out $Config;
    ## use critic
    close $Out;

    return;
}

sub ConnectToDB {
    my ( $Self, %Param ) = @_;

    # check params
    for my $Key (qw (DBType OTRSDBUser DBHost OTRSDBPassword)) {
        if ( !$Param{$Key} && $Key !~ /^(OTRSDBPassword)$/ ) {
            return (
                Successful => 0,
                Message    => "You need '$Key'!!",
                Comment    => 'Please go back',
                DB         => undef,
                DBH        => undef,
            );
        }
    }
    my $DBH;

    # create DSN string for backend
    if ( $Param{DBType} eq 'mysql' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'mssql' ) {
        $Param{DSN} = "DBI:ODBC:driver={SQL Server};Server=$Param{DBHost}";
    }
    elsif ( $Param{DBType} eq 'postgresql' ) {
        $Param{DSN} = "DBI:Pg:host=$Param{DBHost};";
    }

    $DBH = DBI->connect(
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

    # delete not necessary key/value pairs
    delete $Result{DB};
    delete $Result{DBH};

    return %Result;
}

sub CheckMailConfiguration {
    my ( $Self, %Param ) = @_;

    # first check outbound mail config
    my $OutboundMailType =
        $Self->{ParamObject}->GetParam( Param => 'OutboundMailType' );
    my $SMTPHost = $Self->{ParamObject}->GetParam( Param => 'SMTPHost' );
    my $SMTPPort = $Self->{ParamObject}->GetParam( Param => 'SMTPPort' );
    my $SMTPAuthUser =
        $Self->{ParamObject}->GetParam( Param => 'SMTPAuthUser' );
    my $SMTPAuthPassword =
        $Self->{ParamObject}->GetParam( Param => 'SMTPAuthPassword' );

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
    my $SendObject = Kernel::System::Email->new( %{$Self} );
    my %Result     = $SendObject->Check();

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );

    # if smtp check was successful, write data into config
    my $SendmailModule = $Self->{ConfigObject}->Get('SendmailModule');
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
            Value => $Self->{ConfigObject}->Get('SendmailModule'),
        );
    }

    # now check inbound mail config. if outbound config threw error, theres no need to carry on
    if ( !$Result{Successful} ) {
        return %Result;
    }

    # check inbound mail config
    my $MailAccount = Kernel::System::MailAccount->new( %{$Self} );

    for (qw(InboundUser InboundPassword InboundHost)) {
        if ( !$Self->{ParamObject}->GetParam( Param => $_ ) ) {
            return ( Successful => 0, Message => "Missing parameter: $_!" );
        }
    }

    my $InboundUser = $Self->{ParamObject}->GetParam( Param => 'InboundUser' );
    my $InboundPassword =
        $Self->{ParamObject}->GetParam( Param => 'InboundPassword' );
    my $InboundHost = $Self->{ParamObject}->GetParam( Param => 'InboundHost' );
    my $InboundMailType =
        $Self->{ParamObject}->GetParam( Param => 'InboundMailType' );

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
