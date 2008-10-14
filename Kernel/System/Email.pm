# --
# Kernel/System/Email.pm - the global email send module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Email.pm,v 1.46 2008-10-14 09:31:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Email;

use strict;
use warnings;
use MIME::Entity;
use Mail::Address;
use Kernel::System::Encode;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.46 $) [1];

=head1 NAME

Kernel::System::Email - to send email

=head1 SYNOPSIS

Global module to send email via sendmail or SMTP.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::Email;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        MainObject   => $MainObject,
        LogObject    => $LogObject,
    );
    my $SendObject = Kernel::System::Email->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug level
    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(ConfigObject LogObject DBObject TimeObject MainObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    # create encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # load generator backend module
    my $GenericModule = $Self->{ConfigObject}->Get('SendmailModule')
        || 'Kernel::System::Email::Sendmail';
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        return;
    }

    # create backend object
    $Self->{Backend} = $GenericModule->new(
        %Param,
        EncodeObject => $Self->{EncodeObject},
    );

    return $Self;
}

=item Send()

To send an email without already created header:

    my $Sent = $SendObject->Send(
        From       => 'me@example.com',
        To         => 'friend@example.com',
        Subject    => 'Some words!',
        Type       => 'text/plain',
        Charset    => 'iso-8859-15',
        Body       => 'Some nice text',
        InReplyTo  => '<somemessageid-2@example.com>',
        References => '<somemessageid-1@example.com> <somemessageid-2@example.com>',
        Loop       => 1, # not required, removes smtp from
        Attachment => [
            {
                Filename    => "somefile.csv",
                Content     => $ContentCSV,
                ContentType => "text/csv",
            }
            {
                Filename    => "somefile.png",
                Content     => $ContentPNG,
                ContentType => "image/png",
            }
        ],
        Sign => {
            Type    => 'PGP',
            SubType => 'Inline|Detached',
            Key     => '81877F5E',

            Type => 'SMIME',
            Key  => '3b630c80',
        },
        Crypt => {
            Type    => 'PGP',
            SubType => 'Inline|Detached',
            Key     => '81877F5E',

            Type => 'SMIME',
            Key  => '3b630c80',
        },
    );

    if ($Sent) {
        print "Email sent!\n";
    }
    else {
        print "Email not sent!\n";
    }

=cut

