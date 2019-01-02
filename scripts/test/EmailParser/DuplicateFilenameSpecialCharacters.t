# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $ConfigObject->Get('Home');

# test for bug#1970
my $FileContent = $MainObject->FileRead(
    Location => "$Home/scripts/test/sample/EmailParser/DuplicateFilenameSpecialCharacters.box",
    Result   => 'ARRAY',
);

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    Email => $FileContent,
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
