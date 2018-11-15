package Sisimai::Bite::JSON::AmazonSES;
use parent 'Sisimai::Bite::JSON';
use feature ':5.10';
use strict;
use warnings;

# https://docs.aws.amazon.com/en_us/ses/latest/DeveloperGuide/notification-contents.html
my $BounceType = {
    'Permanent' => {
        'General'    => '',
        'NoEmail'    => '',
        'Suppressed' => '',
    },
    'Transient' => {
        'General'            => '',
        'MailboxFull'        => 'mailboxfull',
        'MessageTooLarge'    => 'mesgtoobig',
        'ContentRejected'    => '',
        'AttachmentRejected' => '',
    },
};

sub description { 'Amazon SES(JSON): http://aws.amazon.com/ses/' };
sub scan {
    # Detect an error from Amazon SES(JSON)
    # @param         [Hash] mhead       Message headers of a bounce email
    # @options mhead [String] from      From header
    # @options mhead [String] date      Date header
    # @options mhead [String] subject   Subject header
    # @options mhead [Array]  received  Received headers
    # @options mhead [String] others    Other required headers
    # @param         [String] mbody     Message body of a bounce email(JSON)
    # @return        [Hash, Undef]      Bounce data list and message/rfc822 part
    #                                   or Undef if it failed to parse or the
    #                                   arguments are missing
    # @since v4.20.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $stuff = undef;

    return undef unless exists $mhead->{'x-amz-sns-message-id'};
    return undef unless $mhead->{'x-amz-sns-message-id'};

    my @hasdivided = split("\n", $$mbody);
    my $jsonstring = '';
    my $foldedline = 0;

    while( my $e = shift @hasdivided ) {
        # Find JSON string from the message body
        next unless length $e;
        last if $e eq '--';
        last if $e eq '__END_OF_EMAIL_MESSAGE__';

        $e =~ s/\A[ ]// if $foldedline; # The line starts with " ", continued from !\n.
        $foldedline = 0;

        if( substr($e, -1, 1) eq '!' ) {
            # ... long long line ...![\n]
            substr($e, -1, 1, '');
            $foldedline = 1;
        }
        $jsonstring .= $e;
    }

    require JSON;
    eval {
        my $jsonparser = JSON->new;
        my $jsonobject = $jsonparser->decode($jsonstring);

        if( exists $jsonobject->{'Message'} ) {
            # 'Message' => '{"notificationType":"Bounce",...
            $stuff = $jsonparser->decode($jsonobject->{'Message'});

        } else {
            # 'mail' => { 'sourceArn' => '...',... }, 'bounce' => {...},
            $stuff = $jsonobject;
        }
    };
    if( $@ ) {
        # Something wrong in decoding JSON
        warn sprintf(" ***warning: Failed to decode JSON: %s", $@);
        return undef;
    }
    return __PACKAGE__->adapt($stuff);
}