sub Send {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Body Charset)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{To} && !$Param{Cc} && !$Param{Bcc} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need To, Cc or Bcc!' );
        return;
    }

    # check from
    if ( !$Param{From} ) {
        $Param{From} = $Self->{ConfigObject}->Get('AdminEmail') || 'otrs@localhost';
    }

    # get sign options for inline
    if ( $Param{Sign} && $Param{Sign}->{SubType} && $Param{Sign}->{SubType} eq 'Inline' ) {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            CryptType    => $Param{Sign}->{Type},
            MainObject   => $Self->{MainObject},
        );
        if ( !$CryptObject ) {
            return;
        }
        my $Body = $CryptObject->Sign(
            Message => $Param{Body},
            Key     => $Param{Sign}->{Key},
            Type    => 'Clearsign',
            Charset => $Param{Charset},
        );
        if ($Body) {
            $Param{Body} = $Body;
        }
    }

    # crypt inline
    if ( $Param{Crypt} && $Param{Crypt}->{Type} eq 'PGP' && $Param{Crypt}->{SubType} eq 'Inline' ) {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            CryptType    => $Param{Crypt}->{Type},
            MainObject   => $Self->{MainObject},
        );
        if ( !$CryptObject ) {
            return;
        }
        my $Body = $CryptObject->Crypt(
            Message => $Param{Body},
            Key     => $Param{Crypt}->{Key},
            Type    => $Param{Crypt}->{SubType},
        );
        if ($Body) {
            $Param{Body} = $Body;
        }
    }

    # build header
    my %Header = ();
    for (qw(From To Cc Subject Charset Reply-To)) {
        next if !$Param{$_};
        $Header{$_} = $Param{$_};
    }

    # loop
    if ( $Param{Loop} ) {
        $Header{'X-Loop'} = 'yes';
        $Header{Precedence} = 'bulk';
    }

    # do some encode
    for (qw(From To Cc Subject)) {
        next if !$Header{$_};
        $Header{$_} = $Self->_EncodeMIMEWords(
            Field   => $_,
            Line    => $Header{$_},
            Charset => $Param{Charset},
        );
    }
    my $XMailer = $Self->{ConfigObject}->Get('Product')
        . ' Mail Service ('
        . $Self->{ConfigObject}->Get('Version') . ')';
    $Header{'X-Mailer'}     = $XMailer;
    $Header{'X-Powered-By'} = 'OTRS - Open Ticket Request System (http://otrs.org/)';
    $Header{Type}           = $Param{Type} || 'text/plain';

    # define email encoding
    if ( $Param{Charset} && $Param{Charset} =~ /^iso/i ) {
        $Header{Encoding} = '8bit';
    }
    else {
        $Header{Encoding} = 'quoted-printable';
    }

    # check if we need to force the encoding
    if ( $Self->{ConfigObject}->Get('SendmailEncodingForce') ) {
        $Header{Encoding} = $Self->{ConfigObject}->Get('SendmailEncodingForce');
    }

    # body encode if utf8 and base64 is used
    if ( $Header{Encoding} =~ /utf(8|-8)/i && $Header{Encoding} =~ /base64/i ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Body} );
    }

    # check and create message id
    if ( $Param{'Message-ID'} ) {
        $Header{'Message-ID'} = $Param{'Message-ID'};
    }
    else {
        $Header{'Message-ID'} = $Self->_MessageIDCreate();
    }

    # add date header
    $Header{Date} = 'Date: ' . $Self->{TimeObject}->MailTimeStamp();

    # add organisation header
    my $Organization = $Self->{ConfigObject}->Get('Organization');
    if ($Organization) {
        $Header{Organization} = $Self->_EncodeMIMEWords(
            Field   => 'Organization',
            Line    => $Organization,
            Charset => $Param{Charset},
        );
    }

    # build MIME::Entity
    my $Entity = MIME::Entity->build( %Header, Data => $Param{Body} );

    # set In-Reply-To and References header
    my $Header = $Entity->head;
    if ($Param{InReplyTo}) {
        $Param{'In-Reply-To'} = $Param{InReplyTo};
    }
    for my $Key ('In-Reply-To', 'References') {
        next if !$Param{$Key};
        $Header->replace( $Key, $Param{$Key} );
    }

    # add attachments to email
    if ( $Param{Attachment} ) {
        for my $Upload ( @{ $Param{Attachment} } ) {
            if ( $Upload->{Content} && $Upload->{Filename} ) {

                # content encode
                $Self->{EncodeObject}->EncodeOutput( \$Upload->{Content} );

                # attach file to email
                $Entity->attach(
                    Filename    => $Upload->{Filename},
                    Data        => $Upload->{Content},
                    Type        => $Upload->{ContentType},
                    Disposition => $Upload->{Disposition} || 'inline',
                    Encoding    => $Upload->{Encoding} || '-SUGGEST',
                );
            }
        }
    }

    # get sign options for detached
    if ( $Param{Sign} && $Param{Sign}->{SubType} && $Param{Sign}->{SubType} eq 'Detached' ) {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            CryptType    => $Param{Sign}->{Type},
        );
        if ( !$CryptObject ) {
            return;
        }
        if ( $Param{Sign}->{Type} eq 'PGP' ) {

            # make_multipart -=> one attachment for sign
            $Entity->make_multipart(
                "signed; micalg=pgp-sha1; protocol=\"application/pgp-signature\";",
                Force => 1,
            );

            # get string to sign
            my $T = $Entity->parts(0)->as_string();

            # according to RFC3156 all line endings MUST be CR/LF
            $T =~ s/\x0A/\x0D\x0A/g;
            $T =~ s/\x0D+/\x0D/g;
            my $Sign = $CryptObject->Sign(
                Message => $T,
                Key     => $Param{Sign}->{Key},
                Type    => 'Detached',
                Charset => $Param{Charset},
            );

            # it sign failed, remove singned multi part
            if ( !$Sign ) {
                $Entity->make_singlepart();
            }
            else {

                # addach sign to email
                $Entity->attach(
                    Filename => 'pgp_sign.asc',
                    Data     => $Sign,
                    Type     => 'application/pgp-signature',
                    Encoding => '7bit',
                );
            }
        }
        elsif ( $Param{Sign}->{Type} eq 'SMIME' ) {

            # make multi part
            my $EntityCopy = $Entity->dup();
            $EntityCopy->make_multipart( 'mixed;', Force => 1, );

            # get header to remember
            my $head = $EntityCopy->head;
            $head->delete('MIME-Version');
            $head->delete('Content-Type');
            $head->delete('Content-Disposition');
            $head->delete('Content-Transfer-Encoding');
            my $Header = $head->as_string();

            # get string to sign
            my $T = $EntityCopy->parts(0)->as_string();

            # according to RFC3156 all line endings MUST be CR/LF
            $T =~ s/\x0A/\x0D\x0A/g;
            $T =~ s/\x0D+/\x0D/g;
            my $Sign = $CryptObject->Sign(
                Message => $T,
                Hash    => $Param{Sign}->{Key},
                Type    => 'Detached',
            );
            if ($Sign) {
                use MIME::Parser;
                my $Parser = new MIME::Parser;
                $Parser->output_to_core('ALL');

                #        $Parser->output_dir($Self->{ConfigObject}->Get('TempDir'));
                $Entity = $Parser->parse_data( $Header . $Sign );
            }
        }
    }

    # crypt detached!
    #my $NotCryptedBody = $Entity->body_as_string();
    if (
        $Param{Crypt}
        && $Param{Crypt}->{Type}
        && $Param{Crypt}->{Type}    eq 'PGP'
        && $Param{Crypt}->{SubType} eq 'Detached'
        )
    {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            CryptType    => $Param{Crypt}->{Type},
        );
        if ( !$CryptObject ) {
            return;
        }

        # make_multipart -=> one attachment for encryption
        $Entity->make_multipart(
            "encrypted; protocol=\"application/pgp-encrypted\";",
            Force => 1,
        );

        # crypt it
        my $Crypt = $CryptObject->Crypt(
            Message => $Entity->parts(0)->as_string(),

            # Key => '81877F5E',
            # Key => '488A0B8F',
            Key => $Param{Crypt}->{Key},
        );

        # it crypt failed, remove encrypted multi part
        if ( !$Crypt ) {
            $Entity->make_singlepart();
        }
        else {

            # eliminate all parts
            $Entity->parts( [] );

            # add crypted parts
            $Entity->attach(
                Type        => 'application/pgp-encrypted',
                Disposition => 'attachment',
                Data        => [ "Version: 1", "" ],
                Encoding    => '7bit',
            );
            $Entity->attach(
                Type        => 'application/octet-stream',
                Disposition => 'inline',
                Filename    => 'msg.asc',
                Data        => $Crypt,
                Encoding    => '7bit',
            );
        }
    }
    elsif ( $Param{Crypt} && $Param{Crypt}->{Type} && $Param{Crypt}->{Type} eq 'SMIME' ) {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            CryptType    => $Param{Crypt}->{Type},
        );
        if ( !$CryptObject ) {
            return;
        }

        # make_multipart -=> one attachment for encryption
        $Entity->make_multipart( 'mixed;', Force => 1, );

        # get header to remember
        my $head = $Entity->head;
        $head->delete('MIME-Version');
        $head->delete('Content-Type');
        $head->delete('Content-Disposition');
        $head->delete('Content-Transfer-Encoding');
        my $Header = $head->as_string();

        # crypt it
        my $Crypt = $CryptObject->Crypt(
            Message => $Entity->parts(0)->as_string(),
            Hash    => $Param{Crypt}->{Key},
        );
        use MIME::Parser;
        my $Parser = new MIME::Parser;

        #        $Parser->output_dir($Self->{ConfigObject}->Get('TempDir'));
        $Entity = $Parser->parse_data( $Header . $Crypt );
    }

    # get header from Entity
    my $head = $Entity->head;
    $Param{Header} = $head->as_string();

    # remove not needed folding of email heads, we do have many problems with email clients
    my @Headers = split( /\n/, $Param{Header} );

    # reset orig header
    $Param{Header} = '';
    for my $Line (@Headers) {
        $Line =~ s/^    (.*)$/ $1/;
        $Param{Header} .= $Line . "\n";
    }

    # get body from Entity
    $Param{Body} = $Entity->body_as_string();

    # get recipients
    my @ToArray = ();
    my $To      = '';
    for (qw(To Cc Bcc)) {
        if ( $Param{$_} ) {
            for my $Email ( Mail::Address->parse( $Param{$_} ) ) {
                push( @ToArray, $Email->address() );
                if ($To) {
                    $To .= ', ';
                }
                $To .= $Email->address();
            }
        }
    }

    # add Bcc recipients
    my $SendmailBcc = $Self->{ConfigObject}->Get('SendmailBcc');
    if ($SendmailBcc) {
        push @ToArray, $SendmailBcc;
        $To .= ', ' . $SendmailBcc;
    }

    # get sender
    my @Sender   = Mail::Address->parse( $Param{From} );
    my $RealFrom = $Sender[0]->address();
    if ( $Param{Loop} ) {
        $RealFrom = $Self->{ConfigObject}->Get('SendmailNotificationEnvelopeFrom') || '';
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent email to '$To' from '$RealFrom'. Subject => '$Param{Subject}';",
        );
    }

    # send email to backend
    my $Sent = $Self->{Backend}->Send(
        From    => $RealFrom,
        ToArray => \@ToArray,
        Header  => \$Param{Header},
        Body    => \$Param{Body},
    );

    return if !$Sent;

    return ( \$Param{Header}, \$Param{Body} );
}

