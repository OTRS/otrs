# --
# Kernel/System/Crypt/SMIME.pm - the main crypt module
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: SMIME.pm,v 1.55 2012-01-16 11:30:23 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Crypt::SMIME;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.55 $) [1];

=head1 NAME

Kernel::System::Crypt::SMIME - smime crypt backend lib

=head1 SYNOPSIS

This is a sub module of Kernel::System::Crypt and contains all smime functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item Check()

check if environment is working

    my $Message = $CryptObject->Check();

=cut

sub Check {
    my ( $Self, %Param ) = @_;

    if ( !-e $Self->{Bin} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such $Self->{Bin}!",
        );
        return "No such $Self->{Bin}!";
    }
    elsif ( !-x $Self->{Bin} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Self->{Bin} not executable!",
        );
        return "$Self->{Bin} not executable!";
    }
    elsif ( !-e $Self->{CertPath} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such $Self->{CertPath}!",
        );
        return "No such $Self->{CertPath}!";
    }
    elsif ( !-d $Self->{CertPath} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such $Self->{CertPath} directory!",
        );
        return "No such $Self->{CertPath} directory!";
    }
    elsif ( !-w $Self->{CertPath} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Self->{CertPath} not writable!",
        );
        return "$Self->{CertPath} not writable!";
    }
    elsif ( !-e $Self->{PrivatePath} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such $Self->{PrivatePath}!",
        );
        return "No such $Self->{PrivatePath}!";
    }
    elsif ( !-d $Self->{PrivatePath} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such $Self->{PrivatePath} directory!",
        );
        return "No such $Self->{PrivatePath} directory!";
    }
    elsif ( !-w $Self->{PrivatePath} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Self->{PrivatePath} not writable!",
        );
        return "$Self->{PrivatePath} not writable!";
    }
    return;
}

=item Crypt()

crypt a message

    my $Message = $CryptObject->Crypt(
        Message  => $Message,
        Filename => $CertificateFilename,
    );

    my $Message = $CryptObject->Crypt(
        Message     => $Message,
        Hash        => $CertificateHash,
        Fingerprint => $CertificateFingerprint,
    );

=cut

sub Crypt {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    if ( !$Param{Filename} && !( $Param{Hash} || $Param{Fingerprint} ) ) {
        $Self->{LogObject}->Log(
            Message  => "Need Param: Filename or Hash and Fingerprint!",
            Priority => 'error',
        );
        return;
    }

    my $Certificate = $Self->CertificateGet(%Param);
    my ( $FHCertificate, $CertFile ) = $Self->{FileTempObject}->TempFile();
    print $FHCertificate $Certificate;
    close $FHCertificate;
    my ( $FH, $PlainFile ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;
    my ( $FHCrypted, $CryptedFile ) = $Self->{FileTempObject}->TempFile();
    close $FHCrypted;

    my $Options
        = "smime -encrypt -binary -des3 -in $PlainFile -out $CryptedFile $CertFile";
    my $LogMessage = $Self->_CleanOutput(qx{$Self->{Cmd} $Options 2>&1});
    if ($LogMessage) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't crypt: $LogMessage!" );
        return;
    }

    my $CryptedRef = $Self->{MainObject}->FileRead( Location => $CryptedFile );
    return if !$CryptedRef;
    return $$CryptedRef;
}

=item Decrypt()

decrypt a message and returns a hash (Successful, Message, Data)

    my %Message = $CryptObject->Decrypt(
        Message  => $CryptedMessage,
        Filename => $Filename,
    );

    my %Message = $CryptObject->Decrypt(
        Message     => $CryptedMessage,
        Hash        => $Hash,
        Fingerprint => $Fingerprint,
    );

=cut

sub Decrypt {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    if ( !$Param{Filename} && !( $Param{Hash} || $Param{Fingerprint} ) ) {
        $Self->{LogObject}->Log(
            Message  => "Need Param: Filename or Hash and Fingerprint!",
            Priority => 'error',
        );
        return;
    }

    my $Certificate = $Self->CertificateGet(%Param);
    my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );
    my ( $Private, $Secret ) = $Self->PrivateGet(%Attributes);

    my ( $FHPrivate, $PrivateKeyFile ) = $Self->{FileTempObject}->TempFile();
    print $FHPrivate $Private;
    close $FHPrivate;
    my ( $FHCertificate, $CertFile ) = $Self->{FileTempObject}->TempFile();
    print $FHCertificate $Certificate;
    close $FHCertificate;
    my ( $FH, $CryptedFile ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;
    my ( $FHDecrypted, $PlainFile ) = $Self->{FileTempObject}->TempFile();
    close $FHDecrypted;
    my ( $FHSecret, $SecretFile ) = $Self->{FileTempObject}->TempFile();
    print $FHSecret $Secret;
    close $FHSecret;

    my $Options
        = "smime -decrypt -in $CryptedFile -out $PlainFile -recip $CertFile -inkey $PrivateKeyFile"
        . " -passin file:$SecretFile";
    my $LogMessage = qx{$Self->{Cmd} $Options 2>&1};
    unlink $SecretFile;

    if (
        $Param{SearchingNeededKey}
        && $LogMessage =~ m{PKCS7_dataDecode:no recipient matches certificate}
        && $LogMessage =~ m{PKCS7_decrypt:decrypt error}
        )
    {
        return (
            Successful => 0,
            Message    => 'Impossible to decrypt with installed private keys!',
        );
    }

    if ($LogMessage) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't decrypt: $LogMessage!" );
        return (
            Successful => 0,
            Message    => $LogMessage,
        );
    }

    my $DecryptedRef = $Self->{MainObject}->FileRead( Location => $PlainFile );
    if ( !$DecryptedRef ) {
        return (
            Successful => 0,
            Message    => "OpenSSL: Can't read $PlainFile!",
            Data       => undef,
        );

    }
    return (
        Successful => 1,
        Message    => "OpenSSL: OK",
        Data       => $$DecryptedRef,
    );
}

