#!/usr/bin/perl
# --
# DBUpdate-to-3.3.pl - update script to migrate OTRS 3.2.x to 3.3.x
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::SysConfig;
use Kernel::System::Cache;
use Kernel::System::Package;
use Kernel::System::VariableCheck qw(:all);

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.3.pl - Upgrade scripts for OTRS 3.2.x to 3.3.x migration.
Copyright (C) 2001-2013 OTRS AG, http://otrs.com/

Usage: $0 [-h]
    Options are as follows:
        -h      display this help

EOF
        exit 1;
    }

    # UID check if not on Windows
    if ( $^O ne 'MSWin32' && $> == 0 ) {    # $EFFECTIVE_USER_ID
        die "
Cannot run this program as root.
Please run it as the 'otrs' user or with the help of su:
    su -c \"$0\" -s /bin/bash otrs
";
    }

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    # define the number of steps
    my $Steps = 13;
    my $Step  = 1;

    print "Step $Step of $Steps: Refresh configuration cache... ";
    RebuildConfig($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    # check framework version
    print "Step $Step of $Steps: Check framework version... ";
    _CheckFrameworkVersion($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Generate MessageID md5sums... ";
    _GenerateMessageIDMD5($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    # migrate old settings
    print "Step $Step of $Steps: Migrate old settings... ";
    if ( _MigrateOldSettings($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
    $Step++;

    # migrate OTRSExternalTicketNumberRecognition
    print "Step $Step of $Steps: Migrate OTRSExternalTicketNumberRecognition... ";
    if ( _MigrateOTRSExternalTicketNumberRecognition($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
    $Step++;

    print "Step $Step of $Steps: Checking Standard Template table columns... ";
    _AddTemplateTypeColumn($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Updating Queue Standard Template relations table... ";

    # do not die if foreign keys already exists
    _AddQueueStandardTemplateForeignKeys($CommonObject);
    print "done.\n\n";
    $Step++;

    # migrate OTRSGenericStandardTemplates
    print "Step $Step of $Steps: Migrate OTRSGenericStandardTemplates... ";
    if ( _MigrateOTRSGenericStandardTemplates($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
    $Step++;

    print "Step $Step of $Steps: Checking if ACL tables already exist... ";
    _AddACLTables($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    # uninstall Merged Feature Add-Ons
    print "Step $Step of $Steps: Uninstall Merged Feature Add-Ons... ";
    if ( _UninstallMergedFeatureAddOns($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
    $Step++;

    # Delete Old Files
    print "Step $Step of $Steps: Delete the files that are not longer needed... ";
    if ( _DeleteOldFiles($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
    $Step++;

    # Clean up the cache completely at the end.
    print "Step $Step of $Steps: Clean up the cache... ";
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} ) || die;
    $CacheObject->CleanUp();
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Refresh configuration cache another time... ";
    RebuildConfig($CommonObject) || die;
    print "done.\n\n";

    print "Migration completed!\n";

    exit 0;
}

sub _CommonObjectsBase {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-DBUpdate-to-3.3',
        %CommonObject,
    );
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
    return \%CommonObject;
}

=item RebuildConfig($CommonObject)

refreshes the configuration to make sure that a ZZZAAuto.pm is present
after the upgrade.

    RebuildConfig($CommonObject);

=cut

sub RebuildConfig {
    my $CommonObject = shift;

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # Rebuild ZZZAAuto.pm with current values
    if ( !$SysConfigObject->WriteDefault() ) {
        die "Error: Can't write default config files!";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # reload config object
    print
        "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";
    $CommonObject = _CommonObjectsBase();

    return 1;
}

=item _CheckFrameworkVersion()

Check if framework it's the correct one for Dinamic Fields migration.

    _CheckFrameworkVersion();

=cut

sub _CheckFrameworkVersion {
    my $CommonObject = shift;

    my $Home = $CommonObject->{ConfigObject}->Get('Home');

  # Compare the configured HOME with the script location and abort if it points to another directory
    $Home =~ s{/+$}{}xmsg;    # remove trailing slashes
    my $HomeCheck = dirname($RealBin);
    $HomeCheck =~ s{/+$}{}xmsg;    # remove trailing slashes
    if ( $Home ne $HomeCheck ) {
        die
            "Error: \$HOME is set to $Home, but you use $HomeCheck. Please check your configuration!";
    }

    # load RELEASE file
    if ( -e !"$Home/RELEASE" ) {
        die "Error: $Home/RELEASE does not exist!";
    }
    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {    ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        die "Error: Can't read $CommonObject->{Home}/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Error: No OTRS system found"
    }
    if ( $Version !~ /^3\.3(.*)$/ ) {

        die "Error: You are trying to run this script on the wrong framework version $Version!"
    }

    return 1;
}

=item _AddACLTables($CommonObject)

This function checks if the acl and acl_sync tables already exist
and creates them otherwise.

    _AddACLTables($CommonObject);

=cut

sub _AddACLTables {
    my $CommonObject = shift;

    my $ACLTablesExist;
    print "Check if ACL table exists.\n";
    {
        my $STDERR;

        # Catch STDERR log messages to not confuse the user. The Prepare() will fail
        #   if the columns are not present.
        local *STDERR;
        open STDERR, '>:encoding(UTF-8)', \$STDERR;    ## no critic

        $ACLTablesExist = $CommonObject->{DBObject}->Prepare(
            SQL   => "SELECT * FROM acl WHERE 1=0",
            Limit => 1,
        );
    }

    my $XMLString;

    if ($ACLTablesExist) {

        print "ACL tables are present, no need to create them.\n";

        # fetch data to avoid warnings
        while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

            # noop
        }

        return 1;
    }
    else {

        print "ACL tables not found, create it.\n";

        $XMLString = '<?xml version="1.0" encoding="utf-8" ?>
        <database Name="otrs">
            <TableCreate Name="acl">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
                <Column Name="name" Required="true" Type="VARCHAR" Size="200"/>
                <Column Name="comments" Required="false" Size="250" Type="VARCHAR"/>
                <Column Name="description" Required="false" Size="250" Type="VARCHAR"/>
                <Column Name="valid_id" Required="true" Type="SMALLINT"/>
                <Column Name="stop_after_match" Required="false" Type="SMALLINT"/>
                <Column Name="config_match" Required="false" Type="LONGBLOB"/>
                <Column Name="config_change" Required="false" Type="LONGBLOB"/>
                <Column Name="create_time" Required="true" Type="DATE"/>
                <Column Name="create_by" Required="true" Type="INTEGER"/>
                <Column Name="change_time" Required="true" Type="DATE"/>
                <Column Name="change_by" Required="true" Type="INTEGER"/>
                <Unique Name="acl_name">
                    <UniqueColumn Name="name"/>
                </Unique>
                <ForeignKey ForeignTable="valid">
                    <Reference Local="valid_id" Foreign="id"/>
                </ForeignKey>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id"/>
                    <Reference Local="change_by" Foreign="id"/>
                </ForeignKey>
            </TableCreate>
            <TableCreate Name="acl_sync">
                <Column Name="acl_id" Required="true" Size="200" Type="VARCHAR"/>
                <Column Name="sync_state" Required="true" Size="30" Type="VARCHAR"/>
                <Column Name="create_time" Required="true" Type="DATE"/>
                <Column Name="change_time" Required="true" Type="DATE"/>
            </TableCreate>
        </database>';
    }

    my @SQL;
    my @SQLPost;

    my $XMLObject = Kernel::System::XML->new( %{$CommonObject} );

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $CommonObject->{DBObject}->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $CommonObject->{DBObject}->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        print $SQL . "\n";
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }
    return 1;
}

=item _AddTemplateTypeColumn()

This function checks if the template_type column from standard_template tables already exist
and sets new default value, otherwise creates it.

    _AddTemplateTypeColumn($CommonObject);

=cut

sub _AddTemplateTypeColumn {
    my $CommonObject = shift;

    my $TemplateTypeColumnExists;
    print "\nCheck if 'template_type' columns exists.\n";
    {
        my $STDERR;

        # Catch STDERR log messages to not confuse the user. The Prepare() will fail
        #   if the columns are not present.
        local *STDERR;
        open STDERR, '>:encoding(UTF-8)', \$STDERR;    ## no critic

        $TemplateTypeColumnExists = $CommonObject->{DBObject}->Prepare(
            SQL   => "SELECT template_type FROM standard_template WHERE 1=0",
            Limit => 1,
        );
    }

    my $XMLString;

    if ($TemplateTypeColumnExists) {

        print "'template_type' column exists, set new default value.\n";

        # fetch data to avoid warnings
        while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

            # noop
        }

        $XMLString = '<?xml version="1.0" encoding="utf-8" ?>
        <database Name="otrs">
            <TableAlter Name="standard_template">
                <ColumnChange NameOld="template_type" NameNew="template_type" Required="true" Size="100" Type="VARCHAR" Default="Answer"/>
            </TableAlter>
        </database>';
    }
    else {

        print "'template_type' column not found, create it.\n";

        $XMLString = '<?xml version="1.0" encoding="utf-8" ?>
        <database Name="otrs">
            <TableAlter Name="standard_template">
                <ColumnAdd Name="template_type" Required="true" Size="100" Type="VARCHAR" Default="Answer"/>
            </TableAlter>
        </database>';
    }

    my @SQL;
    my @SQLPost;

    my $XMLObject = Kernel::System::XML->new( %{$CommonObject} );

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $CommonObject->{DBObject}->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $CommonObject->{DBObject}->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        print $SQL . "\n";
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }
    return 1;
}

=item _AddQueueStandardTemplateForeignKeys()

This function cleans queue_standard_template for inconsistent regusters that points to non existing
templates before creating the foreign key to prevent errors

    _AddQueueStandardTemplateForeignKeys($CommonObject);

=cut

sub _AddQueueStandardTemplateForeignKeys {
    my $CommonObject = shift;

    print "\nCleaning queue_standard_template table\n";
    my $Success = $CommonObject->{DBObject}->Do(
        SQL => '
        DELETE FROM queue_standard_template
        WHERE (
            SELECT COUNT(*)
            FROM standard_template
            WHERE queue_standard_template.standard_template_id = standard_template.id
        ) = 0',
    );

    print "Creating new Foreign Keys for queue_standard_template table\n";
    print "\n--- Note: ---\n";
    print "If you have already run this script before then the Foreign Keys are already set and"
        . " you might see errors regarding 'duplicate key' or 'constrain already exists', that's"
        . " fine, no need to worry!\n";
    print "---\n\n";

    my $XMLString = '<?xml version="1.0" encoding="utf-8" ?>
    <database Name="otrs">
        <TableAlter Name="queue_standard_template">

            <!--  create foreign key (new name) -->
            <ForeignKeyCreate ForeignTable="standard_template">
                <Reference Local="standard_template_id" Foreign="id"/>
            </ForeignKeyCreate>
            <ForeignKeyCreate ForeignTable="queue">
                <Reference Local="queue_id" Foreign="id"/>
            </ForeignKeyCreate>
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>
    </database>';

    my @SQL;
    my @SQLPost;

    my $XMLObject = Kernel::System::XML->new( %{$CommonObject} );

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $CommonObject->{DBObject}->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $CommonObject->{DBObject}->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        print $SQL . "\n";
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }
    return 1;
}

=item _GenerateMessageIDMD5()

Create md5sums of existing MessageIDs in Article table.

=cut

sub _GenerateMessageIDMD5 {
    my $CommonObject = shift;

    # will work on all database backends; warning, we might want to add
    # UPDATE statements for databases that can natively create md5sums

    # conversion to MD5 - if possible using one UPDATE statement
    if (
        $CommonObject->{DBObject}->GetDatabaseFunction('Type') eq 'mysql'
        || $CommonObject->{DBObject}->GetDatabaseFunction('Type') eq 'postgresql'
        )
    {

        $CommonObject->{DBObject}->Do(
            SQL => '
                UPDATE article
                SET a_message_id_md5 = MD5(a_message_id)
                WHERE a_message_id IS NOT NULL
                ',
        );

    }

    # otherwise convert every row using MainObject - much slower
    else {

        $CommonObject->{DBObject}->Prepare(
            SQL => 'SELECT id, a_message_id
                        FROM article
                        WHERE a_message_id IS NOT NULL',
        );
        MESSAGEID:
        while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
            next MESSAGEID if !$Row[1];
            my $ArticleID = $Row[0];
            my $MD5 = $CommonObject->{MainObject}->MD5sum( String => $Row[1] );
            $CommonObject->{DBObject}->Do(
                SQL => "UPDATE article
                         SET a_message_id_md5 = ?
                         WHERE id = ?",
                Bind => [ \$MD5, \$ArticleID ],
            );
        }
    }

    return 1;
}

=item _MigrateOldSettings()

Migrate settings that has changed it name.

    _MigrateOldSettings($CommonObject);

=cut

sub _MigrateOldSettings {
    my $CommonObject = shift;

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # Ticket::Frontend::AgentTicketMove
    # get original setting (old name)
    my $Setting = $CommonObject->{ConfigObject}->Get('Ticket::DefaultNextMoveStateType');

    if ( IsArrayRefWithData($Setting) ) {

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###StateType',
            Value => $Setting,
        );
    }

    # StandardResponse2QueueByCreating
    # get original setting (old name)
    $Setting = $CommonObject->{ConfigObject}->Get('StandardResponse2QueueByCreating');

    if ( IsArrayRefWithData($Setting) ) {

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'StandardTemplate2QueueByCreating',
            Value => $Setting,
        );
    }

    # DashboardBackend should have default columns defined
    my %DefaultColumns = (
        Age                    => 2,
        Changed                => 1,
        CustomerID             => 1,
        CustomerName           => 1,
        CustomerUserID         => 1,
        EscalationResponseTime => 1,
        EscalationSolutionTime => 1,
        EscalationTime         => 1,
        EscalationUpdateTime   => 1,
        Lock                   => 1,
        Owner                  => 1,
        PendingTime            => 1,
        Priority               => 1,
        Queue                  => 1,
        Responsible            => 1,
        SLA                    => 1,
        Service                => 1,
        State                  => 1,
        TicketNumber           => 2,
        Title                  => 2,
        Type                   => 1
    );

    # dashboard backends
    # get values from config
    $Setting = $CommonObject->{ConfigObject}->Get('DashboardBackend');

    # check config
    DASHBOARDBACKEND:
    for my $DashboardBackend ( sort keys %{$Setting} ) {
        next DASHBOARDBACKEND if !IsHashRefWithData( $Setting->{$DashboardBackend} );

        my $Module = $Setting->{$DashboardBackend}->{Module} || '';
        next DASHBOARDBACKEND
            if $Module ne 'Kernel::Output::HTML::DashboardTicketGeneric';

        next DASHBOARDBACKEND
            if IsHashRefWithData( $Setting->{$DashboardBackend}->{DefaultColumns} );

        # set default column values
        $Setting->{$DashboardBackend}->{DefaultColumns} = \%DefaultColumns;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'DashboardBackend###' . $DashboardBackend,
            Value => $Setting->{$DashboardBackend},
        );
    }

    # customer information center backends
    # get values from config
    $Setting = $CommonObject->{ConfigObject}->Get('AgentCustomerInformationCenter::Backend');

    # remove CustomerID for CIC
    delete $DefaultColumns{CustomerID};

    # check config
    CICBACKEND:
    for my $DashboardBackend ( sort keys %{$Setting} ) {
        next CICBACKEND if !IsHashRefWithData( $Setting->{$DashboardBackend} );

        my $Module = $Setting->{$DashboardBackend}->{Module} || '';
        next CICBACKEND
            if $Module ne 'Kernel::Output::HTML::DashboardTicketGeneric';

        next CICBACKEND
            if IsHashRefWithData( $Setting->{$DashboardBackend}->{DefaultColumns} );

        # set default column values
        $Setting->{$DashboardBackend}->{DefaultColumns} = \%DefaultColumns;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AgentCustomerInformationCenter::Backend###' . $DashboardBackend,
            Value => $Setting->{$DashboardBackend},
        );
    }

    # update toolbar items settings
    # otherwise the new fontawesome icons won't be displayed

    # collect icon data for toolbar items
    my %ModuleAttributes = (
        '1-Ticket::AgentTicketQueue' => {
            'Icon' => 'icon-folder-close',
        },
        '2-Ticket::AgentTicketStatus' => {
            'Icon' => 'icon-list-ol',
        },
        '3-Ticket::AgentTicketEscalation' => {
            'Icon' => 'icon-exclamation',
        },
        '4-Ticket::AgentTicketPhone' => {
            'Icon' => 'icon-phone',
        },
        '5-Ticket::AgentTicketEmail' => {
            'Icon' => 'icon-envelope',
        },
        '6-Ticket::TicketResponsible' => {
            'Icon'        => 'icon-user',
            'IconNew'     => 'icon-user',
            'IconReached' => 'icon-user',
        },
        '7-Ticket::TicketWatcher' => {
            'Icon'        => 'icon-eye-open',
            'IconNew'     => 'icon-eye-open',
            'IconReached' => 'icon-eye-open',
        },
        '8-Ticket::TicketLocked' => {
            'Icon'        => 'icon-lock',
            'IconNew'     => 'icon-lock',
            'IconReached' => 'icon-lock',
        },
    );

    $Setting = $CommonObject->{ConfigObject}->Get('Frontend::ToolBarModule');

    TOOLBARMODULE:
    for my $ToolbarModule ( sort keys %ModuleAttributes ) {

        next TOOLBARMODULE if !IsHashRefWithData( $Setting->{$ToolbarModule} );

        # set icon and class infos
        for my $Attribute ( sort keys %{ $ModuleAttributes{$ToolbarModule} } ) {
            $Setting->{$ToolbarModule}->{$Attribute}
                = $ModuleAttributes{$ToolbarModule}->{$Attribute};
        }

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###' . $ToolbarModule,
            Value => $Setting->{$ToolbarModule},
        );
    }

    return 1;
}

=item _MigrateOTRSExternalTicketNumberRecognition()

Migrate PostMaster ExternalTicketNumberRecognition settings to the new names and deletes the FAO
package from the database if installed.

    _MigrateOTRSExternalTicketNumberRecognition($CommonObject);

=cut

sub _MigrateOTRSExternalTicketNumberRecognition {
    my $CommonObject = shift;

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # convert settings
    for my $Number ( 1 .. 4 ) {

        # get original setting (from FAO using old name)
        my $Setting = $CommonObject->{ConfigObject}->Get('PostMaster::PreFilterModule')
            ->{ '00-ExternalTicketNumberRecognition' . $Number };

        if ( IsHashRefWithData($Setting) ) {

            # set new setting, notice that it has an extra 0 in the name
            my $Success = $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key =>
                    'PostMaster::PreFilterModule###000-ExternalTicketNumberRecognition' . $Number,
                Value => $Setting,
            );
        }
    }

    return 1;
}

