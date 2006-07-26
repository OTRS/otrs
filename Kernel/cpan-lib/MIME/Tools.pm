package MIME::Tools;

#------------------------------
# Because the POD documenation is pretty extensive, it follows
# the __END__ statement below...
#------------------------------

use strict;
use vars (qw(@ISA %CONFIG @EXPORT_OK %EXPORT_TAGS $VERSION $ME
	     $M_DEBUG $M_WARNING $M_ERROR
	     $Tmpopen ));

require Exporter;
use FileHandle;
use Carp;
use Benchmark;

$ME = "MIME-tools";

@ISA = qw(Exporter);

# Exporting (importing should only be done by modules in this toolkit!):
%EXPORT_TAGS = (
    'config'  => [qw(%CONFIG)],
    'msgs'    => [qw(usage debug whine error)],
    'msgtypes'=> [qw($M_DEBUG $M_WARNING $M_ERROR)],		
    'utils'   => [qw(catfile shellquote textual_type tmpopen )],
    );
Exporter::export_ok_tags('config', 'msgs', 'msgtypes', 'utils');

# The TOOLKIT version, both in 1.23 style *and* usable by MakeMaker:
$VERSION = "5.420";

# Configuration (do NOT alter this directly)...
# All legal CONFIG vars *must* be in here, even if only to be set to undef:
%CONFIG =
    (
     DEBUGGING       => 0,
     QUIET           => 1,
     );

# Message-logging constants:
$M_DEBUG   = 'debug';
$M_WARNING = 'warning';
$M_ERROR   = 'error';



#------------------------------
#
# CONFIGURATION... (see below)
#
#------------------------------

sub config {
    my $class = shift;
    usage("config() is obsolete");

    # No args? Just return list:
    @_ or return keys %CONFIG;
    my $method = lc(shift);
    return $class->$method(@_);
}

sub debugging {
    my ($class, $value) = @_;
    $CONFIG{'DEBUGGING'} = $value   if (@_ > 1);
    return $CONFIG{'DEBUGGING'};
}

sub quiet {
    my ($class, $value) = @_;
    $CONFIG{'QUIET'} = $value   if (@_ > 1);
    return $CONFIG{'QUIET'};
}

sub version {
    my ($class, $value) = @_;
    return $VERSION;
}



#------------------------------
#
# MESSAGES...
#
#------------------------------

#------------------------------
#
# debug MESSAGE...
#
# Function, private.
# Output a debug message.
#
sub debug {
    print STDERR "$ME: $M_DEBUG: ", @_, "\n"      if $CONFIG{DEBUGGING};
}

#------------------------------
#
# whine MESSAGE...
#
# Function, private.
# Something doesn't look right: issue a warning.
# Only output if $^W (-w) is true, and we're not being QUIET.
#
sub whine {
    my $msg = "$ME: $M_WARNING: ".join('', @_)."\n";
    warn $msg if ($^W && !$CONFIG{QUIET});
    return (wantarray ? () : undef);
}

#------------------------------
#
# error MESSAGE...
#
# Function, private.
# Something failed, but not so badly that we want to throw an
# exception.  Just report our general unhappiness.
# Only output if $^W (-w) is true, and we're not being QUIET.
#
sub error {
    my $msg = "$ME: $M_ERROR: ".join('', @_)."\n";
    warn $msg if ($^W && !$CONFIG{QUIET});
    return (wantarray ? () : undef);
}

#------------------------------
#
# usage MESSAGE...
#
# Register unhappiness about usage.
#
sub usage {
    my ( $p,  $f,  $l,  $s) = caller(1);
    my ($cp, $cf, $cl, $cs) = caller(2);
    my $msg = join('', (($s =~ /::/) ? "$s() " : "${p}::$s() "), @_, "\n");
    my $loc = ($cf ? "\tin code called from $cf l.$cl" : '');

    warn "$msg$loc\n" if ($^W && !$CONFIG{QUIET});
    return (wantarray ? () : undef);
}



#------------------------------
#
# UTILS...
#
#------------------------------

#------------------------------
#
# catfile DIR, FILE
#
# Directory/file concatenation.
#
sub catfile {
    my ($parent, $child) = @_;
    if ($^O eq 'Mac') {
	$parent =~ s{:\Z}{};
	return "$parent:$child";
    }
    else {
	$parent =~ s{/\Z}{};
	return "$parent/$child";
    }
}

#------------------------------
#
# shellquote STRING
#
# Private utility: make string safe for shell.
#
sub shellquote {
    my $str = shift;
    $str =~ s/\$/\\\$/g;
    $str =~ s/\`/\\`/g;
    $str =~ s/\"/\\"/g;
    return "\"$str\"";        # wrap in double-quotes
}

#------------------------------
#
# textual_type MIMETYPE
#
# Function.  Does the given MIME type indicate a textlike document?
#
sub textual_type {
    ($_[0] =~ m{^(text|message)(/|\Z)}i);
}

#------------------------------
#
# tmpopen
#
#
sub tmpopen {
    &$Tmpopen();
}

$Tmpopen = sub { IO::File->new_tmpfile; };





#------------------------------
1;
package MIME::ToolUtils;
@MIME::ToolUtils::ISA = qw(MIME::Tools);
__END__


=head1 NAME

MIME-tools - modules for parsing (and creating!) MIME entities


=head1 SYNOPSIS

Here's some pretty basic code for B<parsing a MIME message,> and outputting
its decoded components to a given directory:

    use MIME::Parser;

    ### Create parser, and set some parsing options:
    my $parser = new MIME::Parser;
    $parser->output_under("$ENV{HOME}/mimemail");

    ### Parse input:
    $entity = $parser->parse(\*STDIN) or die "parse failed\n";

    ### Take a look at the top-level entity (and any parts it has):
    $entity->dump_skeleton;


Here's some code which B<composes and sends a MIME message> containing
three parts: a text file, an attached GIF, and some more text:

    use MIME::Entity;

    ### Create the top-level, and set up the mail headers:
    $top = MIME::Entity->build(Type    =>"multipart/mixed",
                               From    => "me\@myhost.com",
	                       To      => "you\@yourhost.com",
                               Subject => "Hello, nurse!");

    ### Part #1: a simple text document:
    $top->attach(Path=>"./testin/short.txt");

    ### Part #2: a GIF file:
    $top->attach(Path        => "./docs/mime-sm.gif",
                 Type        => "image/gif",
                 Encoding    => "base64");

    ### Part #3: some literal text:
    $top->attach(Data=>$message);

    ### Send it:
    open MAIL, "| /usr/lib/sendmail -t -oi -oem" or die "open: $!";
    $top->print(\*MAIL);
    close MAIL;


For more examples, look at the scripts in the B<examples> directory
of the MIME-tools distribution.



=head1 DESCRIPTION

MIME-tools is a collection of Perl5 MIME:: modules for parsing, decoding,
I<and generating> single- or multipart (even nested multipart) MIME
messages.  (Yes, kids, that means you can send messages with attached
GIF files).


=head1 REQUIREMENTS

You will need the following installed on your system:

	File::Path
	File::Spec
	IPC::Open2              (optional)
	IO::Scalar, ...         from the IO-stringy distribution
	MIME::Base64
	MIME::QuotedPrint
	Net::SMTP
	Mail::Internet, ...     from the MailTools distribution.

See the Makefile.PL in your distribution for the most-comprehensive
list of prerequisite modules and their version numbers.


=head1 A QUICK TOUR

