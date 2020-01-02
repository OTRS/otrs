# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Cache::Delete;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Cache',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete cache files created by OTRS.');
    $Self->AddOption(
        Name        => 'expired',
        Description => 'Delete only caches which are expired by TTL.',
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'type',
        Description => 'Define the type of cache which should be deleted (e.g. Ticket or StdAttachment).',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Options;
    $Options{Expired} = $Self->GetOption('expired');
    $Options{Type}    = $Self->GetOption('type');

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $Self->Print("<yellow>Deleting cache...</yellow>\n");
    if ( !$CacheObject->CleanUp(%Options) ) {
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
