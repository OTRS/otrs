# --
# Kernel/System/Crypt/SMIME.pm - the main crypt module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SMIME.pm,v 1.1 2004-07-30 09:54:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt::SMIME;

use strict;
use Kernel::System::FileTemp;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    $Self->{Bin} = $Self->{ConfigObject}->Get('SMIME::Bin') || '/usr/bin/openssl';
    $Self->{CertPath} = $Self->{ConfigObject}->Get('SMIME::CertPath');

    if ($Self->{CertPath}) {
        $Self->{CertPath} = " -CApath $Self->{CertPath}";
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
    open (VERIFY, "$Self->{Bin} smime -verify -in $Filename -signer $FilenameSign -out $FilenameOutput $Self->{CertPath} 2>&1 |");
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
# add key

# remove key

# list key

# add certificate

# remove certificate

# list certificate
