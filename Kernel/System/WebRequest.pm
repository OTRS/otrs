# --
# WebRequest.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: WebRequest.pm,v 1.1 2001-12-02 14:36:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::WebRequest;

use strict;

use vars qw($VERSION);

$VERSION = '$Revision: 1.1 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    use CGI;

    $Self->{Query} = new CGI;

    return $Self;
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

1;

