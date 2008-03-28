package Net::IMAP::Simple;
use strict;
use IO::File;
use IO::Socket;

use vars qw[$VERSION];
$VERSION = $1 if('$Id: Simple.pm,v 1.1 2008-03-28 11:32:36 martin Exp $' =~ /,v ([\d_.]+) /);

=head1 NAME

Net::IMAP::Simple - Perl extension for simple IMAP account handling.

=head1 SYNOPSIS

    # Duh
    use Net::IMAP::Simple;
    use Email::Simple;

    # Create the object
    my $imap = Net::IMAP::Simple->new('imap.example.com') ||
       die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

    # Log on
    if(!$imap->login('user','pass')){
        print STDERR "Login failed: " . $imap->errstr . "\n";
        exit(64);
    }

    # Print the subject's of all the messages in the INBOX
    my $nm = $imap->select('INBOX');

    for(my $i = 1; $i <= $nm; $i++){
        if($imap->seen($i)){
            print "*";
        } else {
            print " ";
        }

        my $es = Email::Simple->new(join '', @{ $imap->top($i) } );

        printf("[%03d] %s\n", $i, $es->header('Subject'));
    }

    $imap->quit;

=head1 DESCRIPTION

This module is a simple way to access IMAP accounts.

=head1 OBJECT CREATION METHOD

=over 4

=item new

 my $imap = Net::IMAP::Simple->new( $server [ :port ]); OR  my $imap = Net::IMAP::Simple->new( $server [, option_name => option_value ] );


This class method constructs a new C<Net::IMAP::Simple> object. It takes one required parameter which is the server to connect to, and additional optional parameters.

The server parameter may specify just the server, or both the server and port number. To specify an alternate port, seperate it from the server with a colon (C<:>), C<example.com:5143>.

On success an object is returned. On failure, nothing is returned and an error message is set to $Net::IMAP::Simple.

=head2 OPTIONS:

Options are provided as a hash to new()

=item port => int

Assign the port number (default: 143)

=item timeout => int (default: 90)

Connection timeout in seconds.

=item retry => int (default: 1)

Attempt to retry the connection attmpt (x) times before giving up

=item retry_delay => int (default: 5)

Wait (x) seconds before retrying a connection attempt

=item use_v6 => BOOL

If set to true, attempt to use IPv6 sockets rather than IPv4 sockets.

This option requires the IO::Socket::INET6 module

=item bindaddr => str

Assign a local address to bind

=item use_select_cache => BOOL

Enable select() caching internally

=item select_cache_ttl => int

The number of seconds to allow a select cache result live before running $imap->select() again.

=item debug => BOOL | \*HANDLE

Enable debugging output. If \*HANDLE is a valid file handle, debugging will be written to it. Otherwise debugging will be written to STDOUT

=cut

sub new {
    my ( $class, $server, %opts) = @_;

    my $self = bless {
        count => -1,
    } => $class;

    my ($srv, $prt) = split(/:/, $server, 2);
    $prt ||= ($opts{port} ? $opts{port} : $self->_port);

    $self->{server} = $srv;
    $self->{port} = $prt;
    $self->{timeout} = ($opts{timeout} ? $opts{timeout} : $self->_timeout);
    $self->{use_v6} = ($opts{use_v6} ? 1 : 0);
    $self->{retry} = ($opts{retry} ? $opts{retry} : $self->_retry);
    $self->{retry_delay} = ($opts{retry_delay} ? $opts{retry_delay} : $self->_retry_delay);
    $self->{bindaddr} = $opts{bindaddr};
    $self->{use_select_cache} = $opts{use_select_cache};
    $self->{select_cache_ttl} = $opts{select_cache_ttl};
    $self->{debug} = $opts{debug};
    

    # Pop the port off the address string if it's not an IPv6 IP address
    if(!$self->{use_v6} && $self->{server} =~ /^[A-Fa-f0-9]{4}:[A-Fa-f0-9]{4}:/ && $self->{server} =~ s/:(\d+)$//g){
        $self->{port} = $1;
    }
   
    my $c;
    for(my $i = 0; $i <= $self->{retry}; $i++){
	if($self->{sock} = $self->_connect){
		$c = 1;
		last;
	} elsif ($i < $self->{retry}) {
		select(undef, undef, undef, $self->{retry_delay});
	}
    }

    if(!$c){
	$@ =~ s/IO::Socket::INET6?: //g;
	$Net::IMAP::Simple::errstr = "connection failed $@";
	return;
    }


    $self->_sock->getline();

    return $self;
}