=head2 Overview of the classes

Here are the classes you'll generally be dealing with directly:


    (START HERE)            results() .-----------------.
          \                 .-------->| MIME::          |
           .-----------.   /          | Parser::Results |
           | MIME::    |--'           `-----------------'
           | Parser    |--.           .-----------------.
           `-----------'   \ filer()  | MIME::          |
              | parse()     `-------->| Parser::Filer   |
              | gives you             `-----------------'
              | a...                        	      | output_path() 
              |                         	      | determines
              |					      | path() of...
              |    head()       .--------.	      |
              |    returns...   | MIME:: | get()      |
              V       .-------->| Head   | etc...     |
           .--------./          `--------'            |
     .---> | MIME:: | 				      |
     `-----| Entity |           .--------.            |
   parts() `--------'\          | MIME:: |           /
   returns            `-------->| Body   |<---------'
   sub-entities    bodyhandle() `--------'
   (if any)        returns...       | open()
                                    | returns...
                                    |
                                    V
                                .--------. read()
                                | IO::   | getline()
                                | Handle | print()
                                `--------' etc...


To illustrate, parsing works this way:

=over 4

=item *

B<The "parser" parses the MIME stream.>
A parser is an instance of C<MIME::Parser>.
You hand it an input stream (like a filehandle) to parse a message from:
if the parse is successful, the result is an "entity".

=item *

B<A parsed message is represented by an "entity".>
An entity is an instance of C<MIME::Entity> (a subclass of C<Mail::Internet>).
If the message had "parts" (e.g., attachments), then those parts
are "entities" as well, contained inside the top-level entity.
Each entity has a "head" and a "body".

=item *

B<The entity's "head" contains information about the message.>
A "head" is an instance of C<MIME::Head> (a subclass of C<Mail::Header>).
It contains information from the message header: content type,
sender, subject line, etc.

=item *

B<The entity's "body" knows where the message data is.>
You can ask to "open" this data source for I<reading> or I<writing>,
and you will get back an "I/O handle".

=item *

B<You can open() a "body" and get an "I/O handle" to read/write message data.>
This handle is an object that is basically like an IO::Handle or
a FileHandle... it can be any class, so long as it supports a small,
standard set of methods for reading from or writing to the underlying
data source.

=back

A typical multipart message containing two parts -- a textual greeting
and an "attached" GIF file -- would be a tree of MIME::Entity objects,
each of which would have its own MIME::Head.  Like this:

    .--------.
    | MIME:: | Content-type: multipart/mixed
    | Entity | Subject: Happy Samhaine!
    `--------'
         |
         `----.
        parts |
              |   .--------.
              |---| MIME:: | Content-type: text/plain; charset=us-ascii
              |   | Entity | Content-transfer-encoding: 7bit
              |   `--------'
              |   .--------.
              |---| MIME:: | Content-type: image/gif
                  | Entity | Content-transfer-encoding: base64
                  `--------' Content-disposition: inline;
                               filename="hs.gif"



=head2 Parsing messages

You usually start by creating an instance of B<MIME::Parser>
and setting up certain parsing parameters: what directory to save
extracted files to, how to name the files, etc.

You then give that instance a readable filehandle on which waits a
MIME message.  If all goes well, you will get back a B<MIME::Entity>
object (a subclass of B<Mail::Internet>), which consists of...

=over 4

=item *

A B<MIME::Head> (a subclass of B<Mail::Header>) which holds the MIME
header data.

=item *

A B<MIME::Body>, which is a object that knows where the body data is.
You ask this object to "open" itself for reading, and it
will hand you back an "I/O handle" for reading the data: this is
a FileHandle-like object, and could be of any class, so long as it
conforms to a subset of the B<IO::Handle> interface.

=back

If the original message was a multipart document, the MIME::Entity
object will have a non-empty list of "parts", each of which is in
turn a MIME::Entity (which might also be a multipart entity, etc,
etc...).

Internally, the parser (in MIME::Parser) asks for instances
of B<MIME::Decoder> whenever it needs to decode an encoded file.
MIME::Decoder has a mapping from supported encodings (e.g., 'base64')
to classes whose instances can decode them.  You can add to this mapping
to try out new/experiment encodings.  You can also use
MIME::Decoder by itself.


=head2 Composing messages

All message composition is done via the B<MIME::Entity> class.
For single-part messages, you can use the B<MIME::Entity/build>
constructor to create MIME entities very easily.

For multipart messages, you can start by creating a top-level
C<multipart> entity with B<MIME::Entity::build()>, and then use
the similar B<MIME::Entity::attach()> method to attach parts to
that message.  I<Please note:> what most people think of as
"a text message with an attached GIF file" is I<really> a multipart
message with 2 parts: the first being the text message, and the
second being the GIF file.

When building MIME a entity, you'll have to provide two very important
pieces of information: the I<content type> and the
I<content transfer encoding>.  The type is usually easy, as it is directly
determined by the file format; e.g., an HTML file is C<text/html>.
The encoding, however, is trickier... for example, some HTML files are
C<7bit>-compliant, but others might have very long lines and would need to be
sent C<quoted-printable> for reliability.

See the section on encoding/decoding for more details, as well as
L<"A MIME PRIMER">.


=head2 Sending email

Since MIME::Entity inherits directly from Mail::Internet,
you can use the normal Mail::Internet mechanisms to send
email.  For example,

    $entity->smtpsend;



=head2 Encoding/decoding support

The B<MIME::Decoder> class can be used to I<encode> as well; this is done
when printing MIME entities.  All the standard encodings are supported
(see L<"A MIME PRIMER"> for details):

    Encoding:        | Normally used when message contents are:
    -------------------------------------------------------------------
    7bit             | 7-bit data with under 1000 chars/line, or multipart.
    8bit             | 8-bit data with under 1000 chars/line.
    binary           | 8-bit data with some long lines (or no line breaks).
    quoted-printable | Text files with some 8-bit chars (e.g., Latin-1 text).
    base64           | Binary files.

Which encoding you choose for a given document depends largely on
(1) what you know about the document's contents (text vs binary), and
(2) whether you need the resulting message to have a reliable encoding
for 7-bit Internet email transport.

In general, only C<quoted-printable> and C<base64> guarantee reliable
transport of all data; the other three "no-encoding" encodings simply
pass the data through, and are only reliable if that data is 7bit ASCII
with under 1000 characters per line, and has no conflicts with the
multipart boundaries.

I've considered making it so that the content-type and encoding
can be automatically inferred from the file's path, but that seems
to be asking for trouble... or at least, for Mail::Cap...



=head2 Message-logging

MIME-tools is a large and complex toolkit which tries to deal with 
a wide variety of external input.  It's sometimes helpful to see
what's really going on behind the scenes.
There are several kinds of messages logged by the toolkit itself:

=over 4

=item Debug messages

These are printed directly to the STDERR, with a prefix of
C<"MIME-tools: debug">.  

Debug message are only logged if you have turned
L</debugging> on in the MIME::Tools configuration.


=item Warning messages

These are logged by the standard Perl warn() mechanism
to indicate an unusual situation.  
They all have a prefix of C<"MIME-tools: warning">.

Warning messages are only logged if C<$^W> is set true 
and MIME::Tools is not configured to be L</quiet>.


=item Error messages

These are logged by the standard Perl warn() mechanism
to indicate that something actually failed.
They all have a prefix of C<"MIME-tools: error">.

Error messages are only logged if C<$^W> is set true 
and MIME::Tools is not configured to be L</quiet>.


=item Usage messages

Unlike "typical" warnings above, which warn about problems processing
data, usage-warnings are for alerting developers of deprecated methods 
and suspicious invocations.  

Usage messages are currently only logged if C<$^W> is set true 
and MIME::Tools is not configured to be L</quiet>.

=back

When a MIME::Parser (or one of its internal helper classes)
wants to report a message, it generally does so by recording 
the message to the B<MIME::Parser::Results> object
immediately before invoking the appropriate function above.
That means each parsing run has its own trace-log which 
can be examined for problems.


=head2 Configuring the toolkit

If you want to tweak the way this toolkit works (for example, to
turn on debugging), use the routines in the B<MIME::Tools> module.

=over

=item debugging

Turn debugging on or off.  
Default is false (off).

     MIME::Tools->debugging(1);


=item quiet

Turn the reporting of warning/error messages on or off.  
Default is true, meaning that these message are silenced.

     MIME::Tools->quiet(1);


=item version

Return the toolkit version.

     print MIME::Tools->version, "\n";

=back








=head1 THINGS YOU SHOULD DO


=head2 Take a look at the examples

The MIME-Tools distribution comes with an "examples" directory.
The scripts in there are basically just tossed-together, but
they'll give you some ideas of how to use the parser.


=head2 Run with warnings enabled

I<Always> run your Perl script with C<-w>.
If you see a warning about a deprecated method, change your 
code ASAP.  This will ease upgrades tremendously.


=head2 Avoid non-standard encodings

Don't try to MIME-encode using the non-standard MIME encodings.
It's just not a good practice if you want people to be able to
read your messages.


=head2 Plan for thrown exceptions

For example, if your mail-handling code absolutely must not die,
then perform mail parsing like this:

    $entity = eval { $parser->parse(\*INPUT) };

Parsing is a complex process, and some components may throw exceptions
if seriously-bad things happen.  Since "seriously-bad" is in the
eye of the beholder, you're better off I<catching> possible exceptions
instead of asking me to propagate C<undef> up the stack.  Use of exceptions in
reusable modules is one of those religious issues we're never all
going to agree upon; thankfully, that's what C<eval{}> is good for.


=head2 Check the parser results for warnings/errors

As of 5.3xx, the parser tries extremely hard to give you a
MIME::Entity.  If there were any problems, it logs warnings/errors
to the underlying "results" object (see L<MIME::Parser::Results>).
Look at that object after each parse.
Print out the warnings and errors, I<especially> if messages don't
parse the way you thought they would.


=head2 Don't plan on printing exactly what you parsed!

I<Parsing is a (slightly) lossy operation.>
Because of things like ambiguities in base64-encoding, the following 
is I<not> going to spit out its input unchanged in all cases:

    $entity = $parser->parse(\*STDIN);
    $entity->print(\*STDOUT);

If you're using MIME::Tools to process email, remember to save
the data you parse if you want to send it on unchanged.  
This is vital for things like PGP-signed email.


=head2 Understand how international characters are represented

The MIME standard allows for text strings in headers to contain 
characters from any character set, by using special sequences
which look like this:

    =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?=

To be consistent with the existing Mail::Field classes, MIME::Tools
does I<not> automatically unencode these strings, since doing so would
lose the character-set information and interfere with the parsing 
of fields (see L<MIME::Parser/decode_headers> for a full explanation).
That means you should be prepared to deal with these encoded strings.

The most common question then is, B<how do I decode these encoded strings?>
The answer depends on what you want to decode them I<to>:
ASCII, Latin1, UTF-8, etc.  Be aware that your "target" representation
may not support all possible character sets you might encounter; 
for example, Latin1 (ISO-8859-1) has no way of representing Big5 
(Chinese) characters.  A common practice is to represent "untranslateable"
characters as "?"s, or to ignore them completely.

To unencode the strings into some of the more-popular Western byte 
representations (e.g., Latin1, Latin2, etc.), you can use the decoders 
in MIME::WordDecoder (see L<MIME::WordDecoder>).  
The simplest way is by using C<unmime()>, a function wrapped
around your "default" decoder, as follows:

    use MIME::WordDecoder;    
    ...
    $subject = unmime $entity->head->get('subject');

One place this I<is> done automatically is in extracting the recommended
filename for a part while parsing.  That's why you should start by
setting up the best "default" decoder if the default target of Latin1
isn't to your liking.



=head1 THINGS I DO THAT YOU SHOULD KNOW ABOUT


=head2 Fuzzing of CRLF and newline on input

RFC-1521 dictates that MIME streams have lines terminated by CRLF
(C<"\r\n">).  However, it is extremely likely that folks will want to
parse MIME streams where each line ends in the local newline
character C<"\n"> instead.

An attempt has been made to allow the parser to handle both CRLF
and newline-terminated input.


=head2 Fuzzing of CRLF and newline when decoding

The C<"7bit"> and C<"8bit"> decoders will decode both
a C<"\n"> and a C<"\r\n"> end-of-line sequence into a C<"\n">.

The C<"binary"> decoder (default if no encoding specified)
still outputs stuff verbatim... so a MIME message with CRLFs
and no explicit encoding will be output as a text file
that, on many systems, will have an annoying ^M at the end of
each line... I<but this is as it should be>.


=head2 Fuzzing of CRLF and newline when encoding/composing

All encoders currently output the end-of-line sequence as a C<"\n">,
with the assumption that the local mail agent will perform
the conversion from newline to CRLF when sending the mail.
However, there probably should be an option to output CRLF as per RFC-1521.


=head2 Inability to handle multipart boundaries with embedded newlines

Let's get something straight: this is an evil, EVIL practice.
If your mailer creates multipart boundary strings that contain
newlines, give it two weeks notice and find another one.  If your
mail robot receives MIME mail like this, regard it as syntactically
incorrect, which it is.


=head2 Ignoring non-header headers

People like to hand the parser raw messages straight from 
POP3 or from a mailbox.  There is often predictable non-header
information in front of the real headers; e.g., the initial
"From" line in the following message:

    From - Wed Mar 22 02:13:18 2000
    Return-Path: <eryq@zeegee.com>
    Subject: Hello

The parser simply ignores such stuff quietly.  Perhaps it
shouldn't, but most people seem to want that behavior.


=head2 Fuzzing of empty multipart preambles

Please note that there is currently an ambiguity in the way
preambles are parsed in.  The following message fragments I<both>
are regarded as having an empty preamble (where C<\n> indicates a 
newline character):

     Content-type: multipart/mixed; boundary="xyz"\n
     Subject: This message (#1) has an empty preamble\n
     \n      
     --xyz\n
     ...
      
     Content-type: multipart/mixed; boundary="xyz"\n
     Subject: This message (#2) also has an empty preamble\n
     \n      
     \n
     --xyz\n
     ...

In both cases, the I<first> completely-empty line (after the "Subject")
marks the end of the header.  

But we should clearly ignore the I<second> empty line in message #2,
since it fills the role of I<"the newline which is only there to make
sure that the boundary is at the beginning of a line">.  
Such newlines are I<never> part of the content preceding the boundary; 
thus, there is no preamble "content" in message #2.

However, it seems clear that message #1 I<also> has no preamble
"content", and is in fact merely a compact representation of an
empty preamble.


=head2 Use of a temp file during parsing 

I<Why not do everything in core?>
Although the amount of core available on even a modest home
system continues to grow, the size of attachments continues
to grow with it.  I wanted to make sure that even users with small
systems could deal with decoding multi-megabyte sounds and movie files.
That means not being core-bound.

As of the released 5.3xx, MIME::Parser gets by with only
one temp file open per parser.  This temp file provides
a sort of infinite scratch space for dealing with the current
message part.  It's fast and lightweight, but you should know
about it anyway.


=head2 Why do I assume that MIME objects are email objects?

Achim Bohnet once pointed out that MIME headers do nothing more than
store a collection of attributes, and thus could be represented as
objects which don't inherit from Mail::Header.

I agree in principle, but RFC-1521 says otherwise.
RFC-1521 [MIME] headers are a syntactic subset of RFC-822 [email] headers.
Perhaps a better name for these modules would have been RFC1521::
instead of MIME::, but we're a little beyond that stage now.

When I originally wrote these modules for the CPAN, I agonized for a long
time about whether or not they really should subclass from B<Mail::Internet>
(then at version 1.17).  Thanks to Graham Barr, who graciously evolved
MailTools 1.06 to be more MIME-friendly, unification was achieved
at MIME-tools release 2.0.
The benefits in reuse alone have been substantial.




=head1 A MIME PRIMER

So you need to parse (or create) MIME, but you're not quite up on
the specifics?  No problem...



=head2 Glossary

Here are some definitions adapted from RFC-1521 explaining the terminology
we use; each is accompanied by the equivalent in MIME:: module terms...

=over 4

=item attachment

An "attachment" is common slang for any part of a multipart message --
except, perhaps, for the first part, which normally carries a user
message describing the attachments that follow (e.g.: "Hey dude, here's
that GIF file I promised you.").

In our system, an attachment is just a B<MIME::Entity> under the
top-level entity, probably one of its L<parts|MIME::Entity/parts>.

=item body

The "body" of an L<entity|/entity> is that portion of the entity
which follows the L<header|/header> and which contains the real message
content.  For example, if your MIME message has a GIF file attachment,
then the body of that attachment is the base64-encoded GIF file itself.

A body is represented by an instance of B<MIME::Body>.  You get the
body of an entity by sending it a L<bodyhandle()|MIME::Entity/bodyhandle>
message.

=item body part

One of the parts of the body of a multipart B</entity>.
A body part has a B</header> and a B</body>, so it makes sense to
speak about the body of a body part.

Since a body part is just a kind of entity, it's represented by
an instance of B<MIME::Entity>.

=item entity

An "entity" means either a B</message> or a B</body part>.
All entities have a B</header> and a B</body>.

An entity is represented by an instance of B<MIME::Entity>.
There are instance methods for recovering the
L<header|MIME::Entity/head> (a B<MIME::Head>) and the
L<body|MIME::Entity/bodyhandle> (a B<MIME::Body>).

=item header

This is the top portion of the MIME message, which contains the
"Content-type", "Content-transfer-encoding", etc.  Every MIME entity has
a header, represented by an instance of B<MIME::Head>.  You get the
header of an entity by sending it a head() message.

=item message

A "message" generally means the complete (or "top-level") message being
transferred on a network.

There currently is no explicit package for "messages"; under MIME::,
messages are streams of data which may be read in from files or
filehandles.  You can think of the B<MIME::Entity> returned by the
B<MIME::Parser> as representing the full message.


=back


=head2 Content types

This indicates what kind of data is in the MIME message, usually
as I<majortype/minortype>.  The standard major types are shown below.
A more-comprehensive listing may be found in RFC-2046.

=over 4

=item application

Data which does not fit in any of the other categories, particularly
data to be processed by some type of application program.
C<application/octet-stream>, C<application/gzip>, C<application/postscript>...

=item audio

Audio data.
C<audio/basic>...

=item image

Graphics data.
C<image/gif>, C<image/jpeg>...

=item message

A message, usually another mail or MIME message.
C<message/rfc822>...

=item multipart

A message containing other messages.
C<multipart/mixed>, C<multipart/alternative>...

=item text

Textual data, meant for humans to read.
C<text/plain>, C<text/html>...

=item video

Video or video+audio data.
C<video/mpeg>...

=back


=head2 Content transfer encodings

This is how the message body is packaged up for safe transit.
There are the 5 major MIME encodings.
A more-comprehensive listing may be found in RFC-2045.

=over 4

=item 7bit

No encoding is done at all.  This label simply asserts that no
8-bit characters are present, and that lines do not exceed 1000 characters
in length (including the CRLF).

=item 8bit

No encoding is done at all.  This label simply asserts that the message
might contain 8-bit characters, and that lines do not exceed 1000 characters
in length (including the CRLF).

=item binary

No encoding is done at all.  This label simply asserts that the message
might contain 8-bit characters, and that lines may exceed 1000 characters
in length.  Such messages are the I<least> likely to get through mail
gateways.

=item base64

A standard encoding, which maps arbitrary binary data to the 7bit domain.
Like "uuencode", but very well-defined.  This is how you should send
essentially binary information (tar files, GIFs, JPEGs, etc.).

=item quoted-printable

A standard encoding, which maps arbitrary line-oriented data to the
7bit domain.  Useful for encoding messages which are textual in
nature, yet which contain non-ASCII characters (e.g., Latin-1,
Latin-2, or any other 8-bit alphabet).

=back




=head1 TERMS AND CONDITIONS

Eryq (F<eryq@zeegee.com>), ZeeGee Software Inc (F<http://www.zeegee.com>).
David F. Skoll (dfs@roaringpenguin.com) http://www.roaringpenguin.com

Copyright (c) 1998, 1999 by ZeeGee Software Inc (www.zeegee.com).
Copyright (c) 2004 by Roaring Penguin Software Inc (www.roaringpenguin.com)

All rights reserved.  This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.
See the COPYING file in the distribution for details.



=head1 SUPPORT

Please email me directly with questions/problems (see AUTHOR below).

If you want to be placed on an email distribution list (not a mailing list!)
for MIME-tools, and receive bug reports, patches, and updates as to when new
MIME-tools releases are planned, just email me and say so.  If your project
is using MIME-tools, it might not be a bad idea to find out about those
bugs I<before> they become problems...


=head1 VERSION

$Revision: 1.3 $


=head1 CHANGE LOG

=over 4

=item Version 5.411

B<Regenerated docs.>
Bug in HTML docs, now all fixed.

=item Version 5.410   (2000/11/23)

B<Better detection of evil filenames.>
Now we check for filenames which are suspiciously long,
and a new MIME::Filer::exorcise_filename() method is used
to try and remove the evil.
I<Thanks to Jason Haar for the suggestion.>


=item Version 5.409   (2000/11/12)

B<Added functionality to MIME::WordDecoder,> 
including support for plain US-ASCII. 

B<MIME::Tools::tmpopen()> made more flexible.
You can now override the tmpfile-opening behavior.


=item Version 5.408   (2000/11/10)

B<Added new Beta unmime() mechanism.>
See L<MIME::WordDecoder> for full details.
Also see L<"Understand how international characters are represented">.


=item Version 5.405   (2000/11/05)

B<Added a purge() that does what people want it to.>
Now, when a parse finishes and you want to delete everything that
was created by it, you can invoke C<purge()> on the parser's filer.
All files/directories created during the last parse should vanish.
I<Thanks to everyone who complained about MIME::Entity::purge.>


=item Version 5.404   (2000/11/04)

B<Added new automatic MIME-decoding of attachment filenames with
encoded (non-ASCII) characters.>
Hopefully this will do more good than harm.  
The use of MIME::Parser::decode_headers() and MIME::Head::decode() 
has been deprecated in favor of the new MIME::Words "unmime" mechanism.  
Please see L<MIME::Words/unmime>.

B<Added tolerance for unquoted =?...?= in param values.>
This is in violation of the RFCs, but then, so are some MUAs.
I<Thanks to desti for bringing this to my attention.>

B<Fixed supposedly-bad B-encoding.>
I<Thanks to Otto Frost for bringing this to my attention.>


=item Version 5.316   (2000/09/21)

B<Increased tolerance in MIME::Parser.>
Now will ignore bogus POP3 "+OK" line before header, as well as bogus
mailbox "From " line (both with warnings). 
I<Thanks to Antony OSullivan (ajos1) for suggesting this feature.>

B<Fixed small epilogue-related bug in MIME::Entity::print_body().>
Now it only outputs a final newline if the epilogue does not end
in one already.  Support for checking the preamble/epilogue in 
regression tests was also added.
I<Thanks to Lars Hecking for bringing this issue up.>

B<Updated documentation.>
All module manual pages should now direct readers to the main 
MIME-tools manual page.


=item Version 5.314   (2000/09/06)

Fixed Makefile.PL to have less-restrictive requirement
for File::Spec (0.6).


=item Version 5.313   (2000/09/05)

B<Fixed nasty bug with evil filenames.>
Certain evil filenames were getting replaced by internally-generated
filenames which were just as evil... ouch!  If your parser occasionally
throws a fatal exception with a "write-open" error message, then
you have this bug.
I<Thanks to Julian Field and Antony OSullivan (ajos1)
for delivering the evidence!> 

       Beware the doctor
          who cures seasonal head cold
       by killing patient

B<Improved naming of extracted files.>
If a filename is regarded as evil, we guess that it might just
be because of part information, and attempt to find and use the
final path element.  

B<Simplified message logging and made it more consistent.>
For details, see L<"Message-logging">.


=item Version 5.312   (2000/09/03)

B<Fixed a Perl 5.7 select() incompatibility> 
which caused "make test" to fail.  
I<Thanks to Nick Ing-Simmons for the patch.>


=item Version 5.311   (2000/08/16)

B<Blind fix for Win32 uudecoding bug.>
A missing binmode seems to be the culprit here; let's see if this fixes it.
I<Thanks to ajos1 for finding the culprit!>

       The carriage return
          thumbs its nose at me, laughing:
       DOS I/O *still* sucks


=item Version 5.310   (2000/08/15)

B<Fixed a bug in the back-compat output_prefix() method of MIME::Parser.>
Basically, output prefixes were not being set through this mechanism.
I<Thanks to ajos1 for the alert.>

	shift @_,                               ### "shift at-underscore"
	   or @_ will have
	bogus "self" object

B<Added some backcompat methods,> like parse_FH().
I<Thanks (and apologies) to Alain Kotoujansky.>

B<Added filenames-with-spaces support to MIME::Decoder::UU.>
I<Thanks to Richard Pun for the suggestion.>


=item Version 5.305   (2000/07/20)

B<Added MIME::Entity::parts_DFS> as convenient way to "get all parts".
I<Thanks to Xavier Armengou for suggesting this method.>

Removed the Alpha notice.
Still a few features to tweak, but those will be minor.


=item Version 5.303   (2000/07/07)

B<Fixed output bugs in new Filers>.
Scads of them: bad handling of filename collisions, bad implementation
of output_under(), bad linking to results, POD errors, you name it.
If this had gone to CPAN, I'd have issued a factory recall. C<:-(>

       Errors, like beetles,
          Multiply ferociously
       In the small hours


=item Version 5.301   (2000/07/06)

B<READ ME BEFORE UPGRADING PAST THIS POINT!>
B<New MIME::Parser::Filer class -- not fully backwards-compatible.>
In response to demand for more-comprehensive file-output strategies,
I have decided that the best thing to do is to split all the
file-output logic (output_path(), evil_filename(), etc.)
into its own separate class, inheriting from the new
L<MIME::Parser::Filer|MIME::Parser::Filer> class.
If you I<override> any of the following in a MIME::Parser subclass,
you will need to change your code accordingly:

	evil_filename
	output_dir
	output_filename
	output_path
	output_prefix
	output_under

My sincere apologies for any inconvenience this will cause, but
it's ultimately for the best, and is quite likely the last structural
change to 5.x.
I<Thanks to Tyson Ackland for all the ideas.>
Incidentally, the new code also fixes a bug where identically-named
files in the same message could clobber each other.

       A message arrives:
           "Here are three files, all named 'Foo'"
       Only one survives.  :-(

B<Fixed bug in MIME::Words header decoding.>
Underscores were not being handled properly.
I<Thanks to Dominique Unruh and Doru Petrescu,> who independently
submitted the same fix within 2 hours of each other, after this
bug has lain dormant for months:

       Two users, same bug,
          same patch -- mere hours apart:
       Truly, life is odd.

B<Removed escaping of underscore in regexps.>
Escaping the underscore (\_) in regexps was sloppy and wrong
(escaped metacharacters may include anything in \w), and the newest
Perls warn about it.
I<Thanks to David Dyck for bringing this to my attention.>

       What, then, is a word?
	  Some letters, digits, and, yes:
       Underscores as well

B<Added Force option to MIME::Entity's make_multipart>.
I<Thanks to Bob Glickstein for suggesting this.>

B<Numerous fixlets to example code.>
I<Thanks to Doru Petrescu for these.>

B<Added REQUIREMENTS section in docs.>
Long-overdue.  I<Thanks to Ingo Schmiegel for motivating this.>


=item Version 5.211   (2000/06/24)

B<Fixed auto-uudecode bug.>
Parser was failing with "part did not end with expected boundary" error
when uuencoded entity was a I<singlepart> message (ironically,
uuencoded parts of multiparts worked fine).
I<Thanks to Michael Mohlere for testing uudecode and finding this.>

       The hurrying bee
          Flies far for nectar, missing
       The nearest flowers

       Say ten thousand times:
          Complex cases may succeed
       Where simple ones fail

B<Parse errors now generate warnings.>
Parser errors now cause warn()s to be generated if they are
not turned into fatal exceptions.  This might be a little redundant,
seeing as they are available in the "results", but parser-warnings
already cause warn()s.  I can always put in a "quiet" switch if
people complain.

B<Miscellaneous cleanup.>
Documentation of MIME::Parser improved slightly, and a redundant
warning was removed.


=item Version 5.210   (2000/06/20)

B<Change in "evil" filename.>
Made MIME::Parser's evil_filename stricter by having it reject
"path" characters: any of '/' '\' ':' '[' ']'.

       Just as with beauty
	  The eye of the beholder
       Is where "evil" lives.

B<Documentation fixes.>
Corrected a number of docs in MIME::Entity which were obsoleted
in the transition from 4.x to 5.x.
I<Thanks to Michael Fischer for pointing these out.>
For this one, a special 5-5-5-5 Haiku of anagrams:

       Documentation
	  in mutant code, O!
       Edit -- no, CUT! [moan]
	  I meant to un-doc...

B<IO::Lines usage bug fixed.>
MIME::Entity was missing a "use IO::Lines", which caused an
exception when you tried to use the body() method of MIME::Entity.
I<Thanks to Hideyo Imazu and Michael Fischer for pointing this out.>

       Bareword looks fine, but
          Perl cries: "Whoa there... IO::Lines?
       Never heard of it."


=item Version 5.209   (2000/06/10)

B<Autodetection of uuencode.>
You can now tell the parser to hunt for uuencode inside what should
be text parts.
See L<extract_uuencode()|MIME::Parser/extract_uuencode> for full details.
B<Beware:> this is largely untested at the moment.
I<Special thanks to Michael Mohlere at ADJE Webmail, who was the
  first -- and most-insistent -- user to request this feature.>

B<Faster parsing.>
Sped up the MIME::Decoder::NBit decoder quite a bit by using a variant
of the chunking trick I used for MIME::Decoder::Base64.  I suspect
that the same trick (reading a big chunk plus the next line to get a
big block of lines) would work with MIME::Decoder::QuotedPrint, but I
don't have the time or resources to check that right now (tested
contributions would be welcome).  NBit encoding is more-conveniently
done line-by-line for now, because individual line lengths must be
checked.

B<Better use of core.>
MIME::Body::InCore is now used when you build() an entity with
the Data parameter, instead of MIME::Body::Scalar.

B<More documentation> on toolkit configuration.


=item Version 5.207   (2000/06/09)

B<Fixed whine() bug in MIME::Parser> where the "warning" method
whine() was called as a static function instead of invoked as an
instance method.
I<Thanks to Todd A. Bradfute for reporting this.>

       A simple warning
          Invokes method as function:
       "Warning" makes us die


=item Version 5.206   (2000/06/08)

Ahem.  Cough cough:

       Way too many bugs
          Thus, a self-imposed penance:
       Write haiku for each

B<Fixed bug in MIME::Parser:> the reader was not handling the odd
(but legal) case where a multipart boundary is followed by linear
whitespace.
I<Thanks to Jon Agnew for reporting this with the RFC citation.>

       Legal message fails
          And 'round the globe, thousands cry:
       READ THE RFC

Empty preambles are now handled properly by MIME::Entity when
printing: there is now no space between the header-terminator
and the initial boundary.
I<Thanks to "sen_ml" for suggesting this.>

       Nature hates vacuum
          But please refrain from tossing
       Newlines in the void

Started using Benchmark for benchmarking.

=item Version 5.205   (2000/06/06)

Added terminating newline to all parser messages, and fixed
small parser bug that was dropping parts when errors occurred
in certain places.


=item Version 5.203   (2000/06/05)

Brand new parser based on new (private) MIME::Parser::Reader and
(public) MIME::Parser::Results.  Fast and yet simple and very tolerant
of bad MIME when desired.  Message reporting needs some muzzling.

MIME::Parser now has ignore_errors() set true by default.


=item Version 5.116   (2000/05/26)

Removed Tmpfile.t test, which was causing a bogus failure in
"make test".  Now we require 5.004 for MIME::Parser anyway,
so we don't need it.  I<Thanks to Jonathan Cohn for reporting this.>


=item Version 5.115   (2000/05/24)

Fixed Ref.t bug, and documented how to remove parts from a MIME::Entity.


=item Version 5.114   (2000/05/23)

Entity now uses MIME::Lite-style default suggested encoding.

More regression test have been added, and the "Size" tests in
Ref.t are skipped for text document (due to CRLF differences
between platforms).


=item Version 5.113   (2000/05/21)

B<Major speed and structural improvements to the parser.>
    I<Major, MAJOR thanks to Noel Burton-Krahn, Jeremy Gilbert,
      and Doru Petrescu for all the patches, benchmarking,
      and Beta-testing!>

B<Convenient new one-directory-per-message parsing mechanism.>
    Now through C<MIME::Parser> method C<output_under()>,
    you can tell the parser that you want it to create
    a unique directory for each message parsed, to hold the
    resulting parts.

B<Elimination of $', $` and $&.>
    Wow... I still can't believe I missed this.  D'OH!
    I<Thanks to Noel Burton-Krahn for all his patches.>

