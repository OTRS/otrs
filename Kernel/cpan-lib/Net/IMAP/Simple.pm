package Net::IMAP::Simple;

use strict;
use warnings;

use Carp;
use IO::File;
use IO::Socket;
use IO::Select;

our $VERSION = "1.1910";

BEGIN {
    # I'd really rather the pause/cpan indexers miss this "package"
    eval ## no critic
    q( package Net::IMAP::Simple::_message;
       use overload fallback=>1, '""' => sub { local $"=""; "@{$_[0]}" };
       sub new { bless $_[1] })
}

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

    if( $opts{use_ssl} ) {
        eval {
            require IO::Socket::SSL;
            import IO::Socket::SSL;
            "true";

        } or croak "IO::Socket::SSL must be installed in order to use_ssl";
    }

    if ( $opts{use_v6} ) {
        eval {
            require IO::Socket::INET6;
            import  IO::Socket::INET6;
            "true";

        } or croak "IO::Socket::INET6 must be installed in order to use_v6";
    }

    my ( $srv, $prt ) = split( /:/, $server, 2 );
    $prt ||= ( $opts{port} ? $opts{port} : $self->_port );

    $self->{server} = $srv;
    $self->{port}   = $prt;

    $self->{timeout}          = ( $opts{timeout} ? $opts{timeout} : $self->_timeout );
    $self->{retry}            = ( $opts{retry} ? $opts{retry} : $self->_retry );
    $self->{retry_delay}      = ( $opts{retry_delay} ? $opts{retry_delay} : $self->_retry_delay );
    $self->{bindaddr}         = $opts{bindaddr};
    $self->{use_select_cache} = $opts{use_select_cache};
    $self->{select_cache_ttl} = $opts{select_cache_ttl};
    $self->{debug}            = $opts{debug};

    # Pop the port off the address string if it's not an IPv6 IP address
    if ( !$self->{use_v6} && $self->{server} =~ /^[A-Fa-f0-9]{4}:[A-Fa-f0-9]{4}:/ && $self->{server} =~ s/:(\d+)$//g ) {
        $self->{port} = $1;
    }

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

    $self->_debug( caller, __LINE__, 'new', "looking for greeting" ) if $self->{debug};

    my $greeting_ok = 0;
    if( $select->can_read($self->{timeout}) ) {
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

    $sock = $self->_sock_from->new(
        PeerAddr => $self->{server},
        PeerPort => $self->{port},
        Timeout  => $self->{timeout},
        Proto    => 'tcp',
        ( $self->{bindaddr} ? { LocalAddr => $self->{bindaddr} } : () )
    );

    return $sock;
}

sub _port        { return $_[0]->{use_ssl} ? 993 : 143 } 
sub _sock        { return $_[0]->{sock} }
sub _count       { return $_[0]->{count} }
sub _last        { return $_[0]->{last} }
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
                SSL_version        => "SSLv3 TLSv1",
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

    return $self->_process_cmd(
        cmd     => [ LOGIN => qq[$user "$pass"] ],
        final   => sub { 1 },
        process => sub { },
    );
}

sub _clear_cache {
    my $self = shift;

    push @_, $self->{working_box} if exists $self->{working_box} and not @_;
    return unless @_;

    for my $box (@_) {
        delete $self->{BOXES}{$box};
    }

    delete $self->{last};

    return 1;
}

