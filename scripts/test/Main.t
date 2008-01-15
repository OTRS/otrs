# --
# Main.t - Main tests
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: Main.t,v 1.3.2.2 2008-01-15 14:55:16 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use utf8;

# FilenameCleanUp
my $Filename1 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_t o/alal.xml',
    Type => 'Local',
);
$Self->Is(
    $Filename1 || '',
    'me_t o_alal.xml',
    '#1 FilenameCleanUp() - Local',
);

my $Filename2 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/al?al"l.xml',
    Type => 'Local',
);
$Self->Is(
    $Filename2 || '',
    'me_to_al_al_l.xml',
    '#2 FilenameCleanUp() - Local',
);

my $Filename3 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/a\/\\lal.xml',
    Type => 'Local',
);
$Self->Is(
    $Filename3 || '',
    'me_to_a___lal.xml',
    '#3 FilenameCleanUp() - Local',
);

my $Filename4 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/al[al].xml',
    Type => 'Local',
);
$Self->Is(
    $Filename4 || '',
    'me_to_al_al_.xml',
    '#4 FilenameCleanUp() - Local',
);

my $Filename5 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/alal.xml',
    Type => 'Local',
);
$Self->Is(
    $Filename5 || '',
    'me_to_alal.xml',
    '#5 FilenameCleanUp() - Local',
);

my $Filename6 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/a+la l.xml',
    Type => 'Attachment',
);
$Self->Is(
    $Filename6 || '',
    'me_to_a+la_l.xml',
    '#6 FilenameCleanUp() - Attachment',
);

my $Filename7 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/a+lal Grüße 0.xml',
    Type => 'Local',
);
$Self->Is(
    $Filename7 || '',
    'me_to_a+lal Grüße 0.xml',
    '#7 FilenameCleanUp() - Local',
);

my $Filename8 = $Self->{MainObject}->FilenameCleanUp(
    Filename => 'me_to/a+lal123456789012345678901234567890Liebe Grüße aus Straubing123456789012345678901234567890123456789012345678901234567890.xml',
    Type => 'Attachment',
);
$Self->Is(
    $Filename8 || '',
    'me_to_a+lal123456789012345678901234567890Liebe_Gruesse_aus_Straubing123456789012345678901234567.xml',
    '#8 FilenameCleanUp() - Attachment',
);

# md5sum tests
my $String = "abc1234567890";
my $MD5Sum = $Self->{MainObject}->MD5sum(
   String => \$String,
);
$Self->Is(
    $MD5Sum || '',
    '57041f8f7dff9b67e3f97d7facbaf8d3',
    "#9 MD5sum() - String - abc1234567890",
);

# test charset specific situations
my $Charset = $Self->{ConfigObject}->Get('DefaultCharset');
if ($Charset eq 'utf-8') {
    $String = 'abc1234567890äöüß-カスタマ';
    $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$String,
    );

    $Self->Is(
        $MD5Sum || '',
        '56a681e0c46b1f156020182cdf62e825',
        "#9 MD5sum() - String - abc1234567890äöüß-カスタマ",
    );
}
elsif ($Charset eq 'iso-8859-1' || $Charset eq 'iso-8859-15') {
    no utf8;
    $String = 'bc1234567890������';
    $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$String,
    );

    $Self->Is(
        $MD5Sum || '',
        'f528f84187c4ca0e6fc9c4a937dbf9bb',
        "#9 MD5sum() - String - $String",
    );

}

my %MD5SumOf = (
    doc => '2e520036a0cda6a806a8838b1000d9d7',
    pdf => '5ee767f3b68f24a9213e0bef82dc53e5',
    png => 'e908214e672ed20c9c3f417b82e4e637',
    txt => '0596f2939525c6bd50fc2b649e40fbb6',
    xls => '39fae660239f62bb0e4a29fe14ff5663',
);

foreach my $Extention (qw(doc pdf png txt xls)) {
    my $MD5Sum = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('Home')."/scripts/test/sample/Main-Test1.$Extention",
    );

    $Self->Is(
        $MD5Sum || '',
        $MD5SumOf{$Extention},
        "#10 MD5sum() - Filename - Main-Test1.$Extention",
    );
}

