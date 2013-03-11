# --
# Kernel/System/Crypt/PGP.pm - the main crypt module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Crypt::PGP;

use strict;
use warnings;

use vars qw($VERSION);

=head1 NAME

Kernel::System::Crypt::PGP - pgp crypt backend lib

=head1 SYNOPSIS

This is a sub module of Kernel::System::Crypt and contains all pgp functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

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
        Key     => $PGPPublicKeyID,
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
    #    if ( utf8::is_utf8( $Param{Message} ) ) {
    #        utf8::encode( $Param{Message} );
    #    }
    $Self->{EncodeObject}->EncodeOutput( \$Param{Message} );

    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Message};
    close $FH;

    my ( $FHCrypt, $FilenameCrypt ) = $Self->{FileTempObject}->TempFile();
    close $FHCrypt;
    my $GPGOptions
        = "--always-trust --yes --encrypt --armor -o $FilenameCrypt -r $Param{Key} $Filename";
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions 2>&1};

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

    Successful => '1',        # could the given data be decrypted at all (0 or 1)
    Data       => '...',      # the decrypted data
    KeyID      => 'FA23FB24'  # hex ID of PGP-(secret-)key that was used for decryption
    Message    => '...'       # descriptive text containing the result status

=cut

sub Decrypt {
    my ( $Self, %Param ) = @_;

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
    my %Return;

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
            Message    => 'gpg: No private key found to decrypt this message!',
        );
    }
    return %Return;
}

=item Sign()

sign a message

    my $Sign = $CryptObject->Sign(
        Message => $Message,
        Key     => $PGPPrivateKeyID,
        Type    => 'Detached'  # Detached|Inline
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
        Charset => 'utf-8',             # optional, 'ISO-8859-1', 'UTF-8', etc.
    );

Attached sign:

    my %Result = $CryptObject->Verify(
        Message => $Message,
        Sign    => $Sign,
    );

The returned hash %Result has the following keys:

    SignatureFound => 1,                          # was a signature found at all (0 or 1)
    Successful     => 1,                          # could the signature be verified (0 or 1)
    KeyID          => 'FA23FB24'                  # hex ID of PGP-key that was used for signing
    KeyUserID      => 'username <user@test.org>'  # PGP-User-ID (e-mail address) used for signing
    Message        => '...'                       # descriptive text containing the result status
    MessageLong    => '...'                       # full output of GPG binary

=cut

