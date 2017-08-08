package Sisimai::Address;
use feature ':5.10';
use strict;
use warnings;
use Class::Accessor::Lite;
use Sisimai::RFC5322;

my $roaccessors = [
    'address',  # [String] Email address
    'user',     # [String] local part of the email address
    'host',     # [String] domain part of the email address
    'verp',     # [String] VERP
    'alias',    # [String] alias of the email address
];
Class::Accessor::Lite->mk_ro_accessors(@$roaccessors);

sub undisclosed { 
    # Return pseudo recipient or sender address
    # @param    [String] atype  Address type: 'r' or 's'
    # @return   [String, Undef] Pseudo recipient address or sender address or
    #                           Undef when the $argv1 is neither 'r' nor 's'
    my $class = shift;
    my $atype = shift || return undef;
    my $local = '';

    return undef unless $atype =~ m/\A(?:r|s)\z/;
    $local = $atype eq 'r' ? 'recipient' : 'sender';
    return sprintf("undisclosed-%s-in-headers%slibsisimai.org.invalid", $local, '@');
}

sub new {
    # Constructor of Sisimai::Address
    # @param <str>  [String] email            Email address
    # @return       [Sisimai::Address, Undef] Object or Undef when the email 
    #                                         address was not valid.
    my $class = shift;
    my $email = shift // return undef;
    my $thing = { 'address' => '', 'user' => '', 'host' => '', 'verp' => '', 'alias' => '' };

    if( $email =~ m/\A([^@]+)[@]([^@]+)\z/ ) {
        # Get the local part and the domain part from the email address
        my $lpart = $1;
        my $dpart = $2;

        # Remove MIME-Encoded comment part
        $lpart =~ s/\A=[?].+[?]b[?].+[?]=//;
        $lpart =~ y/`'"<>//d unless $lpart =~ m/\A["].+["]\z/;

        my $alias = 0;
        my $addr0 = sprintf("%s@%s", $lpart, $dpart);
        my $addr1 = __PACKAGE__->expand_verp($addr0);

        unless( length $addr1 ) {
            $addr1 = __PACKAGE__->expand_alias($addr0);
            $alias = 1 if $addr1;
        }

        if( length $addr1 ) {
            # The email address is VERP or alias
            my @addrs = split('@', $addr1);
            if( $alias ) {
                # The email address is an alias
                $thing->{'alias'} = $addr0;

            } else {
                # The email address is a VERP
                $thing->{'verp'}  = $addr0;
            }
            $thing->{'user'} = $addrs[0];
            $thing->{'host'} = $addrs[1];

        } else {
            # The email address is neither VERP nor alias.
            $thing->{'user'} = $lpart;
            $thing->{'host'} = $dpart;
        }
        $thing->{'address'} = sprintf("%s@%s", $thing->{'user'}, $thing->{'host'});

        return bless($thing, __PACKAGE__);

    } else {
        # The argument does not include "@"
        return undef unless Sisimai::RFC5322->is_mailerdaemon($email);
        if( $email =~ /[<]([^ ]+)[>]/ ) {
            # Mail Delivery Subsystem <MAILER-DAEMON>
            $thing->{'user'} = $1;
            $thing->{'address'} = $1;

        } else {
            return undef if $email =~ /[ ]/;

            # The argument does not include " "
            $thing->{'user'}    = $email;
            $thing->{'address'} = $email;
        }

        return bless($thing, __PACKAGE__);
    }
}

sub parse {
    # Email address parser
    # @param    [Array] argvs   List of strings including email address
    # @return   [Array, Undef]  Email address list or Undef when there is no 
    #                           email address in the argument
    # @example  Parse email address
    #   parse(['Neko <neko@example.cat>'])  #=> ['neko@example.cat']
    my $class = shift;
    my $argvs = shift // return undef;
    my $addrs = [];
    return undef unless ref($argvs) eq 'ARRAY';

    PARSE_ARRAY: for my $e ( @$argvs ) {
        # Parse each element in the array
        #   1. The element must include '@'.
        #   2. The element must not include character except from 0x20 to 0x7e.
        next unless defined $e;
        unless( $e =~ m/[@]/ ) {
            # Allow if the argument is MAILER-DAEMON
            next unless Sisimai::RFC5322->is_mailerdaemon($e);
        }
        next if $e =~ m/[^\x20-\x7e]/;

        my $v = __PACKAGE__->s3s4($e);
        if( length $v ) {
            # The element includes a valid email address
            push @$addrs, $v;
        }
    }
    return undef unless scalar @$addrs;
    return $addrs;
}

sub s3s4 {
    # Runs like ruleset 3,4 of sendmail.cf
    # @param    [String] input  Text including an email address
    # @return   [String]        Email address without comment, brackets
    # @example  Parse email address
    #   s3s4( '<neko@example.cat>' ) #=> 'neko@example.cat'
    my $class = shift;
    my $input = shift // return undef;

    return $input if ref $input;
    unless( $input =~ /[ ]/ ) {
        # There is no space characters
        # no space character between " and < .
        $input =~ s/(.)"</$1" </;       # "=?ISO-2022-JP?B?....?="<user@example.jp>, 
        $input =~ s/(.)[?]=</$1?= </;   # =?ISO-2022-JP?B?....?=<user@example.jp>

        # comment-part<localpart@domainpart>
        $input =~ s/[<]/ </ unless $input =~ m/\A[<]/;
        $input =~ s/[>]/> / unless $input =~ m/[>]\z/;
    }

    my $canon = '';
    my @addrs = ();
    my @token = split(' ', $input);

    for my $e ( @token ) {
        # Convert character entity; "&lt;" -> ">", "&gt;" -> "<".
        $e =~ s/&lt;/</g; 
        $e =~ s/&gt;/>/g;
        $e =~ s/,\z//g;
    }

    if( scalar(@token) == 1 ) {
        push @addrs, $token[0];

    } else {
        for my $e ( @token ) {
            chomp $e;
            unless( $e =~ m/\A[<]?.+[@][-.0-9A-Za-z]+[.]?[A-Za-z]{2,}[>]?\z/ ) {
                # Check whether the element is mailer-daemon or not
                next unless Sisimai::RFC5322->is_mailerdaemon($e);
            }
            push @addrs, $e;
        }
    }

    if( scalar(@addrs) > 1 ) {
        # Get the first element which is <...> format string from @addrs array.
        $canon = (grep { $_ =~ m/\A[<].+[>]\z/ } @addrs)[0];
        $canon = $addrs[0] unless $canon;

    } else {
        $canon = shift @addrs;
    }

    return '' if( ! defined $canon || $canon eq '' );
    $canon =~ y/<>[]():;//d;    # Remove brackets, colons

    if( $canon =~ m/\A["].+["][@].+\z/ ) {
        # "localpart..."@example.jp
        $canon =~ y/{}'`//d;
    } else {
        # Remove brackets, quotations
        $canon =~ y/{}'"`//d;
    }
    return $canon;
}

