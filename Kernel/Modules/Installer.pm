# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::Installer;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)
## nofilter(TidyAll::Plugin::OTRS::Perl::Print)

use strict;
use warnings;

use DBI;
use Net::Domain qw(hostfqdn);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

use vars qw(%INC);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        $LayoutObject->FatalError(
            Message => Translatable('SecureMode active!'),
            Comment => Translatable(
                'If you want to re-run the Installer, disable the SecureMode in the SysConfig.'
            ),
        );
    }

    # Check environment directories.
    $Self->{Path} = $ConfigObject->Get('Home');
    if ( !-d $Self->{Path} ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Directory "%s" doesn\'t exist!', $Self->{Path} ),
            Comment => Translatable('Configure "Home" in Kernel/Config.pm first!'),
        );
    }
    if ( !-f "$Self->{Path}/Kernel/Config.pm" ) {
        $LayoutObject->FatalError(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'File "%s/Kernel/Config.pm" not found!', $Self->{Path} ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # Check/get SQL schema directory
    my $DirOfSQLFiles = $Self->{Path} . '/scripts/database';
    if ( !-d $DirOfSQLFiles ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Directory "%s" not found!', $DirOfSQLFiles ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # TODO: This seams to be deprecated now
    # Read installer.json if it exists.
    #   It contains options set by Windows Installer
    if ( -f "$Self->{Path}/var/tmp/installer.json" ) {
        my $JSONString = $MainObject->FileRead(
            Location => "$Self->{Path}/var/tmp/installer.json",
        );
        $Self->{Options} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $$JSONString,
        );
    }

    # Check if License option needs to be skipped.
    if ( $Self->{Subaction} eq 'License' && $Self->{Options}->{SkipLicense} ) {
        $Self->{Subaction} = 'Start';
    }

    # Check if Database option needs to be skipped.
    if ( $Self->{Subaction} eq 'Start' && $Self->{Options}->{DBType} ) {
        $Self->{Subaction} = 'DBCreate';
    }

    $Self->{Subaction} = 'Intro' if !$Self->{Subaction};

    # Build steps.
    my @Steps = qw(License Database General Finish);
    my $StepCounter;

    # TODO: This seams to be deprecated now
    # No license step needed if defined in .json file.
    shift @Steps if $Self->{Options}->{SkipLicense};

    # Build header - but only if we're not in AJAX mode.
    if ( $Self->{Subaction} ne 'CheckRequirements' ) {
        $LayoutObject->Block(
            Name => 'Steps',
            Data => {
                Steps => scalar @Steps,
            },
        );

        # Mapping of sub-actions to steps.
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

        # On the intro screen no steps should be highlighted.
        my $Highlight = ( $Self->{Subaction} eq 'Intro' ) ? '' : 'Highlighted NoLink';

        my $Counter;

        for my $Step (@Steps) {
            $Counter++;

            # Is the current step active?
            my $Active = ( $Steps{ $Self->{Subaction} } eq $Step ) ? 'Active' : '';
            $LayoutObject->Block(
                Name => 'Step' . $Step,
                Data => {
                    Step      => $Counter,
                    Highlight => $Highlight,
                    Active    => $Active,
                },
            );

            # If this is the actual step.
            if ( $Steps{ $Self->{Subaction} } eq $Step ) {

                # No more highlights from now on.
                $Highlight = '';

                # Step calculation: 2/5 etc.
                $StepCounter = $Counter . "/" . scalar @Steps;
            }
        }
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Print intro form.
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

    # Print license from.
    elsif ( $Self->{Subaction} eq 'License' ) {
        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('License')
            );
        $LayoutObject->Block(
            Name => 'License',
            Data => {
                Item => Translatable('License'),
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

    # Database selection screen.
    elsif ( $Self->{Subaction} eq 'Start' ) {
        if ( !-w "$Self->{Path}/Kernel/Config.pm" ) {
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate('Error')
                );
            $Output .= $LayoutObject->Warning(
                Message => Translatable('Kernel/Config.pm isn\'t writable!'),
                Comment => Translatable(
                    'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!'
                ),
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        my %Databases = (
            mysql      => "MySQL",
            postgresql => "PostgreSQL",
            oracle     => "Oracle",
        );

        # Build the select field for the InstallerDBStart.tt.
        $Param{SelectDBType} = $LayoutObject->BuildSelection(
            Data       => \%Databases,
            Name       => 'DBType',
            Class      => 'Modernize',
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
                Item         => Translatable('Database Selection'),
                Step         => $StepCounter,
                SelectDBType => $Param{SelectDBType},
            },
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # Check different requirements (AJAX).
    elsif ( $Self->{Subaction} eq 'CheckRequirements' ) {
        my $CheckMode = $ParamObject->GetParam( Param => 'CheckMode' );
        my %Result;

        # Check DB requirements.
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

        # Check mail configuration.
        elsif ( $CheckMode eq 'Mail' ) {
            %Result = $Self->CheckMailConfiguration();
        }

        # No adequate check method found.
        else {
            %Result = (
                Successful => 0,
                Message    => Translatable('Unknown Check!'),
                Comment => $LayoutObject->{LanguageObject}->Translate( 'The check "%s" doesn\'t exist!', $CheckMode ),
            );
        }

        # Return JSON-String because of AJAX-Mode.
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

        # Use MainObject to generate a password.
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
                    . $LayoutObject->{LanguageObject}->Translate( 'Database %s', 'MySQL' )
                );
            $LayoutObject->Block(
                Name => 'DatabaseMySQL',
                Data => {
                    Item                => Translatable('Configure MySQL'),
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
                    Item => Translatable('Configure MySQL'),
                    Step => $StepCounter,
                },
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
        elsif ( $DBType eq 'postgresql' ) {
            my $PasswordExplanation = $DBInstallType eq 'CreateDB'
                ? $LayoutObject->{LanguageObject}->Translate('Enter the password for the administrative database user.')
                : $LayoutObject->{LanguageObject}->Translate('Enter the password for the database user.');
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate( 'Database %s', 'PostgreSQL' )
                );
            $LayoutObject->Block(
                Name => 'DatabasePostgreSQL',
                Data => {
                    Item          => Translatable('Database'),
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
                    Item => Translatable('Configure PostgreSQL'),
                    Step => $StepCounter,
                },
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
        elsif ( $DBType eq 'oracle' ) {
            my $Output =
                $LayoutObject->Header(
                Title => "$Title - "
                    . $LayoutObject->{LanguageObject}->Translate( 'Database %s', 'Oracle' )
                );
            $LayoutObject->Block(
                Name => 'DatabaseOracle',
                Data => {
                    Item => Translatable('Database'),
                    Step => $StepCounter,
                },
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {
                    Item => Translatable('Configure Oracle'),
                    Step => $StepCounter,
                },
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
        else {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Unknown database type "%s".', $DBType ),
                Comment => Translatable('Please go back.'),
            );
        }
    }

    # Do database settings.
    elsif ( $Self->{Subaction} eq 'DBCreate' ) {

        my %DBCredentials;
        for my $Param (
            qw(DBUser DBPassword DBHost DBType DBName DBSID DBPort InstallType OTRSDBUser OTRSDBPassword)
            )
        {
            $DBCredentials{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }
        %DBCredentials = %{ $Self->{Options} } if $Self->{Options}->{DBType};

        # Get and check params and connect to DB.
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
                ),
        );

        $LayoutObject->Block(
            Name => 'DatabaseResult',
            Data => {
                Item => Translatable('Create Database'),
                Step => $StepCounter,
            },
        );

        my @Statements;

        # Create database, add user.
        if ( $DB{DBType} eq 'mysql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {

                # Determine current host for MySQL account.
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

                # Strip off port, i.e. 'localhost:14962' should become 'localhost'.
                $DB{Host} =~ s{:\d*\z}{}xms;

                @Statements = (
                    "CREATE DATABASE `$DB{DBName}` charset utf8",
                    "GRANT ALL PRIVILEGES ON `$DB{DBName}`.* TO `$DB{OTRSDBUser}`\@`$DB{Host}` IDENTIFIED BY '$DB{OTRSDBPassword}' WITH GRANT OPTION",
                    "FLUSH PRIVILEGES",
                );
            }

            # Set DSN for Config.pm.
            $DB{ConfigDSN} = 'DBI:mysql:database=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:mysql:database=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'postgresql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {
                @Statements = (
                    "CREATE ROLE \"$DB{OTRSDBUser}\" WITH LOGIN PASSWORD '$DB{OTRSDBPassword}'",
                    "CREATE DATABASE \"$DB{DBName}\" OWNER=\"$DB{OTRSDBUser}\" ENCODING 'utf-8'",
                );
            }

            # Set DSN for Config.pm.
            $DB{ConfigDSN} = 'DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:Pg:dbname=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'oracle' ) {

            # Set DSN for Config.pm.
            $DB{ConfigDSN} = 'DBI:Oracle://$Self->{DatabaseHost}:' . $DB{DBPort} . '/$Self->{Database}';
            $DB{DSN}       = "DBI:Oracle://$DB{DBHost}:$DB{DBPort}/$DB{DBSID}";
            $ConfigObject->Set(
                Key   => 'Database::Connect',
                Value => "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS'",
            );
        }

        # Execute database statements.
        for my $Statement (@Statements) {
            my @Description = split( ' ', $Statement );

            # Prevent uninitialized variables.
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

        # ReConfigure Config.pm.
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
                Title => Translatable('Install OTRS - Error')
                );
            $Output .= $LayoutObject->Warning(
                Message => Translatable('Kernel/Config.pm isn\'t writable!'),
                Comment => Translatable(
                    'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!'
                ),
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::DB'] );

        # We need a database object to be able to parse the XML
        #   connect to database using given credentials.
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::DB' => {
                DatabaseDSN  => $DB{DSN},
                DatabaseUser => $DB{OTRSDBUser},
                DatabasePw   => $DB{OTRSDBPassword},
                Type         => $DB{DBType},
            },
        );
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Create database tables and insert initial values.
        my @SQLPost;
        for my $SchemaFile (qw(otrs-schema otrs-initial_insert)) {
            if ( !-f "$DirOfSQLFiles/$SchemaFile.xml" ) {
                $LayoutObject->FatalError(
                    Message => $LayoutObject->{LanguageObject}
                        ->Translate( 'File "%s/%s.xml" not found!', $DirOfSQLFiles, $SchemaFile ),
                    Comment => Translatable('Contact your Admin!'),
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

            # If we parsed the schema, catch post instructions.
            @SQLPost = $DBObject->SQLProcessorPost() if $SchemaFile eq 'otrs-schema';

            for my $SQL (@SQL) {
                $DBObject->Do( SQL => $SQL );
            }

            $LayoutObject->Block(
                Name => 'DatabaseResultItemDone',
            );
        }

        # Execute post SQL statements (indexes, constraints).

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

        # If running under PerlEx, reload the application (and thus the configuration).
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

    # Show system settings page, pre-install packages.
    elsif ( $Self->{Subaction} eq 'System' ) {

        if ( !$Kernel::OM->Get('Kernel::System::DB') ) {
            $LayoutObject->FatalError();
        }

        # Take care that default config is in the database.
        if ( !$Self->_CheckConfig() ) {
            return $LayoutObject->FatalError();
        }

        # Install default files.
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
            Class      => 'Modernize',
            SelectedID => $SystemIDs[ int( rand(100) ) ],    # random system ID
        );
        $Param{LanguageString} = $LayoutObject->BuildSelection(
            Data       => $ConfigObject->Get('DefaultUsedLanguages'),
            Name       => 'DefaultLanguage',
            Class      => 'Modernize',
            HTMLQuote  => 0,
            SelectedID => $LayoutObject->{UserLanguage},
        );

        # Build the selection field for the MX check.
        $Param{SelectCheckMXRecord} = $LayoutObject->BuildSelection(
            Data => {
                1 => Translatable('Yes'),
                0 => Translatable('No'),
            },
            Name       => 'CheckMXRecord',
            Class      => 'Modernize',
            SelectedID => '1',
        );

        # Read FQDN using Net::Domain and pre-populate the field.
        $Param{FQDN} = hostfqdn();

        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('System Settings'),
            );

        $LayoutObject->Block(
            Name => 'System',
            Data => {
                Item => Translatable('System Settings'),
                Step => $StepCounter,
                %Param,
            },
        );

        if ( !$Self->{Options}->{SkipLog} ) {
            $Param{LogModuleString} = $LayoutObject->BuildSelection(
                Data => {
                    'Kernel::System::Log::SysLog' => Translatable('Syslog'),
                    'Kernel::System::Log::File'   => Translatable('File'),
                },
                Name       => 'LogModule',
                Class      => 'Modernize',
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

    # Do system settings action.
    elsif ( $Self->{Subaction} eq 'ConfigureMail' ) {

        if ( !$Kernel::OM->Get('Kernel::System::DB') ) {
            $LayoutObject->FatalError();
        }

        # Take care that default config is in the database.
        if ( !$Self->_CheckConfig() ) {
            return $LayoutObject->FatalError();
        }

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );

        for my $SettingName (
            qw(SystemID FQDN AdminEmail Organization LogModule LogModule::LogFile
            DefaultLanguage CheckMXRecord)
            )
        {
            my $EffectiveValue = $ParamObject->GetParam( Param => $SettingName );

            # Update config item via sys config object.
            $SysConfigObject->SettingUpdate(
                Name              => $SettingName,
                IsValid           => 1,
                EffectiveValue    => $EffectiveValue,
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UnlockAll => 1,
        );

        # Get mail account object and check available back-ends.
        my $MailAccount  = $Kernel::OM->Get('Kernel::System::MailAccount');
        my %MailBackends = $MailAccount->MailAccountBackendList();

        my $OutboundMailTypeSelection = $LayoutObject->BuildSelection(
            Data => {
                sendmail => 'Sendmail',
                smtp     => 'SMTP',
                smtps    => 'SMTPS',
                smtptls  => 'SMTPTLS',
            },
            Name  => 'OutboundMailType',
            Class => 'Modernize',
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
            Data  => \%MailBackends,
            Name  => 'InboundMailType',
            Class => 'Modernize',
        );

        my $Output =
            $LayoutObject->Header(
            Title => "$Title - "
                . $LayoutObject->{LanguageObject}->Translate('Configure Mail')
            );
        $LayoutObject->Block(
            Name => 'ConfigureMail',
            Data => {
                Item             => $LayoutObject->{LanguageObject}->Translate('Mail Configuration'),
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

        # Take care that default config is in the database.
        if ( !$Self->_CheckConfig() ) {
            return $LayoutObject->FatalError();
        }

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $SettingName = 'SecureMode';

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $SettingName,
            Force  => 1,
            UserID => 1,
        );

        # Update config item via SysConfig object.
        my $Result = $SysConfigObject->SettingUpdate(
            Name              => $SettingName,
            IsValid           => 1,
            EffectiveValue    => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result ) {
            $LayoutObject->FatalError(
                Message => Translatable('Can\'t write Config file!'),
            );
        }

        # There is no need to unlock the setting as it was already unlocked in the update.

        # 'Rebuild' the configuration.
        $SysConfigObject->ConfigurationDeploy(
            Comments    => "Installer deployment",
            AllSettings => 1,
            Force       => 1,
            UserID      => 1,
        );

        # If running under PerlEx, reload the application (and thus the configuration).
        if (
            exists $ENV{'GATEWAY_INTERFACE'}
            && $ENV{'GATEWAY_INTERFACE'} eq "CGI-PerlEx"
            )
        {
            PerlEx::ReloadAll();
        }

        # Set a generated password for the 'root@localhost' account.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $Password   = $UserObject->GenerateRandomPassword( Size => 16 );
        $UserObject->SetPassword(
            UserLogin => 'root@localhost',
            PW        => $Password,
        );

        # TODO: This seams to be deprecated now.
        # Remove installer file with pre-configured options.
        if ( -f "$Self->{Path}/var/tmp/installer.json" ) {
            unlink "$Self->{Path}/var/tmp/installer.json";
        }

        # check web server - is a restart needed?
        my $Webserver;

        # Only if we have mod_perl we have to restart.
        if ( exists $ENV{MOD_PERL} ) {
            eval 'require mod_perl';               ## no critic
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

        # Check if Apache::Reload is loaded.
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
                Item       => Translatable('Finished'),
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

    # Else error!
    return $LayoutObject->FatalError(
        Message => $LayoutObject->{LanguageObject}->Translate( 'Unknown Subaction %s!', $Self->{Subaction} ),
        Comment => Translatable('Please contact the administrator.'),
    );
}

sub ReConfigure {
    my ( $Self, %Param ) = @_;

    # Perl quote and set via ConfigObject.
    for my $Key ( sort keys %Param ) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => $Key,
            Value => $Param{$Key},
        );
        if ( $Param{$Key} ) {
            $Param{$Key} =~ s/'/\\'/g;
        }
    }

    # Read config file.
    my $ConfigFile = "$Self->{Path}/Kernel/Config.pm";
    ## no critic
    open( my $In, '<', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    ## use critic
    my $Config = '';
    while (<$In>) {

        # Skip empty lines or comments.
        if ( !$_ || $_ =~ /^\s*#/ || $_ =~ /^\s*$/ ) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;

            # Replace config with %Param.
            for my $Key ( sort keys %Param ) {

                # Database passwords can contain characters like '@' or '$' and should be single-quoted
                #   same goes for database hosts which can be like 'myserver\instance name' for MS SQL.
                if ( $Key eq 'DatabasePw' || $Key eq 'DatabaseHost' ) {
                    $NewConfig =~
                        s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = '$Param{$Key}';/g;
                }
                else {
                    $NewConfig =~
                        s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = "$Param{$Key}";/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close $In;

    # Write new config file.
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

    # Check params.
    my @NeededKeys = qw(DBType DBHost DBUser DBPassword);

    if ( $Param{InstallType} eq 'CreateDB' ) {
        push @NeededKeys, qw(OTRSDBUser OTRSDBPassword);
    }

    # For Oracle we require DBSID and DBPort.
    if ( $Param{DBType} eq 'oracle' ) {
        push @NeededKeys, qw(DBSID DBPort);
    }

    # For existing databases we require the database name.
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

    # If we do not need to create a database for OTRS OTRSDBuser equals DBUser.
    if ( $Param{InstallType} ne 'CreateDB' ) {
        $Param{OTRSDBUser}     = $Param{DBUser};
        $Param{OTRSDBPassword} = $Param{DBPassword};
    }

    # Create DSN string for backend.
    if ( $Param{DBType} eq 'mysql' && $Param{InstallType} eq 'CreateDB' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'mysql' && $Param{InstallType} eq 'UseDB' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};database=$Param{DBName}";
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

    # Extract driver to load for install test.
    my ($Driver) = ( $Param{DSN} =~ /^DBI:(.*?):/ );
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'DBD::' . $Driver ) ) {
        return (
            Successful => 0,
            Message    => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
                ->Translate( "Can't connect to database, Perl module DBD::%s not installed!", $Driver ),
            Comment => "",
            DB      => undef,
            DBH     => undef,
        );
    }

    my $DBH = DBI->connect(
        $Param{DSN}, $Param{DBUser}, $Param{DBPassword},
    );

    if ( !$DBH ) {
        return (
            Successful => 0,
            Message    => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
                ->Translate("Can't connect to database, read comment!"),
            Comment => "$DBI::errstr",
            DB      => undef,
            DBH     => undef,
        );
    }

    # If we use an existing database, check if it already contains tables.
    if ( $Param{InstallType} ne 'CreateDB' ) {

        my $Data = $DBH->selectall_arrayref('SELECT * FROM valid');
        if ($Data) {
            return (
                Successful => 0,
                Message    => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
                    ->Translate("Database already contains data - it should be empty!"),
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

    # If mysql, check some more values.
    if ( $Param{DBType} eq 'mysql' && $Result{Successful} == 1 ) {

        # Set max_allowed_packet.
        my $MySQLMaxAllowedPacket            = 0;
        my $MySQLMaxAllowedPacketRecommended = 64;

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

        # Set innodb_log_file_size.
        my $MySQLInnoDBLogFileSize            = 0;
        my $MySQLInnoDBLogFileSizeMinimum     = 256;
        my $MySQLInnoDBLogFileSizeRecommended = 512;

        # Default storage engine variable has changed its name in MySQL 5.5.3, we need to support both of them for now.
        #   <= 5.5.2 storage_engine
        #   >= 5.5.3 default_storage_engine
        my $DataOld = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'storage_engine'");
        my $DataNew = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'default_storage_engine'");
        my $DefaultStorageEngine = ( $DataOld->[0] && $DataOld->[0]->[1] ? $DataOld->[0]->[1] : undef )
            // ( $DataNew->[0] && $DataNew->[0]->[1] ? $DataNew->[0]->[1] : '' );

        if ( lc $DefaultStorageEngine eq 'innodb' ) {

            my $Data = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'innodb_log_file_size'");
            $MySQLInnoDBLogFileSize = $Data->[0]->[1] / 1024 / 1024;

            if ( $MySQLInnoDBLogFileSize < $MySQLInnoDBLogFileSizeMinimum ) {
                $Result{Successful} = 0;
                $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                    "Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.",
                    $MySQLInnoDBLogFileSizeMinimum,
                    $MySQLInnoDBLogFileSize,
                    $MySQLInnoDBLogFileSizeRecommended,
                    'https://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html',
                );
            }
        }

        # Check character_set_database value.
        my $Charset = $Result{DBH}->selectall_arrayref("SHOW variables LIKE 'character_set_database'");

        if ( $Charset->[0]->[1] =~ /utf8mb4/i ) {
            $Result{Successful} = 0;
            $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                "Wrong database collation (%s is %s, but it needs to be utf8).",
                'character_set_database',
                $Charset->[0]->[1],
            );
        }
        elsif ( $Charset->[0]->[1] !~ /utf8/i ) {
            $Result{Successful} = 0;
            $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                "Wrong database collation (%s is %s, but it needs to be utf8).",
                'character_set_database',
                $Charset->[0]->[1],
            );
        }
    }

    # Delete not necessary key/value pairs.
    delete $Result{DB};
    delete $Result{DBH};

    return %Result;
}

sub CheckMailConfiguration {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # First check outbound mail config.
    my $OutboundMailType =
        $ParamObject->GetParam( Param => 'OutboundMailType' );
    my $SMTPHost = $ParamObject->GetParam( Param => 'SMTPHost' );
    my $SMTPPort = $ParamObject->GetParam( Param => 'SMTPPort' );
    my $SMTPAuthUser =
        $ParamObject->GetParam( Param => 'SMTPAuthUser' );
    my $SMTPAuthPassword =
        $ParamObject->GetParam( Param => 'SMTPAuthPassword' );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # If chosen config option is SMTP, set some Config params.
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

    # If sendmail, set config to sendmail.
    else {
        $ConfigObject->Set(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Sendmail',
        );
    }

    # If config option SMTP and no SMTP host given, return with error.
    if ( $OutboundMailType ne 'sendmail' && !$SMTPHost ) {
        return (
            Successful => 0,
            Message    => 'No SMTP Host given!'
        );
    }

    # Check outbound mail configuration.
    my $SendObject = $Kernel::OM->Get('Kernel::System::Email');
    my %Result     = $SendObject->Check();

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );

    # If SMTP check was successful, write data into config.
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

        for my $SettingName ( sort keys %NewConfigs ) {
            $SysConfigObject->SettingUpdate(
                Name              => $SettingName,
                IsValid           => 1,
                EffectiveValue    => $NewConfigs{$SettingName},
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
        }

        if ( $SMTPAuthUser && $SMTPAuthPassword ) {
            %NewConfigs = (
                'SendmailModule::AuthUser'     => $SMTPAuthUser,
                'SendmailModule::AuthPassword' => $SMTPAuthPassword,
            );

            for my $SettingName ( sort keys %NewConfigs ) {
                $SysConfigObject->SettingUpdate(
                    Name              => $SettingName,
                    IsValid           => 1,
                    EffectiveValue    => $NewConfigs{$SettingName},
                    ExclusiveLockGUID => $ExclusiveLockGUID,
                    UserID            => 1,
                );
            }
        }
    }

    # If sendmail check was successful, write data into config.
    elsif (
        $Result{Successful}
        && $SendmailModule eq 'Kernel::System::Email::Sendmail'
        )
    {
        $SysConfigObject->SettingUpdate(
            Name              => 'SendmailModule',
            IsValid           => 1,
            EffectiveValue    => $ConfigObject->Get('SendmailModule'),
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
    }

    # Now check inbound mail config. return if the outbound config threw an error.
    if ( !$Result{Successful} ) {
        return %Result;
    }

    # Check inbound mail config.
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

    # If successful, add mail account to DB.
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

sub _CheckConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @Result = $SysConfigObject->ConfigurationSearch(
        Search => 'ProductName',
    );

    return 1 if @Result;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    return $SysConfigObject->ConfigurationXML2DB(
        UserID    => 1,
        Directory => "$Home/Kernel/Config/Files/XML",
        Force     => 1,
        CleanUp   => 1,
    );
}

1;
