# --
# Kernel/System/CheckItem.pm - the global spellinf module
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CheckItem.pm,v 1.1 2002-12-18 17:27:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CheckItem;

use strict;
use Email::Valid;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # --
    # get needed objects
    # --
    foreach (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}
# --
sub CheckError {
    my $Self = shift;
    return $Self->{Error}; 
}
# --
sub CkeckEmail {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Address)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check if it's to do
    # --
    if (! $Self->{ConfigObject}->Get('CheckEmailAddresses')) {
        return 1;
    }
    # -- 
    # check address
    # --
    if (Email::Valid->address(
                -address => $Param{Address},
                -mxcheck => $Self->{ConfigObject}->Get('CheckMXRecord') || 0,
    )) {
        return 1;
    }
    else {
        $Self->{Error} = "$Email::Valid::Details of $Param{Address}! ";
        return;
    }
}
# --

1;