=item _MigrateOTRSGenericStandardTemplates()

Migrate Standard Templates Types to new style

    _MigrateMigrateOTRSGenericStandardTemplates($CommonObject);

=cut

sub _MigrateOTRSGenericStandardTemplates {
    my $CommonObject = shift;

    # seach all templates with template type anwer or forward
    for my $TemplateType (qw(answer forward)) {

        # set new template type to Answer or Forward (with capital leter)
        my $NewTemplateType = ucfirst $TemplateType;

        # update DB
        return if !$CommonObject->{DBObject}->Do(
            SQL => 'UPDATE standard_template
                SET template_type = ?
                WHERE template_type = ?',
            Bind => [ \$NewTemplateType, \$TemplateType, ],
        );
    }

    return 1;
}

=item _UninstallMergedFeatureAddOns()

safe uninstall packages from the database.

    UninstallMergedFeatureAddOns($CommonObject);

=cut

sub _UninstallMergedFeatureAddOns {
    my $CommonObject = shift;

    my $PackageObject = Kernel::System::Package->new( %{$CommonObject} );

    # qw( ) contains a list of the feature add-ons to uninstall
    for my $PackageName (
        qw(
        OTRSPostMasterFilterExtensions
        OTRSFreeTextFromCustomerUser
        OTRSExternalTicketNumberRecognition
        OTRSDashboardQueueOverview
        OTRSImportantArticles
        OTRSImportantArticlesITSM
        OTRSDashboardTicketCalendar
        OTRSMultiServiceSelect
        OTRSMultiQueueSelect
        OTRSDynamicFieldMultiLevelSelection
        OTRSEventBasedTicketActions
        OTRSTicketAclEditor
        OTRSCustomerProcessSelection
        OTRSACLExtensions
        OTRSGenericStandardTemplates
        OTRSExtendedDynamicDateFieldSearch
        OTRSDashboardTicketOverviewFilters
        OTRSKeepFAQAttachments
        )
        )
    {
        my $Success = $PackageObject->_PackageUninstallMerged(
            Name => $PackageName,
        );
        if ( !$Success ) {
            print STDERR "There was an error uninstalling package $PackageName\n";
            return;
        }
    }
    return 1;
}

=item _DeleteOldFiles()

delete not longer needed files.

    _DeleteOldFiles($CommonObject);

=cut

sub _DeleteOldFiles {
    my $CommonObject = shift;

    my $Home = $CommonObject->{ConfigObject}->Get('Home');

    # qw( ) contains a list of the feature files to uninstall
    for my $File (
        qw(
        bin/otrs.AddQueue2StdResponse.pl
        Kernel/Modules/AdminQueueResponses.pm
        Kernel/Modules/AdminResponse.pm
        Kernel/Modules/AdminResponseAttachment.pm
        Kernel/Output/HTML/Standard/AdminQueueResponses.dtl
        Kernel/Output/HTML/Standard/AdminResponse.dtl
        Kernel/Output/HTML/Standard/AdminResponseAttachment.dtl
        )
        )
    {
        # add home path
        my $Location = $Home . '/' . $File;

        # check if file exists
        if ( -e $Location ) {

            # delete file
            my $Success = unlink $Location;
            if ( !$Success ) {
                print STDERR "Could not delete $Location: $!\n";
                return;
            }
        }
    }
    return 1;
}

1;
