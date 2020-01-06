# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Crypt::PGP;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::CheckItem',
    'Kernel::System::Encode',
    'Kernel::System::FileTemp',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::Crypt::PGP - pgp crypt backend lib

=head1 DESCRIPTION

This is a sub module of Kernel::System::Crypt and contains all pgp functions.

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check if module is enabled
    return 0 if !$Kernel::OM->Get('Kernel::Config')->Get('PGP');

    # call init()
    $Self->_Init();

    # check working ENV
    return 0 if $Self->Check();

    return $Self;
}

=head2 Check()

check if environment is working

    my $Message = $CryptObject->Check();

=cut

sub Check {
    my ( $Self, %Param ) = @_;

    my $GPGBin = $Kernel::OM->Get('Kernel::Config')->Get('PGP::Bin') || '/usr/bin/gpg';
    if ( !-e $GPGBin ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such $GPGBin!",
        );
        return "No such $GPGBin!";
    }
    elsif ( !-x $GPGBin ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$GPGBin not executable!",
        );
        return "$GPGBin not executable!";
    }

    return;
}

=head2 Crypt()

crypt a message

    my $Message = $CryptObject->Crypt(
        Message => $Message,
        Key     => [
            $PGPPublicKeyID,
            $PGPPublicKeyID2,
            # ...
        ],
    );

    my $Message = $CryptObject->Crypt(
        Message => $Message,
        Key     => $PGPPublicKeyID,
    );

=cut

sub Crypt {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw( Message Key )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my @PublicKeys;
    if ( ref $Param{Key} eq 'ARRAY' ) {
        for my $Key ( @{ $Param{Key} } ) {
            my $QuotedKey = $Self->_QuoteShellArgument($Key);
            push @PublicKeys, $QuotedKey;
        }
    }
    elsif ( ref $Param{Key} eq '' ) {
        my $QuotedKey = $Self->_QuoteShellArgument( $Param{Key} );
        push @PublicKeys, $QuotedKey;
    }

    if ( !@PublicKeys ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "Got no keys!",
            Priority => 'error',
        );
        return;
    }

    my $KeyStr = join ' ', map {"-r $_"} @PublicKeys;

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Message} );

    # get temp file object
    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

    my ( $FH, $Filename ) = $FileTempObject->TempFile();
    print $FH $Param{Message};
    close $FH;

    my ( $FHCrypt, $FilenameCrypt ) = $FileTempObject->TempFile();
    close $FHCrypt;
    my $GPGOptions = "--always-trust --yes --encrypt --armor -o $FilenameCrypt $KeyStr $Filename";
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    # get crypted content
    my $CryptedDataRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead( Location => $FilenameCrypt );

    return $$CryptedDataRef;
}

