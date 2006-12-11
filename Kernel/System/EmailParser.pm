# --
# Kernel/System/EmailParser.pm - the global email parser module
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: EmailParser.pm,v 1.47 2006-12-11 06:47:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::EmailParser;

use strict;
use Mail::Internet;
use MIME::Parser;
use MIME::QuotedPrint;
use MIME::Base64;
use MIME::Words qw(:all);
use Mail::Address;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.47 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::EmailParser - parse and encode a email

=head1 SYNOPSIS

A module to parse and encode a email.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::EmailParser;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $ParseObject = Kernel::System::EmailParser->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      Email => \@ArrayOfEmail,
      Debug => 0,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get debug level from parent
    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    foreach (qw(LogObject ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # check needed objects
    if (!$Param{Email} && !$Param{Entity}) {
        die "Need Email or Entity!";
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    if ($Param{Email}) {
        # create Mail::Internet object
        $Self->{Email} = new Mail::Internet($Param{Email});
        # create a Mail::Header object with email
        $Self->{HeaderObject} = $Self->{Email}->head();
        # create MIME::Parser object and get message body or body of first attachemnt
        my $Parser = new MIME::Parser;
        $Parser->output_to_core("ALL");
#        $Parser->output_dir($Self->{ConfigObject}->Get('TempDir'));
        $Self->{ParserParts} = $Parser->parse_data($Self->{Email}->as_string());
    }
    else {
        $Self->{ParserParts} = $Param{Entity};
        $Self->{EntityMode} = 1;
    }
    # get NoHTMLChecks param
    if ($Param{NoHTMLChecks}) {
        $Self->{NoHTMLChecks} = $Param{NoHTMLChecks};
    }
    # parse email at first
    $Self->GetMessageBody();

    return $Self;
}

=item GetPlainEmail()

To get a email as a string back (plain email).

  my $Email = $ParseObject->GetPlainEmail();

=cut

sub GetPlainEmail {
    my $Self = shift;
    return $Self->{Email}->as_string();
}

=item GetParam()

To get a header (e. g. Subject, To, ContentType, ...) of an email
(mime is already done!).

  my $To = $ParseObject->GetParam(WHAT => 'To');

=cut

sub GetParam {
    my $Self = shift;
    my %Param = @_;
    my $What = $Param{WHAT} || return;

    $Self->{HeaderObject}->unfold();
    $Self->{HeaderObject}->combine($What);
    my $Line = $Self->{HeaderObject}->get($What) || '';
    chomp ($Line);
    my $ReturnLine = '';
    my %Remember = ();
    foreach my $Array (decode_mimewords($Line)) {
        foreach (@{$Array}) {
            # I don't know, but decode_mimewords() returns each mime
            # word two times! Remember to the old one. :-(
            if (!$Remember{$Array->[0]}) {
                if ($Array->[0] && $Array->[1]) {
                    $Remember{$Array->[0]} = 1;
                }
                # Workaround for OE problem:
                # If a header contains =?iso-8859-1?Q?Fr=F6hlich=2C_Roman?=
                # which is decoded ->Fröhlich, Roman<- which gets an problem
                # because this means two email addresses. We add " at
                # the start and at the end of this types of words mime.
                if ($What =~ /^(From|To|Cc)/ && $Array->[1]) {
                    if ($Array->[0] !~ /^("|')/ && $Array->[0] =~ /,/) {
                        $Array->[0] = '"'.$Array->[0].'"';
                        $Remember{$Array->[0]} = 1;
                    }
                }
                $ReturnLine .= $Self->{EncodeObject}->Decode(
                    Text => $Array->[0],
                    From => $Array->[1] || $Self->GetCharset() || 'us-ascii',
                );
            }
            else {
                $Remember{$Array->[0]} = undef;
            }
        }
    }
    # debug
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message => "Get: $What; ReturnLine: $ReturnLine; OrigLine: $Line",
        );
    }
    return $ReturnLine;
}

=item GetEmailAddress()

To get the senders email address back.

  my $SenderEmail = $ParseObject->GetEmailAddress(Email => 'Juergen Weber <juergen.qeber@air.com>');

=cut

sub GetEmailAddress {
    my $Self = shift;
    my %Param = @_;
    my $Email = '';
    foreach my $EmailSplit (Mail::Address->parse($Param{Email})) {
        $Email = $EmailSplit->address();
    }
    return $Email;
}

=item SplitAddressLine()

To get an array of email addresses of an To, Cc or Bcc line back.

  my @Addresses = $ParseObject->SplitAddressLine(Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber)');

This returns an array with ('Juergen Weber <juergen.qeber@air.com>', 'me@example.com', 'hans@example.com (Hans Huber)').

=cut

sub SplitAddressLine {
    my $Self = shift;
    my %Param = @_;
    my @GetParam = ();
    foreach my $Line (Mail::Address->parse($Param{Line})) {
        push (@GetParam, $Line->format());
    }
    return @GetParam;
}

=item GetContentType()

Returns the message body (or from the first attachment) "ContentType" header.

    my $ContentType = $ParseObject->GetContentType();

(e. g. 'text/plain; charset="iso-8859-1"')

=cut

sub GetContentType {
    my $Self = shift;
    my $ContentType = shift || '';
    if ($Self->{ContentType}) {
        return $Self->{ContentType};
    }
    else {
        return $Self->GetParam(WHAT => 'Content-Type');
    }
}

=item GetCharset()

Returns the message body (or from the first attachment) "charset".

    my $Charset = $ParseObject->GetCharset();

(e. g. iso-8859-1, utf-8, ...)

=cut

sub GetCharset {
    my $Self = shift;
    my $ContentType = shift || '';
    if ($Self->{Charset}) {
        # debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Got charset from mime body: $Self->{Charset}",
            );
        }
        return $Self->{Charset};
    }
    else {
        $Self->{HeaderObject}->unfold();
        $Self->{HeaderObject}->combine('Content-Type');
        my $Line = $Self->{HeaderObject}->get('Content-Type') || '';
        chomp ($Line);
        my %Data = $Self->GetContentTypeParams(ContentType => $Line);
        if ($Data{Charset}) {
            # debug
            if ($Self->{Debug} > 0) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Got charset from email body: $Data{Charset}",
                );
            }
            # remember to charset
            $Self->{Charset} = $Data{Charset};
            # return charset
            return $Data{Charset};
        }
        else {
            # debug
            if ($Self->{Debug} > 0) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Got no charset from email body! Take iso-8859-1!",
                );
            }
            # remember to charset
            $Self->{Charset} = 'ISO-8859-1';
            # return charset
            return 'ISO-8859-1';
        }
    }
}

