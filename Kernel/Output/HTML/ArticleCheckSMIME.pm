# --
# Kernel/Output/HTML/ArticleCheckSMIME.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleCheckSMIME;

use strict;
use warnings;

use Kernel::System::Crypt;
use Kernel::System::EmailParser;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject EncodeObject MainObject DBObject LayoutObject UserID TicketObject ArticleID)
        )
    {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
        }
    }
    return $Self;
}

sub Check {
    my ( $Self, %Param ) = @_;

    my %SignCheck;
    my @Return;

    # check if smime is enabled
    return if !$Self->{ConfigObject}->Get('SMIME');

    # check if article is an email
    return if $Param{Article}->{ArticleType} !~ /email/i;

    $Self->{CryptObject} = Kernel::System::Crypt->new( %{$Self}, CryptType => 'SMIME' );

    # check inline smime
    if ( $Param{Article}->{Body} =~ /^-----BEGIN PKCS7-----/ ) {
        %SignCheck = $Self->{CryptObject}->Verify( Message => $Param{Article}->{Body} );
        if (%SignCheck) {

            # remember to result
            $Self->{Result} = \%SignCheck;
        }
        else {

            # return with error
            push(
                @Return,
                {
                    Key   => 'Signed',
                    Value => '"S/MIME SIGNED MESSAGE" header found, but invalid!',
                }
            );
        }
    }

    # check smime
    else {

        # get email from fs
        my $Message = $Self->{TicketObject}->ArticlePlain(
            ArticleID => $Self->{ArticleID},
            UserID    => $Self->{UserID},
        );

        my @Email = ();
        my @Lines = split( /\n/, $Message );
        for my $Line (@Lines) {
            push( @Email, $Line . "\n" );
        }

        my $ParserObject = Kernel::System::EmailParser->new( %{$Self}, Email => \@Email, );

        use MIME::Parser;
        my $Parser = MIME::Parser->new();
        $Parser->decode_headers(0);
        $Parser->extract_nested_messages(0);
        $Parser->output_to_core("ALL");
        my $Entity = $Parser->parse_data($Message);
        my $Head   = $Entity->head();
        $Head->unfold();
        $Head->combine('Content-Type');
        my $ContentType = $Head->get('Content-Type');

        if (
            $ContentType
            && $ContentType =~ /application\/(x-pkcs7|pkcs7)-mime/i
            && $ContentType !~ /signed/i
            )
        {

            # check if article is already decrypted
            if ( $Param{Article}->{Body} ne '- no text message => see attachment -' ) {
                push(
                    @Return,
                    {
                        Key        => 'Crypted',
                        Value      => 'Ticket decrypted before',
                        Successful => 1,
                    }
                );
            }

            # check sender (don't decrypt sent emails)
            if ( $Param{Article}->{SenderType} =~ /(agent|system)/i ) {

                # return info
                return (
                    {
                        Key        => 'Crypted',
                        Value      => 'Sent message crypted to recipient!',
                        Successful => 1,
                    }
                );
            }

            # get all email addresses on article
            my %EmailsToSearch;
            for my $Email (qw(Resent-To Envelope-To To Cc Delivered-To X-Original-To)) {

                my @EmailAddressOnField = $ParserObject->SplitAddressLine(
                    Line => $ParserObject->GetParam( WHAT => $Email ),
                );

                # filter email addresses avoiding repeated and save on hash to search
                for my $EmailAddress (@EmailAddressOnField) {
                    my $CleanEmailAddress
                        = $ParserObject->GetEmailAddress( Email => $EmailAddress, );
                    $EmailsToSearch{$CleanEmailAddress} = '1';
                }
            }

            # look for private keys for every email address
            # extract every resulting cert and put it into an hash of hashes avoiding repeated
            my %PrivateKeys;
            for my $EmailAddress ( sort keys %EmailsToSearch ) {
                my @PrivateKeysResult
                    = $Self->{CryptObject}->PrivateSearch( Search => $EmailAddress, );
                for my $Cert (@PrivateKeysResult) {
                    $PrivateKeys{ $Cert->{Filename} } = $Cert;
                }
            }

            # search private cert to decrypt email
            if ( !%PrivateKeys ) {
                push(
                    @Return,
                    {
                        Key   => 'Crypted',
                        Value => 'Impossible to decrypt: private key for email was not found!',
                    }
                );
                return @Return;
            }

            my %Decrypt;
            PRIVATESEARCH:
            for my $CertResult ( values %PrivateKeys ) {

                # decrypt
                %Decrypt = $Self->{CryptObject}->Decrypt(
                    Message            => $Message,
                    SearchingNeededKey => 1,
                    %{$CertResult},
                );
                last PRIVATESEARCH if ( $Decrypt{Successful} );
            }

            # ok, decryption went fine
            if ( $Decrypt{Successful} ) {

                push(
                    @Return,
                    {
                        Key => 'Crypted',
                        Value => $Decrypt{Message} || 'Successful decryption',
                        %Decrypt,
                    }
                );

                # store decrypted data
                my $EmailContent = $Decrypt{Data};

                # now check if the data contains a signature too
                %SignCheck = $Self->{CryptObject}->Verify( Message => $Decrypt{Data}, );

                if ( $SignCheck{SignatureFound} ) {

                  # If the signature was verified well, use the stripped content to store the email.
                  #   Now it contains only the email without other SMIME generated data.
                    $EmailContent = $SignCheck{Content} if $SignCheck{Successful};

                    push(
                        @Return,
                        {
                            Key   => 'Signed',
                            Value => $SignCheck{Message},
                            %SignCheck,
                        }
                    );
                }

                # parse the decrypted email body
                my $ParserObject
                    = Kernel::System::EmailParser->new( %{$Self}, Email => $EmailContent );
                my $Body = $ParserObject->GetMessageBody();

                # from RFC 3850
                # 3.  Using Distinguished Names for Internet Mail
                #
                #   End-entity certificates MAY contain ...
                #
                #    ...
                #
                #   Sending agents SHOULD make the address in the From or Sender header
                #   in a mail message match an Internet mail address in the signer's
                #   certificate.  Receiving agents MUST check that the address in the
                #   From or Sender header of a mail message matches an Internet mail
                #   address, if present, in the signer's certificate, if mail addresses
                #   are present in the certificate.  A receiving agent SHOULD provide
                #   some explicit alternate processing of the message if this comparison
                #   fails, which may be to display a message that shows the recipient the
                #   addresses in the certificate or other certificate details.

                # as described in bug#5098 and RFC 3850 an alternate mail handling should be
                # made if sender and signer addresses does not match

                # get original sender from email
                my @OrigEmail = map {"$_\n"} split( /\n/, $Message );
                my $ParserObjectOrig = Kernel::System::EmailParser->new(
                    %{$Self},
                    Email => \@OrigEmail,
                );

                my $OrigFrom = $ParserObjectOrig->GetParam( WHAT => 'From' );
                my $OrigSender = $ParserObjectOrig->GetEmailAddress( Email => $OrigFrom );

                # compare sender email to signer email
                my $SignerSenderMatch = 0;
                for my $Signer ( @{ $SignCheck{Signers} } ) {
                    if ( $OrigSender =~ m{\A \Q$Signer\E \z}xmsi ) {
                        $SignerSenderMatch = 1;
                        last;
                    }
                }

                # sender email does not match signing certificate!
                if ( !$SignerSenderMatch ) {
                    $SignCheck{Successful} = 0;
                    $SignCheck{Message} =~ s/successful/failed!/;
                    $SignCheck{Message} .= " (signed by "
                        . join( ' | ', @{ $SignCheck{Signers} } )
                        . ")"
                        . ", but sender address $OrigSender: does not match certificate address!";
                }

                # updated article body
                $Self->{TicketObject}->ArticleUpdate(
                    TicketID  => $Param{Article}->{TicketID},
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Body',
                    Value     => $Body,
                    UserID    => $Self->{UserID},
                );

                # delete crypted attachments
                $Self->{TicketObject}->ArticleDeleteAttachment(
                    ArticleID => $Self->{ArticleID},
                    UserID    => $Self->{UserID},
                );

                # write attachments to the storage
                for my $Attachment ( $ParserObject->GetAttachments() ) {
                    $Self->{TicketObject}->ArticleWriteAttachment(
                        Content     => $Attachment->{Content},
                        Filename    => $Attachment->{Filename},
                        ContentType => $Attachment->{ContentType},
                        ArticleID   => $Self->{ArticleID},
                        UserID      => $Self->{UserID},
                    );
                }

                return @Return;
            }
            else {
                push(
                    @Return,
                    {
                        Key   => 'Crypted',
                        Value => "$Decrypt{Message}",
                        %Decrypt,
                    }
                );
            }
        }

        if (
            $ContentType
            && $ContentType =~ /application\/(x-pkcs7|pkcs7)/i
            && $ContentType =~ /signed/i
            )
        {

            # check if article is already verified
            if ( $Param{Article}->{Body} ne '- no text message => see attachment -' ) {

                # return result
                push(
                    @Return,
                    {
                        Key   => 'Signed',
                        Value => 'Signature verified before!',
                    }
                );
            }

            # check sign and get clear content
            %SignCheck = $Self->{CryptObject}->Verify( Message => $Message, );

            # parse and update clear content
            if ( %SignCheck && $SignCheck{Successful} && $SignCheck{Content} ) {

                my @Email = ();
                my @Lines = split( /\n/, $SignCheck{Content} );
                for (@Lines) {
                    push( @Email, $_ . "\n" );
                }
                my $ParserObject = Kernel::System::EmailParser->new( %{$Self}, Email => \@Email, );
                my $Body = $ParserObject->GetMessageBody();

                # from RFC 3850
                # 3.  Using Distinguished Names for Internet Mail
                #
                #   End-entity certificates MAY contain ...
                #
                #    ...
                #
                #   Sending agents SHOULD make the address in the From or Sender header
                #   in a mail message match an Internet mail address in the signer's
                #   certificate.  Receiving agents MUST check that the address in the
                #   From or Sender header of a mail message matches an Internet mail
                #   address, if present, in the signer's certificate, if mail addresses
                #   are present in the certificate.  A receiving agent SHOULD provide
                #   some explicit alternate processing of the message if this comparison
                #   fails, which may be to display a message that shows the recipient the
                #   addresses in the certificate or other certificate details.

                # as described in bug#5098 and RFC 3850 an alternate mail handling should be
                # made if sender and signer addresses does not match

                # get original sender from email
                my @OrigEmail = map {"$_\n"} split( /\n/, $Message );
                my $ParserObjectOrig = Kernel::System::EmailParser->new(
                    %{$Self},
                    Email => \@OrigEmail,
                );

                my $OrigFrom = $ParserObjectOrig->GetParam( WHAT => 'From' );
                my $OrigSender = $ParserObjectOrig->GetEmailAddress( Email => $OrigFrom );

                # compare sender email to signer email
                my $SignerSenderMatch = 0;
                for my $Signer ( @{ $SignCheck{Signers} } ) {
                    if ( $OrigSender =~ m{\A \Q$Signer\E \z}xmsi ) {
                        $SignerSenderMatch = 1;
                        last;
                    }
                }

                # sender email does not match signing certificate!
                if ( !$SignerSenderMatch ) {
                    $SignCheck{Successful} = 0;
                    $SignCheck{Message} =~ s/successful/failed!/;
                    $SignCheck{Message} .= " (signed by "
                        . join( ' | ', @{ $SignCheck{Signers} } )
                        . ")"
                        . ", but sender address $OrigSender: does not match certificate address!";
                }

                # updated article body
                $Self->{TicketObject}->ArticleUpdate(
                    TicketID  => $Param{Article}->{TicketID},
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Body',
                    Value     => $Body,
                    UserID    => $Self->{UserID},
                );

                # delete crypted attachments
                $Self->{TicketObject}->ArticleDeleteAttachment(
                    ArticleID => $Self->{ArticleID},
                    UserID    => $Self->{UserID},
                );

                # write attachments to the storage
                for my $Attachment ( $ParserObject->GetAttachments() ) {
                    $Self->{TicketObject}->ArticleWriteAttachment(
                        Content     => $Attachment->{Content},
                        Filename    => $Attachment->{Filename},
                        ContentType => $Attachment->{ContentType},
                        ArticleID   => $Self->{ArticleID},
                        UserID      => $Self->{UserID},
                    );
                }
            }

            # output signature verification errors
            elsif (
                %SignCheck
                && !$SignCheck{SignatureFound}
                && !$SignCheck{Successful}
                && !$SignCheck{Content}
                )
            {
                # return result
                push(
                    @Return,
                    {
                        Key   => 'Signed',
                        Value => $SignCheck{Message},
                        %SignCheck,
                    }
                );
            }
        }
    }

    if ( $SignCheck{SignatureFound} ) {

        # return result
        push(
            @Return,
            {
                Key   => 'Signed',
                Value => $SignCheck{Message},
                %SignCheck,
            }
        );
    }
    return @Return;
}

sub Filter {
    my ( $Self, %Param ) = @_;

    # remove signature if one is found
    if ( $Self->{Result}->{SignatureFound} ) {

        # remove pgp begin signed message
        $Param{Article}->{Body} =~ s/^-----BEGIN\sPKCS7-----.+?Hash:\s.+?$//sm;

        # remove pgp inline sign
        $Param{Article}->{Body} =~ s/^-----END\sPKCS7-----//sm;
    }
    return 1;
}
1;
