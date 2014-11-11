# --
# Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::oracle::NLS;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    if ( $Self->{DBObject}->GetDatabaseFunction('Type') ne 'oracle' ) {
        return $Self->GetResults();
    }

    if ( $ENV{NLS_LANG} && $ENV{NLS_LANG} =~ m/utf-?8/i ) {
        $Self->AddResultOk(
            Identifier => 'NLS_LANG',
            Label      => 'NLS_LANG Setting',
            Value      => $ENV{NLS_LANG},
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_LANG',
            Label      => 'NLS_LANG Setting',
            Value      => $ENV{NLS_LANG},
            Message    => 'NLS_LANG must be set to utf8 (e.g. german_germany.utf8).',
        );
    }

    if ( $ENV{NLS_DATE_FORMAT} && $ENV{NLS_DATE_FORMAT} eq "YYYY-MM-DD HH24:MI:SS" ) {
        $Self->AddResultOk(
            Identifier => 'NLS_DATE_FORMAT',
            Label      => 'NLS_DATE_FORMAT Setting',
            Value      => $ENV{NLS_DATE_FORMAT},
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_DATE_FORMAT',
            Label      => 'NLS_DATE_FORMAT Setting',
            Value      => $ENV{NLS_DATE_FORMAT},
            Message    => "NLS_DATE_FORMAT must be set to 'YYYY-MM-DD HH24:MI:SS'.",
        );
    }

    my $CreateTime;
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT create_time FROM valid",
        Limit => 1
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $CreateTime = $Row[0];
    }

    if (
        $CreateTime
        && $CreateTime =~ /^\d\d\d\d-(\d|\d\d)-(\d|\d\d)\s(\d|\d\d):(\d|\d\d):(\d|\d\d)/
        )
    {
        $Self->AddResultOk(
            Identifier => 'NLS_DATE_FORMAT_SELECT',
            Label      => 'NLS_DATE_FORMAT Setting SQL Check',
            Value      => $ENV{NLS_DATE_FORMAT},                 # use environment variable to avoid different values
        );
    }
    else {
        $Self->AddResultProblem(
            Identifier => 'NLS_DATE_FORMAT_SELECT',
            Label      => 'NLS_DATE_FORMAT Setting SQL Check',
            Value      => $CreateTime,
            Message    => "NLS_DATE_FORMAT must be set to 'YYYY-MM-DD HH24:MI:SS'.",
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
