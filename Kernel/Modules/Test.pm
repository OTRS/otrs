# --
# Kernel/Modules/Test.pm - a simple test module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Test.pm,v 1.8 2004-02-18 09:37:32 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::Test;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
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

    # get test page header
    my $Output = $Self->{LayoutObject}->Header( Title => 'OTRS Test Page' );

    # get test page 
    $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'Test', Data => \%Param);

    # get test page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return test page
    return $Output;
}
# --
 