=head2 Decrypt()

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

    for (qw(Message)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my ( $FH, $Filename ) = $Kernel::OM->Get('Kernel::System::FileTemp')->TempFile();
    print $FH $Param{Message};
    close $FH;

    my %PasswordHash = %{ $Kernel::OM->Get('Kernel::Config')->Get('PGP::Key::Password') };
    my @Keys         = $Self->_CryptedWithKey( File => $Filename );
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

=head2 Sign()

sign a message

    my $Sign = $CryptObject->Sign(
        Message => $Message,
        Key     => $PGPPrivateKeyID,
        Type    => 'Detached'  # Detached|Inline
    );

=cut

sub Sign {
    my ( $Self, %Param ) = @_;

    for (qw(Message Key)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    my %PasswordHash = %{ $Kernel::OM->Get('Kernel::Config')->Get('PGP::Key::Password') };
    my $Pw           = $PasswordHash{ $Param{Key} } || '';
    my $SigType      = $Param{Type} && $Param{Type} eq 'Detached'
        ? '--detach-sign --armor'
        : '--clearsign';
    my $DigestAlgorithm = $Kernel::OM->Get('Kernel::Config')->Get('PGP::Options::DigestPreference') || '';
    if ($DigestAlgorithm) {
        $DigestAlgorithm = '--personal-digest-preferences ' . uc $DigestAlgorithm;
    }

    # get temp file object
    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

    # create tmp files
    my ( $FH, $Filename ) = $FileTempObject->TempFile();
    close $FH;
    my ( $FHSign, $FileSign ) = $FileTempObject->TempFile();
    close $FHSign;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    $MainObject->FileWrite(
        Location => $Filename,
        Content  => \$Param{Message},
        Mode     => $Param{Charset} && $Param{Charset} =~ /utf(8|\-8)/i ? 'utf8' : 'binmode',
    );

    my ( $FHPhrase, $FilePhrase ) = $FileTempObject->TempFile();
    print $FHPhrase $Pw;
    close $FHPhrase;

    # Quote the key parameter before passing it to the shell.
    my $QuotedKey = $Self->_QuoteShellArgument( $Param{Key} );

    my $Quiet = '';

    # GnuPG 2.1 (and higher) may send info messages about used default keys to STDERR, which leads to problems.
    if (
        IsHashRefWithData( $Self->{Version} )
        && sprintf( "%.3d%.3d", $Self->{Version}->{Major}, $Self->{Version}->{Minor} ) >= 2_001
        )
    {
        $Quiet = '--quiet --batch --pinentry-mode=loopback';
    }

    my $GPGOptions
        = qq{$Quiet --passphrase-fd 0 -o $FileSign --default-key $QuotedKey $SigType $DigestAlgorithm $Filename};
    my $LogMessage = qx{$Self->{GPGBin} $GPGOptions < $FilePhrase 2>&1};

    # error
    if ($LogMessage) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't sign with Key $Param{Key}: $LogMessage!"
        );
        return;
    }

    # get signed content
    my $SignedDataRef = $MainObject->FileRead(
        Location => $FileSign,
        Mode     => $Param{Charset} && $Param{Charset} =~ /utf(8|\-8)/i ? 'utf8' : 'binmode',
    );
    return $$SignedDataRef;
}

