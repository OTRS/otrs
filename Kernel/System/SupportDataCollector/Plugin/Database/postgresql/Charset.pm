# --
# Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Charset;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') !~ m{^postgresql} ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare( SQL => 'show client_encoding' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] =~ /(UNICODE|utf-?8)/i ) {
            $Self->AddResultOk(
                Identifier => 'ClientEncoding',
                Label      => 'Client Connection Charset',
                Value      => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ClientEncoding',
                Label      => 'Client Connection Charset',
                Value      => $Row[0],
                Message    => 'Setting client_encoding needs to be UNICODE or UTF8.',
            );
        }
    }

    $DBObject->Prepare( SQL => 'show server_encoding' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] =~ /(UNICODE|utf-?8)/i ) {
            $Self->AddResultOk(
                Identifier => 'ServerEncoding',
                Label      => 'Server Database Charset',
                Value      => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ServerEncoding',
                Label      => 'Server Database Charset',
                Value      => $Row[0],
                Message    => 'Setting server_encoding needs to be UNICODE or UTF8.',
            );
        }
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
