# --
# Kernel/System/Crypt.pm - the main crypt module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Crypt.pm,v 1.1 2004-07-30 09:54:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt;

use strict;

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

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject CryptType)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # load generator auth module
    $Self->{GenericModule} = "Kernel::System::Crypt::$Param{CryptType}";
    if (!eval "require $Self->{GenericModule}") {
        die "Can't load crypt backend module $Self->{GenericModule}! $@";
    }
    $Self->{Backend} = $Self->{GenericModule}->new(%Param);

    return $Self;
}
# crypt
sub Crypt {
    my $Self = shift;
    return $Self->{Backend}->Crypt(@_);

}
# decrypt
sub Decrypt {
    my $Self = shift;
    return $Self->{Backend}->Decrypt(@_);
}
# sign
sub Sign {
    my $Self = shift;
    return $Self->{Backend}->Sign(@_);
}
# verify_sign
sub Verify {
    my $Self = shift;
    return $Self->{Backend}->Verify(@_);
}
# search key
sub SearchKey {
    my $Self = shift;
    return $Self->{Backend}->SearchKey(@_);
}
sub SearchPrivateKey {
    my $Self = shift;
    return $Self->{Backend}->SearchPrivateKey(@_);
}
sub SearchPublicKey {
    my $Self = shift;
    return $Self->{Backend}->SearchPublicKey(@_);
}
# get key
sub GetKey {
    my $Self = shift;
    return $Self->{Backend}->GetKey(@_);
}
# delete key
sub DeleteKey {
    my $Self = shift;
    return $Self->{Backend}->DeleteKey(@_);
}
# add key
sub AddKey {
    my $Self = shift;
    return $Self->{Backend}->AddKey(@_);
}

