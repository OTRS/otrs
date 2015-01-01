# --
# Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Charset;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    if ( $Self->{DBObject}->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    $Self->{DBObject}->Prepare( SQL => "show variables like 'character_set_client'" );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

    $Self->{DBObject}->Prepare( SQL => "show variables like 'character_set_database'" );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
    $Self->{DBObject}->Prepare( SQL => 'show table status' );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
