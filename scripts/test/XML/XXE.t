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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $XXEFilename  = $ConfigObject->Get('Home') . '/var/tmp/XXE.t.txt';

# Write XXE payload.
unlink $XXEFilename;
my $FileCreated = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
    Location => $XXEFilename,
    Content  => \"XXE",
);
$Self->True(
    $FileCreated,
    'XXE payload written.',
);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'XMLParse',
);

my $XML = <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE r [
<!ELEMENT r ANY >
<!ENTITY sp SYSTEM "$XXEFilename">
]>
<test_xml>Node &sp;</test_xml>
EOF

my $XMLObject       = $Kernel::OM->Get('Kernel::System::XML');
my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

$Self->Is(
    [ $XMLObject->XMLParse( String => $XML ) ]->[0]->{Content},
    "Node ",
    'K::S::XML XXE check.',
);

$Self->Is(
    $XMLSimpleObject->XMLIn( XMLInput => $XML ),
    "Node ",
    'K::S::XML::Simple XXE check.',
);

# Clean-up
unlink $XXEFilename;

1;
