# --
# Kernel/Output/HTML/OutputFilterActiveElement.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: OutputFilterActiveElement.pm,v 1.2 2006-08-27 22:28:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::OutputFilterActiveElement;

use strict;
use HTML::Safe;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # use filter
    my $HTMLSafe = HTML::Safe->new(NoIntSrcLoad => 0, %Param);
    $HTMLSafe->Filter(Data => $Param{Data});
}

1;
