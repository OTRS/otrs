package Email::Valid;

use strict;
use vars qw( $VERSION $RFC822PAT %AUTOLOAD $AUTOLOAD $NSLOOKUP_PAT
             @NSLOOKUP_PATHS $Details $Resolver $Nslookup_Path 
             $DNS_Method $Debug );
use Carp;
use IO::File;
use Mail::Address;

$VERSION = '0.14';

%AUTOLOAD = ( mxcheck => 1, fudge => 1, fqdn => 1, local_rules => 1 );
$NSLOOKUP_PAT = 'preference|serial|expire|mail\s+exchanger';
@NSLOOKUP_PATHS = qw( /usr/bin /usr/sbin /bin );
$DNS_Method = '';

sub new {
  my $class   = shift;

  $class = ref $class || $class;
  bless my $self = {}, $class;
  $self->_initialize;
  %$self = $self->_rearrange([qw( mxcheck fudge fqdn local_rules )], \@_);
  return $self;
}

sub version { $VERSION };

sub _initialize {
  my $self = shift;

  $self->{mxcheck}     = 0;
  $self->{fudge}       = 0;
  $self->{fqdn}        = 1;
  $self->{local_rules} = 0;
  $self->{details}     = $Details = undef;
}            

# Pupose: handles named parameter calling style
sub _rearrange {
  my $self = shift;
  my(@names)  = @{ shift() };
  my(@params) = @{ shift() };
  my(%args);

  ref $self ? %args = %$self : _initialize( \%args );
  return %args unless @params;
  
  unless ($params[0] =~ /^-/) {
    while(@params) {
      croak 'unexpected number of parameters' unless @names;
      $args{ lc shift @names } = shift @params;
    }
    return %args;
  }

  while(@params) {
    my $param = lc substr(shift @params, 1);
    $args{ $param } = shift @params;
  }

  %args;
}                         

# Purpose: determine why an address failed a check
sub details {
  my $self = shift;

  return (ref $self ? $self->{details} : $Details) unless @_;
  $Details = shift;
  $self->{details} = $Details if ref $self;
  return undef;
}

# Purpose: Check whether address conforms to RFC 822 syntax.
sub rfc822 {
  my $self = shift;
  my %args = $self->_rearrange([qw( address )], \@_);

  my $addr = $args{address} or return $self->details('rfc822');
  $addr = $addr->address if UNIVERSAL::isa($addr, 'Mail::Address');

  return $self->details('rfc822') unless $addr =~ m/^$RFC822PAT$/o;

  return 1;
}

# Purpose: attempt to locate the nslookup utility 
sub _find_nslookup {
  my $self = shift;
 
  foreach my $path (@NSLOOKUP_PATHS) {
    return "$path/nslookup" if -x "$path/nslookup" and !-d _;
  }
  return undef;
}               

sub _select_dns_method {
  # Configure a global resolver object for DNS queries
  # if Net::DNS is available
  eval { require Net::DNS };
  return $DNS_Method = 'Net::DNS' unless $@;
 
  $DNS_Method = 'nslookup';
}

# Purpose: perform DNS query using the Net::DNS module
sub _net_dns_query {
  my $self = shift;
  my $host = shift;

  $Resolver = Net::DNS::Resolver->new unless defined $Resolver; 

  my $packet = $Resolver->send($host, 'A')
    or croak $Resolver->errorstring;
  return 1 if $packet->header->ancount;
 
  $packet = $Resolver->send($host, 'MX')
    or croak $Resolver->errorstring;
  return 1 if $packet->header->ancount;
 
  return $self->details('mx');               
}

# Purpose: perform DNS query using the nslookup utility
sub _nslookup_query {
  my $self = shift;
  my $host = shift;
  local($/, *OLDERR);

  unless ($Nslookup_Path) {
    $Nslookup_Path = $self->_find_nslookup
      or croak 'unable to locate nslookup';
  }

  # Check for an A record
  return 1 if gethostbyname $host;

  # Check for an MX record
  if (my $fh = new IO::File '-|') {
    my $response = <$fh>;
    print STDERR $response if $Debug;
    close $fh;
    $response =~ /$NSLOOKUP_PAT/io or return $self->details('mx');
    return 1;
  } else {
    open OLDERR, '>&STDERR' or croak "cannot dup stderr: $!";
    open STDERR, '>&STDOUT' or croak "cannot redirect stderr to stdout: $!";
    {
      exec $Nslookup_Path, '-query=mx', $host;
    }
    open STDERR, ">&OLDERR";
    croak "unable to execute nslookup '$Nslookup_Path': $!";
  }                                                                             
}

