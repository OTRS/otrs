# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.2 2010-05-26 22:03:10 mp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub LoaderCreateClientCacheTimestamp {
    my ( $Self, $Array ) = @_;

    my $StringFile = "";
    my $Dir        = $Self->{ConfigObject}->Get('Home');

    my @Files = glob("$Dir/Kernel/Config/Files/*.pm");

    push( @Files, "$Dir/Kernel/Config.pm" );

    for my $File (@Files) {
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
