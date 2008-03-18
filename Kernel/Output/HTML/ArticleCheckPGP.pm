# --
# Kernel/Output/HTML/ArticleCheckPGP.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ArticleCheckPGP.pm,v 1.18 2008-03-18 16:20:37 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::ArticleCheckPGP;

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject MainObject DBObject LayoutObject UserID TicketObject ArticleID))
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

    my %SignCheck = ();
    my @Return    = ();

    # check if pgp is enabled
    return if !$Self->{ConfigObject}->Get('PGP');

    # check if article is an email
    return if $Param{Article}->{ArticleType} !~ /email/i;

    $Self->{CryptObject} = Kernel::System::Crypt->new( %Param, CryptType => 'PGP' );

    # check inline pgp crypt
    if ( $Param{Article}->{Body} =~ /^-----BEGIN PGP MESSAGE-----/ ) {

        # check sender (don't decrypt sent emails)
        if ( $Param{Article}->{SenderType} =~ /(agent|system)/i ) {

            # return info
            return (
                {   Key   => 'Crypted',
                    Value => 'Sent message crypted to recipient!',
                }
            );
        }
        my %Decrypt = $Self->{CryptObject}->Decrypt( Message => $Param{Article}->{Body} );
        if ( $Decrypt{Successful} ) {

            # remember to result
            $Self->{Result} = \%Decrypt;
            $Param{Article}->{Body} = $Decrypt{Data};

                # updated article body
                $Self->{TicketObject}->ArticleUpdate(
                    TicketID  => $Param{Article}->{TicketID},
                    ArticleID => $Self->{ArticleID},
                    Key       => 'Body',
                    Value     => $Decrypt{Data},
                    UserID    => $Self->{UserID},
                );
        }
        else {

            # return with error
            return (
                {   Key   => 'Crypted',
                    Value => $Decrypt{Message},
                    %Decrypt,
                }
            );
        }
    }

    # check inline pgp signature
    if ( $Param{Article}->{Body} =~ /^-----BEGIN PGP SIGNED MESSAGE-----/ ) {
        %SignCheck = $Self->{CryptObject}->Verify( Message => $Param{Article}->{Body}, );
        if (%SignCheck) {

            # remember to result
            $Self->{Result} = \%SignCheck;
        }
        else {

            # return with error
            return (
                {   Key   => 'Signed',
                    Value => '"PGP SIGNED MESSAGE" header found, but invalid!',
                }
            );
        }
    }

    # check mime pgp
    else {

        # check body
        # if body =~ application/pgp-encrypted
        # if crypted, decrypt it
        # remember that it was crypted!

        # write email to fs
        my $Message = $Self->{TicketObject}->ArticlePlain(
            ArticleID => $Self->{ArticleID},
            UserID    => $Self->{UserID},
        );
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

        # check if we need to decrypt it
        if (   $ContentType
            && $ContentType =~ /multipart\/encrypted/i
            && $ContentType =~ /application\/pgp/i )
        {

            # check sender (don't decrypt sent emails)
            if ( $Param{Article}->{SenderType} =~ /(agent|system)/i ) {

                # return info
                return (
                    {   Key        => 'Crypted',
                        Value      => 'Sent message crypted to recipient!',
                        Successful => 1,
                    }
                );
            }

            # decrypt
            my $Cryped = $Entity->parts(1)->as_string;

            # Encrypt it
            my %Decrypt = $Self->{CryptObject}->Decrypt( Message => $Cryped, );
            if ( $Decrypt{Successful} ) {
                $Entity = $parser->parse_data( $Decrypt{Data} );
                my $Head = $Entity->head();
                $Head->unfold();
                $Head->combine('Content-Type');
                $ContentType = $Head->get('Content-Type');

                use Kernel::System::EmailParser;

                my $ParserObject = Kernel::System::EmailParser->new( %{$Self}, Entity => $Entity, );

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

                push(
                    @Return,
                    {   Key   => 'Crypted',
                        Value => $Decrypt{Message},
                        %Decrypt,
                    },
                );
            }
            else {
                push(
                    @Return,
                    {   Key   => 'Crypted',
                        Value => $Decrypt{Message},
                        %Decrypt,
                    },
                );
            }
        }
        if (   $ContentType
            && $ContentType =~ /multipart\/signed/i
            && $ContentType =~ /application\/pgp/i )
        {
            my $SignedText    = $Entity->parts(0)->as_string();
            my $SignatureText = $Entity->parts(1)->body_as_string();

            # according to RFC3156 all line endings MUST be CR/LF
            $SignedText =~ s/\x0A/\x0D\x0A/g;
            $SignedText =~ s/\x0D+/\x0D/g;

            %SignCheck = $Self->{CryptObject}->Verify(
                Message => $SignedText,
                Sign    => $SignatureText,
            );
        }
    }
    if (%SignCheck) {

        # return result
        push(
            @Return,
            {   Key   => 'Signed',
                Value => $SignCheck{Message},
                %SignCheck,
            },
        );
    }
    return @Return;
}

sub Filter {
    my ( $Self, %Param ) = @_;

    # remove signature if one is found
    if ( $Self->{Result}->{SignatureFound} ) {

        # remove pgp begin signed message
        $Param{Article}->{Body} =~ s/^-----BEGIN\sPGP\sSIGNED\sMESSAGE-----.+?Hash:\s.+?$//sm;

        # remove pgp inline sign
        $Param{Article}->{Body}
            =~ s/^-----BEGIN\sPGP\sSIGNATURE-----.+?-----END\sPGP\sSIGNATURE-----//sm;
    }
    return 1;
}

1;
