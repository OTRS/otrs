package URI::IRI;

# Experimental

use strict;
use URI ();

use overload '""' => sub { shift->as_string };

sub new {
    my($class, $uri, $scheme) = @_;
    utf8::upgrade($uri);
    return bless {
	uri => URI->new($uri, $scheme),
    }, $class;
}

sub clone {
    my $self = shift;
    return bless {
	uri => $self->{uri}->clone,
    }, ref($self);
}

sub as_string {
    my $self = shift;
    return $self->{uri}->as_iri;
}

sub AUTOLOAD
{
    use vars qw($AUTOLOAD);
    my $method = substr($AUTOLOAD, rindex($AUTOLOAD, '::')+2);

    # We create the function here so that it will not need to be
    # autoloaded the next time.
    no strict 'refs';
    *$method = sub { shift->{uri}->$method(@_) };
    goto &$method;
}

sub DESTROY {}   # avoid AUTOLOADing it

1;
