package Types::Standard::ArrayRef;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Types::Standard::ArrayRef::AUTHORITY = 'cpan:TOBYINK';
	$Types::Standard::ArrayRef::VERSION   = '1.010000';
}

$Types::Standard::ArrayRef::VERSION =~ tr/_//d;

use Type::Tiny ();
use Types::Standard ();
use Types::TypeTiny ();

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

no warnings;

sub __constraint_generator
{
	return Types::Standard::ArrayRef unless @_;
	
	my $param = shift;
	Types::TypeTiny::TypeTiny->check($param)
		or _croak("Parameter to ArrayRef[`a] expected to be a type constraint; got $param");
	
	my ($min, $max) = (0, -1);
	$min = Types::Standard::Int->assert_return(shift) if @_;
	$max = Types::Standard::Int->assert_return(shift) if @_;
	
	my $param_compiled_check = $param->compiled_check;
	my $xsub;
	if (Type::Tiny::_USE_XS and $min==0 and $max==-1)
	{
		my $paramname = Type::Tiny::XS::is_known($param_compiled_check);
		$xsub = Type::Tiny::XS::get_coderef_for("ArrayRef[$paramname]")
			if $paramname;
	}
	elsif (Type::Tiny::_USE_MOUSE and $param->_has_xsub and $min==0 and $max==-1)
	{
		require Mouse::Util::TypeConstraints;
		my $maker = "Mouse::Util::TypeConstraints"->can("_parameterize_ArrayRef_for");
		$xsub = $maker->($param) if $maker;
	}
	
	return (
		sub {
			my $array = shift;
			$param->check($_) || return for @$array;
			return !!1;
		},
		$xsub,
	) if $min==0 and $max==-1;
	
	return sub {
		my $array = shift;
		return if @$array < $min;
		$param->check($_) || return for @$array;
		return !!1;
	} if $max==-1;
	
	return sub {
		my $array = shift;
		return if @$array > $max;
		$param->check($_) || return for @$array;
		return !!1;
	} if $min==0;
	
	return sub {
		my $array = shift;
		return if @$array < $min;
		return if @$array > $max;
		$param->check($_) || return for @$array;
		return !!1;
	};
}

sub __inline_generator
{
	my $param = shift;
	my ($min, $max) = (0, -1);
	$min = shift if @_;
	$max = shift if @_;
	
	my $param_compiled_check = $param->compiled_check;
	my $xsubname;
	if (Type::Tiny::_USE_XS and $min==0 and $max==-1)
	{
		my $paramname = Type::Tiny::XS::is_known($param_compiled_check);
		$xsubname  = Type::Tiny::XS::get_subname_for("ArrayRef[$paramname]");
	}
	
	return unless $param->can_be_inlined;
	
	return sub {
		my $v = $_[1];
		return "$xsubname\($v\)" if $xsubname && !$Type::Tiny::AvoidCallbacks;
		my $p = Types::Standard::ArrayRef->inline_check($v);
		
		if ($min != 0) {
			$p .= sprintf(' and @{%s} >= %d', $v, $min);
		}
		if ($max > 0) {
			$p .= sprintf(' and @{%s} <= %d', $v, $max);
		}
		
		my $param_check = $param->inline_check('$i');
		return $p if $param->{uniq} eq Types::Standard::Any->{uniq};
		
		"$p and do { "
		.  "my \$ok = 1; "
		.  "for my \$i (\@{$v}) { "
		.    "(\$ok = 0, last) unless $param_check "
		.  "}; "
		.  "\$ok "
		."}"
	};
}

sub __deep_explanation
{
	my ($type, $value, $varname) = @_;
	my $param = $type->parameters->[0];
	my ($min, $max) = (0, -1);
	$min = $type->parameters->[1] if @{$type->parameters} > 1;  # TODO
	$max = $type->parameters->[2] if @{$type->parameters} > 2;  # TODO
	
	if ($min != 0 and @$value < $min) {
		return [
			sprintf('"%s" constrains array length at least %s', $type, $min),
			sprintf('@{%s} is %d', $varname, scalar @$value),
		];
	}
	
	if ($max > 0 and @$value > $max) {
		return [
			sprintf('"%s" constrains array length at most %d', $type, $max),
			sprintf('@{%s} is %d', $varname, scalar @$value),
		];
	}
	
	for my $i (0 .. $#$value)
	{
		my $item = $value->[$i];
		next if $param->check($item);
		return [
			sprintf('"%s" constrains each value in the array with "%s"', $type, $param),
			@{ $param->validate_explain($item, sprintf('%s->[%d]', $varname, $i)) },
		];
	}
	
	# This should never happen...
	return;  # uncoverable statement
}

# TODO: min and max???
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
			push @code, 'do { my ($orig, $return_orig, @new) = ($_, 0);';
			push @code,    'for (@$orig) {';
			push @code, sprintf('++$return_orig && last unless (%s);', $coercable_item->inline_check('$_'));
			push @code, sprintf('push @new, (%s);', $param->coercion->inline_coercion('$_'));
			push @code,    '}';
			push @code,    '$return_orig ? $orig : \\@new';
			push @code, '}';
			"@code";
		});
	}
	else
	{
		$C->add_type_coercions(
			$parent => sub {
				my $value = @_ ? $_[0] : $_;
				my @new;
				for my $item (@$value)
				{
					return $value unless $coercable_item->check($item);
					push @new, $param->coerce($item);
				}
				return \@new;
			},
		);
	}
	
	return $C;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Types::Standard::ArrayRef - internals for the Types::Standard ArrayRef type constraint

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

