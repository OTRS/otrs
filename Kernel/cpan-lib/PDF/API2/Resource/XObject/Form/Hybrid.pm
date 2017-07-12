package PDF::API2::Resource::XObject::Form::Hybrid;

use base qw(PDF::API2::Content PDF::API2::Resource::XObject::Form);

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Dict;
use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Resource::XObject::Form;

sub new {
    my $self = PDF::API2::Resource::XObject::Form::new(@_);

    $self->{' stream'} = '';
    $self->{' poststream'} = '';
    $self->{' font'} = undef;
    $self->{' fontsize'} = 0;
    $self->{' charspace'} = 0;
    $self->{' hscale'} = 100;
    $self->{' wordspace'} = 0;
    $self->{' lead'} = 0;
    $self->{' rise'} = 0;
    $self->{' render'} = 0;
    $self->{' matrix'} = [1, 0, 0, 1, 0, 0];
    $self->{' fillcolor'} = [0];
    $self->{' strokecolor'} = [0];
    $self->{' translate'} = [0, 0];
    $self->{' scale'} = [1, 1];
    $self->{' skew'} = [0, 0];
    $self->{' rotate'} = 0;
    $self->{' apiistext'} = 0;

    $self->{'Resources'} = PDFDict();
    $self->{'Resources'}->{'ProcSet'} = PDFArray(map { PDFName($_) } qw(PDF Text ImageB ImageC ImageI));

    $self->compressFlate();

    return $self;
}

sub outobjdeep {
    my ($self, @options) = @_;
    $self->textend() unless $self->{' nofilt'};

    # Maintainer's Note: This list of keys isn't the same as the list
    # in new().  Should it be?
    foreach my $key (qw(api apipdf apipage font fontsize charspace hscale
                        wordspace lead rise render matrix fillcolor
                        strokecolor translate scale skew rotate)) {
        delete $self->{" $key"};
    }
    return PDF::API2::Basic::PDF::Dict::outobjdeep($self, @options);
}

1;
