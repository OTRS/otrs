# --
# Kernel/Output/HTML/ArticleCheckSMIME.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: ArticleCheckSMIME.pm,v 1.20.6.7 2012-05-04 09:05:35 mg Exp $
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
$VERSION = qw($Revision: 1.20.6.7 $) [1];

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
        my $parser = MIME::Parser->new();
        $parser->decode_headers(0);
        $parser->extract_nested_messages(0);
        $parser->output_to_core("ALL");
        my $Entity = $parser->parse_data($Message);
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
            for my $EmailAddress ( keys %EmailsToSearch ) {
                my @PrivateKeysResult
                    = $Self->{CryptObject}->PrivateSearch( Search => $EmailAddress, );
                for my $Cert (@PrivateKeysResult) {
                    $PrivateKeys{ $Cert->{Hash} } = $Cert;
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
