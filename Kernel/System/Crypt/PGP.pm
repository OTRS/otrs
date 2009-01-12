# --
# Kernel/System/Crypt/PGP.pm - the main crypt module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PGP.pm,v 1.28 2009-01-12 12:57:07 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Crypt::PGP;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

=head1 NAME

Kernel::System::Crypt::PGP - pgp crypt backend lib

=head1 SYNOPSIS

This is a sub module of Kernel::System::Crypt and contains all pgp functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

# just for internal
sub _Init {
    my ( $Self, %Param ) = @_;

    $Self->{GPGBin}  = $Self->{ConfigObject}->Get('PGP::Bin')     || '/usr/bin/gpg';
    $Self->{Options} = $Self->{ConfigObject}->Get('PGP::Options') || '--batch --no-tty --yes';

    if ( $^O =~ m{Win}i ) {

        # take care to deal properly with paths containing whitespace
        $Self->{GPGBin} = qq{"$Self->{GPGBin}" $Self->{Options}};
    }
    else {

        # make sure that we are getting POSIX (i.e. english) messages from gpg
        $Self->{GPGBin} = "LC_MESSAGES=POSIX $Self->{GPGBin} $Self->{Options}";
    }

    return $Self;
}

=item Check()

check if environment is working

    my $Message = $CryptObject->Check();

=cut

sub Check {
    my ( $Self, %Param ) = @_;

    my $GPGBin = $Self->{ConfigObject}->Get('PGP::Bin') || '/usr/bin/gpg';
    if ( !-e $GPGBin ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such $GPGBin!",
        );
        return "No such $GPGBin!";
    }
    elsif ( !-x $GPGBin ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$GPGBin not executable!",
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
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $ParamName (qw( Message Key )) {
        if ( !$Param{$ParamName} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $ParamName!" );
            return;
        }
    }

    # since the following write would auto-convert utf8-characters into iso-characters, we
    # avoid that by explicitly encoding utf8-strings:
    if ( utf8::is_utf8( $Param{Message} ) ) {
        utf8::encode( $Param{Message} );
    }

    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;

    my ( $FHCrypt, $FilenameCrypt ) = $Self->{FileTempObject}->TempFile();
    close $FHCrypt;
    my $GPGOptions
        = "--always-trust --yes --encrypt --armor -o $FilenameCrypt -r $Param{Key} $Filename";
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    # error
    if ($LogMessage) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't crypt with Key $Param{Key}: $LogMessage!"
        );
        return;
    }

    # get crypted content
    my $CryptedDataRef = $Self->{MainObject}->FileRead( Location => $FilenameCrypt );
    return $$CryptedDataRef;
}

=item Decrypt()

Decrypt a message and returns a hash (Successful, Message, Data)

    my %Result = $CryptObject->Decrypt(
        Message => $CryptedMessage,
    );

The returned hash %Result has the following keys:

    'Successful' => '1',        # could the given data be decrypted at all (0 or 1)
    'Data'       => '...',      # the decrypted data
    'KeyID'      => 'FA23FB24'  # hex ID of PGP-(secret-)key that was used for decryption
    'Message'    => '...'       # descriptive text containing the result status

=cut

