# --
# NestedMessage.t - email parser tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: NestedMessage.t,v 1.1.2.2 2012-11-29 12:42:28 mg Exp $
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
open( IN, "< $Home/scripts/test/sample/EmailParser/NestedMessage-Test1.box" );
while (<IN>) {
    push( @Array, $_ );
}
close(IN);

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);

my @Attachments = $EmailParserObject->GetAttachments();
$Self->Is(
    scalar @Attachments,
    3,
    "Found 3 files (plain, html and attachment for nested message)",
);

$Self->Is(
    $Attachments[2]->{Filename} || '',
    '[Presse-Greenpeace] Morgen wird Greenpeace-Einspruch gegenEmbryonen-Patent verhandelt - NeueDokumentation ueber Patente auf Leben.eml',
    "Nested message filename",
);

1;