=head2 Verify()

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

    if ( !$Param{Message} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Message!'
        );
        return;
    }

    # check if original mail was encoded as UTF8, UTF-8, utf8 or utf-8
    if ( defined $Param{Charset} && $Param{Charset} =~ m{ utf -?? 8 }imsx ) {

        # encode the message to be written into the FS
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Message} );
    }

    # get temp file object
    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

    my ( $FH, $File ) = $FileTempObject->TempFile();
    binmode($FH);
    print $FH $Param{Message};
    close $FH;

    my $GPGOptions = '--verify --status-fd 1';
    if ( $Param{Sign} ) {
        my ( $FHSign, $FilenameSign ) = $FileTempObject->TempFile();
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Unable to fetch key-user-ID from gpg output!'
            );
        }

        my $KeyFingerprint   = '';
        my $ValidMessageLong = '';
        if (
            $LogMessage{VALIDSIG}
            && $LogMessage{VALIDSIG}->{MessageLong} =~ m{\Q[GNUPG:] VALIDSIG \E ([0-9A-F]{40}) }xms
            )
        {
            $KeyFingerprint   = $1;
            $ValidMessageLong = $LogMessage{VALIDSIG}->{MessageLong};
        }

        # Include additional key attributes in the message:
        #   - signer email address
        #   - key id
        #   - key fingerprint
        #   Please see bug#12284 for more information.
        %Return = (
            SignatureFound => 1,
            Successful     => 1,
            Message        => $LogMessage{GOODSIG}->{Log} . " ($KeyUserID : $KeyID : $KeyFingerprint)",
            MessageLong    => $LogMessage{GOODSIG}->{MessageLong} . $ValidMessageLong,
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    my $Trusted = $Kernel::OM->Get('Kernel::Config')->Get('PGP::TrustedNetwork');
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

    # looks for text before and after the signature (but ignore if is in quoted text)
    if (
        $Param{Message} =~ m{ \s* \S+ \s* ^ \s* -----BEGIN [ ] PGP [ ] SIGNED [ ] MESSAGE----- }xmsg
        || $Param{Message} =~ m{ ^ \s* -----END [ ] PGP [ ] SIGNATURE----- \s* \S+ \s* }xmsg
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

=head2 KeySearch()

returns a array with search result (private and public keys)

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

=head2 PrivateKeySearch()

returns an array with search result (private keys)

    my @Keys = $CryptObject->PrivateKeySearch(
        Search => 'something to search'
    );

=cut

sub PrivateKeySearch {
    my ( $Self, %Param ) = @_;

    my $Search         = $Self->_QuoteShellArgument( $Param{Search} ) || '';
    my $GPGOptions     = "--list-secret-keys --with-fingerprint --with-colons $Search";
    my @GPGOutputLines = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    return $Self->_ParseGPGKeyList( GPGOutputLines => \@GPGOutputLines );
}

=head2 PublicKeySearch()

returns an array with search result (public keys)

    my @Keys = $CryptObject->PublicKeySearch(
        Search => 'something to search'
    );

=cut

sub PublicKeySearch {
    my ( $Self, %Param ) = @_;

    my $Search         = $Self->_QuoteShellArgument( $Param{Search} ) || '';
    my $GPGOptions     = "--list-keys --with-fingerprint --with-colons $Search";
    my @GPGOutputLines = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    return $Self->_ParseGPGKeyList( GPGOutputLines => \@GPGOutputLines );
}

=head2 PublicKeyGet()

returns public key in ascii

    my $Key = $CryptObject->PublicKeyGet(
        Key => $KeyID,
    );

=cut

sub PublicKeyGet {
    my ( $Self, %Param ) = @_;

    my $QuotedKey  = $Self->_QuoteShellArgument( $Param{Key} ) || '';
    my $LogMessage = qx{$Self->{GPGBin} --export --armor $QuotedKey 2>&1};
    my $PublicKey;
    if ( $LogMessage =~ /nothing exported/i ) {
        $LogMessage =~ s/\n//g;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

=head2 SecretKeyGet()

returns secret key in ascii

    my $Key = $CryptObject->SecretKeyGet(
        Key => $KeyID,
    );

=cut

sub SecretKeyGet {
    my ( $Self, %Param ) = @_;

    my $LogMessage = '';

    # GnuPG 2.1 (and higher) asks via pinentry for the key passphrase. We suppress that behavior by passing the phrase
    # via STDIN from temporary file (--passphrase-fd 0 / file descriptor 0).
    if (
        IsHashRefWithData( $Self->{Version} )
        && sprintf( "%.3d%.3d", $Self->{Version}->{Major}, $Self->{Version}->{Minor} ) >= 2_001
        )
    {
        my %PasswordHash = %{ $Kernel::OM->Get('Kernel::Config')->Get('PGP::Key::Password') };
        my $Key          = quotemeta( $Param{Key} || '' );
        my $Password     = $PasswordHash{$Key} || '';

        my ( $FH, $Filename ) = $Kernel::OM->Get('Kernel::System::FileTemp')->TempFile();
        print $FH $Password;
        close $FH;

        $LogMessage
            = qx{$Self->{GPGBin} --batch --pinentry-mode=loopback --export-secret-keys --passphrase-fd 0 --armor --decrypt <$Filename 2>&1};
    }

    # GnuPG 2.0 (and lower)
    else {
        my $QuotedKey = $Self->_QuoteShellArgument( $Param{Key} ) || '';
        $LogMessage = qx{$Self->{GPGBin} --export-secret-keys --armor $QuotedKey 2>&1};
    }

    my $SecretKey = '';

    if ( $LogMessage =~ /nothing exported/i ) {
        $LogMessage =~ s/\n//g;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

=head2 PublicKeyDelete()

remove public key from key ring

    $CryptObject->PublicKeyDelete(
        Key => $KeyID,
    );

=cut

sub PublicKeyDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Key} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Key!',
        );
        return;
    }

    my $QuotedKey  = $Self->_QuoteShellArgument( $Param{Key} ) || '';
    my $GPGOptions = '--status-fd 1';
    my $Message    = qx{$Self->{GPGBin} $GPGOptions --delete-key $QuotedKey 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );

    if ( $LogMessage{DELETE_PROBLEM} ) {
        $LogMessage{CleanLog} =~ s/\n//g;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't delete key: $LogMessage{CleanLog}!",
        );
        return;
    }

    return 1;
}

=head2 SecretKeyDelete()

remove secret key from key ring

    $CryptObject->SecretKeyDelete(
        Key => $KeyID,
    );

=cut

sub SecretKeyDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Key} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Key!',
        );
        return;
    }

    my @Keys = $Self->PrivateKeySearch( Search => $Param{Key} );
    if ( @Keys > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't delete key, multiple key for $Param{Key}!",
        );
        return;
    }
    if ( !$Keys[0]->{FingerprintShort} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't delete key, found no fingerprint for $Param{Key}!",
        );
        return;
    }
    my $GPGOptions = '--status-fd 1 --delete-secret-key ' . quotemeta( $Keys[0]->{FingerprintShort} );
    my $Message    = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );

    # waiting for better solution, some times gpg returns just enviroment warnings and
    # with next code lines is wrong detected like an error
    #    if ($Message) {
    #        $Message =~ s/\n//g;
    #        $Kernel::OM->Get('Kernel::System::Log')->Log(
    #            Priority => 'error',
    #            Message  => "Can't delete private key: $Message!",
    #        );
    #        return;
    #    }

    return 1;
}

