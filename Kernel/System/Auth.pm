# --
# Kernel/System/Auth.pm - provides the authentification 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Auth.pm,v 1.15 2003-02-08 15:09:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Auth; 

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # --
    # load generator auth module
    # --
    $Self->{GenericModule} = $Self->{ConfigObject}->Get('AuthModule')
      || 'Kernel::System::Auth::DB';
    if (!eval "require $Self->{GenericModule}") {
        die "Can't load auth backend module $Self->{GenericModule}! $@";
    }

    $Self->Init(%Param);
#    $Self->{Backend} = $Self->{GeneratorModule}->new(%Param);

    return $Self;
}
# --
sub Init {
    my $Self = shift;
    my %Param = @_;
    $Self->{Backend} = $Self->{GenericModule}->new(%Param);
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->Auth(%Param);
}
# --

1;

