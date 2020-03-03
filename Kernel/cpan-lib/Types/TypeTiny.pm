package Types::TypeTiny;

use strict;
use warnings;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '1.010000';

$VERSION =~ tr/_//d;

use Scalar::Util qw< blessed refaddr weaken >;

our @EXPORT_OK = (
	map(@{[ $_, "is_$_", "assert_$_" ]}, __PACKAGE__->type_names),
	qw/to_TypeTiny/
);
our %EXPORT_TAGS = (
	types     => [                  __PACKAGE__->type_names ],
	is        => [ map "is_$_",     __PACKAGE__->type_names ],
	assert    => [ map "assert_$_", __PACKAGE__->type_names ],
);

my %cache;

# This `import` method is designed to avoid loading Exporter::Tiny.
# This is so that if you stick to only using the purely OO parts of
# Type::Tiny, you can skip loading the exporter.
#
sub import
{
	# If this sub succeeds, it will replace itself.
	# uncoverable subroutine
	return unless @_ > 1;                         # uncoverable statement
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

for (__PACKAGE__->type_names) {
	eval qq{
		sub is_$_     { $_()->check(shift) }
		sub assert_$_ { $_()->assert_return(shift) }
	};
}

sub meta
{
	return $_[0];
}

sub type_names
{
	qw( CodeLike StringLike TypeTiny HashLike ArrayLike _ForeignTypeConstraint );
}

sub has_type
{
	my %has = map +($_ => 1), shift->type_names;
	!!$has{ $_[0] };
}

sub get_type
{
	my $self = shift;
	return unless $self->has_type(@_);
	no strict qw(refs);
	&{$_[0]}();
}

sub coercion_names
{
	qw();
}

sub has_coercion
{
	my %has = map +($_ => 1), shift->coercion_names;
	!!$has{ $_[0] };
}

sub get_coercion
{
	my $self = shift;
	return unless $self->has_coercion(@_);
	no strict qw(refs);
	&{$_[0]}();  # uncoverable statement
}

my ($__get_linear_isa_dfs, $tried_mro);
$__get_linear_isa_dfs = sub {
	if (!$tried_mro && eval { require mro }) {
		$__get_linear_isa_dfs = \&mro::get_linear_isa;
		goto $__get_linear_isa_dfs;
	}
	no strict 'refs';
	my $classname = shift;
	my @lin = ($classname);
	my %stored;
	foreach my $parent (@{"$classname\::ISA"})
	{
		my $plin = $__get_linear_isa_dfs->($parent);
		foreach (@$plin) {
			next if exists $stored{$_};
			push(@lin, $_);
			$stored{$_} = 1;
		}
	}
	return \@lin;
};

sub _check_overload
{
	my $package = shift;
	if (ref $package) {
		$package = blessed($package);
		return !!0 if !defined $package;
	}
	my $op  = shift;
	my $mro = $__get_linear_isa_dfs->($package);
	foreach my $p (@$mro) {
		my $fqmeth = $p . q{::(} . $op;
		return !!1 if defined &{$fqmeth};
	}
	!!0;
}

sub _get_check_overload_sub {
	if ($Type::Tiny::AvoidCallbacks) {
		return '(sub { require overload; overload::Overloaded(ref $_[0] or $_[0]) and overload::Method((ref $_[0] or $_[0]), $_[1]) })->'
	}
	return 'Types::TypeTiny::_check_overload';
}

sub StringLike ()
{
	require Type::Tiny;
	$cache{StringLike} ||= "Type::Tiny"->new(
		name       => "StringLike",
		constraint => sub {    defined($_   ) && !ref($_   ) or Scalar::Util::blessed($_   ) && Types::TypeTiny::_check_overload($_   , q[""])  },
		inlined    => sub { qq/defined($_[1]) && !ref($_[1]) or Scalar::Util::blessed($_[1]) && ${\ +_get_check_overload_sub() }($_[1], q[""])/ },
		library    => __PACKAGE__,
	);
}

sub HashLike ()
{
	require Type::Tiny;
	$cache{HashLike} ||= "Type::Tiny"->new(
		name       => "HashLike",
		constraint => sub {    ref($_   ) eq q[HASH] or Scalar::Util::blessed($_   ) && Types::TypeTiny::_check_overload($_   , q[%{}])  },
		inlined    => sub { qq/ref($_[1]) eq q[HASH] or Scalar::Util::blessed($_[1]) && ${\ +_get_check_overload_sub() }($_[1], q[\%{}])/ },
		library    => __PACKAGE__,
	);
}

sub ArrayLike ()
{
	require Type::Tiny;
	$cache{ArrayLike} ||= "Type::Tiny"->new(
		name       => "ArrayLike",
		constraint => sub {    ref($_   ) eq q[ARRAY] or Scalar::Util::blessed($_   ) && Types::TypeTiny::_check_overload($_   , q[@{}])  },
		inlined    => sub { qq/ref($_[1]) eq q[ARRAY] or Scalar::Util::blessed($_[1]) && ${\ +_get_check_overload_sub() }($_[1], q[\@{}])/ },
		library    => __PACKAGE__,
	);
}

sub CodeLike ()
{
	require Type::Tiny;
	$cache{CodeLike} ||= "Type::Tiny"->new(
		name       => "CodeLike",
		constraint => sub {    ref($_   ) eq q[CODE] or Scalar::Util::blessed($_   ) && Types::TypeTiny::_check_overload($_   , q[&{}])  },
		inlined    => sub { qq/ref($_[1]) eq q[CODE] or Scalar::Util::blessed($_[1]) && ${\ +_get_check_overload_sub() }($_[1], q[\&{}])/ },
		library    => __PACKAGE__,
	);
}

sub TypeTiny ()
{
	require Type::Tiny;
	$cache{TypeTiny} ||= "Type::Tiny"->new(
		name       => "TypeTiny",
		constraint => sub {  Scalar::Util::blessed($_   ) && $_   ->isa(q[Type::Tiny])  },
		inlined    => sub { my $var = $_[1]; "Scalar::Util::blessed($var) && $var\->isa(q[Type::Tiny])" },
		library    => __PACKAGE__,
		_build_coercion => sub {
			my $c = shift;
			$c->add_type_coercions(_ForeignTypeConstraint(), \&to_TypeTiny);
			$c->freeze;
		},
	);
}

sub _ForeignTypeConstraint ()
{
	require Type::Tiny;
	$cache{_ForeignTypeConstraint} ||= "Type::Tiny"->new(
		name       => "_ForeignTypeConstraint",
		constraint => \&_is_ForeignTypeConstraint,
		inlined    => sub { qq/ref($_[1]) && do { require Types::TypeTiny; Types::TypeTiny::_is_ForeignTypeConstraint($_[1]) }/ },
		library    => __PACKAGE__,
	);
}

my %ttt_cache;

sub _is_ForeignTypeConstraint
{
	my $t = @_ ? $_[0] : $_;
	return !!1 if ref $t eq 'CODE';
	if (my $class = blessed $t)
	{
		return !!0 if $class->isa("Type::Tiny");
		return !!1 if $class->isa("Moose::Meta::TypeConstraint");
		return !!1 if $class->isa("MooseX::Types::TypeDecorator");
		return !!1 if $class->isa("Validation::Class::Simple");
		return !!1 if $class->isa("Validation::Class");
		return !!1 if $t->can("check") && $t->can("get_message");
	}
	!!0;
}

sub to_TypeTiny
{
	my $t = @_ ? $_[0] : $_;
	
	return $t unless (my $ref = ref $t);
	return $t if $ref =~ /^Type::Tiny\b/;
	
	return $ttt_cache{ refaddr($t) } if $ttt_cache{ refaddr($t) };
	
	if (my $class = blessed $t)
	{
		return $t                               if $class->isa("Type::Tiny");
		return _TypeTinyFromMoose($t)           if $class eq "MooseX::Types::TypeDecorator";  # needed before MooseX::Types 0.35.
		return _TypeTinyFromMoose($t)           if $class->isa("Moose::Meta::TypeConstraint");
		return _TypeTinyFromMoose($t)           if $class->isa("MooseX::Types::TypeDecorator");
		return _TypeTinyFromMouse($t)           if $class->isa("Mouse::Meta::TypeConstraint");
		return _TypeTinyFromValidationClass($t) if $class->isa("Validation::Class::Simple");
		return _TypeTinyFromValidationClass($t) if $class->isa("Validation::Class");
		return _TypeTinyFromGeneric($t)         if $t->can("check") && $t->can("get_message"); # i.e. Type::API::Constraint
	}
	
	return _TypeTinyFromCodeRef($t) if $ref eq q(CODE);
	
	$t;
}

sub _TypeTinyFromMoose
{
	my $t = $_[0];
	
	if (ref $t->{"Types::TypeTiny::to_TypeTiny"})
	{
		return $t->{"Types::TypeTiny::to_TypeTiny"};
	}
	
	if ($t->name ne '__ANON__')
	{
		require Types::Standard;
		my $ts = 'Types::Standard'->get_type($t->name);
		return $ts if $ts->{_is_core};
	}
	
	my ($tt_class, $tt_opts) =
		$t->can('parameterize')                          ? _TypeTinyFromMoose_parameterizable($t) :
		$t->isa('Moose::Meta::TypeConstraint::Enum')     ? _TypeTinyFromMoose_enum($t) :
		$t->isa('Moose::Meta::TypeConstraint::Class')    ? _TypeTinyFromMoose_class($t) :
		$t->isa('Moose::Meta::TypeConstraint::Role')     ? _TypeTinyFromMoose_role($t) :
		$t->isa('Moose::Meta::TypeConstraint::Union')    ? _TypeTinyFromMoose_union($t) :
		$t->isa('Moose::Meta::TypeConstraint::DuckType') ? _TypeTinyFromMoose_ducktype($t) :
		_TypeTinyFromMoose_baseclass($t);
	
	# Standard stuff to do with all type constraints from Moose,
	# regardless of variety.
	$tt_opts->{moose_type}   = $t;
	$tt_opts->{display_name} = $t->name;
	$tt_opts->{message}      = sub { $t->get_message($_) } if $t->has_message;
	
	my $new = $tt_class->new(%$tt_opts);
	$ttt_cache{ refaddr($t) } = $new;
	weaken($ttt_cache{ refaddr($t) });
	
	$new->{coercion} = do {
		require Type::Coercion::FromMoose;
		'Type::Coercion::FromMoose'->new(
			type_constraint => $new,
			moose_coercion  => $t->coercion,
		);
	} if $t->has_coercion;
		
	return $new;
}

sub _TypeTinyFromMoose_baseclass
{
	my $t = shift;
	my %opts;
	$opts{parent}       = to_TypeTiny($t->parent)              if $t->has_parent;
	$opts{constraint}   = $t->constraint;
	$opts{inlined}      = sub { shift; $t->_inline_check(@_) } if $t->can("can_be_inlined") && $t->can_be_inlined;
	
	# Cowardly refuse to inline types that need to close over stuff
	if ($opts{inlined}) {
		my %env = %{ $t->inline_environment || {} };
		delete($opts{inlined}) if keys %env;
	}
	
	require Type::Tiny;
	return 'Type::Tiny' => \%opts;
}

sub _TypeTinyFromMoose_union
{
	my $t = shift;
	require Type::Tiny::Union;
	return 'Type::Tiny::Union' => { type_constraints => [ map _TypeTinyFromMoose($_), @{$t->type_constraints} ] };
}

sub _TypeTinyFromMoose_enum
{
	my $t = shift;
	require Type::Tiny::Enum;
	return 'Type::Tiny::Enum' => { values => [@{ $t->values }] };
}

sub _TypeTinyFromMoose_class
{
	my $t = shift;
	require Type::Tiny::Class;
	return 'Type::Tiny::Class' => { class => $t->class };
}

sub _TypeTinyFromMoose_role
{
	my $t = shift;
	require Type::Tiny::Role;
	return 'Type::Tiny::Role' => { role => $t->role };
}

sub _TypeTinyFromMoose_ducktype
{
	my $t = shift;
	require Type::Tiny::Duck;
	return 'Type::Tiny::Duck' => { methods => [@{ $t->methods }] };
}

sub _TypeTinyFromMoose_parameterizable
{
	my $t = shift;
	my ($class, $opts) = _TypeTinyFromMoose_baseclass($t);
	$opts->{constraint_generator} = sub {
		# convert args into Moose native types; not strictly necessary
		my @args = map { TypeTiny->check($_) ? $_->moose_type : $_ } @_;
		_TypeTinyFromMoose( $t->parameterize(@args) );
	};
	return ($class, $opts);
}

sub _TypeTinyFromValidationClass
{
	my $t = $_[0];
	
	require Type::Tiny;
	require Types::Standard;
	
	my %opts = (
		parent            => Types::Standard::HashRef(),
		_validation_class => $t,
	);
	
	if ($t->VERSION >= "7.900048")
	{
		$opts{constraint} = sub {
			$t->params->clear;
			$t->params->add(%$_);
			my $f = $t->filtering; $t->filtering('off');
			my $r = eval { $t->validate };
			$t->filtering($f || 'pre');
			return $r;
		};
		$opts{message} = sub {
			$t->params->clear;
			$t->params->add(%$_);
			my $f = $t->filtering; $t->filtering('off');
			my $r = (eval { $t->validate } ? "OK" : $t->errors_to_string);
			$t->filtering($f || 'pre');
			return $r;
		};
	}
	else  # need to use hackish method
	{
		$opts{constraint} = sub {
			$t->params->clear;
			$t->params->add(%$_);
			no warnings "redefine";
			local *Validation::Class::Directive::Filters::execute_filtering = sub { $_[0] };
			eval { $t->validate };
		};
		$opts{message} = sub {
			$t->params->clear;
			$t->params->add(%$_);
			no warnings "redefine";
			local *Validation::Class::Directive::Filters::execute_filtering = sub { $_[0] };
			eval { $t->validate } ? "OK" : $t->errors_to_string;
		};
	}
	
	require Type::Tiny;
	my $new = "Type::Tiny"->new(%opts);
	
	$new->coercion->add_type_coercions(
		Types::Standard::HashRef() => sub {
			my %params = %$_;
			for my $k (keys %params)
				{ delete $params{$_} unless $t->get_fields($k) };
			$t->params->clear;
			$t->params->add(%params);
			eval { $t->validate };
			$t->get_hash;
		},
	);
	
	$ttt_cache{ refaddr($t) } = $new;
	weaken($ttt_cache{ refaddr($t) });
	return $new;
}

sub _TypeTinyFromGeneric
{
	my $t = $_[0];
	
	my %opts = (
		constraint => sub { $t->check(@_ ? @_ : $_) },
		message    => sub { $t->get_message(@_ ? @_ : $_) },
	);
	
	$opts{display_name} = $t->name if $t->can("name");
	
	$opts{coercion} = sub { $t->coerce(@_ ? @_ : $_) }
		if $t->can("has_coercion") && $t->has_coercion && $t->can("coerce");
	
	if ($t->can('can_be_inlined') && $t->can_be_inlined && $t->can('inline_check')) {
		$opts{inlined} = sub { $t->inline_check($_[1]) };
	}
	
	require Type::Tiny;
	my $new = "Type::Tiny"->new(%opts);
	$ttt_cache{ refaddr($t) } = $new;
	weaken($ttt_cache{ refaddr($t) });
	return $new;
}

sub _TypeTinyFromMouse
{
	my $t = $_[0];
	
	my %opts = (
		constraint => sub { $t->check(@_ ? @_ : $_) },
		message    => sub { $t->get_message(@_ ? @_ : $_) },
	);
	
	$opts{display_name} = $t->name if $t->can("name");
	
	$opts{coercion} = sub { $t->coerce(@_ ? @_ : $_) }
		if $t->can("has_coercion") && $t->has_coercion && $t->can("coerce");

	if ($t->{'constraint_generator'}) {
		$opts{constraint_generator} = sub {
			# convert args into Moose native types; not strictly necessary
			my @args    = map { TypeTiny->check($_) ? $_->mouse_type : $_ } @_;
			_TypeTinyFromMouse( $t->parameterize(@args) );
		};
	}

	require Type::Tiny;
	my $new = "Type::Tiny"->new(%opts);
	$ttt_cache{ refaddr($t) } = $new;
	weaken($ttt_cache{ refaddr($t) });
	return $new;
}

my $QFS;
sub _TypeTinyFromCodeRef
{
	my $t = $_[0];
	
	my %opts = (
		constraint => sub {
			return !!eval { $t->($_) };
		},
		message => sub {
			local $@;
			eval { $t->($_); 1 } or do { chomp $@; return $@ if $@ };
			return sprintf('%s did not pass type constraint', Type::Tiny::_dd($_));
		},
	);
	
	if ($QFS ||= "Sub::Quote"->can("quoted_from_sub"))
	{
		my (undef, $perlstring, $captures) = @{ $QFS->($t) || [] };
		if ($perlstring)
		{
			$perlstring = "!!eval{ $perlstring }";
			$opts{inlined} = sub
			{
				my $var = $_[1];
				Sub::Quote::inlinify(
					$perlstring,
					$var,
					$var eq q($_) ? '' : "local \$_ = $var;",
					1,
				);
			} if $perlstring && !$captures;
		}
	}
	
	require Type::Tiny;
	my $new = "Type::Tiny"->new(%opts);
	$ttt_cache{ refaddr($t) } = $new;
	weaken($ttt_cache{ refaddr($t) });
	return $new;
}

1;

__END__

=pod

=encoding utf-8

=for stopwords arrayfication hashification

=head1 NAME

Types::TypeTiny - type constraints used internally by Type::Tiny

=head1 STATUS

This module is covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

Dogfooding.

This isn't a real Type::Library-based type library; that would involve
too much circularity. But it exports some type constraints which, while
designed for use within Type::Tiny, may be more generally useful.

=head2 Types

=over

=item C<< StringLike >>

Accepts strings and objects overloading stringification.

=item C<< HashLike >>

Accepts hashrefs and objects overloading hashification.

=item C<< ArrayLike >>

Accepts arrayrefs and objects overloading arrayfication.

=item C<< CodeLike >>

Accepts coderefs and objects overloading codification.

=item C<< TypeTiny >>

Accepts blessed L<Type::Tiny> objects.

=item C<< _ForeignTypeConstraint >>

Any reference which to_TypeTiny recognizes as something that can be coerced
to a Type::Tiny object.

Yeah, the underscore is included.

=back

=head2 Coercion Functions

=over

=item C<< to_TypeTiny($constraint) >>

Promotes (or "demotes" if you prefer) a Moose::Meta::TypeConstraint object
to a Type::Tiny object.

Can also handle L<Validation::Class> objects. Type constraints built from 
Validation::Class objects deliberately I<ignore> field filters when they
do constraint checking (and go to great lengths to do so); using filters for
coercion only. (The behaviour of C<coerce> if we don't do that is just too
weird!)

Can also handle any object providing C<check> and C<get_message> methods.
(This includes L<Mouse::Meta::TypeConstraint> objects.) If the object also
provides C<has_coercion> and C<coerce> methods, these will be used too.

Can also handle coderefs (but not blessed coderefs or objects overloading
C<< &{} >>). Coderefs are expected to return true iff C<< $_ >> passes the
constraint. If C<< $_ >> fails the type constraint, they may either return
false, or die with a helpful error message.

=back

=head2 Methods

These are implemented so that C<< Types::TypeTiny->meta->get_type($foo) >>
works, for rough compatibility with a real L<Type::Library> type library.

=over

=item C<< meta >>

=item C<< type_names >>

=item C<< get_type($name) >>

=item C<< has_type($name) >>

=item C<< coercion_names >>

=item C<< get_coercion($name) >>

=item C<< has_coercion($name) >>

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny>.

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

