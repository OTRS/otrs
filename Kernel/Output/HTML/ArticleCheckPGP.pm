# --
# Kernel/Output/HTML/ArticleCheckPGP.pm
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleCheckPGP.pm,v 1.1 2004-07-30 09:55:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleCheckPGP;

use strict;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{CryptObject} = Kernel::System::Crypt->new(%Param, CryptType => 'PGP');
    return $Self;
}
# --
sub Check {
    my $Self = shift;
    my %Param = @_;
    my %SignCheck = ();
    my @Return = ();
    # check if article is an email
    if ($Param{Article}->{ArticleType} !~ /email/i) {
        return;
    }
    # check inline pgp
    if ($Param{Article}->{Body} =~ /^-----BEGIN PGP SIGNED MESSAGE-----/) {
        %SignCheck = $Self->{CryptObject}->Verify(Message => $Param{Article}->{Body});
        if (%SignCheck) {
            # remember to result
            $Self->{Result} = \%SignCheck;
        }
        else {
            # return with error
            return ({
                Key => 'Signed',
                Value => '"PGP SIGNED MESSAGE" header found, but invalid!',
            });
        }
    }
    # check mime pgp
    else {
        # write email to fs
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
        my $entity = $parser->parse_data($Message);
#print STDERR "+++ ".$entity->mime_type()."\n";
#        if ( $entity->effective_type() eq 'multipart/signed' ) {
        my $Head = $entity->head();
        $Head->unfold();
        $Head->combine('Content-Type');
        my $ContentType = $Head->get('Content-Type');
        # check if we need to decrypt it
        if ($ContentType && $ContentType =~ /multipart\/encrypted/i && $ContentType =~ /application\/pgp/i) {
            # decrypt
            my $Cryped = $entity->parts(1)->as_string;
            # Encrypt it
            my %Decrypt = $Self->{CryptObject}->Decrypt(
                Message => $Cryped,
            );
            if ($Decrypt{Successful}) {
                $entity = $parser->parse_data($Decrypt{Data});
                my $Head = $entity->head();
                $Head->unfold();
                $Head->combine('Content-Type');
                $ContentType = $Head->get('Content-Type');
print STDERR "$ContentType--\n";
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
        if ($ContentType && $ContentType =~ /multipart\/signed/i && $ContentType =~ /application\/pgp/i) {
#    $parser->decode_bodies(0);
            my $signed_text    = $entity->parts(0)->as_string;
            my $signature_text = $entity->parts(1)->body_as_string;
            # according to RFC3156 all line endings MUST be CR/LF
            $signed_text =~ s/\x0A/\x0D\x0A/g;
            $signed_text =~ s/\x0D+/\x0D/g;

            %SignCheck = $Self->{CryptObject}->Verify(
                Message => $signed_text,
                Sign => $signature_text,
            );
        }
    }
    if (%SignCheck) {
       # return result
       push (@Return, {
           Key => 'Signed',
           Value => $SignCheck{Message},
           %SignCheck,
           }
       );
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
        $Param{Article}->{Body} =~ s/^-----BEGIN\sPGP\sSIGNED\sMESSAGE-----.+?Hash:\s.+?$//sm;
        # remove pgp inline sign
        $Param{Article}->{Body} =~ s/^-----BEGIN\sPGP\sSIGNATURE-----.+?-----END\sPGP\sSIGNATURE-----//sm;
    }
}
# --
1;
