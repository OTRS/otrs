package Sisimai::Mail::STDIN;
use feature ':5.10';
use strict;
use warnings;
use Class::Accessor::Lite;
use IO::Handle;

my $roaccessors = [
    'path',     # [String]  Path to mbox
    'name',     # [String]  File name of the mbox
    'size',     # [Integer] File size of the mbox
];
my $rwaccessors = [
    'offset',   # [Integer]  Offset position for seeking
    'handle',   # [IO::File] File handle
];
Class::Accessor::Lite->mk_accessors(@$rwaccessors);
Class::Accessor::Lite->mk_ro_accessors(@$roaccessors);

sub new {
    # Constructor of Sisimai::Mail::STDIN
    # @return   [Sisimai::Mail::STDIN] Object
    my $class = shift;
    my $param = { 
        'path'   => '<STDIN>',
        'name'   => '<STDIN>',
        'size'   => undef,
        'offset' => 0,
        'handle' => IO::Handle->new->fdopen(fileno(STDIN), 'r'),
    };
    return bless($param, __PACKAGE__);
}

sub read {
    # Mbox reader, works as a iterator.
    # @return   [String] Contents of mbox
    my $self = shift;
    return undef unless -T $self->{'handle'};

    my $readhandle = $self->{'handle'};
    my $readbuffer = '';
    eval {
        $readhandle = $self->{'handle'}->fdopen(fileno(STDIN), 'r') unless eof $readhandle;

        while( my $r = <$readhandle> ) {
            # Read an email from the mailbox file
            last if( $readbuffer && substr($r, 0, 5) eq 'From ' );
            $readbuffer .= $r;
        }
    };
    return $readbuffer;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::Mail::STDIN - Mailbox reader

=head1 SYNOPSIS

    use Sisimai::Mail::STDIN;
    my $mailbox = Sisimai::Mail::STDIN->new();
    while( my $r = $mailbox->read ) {
        print $r;   # print data read from STDIN
    }
    $mailbox->close;

=head1 DESCRIPTION

Sisimai::Mail::STDIN read email data from STDIN.

=head1 CLASS METHODS

=head2 C<B<new()>>

C<new()> is a constructor of Sisimai::Mail::STDIN

    my $mailbox = Sisimai::Mail::STDIN->new();

=head1 INSTANCE METHODS

=head2 C<B<path()>>

C<path()> returns "<STDIN>"

    print $mailbox->path;   # "<STDIN>"

=head2 C<B<name()>>

C<name()> returns "<STDIN>"

    print $mailbox->name;   # "<STDIN>"

=head2 C<B<size()>>

C<size()> returns "undef"

    print $mailbox->size;   # undef

=head2 C<B<offset()>>

C<offset()> returns offset position for seeking the mbox. The value of "offset"
is bytes which have already read.

    print $mailbox->offset;   # 0

=head2 C<B<handle()>>

C<handle()> returns file handle object (IO::Handle) of the mbox.

    $mailbox->handle->close;

=head2 C<B<read()>>

C<read()> works as a iterator for reading each email in the mbox.

    my $mailbox = Sisimai::Mail->new();
    while( my $r = $mailbox->read ) {
        print $r;   # print data read from STDIN
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

