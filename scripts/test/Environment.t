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

# get environment object
my $EnvironmentObject = $Kernel::OM->Get('Kernel::System::Environment');

my %OSInfo = $EnvironmentObject->OSInfoGet();

for my $Attribute (qw(Hostname OS OSName User)) {
    $Self->True(
        $OSInfo{$Attribute},
        "OSInfoGet - returned $Attribute",
    );
}

$Self->True(
    $OSInfo{OSName} !~ m{\A Unknown version }xms ? 1 : 0,
    "OSInfoGet - OSName is not unknown but '$OSInfo{OSName}'",
);

my %PerlInfo = $EnvironmentObject->PerlInfoGet();

$Self->True(
    $PerlInfo{PerlVersion} =~ /^\d.\d\d.\d/,
    "PerlInfoGet - retrieved Perl version.",
);

$Self->False(
    $PerlInfo{Modules},
    "PerlInfoGet - no module versions if not specified.",
);

%PerlInfo = $EnvironmentObject->PerlInfoGet(
    BundledModules => 1,
);

$Self->True(
    $PerlInfo{PerlVersion} =~ /^\d.\d\d.\d/,
    "PerlInfoGet w/ BundledModules - retrieved Perl version.",
);

$Self->True(
    $PerlInfo{Modules}{CGI} =~ /^\d.\d\d$/,
    "PerlInfoGet w/ BundledModules - found version for CGI $PerlInfo{Modules}->{CGI}",
);

$Self->True(
    $PerlInfo{Modules}->{'JSON::PP'} =~ /^\d.\d\d/,
    "PerlInfoGet w/ BundledModules - found version for JSON::PP $PerlInfo{Modules}->{'JSON::PP'}",
);

my $Version = $EnvironmentObject->ModuleVersionGet(
    Module => 'MIME::Parser',
);

$Self->True(
    $Version =~ /^\d\.\d\d\d$/,
    "ModuleVersionGet - Version for MIME::Parser is $Version.",
);

$Version = $EnvironmentObject->ModuleVersionGet(
    Module => 'SCHMIME::Parser',
);

$Self->False(
    $Version,
    "ModuleVersionGet - Version for SCMIME::Parser does not exist.",
);

my %DBInfo = $EnvironmentObject->DBInfoGet();

for my $Key (qw(Database Host Type User Version)) {
    $Self->True(
        $DBInfo{$Key} =~ /\w\w/,
        "DBInfoGet - returned value for $Key",
    );
}

my %OTRSInfo = $EnvironmentObject->OTRSInfoGet();

for my $Key (qw(Version Home Host Product SystemID DefaultLanguage)) {
    $Self->True(
        $OTRSInfo{$Key},
        "OTRSInfoGet - returned value for $Key",
    );
}

1;
