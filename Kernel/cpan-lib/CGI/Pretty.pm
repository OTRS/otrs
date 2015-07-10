package CGI::Pretty;

use strict;
use if $] >= 5.019, 'deprecate';
use CGI ();

$CGI::Pretty::VERSION = '4.21';
$CGI::DefaultClass = __PACKAGE__;
@CGI::Pretty::ISA = qw( CGI );

sub new {
    my $class = shift;
    my $this = $class->SUPER::new( @_ );
    return bless $this, $class;
}

sub import {

	warn "CGI::Pretty is DEPRECATED and will be removed in a future release. Please see https://github.com/leejo/CGI.pm/issues/162 for more information";

    my $self = shift;
    no strict 'refs';

    # This causes modules to clash.
    undef %CGI::EXPORT;
    undef %CGI::EXPORT;

    $self->_setup_symbols(@_);
    my ($callpack, $callfile, $callline) = caller;

    # To allow overriding, search through the packages
    # Till we find one in which the correct subroutine is defined.
    my @packages = ($self,@{"$self\:\:ISA"});
    foreach my $sym (keys %CGI::EXPORT) {
	my $pck;
	my $def = $CGI::DefaultClass;
	foreach $pck (@packages) {
	    if (defined(&{"$pck\:\:$sym"})) {
		$def = $pck;
		last;
	    }
	}
	*{"${callpack}::$sym"} = \&{"$def\:\:$sym"};
    }
}

1;

=head1 NAME

CGI::Pretty - module to produce nicely formatted HTML code

=head1 CGI::Pretty IS DEPRECATED

It will be removed from the CGI distribution in a future release, so you
should no longer use it and remove it from any code that currently uses it.

For now it has been reduced to a shell to prevent your code breaking, but
the "pretty" functions will no longer output "pretty" HTML.

=head1 Alternatives

L<HTML::HTML5::Parser> + L<HTML::HTML5::Writer> + L<XML::LibXML::PrettyPrint>:

    use HTML::HTML5::Parser qw();
    use HTML::HTML5::Writer qw();
    use XML::LibXML::PrettyPrint qw();

    print HTML::HTML5::Writer->new(
        start_tags => 'force',
        end_tags   => 'force',
    )->document(
        XML::LibXML::PrettyPrint->new_for_html( indent_string => "\t" )
        ->pretty_print(
            HTML::HTML5::Parser->new->parse_string( $html_string )
        )
    );

L<Marpa::R2::HTML> (see the html_fmt script for examples)

L<HTML::Tidy>

L<HTML::Parser>

=cut
