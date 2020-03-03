package Eval::TypeTiny;

use strict;

sub _clean_eval {
	local $@;
	local $SIG{__DIE__};
	my $r = eval $_[0];
	my $e = $@;
	return ($r, $e);
}

use warnings;

BEGIN {
	*HAS_LEXICAL_SUBS = ($] >= 5.018) ? sub(){!!1} : sub(){!!0};
};

{
	# this is unused now and will be removed in a future version of Eval::TypeTiny
	my $hlv;
	sub HAS_LEXICAL_VARS () {
		$hlv = !! eval {
			require Devel::LexAlias;
			exists(&Devel::LexAlias::lexalias);
		} unless defined $hlv;
		$hlv;
	}
}

BEGIN {
	sub IMPLEMENTATION_DEVEL_LEXALIAS   () { 'Devel::LexAlias' }
	sub IMPLEMENTATION_PADWALKER        () { 'PadWalker' }
	sub IMPLEMENTATION_TIE              () { 'tie' }
	sub IMPLEMENTATION_NATIVE           () { 'perl' }
	
	my $implementation;
	sub ALIAS_IMPLEMENTATION () {
		$implementation ||= do {
			do   { $] ge '5.022'           } ? IMPLEMENTATION_NATIVE :
			eval { require Devel::LexAlias } ? IMPLEMENTATION_DEVEL_LEXALIAS :
			eval { require PadWalker       } ? IMPLEMENTATION_PADWALKER      : IMPLEMENTATION_TIE
		};
	}
	
	sub _force_implementation {
		$implementation = shift;
	}
}

BEGIN {
	*_EXTENDED_TESTING = ($ENV{EXTENDED_TESTING}) ? sub(){!!1} : sub(){!!0};
};

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '1.010000';
our @EXPORT    = qw( eval_closure );
our @EXPORT_OK = qw(
	HAS_LEXICAL_SUBS HAS_LEXICAL_VARS ALIAS_IMPLEMENTATION
	IMPLEMENTATION_DEVEL_LEXALIAS IMPLEMENTATION_PADWALKER
	IMPLEMENTATION_NATIVE IMPLEMENTATION_TIE
);

$VERSION =~ tr/_//d;

# See Types::TypeTiny for an explanation of this import method.
#
sub import {
	# uncoverable subroutine
	no warnings "redefine";                       # uncoverable statement
	our @ISA = qw( Exporter::Tiny );              # uncoverable statement
	require Exporter::Tiny;                       # uncoverable statement
	my $next = \&Exporter::Tiny::import;          # uncoverable statement
	*import = $next;                              # uncoverable statement
	my $class = shift;                            # uncoverable statement
	my $opts  = { ref($_[0]) ? %{+shift} : () };  # uncoverable statement
	$opts->{into} ||= scalar(caller);             # uncoverable statement
	return $class->$next($opts, @_);              # uncoverable statement
}

