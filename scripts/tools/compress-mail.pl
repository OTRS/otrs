#!/usr/bin/perl -w
# --
# scripts/tools/compress-mail.pl - compress email, zip attachments
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: compress-mail.pl,v 1.1 2004-01-31 14:45:52 martin Exp $
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
use lib dirname($RealBin). "../";
use lib dirname($RealBin)."/../Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    %CommonObject,
);
my $MSGID = $CommonObject{ParseObject}->GetParam(WHAT => 'Message-ID') || 'No Message-ID';
my $Touch = 0;
my $Counter = 0;
my @Attachments = $CommonObject{ParseObject}->GetAttachments();
my $Entity;
my $Header = $CommonObject{ParseObject}->{HeaderObject}->header_hashref();
foreach my $Attachment (@Attachments) {
    $Counter++;
    my $Compress = 0;
    foreach (@Compress) {
        if ($Attachment->{Filename} =~ /\.$_$/i) {
            $Compress = 1;
            $Touch = 1;
        }
    }
#    if ($Counter > 1 && $Attachment->{ContentType} && $Attachment->{ContentType} =~ /^text\//i) {
#        $Compress = 1;
#    }
    if ($Compress) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Compress $Attachment->{Filename} ($MSGID)!",
        );
        $Attachment->{Filename} .= '.gz';
        $Attachment->{Content} = Compress::Zlib::memGzip($Attachment->{Content});
        $Attachment->{ContentType} = 'application/x-gzip';
    }
    if (!$Entity) {
        $Entity = MIME::Entity->build(
            %{$Header},
#            Filename => $Attachment->{Filename},
            Data     => $Attachment->{Content},
#            Type     => $Attachment->{ContentType},
#            Encoding => "base64",
        );
    }
    $Entity->attach(
        Filename => $Attachment->{Filename},
        Data     => $Attachment->{Content},
        Type     => $Attachment->{ContentType},
        Encoding => "base64",
    );
}

if (!$Touch) {
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => "No changes ($MSGID)!",
    );
    foreach (@Email) {
        print $_;
    }
}
else {
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => "Changes ($MSGID)!"
    );
    my $Header = $CommonObject{ParseObject}->{HeaderObject}->as_string();
    print $Header;
    print $Entity->body_as_string();
}
