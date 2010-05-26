# --
#Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.1 2010-05-26 21:15:57 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub CreateClientCacheTimestamp {
    my ( $Self, $Array ) = @_;

    my $StringFile = "";
    my $Dir        = "../../Kernel/Config/Files";

    my @Files = glob("$Dir/*.*");
    push( @Files, '../../Kernel/Config.pm' );

    for my $File (@Files)
    {
        my $FileMTime = $Self->{MainObject}->FileGetMTime(
            Location => $File,
        );
        $File =~ s/^.*\/(.+?)/$1/g;
        $StringFile .= $File . $FileMTime;
    }

    my $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$StringFile,
    );
    return $MD5Sum;
}
1;
