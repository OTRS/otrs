# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my @CommandFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/System/Console/Command',
    Filter    => '*.pm',
    Recursive => 1,
);

my @Commands;

for my $CommandFile (@CommandFiles) {
    $CommandFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
    $CommandFile =~ s{/+}{::}xmsg;
    push @Commands, $CommandFile;
}

for my $Command (@Commands) {

    my $CommandObject = $Kernel::OM->Get($Command);

    $Self->True(
        $CommandObject,
        "$Command could be created",
    );

    $Self->Is(
        $CommandObject->{_ConfigureSuccessful},
        1,
        "$Command was correctly configured",
    );
}

1;
