# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ArticleCompose::Sign;

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
    'Kernel::System::Queue',
);

sub Option {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled.
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    return ('SignKeyID');
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Check if PGP and SMIME are disabled.
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    my %KeyList = $Self->Data(%Param);

    # Sender with unique key won't be displayed in the selection
    my $UniqueSignKeyIDsToRemove = $Self->_GetUniqueSignKeyIDsToRemove(%Param);
    my $InvalidMessage           = '';
    my $Class                    = '';
    if ( IsArrayRefWithData($UniqueSignKeyIDsToRemove) ) {
        UNIQUEKEY:
        for my $UniqueSignKeyIDToRemove ( @{$UniqueSignKeyIDsToRemove} ) {

            next UNIQUEKEY if !defined $KeyList{$UniqueSignKeyIDToRemove};

            if ( $KeyList{$UniqueSignKeyIDToRemove} =~ m/WARNING: EXPIRED KEY].*\] (.*)/ ) {
                $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                    "Cannot use expired signing key: '%s'. ", $1
                );
                $Self->{Error}->{InvalidKey} = 1;
                $Class .= ' ServerError';
            }
            elsif ( $KeyList{$UniqueSignKeyIDToRemove} =~ m/WARNING: REVOKED KEY].*\] (.*)/ ) {
                $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                    "Cannot use revoked signing key: '%s'. ", $1
                );
                $Self->{Error}->{InvalidKey} = 1;
                $Class .= ' ServerError';
            }

            delete $KeyList{$UniqueSignKeyIDToRemove};
        }

    }

    # Add signing options.
    if (
        !defined $Param{SignKeyID}
        || ( $Param{ExpandCustomerName} && $Param{ExpandCustomerName} == 3 )
        )
    {

        # Get default signing key from the queue (if apply) or any other key from queue system
        #   address that fits.
        if ( $Param{QueueID} ) {

            $Param{SignKeyID} = $Self->_PickSignKeyID(%Param) || '';
        }
    }

    if (
        $Param{StoreNew}
        && $Param{EmailSecurityOptions}
        && $Param{EmailSecurityOptions} =~ m{Sign}msxi
        )
    {
        my $CheckSuccess = $Self->_CheckSender(%Param);
        if ( !$CheckSuccess ) {
            if ( IsArrayRefWithData( $Self->{MissingKeys} ) ) {
                $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                    "There are no signing keys available for the addresses '%s'.",
                    join ', ', @{ $Self->{MissingKeys} }
                );
            }
            if ( IsArrayRefWithData( $Self->{MissingSelectedKey} ) ) {
                $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                    "There are no selected signing keys for the addresses '%s'.",
                    join ', ', @{ $Self->{MissingSelectedKey} }
                );
            }
            $Self->{Error}->{SignMissingKey} = 1;
            $Class .= ' ServerError';
        }
    }

    # Check if selected signing keys are expired.
    if ( defined $Param{SignKeyID} && defined $KeyList{ $Param{SignKeyID} } && !$Self->{Error}->{InvalidKey} ) {

        if ( $KeyList{ $Param{SignKeyID} } =~ m/WARNING: EXPIRED KEY].*] (.*)/ ) {
            $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                "Cannot use expired signing key: '%s'. ",
                join ', ', $1
            );
            $Self->{Error}->{InvalidKey} = 1;
            $Class .= ' ServerError';
        }
        elsif ( $KeyList{ $Param{SignKeyID} } =~ m/WARNING: REVOKED KEY].*\] (.*)/ ) {
            $InvalidMessage .= $LayoutObject->{LanguageObject}->Translate(
                "Cannot use revoked signing key: '%s'. ", $1
            );
            $Self->{Error}->{InvalidKey} = 1;
            $Class .= ' ServerError';
        }
    }

    my $List = $LayoutObject->BuildSelection(
        Data         => \%KeyList,
        Name         => 'SignKeyID',
        SelectedID   => $Param{SignKeyID},
        Class        => "$Class Modernize",
        PossibleNone => 1,
    );
    $LayoutObject->Block(
        Name => 'Option',
        Data => {
            Name             => 'SignKeyID',
            Key              => Translatable('Sign'),
            Value            => $List,
            Invalid          => $InvalidMessage,
            FieldExplanation => Translatable(
                'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.'
            ),
        },
    );

    return;
}

