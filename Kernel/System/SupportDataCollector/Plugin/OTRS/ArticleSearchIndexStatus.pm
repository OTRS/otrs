# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::ArticleSearchIndexStatus;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket::Article',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Article Search Index Status');
}

sub Run {
    my $Self = shift;

    my %Status = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexStatus();

    my $Percentage;
    if ( $Status{ArticlesIndexed} == 0 || $Status{ArticlesTotal} == 0 ) {
        $Percentage = 0;
    }
    else {
        $Percentage = $Status{ArticlesIndexed} / $Status{ArticlesTotal} * 100;
    }

    $Self->AddResultInformation(
        Label => Translatable('Indexed Articles'),
        Value => sprintf( '%.1f %% (%d/%d)', $Percentage, $Status{ArticlesIndexed}, $Status{ArticlesTotal} ),
    );

    return $Self->GetResults();
}

1;
