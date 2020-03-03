package Type::Library;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Type::Library::AUTHORITY = 'cpan:TOBYINK';
	$Type::Library::VERSION   = '1.010000';
}

$Type::Library::VERSION =~ tr/_//d;

use Eval::TypeTiny qw< eval_closure >;
use Scalar::Util qw< blessed refaddr >;
use Type::Tiny;
use Types::TypeTiny qw< TypeTiny to_TypeTiny >;

require Exporter::Tiny;
our @ISA = 'Exporter::Tiny';

BEGIN { *NICE_PROTOTYPES = ($] >= 5.014) ? sub () { !!1 } : sub () { !!0 } };

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

{
	my $subname;
	my %already; # prevent renaming established functions
	sub _subname ($$)
	{
		$subname =
			eval { require Sub::Util } ? \&Sub::Util::set_subname :
			eval { require Sub::Name } ? \&Sub::Name::subname :
			0
			if not defined $subname;
		!$already{refaddr($_[1])}++ and return($subname->(@_))
			if $subname;
		return $_[1];
	}
}

sub _exporter_validate_opts
{
	my $class = shift;
	
	no strict "refs";
	my $into  = $_[0]{into};
	push @{"$into\::ISA"}, $class if $_[0]{base};
	
	return $class->SUPER::_exporter_validate_opts(@_);
}

sub _exporter_expand_tag
{
	my $class = shift;
	my ($name, $value, $globals) = @_;
	
	$name eq 'types'     and return map [ "$_"        => $value ], $class->type_names;
	$name eq 'is'        and return map [ "is_$_"     => $value ], $class->type_names;
	$name eq 'assert'    and return map [ "assert_$_" => $value ], $class->type_names;
	$name eq 'to'        and return map [ "to_$_"     => $value ], $class->type_names;
	$name eq 'coercions' and return map [ "$_"        => $value ], $class->coercion_names;
	
	if ($name eq 'all')
	{
		no strict "refs";
		return (
			map(
				[ "+$_" => $value ],
				$class->type_names,
			),
			map(
				[ $_ => $value ],
				$class->coercion_names,
				@{"$class\::EXPORT"},
				@{"$class\::EXPORT_OK"},
			),
		);
	}
	
	return $class->SUPER::_exporter_expand_tag(@_);
}

sub _mksub
{
	my $class = shift;
	my ($type, $post_method) = @_;
	$post_method ||= q();
	
	my $source = $type->is_parameterizable
		? sprintf(
			q{
				sub (%s) {
					return $_[0]->complete($type) if ref($_[0]) eq 'Type::Tiny::_HalfOp';
					my $params; $params = shift if ref($_[0]) eq q(ARRAY);
					my $t = $params ? $type->parameterize(@$params) : $type;
					@_ && wantarray ? return($t%s, @_) : return $t%s;
				}
			},
			NICE_PROTOTYPES ? q(;$) : q(;@),
			$post_method,
			$post_method,
		)
		: sprintf(
			q{ sub () { $type%s if $] } },
			$post_method,
		);
		
	return _subname(
		$type->qualified_name,
		eval_closure(
			source      => $source,
			description => sprintf("exportable function '%s::%s'", $class, $type),
			environment => {'$type' => \$type},
		),
	);
}

sub _exporter_permitted_regexp
{
	my $class = shift;
	
	my $inherited = $class->SUPER::_exporter_permitted_regexp(@_);
	my $types = join "|", map quotemeta, sort {
		length($b) <=> length($a) or $a cmp $b
	} $class->type_names;
	my $coercions = join "|", map quotemeta, sort {
		length($b) <=> length($a) or $a cmp $b
	} $class->coercion_names;
	
	qr{^(?:
		$inherited
		| (?: (?:is_|to_|assert_)? (?:$types) )
		| (?:$coercions)
	)$}xms;
}

