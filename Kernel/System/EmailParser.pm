# --
# Kernel/System/EmailParser.pm - the global email parser module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: EmailParser.pm,v 1.62 2008-04-07 10:27:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::EmailParser;

use strict;
use warnings;
use Mail::Internet;
use MIME::Parser;
use MIME::QuotedPrint;
use MIME::Base64;
use MIME::Words qw(:all);
use Mail::Address;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.62 $) [1];

=head1 NAME

Kernel::System::EmailParser - parse and encode a email

=head1 SYNOPSIS

A module to parse and encode a email.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::EmailParser;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $ParseObject = Kernel::System::EmailParser->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        Email => \@ArrayOfEmail,
        Debug => 0,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get debug level from parent
    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    for (qw(LogObject ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # check needed objects
    if ( !$Param{Email} && !$Param{Entity} ) {
        die "Need Email or Entity!";
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    if ( $Param{Email} ) {

        # create Mail::Internet object
        $Self->{Email} = new Mail::Internet( $Param{Email} );

        # create a Mail::Header object with email
        $Self->{HeaderObject} = $Self->{Email}->head();

        # create MIME::Parser object and get message body or body of first attachemnt
        my $Parser = new MIME::Parser;
        $Parser->output_to_core("ALL");
        $Self->{ParserParts} = $Parser->parse_data( $Self->{Email}->as_string() );
    }
    else {
        $Self->{ParserParts} = $Param{Entity};
        $Self->{EntityMode}  = 1;
    }

    # get NoHTMLChecks param
    if ( $Param{NoHTMLChecks} ) {
        $Self->{NoHTMLChecks} = $Param{NoHTMLChecks};
    }

    # parse email at first
    $Self->GetMessageBody();

    return $Self;
}

=item GetPlainEmail()

To get a email as a string back (plain email).

    my $Email = $ParseObject->GetPlainEmail();

=cut

sub GetPlainEmail {
    my ($Self) = @_;

    return $Self->{Email}->as_string();
}

=item GetParam()

To get a header (e. g. Subject, To, ContentType, ...) of an email
(mime is already done!).

    my $To = $ParseObject->GetParam(WHAT => 'To');

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $What = $Param{WHAT} || return;

    $Self->{HeaderObject}->unfold();
    $Self->{HeaderObject}->combine($What);
    my $Line = $Self->{HeaderObject}->get($What) || '';
    chomp($Line);
    my $ReturnLine = '';
    my %Remember   = ();
    for my $Array ( decode_mimewords($Line) ) {
        for ( @{$Array} ) {

            # I don't know, but decode_mimewords() returns each mime
            # word two times! Remember to the old one. :-(
            if ( !$Remember{ $Array->[0] } ) {
                if ( $Array->[0] && $Array->[1] ) {
                    $Remember{ $Array->[0] } = 1;
                }

                # Workaround for OE problem:
                # If a header contains =?iso-8859-1?Q?Fr=F6hlich=2C_Roman?=
                # which is decoded ->Fröhlich, Roman<- which gets an problem
                # because this means two email addresses. We add " at
                # the start and at the end of this types of words mime.
                if ( $What =~ /^(From|To|Cc)/ && $Array->[1] ) {
                    if ( $Array->[0] !~ /^("|')/ && $Array->[0] =~ /,/ ) {
                        $Array->[0] = '"' . $Array->[0] . '"';
                        $Remember{ $Array->[0] } = 1;
                    }
                }
                $ReturnLine .= $Self->{EncodeObject}->Decode(
                    Text => $Array->[0],
                    From => $Array->[1] || $Self->GetCharset() || 'us-ascii',
                );
            }
            else {
                $Remember{ $Array->[0] } = undef;
            }
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => "Get: $What; ReturnLine: $ReturnLine; OrigLine: $Line",
        );
    }
    return $ReturnLine;
}

=item GetEmailAddress()

To get the senders email address back.

    my $SenderEmail = $ParseObject->GetEmailAddress(Email => 'Juergen Weber <juergen.qeber@air.com>');

=cut

sub GetEmailAddress {
    my ( $Self, %Param ) = @_;

    my $Email = '';
    for my $EmailSplit ( Mail::Address->parse( $Param{Email} ) ) {
        $Email = $EmailSplit->address();
    }
    return $Email;
}

=item SplitAddressLine()

To get an array of email addresses of an To, Cc or Bcc line back.

    my @Addresses = $ParseObject->SplitAddressLine(Line => 'Juergen Weber <juergen.qeber@air.com>, me@example.com, hans@example.com (Hans Huber)');

This returns an array with ('Juergen Weber <juergen.qeber@air.com>', 'me@example.com', 'hans@example.com (Hans Huber)').

=cut

sub SplitAddressLine {
    my ( $Self, %Param ) = @_;

    my @GetParam = ();
    for my $Line ( Mail::Address->parse( $Param{Line} ) ) {
        push( @GetParam, $Line->format() );
    }
    return @GetParam;
}

=item GetContentType()

Returns the message body (or from the first attachment) "ContentType" header.

    my $ContentType = $ParseObject->GetContentType();

(e. g. 'text/plain; charset="iso-8859-1"')

=cut

sub GetContentType {
    my ( $Self, $ContentType ) = @_;
    if ( !$ContentType ) {
        $ContentType = '';
    }

    if ( $Self->{ContentType} ) {
        return $Self->{ContentType};
    }
    else {
        return $Self->GetParam( WHAT => 'Content-Type' );
    }
}

=item GetCharset()

Returns the message body (or from the first attachment) "charset".

    my $Charset = $ParseObject->GetCharset();

(e. g. iso-8859-1, utf-8, ...)

=cut

sub GetCharset {
    my ( $Self, $ContentType ) = @_;
    if ( !$ContentType ) {
        $ContentType = '';
    }

    if ( defined( $Self->{Charset} ) ) {
        # debug
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Got charset from mime body: $Self->{Charset}",
            );
        }
        return $Self->{Charset};
    }
    else {
        $Self->{HeaderObject}->unfold();
        $Self->{HeaderObject}->combine('Content-Type');
        my $Line = $Self->{HeaderObject}->get('Content-Type') || '';
        chomp($Line);
        my %Data = $Self->GetContentTypeParams( ContentType => $Line );

        # check content type (only do charset decode if no Content-Type or ContentType
        # with text/* exists) if it's not a text content type (e. g. pdf, png, ...),
        # return no charset
        if ( $Data{ContentType} && $Data{ContentType} !~ /text/i) {

            # debug
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Got no charset from email body because of ContentType ($Data{ContentType})!",
                );
            }

            # remember to charset
            $Self->{Charset} = '';

            # return charset
            return '';
        }

        # return charset if it can be detected
        elsif ( $Data{Charset} ) {

            # debug
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Got charset from email body: $Data{Charset}",
                );
            }

            # remember to charset
            $Self->{Charset} = $Data{Charset};

            # return charset
            return $Data{Charset};
        }

        # if there is no available header for charset and content type, use
        # iso-8859-1 as charset
        else {

            # debug
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Got no charset from email body! Take iso-8859-1!",
                );
            }

            # remember to charset
            $Self->{Charset} = 'ISO-8859-1';

            # return charset
            return 'ISO-8859-1';
        }
    }
}

