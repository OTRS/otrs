package Sisimai::Mail::Memory;
use feature ':5.10';
use strict;
use warnings;
use Class::Accessor::Lite;

my $roaccessors = [
    'size',     # [Integer] data size
];
my $rwaccessors = [
    'data',     # [Array] entire bounce mail message
    'offset',   # [Integer] Index of "data"
];
Class::Accessor::Lite->mk_accessors(@$rwaccessors);
Class::Accessor::Lite->mk_ro_accessors(@$roaccessors);

sub new {
    # Constructor of Sisimai::Mail::Memory
    # @param    [String] argv1          Entire email string
    # @return   [Sisimai::Mail::Memory] Object or Undef if the argument is not 
    #                                   valid email text
    my $class = shift;
    my $argv1 = shift // return undef;
    my $first = substr($$argv1, 0, 5) || '';
    my $param = { 
        'data'   => [],
        'size'   => length $$argv1 || 0,
        'offset' => 0,
    };

    return undef unless $param->{'size'};
    if( $first eq 'From ') {
        # UNIX mbox
        $param->{'data'} = [split(/^From /m, $$argv1)];
        shift @{ $param->{'data'} };
        map { $_ = 'From '.$_ } @{ $param->{'data'} };

    } else {
        $param->{'data'} = [$$argv1];
    }
    return bless($param, __PACKAGE__);
}

sub read {
    # Memory reader, works as a iterator.
    # @return   [String] Contents of a bounce mail
    my $self = shift;
    return undef unless scalar @{ $self->{'data'} };

    $self->{'offset'} += 1;
    return shift @{ $self->{'data'} };
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::Mail::Memory - Mailbox reader

=head1 SYNOPSIS

    use Sisimai::Mail::Memory;
    my $mailtxt = 'From Mailer-Daemon ...';
    my $mailobj = Sisimai::Mail::Memory->new(\$mailtxt);
    while( my $r = $mailobj->read ) {
        print $r;   # print contents of each mail in the mailbox or Maildir/
    }

=head1 DESCRIPTION

Sisimai::Mail::Memory is a class for reading a mailbox, files in Maildir/, or
JSON string from variable.

=head1 CLASS METHODS

=head2 C<B<new(I<\$scalar>)>>

C<new()> is a constructor of Sisimai::Mail::Memory

    my $mailtxt = 'From Mailer-Daemon ...';
    my $mailobj = Sisimai::Mail::Memory->new(\$mailtxt);

=head1 INSTANCE METHODS

=head2 C<B<size()>>

C<size()> returns a memory size of the mailbox or JSON string.

    print $mailobj->size;   # 94515

=head2 C<B<data()>>

C<data()> returns an array reference to each email message or JSON string

    print scalar @{ $mailobj->data };   # 17

=head2 C<B<offset()>>

C<offset()> returns an offset position for seeking "data". The value of "offset"
is an index number which have already read.

    print $mailobj->offset;   # 0

=head2 C<B<read()>>

C<read()> works as a iterator for reading each email in the mailbox.

    my $mailtxt = 'From Mailer-Daemon ...';
    my $mailobj = Sisimai::Mail->new(\$mailtxt);
    while( my $r = $mailobj->read ) {
        print $r;   # print each email in the first argument of new().
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

