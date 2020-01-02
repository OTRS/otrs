# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::TablePresence;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    # table check
    my $File = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/database/otrs-schema.xml';
    if ( !-f $File ) {
        $Self->AddResultProblem(
            Label   => Translatable('Table Presence'),
            Value   => '',
            Message => Translatable("Internal Error: Could not open file."),
        );
    }

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
        Mode     => 'utf8',
    );
    if ( !ref $ContentRef && !${$ContentRef} ) {
        $Self->AddResultProblem(
            Label   => Translatable('Table Check'),
            Value   => '',
            Message => Translatable("Internal Error: Could not read file."),
        );
    }

    my @XMLHash = $Kernel::OM->Get('Kernel::System::XML')->XMLParse2XMLHash( String => ${$ContentRef} );

    my %ExistingTables = map { lc($_) => 1 } $Kernel::OM->Get('Kernel::System::DB')->ListTables();

    my @MissingTables;
    TABLE:
    for my $Table ( @{ $XMLHash[1]->{database}->[1]->{Table} } ) {
        next TABLE if !$Table;

        if ( !$ExistingTables{ lc( $Table->{Name} ) } ) {
            push( @MissingTables, $Table->{Name} );
        }
    }
    if ( !@MissingTables ) {
        $Self->AddResultOk(
            Label => Translatable('Table Presence'),
            Value => '',
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => Translatable('Table Presence'),
            Value   => join( ', ', @MissingTables ),
            Message => Translatable("Tables found which are not present in the database."),
        );
    }

    return $Self->GetResults();
}

1;
