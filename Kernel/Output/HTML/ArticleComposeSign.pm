# --
# Kernel/Output/HTML/ArticleComposeSign.pm
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleComposeSign.pm,v 1.4 2004-08-11 07:59:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleComposeSign;

use strict;
use Mail::Address;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ParamObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}
# --
sub Option {
    my $Self = shift;
    my %Param = @_;
    return ('SignKeyID');
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    if (!$Param{From}) {
        return;
    }
    my %KeyList = ();
    my @SearchAddress = Mail::Address->parse($Param{From});
    my $CryptObjectPGP = Kernel::System::Crypt->new(%{$Self}, CryptType => 'PGP');
    if ($CryptObjectPGP) {
        my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch(
            Search => $SearchAddress[0]->address(),
        );
        foreach my $DataRef (@PrivateKeys) {
            $KeyList{"PGP::Inline::$DataRef->{Key}"} = "PGP-Inline: $DataRef->{Key} $DataRef->{Identifer}";
            $KeyList{"PGP::Detached::$DataRef->{Key}"} = "PGP-Detached: $DataRef->{Key} $DataRef->{Identifer}";
        }
    }
    my $CryptObjectSMIME = Kernel::System::Crypt->new(%{$Self}, CryptType => 'SMIME');
    if ($CryptObjectSMIME) {
        my @PrivateKeys = $CryptObjectSMIME->PrivateSearch(
            Search => $SearchAddress[0]->address(),
        );
        foreach my $DataRef (@PrivateKeys) {
            $KeyList{"SMIME::Detached::$DataRef->{Hash}"} = "SMIME-Detached: $DataRef->{Hash} $DataRef->{Email}";
        }
    }
    if (%KeyList) {
        $KeyList{''} = '-none-';
        if (!defined($Param{SignKeyID}) && $Self->{ConfigObject}->Get("DefaultSignKey::".$SearchAddress[0]->address())) {
            $Param{SignKeyID} = $Self->{ConfigObject}->Get("DefaultSignKey::".$SearchAddress[0]->address());
        }
        my $List = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%KeyList,
            Name => 'SignKeyID',
            SelectedID => $Param{SignKeyID}
        );
        $Self->{LayoutObject}->Block(
            Name => 'Option',
            Data => {
                Key => 'Sign',
                Value => $List,
            },
        );
    }
    return;
}
# --
sub ArticleOption {
    my $Self = shift;
    my %Param = @_;
    if ($Param{SignKeyID}) {
        my ($Type, $SubType, $Key) = split (/::/, $Param{SignKeyID});
        return (
            Sign => {
                Type => $Type,
                SubType => $SubType,
                Key => $Key,
            },
        );
    }
    return;
}
# --
sub Error {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{Error}) {
        return %{$Self->{Error}};
    }
    else {
        return;
    }
}
# --
1;
