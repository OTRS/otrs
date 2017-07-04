# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::ArticlesPerCommunicationChannel;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Articles Per Communication Channel');
}

sub Run {
    my $Self = shift;

    my @Channels = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelList();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Channel (@Channels) {
        $DBObject->Prepare(
            SQL  => 'SELECT count(*) FROM article WHERE communication_channel_id = ?',
            Bind => [ \$Channel->{ChannelID} ],
        );
        my $Count;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Count = $Row[0];
        }
        $Self->AddResultInformation(
            Identifier => $Channel->{ChannelName},
            Label      => $Channel->{DisplayName},
            Value      => $Count,
        );
    }

    return $Self->GetResults();
}

1;
