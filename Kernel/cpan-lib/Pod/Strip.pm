package Pod::Strip;

use warnings;
use strict;

use base ('Pod::Simple');

our $VERSION = "1.02";

sub new {
    my $new = shift->SUPER::new(@_);
    $new->{_code_line}=0;
    $new->code_handler(
        sub {
            # Add optional line directives
            if ($_[2]->{_replace_with_comments}) {
                if ($_[2]->{_code_line}+1<$_[1]) {
                    print {$_[2]{output_fh}} ("# stripped POD\n") x ($_[1] - $_[2]->{_code_line} -1 );
                }
                $_[2]->{_code_line}=$_[1];
            }
            print {$_[2]{output_fh}} $_[0],"\n";
            return;
       });
    return $new;
}


sub replace_with_comments {
    my $self = shift;
    $self->{_replace_with_comments} = defined $_[0] ? $_[0] : 1;
}


1;
__END__

=pod

=head1 NAME

Pod::Strip - Remove POD from Perl code

=head1 SYNOPSIS

    use Pod::Strip;

    my $p=Pod::Strip->new;              # create parser
    my $podless;                        # set output string
    $p->output_string(\$podless);       # see Pod::Simple
    $p->parse_string_document($code);   # or some other parsing method
                                        #    from Pod::Simple
    # $podless will now contain code without any POD


=head1 DESCRIPTION

Pod::Strip is a subclass of Pod::Simple that strips all POD from Perl Code.

=head1 METHODS

All methods besides those listed here are inherited from Pod::Simple

=head2 new

Generate a new parser object.

=head2 replace_with_comments

Call this method with a true argument to replace POD with comments (looking like "# stripped POD") instead of stripping it.

This has the effect that line numbers get reported correctly in error
messages etc.

=head1 AUTHOR

Thomas Klausner, C<< <domm@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-pod-strip@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2004, 2005, 2006 Thomas Klausner, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

