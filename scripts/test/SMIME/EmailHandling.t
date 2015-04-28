# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Output::HTML::ArticleCheckSMIME;

# get needed objects
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

my $HomeDir     = $ConfigObject->Get('Home');
my $CertPath    = $ConfigObject->Get('SMIME::CertPath');
my $PrivatePath = $ConfigObject->Get('SMIME::PrivatePath');

my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');

# get the openssl version string, e.g. OpenSSL 0.9.8e 23 Feb 2007
my $OpenSSLVersionString = qx{$OpenSSLBin version};
my $OpenSSLMajorVersion;

# get the openssl major version, e.g. 1 for version 1.0.0
if ( $OpenSSLVersionString =~ m{ \A (?: OpenSSL )? \s* ( \d )  }xmsi ) {
    $OpenSSLMajorVersion = $1;
}

# openssl version 1.0.0 uses different hash algorithm... in the future release of openssl this might
#change again in such case a better version detection will be needed
my $UseNewHashes;
if ( $OpenSSLMajorVersion >= 1 ) {
    $UseNewHashes = 1;
}

# set config
$ConfigObject->Set(
    Key   => 'SMIME',
    Value => 1,
);
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# check if openssl is located there
if ( !-e $ConfigObject->Get('SMIME::Bin') ) {

    # maybe it's a mac with macport
    if ( -e '/opt/local/bin/openssl' ) {
        $ConfigObject->Set(
            Key   => 'SMIME::Bin',
            Value => '/opt/local/bin/openssl',
        );
    }
}

# create crypt object
my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

if ( !$SMIMEObject ) {
    print STDERR "NOTICE: No SMIME support!\n";

    if ( !-e $OpenSSLBin ) {
        $Self->False(
            1,
            "No such $OpenSSLBin!",
        );
    }
    elsif ( !-x $OpenSSLBin ) {
        $Self->False(
            1,
            "$OpenSSLBin not executable!",
        );
    }
    elsif ( !-e $CertPath ) {
        $Self->False(
            1,
            "No such $CertPath!",
        );
    }
    elsif ( !-d $CertPath ) {
        $Self->False(
            1,
            "No such $CertPath directory!",
        );
    }
    elsif ( !-w $CertPath ) {
        $Self->False(
            1,
            "$CertPath not writable!",
        );
    }
    elsif ( !-e $PrivatePath ) {
        $Self->False(
            1,
            "No such $PrivatePath!",
        );
    }
    elsif ( !-d $Self->{PrivatePath} ) {
        $Self->False(
            1,
            "No such $PrivatePath directory!",
        );
    }
    elsif ( !-w $PrivatePath ) {
        $Self->False(
            1,
            "$PrivatePath not writable!",
        );
    }
    return 1;
}

#
# Setup environment
#

# OpenSSL 0.9.x hashes
my $Check1Hash       = '980a83c7';
my $Check2Hash       = '999bcb2f';
my $OTRSRootCAHash   = '1a01713f';
my $OTRSRDCAHash     = '7807c24e';
my $OTRSLabCAHash    = '2fc24258';
my $OTRSUserCertHash = 'eab039b6';

# OpenSSL 1.0.0 hashes
if ($UseNewHashes) {
    $Check1Hash       = 'f62a2257';
    $Check2Hash       = '35c7d865';
    $OTRSRootCAHash   = '7835cf94';
    $OTRSRDCAHash     = 'b5d19fb9';
    $OTRSLabCAHash    = '19545811';
    $OTRSUserCertHash = '4d400195';
}