sub _connect {
 my ($self) = @_;
 my $sock;
 if($self->{use_v6}){
	require 'IO::Socket::INET6';
	import IO::Socket::INET6;
 }

 $sock = $self->_sock_from->new(
	PeerAddr => $self->{server},
	PeerPort => $self->{port},
	Timeout  => $self->{timeout},
	Proto    => 'tcp',
	($self->{bindaddr} ? { LocalAddr => $self->{bindaddr} } : ())
 );

 return $sock;
}

sub _port        { 143            }
sub _sock        { $_[0]->{sock}  }
sub _count       { $_[0]->{count} }
sub _last        { $_[0]->{last}  }
sub _timeout     { 90             }
sub _retry       { 1              }
sub _retry_delay { 5              }
sub _sock_from   { $_[0]->{use_v6} ? 'IO::Socket::INET6' : 'IO::Socket::INET' }

=pod

=head1 METHODS

=item login

  my $inbox_msgs = $imap->login($user, $passwd);

This method takes two required parameters, a username and password. This pair
is authenticated against the server. If authentication is successful TRUE (1) will be returned

Nothing is returned on failure and the errstr() error handler is set with the error message.

=cut

sub login {
 my ( $self, $user, $pass ) = @_;

 return $self->_process_cmd (
	cmd     => [LOGIN => qq[$user "$pass"]],
	final   => sub { 1 },
	process => sub { },
 );
}

=pod

=item select

    my $num_messages = $imap->select($folder);

Selects a folder named in the single required parameter. The number of messages in that folder is returned on success. On failure, nothing is returned  and the errstr() error handler is set with the error message.

=cut

sub select {
 my ( $self, $mbox ) = @_;

 $mbox = 'INBOX' unless $mbox;

 $self->{working_box} = $mbox;

 if($self->{use_select_cache} && (time - $self->{BOXES}->{ $mbox }->{proc_time}) <= $self->{select_cache_ttl}){
	return $self->{BOXES}->{$mbox}->{messages};
 }

 $self->{BOXES}->{$mbox}->{proc_time} = time;

 my $t_mbox = $mbox;

 $self->_process_cmd(
	cmd     => [SELECT => _escape($t_mbox)],
	final   => sub { $self->{last} = $self->{BOXES}->{$mbox}->{messages} },
	process => sub {
		if($_[0] =~ /^\*\s+(\d+)\s+EXISTS/i){
			$self->{BOXES}->{$mbox}->{messages} = $1;
		} elsif($_[0] =~ /^\*\s+FLAGS\s+\((.*?)\)/i){
			$self->{BOXES}->{$mbox}->{flags} = [ split(/\s+/, $1) ];
		} elsif($_[0] =~ /^\*\s+(\d+)\s+RECENT/i){
			$self->{BOXES}->{$mbox}->{recent} = $1;
		} elsif($_[0] =~ /^\*\s+OK\s+\[(.*?)\s+(.*?)\]/i){
			my ($flag, $value) = ($1, $2);
			if($value =~ /\((.*?)\)/){
				$self->{BOXES}->{$mbox}->{sflags}->{$flag} = [split(/\s+/, $1)];
			} else {
				$self->{BOXES}->{$mbox}->{oflags}->{$flag} = $value;
			}
		}
	},
 ) || return;

 return $self->{last}
}

=pod

=item messages

    print "Messages in Junk Mail -- " . $imap->messages("INBOX.Junk Mail") . "\n";

This method is an alias for $imap->select

=cut

sub messages {
 my ($self, $folder) = @_;
 return $self->select($folder);
}

=pod

=item flags

    print "Avaliable server flags: " . join(", ", $imap->flags) . "\n";

This method accepts an optional folder name and returns the current avaliable server flags as a list, for the selected folder. If no folder name is provided the last folder $imap->select'ed will be used.