=item Sign()

sign a message

    my $Sign = $CryptObject->Sign(
        Message  => $Message,
        Filename => $PrivateFilename,
    );
    my $Sign = $CryptObject->Sign(
        Message     => $Message,
        Hash        => $Hash,
        Fingerprint => $Fingerprint,
    );

=cut

sub Sign {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    if ( !$Param{Filename} && !( $Param{Hash} || $Param{Fingerprint} ) ) {
        $Self->{LogObject}->Log(
            Message  => "Need Param: Filename or Hash and Fingerprint!",
            Priority => 'error',
        );
        return;
    }

    my $Certificate = $Self->CertificateGet(%Param);
    my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );
    my ( $Private, $Secret ) = $Self->PrivateGet(%Attributes);

    # get the related certificates
    my @RelatedCertificates
        = $Self->SignerCertRelationGet( CertFingerprint => $Attributes{Fingerprint} );

    my $FHCACertFileActive;
    my ( $FHCACertFile, $CAFileName ) = $Self->{FileTempObject}->TempFile();

    my $CertFileCommand = '';

    # get every related cert
    for my $Cert (@RelatedCertificates) {
        my $CAFilename = $Self->_CertificateFilename(
            Hash        => $Cert->{CAHash},
            Fingerprint => $Cert->{CAFingerprint},
        );
        print $FHCACertFile $Self->CertificateGet( Filename => $CAFilename ) . "\n";
        $FHCACertFileActive = 1;
    }

    if ($FHCACertFileActive) {
        $CertFileCommand = " -certfile $CAFileName ";
    }
    close $FHCACertFile;

    my ( $FH, $PlainFile ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;
    my ( $FHPrivate, $PrivateKeyFile ) = $Self->{FileTempObject}->TempFile();
    print $FHPrivate $Private;
    close $FHPrivate;
    my ( $FHCertificate, $CertFile ) = $Self->{FileTempObject}->TempFile();
    print $FHCertificate $Certificate;
    close $FHCertificate;
    my ( $FHSign, $SignFile ) = $Self->{FileTempObject}->TempFile();
    close $FHSign;
    my ( $FHSecret, $SecretFile ) = $Self->{FileTempObject}->TempFile();
    print $FHSecret $Secret;
    close $FHSecret;

    my $Options
        = "smime -sign -in $PlainFile -out $SignFile -signer $CertFile -inkey $PrivateKeyFile"
        . " -text -binary -passin file:$SecretFile";

    # add the certfile parameter
    $Options .= $CertFileCommand;

    my $LogMessage = $Self->_CleanOutput(qx{$Self->{Cmd} $Options 2>&1});
    unlink $SecretFile;
    if ($LogMessage) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't sign: $LogMessage! (Command: $Options)"
        );
        return;
    }

    my $SignedRef = $Self->{MainObject}->FileRead( Location => $SignFile );
    return if !$SignedRef;
    return $$SignedRef;

}

=item Verify()

verify a message with signature and returns a hash (Successful, Message, SignerCertificate)

    my %Data = $CryptObject->Verify(
        Message => $Message,
        CACert  => $PathtoCACert, # send path to the cert, when using self signed certificates
    );

=cut

sub Verify {
    my ( $Self, %Param ) = @_;

    my %Return;
    my $Message     = '';
    my $MessageLong = '';
    my $UsedKey     = '';

    # check needed stuff
    if ( !$Param{Message} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Message!" );
        return;
    }

    my ( $FH, $SignedFile ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;
    my ( $FHOutput, $VerifiedFile ) = $Self->{FileTempObject}->TempFile();
    close $FHOutput;
    my ( $FHSigner, $SignerFile ) = $Self->{FileTempObject}->TempFile();
    close $FHSigner;

    # path to the cert, when self signed certs
    # specially for openssl 1.0
    my $CertificateOption = '';
    if ( $Param{CACert} ) {
        $CertificateOption = "-CAfile $Param{CACert}";
    }

    my $Options
        = "smime -verify -in $SignedFile -out $VerifiedFile -signer $SignerFile "
        . "-CApath $Self->{CertPath} $CertificateOption $SignedFile";

    my @LogLines = qx{$Self->{Cmd} $Options 2>&1};

    for my $LogLine (@LogLines) {
        $MessageLong .= $LogLine;
        if ( $LogLine =~ /^\d.*:(.+?):.+?:.+?:$/ || $LogLine =~ /^\d.*:(.+?)$/ ) {
            $Message .= ";$1";
        }
        else {
            $Message .= $LogLine;
        }
    }

    # TODO: maybe use _FetchAttributesFromCert() to determine the cert-hash and return that instead?
    # determine hash of signer certificate
    my $SignerCertRef    = $Self->{MainObject}->FileRead( Location => $SignerFile );
    my $SignedContentRef = $Self->{MainObject}->FileRead( Location => $VerifiedFile );

    # return message
    if ( $Message =~ /Verification successful/i ) {
        %Return = (
            SignatureFound    => 1,
            Successful        => 1,
            Message           => 'OpenSSL: ' . $Message,
            MessageLong       => 'OpenSSL: ' . $MessageLong,
            SignerCertificate => $$SignerCertRef,
            Content           => $$SignedContentRef,
        );
    }
    elsif ( $Message =~ /self signed certificate/i ) {
        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message =>
                'OpenSSL: self signed certificate, to use it send the \'Certificate\' parameter : '
                . $Message,
            MessageLong =>
                'OpenSSL: self signed certificate, to use it send the \'Certificate\' parameter : '
                . $MessageLong,
            SignerCertificate => $$SignerCertRef,
            Content           => $$SignedContentRef,
        );
    }
    else {
        %Return = (
            SignatureFound => 0,
            Successful     => 0,
            Message        => 'OpenSSL: ' . $Message,
            MessageLong    => 'OpenSSL: ' . $MessageLong,
        );
    }
    return %Return;
}