sub eval_closure {
	my (%args) = @_;
	my $src    = ref $args{source} eq "ARRAY" ? join("\n", @{$args{source}}) : $args{source};
	
	$args{alias}  = 0 unless defined $args{alias};
	$args{line}   = 1 unless defined $args{line};
	$args{description} =~ s/[^\w .:-\[\]\(\)\{\}\']//g if defined $args{description};
	$src = qq{#line $args{line} "$args{description}"\n$src} if defined $args{description} && !($^P & 0x10);
	$args{environment} ||= {};

	if (_EXTENDED_TESTING) {
		require Scalar::Util;
		for my $k (sort keys %{$args{environment}}) {
			next if $k =~ /^\$/ && Scalar::Util::reftype($args{environment}{$k}) =~ /^(SCALAR|REF)$/;
			next if $k =~ /^\@/ && Scalar::Util::reftype($args{environment}{$k}) eq q(ARRAY);
			next if $k =~ /^\%/ && Scalar::Util::reftype($args{environment}{$k}) eq q(HASH);
			next if $k =~ /^\&/ && Scalar::Util::reftype($args{environment}{$k}) eq q(CODE);
			
			require Error::TypeTiny;
			Error::TypeTiny::croak("Expected a variable name and ref; got %s => %s", $k, $args{environment}{$k});
		}
	}
	
	my $sandpkg   = 'Eval::TypeTiny::Sandbox';
	my $alias     = exists($args{alias}) ? $args{alias} : 0;
	my @keys      = sort keys %{$args{environment}};
	my $i         = 0;
	my $source    = join "\n" => (
		"package $sandpkg;",
		"sub {",
		map(_make_lexical_assignment($_, $i++, $alias), @keys),
		$src,
		"}",
	);
	
	if ($alias and ALIAS_IMPLEMENTATION eq IMPLEMENTATION_TIE) {
		_manufacture_ties();
	}
	
	my ($compiler, $e) = _clean_eval($source);
	if ($e) {
		chomp $e;
		require Error::TypeTiny::Compilation;
		"Error::TypeTiny::Compilation"->throw(
			code        => (ref $args{source} eq "ARRAY" ? join("\n", @{$args{source}}) : $args{source}),
			errstr      => $e,
			environment => $args{environment},
		);
	}
	
	my $code = $compiler->(@{$args{environment}}{@keys});
	undef($compiler);

	if ($alias and ALIAS_IMPLEMENTATION eq IMPLEMENTATION_DEVEL_LEXALIAS) {
		require Devel::LexAlias;
		Devel::LexAlias::lexalias($code, $_ => $args{environment}{$_}) for grep !/^\&/, @keys;
	}

	if ($alias and ALIAS_IMPLEMENTATION eq IMPLEMENTATION_PADWALKER) {
		require PadWalker;
		my %env = map +($_ => $args{environment}{$_}), grep !/^\&/, @keys;
		PadWalker::set_closed_over($code, \%env);
	}

	return $code;
}

my $tmp;
sub _make_lexical_assignment {
	my ($key, $index, $alias) = @_;
	my $name = substr($key, 1);
	
	if (HAS_LEXICAL_SUBS and $key =~ /^\&/) {
		$tmp++;
		my $tmpname = '$__LEXICAL_SUB__'.$tmp;
		return
			"no warnings 'experimental::lexical_subs';".
			"use feature 'lexical_subs';".
			"my $tmpname = \$_[$index];".
			"my sub $name { goto $tmpname };";
	}
	
	if (!$alias) {
		my $sigil = substr($key, 0, 1);
		return "my $key = $sigil\{ \$_[$index] };";
	}
	elsif (ALIAS_IMPLEMENTATION eq IMPLEMENTATION_NATIVE) {
		return
			"no warnings 'experimental::refaliasing';".
			"use feature 'refaliasing';".
			"my $key; \\$key = \$_[$index];"
	}
	elsif (ALIAS_IMPLEMENTATION eq IMPLEMENTATION_DEVEL_LEXALIAS) {
		return "my $key;";
	}
	elsif (ALIAS_IMPLEMENTATION eq IMPLEMENTATION_PADWALKER) {
		return "my $key;";
	}
	else {
		my $tieclass = {
			'@' => 'Eval::TypeTiny::_TieArray',
			'%' => 'Eval::TypeTiny::_TieHash',
			'$' => 'Eval::TypeTiny::_TieScalar',
		}->{ substr($key, 0, 1) };
		
		return sprintf(
			'tie(my(%s), "%s", $_[%d]);',
			$key,
			$tieclass,
			$index,
		);
	}
}

{ my $tie; sub _manufacture_ties { $tie ||= eval <<'FALLBACK'; } }
no warnings qw(void once uninitialized numeric);
use Type::Tiny ();

{
	package #
		Eval::TypeTiny::_TieArray;
	require Tie::Array;
	our @ISA = qw( Tie::StdArray );
	sub TIEARRAY {
		my $class = shift;
		bless $_[0] => $class;
	}
	sub AUTOLOAD {
		my $self = shift;
		my ($method) = (our $AUTOLOAD =~ /(\w+)$/);
		defined tied(@$self) and return tied(@$self)->$method(@_);
		require Carp;
		Carp::croak(qq[Can't call method "$method" on an undefined value]) unless $method eq 'DESTROY';
	}
	sub can {
		my $self = shift;
		my $code = $self->SUPER::can(@_)
			|| (defined tied(@$self) and tied(@$self)->can(@_));
		return $code;
	}
	__PACKAGE__->Type::Tiny::_install_overloads(
		q[bool]  => sub { !!   tied @{$_[0]} },
		q[""]    => sub { '' . tied @{$_[0]} },
		q[0+]    => sub { 0  + tied @{$_[0]} },
	);
}
{
	package #
		Eval::TypeTiny::_TieHash;
	require Tie::Hash;
	our @ISA = qw( Tie::StdHash );
	sub TIEHASH {
		my $class = shift;
		bless $_[0] => $class;
	}
	sub AUTOLOAD {
		my $self = shift;
		my ($method) = (our $AUTOLOAD =~ /(\w+)$/);
		defined tied(%$self) and return tied(%$self)->$method(@_);
		require Carp;
		Carp::croak(qq[Can't call method "$method" on an undefined value]) unless $method eq 'DESTROY';
	}
	sub can {
		my $self = shift;
		my $code = $self->SUPER::can(@_)
			|| (defined tied(%$self) and tied(%$self)->can(@_));
		return $code;
	}
	__PACKAGE__->Type::Tiny::_install_overloads(
		q[bool]  => sub { !!   tied %{$_[0]} },
		q[""]    => sub { '' . tied %{$_[0]} },
		q[0+]    => sub { 0  + tied %{$_[0]} },
	);
}
{
	package #
		Eval::TypeTiny::_TieScalar;
	require Tie::Scalar;
	our @ISA = qw( Tie::StdScalar );
	sub TIESCALAR {
		my $class = shift;
		bless $_[0] => $class;
	}
	sub AUTOLOAD {
		my $self = shift;
		my ($method) = (our $AUTOLOAD =~ /(\w+)$/);
		defined tied($$self) and return tied($$self)->$method(@_);
		require Carp;
		Carp::croak(qq[Can't call method "$method" on an undefined value]) unless $method eq 'DESTROY';
	}
	sub can {
		my $self = shift;
		my $code = $self->SUPER::can(@_)
			|| (defined tied($$self) and tied($$self)->can(@_));
		return $code;
	}
	__PACKAGE__->Type::Tiny::_install_overloads(
		q[bool]  => sub { !!   tied ${$_[0]} },
		q[""]    => sub { '' . tied ${$_[0]} },
		q[0+]    => sub { 0  + tied ${$_[0]} },
	);
}

1;
FALLBACK

1;

__END__

=pod

=encoding utf-8

=for stopwords pragmas coderefs

=head1 NAME

Eval::TypeTiny - utility to evaluate a string of Perl code in a clean environment

=head1 STATUS
 
This module is covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

This module is used by Type::Tiny to compile coderefs from strings of
Perl code, and hashrefs of variables to close over.

=head2 Functions

This module exports one function, which works much like the similarly named
function from L<Eval::Closure>:

=over

=item C<< eval_closure(source => $source, environment => \%env, %opt) >>

=back

=head2 Constants

The following constants may be exported, but are not by default.

=over

=item C<< HAS_LEXICAL_SUBS >>

Boolean indicating whether Eval::TypeTiny has support for lexical subs.
(This feature requires Perl 5.18.)

=item C<< ALIAS_IMPLEMENTATION >>

Returns a string indicating what implementation of C<< alias => 1 >> is
being used. Eval::TypeTiny will automatically choose the best implementation.
This constant can be matched against the C<< IMPLEMENTAION_* >> constants.

=item C<< IMPLEMENTATION_NATIVE >>

If C<< ALIAS_IMPLEMENTATION eq IMPLEMENTATION_NATIVE >> then Eval::TypeTiny is
currently using Perl 5.22's native alias feature. This requires Perl 5.22.

=item C<< IMPLEMENTATION_DEVEL_LEXALIAS >>

If C<< ALIAS_IMPLEMENTATION eq IMPLEMENTATION_DEVEL_LEXALIAS >> then
Eval::TypeTiny is currently using L<Devel::LexAlias> to provide aliases.

=item C<< IMPLEMENTATION_PADWALKER >>

If C<< ALIAS_IMPLEMENTATION eq IMPLEMENTATION_PADWALKER >> then
Eval::TypeTiny is currently using L<PadWalker> to provide aliases.

=item C<< IMPLEMENTATION_TIE >>

If C<< ALIAS_IMPLEMENTATION eq IMPLEMENTATION_TIE >> then Eval::TypeTiny is
using the fallback implementation of aliases using C<tie>. This is the
slowest implementation, and may cause problems in certain edge cases, like
trying to alias already-tied variables, but it's the only way to implement
C<< alias => 1 >> without a recent version of Perl or one of the two optional
modules mentioned above.

=back

=head1 EVALUATION ENVIRONMENT

The evaluation is performed in the presence of L<strict>, but the absence of
L<warnings>. (This is different to L<Eval::Closure> which enables warnings for
compiled closures.)

The L<feature> pragma is not active in the evaluation environment, so the
following will not work:

   use feature qw(say);
   use Eval::TypeTiny qw(eval_closure);
   
   my $say_all = eval_closure(
      source => 'sub { say for @_ }',
   );
   $say_all->("Hello", "World");

The L<feature> pragma does not "carry over" into the stringy eval. It is
of course possible to import pragmas into the evaluated string as part of the
string itself:

   use Eval::TypeTiny qw(eval_closure);
   
   my $say_all = eval_closure(
      source => 'sub { use feature qw(say); say for @_ }',
   );
   $say_all->("Hello", "World");

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Eval::Closure>, L<Error::TypeTiny::Compilation>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014, 2017-2020 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

