# --
# Test.pm - a simple test module
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Test.pm,v 1.1 2001-12-05 18:57:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::Test;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    # get test page     
    my $Output = $Self->{LayoutObject}->Test();
 
    # return test page
    return $Output;
}
# --
 