=head2 KeyAdd()

add key to key ring

    my $Message = $CryptObject->KeyAdd(
        Key => $KeyString,
    );

=cut

sub KeyAdd {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Key} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Key!',
        );
        return;
    }
    my ( $FH, $Filename ) = $Kernel::OM->Get('Kernel::System::FileTemp')->TempFile();
    print $FH $Param{Key};
    my $GPGOptions = "--status-fd 1 --import $Filename";
    my $Message    = qx{$Self->{GPGBin} $GPGOptions 2>&1};

    my %LogMessage = $Self->_HandleLog( LogString => $Message );

    if ( !$LogMessage{IMPORT_OK} ) {
        $Message =~ s/\n//g;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Self->{GPGBin}  = $ConfigObject->Get('PGP::Bin')     || '/usr/bin/gpg';
    $Self->{Options} = $ConfigObject->Get('PGP::Options') || '--batch --no-tty --yes';

    if ( $^O =~ m/Win/i ) {

        # take care to deal properly with paths containing whitespace
        $Self->{GPGBin} = "\"$Self->{GPGBin}\" $Self->{Options}";
    }
    else {

        # make sure that we are getting POSIX (i.e. english) messages from gpg
        $Self->{GPGBin} = "LC_MESSAGES=POSIX $Self->{GPGBin} $Self->{Options}";
    }

    # determine active GnuPG version
    my $VersionString = '';

    eval {
        $VersionString = `$Self->{GPGBin} --version`;
    };

    if ( $VersionString =~ m{ gpg [ ]+ \(.+?\) [ ]+ (\d+)\.(\d+)\.(\d+) }smx ) {
        $Self->{Version} = {
            Major  => $1,
            Minor  => $2,
            Patch  => $3,
            String => $1 . '.' . $2 . '.' . $3,
        };
    }

    return $Self;
}