sub Verify {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Message} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Message!' );
        return;
    }

    # check if original mail was encoded as UTF8, UTF-8, utf8 or utf-8
    if ( defined $Param{Charset} && $Param{Charset} =~ m{ utf -?? 8 }imsx ) {

        # encode the message to be written into the FS
        $Self->{EncodeObject}->EncodeOutput( \$Param{Message} );
    }

    my ( $FH, $File ) = $Self->{FileTempObject}->TempFile();
    binmode($FH);
    print $FH $Param{Message};
    close $FH;

    my $GPGOptions = '--verify --status-fd 1';
    if ( $Param{Sign} ) {
        my ( $FHSign, $FilenameSign ) = $Self->{FileTempObject}->TempFile();
        binmode($FHSign);
        print $FHSign $Param{Sign};
        close $FHSign;
        $GPGOptions .= " $FilenameSign";
    }

    my %Return;
    my $Message = qx{$Self->{GPGBin} $GPGOptions $File 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );
    if ( $LogMessage{GOODSIG} ) {
        my $KeyID = '';

        if (
            $LogMessage{GOODSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] GOODSIG \E (?: [0-9A-F]{8}) ([0-9A-F]{8}) }xms
            )
        {
            $KeyID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-ID from gpg output!'
            );
        }

        my $KeyUserID = '';
        if (
            $LogMessage{GOODSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] GOODSIG \E (?:[0-9A-F]{16}) \s (.*) }xms
            )
        {
            $KeyUserID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-user-ID from gpg output!'
            );
        }

        %Return = (
            SignatureFound => 1,
            Successful     => 1,
            Message        => $LogMessage{GOODSIG}->{Log} . " : $KeyID $KeyUserID",
            MessageLong    => $LogMessage{GOODSIG}->{MessageLong},
            KeyID          => $KeyID,
            KeyUserID      => $KeyUserID,
        );

    }
    elsif ( $LogMessage{ERRSIG} ) {
        my $KeyID = '';

        # key id
        if (
            $LogMessage{ERRSIG}->{MessageLong}
            =~ m{ \Q[GNUPG:] ERRSIG \E (?:[0-9A-F]{8}) ([0-9A-F]{8}) }xms
            )
        {
            $KeyID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-ID from gpg output!'
            );
        }

        my $InternalMessage;
        if ( $LogMessage{NO_PUBKEY}->{Log} ) {
            $InternalMessage = $LogMessage{NO_PUBKEY}->{Log} . ": $KeyID";
        }

        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => $InternalMessage || $LogMessage{ERRSIG}->{Log},
        );

    }
    elsif ( $LogMessage{KEYREVOKED} && $LogMessage{EXPKEYSIG} ) {

        # revoked has the preference but also expired can be shown, is it?
        my $KeyID;
        if (
            $LogMessage{EXPKEYSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] EXPKEYSIG \E (?:[0-9A-F]{8}) ([0-9A-F]{8})}xms
            )
        {
            $KeyID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-ID from gpg output!'
            );
        }

        my $KeyUserID = '';
        if (
            $LogMessage{EXPKEYSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] EXPKEYSIG \E (?:[0-9A-F]{16}) \s (.*) }xms
            )
        {
            $KeyUserID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-user-ID from gpg output!'
            );
        }

        my $ComposedMessage = '';
        if ( $LogMessage{KEYREVOKED}->{Log} ) {
            $ComposedMessage = $LogMessage{KEYREVOKED}->{Log}
                . " and the key is also expired. : $KeyID $KeyUserID";
        }

        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => $ComposedMessage || $Message,
        );
    }
    elsif ( $LogMessage{REVKEYSIG} ) {

        my $KeyID;
        if (
            $LogMessage{REVKEYSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] REVKEYSIG \E (?:[0-9A-F]{8}) ([0-9A-F]{8}) }xms
            )
        {
            $KeyID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-ID from gpg output!'
            );
        }

        my $KeyUserID = '';
        if (
            $LogMessage{REVKEYSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] REVKEYSIG \E (?:[0-9A-F]{16}) \s (.*) }xms
            )
        {
            $KeyUserID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-user-ID from gpg output!'
            );
        }

        my $ComposedMessage = '';
        if ( $LogMessage{REVKEYSIG}->{Log} ) {
            $ComposedMessage = $LogMessage{REVKEYSIG}->{Log} . ": $KeyID $KeyUserID";
        }

        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => $ComposedMessage || $Message,
        );

    }
    elsif ( $LogMessage{EXPKEYSIG} ) {

        my $KeyID;
        if (
            $LogMessage{EXPKEYSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] EXPKEYSIG \E (?:[0-9A-F]{8}) ([0-9A-F]{8}) }xms
            )
        {
            $KeyID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-ID from gpg output!'
            );
        }

        my $KeyUserID = '';
        if (
            $LogMessage{EXPKEYSIG}->{MessageLong}
            =~ m{\Q[GNUPG:] EXPKEYSIG \E (?:[0-9A-F]{16}) \s (.*) }xms
            )
        {
            $KeyUserID = $1;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-user-ID from gpg output!'
            );
        }

        my $ComposedMessage = '';
        if ( $LogMessage{EXPKEYSIG}->{Log} ) {
            $ComposedMessage = $LogMessage{EXPKEYSIG}->{Log} . ": $KeyID $KeyUserID";
        }
        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => ($ComposedMessage) || $Message,
        );

    }
    elsif ( $LogMessage{NODATA} ) {
        %Return = (
            SignatureFound => 0,
            Successful     => 0,
            Message        => $LogMessage{NODATA}->{Log} || $Message,
        );
    }
    else {
        %Return = (
            SignatureFound => 1,
            Successful     => 0,
            Message        => $LogMessage{CleanLog} || $Message,
        );
    }

    my @WarningTags;

    my $Trusted = $Self->{ConfigObject}->Get('PGP::TrustedNetwork');
    if ( !$Trusted ) {
        push @WarningTags, 'TRUST_UNDEFINED';
    }

    # get needed warnings
    my @Warnings;
    for my $Tag (@WarningTags) {
        if ( $LogMessage{$Tag}->{Log} ) {
            push @Warnings, {
                Result => 'Error',
                Key    => 'Sign Warning',
                Value  => $LogMessage{$Tag}->{Log},
            };
        }
    }

    # looks for text before and after the signature
    if (
        $Param{Message} =~ m{ \s* \S+ \s* \Q-----BEGIN PGP SIGNED MESSAGE-----\E }xmsg
        ||
        $Param{Message} =~ m{ \Q-----END PGP SIGNATURE-----\E \s* \S+ \s* }xmsg
        )
    {
        push @Warnings, {
            Result => 'Error',
            Key    => 'Sign Warning',
            Value =>
                'Just a part of the message is signed, for info please see \'Plain Format\' view of article.',
        };
    }

    if ( scalar @Warnings ) {
        $Return{Warnings} = \@Warnings;
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
    push @Result, $Self->PublicKeySearch(%Param);
    push @Result, $Self->PrivateKeySearch(%Param);

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

=item PublicKeyGet()

returns public key in ascii

    my $Key = $CryptObject->PublicKeyGet(
        Key => $KeyID,
    );

=cut

sub PublicKeyGet {
    my ( $Self, %Param ) = @_;

    my $Key = quotemeta( $Param{Key} || '' );
    my $LogMessage = qx{$Self->{GPGBin} --export --armor $Key 2>&1};
    my $PublicKey;
    if ( $LogMessage =~ /nothing exported/i ) {
        $LogMessage =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't export key: $LogMessage!",
        );
        return;
    }
    elsif ( $LogMessage =~ /-----BEGIN PGP PUBLIC KEY BLOCK-----/i ) {

        # filter the key
        $PublicKey = $LogMessage;

        # delete text before
        $PublicKey =~ s{
            .* ( \Q-----BEGIN PGP PUBLIC KEY BLOCK-----\E .*
                 \Q-----END PGP PUBLIC KEY BLOCK-----\E ) .*
        }{$1}xmsg;

        return $PublicKey;
    }

    return $LogMessage;
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

    my $LogMessage = qx{$Self->{GPGBin} --export-secret-keys --armor $Key 2>&1};
    my $SecretKey  = '';

    if ( $LogMessage =~ /nothing exported/i ) {
        $LogMessage =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't export key: $LogMessage!",
        );
        return;
    }
    elsif ( $LogMessage =~ /-----BEGIN PGP PRIVATE KEY BLOCK-----/i ) {

        # filter the key
        $SecretKey = $LogMessage;
        $SecretKey =~ s{
            .* ( \Q-----BEGIN PGP PRIVATE KEY BLOCK-----\E .*
                 \Q-----END PGP PRIVATE KEY BLOCK-----\E ) .*
        }{$1}xmsg;

        return $SecretKey;
    }

    return $LogMessage;
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
            Message  => 'Need Key!',
        );
        return;
    }

    my $Key        = quotemeta( $Param{Key} || '' );
    my $GPGOptions = '--status-fd 1';
    my $Message    = qx{$Self->{GPGBin} $GPGOptions --delete-key $Key 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );

    if ( $LogMessage{DELETE_PROBLEM} ) {
        $LogMessage{CleanLog} =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete key: $LogMessage{CleanLog}!",
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
            Message  => 'Need Key!',
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
    my $GPGOptions
        = '--status-fd 1 --delete-secret-key ' . quotemeta( $Keys[0]->{FingerprintShort} );
    my $Message = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );

    # waiting for better solution, some times gpg returns just enviroment warnings and
    # with next code lines is wrong detected like an error
    #    if ($Message) {
    #        $Message =~ s/\n//g;
    #        $Self->{LogObject}->Log(
    #            Priority => 'error',
    #            Message  => "Can't delete private key: $Message!",
    #        );
    #        return;
    #    }

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
            Message  => 'Need Key!',
        );
        return;
    }
    my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
    print $FH $Param{Key};
    my $GPGOptions = "--status-fd 1 --import $Filename";
    my $Message    = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );

    if ( !$LogMessage{IMPORT_OK} ) {
        $Message =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't add key: $LogMessage{CleanLog}!",
        );
        return;
    }

    return $LogMessage{CleanLog};
}

