# --
# Kernel/System/WebRequest.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: WebRequest.pm,v 1.6 2002-12-08 20:54:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::WebRequest;

use strict;

use vars qw($VERSION);

$VERSION = '$Revision: 1.6 $ ';
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

