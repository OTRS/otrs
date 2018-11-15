package Sisimai::Rhost::KDDI;
use feature ':5.10';
use strict;
use warnings;

my $MessagesOf = {
    'filtered'    => '550 : User unknown',  # The response was: 550 : User unknown
    'userunknown' => '>: User unknown',     # The response was: 550 <...>: User unknown
};

sub get {
    # Detect bounce reason from au(KDDI)
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String]                The bounce reason au.com and ezweb.ne.jp
    my $class = shift;
    my $argvs = shift // return undef;

    my $statusmesg = $argvs->diagnosticcode;
    my $reasontext = '';

    for my $e ( keys %$MessagesOf ) {
        # Try to match the error message with message patterns defined in $MessagesOf
        next unless rindex($statusmesg, $MessagesOf->{ $e }) > -1;
        $reasontext = $e;
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::KDDI - Detect the bounce reason returned from au (KDDI).

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Data
object as an argument of get() method when the value of C<rhost> of the object
is "msmx.au.com" or "lsean.ezweb.ne.jp".
This class is called only Sisimai::Data class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Data Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

