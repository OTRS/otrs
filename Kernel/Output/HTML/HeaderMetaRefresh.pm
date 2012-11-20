# --
# Kernel/Output/HTML/HeaderMetaRefresh.pm
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: HeaderMetaRefresh.pm,v 1.5 2012-11-20 14:58:29 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::HeaderMetaRefresh;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject LayoutObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Param{Refresh} ) {
        $Self->{LayoutObject}->Block(
            Name => 'MetaHttpEquivRefresh',
            Data => \%Param,
        );
    }
    return 1;
}

1;