sub Decrypt {
    my ( $Self, %Param ) = @_;

    my %Return;

    # check needed stuff
    for (qw(Message)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;

    my %PasswordHash = %{ $Self->{ConfigObject}->Get('PGP::Key::Password') };
    my @Keys = $Self->_CryptedWithKey( File => $Filename );
    KEY:
    for my $Key (@Keys) {
        my $Password = $Param{Password} || $PasswordHash{$Key} || '';
        %Return = $Self->_DecryptPart(
            Filename => $Filename,
            Key      => $Key,
            Password => $Password,
        );
        last KEY if $Return{Successful};
    }
    if ( !%Return ) {
        return (
            Successful => 0,
            Message    => 'gpg: No privat key found to decrypt this message!',
        );
    }
    return %Return;
}

sub _DecryptPart {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key Password Filename)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my ( $FHDecrypt, $FileDecrypt ) = $Self->{FileTempObject}->TempFile();
    close $FHDecrypt;
    my ( $FHPhrase, $FilePhrase ) = $Self->{FileTempObject}->TempFile();
    print $FHPhrase $Param{Password};
    close $FHPhrase;
    my $GPGOptions
        = qq{--batch --passphrase-fd 0 --always-trust --yes --decrypt -o $FileDecrypt $Param{Filename}};
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions <$FilePhrase 2>&1};
    if ( $LogMessage =~ /failed/i ) {
        $Self->{LogObject}->Log( Priority => 'notice', Message => "$LogMessage!" );
        return (
            Successful => 0,
            Message    => $LogMessage,
        );
    }
    else {
        my $DecryptedDataRef = $Self->{MainObject}->FileRead( Location => $FileDecrypt );
        return (
            Successful => 1,
            Message    => $LogMessage,
            Data       => $$DecryptedDataRef,
            KeyID      => $Param{Key},
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
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Message Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %PasswordHash = %{ $Self->{ConfigObject}->Get('PGP::Key::Password') };
    my $Pw = $PasswordHash{ $Param{Key} } || '';
    my $SigType
        = $Param{Type} && $Param{Type} eq 'Detached'
        ? '--detach-sign --armor'
        : '--clearsign';

    # create tmp files
    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    close $FH;
    my ( $FHSign, $FileSign ) = $Self->{FileTempObject}->TempFile();
    close $FHSign;
    $Self->{MainObject}->FileWrite(
        Location => $Filename,
        Content  => \$Param{Message},
        Mode     => $Param{Charset} && $Param{Charset} =~ /utf(8|\-8)/i ? 'utf8' : 'binmode',
    );

    my ( $FHPhrase, $FilePhrase ) = $Self->{FileTempObject}->TempFile();
    print $FHPhrase $Pw;
    close $FHPhrase;
    my $GPGOptions
        = qq{--passphrase-fd 0 --default-key $Param{Key} -o $FileSign $SigType $Filename};
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions <$FilePhrase 2>&1};

    # error
    if ($LogMessage) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't sign with Key $Param{Key}: $LogMessage!"
        );
        return;
    }

    # get signed content
    my $SignedDataRef = $Self->{MainObject}->FileRead(
        Location => $FileSign,
        Mode => $Param{Charset} && $Param{Charset} =~ /utf(8|\-8)/i ? 'utf8' : 'binmode',
    );
    return $$SignedDataRef;
}

=item Verify()

verify a message signature and returns a hash (Successful, Message, Data)

Inline sign:

    my %Result = $CryptObject->Verify(
        Message => $Message,
    );

Attached sign:

    my %Result = $CryptObject->Verify(
        Message => $Message,
        Sign => $Sign,
    );

The returned hash %Result has the following keys:

    'SignatureFound' => '1',        # was a signature found at all (0 or 1)
    'Successful'     => '1',        # could the signature be verified (0 or 1)
    'KeyID'          => 'FA23FB24'  # hex ID of PGP-key that was used for signing
    'KeyUserID'      => 'username <user@test.org>'  # PGP-User-ID (e-mail adress) used for signing
    'Message'        => '...'       # descriptive text containing the result status
    'MessageLong'    => '...'       # full output of GPG binary

=cut

