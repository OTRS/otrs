package Types::Standard::Map;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Types::Standard::Map::AUTHORITY = 'cpan:TOBYINK';
	$Types::Standard::Map::VERSION   = '1.010000';
}

$Types::Standard::Map::VERSION =~ tr/_//d;

use Type::Tiny ();
use Types::Standard ();
use Types::TypeTiny ();

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

my $meta = Types::Standard->meta;

no warnings;

sub __constraint_generator
{
	return $meta->get_type('Map') unless @_;
	
	my ($keys, $values) = @_;
	Types::TypeTiny::TypeTiny->check($keys)
		or _croak("First parameter to Map[`k,`v] expected to be a type constraint; got $keys");
	Types::TypeTiny::TypeTiny->check($values)
		or _croak("Second parameter to Map[`k,`v] expected to be a type constraint; got $values");
	
	my @xsub;
	if (Type::Tiny::_USE_XS)
	{
		my @known = map {
			my $known = Type::Tiny::XS::is_known($_->compiled_check);
			defined($known) ? $known : ();
		} ($keys, $values);
		
		if (@known == 2)
		{
			my $xsub = Type::Tiny::XS::get_coderef_for(
				sprintf "Map[%s,%s]", @known
			);
			push @xsub, $xsub if $xsub;
		}
	}
	
	sub
	{
		my $hash = shift;
		$keys->check($_)   || return for keys %$hash;
		$values->check($_) || return for values %$hash;
		return !!1;
	}, @xsub;
}

sub __inline_generator
{
	my ($k, $v) = @_;
	return unless $k->can_be_inlined && $v->can_be_inlined;
	
	my $xsubname;
	if (Type::Tiny::_USE_XS)
	{
		my @known = map {
			my $known = Type::Tiny::XS::is_known($_->compiled_check);
			defined($known) ? $known : ();
		} ($k, $v);
		
		if (@known == 2)
		{
			$xsubname = Type::Tiny::XS::get_subname_for(
				sprintf "Map[%s,%s]", @known
			);
		}
	}
	
	return sub {
		my $h = $_[1];
		return "$xsubname\($h\)" if $xsubname && !$Type::Tiny::AvoidCallbacks;
		my $p = Types::Standard::HashRef->inline_check($h);
		my $k_check = $k->inline_check('$k');
		my $v_check = $v->inline_check('$v');
		"$p and do { "
		.  "my \$ok = 1; "
		.  "for my \$v (values \%{$h}) { "
		.    "(\$ok = 0, last) unless $v_check "
		.  "}; "
		.  "for my \$k (keys \%{$h}) { "
		.    "(\$ok = 0, last) unless $k_check "
		.  "}; "
		.  "\$ok "
		."}"
	};
}

sub __deep_explanation
{
	require B;
	my ($type, $value, $varname) = @_;
	my ($kparam, $vparam) = @{ $type->parameters };
	
	for my $k (sort keys %$value)
	{
		unless ($kparam->check($k))
		{
			return [
				sprintf('"%s" constrains each key in the hash with "%s"', $type, $kparam),
				@{ $kparam->validate_explain($k, sprintf('key %s->{%s}', $varname, B::perlstring($k))) },
			];
		}
		
		unless ($vparam->check($value->{$k}))
		{
			return [
				sprintf('"%s" constrains each value in the hash with "%s"', $type, $vparam),
				@{ $vparam->validate_explain($value->{$k}, sprintf('%s->{%s}', $varname, B::perlstring($k))) },
			];
		}
	}
	
	# This should never happen...
	return;  # uncoverable statement
}

sub __coercion_generator
{
	my ($parent, $child, $kparam, $vparam) = @_;
	return unless $kparam->has_coercion || $vparam->has_coercion;
	
	my $kcoercable_item = $kparam->has_coercion ? $kparam->coercion->_source_type_union : $kparam;
	my $vcoercable_item = $vparam->has_coercion ? $vparam->coercion->_source_type_union : $vparam;
	my $C = "Type::Coercion"->new(type_constraint => $child);
	
	if ((!$kparam->has_coercion or $kparam->coercion->can_be_inlined)
	and (!$vparam->has_coercion or $vparam->coercion->can_be_inlined)
	and $kcoercable_item->can_be_inlined
	and $vcoercable_item->can_be_inlined)
	{
		$C->add_type_coercions($parent => Types::Standard::Stringable {
			my @code;
			push @code, 'do { my ($orig, $return_orig, %new) = ($_, 0);';
			push @code,    'for (keys %$orig) {';
			push @code, sprintf('++$return_orig && last unless (%s);', $kcoercable_item->inline_check('$_'));
			push @code, sprintf('++$return_orig && last unless (%s);', $vcoercable_item->inline_check('$orig->{$_}'));
			push @code, sprintf('$new{(%s)} = (%s);',
				$kparam->has_coercion ? $kparam->coercion->inline_coercion('$_') : '$_',
				$vparam->has_coercion ? $vparam->coercion->inline_coercion('$orig->{$_}') : '$orig->{$_}',
			);
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
					return $value unless $kcoercable_item->check($k) && $vcoercable_item->check($value->{$k});
					$new{$kparam->has_coercion ? $kparam->coerce($k) : $k} =
						$vparam->has_coercion ? $vparam->coerce($value->{$k}) : $value->{$k};
				}
				return \%new;
			},
		);
	}
	
	return $C;
}

sub __hashref_allows_key {
	my $self = shift;
	my ($key) = @_;
	
	return Types::Standard::Str()->check($key) if $self==Types::Standard::Map();
	
	my $map = $self->find_parent(sub { $_->has_parent && $_->parent==Types::Standard::Map() });
	my ($kcheck, $vcheck) = @{ $map->parameters };
	
	($kcheck or Types::Standard::Any())->check($key);
}

sub __hashref_allows_value {
	my $self = shift;
	my ($key, $value) = @_;
	
	return !!0 unless $self->my_hashref_allows_key($key);
	return !!1 if $self==Types::Standard::Map();
	
	my $map = $self->find_parent(sub { $_->has_parent && $_->parent==Types::Standard::Map() });
	my ($kcheck, $vcheck) = @{ $map->parameters };
	
	($kcheck or Types::Standard::Any())->check($key)
		and ($vcheck or Types::Standard::Any())->check($value);
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Types::Standard::Map - internals for the Types::Standard Map type constraint

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

