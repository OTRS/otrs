# --
# Kernel/System/Web/Request.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Request.pm,v 1.10 2007-01-21 01:26:10 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Web::Request;

use strict;

use vars qw($VERSION);

$VERSION = '$Revision: 1.10 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Web::Request - global cgi param interface

=head1 SYNOPSIS

All cgi param functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create param object

    use Kernel::Config;
    use Kernel::System::Web::Request;

    my $ConfigObject = Kernel::Config->new();
    my $ParamObject = Kernel::System::Web::Request->new(
        ConfigObject => $ConfigObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(ConfigObject LogObject EncodeObject)) {
        if ($Param{$_}) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Gor no $_";
        }
    }
    # Simple Common Gateway Interface Class
    use CGI qw(:cgi);
    # to get the errors on screen
    use CGI::Carp qw(fatalsToBrowser);
    # max 5 MB posts
    $CGI::POST_MAX = $Self->{ConfigObject}->Get('WebMaxFileUpload') || 1024 * 1024 * 5;
    # query object (in case use already existing WebRequest, e. g. fast cgi)
    $Self->{Query} = $Param{WebRequest} || new CGI;

    return $Self;
}

=item Error()

to get the error back

    if ($ParamObject->Error()) {
        print STDERR $Self->{ParamObject}->Error()."\n";
    }

=cut

sub Error {
    my $Self = shift;
    if (cgi_error()) {
        return cgi_error()." - POST_MAX=".($CGI::POST_MAX/1024)."KB";
    }
    else {
        return;
    }
}

=item GetParam()

to get params

    my $Param = $ParamObject->GetParam(Param => 'ID');

=cut

sub GetParam {
    my $Self = shift;
    my %Param = @_;
#return $Self->{P}->{$Param{Param}};
    my $Value = $Self->{Query}->param($Param{Param});
    $Self->{EncodeObject}->Encode(\$Value);
    return $Value;
}

=item GetArray()

to get array params

    my @Param = $ParamObject->GetArray(Param => 'ID');

=cut

sub GetArray {
    my $Self = shift;
    my %Param = @_;
    my @Value = $Self->{Query}->param($Param{Param});
    $Self->{EncodeObject}->Encode(\@Value);
    return @Value;
}

=item GetUpload()

internal function for GetUploadAll()

=cut

sub GetUpload {
    my $Self = shift;
    my %Param = @_;
    my $File = $Self->{Query}->upload($Param{Filename});
    return $File;
}

=item GetUploadInfo()

internal function for GetUploadAll()

=cut

sub GetUploadInfo {
    my $Self = shift;
    my %Param = @_;
    my $Info = $Self->{Query}->uploadInfo($Param{Filename})->{$Param{Header}};
    return $Info;
}

=item GetUploadAll()

to get file upload

    my %File = $ParamObject->GetUploadAll(
        Param => '123.jpg',
    );

    to get file upload without uft-8 encoding

    my %File = $ParamObject->GetUploadAll(
        Param => '123.jpg',
        Encoding => 'Raw', # optional
    );

    print "Filename: $File{Filename}\n";
    print "ContentType: $File{ContentType}\n";
    print "Content: $File{Content}\n";

=cut

sub GetUploadAll {
    my $Self = shift;
    my %Param = @_;
    my $Upload = $Self->GetUpload(Filename => $Param{Param});
    if ($Upload) {
        $Param{UploadFilenameOrig} = $Self->GetParam(Param => $Param{Param}) || 'unkown';
        # replace all devices like c: or d: and dirs for IE!
        my $NewFileName = $Param{UploadFilenameOrig};
        $NewFileName =~ s/.:\\(.*)/$1/g;
        $NewFileName =~ s/.*\\(.+?)/$1/g;
        # return a string
        if ($Param{Source} && $Param{Source} =~ /^string$/i) {
            $Param{UploadFilename} = '';
            while (<$Upload>) {
                $Param{UploadFilename} .= $_;
            }
            if (!$Param{Encoding}) {
                $Self->{EncodeObject}->Encode(\$Param{UploadFilename});
            }
        }
        # return file location in FS
        else {
            # delete upload dir if exists
            my $Path = "/tmp/$$";
            if (-d $Path) {
                File::Path::rmtree([$Path]);
            }
            # create upload dir
            File::Path::mkpath([$Path], 0, 0700);

            $Param{UploadFilename} = "$Path/$NewFileName";
            open (OUTFILE,"> $Param{UploadFilename}") || die $!;
            while (<$Upload>) {
                print OUTFILE $_;
            }
            close (OUTFILE);
        }
        # check if content is there, IE is always sending file uploades
        # without content
        if (!$Param{UploadFilename}) {
            return;
        }
        if ($Param{UploadFilename}) {
            $Param{UploadContentType} = $Self->GetUploadInfo(
                Filename => $Param{UploadFilenameOrig},
                Header => 'Content-Type',
            ) || '';
        }
        return (
            Filename => $NewFileName,
            Content => $Param{UploadFilename},
            ContentType => $Param{UploadContentType},
        );
    }
    else {
        return;
    }
}

=item SetCookie()

set a cookie

    $ParamObject->SetCookie(
        Key => ID,
        Value => 123456,
    );

=cut

sub SetCookie {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Query}->cookie(
        -name=> $Param{Key},
        -value=> $Param{Value},
        -expires=> $Param{Expires},
    );
}

=item GetCookie()

get a cookie

    my $String = $ParamObject->GetCookie(
        Key => ID,
    );

=cut

sub GetCookie {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Query}->cookie($Param{Key}) || '';
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.10 $ $Date: 2007-01-21 01:26:10 $

=cut