sub _DecryptPart {
    my ( $Self, %Param ) = @_;

    for (qw(Key Password Filename)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

    # temp file for decrypted message
    my ( $FHDecrypt, $FileDecrypt ) = $FileTempObject->TempFile();
    close $FHDecrypt;

    # temp file for passphrase
    my ( $FHPhrase, $FilePhrase ) = $FileTempObject->TempFile();
    print $FHPhrase $Param{Password};
    close $FHPhrase;

    # Quote the filename parameter before passing it to the shell.
    my $QuotedFilename = $Self->_QuoteShellArgument( $Param{Filename} );

    my $LogMessage = '';

    # GnuPG 2.1 (and higher)
    if (
        IsHashRefWithData( $Self->{Version} )
        && sprintf( "%.3d%.3d", $Self->{Version}->{Major}, $Self->{Version}->{Minor} ) >= 2_001
        )
    {
        my $GPGOptions
            = qq{--batch --pinentry-mode=loopback --passphrase-fd 0 --armor -o $FileDecrypt --decrypt $QuotedFilename};
        $LogMessage = qx{$Self->{GPGBin} $GPGOptions < $FilePhrase 2>&1};
    }

    # GnuPG 2.0 (and lower)
    else {
        my $GPGOptions = qq{--batch --passphrase-fd 0 --yes --decrypt -o $FileDecrypt $QuotedFilename};
        $LogMessage = qx{$Self->{GPGBin} $GPGOptions <$FilePhrase 2>&1};
    }

    if ( $LogMessage =~ /failed/i ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "$LogMessage!",
        );
        return (
            Successful => 0,
            Message    => $LogMessage,
        );
    }
    else {
        my $DecryptedDataRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead( Location => $FileDecrypt );
        return (
            Successful => 1,
            Message    => $LogMessage,
            Data       => $$DecryptedDataRef,
            KeyID      => $Param{Key},
        );
    }
}

=head2 _HandleLog()

Clean and build the log

    my %Log = $PGPObject->_HandleLog(
        LogString => $LogMessage,
    );

=cut

sub _HandleLog {
    my ( $Self, %Param ) = @_;

    for (qw(LogString)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
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
    my $LogDictionary = $Kernel::OM->Get('Kernel::Config')->Get('PGP::Log');

    my %ComputableLog;
    for my $Line (@ComputableLines) {

        # get tag
        $Line =~ m{(:?\[GNUPG\:\]\s)(\w*)(:?\s.*)?}xms;
        my $Tag     = $2;
        my $Message = $Line;

        $ComputableLog{$Tag} = {
            Log         => $LogDictionary->{$Tag} || $Line,
            MessageLong => $Line                  || $LogDictionary->{$Tag},
        };
    }

    # get clean log lines
    my $CleanLog = '';
    while ( $Param{LogString} =~ m{(gpg\:\s.*)}g ) {
        $CleanLog .= ' ' . $1;
    }

    $ComputableLog{CleanLog} = $CleanLog;

    return %ComputableLog;
}

=head2 _ParseGPGKeyList()

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
        my $Type   = $Fields[0];

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
            $Key{Key}              = substr( $Fields[4], -8, 8 );    # only use last 8 chars of key-ID
                                                                     # in order to be compatible with
                                                                     # previous parser
            $Key{Created}          = $Fields[5];
            $Key{Expires}          = $Fields[6] || 'never';
            $Key{Identifier}       = $Fields[9];
            $Key{IdentifierMaster} = $Fields[9];

            if ( $Key{Expires} eq 'never' || $Key{Status} ne 'good' ) {
                next LINE;
            }

            # Status is good, but let's make sure the key isn't expired.
            my $CurSysDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

            # GnuPG 2.0 (and higher) Key Expires date is in epoch format. Appropriately modify DateTime params.
            my %DateTimeParams = (
                String => $Key{Expires} . ' 23:59:59',
            );

            if (
                IsHashRefWithData( $Self->{Version} )
                && sprintf( "%.3d%.3d", $Self->{Version}->{Major}, $Self->{Version}->{Minor} ) >= 2_000
                )
            {
                %DateTimeParams = (
                    Epoch => $Key{Expires},
                );
            }

            my $ExpiresKeyDTObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    %DateTimeParams,
                },
            );

            if ( $CurSysDTObject >= $ExpiresKeyDTObject ) {
                $Key{Status} = 'expired';
            }
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
            $Key{Key}     = substr( $Fields[4], -8, 8 );
            $Key{Created} = $Fields[5];
        }
        elsif ( $Type eq 'sub' ) {

            # only use last 8 chars of key-ID in order to be compatible with previous parser
            $Key{KeyPrivate} = substr( $Fields[4], -8, 8 );
        }

        # The public and secret key information will be exposed at first. Since GnugPG 2 (and higher)
        # the sub-key fingerprint will be displayed as well (--list-keys --with-colons), which leads
        # to overwriting of the main information. Therefore we just collect the first fingerprint.
        elsif ( $Type eq 'fpr' && !$Key{Fingerprint} && !$Key{Fingerprint} ) {
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
        my $Epoch2YMD = sub {
            return $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Epoch => shift,
                },
            )->Format( Format => '%Y-%m-%d' );
        };

        if ( $Key{Created} !~ /-/ ) {
            $Key{Created} = $Epoch2YMD->( $Key{Created} );
        }

        # expires
        if ( $Key{Expires} =~ /^\d*$/ ) {
            $Key{Expires} = $Epoch2YMD->( $Key{Expires} );
        }
    }

    if (%Key) {
        push( @Result, \%Key );
    }

    return @Result;
}

