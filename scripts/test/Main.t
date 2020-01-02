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

use File::Path;
use JSON::PP;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# FilenameCleanUp - tests
my @Tests = (
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_t o/alal.xml',
        FilenameNew  => 'me_t_o_alal.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_to/al?al"l.xml',
        FilenameNew  => 'me_to_al_al_l.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_to/a\/\\lal.xml',
        FilenameNew  => 'me_to_a___lal.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_to/al[al].xml',
        FilenameNew  => 'me_to_al_al_.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_to/alal.xml',
        FilenameNew  => 'me_to_alal.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Long filename no extension - Local',
        FilenameOrig => 'a' x 250,
        FilenameNew  => 'a' x 220,
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Long filename short extension - Local',
        FilenameOrig => 'a' x 250 . '.test',
        FilenameNew  => 'a' x 215 . '.test',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Short filename long extension - Local',
        FilenameOrig => 'test.' . 'a' x 250,
        FilenameNew  => 't.' . 'a' x 218,
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Long filename no extension - 2 bytes character - Local',
        FilenameOrig => 'ß' x 250,
        FilenameNew  => 'ß' x 110,
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Long filename short extension - 2 bytes character - Local',
        FilenameOrig => 'ß' x 250 . '.test',
        FilenameNew  => 'ß' x 107 . '.test',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Short filename long extension - 2 bytes character - Local',
        FilenameOrig => 'test.' . 'ß' x 250,
        FilenameNew  => 't.' . 'ß' x 109,
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Filename ending with period - Local',
        FilenameOrig => 'abc.',
        FilenameNew  => 'abc.',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - Attachment',
        FilenameOrig => 'me_to/a+la l.xml',
        FilenameNew  => 'me_to_a+la_l.xml',
        Type         => 'Attachment',
    },
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_to/a+lal Grüße 0.xml',
        FilenameNew  => 'me_to_a+lal_Grüße_0.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - leading dots - Local',
        FilenameOrig => '....test.xml',
        FilenameNew  => 'test.xml',
        Type         => 'Local',
    },
    {
        Name         => 'FilenameCleanUp() - leading dots - Attachment',
        FilenameOrig => '....test.xml',
        FilenameNew  => 'test.xml',
        Type         => 'Attachment',
    },
    {
        Name => 'FilenameCleanUp() - Attachment',
        FilenameOrig =>
            'me_to/a+lal123456789012345678901234567890Liebe Grüße aus Straubing123456789012345678901234567890123456789012345678901234567890.xml',
        FilenameNew =>
            'me_to_a+lal123456789012345678901234567890Liebe_Gruesse_aus_Straubing123456789012345678901234567890123456789012345678901234567890.xml',
        Type => 'Attachment',
    },
    {
        Name         => 'FilenameCleanUp() - md5',
        FilenameOrig => 'some file.xml',
        FilenameNew  => '6b9e62f9a8c56a0c06c66cc716e30c45',
        Type         => 'md5',
    },
    {
        Name         => 'FilenameCleanUp() - md5',
        FilenameOrig => 'me_to/a+lal Grüße 0öäüßカスタマ.xml',
        FilenameNew  => 'c235a9eabe8494b5f90ffd1330af3407',
        Type         => 'md5',
    },
);

for my $Test (@Tests) {
    my $Filename = $MainObject->FilenameCleanUp(
        Filename => $Test->{FilenameOrig},
        Type     => $Test->{Type},
    );
    $Self->Is(
        $Filename || '',
        $Test->{FilenameNew},
        $Test->{Name},
    );
}

# md5sum tests
my $String = 'abc1234567890';
my $MD5Sum = $MainObject->MD5sum( String => \$String );
$Self->Is(
    $MD5Sum || '',
    '57041f8f7dff9b67e3f97d7facbaf8d3',
    "MD5sum() - String - abc1234567890",
);

# test charset specific situations
$String = 'abc1234567890äöüß-カスタマ';
$MD5Sum = $MainObject->MD5sum( String => \$String );

$Self->Is(
    $MD5Sum || '',
    '56a681e0c46b1f156020182cdf62e825',
    "MD5sum() - String - $String",
);

