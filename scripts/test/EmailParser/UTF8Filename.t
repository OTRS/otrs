# --
# UTF8Filename.t - email parser tests
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

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#9989
my @Array;
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/UTF8Filename.box";    ## no critic
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
    "Found 3 files (plain and both attachments)",
);

$Self->Is(
    $Attachments[1]->{Filename} || '',
    'file-2',
    "HTML attachment",
);

$Self->Is(
    $Attachments[2]->{Filename} || '',
    'Documentación.pdf',
    "UTF8 attachment",
);

1;