sub adapt {
    # Adapt Amazon SES bounce object for Sisimai::Message format
    # @param        [Hash] argvs     bounce object(JSON) retrieved from Amazon SNS
    # @return       [Hash, Undef]    Bounce data list and message/rfc822 part
    #                                or Undef if it failed to parse or the
    #                                arguments are missing
    # @since v4.20.0
    my $class = shift;
    my $argvs = shift;

    return undef unless ref $argvs eq 'HASH';
    return undef unless keys %$argvs;
    return undef unless exists $argvs->{'notificationType'};

    use Sisimai::RFC5322;
    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my $rfc822head = {};    # (Hash) Check flags for headers in RFC822 part
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $labeltable = {
        'Bounce'    => 'bouncedRecipients',
        'Complaint' => 'complainedRecipients',
    };
    my $v = undef;

    if( $argvs->{'notificationType'} eq 'Bounce' || $argvs->{'notificationType'} eq 'Complaint' ) {
        # { "notificationType":"Bounce", "bounce": { "bounceType":"Permanent",...
        my $o = $argvs->{ lc $argvs->{'notificationType'} };
        my $r = $o->{ $labeltable->{ $argvs->{'notificationType'} } } || [];

        for my $e ( @$r ) {
            # 'bouncedRecipients' => [ { 'emailAddress' => 'bounce@si...' }, ... ]
            # 'complainedRecipients' => [ { 'emailAddress' => 'complaint@si...' }, ... ]
            next unless Sisimai::RFC5322->is_emailaddress($e->{'emailAddress'});

            $v = $dscontents->[-1];
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $recipients++;
            $v->{'recipient'} = $e->{'emailAddress'};

            if( $argvs->{'notificationType'} eq 'Bounce' ) {
                # 'bouncedRecipients => [ {
                #   'emailAddress' => 'bounce@simulator.amazonses.com',
                #   'action' => 'failed',
                #   'status' => '5.1.1',
                #   'diagnosticCode' => 'smtp; 550 5.1.1 user unknown'
                # }, ... ]
                $v->{'action'} = $e->{'action'};
                $v->{'status'} = $e->{'status'};

                if( $e->{'diagnosticCode'} =~ /\A(.+?);[ ]*(.+)\z/ ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'} = uc $1;
                    $v->{'diagnosis'} = $2;

                } else {
                    $v->{'diagnosis'} = $e->{'diagnosticCode'};
                }

                # 'reportingMTA' => 'dsn; a27-23.smtp-out.us-west-2.amazonses.com',
                $v->{'lhost'} = $1 if $o->{'reportingMTA'} =~ /\Adsn;[ ](.+)\z/;

                if( exists $BounceType->{ $o->{'bounceType'} } &&
                    exists $BounceType->{ $o->{'bounceType'} }->{ $o->{'bounceSubType'} } ) {
                    # 'bounce' => {
                    #       'bounceType' => 'Permanent',
                    #       'bounceSubType' => 'General'
                    # },
                    $v->{'reason'} = $BounceType->{ $o->{'bounceType'} }->{ $o->{'bounceSubType'} };
                }
            } else {
                # 'complainedRecipients' => [ {
                #   'emailAddress' => 'complaint@simulator.amazonses.com' }, ... ],
                $v->{'reason'} = 'feedback';
                $v->{'feedbacktype'} = $o->{'complaintFeedbackType'} || '';
            }

            $v->{'date'} =  $o->{'timestamp'} || $argvs->{'mail'}->{'timestamp'};
            $v->{'date'} =~ s/[.]\d+Z\z//;
        }
    } elsif( $argvs->{'notificationType'} eq 'Delivery' ) {
        # { "notificationType":"Delivery", "delivery": { ...
        my $o = $argvs->{'delivery'};
        my $r = $o->{'recipients'} || [];

        for my $e ( @$r ) {
            # 'delivery' => {
            #       'timestamp' => '2016-11-23T12:01:03.512Z',
            #       'processingTimeMillis' => 3982,
            #       'reportingMTA' => 'a27-29.smtp-out.us-west-2.amazonses.com',
            #       'recipients' => [
            #           'success@simulator.amazonses.com'
            #       ],
            #       'smtpResponse' => '250 2.6.0 Message received'
            #   },
            next unless Sisimai::RFC5322->is_emailaddress($e);

            $v = $dscontents->[-1];
            if( $v->{'recipient'} ) {
                # There are multiple recipient addresses in the message body.
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                $v = $dscontents->[-1];
            }
            $recipients++;
            $v->{'recipient'} = $e;
            $v->{'lhost'}     = $o->{'reportingMTA'} || '';
            $v->{'diagnosis'} = $o->{'smtpResponse'} || '';
            $v->{'status'}    = Sisimai::SMTP::Status->find($v->{'diagnosis'});
            $v->{'replycode'} = Sisimai::SMTP::Reply->find($v->{'diagnosis'});
            $v->{'reason'}    = 'delivered';
            $v->{'action'}    = 'deliverable';

            $v->{'date'} =  $o->{'timestamp'} || $argvs->{'mail'}->{'timestamp'};
            $v->{'date'} =~ s/[.]\d+Z\z//;
        }
    } else {
        # The value of "notificationType" is not any of "Bounce", "Complaint",
        # or "Delivery".
        return undef;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'} = __PACKAGE__->smtpagent;
    }

    if( exists $argvs->{'mail'}->{'headers'} ) {
        # "headersTruncated":false,
        # "headers":[ { ...
        for my $e ( @{ $argvs->{'mail'}->{'headers'} } ) {
            # 'headers' => [ { 'name' => 'From', 'value' => 'neko@nyaan.jp' }, ... ],
            next unless $e->{'name'} =~ /\A(?:From|To|Subject|Message-ID|Date)\z/;
            $rfc822head->{ lc $e->{'name'} } = $e->{'value'};
        }
    }

    unless( $rfc822head->{'message-id'} ) {
        # Try to get the value of "Message-Id".
        # 'messageId' => '01010157e48f9b9b-891e9a0e-9c9d-4773-9bfe-608f2ef4756d-000000'
        $rfc822head->{'message-id'} = $argvs->{'mail'}->{'messageId'} if $argvs->{'mail'}->{'messageId'};
    }
    return { 'ds' => $dscontents, 'rfc822' => $rfc822head };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::JSON::AmazonSES - bounce object (JSON) parser class for C<Amazon SES>.

=head1 SYNOPSIS

    use Sisimai::Bite::JSON::AmazonSES;

=head1 DESCRIPTION

Sisimai::Bite::JSON::AmazonSES parses a bounce object as JSON which created by
C<Amazon Simple Email Service>. Methods in the module are called from only 
Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::JSON::AmazonSES->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::JSON::AmazonSES->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head2 C<B<adapt(I<Hash>)>>

C<adapt()> method adapts Amazon SES bounce object (JSON) for Perl hash object
used at Sisimai::Message class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