my %MD5SumOf = (
    doc => '2e520036a0cda6a806a8838b1000d9d7',
    pdf => '5ee767f3b68f24a9213e0bef82dc53e5',
    png => 'e908214e672ed20c9c3f417b82e4e637',
    txt => '0596f2939525c6bd50fc2b649e40fbb6',
    xls => '39fae660239f62bb0e4a29fe14ff5663',
);

my $Home = $ConfigObject->Get('Home');

for my $Extension (qw(doc pdf png txt xls)) {
    my $MD5Sum = $MainObject->MD5sum(
        Filename => $Home . "/scripts/test/sample/Main/Main-Test1.$Extension",
    );
    $Self->Is(
        $MD5Sum || '',
        $MD5SumOf{$Extension},
        "MD5sum() - Filename - Main-Test1.$Extension",
    );
}

my $Path = $ConfigObject->Get('TempDir');

# write & read some files via Directory/Filename
for my $Extension (qw(doc pdf png txt xls)) {
    my $MD5Sum = $MainObject->MD5sum(
        Filename => $Home . "/scripts/test/sample/Main/Main-Test1.$Extension",
    );
    my $Content = $MainObject->FileRead(
        Directory => $Home . '/scripts/test/sample/Main/',
        Filename  => "Main-Test1.$Extension",
    );
    $Self->True(
        ${$Content} || '',
        "FileRead() - Main-Test1.$Extension",
    );
    my $FileLocation = $MainObject->FileWrite(
        Directory => $Path,
        Filename  => "me_öüto/al<>?Main-Test1.$Extension",
        Content   => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $MainObject->MD5sum(
        Filename => $Path . '/' . $FileLocation,
    );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum  || '',
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $MainObject->FileDelete(
        Directory => $Path,
        Filename  => $FileLocation,
    );
    $Self->True(
        $Success || '',
        "FileDelete() - $FileLocation",
    );
}

# write & read some files via Location
for my $Extension (qw(doc pdf png txt xls)) {
    my $MD5Sum = $MainObject->MD5sum(
        Filename => $Home . "/scripts/test/sample/Main/Main-Test1.$Extension",
    );
    my $Content = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/Main/' . "Main-Test1.$Extension",
    );
    $Self->True(
        ${$Content} || '',
        "FileRead() - Main-Test1.$Extension",
    );
    my $FileLocation = $MainObject->FileWrite(
        Location => $Path . "Main-Test1.$Extension",
        Content  => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $MainObject->MD5sum( Filename => $FileLocation );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum  || '',
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $MainObject->FileDelete( Location => $FileLocation );
    $Self->True(
        $Success || '',
        "FileDelete() - $FileLocation",
    );
}

# write / read ARRAYREF test
my $Content      = "some\ntest\nöäüßカスタマ";
my $FileLocation = $MainObject->FileWrite(
    Directory => $Path,
    Filename  => "some-test.txt",
    Mode      => 'utf8',
    Content   => \$Content,
);
$Self->True(
    $FileLocation || '',
    "FileWrite() - $FileLocation",
);

my $ContentARRAYRef = $MainObject->FileRead(
    Directory => $Path,
    Filename  => $FileLocation,
    Mode      => 'utf8',
    Result    => 'ARRAY',         # optional - SCALAR|ARRAY
);
$Self->True(
    $ContentARRAYRef || '',
    "FileRead() - $FileLocation $ContentARRAYRef",
);
$Self->Is(
    $ContentARRAYRef->[0] || '',
    "some\n",
    "FileRead() [0] - $FileLocation",
);
$Self->Is(
    $ContentARRAYRef->[1] || '',
    "test\n",
    "FileRead() [1] - $FileLocation",
);
$Self->Is(
    $ContentARRAYRef->[2] || '',
    "öäüßカスタマ",
    "FileRead() [2] - $FileLocation",
);

my $Success = $MainObject->FileDelete(
    Directory => $Path,
    Filename  => $FileLocation,
);
$Self->True(
    $Success || '',
    "FileDelete() - $FileLocation",
);

# check if the file have the correct charset
my $ContentSCALARRef = $MainObject->FileRead(
    Location => $Home . '/scripts/test/sample/Main/PDF-test2-utf-8.txt',
    Mode     => 'utf8',
    Result   => 'SCALAR',
);

my $Text = ${$ContentSCALARRef};

$Self->True(
    Encode::is_utf8($Text),
    "FileRead() - Check a utf8 file - exists the utf8 flag ( $Text )",
);

$Self->True(
    Encode::is_utf8( $Text, 1 ),
    "FileRead() - Check a utf8 file - is the utf8 content wellformed ( $Text )",
);

my $FileMTime = $MainObject->FileGetMTime(
    Location => $Home . '/Kernel/Config.pm',
);

$Self->True(
    int $FileMTime > 1_000_000,
    'FileGetMTime()',
);

my $FileMTimeNonexisting = $MainObject->FileGetMTime(
    Location => $Home . '/Kernel/some.nonexisting.file',
);

$Self->False(
    defined $FileMTimeNonexisting,
    'FileGetMTime() for nonexisting file',
);

# testing DirectoryRead function
my $DirectoryWithFiles    = "$Path/WithFiles";
my $DirectoryWithoutFiles = "$Path/WithoutFiles";
my $SubDirA               = "$DirectoryWithFiles/a";
my $SubDirB               = "$DirectoryWithFiles/b";

# create needed test directories
for my $Directory ( $DirectoryWithFiles, $DirectoryWithoutFiles, $SubDirA, $SubDirB, ) {
    if ( !mkdir $Directory ) {
        $Self->True(
            0,
            "DirectoryRead() - create '$Directory': $!",
        );
    }
}

# create test files
for my $Directory ( $DirectoryWithFiles, $SubDirA, $SubDirB, ) {

    for my $Suffix (
        0 .. 5,
        'öäüßカスタマ',         # Unicode NFC
        'Второй_файл',    # Unicode NFD
        )
    {
        my $Success = $MainObject->FileWrite(
            Directory => $Directory,
            Filename  => "Example_File_$Suffix",
            Content   => \'',
        );
        $Self->True(
            $Success,
            "DirectoryRead() - create '$Directory/Example_File_$Suffix'!",
        );
    }
}

@Tests = (
    {
        Name      => 'Read directory with files, \'Example_File*\' Filter',
        Filter    => 'Example_File*',
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
        ],
    },
    {
        Name      => 'Read directory with files, \'Example_File*\' Filter, recursive',
        Filter    => 'Example_File*',
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$SubDirA/Example_File_0",
            "$SubDirA/Example_File_1",
            "$SubDirA/Example_File_2",
            "$SubDirA/Example_File_3",
            "$SubDirA/Example_File_4",
            "$SubDirA/Example_File_5",
            "$SubDirA/Example_File_öäüßカスタマ",
            "$SubDirA/Example_File_Второй_файл",
            "$SubDirB/Example_File_0",
            "$SubDirB/Example_File_1",
            "$SubDirB/Example_File_2",
            "$SubDirB/Example_File_3",
            "$SubDirB/Example_File_4",
            "$SubDirB/Example_File_5",
            "$SubDirB/Example_File_öäüßカスタマ",
            "$SubDirB/Example_File_Второй_файл",

        ],
    },
    {
        Name      => 'Read directory with files, \'XX_NOTEXIST_XX\' Filter',
        Filter    => 'XX_NOTEXIST_XX',
        Directory => $DirectoryWithFiles,
        Results   => [],
    },
    {
        Name      => 'Read directory with files, \'XX_NOTEXIST_XX\' Filter, recursive',
        Filter    => 'XX_NOTEXIST_XX',
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [],
    },
    {
        Name      => 'Read directory with files, *0 *1 *2 Filters',
        Filter    => [ '*0', '*1', '*2' ],
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
        ],
    },
    {
        Name      => 'Read directory with files, *0 *1 *2 Filters, recursive',
        Filter    => [ '*0', '*1', '*2' ],
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$SubDirA/Example_File_0",
            "$SubDirA/Example_File_1",
            "$SubDirA/Example_File_2",
            "$SubDirB/Example_File_0",
            "$SubDirB/Example_File_1",
            "$SubDirB/Example_File_2",
        ],
    },
    {
        Name      => 'Read directory with files, *0 *1 *2 Filters',
        Filter    => [ '*0', '*2', '*1', '*1', '*0', '*2' ],
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_1",
        ],
    },
    {
        Name      => 'Read directory with files, no Filter',
        Filter    => '*',
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$DirectoryWithFiles/a",
            "$DirectoryWithFiles/b",
        ],
    },
    {
        Name      => 'Read directory with files, no Filter (multiple)',
        Filter    => [ '*', '*', '*' ],
        Directory => $DirectoryWithFiles,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$DirectoryWithFiles/a",
            "$DirectoryWithFiles/b",
        ],
    },
    {
        Name      => 'Read directory with files, no Filter (multiple), recursive',
        Filter    => [ '*', '*', '*' ],
        Directory => $DirectoryWithFiles,
        Recursive => 1,
        Results   => [
            "$DirectoryWithFiles/Example_File_0",
            "$DirectoryWithFiles/Example_File_1",
            "$DirectoryWithFiles/Example_File_2",
            "$DirectoryWithFiles/Example_File_3",
            "$DirectoryWithFiles/Example_File_4",
            "$DirectoryWithFiles/Example_File_5",
            "$DirectoryWithFiles/Example_File_öäüßカスタマ",
            "$DirectoryWithFiles/Example_File_Второй_файл",
            "$DirectoryWithFiles/a",
            "$DirectoryWithFiles/b",
            "$SubDirA/Example_File_0",
            "$SubDirA/Example_File_1",
            "$SubDirA/Example_File_2",
            "$SubDirA/Example_File_3",
            "$SubDirA/Example_File_4",
            "$SubDirA/Example_File_5",
            "$SubDirA/Example_File_öäüßカスタマ",
            "$SubDirA/Example_File_Второй_файл",
            "$SubDirB/Example_File_0",
            "$SubDirB/Example_File_1",
            "$SubDirB/Example_File_2",
            "$SubDirB/Example_File_3",
            "$SubDirB/Example_File_4",
            "$SubDirB/Example_File_5",
            "$SubDirB/Example_File_öäüßカスタマ",
            "$SubDirB/Example_File_Второй_файл",
        ],
    },
    {
        Name      => 'Read directory without files, * Filter',
        Filter    => '*',
        Directory => $DirectoryWithoutFiles,
        Results   => [],
    },
    {
        Name      => 'Read directory without files, no Filter',
        Filter    => '*',
        Directory => $DirectoryWithoutFiles,
        Results   => [],
    },
    {
        Name      => 'Directory doesn\'t exists!',
        Directory => 'THIS',
        Filter    => '*',
        Results   => [],
    },
);

