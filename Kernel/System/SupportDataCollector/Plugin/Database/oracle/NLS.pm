# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::oracle::NLS;

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

    if ( $DBObject->GetDatabaseFunction('Type') ne 'oracle' ) {
        return $Self->GetResults();
    }

    if ( $ENV{NLS_LANG} && $ENV{NLS_LANG} =~ m/al32utf-?8/i ) {
        $Self->AddResultOk(
            Identifier => 'NLS_LANG',
            Label      => Translatable('NLS_LANG Setting'),
            Value      => $ENV{NLS_LANG},
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_LANG',
            Label      => Translatable('NLS_LANG Setting'),
            Value      => $ENV{NLS_LANG},
            Message    => Translatable('NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).'),
        );
    }

    if ( $ENV{NLS_DATE_FORMAT} && $ENV{NLS_DATE_FORMAT} eq "YYYY-MM-DD HH24:MI:SS" ) {
        $Self->AddResultOk(
            Identifier => 'NLS_DATE_FORMAT',
            Label      => Translatable('NLS_DATE_FORMAT Setting'),
            Value      => $ENV{NLS_DATE_FORMAT},
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_DATE_FORMAT',
            Label      => Translatable('NLS_DATE_FORMAT Setting'),
            Value      => $ENV{NLS_DATE_FORMAT},
            Message    => Translatable("NLS_DATE_FORMAT must be set to 'YYYY-MM-DD HH24:MI:SS'."),
        );
    }

    my $CreateTime;
    $DBObject->Prepare(
        SQL   => "SELECT create_time FROM valid",
        Limit => 1
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CreateTime = $Row[0];
    }

    if (
        $CreateTime
        && $CreateTime =~ /^\d\d\d\d-(\d|\d\d)-(\d|\d\d)\s(\d|\d\d):(\d|\d\d):(\d|\d\d)/
        )
    {
        $Self->AddResultOk(
            Identifier => 'NLS_DATE_FORMAT_SELECT',
            Label      => Translatable('NLS_DATE_FORMAT Setting SQL Check'),
            Value => $ENV{NLS_DATE_FORMAT},    # use environment variable to avoid different values
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_DATE_FORMAT_SELECT',
            Label      => Translatable('NLS_DATE_FORMAT Setting SQL Check'),
            Value      => $CreateTime,
            Message    => Translatable("NLS_DATE_FORMAT must be set to 'YYYY-MM-DD HH24:MI:SS'."),
        );
    }

    return $Self->GetResults();
}

1;
