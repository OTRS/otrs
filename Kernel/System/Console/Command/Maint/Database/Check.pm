# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Check;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check OTRS database connectivity.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    $Self->Print("<yellow>Trying to connect to database '$DatabaseDSN' with user '$DatabaseUser'...</yellow>\n");

    # check database state
    if ($DBObject) {
        $DBObject->Prepare( SQL => "SELECT * FROM valid" );
        my $Check = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Check++;
        }
        if ( !$Check ) {
            $Self->PrintError("Connection was successful, but database content is missing.");
            return $Self->ExitCodeError();
        }
        else {
            $Self->Print("<green>Connection successful.</green>\n");

            # check for common MySQL issue where default storage engine is different
            # from initial OTRS table; this can happen when MySQL is upgraded from
            # 5.1 > 5.5.
            if ( $DBObject->{'DB::Type'} eq 'mysql' ) {
                $DBObject->Prepare(
                    SQL => "SHOW VARIABLES WHERE variable_name = 'storage_engine'",
                );
                my $StorageEngine;
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    $StorageEngine = $Row[1];
                }
                $DBObject->Prepare(
                    SQL  => "SHOW TABLE STATUS WHERE engine != ?",
                    Bind => [ \$StorageEngine ],
                );
                my @Tables;
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    push @Tables, $Row[0];
                }
                if (@Tables) {
                    my $Error = "Your storage engine is $StorageEngine.\n";
                    $Error .= "These tables use a different storage engine:\n\n";
                    $Error .= join( "\n", sort @Tables );
                    $Error .= "\n\n *** Please correct these problems! *** \n\n";

                    $Self->PrintError($Error);
                    return $Self->ExitCodeError();
                }
            }

            return $Self->ExitCodeOk();
        }
    }

    $Self->PrintError('Connection failed.');
    return $Self->ExitCodeError();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
