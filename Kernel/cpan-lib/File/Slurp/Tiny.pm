package File::Slurp::Tiny;
$File::Slurp::Tiny::VERSION = '0.004';
use strict;
use warnings;

use Carp 'croak';
use Exporter 5.57 'import';
use File::Spec::Functions 'catfile';
use FileHandle;
our @EXPORT_OK = qw/read_file read_lines write_file read_dir/;

my $default_layer = $^O eq 'MSWin32' ? ':crlf' : ':unix';

sub read_file {
	my ($filename, %options) = @_;
	my $layer = $options{binmode} || $default_layer;
	my $buf_ref = defined $options{buf_ref} ? $options{buf_ref} : \my $buf;

	open my $fh, "<$layer", $filename or croak "Couldn't open $filename: $!";
	if (my $size = -s $fh) {
		my ($pos, $read) = 0;
		do {
			defined($read = read $fh, ${$buf_ref}, $size - $pos, $pos) or croak "Couldn't read $filename: $!";
			$pos += $read;
		} while ($read && $pos < $size);
	}
	else {
		${$buf_ref} = do { local $/; <$fh> };
	}
	close $fh;
	return if not defined wantarray or $options{buf_ref};
	return $options{scalar_ref} ? $buf_ref : $buf;
}

sub read_lines {
	my ($filename, %options) = @_;
	my $layer = delete $options{binmode} || ':';
	
	open my $fh, "<$layer", $filename or croak "Couldn't open $filename: $!";
	return <$fh> if not %options;
	my @buf = <$fh>;
	close $fh;
	chomp @buf if $options{chomp};
	return $options{array_ref} ? \@buf : @buf;
}

sub write_file {
	my ($filename, undef, %options) = @_;
	my $layer = $options{binmode} || $default_layer;
	my $mode = $options{append} ? '>>' : '>';
	my $buf_ref = defined $options{buf_ref} ? $options{buf_ref} : \$_[1];

	open my $fh, $mode.$layer, $filename or croak "Couldn't open $filename: $!";
	$fh->autoflush(1);
	print $fh ${$buf_ref} or croak "Couldn't write to $filename: $!";
	close $fh or croak "Couldn't close $filename: $!";
	return;
}

sub read_dir {
	my ($dirname, %options) = @_;
	opendir my ($dir), $dirname or croak "Could not open $dirname: $!";
	my @ret = grep { not m/ \A \.\.? \z /x } readdir $dir;
	@ret = map { catfile($dirname, $_) } @ret if $options{prefix};
	closedir $dir;
	return @ret;
}

1;

# ABSTRACT: A simple, sane and efficient file slurper [DISCOURAGED]

__END__

=pod

=encoding UTF-8

=head1 NAME

File::Slurp::Tiny - A simple, sane and efficient file slurper [DISCOURAGED]

=head1 VERSION

version 0.004

=head1 SYNOPSIS

 use File::Slurp::Tiny 'read_file';
 my $content = read_file($filename);

=head1 DISCOURAGED

B<This module is discouraged in favor of L<File::Slurper|File::Slurper>>. While a useful experiment, it turned out to be both too similar to File::Slurp (still containing most problematic features of File::Slurp's interface) and yet not similar enough to be a true drop-in replacement.

Bugs will still be fixed, but new features will probably not be added.

=head1 DESCRIPTION

This module provides functions for fast and correct slurping and spewing. All functions are optionally exported.

=head1 FUNCTIONS

=head2 read_file($filename, %options)

Reads file C<$filename> into a scalar. By default it returns this scalar. Can optionally take these named arguments:

=over 4

=item * binmode

Set the layers to read the file with. The default will be something sensible on your platform.

=item * buf_ref

Pass a reference to a scalar to read the file into, instead of returning it by value. This has performance benefits.

=item * scalar_ref

If set to true, C<read_file> will return a reference to a scalar containing the file content.

=back

=head2 read_lines($filename, %options)

Reads file C<$filename> into a list/array. By default it returns this list. Can optionally take these named arguments:

=over 4

=item * binmode

Set the layers to read the file with. The default will be something sensible on your platform.

=item * array_ref

Pass a reference to an array to read the lines into, instead of returning them by value. This has performance benefits.

=item * chomp

C<chomp> the lines.

=back

=head2 write_file($filename, $content, %options)

Open C<$filename>, and write C<$content> to it. Can optionally take this named argument:

=over 4

=item * binmode

Set the layers to write the file with. The default will be something sensible on your platform.

=back

=head2 read_dir($dirname, %options)

Open C<dirname> and return all entries except C<.> and C<..>. Can optionally take this named argument:

=over 4

=item * prefix

This will prepend C<$dir> to the entries

=back

=head1 SEE ALSO

=over 4

=item * L<Path::Tiny>

A minimalistic abstraction not only around 

=item * L<File::Slurp>

Another file slurping tool.

=back

=head1 AUTHOR

Leon Timmermans <leont@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Leon Timmermans.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
