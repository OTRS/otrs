# --
# EmailParser.t - email parser tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

# test #1
my @Array = ();
open( my $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test1.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

# create local object
my $EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);

$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'To' ),
    'darthvader@otrs.org',
    "#1 GetParam(WHAT => 'To')",
);

$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'From' ),
    'Skywalker Attachment <skywalker@otrs.org>',
    "#1 GetParam(WHAT => 'From')",
);

$Self->Is(
    $EmailParserObject->GetCharset(),
    'us-ascii',
    "#1 GetCharset()",
);

my @Attachments = $EmailParserObject->GetAttachments();
$Self->False(
    $Attachments[1]->{Filename} || '',
    "#1 GetAttachments() - no attachments",
);

# test #2
my @Addresses = $EmailParserObject->SplitAddressLine(
    Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber),
        Juergen "quoted name" Weber <juergen.qeber@air.com>',
);

$Self->Is(
    $Addresses[2],
    'hans@example.com (Hans Huber)',
    "#2 SplitAddressLine()",
);

$Self->Is(
    $Addresses[3],
    'Juergen "quoted name" Weber <juergen.qeber@air.com>',
    "#2 SplitAddressLine() with quoted name",
);

$Self->Is(
    $EmailParserObject->GetEmailAddress( Email => 'Juergen Weber <juergen.qeber@air.com>' ),
    'juergen.qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $EmailParserObject->GetEmailAddress( Email => 'Juergen Weber <juergen+qeber@air.com>' ),
    'juergen+qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $EmailParserObject->GetEmailAddress(
        Email => 'Juergen Weber <juergen+qeber@air.com> (Comment)'
    ),
    'juergen+qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $EmailParserObject->GetEmailAddress( Email => 'juergen+qeber@air.com (Comment)' ),
    'juergen+qeber@air.com',
    "#1 GetEmailAddress()",
);

$Self->Is(
    $EmailParserObject
        ->GetRealname( Email => '"Juergen "quoted name" Weber" <juergen.qeber@air.com>' ),
    'Juergen "quoted name" Weber',
    "#1 GetRealname() with quoted name",
);

$Self->Is(
    $EmailParserObject
        ->GetRealname( Email => '"Juergen " quoted name " Weber" <juergen.qeber@air.com>' ),
    'Juergen "quoted name" Weber',
    "#1 GetRealname() with quoted name",
);

# test #3
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test3.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'UTF-8',
    "#3 GetCharset()",
);
@Attachments = $EmailParserObject->GetAttachments();
my $MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    '4e78ae6bffb120669f50bca56965f552',
    "#3 md5 check",
);
$Self->Is(
    $Attachments[1]->{Filename},
    'utf-8-file-äöüß-カスタマ.txt',
    "#3 GetAttachments()",
);

# test #4
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test4.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'iso-8859-15',
    "#4 GetCharset()",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'From' ),
    'Hans BÄKOSchönland <me@bogen.net>',
    "#4 From()",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'To' ),
    'Namedyński (hans@example.com)',
    "#4 To()",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'Subject' ),
    'utf8: 使って / ISO-8859-1: Priorität"  / cp-1251: Сергей Углицких',
    "#4 Subject()",
);

# match values
my %Match = (
    "Test1:" . chr(8211)              => 0,
    "Test2:&"                         => 0,
    "Test3:" . chr(8715)              => 0,
    "Test4:&"                         => 0,
    "Test5:" . chr( hex("3d") )       => 0,
    "Compare Cable, DSL or Satellite" => 0,
);
for my $Key ( sort keys %Match ) {
    if ( $EmailParserObject->GetMessageBody() =~ /$Key/ ) {
        $Match{$Key} = 1;
    }
    $Self->True(
        $Match{$Key},
        "#4 html2ascii - Body match - $Key",
    );
}

# match values not
my %MatchNot = (
    "style"      => 0,
    "background" => 0,
    "br"         => 0,
    "div"        => 0,
    "html"       => 0,
);
for my $Key ( sort keys %MatchNot ) {
    if ( $EmailParserObject->GetMessageBody() !~ /$Key/ ) {
        $MatchNot{$Key} = 1;
    }
    $Self->True(
        $MatchNot{$Key},
        "#4 html2ascii - Body match not - $Key",
    );
}

# test #5
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test5.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'iso-8859-1',
    "#5 GetCharset()",
);
@Attachments = $EmailParserObject->GetAttachments();
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
$Self->Is(
    $Attachments[1]->{ContentAlternative} || '',
    '',
    "#5 ContentAlternative check",
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
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test6.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'utf-8',
    "#6 GetCharset()",
);
@Attachments = $EmailParserObject->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    '5ee767f3b68f24a9213e0bef82dc53e5',
    "#6 md5 check",
);
$Self->Is(
    $Attachments[1]->{Filename},
    'test-attachment-äöüß.pdf',
    "#6 GetAttachments()",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[2]->{Content} ) || '';
