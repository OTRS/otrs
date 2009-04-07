# --
# Kernel/Output/HTML/ArticleComposeCrypt.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: ArticleComposeCrypt.pm,v 1.14 2009-04-07 09:24:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleComposeCrypt;

use strict;
use warnings;

use Mail::Address;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ParamObject MainObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Option {
    my ( $Self, %Param ) = @_;

    return ('CryptKeyID');
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Recipient = '';
    for (qw(To Cc Bcc)) {
        if ( $Param{$_} ) {
            $Recipient .= ', ' . $Param{$_};
        }
    }
    my @SearchAddress = Mail::Address->parse($Recipient);
    return if !@SearchAddress;

    my %KeyList;

    # check pgp backend
    my $CryptObjectPGP = Kernel::System::Crypt->new( %{$Self}, CryptType => 'PGP' );
    if ($CryptObjectPGP) {
        my @PublicKeys = $CryptObjectPGP->PublicKeySearch(
            Search => $SearchAddress[0]->address(),
        );
        for my $DataRef (@PublicKeys) {
            $KeyList{"PGP::Detached::$DataRef->{Key}"}
                = "PGP-Detached: $DataRef->{Key} - $DataRef->{Identifier}";
            $KeyList{"PGP::Inline::$DataRef->{Key}"}
                = "PGP-Inline: $DataRef->{Key} - $DataRef->{Identifier}";
        }
    }

    # check smime backend
    my $CryptObjectSMIME = Kernel::System::Crypt->new( %{$Self}, CryptType => 'SMIME' );
    if ($CryptObjectSMIME) {
        my @PublicKeys = $CryptObjectSMIME->CertificateSearch(
            Search => $SearchAddress[0]->address(),
        );
        for my $DataRef (@PublicKeys) {
            $KeyList{"SMIME::Detached::$DataRef->{Hash}"}
                = "SMIME-Detached: $DataRef->{Hash} - $DataRef->{Email}";
        }
    }

    # return if no keys for crypt are available
    return if !%KeyList;

    # backend currently only supports one recipient
    if ( $#SearchAddress > 0 && $Param{CryptKeyID} ) {
        $Self->{Error}->{Recipient} = 1;
        $Self->{LayoutObject}->Block(
            Name => 'Option',
            Data => {
                Key     => 'Crypt',
                Invalid => '* Just one recipient for crypt possible!',
            },
        );
        return;
    }

    # add non crypt option
    $KeyList{''} = '-none-';

    # add crypt options
    my $List = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => \%KeyList,
        Name       => 'CryptKeyID',
        SelectedID => $Param{CryptKeyID}
    );
    $Self->{LayoutObject}->Block(
        Name => 'Option',
        Data => {
            Key   => 'Crypt',
            Value => $List,
        },
    );
    return;
}

sub ArticleOption {
    my ( $Self, %Param ) = @_;

    if ( $Param{CryptKeyID} ) {
        my ( $Type, $SubType, $Key ) = split /::/, $Param{CryptKeyID};
        return (
            Crypt => {
                Type    => $Type,
                SubType => $SubType,
                Key     => $Key,
            },
        );
    }
    return;
}

sub Error {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Error} ) {
        return %{ $Self->{Error} };
    }
    return;
}

1;