This method uses caching.

=cut

sub flags {
 my ($self, $folder) = @_;

 $self->select($folder);
 return @{ $self->{BOXES}->{ $self->current_box }->{flags} };
}


=pod

=item recent

    print "Recent messages value: " . $imap->recent . "\n";

This method accepts an optional folder name and returns the 'RECENT' value provided durning a SELECT result set. If no folder name is provided the last folder $imap->select'ed will be used.

This method uses caching.

=cut

sub recent {
 my ($self, $folder) = @_;

 $self->select($folder);
 return $self->{BOXES}->{ $self->current_box }->{recent};
}


=pod

=item current_box

   print "Current Mail Box folder: " . $imap->current_box . "\n";

This method returns the current working mail box folder name.

=cut

sub current_box {
 my ($self) = @_;
 return ($self->{working_box} ? $self->{working_box} : 'INBOX');
}

=pod

=item top

    my $header = $imap->top( $message_number );
    print for @{$header};

This method accepts a message number as its required parameter. That message
will be retrieved from the currently selected folder. On success this method
returns a list reference containing the lines of the header. Nothing is
returned on failure and the errstr() error handler is set with the error message.

=cut

sub top {
    my ( $self, $number ) = @_;
    
    my @lines;
    $self->_process_cmd(
        cmd     => [FETCH => qq[$number rfc822.header]],
        final   => sub { \@lines },
        process => sub { push @lines, $_[0] if $_[0] =~ /^(?: \s+\S+ | [^:]+: )/x },
    );
}

=pod

=item seen

  print "Seen it!" if $imap->seen( $message_number );

A message number is the only required parameter for this method. The message's
C<\Seen> flag will be examined and if the message has been seen a true
value is returned. All other failures return a false value and the errstr() error handler is set with the error message.

=cut

sub seen {
    my ( $self, $number ) = @_;
    
    my $lines = '';
    $self->_process_cmd(
        cmd     => [FETCH=> qq[$number (FLAGS)]],
        final   => sub { $lines =~ /\\Seen/i },
        process => sub { $lines .= $_[0] },
    );
}

=pod

=item list

  my $message_size  = $imap->list($message_number);
  my $mailbox_sizes = $imap->list;

This method returns size information for a message, as indicated in the
single optional parameter, or all messages in a mailbox. When querying a
single message a scalar value is returned. When listing the entire
mailbox a hash is returned. On failure, nothing is returned and the errstr() error handler is set with the error message.

=cut

sub list {
    my ( $self, $number ) = @_;

    my $messages = $number || '1:' . $self->_last;
    my %list;
    $self->_process_cmd(
        cmd     => [FETCH => qq[$messages RFC822.SIZE]],
        final   => sub { $number ? $list{$number} : \%list },
        process => sub {
                        if ($_[0] =~ /^\*\s+(\d+).*RFC822.SIZE\s+(\d+)/i) {
                            $list{$1} = $2;
                        }
                       },
    );
}

=pod

=item get

  my $message = $imap->get( $message_number );
  print for @{$message};

This method fetches a message and returns its lines in a list reference.
On failure, nothing is returned and the errstr() error handler is set with the error message.

=cut

sub get {
    my ( $self, $number ) = @_;

    my @lines;
    $self->_process_cmd(
        cmd     => [FETCH => qq[$number rfc822]],
        final   => sub { pop @lines; \@lines },
        process => sub {
		if($_[0] !~ /^\* \d+ FETCH/){
			push @lines, join(' ', @_);
		}
	},
    );

}

=pod

=item getfh

  my $file = $imap->getfh( $message_number );
  print <$file>;

On success this method returns a file handle pointing to the message
identified by the required parameter. On failure, nothing is returned and the errstr() error handler is set with the error message.

=cut

sub getfh {
    my ( $self, $number ) = @_;
    
    my $file = IO::File->new_tmpfile;
    my $buffer;
    $self->_process_cmd(
        cmd     => [FETCH => qq[$number rfc822]],
        final   => sub { seek $file, 0, 0; $file },
        process => sub {
		if($_[0] !~ /^\* \d+ FETCH/){
                        defined($buffer) and print $file $buffer;
                        $buffer = $_[0];
		}
	},
    );
}

