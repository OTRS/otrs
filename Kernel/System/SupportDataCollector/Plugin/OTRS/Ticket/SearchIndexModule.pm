# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::SearchIndexModule;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my $Module = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndexModule');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $ArticleCount;
    $DBObject->Prepare( SQL => 'SELECT count(*) FROM article' );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleCount = $Row[0];
    }

    if ( $ArticleCount > 50_000 && $Module =~ /RuntimeDB/ ) {
        $Self->AddResultWarning(
            Label => 'Ticket Search Index Module',
            Value => $Module,
            Message =>
                'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Ticket Search Index Module',
            Value => $Module,
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
