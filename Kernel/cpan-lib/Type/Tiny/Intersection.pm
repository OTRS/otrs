package Type::Tiny::Intersection;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Type::Tiny::Intersection::AUTHORITY = 'cpan:TOBYINK';
	$Type::Tiny::Intersection::VERSION   = '1.010000';
}

$Type::Tiny::Intersection::VERSION =~ tr/_//d;

use Scalar::Util qw< blessed >;
use Types::TypeTiny ();

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

use Type::Tiny ();
our @ISA = 'Type::Tiny';

__PACKAGE__->_install_overloads(
	q[@{}] => sub { $_[0]{type_constraints} ||= [] },
);

sub new {
	my $proto = shift;
	
	my %opts = (@_==1) ? %{$_[0]} : @_;
	_croak "Intersection type constraints cannot have a parent constraint" if exists $opts{parent};
	_croak "Intersection type constraints cannot have a constraint coderef passed to the constructor" if exists $opts{constraint};
	_croak "Intersection type constraints cannot have a inlining coderef passed to the constructor" if exists $opts{inlined};
	_croak "Need to supply list of type constraints" unless exists $opts{type_constraints};
	
	$opts{type_constraints} = [
		map { $_->isa(__PACKAGE__) ? @$_ : $_ }
		map Types::TypeTiny::to_TypeTiny($_),
		@{ ref $opts{type_constraints} eq "ARRAY" ? $opts{type_constraints} : [$opts{type_constraints}] }
	];
	
	if (Type::Tiny::_USE_XS)
	{
		my @constraints = @{$opts{type_constraints}};
		my @known = map {
			my $known = Type::Tiny::XS::is_known($_->compiled_check);
			defined($known) ? $known : ();
		} @constraints;
		
		if (@known == @constraints)
		{
			my $xsub = Type::Tiny::XS::get_coderef_for(
				sprintf "AllOf[%s]", join(',', @known)
			);
			$opts{compiled_type_constraint} = $xsub if $xsub;
		}
	}
	
	return $proto->SUPER::new(%opts);
}

sub type_constraints { $_[0]{type_constraints} }
sub constraint       { $_[0]{constraint} ||= $_[0]->_build_constraint }

sub _is_null_constraint { 0 }

sub _build_display_name
{
	my $self = shift;
	join q[&], @$self;
}

sub _build_constraint
{
	my @checks = map $_->compiled_check, @{+shift};
	return sub
	{
		my $val = $_;
		$_->($val) || return for @checks;
		return !!1;
	}
}

sub can_be_inlined
{
	my $self = shift;
	not grep !$_->can_be_inlined, @$self;
}

sub inline_check
{
	my $self = shift;
	
	if (Type::Tiny::_USE_XS and !exists $self->{xs_sub})
	{
		$self->{xs_sub} = undef;
		
		my @constraints = @{$self->type_constraints};
		my @known = map {
			my $known = Type::Tiny::XS::is_known($_->compiled_check);
			defined($known) ? $known : ();
		} @constraints;
		
		if (@known == @constraints)
		{
			$self->{xs_sub} = Type::Tiny::XS::get_subname_for(
				sprintf "AllOf[%s]", join(',', @known)
			);
		}
	}
	
	if (Type::Tiny::_USE_XS and $self->{xs_sub}) {
		return "$self->{xs_sub}\($_[0]\)";
	}
	
	sprintf '(%s)', join " and ", map $_->inline_check($_[0]), @$self;
}

sub has_parent
{
	!!@{ $_[0]{type_constraints} };
}

sub parent
{
	$_[0]{type_constraints}[0];
}

sub validate_explain
{
	my $self = shift;
	my ($value, $varname) = @_;
	$varname = '$_' unless defined $varname;
	
	return undef if $self->check($value);
	
	require Type::Utils;
	for my $type (@$self)
	{
		my $deep = $type->validate_explain($value, $varname);
		return [
			sprintf(
				'"%s" requires that the value pass %s',
				$self,
				Type::Utils::english_list(map qq["$_"], @$self),
			),
			@$deep,
		] if $deep;
	}
	
	# This should never happen...
	return;  # uncoverable statement
}

my $_delegate = sub {
	my ($self, $method) = (shift, shift);
	my @types = @{ $self->type_constraints };
	my $found = 0;
	for my $i (0 .. $#types) {
		my $type = $types[$i];
		if ($type->can($method)) {
			$types[$i] = $type->$method(@_);
			++$found;
			last;
		}
	}
	_croak('Could not apply method %s to any type within the intersection', $method) unless $found;
	ref($self)->new(type_constraints => \@types);
};

sub stringifies_to {
	my $self = shift;
	$self->$_delegate(stringifies_to => @_);
}

sub numifies_to {
	my $self = shift;
	$self->$_delegate(numifies_to => @_);
}

sub with_attribute_values {
	my $self = shift;
	$self->$_delegate(with_attribute_values => @_);
}

my $comparator;
$comparator = sub {
	my $A = shift->find_constraining_type;
	my $B = shift->find_constraining_type;
	
	if ($A->isa(__PACKAGE__)) {
		my @A_constraints = map $_->find_constraining_type, @{ $A->type_constraints };
		
		my @A_equal_to_B = grep $_->equals($B), @A_constraints;
		if (@A_equal_to_B == @A_constraints) {
			return Type::Tiny::CMP_EQUIVALENT();
		}
		
		my @A_subs_of_B = grep $_->is_a_type_of($B), @A_constraints;
		if (@A_subs_of_B) {
			return Type::Tiny::CMP_SUBTYPE();
		}
	}
	
	elsif ($B->isa(__PACKAGE__)) {
		my $r = $comparator->($B, $A);
		return  $r if $r eq Type::Tiny::CMP_EQUIVALENT();
		return -$r if $r eq Type::Tiny::CMP_SUBTYPE();
	}
	
	return Type::Tiny::CMP_UNKNOWN();
};
push @Type::Tiny::CMP, $comparator;

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Type::Tiny::Intersection - intersection type constraints

=head1 STATUS

This module is covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

Intersection type constraints.

This package inherits from L<Type::Tiny>; see that for most documentation.
Major differences are listed below:

=head2 Attributes

=over

=item C<type_constraints>

Arrayref of type constraints.

When passed to the constructor, if any of the type constraints in the
intersection is itself an intersection type constraint, this is "exploded"
into the new intersection.

=item C<constraint>

Unlike Type::Tiny, you I<cannot> pass a constraint coderef to the constructor.
Instead rely on the default.

=item C<inlined>

Unlike Type::Tiny, you I<cannot> pass an inlining coderef to the constructor.
Instead rely on the default.

=item C<parent>

Unlike Type::Tiny, you I<cannot> pass an inlining coderef to the constructor.
A parent will instead be automatically calculated.

(Technically any of the types in the intersection could be treated as a
parent type; we choose the first arbitrarily.)

=back

=head2 Methods

=over

=item C<< stringifies_to($constraint) >>

See L<Type::Tiny::ConstrainedObject>.

=item C<< numifies_to($constraint) >>

See L<Type::Tiny::ConstrainedObject>.

=item C<< with_attribute_values($attr1 => $constraint1, ...) >>

See L<Type::Tiny::ConstrainedObject>.

=back

=head2 Overloading

=over

=item *

Arrayrefification calls C<type_constraints>.

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Tiny::Manual>.

L<Type::Tiny>.

L<MooseX::Meta::TypeConstraint::Intersection>.

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

