# --
# Kernel/Output/HTML/OutputFilterActiveElement.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: OutputFilterActiveElement.pm,v 1.5 2007-10-02 10:43:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::OutputFilterActiveElement;

use strict;
use warnings;

use HTML::Safe;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # use filter
    my $HTMLSafe = HTML::Safe->new( NoIntSrcLoad => 0, %Param );
    return $HTMLSafe->Filter( Data => $Param{Data} );
}

1;