sub Data {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    # generate key list
    my %KeyList;

    return %KeyList if !$Param{From};

    my @SearchAddress = Mail::Address->parse( $Param{From} );

    return %KeyList if !$Param{EmailSecurityOptions};

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    return %KeyList if !$Backend;
    return %KeyList if !$Sign;
    return %KeyList if $Sign ne 'Sign';

    # check PGP backend
    if ( $Backend eq 'PGP' ) {

        my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

        return %KeyList if !$PGPObject;

        # Get PGP method (Detached or In-line).
        my $PGPMethod = $ConfigObject->Get('PGP::Method') || 'Detached';

        if (
            $PGPMethod eq 'Detached'
            || ( $PGPMethod eq 'Inline' && !$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{BrowserRichText} )
            )
        {
            my @PrivateKeys = $PGPObject->PrivateKeySearch(
                Search => $SearchAddress[0]->address(),
            );
            for my $DataRef (@PrivateKeys) {
                my $Expires = '';
                if ( $DataRef->{Expires} ) {
                    $Expires = "[$DataRef->{Expires}]";
                }

                my $Status = '[' . $DataRef->{Status} . ']';
                if ( $DataRef->{Status} eq 'expired' ) {
                    $Status = '[WARNING: EXPIRED KEY]';
                }
                elsif ( $DataRef->{Status} eq 'revoked' ) {
                    $Status = '[WARNING: REVOKED KEY]';
                }

                $KeyList{"PGP::$DataRef->{Key}"} = "PGP: $Status $DataRef->{Key} $Expires $DataRef->{Identifier}";
            }
        }
    }

    # Check SMIME backend.
    elsif ( $Backend eq 'SMIME' ) {

        my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

        return %KeyList if !$SMIMEObject;

        my @PrivateKeys = $SMIMEObject->PrivateSearch(
            Search => $SearchAddress[0]->address(),
        );
        for my $DataRef (@PrivateKeys) {
            my $Expired = '';
            my $EndDate = ( defined $DataRef->{EndDate} ) ? "[$DataRef->{EndDate}]" : '';

            if ( defined $DataRef->{EndDate} && $SMIMEObject->KeyExpiredCheck( EndDate => $DataRef->{EndDate} ) ) {
                $Expired = ' [WARNING: EXPIRED KEY]';
            }

            $KeyList{"SMIME::$DataRef->{Filename}"} = "SMIME:$Expired $DataRef->{Filename} $EndDate $DataRef->{Email}";
        }
    }

    return %KeyList;
}

sub ArticleOption {
    my ( $Self, %Param ) = @_;

    if ( $Param{SignKeyID} ) {

        my ( $Type, $Key ) = split /::/, $Param{SignKeyID};

        $Param{EmailSecurity}->{SignKey} = $Key;

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

    return if !$Param{QueueID} && !$Param{From};

    return (
        SignKeyID => $Self->_PickSignKeyID(%Param) || '',
    );
}

sub Error {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Error} ) {
        return %{ $Self->{Error} };
    }
    return;
}

sub _CheckSender {
    my ( $Self, %Param ) = @_;

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    # Stop checking if no backed was selected.
    return 1 if !$Backend;
    return 1 if $Sign ne 'Sign';

    # Get encrypt object.
    my $EncryptObject = $Kernel::OM->Get("Kernel::System::Crypt::$Backend");

    # Return error if encrypt object could not be created.
    return 0 if !$EncryptObject;

    # Create a selected sign keys lookup table
    my %SelectedSignKeyIDs = (
        $Param{SignKeyID} => 1,
    );

    # Sender with unique key isn't part of the selection so add it manually
    my $UniqueSignKeyIDsToRemove = $Self->_GetUniqueSignKeyIDsToRemove(%Param);
    if ( IsArrayRefWithData($UniqueSignKeyIDsToRemove) ) {
        for my $UniqueSignKeyIDToRemove ( @{$UniqueSignKeyIDsToRemove} ) {
            $SelectedSignKeyIDs{$UniqueSignKeyIDToRemove} = 1;
        }
    }

    my $MissingSelectedKeyFlag;
    my $MissingKeysFlag;

    my @SearchAddress = Mail::Address->parse( $Param{From} );

    ADDRESS:
    for my $Address (@SearchAddress) {

        my $EmailAddress = $Address->address();

        my @PrivateKeys;
        if ( $Backend eq 'PGP' ) {
            @PrivateKeys = $EncryptObject->PrivateKeySearch(
                Search => $EmailAddress,
            );
        }
        else {
            @PrivateKeys = $EncryptObject->PrivateSearch(
                Search => $EmailAddress,
            );
        }

        # Remember addresses with no sign keys available
        if ( !@PrivateKeys ) {
            push @{ $Self->{MissingKeys} }, $EmailAddress;
            $MissingKeysFlag = 1;
            next ADDRESS;
        }

        $MissingSelectedKeyFlag = 1;

        PRIVATEKEY:
        for my $PrivateKey (@PrivateKeys) {

            my $SignKeyID;
            if ( $Backend eq 'PGP' ) {
                $SignKeyID = "PGP::$PrivateKey->{Key}";
            }
            else {
                $SignKeyID = "SMIME::$PrivateKey->{Filename}";
            }

            # If this key is selected everything is fine, remove missing key flag and check next
            #   address.
            if ( $SelectedSignKeyIDs{$SignKeyID} ) {
                $MissingSelectedKeyFlag = 0;
                next ADDRESS;
            }
        }

        push @{ $Self->{MissingSelectedKey} }, $EmailAddress;
    }

    # Return error if there was no sign key available for an email address.
    return if $MissingKeysFlag;

    # Return error if there was no selected key for an email address.
    return if $MissingSelectedKeyFlag;

    # Otherwise return success
    return 1;
}