sub _CryptedWithKey {
    my ( $Self, %Param ) = @_;

    if ( !$Param{File} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need File!"
        );
        return;
    }

    # Quote the file parameter before passing it to the shell.
    my $QuotedFile = $Self->_QuoteShellArgument( $Param{File} );

    # This is a bit tricky: all we actually want is the list of keys that this message has been
    # encrypted for, but gpg does not seem to offer a way to just get these.
    # So we simply try to decrypt with an incorrect passphrase, which of course fails, but still
    # gives us the listing of the keys that we want ...
    # N.B.: if anyone knows how to get that info without resorting to such tricks - please tell!
    my ( $FHPhrase, $FilePhrase ) = $Kernel::OM->Get('Kernel::System::FileTemp')->TempFile();
    print $FHPhrase '_no_this_is_not_the_@correct@_passphrase_';
    close $FHPhrase;
    my $GPGOptions     = qq{--batch --passphrase-fd 0 --always-trust --yes --decrypt $QuotedFile};
    my @GPGOutputLines = qx{$Self->{GPGBin} $GPGOptions <$FilePhrase 2>&1};

    my @Keys;
    for my $Line (@GPGOutputLines) {
        if ( $Line =~ m{\sID\s((0x)?([0-9A-F]{8}){1,2})}i ) {
            my $KeyID  = $1;
            my @Result = $Self->PrivateKeySearch( Search => $KeyID );
            if (@Result) {
                push( @Keys, ( $Result[-1]->{Key} || $KeyID ) );
            }
        }
    }

    return @Keys;
}

=head2 _QuoteShellArgument()

Quote passed string to be safe to use as a shell argument.

    my $Result = $Self->_QuoteShellArgument(
        "Safe string for 'shell arguments'."   # string to quote
    );

Returns quoted string if supplied or undef otherwise:

    $Result = <<'EOS';
'Safe string for '"'"'shell arguments'"'"'.'
EOS

=cut

sub _QuoteShellArgument {
    my ( $Self, $String ) = @_;

    # Only continue with quoting if we received a valid string.
    if ( IsStringWithData($String) ) {

        # Encase any single quotes in double quotes, and glue them together with single quotes.
        #   Please see https://stackoverflow.com/a/1250279 for more information.
        $String =~ s/'/'"'"'/g;

        # Enclose the string in single quotes.
        return "'$String'";
    }

    return;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