=item GetReturnContentType()

Returns the new message body (or from the first attachment) "ContentType" header
(maybe the message is converted to utf-8).

    my $ContentType = $ParseObject->GetReturnContentType();

(e. g. 'text/plain; charset="utf-8"')

=cut

sub GetReturnContentType {
    my $Self = shift;
    my $ContentType = $Self->GetContentType();
    if ($Self->{EncodeObject}->EncodeInternalUsed()) {
        my $InternalCharset = $Self->{EncodeObject}->EncodeInternalUsed();
        $ContentType =~ s/(charset=)(.*)/$1$InternalCharset/ig;
        # debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Changed ContentType from '".$Self->GetContentType()."' to '$ContentType'.",
            );
        }
        return $ContentType;
    }
    else {
        # debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Changed no ContentType",
            );
        }
        return $ContentType;
    }
}

=item GetReturnCharset()

Returns the charset of the new message body "Charset"
(maybe the message is converted to utf-8).

    my $Charset = $ParseObject->GetReturnCharset();

(e. g. 'text/plain; charset="utf-8"')

=cut

sub GetReturnCharset {
    my $Self = shift;
    my $ContentType = $Self->GetContentType();
    if ($Self->{EncodeObject}->EncodeInternalUsed()) {
        return $Self->{EncodeObject}->EncodeInternalUsed();
    }
    else {
        return $Self->GetCharset();
    }
}

