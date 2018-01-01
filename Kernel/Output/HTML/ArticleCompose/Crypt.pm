# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleCompose::Crypt;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Mail::Address;
use Kernel::Language qw(Translatable);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::PGP',
    'Kernel::System::Crypt::SMIME',
    'Kernel::Output::HTML::Layout',
);

sub Option {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled.
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    return ('CryptKeyID');
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled.
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    my %KeyList = $Self->Data(%Param);

    # Recipients with unique public keys won't be displayed in the selection
    my $UniqueEncryptKeyIDsToRemove = $Self->_GetUniqueEncryptKeyIDsToRemove(%Param);
    if ( IsArrayRefWithData($UniqueEncryptKeyIDsToRemove) ) {
        for my $UniqueEncryptKeyIDToRemove ( @{$UniqueEncryptKeyIDsToRemove} ) {
            delete $KeyList{$UniqueEncryptKeyIDToRemove};
        }
    }

    # Find recipient list.
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

    my $Class = '';

    if (
        !IsArrayRefWithData( $Param{CryptKeyID} )
        || ( $Param{ExpandCustomerName} && $Param{ExpandCustomerName} == 3 )
        )
    {
        $Param{CryptKeyID} = $Self->_PickEncryptKeyIDs(%Param);
    }

    # Get layout object.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $InvalidMessage;

    # Check if all recipients have at least a key selected
    if (
        $Param{StoreNew}
        && $Param{EmailSecurityOptions}
        && $Param{EmailSecurityOptions} =~ m{Encrypt}msxi
        )
    {
        my $CheckSuccess = $Self->_CheckRecipient(%Param);
        if ( !$CheckSuccess ) {
            if ( IsArrayRefWithData( $Self->{MissingKeys} ) ) {
                $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                    "There are no encryption keys available for the addresses: '%s'. ",
                    join ', ', @{ $Self->{MissingKeys} }
                );
            }
            if ( IsArrayRefWithData( $Self->{MissingSelectedKey} ) ) {
                $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                    "There are no selected encryption keys for the addresses: '%s'. ",
                    join ', ', @{ $Self->{MissingSelectedKey} }
                );
            }
            $Self->{Error}->{EncryptMissingKey} = 1;
            $Class .= ' ServerError';
        }
    }

    # Add encrypt options.
    my $List = $LayoutObject->BuildSelection(
        Data         => \%KeyList,
        Name         => 'CryptKeyID',
        SelectedID   => $Param{CryptKeyID} || '',
        Class        => "$Class Modernize",
        Max          => 150,
        Multiple     => 1,
        PossibleNone => 1.
    );

    $LayoutObject->Block(
        Name => 'Option',
        Data => {
            Name             => 'CryptKeyID',
            Key              => Translatable('Encrypt'),
            Value            => $List,
            Invalid          => $InvalidMessage,
            FieldExplanation => Translatable(
                'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.'
            ),
        },
    );
    return;
}

sub Data {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP or SMIME is disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    # Find recipient list.
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

    # Generate key list.
    my %KeyList;

    return %KeyList if !@SearchAddress;
    return %KeyList if !$Param{EmailSecurityOptions};

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    return %KeyList if !$Backend;
    return %KeyList if !$Encrypt;
    return %KeyList if $Encrypt ne 'Encrypt';

    # Check PGP backend.
    if ( $Backend eq 'PGP' ) {

        my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

        return %KeyList if !$PGPObject;

        # Get PGP method (Detached or In-line).
        my $PGPMethod = $ConfigObject->Get('PGP::Method') || 'Detached';

        # For PGP In-line Rich-text editor needs to be disabled.
        if (
            $PGPMethod eq 'Detached'
            || ( $PGPMethod eq 'Inline' && !$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{BrowserRichText} )
            )
        {
            for my $SearchAddress (@SearchAddress) {
                my @PublicKeys = $PGPObject->PublicKeySearch(
                    Search => $SearchAddress->address(),
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

                    $KeyList{"PGP::$DataRef->{Key}::$DataRef->{Identifier}"}
                        = "PGP: $Status $DataRef->{Key} $Expires $DataRef->{Identifier}";
                }
            }
        }
    }

    # Check SMIME backend.
    elsif ( $Backend eq 'SMIME' ) {

        my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

        return %KeyList if !$SMIMEObject;

        for my $SearchAddress (@SearchAddress) {
            my @PublicKeys = $SMIMEObject->CertificateSearch(
                Search => $SearchAddress->address(),
            );
            for my $DataRef (@PublicKeys) {
                my $EndDate = '';
                if ( $DataRef->{EndDate} ) {
                    $EndDate = "[$DataRef->{EndDate}]";
                }
                $KeyList{"SMIME::$DataRef->{Filename}::$DataRef->{Email}"}
                    = "SMIME: $DataRef->{Filename} $EndDate $DataRef->{Email}";
            }
        }
    }

    return %KeyList;
}

