# --
# Kernel/System/Crypt/SMIME.pm - the main crypt module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SMIME.pm,v 1.4 2004-08-06 13:29:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt::SMIME;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Init {
    my $Self = shift;
    my %Param = @_;

    $Self->{Bin} = $Self->{ConfigObject}->Get('SMIME::Bin') || '/usr/bin/openssl';
    $Self->{CertPath} = $Self->{ConfigObject}->Get('SMIME::CertPath');
    $Self->{PrivatePath} = $Self->{ConfigObject}->Get('SMIME::PrivatePath');

    if ($Self->{CertPath}) {
        $Self->{CertPathArg} = " -CApath $Self->{CertPath}";
    }
    else {
        $Self->{CertPathArg} = '';
    }

    return $Self;
}
# crypt
sub Crypt {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = '';
    my $UsedKey = '';
    # check needed stuff
    foreach (qw(Message Hash)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHCrypted, $FilenameCrypted) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};

    open (SIGN, "$Self->{Bin} smime -encrypt -in $Filename -out $FilenameCrypted -des3 newcert.pem 2>&1 |");
    while (<SIGN>) {
        $LogMessage .= $_;
    }
    close (SIGN);
    if ($LogMessage) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't crypt: $LogMessage!");
        return;
    }
    my $Crypted;
    open (TMP, "< $FilenameCrypted");
    while (<TMP>) {
        $Crypted .= $_;
    }
    close (TMP);
    return $Crypted;
}
# decrypt
sub Decrypt {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = '';
    my $UsedKey = '';
    # check needed stuff
    foreach (qw(Message Hash)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my ($Private, $Secret) = $Self->PrivateGet(%Param);
    my $Certificate = $Self->CertificateGet(%Param);
    my ($FHPrivate, $FilenamePrivate) = $Self->{FileTempObject}->TempFile();
    print $FHPrivate $Private;
    my ($FHCertificate, $FilenameCertificate) = $Self->{FileTempObject}->TempFile();
    print $FHCertificate $Certificate;
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHDecrypted, $FilenameDecrypted) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};

#    open (IN, "$Self->{Bin} smime -decrypt -passin pass:1234 -in $Filename -out $FilenameDecrypted -recip newcert.pem -inkey newpriv.pem 2>&1 |");
    open (IN, "$Self->{Bin} smime -decrypt -passin ".quotemeta($Secret)." -in $Filename -out $FilenameDecrypted -recip $FilenameCertificate -inkey $FilenamePrivate 2>&1 |");
    while (<IN>) {
        $LogMessage .= $_;
    }
    close (IN);
    if ($LogMessage) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't decrypt: $LogMessage!");
        return (
            Successful => 0,
            Message => $LogMessage,
        );
    }
    my $Decrypted;
    open (TMP, "< $FilenameDecrypted");
    while (<TMP>) {
        $Decrypted .= $_;
    }
    close (TMP);
    return (
        Successful => 1,
        Message => "OpenSSL: OK",
        Data => $Decrypted,
    );
}
# sign
sub Sign {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = '';
    my $UsedKey = '';
    # check needed stuff
    foreach (qw(Message Hash)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my ($Private, $Secret) = $Self->PrivateGet(%Param);
    my $Certificate = $Self->CertificateGet(%Param);
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    my ($FHSign, $FilenameSign) = $Self->{FileTempObject}->TempFile();
    my ($FHPrivate, $FilenamePrivate) = $Self->{FileTempObject}->TempFile();
    print $FHPrivate $Private;
    my ($FHCertificate, $FilenameCertificate) = $Self->{FileTempObject}->TempFile();
    print $FHCertificate $Certificate;
    open (SIGN, "export HOME=/var/lib/wwwrun && $Self->{Bin} smime -sign -passin pass:".quotemeta($Secret)." -in $Filename -out $FilenameSign -text -signer $FilenameCertificate -inkey $FilenamePrivate -binary 2>&1 |");
    while (<SIGN>) {
        $LogMessage .= $_;
    }
    close (SIGN);
    if ($LogMessage) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't sign: $LogMessage!");
        return;
    }
    my $Signed;
    open (TMP, "< $FilenameSign");
    while (<TMP>) {
        $Signed .= $_;
    }
    close (TMP);
    return $Signed;

}
# verify_sign
sub Verify {
    my $Self = shift;
    my %Param = @_;
    my %Return = ();
    my $Message = '';
    my $MessageLong = '';
    my $UsedKey = '';
    # check needed stuff
    if (!$Param{Message}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Message!");
        return;
    }

    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHSign, $FilenameSign) = $Self->{FileTempObject}->TempFile();
    my ($FHOutput, $FilenameOutput) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    my $File = $Filename;
    if ($Param{Sign}) {
        print $FHSign $Param{Sign};
        $File = "$FilenameSign $File";
    }