# write & read some files via Directory/Filename
foreach my $Extention (qw(doc pdf png txt xls)) {
    my $MD5Sum = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('Home')."/scripts/test/sample/Main-Test1.$Extention",
    );
    my $Content = $Self->{MainObject}->FileRead(
        Directory => $Self->{ConfigObject}->Get('Home').'/scripts/test/sample/',
        Filename => "Main-Test1.$Extention",
    );
    $Self->True(
        ${$Content} || '',
        "#11 FileRead() - Main-Test1.$Extention",
    );
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory => $Self->{ConfigObject}->Get('TempDir'),
        Filename => "me_öüto/al<>?Main-Test1.$Extention",
        Content => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "#11 FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('TempDir').'/'.$FileLocation,
    );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum || '',
        "#11 MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $Self->{MainObject}->FileDelete(
        Directory => $Self->{ConfigObject}->Get('TempDir'),
        Filename => $FileLocation,
    );
    $Self->True(
        $Success || '',
        "#11 FileDelete() - $FileLocation",
    );
}

# write & read some files via Location
foreach my $Extention (qw(doc pdf png txt xls)) {
    my $MD5Sum = $Self->{MainObject}->MD5sum(
        Filename => $Self->{ConfigObject}->Get('Home')."/scripts/test/sample/Main-Test1.$Extention",
    );
    my $Content = $Self->{MainObject}->FileRead(
        Location => $Self->{ConfigObject}->Get('Home').'/scripts/test/sample/'."Main-Test1.$Extention",
    );
    $Self->True(
        ${$Content} || '',
        "#12 FileRead() - Main-Test1.$Extention",
    );
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Location => $Self->{ConfigObject}->Get('TempDir')."Main-Test1.$Extention",
        Content => $Content,
    );
    $Self->True(
        $FileLocation || '',
        "#12 FileWrite() - $FileLocation",
    );
    my $MD5Sum2 = $Self->{MainObject}->MD5sum(
        Filename => $FileLocation,
    );
    $Self->Is(
        $MD5Sum2 || '',
        $MD5Sum || '',
        "#12 MD5sum()>FileWrite()>MD5sum() - $FileLocation",
    );
    my $Success = $Self->{MainObject}->FileDelete(
        Location => $FileLocation,
    );
    $Self->True(
        $Success || '',
        "#12 FileDelete() - $FileLocation",
    );
}

# write / read ARRAYREF test
my $Content = "some\ntest\nöäüßカスタマ";
my $FileLocation = $Self->{MainObject}->FileWrite(
    Directory => $Self->{ConfigObject}->Get('TempDir'),
    Filename => "some-test.txt",
    Mode => 'utf8',
    Content => \$Content,
);
$Self->True(
    $FileLocation || '',
    "#13 FileWrite() - $FileLocation",
);

my $ContentARRAYRef = $Self->{MainObject}->FileRead(
    Directory => $Self->{ConfigObject}->Get('TempDir'),
    Filename => $FileLocation,
    Mode => 'utf8',
    Result => 'ARRAY', # optional - SCALAR|ARRAY
);
$Self->True(
    $ContentARRAYRef || '',
    "#13 FileRead() - $FileLocation $ContentARRAYRef",
);
$Self->Is(
    $ContentARRAYRef->[0] || '',
   "some\n",
    "#13 FileRead() [0] - $FileLocation",
);
$Self->Is(
    $ContentARRAYRef->[1] || '',
   "test\n",
    "#13 FileRead() [1] - $FileLocation",
);
$Self->Is(
    $ContentARRAYRef->[2] || '',
    "öäüßカスタマ",
    "#13 FileRead() [2] - $FileLocation",
);

my $Success = $Self->{MainObject}->FileDelete(
    Directory => $Self->{ConfigObject}->Get('TempDir'),
    Filename => $FileLocation,
);
$Self->True(
    $Success || '',
    "#13 FileDelete() - $FileLocation",
);

1;