B<Parser is more tolerant of weird EOL termination.>
    Some mailagents are can terminate lines with "\r\r\n".
    We're okay with that now when we extract the header.
    I<Thanks to Joao Fonseca for pointing this out.>

B<Parser is tolerant of "From " lines in headers.>
    I<Thanks to Joachim Wieland, Anthony Hinsinger, Marius Stan,
      and numerous others.>

B<Parser catches syntax errors in headers.>
    I<Thanks to Russell P. Sutherland for catching this.>

B<Parser no longer warns when subtype is undefined.>
    I<Thanks to Eric-Olivier Le Bigot for his fix.>

B<Better integration with Mail::Internet.>
    For example, smtpsend() should work fine.
    I<Thanks to Michael Fischer and others for the patch.>

B<Miscellaneous cleanup.>
    I<Thanks to Marcus Brinkmann for additional helpful input.>
    I<Thanks to Klaus Seidenfaden for good feedback on 5.x Alpha!>




=item Version 4.123   (1999/05/12)

Cleaned up some of the tests for non-Unix OS'es.
Will require a few iterations, no doubt.


=item Version 4.122   (1999/02/09)

B<Resolved CORE::open warnings for 5.005.>
        I<Thanks to several folks for this bug report.>


=item Version 4.121   (1998/06/03)