#    open (VERIFY, "openssl smime -verify -in $Param{Sign} -CAfile $File 2>&1 |");
#    open (VERIFY, "openssl smime -verify -in $Filename -signer $FilenameSign -out $FilenameOutput -CAfile /etc/ssl/certs/bsi.pem 2>&1 |");
    open (VERIFY, "$Self->{Bin} smime -verify -in $Filename -signer $FilenameSign -out $FilenameOutput $Self->{CertPathArg} 2>&1 |");
#-noverify
#    open (VERIFY, "openssl rsautl -verify -in $Filename -inkey $FilenameSign -out /tmp/signedtext.txt 2>&1 |");
    while (<VERIFY>) {
        $MessageLong .= $_;
        if ($_ =~ /^\d.*:(.+?):.+?:.+?:$/ || $_ =~ /^\d.*:(.+?)$/) {
            $Message .= ";$1";
        }
        else {
            $Message .= $_;
        }
    }
    close (VERIFY);
    if ($Message =~ /Verification successful/i) {
        %Return = (
            SignatureFound => 1,
            Successful => 1,
#            Message => $1,
            Message => "OpenSSL: ".$Message,
            MessageLong => "OpenSSL: ".$MessageLong,
        );
    }
    else {
        %Return = (
            SignatureFound => 1,
            Successful => 0,
            Message => "OpenSSL: ".$Message,
            MessageLong => "OpenSSL: ".$MessageLong,
        );
    }
    return %Return;
}
# serarch public certificate
sub CertificateSearch {
    my $Self = shift;
    my %Param = @_;
    my $Search = $Param{Search} || '';
    my @Result = ();
    my @Hash = $Self->CertificateList();
    foreach (@Hash) {
        my $Certificate = $Self->CertificateGet(Hash => $_);
        my %Attributes = $Self->CertificateAttributes(Certificate => $Certificate);
        my $Hit = 0;
        if ($Search) {
            foreach (keys %Attributes) {
                if (eval {$Attributes{$_} =~ /$Search/i}) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ($Hit) {
            push (@Result, \%Attributes);
        }
    }
    return @Result;
}

# add certificate
sub CertificateAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Certificate}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Certificate!");
        return;
    }
    my %Attributes = $Self->CertificateAttributes(%Param);
    if ($Attributes{Hash}) {
        my $File = "$Self->{CertPath}/$Attributes{Hash}.0";
        if (open (OUT, "> $File")) {
            print OUT $Param{Certificate};
            close (OUT);
            return "Certificate uploaded!";
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $File: $!!");
            return;
        }
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't add invalid certificat!");
        return;
    }
}
# get certificate
sub CertificateGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Hash}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Hash!");
        return;
    }
    my $File = "$Self->{CertPath}/$Param{Hash}.0";
    if (open (IN, "< $File")) {
        my $Certificate = '';
        while (<IN>) {
            $Certificate .= $_;
        }
        close (IN);
        return $Certificate;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't open $File: $!!");
        return;
    }
}

