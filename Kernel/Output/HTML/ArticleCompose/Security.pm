# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    'Kernel::System::Queue',
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

    if ( !$Param{EmailSecurityOptions} && $Param{QueueID} ) {

        # Get default signing key from queue data.
        my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $Param{QueueID} );

        # Check if queue has a default signature, in such case check its backend and preselect
        #   email signing security option.
        if ( $Queue{DefaultSignKey} && $Queue{DefaultSignKey} =~ m{\A SMIME}msxi ) {
            $Param{EmailSecurityOptions} = 'SMIME::Sign::-';
        }
        elsif ( $Queue{DefaultSignKey} && $Queue{DefaultSignKey} =~ m{\A PGP}msxi ) {
            $Param{EmailSecurityOptions} = 'PGP::Sign::-';
        }
    }

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

    # Normal return if no EmailSecurityOptions was set.
    return if !$Param{EmailSecurityOptions};

    # Return EmailSecurityOptions to cascade into other ArticleCompose modules.
    return $Param{EmailSecurityOptions};
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

sub GetParamAJAX {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    return if !$Param{QueueID};

    my $EmailSecurityOptions = $Param{EmailSecurityOptions} || '';

    # Get default signing key from queue data.
    my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $Param{QueueID} );

    if ( !$Queue{DefaultSignKey} || $EmailSecurityOptions ) {
        return (
            EmailSecurityOptions => $EmailSecurityOptions,
        );
    }

    # Check if queue has a default signature, in such case check its backend and preselect
    #   email signing security option.
    if ( $Queue{DefaultSignKey} =~ m{\A SMIME}msxi ) {
        $EmailSecurityOptions = 'SMIME::Sign::-';
    }
    elsif ( $Queue{DefaultSignKey} =~ m{\A PGP}msxi ) {
        $EmailSecurityOptions = 'PGP::Sign::-';
    }
    return (
        EmailSecurityOptions => $EmailSecurityOptions,
    );
}

sub Error {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Error} ) {
        return %{ $Self->{Error} };
    }
    return;
}

1;