=item Bounce()

Bounce an email

    $SendObject->Bounce(
        From  => 'me@example.com',
        To    => 'friend@example.com',
        Email => $Email,
    );

=cut

sub Bounce {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(From To Email)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check and create message id
    my $MessageID = '';
    if ( $Param{'Message-ID'} ) {
        $MessageID = $Param{'Message-ID'};
    }
    else {
        $MessageID = $Self->_MessageIDCreate();
    }

    # split body && header
    my @EmailPlain = split( /\n/, $Param{Email} );
    my $EmailObject = new Mail::Internet( \@EmailPlain );

    # add ReSent header
    my $HeaderObject = $EmailObject->head();
    my $OldMessageID = $HeaderObject->get('Message-ID') || '??';
    $HeaderObject->replace( 'Message-ID',        $MessageID );
    $HeaderObject->replace( 'ReSent-Message-ID', $OldMessageID );
    $HeaderObject->replace( 'Resent-To',         $Param{To} );
    $HeaderObject->replace( 'Resent-From',       $Param{From} );
    my $Body         = $EmailObject->body();
    my $BodyAsString = '';
    for ( @{$Body} ) {
        $BodyAsString .= $_ . "\n";
    }
    my $HeaderAsString = $HeaderObject->as_string();

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Bounced email to '$Param{To}' from '$Param{From}'. "
                . "MessageID => '$OldMessageID';",
        );
    }

    my $Sent = $Self->{Backend}->Send(
        From    => $Param{From},
        ToArray => [ $Param{To} ],
        Header  => \$HeaderAsString,
        Body    => \$BodyAsString,
    );

    return if !$Sent;

    return ( \$HeaderAsString, \$BodyAsString );
}