sub _PickSignKeyID {
    my ( $Self, %Param ) = @_;

    # Get the list of keys for the current backend.
    my %KeyList = $Self->Data(%Param);

    # Return nothing if there are no possible encrypt keys;
    return if !%KeyList;

    # Check if signing key is still valid for the selected backend.
    if (
        $Param{SignKeyID}
        && $KeyList{ $Param{SignKeyID} } && $KeyList{ $Param{SignKeyID} } !~ m/WARNING: EXPIRED KEY/
        )
    {
        return $Param{SignKeyID};
    }

    my $SignKeyID = '';
    if ( $Param{QueueID} ) {

        # Get default signing key from queue data.
        my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $Param{QueueID} );
        $SignKeyID = $Queue{DefaultSignKey} || '';
    }

    # Convert legacy stored default sign keys.
    if ( $SignKeyID =~ m{ (?: Inline|Detached ) }msx ) {
        my ( $Type, $SubType, $Key ) = split /::/, $SignKeyID;
        $SignKeyID = "$Type::$Key";
    }

    # if there is a preselected key from the queue, use it.
    if ( $SignKeyID && $KeyList{$SignKeyID} && $KeyList{$SignKeyID} !~ m/WARNING: EXPIRED KEY/ ) {
        return $SignKeyID;
    }

    # Get email security options.
    return if !$Param{EmailSecurityOptions};
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    # Return nothing if Backend is not present.
    return if !$Backend;

    # Get encrypt object.
    my $EncryptObject = $Kernel::OM->Get("Kernel::System::Crypt::$Backend");

    # Return nothing if encrypt object was not created
    return if !$EncryptObject;

    my @SearchAddress = Mail::Address->parse( $Param{From} );

    # Search for privates keys for queue system address.
    my @PrivateKeys;
    if ( $Backend eq 'PGP' ) {
        @PrivateKeys = $EncryptObject->PrivateKeySearch(
            Search => $SearchAddress[0]->address(),
        );

        @PrivateKeys = sort { $a->{Expires} cmp $b->{Expires} } grep { $_->{Status} eq 'good' } @PrivateKeys;
    }
    else {
        @PrivateKeys = $EncryptObject->PrivateSearch(
            Search => $SearchAddress[0]->address(),
            Valid  => 1,
        );
        @PrivateKeys = sort { $a->{ShortEndDate} cmp $b->{ShortEndDate} } @PrivateKeys;
    }

    # If there are no private keys for this queue, return nothing.
    return if !@PrivateKeys;

    # Use the last key for the selected backend.
    if ( $Backend eq 'PGP' ) {
        $SignKeyID = "PGP::$PrivateKeys[-1]->{Key}";
    }
    else {
        $SignKeyID = "SMIME::$PrivateKeys[-1]->{Filename}";
    }

    return $SignKeyID;

}

sub GetOptionsToRemoveAJAX {
    my ( $Self, %Param ) = @_;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if PGP and SMIME are disabled
    return if !$ConfigObject->Get('PGP') && !$ConfigObject->Get('SMIME');

    my $OptionsToRemove = $Self->_GetUniqueSignKeyIDsToRemove(%Param);

    return if !IsArrayRefWithData($OptionsToRemove);

    return @{$OptionsToRemove};
}

sub _GetUniqueSignKeyIDsToRemove {
    my ( $Self, %Param ) = @_;

    # Get the list of keys for the current backend.
    my %KeyList = $Self->Data(%Param);

    # Return nothing if there are no possible sign keys;
    return if !%KeyList;

    # Return nothing if there are no security options.
    return if !defined $Param{EmailSecurityOptions};

    # Get email security options.
    my ( $Backend, $Sign, $Encrypt ) = split /::/, $Param{EmailSecurityOptions};

    return if !$Backend;
    return if !$Sign || $Sign ne 'Sign';

    # Get encrypt object.
    my $EncryptObject = $Kernel::OM->Get("Kernel::System::Crypt::$Backend");

    # Return nothing if encrypt object was not created
    return if !$EncryptObject;

    my %UniqueSignKeyIDsToRemove;

    my @SearchAddress = Mail::Address->parse( $Param{From} );

    ADDRESS:
    for my $Address (@SearchAddress) {

        my @PrivateKeys;
        if ( $Backend eq 'PGP' ) {
            @PrivateKeys = $EncryptObject->PrivateKeySearch(
                Search => $Address->address(),
            );
        }
        else {
            @PrivateKeys = $EncryptObject->PrivateSearch(
                Search => $Address->address(),
            );
        }

        # Only unique keys will be removed, so skip to next address if there
        # is not exactly one key
        next ADDRESS if @PrivateKeys != 1;

        my $PrivateKey = shift @PrivateKeys;

        my $SignKeyID;
        if ( $Backend eq 'PGP' ) {
            $SignKeyID = "PGP::$PrivateKey->{Key}";
        }
        else {
            $SignKeyID = "SMIME::$PrivateKey->{Filename}";
        }

        $UniqueSignKeyIDsToRemove{$SignKeyID} = 1;
    }

    my @UniqueSignKeyIDsToRemove = sort keys %UniqueSignKeyIDsToRemove;

    return \@UniqueSignKeyIDsToRemove;
}

1;
