# --
# FilenameWithNewline.t - email parser tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::EmailParser;

# Test that filenames with multiple newlines are properly cleaned up.
# See http://bugs.otrs.org/show_bug.cgi?id=10394.

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#1970
my @Array;
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/FilenameWithNewline.box";   ## no critic
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

$Self->Is(
    $Attachments[2]->{'Filename'} || '',
    'Test testtestt 1231234/34/Testtesttes testes testtesttestt - testtesttes dokumentów/Sprzedaż, testTE [...] [TE#123123123].eml',
    "Filename with multiple newlines removed",
);

1;