=item Search()

search a certifcate or an private key

    my @Result = $CryptObject->Search(
        Search => 'some text to search',
    );

=cut

sub Search {
    my ( $Self, %Param ) = @_;

    my @Result = $Self->CertificateSearch(%Param);
    @Result = ( @Result, $Self->PrivateSearch(%Param) );
    return @Result;
}

=item CertificateSearch()

search a local certifcate

    my @Result = $CryptObject->CertificateSearch(
        Search => 'some text to search',
    );

=cut

sub CertificateSearch {
    my ( $Self, %Param ) = @_;

    my $Search = $Param{Search} || '';
    my @Result;
    my @CertList = $Self->CertificateList();

    for my $Filename (@CertList) {
        my $Certificate = $Self->CertificateGet( Filename => $Filename );
        my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate, );
        my $Hit = 0;
        if ($Search) {
            for my $Attribute ( keys %Attributes ) {
                if ( $Attributes{$Attribute} =~ m{$Search}xms ) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }

        $Attributes{Filename} = $Filename;

        if ($Hit) {
            push @Result, \%Attributes;
        }
    }
    return @Result;
}

=item CertificateAdd()

add a certificate to local certificates
returns result message and new certificate filename

    my %Result = $CryptObject->CertificateAdd(
        Certificate => $CertificateString,
    );

=cut

sub CertificateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Certificate} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Certificate!' );
        return;
    }
    my %Attributes = $Self->CertificateAttributes( Certificate => $Param{Certificate}, );
    my %Result;

    if ( !$Attributes{Hash} ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => 'Can\'t add invalid certificate!' );
        %Result = (
            Successful => 0,
            Message    => 'Can\'t add invalid certificate!',
        );
        return %Result;
    }

    # search for certs with same hash
    my @Result = $Self->CertificateSearch(
        Search => $Attributes{Hash},
    );

    # does the cert already exists?
    for my $CertResult (@Result) {
        if ( $Attributes{Fingerprint} eq $CertResult->{Fingerprint} ) {
            %Result = (
                Successful => 0,
                Message    => 'Certificate already installed!',
            );
            return %Result;
        }
    }

    # look for an available filename
    FILENAME:
    for my $Count ( 0 .. 9 ) {
        if ( -e "$Self->{CertPath}/$Attributes{Hash}.$Count" ) {
            next FILENAME;
        }

        my $File = "$Self->{CertPath}/$Attributes{Hash}.$Count";
        if ( open( my $OUT, '>', $File ) ) {
            print $OUT $Param{Certificate};
            close($OUT);
            %Result = (
                Successful => 1,
                Message    => 'Certificate uploaded',
                Filename   => "$Attributes{Hash}.$Count",
            );
            return %Result;
        }

        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't write $File: $!!" );
        %Result = (
            Successful => 0,
            Message    => "Can't write $File: $!!",
        );
        return %Result;
    }

    %Result = (
        Successful => 0,
        Message    => "No more available filenames for certificate hash:$Attributes{Hash}!",
    );
    return %Result;
}

=item CertificateGet()

get a local certificate

    my $Certificate = $CryptObject->CertificateGet(
        Filename => $CertificateFilename,
    );

    my $Certificate = $CryptObject->CertificateGet(
        Fingerprint => $Fingerprint,
        Hash        => $Hash,
    );

=cut

sub CertificateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Filename} && !( $Param{Fingerprint} && $Param{Hash} ) ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => 'Need Filename or Fingerprint and Hash!' );
        return;
    }

    if ( !$Param{Filename} && ( $Param{Fingerprint} && $Param{Hash} ) ) {
        $Param{Filename} = $Self->_CertificateFilename(%Param);
        return if !$Param{Filename};
    }

    my $File = "$Self->{CertPath}/$Param{Filename}";
    my $CertificateRef = $Self->{MainObject}->FileRead( Location => $File );

    return if !$CertificateRef;

    return $$CertificateRef;
}

=item CertificateRemove()

