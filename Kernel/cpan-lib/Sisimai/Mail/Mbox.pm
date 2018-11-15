package Sisimai::Mail::Mbox;
use feature ':5.10';
use strict;
use warnings;
use Class::Accessor::Lite;
use File::Basename qw(basename dirname);
use IO::File;

my $roaccessors = [
    'dir',      # [String]  Directory name of the mbox
    'file',     # [String]  File name of the mbox
    'path',     # [String]  Path to mbox
    'size',     # [Integer] File size of the mbox
];
my $rwaccessors = [
    'offset',   # [Integer]  Offset position for seeking
    'handle',   # [IO::File] File handle
];
Class::Accessor::Lite->mk_accessors(@$rwaccessors);
Class::Accessor::Lite->mk_ro_accessors(@$roaccessors);

sub new {
    # Constructor of Sisimai::Mail::Mbox
    # @param    [String] argv1          Path to mbox
    # @return   [Sisimai::Mail::Mbox]   Object or Undef if the argument is not 
    #                                   a file or does not exist
    my $class = shift;
    my $argv1 = shift // return undef;
    my $param = { 'offset' => 0 };
    return undef unless -f $argv1;

    $param->{'dir'}    = File::Basename::dirname $argv1;
    $param->{'path'}   = $argv1;
    $param->{'size'}   = -s $argv1;
    $param->{'file'}   = File::Basename::basename $argv1;
    $param->{'handle'} = ref $argv1 ? $argv1 : IO::File->new($argv1, 'r');
    binmode $param->{'handle'};

    return bless($param, __PACKAGE__);
}

sub read {
    # Mbox reader, works as a iterator.
    # @return   [String] Contents of mbox
    my $self = shift;

    my $seekoffset = $self->{'offset'} // 0;
    my $filehandle = $self->{'handle'};
    my $readbuffer = '';

    return undef unless defined $self->{'path'};
    unless( ref $self->{'path'} ) {
        # "path" is not IO::File object
        return undef unless -f $self->{'path'};
        return undef unless -T $self->{'path'};
    }
    return undef unless $self->{'offset'} < $self->{'size'};

    eval {
        $seekoffset = 0 if $seekoffset < 0;
        seek($filehandle, $seekoffset, 0);

        while( my $r = <$filehandle> ) {
            # Read the UNIX mbox file from 'From ' to the next 'From '
            last if( $readbuffer && substr($r, 0, 5) eq 'From ' );
            $readbuffer .= $r;
        }
        $seekoffset += length $readbuffer;
        $self->{'offset'} = $seekoffset;
        $filehandle->close unless $seekoffset < $self->{'size'};
    };
    return $readbuffer;
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::Mail::Mbox - Mailbox reader

=head1 SYNOPSIS

    use Sisimai::Mail::Mbox;
    my $mailbox = Sisimai::Mail::Mbox->new('/var/spool/mail/root');
    while( my $r = $mailbox->read ) {
        print $r;   # print contents of each mail in mbox
    }

=head1 DESCRIPTION

Sisimai::Mail::Mbox is a mailbox file (UNIX mbox) reader.

=head1 CLASS METHODS

=head2 C<B<new(I<path to mbox>)>>

C<new()> is a constructor of Sisimai::Mail::Mbox

    my $mailbox = Sisimai::Mail::Mbox->new('/var/mail/root');

=head1 INSTANCE METHODS

=head2 C<B<dir()>>

C<dir()> returns the directory name of mbox

    print $mailbox->dir;   # /var/mail

=head2 C<B<path()>>

C<path()> returns the path to mbox.

    print $mailbox->path;   # /var/mail/root

=head2 C<B<file()>>

C<file()> returns a file name of the mbox.

    print $mailbox->file;   # root

=head2 C<B<size()>>

C<size()> returns the file size of the mbox.

    print $mailbox->size;   # 94515

=head2 C<B<offset()>>

C<offset()> returns offset position for seeking the mbox. The value of "offset"
is bytes which have already read.

    print $mailbox->offset;   # 0

=head2 C<B<handle()>>

C<handle()> returns file handle object (IO::File) of the mbox.

    $mailbox->handle->close;

=head2 C<B<read()>>

C<read()> works as a iterator for reading each email in the mbox.

    my $mailbox = Sisimai::Mail->new('/var/mail/neko');
    while( my $r = $mailbox->read ) {
        print $r;   # print each email in /var/mail/neko
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