=item GetReturnContentType()

Returns the new message body (or from the first attachment) "ContentType" header
(maybe the message is converted to utf-8).

    my $ContentType = $ParseObject->GetReturnContentType();

(e. g. 'text/plain; charset="utf-8"')

=cut

sub GetReturnContentType {
    my ($Self) = @_;

    my $ContentType = $Self->GetContentType();
    if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
        my $InternalCharset = $Self->{EncodeObject}->EncodeInternalUsed();
        $ContentType =~ s/(charset=)(.*)/$1$InternalCharset/ig;

        # debug
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Changed ContentType from '" . $Self->GetContentType() . "' to '$ContentType'.",
            );
        }
        return $ContentType;
    }
    else {

        # debug
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Changed no ContentType",
            );
        }
        return $ContentType;
    }
}

=item GetReturnCharset()

Returns the charset of the new message body "Charset"
(maybe the message is converted to utf-8).

    my $Charset = $ParseObject->GetReturnCharset();

(e. g. 'text/plain; charset="utf-8"')

=cut

sub GetReturnCharset {
    my ($Self) = @_;

    my $ContentType = $Self->GetContentType();
    if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
        return $Self->{EncodeObject}->EncodeInternalUsed();
    }
    else {
        return $Self->GetCharset();
    }
}