B<Fixed MIME::Words infinite recursion.>
        I<Thanks to several folks for this bug report.>


=item Version 4.117   (1998/05/01)

B<Nicer MIME::Entity::build.>
        No longer outputs warnings with undefined Filename, and now
        accepts Charset as well.
	I<Thanks to Jason Tibbits III for the inspirational patch.>

B<Documentation fixes.>
        Hopefully we've seen the last of the pod2man warnings...

B<Better test logging.>
        Now uses ExtUtils::TBone.


=item Version 4.116   (1998/02/14)

B<Bug fix:>
        MIME::Head and MIME::Entity were not downcasing the
        content-type as they claimed.  This has now been fixed.
	I<Thanks to Rodrigo de Almeida Siqueira for finding this.>


=item Version 4.114   (1998/02/12)

B<Gzip64-encoding has been improved, and turned off as a default,>
	since it depends on having gzip installed.
        See MIME::Decoder::Gzip64 if you want to activate it in your app.
	You can	now set up the gzip/gunzip commands to use, as well.
	I<Thanks to Paul J. Schinder for finding this bug.>


=item Version 4.113   (1998/01/20)

B<Bug fix:>
        MIME::ParserBase was accidentally folding newlines in header fields.
	I<Thanks to Jason L. Tibbitts III for spotting this.>