=item GetMessageBody()

Returns the message body (or from the first attachment) from the email.

    my $Body = $ParseObject->GetMessageBody();

=cut

sub GetMessageBody {
    my $Self = shift;
    my %Param = @_;
    # check if message body is already there
    if ($Self->{MessageBody}) {
        return $Self->{MessageBody};
    }

    if (!$Self->{EntityMode} && $Self->{ParserParts}->parts() == 0) {
        $Self->{MimeEmail} = 0;
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "It's a plain (not mime) email!",
            );
        }
        my $BodyStrg = join('', @{$Self->{Email}->body()});
        # quoted printable!
        if ($Self->GetParam(WHAT => 'Content-Transfer-Encoding') =~ /quoted-printable/i) {
            $BodyStrg = MIME::QuotedPrint::decode($BodyStrg);
        }
        # base 64 encode
        elsif ($Self->GetParam(WHAT => 'Content-Transfer-Encoding') =~ /base64/i) {
            $BodyStrg = decode_base64($BodyStrg);
        }
        # charset decode
        $Self->{MessageBody} = $Self->{EncodeObject}->Decode(
            Text => $BodyStrg,
            From => $Self->GetCharset(),
        );
        # check it it's juat a html email (store it as attachment and add text/plain)
        $Self->CheckMessageBody();
        # return message body
        return $Self->{MessageBody};
    }
    else {
        $Self->{MimeEmail} = 1;
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "It's a mime email!",
            );
        }
        my @Attachments = $Self->GetAttachments();
        # check if there is an valid attachment there, if yes, return
        # first attachment (normally text/plain) as message body
        if (@Attachments > 0) {
            my %Attachment = %{$Attachments[0]};
            $Self->{Charset} = $Attachment{Charset};
            $Self->{ContentType} = $Attachment{ContentType};
            if ($Self->{Debug} > 0) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "First atm ContentType: $Self->{ContentType}",
                );
            }
            $Self->{MessageBody} = $Self->{EncodeObject}->Decode(
                Text => $Attachment{Content},
                From => $Self->GetCharset(),
            );
            # check it it's juat a html email (store it as attachment and add text/plain)
            $Self->CheckMessageBody();
            # return message body
            return $Self->{MessageBody};
        }
        else {
            if ($Self->{Debug} > 0) {
                $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "No attachments returned from GetAttachments(), just a null attachment!?",
                );
            }
            # return empty attachment
            $Self->{Charset} = 'iso-8859-1';
            $Self->{ContentType} = 'text/plain';
            return '-';
        }
    }
    return;
}

=item GetAttachments()

Returns an array of the email attachments.

    my @Attachments = $ParseObject->GetAttachments();

    foreach my $Attachment (@Attachments) {
        print $Attachment->{Filename};
        print $Attachment->{Charset};
        print $Attachment->{MimeType};
        print $Attachment->{ContentType};
        print $Attachment->{Content};
    }

=cut

