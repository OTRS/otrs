package Net::POP3::SSLWrapper;
use strict;
use warnings;
use parent qw/Net::Cmd IO::Socket::SSL Exporter/;
use 5.008001;
use Net::POP3;

our $VERSION = '0.06';
our @EXPORT = 'pop3s';

my @instances;

sub pop3s(&) { ## no critic.
    my $code = shift;

    local @Net::POP3::ISA = __PACKAGE__;

    $code->();

    undef $_ for @instances;
}

sub new {
    my $class = shift;

    my $self = $class->SUPER::new(@_);
    return if !$self;
    $self->blocking(0); # XXX why need this?
    push @instances, $self;
    return $self;
}

1;
__END__

=head1 NAME

Net::POP3::SSLWrapper - simple POP3S wrapper for Net::POP3

=head1 SYNOPSIS

  use Net::POP3::SSLWrapper;
  pop3s {
    my $pop3 = Net::POP3->new('mail.example.com', Port => 995) or die "Can't connect";
    if ($pop3->login($YOURMAIL, $PASSWORD) > 0) {
      my $msgnum = $pop3->list;
    }
    $pop3->quit;
  };

=head1 DESCRIPTION

Net::POP3::SSLWrapper is simple POP3S wrapper for Net::POP3.

You can easy to support POP3S, with very small code change.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
