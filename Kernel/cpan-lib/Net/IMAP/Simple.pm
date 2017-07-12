package Net::IMAP::Simple;

use strict;
use warnings;

use Carp;
use IO::File;
use IO::Socket;
use IO::Select;
use Net::IMAP::Simple::PipeSocket;

our $VERSION = "1.2209";

BEGIN {
    # I'd really rather the pause/cpan indexers miss this "package"
    eval ## no critic
    q( package Net::IMAP::Simple::_message;
       use overload fallback=>1, '""' => sub { local $"=""; "@{$_[0]}" };
       sub new { bless $_[1] })
}

our $uidm;

sub new {
    my ( $class, $server, %opts ) = @_;

    ## warn "use of Net::IMAP::Simple::SSL is depricated, pass use_ssl to new() instead\n"
    ##     if $class =~ m/::SSL/;

    my $self = bless { count => -1 } => $class;

    $self->{use_v6}  = ( $opts{use_v6}  ? 1 : 0 );
    $self->{use_ssl} = ( $opts{use_ssl} ? 1 : 0 );

    unless( $opts{shutup_about_v6ssl} ) {
        carp "use_ssl with IPv6 is not yet supported"
            if $opts{use_v6} and $opts{use_ssl};
    }

    if( $opts{ssl_version} ) {
        $self->{ssl_version} = $opts{ssl_version};
        $opts{use_ssl} = 1;
    }

    $opts{use_ssl} = 1 if $opts{find_ssl_defaults};

    if( $opts{use_ssl} ) {
        eval {
            require IO::Socket::SSL;
            import IO::Socket::SSL;
            "true";

        } or croak "IO::Socket::SSL must be installed in order to use_ssl";

         $self->{ssl_options}       = [ eval {@{ $opts{ssl_options} }} ];
         carp "ignoring ssl_options: $@" if $opts{ssl_options} and not @{ $self->{ssl_options} };

        unless( @{ $self->{ssl_options} } ) {
            if( $opts{find_ssl_defaults} ) {
                my $nothing = 1;

                for(qw(
                            /etc/ssl/certs/ca-certificates.crt
                            /etc/pki/tls/certs/ca-bundle.crt
                            /etc/ssl/ca-bundle.pem
                            /etc/ssl/certs/
                    )) {

                    if( -f $_ ) {
                        @{ $self->{ssl_options} } = (SSL_ca_file=>$_, SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_PEER());
                        $nothing = 0;
                        last;

                    } elsif( -d $_ ) {
                        @{ $self->{ssl_options} } = (SSL_ca_path=>$_, SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_PEER());
                        $nothing = 0;
                        last;
                    }
                }

                if( $nothing ) {
                    carp "couldn't find rational defaults for ssl verify.  Choosing to not verify.";
                    @{ $self->{ssl_options} } = (SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE());
                }

            } else {
                @{ $self->{ssl_options} } = (SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE());
            }
        }
    }

    if ( $opts{use_v6} ) {
        eval {
            require IO::Socket::INET6;
            import  IO::Socket::INET6;
            "true";

        } or croak "IO::Socket::INET6 must be installed in order to use_v6";
    }

    if( $server =~ m/cmd:(.+)/ ) {
        $self->{cmd} = $1;

    } else {
        if( ($self->{server}, $self->{port}) = $server =~ m/^(\d{1,3}(?:\.\d{1,3}){3})(?::(\d+))?\z/ ) {

        } elsif( ($self->{server}, $self->{port}) = $server =~ m/^\[([a-fA-F0-9:]+)\]:(\d+)\z/ ) {

        } elsif( ($self->{server}, $self->{port}) = $server =~ m/^([a-fA-F0-9:]+)\z/ ) {

        } elsif( ($self->{server}, $self->{port}) = $server =~ m/^([^:]+):(\d+)\z/ ) {

        } else {
            $self->{server} = $server;
            $self->{port}   = $opts{port};
        }

        $self->{port} = $self->_port unless defined $self->{port};
    }

    $self->{timeout}           = ( $opts{timeout} ? $opts{timeout} : $self->_timeout );
    $self->{retry}             = ( defined($opts{retry}) ? $opts{retry} : $self->_retry );
    $self->{retry_delay}       = ( defined($opts{retry_delay}) ? $opts{retry_delay} : $self->_retry_delay );
    $self->{bindaddr}          = $opts{bindaddr};
    $self->{use_select_cache}  = $opts{use_select_cache};
    $self->{select_cache_ttl}  = $opts{select_cache_ttl};
    $self->{debug}             = $opts{debug};
    $self->{readline_callback} = $opts{readline_callback};

    my $sock;
    my $c;
    for ( my $i = 0 ; $i <= $self->{retry} ; $i++ ) {
        if ( $sock = $self->{sock} = $self->_connect ) {
            $c = 1;
            last;

        } elsif ( $i < $self->{retry} ) {
            sleep $self->{retry_delay};

            # Critic NOTE: I'm not sure why this was done, but it was removed
            # beucase the critic said it was bad and sleep makes more sense.
            # select( undef, undef, undef, $self->{retry_delay} );
        }
    }

    if ( !$c ) {
        $@ =~ s/IO::Socket::INET6?: //g;
        $Net::IMAP::Simple::errstr = "connection failed $@";
        return;
    }

    return unless $sock;

    my $select = $self->{sel} = IO::Select->new($sock);

    $self->_debug( caller, __LINE__, 'new', "waiting for socket ready" ) if $self->{debug};

    my $greeting_ok = 0;
    if( $select->can_read($self->{timeout}) ) {
        $self->_debug( caller, __LINE__, 'new', "looking for greeting" ) if $self->{debug};
        if( my $line = $sock->getline ) {
            # Cool, we got a line, check to see if it's a
            # greeting.

            $self->_debug( caller, __LINE__, 'new', "got a greeting: $line" ) if $self->{debug};
            $greeting_ok = 1 if $line =~ m/^\*\s+(?:OK|PREAUTH)/i;

            # Also, check to see if we failed before we sent any
            # commands.
            return if $line =~ /^\*\s+(?:NO|BAD)(?:\s+(.+))?/i;

        } else {
            $self->_debug( caller, __LINE__, 'new', "server hung up during connect" ) if $self->{debug};

            # The server hung up on us, otherwise we'd get a line
            # after can_read.
            return;
        }

    } else {
        $self->_debug( caller, __LINE__, 'new', "no greeting found before timeout" ) if $self->{debug};
    }

    return unless $greeting_ok;
    return $self;
}

sub _connect {
    my ($self) = @_;
    my $sock;

    if( $self->{cmd} ) {
        $self->_debug( caller, __LINE__, '_connect', "popping open a pipesocket for command: $self->{cmd}" ) if $self->{debug};
        $sock = Net::IMAP::Simple::PipeSocket->new(cmd=>$self->{cmd});

    } else {
        $self->_debug( caller, __LINE__, '_connect', "connecting to $self->{server}:$self->{port}" ) if $self->{debug};
        $sock = $self->_sock_from->new(
            PeerAddr => $self->{server},
            PeerPort => $self->{port},
            Timeout  => $self->{timeout},
            Proto    => 'tcp',
            ( $self->{bindaddr}    ? ( LocalAddr => $self->{bindaddr} )      : () ),
            ( $_[0]->{ssl_version} ? ( SSL_version => $self->{ssl_version} ) : () ),
            ( $_[0]->{use_ssl}     ? (@{ $self->{ssl_options} })             : () ),
        );
    }

    $self->_debug( caller, __LINE__, '_connect', "connected, returning socket" ) if $self->{debug};
    return $sock;
}

sub _port        { return $_[0]->{use_ssl} ? 993 : 143 }
sub _sock        { return $_[0]->{sock} }
sub _count       { return $_[0]->{count} }
sub _last        { $_[0]->select unless exists $_[0]->{last}; return $_[0]->{last}||0 }
sub _timeout     { return 90 }
sub _retry       { return 1 }
sub _retry_delay { return 5 }
sub _sock_from   { return $_[0]->{use_v6} ? 'IO::Socket::INET6' : $_[0]->{use_ssl} ? 'IO::Socket::SSL' : 'IO::Socket::INET' }

sub starttls {
    my ($self) = @_;

    require IO::Socket::SSL; import IO::Socket::SSL;
    require Net::SSLeay;     import Net::SSLeay;

    # $self->{debug} = 1;
    # warn "Processing STARTTLS command";

    return $self->_process_cmd(
        cmd   => ['STARTTLS'],
        final => sub {
            Net::SSLeay::load_error_strings();
            Net::SSLeay::SSLeay_add_ssl_algorithms();
            Net::SSLeay::randomize();

            my $startres = IO::Socket::SSL->start_SSL(
                $self->{sock},
                SSL_version        => $self->{ssl_version} || "SSLv3 TLSv1",
                SSL_startHandshake => 0,
            );

            unless ( $startres ) {
                croak "Couldn't start TLS: " . IO::Socket::SSL::errstr() . "\n";
            }

            $self->_debug( caller, __LINE__, 'starttls', "TLS initialization done" ) if $self->{debug};
            1;
        },

        # process => sub { push @lines, $_[0] if $_[0] =~ /^(?: \s+\S+ | [^:]+: )/x },
    );
}

sub login {
    my ( $self, $user, $pass ) = @_;

    $pass = _escape($pass);

    return $self->_process_cmd(
        cmd     => [ LOGIN => qq[$user $pass] ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub separator {
    my ( $self, ) = @_;
    my $sep;

        return $self->_process_cmd (
        cmd     => [ LIST => qq["" ""]  ],
        final => sub { $sep },
        process => sub { (undef,undef,undef,$sep,undef) = split /\s/smx , $_[0];
                        $sep =~ s/["]//g;  },
    );
}

sub _clear_cache {
    my $self = shift;
    my $cb = $self->current_box;

    push @_, $cb if $cb and not @_;
    return unless @_;

    for my $box (@_) {
        delete $self->{BOXES}{$box};
    }

    delete $self->{last};

    return 1;
}

sub uidnext {
    my $self = shift;
    my $mbox = shift || $self->current_box || "INBOX";

    return $self->status($mbox => 'uidnext');
}

sub uidvalidity {
    my $self = shift;
    my $mbox = shift || $self->current_box || "INBOX";

    return $self->status($mbox => 'uidvalidity');
}

sub uidsearch {
    my $self = shift;

    local $uidm = 1;

    return $self->search(@_);
}

sub uid {
    my $self = shift;
       $self->_be_on_a_box; # does a select if we're not on a mailbox

    return $self->uidsearch( shift || "1:*" );
}

sub seq {
    my $self = shift;
    my $msgno = shift || "1:*";

    $self->_be_on_a_box; # does a select if we're not on a mailbox

    return $self->search("uid $msgno");
}

sub status {
    my $self = shift;
    my $mbox = shift || $self->current_box || "INBOX";
    my @fields = @_ ? @_ : qw(unseen recent messages);

    # Example: C: A042 STATUS blurdybloop (UIDNEXT MESSAGES)
    #          S: * STATUS blurdybloop (MESSAGES 231 UIDNEXT 44292)
    #          S: A042 OK STATUS completed

    @fields = map{uc$_} @fields;
    my %fields;

    return $self->_process_cmd(
        cmd     => [ STATUS => _escape($mbox) . " (@fields)" ],
        final   => sub { (@fields{@fields}) },
        process => sub {
            if( my ($status) = $_[0] =~ m/\* STATUS.+?$mbox.+?\((.+?)\)/i ) {

                for( @fields ) {
                    $fields{$_} = _unescape($1)
                        if $status =~ m/$_\s+(\S+|"[^"]+"|'[^']+')/i
                            # NOTE: this regex isn't perfect, but should almost always work
                            # for status values returned by a well meaning IMAP server
                }

            }
        },
    );
}

sub select { ## no critic -- too late to choose a different name now...
    my ( $self, $mbox, $examine_mode ) = @_;
    $examine_mode = $examine_mode ? 1:0;
    $self->{examine_mode} = 0 unless exists $self->{examine_mode};

    $mbox = $self->current_box unless $mbox;

    if( $examine_mode == $self->{examine_mode} ) {
        if ( $self->{use_select_cache} && ( time - $self->{BOXES}{$mbox}{proc_time} ) <= $self->{select_cache_ttl} ) {
            return $self->{BOXES}{$mbox}{messages};
        }
    }

    $self->{BOXES}{$mbox}{proc_time} = time;

    my $cmd = $examine_mode ? 'EXAMINE' : 'SELECT';

    return $self->_process_cmd(
        cmd => [ $cmd => _escape($mbox) ],
        final => sub {
            my $nm = $self->{last} = $self->{BOXES}{$mbox}{messages};

            $self->{working_box}  = $mbox;
            $self->{examine_mode} = $examine_mode;

            $nm ? $nm : "0E0";
        },
        process => sub {
            if ( $_[0] =~ /^\*\s+(\d+)\s+EXISTS/i ) {
                $self->{BOXES}{$mbox}{messages} = $1;

            } elsif ( $_[0] =~ /^\*\s+FLAGS\s+\((.*?)\)/i ) {
                $self->{BOXES}{$mbox}{flags} = [ split( /\s+/, $1 ) ];

            } elsif ( $_[0] =~ /^\*\s+(\d+)\s+RECENT/i ) {
                $self->{BOXES}{$mbox}{recent} = $1;

            } elsif ( $_[0] =~ /^\*\s+OK\s+\[(.*?)\s+(.*?)\]/i ) {
                my ( $flag, $value ) = ( $1, $2 );

                if ( $value =~ /\((.*?)\)/ ) {
                    # NOTE: the sflags really aren't used anywhere, should they be?
                    $self->{BOXES}{$mbox}{sflags}{$flag} = [ split( /\s+/, $1 ) ];

                } else {
                    $self->{BOXES}{$mbox}{oflags}{$flag} = $value;
                }
            }
        },
    );
}

sub examine {
    my $self = shift;

    return $self->select($_[0], 1);
}

sub messages {
    my ( $self, $folder ) = @_;

    return $self->select($folder);
}

sub flags {
    my ( $self, $folder ) = @_;

    $self->select($folder);

    return @{ $self->{BOXES}{ $self->current_box }{flags} || [] };
}

sub recent {
    my ( $self, $folder ) = @_;

    $self->select($folder);

    return $self->{BOXES}{ $self->current_box }{recent};
}

sub unseen {
    my ( $self, $folder ) = @_;

    my $oflags = $self->{BOXES}{ $self->current_box }{oflags};

    if( exists $oflags->{UNSEEN} ) {
        $self->select($folder);

        return $self->{BOXES}{ $self->current_box }{oflags}{UNSEEN};
    }

    my ($unseen) = $self->status;

    return $unseen;
}

sub current_box {
    my ($self) = @_;

    return ( $self->{working_box} ? $self->{working_box} : 'INBOX' );
}

sub close { ## no critic -- we already have tons of methods with built in names

    my $self = shift;
    $self->{working_box} = undef;
    return $self->_process_cmd(
        cmd => [ "CLOSE" ],
    );
}

sub noop {
    my $self = shift;
    return $self->_process_cmd(
        cmd => [ "NOOP" ],
    );
}

sub top {
    my ( $self, $number ) = @_;
    my $messages = $number || '1:' . $self->_last;

    my @lines;

    ## rfc2822 ## 2.2. Header Fields

    ## rfc2822 ##    Header fields are lines composed of a field name, followed by a colon
    ## rfc2822 ##    (":"), followed by a field body, and terminated by CRLF.  A field
    ## rfc2822 ##    name MUST be composed of printable US-ASCII characters (i.e.,
    ## rfc2822 ##    characters that have values between 33 and 126, inclusive), except
    ## rfc2822 ##    colon.  A field body may be composed of any US-ASCII characters,
    ## rfc2822 ##    except for CR and LF.  However, a field body may contain CRLF when
    ## rfc2822 ##    used in header "folding" and  "unfolding" as described in section
    ## rfc2822 ##    2.2.3.  All field bodies MUST conform to the syntax described in
    ## rfc2822 ##    sections 3 and 4 of this standard.

    return $self->_process_cmd(
        cmd   => [ FETCH => qq[$messages RFC822.HEADER] ],
        final => sub {
            $lines[-1] =~ s/\)\x0d\x0a\z//  # sometimes we get this and I don't think we should
                                            # I really hoping I'm not breaking someting by doing this.
                if @lines;

            return wantarray ? @lines : \@lines
        },
        process => sub {
            return if $_[0] =~ m/\*\s+\d+\s+FETCH/i; # should this really be case insensitive?

            if( not @lines or $_[0] =~ m/^[!-9;-~]+:/ ) {
                push @lines, $_[0];

            } else {
                $lines[-1] .= $_[0];
            }
        },
    );
}

sub seen {
    my ( $self, $number ) = @_;

    my @flags = $self->msg_flags($number);
    return if $self->waserr;
    return 1 if grep {$_ eq '\Seen'} @flags;
    return 0;
}

sub deleted {
    my ( $self, $number ) = @_;

    my @flags = $self->msg_flags($number);
    return if $self->waserr;
    return 1 if grep {$_ eq '\Deleted'} @flags;
    return 0;
}

sub range2list {
    my $self_or_class = shift;
    my %h;
    my @items = grep {!$h{$_}++} map { m/(\d+):(\d+)/ ? ($1 .. $2) : ($_) } split(m/[,\s]+/, shift);

    return @items;
}

sub list2range {
    my $self_or_class = shift;
    my %h;
    my @a = sort { $a<=>$b } grep {!$h{$_}++} grep {m/^\d+/} grep {defined $_} @_;
    my @b;

    while(@a) {
        my $e = 0;

        $e++ while $e+1 < @a and $a[$e]+1 == $a[$e+1];

        push @b, ($e>0 ? [$a[0], $a[$e]] : [$a[0]]);
        splice @a, 0, $e+1;
    }

    return join(",", map {join(":", @$_)} @b);
}

sub list {
    my ( $self, $number ) = @_;

    # NOTE: this entire function is horrible:
    # 1. it should be called message_size() or something similar
    # 2. what if $number is a range? none of this works right

    my $messages = $number || '1:' . $self->_last;
    my %list;

    return {} if $messages eq "1:0";

    return $self->_process_cmd(
        cmd => [ FETCH => qq[$messages RFC822.SIZE] ],
        final => sub { $number ? $list{$number} : \%list },
        process => sub {
            if ( $_[0] =~ /^\*\s+(\d+).*RFC822.SIZE\s+(\d+)/i ) {
                $list{$1} = $2;
            }
        },
    );
}

sub search {
    my ($self, $search, $sort, $charset) = @_;

    $search   ||= "ALL";
    $charset  ||= 'UTF-8';

    my $cmd = $uidm ? 'UID SEARCH' : 'SEARCH';

    $self->_be_on_a_box; # does a select if we're not on a mailbox

    # add rfc5256 sort, requires charset :(
    if ($sort) {
        $sort = uc $sort;
        $cmd = ($uidm ? "UID ": "") . "SORT ($sort) \"$charset\"";
    }

    my @seq;

    return $self->_process_cmd(
        cmd => [ $cmd => $search ],
        final => sub { wantarray ? @seq : int @seq },
        process => sub { if ( my ($msgs) = $_[0] =~ /^\*\s+(?:SEARCH|SORT)\s+(.*)/i ) {

            @seq = $self->range2list($msgs);

        }},
    );
}

sub search_seen     { my $self = shift; return $self->search("SEEN"); }
sub search_recent   { my $self = shift; return $self->search("RECENT"); }
sub search_answered { my $self = shift; return $self->search("ANSWERED"); }
sub search_deleted  { my $self = shift; return $self->search("DELETED"); }
sub search_flagged  { my $self = shift; return $self->search("FLAGGED"); }
sub search_draft    { my $self = shift; return $self->search("FLAGGED"); }

sub search_unseen     { my $self = shift; return $self->search("UNSEEN"); }
sub search_old        { my $self = shift; return $self->search("OLD"); }
sub search_unanswered { my $self = shift; return $self->search("UNANSWERED"); }
sub search_undeleted  { my $self = shift; return $self->search("UNDELETED"); }
sub search_unflagged  { my $self = shift; return $self->search("UNFLAGGED"); }

sub search_smaller { my $self = shift; my $octets = int shift; return $self->search("SMALLER $octets"); }
sub search_larger  { my $self = shift; my $octets = int shift; return $self->search("LARGER $octets"); }

sub _process_date {
    my $d = shift;

    if( eval 'use Date::Manip (); 1' ) { ## no critic
        if( my $pd = Date::Manip::ParseDate($d) ) {

            # NOTE: RFC 3501 wants this poorly-internationalized date format
            # for SEARCH.  Not my fault.

            return Date::Manip::UnixDate($pd, '%d-%b-%Y');
        }

    } else {
        # TODO: complain if the date isn't %d-%m-%Y

        # I'm not sure there's anything to be gained by doing so ...  They'll
        # just get an imap error they can choose to handle.
    }

    return $d;
}

sub _process_qstring {
    my $t = shift;
       $t =~ s/\\/\\\\/g;
       $t =~ s/"/\\"/g;

    return "\"$t\"";
}

sub search_before      { my $self = shift; my $d = _process_date(shift); return $self->search("BEFORE $d"); }
sub search_since       { my $self = shift; my $d = _process_date(shift); return $self->search("SINCE $d"); }
sub search_sent_before { my $self = shift; my $d = _process_date(shift); return $self->search("SENTBEFORE $d"); }
sub search_sent_since  { my $self = shift; my $d = _process_date(shift); return $self->search("SENTSINCE $d"); }

sub search_from    { my $self = shift; my $t = _process_qstring(shift); return $self->search("FROM $t"); }
sub search_to      { my $self = shift; my $t = _process_qstring(shift); return $self->search("TO $t"); }
sub search_cc      { my $self = shift; my $t = _process_qstring(shift); return $self->search("CC $t"); }
sub search_bcc     { my $self = shift; my $t = _process_qstring(shift); return $self->search("BCC $t"); }
sub search_subject { my $self = shift; my $t = _process_qstring(shift); return $self->search("SUBJECT $t"); }
sub search_body    { my $self = shift; my $t = _process_qstring(shift); return $self->search("BODY $t"); }

sub get {
    my ( $self, $number, $part ) = @_;
    my $arg = $part ? "BODY[$part]" : 'RFC822';
	return $self->fetch( $number, $part );
}

sub fetch {
    my ( $self, $number, $part ) = @_;
    my $arg = $part || 'RFC822';

    my @lines;
    my $fetching;

    return $self->_process_cmd(
        cmd => [ FETCH => qq[$number $arg] ],
        final => sub {
            if( $fetching ) {
                if( $fetching > 0 ) {
                    # XXX: this is just about the least efficient way in the
                    # world to do this; I should appologize, but really,
                    # nothing in this module is done particularly well.  I
                    # doubt anyone will notice this.

                    local $"="";
                    my $message = "@lines";
                    @lines = split m/(?<=\x0d\x0a)/, substr($message, 0, $fetching)
                        if( length $message > $fetching );
                }
                return  wantarray ? @lines : Net::IMAP::Simple::_message->new(\@lines)
            }

            if( defined $fetching and $fetching == 0 ) {
                return "\n"; # XXX: Your 0 byte message is incorrectly returned as a newline.  Meh.
            }

            # NOTE: There is not supposed to be an error if you ask for a
            # message that's not there, but this is a rather confusing
            # notion … so we generate an error here.

            $self->{_errstr} = "message not found";
            return;
        },
        process => sub {
            if ( $_[0] =~ /^\*\s+\d+\s+FETCH\s+\(.+?\{(\d+)\}/ ) {
                $fetching = $1;

            } elsif( $_[0] =~ /^\*\s+\d+\s+FETCH\s+\(.+?\"(.*)\"\s*\)/ ) {
                # XXX: this is not tested because Net::IMAP::Server doesn't do
                # this type of string result (that I know of) for this it might
                # work, ... frog knows.  Not likely to come up very often, if
                # ever; although you do sometimes see the occasional 0byte
                # message.  Valid really.

                $fetching = -1;
                @lines = ($1);

            } elsif( $fetching ) {
                push @lines, join( ' ', @_ );
            }
        },
    );

}

sub _process_flags {
    my $self = shift;
    my @ret = map { split m/\s+/, $_ } grep { $_ } @_;

    return @ret;
}

sub put {
    my ( $self, $mailbox_name, $msg, @flags ) = @_;

    croak "usage: \$imap->put(mailbox, message, \@flags)" unless defined $msg and defined $mailbox_name;

    my $size = length $msg;
    if ( ref $msg eq "ARRAY" ) {
        $size = 0;
        $size += length $_ for @$msg;
    }

    @flags = $self->_process_flags(@flags);

    return $self->_process_cmd(
        cmd   => [ APPEND => _escape($mailbox_name) ." (@flags) {$size}" ],
        final => sub { $self->_clear_cache; 1 },
        process => sub {
            if( $_[0] =~ m/^\+\s+/ ) { # + continue (or go ahead, or whatever)
                if ($size) {
                    my $sock = $self->_sock;
                    if ( ref $msg eq "ARRAY" ) {
                        print $sock $_ for @$msg;

                    } else {
                        print $sock $msg;
                    }
                    $size = undef;
                    print $sock "\r\n";
                }
            }
        },

    );
}

# This supports supplying a date per IMAP RFC 3501
# APPEND Command - Section 6.3.11
# Implemented here as a new method so when calling the put above
# older code will not break
sub put_with_date {
    my ( $self, $mailbox_name, $msg, $date, @flags ) = @_;

    croak "usage: \$imap->put_with_date(mailbox, message, date, \@flags)" unless defined $msg and defined $mailbox_name;

    my $size = length $msg;
    if ( ref $msg eq "ARRAY" ) {
        $size = 0;
        $size += length $_ for @$msg;
    }

    @flags = $self->_process_flags(@flags);

    my $cmd_str = _escape($mailbox_name) . " (@flags)";
    $cmd_str .= " " . _escape($date) if $date ne "";
    $cmd_str .= " {$size}";

    return $self->_process_cmd(
        cmd   => [ APPEND => $cmd_str ],
        final => sub { $self->_clear_cache; 1 },
        process => sub {
            if( $_[0] =~ m/^\+\s+/ ) { # + continue (or go ahead, or whatever)
                if ($size) {
                    my $sock = $self->_sock;
                    if ( ref $msg eq "ARRAY" ) {
                        print $sock $_ for @$msg;

                    } else {
                        print $sock $msg;
                    }
                    $size = undef;
                    print $sock "\r\n";
                }
            }
        },

    );
}

sub msg_flags {
    my ( $self, $number ) = @_;

    my @flags;
    $self->{_waserr} = 1; # assume something went wrong.
    $self->{_errstr} = "flags not found during fetch";

    #  _send_cmd] 15 FETCH 12 (FLAGS)\r\n
    #  _process_cmd] * 12 FETCH (FLAGS (\Seen))\r\n
    #  _cmd_ok] * 12 FETCH (FLAGS (\Seen))\r\n
    #  _seterrstr] warning unknown return string (id=15): * 12 FETCH (FLAGS (\Seen))\r\n
    #  _process_cmd] 15 OK Success\r\n

    return $self->_process_cmd(
        cmd => [ FETCH => qq[$number (FLAGS)] ],
        final => sub {
            return if $self->{_waserr};
            wantarray ? @flags : "@flags";
        },
        process => sub {
            if( $_[0] =~ m/\* $number FETCH \(FLAGS \(([^()]*?)\)\)/i ) {
                @flags = $self->_process_flags($1);
                delete $self->{_waserr};
            }
        },
    );
}

sub getfh {
    my ( $self, $number ) = @_;

    my $file = IO::File->new_tmpfile;
    my $buffer;

    return $self->_process_cmd(
        cmd => [ FETCH => qq[$number RFC822] ],
        final => sub { seek $file, 0, 0; $file },
        process => sub {
            if ( $_[0] !~ /^\* \d+ FETCH/ ) {
                defined($buffer) and print $file $buffer;
                $buffer = $_[0];
            }
        },
    );
}

sub logout {
    my $self = shift;

    return $self->_process_cmd( cmd => ['LOGOUT'], final => sub { $self->_sock->close; 1 }, process => sub { } );
}

sub quit {
    my ( $self, $hq ) = @_;
    $self->_send_cmd('EXPUNGE'); # XXX: $self->expunge_mailbox?

    if ( !$hq ) {
        # XXX: $self->logout?
        $self->_process_cmd( cmd => ['LOGOUT'], final => sub { 1 }, process => sub { } );

    } else {
        # XXX: do people use the $hq?
        $self->_send_cmd('LOGOUT');
    }

    $self->_sock->close;

    return 1;
}

sub _be_on_a_box {
    my $self = shift;
    return if $self->{working_box};
    $self->select; # sit on something
    return;
}

sub last { ## no critic -- too late to choose a different name now...
    my $self = shift;
    my $last = $self->_last;

    if( not defined $last ) {
        $self->select or return;
        $last = $self->_last;
    }

    return $last;
}

sub add_flags {
    my ( $self, $number, @flags ) = @_;

    @flags = $self->_process_flags(@flags);
    return unless @flags;

    return $self->_process_cmd(
        cmd     => [ STORE => qq[$number +FLAGS (@flags)] ],
        final   => sub { $self->_clear_cache },
        process => sub { },
    );
}

sub sub_flags {
    my ( $self, $number, @flags ) = @_;

    @flags = $self->_process_flags(@flags);
    return unless @flags;

    return $self->_process_cmd(
        cmd     => [ STORE => qq[$number -FLAGS (@flags)] ],
        final   => sub { $self->_clear_cache },
        process => sub { },
    );
}

sub delete { ## no critic -- too late to choose a different name now...
    my ( $self, $number ) = @_;

    return $self->add_flags( $number, '\Deleted' );
}

sub undelete {
    my ( $self, $number ) = @_;

    return $self->sub_flags( $number, '\Deleted' );
}

sub see {
    my ( $self, $number ) = @_;

    return $self->add_flags( $number, '\Seen' );
}

sub unsee {
    my ( $self, $number ) = @_;

    return $self->sub_flags( $number, '\Seen' );
}

sub _process_list {
    my ( $self, $line ) = @_;
    $self->_debug( caller, __LINE__, '_process_list', $line ) if $self->{debug};

    my @list;
    if ( $line =~ /^\*\s+(LIST|LSUB).*\s+\{\d+\}\s*$/i ) {
        chomp( my $res = $self->_sock->getline );

        $res =~ s/\r//;

        push @list, _escape($res);

        $self->_debug( caller, __LINE__, '_process_list', $res ) if $self->{debug};

    } elsif ( $line =~ /^\*\s+(LIST|LSUB).*\s+(\".*?\")\s*$/i || $line =~ /^\*\s+(LIST|LSUB).*\s+(\S+)\s*$/i ) {
        push @list, $2;
    }

    return @list;
}

sub mailboxes {
    my ( $self, $box, $ref ) = @_;

    $ref ||= '""';
    my @list;
    if ( !defined $box ) {

        # recurse, should probably follow
        # RFC 2683: 3.2.1.1.  Listing Mailboxes
        return $self->_process_cmd(
            cmd     => [ LIST => qq[$ref *] ],
            final   => sub { map { _unescape($_) } @list },
            process => sub { push @list, $self->_process_list( $_[0] ); },
        );

    }

    return $self->_process_cmd(
        cmd     => [ LIST => qq[$ref $box] ],
        final   => sub { map { _unescape($_) } @list },
        process => sub { push @list, $self->_process_list( $_[0] ) },
    );
}

sub mailboxes_subscribed {
    my ( $self, $box, $ref ) = @_;

    $ref ||= '""';

    my @list;
    if ( !defined $box ) {

        # recurse, should probably follow
        # RFC 2683: 3.2.2.  Subscriptions
        return $self->_process_cmd(
            cmd     => [ LSUB => qq[$ref *] ],
            final   => sub { map { _unescape($_) } @list },
            process => sub { push @list, $self->_process_list( $_[0] ) },
        );

    }

    return $self->_process_cmd(
        cmd     => [ LSUB => qq[$ref $box] ],
        final   => sub { map { _unescape($_) } @list },
        process => sub { push @list, $self->_process_list( $_[0] ) },
    );
}

sub create_mailbox {
    my ( $self, $box ) = @_;

    return $self->_process_cmd(
        cmd     => [ CREATE => _escape($box) ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub expunge_mailbox {
    my ( $self, $box ) = @_;

    return if !$self->select($box);

    # C: A202 EXPUNGE
    # S: * 3 EXPUNGE
    # S: * 3 EXPUNGE
    # S: * 5 EXPUNGE
    # S: * 8 EXPUNGE
    # S: A202 OK EXPUNGE completed

    my @expunged;
    return $self->_process_cmd(
        cmd   => ['EXPUNGE'],
        final => sub {
            $self->_clear_cache;
            return @expunged if wantarray; # don't return 0E0 if want array and we're empty
            return "0E0" unless @expunged;
            return @expunged;
        },
        process => sub {
            if( $_[0] =~ m/^\s*\*\s+(\d+)\s+EXPUNGE[\r\n]*$/i ) {
                push @expunged, $1;
            }
        },
    );
}

sub delete_mailbox {
    my ( $self, $box ) = @_;

    return $self->_process_cmd(
        cmd     => [ DELETE => _escape($box) ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub rename_mailbox {
    my ( $self, $old_box, $new_box ) = @_;
    my $o = _escape($old_box);
    my $n = _escape($new_box);

    return $self->_process_cmd(
        cmd     => [ RENAME => qq[$o $n] ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub folder_subscribe {
    my ( $self, $box ) = @_;
    $self->select($box);

    return $self->_process_cmd(
        cmd     => [ SUBSCRIBE => _escape($box) ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub folder_unsubscribe {
    my ( $self, $box ) = @_;
    $self->select($box);

    return $self->_process_cmd(
        cmd     => [ UNSUBSCRIBE => _escape($box) ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub copy {
    my ( $self, $number, $box ) = @_;
    my $b = _escape($box);

    return $self->_process_cmd(
        cmd     => [ COPY => qq[$number $b] ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub uidcopy {
    my ( $self, $number, $box ) = @_;
    my $b = _escape($box);

    return $self->_process_cmd(
        cmd     => [ 'UID COPY' => qq[$number $b] ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub waserr {
    return $_[0]->{_waserr};
}

sub errstr {
    return $_[0]->{_errstr};
}

sub _nextid { return ++$_[0]->{count} }

sub _escape {
    my $val = shift;
       $val =~ s/\\/\\\\/g;
       $val =~ s/\"/\\\"/g;
       $val = "\"$val\"";

    return $val;
}

sub _unescape {
    my $val = shift;
       $val =~ s/^"//g;
       $val =~ s/"$//g;
       $val =~ s/\\\"/\"/g;
       $val =~ s/\\\\/\\/g;

    return $val;
}

sub _send_cmd {
    my ( $self, $name, $value ) = @_;
    my $sock = $self->_sock;
    my $id   = $self->_nextid;
    my $cmd  = "$id $name" . ( $value ? " $value" : "" ) . "\r\n";

    $self->_debug( caller, __LINE__, '_send_cmd', $cmd ) if $self->{debug};

    { local $\; print $sock $cmd; }

    return ( $sock => $id );
}

sub _cmd_ok {
    my ( $self, $res ) = @_;
    my $id = $self->_count;

    $self->_debug( caller, __LINE__, '_cmd_ok', $res ) if $self->{debug};

    if ( $res =~ /^$id\s+OK/i ) {
        return 1;

    } elsif ( $res =~ /^$id\s+(?:NO|BAD)(?:\s+(.+))?/i ) {
        $self->_seterrstr( $1 || 'unknown error' );
        return 0;

    } elsif ( $res =~ m/^\*\s+/ ) {

    } else {
        $self->_seterrstr("warning unknown return string (id=$id): $res");
    }

    return;
}

sub _read_multiline {
    my ( $self, $sock, $list, $count ) = @_;

    my @lines;
    my $read_so_far = 0;

    while ( $read_so_far < $count ) {
        if( defined( my $line = $sock->getline ) ) {
            $read_so_far += length( $line );
            push @lines, $line;

        } else {
            $self->_seterrstr( "error reading $count bytes from socket" );
            last;
        }
    }

    if( $list and $lines[-1] !~ m/\)[\x0d\x0a\s]*$/ ) {
        $self->_debug( caller, __LINE__, '_read_multiline', "Looking for ending parenthesis match..." ) if $self->{debug};

        my $unmatched = 1;
        while( $unmatched ) {

            if( defined( my $line = $sock->getline ) ) {
                push @lines, $line;
                $unmatched = 0 if $line =~ m/\)[\x0d\x0a\s]*$/;

            } else {
                $self->_seterrstr( "error reading $count bytes from socket" );
                last;
            }

        }
    }

    if ( $self->{debug} ) {
        my $count=0;
        for ( my $i = 0 ; $i < @lines ; $i++ ) {
            $count += length($lines[$i]);
            $self->_debug( caller, __LINE__, '_read_multiline', "[$i] ($count) $lines[$i]" );
        }
    }

    return @lines;
}

sub _process_cmd {
    my ( $self, %args ) = @_;
    my ( $sock, $id )   = $self->_send_cmd( @{ $args{cmd} } );

    $args{process} = sub {} unless ref($args{process}) eq "CODE";
    $args{final}   = sub {} unless ref($args{final})   eq "CODE";

    my $cb = $self->{readline_callback};

    my $res;
    while ( $res = $sock->getline ) {
        $cb->($res) if $cb;
        $self->_debug( caller, __LINE__, '_process_cmd', $res ) if $self->{debug};

        if ( $res =~ /^\*.*\{(\d+)\}[\r\n]*$/ ) {
            my $count = $1;
            my $list;

            $list = 1 if($res =~ /\(/);

            $args{process}->($res);
            foreach( $self->_read_multiline( $sock, $list, $count ) ) {
                $cb->($_) if $cb;
                $args{process}->($_)
            }

        } else {
            my $ok = $self->_cmd_ok($res);
            if ( defined($ok) && $ok == 1 ) {
                return $args{final}->($res);

            } elsif ( defined($ok) && !$ok ) {
                return;

            } else {
                $args{process}->($res);
            }
        }
    }

    return;
}

sub _seterrstr {
    my ( $self, $err ) = @_;

    $self->{_errstr} = $err;
    $self->_debug( caller, __LINE__, '_seterrstr', $err ) if $self->{debug};

    return;
}

sub debug {
    my $this = shift;
    if( @_ ) {
        $this->{debug} = shift;
    }

    return $this->{debug};
}

sub _debug {
    my ( $self, $package, $filename, $line, $dline, $routine, $str ) = @_;

    $str =~ s/\n/\\n/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\cM/^M/g;

    my $shortness = 30;
    my $elipsissn = $shortness-3;
    my $flen      = length $filename;

    my $short_fname = ($flen > $shortness ? "..." . substr($filename, $flen - $elipsissn) : $filename);

    $line = "[$short_fname line $line in sub $routine] $str\n";

    if( exists $self->{debug} and defined $self->{debug} ) {

        if ( ref( $self->{debug} ) eq 'GLOB' ) {
            print { $self->{debug} } $line;

        } elsif( $self->{debug} eq "warn" ) {
            warn $line;

        } elsif( $self->{debug} =~ m/^file:(.+)/ ) {
            open my $out, ">>",  $1 or warn "[log io fail: $@] $line";
            print $out $line;
            CORE::close($out);

        } else {
            print STDOUT $line;
        }

    }

    return;
}

1;