=item Version 4.112   (1998/01/17)

B<MIME::Entity::print_body now recurses> when printing multipart
	entities, and prints "everything following the header."  This is more
	likely what people expect to happen.  PLEASE read the
        "two body problem" section of MIME::Entity's docs.


=item Version 4.111   (1998/01/14)

Clean build/test on Win95 using 5.004.  Whew.


=item Version 4.110   (1998/01/11)

B<Added> make_multipart() and make_singlepart() in MIME::Entity.

B<Improved> handling/saving of preamble/epilogue.


=item Version 4.109   (1998/01/10)

=over 4

=item Overall

B<Major version shift to 4.x>
	accompanies numerous structural changes, and
	the deletion of some long-deprecated code.  Many apologies to those
	who are inconvenienced by the upgrade.

B<MIME::IO deprecated.>
	You'll see IO::Scalar, IO::ScalarArray, and IO::Wrap
	to make this toolkit work.

B<MIME::Entity deep code.>
	You can now deep-copy MIME entities (except for on-disk data files).


=item Encoding/decoding

B<MIME::Latin1 deprecated, and 8-to-7 mapping removed.>
	Really, MIME::Latin1 was one of my more dumber ideas.
	It's still there, but if you want to map 8-bit characters to
	Latin1 ASCII approximations when 7bit encoding, you'll have to
	request it explicitly.	I<But use quoted-printable for your 8-bit
	documents; that's what it's there for!>