remove a local certificate

    $CryptObject->CertificateRemove(
        Filename => $CertificateHash,
    );

    $CryptObject->CertificateRemove(
        Hash        => $CertificateHash,
        Fingerprint => $CertificateHash,
    );

=cut

sub CertificateRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Filename} && !( $Param{Hash} && $Param{Fingerprint} ) ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => 'Need Filename or Hash and Fingerprint!' );
        return;
    }

    if ( !$Param{Filename} && $Param{Hash} && $Param{Fingerprint} ) {
        $Param{Filename} = $Self->_CertificateFilename(%Param);
        return if !$Param{Filename};
    }

    my %Result;

    # private certificate shouldn't exists if certificate is deleted
    # therefor if exists, first remove private certificate
    # if private delete fails abort certificate removing

    my ($PrivateExists) = $Self->PrivateGet(
        Filename => $Param{Filename},
    );

    if ($PrivateExists) {
        my %PrivateResults = $Self->PrivateRemove(
            Filename => $Param{Filename},
        );
        if ( !$PrivateResults{Successful} ) {
            %Result = (
                Successful => 0,
                Message    => "Delete certificate aborted, $PrivateResults{Message}: $!!",
            );
            return %Result;
        }
    }

    my $Message   = "Certificate successfully removed";
    my $Succesful = 1;

    # remove certificate
    my $Cert = unlink "$Self->{CertPath}/$Param{Filename}";
    if ( !$Cert ) {
        $Message = "Impossible to remove certificate: $Self->{CertPath}/$Param{Filename}: $!!",
            $Succesful = 0;
    }

    $Message .= ". Private certificate succesfuly deleted" if ($PrivateExists);

    %Result = (
        Successful => $Succesful,
        Message    => $Message,
    );
    return %Result;
}

=item CertificateList()

get list of local certificates filenames

    my @CertList = $CryptObject->CertificateList();

=cut

sub CertificateList {
    my ( $Self, %Param ) = @_;

    my @CertList;
    my @Filters;
    for my $Number ( 0 .. 9 ) {
        push @Filters, "*.$Number";
    }

    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => "$Self->{CertPath}",
        Filter    => \@Filters,
    );

    for my $File (@List) {
        $File =~ s{^.*/}{}xms;
        push @CertList, $File;
    }
    return @CertList;
}

=item CertificateAttributes()

get certificate attributes

    my %CertificateAttributes = $CryptObject->CertificateAttributes(
        Certificate => $CertificateString,
    );

=cut

sub CertificateAttributes {
    my ( $Self, %Param ) = @_;

    my %Attributes;
    if ( !$Param{Certificate} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Certificate!' );
        return;
    }
    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Certificate};
    close $FH;
    $Self->_FetchAttributesFromCert( $Filename, \%Attributes );
    if ( $Attributes{Hash} ) {
        my ($Private) = $Self->PrivateGet(%Attributes);
        if ($Private) {
            $Attributes{Private} = 'Yes';
        }
        else {
            $Attributes{Private} = 'No';
        }
        $Attributes{Type} = 'cert';
    }
    return %Attributes;
}

=item PrivateSearch()

returns private keys

    my @Result = $CryptObject->PrivateSearch(
        Search => 'some text to search',
    );

=cut

sub PrivateSearch {
    my ( $Self, %Param ) = @_;

    my $Search = $Param{Search} || '';
    my @Result;
    my @Certificates = $Self->CertificateList();

    for my $File (@Certificates) {
        my $Certificate = $Self->CertificateGet( Filename => $File );
        my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );

        my $Hit = 0;
        if ($Search) {
            for my $Attribute ( keys %Attributes ) {
                if ( $Attributes{$Attribute} =~ m{$Search}xms ) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ( $Hit && $Attributes{Private} && $Attributes{Private} eq 'Yes' ) {
            $Attributes{Type}     = 'key';
            $Attributes{Filename} = $File;
            push @Result, \%Attributes;
        }
    }
    return @Result;
}

=item PrivateAdd()

add private key

    my %Result = $CryptObject->PrivateAdd(
        Private => $PrivateKeyString,
        Secret  => 'Password',
    );

=cut

sub PrivateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Private Secret)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my %Result;

    # get private attributes
    my %Attributes = $Self->PrivateAttributes(%Param);
    if ( !$Attributes{Modulus} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'No Private Key!' );
        %Result = (
            Successful => 0,
            Message    => 'No private key',
        );
        return;
    }

    # get certificate
    my @Certificates = $Self->CertificateSearch( Search => $Attributes{Modulus} );
    if ( !@Certificates ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Certificate of Private Key first -$Attributes{Modulus})!",
        );
        %Result = (
            Successful => 0,
            Message    => 'Need Certificate of Private Key first -$Attributes{Modulus})!',
        );
        return %Result;
    }
    elsif ( $#Certificates > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Multiple Certificates with the same Modulus, can\'t add Private Key!',
        );
        %Result = (
            Successful => 0,
            Message    => 'Multiple Certificates with the same Modulus, can\'t add Private Key!',
        );
        return %Result;
    }
    my %CertificateAttributes = $Self->CertificateAttributes(
        Certificate => $Self->CertificateGet( Filename => $Certificates[0]->{Filename} ),
    );
    if ( $CertificateAttributes{Hash} ) {
        my $File = "$Self->{PrivatePath}/$Certificates[0]->{Filename}";
        if ( open( my $PrivKeyFH, '>', "$File" ) ) {
            print $PrivKeyFH $Param{Private};
            close $PrivKeyFH;
            open( my $PassFH, '>', "$File.P" );
            print $PassFH $Param{Secret};
            close $PassFH;
            %Result = (
                Successful => 1,
                Message    => 'Private Key uploaded!',
                Filename   => $Certificates[0]->{Filename},
            );
            return %Result;
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Can't write $File: $!!" );
            %Result = (
                Successful => 0,
                Message    => "Can't write $File: $!!",
            );
            return %Result;
        }
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => 'Can\'t add invalid private key!' );
    %Result = (
        Successful => 0,
        Message    => 'Can\'t add invalid private key!',
    );
    return %Result;
}