sub GetAttachments {
    my $Self = shift;
    my %Param = @_;
    if (!$Self->{MimeEmail}) {
        return;
    }
    elsif ($Self->{Attachments}) {
        return @{$Self->{Attachments}};
    }
    else {
        $Self->PartsAttachments(Part => $Self->{ParserParts});
        if ($Self->{Attachments}) {
            return @{$Self->{Attachments}};
        }
        else {
            return;
        }
    }
}
# just for internal
sub PartsAttachments {
    my $Self = shift;
    my %Param = @_;
    my $Part = $Param{Part} || $Self->{ParserParts};
    my $PartCounter = $Param{PartCounter} || 0;
    my $SubPartCounter = $Param{SubPartCounter} || 0;
    $Self->{PartCounter}++;
    if ($Part->parts() > 0) {
        $PartCounter++;
        foreach ($Part->parts()) {
            $SubPartCounter++;
            if ($Self->{Debug} > 0) {
                print STDERR "Sub part($PartCounter/$SubPartCounter)!\n";
            }
            $Self->PartsAttachments(Part => $_, PartCounter => $PartCounter);
        }
    }
    else {
        # get attachment meta stuff
        my %PartData = ();
        # get ContentType
        $Part->head()->unfold();
        $Part->head()->combine('Content-Type');
        # get Content-Type, use text/plain if no content type is given
        $PartData{ContentType} = $Part->head()->get('Content-Type') || 'text/plain;';
        chomp ($PartData{ContentType});
        # get mime type
        $PartData{MimeType} = $Part->head()->mime_type();
        # get charset
        my %Data = $Self->GetContentTypeParams(ContentType => $PartData{ContentType});
        if ($Data{Charset}) {
            $PartData{Charset} = $Data{Charset};
        }
        else {
            $PartData{Charset} = 'ISO-8859-1';
        }
#print STDERR "$PartData{ContentType}:$PartData{MimeType}:$PartData{Charset}\n";
        # get content (if possible)
        if ($Part->bodyhandle()) {
            $PartData{Content} = $Part->bodyhandle()->as_string();
            if (!$PartData{Content}) {
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "Totally empty attachment part ($PartCounter)",
                );
                return;
            }
        }
        # log error if there is an corrupt MIME email
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Was not able to parse corrupt MIME email! Skipped attachment ($PartCounter)",
            );
            return;
        }
        # check if there is no recommended_filename -> add file-NoFilenamePartCounter
        if (!$Part->head()->recommended_filename()) {
            $Self->{NoFilenamePartCounter}++;
            $PartData{Filename} = "file-$Self->{NoFilenamePartCounter}";
        }
        else {
            $PartData{Filename} = decode_mimewords($Part->head()->recommended_filename());
            # convert the file name in utf-8 if utf-8 is used
            $PartData{Filename} = $Self->{EncodeObject}->Decode(
                Text => $PartData{Filename},
                From => 'utf-8',
            );
        }
        # debug
        if ($Self->{Debug} > 0) {
            print STDERR "->GotArticle::Atm: '$PartData{Filename}' '$PartData{ContentType}'\n";
        }
        # get attachment size
        {
            use bytes;
            $PartData{Filesize} = length($PartData{Content});
            no bytes;
        }
        # store data
        push(@{$Self->{Attachments}}, \%PartData);
    }
}

=item GetReferences()

To get an array of reference ids of the parsed email

  my @References = $ParseObject->GetReferences();

This returns an array with ('fasfda@host.de', '4124.2313.1231@host.com').

=cut

sub GetReferences {
    my $Self = shift;
    my %Param = @_;
    my @ReferencesAll = ();
    my @References = ();
    # get references ids
    my $ReferencesString = $Self->GetParam(WHAT => 'References');
    if ($ReferencesString) {
        push (@ReferencesAll, ($ReferencesString =~ /<([^>]+)>/g));
    }
    # get in reply to id
    my $InReplyToString = $Self->GetParam(WHAT => 'In-Reply-To');
    if ($InReplyToString) {
        chomp $InReplyToString;
        $InReplyToString =~ s/.*?<([^>]+)>.*/$1/;
        push (@ReferencesAll, $InReplyToString);
    }
    my %Checked = ();
    # get uniq
    foreach (reverse @ReferencesAll) {
        if (!$Checked{$_}) {
            push (@References, $_);
        }
        $Checked{$_} = 1;
    }
    return @References;
}

