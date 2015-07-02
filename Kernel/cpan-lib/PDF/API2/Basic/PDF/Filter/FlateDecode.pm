package PDF::API2::Basic::PDF::Filter::FlateDecode;

our $VERSION = '2.023'; # VERSION

use base 'PDF::API2::Basic::PDF::Filter';

use strict;
no warnings qw[ deprecated recursion uninitialized ];

our $havezlib;

BEGIN
{
    eval {require "Compress/Zlib.pm";};
    $havezlib = !$@;
}

sub new
{
    return undef unless $havezlib;
    my ($class) = @_;
    my ($self) = {};

    $self->{'outfilt'} = Compress::Zlib::deflateInit(
      -Level=>9,
      -Bufsize=>32768,
    );
    $self->{'infilt'} = Compress::Zlib::inflateInit();
    bless $self, $class;
}

sub outfilt
{
    my ($self, $str, $isend) = @_;
    my ($res);

    $res = $self->{'outfilt'}->deflate($str);
    $res .= $self->{'outfilt'}->flush() if ($isend);
    $res;
}

sub infilt
{
    my ($self, $dat, $last) = @_;
    my ($res, $status) = $self->{'infilt'}->inflate("$dat");
    $res;
}

1;