=item PrivateGet()

get private key

    my ($PrivateKey, $Secret) = $CryptObject->PrivateGet(
        Filename => $PrivateFilename,
    );

    my ($PrivateKey, $Secret) = $CryptObject->PrivateGet(
        Hash    => $Hash,
        Modulus => $Modulus,
    );

=cut

sub PrivateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Filename} && !( $Param{Hash} && $Param{Modulus} ) ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => 'Need Filename or Hash and Modulus!' );
        return;
    }

    if ( !$Param{Filename} && ( $Param{Hash} && $Param{Modulus} ) ) {
        $Param{Filename} = $Self->_PrivateFilename(
            Hash    => $Param{Hash},
            Modulus => $Param{Modulus},
        );
        return if !$Param{Filename};
    }

    my $File = "$Self->{PrivatePath}/$Param{Filename}";

    my $Private;
    if ( -e $File ) {
        $Private = $Self->{MainObject}->FileRead( Location => $File );
    }

    return if !$Private;

    # read secret
    $File = "$Self->{PrivatePath}/$Param{Filename}.P";
    my $Secret = $Self->{MainObject}->FileRead( Location => $File );

    return ( $$Private, $$Secret ) if ( $Private && $Secret );
}

=item PrivateRemove()

remove private key

    $CryptObject->PrivateRemove(
        Filename => $Filename,
    );

    $CryptObject->PrivateRemove(
        Hash    => $Hash,
        Modulus => $Modulus,
    );

=cut

sub PrivateRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Filename} && !( $Param{Hash} && $Param{Modulus} ) ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => 'Need Filename or Hash and Modulus!' );
        return;
    }

    my %Return;
    if ( !$Param{Filename} && ( $Param{Hash} && $Param{Modulus} ) ) {
        $Param{Filename} = $Self->_PrivateFilename(
            Hash    => $Param{Hash},
            Modulus => $Param{Modulus},
        );
        %Return = (
            Successful => 0,
            Message    => "Filename not found for hash: $Param{Hash} in: $Self->{PrivatePath}, $!!",
        );
        return %Return if !$Param{Filename};
    }

    my $SecretDelete = unlink "$Self->{PrivatePath}/$Param{Filename}.P";

    # abort if secret is not deleted
    if ( !$SecretDelete ) {
        %Return = (
            Successful => 0,
            Message =>
                "Delete private aborted, not possible to delete Secret: $Self->{PrivatePath}/$Param{Filename}.P, $!!",
        );
        return %Return;
    }

    my $PrivateDelete = unlink "$Self->{PrivatePath}/$Param{Filename}";
    if ($PrivateDelete) {

        my $Certificate = $Self->CertificateGet(
            Filename => $Param{Filename},
        );

        # get cert attributes
        my %CertificateAttributes = $Self->CertificateAttributes(
            Certificate => $Certificate,
        );

        $Self->SignerCertRelationDelete(
            CertFingerprint => $CertificateAttributes{Fingerprint},
        );

        %Return = (
            Successful => 1,
            Message    => 'Private key deleted!'
        );
        return %Return;
    }

    %Return = (
        Successful => 0,
        Message    => "Impossible to delete key $Param{Filename} $!!"
    );
    return %Return;
}

=item PrivateList()

returns a list of private key hashs

    my @PrivateList = $CryptObject->PrivateList();

=cut

sub PrivateList {
    my ( $Self, %Param ) = @_;

    my @CertList;
    my @Filters;
    for my $Number ( 0 .. 9 ) {
        push @Filters, "*.$Number";
    }

    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => "$Self->{PrivatePath}",
        Filter    => \@Filters,
    );

    for my $File (@List) {
        $File =~ s{^.*/}{}xms;
        push @CertList, $File;
    }
    return @CertList;

}

=item PrivateAttributes()

returns attributes of private key

    my %Hash = $CryptObject->PrivateAttributes(
        Private => $PrivateKeyString,
        Secret => 'Password',
    );

=cut

sub PrivateAttributes {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Private Secret)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my %Attributes;
    my %Option = ( Modulus => '-modulus', );
    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Private};
    close $FH;
    my ( $FHSecret, $SecretFile ) = $Self->{FileTempObject}->TempFile();
    print $FHSecret $Param{Secret};
    close $FHSecret;
    my $Options    = "rsa -in $Filename -noout -modulus -passin file:$SecretFile";
    my $LogMessage = qx{$Self->{Cmd} $Options 2>&1};
    unlink $SecretFile;
    $LogMessage =~ tr{\r\n}{}d;
    $LogMessage =~ s/Modulus=//;
    $Attributes{Modulus} = $LogMessage;
    $Attributes{Type}    = 'P';
    return %Attributes;
}

