# --
# Kernel/System/CheckItem.pm - the global spellinf module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CheckItem.pm,v 1.11 2004-10-08 07:21:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CheckItem;

use strict;
use Email::Valid;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
sub CheckEmail {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Address)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if it's to do
    if (! $Self->{ConfigObject}->Get('CheckEmailAddresses')) {
        return 1;
    }
    # check valid email addesses
    my $RegExp = $Self->{ConfigObject}->Get('CheckEmailValidAddress');
    if ($RegExp && $Param{Address} =~ /$RegExp/i) {
        return 1;
    }
    # check address
    if (Email::Valid->address(
                -address => $Param{Address},
                -mxcheck => $Self->{ConfigObject}->Get('CheckMXRecord') || 0,
    )) {
        # check special stuff
        my $RegExp = $Self->{ConfigObject}->Get('CheckEmailInvalidAddress');
        if ($RegExp && $Param{Address} =~ /$RegExp/i) {
            $Self->{Error} = "invalid $Param{Address}! ";
            return;
        }
        return 1;
    }
    else {
        # log dns problems
        if ($Email::Valid::Details =~ /^DNS/i) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "$Email::Valid::Details!",
            );
        }
        # remember error
        $Self->{Error} = "invalid $Param{Address} ($Email::Valid::Details)! ";
        return;
    }
}
# --

1;
