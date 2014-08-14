# --
# Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::TablePresence;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',
);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    # table check
    my $File
        = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/database/otrs-schema.xml';
    if ( !-f $File ) {
        $Self->AddResultProblem(
            Label   => 'Table Presence',
            Value   => '',
            Message => "Internal Error: Could not open file."
        );
    }

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
        Mode     => 'utf8',
    );
    if ( !ref $ContentRef && !${$ContentRef} ) {
        $Self->AddResultProblem(
            Label   => 'Table Check',
            Value   => '',
            Message => "Internal Error: Could not read file."
        );
    }

    my @XMLHash
        = $Kernel::OM->Get('Kernel::System::XML')->XMLParse2XMLHash( String => ${$ContentRef} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @MissingTables;
    TABLE:
    for my $Table ( @{ $XMLHash[1]->{database}->[1]->{Table} } ) {
        next TABLE if !$Table;

        my $TableExists = $DBObject->Prepare(
            SQL   => "SELECT 1 FROM $Table->{Name}",
            Limit => 1
        );

        if ($TableExists) {
            while ( my @Row = $DBObject->FetchrowArray() ) {

                # noop
            }
        }
        else {
            push( @MissingTables, $Table->{Name} );
        }
    }
    if ( !@MissingTables ) {
        $Self->AddResultOk(
            Label => 'Table Presence',
            Value => '',
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => 'Table Presence',
            Value   => join( ', ', @MissingTables ),
            Message => "Tables found which are not present in the database."

        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