=pod

=item quit

  $imap->quit;

  OR

  $imap->quit(BOOL);

This method logs out of the IMAP server, expunges the selected mailbox,
and closes the connection. No error message will ever be returned from this method.

Optionally if BOOL is TRUE (1) then a hard quit is preformed which closes the socket connection. This hard quit will still issue both EXPUNGE and LOGOUT commands however the response is ignored and the socket is closed after issuing the commands.

=cut

sub quit {
 my ( $self, $hq ) = @_;
 $self->_send_cmd('EXPUNGE');

 if(!$hq){   
	$self->_process_cmd(cmd => ['LOGOUT'], final => sub {}, process => sub{});
 } else {
	$self->_send_cmd('LOGOUT');
 }

 $self->_sock->close;
 return 1;
}    

=pod

=item last

  my $message_number = $imap->last;

This method retuns the message number of the last message in the selected
mailbox, since the last time the mailbox was selected. On failure, nothing
is returned and the errstr() error handler is set with the error message.

=cut

sub last { shift->_last }

=pod

=item delete

  print "Gone!" if $imap->delete( $message_number );

This method deletes a message from the selected mailbox. On success it
returns true. False on failure and the errstr() error handler is set with the error message.

=cut

sub delete {
    my ( $self, $number ) = @_;
    
    $self->_process_cmd(
        cmd     => [STORE => qq[$number +FLAGS (\\Deleted)]],
        final   => sub { 1 },
        process => sub { },
    );
}