sub Verify {
    my ( $Self, %Param ) = @_;

    my %Return;

    # check needed stuff
    if ( !$Param{Message} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Message!" );
        return;
    }

    my ( $FH, $File ) = $Self->{FileTempObject}->TempFile();
    binmode($FH);
    print $FH $Param{Message};
    close $FH;

    my $GPGOptions = "--verify";
    if ( $Param{Sign} ) {
        my ( $FHSign, $FilenameSign ) = $Self->{FileTempObject}->TempFile();
        binmode($FHSign);
        print $FHSign $Param{Sign};
        close $FHSign;
        $GPGOptions .= " $FilenameSign";
    }
    my $Message = qx{$Self->{GPGBin} $GPGOptions $File 2>&1};
    if ( $Message =~ m{(Good signature from ".+?")}i ) {
        my $GPGMessage = $1;
        my $KeyID      = '';
        if ( $Message =~ m{\s+ID\s+([0-9A-F]{8})}i ) {
            $KeyID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Unable to fetch key-ID from gpg output!"
            );
        }
        my $KeyUserID = '';
        if ( $Message =~ m{Good signature from "(.+?)"}i ) {
            $KeyUserID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Unable to fetch key-user-ID from gpg output!"
            );
        }
        %Return = (
            SignatureFound => 1,
            Successful     => 1,
            Message        => "gpg: $GPGMessage",
            MessageLong    => $Message,
            KeyID          => $KeyID,
            KeyUserID      => $KeyUserID,
        );
    }
    else {
        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => $Message,
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
    my ( $Self, %Param ) = @_;

    my @Result;
    push( @Result, $Self->PublicKeySearch(%Param) );
    push( @Result, $Self->PrivateKeySearch(%Param) );

    return @Result;
}

=item PrivateKeySearch()

returns an array with search result (private keys)

    my @Keys = $CryptObject->PrivateKeySearch(
        Search => 'something to search'
    );

=cut

sub PrivateKeySearch {
    my ( $Self, %Param ) = @_;

    my $Search         = $Param{Search} || '';
    my $GPGOptions     = "--list-secret-keys --with-fingerprint --with-colons $Search";
    my @GPGOutputLines = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    return $Self->_ParseGPGKeyList( GPGOutputLines => \@GPGOutputLines );
}

=item PublicKeySearch()

returns an array with search result (public keys)

    my @Keys = $CryptObject->PublicKeySearch(
        Search => 'something to search'
    );

=cut

sub PublicKeySearch {
    my ( $Self, %Param ) = @_;

    my $Search         = $Param{Search} || '';
    my $GPGOptions     = "--list-keys --with-fingerprint --with-colons $Search";
    my @GPGOutputLines = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    return $Self->_ParseGPGKeyList( GPGOutputLines => \@GPGOutputLines );
}

=item _ParseGPGKeyList()

parses given key list (as received from gpg) and returns an array with key infos

=cut

sub _ParseGPGKeyList {
    my ( $Self, %Param ) = @_;

    my %Key;
    my $InKey;
    my @Result;
    LINE:
    for my $Line ( @{ $Param{GPGOutputLines} } ) {

        # The option '--with-colons' causes gpg to output a machine-parsable format where the
        # individual fields are separated by a colon (':') - for a detailed description,
        # see the file doc/DETAILS in the gpg source distribution.
        my @Fields = split ':', $Line;
        my $Type = $Fields[0];

        # 'sec' or 'pub' indicate the start of a info block for a specific key
        if ( $Type eq 'sec' || $Type eq 'pub' ) {

            # push last key and restart with empty key info
            if (%Key) {
                push( @Result, {%Key} );
                %Key = ();
            }
            $InKey     = 1;
            $Key{Type} = $Type;
            $Key{Bit}  = $Fields[2];
            $Key{Key} = substr( $Fields[4], -8, 8 );    # only use last 8 chars of key-ID
                                                        # in order to be compatible with
                                                        # previous parser
            $Key{Created}          = $Fields[5];
            $Key{Expires}          = $Fields[6];
            $Key{Identifier}       = $Fields[9];
            $Key{IdentifierMaster} = $Fields[9];
        }

        # skip anything before we've seen the first key
        next LINE if !$InKey;

        # add any additional info to the current key
        if ( $Type eq 'uid' ) {
            $Key{Identifier} .= ', ' . $Fields[9];
        }
        elsif ( $Type eq 'ssb' ) {
            $Key{Bit} = $Fields[2];

            # only use last 8 chars of key-ID in order to be compatible with previous parser
            $Key{Key}     = substr( $Fields[4], -8, 8 );
            $Key{Created} = $Fields[5];
        }
        elsif ( $Type eq 'sub' ) {

            # only use last 8 chars of key-ID in order to be compatible with previous parser
            $Key{KeyPrivate} = substr( $Fields[4], -8, 8 );
        }
        elsif ( $Type eq 'fpr' ) {
            $Key{FingerprintShort} = $Fields[9];

            # add fingerprint in standard format, too
            if (
                $Fields[9] =~ m{
                (\w\w\w\w)(\w\w\w\w)(\w\w\w\w)(\w\w\w\w)(\w\w\w\w)
                (\w\w\w\w)(\w\w\w\w)(\w\w\w\w)(\w\w\w\w)(\w\w\w\w)
            }x
                )
            {
                $Key{Fingerprint} = "$1 $2 $3 $4 $5  $6 $7 $8 $9 $10";
            }
        }
    }
    push( @Result, {%Key} ) if (%Key);

    return @Result;
}