# remove certificate
sub CertificateRemove {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Hash}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Hash!");
        return;
    }
    unlink "$Self->{CertPath}/$Param{Hash}.0" || return $!;
    return;
}

# list certificate
sub CertificateList {
    my $Self = shift;
    my %Param = @_;
    my @Hash = ();
    my @List = glob("$Self->{CertPath}/*.0");
    foreach my $File (@List) {
       $File =~ s!^.*/!!;
       $File =~ s/(.*)\.0/$1/;
       push (@Hash, $File);
    }
    return @Hash;
}

sub CertificateAttributes {
    my $Self = shift;
    my %Param = @_;
    my %Attributes = ();
    my %Option = (
        Hash => '-hash',
        Issuer => '-issuer',
        Fingerprint => '-fingerprint',
        Serial => '-serial',
        Subject => '-subject',
        StartDate => '-startdate',
        EndDate => '-enddate',
        Email => '-email',
        Modulus => '-modulus',
    );
    if (!$Param{Certificate}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Certificate!");
        return;
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Certificate};
    foreach my $Key (keys %Option) {
        open (VERIFY, "$Self->{Bin} x509 -in $Filename -noout $Option{$Key} |");
        my $Line = '';
        while (<VERIFY>) {
            chomp($_);
            $Line .= $_;
        }
        close (VERIFY);
        if ($Key eq 'Issuer') {
            $Line =~ s/=/= /g;
        }
        elsif ($Key eq 'Fingerprint') {
            $Line =~ s/MD5 Fingerprint=//;
        }
        elsif ($Key eq 'StartDate') {
            $Line =~ s/notBefore=//;
        }
        elsif ($Key eq 'EndDate') {
            $Line =~ s/notAfter=//;
        }
        elsif ($Key eq 'Subject') {
            $Line =~ s/subject=//;
            $Line =~ s/\// /g;
            $Line =~ s/=/= /g;
        }
        elsif ($Key eq 'Modulus') {
            $Line =~ s/Modulus=//;
        }
        if ($Key =~ /(StartDate|EndDate)/) {
            my $Type = $1;
            if ($Line =~ /(.+?)\s(.+?)\s(\d\d:\d\d:\d\d)\s(\d\d\d\d)/) {
                my $Day = $2;
                if ($Day < 10) {
                    $Day = "0".int($Day);
                }
                my $Month = '';
                my $Year = $4;
                if ($Line =~ /jan/i) {
                    $Month = '01';
                }
                elsif ($Line =~ /feb/i) {
                    $Month = '02';
                }
                elsif ($Line =~ /mar/i) {
                    $Month = '03';
                }
                elsif ($Line =~ /apr/i) {
                    $Month = '04';
                }
                elsif ($Line =~ /mai/i) {
                    $Month = '05';
                }
                elsif ($Line =~ /jun/i) {
                    $Month = '06';
                }
                elsif ($Line =~ /jul/i) {
                    $Month = '07';
                }
                elsif ($Line =~ /aug/i) {
                    $Month = '08';
                }
                elsif ($Line =~ /sep/i) {
                    $Month = '09';
                }
                elsif ($Line =~ /oct/i) {
                    $Month = '10';
                }
                elsif ($Line =~ /nov/i) {
                    $Month = '11';
                }
                elsif ($Line =~ /dec/i) {
                    $Month = '12';
                }
                $Attributes{"Short$Type"} = "$Year-$Month-$Day";
            }
        }
        $Attributes{$Key} = $Line;
    }
    if ($Attributes{Hash}) {
        my $Private = $Self->PrivateGet(Hash => $Attributes{Hash});
        if ($Private) {
            $Attributes{Private} = 'Yes';
            $Attributes{Type} = 'C+P';
        }
        else {
            $Attributes{Private} = 'No';
            $Attributes{Type} = 'C';
        }
    }
    return %Attributes;
}