=begin Internal:

=cut

sub _Init {
    my ( $Self, %Param ) = @_;

    $Self->{Bin}         = $Self->{ConfigObject}->Get('SMIME::Bin') || '/usr/bin/openssl';
    $Self->{CertPath}    = $Self->{ConfigObject}->Get('SMIME::CertPath');
    $Self->{PrivatePath} = $Self->{ConfigObject}->Get('SMIME::PrivatePath');

    if ( $^O =~ m{Win}i ) {

        # take care to deal properly with paths containing whitespace
        $Self->{Cmd} = qq{"$Self->{Bin}"};
    }
    else {

        # make sure that we are getting POSIX (i.e. english) messages from openssl
        $Self->{Cmd} = "LC_MESSAGES=POSIX $Self->{Bin}";
    }

    # ensure that there is a random state file that we can write to (otherwise openssl will bail)
    $ENV{RANDFILE} = $Self->{ConfigObject}->Get('TempDir') . '/.rnd';

    # prepend RANDFILE declaration to openssl cmd
    $Self->{Cmd}
        = "HOME=" . $Self->{ConfigObject}->Get('Home') . " RANDFILE=$ENV{RANDFILE} $Self->{Cmd}";

    # get the openssl version string, e.g. OpenSSL 0.9.8e 23 Feb 2007
    $Self->{OpenSSLVersionString} = qx{$Self->{Cmd} version};

    # get the openssl major version, e.g. 1 for version 1.0.0
    if ( $Self->{OpenSSLVersionString} =~ m{ \A (?: OpenSSL )? \s* ( \d )  }xmsi ) {
        $Self->{OpenSSLMajorVersion} = $1;
    }

    return $Self;
}

sub _FetchAttributesFromCert {
    my ( $Self, $Filename, $AttributesRef ) = @_;

    # The hash algorithm used in the -subject_hash and -issuer_hash options before OpenSSL 1.0.0
    # was based on the deprecated MD5 algorithm and the encoding of the distinguished name.
    # In OpenSSL 1.0.0 and later it is based on a canonical version of the DN using SHA1.
    #
    # output the hash of the certificate subject name using the older algorithm as
    # used by OpenSSL versions before 1.0.0.

    # hash
    my $HashAttribute = '-subject_hash';

    if ( $Self->{OpenSSLMajorVersion} >= 1 ) {
        $HashAttribute = '-subject_hash_old';
    }

    # testing new solution
    my $OptionString = ' '
        . "$HashAttribute "
        . '-issuer '
        . '-fingerprint -sha1 '
        . '-serial '
        . '-subject '
        . '-startdate '
        . '-enddate '
        . '-email '
        . '-modulus '
        . ' ';

    # call all attributes at same time
    my $Options = "x509 -in $Filename -noout $OptionString";

    # get the output string
    my $Output = qx{$Self->{Cmd} $Options 2>&1};

    # filters
    my %Filters = (
        Hash        => '(\w{8})',
        Issuer      => 'issuer=\s*(.*)',
        Fingerprint => 'SHA1\sFingerprint=(.*)',
        Serial      => 'serial=(.*)',
        Subject     => 'subject=\s*/(.*)',
        StartDate   => 'notBefore=(.*)',
        EndDate     => 'notAfter=(.*)',
        Email       => '([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4})',
        Modulus     => 'Modulus=(.*)',
    );

    # parse output string
    my @Attributes = split( /\n/, $Output );
    for my $Line (@Attributes) {

        # clean end spaces
        $Line =~ tr{\r\n}{}d;

        # look for every attribute by filter
        for my $Filter ( keys %Filters ) {
            if ( $Line =~ m{\A $Filters{$Filter} \z}xms ) {
                $AttributesRef->{$Filter} = $1 || '';

          # delete the match key from filter  to don't search again this value and improve the speed
                delete $Filters{$Filter};
                last;
            }
        }
    }

    # prepare attributes data for use
    $AttributesRef->{Issuer}  =~ s{=}{= }xmsg if $AttributesRef->{Issuer};
    $AttributesRef->{Subject} =~ s{\/}{ }xmsg if $AttributesRef->{Subject};
    $AttributesRef->{Subject} =~ s{=}{= }xmsg if $AttributesRef->{Subject};

    my %Month = (
        Jan => '01',
        Feb => '02',
        Mar => '03',
        Apr => '04',
        May => '05',
        Jun => '06',
        Jul => '07', Aug => '08', Sep => '09', Oct => '10', Nov => '11', Dec => '12',
    );

    for my $DateType ( 'StartDate', 'EndDate' ) {
        if (
            $AttributesRef->{$DateType}
            &&
            $AttributesRef->{$DateType} =~ /(.+?)\s(.+?)\s(\d\d:\d\d:\d\d)\s(\d\d\d\d)/
            )
        {
            my $Day   = $2;
            my $Month = '';
            my $Year  = $4;

            if ( $Day < 10 ) {
                $Day = "0" . int($Day);
            }

            for my $MonthKey ( keys %Month ) {
                if ( $AttributesRef->{$DateType} =~ /$MonthKey/i ) {
                    $Month = $Month{$MonthKey};
                    last;
                }
            }
            $AttributesRef->{"Short$DateType"} = "$Year-$Month-$Day";
        }
    }
    return 1;
}