$Self->Is(
    $MD5,
    'bb29962e132ba159539f1e88b41663b1',
    "#6 md5 check",
);
$Self->Is(
    $Attachments[2]->{Filename},
    'test-attachment-äöüß-utf-8.txt',
    "#6 GetAttachments()",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[3]->{Content} ) || '';
$Self->Is(
    $MD5,
    '0596f2939525c6bd50fc2b649e40fbb6',
    "#6 md5 check",
);
$Self->Is(
    $Attachments[3]->{Filename},
    'test-attachment-äöüß-iso-8859-1.txt',
    "#6 GetAttachments()",
);

# test #7
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test7.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'iso-8859-1',
    "#7 GetCharset()",
);
@Attachments = $EmailParserObject->GetAttachments();
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
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test8.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    '',
    "#8 GetCharset() - no charset should be found (non text body)",
);

my $Body = $EmailParserObject->GetMessageBody();
@Attachments = $EmailParserObject->GetAttachments();
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
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test9.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'us-ascii',
    "#9 GetCharset() - us-ascii charset should be found",
);

@Attachments = $EmailParserObject->GetAttachments();
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
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test10.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'iso-8859-1',
    "#10 GetCharset() - iso-8859-1 charset should be found",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
$Self->Is(
    $MD5,
    '7ddc731e5a3e76cd27d4b1e0628468b1',
    "#10 md5 body check",
);

@Attachments = $EmailParserObject->GetAttachments();
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
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test11.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'ISO-8859-1',
    "#11 GetCharset() - iso-8859-1 charset should be found",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
$Self->Is(
    $MD5,
    '52f20c90a1f0d8cf3bd415e278992001',
    "#11 md5 body check",
);

@Attachments = $EmailParserObject->GetAttachments();
$Self->True(
    !$Attachments[0] || 0,
    "#11 attachment check #0",
);

# test #12
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test12.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'ISO-8859-1',
    "#12 GetCharset() - iso-8859-1 charset should be found",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'To' ),
    '金田　美羽 <support@example.com>',
    "#12 GetParam(WHAT => 'To')",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'Cc' ),
    '張雅惠 <support2@example.com>, "문화연대" <support3@example.com>',
    "#12 GetParam(WHAT => 'Cc')",
);

$MD5 = $Self->{MainObject}->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
$Self->Is(
    $MD5,
    '603c11a38065909cc13bf53c650506c1',
    "#12 md5 body check",
);

@Attachments = $EmailParserObject->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    'ecfbec2030e6bf91cc97ed22f7c6551a',
    "#12 md5 check",
);
$Self->Is(
    $Attachments[1]->{Filename} || '',
    'attachment-äöüß-utf8.txt',
    "#12 Filename check",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[2]->{Content} ) || '';
$Self->Is(
    $MD5,
    'b25beeea18c52cdc791864b52862743e',
    "#12 md5 check",
);
$Self->Is(
    $Attachments[2]->{Filename} || '',
    'attachment-äöüß-iso.txt',
    "#12 Filename check",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[3]->{Content} ) || '';
$Self->Is(
    $MD5,
    'f287d0dd6d0f90da4ac69348b09ec281',
    "#12 md5 check",
);
$Self->Is(
    $Attachments[3]->{Filename} || '',
    'Обяснительная.jpg',
    "#12 Filename check",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[4]->{Content} ) || '';
$Self->Is(
    $MD5,
    'f287d0dd6d0f90da4ac69348b09ec281',
    "#12 md5 check",
);
$Self->Is(
    $Attachments[4]->{Filename} || '',
    'Сообщение.jpg',
    "#12 Filename check",
);
$Self->Is(
    $Attachments[5]->{Filename} || '',
    '報告書①..txt',
    "#12 Filename check",
);
$Self->Is(
    $Attachments[6]->{Filename} || '',
    '金田　美羽',
    "#12 Filename check",
);
$Self->Is(
    $Attachments[7]->{Filename} || '',
    '國科會50科學之旅活動計畫徵求書(r_final).doc',
    "#12 Filename check",
);
$Self->Is(
    $Attachments[8]->{Filename} || '',
    '2차 보도자료.hwp',
    "#12 Filename check",
);
$Self->True(
    !$Attachments[9] || 0,
    "#12 attachment check #0",
);

