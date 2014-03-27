# --
# Kernel/System/Crypt/SMIME.pm - the main crypt module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: SMIME.pm,v 1.43.2.5 2012-05-03 12:34:00 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Crypt::SMIME;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.43.2.5 $) [1];

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
        Message => $Message,
        Hash    => $CertificateHash,
    );

=cut

sub Crypt {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message Hash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
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
        Message => $CryptedMessage,
        Hash    => $PrivateKeyHash,
    );

=cut

sub Decrypt {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message Hash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my ( $Private, $Secret ) = $Self->PrivateGet(%Param);
    my $Certificate = $Self->CertificateGet(%Param);

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
        Message => $Message,
        Hash    => $PrivateKeyHash,
    );

=cut

sub Sign {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message Hash)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my ( $Private, $Secret ) = $Self->PrivateGet(%Param);
    my $Certificate = $Self->CertificateGet(%Param);

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
        Message     => $Message,
        Certificate => $PathtoCert, # send path to the cert, when unsing self signed certificates
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
    if ( $Param{Certificate} ) {
        $CertificateOption = "-CAfile $Param{Certificate}";
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
    my @Hash = $Self->CertificateList();
    for (@Hash) {
        my $Certificate = $Self->CertificateGet( Hash => $_ );
        my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );
        my $Hit = 0;
        if ($Search) {
            for ( keys %Attributes ) {
                if ( eval { $Attributes{$_} =~ /\Q$Search\E/i } ) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ($Hit) {
            push @Result, \%Attributes;
        }
    }
    return @Result;
}

=item CertificateAdd()

add a certificate to local certificates

    $CryptObject->CertificateAdd(
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
    my %Attributes = $Self->CertificateAttributes(%Param);
    if ( $Attributes{Hash} ) {
        my $File = "$Self->{CertPath}/$Attributes{Hash}.0";
        if ( open( my $OUT, '>', $File ) ) {
            print $OUT $Param{Certificate};
            close($OUT);
            return 'Certificate uploaded!';
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Can't write $File: $!!" );
            return;
        }
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => "Can't add invalid certificate!" );
    return;
}

=item CertificateGet()

get a local certificate

    my $Certificate = $CryptObject->CertificateGet(
        Hash => $CertificateHash,
    );

=cut

sub CertificateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Hash} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Hash!' );
        return;
    }
    my $File = "$Self->{CertPath}/$Param{Hash}.0";
    my $CertificateRef = $Self->{MainObject}->FileRead( Location => $File );

    return if !$CertificateRef;

    return $$CertificateRef;
}

=item CertificateRemove()

remove a local certificate

    $CryptObject->CertificateRemove(
        Hash => $CertificateHash,
    );

=cut

sub CertificateRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Hash} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Hash!' );
        return;
    }
    my $Result = unlink "$Self->{CertPath}/$Param{Hash}.0" || return $!;
    return $Result;
}

=item CertificateList()

get list of local certificates

    my @HashList = $CryptObject->CertificateList();

=cut

sub CertificateList {
    my ( $Self, %Param ) = @_;

    my @Hash;
    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => "$Self->{CertPath}",
        Filter    => '*.0',
    );
    for my $File (@List) {
        $File =~ s{^.*/}{}xms;
        $File =~ s{(.*)\.0}{$1}xms;
        push @Hash, $File;
    }
    return @Hash;
}

=item CertificateAttributes()