sub expand_verp {
    # Expand VERP: Get the original recipient address from VERP
    # @param    [String] email  VERP Address
    # @return   [String]        Email address
    # @example  Expand VERP address
    #   expand_verp('bounce+neko=example.jp@example.org') #=> 'neko@example.jp'
    my $class = shift;
    my $email = shift // return undef;
    my $local = (split('@', $email, 2))[0];
    my $verp0 = '';

    if( $local =~ m/\A[-_\w]+?[+](\w[-._\w]+\w)[=](\w[-.\w]+\w)\z/ ) {
        # bounce+neko=example.jp@example.org => neko@example.jp
        $verp0 = $1.'@'.$2;
        return $verp0 if Sisimai::RFC5322->is_emailaddress($verp0);

    } else {
        return '';
    }
}

sub expand_alias {
    # Expand alias: remove from '+' to '@'
    # @param    [String] email  Email alias string
    # @return   [String]        Expanded email address
    # @example  Expand alias
    #   expand_alias('neko+straycat@example.jp') #=> 'neko@example.jp'
    my $class = shift;
    my $email = shift // return undef;
    my $alias = '';

    return '' unless Sisimai::RFC5322->is_emailaddress($email);

    my @local = split('@', $email);
    if( $local[0] =~ m/\A([-_\w]+?)[+].+\z/ ) {
        # neko+straycat@example.jp => neko@example.jp
        $alias = sprintf("%s@%s", $1, $local[1]);
    }
    return $alias;
}

sub TO_JSON {
    # Instance method for JSON::encode()
    # @return   [String] The value of "address" accessor
    my $self = shift;
    return $self->address;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Address - Email address object

=head1 SYNOPSIS

    use Sisimai::Address;

    my $v = Sisimai::Address->new('neko@example.jp');
    print $v->user;     # neko
    print $v->host;     # example.jp
    print $v->address;  # neko@example.jp

=head1 DESCRIPTION

Sisimai::Address provide methods for dealing email address.

=head1 CLASS METHODS

=head2 C<B<new(I<email address>)>>

C<new()> is a constructor of Sisimai::Address

    my $v = Sisimai::Address->new('neko@example.jp');

=head2 C<B<parse(I<Array-Ref>)>>

C<parse()> is a parser for getting only email address from text including email
addresses.

    my $r = [
        'Stray cat <cat@example.jp>',
        'nyaa@example.jp (White Cat)',
    ];
    my $v = Sisimai::Address->parse($r);

    warn Dumper $v;
    $VAR1 = [
                'cat@example.jp',
                'nyaa@example.jp'
            ];

=head2 C<B<s3s4(I<email address>)>>

C<s3s4()> works Ruleset 3, and 4 of sendmail.cf.

    my $r = [
        'Stray cat <cat@example.jp>',
        'nyaa@example.jp (White Cat)',
    ];

    for my $e ( @$r ) {
        print Sisimai::Address->s3s4($e);   # cat@example.jp
                                            # nyaa@example.jp
    }

=head2 C<B<expand_verp(I<email address>)>>

C<expand_verp()> gets the original email address from VERP

    my $r = 'nyaa+neko=example.jp@example.org';
    print Sisimai::Address->expand_verp($r); # neko@example.jp

=head2 C<B<expand_alias(I<email address>)>>

C<expand_alias()> gets the original email address from alias

    my $r = 'nyaa+neko@example.jp';
    print Sisimai::Address->expand_alias($r); # nyaa@example.jp

=head1 INSTANCE METHODS

=head2 C<B<user()>>

C<user()> returns a local part of the email address.

    my $v = Sisimai::Address->new('neko@example.jp');
    print $v->user;     # neko

=head2 C<B<host()>>

C<host()> returns a domain part of the email address.

    my $v = Sisimai::Address->new('neko@example.jp');
    print $v->host;     # example.jp

=head2 C<B<address()>>

C<address()> returns the email address

    my $v = Sisimai::Address->new('neko@example.jp');
    print $v->address;     # neko@example.jp

=head2 C<B<verp()>>

C<verp()> returns the VERP email address

    my $v = Sisimai::Address->new('neko+nyaa=example.jp@example.org');
    print $v->verp;     # neko+nyaa=example.jp@example.org
    print $v->address;  # nyaa@example.jp

=head2 C<B<alias()>>

C<alias()> returns the email address (alias)

    my $v = Sisimai::Address->new('neko+nyaa@example.jp');
    print $v->alias;    # neko+nyaa@example.jp
    print $v->address;  # neko@example.jp

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2015 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