sub status {
    my $self = shift;
    my $mbox = shift || $self->current_box || "INBOX";

    # Example: C: A042 STATUS blurdybloop (UIDNEXT MESSAGES)
    #          S: * STATUS blurdybloop (MESSAGES 231 UIDNEXT 44292)
    #          S: A042 OK STATUS completed

    my ($unseen, $recent, $messages);

    return $self->_process_cmd(
        cmd     => [ STATUS => _escape($mbox) . " (UNSEEN RECENT MESSAGES)" ],
        final   => sub { return unless defined $messages; ($unseen, $recent, $messages) },
        process => sub {
            if( my ($status) = $_[0] =~ m/\* STATUS.+?$mbox.+?\((.+?)\)/i ) {
                $unseen   = $1 if $status =~ m/UNSEEN (\d+)/i;
                $recent   = $1 if $status =~ m/RECENT (\d+)/i;
                $messages = $1 if $status =~ m/MESSAGES (\d+)/i;
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

    $self->select($folder);

    return $self->{BOXES}{ $self->current_box }{oflags}{UNSEEN};
}

sub current_box {
    my ($self) = @_;

    return ( $self->{working_box} ? $self->{working_box} : 'INBOX' );
}

sub top {
    my ( $self, $number ) = @_;

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
        cmd   => [ FETCH => qq[$number RFC822.HEADER] ],
        final => sub { \@lines },
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

sub list {
    my ( $self, $number ) = @_;

    my $messages = $number || '1:' . $self->_last;
    my %list;

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
    my ($self, $search) = @_;
    $search ||= "ALL";

    my @seq;

    return $self->_process_cmd(
        cmd => [ SEARCH => $search ],
        final => sub { wantarray ? @seq : int @seq },
        process => sub { if ( my ($msgs) = $_[0] =~ /^\*\s+SEARCH\s+(.*)/i ) {
            push @seq, $1 while $msgs =~ m/\b(\d+)\b/g;
        } },
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

            return Date::Manip::UnixDate($pd, '%d-%m-%Y');
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
    my ( $self, $number ) = @_;

    my @lines;

    return $self->_process_cmd(
        cmd => [ FETCH => qq[$number RFC822] ],
        final => sub { pop @lines; wantarray ? @lines : Net::IMAP::Simple::_message->new(\@lines) },
        process => sub {
            if ( $_[0] !~ /^\* \d+ FETCH/ ) {
                push @lines, join( ' ', @_ );
            }
        },
    );

}

sub _process_flags {
    my $self = shift;

    return grep { m/^\\\w+\z/ }
            map { split m/\s+/, $_ }
            @_;
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
        cmd   => [ APPEND => "$mailbox_name (@flags) {$size}" ],
        final => sub { $self->_clear_cache },
        process => sub {
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
        },

    );
}

sub msg_flags {
    my ( $self, $number ) = @_;

    my @flags;
    $self->{_waserr} = 1; # assume something went wrong.

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
            if( $_[0] =~ m/\* $number FETCH \(FLAGS \(([^()]+?)\)\)/i ) {
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

sub quit {
    my ( $self, $hq ) = @_;
    $self->_send_cmd('EXPUNGE');

    if ( !$hq ) {
        $self->_process_cmd( cmd => ['LOGOUT'], final => sub { 1 }, process => sub { } );

    } else {
        $self->_send_cmd('LOGOUT');
    }

    $self->_sock->close;

    return 1;
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
        _escape($res);

        push @list, $res;

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
            cmd => [ LIST => qq[$ref *] ],
            final => sub { _unescape($_) for @list; @list },
            process => sub { push @list, $self->_process_list( $_[0] ); },
        );

    }

    return $self->_process_cmd(
        cmd => [ LIST => qq[$ref $box] ],
        final => sub { _unescape($_) for @list; @list },
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
            cmd => [ LSUB => qq[$ref *] ],
            final => sub { _unescape($_) for @list; @list },
            process => sub { push @list, $self->_process_list( $_[0] ) },
        );

    }

    return $self->_process_cmd(
        cmd => [ LSUB => qq[$ref $box] ],
        final => sub { _unescape($_) for @list; @list },
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

    $self->{_waserr} = 1;

    my @expunged;
    return $self->_process_cmd(
        cmd   => ['EXPUNGE'],
        final => sub {
            $self->_clear_cache;
            return if $self->{_waserr};
            return @expunged if wantarray;
            return "0E0" unless @expunged;
            return @expunged;
        },
        process => sub {
            if( $_[0] =~ m/^\s*\*\s+(\d+)\s+EXPUNGE[\r\n]*$/i ) {
                push @expunged, $1;
                delete $self->{_waserr};
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
    my ( $self, $sock, $count ) = @_;

    my @lines;
    my $read_so_far = 0;

    while ( $read_so_far < $count ) {
        push @lines, $sock->getline;
        $read_so_far += length( $lines[-1] );
    }

    if ( $self->{debug} ) {
        for ( my $i = 0 ; $i < @lines ; $i++ ) {
            $self->_debug( caller, __LINE__, '_read_multiline', "[$i] $lines[$i]" );
        }
    }

    return @lines;
}

sub _process_cmd {
    my ( $self, %args ) = @_;
    my ( $sock, $id )   = $self->_send_cmd( @{ $args{cmd} } );

    my $res;
    while ( $res = $sock->getline ) {
        $self->_debug( caller, __LINE__, '_process_cmd', $res ) if $self->{debug};

        if ( $res =~ /^\*.*\{(\d+)\}[\r\n]*$/ ) {
            $args{process}->($res);
            $args{process}->($_) foreach $self->_read_multiline( $sock, $1 );

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

    if ( ref( $self->{debug} ) eq 'GLOB' ) {
        print { $self->{debug} } $line;

    } else {
        print STDOUT $line;
    }

    return;
}

"True"; ## no critic -- pfft