# just for internal
sub GetContentTypeParams {
    my $Self = shift;
    my %Param = @_;
    my $ContentType = $Param{ContentType} || return;
    if ($Param{ContentType} =~ /charset=.+?/i) {
        $Param{Charset} = $Param{ContentType};
        $Param{Charset} =~ s/.+?charset=("|'|)(\w+)/$2/gi;
        $Param{Charset} =~ s/"|'//g ;
        $Param{Charset} =~ s/(.+?);.*/$1/g;
    }
    if ($Param{ContentType} =~ /^(\w+\/\w+)/i) {
        $Param{MimeType} = $1;
        $Param{MimeType} =~ s/"|'//g ;
    }
    return %Param;
}
# just for internal
sub CheckMessageBody {
    my $Self = shift;
    my %Param = @_;
    # if already checked, just return
    if ($Self->{MessageChecked} || !$Self->{ConfigObject}->Get('PostmasterAutoHTML2Text') || $Self->{NoHTMLChecks}) {
        return;
    }
    # check it it's juat a html email (store it as attachment and add text/plain)
    if ($Self->GetReturnContentType() =~ /text\/html/i) {
        $Self->{MessageChecked} = 1;
        # add html email as attachment (if needed)
        if (!$Self->{MimeEmail}) {
            push (@{$Self->{Attachments}}, {
                Charset => $Self->GetCharset(),
                ContentType => $Self->GetReturnContentType(),
                Content => $Self->{MessageBody},
                Filename => 'orig-html-email.html',
            });
        }
        # remember to html file if not aleady there
        else {
            if ($Self->{Attachments}->[0]->{Filename}) {
                if ($Self->{Attachments}->[0]->{Filename} !~ /\.(htm|html)/i) {
                    $Self->{Attachments}->[0]->{Filename} .= '.html';
                }
            }
        }
        # remember to be an mime email now
        $Self->{MimeEmail} = 1;
        # html2text filter for message body
        my $LinkList = '';
        my $Counter = 0;
        $Self->{MessageBody} =~ s{
            <a\Whref=("|')(.+?)("|')(|.+?)>
        }
        {
            my $Link = $2;
            if ($Link !~ /^(......|.....|....|...):/i) {
                $Link = $Param{URL}.$Link;
            }
            $Counter++;
            $LinkList .= "[$Counter] $Link\n";
            "[$Counter]";
        }egxi;
        $Self->{MessageBody} =~ s/^\s*//mg;
        $Self->{MessageBody} =~ s/\n//gs;
        $Self->{MessageBody} =~ s/\<style.+?\>.*\<\/style\>//gsi;
        $Self->{MessageBody} =~ s/\<br(\/|)\>/\n/gsi;
        $Self->{MessageBody} =~ s/\<(hr|hr.+?)\>/\n\n/gsi;
        $Self->{MessageBody} =~ s/\<(\/|)(pre|pre.+?|p|p.+?|table|table.+?|code|code.+?)\>/\n\n/gsi
;
        $Self->{MessageBody} =~ s/\<(tr|tr.+?|th|th.+?)\>/\n\n/gsi;
        $Self->{MessageBody} =~ s/\.+?<\/(td|td.+?)\>/ /gsi;
        $Self->{MessageBody} =~ s/\<.+?\>//gs;
        $Self->{MessageBody} =~ s/  / /mg;
        $Self->{MessageBody} =~ s/&amp;/&/g;
        $Self->{MessageBody} =~ s/&lt;/</g;
        $Self->{MessageBody} =~ s/&gt;/>/g;
        $Self->{MessageBody} =~ s/&quot;/"/g;
        $Self->{MessageBody} =~ s/&nbsp;/ /g;
        $Self->{MessageBody} =~ s/^\s*\n\s*\n/\n/mg;
        $Self->{MessageBody} =~ s/(.{4,78})(?:\s|\z)/$1\n/gm;
        $Self->{MessageBody} .= "\n\n".$LinkList;
        $Self->{ContentType} = 'text/plain';
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "It's an html only email, added ascii dump, attached html email as attachment.",
            );
        }
    }
    return;
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.47 $ $Date: 2006-12-11 06:47:22 $

=cut