sub ArticleOption {
    my ( $Self, %Param ) = @_;

    if ( IsArrayRefWithData( $Param{CryptKeyID} ) ) {
        my @Keys;
        for my $EncryptKey ( @{ $Param{CryptKeyID} } ) {
            my ( $Type, $Key ) = split /::/, $EncryptKey;
            push @Keys, $Key;
        }

        $Param{EmailSecurity}->{EncryptKeys} = \@Keys;

        return (
            EmailSecurity => $Param{EmailSecurity},
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

    return (
        CryptKeyID => $Self->_PickEncryptKeyIDs(%Param),
    );
}

sub Error {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Error} ) {
        return %{ $Self->{Error} };
    }
    return;
}

sub _CheckRecipient {
    my ( $Self, %Param ) = @_;

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    # Stop checking if no backed was selected.
    return 1 if !$Backend;
    return 1 if $Encrypt ne 'Encrypt';

    # Get encrypt object.
    my $EncryptObject = $Kernel::OM->Get("Kernel::System::Crypt::$Backend");

    # Return error if encrypt object could not be created.
    return 0 if !$EncryptObject;

    # Create a selected encryption keys lookup table
    my %SelectedEncryptKeyIDs = map { $_ => 1 } @{ $Param{CryptKeyID} };

    # Recipients with unique public keys aren't part of the selection so add them manually
    my $UniqueEncryptKeyIDsToRemove = $Self->_GetUniqueEncryptKeyIDsToRemove(%Param);
    if ( IsArrayRefWithData($UniqueEncryptKeyIDsToRemove) ) {
        for my $UniqueEncryptKeyIDToRemove ( @{$UniqueEncryptKeyIDsToRemove} ) {
            $SelectedEncryptKeyIDs{$UniqueEncryptKeyIDToRemove} = 1;
        }
    }

    my $MissingSelectedKeyFlag;
    my $MissingKeysFlag;

    # Check each recipient type.
    RECIPIENTTYPE:
    for my $RecipientType (qw(To Cc Bcc)) {

        # Get all addresses for each recipient type.
        my @SearchAddress;
        if ( $Param{$RecipientType} ) {
            @SearchAddress = Mail::Address->parse( $Param{$RecipientType} );
        }

        # Get all certificates/public keys for each address.
        ADDRESS:
        for my $Address (@SearchAddress) {

            my $EmailAddress = $Address->address();

            my @PublicKeys;
            if ( $Backend eq 'PGP' ) {
                @PublicKeys = $EncryptObject->PublicKeySearch(
                    Search => $EmailAddress,
                );
            }
            else {
                @PublicKeys = $EncryptObject->CertificateSearch(
                    Search => $EmailAddress,
                );
            }

            # Remember addresses with no encryption keys available
            if ( !@PublicKeys ) {
                push @{ $Self->{MissingKeys} }, $EmailAddress;
                $MissingKeysFlag = 1;
                next ADDRESS;
            }

            $MissingSelectedKeyFlag = 1;

            PUBLICKEY:
            for my $PublicKey (@PublicKeys) {

                my $EncryptKeyID;
                if ( $Backend eq 'PGP' ) {
                    $EncryptKeyID = "PGP::$PublicKey->{Key}::$PublicKey->{Identifier}";
                }
                else {
                    $EncryptKeyID = "SMIME::$PublicKey->{Filename}::$PublicKey->{Email}";
                }

                # If this key is selected everything is fine, remove missing key flag and check next
                #   address.
                if ( $SelectedEncryptKeyIDs{$EncryptKeyID} ) {
                    $MissingSelectedKeyFlag = 0;
                    next ADDRESS;
                }
            }

            push @{ $Self->{MissingSelectedKey} }, $EmailAddress;
        }
    }

    # Return error if there was no encryption keys available for an email address.
    return if $MissingKeysFlag;

    # Return error if there was no selected key for an email address.
    return if $MissingSelectedKeyFlag;

    # Otherwise return success
    return 1;
}

