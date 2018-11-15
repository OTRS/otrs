package Sisimai::Address;
use feature ':5.10';
use strict;
use warnings;
use Class::Accessor::Lite;
use Sisimai::RFC5322;

my $Indicators = {
    'email-address' => (1 << 0),    # <neko@example.org>
    'quoted-string' => (1 << 1),    # "Neko, Nyaan"
    'comment-block' => (1 << 2),    # (neko)
};
my $ValidEmail = qr{(?>
    (?:([^\s]+|["].+?["]))          # local part
    [@]
    (?:([^@\s]+|[0-9A-Za-z:\.]+))   # domain part
    )
}x;
my $undisclosed = 'libsisimai.org.invalid';
my $roaccessors = [
    'address',  # [String] Email address
    'user',     # [String] local part of the email address
    'host',     # [String] domain part of the email address
    'verp',     # [String] VERP
    'alias',    # [String] alias of the email address
];
my $rwaccessors = [
    'name',     # [String] Display name
    'comment',  # [String] (Comment)
];
Class::Accessor::Lite->mk_ro_accessors(@$roaccessors);
Class::Accessor::Lite->mk_accessors(@$rwaccessors);

sub undisclosed { 
    # Return pseudo recipient or sender address
    # @param    [String] atype  Address type: 'r' or 's'
    # @return   [String, Undef] Pseudo recipient address or sender address or
    #                           Undef when the $argv1 is neither 'r' nor 's'
    my $class = shift;
    my $atype = shift || return undef;

    return undef unless $atype =~ /\A(?:r|s)\z/;
    my $local = $atype eq 'r' ? 'recipient' : 'sender';
    return sprintf("undisclosed-%s-in-headers%s%s", $local, '@', $undisclosed);
}

sub new {
    # Old constructor of Sisimai::Address, wrapper method of make()
    # @param        [String] email            Email address
    # @return       [Sisimai::Address, Undef] Object or Undef when the email 
    #                                         address was not valid.
    my $class = shift;
    my $email = shift // return undef;
    my $addrs = __PACKAGE__->find($email);

    return undef unless $addrs;
    return undef unless scalar @$addrs;
    return __PACKAGE__->make($addrs->[0]);
}

sub make {
    # New constructor of Sisimai::Address
    # @param    [Hash] argvs        Email address, name, and other elements
    # @return   [Sisimai::Address]  Object or Undef when the email address was
    #                               not valid.
    # @since    v4.22.1
    my $class = shift;
    my $argvs = shift // return undef;
    my $thing = {
        'address' => '',    # Entire email address
        'user'    => '',    # Local part
        'host'    => '',    # Domain part
        'verp'    => '',    # VERP
        'alias'   => '',    # Alias
        'comment' => '',    # Comment
        'name'    => '',    # Display name
    };

    return undef unless ref $argvs eq 'HASH';
    return undef unless exists $argvs->{'address'};
    return undef unless $argvs->{'address'};

    if( $argvs->{'address'} =~ /\A([^\s]+)[@]([^@]+)\z/ ||
        $argvs->{'address'} =~ /\A(["].+?["])[@]([^@]+)\z/ ) {
        # Get the local part and the domain part from the email address
        my $lpart = $1;
        my $dpart = $2;
        my $email = __PACKAGE__->expand_verp($argvs->{'address'});
        my $alias = 0;

        unless( $email ) {
            # Is not VERP address, try to expand the address as an alias
            $email = __PACKAGE__->expand_alias($argvs->{'address'});
            $alias = 1 if $email;
        }

        if( $email =~ /\A.+[@].+?\z/ ) {
            # The address is a VERP or an alias
            if( $alias ) {
                # The address is an alias: neko+nyaan@example.jp
                $thing->{'alias'} = $argvs->{'address'};

            } else {
                # The address is a VERP: b+neko=example.jp@example.org
                $thing->{'verp'}  = $argvs->{'address'};
            }
        }
        $thing->{'user'} = $lpart;
        $thing->{'host'} = $dpart;
        $thing->{'address'} = $lpart.'@'.$dpart;

    } else {
        # The argument does not include "@"
        return undef unless Sisimai::RFC5322->is_mailerdaemon($argvs->{'address'});
        return undef if rindex($argvs->{'address'}, ' ') > -1;

        # The argument does not include " "
        $thing->{'user'}    = $argvs->{'address'};
        $thing->{'address'} = $argvs->{'address'};
    }

    $thing->{'name'}    = $argvs->{'name'}    || '';
    $thing->{'comment'} = $argvs->{'comment'} || '';
    return bless($thing, __PACKAGE__);
}

