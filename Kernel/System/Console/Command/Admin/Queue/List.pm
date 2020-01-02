# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Queue::List;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Queue',
    'Kernel::System::Valid',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List existing queues.');
    $Self->AddOption(
        Name        => 'all',
        Description => "Show all queues.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'verbose',
        Description => "More detailled output.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Listing Queues...</yellow>\n");

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %ValidList   = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    my $Valid  = !$Self->GetOption('all');
    my %Queues = $QueueObject->QueueList( Valid => $Valid );

    if ( $Self->GetOption('verbose') ) {
        for ( sort keys %Queues ) {
            my %Queue = $QueueObject->QueueGet( ID => $_ );

            $Self->Print( sprintf( "%6s", $_ ) . " $Queue{'Name'} " );
            if ( $Queue{'ValidID'} == 1 ) {
                $Self->Print("<green>$ValidList{$Queue{'ValidID'}}</green>\n");
            }
            else {
                $Self->Print("<yellow>$ValidList{$Queue{'ValidID'}}</yellow>\n");
            }
        }
    }
    else {
        for ( sort keys %Queues ) {
            $Self->Print("  $Queues{$_}\n");
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
