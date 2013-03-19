# --
# Kernel/Output/HTML/ArticleComposeCrypt.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

    # check if pgp or smime is disabled
    return if !$Self->{ConfigObject}->Get('PGP') && !$Self->{ConfigObject}->Get('SMIME');

    return ('CryptKeyID');
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if pgp or smime is disabled
    return if !$Self->{ConfigObject}->Get('PGP') && !$Self->{ConfigObject}->Get('SMIME');

    my %KeyList = $Self->Data(%Param);

    # find recipient list
    my $Recipient = '';
    for (qw(To Cc Bcc)) {
        if ( $Param{$_} ) {
            $Recipient .= ', ' . $Param{$_};
        }
    }
    my @SearchAddress = ();
    if ($Recipient) {
        @SearchAddress = Mail::Address->parse($Recipient);
    }

    my $Class;

    # backend currently only supports one recipient
    if ( $#SearchAddress > 0 && $Param{CryptKeyID} ) {
        $Self->{Error}->{CryptMultipleRecipient} = 1;
        $Class .= ' ServerError';
    }

    # add crypt options
    my $List = $Self->{LayoutObject}->BuildSelection(
        Data       => \%KeyList,
        Name       => 'CryptKeyID',
        SelectedID => $Param{CryptKeyID} || '',
        Class      => $Class,
    );
    $Self->{LayoutObject}->Block(
        Name => 'Option',
        Data => {
            Name    => 'CryptKeyID',
            Key     => 'Crypt',
            Value   => $List,
            Invalid => 'Just one recipient for crypt is possible!',
        },
    );
    return;
}

sub Data {
    my ( $Self, %Param ) = @_;

    # check if pgp or smime is disabled
    return if !$Self->{ConfigObject}->Get('PGP') && !$Self->{ConfigObject}->Get('SMIME');

    # find recipient list
    my $Recipient = '';
    for (qw(To Cc Bcc)) {
        if ( $Param{$_} ) {
            $Recipient .= ', ' . $Param{$_};
        }
    }
    my @SearchAddress = ();
    if ($Recipient) {
        @SearchAddress = Mail::Address->parse($Recipient);
    }

    # generate key list
    my %KeyList;

    # add non crypt option
    $KeyList{''} = '-none-';

    # backend currently only supports one recipient
    if ( $#SearchAddress > 0 ) {
        return %KeyList;
    }
    elsif (@SearchAddress) {

        # check pgp backend
        my $CryptObjectPGP = Kernel::System::Crypt->new( %{$Self}, CryptType => 'PGP' );
        if ($CryptObjectPGP) {
            my @PublicKeys = $CryptObjectPGP->PublicKeySearch(
                Search => $SearchAddress[0]->address(),
            );
            for my $DataRef (@PublicKeys) {
                my $Expires = '';
                if ( $DataRef->{Expires} ) {
                    $Expires = "[$DataRef->{Expires}]";
                }

                my $Status = '';
                $Status = '[' . $DataRef->{Status} . ']';
                if ( $DataRef->{Status} eq 'expired' ) {
                    $Status = '[WARNING: EXPIRED KEY]';
                }
                elsif ( $DataRef->{Status} eq 'revoked' ) {
                    $Status = '[WARNING: REVOKED KEY]';
                }

                # disable inline pgp if rich text is enabled
                if ( !$Self->{LayoutObject}->{BrowserRichText} ) {
                    $KeyList{"PGP::Inline::$DataRef->{Key}"}
                        = "PGP-Inline: $Status $DataRef->{Key} $Expires $DataRef->{Identifier}";
                }

                $KeyList{"PGP::Detached::$DataRef->{Key}"}
                    = "PGP-Detached: $Status $DataRef->{Key} $Expires $DataRef->{Identifier}";
            }
        }

        # check smime backend
        my $CryptObjectSMIME = Kernel::System::Crypt->new( %{$Self}, CryptType => 'SMIME' );
        if ($CryptObjectSMIME) {
            my @PublicKeys = $CryptObjectSMIME->CertificateSearch(
                Search => $SearchAddress[0]->address(),
            );
            for my $DataRef (@PublicKeys) {
                my $EndDate = '';
                if ( $DataRef->{EndDate} ) {
                    $EndDate = "[$DataRef->{EndDate}]";
                }
                $KeyList{"SMIME::Detached::$DataRef->{Filename}"}
                    = "SMIME-Detached: $DataRef->{Filename} $EndDate $DataRef->{Email}";
            }
        }

    }
    return %KeyList;
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
