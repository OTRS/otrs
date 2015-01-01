# --
# BrokenEncoding.t - email parser tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

# This test should verify that an email with an unknown encoding not cause a "die".

use Kernel::System::EmailParser;

my $Home = $Self->{ConfigObject}->Get('Home');

# test for bug#1970
my @Array = ();
open( my $IN, "<", "$Home/scripts/test/sample/EmailParser/BrokenEncoding.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);

$Self->True(
    $EmailParserObject->GetMessageBody(),
    'Body found',
);

my @Attachments = $EmailParserObject->GetAttachments();

$Self->Is(
    scalar @Attachments,
    1,
    "Found files",
);

1;