=begin Internal:

=cut

sub _Init {
    my ( $Self, %Param ) = @_;

    $Self->{GPGBin}  = $Self->{ConfigObject}->Get('PGP::Bin')     || '/usr/bin/gpg';
    $Self->{Options} = $Self->{ConfigObject}->Get('PGP::Options') || '--batch --no-tty --yes';

    if ( $^O =~ m/Win/i ) {

        # take care to deal properly with paths containing whitespace
        $Self->{GPGBin} = "\"$Self->{GPGBin}\" $Self->{Options}";
    }
    else {

        # make sure that we are getting POSIX (i.e. english) messages from gpg
        $Self->{GPGBin} = "LC_MESSAGES=POSIX $Self->{GPGBin} $Self->{Options}";
    }

    return $Self;
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
        = qq{--batch --passphrase-fd 0 --yes --decrypt -o $FileDecrypt $Param{Filename}};
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions <$FilePhrase 2>&1};
    if ( $LogMessage =~ /failed/i ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "$LogMessage!",
        );
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

=item _HandleLog()

Clean and build the log

    my %Log = $PGPObject->_HandleLog(
        LogString => $LogMessage,
    );

=cut

sub _HandleLog {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LogString)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Log;
    $Log{OriginalLog} = $Param{LogString};

    # get computable log lines
    my @ComputableLines;
    while ( $Log{OriginalLog} =~ m{(\[GNUPG\:\]\s.*)}g ) {
        push @ComputableLines, $1;
    }

    # get the hash of messages
    my $LogDictionary = $Self->{ConfigObject}->Get('PGP::Log');

    my %ComputableLog;
    for my $Line (@ComputableLines) {

        # get tag
        $Line =~ m{(:?\[GNUPG\:\]\s)(\w*)(:?\s.*)?}xms;
        my $Tag     = $2;
        my $Message = $Line;

        $ComputableLog{$Tag} = {
            Log => $LogDictionary->{$Tag} || $Line,
            MessageLong => $Line || $LogDictionary->{$Tag},
            }
    }

    # get clean log lines
    my $CleanLog = '';
    while ( $Param{LogString} =~ m{(gpg\:\s.*)}g ) {
        $CleanLog .= ' ' . $1;
    }

    $ComputableLog{CleanLog} = $CleanLog;

    return %ComputableLog;
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
            $InKey = 1;
            $Key{Type} = $Type;

            # is the key expired, revoked or good?
            if ( $Fields[1] eq 'e' ) {
                $Key{Status} = 'expired';
            }
            elsif ( $Fields[1] eq 'r' ) {
                $Key{Status} = 'revoked';
            }
            else {
                $Key{Status} = 'good';
            }

            $Key{Bit}              = $Fields[2];
            $Key{Key}              = substr( $Fields[4], -8, 8 );  # only use last 8 chars of key-ID
                                                                   # in order to be compatible with
                                                                   # previous parser
            $Key{Created}          = $Fields[5];
            $Key{Expires}          = $Fields[6] || 'never';
            $Key{Identifier}       = $Fields[9];
            $Key{IdentifierMaster} = $Fields[9];
        }

        # skip anything before we've seen the first key
        next LINE if !$InKey;

        # add any additional info to the current key
        if ( $Type eq 'uid' ) {
            if ( $Key{Identifier} ) {
                $Key{Identifier} .= ', ' . $Fields[9];
            }
            else {
                $Key{Identifier} .= $Fields[9];
            }
        }
        elsif ( $Type eq 'ssb' ) {
            $Key{Bit} = $Fields[2];

            # only use last 8 chars of key-ID in order to be compatible with previous parser
            $Key{Key} = substr( $Fields[4], -8, 8 );
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

        # convert system time to timestamp
        if ( $Key{Created} !~ /-/ ) {
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay )
                = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Key{Created},
                );
            $Key{Created} = "$Year-$Month-$Day";
        }

        # expires
        if ( $Key{Expires} =~ /^\d*$/ ) {
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay )
                = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Key{Expires},
                );
            $Key{Expires} = "$Year-$Month-$Day";
        }
    }
    push( @Result, {%Key} ) if (%Key);

    return @Result;
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

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