sub _exporter_expand_sub
{
	my $class = shift;
	my ($name, $value, $globals) = @_;
	
	if ($name =~ /^\+(.+)/ and $class->has_type($1))
	{
		my $type   = $1;
		my $value2 = +{%{$value||{}}};
		
		return map $class->_exporter_expand_sub($_, $value2, $globals),
			$type, "is_$type", "assert_$type", "to_$type";
	}
	
	my $typename = $name;
	my $thingy   = undef;
	if ($name =~ /^(is|assert|to)_(.+)$/)
	{
		$thingy   = $1;
		$typename = $2;
	}
	
	if (my $type = $class->get_type($typename))
	{
		my $custom_type = 0;
		for my $param (qw/ of where /)
		{
			exists $value->{$param} or next;
			defined $value->{-as}
				or _croak("Parameter '-as' not supplied");
			$type = $type->$param($value->{$param});
			$name = $value->{-as};
			++$custom_type;
		}
		
		if (!defined $thingy)
		{
			my $post_method = q();
			$post_method = '->mouse_type' if $globals->{mouse};
			$post_method = '->moose_type' if $globals->{moose};
			return ($name => $class->_mksub($type, $post_method)) if $post_method || $custom_type;
		}
		elsif ($thingy eq 'is')
		{
			return ($value->{-as} || "is_$typename" => $type->compiled_check) if $custom_type;
		}
		elsif ($thingy eq 'assert')
		{
			return ($value->{-as} || "assert_$typename" => $type->_overload_coderef) if $custom_type;
		}
		elsif ($thingy eq 'to')
		{
			my $to_type = $type->has_coercion && $type->coercion->frozen
				? $type->coercion->compiled_coercion
				: sub ($) { $type->coerce($_[0]) };
			return ($value->{-as} || "to_$typename" => $to_type) if $custom_type;
		}
	}
	
	return $class->SUPER::_exporter_expand_sub(@_);
}

sub _exporter_install_sub
{
	my $class = shift;
	my ($name, $value, $globals, $sym) = @_;
	
	my $package = $globals->{into};
	my $type = $class->get_type($name);
	
	Exporter::Tiny::_carp(
		"Exporting deprecated type %s to %s",
		$type->qualified_name,
		ref($package) ? "reference" : "package $package",
	) if (defined $type and $type->deprecated and not $globals->{allow_deprecated});
	
	if (!ref $package and defined $type)
	{
		my ($prefix) = grep defined, $value->{-prefix}, $globals->{prefix}, q();
		my ($suffix) = grep defined, $value->{-suffix}, $globals->{suffix}, q();
		my $as = $prefix . ($value->{-as} || $name) . $suffix;
		
		$INC{'Type/Registry.pm'}
			? 'Type::Registry'->for_class($package)->add_type($type, $as)
			: ($Type::Registry::DELAYED{$package}{$as} = $type);
	}
	
	$class->SUPER::_exporter_install_sub(@_);
}

sub _exporter_fail
{
	my $class = shift;
	my ($name, $value, $globals) = @_;
	
	my $into = $globals->{into}
		or _croak("Parameter 'into' not supplied");
	
	if ($globals->{declare})
	{
		my $declared = sub (;$)
		{
			my $params; $params = shift if ref($_[0]) eq "ARRAY";
			my $type = $into->get_type($name);
			my $t;
			
			if ($type) {
				my $t = $params ? $type->parameterize(@$params) : $type;
			}
			else
			{
				_croak "Cannot parameterize a non-existant type" if $params;
				$t = Type::Tiny::_DeclaredType->new(library => $into, name => $name);
			}
			
			@_ && wantarray ? return($t, @_) : return $t;
		};
		
		return(
			$name,
			_subname(
				"$class\::$name",
				NICE_PROTOTYPES ? sub (;$) { goto $declared } : sub (;@) { goto $declared },
			),
		);
	}
	
	return $class->SUPER::_exporter_fail(@_);
}

{
	package Type::Tiny::_DeclaredType;
	our @ISA = 'Type::Tiny';
	sub new {
		my $class = shift;
		my %opts  = @_==1 ? %{+shift} : @_;
		my $library = delete $opts{library};
		my $name    = delete $opts{name};
		$opts{display_name} = $name;
		$opts{constraint} = sub {
			my $val = @_ ? pop : $_;
			$library->get_type($name)->check($val);
		};
		$opts{inlined} = sub {
			my $val = @_ ? pop : $_;
			sprintf('%s::is_%s(%s)', $library, $name, $val);
		};
		$class->SUPER::new(%opts);
	}
}

sub meta
{
	no strict "refs";
	no warnings "once";
	return $_[0] if blessed $_[0];
	${"$_[0]\::META"} ||= bless {}, $_[0];
}

