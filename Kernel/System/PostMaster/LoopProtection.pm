# --
# Kernel/System/PostMaster/LoopProtection.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: LoopProtection.pm,v 1.12 2007-01-21 01:26:10 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::LoopProtection;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed  objects
    foreach (qw(DBObject LogObject ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # load backend module
    my $BackendModule = $Self->{ConfigObject}->Get('LoopProtectionModule')
        || 'Kernel::System::PostMaster::LoopProtection::DB';
    if (!eval "require $BackendModule") {
        die "Can't load loop protection backend module $BackendModule! $@";
    }

    $Self->{Backend} = $BackendModule->new(%Param);

    return $Self;
}

sub SendEmail {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->SendEmail(%Param);
}

sub Check {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->Check(%Param);
}

1;