for my $Test (@Tests) {

    my @UnicodeResults;
    for my $Result ( @{ $Test->{Results} } ) {
        push @UnicodeResults, $EncodeObject->Convert2CharsetInternal(
            Text => $Result,
            From => 'utf-8',
        );
    }
    @UnicodeResults = sort @UnicodeResults;

    my @Results = $MainObject->DirectoryRead(
        Directory => $Test->{Directory},
        Filter    => $Test->{Filter},
        Recursive => $Test->{Recursive},
    );

    $Self->IsDeeply( \@Results, \@UnicodeResults, $Test->{Name} );
}

# delete needed test directories
for my $Directory ( $DirectoryWithFiles, $DirectoryWithoutFiles ) {
    if ( !File::Path::rmtree( [$Directory] ) ) {
        $Self->True(
            0,
            "DirectoryRead() - delete '$Directory'",
        );
    }
}

#
# Dump()
#
@Tests = (
    {
        Name             => 'Unicode dump 1',
        Source           => 'é',
        ResultDumpBinary => "\$VAR1 = 'é';\n",
        ResultDumpAscii  => '$VAR1 = "\x{e9}";' . "\n",
    },
    {
        Name             => 'Unicode dump 2',
        Source           => 'äöüßÄÖÜ€ис é í  ó',
        ResultDumpBinary => "\$VAR1 = 'äöüßÄÖÜ€ис é í  ó';\n",
        ResultDumpAscii =>
            '$VAR1 = "\x{e4}\x{f6}\x{fc}\x{df}\x{c4}\x{d6}\x{dc}\x{20ac}\x{438}\x{441} \x{e9} \x{ed}  \x{f3}";' . "\n",
    },
    {
        Name => 'Unicode dump 3',
        Source =>
            "\x{e4}\x{f6}\x{fc}\x{df}\x{c4}\x{d6}\x{dc}\x{20ac}\x{438}\x{441} \x{e9} \x{ed}  \x{f3}",
        ResultDumpBinary => "\$VAR1 = 'äöüßÄÖÜ€ис é í  ó';\n",
        ResultDumpAscii =>
            '$VAR1 = "\x{e4}\x{f6}\x{fc}\x{df}\x{c4}\x{d6}\x{dc}\x{20ac}\x{438}\x{441} \x{e9} \x{ed}  \x{f3}";' . "\n",
    },
    {
        Name             => 'Unicode dump 4',
        Source           => "Mus\x{e9}e royal de l\x{2019}Arm\x{e9}e et d\x{2019}histoire militaire",
        ResultDumpBinary => "\$VAR1 = 'Musée royal de l’Armée et d’histoire militaire';\n",
        ResultDumpAscii  => '$VAR1 = "Mus\x{e9}e royal de l\x{2019}Arm\x{e9}e et d\x{2019}histoire militaire";' . "\n",
    },
    {
        Name             => 'Unicode dump 5',
        Source           => "Antonín Dvořák",
        ResultDumpBinary => "\$VAR1 = 'Antonín Dvořák';\n",
        ResultDumpAscii  => '$VAR1 = "Anton\x{ed}n Dvo\x{159}\x{e1}k";' . "\n",
    },
    {
        Name             => 'Scalar Reference',
        Source           => \1,
        ResultDumpBinary => "\$VAR1 = \\1;\n",
        ResultDumpAscii  => "\$VAR1 = \\1;\n",
    },
    {
        Name             => 'Array Reference',
        Source           => [ 1, 2 ],
        ResultDumpBinary => "\$VAR1 = [
  1,
  2
];\n",
        ResultDumpAscii => "\$VAR1 = [
  1,
  2
];\n",
    },
    {
        Name             => 'Hash Reference',
        Source           => { 1 => 2 },
        ResultDumpBinary => "\$VAR1 = {
  '1' => 2
};\n",
        ResultDumpAscii => "\$VAR1 = {
  '1' => 2
};\n",
    },
    {
        Name             => 'JSON::PP::Boolean true Reference',
        Source           => JSON::PP::true(),
        ResultDumpBinary => q|$VAR1 = bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' );
|,
        ResultDumpAscii => q|$VAR1 = bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' );
|,
    },
    {
        Name             => 'JSON::PP::Boolean false Reference',
        Source           => JSON::PP::false(),
        ResultDumpBinary => q|$VAR1 = bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' );
|,
        ResultDumpAscii => q|$VAR1 = bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' );
|,
    },
);

