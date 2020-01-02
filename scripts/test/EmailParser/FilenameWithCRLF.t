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

# Test that filenames with CR + LF are properly cleaned up.
# See http://bugs.otrs.org/show_bug.cgi?id=13554.

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#13554
my @Array;
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/FilenameWithCRLF.box";    ## no critic
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
    3,
    "Found files",
);

# Tested cleaning up CR and LF
# CR => 0D hexadecimal
# LF => 0A hexadecimal
$Self->Is(
    $Attachments[2]->{'Filename'} || '',
    'Test__test_test_test_dokument.eml',
    "Filename with multiple newlines removed",
);

1;
