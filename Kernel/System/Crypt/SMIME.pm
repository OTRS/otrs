# --
# Kernel/System/Crypt/SMIME.pm - the main crypt module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SMIME.pm,v 1.22 2008-05-15 13:49:17 ot Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Crypt::SMIME;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

=head1 NAME

Kernel::System::Crypt::SMIME - smime crypt backend lib

=head1 SYNOPSIS

This is a sub module of Kernel::System::Crypt and contains all smime functions.

=head1 PUBLIC INTERFACE

=over 4

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

        # make sure that we are getting POSIX (i.e. english) messages from gpg
        $Self->{Cmd} = "LC_MESSAGES=POSIX $Self->{Bin}";
    }

    # ensure that there is a random state file that we can write to (otherwise openssl will bail
    $ENV{RANDFILE} ||= $Self->{ConfigObject}->Get('TempDir') . '/.rnd';

    return $Self;
}

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
        Hash => $CertificateHash,
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
    my $LogMessage = $Self->_CleanOutput( qx{$Self->{Cmd} $Options 2>&1} );
    if ($LogMessage) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't crypt: $LogMessage!" );
        return;
    }

    my $CryptedRef = $Self->{MainObject}->FileRead( Location => $CryptedFile );
    return $$CryptedRef;
}

=item Decrypt()

decrypt a message and returns a hash (Successful, Message, Data)

    my %Message = $CryptObject->Decrypt(
        Message => $CryptedMessage,
        Hash => $PrivateKeyHash,
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
    if ($LogMessage) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't decrypt: $LogMessage!" );
        return (
            Successful => 0,
            Message    => $LogMessage,
        );
    }

    my $DecryptedRef = $Self->{MainObject}->FileRead( Location => $PlainFile );
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
        Hash => $PrivateKeyHash,
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
    my $LogMessage = $Self->_CleanOutput( qx{$Self->{Cmd} $Options 2>&1} );
    unlink $SecretFile;
    if ($LogMessage) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't sign: $LogMessage!" );
        return;
    }

    my $SignedRef = $Self->{MainObject}->FileRead( Location => $SignFile );
    return $$SignedRef;

}

=item Verify()

verify a message with signature and returns a hash (Successful, Message, SignerCertificate)

    my %Data = $CryptObject->Verify(
        Message => $Message,
    );

=cut

sub Verify {
    my ( $Self, %Param ) = @_;

    my %Return      = ();
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
    my ( $FHSigner, $SignerFile )   = $Self->{FileTempObject}->TempFile();
    close $FHSigner;
    my $SigFile = '';
    if ( $Param{Sign} ) {
        ( my $FHSig, $SigFile ) = $Self->{FileTempObject}->TempFile();
        print $FHSig $Param{Sign};
        close $FHSig;
    }
    my $Options
        = "smime -verify -in $SignedFile -out $VerifiedFile -signer $SignerFile "
            . " -CApath $Self->{CertPath} $SigFile $SignedFile";
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
            SignatureFound => 1,
            Successful     => 1,

            #            Message => $1,
            Message           => "OpenSSL: " . $Message,
            MessageLong       => "OpenSSL: " . $MessageLong,
            SignerCertificate => $$SignerCertRef,
            Content           => $$SignedContentRef,
        );
    }
    else {
        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => "OpenSSL: " . $Message,
            MessageLong    => "OpenSSL: " . $MessageLong,
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
    my @Result = ();
    my @Hash   = $Self->CertificateList();
    for (@Hash) {
        my $Certificate = $Self->CertificateGet( Hash => $_ );
        my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );
        my $Hit = 0;
        if ($Search) {
            for ( keys %Attributes ) {
                if ( eval { $Attributes{$_} =~ /$Search/i } ) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ($Hit) {
            push( @Result, \%Attributes );
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Certificate!" );
        return;
    }
    my %Attributes = $Self->CertificateAttributes(%Param);
    if ( $Attributes{Hash} ) {
        my $File = "$Self->{CertPath}/$Attributes{Hash}.0";
        if ( open( OUT, "> $File" ) ) {
            print OUT $Param{Certificate};
            close(OUT);
            return "Certificate uploaded!";
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Can't write $File: $!!" );
            return;
        }
    }
    else {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't add invalid certificat!" );
        return;
    }
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Hash!" );
        return;
    }
    my $File = "$Self->{CertPath}/$Param{Hash}.0";
    my $CertificateRef = $Self->{MainObject}->FileRead( Location => $File );
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Hash!" );
        return;
    }
    unlink "$Self->{CertPath}/$Param{Hash}.0" || return $!;
    return 1;
}

