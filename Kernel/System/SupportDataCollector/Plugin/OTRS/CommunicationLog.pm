# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::CommunicationLog;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::CommunicationLog::DB',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Communication Log');
}

sub Run {
    my $Self = shift;

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my @CommunicationList     = @{ $CommunicationLogDBObj->CommunicationList() || [] };

    my %CommunicationData = (
        All        => 0,
        Successful => 0,
        Processing => 0,
        Failed     => 0,
        Incoming   => 0,
        Outgoing   => 0,
    );
    for my $Communication (@CommunicationList) {
        $CommunicationData{All}++;
        $CommunicationData{ $Communication->{Status} }++;
        $CommunicationData{ $Communication->{Direction} }++;
    }

    my $CommunicationAverageSeconds = $CommunicationLogDBObj->CommunicationList( Result => 'AVERAGE' );

    $Self->AddResultInformation(
        Identifier => 'Incoming',
        Label      => Translatable('Incoming communications'),
        Value      => $CommunicationData{Incoming},
    );
    $Self->AddResultInformation(
        Identifier => 'Outgoing',
        Label      => Translatable('Outgoing communications'),
        Value      => $CommunicationData{Outgoing},
    );
    $Self->AddResultInformation(
        Identifier => 'Failed',
        Label      => Translatable('Failed communications'),
        Value      => $CommunicationData{Failed}
    );

    my $Mask = "%.0f";
    if ( $CommunicationAverageSeconds < 10 ) {
        $Mask = "%.1f";
    }
    $Self->AddResultInformation(
        Identifier => 'AverageProcessingTime',
        Label      => Translatable('Average processing time of communications (s)'),
        Value      => sprintf( $Mask, $CommunicationAverageSeconds ),
    );

    return $Self->GetResults();
}

1;