=item PublicKeyGet()

returns public key in ascii

    my $Key = $CryptObject->PublicKeyGet(
        Key => $KeyID,
    );

=cut

sub PublicKeyGet {
    my ( $Self, %Param ) = @_;

    my $Key = quotemeta( $Param{Key} || '' );
    my $KeyString = qx{$Self->{GPGBin} --export --armor $Key 2>&1};

    if ( $KeyString =~ /nothing exported/i ) {
        $KeyString =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't export key: $KeyString!",
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
    my ( $Self, %Param ) = @_;

    my $Key = quotemeta( $Param{Key} || '' );
    my $KeyString = qx{$Self->{GPGBin} --export-secret-keys --armor $Key 2>&1};

    if ( $KeyString =~ /nothing exported/i ) {
        $KeyString =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't export key: $KeyString!",
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
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Key} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Key!",
        );
        return;
    }

    my $Key = quotemeta( $Param{Key} || '' );
    my $LogMessage = qx{$Self->{GPGBin} --delete-key $Key 2>&1};

    if ($LogMessage) {
        $LogMessage =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete key: $LogMessage!",
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
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Key} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Key!",
        );
        return;
    }

    my @Keys = $Self->PrivateKeySearch( Search => $Param{Key} );
    if ( @Keys > 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete key, multiple key for $Param{Key}!",
        );
        return;
    }
    if ( !$Keys[0]->{FingerprintShort} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete key, found no fingerprint for $Param{Key}!",
        );
        return;
    }
    my $GPGOptions = '--delete-secret-key ' . quotemeta( $Keys[0]->{FingerprintShort} );
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    if ($LogMessage) {
        $LogMessage =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete private key: $LogMessage!",
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
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Key} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need Key!",
        );
        return;
    }
    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Key};
    close $FH;
    my $GPGOptions = "--import $Filename";
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions 2>&1};
    if ( $LogMessage =~ /failed/i ) {
        $LogMessage =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't add key: $LogMessage!",
        );
        return;
    }
    return $LogMessage;
}

sub _CryptedWithKey {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{File} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need File!" );
        return;
    }

    # This is a bit tricky: all we actually want is the list of keys that this message has been
    # encrypted for, but gpg does not seem to offer a way to just get these.
    # So we simply try to decrypt with an incorrect passphrase, which of course fails, but still
    # gives us the listing of the keys that we want ...
    # N.B.: if anyone knows how to get that info without resorting to such tricks - please tell!
    my ( $FHPhrase, $FilePhrase ) = $Self->{FileTempObject}->TempFile();
    print $FHPhrase '_no_this_is_not_the_@correct@_passphrase_';
    close $FHPhrase;
    my $GPGOptions
        = qq{--batch --passphrase-fd 0 --always-trust --yes --decrypt $Param{File}};
    my @GPGOutputLines = qx{$Self->{GPGBin} $GPGOptions <$FilePhrase 2>&1};

    my @Keys;
    for my $Line (@GPGOutputLines) {
        if ( $Line =~ m{\sID\s([0-9A-F]{8})}i ) {
            my $KeyID = $1;
            my @Result = $Self->PrivateKeySearch( Search => $KeyID );
            if (@Result) {
                push( @Keys, ( $Result[-1]->{Key} || $KeyID ) );
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
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.28 $ $Date: 2009-01-12 12:57:07 $

=cut
