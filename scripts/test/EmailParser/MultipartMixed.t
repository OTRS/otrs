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

use Kernel::System::EmailParser;

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @Tests = (
    {
        Name     => "plain email with ascii and utf-8 part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedPlain.eml",
        Body     => 'first part



second part äöø',
        Attachments => [

            # Look for the concatenated plain body part that was converted to utf-8.
            {
                'Charset' => 'utf-8',
                'Content' => 'first part



second part äöø',
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; charset=utf-8',
                'Disposition'     => undef,
                'Filename'        => 'file-1',
                'Filesize'        => 32,
                'MimeType'        => 'text/plain'
            },

            # Look for the attachment.
            {
                'Charset'            => '',
                'Content'            => "1\n",
                'ContentDisposition' => "attachment; filename=1.txt\n",
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; name="1.txt"',
                'Disposition'        => 'attachment; filename=1.txt',
                'Filename'           => '1.txt',
                'Filesize'           => 2,
                'MimeType'           => 'text/plain'
            }
        ],
    },
    {
        Name     => "HTML email with ascii and utf-8 part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedHTML.eml",
        Body     => 'first part



second part äöø',
        Attachments => [

            # Look for the plain body part.
            {
                'Charset' => 'utf-8',
                'Content' => 'first part



second part äöø',
                'ContentAlternative' => 1,
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; charset=utf-8',
                'Disposition'        => undef,
                'Filename'           => 'file-1',
                'Filesize'           => 32,
                'MimeType'           => 'text/plain'
            },

            # Look for the concatenated HTML body part that was converted to utf-8.
            {
                'Charset' => 'utf-8',
                'Content' =>
                    '<html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><b class="">first</b> part<div class=""><br class=""></div><div class=""></div></body></html><html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">second part äöø</div></body></html>',
                'ContentAlternative' => 1,
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/html; charset=utf-8',
                'Disposition'        => undef,
                'Filename'           => 'file-2',
                'Filesize'           => 590,
                'MimeType'           => 'text/html'
            },

            # Look for the attachment.
            {
                'Charset'            => '',
                'Content'            => "1\n",
                'ContentAlternative' => 1,
                'ContentDisposition' => "attachment; filename=1.txt\n",
                'ContentID'          => undef,
                'ContentLocation'    => undef,
                'ContentType'        => 'text/plain; name="1.txt"',
                'Disposition'        => 'attachment; filename=1.txt',
                'Filename'           => '1.txt',
                'Filesize'           => 2,
                'MimeType'           => 'text/plain'
            }
        ],
    },
    {
        Name     => "mixed email with plain and HTML part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedPlainHTML.eml",
        Body     => 'Hello,

This is the forwarded message...

--
Met vriendelijke groeten,
Erik Thijs

    Hi,
 
This mail is composed in html format.
 
Cheers,
Erik
',
        Attachments => [
            {
                'Charset' => 'utf-8',
                'Content' => 'Hello,

This is the forwarded message...

--
Met vriendelijke groeten,
Erik Thijs

    Hi,
 
This mail is composed in html format.
 
Cheers,
Erik
',
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/plain; charset=utf-8',
                'Disposition'     => 'inline',
                'Filename'        => 'file-1',
                'Filesize'        => 148,
                'MimeType'        => 'text/plain'
            },
        ],
    },
    {
        Name     => "mixed email with HTML and plain part",
        RawEmail => "$Home/scripts/test/sample/EmailParser/MultipartMixedHTMLPlain.eml",
        Body     => '    Hi,
 
This mail is composed in html format.
 
Cheers,
Erik
 Hello,

This is the forwarded message...

--
Met vriendelijke groeten,
Erik Thijs

',
        Attachments => [
            {
                'Charset' => 'utf-8',
                'Content' => '<html>
<head>
<style><!--
.hmmessage P
{
margin:0px;
padding:0px
}
body.hmmessage
{
font-size: 10pt;
font-family:Tahoma
}
--></style>
</head>
<body class=\'hmmessage\'>
Hi,<BR>
&nbsp;<BR>
This <FONT color=#ff0000>mail </FONT>is <FONT color=#00b050>composed </FONT>in <FONT color=#0070c0>html </FONT>format.<BR>

&nbsp;<BR>
Cheers,<BR>
<FONT style="BACKGROUND-COLOR: #ffff00">Erik</FONT><BR></body></html>
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Hello,<br/>
<br/>
This is the forwarded message...<br/>
<br/>
--<br/>
Met vriendelijke groeten,<br/>
Erik Thijs<br/>
<br/>
</body></html>',
                'ContentID'       => undef,
                'ContentLocation' => undef,
                'ContentType'     => 'text/html; charset=utf-8',
                'Disposition'     => 'inline',
                'Filename'        => 'file-1.html',
                'Filesize'        => 720,
                'MimeType'        => 'text/html'
            },
        ],
    },
);

for my $Test (@Tests) {
    my @Array;
    open my $IN, '<', $Test->{RawEmail};    ## no critic
    while (<$IN>) {
        push @Array, $_;
    }
    close $IN;

    # create local object
    my $EmailParserObject = Kernel::System::EmailParser->new(
        Email => \@Array,
    );

    my @Attachments = $EmailParserObject->GetAttachments();
    my $Body        = $EmailParserObject->GetMessageBody();

    $Self->Is(
        $Body,
        $Test->{Body},
        "Test->{Name} - body",
    );

    # Turn on utf-8 flag for parts that were not converted but are still utf-8 for correct comparison.
    for my $Attachment (@Attachments) {
        if ( $Attachment->{Charset} eq 'utf-8' ) {
            Encode::_utf8_on( $Attachment->{Content} );
        }
    }

    $Self->IsDeeply(
        \@Attachments,
        $Test->{Attachments},
        "$Test->{Name} - attachments"
    );
}

1;
