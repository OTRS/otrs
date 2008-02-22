# --
# EmailParser.t - email parser tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: EmailParser.t,v 1.11 2008-02-22 21:32:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use utf8;
use Kernel::System::EmailParser;

my $Home = $Self->{ConfigObject}->Get('Home');

# test #1
my @Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test1.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);

$Self->Is(
    $Self->{EmailParserObject}->GetParam(WHAT => 'To'),
    'darthvader@otrs.org',
    "#1 GetParam(WHAT => 'To')",
);

$Self->Is(
    $Self->{EmailParserObject}->GetParam(WHAT => 'From'),
    'Skywalker Attachment <skywalker@otrs.org>',
    "#1 GetParam(WHAT => 'From')",
);

$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'us-ascii',
    "#1 GetCharset()",
);

my @Attachments = $Self->{EmailParserObject}->GetAttachments();
$Self->False(
    $Attachments[1]->{Filename} || '',
    "#1 GetAttachments() - no attachments",
);

# test #2
my @Addresses = $Self->{EmailParserObject}->SplitAddressLine(
    Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber)',
);

$Self->Is(
    $Addresses[2],
    'hans@example.com (Hans Huber)',
    "#2 SplitAddressLine()",
);
$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen.qeber@air.com>'),
    'juergen.qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen+qeber@air.com>'),
    'juergen+qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'Juergen Weber <juergen+qeber@air.com> (Comment)'),
    'juergen+qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $Self->{EmailParserObject}->GetEmailAddress(Email => 'juergen+qeber@air.com (Comment)'),
    'juergen+qeber@air.com',
    "#1 GetEmailAddress()",
);

# test #3
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test3.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'UTF-8',
    "#3 GetCharset()",
);
@Attachments = $Self->{EmailParserObject}->GetAttachments();
my $MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    '4e78ae6bffb120669f50bca56965f552',
    "#3 md5 check",
);
if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /utf/i) {
    $Self->Is(
        $Attachments[1]->{Filename},
        'utf-8-file-äöüß-カスタマ.txt',
        "#3 GetAttachments()",
    );
}

# test #4
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test4.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'iso-8859-15',
    "#4 GetCharset()",
);
if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /utf/i) {
    $Self->Is(
        $Self->{EmailParserObject}->GetParam(WHAT => 'From'),
        'Hans BÄKOSchönland <me@bogen.net>',
        "#4 From()",
    );
    $Self->Is(
        $Self->{EmailParserObject}->GetParam(WHAT => 'To'),
        'Namedyński (hans@example.com)',
        "#4 To()",
    );
    $Self->Is(
        $Self->{EmailParserObject}->GetParam(WHAT => 'Subject'),
        'utf8: 使って / ISO-8859-1: Priorität"  / cp-1251: Сергей Углицких',
        "#4 Subject()",
    );
}

# match values
my %Match = (
    "Test1:".chr(8211) => 0,
    "Test2:&" => 0,
    "Test3:".chr(8715) => 0,
    "Test4:&" => 0,
    "Test5:".chr(hex("3d")) => 0,
    "Compare Cable, DSL or Satellite" => 0,
);
for my $Key (sort keys %Match) {
    if ( $Self->{EmailParserObject}->GetMessageBody() =~ /$Key/ ) {
        $Match{$Key} = 1;
    }
    $Self->True(
        $Match{$Key},
        "#4 html2ascii - Body match - $Key",
    );
}

# match values not
my %MatchNot = (
    "style" => 0,
    "background" => 0,
    "br" => 0,
    "div" => 0,
    "html" => 0,
);
for my $Key (sort keys %MatchNot) {
    if ( $Self->{EmailParserObject}->GetMessageBody() !~ /$Key/ ) {
        $MatchNot{$Key} = 1;
    }
    $Self->True(
        $MatchNot{$Key},
        "#4 html2ascii - Body match not - $Key",
    );
}

# test #5
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test5.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'iso-8859-1',
    "#5 GetCharset()",
);
@Attachments = $Self->{EmailParserObject}->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    '0596f2939525c6bd50fc2b649e40fbb6',
    "#5 md5 check",
);
$Self->Is(
    $Attachments[1]->{Filename},
    'test-attachment-äöüß-iso-8859-1.txt',
    "#5 GetAttachments()",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[2]->{Content} ) || '';
$Self->Is(
    $MD5,
    'bb29962e132ba159539f1e88b41663b1',
    "#5 md5 check",
);
$Self->Is(
    $Attachments[2]->{Filename},
    'test-attachment-äöüß-utf-8.txt',
    "#5 GetAttachments()",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[3]->{Content} ) || '';
$Self->Is(
    $MD5,
    '5ee767f3b68f24a9213e0bef82dc53e5',
    "#5 md5 check",
);
$Self->Is(
    $Attachments[3]->{Filename},
    'test-attachment-äöüß.pdf',
    "#5 GetAttachments()",
);

