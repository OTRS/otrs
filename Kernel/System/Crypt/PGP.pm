# --
# Kernel/System/Crypt/PGP.pm - the main crypt module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PGP.pm,v 1.5 2004-08-12 10:35:41 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt::PGP;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Init {
    my $Self = shift;
    my %Param = @_;


    $Self->{GPGBin} = $Self->{ConfigObject}->Get('PGP::Bin') || '/usr/bin/gpg';
    $Self->{Options} = $Self->{ConfigObject}->Get('PGP::Options') || '--batch --no-tty --yes';

    $Self->{GPGBin} = "$Self->{GPGBin} $Self->{Options} ";

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
    my ($FHCrypt, $FilenameCrypt) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    open (CRYPT, "$Self->{GPGBin} --always-trust --yes -e -a -o $FilenameCrypt -r $Param{Key} $Filename |");
    while (<CRYPT>) {
        $LogMessage .= $_;
    }
    close (CRYPT);
    # error
    if ($LogMessage) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't crypt with Key $Param{Key}: $LogMessage!");
        return;
    }
    # get crypted content
    my $Crypt;
    open (TMP, "< $FilenameCrypt") || die "$!";
    while (<TMP>) {
        $Crypt .= $_;
    }
    close (TMP);
    return $Crypt;
}
# decrypt
sub Decrypt {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = '';
    my $Decrypt = '';
    # check needed stuff
    foreach (qw(Message)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHDecrypt, $FilenameDecrypt) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    if (!$Param{Password}) {
        my $Pw;
        my @Keys = $Self->_CryptedWithKey(File => $Filename);
        foreach (@Keys) {
            if (defined ($Self->{ConfigObject}->Get("PGP::Key::Password::$_"))) {
                $Pw = $Self->{ConfigObject}->Get("PGP::Key::Password::$_");
            }
        }
        if (defined($Pw)) {
            $Param{Password} = $Pw;
        }
        else {
            $Param{Password} = '';
        }
    }
    open (SIGN, "echo ".quotemeta($Param{Password})." | $Self->{GPGBin} --passphrase-fd 0 --always-trust --yes -d -o $FilenameDecrypt $Filename 2>&1 | ");
    while (<SIGN>) {
        $LogMessage .= $_;
    }
    close (SIGN);
    if ($LogMessage =~ /failed/i) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "$LogMessage!");
        return (
            Successful => 0,
            Message => $LogMessage,
        );
    }
    else {
        open (TMP, "< $FilenameDecrypt");
        while (<TMP>) {
            $Decrypt .= $_;
        }
        close (TMP);
        return (
            Successful => 1,
            Message => "$LogMessage",
            Data => $Decrypt,
        );
    }
}
# sign
sub Sign {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = '';
    my $UsedKey = '';
    my $AddParams = '';
    # check needed stuff
    foreach (qw(Message Key)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $Pw = $Self->{ConfigObject}->Get("PGP::Key::Password::$Param{Key}") || '';
    if ($Param{Type} && $Param{Type} eq 'Detached') {
        $AddParams = '-sba';
    }
    else {
        $AddParams = '--clearsign';
    }

    # create tmp files
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHSign, $FilenameSign) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};

    open (SIGN, "echo ".quotemeta($Pw)." | $Self->{GPGBin} --passphrase-fd 0 --default-key $Param{Key} -o $FilenameSign $AddParams $Filename 2>&1 |");
    while (<SIGN>) {
        $LogMessage .= $_;
    }
    close (SIGN);
    # error
    if ($LogMessage) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't sign with Key $Param{Key}: $LogMessage!");
        return;
    }
    # get signed content
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
    my $UsedKey = '';
    # check needed stuff
    if (!$Param{Message}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Message!");
        return;
    }

    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHSign, $FilenameSign) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    my $File = $Filename;
    if ($Param{Sign}) {
        print $FHSign $Param{Sign};
        $File = "$FilenameSign $File";
    }
    open (VERIFY, "$Self->{GPGBin} --verify $File 2>&1 |");
    while (<VERIFY>) {
        $Message .= $_;
    }
    close (VERIFY);
    if ($Message =~ /(Good signature from ".+?")/i) {
        %Return = (
            SignatureFound => 1,
            Successful => 1,
            Message => "gpg: $1",
            MessageLong => $Message,
        );
    }
    else {
        %Return = (
            SignatureFound => 1,
            Successful => 0,
            Message => $Message,
        );
    }
    return %Return;
}

