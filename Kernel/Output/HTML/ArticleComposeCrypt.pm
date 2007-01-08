# --
# Kernel/Output/HTML/ArticleComposeCrypt.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ArticleComposeCrypt.pm,v 1.8 2007-01-08 17:00:42 martin Exp $
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
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ParamObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Option {
    my $Self = shift;
    my %Param = @_;
    return ('CryptKeyID');
}

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
    if (@SearchAddress) {
        my %KeyList = ();
        my $CryptObjectPGP = Kernel::System::Crypt->new(%{$Self}, CryptType => 'PGP');
        if ($CryptObjectPGP) {
            my @PublicKeys = $CryptObjectPGP->PublicKeySearch(
                Search => $SearchAddress[0]->address(),
            );
            foreach my $DataRef (@PublicKeys) {
                $KeyList{"PGP::Detached::$DataRef->{Key}"} = "PGP-Detached: $DataRef->{Key} - $DataRef->{Identifier}";
                $KeyList{"PGP::Inline::$DataRef->{Key}"} = "PGP-Inline: $DataRef->{Key} - $DataRef->{Identifier}";
            }
        }
        my $CryptObjectSMIME = Kernel::System::Crypt->new(%{$Self}, CryptType => 'SMIME');
        if ($CryptObjectSMIME) {
            my @PublicKeys = $CryptObjectSMIME->CertificateSearch(
                Search => $SearchAddress[0]->address(),
            );
            foreach my $DataRef (@PublicKeys) {
                $KeyList{"SMIME::Detached::$DataRef->{Hash}"} = "SMIME-Detached: $DataRef->{Hash} - $DataRef->{Email}";
            }
        }
        if (%KeyList) {
            if ($#SearchAddress > 0 && $Param{CryptKeyID}) {
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

sub ArticleOption {
    my $Self = shift;
    my %Param = @_;
    if ($Param{CryptKeyID}) {
        my ($Type, $SubType, $Key) = split (/::/, $Param{CryptKeyID});
        return (
            Crypt => {
                Type => $Type,
                SubType => $SubType,
                Key => $Key,
            },
        );
    }
    return;
}

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

1;
