# --
# Main.t - Main tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Main.t,v 1.23.2.1 2011-03-07 11:55:27 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;
use Encode;
use File::Path;
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
my $MD5Sum = $Self->{MainObject}->MD5sum( String => \$String );
$Self->Is(
    $MD5Sum || '',
    '57041f8f7dff9b67e3f97d7facbaf8d3',
    "MD5sum() - String - abc1234567890",
);

# test charset specific situations
my $Charset = $Self->{ConfigObject}->Get('DefaultCharset');
if ( $Charset eq 'utf-8' ) {
    $String = 'abc1234567890äöüß-カスタマ';
    $MD5Sum = $Self->{MainObject}->MD5sum( String => \$String );

    $Self->Is(
        $MD5Sum || '',
        '56a681e0c46b1f156020182cdf62e825',
        "MD5sum() - String - $String",
    );
}
elsif ( $Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15' ) {
    no utf8;
    $String = 'bc1234567890\xd6\xc4\xdc\xe4\xfc\xf6';
    $MD5Sum = $Self->{MainObject}->MD5sum( String => \$String );

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

# on Win32 we have Windows style line endings for the .txt file.
# this causes a different md5sum then when run on Linux.

if ( $^O =~ 'MSWin' ) {
    $MD5SumOf{txt} = '930d6f64fb8949ce4ddceb4ab45b1d2e';
}

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
    my $MD5Sum2 = $Self->{MainObject}->MD5sum( Filename => $FileLocation );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum  || '',
        "MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $Self->{MainObject}->FileDelete( Location => $FileLocation );
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

# testing DirectoryRead function
my $Path                  = $Self->{ConfigObject}->Get('TempDir');
my $DirectoryWithFiles    = "$Path/WithFiles";
my $DirectoryWithoutFiles = "$Path/WithoutFiles";

# create needed test directories
for my $Directory ( $DirectoryWithFiles, $DirectoryWithoutFiles ) {
    if ( !mkdir $Directory ) {
        $Self->True(
            0,
            "DirectoryRead() - create '$Directory': $!",
        );
    }
}

# create test files
for my $Suffix ( 0 .. 5, 'öäüßカスタマ' ) {
    my $Success = $Self->{MainObject}->FileWrite(
        Directory => $DirectoryWithFiles,
        Filename  => "Example_File_$Suffix",
        Content   => \'',
    );
    $Self->True(
        $Success,
        "DirectoryRead() - create '$DirectoryWithFiles/Example_File_$Suffix'!",
    );
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
        ],
    },
    {
        Name      => 'Read directory with files, \'XX_NOTEXIST_XX\' Filter',
        Filter    => 'XX_NOTEXIST_XX',
        Directory => $DirectoryWithFiles,
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
        push @UnicodeResults, $Self->{EncodeObject}->Convert2CharsetInternal(
            Text => $Result,
            From => 'utf-8',
        );
    }
    @UnicodeResults = sort @UnicodeResults;

    my @Results = $Self->{MainObject}->DirectoryRead(
        Directory => $Test->{Directory},
        Filter    => $Test->{Filter},
    );

    #use Data::Dumper;
    #print STDERR "Dump: " . Dumper(\@Results) . "\n";
    #print STDERR "Dump: " . Dumper(\@UnicodeResults) . "\n";

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

1;