# test #13
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test13.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    '',
    "#13 GetCharset() - no charset should be found",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'To' ),
    '<support@example.com>',
    "#13 GetParam(WHAT => 'To')",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
$Self->Is(
    $MD5,
    '474f97c23688e88edfb70139d5658e01',
    "#13 md5 body check",
);

# test #14
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test14.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'UTF-8',
    "#14 GetCharset() - no charset should be found",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'To' ),
    '<security@example.org>',
    "#14 GetParam(WHAT => 'To')",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'From' ),
    'VIAGRA � Official Site <security@example.org>',
    "#14 GetParam(WHAT => 'From')",
);
$MD5 = $Self->{MainObject}->MD5sum( String => $EmailParserObject->GetMessageBody() ) || '';
$Self->Is(
    $MD5,
    'b8b01a1acd8fe7efeff8351bf48d8f63',
    "#14 md5 body check",
);

# test #15
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test16.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'ISO-8859-1',
    "#15 GetCharset() - iso-8859-1 charset should be found",
);

@Attachments = $EmailParserObject->GetAttachments();
$MD5 = $Self->{MainObject}->MD5sum( String => $Attachments[1]->{Content} ) || '';
$Self->Is(
    $MD5,
    'e86c2c15e59fc1e1695f890ff102b06c',
    "#15 md5 check",
);
$Self->Is(
    $Attachments[0]->{ContentAlternative} || '',
    1,
    "#15 ContentAlternative check",
);
$Self->Is(
    $Attachments[1]->{ContentAlternative} || '',
    1,
    "#15 ContentAlternative check",
);

# content type tests
my @Tests = (
    {
        ContentType => 'Content-Type: text/plain; charset="iso-8859-1"; charset="iso-8859-1"',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type: text/plain; charset="iso-8859-1"',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type: text/xls-2; charset="iso-8859-1";',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/xls-2',
    },
    {
        ContentType => 'Content-Type: text/plain; charset="iso-8859-1"; format=flowed',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type: text/plain; charset="utf8"; format=flowed',
        Charset     => 'utf8',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type: text/plain; charset=iso-8859-1',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type: text/plain; charset=\'iso-8859-1\'',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type:text/plain; charset=\'iso-8859-1\'',
        Charset     => 'iso-8859-1',
        MimeType    => 'text/plain',
    },
    {
        ContentType => 'Content-Type: text/plain; charset = "utf8"; format=flowed',
        Charset     => 'utf8',
        MimeType    => 'text/plain',
    },
);

for my $Test (@Tests) {
    my %Data = $EmailParserObject->GetContentTypeParams(
        ContentType => $Test->{ContentType},
    );
    $Self->Is(
        $Data{Charset},
        $Test->{Charset},
        "#16 ContentType - Charset check",
    );
    $Self->Is(
        $Data{MimeType},
        $Test->{MimeType},
        "#16 MimeType - Charset check",
    );
}

# test #17
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test19.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);
$Self->Is(
    $EmailParserObject->GetCharset(),
    'iso-8859-1',
    "#17 GetCharset() - iso-8859-1 charset should be found",
);

#test #18
my $ContentType = qq(Content-Type: text/html; charset="iso-8859-1"; charset="iso-8859-1");
my %Data        = $EmailParserObject->GetContentTypeParams(
    ContentType => $ContentType,
);
$Self->Is(
    $Data{Charset},
    'iso-8859-1',
    "#18 ContentType - iso-8859-1 charset should be found",
);

# test #20
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test20.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);

@Attachments = $EmailParserObject->GetAttachments();
my $ContentLocation;
for my $Attachment (@Attachments) {
    next if $Attachment->{ContentType} ne 'image/bmp; name="ole0.bmp"';
    $ContentLocation = $Attachment->{ContentID};
}

$Self->Is(
    $ContentLocation,
    'Untitled%20Attachment',
    "#20 Get Content-Location",
);

# test #21
@Array = ();
open( $IN, "<", "$Home/scripts/test/sample/EmailParser/PostMaster-Test21.box" );    ## no critic
while (<$IN>) {
    push( @Array, $_ );
}
close($IN);

$EmailParserObject = Kernel::System::EmailParser->new(
    %{$Self},
    Email => \@Array,
);

$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'To' ),
    'Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>',
    "#21 GetParam(WHAT => 'To' Multiline encode quote printable)",
);
$Self->Is(
    $EmailParserObject->GetParam( WHAT => 'Subject' ),
    'Евгений Васильев Новоподзалупинский <xxzzyy@gmail.com>',
    "#21 GetParam(WHAT => 'Subject' Multiline encode quote printable)",
);
1;
