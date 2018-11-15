package Sisimai::Message;
use feature ':5.10';
use strict;
use warnings;
use Class::Accessor::Lite;
use Sisimai::RFC5322;
use Sisimai::Address;
use Sisimai::String;
use Sisimai::SMTP::Error;

my $rwaccessors = [
    'from',     # [String] UNIX From line
    'header',   # [Hash]   Header part of an email
    'ds',       # [Array]  Parsed data by Sisimai::Bite::*::*
    'rfc822',   # [Hash]   Header part of the original message
    'catch'     # [?]      The results returned by hook method
];
Class::Accessor::Lite->mk_accessors(@$rwaccessors);

sub new {
    # Constructor of Sisimai::Message
    # @param         [Hash] argvs       Email text data
    # @options argvs [String] data      Entire email message
    # @options argvs [Array]  load      User defined MTA module list
    # @options argvs [Array]  order     The order of MTA modules
    # @options argvs [Array]  field     Email header names to be captured
    # @options argvs [Code]   hook      Reference to callback method
    # @return        [Sisimai::Message] Structured email data or Undef if each
    #                                   value of the arguments are missing
    my $class = shift;
    my $argvs = { @_ };
    my $input = $argvs->{'input'} // 'email';
    my $email = $argvs->{'data'}  // '';
    my $field = $argvs->{'field'} || [];
    my $child = undef;

    if( $input eq 'email' ) {
        # Sisimai::Message::Email
        return undef unless $email;
        $child = 'Sisimai::Message::Email';

    } elsif( $input eq 'json' ) {
        # Sisimai::Message::JSON
        return undef unless ref($email) eq 'HASH';
        $child = 'Sisimai::Message::JSON';

    } else {
        # Unsupported value in "input"
        warn ' ***warning: Unsupported value in "input": '.$input;
        return undef;
    }

    if( ref $field ne 'ARRAY' ) {
        # Unsupported value in "field"
        warn ' ***warning: "field" accepts an array reference only';
        return undef;
    }

    (my $modulepath = $child) =~ s|::|/|g; 
    require $modulepath.'.pm';

    my $methodargv = {
        'data'  => $email,
        'hook'  => $argvs->{'hook'}  // undef,
        'field' => $field,
    };
    my $datasource = undef;
    my $mesgobject = undef;

    for my $e ('load', 'order') {
        # Order of MTA modules
        next unless exists $argvs->{ $e };
        next unless ref $argvs->{ $e } eq 'ARRAY';
        next unless scalar @{ $argvs->{ $e } };
        $methodargv->{ $e } = $argvs->{ $e };
    }

    $datasource = $child->make(%$methodargv);
    return undef unless $datasource->{'ds'};

    $mesgobject = {
        'from'   => $datasource->{'from'},
        'header' => $datasource->{'header'},
        'ds'     => $datasource->{'ds'},
        'rfc822' => $datasource->{'rfc822'},
        'catch'  => $datasource->{'catch'} || undef,
    };
    return bless($mesgobject, $class);
}

sub make {
    # Make data structure (Should be implemeneted at each child class)
    return {
        'from'   => '',     # From_ line
        'header' => {},     # Email header
        'rfc822' => '',     # Original message part
        'ds'     => [],     # Parsed data, Delivery Status
        'catch'  => undef,  # Data parsed by callback method
    }
}

sub load {
    # Load MTA modules which specified at 'order' and 'load' in the argument
    # This method should be implemented at each child class
    # @since v4.20.0
    return [];
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Message - Convert bounce email text to data structure.

=head1 SYNOPSIS

    use Sisimai::Mail;
    use Sisimai::Message;

    my $mailbox = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mailbox->read ) {
        my $p = Sisimai::Message->new('data' => $r);
    }

    my $notmail = '/home/neko/Maildir/cur/22222';   # is not a bounce email
    my $mailobj = Sisimai::Mail->new($notmail);
    while( my $r = $mailobj->read ) {
        my $p = Sisimai::Message->new('data' => $r);  # $p is "undef"
    }

=head1 DESCRIPTION

Sisimai::Message convert bounce email text to data structure. It resolve email
text into an UNIX From line, the header part of the mail, delivery status, and
RFC822 header part. When the email given as a argument of "new" method is not a
bounce email, the method returns "undef".

=head1 CLASS METHODS

=head2 C<B<new(I<Hash reference>)>>

C<new()> is a constructor of Sisimai::Message

    my $mailtxt = 'Entire email text';
    my $message = Sisimai::Message->new('data' => $mailtxt);

If you have implemented a custom MTA module and use it, set the value of "load"
in the argument of this method as an array reference like following code:

    my $message = Sisimai::Message->new(
                        'data' => $mailtxt,
                        'load' => ['Your::Custom::MTA::Module']
                  );

Beginning from v4.19.0, `hook` argument is available to callback user defined
method like the following codes:

    my $cmethod = sub {
        my $argv = shift;
        my $data = {
            'queue-id' => '',
            'x-mailer' => '',
            'precedence' => '',
        };

        # Header part of the bounced mail
        for my $e ( 'x-mailer', 'precedence' ) {
            next unless exists $argv->{'headers'}->{ $e };
            $data->{ $e } = $argv->{'headers'}->{ $e };
        }

        # Message body of the bounced email
        if( $argv->{'message'} =~ /^X-Postfix-Queue-ID:\s*(.+)$/m ) {
            $data->{'queue-id'} = $1;
        }

        return $data;
    };

    my $message = Sisimai::Message->new(
        'data' => $mailtxt, 
        'hook' => $cmethod,
        'field' => ['X-Mailer', 'Precedence']
    );
    print $message->catch->{'x-mailer'};    # Apple Mail (2.1283)
    print $message->catch->{'queue-id'};    # 2DAEB222022E
    print $message->catch->{'precedence'};  # bulk

=head1 INSTANCE METHODS

=head2 C<B<(from)>>

C<from()> returns the UNIX From line of the email.

    print $message->from;

=head2 C<B<header()>>

C<header()> returns the header part of the email.

    print $message->header->{'subject'};    # Returned mail: see transcript for details

=head2 C<B<ds()>>

C<ds()> returns an array reference which include contents of delivery status.

    for my $e ( @{ $message->ds } ) {
        print $e->{'status'};   # 5.1.1
        print $e->{'recipient'};# neko@example.jp
    }

=head2 C<B<rfc822()>>

C<rfc822()> returns a hash reference which include the header part of the original
message.

    print $message->rfc822->{'from'};   # cat@example.com
    print $message->rfc822->{'to'};     # neko@example.jp

=head2 C<B<catch()>>

C<catch()> returns any data generated by user-defined method passed at the `hook`
argument of new() constructor.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
