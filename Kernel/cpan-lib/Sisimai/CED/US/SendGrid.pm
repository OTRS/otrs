package Sisimai::CED::US::SendGrid;
use parent 'Sisimai::CED';
use feature ':5.10';
use strict;
use warnings;

sub description { 'SendGrid(JSON): http://sendgrid.com/' };
sub adapt {
    # @abstract     Adapt SendGrid bounce object for Sisimai::Message format
    # @param        [Hash] argvs     bounce object(JSON) retrieved via SendGrid API
    # @return       [Hash, Undef]    Bounce data list and message/rfc822 part
    #                                or Undef if it failed to parse or the
    #                                arguments are missing
    # @since v4.20.0
    my $class = shift;
    my $argvs = shift;

    return undef unless ref $argvs eq 'HASH';
    return undef unless scalar keys %$argvs;
    return undef unless exists $argvs->{'email'};

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $rfc822head = {};    # (Hash) Check flags for headers in RFC822 part
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = $dscontents->[-1];

    require Sisimai::String;
    require Sisimai::Address;
    require Sisimai::RFC5322;

    if( Sisimai::RFC5322->is_emailaddress($argvs->{'email'}) ) {
        #   {
        #       "status": "4.0.0",
        #       "created": "2011-09-16 22:02:19",
        #       "reason": "Unable to resolve MX host sendgrid.ne",
        #       "email": "esting@sendgrid.ne"
        #   },
        $recipients++;
        $v->{'recipient'} = $argvs->{'email'};
        $v->{'date'} = $argvs->{'created'};

        my $statuscode = $argvs->{'status'}  || '';
        my $diagnostic = Sisimai::String->sweep($argvs->{'reason'}) || '';

        if( $statuscode =~ m/\A[245]\d\d\z/ ) {
            # "status": "550"
            $v->{'replycode'} = $statuscode;

        } elsif( $statuscode =~ m/\A[245][.]\d[.]\d+\z/ ) {
            # "status": "5.1.1"
            $v->{'status'} = $statuscode;
        }

        require Sisimai::SMTP::Reply;
        require Sisimai::SMTP::Status;
        $v->{'status'}    ||= Sisimai::SMTP::Status->find($diagnostic);
        $v->{'replycode'} ||= Sisimai::SMTP::Reply->find($diagnostic);
        $v->{'diagnosis'}   = $argvs->{'reason'} || '';
        $v->{'agent'}       = __PACKAGE__->smtpagent;

        # Generate pseudo message/rfc822 part
        $rfc822head = {
            'to'   => $argvs->{'email'},
            'from' => Sisimai::Address->undisclosed('s'),
            'date' => $v->{'date'},
        };

    } else {
        # The value of $argvs->{'email'} does not seems to an email address
        return undef;
    }
    return undef if $recipients == 0;
    return { 'ds' => $dscontents, 'rfc822' => $rfc822head };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::CED::US::SendGrid - bounce object (JSON) parser class for C<SendGrid>.

=head1 SYNOPSIS

    use Sisimai::CED::US::SendGrid;

=head1 DESCRIPTION

Sisimai::CED::US::SendGrid parses a bounce object as JSON which created by
C<SendGrid>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::CED::US::SendGrid->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::CED::US::SendGrid->smtpagent;

=head2 C<B<adapt(I<Hash>)>>

C<adapt()> method adapts SendGrid bounce object (JSON) for Perl hash object
used at Sisimai::Message class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

