# --
# Kernel/System/Crypt/PGP.pm - the main crypt module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PGP.pm,v 1.16 2007-08-21 19:55:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt::PGP;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

=head1 NAME

Kernel::System::Crypt::PGP - pgp crypt backend lib

=head1 SYNOPSIS

This is a sub module of Kernel::System::Crypt and contains all pgp functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

# just for internal
sub _Init {
    my $Self = shift;
    my %Param = @_;

    $Self->{GPGBin} = $Self->{ConfigObject}->Get('PGP::Bin') || '/usr/bin/gpg';
    $Self->{Options} = $Self->{ConfigObject}->Get('PGP::Options') || '--batch --no-tty --yes';

    $Self->{GPGBin} = "$Self->{GPGBin} $Self->{Options} ";

    return $Self;
}

=item Check()

check if environment is working

    my $Message = $CryptObject->Check();

=cut

sub Check {
    my $Self = shift;
    my %Param = @_;

    my $GPGBin = $Self->{ConfigObject}->Get('PGP::Bin') || '/usr/bin/gpg';
    if (! -e $GPGBin) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "No such $GPGBin!",
        );
        return "No such $GPGBin!";
    }
    elsif (! -x $GPGBin) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "$GPGBin not executable!",
        );
        return "$GPGBin not executable!";
    }
    return;
}

=item Crypt()

crypt a message

    my $Message = $CryptObject->Crypt(
        Message => $Message,
        Key => $PGPPublicKeyID,
    );

=cut

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

=item Decrypt()

decrypt a message and returns a hash (Successful, Message, Data)

    my %Message = $CryptObject->Decrypt(
        Message => $CryptedMessage,
    );

=cut

sub Decrypt {
    my $Self = shift;
    my %Param = @_;
    my %Return = ();
    # check needed stuff
    foreach (qw(Message)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    my @Keys = $Self->_CryptedWithKey(File => $Filename);
    foreach my $Key (@Keys) {
        my $Password = $Param{Password};
        if (!$Password) {
            my $Pw;
            my %PasswordHash = %{$Self->{ConfigObject}->Get('PGP::Key::Password')};
            if (defined($PasswordHash{$Key})) {
                $Pw = $PasswordHash{$Key};
            }
            if (defined($Pw)) {
                $Password = $Pw;
            }
            else {
                $Password = '';
            }
        }
        %Return = $Self->_DecryptPart(
            Filename => $Filename,
            Key => $Key,
            Password => $Password,
        );
        if ($Return{Successful}) {
            last;
        }
    }
    if (!%Return) {
        return (
            Successful => 0,
            Message => 'gpg: No privat key found to decrypt this message!',
        );
    }
    else {
        return %Return;
    }
}

sub _DecryptPart {
    my $Self = shift;
    my %Param = @_;
    my $LogMessage = '';
    my $Decrypt = '';
    # check needed stuff
    foreach (qw(Key Password Filename)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    my ($FHDecrypt, $FilenameDecrypt) = $Self->{FileTempObject}->TempFile();
    open (SIGN, "echo ".quotemeta($Param{Password})." | $Self->{GPGBin} --passphrase-fd 0 --always-trust --yes -d -o $FilenameDecrypt $Param{Filename} 2>&1 | ");
    while (<SIGN>) {
        $LogMessage .= $_;
    }
    close (SIGN);
    if ($LogMessage =~ /failed/i) {
        $Self->{LogObject}->Log(Priority => 'notice', Message => "$LogMessage!");
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
            Message => $LogMessage,
            Data => $Decrypt,
        );
    }
}

=item Sign()

sign a message

    my $Sign = $CryptObject->Sign(
        Message => $Message,
        Key => $PGPPrivateKeyID,
        Type => 'Detached'  # Detached|Inline
    );

=cut

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
    my $Pw = '';
    my %Password = %{$Self->{ConfigObject}->Get('PGP::Key::Password')};
    if (defined ($Password{$Param{Key}})) {
        $Pw = $Password{$Param{Key}};
    }
    if ($Param{Type} && $Param{Type} eq 'Detached') {
        $AddParams = '-sba';
    }
    else {
        $AddParams = '--clearsign';
    }

    # create tmp files
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    my ($FHSign, $FilenameSign) = $Self->{FileTempObject}->TempFile();
    $Self->{EncodeObject}->SetIO($FH);
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
    $Self->{EncodeObject}->SetIO(\*TMP);
    while (<TMP>) {
        $Signed .= $_;
    }
    close (TMP);
    return $Signed;
}

