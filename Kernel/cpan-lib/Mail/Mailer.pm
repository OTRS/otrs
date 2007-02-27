#

package Mail::Mailer;

use POSIX qw/_exit/;

=head1 NAME

Mail::Mailer - Simple interface to electronic mailing mechanisms 

=head1 SYNOPSIS

    use Mail::Mailer;
    use Mail::Mailer qw(mail);    # specifies default mailer

    $mailer = new Mail::Mailer;

    $mailer = new Mail::Mailer $type, @args;

    $mailer->open(\%headers);

    print $mailer $body;

    $mailer->close;


=head1 DESCRIPTION

Sends mail using any of the built-in methods. As C<$type> you can specify
any of:

=over 4

=item C<sendmail>
Use the C<sendmail> program to deliver the mail.

=item C<smtp>

Use the C<smtp> protocol via Net::SMTP to deliver the mail. The server
to use can be specified in C<@args> with

    $mailer = new Mail::Mailer 'smtp', Server => $server;

The smtp mailer does not handle C<Cc> and C<Bcc> lines, neither their
C<Resent-*> fellows. The C<Debug> options enables debugging output
from C<Net::SMTP>.

You may also use the C<< Auth => [ $user, $password ] >> option for SASL
authentication (requires L<Authen::SASL> and L<MIME::Base64>).

=item C<qmail>

Use qmail's qmail-inject program to deliver the mail.

=item C<testfile>

Used for debugging, this displays the data to the file named in
C<$Mail::Mailer::testfile::config{outfile}> which defaults to a file
named C<mailer.testfile>.  No mail is ever sent.

=back

C<Mail::Mailer> will search for executables in the above order. The
default mailer will be the first one found.

=head2 ARGUMENTS

C<new> can optionally be given a C<$type>, which
is one C<sendmail>, C<mail>, ... given above.

C<open> is given a reference to a hash.  The hash consists of key and
value pairs, the key being the name of the header field (eg, C<To>),
and the value being the corresponding contents of the header field.
The value can either be a scalar (eg, C<gnat@frii.com>) or a reference
to an array of scalars (C<eg, ['gnat@frii.com', 'Tim.Bunce@ig.co.uk']>).

=head1 TO DO

Assist formatting of fields in ...::rfc822:send_headers to ensure
valid in the face of newlines and longlines etc.

Secure all forms of send_headers() against hacker attack and invalid
contents. Especially "\n~..." in ...::mail::send_headers.

=head1 ENVIRONMENT VARIABLES

=over 4

=item PERL_MAILERS

Augments/override the build in choice for binary used to send out
our mail messages.

Format:

    "type1:mailbinary1;mailbinary2;...:type2:mailbinaryX;...:..."

Example: assume you want you use private sendmail binary instead
of mailx, one could set C<PERL_MAILERS> to:

    "mail:/does/not/exists:sendmail:$HOME/test/bin/sendmail"

On systems which may include C<:> in file names, use C<|> as separator
between type-groups.

    "mail:c:/does/not/exists|sendmail:$HOME/test/bin/sendmail"


=back

=head1 SEE ALSO

Mail::Send

=head1 AUTHORS

Maintained by Mark Overmeer <mailtools@overmeer.net>

Original code written by Tim Bunce E<lt>F<Tim.Bunce@ig.co.uk>E<gt>,
with a kick start from Graham Barr E<lt>F<gbarr@pobox.com>E<gt>. With
contributions by Gerard Hickey E<lt>F<hickey@ctron.com>E<gt> Small fix
and documentation by Nathan Torkington E<lt>F<gnat@frii.com>E<gt>.

=cut

use Carp;
use IO::Handle;
use vars qw(@ISA $VERSION $MailerBinary $MailerType %Mailers @Mailers);
use Config;
use strict;

$VERSION = "1.74";

sub Version { $VERSION }

@ISA = qw(IO::Handle);

# Suggested binaries for types?  Should this be handled in the object class?
@Mailers = (

    # Headers-blank-Body all on stdin
    'sendmail'  => '/usr/lib/sendmail;/usr/sbin/sendmail;/usr/ucblib/sendmail',

    'smtp'	=> undef,
    'qmail'     => '/usr/sbin/qmail-inject;/var/qmail/bin/qmail-inject',
    'testfile'	=> undef
);

if($ENV{PERL_MAILERS})
{   push @Mailers
       , map { split /\:/, $_, 2}
             split /$Config{path_sep}/, $ENV{PERL_MAILERS};
}

%Mailers = @Mailers;

$MailerBinary = undef;

# does this really need to be done? or should a default mailer be specfied?

