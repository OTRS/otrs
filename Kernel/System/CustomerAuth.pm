# --
# Kernel/System/CustomerAuth.pm - provides the authentification 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerAuth.pm,v 1.3 2003-02-08 15:09:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerAuth; 

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.3 $';
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
    my $GeneratorModule = $Self->{ConfigObject}->Get('Customer::AuthModule')
      || 'Kernel::System::CustomerAuth::DB';
    eval "require $GeneratorModule";

    $Self->{Backend} = $GeneratorModule->new(%Param);

    return $Self;
}
# --
sub Auth {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->Auth(%Param);
}
# --

1;

