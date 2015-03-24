# --
# Kernel/System/Console/Command/Admin/Queue/Add.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Queue::Add;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Create a new queue.');
    $Self->AddOption(
        Name        => 'name',
        Description => 'Queue name for the new queue.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'group',
        Description => 'Group which should be assigned to the new queue.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'system-address-id',
        Description => 'ID of the system address which should be assigned to the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d/smx,
    );
    $Self->AddOption(
        Name        => 'system-address-name',
        Description => 'Name of the system address which should be assigned to the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'comment',
        Description => 'Comment for the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'unlock-timeout',
        Description => 'Unlock timeout in minutes for the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d/smx,
    );
    $Self->AddOption(
        Name        => 'first-response-time',
        Description => 'Ticket first respone time in minutes for the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d/smx,
    );
    $Self->AddOption(
        Name        => 'update-time',
        Description => 'Ticket update in minutes for the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d/smx,
    );
    $Self->AddOption(
        Name        => 'solution-time',
        Description => 'Ticket solution time in minutes for the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d/smx,
    );
    $Self->AddOption(
        Name        => 'calendar',
        Description => 'Name of the calendar for the new queue.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding a new queue...</yellow>\n");

    # check group
    my $Group = $Self->GetOption('group');
    my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup( Group => $Group );
    if ( !$GroupID ) {
        $Self->PrintError("Found no GroupID for $Group\n");
        return $Self->ExitCodeError();
    }

    my $SystemAddressID   = $Self->GetOption('system-address-id');
    my $SystemAddressName = $Self->GetOption('system-address-name');

    # check System Address
    if ($SystemAddressName) {
        my %SystemAddressList = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressList(
            Valid => 1
        );
        ADDRESS:
        for my $ID ( sort keys %SystemAddressList ) {
            my %SystemAddressInfo = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressGet(
                ID => $ID
            );
            if ( $SystemAddressInfo{Name} eq $SystemAddressName ) {
                $SystemAddressID = $ID;
                last ADDRESS;
            }
        }
        if ( !$SystemAddressID ) {
            $Self->PrintError("Address $SystemAddressName not found\n");
            return $Self->ExitCodeError();
        }
    }

    # add queue
    my $Success = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
        Name              => $Self->GetOption('name'),
        GroupID           => $GroupID,
        SystemAddressID   => $SystemAddressID || $Self->GetOption('system-address-id') || undef,
        Comment           => $Self->GetOption('comment'),
        UnlockTimeout     => $Self->GetOption('unlock-timeout'),
        FirstResponseTime => $Self->GetOption('first-response-time'),
        UpdateTime        => $Self->GetOption('update-time'),
        SolutionTime      => $Self->GetOption('solution-time'),
        Calendar          => $Self->GetOption('calendar'),
        ValidID           => 1,
        UserID            => 1,
    );

    # error handling
    if ( !$Success ) {
        $Self->PrintError("Can't create queue.\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