# Purpose: Check whether a DNS record (A or MX) exists for a domain.
sub mx {
  my $self = shift;
  my %args = $self->_rearrange([qw( address )], \@_);

  my $addr = $args{address} or return $self->details('mx');
  $addr = $addr->address if UNIVERSAL::isa($addr, 'Mail::Address');

  my $host = ($addr =~ /^.*@(.*)$/ ? $1 : $addr);
  $host =~ s/\s+//g;
 
  # REMOVE BRACKETS IF IT'S A DOMAIN-LITERAL
  #   RFC822 3.4.6
  #   Square brackets ("[" and "]") are used to indicate the
  #   presence of a domain-literal, which the appropriate
  #   name-domain is to use directly, bypassing normal
  #   name-resolution mechanisms.
  $host =~ s/(^\[)|(\]$)//g;              

  $self->_select_dns_method unless $DNS_Method;

  if ($DNS_Method eq 'Net::DNS') {
    print STDERR "using Net::DNS for dns query\n" if $Debug;
    return $self->_net_dns_query( $host );
  } elsif ($DNS_Method eq 'nslookup') {
    print STDERR "using nslookup for dns query\n" if $Debug;
    return $self->_nslookup_query( $host );
  } else {
    croak "unknown DNS method '$DNS_Method'";
  }
}

# Purpose: Fix common addressing errors
# Returns: Possibly modified address
sub _fudge {
  my $self = shift;
  my $addr = shift;

  $addr =~ s/\s+//g if $addr =~ /aol\.com$/i;
  $addr =~ s/,/./g  if $addr =~ /compuserve\.com$/i;
  $addr;
}

# Purpose: Special address restrictions on a per-domain basis.
# Caveats: These organizations may change their rules at any time.  
sub _local_rules {
  my $self = shift;
  my($user, $host) = @_;

  # AOL ADDRESSING CONVENTIONS (according to their autoresponder)
  #   AOL addresses cannot:
  #     - be shorter than 3 or longer than 10 characters
  #     - begin with numerals
  #     - contain periods, underscores, dashes or other punctuation
  #                  
  if ($host =~ /aol\.com/i) {
    return undef unless $user =~ /^[a-zA-Z][a-zA-Z0-9]{2,9}$/;
  }
  1;  
}

# Purpose: Put an address through a series of checks to determine 
#          whether it should be considered valid.
sub address {
  my $self = shift;
  my %args = $self->_rearrange([qw( address fudge mxcheck fqdn  
                                    local_rules )], \@_);

  my $addr = $args{address} or return $self->details('rfc822');
  $addr = $addr->address if UNIVERSAL::isa($addr, 'Mail::Address');

  $addr = $self->_fudge( $addr ) if $args{fudge};
  $self->rfc822( $addr ) or return undef;

  ($addr) = Mail::Address->parse( $addr );
  $addr or return $self->details('rfc822'); # This should never happen

  if ($args{local_rules}) {
    $self->_local_rules( $addr->user, $addr->host ) 
      or return $self->details('local_rules');
  }

  if ($args{fqdn}) {
    $addr->host =~ /^.+\..+$/ or return $self->details('fqdn');
  }

  if ($args{mxcheck}) {
    $self->mx( $addr->host ) or return undef; 
  }

  return (wantarray ? ($addr->address, $addr) : $addr->address);  
}

sub AUTOLOAD {
  my $self = shift;
  my $type = ref($self) || die "$self is not an object";
  my $name = $AUTOLOAD;

  $name =~ s/.*://;
  return if $name eq 'DESTROY';
  die "unknown autoload name '$name'" unless $AUTOLOAD{$name};

  return (@_ ? $self->{$name} = shift : $self->{$name});
}               

# Regular expression built using Jeffrey Friedl's example in
# _Mastering Regular Expressions_ (http://www.ora.com/catalog/regexp/).