# certificates
my @Certificates = (
    {
        CertificateName       => 'Check1',
        CertificateHash       => $Check1Hash,
        CertificateFileName   => 'SMIMECertificate-1.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-1.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-1.asc',
    },
    {
        CertificateName       => 'Check2',
        CertificateHash       => $Check2Hash,
        CertificateFileName   => 'SMIMECertificate-2.asc',
        PrivateKeyFileName    => 'SMIMEPrivateKey-2.asc',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-2.asc',
    },
    {
        CertificateName       => 'OTRSUserCert',
        CertificateHash       => $OTRSUserCertHash,
        CertificateFileName   => 'SMIMECertificate-smimeuser1.crt',
        PrivateKeyFileName    => 'SMIMEPrivateKey-smimeuser1.pem',
        PrivateSecretFileName => 'SMIMEPrivateKeyPass-smimeuser1.crt',
    },
    {
        CertificateName       => 'OTRSLabCA',
        CertificateHash       => $OTRSLabCAHash,
        CertificateFileName   => 'SMIMECACertificate-OTRSLab.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-OTRSLab.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-OTRSLab.crt',
    },
    {
        CertificateName       => 'OTRSRDCA',
        CertificateHash       => $OTRSRDCAHash,
        CertificateFileName   => 'SMIMECACertificate-OTRSRD.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-OTRSRD.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-OTRSRD.crt',
    },
    {
        CertificateName       => 'OTRSRootCA',
        CertificateHash       => $OTRSRootCAHash,
        CertificateFileName   => 'SMIMECACertificate-OTRSRoot.crt',
        PrivateKeyFileName    => 'SMIMECAPrivateKey-OTRSRoot.pem',
        PrivateSecretFileName => 'SMIMECAPrivateKeyPass-OTRSRoot.crt',
    },
);

# add chain certificates
for my $Certificate (@Certificates) {

    # add certificate ...
    my $CertString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{CertificateFileName},
    );
    my %Result = $SMIMEObject->CertificateAdd( Certificate => ${$CertString} );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} CertificateAdd() - $Result{Message}",
    );

    # and private key
    my $KeyString = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{PrivateKeyFileName},
    );
    my $Secret = $MainObject->FileRead(
        Directory => $ConfigObject->Get('Home') . "/scripts/test/sample/SMIME/",
        Filename  => $Certificate->{PrivateSecretFileName},
    );
    %Result = $SMIMEObject->PrivateAdd(
        Private => ${$KeyString},
        Secret  => ${$Secret},
    );
    $Self->True(
        $Result{Successful} || '',
        "#$Certificate->{CertificateName} PrivateAdd()",
    );
}

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    'TicketCreate()',
);

#
# actual tests
#