get certificate attributes

    my %CertificateArrtibutes = $CryptObject->CertificateAttributes(
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
        my ($Private) = $Self->PrivateGet( Hash => $Attributes{Hash} );
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
    my @Hash = $Self->CertificateList();
    for (@Hash) {
        my $Certificate = $Self->CertificateGet( Hash => $_ );
        my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );
        my $Hit = 0;
        if ($Search) {
            for ( keys %Attributes ) {
                if ( $Attributes{$_} =~ /\Q$Search\E/i ) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ( $Hit && $Attributes{Private} eq 'Yes' ) {
            $Attributes{Type} = 'key';
            push @Result, \%Attributes;
        }
    }
    return @Result;
}

=item PrivateAdd()

add private key

    my $Message = $CryptObject->PrivateAdd(
        Private => $PrivateKeyString,
        Secret  => 'Password',
    );

=cut

sub PrivateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Private} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Private!' );
        return;
    }

    # get private attributes
    my %Attributes = $Self->PrivateAttributes(%Param);
    if ( !$Attributes{Modulus} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'No Private Key!' );
        return;
    }

    # get certificate hash
    my @Certificates = $Self->CertificateSearch( Search => $Attributes{Modulus} );
    if ( !@Certificates ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Certificate of Private Key first -$Attributes{Modulus})!",
        );
        return;
    }
    elsif ( $#Certificates > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Multiple Certificates with the same Modulus, can't add Private Key!",
        );
        return;
    }
    my %CertificateAttributes = $Self->CertificateAttributes(
        Certificate => $Self->CertificateGet( Hash => $Certificates[0]->{Hash} ),
    );
    if ( $CertificateAttributes{Hash} ) {
        my $File = "$Self->{PrivatePath}/$CertificateAttributes{Hash}";
        if ( open( my $PrivKeyFH, '>', "$File.0" ) ) {
            print $PrivKeyFH $Param{Private};
            close $PrivKeyFH;
            open( my $PassFH, '>', "$File.P" );
            print $PassFH $Param{Secret};
            close $PassFH;
            return 'Private Key uploaded!';
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Can't write $File: $!!" );
            return;
        }
    }
    $Self->{LogObject}->Log( Priority => 'error', Message => "Can't add invalid private key!" );
    return;
}

=item PrivateGet()

get private key

    my ($PrivateKey, $Secret) = $CryptObject->PrivateGet(
        Hash => $PrivateKeyHash,
    );

=cut

sub PrivateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Hash} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Hash!' );
        return;
    }
    my $File = "$Self->{PrivatePath}/$Param{Hash}.0";
    if ( !-f $File ) {

        # no private exists
        return;
    }
    elsif ( open( my $IN, '<', $File ) ) {
        my $Private = '';
        while (<$IN>) {
            $Private .= $_;
        }
        close($IN);

        # read secret
        my $File   = "$Self->{PrivatePath}/$Param{Hash}.P";
        my $Secret = '';
        if ( open( my $IN, '<', $File ) ) {
            while (<$IN>) {
                $Secret .= $_;
            }
            close($IN);
        }
        return ( $Private, $Secret );
    }

    $Self->{LogObject}->Log( Priority => 'error', Message => "Can't open $File: $!!" );
    return;
}

=item PrivateRemove()

remove private key

    $CryptObject->PrivateRemove(
        Hash => $PrivateKeyHash,
    );

=cut

sub PrivateRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Hash} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Hash!' );
        return;
    }
    my $CertDelete    = unlink "$Self->{PrivatePath}/$Param{Hash}.0" || return;
    my $PrivateDelete = unlink "$Self->{PrivatePath}/$Param{Hash}.P" || return;

    if ( $CertDelete && $PrivateDelete ) {
        return 1;
    }
    else {
        return 0;
    }
}

=item PrivateList()

returns a list of private key hashs

    my @HashList = $CryptObject->PrivateList();

=cut

sub PrivateList {
    my ( $Self, %Param ) = @_;

    my @Hash;
    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => "$Self->{PrivatePath}",
        Filter    => '*.0',
    );

    for my $File (@List) {
        $File =~ s{^.*/}{}xms;
        $File =~ s{(.*)\.0}{$1}xms;
        push @Hash, $File;
    }
    return @Hash;
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

    my %Attributes;
    my %Option = ( Modulus => '-modulus', );
    if ( !$Param{Private} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Private!' );
        return;
    }
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
                $AttributesRef->{$Filter} = $1;

          # delete the match key from filter  to don't search again this value and improve the speed
                delete $Filters{$Filter};
                last;
            }
        }
    }

    # prepare attributes data for use
    $AttributesRef->{Issuer} =~ s{=}{= }xmsg;
    $AttributesRef->{Subject} =~ s{\/}{ }xmsg;
    $AttributesRef->{Subject} =~ s{=}{= }xmsg;

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
        if ( $AttributesRef->{$DateType} =~ /(.+?)\s(.+?)\s(\d\d:\d\d:\d\d)\s(\d\d\d\d)/ ) {
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

$Revision: 1.43.2.5 $ $Date: 2012-05-03 12:34:00 $

=cut