sub KeySearch {
    my $Self = shift;
    my %Param = @_;
    my @Result = ();
    push (@Result, $Self->PublicKeySearch(%Param));
    push (@Result, $Self->PrivateKeySearch(%Param));
    return @Result;
}
sub PrivateKeySearch {
    my $Self = shift;
    my %Param = @_;
    my $Search = $Param{Search} || '';
    my @Result = ();
    my $InKey = 0;
    open (SEARCH, "$Self->{GPGBin} --list-secret-keys --with-fingerprint ".quotemeta($Search)." 2>&1 |");
    my %Key = ();
    while (my $Line = <SEARCH>) {
        if ($Line =~ /^(se.+?)\s(.+?)\/(.+?)\s(.+?)\s(.*)$/) {
            if (%Key) {
                push (@Result, {%Key});
                %Key = ();
            }
            $InKey = 1;
            $Key{Type} .= $1;
            $Key{Bit} .= $2;
            $Key{Key} .= $3;
            $Key{Created} .= $4;
            $Key{Identifer} .= $5;
        }
        if ($InKey && $Line =~ /^(ssb)\s(.+?)\/(.+?)\s(.+?)\s/) {
            $Key{Bit} = $2;
            $Key{Key} = $3;
            $Key{Created} = $4;
        }
        if ($InKey && $Line =~ /\[expires:\s(.+?)\]/) {
            $Key{Expires} = $1;
        }
        if ($InKey && $Line =~ /Key fingerprint = (.*)/) {
            $Key{Fingerprint} = $1;
            $Key{FingerprintShort} = $1;
            $Key{FingerprintShort} =~ s/  / /g;
            $Key{FingerprintShort} =~ s/ //g;
        }
    }
    push (@Result, {%Key}) if (%Key);
    close (SEARCH);

    return @Result;
}
sub PublicKeySearch {
    my $Self = shift;
    my %Param = @_;
    my $Search = $Param{Search} || '';
    my @Result = ();
    my $InKey = 0;
    open (SEARCH, "$Self->{GPGBin} --list-public-keys --with-fingerprint ".quotemeta($Search)." 2>&1 |");
    my %Key = ();
    while (my $Line = <SEARCH>) {
        if ($Line =~ /^(p.+?)\s(.+?)\/(.+?)\s(.+?)\s(.*)$/) {
            if (%Key) {
                push (@Result, {%Key});
                %Key = ();
            }
            $InKey = 1;
            $Key{Type} .= $1;
            $Key{Bit} .= $2;
            $Key{Key} .= $3;
            $Key{Created} .= $4;
            $Key{Identifer} .= $5;
        }
        if ($InKey && $Line =~ /\[expires:\s(.+?)\]/) {
            $Key{Expires} = $1;
        }
        if ($InKey && $Line =~ /Key fingerprint = (.*)/) {
            $Key{Fingerprint} = $1;
            $Key{FingerprintShort} = $1;
            $Key{FingerprintShort} =~ s/  / /g;
            $Key{FingerprintShort} =~ s/ //g;
        }
    }
    push (@Result, {%Key}) if (%Key);
    close (SEARCH);
    return @Result;
}

sub PublicKeyGet {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $KeyString = '';
    my %Result = ();
    open (SEARCH, "$Self->{GPGBin} --export -a ".quotemeta($Key)." 2>&1 |");
    while (<SEARCH>) {
        $KeyString .= $_;
    }
    close (SEARCH);

    return $KeyString;
}
sub SecretKeyGet {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $KeyString = '';
    my %Result = ();
    open (SEARCH, "$Self->{GPGBin} --export-secret-keys -a ".quotemeta($Key)." 2>&1 |");
    while (<SEARCH>) {
        $KeyString .= $_;
    }
    close (SEARCH);

    return $KeyString;
}

sub PublicKeyDelete {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $KeyString = '';
    my %Result = ();
    open (SEARCH, "$Self->{GPGBin} --delete-key ".quotemeta($Key)." 2>&1 |");
    while (<SEARCH>) {
        $KeyString .= $_;
    }
    close (SEARCH);

    return $KeyString;
}
sub SecretKeyDelete {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $KeyString = '';
    my %Result = ();
    open (SEARCH, "$Self->{GPGBin} --delete-secret-key ".quotemeta($Key)." 2>&1 |");
    while (<SEARCH>) {
        $KeyString .= $_;
    }
    close (SEARCH);

    return $KeyString;
}

sub KeyAdd {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $Message = '';
    my %Result = ();
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Key;
    open (OUT, "$Self->{GPGBin} --import $Filename 2>&1 |");
    while (<OUT>) {
        $Message .= $_;
    }
    close (OUT);
    return $Message;
}

sub _CryptedWithKey {
    my $Self = shift;
    my %Param = @_;
    my $Message = '';
    # check needed stuff
    if (!$Param{File}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need File!");
        return;
    }
    open (OUT, "$Self->{GPGBin} $Param{File} 2>&1 |");
    while (<OUT>) {
        $Message .= $_;
    }
    close (OUT);
    if ($Message =~ /encrypted with.+?\sID\s(.+?),\s/i) {
        my @Result = $Self->KeySearch(Search => $1);
        if (@Result) {
            return ($1, $Result[$#Result]->{Key});
        }
    }
    return;
}