sub find {
    # Email address parser with a name and a comment
    # @param    [String] argv1  String including email address
    # @param    [Boolean] addrs 0 = Returns list including all the elements
    #                           1 = Returns list including email addresses only
    # @return   [Array, Undef]  Email address list or Undef when there is no 
    #                           email address in the argument
    # @since    v4.22.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $addrs = shift // undef;

    $argv1 =~ s/[\r\n]//g;  # Remove new line codes

    my $emailtable = { 'address' => '', 'name' => '', 'comment' => '' };
    my $addrtables = [];
    my $readbuffer = [];
    my $readcursor = 0;

    my $v = $emailtable;   # temporary buffer
    my $p = '';            # current position

    for my $e ( split('', $argv1) ) {
        # Check each characters
        if( grep { $e eq $_ } ('<', '>', '(', ')', '"', ',') ) {
            # The character is a delimiter character
            if( $e eq ',' ) {
                # Separator of email addresses or not
                if(  index($v->{'address'}, '<') == 0 &&
                    rindex($v->{'address'}, '@') > -1 &&
                    substr($v->{'address'}, -1, 1) eq '>' ) {
                    # An email address has already been picked
                    if( $readcursor & $Indicators->{'comment-block'} ) {
                        # The cursor is in the comment block (Neko, Nyaan)
                        $v->{'comment'} .= $e;

                    } elsif( $readcursor & $Indicators->{'quoted-string'} ) {
                        # "Neko, Nyaan"
                        $v->{'name'} .= $e;

                    } else {
                        # The cursor is not in neither the quoted-string nor the comment block
                        $readcursor = 0;    # reset cursor position
                        push @$readbuffer, $v;
                        $v = { 'address' => '', 'name' => '', 'comment' => '' };
                        $p = '';
                    }
                } else {
                    # "Neko, Nyaan" <neko@nyaan.example.org> OR <"neko,nyaan"@example.org>
                    $p ? ($v->{ $p } .= $e) : ($v->{'name'} .= $e);
                }
                next;
            } # End of if(',')

            if( $e eq '<' ) {
                # <: The beginning of an email address or not
                if( $v->{'address'} ) {
                    $p ? ($v->{ $p } .= $e) : ($v->{'name'} .= $e);

                } else {
                    # <neko@nyaan.example.org>
                    $readcursor |= $Indicators->{'email-address'};
                    $v->{'address'} .= $e;
                    $p = 'address';
                }
                next;
            } # End of if('<')

            if( $e eq '>' ) {
                # >: The end of an email address or not
                if( $readcursor & $Indicators->{'email-address'} ) {
                    # <neko@example.org>
                    $readcursor &= ~$Indicators->{'email-address'};
                    $v->{'address'} .= $e;
                    $p = '';

                } else {
                    # a comment block or a display name
                    $p ? ($v->{'comment'} .= $e) : ($v->{'name'} .= $e);
                }
                next;
            } # End of if('>')

            if( $e eq '(' ) {
                # The beginning of a comment block or not
                if( $readcursor & $Indicators->{'email-address'} ) {
                    # <"neko(nyaan)"@example.org> or <neko(nyaan)@example.org>
                    if( rindex($v->{'address'}, '"') > -1 ) {
                        # Quoted local part: <"neko(nyaan)"@example.org>
                        $v->{'address'} .= $e;

                    } else {
                        # Comment: <neko(nyaan)@example.org>
                        $readcursor |= $Indicators->{'comment-block'};
                        $v->{'comment'} .= ' ' if substr($v->{'comment'}, -1, 1) eq ')';
                        $v->{'comment'} .= $e;
                        $p = 'comment';
                    }
                } elsif( $readcursor & $Indicators->{'comment-block'} ) {
                    # Comment at the outside of an email address (...(...)
                    $v->{'comment'} .= ' ' if substr($v->{'comment'}, -1, 1) eq ')';
                    $v->{'comment'} .= $e;

                } elsif( $readcursor & $Indicators->{'quoted-string'} ) {
                    # "Neko, Nyaan(cat)", Deal as a display name
                    $v->{'name'} .= $e;

                } else {
                    # The beginning of a comment block
                    $readcursor |= $Indicators->{'comment-block'};
                    $v->{'comment'} .= ' ' if substr($v->{'comment'}, -1, 1) eq ')';
                    $v->{'comment'} .= $e;
                    $p = 'comment';
                }
                next;
            } # End of if('(')

            if( $e eq ')' ) {
                # The end of a comment block or not
                if( $readcursor & $Indicators->{'email-address'} ) {
                    # <"neko(nyaan)"@example.org> OR <neko(nyaan)@example.org>
                    if( rindex($v->{'address'}, '"') > -1 ) {
                        # Quoted string in the local part: <"neko(nyaan)"@example.org>
                        $v->{'address'} .= $e;

                    } else {
                        # Comment: <neko(nyaan)@example.org>
                        $readcursor &= ~$Indicators->{'comment-block'};
                        $v->{'comment'} .= $e;
                        $p = 'address';
                    }
                } elsif( $readcursor & $Indicators->{'comment-block'} ) {
                    # Comment at the outside of an email address (...(...)
                    $readcursor &= ~$Indicators->{'comment-block'};
                    $v->{'comment'} .= $e;
                    $p = '';

                } else {
                    # Deal as a display name
                    $readcursor &= ~$Indicators->{'comment-block'};
                    $v->{'name'} .= $e;
                    $p = '';
                }
                next;
            } # End of if(')')

            if( $e eq '"' ) {
                # The beginning or the end of a quoted-string
                if( $p ) {
                    # email-address or comment-block
                    $v->{ $p } .= $e;

                } else {
                    # Display name
                    $v->{'name'} .= $e;
                    if( $readcursor & $Indicators->{'quoted-string'} ) {
                        # "Neko, Nyaan"
                        unless( $v->{'name'} =~ /\x5c["]\z/ ) {
                            # "Neko, Nyaan \"...
                            $readcursor &= ~$Indicators->{'quoted-string'};
                            $p = '';
                        }
                    }
                }
                next;
            } # End of if('"')
        } else {
            # The character is not a delimiter
            $p ? ($v->{ $p } .= $e) : ($v->{'name'} .= $e);
            next;
        }
    }

    if( $v->{'address'} ) {
        # Push the latest values
        push @$readbuffer, $v;

    } else {
        # No email address like <neko@example.org> in the argument
        if( $v->{'name'} =~ $ValidEmail ) {
            # String like an email address will be set to the value of "address"
             $v->{'address'} = $1.'@'.$2;

        } elsif( Sisimai::RFC5322->is_mailerdaemon($v->{'name'}) ) {
            # Allow if the argument is MAILER-DAEMON
            $v->{'address'} = $v->{'name'};
        }

        if( $v->{'address'} ) {
            # Remove the comment from the address
            if( $v->{'address'} =~ /(.*)([(].+[)])(.*)/ ) {
                # (nyaan)nekochan@example.org, nekochan(nyaan)cat@example.org or
                # nekochan(nyaan)@example.org
                $v->{'address'} = $1.$3;
                $v->{'comment'} = $2;
            }
            push @$readbuffer, $v;
        }
    }

    while( my $e = shift @$readbuffer ) {
        # The element must not include any character except from 0x20 to 0x7e.
        next if $e->{'address'} =~ /[^\x20-\x7e]/;

        unless( $e->{'address'} =~ /\A.+[@].+\z/ ) {
            # Allow if the argument is MAILER-DAEMON
            next unless Sisimai::RFC5322->is_mailerdaemon($e->{'address'});
        }

        # Remove angle brackets, other brackets, and quotations: []<>{}'`
        # except a domain part is an IP address like neko@[192.0.2.222]
        $e->{'address'} =~ s/\A[\[<{('`]//;
        $e->{'address'} =~ s/['`>})]\z//;
        $e->{'address'} =~ s/\]\z// unless $e->{'address'} =~ /[@]\[[0-9A-Za-z:\.]+\]\z/;

        unless( $e->{'address'} =~ /\A["].+["][@]/ ) {
            # Remove double-quotations
            substr($e->{'address'},  0, 1, '') if substr($e->{'address'},  0, 1) eq '"';
            substr($e->{'address'}, -1, 1, '') if substr($e->{'address'}, -1, 1) eq '"';
        }

        if( $addrs ) {
            # Almost compatible with parse() method, returns email address only
            delete $e->{'name'};
            delete $e->{'comment'};

        } else {
            # Remove double-quotations, trailing spaces.
            for my $f ('name', 'comment') {
                # Remove traliing spaces
                $e->{ $f } =~ s/\A\s*//;
                $e->{ $f } =~ s/\s*\z//;
            }
            $e->{'comment'} = ''   unless $e->{'comment'} =~ /\A[(].+[)]\z/;
            $e->{'name'} =~ y/ //s    unless $e->{'name'} =~ /\A["].+["]\z/;
            $e->{'name'} =~ s/\A["]// unless $e->{'name'} =~ /\A["].+["][@]/;
            substr($e->{'name'}, -1, 1, '') if substr($e->{'name'}, -1, 1) eq '"';
        }
        push @$addrtables, $e;
    }

    return undef unless scalar @$addrtables;
    return $addrtables;
}

sub s3s4 {
    # Runs like ruleset 3,4 of sendmail.cf
    # @param    [String] input  Text including an email address
    # @return   [String]        Email address without comment, brackets
    my $class = shift;
    my $input = shift // return undef;
    return $input if ref $input;

    my $addrs = __PACKAGE__->find($input, 1) || [];
    return $input unless scalar @$addrs;
    return $addrs->[0]->{'address'};
}

sub expand_verp {
    # Expand VERP: Get the original recipient address from VERP
    # @param    [String] email  VERP Address
    # @return   [String]        Email address
    my $class = shift;
    my $email = shift // return undef;
    my $local = (split('@', $email, 2))[0];

    if( $local =~ /\A[-_\w]+?[+](\w[-._\w]+\w)[=](\w[-.\w]+\w)\z/ ) {
        # bounce+neko=example.org@example.org => neko@example.org
        my $verp0 = $1.'@'.$2;
        return $verp0 if Sisimai::RFC5322->is_emailaddress($verp0);
    } else {
        return '';
    }
}

sub expand_alias {
    # Expand alias: remove from '+' to '@'
    # @param    [String] email  Email alias string
    # @return   [String]        Expanded email address
    my $class = shift;
    my $email = shift // return undef;
    return '' unless Sisimai::RFC5322->is_emailaddress($email);

    my @local = split('@', $email);
    my $alias = '';
    if( $local[0] =~ /\A([-_\w]+?)[+].+\z/ ) {
        # neko+straycat@example.org => neko@example.org
        $alias = $1.'@'.$local[1];
    }
    return $alias;
}

sub is_undisclosed {
    # Check the "address" is an undisclosed address or not
    # @param    [None]
    # @return   [Integer]   1: Undisclosed address
    #                       0: Is not undisclosed address
    my $self = shift;
    return 1 if $self->host eq $undisclosed;
    return 0;
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

    my $v = Sisimai::Address->new('neko@example.org');
    print $v->user;     # neko
    print $v->host;     # example.org
    print $v->address;  # neko@example.org

=head1 DESCRIPTION

Sisimai::Address provide methods for dealing email address.

=head1 CLASS METHODS

=head2 C<B<new(I<email address>)>>

C<new()> is a constructor of Sisimai::Address

    my $v = Sisimai::Address->new('neko@example.org');

=head2 C<B<find(I<String>)>>

C<find()> is a new parser for getting only email address from text including
email addresses.

    my $r = 'Stray cat <cat@example.org>, nyaa@example.org (White Cat)',
    my $v = Sisimai::Address->find($r);

    warn Dumper $v;
    $VAR1 = [
              {
                'name' => 'Stray cat',
                'address' => 'cat@example.org',
                'comment' => ''
              },
              {
                'name' => '',
                'address' => 'nyaa@example.jp',
                'comment' => '(White Cat)'
              }
    ];

=head2 C<B<s3s4(I<email address>)>>

C<s3s4()> works Ruleset 3, and 4 of sendmail.cf.

    my $r = [
        'Stray cat <cat@example.org>',
        'nyaa@example.org (White Cat)',
    ];

    for my $e ( @$r ) {
        print Sisimai::Address->s3s4($e);   # cat@example.org
                                            # nyaa@example.org
    }

=head2 C<B<expand_verp(I<email address>)>>

C<expand_verp()> gets the original email address from VERP

    my $r = 'nyaa+neko=example.org@example.org';
    print Sisimai::Address->expand_verp($r); # neko@example.org

=head2 C<B<expand_alias(I<email address>)>>

C<expand_alias()> gets the original email address from alias

    my $r = 'nyaa+neko@example.org';
    print Sisimai::Address->expand_alias($r); # nyaa@example.org

=head1 INSTANCE METHODS

=head2 C<B<user()>>

C<user()> returns a local part of the email address.

    my $v = Sisimai::Address->new('neko@example.org');
    print $v->user;     # neko

=head2 C<B<host()>>

C<host()> returns a domain part of the email address.

    my $v = Sisimai::Address->new('neko@example.org');
    print $v->host;     # example.org

=head2 C<B<address()>>

C<address()> returns an email address

    my $v = Sisimai::Address->new('neko@example.org');
    print $v->address;     # neko@example.org

=head2 C<B<verp()>>

C<verp()> returns a VERP email address

    my $v = Sisimai::Address->new('neko+nyaan=example.org@example.org');
    print $v->verp;     # neko+nyaan=example.org@example.org
    print $v->address;  # nyaan@example.org

=head2 C<B<alias()>>

C<alias()> returns an email address (alias)

    my $v = Sisimai::Address->new('neko+nyaan@example.org');
    print $v->alias;    # neko+nyaan@example.org
    print $v->address;  # neko@example.org

=head2 C<B<name()>>

C<name()> returns a display name

    my $e = '"Neko, Nyaan" <neko@example.org>';
    my $r = Sisimai::Address->find($e);
    my $v = Sisimai::Address->make($r->[0]);
    print $v->address;  # neko@example.org
    print $v->name;     # Neko, Nyaan

=head2 C<B<comment()>>

C<name()> returns a comment

    my $e = '"Neko, Nyaan" <neko(nyaan)@example.org>';
    my $v = Sisimai::Address->make(shift @{ Sisimai::Address->find($e) });
    print $v->address;  # neko@example.org
    print $v->comment;  # nyaan

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
