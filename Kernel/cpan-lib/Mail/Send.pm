
package Mail::Send;

# $Id: Send.pm,v 1.3 2006-12-14 19:58:52 mh Exp $

use strict;
use Carp;
use vars qw($VERSION);
require Mail::Mailer;

$VERSION = "1.74";

sub Version { $VERSION }

sub new {
    my $pkg = shift;
    my %attr = @_;
    my($key, $value);
    my $me = bless {}, $pkg;
    while( ($key, $value) = each %attr ) {
	$key = lc($key);
	$me->$key($value);
    }
    $me;
}

sub set {
    my($me, $hdr, @values) = @_;
    $me->{$hdr} = [ @values ] if @values;
    @{$me->{$hdr} || []};	# return new (or original) values
}

sub add {
    my($me, $hdr, @values) = @_;
    $me->{$hdr} = [] unless $me->{$hdr};
    push(@{$me->{$hdr}}, @values);
}

sub delete {
    my($me, $hdr) = @_;
    delete $me->{$hdr};
}

sub to		{ my $me=shift; $me->set('To', @_); }
sub cc		{ my $me=shift; $me->set('Cc', @_); }
sub bcc		{ my $me=shift; $me->set('Bcc', @_); }
sub subject	{ my $me=shift; $me->set('Subject', join (' ', @_)); }


sub open {
    my $me = shift;
    Mail::Mailer->new(@_)->open($me);
}

1;

__END__

=head1 NAME

Mail::Send - Simple electronic mail interface

=head1 SYNOPSIS

    require Mail::Send;

    $msg = new Mail::Send;

    $msg = new Mail::Send Subject=>'example subject', To=>'timbo';

    $msg->to('user@host');
    $msg->to('user@host', 'user2@example.com');
    $msg->subject('example subject');
    $msg->cc('user@host');
    $msg->bcc('someone@else');

    $msg->set($header, @values);
    $msg->add($header, @values);
    $msg->delete($header);

    # Launch mailer and set headers. The filehandle returned
    # by open() is an instance of the Mail::Mailer class.
    # Arguments to the open() method are passed to the Mail::Mailer
    # constructor.

    $fh = $msg->open;               # some default mailer
    # $fh = $msg->open('sendmail'); # explicit

    print $fh "Body of message";

    $fh->close;         # complete the message and send it

    $fh->cancel;        # not yet implemented

=head1 DESCRIPTION

=head1 SEE ALSO

Mail::Mailer

=head1 AUTHORS

Maintained by Mark Overmeer <mailtools@overmeer.net>

Original code written by Tim Bunce E<lt>F<Tim.Bunce@ig.co.uk>E<gt>,
with a kick start from Graham Barr E<lt>F<gbarr@pobox.com>E<gt>. With
contributions by Gerard Hickey E<lt>F<hickey@ctron.com>E<gt>

Copyright (c) 2002-2003 Mark Overmeer. All rights
reserved. This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