sub add_type
{
	my $meta  = shift->meta;
	my $class = blessed($meta);
	
	my $type =
		ref($_[0]) =~ /^Type::Tiny\b/  ? $_[0] :
		blessed($_[0])                 ? to_TypeTiny($_[0]) :
		ref($_[0]) eq q(HASH)          ? "Type::Tiny"->new(library => $class, %{$_[0]}) :
		"Type::Tiny"->new(library => $class, @_);
	my $name = $type->{name};
	
	$meta->{types} ||= {};
	_croak 'Type %s already exists in this library', $name if $meta->has_type($name);
	_croak 'Type %s conflicts with coercion of same name', $name if $meta->has_coercion($name);
	_croak 'Cannot add anonymous type to a library' if $type->is_anon;
	$meta->{types}{$name} = $type;
	
	no strict "refs";
	no warnings "redefine", "prototype";
	
	my $to_type = $type->has_coercion && $type->coercion->frozen
		? $type->coercion->compiled_coercion
		: sub ($) { $type->coerce($_[0]) };
	
	*{"$class\::$name"}        = $class->_mksub($type);
	*{"$class\::is_$name"}     = _subname "$class\::is_$name", $type->compiled_check;
	*{"$class\::to_$name"}     = _subname "$class\::to_$name", $to_type;
	*{"$class\::assert_$name"} = _subname "$class\::assert_$name", $type->_overload_coderef;
	
	return $type;
}

sub get_type
{
	my $meta = shift->meta;
	$meta->{types}{$_[0]};
}

sub has_type
{
	my $meta = shift->meta;
	exists $meta->{types}{$_[0]};
}

sub type_names
{
	my $meta = shift->meta;
	keys %{ $meta->{types} };
}

sub add_coercion
{
	require Type::Coercion;
	my $meta = shift->meta;
	my $c    = blessed($_[0]) ? $_[0] : "Type::Coercion"->new(@_);
	my $name = $c->name;

	$meta->{coercions} ||= {};
	_croak 'Coercion %s already exists in this library', $name if $meta->has_coercion($name);
	_croak 'Coercion %s conflicts with type of same name', $name if $meta->has_type($name);
	_croak 'Cannot add anonymous type to a library' if $c->is_anon;
	$meta->{coercions}{$name} = $c;

	no strict "refs";
	no warnings "redefine", "prototype";
	
	my $class = blessed($meta);
	*{"$class\::$name"} = $class->_mksub($c);
	
	return $c;
}

sub get_coercion
{
	my $meta = shift->meta;
	$meta->{coercions}{$_[0]};
}

sub has_coercion
{
	my $meta = shift->meta;
	exists $meta->{coercions}{$_[0]};
}

sub coercion_names
{
	my $meta = shift->meta;
	keys %{ $meta->{coercions} };
}

sub make_immutable
{
	my $meta  = shift->meta;
	my $class = ref($meta);
	
	for my $type (values %{$meta->{types}})
	{
		$type->coercion->freeze;
		
		no strict "refs";
		no warnings "redefine", "prototype";
		
		my $to_type = $type->has_coercion && $type->coercion->frozen
			? $type->coercion->compiled_coercion
			: sub ($) { $type->coerce($_[0]) };
		my $name = $type->name;
		
		*{"$class\::to_$name"} = _subname "$class\::to_$name", $to_type;
	}
	
	1;
}

1;

__END__

=pod

=encoding utf-8

=for stopwords Moo(se)-compatible MooseX::Types-like

=head1 NAME

Type::Library - tiny, yet Moo(se)-compatible type libraries

=head1 SYNOPSIS

=for test_synopsis
BEGIN { die "SKIP: crams multiple modules into single example" };

   package Types::Mine {
      use Scalar::Util qw(looks_like_number);
      use Type::Library -base;
      use Type::Tiny;
      
      my $NUM = "Type::Tiny"->new(
         name       => "Number",
         constraint => sub { looks_like_number($_) },
         message    => sub { "$_ ain't a number" },
      );
      
      __PACKAGE__->meta->add_type($NUM);
      
      __PACKAGE__->meta->make_immutable;
   }
      
   package Ermintrude {
      use Moo;
      use Types::Mine qw(Number);
      has favourite_number => (is => "ro", isa => Number);
   }
   
   package Bullwinkle {
      use Moose;
      use Types::Mine qw(Number);
      has favourite_number => (is => "ro", isa => Number);
   }
   
   package Maisy {
      use Mouse;
      use Types::Mine qw(Number);
      has favourite_number => (is => "ro", isa => Number);
   }

=head1 STATUS

This module is covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

L<Type::Library> is a tiny class for creating MooseX::Types-like type
libraries which are compatible with Moo, Moose and Mouse.

