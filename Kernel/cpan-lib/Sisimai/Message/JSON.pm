package Sisimai::Message::JSON;
use parent 'Sisimai::Message';
use feature ':5.10';
use strict;
use warnings;
use Sisimai::Order::JSON;
use JSON;

my $ToBeLoaded = [];
my $TryOnFirst = [];
my $DefaultSet = Sisimai::Order::JSON->default;
my $ObjectKeys = Sisimai::Order::JSON->by('keyname');

sub make {
    # Make data structure from decoded JSON object
    # @param         [Hash] argvs   Bounce object
    # @options argvs [Hash]  data   Decoded JSON
    # @options argvs [Array] load   User defined MTA module list
    # @options argvs [Array] order  The order of MTA modules
    # @options argvs [Code]  hook   Reference to callback method
    # @return        [Hash]         Resolved data structure
    my $class = shift;
    my $argvs = { @_ };

    my $methodargv = {};
    my $hookmethod = $argvs->{'hook'} || undef;
    my $bouncedata = undef;
    my $processing = {
        'from'   => '',     # From_ line
        'header' => {},     # Email header
        'rfc822' => '',     # Original message part
        'ds'     => [],     # Parsed data, Delivery Status
        'catch'  => undef,  # Data parsed by callback method
    };

    $methodargv = {
        'load'  => $argvs->{'load'}  || [],
        'order' => $argvs->{'order'} || [],
    };
    $ToBeLoaded = __PACKAGE__->load(%$methodargv);
    $TryOnFirst = __PACKAGE__->makeorder($argvs->{'data'});

    # Rewrite message body for detecting the bounce reason
    $methodargv = { 'hook' => $hookmethod, 'json' => $argvs->{'data'} };
    $bouncedata = __PACKAGE__->parse(%$methodargv);

    return undef unless $bouncedata;
    return undef unless keys %$bouncedata;

    $processing->{'ds'}     = $bouncedata->{'ds'};
    $processing->{'catch'}  = $bouncedata->{'catch'};
    $processing->{'rfc822'} = $bouncedata->{'rfc822'} || {};
    return $processing;
}

sub load {
    # Load MTA modules which specified at 'order' and 'load' in the argument
    # @param         [Hash] argvs       Module information to be loaded
    # @options argvs [Array]  load      User defined MTA module list
    # @options argvs [Array]  order     The order of MTA modules
    # @return        [Array]            Module list
    # @since v4.20.0
    my $class = shift;
    my $argvs = { @_ };

    my @modulelist = ();
    my $tobeloaded = [];
    my $modulepath = '';

    for my $e ('load', 'order') {
        # The order of MTA modules specified by user
        next unless exists $argvs->{ $e };
        next unless ref $argvs->{ $e } eq 'ARRAY';
        next unless scalar @{ $argvs->{ $e } };

        push @modulelist, @{ $argvs->{'order'} } if $e eq 'order';
        next unless $e eq 'load';

        # Load user defined MTA module
        for my $v ( @{ $argvs->{'load'} } ) {
            # Load user defined MTA module
            eval { 
                ($modulepath = $v) =~ s|::|/|g; 
                require $modulepath.'.pm';
            };
            next if $@;
            push @$tobeloaded, $v;
        }
    }

    for my $e ( @modulelist ) {
        # Append the custom order of MTA modules
        next if grep { $e eq $_ } @$tobeloaded;
        push @$tobeloaded, $e;
    }
    return $tobeloaded;
}

sub makeorder {
    # Check the decoded JSON strucutre for detecting MTA modules and returns the
    # order of modules to be called.
    # @param         [Hash]  argvs  Decoded JSON object
    # @return        [Array]        Order of MTA modules
    my $class = shift;
    my $argvs = shift || return [];
    my $order = [];

    return [] unless ref $argvs eq 'HASH';
    return [] unless scalar keys %$argvs;

    # Seek some key names from given argument
    for my $e ( keys %$ObjectKeys ) {
        # Get MTA module list matched with a specified key
        next unless exists $argvs->{ $e };

        # Matched and push it into the order list
        push @$order, @{ $ObjectKeys->{ $e } };
        last;
    }
    return $order;
}