sub _process_list {
    my ($self, $line) = @_;
    $self->_debug(caller, __LINE__, '_process_list', $line) if $self->{debug};

    my @list;
    if ( $line =~ /^\*\s+(LIST|LSUB).*\s+\{\d+\}\s*$/i ) {
        chomp( my $res = $self->_sock->getline );
        $res =~ s/\r//;
        _escape($res);
        push @list, $res;

	$self->_debug(caller, __LINE__, '_process_list', $res) if $self->{debug};
    } elsif ( $line =~ /^\*\s+(LIST|LSUB).*\s+(\".*?\")\s*$/i ||
              $line =~ /^\*\s+(LIST|LSUB).*\s+(\S+)\s*$/i ) {
        push @list, $2;
    }
    @list;
}

=pod

=item mailboxes

  my @boxes   = $imap->mailboxes;
  my @folders = $imap->mailboxes("Mail/%");
  my @lists   = $imap->mailboxes("lists/perl/*", "/Mail/");

This method returns a list of mailboxes. When called with no arguments it
recurses from the IMAP root to get all mailboxes. The first optional
argument is a mailbox path and the second is the path reference. RFC 3501
section 6.3.8 has more information.

On failure nothing is returned and the errstr() error handler is set with the error message.

=cut

sub mailboxes {
    my ( $self, $box, $ref ) = @_;
    
    $ref ||= '""';
    my @list;
    if ( ! defined $box ) {
        # recurse, should probably follow
        # RFC 2683: 3.2.1.1.  Listing Mailboxes
        return $self->_process_cmd(
            cmd     => [LIST => qq[$ref *]],
            final   => sub { _unescape($_) for @list; @list },
            process => sub { push @list, $self->_process_list($_[0]);},
        );
    } else {
        return $self->_process_cmd(
            cmd     => [LIST => qq[$ref $box]],
            final   => sub { _unescape($_) for @list; @list },
            process => sub { push @list, $self->_process_list($_[0]) },
        );
    }
}

=pod

=item mailboxes_subscribed

  my @boxes   = $imap->mailboxes_subscribed;
  my @folders = $imap->mailboxes_subscribed("Mail/%");
  my @lists   = $imap->mailboxes_subscribed("lists/perl/*", "/Mail/");

This method returns a list of mailboxes subscribed to. When called with no
arguments it recurses from the IMAP root to get all mailboxes. The first optional
argument is a mailbox path and the second is the path reference. RFC 3501
has more information.

On failure nothing is returned and the errstr() error handler is set with the error message.

=cut

sub mailboxes_subscribed {
    my ( $self, $box, $ref ) = @_;
    
    $ref ||= '""';
    my @list;
    if ( ! defined $box ) {
        # recurse, should probably follow
        # RFC 2683: 3.2.2.  Subscriptions
        return $self->_process_cmd(
            cmd     => [LSUB => qq[$ref *]],
            final   => sub { _unescape($_) for @list; @list },
            process => sub { push @list, $self->_process_list($_[0]) },
        );
    } else {
        return $self->_process_cmd(
            cmd     => [LSUB => qq[$ref $box]],
            final   => sub { _unescape($_) for @list; @list },
            process => sub { push @list, $self->_process_list($_[0]) },
        );
    }
}

=pod

=item create_mailbox

  print "Created" if $imap->create_mailbox( "/Mail/lists/perl/advocacy" );

This method creates the mailbox named in the required argument. Returns true
on success, false on failure and the errstr() error handler is set with the error message.

=cut

sub create_mailbox {
    my ( $self, $box ) = @_;
    _escape( $box );
    
    return $self->_process_cmd(
        cmd     => [CREATE => $box],
        final   => sub { 1 },
        process => sub { },
    );
}

=pod

=item expunge_mailbox

  print "Expunged" if $imap->expunge_mailbox( "/Mail/lists/perl/advocacy" );

This method removes all mail marked as deleted in the mailbox named in
the required argument. Returns true on success, false on failure and the errstr() error handler is set with the error message.

=cut

sub expunge_mailbox {
 my ($self, $box) = @_;
 return if !$self->select($box);

 return $self->_process_cmd(
	cmd     => ['EXPUNGE'],
	final   => sub { 1 },
	process => sub { },
 );
}

=pod

=item delete_mailbox

  print "Deleted" if $imap->delete_mailbox( "/Mail/lists/perl/advocacy" );

This method deletes the mailbox named in the required argument. Returns true
on success, false on failure and the errstr() error handler is set with the error message.

=cut

sub delete_mailbox {
    my ( $self, $box ) = @_;
    _escape( $box );
    
    return $self->_process_cmd(
        cmd     => [DELETE => $box],
        final   => sub { 1 },
        process => sub { },
    );
}

=pod

=item rename_mailbox

  print "Renamed" if $imap->rename_mailbox( $old => $new );

This method renames the mailbox in the first required argument to the
mailbox named in the second required argument. Returns true on success,
false on failure and the errstr() error handler is set with the error message.

=cut

sub rename_mailbox {
    my ( $self, $old_box, $new_box ) = @_;
    _escape( $old_box );
    _escape( $new_box );
    
    return $self->_process_cmd(
        cmd     => [RENAME => qq[$old_box $new_box]],
        final   => sub { 1 },
        process => sub { },
    );
}

=pod

=item folder_subscribe

  print "Subscribed" if $imap->folder_subscribe( "/Mail/lists/perl/advocacy" );

This method subscribes to the folder. Returns true on success, false on failure
and the errstr() error handler is set with the error message.

=cut

sub folder_subscribe {
 my ($self, $box) = @_;
 $self->select($box); # XXX does it matter if this fails?
 _escape($box);
 
 return $self->_process_cmd(
        cmd     => [SUBSCRIBE => $box],
        final   => sub { 1 },
        process => sub { },
 );
}

=pod

=item folder_unsubscribe

  print "Unsubscribed" if $imap->folder_unsubscribe( "/Mail/lists/perl/advocacy" );

This method unsubscribes to the folder. Returns true on success, false on failure
and the errstr() error handler is set with the error message.

=cut

sub folder_unsubscribe {
 my ($self, $box) = @_;
 $self->select($box);
 _escape($box);
 
 return $self->_process_cmd(
        cmd     => [UNSUBSCRIBE => $box],
        final   => sub { 1 },
        process => sub { },
 );
}

=pod

=item copy

  print "copied" if $imap->copy( $message_number, $mailbox );

This method copies the message number in the currently seleted mailbox to
the fold specified in the second argument. Both arguments are required. On
success this method returns true. Returns false on failure and the errstr() error handler is set with the error message.

=cut

sub copy {
    my ( $self, $number, $box ) = @_;
    _escape( $box );
    
    return $self->_process_cmd(
        cmd     => [COPY => qq[$number $box]],
        final   => sub { 1 },
        process => sub { },
    );
}

=pod

=item errstr

 print "Login ERROR: " . $imap->errstr . "\n" if !$imap->login($user, $pass);

Return the last error string captured for the last operation which failed.

=cut

sub errstr {
 return $_[0]->{_errstr};
}

sub _nextid       { ++$_[0]->{count}   }

sub _escape {
    $_[0] =~ s/\\/\\\\/g;
    $_[0] =~ s/\"/\\\"/g;
    $_[0] = "\"$_[0]\"";
}

sub _unescape {
    $_[0] =~ s/^"//g;
    $_[0] =~ s/"$//g;
    $_[0] =~ s/\\\"/\"/g;
    $_[0] =~ s/\\\\/\\/g;
}

sub _send_cmd {
    my ( $self, $name, $value ) = @_;
    my $sock = $self->_sock;
    my $id   = $self->_nextid;
    my $cmd  = "$id $name" . ($value ? " $value" : "") . "\r\n";

    $self->_debug(caller, __LINE__, '_send_cmd', $cmd) if $self->{debug};

    { local $\; print $sock $cmd; }
    return ($sock => $id);
}

sub _cmd_ok {
    my ($self, $res) = @_;
    my $id = $self->_count;

    $self->_debug(caller, __LINE__, '_send_cmd', $res) if $self->{debug};

    if($res =~ /^$id\s+OK/i){
	return 1;
    } elsif($res =~ /^$id\s+(?:NO|BAD)(?:\s+(.+))?/i){
	$self->_seterrstr($1 || 'unknown error');
	return 0;
    } else {
	$self->_seterrstr("warning unknown return string: $res");
	return;
    }
}

sub _read_multiline {
  my ($self, $sock, $count) = @_;
  
  my @lines;
  my $read_so_far = 0;
  while ($read_so_far < $count) {
    push @lines, $sock->getline;
    $read_so_far += length($lines[-1]);
  }
  if($self->{debug}){
	for(my $i = 0; $i < @lines; $i++){
		$self->_debug(caller, __LINE__, '_read_multiline', "[$i] $lines[$i]");
	}
  }

  return @lines;
}

sub _process_cmd {
    my ($self, %args) = @_;
    my ($sock, $id) = $self->_send_cmd(@{$args{cmd}});

    my $res;
    while ( $res = $sock->getline ) {
	$self->_debug(caller, __LINE__, '_process_cmd', $res) if $self->{debug};

        if ( $res =~ /^\*.*\{(\d+)\}$/ ) {
            $args{process}->($res);
            $args{process}->($_) foreach $self->_read_multiline($sock, $1);
        } else {
            my $ok = $self->_cmd_ok($res);
   	    if ( defined($ok) && $ok == 1 ) {
                return $args{final}->($res);
            } elsif ( defined($ok) && ! $ok ) {
                return;
            } else {
		$args{process}->($res);
            }
        }
    }
}

sub _seterrstr {
 my ($self, $err) = @_;
 $self->{_errstr} = $err;
 $self->_debug(caller, __LINE__, '_seterrstr', $err) if $self->{debug};
 return;
}

sub _debug {
 my ($self, $package, $filename, $line, $dline, $routine, $str) = @_;

 $str =~ s/\n/\\n/g;
 $str =~ s/\r/\\r/g;
 $str =~ s/\cM/^M/g;

 $line = "[$package :: $filename :: $line\@$dline -> $routine] $str\n";
 if(ref($self->{debug}) eq 'GLOB'){
#	write($self->{debug}, $line);
 } else {
	print STDOUT $line;
 }
}

=pod

=back

=cut

1;

__END__

=head1 AUTHOR

Colin Faber, <F<cfaber@fpsn.net>>.

Casey West, <F<casey@geeknst.com>>.

Joao Fonseca, <F<joao_g_fonseca@yahoo.com>>.

=head1 SEE ALSO

L<Net::IMAP>,
L<perl>,
L<Changes>

=head1 COPYRIGHT

Copyright (c) 2005 Colin Faber.
Copyright (c) 2004 Casey West.
Copyright (c) 1999 Joao Fonseca.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl
itself.

=cut