B<7bit and 8bit "encoders" no longer encode.>
	As per RFC-2045, these just do a pass-through of the data,
	but they'll warn you if you send bad data through.

B<MIME::Entity suggests encoding.>
	Now you can ask MIME::Entity's build() method to "suggest"
	a legal encoding based on the body and the content-type.
	No more guesswork!  See the "mimesend" example.

B<New module structure for MIME::Decoder classes.>
	It should be easier for you to see what's happening.

B<New MIME decoders!>
	Support added for decoding C<x-uuencode>, and for
	decoding/encoding C<x-gzip64>.  You'll need "gzip" to make
	the latter work.

B<Quoted-printable back on track... and then some.>
	The 'quoted-printable' decoder now uses the newest MIME::QuotedPrint,
	and amends its output with guideline #8 from RFC2049 (From/.).
	I<Thanks to Denis N. Antonioli for suggesting this.>

=item Parsing

B<Preamble and epilogue are now saved.>
	These are saved in the parsed entities as simple
	string-arrays, and are output by print() if there.
	I<Thanks to Jason L. Tibbitts for suggesting this.>

B<The "multipart/digest" semantics are now preserved.>
	Parts of digest messages have their mime_type() defaulted
	to "message/rfc822" instead of "text/plain", as per the RFC.
	I<Thanks to Carsten Heyl for suggesting this.>