# different mails to test
my @Tests = (
    {
        Name        => 'simple string',
        ArticleData => {
            Body     => 'Simple string',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with unix newline',
        ArticleData => {
            Body     => 'Simple string \n with unix newline',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with windows newline',
        ArticleData => {
            Body     => 'Simple string \r\n with windows newline',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with long word',
        ArticleData => {
            Body =>
                'SimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleStringSimpleString',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with long lines',
        ArticleData => {
            Body =>
                'Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string Simple string',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'simple string with unicode data',
        ArticleData => {
            Body     => 'äöüßø@«∑€©ƒ',
            MimeType => 'text/plain',
        },
    },
    {
        Name        => 'Multiline HTML',
        ArticleData => {
            Body =>
                '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Simple Line<br/><br/><br/>Your Ticket-Team<br/><br/>Your Agent<br/><br/>--<br/> Super Support - Waterford Business Park<br/> 5201 Blue Lagoon Drive - 8th Floor &amp; 9th Floor - Miami, 33126 USA<br/> Email: hot@example.com - Web: <a href="http://www.example.com/" title="http://www.example.com/" target="_blank">http://www.example.com/</a><br/>--</body></html>',
            MimeType => 'text/html',
        },
    },
    {
        Name        => 'Inline Attachment',
        ArticleData => {
            Body =>
                '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Hi<img alt="" src="cid:inline835421.188799263.1394842906.6253839.53368344@Mandalore.local" style="height:16px; width:16px" /></body></html>',
            MimeType   => 'text/html',
            Attachment => [
                {
                    ContentID =>
                        'inline835421.188799263.1394842906.6253839.53368344@Mandalore.local',
                    Content     => 'Any',
                    ContentType => 'image/png; name="ui-toolbar-bookmark.png"',
                    Filename    => 'ui-toolbar-bookmark.png',
                    Disposition => 'inline',
                },
            ],
        },
    },
    {
        Name        => 'Normal Attachment',
        ArticleData => {
            Body =>
                '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Simple Line<br/><br/><br/>Your Ticket-Team<br/><br/>Your Agent<br/><br/>--<br/> Super Support - Waterford Business Park<br/> 5201 Blue Lagoon Drive - 8th Floor &amp; 9th Floor - Miami, 33126 USA<br/> Email: hot@example.com - Web: <a href="http://www.example.com/" title="http://www.example.com/" target="_blank">http://www.example.com/</a><br/>--</body></html>',
            MimeType   => 'text/html',
            Attachment => [
                {
                    ContentID   => '',
                    Content     => 'Any',
                    ContentType => 'image/png; name="ui-toolbar-bookmark.png"',
                    Filename    => 'ui-toolbar-bookmark.png',
                    Disposition => 'attachment',
                },
            ],
        },
    },
);

# test each mail with sign/crypt/sign+crypt
my @TestVariations;

for my $Test (@Tests) {
    push @TestVariations, {
        %{$Test},
        Name        => $Test->{Name} . " sign only",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From => 'unittest@example.org',
            To   => 'unittest@example.org',
            Sign => {
                Type    => 'SMIME',
                SubType => 'Detached',
                Key     => $Check1Hash . '.0',
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 0,
    };

    push @TestVariations, {
        %{$Test},
        Name        => $Test->{Name} . " crypt only",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From  => 'unittest@example.org',
            To    => 'unittest@example.org',
            Crypt => {
                Type => 'SMIME',
                Key  => $Check1Hash . '.0',
            },
        },
        VerifySignature  => 0,
        VerifyDecryption => 1,
    };

    push @TestVariations, {
        %{$Test},
        Name        => $Test->{Name} . " sign and crypt",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From => 'unittest@example.org',
            To   => 'unittest@example.org',
            Sign => {
                Type    => 'SMIME',
                SubType => 'Detached',
                Key     => $Check1Hash . '.0',
            },
            Crypt => {
                Type => 'SMIME',
                Key  => $Check1Hash . '.0',
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 1,
    };

    push @TestVariations, {
        %{$Test},
        Name        => $Test->{Name} . " chain CA cert sign only",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From => 'smimeuser1@test.com',
            To   => 'smimeuser1@test.com',
            Sign => {
                Type    => 'SMIME',
                SubType => 'Detached',
                Key     => $OTRSUserCertHash . '.0',
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 0,
    };

    push @TestVariations, {
        %{$Test},
        Name        => $Test->{Name} . " chain CA cert crypt only",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From  => 'smimeuser1@test.com',
            To    => 'smimeuser1@test.com',
            Crypt => {
                Type => 'SMIME',
                Key  => $OTRSUserCertHash . '.0',
            },
        },
        VerifySignature  => 0,
        VerifyDecryption => 1,
    };

    push @TestVariations, {
        %{$Test},
        Name        => $Test->{Name} . " chain CA cert sign and crypt",
        ArticleData => {
            %{ $Test->{ArticleData} },
            From => 'smimeuser1@test.com',
            To   => 'smimeuser1@test.com',
            Sign => {
                Type    => 'SMIME',
                SubType => 'Detached',
                Key     => $OTRSUserCertHash . '.0',
            },
            Crypt => {
                Type => 'SMIME',
                Key  => $OTRSUserCertHash . '.0',
            },
        },
        VerifySignature  => 1,
        VerifyDecryption => 1,
    };
}

for my $Test (@TestVariations) {

    # make a deep copy as the references gets mofified over the tests
    $Test = Storable::dclone($Test);

    my $ArticleID = $TicketObject->ArticleSend(
        TicketID       => $TicketID,
        From           => $Test->{ArticleData}->{From},
        To             => $Test->{ArticleData}->{To},
        ArticleType    => 'email-external',
        SenderType     => 'customer',
        HistoryType    => 'AddNote',
        HistoryComment => 'note',
        Subject        => 'Unittest data',
        Charset        => 'utf-8',
        MimeType       => $Test->{ArticleData}->{MimeType},    # "text/plain" or "text/html"
        Body           => 'Some nice text\n.',
        Sign           => {
            Type    => 'SMIME',
            SubType => 'Detached',
            Key     => $Test->{ArticleData}->{Sign}->{Key},
        },
        UserID => 1,
        %{ $Test->{ArticleData} },
    );

    $Self->True(
        $ArticleID,
        "$Test->{Name} - ArticleSend()",
    );

    my %Article = $TicketObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    my $CheckObject = Kernel::Output::HTML::ArticleCheckSMIME->new(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    my @CheckResult = $CheckObject->Check( Article => \%Article );

    if ( $Test->{VerifySignature} ) {
        my $SignatureVerified =
            grep {
            $_->{Successful} && $_->{Key} eq 'Signed' && $_->{SignatureFound} && $_->{Message}
            } @CheckResult;

        $Self->True(
            $SignatureVerified,
            "$Test->{Name} - signature verified",
        );
    }

    if ( $Test->{VerifyDecryption} ) {
        my $DecryptionVerified =
            grep { $_->{Successful} && $_->{Key} eq 'Crypted' && $_->{Message} } @CheckResult;

        $Self->True(
            $DecryptionVerified,
            "$Test->{Name} - decryption verified",
        );
    }

    my %FinalArticleData = $TicketObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    my $TestBody = $Test->{ArticleData}->{Body};

    # convert test body to ASCII if it was HTML
    if ( $Test->{ArticleData}->{MimeType} eq 'text/html' ) {
        $TestBody = $HTMLUtilsObject->ToAscii(
            String => $TestBody,
        );
    }

    $Self->Is(
        $FinalArticleData{Body},
        $TestBody,
        "$Test->{Name} - verified body content",
    );

    if ( defined $Test->{ArticleData}->{Attachment} ) {
        my $Found;
        my %Index = $TicketObject->ArticleAttachmentIndex(
            ArticleID                  => $ArticleID,
            UserID                     => 1,
            Article                    => \%FinalArticleData,
            StripPlainBodyAsAttachment => 0,
        );

        TESTATTACHMENT:
        for my $Attachment ( @{ $Test->{ArticleData}->{Attachment} } ) {

            next TESTATTACHMENT if !$Attachment->{Filename};

            ATTACHMENTINDEX:
            for my $AttachmentIndex ( sort keys %Index ) {

                if ( $Index{$AttachmentIndex}->{Filename} ne $Attachment->{Filename} ) {
                    next ATTACHMENTINDEX;
                }
                my $ExpectedContentID = $Attachment->{ContentID};
                if ( $Attachment->{ContentID} ) {
                    $ExpectedContentID = '<' . $Attachment->{ContentID} . '>';
                }
                $Self->Is(
                    $Index{$AttachmentIndex}->{ContentID},
                    $ExpectedContentID,
                    "$Test->{Name} - Attachment '$Attachment->{Filename}' ContentID",
                );
                $Found = 1;
                last ATTACHMENTINDEX;
            }
            $Self->True(
                $Found,
                "$Test->{Name} - Attachment '$Attachment->{Filename}' was found"
            );
        }
    }
}

#
# cleanup
#

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

for my $Certificate (@Certificates) {
    my @Keys = $SMIMEObject->Search(
        Search => $Certificate->{CertificateHash},
    );
    $Self->True(
        $Keys[0] || '',
        "$Certificate->{CertificateName} Search()",
    );

    my %Result = $SMIMEObject->PrivateRemove(
        Hash    => $Keys[0]->{Hash},
        Modulus => $Keys[0]->{Modulus},
    );
    $Self->True(
        $Result{Successful} || '',
        "$Certificate->{CertificateName} PrivateRemove() - $Result{Message}",
    );

    %Result = $SMIMEObject->CertificateRemove(
        Hash        => $Keys[0]->{Hash},
        Fingerprint => $Keys[0]->{Fingerprint},
    );

    $Self->True(
        $Result{Successful} || '',
        "$Certificate->{CertificateName} CertificateRemove()",
    );
}

1;
