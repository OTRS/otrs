#!/usr/bin/perl -w
# --
# scripts/tools/compress-mail.pl - compress email, zip attachments
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: compress-mail.pl,v 1.5 2006-10-03 14:34:47 mh Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin). "/../";
use lib dirname($RealBin)."/../Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# config
# --
my @Compress = qw(xls doc dot bmp tiff tif jpg pdf exe class pm pl ps eps ppt rft php php3 php4 js com latex tex tcl sql wav wbmp css html htm phtml sgm shml xml xsl rtx txt asc vcf vcs);

use Compress::Zlib;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::EmailParser;

# --
# create common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PM-Compress',
    %CommonObject,
);
my @Email = <STDIN>;
$CommonObject{ParseObject} = Kernel::System::EmailParser->new(
    Email => \@Email,
    NoHTMLChecks => 1,
    %CommonObject,
);
my $MSGID = $CommonObject{ParseObject}->GetParam(WHAT => 'Message-ID') || 'No Message-ID';
my $Touch = 0;
my $NoTouch = 0;
my $Counter = 0;
my $CompressAttachmentMinSize = $CommonObject{ConfigObject}->Get('CompressAttachmentMinSize') || (1014*3);
my $CompressAttachmentMaxSize = $CommonObject{ConfigObject}->Get('CompressAttachmentMaxSize') || (1024*1024*60);
my $CompressAttachmentNoTouch = $CommonObject{ConfigObject}->Get('CompressAttachmentNoTouch') || '(application/(x-pkcs.-signature|pgp-signature))';
my @Attachments = $CommonObject{ParseObject}->GetAttachments();
my $Entity;
my $Header = $CommonObject{ParseObject}->{HeaderObject}->header_hashref();
# check if this mail can be modified (not touch signed or crypted emails)
foreach my $Attachment (@Attachments) {
    if ($Attachment->{MimeType} && $Attachment->{MimeType} =~ /$CompressAttachmentNoTouch/i) {
        $NoTouch = 1;
    }
}
# just compress touchable emails
if (!$NoTouch) {
    foreach my $Attachment (@Attachments) {
        $Counter++;
        my $Compress = 0;
        # just compress attachments after the first one
        if ($Counter > 1) {
            # check if attachment should be compresed
            foreach (@Compress) {
                if ($Attachment->{Filename} =~ /\.$_$/i) {
                    # just compress attachments within a size range
                    use bytes;
                    my $FileSize = length($Attachment->{Content});
                    no bytes;
    	            if ($FileSize > $CompressAttachmentMinSize && $FileSize < $CompressAttachmentMaxSize) {
                        $Compress = 1;
                        $Touch = 1;
                    }
            	}
            }
        }
        # compress attachment
        if ($Compress) {
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message => "Compress $Attachment->{Filename} ($MSGID)!",
            );
            $Attachment->{Filename} .= '.gz';
            $Attachment->{Content} = Compress::Zlib::memGzip($Attachment->{Content});
            $Attachment->{ContentType} = 'application/x-gzip';
        }
        # build new entity
        if (!$Entity) {
            $Entity = MIME::Entity->build(
                %{$Header},
#               Filename => $Attachment->{Filename},
                Data     => $Attachment->{Content},
#               Type     => $Attachment->{ContentType},
#               Encoding => "base64",
            );
        }
        # add attachment to entity
        $Entity->attach(
            Filename => $Attachment->{Filename},
            Data     => $Attachment->{Content},
            Type     => $Attachment->{ContentType},
            Encoding => "base64",
        );
    }
}
# return old email 1:1
if (!$Touch) {
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => "No changes ($MSGID)!",
    );
    my $Header = $CommonObject{ParseObject}->{HeaderObject}->as_string();
    print $Header;
    print "\n";
    foreach (@Email) {
        print $_;
    }
}
# return modified email
else {
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => "Changes ($MSGID)!"
    );
    my $Header = $CommonObject{ParseObject}->{HeaderObject}->as_string();
    print $Header;
    print "\n";
    print $Entity->body_as_string();
}
