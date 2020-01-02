# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Charset;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare( SQL => "show variables like 'character_set_client'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[1] =~ /utf8/i ) {
            $Self->AddResultOk(
                Identifier => 'ClientEncoding',
                Label      => 'Client Connection Charset',
                Value      => $Row[1],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ClientEncoding',
                Label      => 'Client Connection Charset',
                Value      => $Row[1],
                Message    => 'Setting character_set_client needs to be utf8.',
            );
        }
    }

    $DBObject->Prepare( SQL => "show variables like 'character_set_database'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[1] =~ /utf8/i ) {
            $Self->AddResultOk(
                Identifier => 'ServerEncoding',
                Label      => 'Server Database Charset',
                Value      => $Row[1],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ServerEncoding',
                Label      => 'Server Database Charset',
                Value      => $Row[1],
                Message    => 'Setting character_set_database needs to be UNICODE or UTF8.',
            );
        }
    }

    my @TablesWithInvalidCharset;

    # Views have engine == null, ignore those.
    $DBObject->Prepare( SQL => 'show table status where engine is not null' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[14] !~ /^utf8/i ) {
            push @TablesWithInvalidCharset, $Row[0];
        }
    }
    if (@TablesWithInvalidCharset) {
        $Self->AddResultProblem(
            Identifier => 'TableEncoding',
            Label      => 'Table Charset',
            Value      => join( ', ', @TablesWithInvalidCharset ),
            Message    => 'There were tables found which do not have utf8 as charset.',
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'TableEncoding',
            Label      => 'Table Charset',
            Value      => '',
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
