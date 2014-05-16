# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use File::Basename;
use File::Copy;

use Kernel::System::FileTemp;

my $Filename;
my $TempDir;
my $FH;

{

    my $FileTempObject = Kernel::System::FileTemp->new( %{$Self} );

    ( $FH, $Filename ) = $FileTempObject->TempFile();

    $Self->True(
        $Filename,
        'TempFile()',
    );

    $Self->True(
        ( -e $Filename ),
        'TempFile() -e',
    );

    $TempDir = $FileTempObject->TempDir();

    $Self->True(
        ( -d $TempDir ),
        "TempDir $TempDir exists",
    );

    my $ConfiguredTempDir = $Self->{ConfigObject}->Get('TempDir');
    $ConfiguredTempDir =~ s{/+}{/}smxg;

    $Self->Is(
        ( dirname $TempDir ),
        $ConfiguredTempDir,
        "$TempDir is relative to defined TempDir",
    );

    $Self->True(
        ( copy( $Self->{ConfigObject}->Get('Home') . '/scripts/test/FileTemp.t', "$TempDir/" ) ),
        'Copy test to tempdir',
    );

    $Self->True(
        ( -e $TempDir . '/FileTemp.t' ),
        'Copied file exists in tempdir',
    );

}

$Self->False(
    ( -e $Filename ),
    "TempFile() $Filename -e after destroy",
);

$Self->False(
    ( -d $TempDir ),
    "TempDir() $TempDir removed after destroy",
);

1;