sub _EncodeMIMEWords {
    my ( $Self, %Param ) = @_;

    # return if no content is given
    return '' if !defined $Param{Line};

    # check if MIME::EncWords is installed
    if ( eval { require MIME::EncWords } ) {
        return MIME::EncWords::encode_mimewords(
            Encode::encode(
                $Param{Charset},
                $Param{Line},
            ),
            Charset => $Param{Charset},

            # use 'a' for quoted printable or base64 choice automatically
            Encoding => 'a',

            # for line length calculation to fold lines
            Field => $Param{Field},
        );
    }

    # as fallback use MIME::Words of MIME::Tools (but it lakes on some utf8
    # issues, see pod of MIME::Words)
    else {
        require MIME::Words;
        return MIME::Words::encode_mimewords(
            Encode::encode(
                $Param{Charset},
                $Param{Line},
            ),
            Charset => $Param{Charset},

            # for line length calculation to fold lines (gets ignored by
            # MIME::Words, see pod of MIME::Words)
            Field => $Param{Field},
        );
    }
}

sub _MessageIDCreate {
    my ( $Self, %Param ) = @_;

    my $FQDN = $Self->{ConfigObject}->Get('FQDN');
    return 'Message-ID: <' . time() . '.' . rand(999999) . '@' . $FQDN . '>';
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

$Revision: 1.46 $ $Date: 2008-10-14 09:31:39 $

=cut
