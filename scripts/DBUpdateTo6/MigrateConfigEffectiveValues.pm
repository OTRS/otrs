# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateConfigEffectiveValues;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::SysConfig::Migration',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateConfigEffectiveValues - Migrate config effective values.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Move and rename ZZZAuto.pm from OTRS 5 away from Kernel/Config/Files
    my ( $FileClass, $FilePath ) = $Self->_MoveZZZAuto();

    # check error
    if ( !$FilePath ) {
        if ($Verbose) {
            print
                "    Could not find Kernel/Config/Files/ZZZAuto.pm or Kernel/Config/Backups/ZZZAutoOTRS5.pm, skipping...\n";
        }
        return 1;
    }

    # Rebuild config to read the xml config files from otrs 6 to write them
    # to the database and deploy them to ZZZAAuto.pm
    $Self->RebuildConfig();
    if ($Verbose) {
        print "\n    If you see errors about 'Setting ... is invalid', that's fine, no need to worry! \n"
            . "    This could happen because some config settings are no longer needed for OTRS 6 \n"
            . "    or you may have some packages installed, which will be migrated \n"
            . "    in a later step (during the package upgrade). \n"
            . "\n"
            . "    The configuration migration can take some time, please be patient.\n";
    }

    # migrate the effective values from modified settings in OTRS 5 to OTRS 6
    my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
        FileClass => $FileClass,
        FilePath  => $FilePath,
        NoOutput  => !$Verbose,
    );

    return $Success;
}

sub _MoveZZZAuto {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # define old location of ZZZAuto.pm and file class name
    my $OldLocation  = "$Home/Kernel/Config/Files/ZZZAuto.pm";
    my $OldFileClass = 'Kernel::Config::Files::ZZZAuto';

    # define backup directory, new location of ZZZAuto.pm (renamed to ZZZAutoOTRS5.pm)
    # and new file class
    my $BackupDirectory = "$Home/Kernel/Config/Backups";
    my $NewLocation     = "$BackupDirectory/ZZZAutoOTRS5.pm";
    my $NewFileClass    = 'Kernel::Config::Backups::ZZZAutoOTRS5';

    # ZZZAuto.pm file does not exist
    if ( !-e $OldLocation ) {

        # but Kernel/Config/Backups/ZZZAutoOTRS5.pm exists already
        return ( $NewFileClass, $NewLocation ) if -e $NewLocation;

        # error
        return;
    }

    # check if backup directory exists
    if ( !-d $BackupDirectory ) {

        # we try to create it
        if ( !mkdir $BackupDirectory ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create directory $BackupDirectory!",
            );
            return;
        }
    }

    # move it to new location and rename it
    system("mv $OldLocation $NewLocation");

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Read the content of the file. Make sure to open it in UTF-8 mode, in order to preserve multi-byte characters.
    #   Please see bug#13344 for more information.
    my $ContentSCALARRef = $MainObject->FileRead(
        Location => $NewLocation,
        Mode     => 'utf8',
    );

    # rename the package name inside the file
    ${$ContentSCALARRef} =~ s{^package $OldFileClass;$}{package $NewFileClass;}ms;

    # write content back to file
    my $FileLocation = $MainObject->FileWrite(
        Location   => $NewLocation,
        Content    => $ContentSCALARRef,
        Mode       => 'utf8',
        Permission => '644',
    );

    return ( $NewFileClass, $FileLocation );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