sub _CleanOutput {
    my ( $Self, $Output ) = @_;

    # remove spurious warnings that appear on Windows
    if ( $^O =~ m{Win}i ) {
        $Output =~ s{Loading 'screen' into random state - done\r?\n}{}igms;
    }

    return $Output;
}

sub _CertificateFilename {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Fingerprint Hash)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # get all certificates with hash name
    my @CertList = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{CertPath},
        Filter    => "$Param{Hash}.*",
    );

    # open every file, get attributes and compare fingerprint
    for my $CertFile (@CertList) {
        my %Attributes;
        $Self->_FetchAttributesFromCert( $CertFile, \%Attributes );

        # exit and return on first finger print found
        if ( $Attributes{Fingerprint} && $Attributes{Fingerprint} eq $Param{Fingerprint} ) {
            $CertFile =~ s{^.*/}{}xms;
            return $CertFile;
        }
    }

    return;
}

sub _PrivateFilename {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Hash Modulus)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # get all certificates with hash name
    my @CertList = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{PrivatePath},
        Filter    => $Param{Hash} . '\.*',
    );

    # open every file, get attributes and compare modulus
    CERTFILE:
    for my $CertFile (@CertList) {
        my %Attributes;
        next CERTFILE if $CertFile =~ m{\.P}xms;

        # open secret
        my $Private = $Self->{MainObject}->FileRead(
            Location => $CertFile,
        );
        my $Secret = $Self->{MainObject}->FileRead(
            Location => $CertFile . '.P',
        );

        %Attributes = $Self->PrivateAttributes(
            Private => $$Private,
            Secret  => $$Secret,
        );

        # exit and return on first modulus found
        if ( $Attributes{Modulus} && $Attributes{Modulus} eq $Param{Modulus} ) {
            $CertFile =~ s{^.*/}{}xms;
            return $CertFile;
        }
    }
}

=item SignerCertRelationAdd ()

add a relation between signer certificate and CA certificate to attach to the signature
returns 1 if success

    my $RelationID = $CryptObject->SignerCertRelationAdd(
        CertFingerprint => $CertFingerprint,
        CAFingerprint => $CAFingerprint,
        UserID => 1,
    );

=cut

sub SignerCertRelationAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw( CertFingerprint CAFingerprint UserID )) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    if ( $Param{CertFingerprint} eq $Param{CAFingerprint} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CertFingerprint must be different to the CAFingerprint param',
        );
        return;
    }

    # searh certificates by fingerprint
    my @CertResult = $Self->PrivateSearch(
        Search => $Param{CertFingerprint},
    );

    # results?
    if ( !scalar @CertResult ) {
        $Self->{LogObject}->Log(
            Message  => "Wrong CertFingerprint, certificate not found!",
            Priority => 'error',
        );
        return 0;
    }

    # searh certificates by fingerprint
    my @CAResult = $Self->CertificateSearch(
        Search => $Param{CAFingerprint},
    );

    # results?
    if ( !scalar @CAResult ) {
        $Self->{LogObject}->Log(
            Message  => "Wrong CAFingerprint, certificate not found!",
            Priority => 'error',
        );
        return 0;
    }

    my $Success = $Self->{DBObject}->Do(
        SQL => 'INSERT INTO smime_signer_cert_relations'
            . ' ( cert_hash, cert_fingerprint, ca_hash, ca_fingerprint, create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$CertResult[0]->{Hash}, \$CertResult[0]->{Fingerprint}, \$CAResult[0]->{Hash},
            \$CAResult[0]->{Fingerprint},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    return $Success;
}

=item SignerCertRelationGet ()

get relation data by ID or by Certificate finger print
returns data Hash if ID given or Array of all relations if CertFingerprint given

    my %Data = $CryptObject->SignerCertRelationGet(
        ID => $RelationID,
    );

    my @Data = $CryptObject->SignerCertRelationGet(
        CertFingerprint => $CertificateFingerprint,
    );

=cut

sub SignerCertRelationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{CertFingerprint} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Needed ID or CertFingerprint!' );
        return;
    }

    # ID
    my %Data;
    my @Data;
    if ( $Param{ID} ) {
        my $Success = $Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, cert_hash, cert_fingerprint, ca_hash, ca_fingerprint, create_time, create_by, change_time, change_by'
                . ' FROM smime_signer_cert_relations'
                . ' WHERE id = ? ORDER BY create_time DESC',
            Bind  => [ \$Param{ID} ],
            Limit => 1,
        );

        if ($Success) {
            while ( my @ResultData = $Self->{DBObject}->FetchrowArray() ) {

                # format date
                %Data = (
                    ID              => $ResultData[0],
                    CertHash        => $ResultData[1],
                    CertFingerprint => $ResultData[2],
                    CAHash          => $ResultData[3],
                    CAFingerprint   => $ResultData[4],
                    Changed         => $ResultData[5],
                    ChangedBy       => $ResultData[6],
                    Created         => $ResultData[7],
                    CreatedBy       => $ResultData[8],
                );
            }
            return %Data || '';
        }
        else {
            $Self->{LogObject}->Log(
                Message  => 'DB error: not possible to get relation!',
                Priority => 'error',
            );
            return;
        }
    }
    else {
        my $Success = $Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, cert_hash, cert_fingerprint, ca_hash, ca_fingerprint, create_time, create_by, change_time, change_by'
                . ' FROM smime_signer_cert_relations'
                . ' WHERE cert_fingerprint = ? ORDER BY id DESC',
            Bind => [ \$Param{CertFingerprint} ],
        );

        if ($Success) {
            while ( my @ResultData = $Self->{DBObject}->FetchrowArray() ) {
                my %ResultData = (
                    ID              => $ResultData[0],
                    CertHash        => $ResultData[1],
                    CertFingerprint => $ResultData[2],
                    CAHash          => $ResultData[3],
                    CAFingerprint   => $ResultData[4],
                    Changed         => $ResultData[5],
                    ChangedBy       => $ResultData[6],
                    Created         => $ResultData[7],
                    CreatedBy       => $ResultData[8],
                );
                push @Data, \%ResultData;
            }
            return @Data;
        }
        else {
            $Self->{LogObject}->Log(
                Message  => 'DB error: not possible to get relations!',
                Priority => 'error',
            );
            return;
        }
    }
    return;
}

