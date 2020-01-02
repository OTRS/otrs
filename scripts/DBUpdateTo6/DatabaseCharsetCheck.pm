# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::DatabaseCharsetCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

use version;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo6::DatabaseCharsetCheck - Checks if MySQL database is using correct charset.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CheckPreviousRequirement()

Check for initial conditions for running this migration step.

Returns 1 on success:

    my $Result = $DBUpdateObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # This check makes sense only for MySQL, so skip it in case of other back-ends.
    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        if ($Verbose) {
            print "    Database backend is not MySQL, skipping...\n";
        }
        return 1;
    }

    my $ClientIsUTF8       = 0;
    my $ClientCharacterSet = "";

    # Check client character set.
    $DBObject->Prepare( SQL => "show variables like 'character_set_client'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ClientCharacterSet = $Row[1];
        if ( $ClientCharacterSet =~ /utf8/i ) {
            $ClientIsUTF8 = 1;
        }
    }

    if ( !$ClientIsUTF8 ) {
        print "    Error: Setting character_set_client needs to be utf8.\n";
        return;
    }

    if ($Verbose) {
        print "    The setting character_set_client is: $ClientCharacterSet. ";
    }

    my $DatabaseIsUTF8       = 0;
    my $DatabaseIsUTF8MB4    = 0;
    my $DatabaseCharacterSet = "";

    # Check database character set.
    $DBObject->Prepare( SQL => "show variables like 'character_set_database'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DatabaseCharacterSet = $Row[1];
        if ( $DatabaseCharacterSet =~ /utf8/i ) {
            $DatabaseIsUTF8 = 1;
        }
        if ( $DatabaseCharacterSet =~ /utf8mb4/i ) {
            $DatabaseIsUTF8MB4 = 1;
        }
    }

    if ($DatabaseIsUTF8MB4) {
        print "\n    Error: The setting character_set_database is set to '$DatabaseCharacterSet'.";
        print
            "\n    Error: This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361.";
        print "\n    Error: Please convert your database to the character set 'utf8'.\n";
        return;
    }

    if ( !$DatabaseIsUTF8 ) {
        print "\n    Error: The setting character_set_database needs to be 'utf8'.\n";
        return;
    }

    if ($Verbose) {
        print "The setting character_set_database is: $DatabaseCharacterSet. ";
    }

    my @TablesWithInvalidCharset;

    # Check for tables with invalid character set. Views have engine == null, ignore those.
    $DBObject->Prepare( SQL => 'show table status where engine is not null' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[14] =~ /^utf8mb4/i || $Row[14] !~ /^utf8/i ) {
            push @TablesWithInvalidCharset, $Row[0];
        }
    }

    if (@TablesWithInvalidCharset) {
        print "\n    Error: There were tables found which do not have 'utf8' as charset: '";
        print join( "', '", @TablesWithInvalidCharset ) . "'.\n";
        return;
    }

    if ($Verbose) {
        print "No tables found with invalid charset.\n";
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
