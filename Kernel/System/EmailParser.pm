# --
# Kernel/System/EmailParser.pm - the global email parser module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailParser.pm,v 1.20 2004-01-10 12:54:18 martin Exp $
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
$VERSION = '$Revision: 1.20 $';
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

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
 
    # get debug level from parent
    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    foreach (qw(LogObject ConfigObject Email)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    # create Mail::Internet object
    $Self->{Email} = new Mail::Internet($Param{Email});
    # create a Mail::Header object with email
    $Self->{HeaderObject} = $Self->{Email}->head();
    # parse email at first
    $Self->GetMessageBody();

    return $Self;
}
# --

=item GetPlainEmail()
    
To get a email as a string back (plain email).
  
  my $Email = $ParseObject->GetPlainEmail();

=cut

sub GetPlainEmail {
    my $Self = shift;
    return $Self->{Email}->as_string();
}
# --

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
# --

=item SplitAddressLine()
    
To get an array of email addresses of an To, Cc or Bcc line back.
 
  my @Addresses = $ParseObject->SplitAddressLine(Line => 'Juergen Weber <juergen.qeber@air.com, me@example.com, hans@example.com (Hans Huber)');
   
This returns an array with ('juergen.qeber@air.com', 'me@example.com', 'hans@example.com').

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
# --

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
# --

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

=item GetReturnContentType()
    
Returns the new message body (or from the first attachment) "ContentType" header
(maybe the message is converted to utf-8).
 
    my $Charset = $ParseObject->GetReturnContentType();
   
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
# --

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
    # create MIME::Parser object and get message body or body of first attachemnt
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
        $Self->{MessageBody} = $Self->{EncodeObject}->Decode(
            Text => $BodyStrg, 
            From => $Self->GetCharset(),
        );
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
        return $Self->{MessageBody};
    }
    return
}
# --

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
# --
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
# just for internal
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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).  
    
This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut
    
=head1 VERSION

$Revision: 1.20 $ $Date: 2004-01-10 12:54:18 $

=cut