=item Verify()

verify a message signature and returns a hash (Successful, Message, Data)

Inline sign:

    my %Data = $CryptObject->Verify(
        Message => $Message,
    );

Attached sign:

    my %Data = $CryptObject->Verify(
        Message => $Message,
        Sign => $Sign,
    );

=cut

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
    $Self->{EncodeObject}->SetIO($FH);
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

=item KeySearch()

returns a array with serach result (private and public keys)

    my @Keys = $CryptObject->KeySearch(
        Search => 'something to search'
    );

=cut

sub KeySearch {
    my $Self = shift;
    my %Param = @_;
    my @Result = ();
    push (@Result, $Self->PublicKeySearch(%Param));
    push (@Result, $Self->PrivateKeySearch(%Param));
    return @Result;
}

=item PrivateKeySearch()

returns a array with serach result (private keys)

    my @Keys = $CryptObject->PrivateKeySearch(
        Search => 'something to search'
    );

=cut

sub PrivateKeySearch {
    my $Self = shift;
    my %Param = @_;
    my $Search = $Param{Search} || '';
    my @Result = ();
    my $InKey = 0;
    open (SEARCH, "$Self->{GPGBin} --list-secret-keys --with-fingerprint ".quotemeta($Search)." 2>&1 |");
    my %Key = ();
    while (my $Line = <SEARCH>) {
        if ($Line =~ /^(se.+?)\s{1,6}(.+?)\/(.+?)\s(.+?)\s(.*)$/) {
            if (%Key) {
                push (@Result, {%Key});
                %Key = ();
            }
            $InKey = 1;
            $Key{Type} .= $1;
            $Key{Bit} .= $2;
            $Key{Key} .= $3;
            $Key{Created} .= $4;
            $Key{Identifier} .= $5;
            $Key{IdentifierMaster} .= $5;
        }
        if ($InKey && $Line =~ /^uid\s+(.*)/) {
            if ($Key{Identifier}) {
                $Key{Identifier} .= ', '.$1;
            }
            else {
                $Key{Identifier} = $1;
            }
        }
        if ($InKey && $Line =~ /^(ssb)\s(.+?)\/(.+?)\s(.+?)\s/) {
            $Key{Bit} = ''.$2;
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

=item PublicKeySearch()

returns a array with serach result (public keys)

    my @Keys = $CryptObject->PublicKeySearch(
        Search => 'something to search'
    );

=cut

sub PublicKeySearch {
    my $Self = shift;
    my %Param = @_;
    my $Search = $Param{Search} || '';
    my @Result = ();
    my $InKey = 0;
    open (SEARCH, "$Self->{GPGBin} --list-public-keys --with-fingerprint ".quotemeta($Search)." 2>&1 |");
    my %Key = ();
    while (my $Line = <SEARCH>) {
        if ($Line =~ /^(p.+?)\s{1,6}(.+?)\/(.+?)\s(.+?)\s(.*)$/) {
            if (%Key) {
                push (@Result, {%Key});
                %Key = ();
            }
            $InKey = 1;
            $Key{Type} .= $1;
            $Key{Bit} .= $2;
            $Key{Key} .= $3;
            $Key{Created} .= $4;
            if ($5 !~ /\[expires:\s.+?\]/) {
                $Key{Identifier} .= $5;
                $Key{IdentifierMaster} .= $5;
            }
        }
        if ($InKey && $Line =~ /^uid\s+(.*)/) {
            if ($Key{Identifier}) {
                $Key{Identifier} .= ', '.$1;
            }
            else {
                $Key{Identifier} = $1;
            }
        }
        if ($InKey && $Line =~ /^sub\s+(.+?)\/(.+?)\s.*/) {
            $Key{KeyPrivate} = $2;
        }
        if ($InKey && $Line =~ /\[expires:\s(.+?)\]/) {
            $Key{Expires} = $1;
        }
        if ($InKey && $Line =~ /Key\sfingerprint\s=\s(.*)/i) {
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

=item PublicKeyGet()

returns public key in ascii

    my $Key = $CryptObject->PublicKeyGet(
        Key => $KeyID,
    );

=cut

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

    if ($KeyString =~/nothing exported/i) {
        $KeyString =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't export key: $KeyString!",
        );
        return;
    }

    return $KeyString;
}

=item SecretKeyGet()

returns secret key in ascii

    my $Key = $CryptObject->SecretKeyGet(
        Key => $KeyID,
    );

=cut

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

    if ($KeyString =~/nothing exported/i) {
        $KeyString =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't export key: $KeyString!",
        );
        return;
    }

    return $KeyString;
}

=item PublicKeyDelete()

remove public key from key ring

    $CryptObject->PublicKeyDelete(
        Key => $KeyID,
    );

=cut

sub PublicKeyDelete {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $KeyString = '';
    my %Result = ();
    # check needed stuff
    if (!$Key) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Key!",
        );
        return;
    }
    open (SEARCH, "$Self->{GPGBin} --delete-key ".quotemeta($Key)." 2>&1 |");
    while (<SEARCH>) {
        $KeyString .= $_;
    }
    close (SEARCH);

    if ($KeyString) {
        $KeyString =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't delete key: $KeyString!",
        );
        return;
    }

    return 1;
}

