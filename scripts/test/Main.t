# --
# Main.t - Main tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Main.t,v 1.15 2010-06-15 05:00:27 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use utf8;
use Encode;
use Unicode::Normalize;

# FilenameCleanUp - tests
my @Tests = (
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_t o/alal.xml',
        FilenameNew  => 'me_t o_alal.xml',
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
        Name         => 'FilenameCleanUp() - Attachment',
        FilenameOrig => 'me_to/a+la l.xml',
        FilenameNew  => 'me_to_a+la_l.xml',
        Type         => 'Attachment',
    },
    {
        Name         => 'FilenameCleanUp() - Local',
        FilenameOrig => 'me_to/a+lal Grüße 0.xml',
        FilenameNew  => 'me_to_a+lal Grüße 0.xml',
        Type         => 'Local',
    },
    {
        Name => 'FilenameCleanUp() - Attachment',
        FilenameOrig =>
            'me_to/a+lal123456789012345678901234567890Liebe Grüße aus Straubing123456789012345678901234567890123456789012345678901234567890.xml',
        FilenameNew =>
            'me_to_a+lal123456789012345678901234567890Liebe_Gruesse_aus_Straubing123456789012345678901234567.xml',
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
    my $Filename = $Self->{MainObject}->FilenameCleanUp(
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
my $MD5Sum = $Self->{MainObject}->MD5sum(
    String => \$String,
);
$Self->Is(
    $MD5Sum || '',
    '57041f8f7dff9b67e3f97d7facbaf8d3',
    "MD5sum() - String - abc1234567890",
);

# test charset specific situations
my $Charset = $Self->{ConfigObject}->Get('DefaultCharset');
if ( $Charset eq 'utf-8' ) {
    $String = 'abc1234567890äöüß-カスタマ';
    $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$String,
    );

    $Self->Is(
        $MD5Sum || '',
        '56a681e0c46b1f156020182cdf62e825',
        "MD5sum() - String - $String",
    );
}
elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
    no utf8;
    $String = 'bc1234567890\xd6\xc4\xdc\xe4\xfc\xf6';
    $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$String,
    );

    $Self->Is(
        $MD5Sum || '',
        'f528f84187c4ca0e6fc9c4a937dbf9bb',
        "MD5sum() - String - $String",
    );
}

my %MD5SumOf = (
    doc => '2e520036a0cda6a806a8838b1000d9d7',
    pdf => '5ee767f3b68f24a9213e0bef82dc53e5',
    png => 'e908214e672ed20c9c3f417b82e4e637',
    txt => '0596f2939525c6bd50fc2b649e40fbb6',
    xls => '39fae660239f62bb0e4a29fe14ff5663',
);

for my $Extention (qw(doc pdf png txt xls)) {
    my $MD5Sum = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('Home')
            . "/scripts/test/sample/Main/Main-Test1.$Extention",
    );
    $Self->Is(
        $MD5Sum || '',
        $MD5SumOf{$Extention},
        "MD5sum() - Filename - Main-Test1.$Extention",
    );
}

# write & read some files via Directory/Filename
for my $Extention (qw(doc pdf png txt xls)) {
    my $MD5Sum = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('Home')
            . "/scripts/test/sample/Main/Main-Test1.$Extention",
    );
    my $Content = $Self->{MainObject}->FileRead(
        Directory => $Self->{ConfigObject}->Get('Home') . '/scripts/test/sample/Main/',
        Filename  => "Main-Test1.$Extention",
    );
    $Self->True(
        ${$Content} || '',
        "FileRead() - Main-Test1.$Extention",
    );
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory => $Self->{ConfigObject}->Get('TempDir'),
        Filename  => "me_öüto/al<>?Main-Test1.$Extention",
        Content   => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('TempDir') . '/' . $FileLocation,
    );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum  || '',
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $Self->{MainObject}->FileDelete(
        Directory => $Self->{ConfigObject}->Get('TempDir'),
        Filename  => $FileLocation,
    );
    $Self->True(
        $Success || '',
        "FileDelete() - $FileLocation",
    );
}

# write & read some files via Location
for my $Extention (qw(doc pdf png txt xls)) {
    my $MD5Sum = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('Home')
            . "/scripts/test/sample/Main/Main-Test1.$Extention",
    );
    my $Content = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home')
            . '/scripts/test/sample/Main/'
            . "Main-Test1.$Extention",
    );
    $Self->True(
        ${$Content} || '',
        "FileRead() - Main-Test1.$Extention",
    );
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Location => $Self->{ConfigObject}->Get('TempDir') . "Main-Test1.$Extention",
        Content  => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $Self->{MainObject}->MD5sum(
        Filename => $FileLocation,
    );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum  || '',
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $Self->{MainObject}->FileDelete(
        Location => $FileLocation,
    );
    $Self->True(
        $Success || '',
        "FileDelete() - $FileLocation",
    );
}

