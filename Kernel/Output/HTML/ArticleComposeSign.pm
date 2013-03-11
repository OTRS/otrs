# --
# Kernel/Output/HTML/ArticleComposeSign.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

    return ('SignKeyID');
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if pgp or smime is disabled
    return if !$Self->{ConfigObject}->Get('PGP') && !$Self->{ConfigObject}->Get('SMIME');

    my %KeyList = $Self->Data(%Param);

    # add signing options
    if (
        !defined $Param{SignKeyID}
        || ( $Param{ExpandCustomerName} && $Param{ExpandCustomerName} == 3 )
        )
    {

        # get default signing key
        if ( $Param{QueueID} ) {
            my $QueueObject = Kernel::System::Queue->new( %{$Self} );
            my %Queue = $QueueObject->QueueGet( ID => $Param{QueueID} );
            $Param{SignKeyID} = $Queue{DefaultSignKey} || '';
        }
    }
    my $List = $Self->{LayoutObject}->BuildSelection(
        Data       => \%KeyList,
        Name       => 'SignKeyID',
        SelectedID => $Param{SignKeyID},
    );
    $Self->{LayoutObject}->Block(
        Name => 'Option',
        Data => {
            Name  => 'SignKeyID',
            Key   => 'Sign',
            Value => $List,
        },
    );
    return;
}

sub Data {
    my ( $Self, %Param ) = @_;

    # check if pgp or smime is disabled
    return if !$Self->{ConfigObject}->Get('PGP') && !$Self->{ConfigObject}->Get('SMIME');

    # generate key list
    my %KeyList;

    # add non signing option
    $KeyList{''} = '-none-';

    if ( $Param{From} ) {

        my @SearchAddress = Mail::Address->parse( $Param{From} );

        # check pgp backend
        my $CryptObjectPGP = Kernel::System::Crypt->new( %{$Self}, CryptType => 'PGP' );
        if ($CryptObjectPGP) {
            my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch(
                Search => $SearchAddress[0]->address(),
            );
            for my $DataRef (@PrivateKeys) {
                my $Expires = '';
                if ( $DataRef->{Expires} ) {
                    $Expires = "[$DataRef->{Expires}]";
                }

                # disable inline pgp if rich text is enabled
                if ( !$Self->{LayoutObject}->{BrowserRichText} ) {
                    $KeyList{"PGP::Inline::$DataRef->{Key}"}
                        = "PGP-Inline: $DataRef->{Key} $Expires $DataRef->{Identifier}";
                }
                $KeyList{"PGP::Detached::$DataRef->{Key}"}
                    = "PGP-Detached: $DataRef->{Key} $Expires $DataRef->{Identifier}";
            }
        }

        # check smime backend
        my $CryptObjectSMIME = Kernel::System::Crypt->new( %{$Self}, CryptType => 'SMIME' );
        if ($CryptObjectSMIME) {
            my @PrivateKeys = $CryptObjectSMIME->PrivateSearch(
                Search => $SearchAddress[0]->address(),
            );
            for my $DataRef (@PrivateKeys) {
                $KeyList{"SMIME::Detached::$DataRef->{Filename}"}
                    = "SMIME-Detached: $DataRef->{Filename} [$DataRef->{EndDate}] $DataRef->{Email}";
            }
        }

    }
    return %KeyList;
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

sub GetParamAJAX {
    my ( $Self, %Param ) = @_;

    # check if pgp or smime is disabled
    return if !$Self->{ConfigObject}->Get('PGP') && !$Self->{ConfigObject}->Get('SMIME');

    my %Result;

    # get default signing key
    if ( $Param{QueueID} ) {
        my $QueueObject = Kernel::System::Queue->new( %{$Self} );
        my %Queue = $QueueObject->QueueGet( ID => $Param{QueueID} );
        $Result{SignKeyID} = $Queue{DefaultSignKey} || '';
    }

    return %Result;
}

sub Error {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Error} ) {
        return %{ $Self->{Error} };
    }
    return;
}

1;
