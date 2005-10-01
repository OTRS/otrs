# --
# Kernel/Output/HTML/ArticleCheckSMIME.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleCheckSMIME.pm,v 1.5 2005-10-01 13:13:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleCheckSMIME;

use strict;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ArticleID)) {
        if ($Param{$_}) {
            $Self->{$_} = $Param{$_};
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
#            return;
        }
    }
    $Self->{CryptObject} = Kernel::System::Crypt->new(%Param, CryptType => 'SMIME');
    return $Self;
}
# --
sub Check {
    my $Self = shift;
    my %Param = @_;
    my %SignCheck = ();
    my @Return = ();
    # check if pgp is enabled
    if (!$Self->{ConfigObject}->Get('SMIME')) {
        return;
    }
    # check if article is an email
    if ($Param{Article}->{ArticleType} !~ /email/i) {
        return;
    }
    # check inline smime
    if ($Param{Article}->{Body} =~ /^-----BEGIN PKCS7-----/) {
        %SignCheck = $Self->{CryptObject}->Verify(Message => $Param{Article}->{Body});
        if (%SignCheck) {
            # remember to result
            $Self->{Result} = \%SignCheck;
        }
        else {
            # return with error
            push (@Return, {
                Key => 'Signed',
                Value => '"SMIME SIGNED MESSAGE" header found, but invalid!',
            });
        }
    }
    # check smime
    else {
        # get email from fs
        my $Message = $Self->{TicketObject}->ArticlePlain(
            ArticleID => $Self->{ArticleID},
            UserID => $Self->{UserID},
        );
        use MIME::Parser;
        my $parser = MIME::Parser->new();
#        $parser->decode_bodies(0);
        $parser->decode_headers(0);
        $parser->extract_nested_messages(0);
        $parser->output_to_core("ALL");
        my $Entity = $parser->parse_data($Message);
        my $Head = $Entity->head();
        $Head->unfold();
        $Head->combine('Content-Type');
        my $ContentType = $Head->get('Content-Type');
       if ($ContentType && $ContentType =~ /application\/(x-pkcs7|pkcs7)-mime/i && $ContentType !~ /signed/i) {
            # check sender (don't decrypt sent emails)
            if ($Param{Article}->{SenderType} =~ /(agent|system)/i) {
                # return info
                return ({
                    Key => 'Crypted',
                    Value => 'Sent message crypted to recipient!',
                    Successful => 1,
                });
            }
            # decrypt
            my %Decrypt = $Self->{CryptObject}->Decrypt(
                Message => $Message,
                Cert => 123,
                Key => 123,
            );
            if ($Decrypt{Successful}) {
                $Entity = $parser->parse_data($Decrypt{Data});
                my $Head = $Entity->head();
                $Head->unfold();
                $Head->combine('Content-Type');
                $ContentType = $Head->get('Content-Type');
#print STDERR "$ContentType--\n";
                push (@Return, {
                    Key => 'Crypted',
                    Value => $Decrypt{Message},
                    %Decrypt,
                    },
                );
            }
            else {
                push (@Return, {
                    Key => 'Crypted',
                    Value => $Decrypt{Message},
                    %Decrypt,
                  },
                );
            }
        }
        if ($ContentType && $ContentType =~ /application\/(x-pkcs7|pkcs7)/i && $ContentType =~ /signed/i) {
            # check sign and get clear content
            %SignCheck = $Self->{CryptObject}->Verify(
                Message => $Message,
            );
            # parse and update clear content
            if (%SignCheck && $SignCheck{Successful} && $SignCheck{Content}) {
                use Kernel::System::EmailParser;

                my @Email = ();
                my @Lines = split(/\n/, $SignCheck{Content});
                foreach (@Lines) {
                    push (@Email, $_."\n");
                }
                my $ParserObject = Kernel::System::EmailParser->new(
                    %{$Self},
                    Email => \@Email,
                );
                my $Body = $ParserObject->GetMessageBody();
                # updated article body
                $Self->{TicketObject}->ArticleUpdate(
                    ArticleID => $Self->{ArticleID},
                    Key => 'Body',
                    Value => $Body,
                    UserID => $Self->{UserID},
                );
                # delete crypted attachments
                $Self->{TicketObject}->ArticleDeleteAttachment(
                    ArticleID => $Self->{ArticleID},
                    UserID => $Self->{UserID},
                );
                # write attachments to the storage
                foreach my $Attachment ($ParserObject->GetAttachments()) {
                    $Self->{TicketObject}->ArticleWriteAttachment(
                        Content => $Attachment->{Content},
                        Filename => $Attachment->{Filename},
                        ContentType => $Attachment->{ContentType},
                        ArticleID => $Self->{ArticleID},
                        UserID => $Self->{UserID},
                    );
                }
            }
        }
    }
    if (%SignCheck) {
       # return result
       push (@Return, {
           Key => 'Signed',
           Value => $SignCheck{Message},
           %SignCheck,
       });
    }
    return @Return;
}
# --
sub Filter {
    my $Self = shift;
    my %Param = @_;
    # remove signature if one is found
    if ($Self->{Result}->{SignatureFound}) {
        # remove pgp begin signed message
        $Param{Article}->{Body} =~ s/^-----BEGIN\sPKCS7-----.+?Hash:\s.+?$//sm;
        # remove pgp inline sign
        $Param{Article}->{Body} =~ s/^-----END\sPKCS7-----//sm;
    }
}
# --
1;
