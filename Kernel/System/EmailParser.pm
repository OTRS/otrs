# --
# Kernel/System/EmailParser.pm - the global email parser module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: EmailParser.pm,v 1.15 2003-10-29 21:13:33 martin Exp $
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

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # check needed objects
    foreach (qw(LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # create Mail::Internet object
    $Self->{Email} = new Mail::Internet($Param{Email});
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

    my $Header = $Self->{Email}->head();
    $Header->unfold();
    $Header->combine($What);
    my $Line = $Header->get($What) || '';
    $Line = decode_mimewords($Line);
    chomp ($Line);
    return $Line;
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
            print STDERR 'No Mime Email' . "\n";
        }
        my $BodyStrg = join('', @{$Self->{Email}->body()});
        # --
        # quoted printable!
        # --
        if ($Self->GetParam(WHAT => 'Content-Transfer-Encoding') =~ /quoted-printable/i) {
            $BodyStrg = MIME::QuotedPrint::decode($BodyStrg);
        }
        elsif ($Self->GetParam(WHAT => 'Content-Transfer-Encoding') =~ /base64/i) {
            $BodyStrg = decode_base64($BodyStrg);
        }
        return $BodyStrg;
    }
    else {
        $Self->{MimeEmail} = 1;
        if ($Self->{Debug} > 0) {
            print STDERR "Mime Email\n";
        }
        my @Attachments = $Self->GetAttachments();
        my %Attachment = %{$Attachments[0]};
        $Self->{ContentType} = $Attachment{ContentTypeLong};
        return $Attachment{Content};
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
        $PartData{ContentType} = $Part->effective_type();
        $PartData{ContentTypeLong} = $Part->head()->mime_type()."; ";
        if ($Part->head()->mime_attr('content-type.charset')) {    
            $Self->{ContentType} .= "charset=".
            $Part->head()->mime_attr('content-type.charset');
        }
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

1;