=item GetMessageBody()

Returns the message body (or from the first attachment) from the email.

    my $Body = $ParseObject->GetMessageBody();

=cut

sub GetMessageBody {
    my ( $Self, %Param ) = @_;

    # check if message body is already there
    if ( $Self->{MessageBody} ) {
        return $Self->{MessageBody};
    }

    if ( !$Self->{EntityMode} && $Self->{ParserParts}->parts() == 0 ) {
        $Self->{MimeEmail} = 0;
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "It's a plain (not mime) email!",
            );
        }
        my $BodyStrg = join( '', @{ $Self->{Email}->body() } );

        # quoted printable!
        if ( $Self->GetParam( WHAT => 'Content-Transfer-Encoding' ) =~ /quoted-printable/i ) {
            $BodyStrg = MIME::QuotedPrint::decode($BodyStrg);
        }

        # base 64 encode
        elsif ( $Self->GetParam( WHAT => 'Content-Transfer-Encoding' ) =~ /base64/i ) {
            $BodyStrg = decode_base64($BodyStrg);
        }

        if ( $Self->GetCharset() ) {
            # charset decode
            $Self->{MessageBody} = $Self->{EncodeObject}->Decode(
                Text => $BodyStrg,
                From => $Self->GetCharset(),
            );
        }
        else {
             $Self->{MessageBody} = $BodyStrg;
        }

        # check if it's juat a html email (store it as attachment and add text/plain)
        $Self->CheckMessageBody();

        # return message body
        return $Self->{MessageBody};
    }
    else {
        $Self->{MimeEmail} = 1;
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "It's a mime email!",
            );
        }

        # check if there is an valid attachment there, if yes, return
        # first attachment (normally text/plain) as message body
        my @Attachments = $Self->GetAttachments();
        if ( @Attachments > 0 ) {
            $Self->{Charset}     = $Attachments[0]->{Charset};
            $Self->{ContentType} = $Attachments[0]->{ContentType};
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "First attachment ContentType: $Self->{ContentType}",
                );
            }

            # check if charset is given, set iso-8859-1 if content is text
            if ( !$Self->{Charset} && $Self->{ContentType} =~ /\btext\b/) {
                $Self->{Charset} = 'iso-8859-1';
            }

            # check if charset exists
            if ( $Self->GetCharset() ) {
                $Self->{MessageBody} = $Self->{EncodeObject}->Decode(
                    Text => $Attachments[0]->{Content},
                    From => $Self->GetCharset(),
                );
            }
            else {
                $Self->{Charset}     = 'us-ascii';
                $Self->{ContentType} = 'text/plain';
                $Self->{MessageBody} = '- no text message => see attachment -';
            }

            # check it it's juat a html email (store it as attachment and add text/plain)
            $Self->CheckMessageBody();

            # return message body
            return $Self->{MessageBody};
        }
        else {
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message =>
                        "No attachments returned from GetAttachments(), just a null attachment!?",
                );
            }

            # return empty attachment
            $Self->{Charset}     = 'iso-8859-1';
            $Self->{ContentType} = 'text/plain';
            return '-';
        }
    }
    return;
}

=item GetAttachments()

Returns an array of the email attachments.

    my @Attachments = $ParseObject->GetAttachments();
    for my $Attachment (@Attachments) {
        print $Attachment->{Filename};
        print $Attachment->{Charset};
        print $Attachment->{MimeType};
        print $Attachment->{ContentType};
        print $Attachment->{Content};
    }

=cut

sub GetAttachments {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{MimeEmail} ) {
        return;
    }
    elsif ( $Self->{Attachments} ) {
        return @{ $Self->{Attachments} };
    }
    else {
        $Self->PartsAttachments( Part => $Self->{ParserParts} );
        if ( $Self->{Attachments} ) {
            return @{ $Self->{Attachments} };
        }
        else {
            return;
        }
    }
}

