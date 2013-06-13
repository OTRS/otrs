# --
# NestedMessage.t - email parser tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::EmailParser;

my $Home = $Self->{ConfigObject}->Get('Home');

# test for bug#1970
my @Array = ();
open( my $IN, "<", "$Home/scripts/test/sample/EmailParser/DuplicateFilenameSpecialCharacters.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
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
    '[Terminology_Guide].pdf',
    "First attachment",
);

$Self->Is(
    $Attachments[2]->{Filename} || '',
    '[Terminology_Guide].pdf',
    "First attachment",
);

1;