# test #6
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test6.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'utf-8',
    "#6 GetCharset()",
);
@Attachments = $Self->{EmailParserObject}->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    '5ee767f3b68f24a9213e0bef82dc53e5',
    "#6 md5 check",
);
if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /utf/i) {
    $Self->Is(
        $Attachments[1]->{Filename},
        'test-attachment-äöüß.pdf',
        "#6 GetAttachments()",
    );
}
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[2]->{Content} ) || '';
$Self->Is(
    $MD5,
    'bb29962e132ba159539f1e88b41663b1',
    "#6 md5 check",
);
if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /utf/i) {
    $Self->Is(
        $Attachments[2]->{Filename},
        'test-attachment-äöüß-utf-8.txt',
        "#6 GetAttachments()",
    );
}
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[3]->{Content} ) || '';
$Self->Is(
    $MD5,
    '0596f2939525c6bd50fc2b649e40fbb6',
    "#6 md5 check",
);
if ($Self->{ConfigObject}->Get('DefaultCharset') =~ /utf/i) {
    $Self->Is(
        $Attachments[3]->{Filename},
        'test-attachment-äöüß-iso-8859-1.txt',
        "#6 GetAttachments()",
    );
}

# test #7
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test7.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'iso-8859-1',
    "#7 GetCharset()",
);
@Attachments = $Self->{EmailParserObject}->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    '5ee767f3b68f24a9213e0bef82dc53e5',
    "#7 md5 check",
);
$Self->Is(
    $Attachments[1]->{Filename},
    'test-attachment-äöüß.pdf',
    "#7 GetAttachments()",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[2]->{Content} ) || '';
$Self->Is(
    $MD5,
    'bb29962e132ba159539f1e88b41663b1',
    "#7 md5 check",
);
$Self->Is(
    $Attachments[2]->{Filename},
    'test-attachment-äöüß-utf-8.txt',
    "#7 GetAttachments()",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[3]->{Content} ) || '';
$Self->Is(
    $MD5,
    '0596f2939525c6bd50fc2b649e40fbb6',
    "#7 md5 check",
);
$Self->Is(
    $Attachments[3]->{Filename},
    'test-attachment-äöüß-iso-8859-1.txt',
    "#7 GetAttachments()",
);

# test #8
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test8.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    '',
    "#8 GetCharset() - no charset should be found (non text body)",
);

my $Body = $Self->{EmailParserObject}->GetMessageBody();
@Attachments = $Self->{EmailParserObject}->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Body ) || '';

$Self->Is(
    $MD5,
    '5ee767f3b68f24a9213e0bef82dc53e5',
    "#8 md5 check",
);

$Self->True(
    !$Attachments[0] || 0,
    "#8 no attachment check",
);

# test #9
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test9.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'us-ascii',
    "#9 GetCharset() - us-ascii charset should be found",
);

@Attachments = $Self->{EmailParserObject}->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[0]->{Content} ) || '';

$Self->Is(
    $MD5,
    '5ee767f3b68f24a9213e0bef82dc53e5',
    "#9 md5 check",
);

$Self->True(
    $Attachments[0] || 0,
    "#9 attachment check #1",
);

$Self->True(
    !$Attachments[1] || 0,
    "#9 attachment check #2",
);

# test #10
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test10.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'iso-8859-1',
    "#10 GetCharset() - iso-8859-1 charset should be found",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $Self->{EmailParserObject}->GetMessageBody()  ) || '';
$Self->Is(
    $MD5,
    '7ddc731e5a3e76cd27d4b1e0628468b1',
    "#10 md5 body check",
);

@Attachments = $Self->{EmailParserObject}->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[0]->{Content} ) || '';
$Self->Is(
    $MD5,
    '7ddc731e5a3e76cd27d4b1e0628468b1',
    "#10 md5 check",
);

$Self->True(
    $Attachments[0] || 0,
    "#10 attachment check #1",
);

$Self->True(
    $Attachments[1] || 0,
    "#10 attachment check #2",
);

$Self->True(
    $Attachments[2] || 0,
    "#10 attachment check #3",
);

$Self->True(
    !$Attachments[3] || 0,
    "#10 attachment check #4",
);

# test #11
@Array = ();
open(IN, "< $Home/scripts/test/sample/PostMaster-Test11.box");
while (<IN>) {
    push(@Array, $_);
}
close (IN);

$Self->{EmailParserObject} = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $Self->{EmailParserObject}->GetCharset(),
    'ISO-8859-1',
    "#11 GetCharset() - iso-8859-1 charset should be found",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $Self->{EmailParserObject}->GetMessageBody()  ) || '';
$Self->Is(
    $MD5,
    '52f20c90a1f0d8cf3bd415e278992001',
    "#11 md5 body check",
);

@Attachments = $Self->{EmailParserObject}->GetAttachments();
$Self->True(
    !$Attachments[0] || 0,
    "#11 attachment check #0",
);

1;