=item CertificateList()

get list of local certificates

    my @HashList = $CryptObject->CertificateList();

=cut

sub CertificateList {
    my ( $Self, %Param ) = @_;

    my @Hash = ();
    my @List = glob("$Self->{CertPath}/*.0");
    for my $File (@List) {
        $File =~ s!^.*/!!;
        $File =~ s/(.*)\.0/$1/;
        push( @Hash, $File );
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

    my %Attributes = ();
    if ( !$Param{Certificate} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Certificate!" );
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
    my @Result = ();
    my @Hash   = $Self->CertificateList();
    for (@Hash) {
        my $Certificate = $Self->CertificateGet( Hash => $_ );
        my %Attributes = $Self->CertificateAttributes( Certificate => $Certificate );
        my $Hit = 0;
        if ($Search) {
            for ( keys %Attributes ) {
                if ( $Attributes{$_} =~ /$Search/i ) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ( $Hit && $Attributes{Private} eq 'Yes' ) {
            $Attributes{Type} = 'key';
            push( @Result, \%Attributes );
        }
    }
    return @Result;

}

=item PrivateAdd()

add private key

    my $Message = $CryptObject->PrivateAdd(
        Private => $PrivateKeyString,
        Secret => 'Password',
    );

=cut

sub PrivateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Private} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Private!" );
        return;
    }

    # get private attributes
    my %Attributes = $Self->PrivateAttributes(%Param);
    if ( !$Attributes{Modulus} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "No Private Key!" );
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
        if (open( my $PrivKeyFH, "> $File.0" ) ) {
            print $PrivKeyFH $Param{Private};
            close $PrivKeyFH;
            open( my $PassFH, "> $File.P" );
            print $PassFH $Param{Secret};
            close $PassFH;
            return "Private Key uploaded!";
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Can't write $File: $!!" );
            return;
        }
    }
    else {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't add invalid private key!" );
        return;
    }

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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Hash!" );
        return;
    }
    my $File = "$Self->{PrivatePath}/$Param{Hash}.0";
    if ( !-f $File ) {

        # no private exists
        return;
    }
    elsif ( open( IN, "< $File" ) ) {
        my $Private = '';
        while (<IN>) {
            $Private .= $_;
        }
        close(IN);

        # read secret
        my $File   = "$Self->{PrivatePath}/$Param{Hash}.P";
        my $Secret = '';
        if ( open( IN, "< $File" ) ) {
            while (<IN>) {
                $Secret .= $_;
            }
            close(IN);
        }
        return ( $Private, $Secret );
    }
    else {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Can't open $File: $!!" );
        return;
    }

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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Hash!" );
        return;
    }
    unlink "$Self->{PrivatePath}/$Param{Hash}.0" || return 0;
    unlink "$Self->{PrivatePath}/$Param{Hash}.P" || return 0;
    return 1;
}

=item PrivateList()

returns a list of private key hashs

    my @Hash = $CryptObject->PrivateList();

=cut

