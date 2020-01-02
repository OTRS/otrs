# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::SearchIndexModule;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    my $ForceUnfilteredStorage = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndex::ForceUnfilteredStorage');

    if ($ForceUnfilteredStorage) {
        $Self->AddResultWarning(
            Label => Translatable('Ticket Search Index Module'),
            Value => 'Ticket::SearchIndex::ForceUnfilteredStorage',
            Message =>
                Translatable(
                'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.'
                ),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Ticket Search Index Module'),
            Value => 'Ticket::SearchIndex::ForceUnfilteredStorage',
        );
    }

    return $Self->GetResults();
}

1;
