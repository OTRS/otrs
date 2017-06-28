# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::Base;    ## no critic

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

scripts::DBUpdateTo6::Base - Base class for migrations.

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $DBUpdateTo6Object->RebuildConfig(
        UnitTestMode => 1,      # (optional) Prevent discarding all objects at the end
    );

=cut

sub RebuildConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            CleanUp => 1,
            Force   => 1,
            UserID  => 1,
        )
        )
    {
        die "There was a problem writing XML to DB.";
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments => $Param{Comments} || "Configuration Rebuild",
            AllSettings  => 1,
            Force        => 1,
            NoValidation => 1,
            UserID       => 1,
        )
        )
    {
        die "There was a problem writing ZZZAAuto.pm.";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    print "\n  If you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanup()

Clean up the cache.

    $DBUpdateTo6Object->CacheCleanup();

=cut

sub CacheCleanup {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    return 1;
}

=head2 ExecuteXMLDBString()

Parse and execute an XML string.

    $DBUpdateTo6Object->ExecuteXMLDBString();

=cut

sub ExecuteXMLDBString {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{XMLString} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need XMLString!",
        );
        return;
    }

    my $XMLString = $Param{XMLString};

    # Create database specific SQL and PostSQL commands out of XML.
    my @SQL;
    my @SQLPost;
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # Create database specific SQL.
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # Create database specific PostSQL.
    push @SQLPost, $DBObject->SQLProcessorPost();

    # Execute SQL.
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=head2 TableExists()

Checks if the given table exists in the database.

    my $Result = $DBUpdateTo6Object->TableExists(
        Table => 'ticket',
    );

Returns true if the table exists, otherwise false.

=cut

sub TableExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Table} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Table!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TableNames = map { lc $_ => 1 } $DBObject->ListTables();

    return if !$TableNames{ lc $Param{Table} };

    return 1;
}

=head2 ColumnExists()

Checks if the given column exists in the given table.

    my $Result = $DBUpdateTo6Object->ColumnExists(
        Table  => 'ticket',
        Column =>  'id',
    );

Returns true if the column exists, otherwise false.

=cut

sub ColumnExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Table Column)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => "SELECT * FROM $Param{Table}",
        Limit => 1,
    );

    my %ColumnNames = map { lc $_ => 1 } $DBObject->GetColumnNames();

    return if !$ColumnNames{ lc $Param{Column} };

    return 1;
}

=head2 GetTaskConfig()

Clean up the cache.

    $DBUpdateTo6Object->GetTaskConfig( Module => "TaskModuleName");

=cut

sub GetTaskConfig {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Module} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Module!',
        );
        return;
    }

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $File = $Home . '/scripts/DBUpdateTo6/TaskConfig/' . $Param{Module} . '.yml';

    if ( !-e $File ) {
        $File .= '.dist';

        if ( !-e $File ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Couldn't find $File!",
            );
            return;
        }
    }

    my $FileRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
    );

    # Convert configuration to Perl data structure for easier handling.
    my $ConfigData = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => ${$FileRef} );

    return $ConfigData;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
