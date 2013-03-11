# --
# Kernel/System/Email.pm - the global email send module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email;

use strict;
use warnings;

use MIME::Entity;
use Mail::Address;

use Kernel::System::Crypt;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);

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
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::Email;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SendObject = Kernel::System::Email->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        EncodeObject => $EncodeObject,
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
    for (qw(ConfigObject LogObject DBObject TimeObject MainObject EncodeObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    # load generator backend module
    my $GenericModule = $Self->{ConfigObject}->Get('SendmailModule')
        || 'Kernel::System::Email::Sendmail';

    return if !$Self->{MainObject}->Require($GenericModule);

    # create backend object
    $Self->{Backend} = $GenericModule->new(%Param);

    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);

    return $Self;
}

=item Send()

To send an email without already created header:

    my $Sent = $SendObject->Send(
        From        => 'me@example.com',
        To          => 'friend@example.com',
        Subject     => 'Some words!',
        Charset     => 'iso-8859-15',
        MimeType    => 'text/plain', # "text/plain" or "text/html"
        Body        => 'Some nice text',
        InReplyTo   => '<somemessageid-2@example.com>',
        References  => '<somemessageid-1@example.com> <somemessageid-2@example.com>',
        Loop        => 1, # not required, removes smtp from
        Attachment  => [
            {
                Filename    => "somefile.csv",
                Content     => $ContentCSV,
                ContentType => "text/csv",
            },
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

    # replace all br tags with br tags with a space to show newlines in Lotus Notes
    if ( $Param{MimeType} && lc $Param{MimeType} eq 'text/html' ) {
        $Param{Body} =~ s{\Q<br/>\E}{<br />}xmsgi;
    }

    # get sign options for inline
    if ( $Param{Sign} && $Param{Sign}->{SubType} && $Param{Sign}->{SubType} eq 'Inline' ) {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            EncodeObject => $Self->{EncodeObject},
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
            EncodeObject => $Self->{EncodeObject},
            CryptType    => $Param{Crypt}->{Type},
            MainObject   => $Self->{MainObject},
        );
        if ( !$CryptObject ) {
            $Self->{LogObject}->Log(
                Message  => 'Not possible to create crypt object',
                Priority => 'error',
            );
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
    my %Header;
    for (qw(From To Cc Subject Charset Reply-To)) {
        next if !$Param{$_};
        $Header{$_} = $Param{$_};
    }

    # loop
    if ( $Param{Loop} ) {
        $Header{'X-Loop'}          = 'yes';
        $Header{'Precedence:'}     = 'bulk';
        $Header{'Auto-Submitted:'} = "auto-generated";
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

    # check if it's html, add text attachment
    my $HTMLEmail = 0;
    if ( $Param{MimeType} && $Param{MimeType} =~ /html/i ) {
        $HTMLEmail = 1;

        # add html as first attachment
        my $Attach = {
            Content     => $Param{Body},
            ContentType => "text/html; charset=\"$Param{Charset}\"",
            Filename    => '',
        };
        if ( !$Param{Attachment} ) {
            @{ $Param{Attachment} } = ($Attach);
        }
        else {
            @{ $Param{Attachment} } = ( $Attach, @{ $Param{Attachment} } );
        }

        # remember html body for later comparison
        $Param{HTMLBody} = $Param{Body};

        # add ascii body
        $Param{MimeType} = 'text/plain';
        $Param{Body}     = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{Body},
        );

    }

    my $Product = $Self->{ConfigObject}->Get('Product');
    my $Version = $Self->{ConfigObject}->Get('Version');

    if ( !$Self->{ConfigObject}->Get('Secure::DisableBanner') ) {
        $Header{'X-Mailer'}     = "$Product Mail Service ($Version)";
        $Header{'X-Powered-By'} = 'OTRS - Open Ticket Request System (http://otrs.org/)';
    }
    $Header{Type} = $Param{MimeType} || 'text/plain';

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
    my $Header = $Entity->head();
    if ( $Param{InReplyTo} ) {
        $Param{'In-Reply-To'} = $Param{InReplyTo};
    }
    for my $Key ( 'In-Reply-To', 'References' ) {
        next if !$Param{$Key};
        $Header->replace( $Key, $Param{$Key} );
    }

    # add attachments to email
    if ( $Param{Attachment} ) {
        my $Count    = 0;
        my $PartType = '';
        my @NewAttachments;
        ATTACHMENT:
        for my $Upload ( @{ $Param{Attachment} } ) {

            # ignore attachment if no content is given
            next ATTACHMENT if !defined $Upload->{Content};

            # ignore attachment if no filename is given
            next ATTACHMENT if !defined $Upload->{Filename};

            # prepare ContentType for Entity Type. $Upload->{ContentType} has
            # useless `name` parameter, we don't need to send it to the `attach`
            # constructor. For more details see Bug #7879 and MIME::Entity.
            # Note: we should remove `name` attribute only.
            my @ContentTypeTmp = grep { !/\s*name=/ } ( split /;/, $Upload->{ContentType} );
            $Upload->{ContentType} = join ';', @ContentTypeTmp;

            # if it's a html email, add the first attachment as alternative (to show it
            # as alternative content)
            if ($HTMLEmail) {
                $Count++;
                if ( $Count == 1 ) {
                    $Entity->make_multipart('alternative;');
                    $PartType = 'alternative';
                }
                else {

                    # don't attach duplicate html attachment (aka file-2)
                    next ATTACHMENT if
                        $Upload->{Filename} eq 'file-2'
                        && $Upload->{ContentType} =~ /html/i
                        && $Upload->{Content} eq $Param{HTMLBody};

                    # skip, but remember all attachments except inline images
                    if ( !defined $Upload->{ContentID} ) {
                        push @NewAttachments, \%{$Upload};
                        next ATTACHMENT;
                    }

                    # add inline images as related
                    if ( $PartType ne 'related' ) {
                        $Entity->make_multipart( 'related;', Force => 1, );
                        $PartType = 'related';
                    }
                }
            }

            # content encode
            $Self->{EncodeObject}->EncodeOutput( \$Upload->{Content} );

            # filename encode
            my $Filename = $Self->_EncodeMIMEWords(
                Field   => 'filename',
                Line    => $Upload->{Filename},
                Charset => $Param{Charset},
            );

            # format content id, leave undefined if no value
            my $ContentID = $Upload->{ContentID};
            if ( $ContentID && $ContentID !~ /^</ ) {
                $ContentID = '<' . $ContentID . '>';
            }

            # attach file to email
            $Entity->attach(
                Filename    => $Filename,
                Data        => $Upload->{Content},
                Type        => $Upload->{ContentType},
                Id          => $ContentID,
                Disposition => $Upload->{Disposition} || 'inline',
                Encoding    => $Upload->{Encoding} || '-SUGGEST',
            );
        }

        # add all other attachments as multipart mixed (if we had html body)
        for my $Upload (@NewAttachments) {

            # make multipart mixed
            if ( $PartType ne 'mixed' ) {
                $Entity->make_multipart( 'mixed;', Force => 1, );
                $PartType = 'mixed';
            }

            # content encode
            $Self->{EncodeObject}->EncodeOutput( \$Upload->{Content} );

            # filename encode
            my $Filename = $Self->_EncodeMIMEWords(
                Field   => 'filename',
                Line    => $Upload->{Filename},
                Charset => $Param{Charset},
            );

            # attach file to email (no content id needed)
            $Entity->attach(
                Filename    => $Filename,
                Data        => $Upload->{Content},
                Type        => $Upload->{ContentType},
                Disposition => $Upload->{Disposition} || 'inline',
                Encoding    => $Upload->{Encoding} || '-SUGGEST',
            );
        }
    }

    # get sign options for detached
    if ( $Param{Sign} && $Param{Sign}->{SubType} && $Param{Sign}->{SubType} eq 'Detached' ) {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            EncodeObject => $Self->{EncodeObject},
            MainObject   => $Self->{MainObject},
            CryptType    => $Param{Sign}->{Type},
        );
        if ( !$CryptObject ) {
            $Self->{LogObject}->Log(
                Message  => 'Not possible to create crypt object',
                Priority => 'error',
            );
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
            my $Head = $EntityCopy->head();
            $Head->delete('MIME-Version');
            $Head->delete('Content-Type');
            $Head->delete('Content-Disposition');
            $Head->delete('Content-Transfer-Encoding');
            my $Header = $Head->as_string();

            # get string to sign
            my $T = $EntityCopy->parts(0)->as_string();

            # according to RFC3156 all line endings MUST be CR/LF
            $T =~ s/\x0A/\x0D\x0A/g;
            $T =~ s/\x0D+/\x0D/g;
            my $Sign = $CryptObject->Sign(
                Message  => $T,
                Filename => $Param{Sign}->{Key},
                Type     => 'Detached',
            );
            if ($Sign) {
                use MIME::Parser;
                my $Parser = MIME::Parser->new();
                $Parser->output_to_core('ALL');

                $Parser->output_dir( $Self->{ConfigObject}->Get('TempDir') );
                $Entity = $Parser->parse_data( $Header . $Sign );
            }
        }
    }

    # crypt detached!
    #my $NotCryptedBody = $Entity->body_as_string();
    if (
        $Param{Crypt}
        && $Param{Crypt}->{Type}
        && $Param{Crypt}->{Type} eq 'PGP'
        && $Param{Crypt}->{SubType} eq 'Detached'
        )
    {
        my $CryptObject = Kernel::System::Crypt->new(
            LogObject    => $Self->{LogObject},
            DBObject     => $Self->{DBObject},
            ConfigObject => $Self->{ConfigObject},
            EncodeObject => $Self->{EncodeObject},
            MainObject   => $Self->{MainObject},
            CryptType    => $Param{Crypt}->{Type},
        );
        return if !$CryptObject;

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
            EncodeObject => $Self->{EncodeObject},
            MainObject   => $Self->{MainObject},
            CryptType    => $Param{Crypt}->{Type},
        );

        if ( !$CryptObject ) {
            $Self->{LogObject}->Log(
                Message  => 'Failed creation of crypt object',
                Priority => 'error',
            );
            return;
        }

        # make_multipart -=> one attachment for encryption
        $Entity->make_multipart( 'mixed;', Force => 1, );

        # get header to remember
        my $Head = $Entity->head();
        $Head->delete('MIME-Version');
        $Head->delete('Content-Type');
        $Head->delete('Content-Disposition');
        $Head->delete('Content-Transfer-Encoding');
        my $Header = $Head->as_string();

        my $T = $Entity->parts(0)->as_string();

        # according to RFC3156 all line endings MUST be CR/LF
        $T =~ s/\x0A/\x0D\x0A/g;
        $T =~ s/\x0D+/\x0D/g;

        # crypt it
        my $Crypt = $CryptObject->Crypt(
            Message  => $T,
            Filename => $Param{Crypt}->{Key},
        );
        use MIME::Parser;
        my $Parser = MIME::Parser->new();

        $Parser->output_dir( $Self->{ConfigObject}->Get('TempDir') );
        $Entity = $Parser->parse_data( $Header . $Crypt );
    }

    # get header from Entity
    my $Head = $Entity->head();
    $Param{Header} = $Head->as_string();

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
    my @ToArray;
    my $To = '';
    for (qw(To Cc Bcc)) {
        next if !$Param{$_};
        for my $Email ( Mail::Address->parse( $Param{$_} ) ) {
            push( @ToArray, $Email->address() );
            if ($To) {
                $To .= ', ';
            }
            $To .= $Email->address();
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

    if ( !$Sent ) {
        $Self->{LogObject}->Log(
            Message  => "Error sending message",
            Priority => 'info',
        );
        return;
    }

    return ( \$Param{Header}, \$Param{Body} );
}

=item Check()

Check mail configuration

    my %Check = $SendObject->Check();

=cut

sub Check {
    my ( $Self, %Param ) = @_;

    my %Check = $Self->{Backend}->Check();

    if ( $Check{Successful} ) {
        return ( Successful => 1 )
    }
    else {
        return ( Successful => 0, Message => $Check{Message} );
    }
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

    # get sender
    my @Sender   = Mail::Address->parse( $Param{From} );
    my $RealFrom = $Sender[0]->address();

    # add ReSent header
    my $HeaderObject = $EmailObject->head();
    my $OldMessageID = $HeaderObject->get('Message-ID') || '??';
    $HeaderObject->replace( 'Message-ID',        $MessageID );
    $HeaderObject->replace( 'ReSent-Message-ID', $OldMessageID );
    $HeaderObject->replace( 'Resent-To',         $Param{To} );
    $HeaderObject->replace( 'Resent-From',       $RealFrom );
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
            Message  => "Bounced email to '$Param{To}' from '$RealFrom'. "
                . "MessageID => '$OldMessageID';",
        );
    }

    my $Sent = $Self->{Backend}->Send(
        From    => $RealFrom,
        ToArray => [ $Param{To} ],
        Header  => \$HeaderAsString,
        Body    => \$BodyAsString,
    );

    return if !$Sent;

    return ( \$HeaderAsString, \$BodyAsString );
}

=begin Internal:

=cut

sub _EncodeMIMEWords {
    my ( $Self, %Param ) = @_;

    # return if no content is given
    return '' if !defined $Param{Line};

    # check if MIME::EncWords is installed
    if ( eval { require MIME::EncWords } ) {    ## no critic
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
        require MIME::Words;    ## no critic
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

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
