# --
# Kernel/Output/HTML/HeaderMetaRefresh.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: HeaderMetaRefresh.pm,v 1.3 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::HeaderMetaRefresh;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