sub _PickEncryptKeyIDs {
    my ( $Self, %Param ) = @_;

    # Get the list of keys for the current backend.
    my %KeyList = $Self->Data(%Param);

    # Return nothing if there are no possible encrypt keys;
    return [] if !%KeyList;

    my %SelectedEncryptKeyIDs;

    # Check if encryption keys are still valid for the selected backend, otherwise remove them.
    ENCRYPTKEYID:
    for my $EncryptKeyID ( @{ $Param{CryptKeyID} } ) {
        next ENCRYPTKEYID if !$EncryptKeyID;
        next ENCRYPTKEYID if !$KeyList{$EncryptKeyID};

        $SelectedEncryptKeyIDs{$EncryptKeyID} = 1;
    }

    # Return nothing if there are no security options.
    return [] if !defined $Param{EmailSecurityOptions};

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    # Return nothing if Backend is not present.
    return [] if !$Backend;

    # Get encrypt object.
    my $EncryptObject = $Kernel::OM->Get("Kernel::System::Crypt::$Backend");

    # Return nothing if encrypt object was not created
    return [] if !$EncryptObject;

    # Check each recipient type.
    for my $RecipientType (qw(To Cc Bcc)) {

        # Get all addresses for each recipient type.
        my @SearchAddress;
        if ( $Param{$RecipientType} ) {
            @SearchAddress = Mail::Address->parse( $Param{$RecipientType} );
        }

        ADDRESS:
        for my $Address (@SearchAddress) {

            my @PublicKeys;
            if ( $Backend eq 'PGP' ) {
                @PublicKeys = $EncryptObject->PublicKeySearch(
                    Search => $Address->address(),
                );
            }
            else {
                @PublicKeys = $EncryptObject->CertificateSearch(
                    Search => $Address->address(),
                );
            }

            # If there are no public keys for this recipient, do nothing and check the next one.
            next ADDRESS if !@PublicKeys;

            my @EncryptKeyIDs;

            # Check / store all keys.
            PUBLICKEY:
            for my $PublicKey (@PublicKeys) {

                my $EncryptKeyID;
                if ( $Backend eq 'PGP' ) {
                    $EncryptKeyID = "PGP::$PublicKey->{Key}::$PublicKey->{Identifier}";
                }
                else {
                    $EncryptKeyID = "SMIME::$PublicKey->{Filename}::$PublicKey->{Email}";
                }

                # Do nothing if key is already selected, check next address.
                next ADDRESS if $SelectedEncryptKeyIDs{$EncryptKeyID};

                # Add key to possible encryption keys
                push @EncryptKeyIDs, $EncryptKeyID;
            }

            for my $EncryptKeyID (@EncryptKeyIDs) {

                # Select the first key and check the next address.
                $SelectedEncryptKeyIDs{$EncryptKeyID} = 1;
                next ADDRESS;
            }
        }
    }

    my @EncryptKeyIDs = sort keys %SelectedEncryptKeyIDs;
    return \@EncryptKeyIDs;
}

sub GetOptionsToRemoveAJAX {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    my $OptionsToRemove = $Self->_GetUniqueEncryptKeyIDsToRemove(%Param);
    return if !IsArrayRefWithData($OptionsToRemove);

    return @{$OptionsToRemove};
}

sub _GetUniqueEncryptKeyIDsToRemove {
    my ( $Self, %Param ) = @_;

    # Get the list of keys for the current backend.
    my %KeyList = $Self->Data(%Param);

    # Return nothing if there are no possible encrypt keys;
    return if !%KeyList;

    # Return nothing if there are no security options.
    return if !defined $Param{EmailSecurityOptions};

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    return if !$Backend;
    return if !$Encrypt || $Encrypt ne 'Encrypt';

    # Get encrypt object.
    my $EncryptObject = $Kernel::OM->Get("Kernel::System::Crypt::$Backend");

    # Return nothing if encrypt object was not created
    return if !$EncryptObject;

    my %UniqueEncryptKeyIDsToRemove;

    # Check each recipient type.
    for my $RecipientType (qw(To Cc Bcc)) {

        # Get all addresses for each recipient type.
        my @SearchAddress;
        if ( $Param{$RecipientType} ) {
            @SearchAddress = Mail::Address->parse( $Param{$RecipientType} );
        }

        ADDRESS:
        for my $Address (@SearchAddress) {

            my @PublicKeys;
            if ( $Backend eq 'PGP' ) {
                @PublicKeys = $EncryptObject->PublicKeySearch(
                    Search => $Address->address(),
                );
            }
            else {
                @PublicKeys = $EncryptObject->CertificateSearch(
                    Search => $Address->address(),
                );
            }

            # Only unique public keys will be removed, so skip to next address if there
            # is not exactly one public key
            next ADDRESS if @PublicKeys != 1;

            my $PublicKey = shift @PublicKeys;

            my $EncryptKeyID;
            if ( $Backend eq 'PGP' ) {
                $EncryptKeyID = "PGP::$PublicKey->{Key}::$PublicKey->{Identifier}";
            }
            else {
                $EncryptKeyID = "SMIME::$PublicKey->{Filename}::$PublicKey->{Email}";
            }

            $UniqueEncryptKeyIDsToRemove{$EncryptKeyID} = 1;
        }
    }

    my @UniqueEncryptKeyIDsToRemove = sort keys %UniqueEncryptKeyIDsToRemove;
    return \@UniqueEncryptKeyIDsToRemove;
}

1;
