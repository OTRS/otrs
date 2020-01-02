# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Charset;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
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
                Label      => Translatable('Client Connection Charset'),
                Value      => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ClientEncoding',
                Label      => Translatable('Client Connection Charset'),
                Value      => $Row[0],
                Message    => Translatable('Setting client_encoding needs to be UNICODE or UTF8.'),
            );
        }
    }

    $DBObject->Prepare( SQL => 'show server_encoding' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] =~ /(UNICODE|utf-?8)/i ) {
            $Self->AddResultOk(
                Identifier => 'ServerEncoding',
                Label      => Translatable('Server Database Charset'),
                Value      => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Identifier => 'ServerEncoding',
                Label      => Translatable('Server Database Charset'),
                Value      => $Row[0],
                Message    => Translatable('Setting server_encoding needs to be UNICODE or UTF8.'),
            );
        }
    }

    return $Self->GetResults();
}

1;
