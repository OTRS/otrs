package Sisimai::Bite::JSON::SendGrid;
use parent 'Sisimai::Bite::JSON';
use feature ':5.10';
use strict;
use warnings;

sub description { 'SendGrid(JSON): http://sendgrid.com/' };
sub adapt {
    # Adapt SendGrid bounce object for Sisimai::Message format
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
    return undef unless Sisimai::RFC5322->is_emailaddress($argvs->{'email'});

    my $dscontents = undef;
    my $rfc822head = {};
    my $v = undef;

    if( exists $argvs->{'event'} ) {
        # https://sendgrid.com/docs/API_Reference/Webhooks/event.html
        # {
        #   'tls' => 0,
        #   'timestamp' => 1504555832,
        #   'event' => 'bounce',
        #   'email' => 'mailboxfull@example.jp',
        #   'ip' => '192.0.2.22',
        #   'sg_message_id' => '03_Wof6nRbqqzxRvLpZbfw.filter0017p3mdw1-11399-59ADB335-16.0',
        #   'type' => 'blocked',
        #   'sg_event_id' => 'S4wr46YHS0qr3BKhawTQjQ',
        #   'reason' => '550 5.2.2 <mailboxfull@example.jp>... Mailbox Full ',
        #   'smtp-id' => '<201709042010.v84KAQ5T032530@example.nyaan.jp>',
        #   'status' => '5.2.2'
        # },
        return undef unless $argvs->{'event'} =~ /\A(?:bounce|deferred|delivered|spamreport)\z/;
        use Sisimai::Time;
        $dscontents = [__PACKAGE__->DELIVERYSTATUS];
        $v = $dscontents->[-1];

        $v->{'date'}      = gmtime(Sisimai::Time->new($argvs->{'timestamp'}));
        $v->{'agent'}     = __PACKAGE__->smtpagent;
        $v->{'lhost'}     = $argvs->{'ip'};
        $v->{'status'}    = $argvs->{'status'} || '';
        $v->{'diagnosis'} = Sisimai::String->sweep($argvs->{'reason'} || $argvs->{'response'}) || '';
        $v->{'recipient'} = $argvs->{'email'};

        if( $argvs->{'event'} eq 'delivered' ) {
            # "event": "delivered"
            $v->{'reason'} = 'delivered';

        } elsif( $argvs->{'event'} eq 'spamreport' ) {
            # [
            #   {
            #     "email": "kijitora@example.com",
            #     "timestamp": 1504837383,
            #     "sg_message_id": "6_hrAeKvTDaB5ynBI2nbnQ.filter0002p3las1-27574-59B1FDA3-19.0",
            #     "sg_event_id": "o70uHqbMSXOaaoveMZIjjg",
            #     "event": "spamreport"
            #   }
            # ]
            $v->{'reason'} = 'feedback';
            $v->{'feedbacktype'} = 'abuse';
        }
        $v->{'status'}    ||= Sisimai::SMTP::Status->find($v->{'diagnosis'});
        $v->{'replycode'} ||= Sisimai::SMTP::Reply->find($v->{'diagnosis'});

        # Generate pseudo message/rfc822 part
        $rfc822head = {
            'from'       => Sisimai::Address->undisclosed('s'),
            'message-id' => $argvs->{'sg_message_id'},
        };
    } else {
        #   {
        #       "status": "4.0.0",
        #       "created": "2011-09-16 22:02:19",
        #       "reason": "Unable to resolve MX host sendgrid.ne",
        #       "email": "esting@sendgrid.ne"
        #   },
        $dscontents = [__PACKAGE__->DELIVERYSTATUS];
        $v = $dscontents->[-1];

        $v->{'recipient'} = $argvs->{'email'};
        $v->{'date'} = $argvs->{'created'};

        my $statuscode = $argvs->{'status'} || '';
        my $diagnostic = Sisimai::String->sweep($argvs->{'reason'}) || '';

        if( $statuscode =~ /\A[245]\d\d\z/ ) {
            # "status": "550"
            $v->{'replycode'} = $statuscode;

        } elsif( $statuscode =~ /\A[245][.]\d[.]\d+\z/ ) {
            # "status": "5.1.1"
            $v->{'status'} = $statuscode;
        }

        $v->{'status'}    ||= Sisimai::SMTP::Status->find($diagnostic);
        $v->{'replycode'} ||= Sisimai::SMTP::Reply->find($diagnostic);
        $v->{'diagnosis'}   = $argvs->{'reason'} || '';
        $v->{'agent'}       = __PACKAGE__->smtpagent;

        # Generate pseudo message/rfc822 part
        $rfc822head = {
            'from' => Sisimai::Address->undisclosed('s'),
            'date' => $v->{'date'},
        };
    }
    return { 'ds' => $dscontents, 'rfc822' => $rfc822head };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::JSON::SendGrid - bounce object (JSON) parser class for C<SendGrid>.

=head1 SYNOPSIS

    use Sisimai::Bite::JSON::SendGrid;

=head1 DESCRIPTION

Sisimai::Bite::JSON::SendGrid parses a bounce object as JSON which created by
C<SendGrid>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::JSON::SendGrid->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::JSON::SendGrid->smtpagent;

=head2 C<B<adapt(I<Hash>)>>

C<adapt()> method adapts SendGrid bounce object (JSON) for Perl hash object
used at Sisimai::Message class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