=item Output

B<Well-defined, more-complete print() output.>
	When printing an entity, the output is now well-defined if the
	entity came from a MIME::Parser, even if using parse_nested_messages.
	See MIME::Entity for details.

B<You can prevent recommended filenames from being output.>
	This possible security hole has been plugged; when building MIME
	entities, you can specify a body path but suppress the filename
	in the header.
	I<Thanks to Jason L. Tibbitts for suggesting this.>

=item Bug fixes

B<Win32 installations should work.>
	The binmode() calls should work fine on Win32 now.
	I<Thanks to numerous folks for their patches.>

B<MIME::Head::add()> now no longer downcases its argument.
	I<Thanks to Brandon Browning & Jason L. Tibbitts for finding this bug.>

=back






=item Version 3.204   

B<Bug in MIME::Head::original_text fixed.>
	Well, it took a while, but another bug surfaced from my transition
	from 1.x to 2.x.  This method was, quite idiotically, sorting the
	header fields.
	I<Thanks, as usual, to Andreas Koenig for spotting this one.>

B<MIME::ParserBase no longer defaults to RFC-1522-decoding headers.>
	The documentation correctly stated that the default setting was
	to I<not> RFC-1522-decode the headers.  The code, on the other hand,
	was init'ing this parser option in the "on" position.
	This has been fixed.

B<MIME::ParserBase::parse_nested_messages reexamined.>
	If you use this feature, please re-read the documentation.
	It explains a little more precisely what the ramifications are.

B<MIME::Entity tries harder to ensure MIME compliance.>
	It is now a fatal error to use certain bad combinations of content
	type and encoding when "building", or to attempt to "attach" to
	anything that is not a multipart document.  My apologies if this
	inconveniences anyone, but it was just too darn easy before for folks
	to create bad MIME, and gosh darn it, good libraries should at least
	I<try> to protect you from mistakes.

B<The "make" now halts if you don't have the right stuff,>
	provided your MakeMaker supports PREREQ_PM.  See L<"REQUIREMENTS">
	for what you need to install this package.  I still provide
	old courtesy copies of the MIME:: decoding modules.
I<Thanks to Hugo van der Sanden for suggesting this.>

B<The "make test" is far less chatty.>
	Okay, okay, STDERR is evil.  Now a C<"make test"> will just give you
	the important stuff: do a C<"make test TEST_VERBOSE=1"> if you want
	the gory details (advisable if sending me a bug report).
I<Thanks to Andreas Koenig for suggesting this.>


=item Version 3.203   

B<No, there haven't been any major changes between 2.x and 3.x.>
	The major-version increase was from a few more tweaks to get $VERSION
	to be calculated better and more efficiently (I had been using RCS
	version numbers in a way which created problems for users of CPAN::).
	After a couple of false starts, all modules have been upgraded to RCS
	3.201 or higher.

B<You can now parse a MIME message from a scalar,>
	an array-of-scalars, or any MIME::IO-compliant object (including IO::
	objects.)  Take a look at parse_data() in MIME::ParserBase.  The
	parser code has been modified to support the MIME::IO interface.
	I<Thanks to fellow Chicagoan Tim Pierce (and countless others)
	for asking.>

B<More sensible toolkit configuration.>
	A new config() method in MIME::ToolUtils makes a lot of toolkit-wide
	configuration cleaner.  Your old calls will still work, but with
	deprecation warnings.

B<You can now sign messages> just like in Mail::Internet.
	See MIME::Entity for the interface.

B<You can now remove signatures from messages> just like in Mail::Internet.
	See MIME::Entity for the interface.

B<You can now compute/strip content lengths>
	and other non-standard MIME fields.
	See sync_headers() in MIME::Entity.
	I<Thanks to Tim Pierce for bringing the basic problem to my attention.>

B<Many warnings are now silent unless $^W is true.>
	That means unless you run your Perl with C<-w>, you won't see
        deprecation warnings, non-fatal-error messages, etc.
        But of course you run with C<-w>, so this doesn't affect you.  C<:-)>

B<Completed the 7-bit encodings in MIME::Latin1.>
	We hadn't had complete coverage in the conversion from 8- to 7-bit;
	now we do. I<Thanks to Rolf Nelson for bringing this to my attention.>

B<Fixed broken parse_two() in MIME::ParserBase.>
	BTW, if your code worked with the "broken" code, it should I<still>
	work.
	I<Thanks again to Tim Pierce for bringing this to my attention.>


=item Version 2.14   

Just a few bug fixes to improve compatibility with Mail-Tools 1.08,
and with the upcoming Perl 5.004 release.
I<Thanks to Jason L. Tibbitts III for reporting the problems so quickly.>


=item Version 2.13   

=over 4

=item New features

B<Added RFC-1522-style decoding of encoded header fields.>
	Header decoding can now be done automatically during parsing via the
	new C<decode()> method in MIME::Head... just tell your parser
	object that you want to C<decode_headers()>.
	I<Thanks to Kent Boortz for providing the idea, and the baseline
	RFC-1522-decoding code!>

B<Building MIME messages is even easier.>
	Now, when you use MIME::Entity's C<build()> or C<attach()>,
	you can also supply individual
	mail headers to set (e.g., C<-Subject>, C<-From>, C<-To>).

Added C<Disposition> to MIME::Entity's C<build()> method.
	I<Thanks to Kurt Freytag for suggesting this feature.>

An C<X-Mailer> header is now output
	by default in all MIME-Entity-prepared messages,
	so any bad MIME we generate can be traced back to this toolkit.

Added C<purge()> method to MIME::Entity for deleteing leftover files.
	I<Thanks to Jason L. Tibbitts III for suggesting this feature.>