=item SecretKeyDelete()

remove secret key from key ring

    $CryptObject->SecretKeyDelete(
        Key => $KeyID,
    );

=cut

sub SecretKeyDelete {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $KeyString = '';
    my %Result = ();
    # check needed stuff
    if (!$Key) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Key!",
        );
        return;
    }
    my @Keys = $Self->PrivateKeySearch(
        Search => $Key,
    );
    if ($Keys[1]) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't delete key, multible key for $Key!",
        );
        return;
    }
    if (!$Keys[0]->{FingerprintShort}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't delete key, found no fingerprint for $Key!",
        );
        return;
    }
    open (SEARCH, "$Self->{GPGBin} --delete-secret-key ".quotemeta($Keys[0]->{FingerprintShort})." 2>&1 |");
    while (<SEARCH>) {
        $KeyString .= $_;
    }
    close (SEARCH);

    if ($KeyString) {
        $KeyString =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't delete key: $KeyString!",
        );
        return;
    }

    return 1;
}

=item KeyAdd()

add key to key ring

    my $Message = $CryptObject->KeyAdd(
        Key => $KeyString,
    );

=cut

sub KeyAdd {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || '';
    my $Message = '';
    my %Result = ();
    # check needed stuff
    if (!$Key) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Key!",
        );
        return;
    }
    my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();
    print $FH $Key;
    open (OUT, "$Self->{GPGBin} --import $Filename 2>&1 |");
    while (<OUT>) {
        $Message .= $_;
    }
    close (OUT);
    if ($Message =~/failed/i) {
        $Message =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't add key: $Message!",
        );
        return;
    }
    return $Message;
}

sub _CryptedWithKey {
    my $Self = shift;
    my %Param = @_;
    my $Message = '';
    my @Keys = ();
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
    my @Lines = split(/\n/, $Message);
    foreach my $Line (@Lines) {
        if ($Line =~ /encrypted with.+?\sID\s(........)/i) {
            my @Result = $Self->PrivateKeySearch(Search => $1);
            if (@Result) {
                push (@Keys, ($Result[$#Result]->{Key} || $1));
            }
        }
    }
    return @Keys;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.16 $ $Date: 2007-08-21 19:55:45 $

=cut