If you're reading this because you want to create a type library, then
you're probably better off reading L<Type::Tiny::Manual::Libraries>.

=head2 Methods

A type library is a singleton class. Use the C<meta> method to get a blessed
object which other methods can get called on. For example:

   Types::Mine->meta->add_type($foo);

=begin trustme

=item meta

=end trustme

=over

=item C<< add_type($type) >> or C<< add_type(%opts) >>

Add a type to the library. If C<< %opts >> is given, then this method calls
C<< Type::Tiny->new(%opts) >> first, and adds the resultant type.

Adding a type named "Foo" to the library will automatically define four
functions in the library's namespace:

=over

=item C<< Foo >>

Returns the Type::Tiny object.

=item C<< is_Foo($value) >>

Returns true iff $value passes the type constraint.

=item C<< assert_Foo($value) >>

Returns $value iff $value passes the type constraint. Dies otherwise.

=item C<< to_Foo($value) >>

Coerces the value to the type.

=back

=item C<< get_type($name) >>

Gets the C<Type::Tiny> object corresponding to the name.

=item C<< has_type($name) >>

Boolean; returns true if the type exists in the library.

=item C<< type_names >>

List all types defined by the library.

=item C<< add_coercion($c) >> or C<< add_coercion(%opts) >>

Add a standalone coercion to the library. If C<< %opts >> is given, then
this method calls C<< Type::Coercion->new(%opts) >> first, and adds the
resultant coercion.

Adding a coercion named "FooFromBar" to the library will automatically
define a function in the library's namespace:

=over

=item C<< FooFromBar >>

Returns the Type::Coercion object.

=back

=item C<< get_coercion($name) >>

Gets the C<Type::Coercion> object corresponding to the name.

=item C<< has_coercion($name) >>

Boolean; returns true if the coercion exists in the library.

=item C<< coercion_names >>

List all standalone coercions defined by the library.

=item C<< import(@args) >>

Type::Library-based libraries are exporters.

=item C<< make_immutable >>

A shortcut for calling C<< $type->coercion->freeze >> on every
type constraint in the library.

=back

=head2 Constants

=over

=item C<< NICE_PROTOTYPES >>

If this is true, then Type::Library will give parameterizable type constraints
slightly the nicer prototype of C<< (;$) >> instead of the default C<< (;@) >>.
This allows constructs like:

   ArrayRef[Int] | HashRef[Int]

... to "just work".

=back

=head2 Export

Type libraries are exporters. For the purposes of the following examples,
assume that the C<Types::Mine> library defines types C<Number> and C<String>.

   # Exports nothing.
   # 
   use Types::Mine;
   
   # Exports a function "String" which is a constant returning
   # the String type constraint.
   #
   use Types::Mine qw( String );
   
   # Exports both String and Number as above.
   #
   use Types::Mine qw( String Number );
   
   # Same.
   #
   use Types::Mine qw( :types );
   
   # Exports "coerce_String" and "coerce_Number", as well as any other
   # coercions
   #
   use Types::Mine qw( :coercions );
   
   # Exports a sub "is_String" so that "is_String($foo)" is equivalent
   # to "String->check($foo)".
   #
   use Types::Mine qw( is_String );
   
   # Exports "is_String" and "is_Number".
   #
   use Types::Mine qw( :is );
   
   # Exports a sub "assert_String" so that "assert_String($foo)" is
   # equivalent to "String->assert_return($foo)".
   #
   use Types::Mine qw( assert_String );
   
   # Exports "assert_String" and "assert_Number".
   #
   use Types::Mine qw( :assert );
   
   # Exports a sub "to_String" so that "to_String($foo)" is equivalent
   # to "String->coerce($foo)".
   #
   use Types::Mine qw( to_String );
   
   # Exports "to_String" and "to_Number".
   #
   use Types::Mine qw( :to );
   
   # Exports "String", "is_String", "assert_String" and "coerce_String".
   #
   use Types::Mine qw( +String );
   
   # Exports everything.
   #
   use Types::Mine qw( :all );

Type libraries automatically inherit from L<Exporter::Tiny>; see the
documentation of that module for tips and tricks importing from libraries.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny::Manual>.

L<Type::Tiny>, L<Type::Utils>, L<Types::Standard>, L<Type::Coercion>.

L<Moose::Util::TypeConstraints>,
L<Mouse::Util::TypeConstraints>.

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