# just for internal
sub PartsAttachments {
    my ( $Self, %Param ) = @_;

    my $Part           = $Param{Part}           || $Self->{ParserParts};
    my $PartCounter    = $Param{PartCounter}    || 0;
    my $SubPartCounter = $Param{SubPartCounter} || 0;
    $Self->{PartCounter}++;
    if ( $Part->parts() > 0 ) {
        $PartCounter++;
        for ( $Part->parts() ) {
            $SubPartCounter++;
            if ( $Self->{Debug} > 0 ) {
                print STDERR "Sub part($PartCounter/$SubPartCounter)!\n";
            }
            $Self->PartsAttachments( Part => $_, PartCounter => $PartCounter );
        }
        return 1;
    }
    else {

        # get attachment meta stuff
        my %PartData = ();

        # get ContentType
        $Part->head()->unfold();
        $Part->head()->combine('Content-Type');

        # get Content-Type, use text/plain if no content type is given
        $PartData{ContentType} = $Part->head()->get('Content-Type') || 'text/plain;';
        chomp( $PartData{ContentType} );

        # get mime type
        $PartData{MimeType} = $Part->head()->mime_type();

        # get charset
        my %Data = $Self->GetContentTypeParams( ContentType => $PartData{ContentType} );
        if ( $Data{Charset} ) {
            $PartData{Charset} = $Data{Charset};
        }
        else {
            $PartData{Charset} = '';
        }

        # get content (if possible)
        if ( $Part->bodyhandle() ) {
            $PartData{Content} = $Part->bodyhandle()->as_string();
            if ( !$PartData{Content} ) {
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Totally empty attachment part ($PartCounter)",
                );
                return;
            }
        }

        # log error if there is an corrupt MIME email
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Was not able to parse corrupt MIME email! Skipped attachment ($PartCounter)",
            );
            return;
        }

        # check if there is no recommended_filename -> add file-NoFilenamePartCounter
        if ( !$Part->head()->recommended_filename() ) {
            $Self->{NoFilenamePartCounter}++;
            $PartData{Filename} = "file-$Self->{NoFilenamePartCounter}";
        }
        else {
            $PartData{Filename} = decode_mimewords( $Part->head()->recommended_filename() );
            $PartData{ContentDisposition} = $Part->head()->get('Content-Disposition');
            if ( $PartData{ContentDisposition} ) {
                my %Data = $Self->GetContentTypeParams(
                    ContentType => $PartData{ContentDisposition},
                );
                if ( $Data{Charset} ) {
                    $PartData{Charset} = $Data{Charset};
                }
            }
            else {
                $PartData{Charset} = '';
            }

            # convert the file name in utf-8 if utf-8 is used
            if ( $PartData{Charset} ) {
                $PartData{Filename} = $Self->{EncodeObject}->Decode(
                    Text => $PartData{Filename},
                    From => $PartData{Charset},
                );
            }
        }

        # debug
        if ( $Self->{Debug} > 0 ) {
            print STDERR "->GotArticle::Atm: '$PartData{Filename}' '$PartData{ContentType}'\n";
        }

        # get attachment size
        {
            use bytes;
            $PartData{Filesize} = length( $PartData{Content} );
            no bytes;
        }

        # store data
        push( @{ $Self->{Attachments} }, \%PartData );
        return 1;
    }
}

=item GetReferences()

To get an array of reference ids of the parsed email

    my @References = $ParseObject->GetReferences();

This returns an array with ('fasfda@host.de', '4124.2313.1231@host.com').

=cut

sub GetReferences {
    my ( $Self, %Param ) = @_;

    my @ReferencesAll = ();
    my @References    = ();

    # get references ids
    my $ReferencesString = $Self->GetParam( WHAT => 'References' );
    if ($ReferencesString) {
        push( @ReferencesAll, ( $ReferencesString =~ /<([^>]+)>/g ) );
    }

    # get in reply to id
    my $InReplyToString = $Self->GetParam( WHAT => 'In-Reply-To' );
    if ($InReplyToString) {
        chomp $InReplyToString;
        $InReplyToString =~ s/.*?<([^>]+)>.*/$1/;
        push( @ReferencesAll, $InReplyToString );
    }
    my %Checked = ();

    # get uniq
    for ( reverse @ReferencesAll ) {
        if ( !$Checked{$_} ) {
            push( @References, $_ );
        }
        $Checked{$_} = 1;
    }
    return @References;
}

