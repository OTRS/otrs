package Net::IMAP::Simple::PipeSocket;

use strict;
use warnings;
use Carp;
use IPC::Open3;
use IO::Select;
use Symbol 'gensym';
use base 'Tie::Handle';

sub new {
    my $class = shift;
    my %args  = @_;

    croak "command (e.g. 'ssh hostname dovecot') argument required" unless $args{cmd};

    open my $fake, "+>", undef or die "initernal error dealing with blarg: $!"; ## no critic

    my($wtr, $rdr, $err); $err = gensym;
    my $pid = eval { open3($wtr, $rdr, $err, $args{cmd}) } or croak $@;
    my $sel = IO::Select->new($err);

    # my $orig = select $wtr; $|=1;
    # select $rdr; $|=1;
    # select $orig;

    my $this = tie *{$fake}, $class,
        (%args, pid=>$pid, wtr=>$wtr, rdr=>$rdr, err=>$err, sel=>$sel, )
            or croak $!;

    return $fake;
}

sub UNTIE   { return $_[0]->_waitpid }
sub DESTROY { return $_[0]->_waitpid }

sub FILENO {
    my $this = shift;
    my $rdr  = $this->{rdr};

    # do we mean rdr or wtr? meh?
    return fileno($rdr); # probably need this for select() on the read handle
}

sub TIEHANDLE {
    my $class = shift;
    my $this  = bless {@_}, $class;

    return $this;
}

sub _chkerr {
    my $this = shift;
    my $sel = $this->{sel};

    while( my @rdy = $sel->can_read(0) ) {
        for my $fh (@rdy) {
            if( eof($fh) ) {
                $sel->remove($fh);
                next;
            }
            my $line = <$fh>;
            warn "PIPE ERR: $line";
        }
    }

    return
}

sub PRINT {
    my $this = shift;
    my $wtr  = $this->{wtr};

    $this->_chkerr;
    return print $wtr @_;
}

sub READLINE {
    my $this = shift;
    my $rdr  = $this->{rdr};

    $this->_chkerr;
    my $line = <$rdr>;
    return $line;
}

sub _waitpid {
    my $this = shift;

    if( my $pid = delete $this->{pid} ) {
        for my $key (qw(wtr rdr err)) {
            close delete $this->{$key} if exists $this->{$key};
        }

        kill 1, $pid;
        # doesn't really matter if this works... we hung up all the
        # filehandles, so ... it's probably dead anyway.

        waitpid( $pid, 0 );
        my $child_exit_status = $? >> 8;
        return $child_exit_status;
    }

    return;
}

sub CLOSE {
    my $this = shift;
    my $rdr  = $this->{rdr};
    my $wtr  = $this->{wtr};

    close $rdr or warn "PIPE ERR (close-r): $!";
    close $wtr or warn "PIPE ERR (close-w): $!";

    return;
}

1;

__END__

=head1 NAME

Net::IMAP::Simple::PipeSocket - a little wrapper around IPC-Open3 that feels like a socket

=head1 SYNOPSIS

This module is really just a wrapper around IPC-Open3 that can be dropped in
place of a socket handle.  The L<Net::IMAP::Simple> code assumes the socket is
always a socket and is never a pipe and re-writing it all would be horrible.

This abstraction is used only for that purpose.