$RFC822PAT = <<'EOF';
[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\
xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xf
f\n\015()]*)*\)[\040\t]*)*(?:(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\x
ff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|"[^\\\x80-\xff\n\015
"]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015"]*)*")[\040\t]*(?:\([^\\\x80-\
xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80
-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*
)*(?:\.[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\
\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\
x80-\xff\n\015()]*)*\)[\040\t]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x8
0-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|"[^\\\x80-\xff\n
\015"]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015"]*)*")[\040\t]*(?:\([^\\\x
80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^
\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040
\t]*)*)*@[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([
^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\
\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\
x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-
\xff\n\015\[\]]|\\[^\x80-\xff])*\])[\040\t]*(?:\([^\\\x80-\xff\n\015()
]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\
x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:\.[\04
0\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\
n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\
015()]*)*\)[\040\t]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?!
[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\
]]|\\[^\x80-\xff])*\])[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\
x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\01
5()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*)*|(?:[^(\040)<>@,;:".
\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]
)|"[^\\\x80-\xff\n\015"]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015"]*)*")[^
()<>@,;:".\\\[\]\x80-\xff\000-\010\012-\037]*(?:(?:\([^\\\x80-\xff\n\0
15()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][
^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)|"[^\\\x80-\xff\
n\015"]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015"]*)*")[^()<>@,;:".\\\[\]\
x80-\xff\000-\010\012-\037]*)*<[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?
:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-
\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:@[\040\t]*
(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015
()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()
]*)*\)[\040\t]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\0
40)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\
[^\x80-\xff])*\])[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\
xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*
)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:\.[\040\t]*(?:\([^\\\x80
-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x
80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t
]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\
\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])
*\])[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x
80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80
-\xff\n\015()]*)*\)[\040\t]*)*)*(?:,[\040\t]*(?:\([^\\\x80-\xff\n\015(
)]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\
\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*@[\040\t
]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\0
15()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015
()]*)*\)[\040\t]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(
\040)<>@,;:".\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|
\\[^\x80-\xff])*\])[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80
-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()
]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:\.[\040\t]*(?:\([^\\\x
80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^
\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040
\t]*)*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".
\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff
])*\])[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\
\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x
80-\xff\n\015()]*)*\)[\040\t]*)*)*)*:[\040\t]*(?:\([^\\\x80-\xff\n\015
()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\
\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*)?(?:[^
(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-
\037\x80-\xff])|"[^\\\x80-\xff\n\015"]*(?:\\[^\x80-\xff][^\\\x80-\xff\
n\015"]*)*")[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|
\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))
[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:\.[\040\t]*(?:\([^\\\x80-\xff
\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\x
ff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(
?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\
000-\037\x80-\xff])|"[^\\\x80-\xff\n\015"]*(?:\\[^\x80-\xff][^\\\x80-\
xff\n\015"]*)*")[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\x
ff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)
*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*)*@[\040\t]*(?:\([^\\\x80-\x
ff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-
\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)
*(?:[^(\040)<>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\
]\000-\037\x80-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\]
)[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-
\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\x
ff\n\015()]*)*\)[\040\t]*)*(?:\.[\040\t]*(?:\([^\\\x80-\xff\n\015()]*(
?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]*(?:\\[^\x80-\xff][^\\\x80
-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)*\)[\040\t]*)*(?:[^(\040)<
>@,;:".\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\[\]\000-\037\x8
0-\xff])|\[(?:[^\\\x80-\xff\n\015\[\]]|\\[^\x80-\xff])*\])[\040\t]*(?:
\([^\\\x80-\xff\n\015()]*(?:(?:\\[^\x80-\xff]|\([^\\\x80-\xff\n\015()]
*(?:\\[^\x80-\xff][^\\\x80-\xff\n\015()]*)*\))[^\\\x80-\xff\n\015()]*)
*\)[\040\t]*)*)*>)
EOF

$RFC822PAT =~ s/\n//g;

1;

__END__

=head1 NAME

Email::Valid - Check validity of Internet email addresses 

=head1 SYNOPSIS

  use Email::Valid;
  print (Email::Valid->address('maurice@hevanet.com') ? 'yes' : 'no');

=head1 DESCRIPTION

This module determines whether an email address is well-formed, and
optionally, whether a mail host exists for the domain.

Please note that there is no way to determine whether an
address is deliverable without attempting delivery (for details, see
perlfaq 9).

=head1 PREREQUISITES

This module requires perl 5.004 or later and the Mail::Address module.
Either the Net::DNS module or the nslookup utility is required
for DNS checks.

=head1 METHODS

  Every method which accepts an <ADDRESS> parameter may
  be passed either a string or an instance of the Mail::Address
  class.  All errors raise an exception.

=over 4

=item new ( [PARAMS] )

This method is used to construct an Email::Valid object.
It accepts an optional list of named parameters to
control the behavior of the object at instantiation.

The following named parameters are allowed.  See the
individual methods below of details.

 -mxcheck
 -fudge
 -fqdn
 -local_rules

=item mx ( <ADDRESS>|<DOMAIN> )

This method accepts an email address or domain name and determines
whether a DNS record (A or MX) exists for it.

The method returns true if a record is found and undef if not.

Either the Net::DNS module or the nslookup utility is required for
DNS checks.  Using Net::DNS is the preferred method since error
handling is improved.  If Net::DNS is available, you can modify
the behavior of the resolver (e.g. change the default tcp_timeout
value) by manipulating the global Net::DNS::Resolver instance stored in
$Email::Valid::Resolver.     

=item rfc822 ( <ADDRESS> )

This method determines whether an address conforms to the RFC822
specification (except for nested comments).  It returns true if it
conforms and undef if not.

=item fudge ( <TRUE>|<FALSE> )

Specifies whether calls to address() should attempt to correct
common addressing errors.  Currently, this results in the removal of
spaces in AOL addresses, and the conversion of commas to periods in
Compuserve addresses.  The default is false.

=item fqdn ( <TRUE>|<FALSE> )

Species whether addresses passed to address() must contain a fully
qualified domain name (FQDN).  The default is true.

=item local_rules ( <TRUE>|<FALSE> )

Specifies whether addresses passed to address() should be tested
for domain specific restrictions.  Currently, this is limited to
certain AOL restrictions that I'm aware of.  The default is false.

=item mxcheck ( <TRUE>|<FALSE> )

Specifies whether addresses passed to address() should be checked
for a valid DNS entry.  The default is false.

=item address ( <ADDRESS> )

This is the primary method which determines whether an email 
address is valid.  It's behavior is modified by the values of
mxcheck(), local_rules(), fqdn(), and fudge().  If the address
passes all checks, the (possibly modified) address is returned as
a string.  Otherwise, the undefined value is returned.
In a list context, the method also returns an instance of the
Mail::Address class representing the email address.

=item details ()

If the last call to address() returned undef, you can call this
method to determine why it failed.  Possible values are:

 rfc822
 local_rules
 fqdn
 mxcheck  

If the class is not instantiated, you can get the same information
from the global $Email::Valid::Details.  

=back

=head1 EXAMPLES

Let's see if the address 'maurice@hevanet.com' conforms to the
RFC822 specification:

  print (Email::Valid->address('maurice@hevanet.com') ? 'yes' : 'no');

Additionally, let's make sure there's a mail host for it:

  print (Email::Valid->address( -address => 'maurice@hevanet.com',
                                -mxcheck => 1 ) ? 'yes' : 'no');

Let's see an example of how the address may be modified:

  $addr = Email::Valid->address('Alfred Neuman <Neuman @ foo.bar>');
  print "$addr\n"; # prints Neuman@foo.bar 

Need to determine why an address failed?

  unless(Email::Valid->address('maurice@hevanet')) {
    print "address failed $Email::Valid::Details check.\n";
  }

If an error is encountered, an exception is raised.  This is really
only possible when performing DNS queries.  Trap any exceptions by
wrapping the call in an eval block: 

  eval {
    $addr = Email::Valid->address( -address => 'maurice@hevanet.com',
                                   -mxcheck => 1 );
  };
  warn "an error was encountered: $@" if $@; 

=head1 BUGS

Email::Valid should work with Perl for Win32.  In my experience,
however, Net::DNS queries seem to take an extremely long time when
a record cannot be found.

=head1 AUTHOR

Copyright 1998-1999, Maurice Aubrey E<lt>maurice@hevanet.comE<gt>. 
All rights reserved.

This module is free software; you may redistribute it and/or
modify it under the same terms as Perl itself.

=head1 CREDITS

Significant portions of this module are based on the ckaddr program
written by Tom Christiansen and the RFC822 address pattern developed
by Jeffrey Friedl.  Neither were involved in the construction of this 
module; all errors are mine.

Thanks very much to the following people for their suggestions and
bug fixes:

  Otis Gospodnetic <otis@DOMINIS.com>
  Kim Ryan <kimaryan@ozemail.com.au>
  Pete Ehlke <pde@listserv.music.sony.com> 
  Lupe Christoph
  David Birnbaum
  Achim

=head1 SEE ALSO

Mail::Address, Net::DNS, perlfaq9

=cut
