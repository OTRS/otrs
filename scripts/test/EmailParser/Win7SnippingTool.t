# --
# Win7SnippingTool.t - email parser tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

=cut
This is a test for an email from the Win7 snipping tool. This email is an invalid
mime message and therefore cannot be parsed by MIME::Tools correctly.

See also: http://bugs.otrs.org/show_bug.cgi?id=8092
=cut

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# test for bug#1970
my @Array;
open my $IN, '<', "$Home/scripts/test/sample/EmailParser/Win7SnippingTool.box";    ## no critic
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
    "Found files",
);

$Self->Is(
    $Attachments[0]->{'ContentType'} || '',
    'multipart/alternative; ',
    "Unparseable content part",
);

1;