# serach private
sub PrivateSearch {
    my $Self = shift;
    my %Param = @_;
    my $Search = $Param{Search} || '';
    my @Result = ();
    my @Hash = $Self->CertificateList();
    foreach (@Hash) {
        my $Certificate = $Self->CertificateGet(Hash => $_);
        my %Attributes = $Self->CertificateAttributes(Certificate => $Certificate);
        my $Hit = 0;
        if ($Search) {
            foreach (keys %Attributes) {
                if ($Attributes{$_} =~ /$Search/i) {
                    $Hit = 1;
                }
            }
        }
        else {
            $Hit = 1;
        }
        if ($Hit && $Attributes{Private} eq 'Yes') {
            push (@Result, \%Attributes);
        }
    }
    return @Result;

}
# serach private
sub PrivateAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Private}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Private!");
        return;
    }
    # get private attributes
    my %Attributes = $Self->PrivateAttributes(%Param);
    if (!$Attributes{Modulus}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No Private Key!");
        return;
    }
    # get certificate hash
    my @Certificates = $Self->CertificateSearch(Search => $Attributes{Modulus});
    if (!@Certificates) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Certificate of Private Key first -$Attributes{Modulus})!");
        return;
    }
    elsif ($#Certificates > 0) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Multible Certificates with the same Modulus, can't add Private Key!");
        return;
    }
    my %CertificateAttributes = $Self->CertificateAttributes(
        Certificate => $Self->CertificateGet(Hash => $Certificates[0]->{Hash}),
    );
    if ($CertificateAttributes{Hash}) {
        my $File = "$Self->{PrivatePath}/$CertificateAttributes{Hash}";
        if (open (OUT, "> $File.0")) {
            print OUT $Param{Private};
            close (OUT);
            open (OUT, "> $File.P");
            print OUT $Param{Secret};
            close (OUT);
            return "Private Key uploaded!";
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write $File: $!!");
            return;
        }
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't add invalid private key!");
        return;
    }

}
# get private
sub PrivateGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Hash}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Hash!");
        return;
    }
    my $File = "$Self->{PrivatePath}/$Param{Hash}.0";
    if (! -f $File) {
        # no private exists
        return;
    }
    elsif (open (IN, "< $File")) {
        my $Private = '';
        while (<IN>) {
            $Private .= $_;
        }
        close (IN);
        # read secret
        my $File = "$Self->{PrivatePath}/$Param{Hash}.P";
        my $Secret = '';
        if (open (IN, "< $File")) {
            while (<IN>) {
                $Secret .= $_;
            }
            close (IN);
        }
        return ($Private, $Secret);
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't open $File: $!!");
        return;
    }

}
# remove private
sub PrivateRemove {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Hash}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Hash!");
        return;
    }
    unlink "$Self->{PrivatePath}/$Param{Hash}.0" || return $!;
    unlink "$Self->{PrivatePath}/$Param{Hash}.P" || return $!;
    return;
}
# list private
sub PrivateList {
    my $Self = shift;
    my %Param = @_;
    my @Hash = ();
    my @List = glob("$Self->{PrivatePath}/*.0");
    foreach my $File (@List) {
       $File =~ s!^.*/!!;
       $File =~ s/(.*)\.0/$1/;
       push (@Hash, $File);
    }
    return @Hash;

}
# private attributes
sub PrivateAttributes {
    my $Self = shift;
    my %Param = @_;
    my %Attributes = ();
    my %Option = (
        Modulus => '-modulus',
    );
    if (!$Param{Private}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Private!");
        return;
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Private};
    foreach my $Key (keys %Option) {
        my $Pass = '';
        if ($Param{Secret}) {
            $Pass = " -passin pass:$Param{Secret}";
        }
        open (VERIFY, "$Self->{Bin} rsa -in $Filename -noout $Option{$Key} $Pass |");
        my $Line = '';
        while (<VERIFY>) {
            chomp($_);
            $Line .= $_;
        }
        close (VERIFY);
        if ($Key eq 'Modulus') {
            $Line =~ s/Modulus=//;
        }
        $Attributes{$Key} = $Line;
    }
    return %Attributes;
}

1;
