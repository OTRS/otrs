# --
# Kernel/System/EmailParser.pm - the global email parser module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailParser.pm,v 1.18 2004-01-10 10:42:27 martin Exp $
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
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # check needed objects
    foreach (qw(LogObject ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    # create Mail::Internet object
    $Self->{Email} = new Mail::Internet($Param{Email});
    # create a Mail::Header object
    $Self->{HeaderObject} = $Self->{Email}->head();

    $Self->GetMessageBody();

    return $Self;
}
# --
sub GetPlainEmail {
    my $Self = shift;
    return $Self->{Email}->as_string();
}
# --
sub GetParam {
    my $Self = shift;
    my %Param = @_;
    my $What = $Param{WHAT} || return;

    $Self->{HeaderObject}->unfold();
    $Self->{HeaderObject}->combine($What);
    my $Line = $Self->{HeaderObject}->get($What) || '';
    chomp ($Line);
    my $ReturnLine = '';
    foreach my $Array (decode_mimewords($Line)) {
        foreach (@{$Array}) {
            $ReturnLine .= $Self->{EncodeObject}->Decode(
                Text => $Array->[0],
                From => $Array->[1] || 'us-ascii',
            );
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
# --
sub GetEmailAddress {
    my $Self = shift;
    my %Param = @_;
    my $Email = '';
    foreach my $EmailSplit (Mail::Address->parse($Param{Email})) {
        $Email = $EmailSplit->address();
    }
    return $Email;
}
# --
sub SplitAddressLine {
    my $Self = shift;
    my %Param = @_;
    my @GetParam = ();
    foreach my $Line (Mail::Address->parse($Param{Line})) {
        push (@GetParam, $Line->format());
    }
    return @GetParam;
}
# --
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
# --
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
        my $Line = $Self->GetParam(WHAT => 'Content-Type') || '';
        my %Data = $Self->GetContentTypeParams(ContentType => $Line);
        if ($Data{Charset}) {
            # debug
            if ($Self->{Debug} > 0) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Got charset from email body: $Data{Charset}",
                );
            }
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
            return 'ISO-8859-1';
        }
    }
}
# --
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
# --
sub GetMessageBody {
    my $Self = shift;
    my %Param = @_;
    my $Parser = new MIME::Parser;
    $Parser->output_to_core("ALL");
    $Self->{ParserParts} = $Parser->parse_data($Self->{Email}->as_string());

    if ($Self->{ParserParts}->parts() == 0) {
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
        return $Self->{EncodeObject}->Decode(
            Text => $BodyStrg, 
            From => $Self->GetCharset(),
        );
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
        my %Attachment = %{$Attachments[0]};
        $Self->{Charset} = $Attachment{Charset};
        $Self->{ContentType} = $Attachment{ContentType};
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "First atm ContentType: $Self->{ContentType}",
            );
        }
        return $Self->{EncodeObject}->Decode(
            Text => $Attachment{Content}, 
            From => $Self->GetCharset(),
        );
    }
    return
}
# --
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
# --
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
        $PartData{ContentType} = $Part->head()->get('Content-Type') || '';
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
        }
        # debug
        if ($Self->{Debug} > 0) {
            print STDERR "->GotArticle::Atm: '$PartData{Filename}' '$PartData{ContentType}'\n";
        }
        # store data
        push(@{$Self->{Attachments}}, \%PartData);
    }
}
# --
sub GetContentTypeParams {
    my $Self = shift;
    my %Param = @_;
    my $ContentType = $Param{ContentType} || return;
    if ($Param{ContentType} =~ /charset=/i) {
        $Param{Charset} = $Param{ContentType};
        $Param{Charset} =~ s/.+?\scharset=("|'|)(\w+)/$2/gi;
        $Param{Charset} =~ s/"|'//g ;
    }
    if ($Param{ContentType} =~ /^(\w+\/\w+)/i) {
        $Param{MimeType} = $1;
        $Param{MimeType} =~ s/"|'//g ;
    }
    return %Param;
}
# --
1;
