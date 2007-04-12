# --
# EmailParser.t - email parser tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: EmailParser.t,v 1.5 2007-04-12 23:55:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use utf8;
use Digest::MD5 qw(md5_hex);
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
my $MD5 = md5_hex($Attachments[1]->{Content}) || '';
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
        'utf8: 使って / ISO-8859-1:  Priorität"  / cp-1251: Сергей Углицких',
        "#4 Subject()",
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
$MD5 = md5_hex($Attachments[1]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[2]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[3]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[1]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[2]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[3]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[1]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[2]->{Content}) || '';
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
$MD5 = md5_hex($Attachments[3]->{Content}) || '';
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

1;
