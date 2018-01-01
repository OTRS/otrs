# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleCompose::Security;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Mail::Address;
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::PGP',
    'Kernel::System::Crypt::SMIME',
    'Kernel::Output::HTML::Layout',
);

sub Option {
    my ( $Self, %Param ) = @_;

    # Get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    return ('EmailSecurityOptions');
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    my %OptionsList = $Self->Data(%Param);

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # add crypt options
    my $List = $LayoutObject->BuildSelection(
        Data         => \%OptionsList,
        Name         => 'EmailSecurityOptions',
        SelectedID   => $Param{EmailSecurityOptions},
        Class        => "Modernize",
        PossibleNone => 1,
        Sort         => 'AlphanumericValue',
        Translation  => 0,
    );

    $LayoutObject->Block(
        Name => 'Option',
        Data => {
            Name    => 'EmailSecurityOptions',
            Key     => Translatable('Email security'),
            Value   => $List,
            Invalid => '',
        },
    );

    $LayoutObject->AddJSData(
        Key   => 'ArticleComposeOptions.EmailSecurityOptions',
        Value => {
            Name   => 'EmailSecurityOptions',
            Fields => [ 'SignKeyID', 'CryptKeyID' ],
        },
    );

    return;
}

sub Data {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP AND SMIME are disabled
    my $PGPEnabled   = $ConfigObject->Get('PGP');
    my $SMIMEEnabled = $ConfigObject->Get('SMIME');

    return if !$PGPEnabled && !$SMIMEEnabled;

    # Generate options list
    my %OptionsList;

    if ($PGPEnabled) {
        my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

        # Get PGP method (Detached or In-line).
        my $PGPMethod = $ConfigObject->Get('PGP::Method') || 'Detached';

        if (
            $PGPObject
            && (
                $PGPMethod eq 'Detached'
                || ( $PGPMethod eq 'Inline' && !$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{BrowserRichText} )
            )
            )
        {
            $OptionsList{'PGP::Sign::-'}       = Translatable('PGP sign');
            $OptionsList{'PGP::Sign::Encrypt'} = Translatable('PGP sign and encrypt');
            $OptionsList{'PGP::-::Encrypt'}    = Translatable('PGP encrypt');
        }
    }

    if ($SMIMEEnabled) {
        my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

        if ($SMIMEObject) {
            $OptionsList{'SMIME::Sign::-'}       = Translatable('SMIME sign');
            $OptionsList{'SMIME::Sign::Encrypt'} = Translatable('SMIME sign and encrypt');
            $OptionsList{'SMIME::-::Encrypt'}    = Translatable('SMIME encrypt');
        }
    }

    return %OptionsList;
}

sub ArticleOption {
    my ( $Self, %Param ) = @_;

    if ( $Param{EmailSecurityOptions} ) {

        my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

        my $Method = 'Detached';
        if ( $Backend eq 'PGP' ) {
            $Method = $Kernel::OM->Get('Kernel::Config')->Get('PGP::Method') || 'Detached';
        }

        return (
            EmailSecurity => {
                Backend => $Backend,
                Method  => $Method,
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