# write / read ARRAYREF test
my $Content      = "some\ntest\nöäüßカスタマ";
my $FileLocation = $Self->{MainObject}->FileWrite(
    Directory => $Self->{ConfigObject}->Get('TempDir'),
    Filename  => "some-test.txt",
    Mode      => 'utf8',
    Content   => \$Content,
);
$Self->True(
    $FileLocation || '',
    "FileWrite() - $FileLocation",
);

my $ContentARRAYRef = $Self->{MainObject}->FileRead(
    Directory => $Self->{ConfigObject}->Get('TempDir'),
    Filename  => $FileLocation,
    Mode      => 'utf8',
    Result    => 'ARRAY',                                 # optional - SCALAR|ARRAY
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

my $Success = $Self->{MainObject}->FileDelete(
    Directory => $Self->{ConfigObject}->Get('TempDir'),
    Filename  => $FileLocation,
);
$Self->True(
    $Success || '',
    "FileDelete() - $FileLocation",
);

# check if the file have the correct charset
my $ContentSCALARRef = $Self->{MainObject}->FileRead(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/scripts/test/sample/Main/PDF-test2-utf-8.txt',
    Mode   => 'utf8',
    Result => 'SCALAR',
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

my $FileMTime = $Self->{MainObject}->FileGetMTime(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/Kernel/Config.pm',
);

$Self->True(
    int $FileMTime > 1_000_000,
    'FileGetMTime()',
);

my $FileMTimeNonexisting = $Self->{MainObject}->FileGetMTime(
    Location => $Self->{ConfigObject}->Get('Home')
        . '/Kernel/some.nonexisting.file',
);

$Self->False(
    defined $FileMTimeNonexisting,
    'FileGetMTime() for nonexisting file',
);

# -------------------------------------
# testing DirectoryRead function

my $Path = $Self->{ConfigObject}->Get('TempDir');

# creating needed test stuff
if ( !-d "$Path/WithFiles" ) {
    mkdir "$Path/WithFiles" or
        $Self->{LogObject}->Log(
        Message  => "Main test: $!",
        Priority => 'error',
        );
}

if ( !-d "$Path/WithoutFiles" ) {
    mkdir "$Path/WithoutFiles" or
        $Self->{LogObject}->Log(
        Message  => "Main test: $!",
        Priority => 'error',
        );
}

my $DirectoryWithFiles    = "$Path/WithFiles";
my $DirectoryWithoutFiles = "$Path/WithoutFiles";

my @FileNames;
my @FileContent;

for my $Number ( 0 .. 5 ) {
    push @FileNames,   "Example_File_$Number";
    push @FileContent, "This is the content $Number";

    if ( $DirectoryWithFiles && !-e "$DirectoryWithFiles/$Number" ) {
        $Self->{MainObject}->FileWrite(
            Directory => "$DirectoryWithFiles",
            Filename  => "Example_File_$Number",
            Content   => \$FileContent[$Number],
        );
    }
}

{

    my $TestName = 'Read directory with files, \'Example_File*\' Filter';

    #--
    my @TestResults;
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithFiles,
        Filter    => "Example_File*",
    );
    $Self->True( scalar @TestResults, $TestName );
}

{

    my $TestName = 'Read directory with files, \'XX_NOTEXIST_XX\' wrong Filter';

    #--
    my @TestResults;
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithFiles,
        Filter    => "XX_NOTEXIST_XX",
    );
    $Self->False( scalar @TestResults, $TestName );
}

{

    my $TestName = 'Read directory with files, *0 *1 *2 Filters';

    #--
    my @TestResults;
    my @Filter = qw( *0 *1 *2 );
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithFiles,
        Filter    => \@Filter,
    );

    my @CorrectResults = qw (Example_File_0 Example_File_1 Example_File_2);
    @CorrectResults = sort @CorrectResults;
    @TestResults    = sort @TestResults;

    my $Test           = 1;
    my $CorrectResults = scalar @CorrectResults;
    if ( scalar @TestResults ) {
        if ( scalar @CorrectResults eq scalar @TestResults ) {
            for my $Index ( 0 .. $CorrectResults ) {
                if ( $TestResults[$Index] && $TestResults[$Index] ne $CorrectResults[$Index] ) {
                    $Test = 0;
                }
            }
        }
        else {
            $Test = 0;
        }
    }
    else {
        $Test = 0;
    }

    $Self->True( $Test, $TestName );
}

{

    my $TestName = 'Read directory with files, no Filter';

    #--
    my @TestResults;
    @TestResults = $Self->{MainObject}->DirectoryRead( Directory => $DirectoryWithFiles, );
    $Self->True( scalar @TestResults, $TestName );
}

