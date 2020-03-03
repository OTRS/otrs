package Types::Standard::HashRef;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Types::Standard::HashRef::AUTHORITY = 'cpan:TOBYINK';
	$Types::Standard::HashRef::VERSION   = '1.010000';
}

$Types::Standard::HashRef::VERSION =~ tr/_//d;

use Type::Tiny ();
use Types::Standard ();
use Types::TypeTiny ();

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

no warnings;

sub __constraint_generator
{
	return Types::Standard::HashRef unless @_;
	
	my $param = shift;
	Types::TypeTiny::TypeTiny->check($param)
		or _croak("Parameter to HashRef[`a] expected to be a type constraint; got $param");
	
	my $param_compiled_check = $param->compiled_check;
	my $xsub;
	if (Type::Tiny::_USE_XS)
	{
		my $paramname = Type::Tiny::XS::is_known($param_compiled_check);
		$xsub = Type::Tiny::XS::get_coderef_for("HashRef[$paramname]")
			if $paramname;
	}
	elsif (Type::Tiny::_USE_MOUSE and $param->_has_xsub)
	{
		require Mouse::Util::TypeConstraints;
		my $maker = "Mouse::Util::TypeConstraints"->can("_parameterize_HashRef_for");
		$xsub = $maker->($param) if $maker;
	}
	
	return (
		sub
		{
			my $hash = shift;
			$param->check($_) || return for values %$hash;
			return !!1;
		},
		$xsub,
	);
}

sub __inline_generator
{
	my $param = shift;
	
	my $compiled = $param->compiled_check;
	my $xsubname;
	if (Type::Tiny::_USE_XS and not $Type::Tiny::AvoidCallbacks)
	{
		my $paramname = Type::Tiny::XS::is_known($compiled);
		$xsubname  = Type::Tiny::XS::get_subname_for("HashRef[$paramname]");
	}
	
	return unless $param->can_be_inlined;
	return sub {
		my $v = $_[1];
		return "$xsubname\($v\)" if $xsubname && !$Type::Tiny::AvoidCallbacks;
		my $p = Types::Standard::HashRef->inline_check($v);
		my $param_check = $param->inline_check('$i');
		
		"$p and do { "
		.  "my \$ok = 1; "
		.  "for my \$i (values \%{$v}) { "
		.    "(\$ok = 0, last) unless $param_check "
		.  "}; "
		.  "\$ok "
		."}"
	};
}

sub __deep_explanation
{
	require B;
	my ($type, $value, $varname) = @_;
	my $param = $type->parameters->[0];
	
	for my $k (sort keys %$value)
	{
		my $item = $value->{$k};
		next if $param->check($item);
		return [
			sprintf('"%s" constrains each value in the hash with "%s"', $type, $param),
			@{ $param->validate_explain($item, sprintf('%s->{%s}', $varname, B::perlstring($k))) },
		];
	}
	
	# This should never happen...
	return;  # uncoverable statement
}

sub __coercion_generator
{
	my ($parent, $child, $param) = @_;
	return unless $param->has_coercion;
	
	my $coercable_item = $param->coercion->_source_type_union;
	my $C = "Type::Coercion"->new(type_constraint => $child);
	
	if ($param->coercion->can_be_inlined and $coercable_item->can_be_inlined)
	{
		$C->add_type_coercions($parent => Types::Standard::Stringable {
			my @code;
			push @code, 'do { my ($orig, $return_orig, %new) = ($_, 0);';
			push @code,    'for (keys %$orig) {';
			push @code, sprintf('$return_orig++ && last unless (%s);', $coercable_item->inline_check('$orig->{$_}'));
			push @code, sprintf('$new{$_} = (%s);', $param->coercion->inline_coercion('$orig->{$_}'));
			push @code,    '}';
			push @code,    '$return_orig ? $orig : \\%new';
			push @code, '}';
			"@code";
		});
	}
	else
	{
		$C->add_type_coercions(
			$parent => sub {
				my $value = @_ ? $_[0] : $_;
				my %new;
				for my $k (keys %$value)
				{
					return $value unless $coercable_item->check($value->{$k});
					$new{$k} = $param->coerce($value->{$k});
				}
				return \%new;
			},
		);
	}
	
	return $C;
}

sub __hashref_allows_key {
	my $self = shift;
	Types::Standard::Str()->check($_[0]);
}

sub __hashref_allows_value {
	my $self = shift;
	my ($key, $value) = @_;
	
	return !!0 unless $self->my_hashref_allows_key($key);
	return !!1 if $self==Types::Standard::HashRef();
	
	my $href  = $self->find_parent(sub { $_->has_parent && $_->parent==Types::Standard::HashRef() });
	my $param = $href->type_parameter;
	
	Types::Standard::Str()->check($key) and $param->check($value);
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Types::Standard::HashRef - internals for the Types::Standard HashRef type constraint

=head1 STATUS

This module is considered part of Type-Tiny's internals. It is not
covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

This file contains some of the guts for L<Types::Standard>.
It will be loaded on demand. You may ignore its presence.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Types::Standard>.

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