Added C<seek()> and C<tell()> methods to built-in MIME::IO classes.
	Only guaranteed to work when reading!
	I<Thanks to Jason L. Tibbitts III for suggesting this feature.>

When parsing a multipart message with apparently no boundaries,
	the error message you get has been improved.
	I<Thanks to Andreas Koenig for suggesting this.>

=item Bug fixes

B<Patched over a Perl 5.002 (and maybe earlier and later) bug involving
FileHandle::new_tmpfile.>  It seems that the underlying filehandles
were not being closed when the FileHandle objects went out of scope!
There is now an internal routine that creates true FileHandle
objects for anonymous temp files.
I<Thanks to Dragomir R. Radev and Zyx for reporting the weird behavior
that led to the discovery of this bug.>

MIME::Entity's C<build()> method now warns you if you give it an illegal
boundary string, and substitutes one of its own.

MIME::Entity's C<build()> method now generates safer, fully-RFC-1521-compliant
boundary strings.

Bug in MIME::Decoder's C<install()> method was fixed.
I<Thanks to Rolf Nelson and Nickolay Saukh for finding this.>

Changed FileHandle::new_tmpfile to FileHandle->new_tmpfile, so some
Perl installations will be happier.
I<Thanks to Larry W. Virden for finding this bug.>

Gave C<=over> an arg of 4 in all PODs.
I<Thanks to Larry W. Virden for pointing out the problems of bare =over's>

=back


=item Version 2.04   

B<A bug in MIME::Entity's output method was corrected.>
MIME::Entity::print now outputs everything to the desired filehandle
explicitly.
I<Thanks to Jake Morrison for pointing out the incompatibility
with Mail::Header.>


=item Version 2.03   

B<Fixed bug in autogenerated filenames> resulting from transposed "if"
statement in MIME::Parser, removing spurious printing of header as well.
(Annoyingly, this bug is invisible if debugging is turned on!)
I<Thanks to Andreas Koenig for bringing this to my attention.>

Fixed bug in MIME::Entity::body() where it was using the bodyhandle
completely incorrectly.
I<Thanks to Joel Noble for bringing this to my attention.>

Fixed MIME::Head::VERSION so CPAN:: is happier.
I<Thanks to Larry Virden for bringing this to my attention.>

Fixed undefined-variable warnings when dumping skeleton
(happened when there was no Subject: line)
I<Thanks to Joel Noble for bringing this to my attention.>


=item Version 2.02   

B<Stupid, stupid bugs in both BASE64 encoding and decoding were fixed.>
I<Thanks to Phil Abercrombie for locating them.>


=item Version 2.01   

B<Modules now inherit from the new Mail:: modules!>
This means big changes in behavior.

B<MIME::Parser can now store message data in-core.>
There were a I<lot> of requests for this feature.

B<MIME::Entity can now compose messages.>
There were a I<lot> of requests for this feature.

Added option to parse C<"message/rfc822"> as a pseduo-multipart document.
I<Thanks to Andreas Koenig for suggesting this.>





=item Version 1.13   

MIME::Head now no longer requires space after ":", although
either a space or a tab after the ":" will be swallowed
if there.
I<Thanks to Igor Starovoitov for pointing out this shortcoming.>

=item Version 1.12   

Fixed bugs in parser where CRLF-terminated lines were
blowing out the handling of preambles/epilogues.
I<Thanks to Russell Sutherland for reporting this bug.>

Fixed idiotic is_multipart() bug.
I<Thanks to Andreas Koenig for noticing it.>

Added untested binmode() calls to parser for DOS, etc.
systems.  No idea if this will work...

Reorganized the output_path() methods to allow easy use
of inheritance, as per Achim Bohnet's suggestion.

Changed MIME::Head to report mime_type more accurately.

POSIX module no longer loaded by Parser if perl >= 5.002.
Hey, 5.001'ers: let me know if this breaks stuff, okay?

Added unsupported ./examples directory.

=item Version 1.11   

Converted over to using Makefile.PL.
I<Thanks to Andreas Koenig for the much-needed kick in the pants...>

Added t/*.t files for testing.  Eeeeeeeeeeeh...it's a start.

Fixed bug in default parsing routine for generating
output paths; it was warning about evil filenames if
there simply I<were> no recommended filenames.  D'oh!

Fixed redefined parts() method in Entity.

Fixed bugs in Head where field name wasn't being case folded.

=item Version 1.10   

A typo was causing the epilogue of an inner multipart
message to be swallowed to the end of the OUTER multipart
message; this has now been fixed.
I<Thanks to Igor Starovoitov for reporting this bug.>

A bad regexp for parameter names was causing
some parameters to be parsed incorrectly; this has also
been fixed.
I<Thanks again to Igor Starovoitov for reporting this bug.>

It is now possible to get full control of the filenaming
algorithm before output files are generated, and the default
algorithm is safer.
I<Thanks to Laurent Amon for pointing out the problems, and suggesting
some solutions.>

Fixed illegal "simple" multipart test file.  D'OH!

=item Version 1.9   

No changes: 1.8 failed CPAN registration

=item Version 1.8   

Fixed incompatibility with 5.001 and FileHandle::new_tmpfile
Added COPYING file, and improved README.

=back




=head1 AUTHOR

MIME-tools was created by:

    ___  _ _ _   _  ___ _
   / _ \| '_| | | |/ _ ' /    Eryq, (eryq@zeegee.com)
  |  __/| | | |_| | |_| |     President, ZeeGee Software Inc.
   \___||_|  \__, |\__, |__   http://www.zeegee.com/
             |___/    |___/

Released as MIME-parser (1.0): 28 April 1996.
Released as MIME-tools (2.0): Halloween 1996.
Released as MIME-tools (4.0): Christmas 1997.
Released as MIME-tools (5.0): Mother's Day 2000.



=head1 ACKNOWLEDGMENTS

B<This kit would not have been possible> but for the direct
contributions of the following:

    Gisle Aas             The MIME encoding/decoding modules.
    Laurent Amon          Bug reports and suggestions.
    Graham Barr           The new MailTools.
    Achim Bohnet          Numerous good suggestions, including the I/O model.
    Kent Boortz           Initial code for RFC-1522-decoding of MIME headers.
    Andreas Koenig        Numerous good ideas, tons of beta testing,
                            and help with CPAN-friendly packaging.
    Igor Starovoitov      Bug reports and suggestions.
    Jason L Tibbitts III  Bug reports, suggestions, patches.

Not to mention the Accidental Beta Test Team, whose bug reports (and
comments) have been invaluable in improving the whole:

    Phil Abercrombie
    Mike Blazer
    Brandon Browning
    Kurt Freytag
    Steve Kilbane
    Jake Morrison
    Rolf Nelson
    Joel Noble
    Michael W. Normandin
    Tim Pierce
    Andrew Pimlott
    Dragomir R. Radev
    Nickolay Saukh
    Russell Sutherland
    Larry Virden
    Zyx

Please forgive me if I've accidentally left you out.
Better yet, email me, and I'll put you in.



=head1 SEE ALSO

At the time of this writing ($Date: 2006-07-26 21:49:11 $), the
MIME-tools homepage was
F<http://www.mimedefang.org/static/mime-tools.php>.  Check there for
updates and support.

Users of this toolkit may wish to read the documentation of Mail::Header
and Mail::Internet.

The MIME format is documented in RFCs 1521-1522, and more recently
in RFCs 2045-2049.

The MIME header format is an outgrowth of the mail header format
documented in RFC 822.


=cut