sub PrivateList {
    my ( $Self, %Param ) = @_;

    my @Hash = ();
    my @List = glob("$Self->{PrivatePath}/*.0");
    for my $File (@List) {
        $File =~ s!^.*/!!;
        $File =~ s/(.*)\.0/$1/;
        push( @Hash, $File );
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

    my %Attributes = ();
    my %Option = ( Modulus => '-modulus', );
    if ( !$Param{Private} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Private!" );
        return;
    }
    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Private};
    close $FH;
    my ( $FHSecret, $SecretFile ) = $Self->{FileTempObject}->TempFile();
    print $FHSecret $Param{Secret};
    close $FHSecret;
    my $Options = "rsa -in $Filename -noout -modulus -passin file:$SecretFile";
    my $LogMessage = qx{$Self->{Cmd} $Options 2>&1};
    unlink $SecretFile;
    $LogMessage =~ tr{\r\n}{}d;
    $LogMessage =~ s/Modulus=//;
    $Attributes{Modulus} = $LogMessage;
    $Attributes{Type} = 'P';
    return %Attributes;
}

sub _FetchAttributesFromCert {
    my ( $Self, $Filename, $AttributesRef ) = @_;

    my %Option = (
        Hash        => '-hash',
        Issuer      => '-issuer',
        Fingerprint => '-fingerprint -sha1',
        Serial      => '-serial',
        Subject     => '-subject',
        StartDate   => '-startdate',
        EndDate     => '-enddate',
        Email       => '-email',
        Modulus     => '-modulus',
    );
    for my $Key ( keys %Option ) {
        my $Options = "x509 -in $Filename -noout $Option{$Key}";
        my $Output = qx{$Self->{Cmd} $Options 2>&1};
        $Output =~ tr{\r\n}{}d;
        if ( $Key eq 'Issuer' ) {
            $Output =~ s/=/= /g;
        }
        elsif ( $Key eq 'Fingerprint' ) {
            $Output =~ s/SHA1 Fingerprint=//;
        }
        elsif ( $Key eq 'StartDate' ) {
            $Output =~ s/notBefore=//;
        }
        elsif ( $Key eq 'EndDate' ) {
            $Output =~ s/notAfter=//;
        }
        elsif ( $Key eq 'Subject' ) {
            $Output =~ s/subject=//;
            $Output =~ s/\// /g;
            $Output =~ s/=/= /g;
        }
        elsif ( $Key eq 'Modulus' ) {
            $Output =~ s/Modulus=//;
        }
        if ( $Key =~ /(StartDate|EndDate)/ ) {
            my $Type = $1;
            if ( $Output =~ /(.+?)\s(.+?)\s(\d\d:\d\d:\d\d)\s(\d\d\d\d)/ ) {
                my $Day = $2;
                if ( $Day < 10 ) {
                    $Day = "0" . int($Day);
                }
                my $Month = '';
                my $Year  = $4;
                if ( $Output =~ /jan/i ) {
                    $Month = '01';
                }
                elsif ( $Output =~ /feb/i ) {
                    $Month = '02';
                }
                elsif ( $Output =~ /mar/i ) {
                    $Month = '03';
                }
                elsif ( $Output =~ /apr/i ) {
                    $Month = '04';
                }
                elsif ( $Output =~ /mai/i ) {
                    $Month = '05';
                }
                elsif ( $Output =~ /jun/i ) {
                    $Month = '06';
                }
                elsif ( $Output =~ /jul/i ) {
                    $Month = '07';
                }
                elsif ( $Output =~ /aug/i ) {
                    $Month = '08';
                }
                elsif ( $Output =~ /sep/i ) {
                    $Month = '09';
                }
                elsif ( $Output =~ /oct/i ) {
                    $Month = '10';
                }
                elsif ( $Output =~ /nov/i ) {
                    $Month = '11';
                }
                elsif ( $Output =~ /dec/i ) {
                    $Month = '12';
                }
                $AttributesRef->{"Short$Type"} = "$Year-$Month-$Day";
            }
        }
        $AttributesRef->{$Key} = $Output;
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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.22 $ $Date: 2008-05-15 13:49:17 $

=cut
