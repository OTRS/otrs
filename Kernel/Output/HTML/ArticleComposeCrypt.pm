# --
# Kernel/Output/HTML/ArticleComposeCrypt.pm
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleComposeCrypt.pm,v 1.1 2004-07-30 09:55:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleComposeCrypt;

use strict;
use Mail::Address;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    $Self->{CryptObject} = Kernel::System::Crypt->new(%Param, CryptType => 'PGP');
    return $Self;
}
# --
sub Option {
    my $Self = shift;
    my %Param = @_;
    return ('CryptKeyID');
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Recipient = '';
    foreach (qw(To Cc Bcc)) {
        if ($Param{$_}) {
            $Recipient .= ", $Param{$_}";
        }
    }
    my @SearchAddress = Mail::Address->parse($Recipient);
    if ($#SearchAddress > 0) {
        $Self->{Error}->{Recipient} = 1;
        $Self->{LayoutObject}->Block(
            Name => 'Option',
            Data => {
                Key => 'Crypt',
                Invalid => '* Just one recipient for crypt possible!',
            },
        );
        return;
    }
    if ($#SearchAddress == 0) {
        my @PublicKeys = $Self->{CryptObject}->SearchPublicKey(Search => $SearchAddress[0]->address());
        my %KeyList = ();
        foreach my $DataRef (@PublicKeys) {
            $KeyList{"PGP::$DataRef->{Key}"} = "PGP: $DataRef->{Key} $DataRef->{Identifer}";
        }
        if (%KeyList) {
            $KeyList{''} = '-none-';
            my $List = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => \%KeyList,
                Name => 'CryptKeyID',
                SelectedID => $Param{CryptKeyID}
            );
            $Self->{LayoutObject}->Block(
                Name => 'Option',
                Data => {
                    Key => 'Crypt',
                    Value => $List,
                },
            );
        }
        return;
    }
}
# --
sub ArticleOption {
    my $Self = shift;
    my %Param = @_;
    if ($Param{CryptKeyID}) {
        my ($Type, $Key) = split (/::/, $Param{CryptKeyID});
        return (
            Crypt => {
                Type => $Type,
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