for my $Test (@Tests) {
    $Self->Is(
        $MainObject->Dump( $Test->{Source} ),
        $Test->{ResultDumpBinary},
        "$Test->{Name} - Dump() result (binary)"
    );
    $Self->Is(
        $MainObject->Dump( $Test->{Source}, 'ascii' ),
        $Test->{ResultDumpAscii},
        "$Test->{Name} - Dump() result (ascii)"
    );
}

# Generate Random string test

my $Token  = $MainObject->GenerateRandomString();
my $Length = length($Token);

$Self->True(
    $Token,
    "GenerateRandomString - generated",
);

$Self->Is(
    $Length,
    16,
    "GenerateRandomString - standard size is 16",
);

$Token = $MainObject->GenerateRandomString(
    Length => 8,
);
$Length = length($Token);

$Self->True(
    $Token,
    "GenerateRandomString - 8 - generated",
);

$Self->Is(
    $Length,
    8,
    "GenerateRandomString - 8 - correct length",
);

my %Values;
my $Seen = 0;
COUNTER:
for my $Counter ( 1 .. 100_000 ) {
    my $Random = $MainObject->GenerateRandomString( Length => 16 );
    if ( $Values{$Random}++ ) {
        $Seen = 1;
        last COUNTER;
    }
}

$Self->Is(
    $Seen,
    0,
    "GenerateRandomString - no duplicates in 100k iterations",
);

# test with custom alphabet
my $NoHexChar;
COUNTER:
for my $Counter ( 1 .. 1000 ) {
    my $HexString = $MainObject->GenerateRandomString(
        Length     => 32,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],
    );
    if ( $HexString =~ m{[^0-9a-f]}xms ) {
        $NoHexChar = $HexString;
        last COUNTER;
    }
}

$Self->Is(
    $NoHexChar,
    undef,
    'Test output for hex chars in 1000 generated random strings with hex dictionary',
);

1;
