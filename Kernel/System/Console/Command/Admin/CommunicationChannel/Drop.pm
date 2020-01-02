# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::CommunicationChannel::Drop;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::CommunicationChannel',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Drop a communication channel (with its data) that is no longer available in the system.'
    );
    $Self->AddOption(
        Name        => 'channel-id',
        Description => 'The ID of the communication channel to drop.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\A\d+\z/smx,
    );
    $Self->AddOption(
        Name        => 'channel-name',
        Description => 'The name of the communication channel to drop.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\A\w+\z/smx,
    );
    $Self->AddOption(
        Name        => 'force',
        Description => 'Force drop the channel even if there is existing article data, use with care.',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $ChannelID   = $Self->GetOption('channel-id');
    my $ChannelName = $Self->GetOption('channel-name');

    if ( !$ChannelID && !$ChannelName ) {
        die "Please provide either --channel-id or --channel-name option.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Deleting communication channel...</yellow>\n");

    my $ChannelID   = $Self->GetOption('channel-id');
    my $ChannelName = $Self->GetOption('channel-name');

    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

    my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
        ChannelID   => $ChannelID,
        ChannelName => $ChannelName,
    );

    if ( !%CommunicationChannel ) {
        if ($ChannelID) {
            $Self->PrintError("Channel with the ID $ChannelID could not be found!");
        }
        else {
            $Self->PrintError("Channel '$ChannelName' could not be found!");
        }
        return $Self->ExitCodeError();
    }

    # Try to drop the channel.
    my $Success = $CommunicationChannelObject->ChannelDrop(
        ChannelID       => $ChannelID,
        ChannelName     => $ChannelName,
        DropArticleData => $Self->GetOption('force'),
    );
    if ( !$Success ) {
        $Self->PrintError('Could not drop a channel!');
        if ( !$Self->GetOption('force') ) {
            $Self->Print("<yellow>Channel might still have associated data in the system.</yellow>\n");
            $Self->Print("If you want to drop this data as well, please use the <green>--force</green> switch.\n");
        }
        else {
            $Self->Print("<yellow>Please note that only invalid channels can be dropped.</yellow>\n");
        }
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