# just for internal
sub GetContentTypeParams {
    my ( $Self, %Param ) = @_;

    my $ContentType = $Param{ContentType} || return;
    if ( $Param{ContentType} =~ /charset=.+?/i ) {
        $Param{Charset} = $Param{ContentType};
        $Param{Charset} =~ s/.+?charset=("|'|)(\w+)/$2/gi;
        $Param{Charset} =~ s/"|'//g;
        $Param{Charset} =~ s/(.+?);.*/$1/g;
    }
    if ( !$Param{Charset} ) {
        if ( $Param{ContentType} =~ /\?(iso-\d{3,4}-(\d{1,2}|[A-z]{1,2})|utf(-8|8)|windows-\d{3,5}|koi8-.+?|cp(-|)\d{2,4}|big5(|.+?)|shift(_|-)jis|euc-.+?|tcvn|visii|vps|gb.+?)\?/i ) {
            $Param{Charset} = $1;
        }
        elsif ( $Param{ContentType} =~ /name\*0\*=(utf-8|utf8)/i ) {
            $Param{Charset} = $1;
        }
        elsif ( $Param{ContentType} =~ /filename\*=(iso-\d{3,4}-(\d{1,2}|[A-z]{1,2})|utf(-8|8)|windows-\d{3,5}|koi8-.+?|cp(-|)\d{2,4}|big5(|.+?)|shift(_|-)jis|euc-.+?|tcvn|visii|vps|gb.+?)''/i ) {
            $Param{Charset} = $1;
        }
    }
    if ( $Param{ContentType} =~ /^(\w+\/\w+)/i ) {
        $Param{MimeType} = $1;
        $Param{MimeType} =~ s/"|'//g;
    }
    return %Param;
}

# just for internal
sub CheckMessageBody {
    my ( $Self, %Param ) = @_;

    # if already checked, just return
    if (   $Self->{MessageChecked}
        || !$Self->{ConfigObject}->Get('PostmasterAutoHTML2Text')
        || $Self->{NoHTMLChecks} )
    {
        return;
    }

    # check it it's juat a html email (store it as attachment and add text/plain)
    if ( $Self->GetReturnContentType() =~ /text\/html/i ) {
        $Self->{MessageChecked} = 1;

        # add html email as attachment (if needed)
        if ( !$Self->{MimeEmail} ) {
            push(
                @{ $Self->{Attachments} },
                {   Charset     => $Self->GetCharset(),
                    ContentType => $Self->GetReturnContentType(),
                    Content     => $Self->{MessageBody},
                    Filename    => 'orig-html-email.html',
                }
            );
        }

        # remember to html file if not aleady there
        else {
            if ( $Self->{Attachments}->[0]->{Filename} ) {
                if ( $Self->{Attachments}->[0]->{Filename} !~ /\.(htm|html)/i ) {
                    $Self->{Attachments}->[0]->{Filename} .= '.html';
                }
            }
        }

        # remember to be an mime email now
        $Self->{MimeEmail} = 1;

        # html2text filter for message body
        my $LinkList = '';
        my $Counter  = 0;

        # find <a href=....> and replace it with [x]
        $Self->{MessageBody} =~ s{
            <a\Whref=("|')(.+?)("|')(|.+?)>
        }
        {
            my $Link = $2;
            if ($Link !~ /^(......|.....|....|...):/i) {
                $Link = $Param{URL}.$Link;
            }
            $Counter++;
            $LinkList .= "[$Counter] $Link\n";
            "[$Counter]";
        }egxi;

        # remove empty lines
        $Self->{MessageBody} =~ s/^\s*//mg;
        $Self->{MessageBody} =~ s/\n//gs;

        # remove style tags
        $Self->{MessageBody} =~ s/\<style.+?\>.*\<\/style\>//gsi;

        # remove br tags and replace it with \n
        $Self->{MessageBody} =~ s/\<br(\/|)\>/\n/gsi;

        # remove hr tags and replace it with \n
        $Self->{MessageBody} =~ s/\<(hr|hr.+?)\>/\n\n/gsi;

        # remove pre, p, table, code tags and replace it with \n
        $Self->{MessageBody} =~ s/\<(\/|)(pre|pre.+?|p|p.+?|table|table.+?|code|code.+?)\>/\n\n/gsi;

        # remove tr, th tags and replace it with \n
        $Self->{MessageBody} =~ s/\<(tr|tr.+?|th|th.+?)\>/\n\n/gsi;

        # remove td tags and replace it with \n
        $Self->{MessageBody} =~ s/\.+?<\/(td|td.+?)\>/ /gsi;

        # strip all other tags
        $Self->{MessageBody} =~ s/\<.+?\>//gs;

        # replace "  " with " " space
        $Self->{MessageBody} =~ s/  / /mg;

        # html encode based from cpan's HTML::Entities v1.35
        my %Entity = (

            # Some normal chars that have special meaning in SGML context
            amp  => '&',    # ampersand
            'gt' => '>',    # greater than
            'lt' => '<',    # less than
            quot => '"',    # double quote
            apos => "'",    # single quote

            # PUBLIC ISO 8879-1986//ENTITIES Added Latin 1//EN//HTML
            AElig  => chr(198),    # capital AE diphthong (ligature)
            Aacute => chr(193),    # capital A, acute accent
            Acirc  => chr(194),    # capital A, circumflex accent
            Agrave => chr(192),    # capital A, grave accent
            Aring  => chr(197),    # capital A, ring
            Atilde => chr(195),    # capital A, tilde
            Auml   => chr(196),    # capital A, dieresis or umlaut mark
            Ccedil => chr(199),    # capital C, cedilla
            ETH    => chr(208),    # capital Eth, Icelandic
            Eacute => chr(201),    # capital E, acute accent
            Ecirc  => chr(202),    # capital E, circumflex accent
            Egrave => chr(200),    # capital E, grave accent
            Euml   => chr(203),    # capital E, dieresis or umlaut mark
            Iacute => chr(205),    # capital I, acute accent
            Icirc  => chr(206),    # capital I, circumflex accent
            Igrave => chr(204),    # capital I, grave accent
            Iuml   => chr(207),    # capital I, dieresis or umlaut mark
            Ntilde => chr(209),    # capital N, tilde
            Oacute => chr(211),    # capital O, acute accent
            Ocirc  => chr(212),    # capital O, circumflex accent
            Ograve => chr(210),    # capital O, grave accent
            Oslash => chr(216),    # capital O, slash
            Otilde => chr(213),    # capital O, tilde
            Ouml   => chr(214),    # capital O, dieresis or umlaut mark
            THORN  => chr(222),    # capital THORN, Icelandic
            Uacute => chr(218),    # capital U, acute accent
            Ucirc  => chr(219),    # capital U, circumflex accent
            Ugrave => chr(217),    # capital U, grave accent
            Uuml   => chr(220),    # capital U, dieresis or umlaut mark
            Yacute => chr(221),    # capital Y, acute accent
            aacute => chr(225),    # small a, acute accent
            acirc  => chr(226),    # small a, circumflex accent
            aelig  => chr(230),    # small ae diphthong (ligature)
            agrave => chr(224),    # small a, grave accent
            aring  => chr(229),    # small a, ring
            atilde => chr(227),    # small a, tilde
            auml   => chr(228),    # small a, dieresis or umlaut mark
            ccedil => chr(231),    # small c, cedilla
            eacute => chr(233),    # small e, acute accent
            ecirc  => chr(234),    # small e, circumflex accent
            egrave => chr(232),    # small e, grave accent
            eth    => chr(240),    # small eth, Icelandic
            euml   => chr(235),    # small e, dieresis or umlaut mark
            iacute => chr(237),    # small i, acute accent
            icirc  => chr(238),    # small i, circumflex accent
            igrave => chr(236),    # small i, grave accent
            iuml   => chr(239),    # small i, dieresis or umlaut mark
            ntilde => chr(241),    # small n, tilde
            oacute => chr(243),    # small o, acute accent
            ocirc  => chr(244),    # small o, circumflex accent
            ograve => chr(242),    # small o, grave accent
            oslash => chr(248),    # small o, slash
            otilde => chr(245),    # small o, tilde
            ouml   => chr(246),    # small o, dieresis or umlaut mark
            szlig  => chr(223),    # small sharp s, German (sz ligature)
            thorn  => chr(254),    # small thorn, Icelandic
            uacute => chr(250),    # small u, acute accent
            ucirc  => chr(251),    # small u, circumflex accent
            ugrave => chr(249),    # small u, grave accent
            uuml   => chr(252),    # small u, dieresis or umlaut mark
            yacute => chr(253),    # small y, acute accent
            yuml   => chr(255),    # small y, dieresis or umlaut mark

            # Some extra Latin 1 chars that are listed in the HTML3.2 draft (21-May-96)
            copy => chr(169),      # copyright sign
            reg  => chr(174),      # registered sign
            nbsp => chr(160),      # non breaking space

            # Additional ISO-8859/1 entities listed in rfc1866 (section 14)
            iexcl   => chr(161),
            cent    => chr(162),
            pound   => chr(163),
            curren  => chr(164),
            yen     => chr(165),
            brvbar  => chr(166),
            sect    => chr(167),
            uml     => chr(168),
            ordf    => chr(170),
            laquo   => chr(171),
            'not'   => chr(172),    # not is a keyword in perl
            shy     => chr(173),
            macr    => chr(175),
            deg     => chr(176),
            plusmn  => chr(177),
            sup1    => chr(185),
            sup2    => chr(178),
            sup3    => chr(179),
            acute   => chr(180),
            micro   => chr(181),
            para    => chr(182),
            middot  => chr(183),
            cedil   => chr(184),
            ordm    => chr(186),
            raquo   => chr(187),
            frac14  => chr(188),
            frac12  => chr(189),
            frac34  => chr(190),
            iquest  => chr(191),
            'times' => chr(215),    # times is a keyword in perl
            divide  => chr(247),

            (   $] > 5.007
                ? ( OElig    => chr(338),
                    oelig    => chr(339),
                    Scaron   => chr(352),
                    scaron   => chr(353),
                    Yuml     => chr(376),
                    fnof     => chr(402),
                    circ     => chr(710),
                    tilde    => chr(732),
                    Alpha    => chr(913),
                    Beta     => chr(914),
                    Gamma    => chr(915),
                    Delta    => chr(916),
                    Epsilon  => chr(917),
                    Zeta     => chr(918),
                    Eta      => chr(919),
                    Theta    => chr(920),
                    Iota     => chr(921),
                    Kappa    => chr(922),
                    Lambda   => chr(923),
                    Mu       => chr(924),
                    Nu       => chr(925),
                    Xi       => chr(926),
                    Omicron  => chr(927),
                    Pi       => chr(928),
                    Rho      => chr(929),
                    Sigma    => chr(931),
                    Tau      => chr(932),
                    Upsilon  => chr(933),
                    Phi      => chr(934),
                    Chi      => chr(935),
                    Psi      => chr(936),
                    Omega    => chr(937),
                    alpha    => chr(945),
                    beta     => chr(946),
                    gamma    => chr(947),
                    delta    => chr(948),
                    epsilon  => chr(949),
                    zeta     => chr(950),
                    eta      => chr(951),
                    theta    => chr(952),
                    iota     => chr(953),
                    kappa    => chr(954),
                    lambda   => chr(955),
                    mu       => chr(956),
                    nu       => chr(957),
                    xi       => chr(958),
                    omicron  => chr(959),
                    pi       => chr(960),
                    rho      => chr(961),
                    sigmaf   => chr(962),
                    sigma    => chr(963),
                    tau      => chr(964),
                    upsilon  => chr(965),
                    phi      => chr(966),
                    chi      => chr(967),
                    psi      => chr(968),
                    omega    => chr(969),
                    thetasym => chr(977),
                    upsih    => chr(978),
                    piv      => chr(982),
                    ensp     => chr(8194),
                    emsp     => chr(8195),
                    thinsp   => chr(8201),
                    zwnj     => chr(8204),
                    zwj      => chr(8205),
                    lrm      => chr(8206),
                    rlm      => chr(8207),
                    ndash    => chr(8211),
                    mdash    => chr(8212),
                    lsquo    => chr(8216),
                    rsquo    => chr(8217),
                    sbquo    => chr(8218),
                    ldquo    => chr(8220),
                    rdquo    => chr(8221),
                    bdquo    => chr(8222),
                    dagger   => chr(8224),
                    Dagger   => chr(8225),
                    bull     => chr(8226),
                    hellip   => chr(8230),
                    permil   => chr(8240),
                    prime    => chr(8242),
                    Prime    => chr(8243),
                    lsaquo   => chr(8249),
                    rsaquo   => chr(8250),
                    oline    => chr(8254),
                    frasl    => chr(8260),
                    euro     => chr(8364),
                    image    => chr(8465),
                    weierp   => chr(8472),
                    real     => chr(8476),
                    trade    => chr(8482),
                    alefsym  => chr(8501),
                    larr     => chr(8592),
                    uarr     => chr(8593),
                    rarr     => chr(8594),
                    darr     => chr(8595),
                    harr     => chr(8596),
                    crarr    => chr(8629),
                    lArr     => chr(8656),
                    uArr     => chr(8657),
                    rArr     => chr(8658),
                    dArr     => chr(8659),
                    hArr     => chr(8660),
                    forall   => chr(8704),
                    part     => chr(8706),
                    exist    => chr(8707),
                    empty    => chr(8709),
                    nabla    => chr(8711),
                    isin     => chr(8712),
                    notin    => chr(8713),
                    ni       => chr(8715),
                    prod     => chr(8719),
                    sum      => chr(8721),
                    minus    => chr(8722),
                    lowast   => chr(8727),
                    radic    => chr(8730),
                    prop     => chr(8733),
                    infin    => chr(8734),
                    ang      => chr(8736),
                    'and'    => chr(8743),
                    'or'     => chr(8744),
                    cap      => chr(8745),
                    cup      => chr(8746),
                    'int'    => chr(8747),
                    there4   => chr(8756),
                    sim      => chr(8764),
                    cong     => chr(8773),
                    asymp    => chr(8776),
                    'ne'     => chr(8800),
                    equiv    => chr(8801),
                    'le'     => chr(8804),
                    'ge'     => chr(8805),
                    'sub'    => chr(8834),
                    sup      => chr(8835),
                    nsub     => chr(8836),
                    sube     => chr(8838),
                    supe     => chr(8839),
                    oplus    => chr(8853),
                    otimes   => chr(8855),
                    perp     => chr(8869),
                    sdot     => chr(8901),
                    lceil    => chr(8968),
                    rceil    => chr(8969),
                    lfloor   => chr(8970),
                    rfloor   => chr(8971),
                    lang     => chr(9001),
                    rang     => chr(9002),
                    loz      => chr(9674),
                    spades   => chr(9824),
                    clubs    => chr(9827),
                    hearts   => chr(9829),
                    diams    => chr(9830),
                    )
                : ()
            )
        );

        # encode html entities like "&#8211;"
        $Self->{MessageBody} =~ s{
            (&\#(\d+);?)
        }
        {
            my $Chr = chr( $2 );
            if ( $Chr ) {
                $Chr;
            }
            else {
                $1;
            };
        }egx;

        # encode html entities like "&#3d;"
        $Self->{MessageBody} =~ s{
            (&\#[xX]([0-9a-fA-F]+);?)
        }
        {
            my $ChrOrig = $1;
            my $Hex = hex( $2 );
            if ( $Hex ) {
                my $Chr = chr( $Hex );
                if ( $Chr ) {
                    $Chr;
                }
                else {
                    $ChrOrig;
                }
            }
            else {
                $ChrOrig;
            }
        }egx;

        # encode html entities like "&amp;"
        $Self->{MessageBody} =~ s{
            (&(\w+);?)
        }
        {
            if ( $Entity{$2} ) {
                $Entity{$2};
            }
            else {
                $1;
            }
        }egx;

        # remove empty lines
        $Self->{MessageBody} =~ s/^\s*\n\s*\n/\n/mg;

        # force line bracking
        $Self->{MessageBody} =~ s/(.{4,78})(?:\s|\z)/$1\n/gm;

        # add extracted links
        $Self->{MessageBody} .= "\n\n" . $LinkList;

        $Self->{ContentType} = 'text/plain';
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "It's an html only email, added ascii dump, attached html email as attachment.",
            );
        }
    }
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=head1 VERSION

$Revision: 1.62 $ $Date: 2008-04-07 10:27:39 $

=cut