=item SignerCertRelationExists ()

returns the ID if the relation exists

    my $Result = $CryptObject->SignerCertRelationExists(
        CertFingerprint => $CertificateFingerprint,
        CAFingerprint => $CAFingerprint,
    );

    my $Result = $CryptObject->SignerCertRelationExists(
        ID => $RelationID,
    );

=cut

sub SignerCertRelationExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !( $Param{CertFingerprint} && $Param{CAFingerprint} ) ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Need ID or CertFingerprint & CAFingerprint!" );
        return;
    }

    if ( $Param{CertFingerprint} && $Param{CAFingerprint} ) {
        my $Data;
        my $Success = $Self->{DBObject}->Prepare(
            SQL => 'SELECT id FROM smime_signer_cert_relations '
                . 'WHERE cert_fingerprint = ? AND ca_fingerprint = ?',
            Bind => [ \$Param{CertFingerprint}, \$Param{CAFingerprint} ],
            Limit => 1,
        );

        if ($Success) {
            while ( my @ResultData = $Self->{DBObject}->FetchrowArray() ) {
                $Data = $ResultData[0];
            }
            return $Data || '';
        }
        else {
            $Self->{LogObject}->Log(
                Message  => 'DB error: not possible to check relation!',
                Priority => 'error',
            );
            return;
        }
    }
    elsif ( $Param{ID} ) {
        my $Data;
        my $Success = $Self->{DBObject}->Prepare(
            SQL => 'SELECT id FROM smime_signer_cert_relations '
                . 'WHERE id = ?',
            Bind  => [ \$Param{ID}, ],
            Limit => 1,
        );

        if ($Success) {
            while ( my @ResultData = $Self->{DBObject}->FetchrowArray() ) {
                $Data = $ResultData[0];
            }
            return $Data || '';
        }
        else {
            $Self->{LogObject}->Log(
                Message  => 'DB error: not possible to check relation!',
                Priority => 'error',
            );
            return;
        }
    }

    return;
}

=item SignerCertRelationDelete ()

returns 1 if success

    # delete all relations for a cert
    my $Success = $CryptObject->SignerCertRelationDelete (
        CertFingerprint => $CertFingerprint,
        UserID => 1,
    );

    # delete one relation by ID
    $Success = $CryptObject->SignerCertRelationDelete (
        ID => '45',
    );

    # delete one relation by CertFingerprint & CAFingerprint
    $Success = $CryptObject->SignerCertRelationDelete (
        CertFingerprint => $CertFingerprint,
        CAFingerprint   => $CAFingerprint,
    );

=cut

sub SignerCertRelationDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CertFingerprint} && !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or CertFingerprint!' );
        return;
    }

    if ( $Param{ID} ) {

        # delete row
        my $Success = $Self->{DBObject}->Do(
            SQL => 'DELETE FROM smime_signer_cert_relations '
                . 'WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Message  => "DB Error, Not possible to delete relation ID:$Param{ID}!",
                Priority => 'error',
            );
        }
        return $Success;
    }
    elsif ( $Param{CertFingerprint} && $Param{CAFingerprint} ) {

        # delete one row
        my $Success = $Self->{DBObject}->Do(
            SQL => 'DELETE FROM smime_signer_cert_relations '
                . 'WHERE cert_fingerprint = ? AND ca_fingerprint = ?',
            Bind => [ \$Param{CertFingerprint}, \$Param{CAFingerprint} ],
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Message =>
                    "DB Error, Not possible to delete relation for "
                    . "CertFingerprint:$Param{CertFingerprint} and CAFingerprint:$Param{CAFingerprint}!",
                Priority => 'error',
            );
        }
        return $Success;
    }
    else {

        # delete all rows
        my $Success = $Self->{DBObject}->Do(
            SQL => 'DELETE FROM smime_signer_cert_relations '
                . 'WHERE cert_fingerprint = ?',
            Bind => [ \$Param{CertFingerprint} ],
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Message =>
                    "DB Error, Not possible to delete relations for CertFingerprint:$Param{CertFingerprint}!",
                Priority => 'error',
            );
        }
        return $Success;
    }
    return;
}

1;

=end Internal:

=cut

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.55 $ $Date: 2012-01-16 11:30:23 $

=cut
