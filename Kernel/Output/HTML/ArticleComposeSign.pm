# --
# Kernel/Output/HTML/ArticleComposeSign.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: ArticleComposeSign.pm,v 1.15 2009-04-07 09:24:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleComposeSign;

use strict;
use warnings;

use Mail::Address;
use Kernel::System::Crypt;
use Kernel::System::Queue;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

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

    return ('SignKeyID');
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{From};

    my @SearchAddress = Mail::Address->parse( $Param{From} );
    my %KeyList;

    # check pgp backend
    my $CryptObjectPGP = Kernel::System::Crypt->new( %{$Self}, CryptType => 'PGP' );
    if ($CryptObjectPGP) {
        my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch(
            Search => $SearchAddress[0]->address(),
        );
        for my $DataRef (@PrivateKeys) {
            $KeyList{"PGP::Inline::$DataRef->{Key}"}
                = "PGP-Inline: $DataRef->{Key} $DataRef->{Identifier}";
            $KeyList{"PGP::Detached::$DataRef->{Key}"}
                = "PGP-Detached: $DataRef->{Key} $DataRef->{Identifier}";
        }
    }

    # check smime backend
    my $CryptObjectSMIME = Kernel::System::Crypt->new( %{$Self}, CryptType => 'SMIME' );
    if ($CryptObjectSMIME) {
        my @PrivateKeys = $CryptObjectSMIME->PrivateSearch(
            Search => $SearchAddress[0]->address(),
        );
        for my $DataRef (@PrivateKeys) {
            $KeyList{"SMIME::Detached::$DataRef->{Hash}"}
                = "SMIME-Detached: $DataRef->{Hash} $DataRef->{Email}";
        }
    }

    # return if no sign keys available
    return if !%KeyList;

    # add non signing option
    $KeyList{''} = '-none-';

    # add singing options
    if ( !defined $Param{SignKeyID} || ( $Param{ExpandCustomerName} && $Param{ExpandCustomerName} == 3 ) ) {

        # get default signing key
        if ( $Param{QueueID} ) {
            my $QueueObject = Kernel::System::Queue->new( %{ $Self } );
            my %Queue = $QueueObject->QueueGet( ID => $Param{QueueID} );
            $Param{SignKeyID} = $Queue{DefaultSignKey} || '';
        }
    }
    my $List = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => \%KeyList,
        Name       => 'SignKeyID',
        SelectedID => $Param{SignKeyID}
    );
    $Self->{LayoutObject}->Block(
        Name => 'Option',
        Data => {
            Key   => 'Sign',
            Value => $List,
        },
    );
    return;
}

sub ArticleOption {
    my ( $Self, %Param ) = @_;

    if ( $Param{SignKeyID} ) {
        my ( $Type, $SubType, $Key ) = split /::/, $Param{SignKeyID};
        return (
            Sign => {
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