sub parse {
    # Parse bounce object with each MTA module
    # @param               [Hash] argvs    Processing message entity.
    # @param options argvs [Hash] json     Decoded bounce object
    # @param options argvs [Code] hook     Hook method to be called
    # @return              [Hash]          Parsed and structured bounce mails
    my $class = shift;
    my $argvs = { @_ };

    my $bouncedata = $argvs->{'json'} || {};
    my $hookmethod = $argvs->{'hook'} || undef;
    my $havecaught = undef;
    my $haveloaded = {};
    my $hasadapted = undef;
    my $modulepath = undef;

    if( ref $hookmethod eq 'CODE' ) {
        # Call hook method
        my $p = {
            'datasrc' => 'json',
            'headers' => undef,
            'message' => undef,
            'bounces' => $argvs->{'json'},
        };
        eval { $havecaught = $hookmethod->($p) };
        warn sprintf(" ***warning: Something is wrong in hook method:%s", $@) if $@;
    }

    ADAPTOR: while(1) {
        # 1. User-Defined Module
        # 2. MTA Module Candidates to be tried on first
        # 3. Sisimai::Bite::JSON::*
        #
        USER_DEFINED: for my $r ( @$ToBeLoaded ) {
            # Call user defined MTA modules
            next if exists $haveloaded->{ $r };
            eval {
                ($modulepath = $r) =~ s|::|/|g; 
                require $modulepath.'.pm';
            };
            if( $@ ) {
                warn sprintf(" ***warning: Failed to load %s: %s", $r, $@);
                next;
            }
            $hasadapted = $r->adapt($bouncedata);
            $haveloaded->{ $r } = 1;
            last(ADAPTOR) if $hasadapted;
        }

        TRY_ON_FIRST: while( my $r = shift @$TryOnFirst ) {
            # Try MTA module candidates which are detected from object key names
            next if exists $haveloaded->{ $r };
            ($modulepath = $r) =~ s|::|/|g; 
            require $modulepath.'.pm';
            next if $@;

            $hasadapted = $r->adapt($bouncedata);
            $haveloaded->{ $r } = 1;
            last(ADAPTOR) if $hasadapted;
        }

        DEFAULT_LIST: for my $r ( @$DefaultSet ) {
            # Default order of MTA modules
            next if exists $haveloaded->{ $r };
            ($modulepath = $r) =~ s|::|/|g; 
            require $modulepath.'.pm';
            next if $@;

            $hasadapted = $r->adapt($bouncedata);
            $haveloaded->{ $r } = 1;
            last(ADAPTOR) if $hasadapted;
        }
        last;   # as of now, we have no sample json data for coding this block

    } # End of while(ADAPTOR)

    $hasadapted->{'catch'} = $havecaught if $hasadapted;
    return $hasadapted;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Message::JSON - Convert bounce object (decoded JSON) to data structure.

=head1 SYNOPSIS

    use JSON;
    use Sisimai::Message;

    my $jsonparser = JSON->new;
    my $jsonobject = $jsonparser->decode($jsonstring);
    my $messageobj = Sisimai::Message->new('data' => $jsonobject, 'input' => 'json');

=head1 DESCRIPTION

Sisimai::Message::JSON convert bounce object (decode JSON) to data structure.
When the email given as a argument of "new()" method is not a decoded JSON, the
method returns "undef".

=head1 CLASS METHODS

=head2 C<B<new(I<Hash reference>)>>

C<new()> is a constructor of Sisimai::Message

    my $jsonparser = JSON->new;
    my $jsonstring = '{"neko":2, "nyaan": "meow", ...}';
    my $jsonobject = $jsonparser->decode($jsonstring);
    my $messageobj = Sisimai::Message->new('data' => $jsonobject, 'input' => 'json');

If you have implemented a custom MTA module and use it, set the value of "load"
in the argument of this method as an array reference like following code:

    my $messageobj = Sisimai::Message->new(
                        'data'  => $jsonobject,
                        'load'  => ['Your::Custom::MTA::Module']
                        'input' => 'json',
                  );

Beginning from v4.19.0, `hook` argument is available to callback user defined
method like the following codes:

    my $callbackto = sub {
        my $argv = shift;
        my $data = { 'feedback-id' => '', 'account-id' => '' };
        my $mesg = $argv->{'message'} || {};

        if( exists $mesg->{'feedbackId'} ) {
            $data->{'feedback-id'} = $mesg->{'feedback-Id'};
        }

        if( exists $mesg->{'sendingAccountId'} ) {
            $data->{'account-id'} = $mesg->{'sendingAccountId'};
        }
        return $data;
    };
    my $messageobj = Sisimai::Message->new(
                        'data'  => $jsonobject,
                        'hook'  => $callbackto,
                        'input' => 'json' );
    print $message->catch->{'feedback-id'};    # 01010157e48fa03f-c7e948fe-...

=head1 INSTANCE METHODS

=head2 C<B<(from)>>

C<from()> returns empty string

    print $message->from;   # ''

=head2 C<B<header()>>

C<header()> returns empty Hash

    print $message->header; # {}

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

