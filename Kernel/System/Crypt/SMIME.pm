# --
# Kernel/System/Crypt/SMIME.pm - the main crypt module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SMIME.pm,v 1.2 2004-08-04 13:11:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt::SMIME;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Init {
    my $Self = shift;
    my %Param = @_;

    $Self->{Bin} = $Self->{ConfigObject}->Get('SMIME::Bin') || '/usr/bin/openssl';
    $Self->{CertPath} = $Self->{ConfigObject}->Get('SMIME::CertPath');

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
    foreach (qw(Message Key)) {
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
    foreach (qw(Message Cert Key)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHDecrypted, $FilenameDecrypted) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};

#    open (IN, "$Self->{Bin} smime -decrypt -passin pass:1234 -in $Filename -out $FilenameDecrypted -recip newcert.pem -inkey newpriv.pem 2>&1 |");
    open (IN, "$Self->{Bin} smime -decrypt -passin pass:1234 -in $Filename -out $FilenameDecrypted -recip /home/martin/src/otrs-cvs/newcert.pem -inkey /home/martin/src/otrs-cvs/newpriv.pem 2>&1 |");
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
    foreach (qw(Message Key Cert)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHSign, $FilenameSign) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    open (SIGN, "$Self->{Bin} smime -sign -passin pass:1234 -in $Filename -out $FilenameSign -text -signer newcert.pem -inkey newpriv.pem 2>&1 |");
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
    if (!$Param{Certificate}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Certificate!");
        return;
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Certificate};

    open (VERIFY, "$Self->{Bin} x509 -in $Filename -noout -hash -issuer -fingerprint -serial -subject -startdate -enddate -email |");
    my $Line = 0;
    while (my $LineIn = <VERIFY>) {
        $Line++;
        chomp($LineIn);
        if ($Line == 1) {
            $Attributes{Hash} = $LineIn;
        }
        elsif ($Line == 2) {
            $Attributes{Issuer} = $LineIn;
            $Attributes{Issuer} =~ s/\//\/ /g;
        }
        elsif ($Line == 3) {
            $Attributes{Fingerprint} = $LineIn;
            $Attributes{Fingerprint} =~ s/MD5 Fingerprint=//g;
        }
        elsif ($Line == 4) {
            $Attributes{Serial} = $LineIn;
        }
        elsif ($Line == 5) {
            $Attributes{Subject} = $LineIn;
        }
        elsif ($Line == 6) {
            $Attributes{StartDate} = $LineIn;
            $Attributes{StartDate} =~ s/notBefore=//g;
        }
        elsif ($Line == 7) {
            $Attributes{EndDate} = $LineIn;
            $Attributes{EndDate} =~ s/notAfter=//g;
        }
        elsif ($Line == 8) {
            $Attributes{Email} = $LineIn;
        }
    }
    close (VERIFY);
    return %Attributes;
}

# serach private
sub PrivatSearch {
    my $Self = shift;
    my %Param = @_;

}
# serach private
sub PrivatAdd {
    my $Self = shift;
    my %Param = @_;

}
# serach private
sub PrivatGet {
    my $Self = shift;
    my %Param = @_;

}
# serach private
sub PrivatRemove {
    my $Self = shift;
    my %Param = @_;

}

1;
