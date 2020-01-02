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

use Kernel::System::EmailParser;

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#9989
my @Array;
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/EmptyEmail.eml";    ## no critic
while (<$IN>) {
    push @Array, $_;
}
close $IN;

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    Email => \@Array,
);

my @Attachments = $EmailParserObject->GetAttachments();
$Self->Is(
    scalar @Attachments,
    2,
    "Attachments",
);

$Self->Is(
    $Attachments[0]->{Filename},
    'file-1',
    "Empty body name",
);

$Self->Is(
    $Attachments[0]->{Filesize},
    '0',
    "Empty body size",
);

$Self->Is(
    $Attachments[1]->{Filename},
    'Łatwa_sprawa.txt',
    "Empty attachment name",
);

$Self->Is(
    $Attachments[1]->{Filesize},
    '0',
    "Empty attachment size",
);

1;