if($^O eq 'os2') {
    $Mailers{sendmail} = 'sendmail' unless is_exe($Mailers{sendmail});
}

if($^O eq 'MacOS' || $^O eq 'VMS' || $^O eq 'MSWin32' || $^O eq 'os2') {
    $MailerType = 'smtp';
    $MailerBinary = $Mailers{$MailerType};
}
else {
    my $i;
    for($i = 0 ; $i < @Mailers ; $i += 2) {
	$MailerType = $Mailers[$i];
	my $binary;
	if($binary = is_exe($Mailers{$MailerType})) {
	    $MailerBinary = $binary;
	    last;
	}
    }
}

sub import {
    shift;

    if(@_) {
	my $type = shift;
	my $exe = shift || $Mailers{$type};

        carp "Cannot locate '$exe'"
            unless is_exe($exe);

        $MailerType = $type;
        $Mailers{$MailerType} = $exe;
    }
}

sub to_array {
    my($self, $thing) = @_;
    if (ref($thing)) {
	return @$thing;
    } else {
	return ($thing);
    }
}

sub is_exe {
    my $exe = shift || '';
    my $cmd;

    foreach $cmd (split /\;/, $exe) {
	$cmd =~ s/^\s+//;

	# remove any options
	my $name = ($cmd =~ /^(\S+)/)[0];

	# check for absolute or relative path
	return ($cmd)
	    if (-x $name and ! -d $name and $name =~ m:[\\/]:);

	if (defined $ENV{PATH}) {
	    my $dir;
	    foreach $dir (split(/$Config{path_sep}/, $ENV{PATH})) {
		return "$dir/$cmd"
		    if (-x "$dir/$name" && ! -d "$dir/$name");
	    }
	}
    }
    0;
}

sub new {
    my($class, $type, @args) = @_;

    $type = $MailerType unless $type;
    croak "No MailerType specified" unless defined $type;

    my $exe = $Mailers{$type};

    if(defined($exe)) {
	$exe = is_exe ($exe) if defined $type;

	$exe  = $MailerBinary  unless $exe;
	croak "No mailer type specified (and no default available), thus can not find executable program."
	    unless $exe;
    }

    $class = "Mail::Mailer::$type";
    eval "require $class" or die $@;
    my $glob = $class->SUPER::new; # local($glob) = gensym;	# Make glob for FileHandle and attributes

    %{*$glob} = (Exe 	=> $exe,
		 Args	=> [ @args ]
		);
    
    $glob; # bless $glob, $class;
}


sub open {
    my($self, $hdrs) = @_;
    my $exe  = *$self->{Exe};   # no exe, then direct smtp
    my $args = *$self->{Args};

# removed MO 20050331: destroyed the folding
#   _cleanup_hdrs($hdrs);

    my @to = $self->who_to($hdrs);
    
    $self->close;	# just in case;

    if(defined $exe)
    {   # Fork and start a mailer
        my $child = open $self, '|-';
        defined $child or die "Failed to send: $!";

        if($child==0)
        {   # Child process will handle sending, but this is not real exec()
            # this is a setup!!!
            unless($self->exec($exe, $args, \@to))
            {   warn $!;     # setup failed
                _exit(1);    # no DESTROY(), keep it for parent
            }
        }
    }
    else
    {   $self->exec($exe, $args, \@to)
            or die $!;
    }

    # Set the headers
    $self->set_headers($hdrs);

    # return self (a FileHandle) ready to accept the body
    $self;
}


sub _cleanup_hdrs {
  my $hdrs = shift;
  my $h;
  foreach $h (values %$hdrs) {
    foreach (ref($h) ? @{$h} : $h) {
      s/\n\s*/ /g;
      s/\s+$//;
    }
  }
}


sub exec {
    my($self, $exe, $args, $to) = @_;
    # Fork and exec the mailer (no shell involved to avoid risks)
    my @exe = split(/\s+/,$exe);

    exec(@exe, @$args, @$to);
}

sub can_cc { 1 }	# overridden in subclass for mailer that can't

sub who_to {
    my($self, $hdrs) = @_;
    my @to = $self->to_array($hdrs->{To});
    if (!$self->can_cc) {  # Can't cc/bcc so add them to @to
	push(@to, $self->to_array($hdrs->{Cc})) if $hdrs->{Cc};
	push(@to, $self->to_array($hdrs->{Bcc})) if $hdrs->{Bcc};
    }
    @to;
}

sub epilogue {
    # This could send a .signature, also see ::smtp subclass
}

sub close {
    my($self, @to) = @_;
    if (fileno($self)) {
	$self->epilogue;
	close($self)
    }
}


sub DESTROY {
    my $self = shift;
    $self->close;
}

1;

