# --
# Kernel/System/WebRequest.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: WebRequest.pm,v 1.9 2003-01-19 18:41:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::WebRequest;

use strict;

use vars qw($VERSION);

$VERSION = '$Revision: 1.9 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
    # --
    # check needed objects
    # --
    foreach (qw(ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # --
    # Simple Common Gateway Interface Class
    # --
    use CGI qw(:cgi);
    # --
    # to get the errors on screen
    # --
    use CGI::Carp qw(fatalsToBrowser);
    # max 5 MB posts
    $CGI::POST_MAX = $Self->{ConfigObject}->Get('MaxFileUpload') || 1024 * 1024 * 5;  

    $Self->{Query} = new CGI;

    return $Self;
}
# --
sub Error {
    my $Self = shift;
    if (cgi_error()) {
        return cgi_error()." - POST_MAX=".($CGI::POST_MAX/1024)."KB";
    }
    else {
        return;
    }
}
# --
sub GetParam {
    my $Self = shift;
    my %Param = @_;
    my $Value = $Self->{Query}->param($Param{Param});
    return $Value;
}
# --
sub GetArray {
    my $Self = shift;
    my %Param = @_;
    my @Value = $Self->{Query}->param($Param{Param});
    return @Value;
}
# --
sub GetUpload {
    my $Self = shift;
    my %Param = @_;
    my $File = $Self->{Query}->upload($Param{Filename});
    return $File;
}
# --
sub GetUploadInfo {
    my $Self = shift;
    my %Param = @_;
    my $Info = $Self->{Query}->uploadInfo($Param{Filename})->{$Param{Header}};
    return $Info;
}
# --
sub GetUploadAll {
    my $Self = shift;
    my %Param = @_;
    my $Upload = $Self->GetUpload(Filename => $Param{Param});
    if ($Upload) {
        $Param{UploadFilenameOrig} = $Self->GetParam(Param => $Param{Param}) || 'unkown';
        # --
        # replace all devices like c: or d: and dirs for IE!
        # --
        my $NewFileName = $Param{UploadFilenameOrig};
        $NewFileName =~ s/.:\\(.*)/$1/g;
        $NewFileName =~ s/.*\\(.+?)/$1/g;
        # --
        # return a string
        # --
        if ($Param{Source} && $Param{Source} =~ /^string$/i) {
            $Param{UploadFilename} = '';
            while (<$Upload>) {
                $Param{UploadFilename} .= $_;
            }
        }
        # --
        # return file location in FS
        # --
        else {
            # --
            # delete upload dir if exists
            # --
            my $Path = "/tmp/$$";
            if (-d $Path) {
                File::Path::rmtree([$Path]);
            }
            # --
            # create upload dir
            # --
            File::Path::mkpath([$Path], 0, 0700);

            $Param{UploadFilename} = "$Path/$NewFileName";
            open (OUTFILE,"> $Param{UploadFilename}") || die $!;
            while (<$Upload>) {
                print OUTFILE $_;
            }
            close (OUTFILE);
        }
        if ($Param{UploadFilename}) { 
          $Param{UploadContentType} = $Self->GetUploadInfo(
            Filename => $Param{UploadFilenameOrig},
            Header => 'Content-Type',
          ) || '';
        }
        return (
            UploadRealFileName => $NewFileName,
            UploadFilename => $Param{UploadFilename}, 
            UploadContentType => $Param{UploadContentType},
        );
    }
    else {
        return;
    }
}
# --
sub SetCookie {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Query}->cookie( 
        -name=> $Param{Key},
        -value=> $Param{Value},
        -expires=> $Param{Expires},
    );
}
# --
sub GetCookie {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Query}->cookie($Param{Key}) || '';
}
# --

1;