{

    my $TestName = 'Read directory without files, * Filter';

    #--
    my @TestResults;
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithoutFiles,
        Filter    => '*',
    );
    $Self->False( scalar @TestResults, $TestName );
}

{

    my $TestName = "Read directory without files, no Filter";

    #--
    my @TestResults;
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithoutFiles,
        Filter    => '*',
    );
    $Self->False( scalar @TestResults, $TestName );
}

{

    my $TestName = 'Read directory without files, *0 *1 *2 Filters';

    #--
    my @TestResults;
    my @Filter = qw( *0 *1 *2 );
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithoutFiles,
        Filter    => \@Filter,
    );

    my @CorrectResults = qw (Example_File_0 Example_File_1 Example_File_2);
    @CorrectResults = sort @CorrectResults;
    @TestResults    = sort @TestResults;

    $Self->False( scalar @TestResults, $TestName );
}

{

    my $TestName = "Directory doesn't exists!";

    #--
    my @TestResults;
    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => "THIS",
        Filter    => '*',
    );
    $Self->False( scalar @TestResults, $TestName );
}

# testing unicode normalizing results
# http://www.unicode.org/Public/UNIDATA/NormalizationTest.txt

# Characters to test enconded with utf8
my @Chars = (
    Encode::encode( 'UTF8', "\x{FB01}" ),              # LATIN SMALL LIGATURE FI
    Encode::encode( 'UTF8', "\x{73}\x{323}\x{307}" )
    ,    # LATIN SMALL LETTER S WITH DOT BELOW AND DOT ABOVE
    Encode::encode( 'UTF8', "\x{1100}\x{1161}\x{11A8}" ),    # HANGUL SYLLABLE GAG
    Encode::encode( 'UTF8', "\x{41}\x{308}" ),               # LATIN CAPITAL LETTER A WITH DIAERESIS
    Encode::encode( 'UTF8', "\x{4E}\x{303}" ),               # LATIN CAPITAL LETTER N WITH TILDE
);

my @FNamesChars;
my @FContentChars;

my $Counter = 0;
for my $Char (@Chars) {
    push @FNamesChars, ( Encode::encode( 'UTF8', "Example_File_" ) . $Char );
    push @FContentChars, "This is the content $Char";

    if ( $DirectoryWithFiles && !-e "$DirectoryWithFiles/$FNamesChars[$Counter]" ) {
        $Self->{MainObject}->FileWrite(
            Directory => "$DirectoryWithFiles",
            Filename  => "$FNamesChars[$Counter]",
            Content   => \$FContentChars[$Counter],
        );
    }
    $Counter++;
}

{
    my @TestResults;
    my @Filters = @Chars;

    my $TestName = "Get normalized filenames looking with not normalized Filter: @Filters";

    #--

    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithFiles,
        Filter    => \@Filters,
    );

    my @CorrectResults = @FNamesChars;

    @CorrectResults = sort @CorrectResults;
    @TestResults    = sort @TestResults;

    my $Test = 1;
    if ( scalar @TestResults ) {
        if ( scalar @CorrectResults eq scalar @TestResults ) {
            for my $Index ( 0 .. scalar @CorrectResults ) {
                if ( $TestResults[$Index] && $TestResults[$Index] ne $CorrectResults[$Index] ) {
                    $Test = 0;
                }
            }
        }
        else {
            $Test = 0;
        }
    }
    else {
        $Test = 0;
    }
    $Self->True( $Test, $TestName );
}
{
    my @TestResults;
    my @Filters = @Chars;

    my $TestName = "Get normalized filenames and comparing with normalized characters";

    @TestResults = $Self->{MainObject}->DirectoryRead(
        Directory => $DirectoryWithFiles,
        Filter    => \@Filters,
    );

    my @NormalizedChars;
    for my $ToNormalize (@Chars) {
        push @NormalizedChars, Unicode::Normalize::normalize( "NFC", $ToNormalize );
    }

    # filtering results, deleting part of name to compare character
    my $Counter = 0;
    for my $Result (@TestResults) {
        $TestResults[$Counter] =~ s{\A(?:.*\_.*\_)(.*)\z}{$1}xms;
        $Counter++;
    }

    my @CorrectResults = @FNamesChars;

    @CorrectResults = sort @NormalizedChars;
    @TestResults    = sort @TestResults;

    my $Test = 1;
    if ( scalar @TestResults ) {
        if ( scalar @CorrectResults eq scalar @TestResults ) {
            for my $Index ( 0 .. scalar @CorrectResults ) {
                if ( $TestResults[$Index] && $TestResults[$Index] ne $CorrectResults[$Index] ) {
                    $Test = 0;
                }
            }
        }
        else {
            $Test = 0;
        }
    }
    else {
        $Test = 0;
    }
    $Self->True( $Test, $TestName );
}
1;
