use warnings;
use strict;

package Class::ReturnValue;


=head1 NAME

Class::ReturnValue - A return-value object that lets you treat it 
as as a boolean, array or object

=head1 DESCRIPTION

Class::ReturnValue is a "clever" return value object that can allow
code calling your routine to expect:
    a boolean value (did it fail)
or  a list (what are the return values)

=head1 EXAMPLE

    sub demo {
        my $value = shift;
        my $ret = Class::ReturnValue->new();
        $ret->as_array('0', 'No results found');
    
        unless($value) {
            $ret->as_error(errno => '1',
                               message => "You didn't supply a parameter.",
                               do_backtrace => 1);
        }

        return($ret->return_value);
    }

    if (demo('foo')){ 
        print "the routine succeeded with one parameter";
    }
    if (demo()) {
        print "The routine succeeded with 0 paramters. shouldn't happen";
    } else {
        print "The routine failed with 0 parameters (as it should).";
    }


    my $return = demo();
    if ($return) {
        print "The routine succeeded with 0 paramters. shouldn't happen";
    } else {
        print "The routine failed with 0 parameters (as it should). ".
              "Stack trace:\n".
        $return->backtrace;
    }

    my @return3 = demo('foo');
    print "The routine got ".join(',',@return3).
          "when asking for demo's results as an array";


    my $return2 = demo('foo');

    unless ($return2) {
        print "The routine failed with a parameter. shouldn't happen.".
             "Stack trace:\n".
        $return2->backtrace;
    }

    my @return2_array = @{$return2}; # TODO: does this work
    my @return2_array2 = $return2->as_array;


=cut


use Exporter;

use vars qw/$VERSION @EXPORT @ISA/;

@ISA = qw/Exporter/;
@EXPORT = qw /&return_value/;
use Carp;
use Devel::StackTrace;
use Data::Dumper;


$VERSION = '0.55';


use overload 'bool' => \&error_condition;
use overload '""' => \&error_condition;
use overload 'eq' => \&my_eq;
use overload '@{}' => \&as_array;
use overload 'fallback' => \&as_array;


=head1 METHODS 

=item new

Instantiate a new Class::ReturnValue object

=cut

sub new {
    my $self = {};
    bless($self);
    return($self);
}

sub my_eq {
    my $self = shift;
    if (wantarray()) {
        return($self->as_array);
    }
    else {
        return($self);
    }    
}

=item as_array

Return the 'as_array' attribute of this object as an array.

=cut


=item as_array [ARRAY]

If $self is called in an array context, returns the array specified in ARRAY

=cut

sub as_array {

    my $self = shift;
    if (@_) { 
        @{$self->{'as_array'}} = (@_);
    }
    return(@{$self->{'as_array'}});
}


=item as_error HASH

Turns this return-value object into  an error return object.  TAkes three parameters:

    message
    do_backtrace
    errno 

    'message' is a human readable error message explaining what's going on

    'do_backtrace' is a boolean. If it's true, a carp-style backtrace will be 
    stored in $self->{'backtrace'}. It defaults to true

    errno and message default to undef. errno _must_ be specified. 
    It's a numeric error number.  Any true integer value  will cause the 
    object to evaluate to false in a scalar context. At first, this may look a 
    bit counterintuitive, but it means that you can have error codes and still 
    allow simple use of your functions in a style like this:


        if ($obj->do_something) {
            print "Yay! it worked";
        } else {
            print "Sorry. there's been an error.";
        }


        as well as more complex use like this:

        my $retval = $obj->do_something;
        
        if ($retval) {
            print "Yay. we did something\n";
            my ($foo, $bar, $baz) = @{$retval};
            my $human_readable_return = $retval;
        } else {
            if ($retval->errno == 20) {
                die "Failed with error 20 (Not enough monkeys).";
            } else {
                die  $retval->backtrace; # Die and print out a backtrace 
            }
        }
    

=cut

sub as_error {
    my $self = shift;
    my %args = ( errno => undef,
                 message => undef,
                 do_backtrace => 1,
                 @_);

    unless($args{'errno'}) {
        carp "$self -> as_error called without an 'errno' parameter";
        return (undef);
    }

    $self->{'errno'} = $args{'errno'};
    $self->{'error_message'} = $args{'message'};
    if ($args{'do_backtrace'}) {
        # Use carp's internal backtrace methods, rather than duplicating them ourselves
         my $trace = Devel::StackTrace->new(ignore_package => 'Class::ReturnValue');

        $self->{'backtrace'} = $trace->as_string; # like carp
    }

    return(1);
}


=item errno 

Returns the errno if there's been an error. Otherwise, return undef

=cut

sub errno { 
    my $self = shift;
    if ($self->{'errno'}) {
        return ($self->{'errno'});
     }
     else {
        return(undef);
     }
}


=item error_message

If there's been an error return the error message.

=cut

sub error_message {
    my $self = shift;
    if ($self->{'error_message'}) {
        return($self->{'error_message'});
    }
    else {
        return(undef);
    }
}


=item backtrace

If there's been an error and we asked for a backtrace, return the backtrace. 
Otherwise, return undef.

=cut

sub backtrace {
    my $self = shift;
    if ($self->{'backtrace'}) {
        return($self->{'backtrace'});
    }
    else {
        return(undef);
    }
}

=cut

=item error_condition

If there's been an error, return undef. Otherwise return 1

=cut

sub error_condition { 
    my $self = shift;
    if ($self->{'errno'}) {
            return (undef);
        }
        elsif (wantarray()) {
            return(@{$self->{'as_array'}});
        }
       else { 
            return(1);
       }     
}

sub return_value {
    my $self = shift;
    if (wantarray) {
         return ($self->as_array);
    }
    else {
       return ($self);
    }
}


=head1 AUTHOR
    
    Jesse Vincent <jesse@bestpractical.com>

=head1 BUGS

    This module has, as yet, not been used in production code. I thing
    it should work, but have never benchmarked it. I have not yet used
    it extensively, though I do plan to in the not-too-distant future.
    If you have questions or comments,  please write me.

    If you need to report a bug, please send mail to 
    <bug-class-returnvalue@rt.cpan.org> or report your error on the web
    at http://rt.cpan.org/

=head1 COPYRIGHT

    Copyright (c) 2002,2003,2005,2007 Jesse Vincent <jesse@bestpractical.com>
    You may use, modify, fold, spindle or mutilate this module under
    the same terms as perl itself.

=head1 SEE ALSO

    Class::ReturnValue isn't an exception handler. If it doesn't
    do what you want, you might want look at one of the exception handlers
    below:

    Error, Exception, Exceptions, Exceptions::Class

    You might also want to look at Contextual::Return, another implementation
    of the same concept as this module.

=cut

1;
