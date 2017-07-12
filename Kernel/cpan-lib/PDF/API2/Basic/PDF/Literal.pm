# Literal PDF Object for Dirty Hacks ...
package PDF::API2::Basic::PDF::Literal;

use base 'PDF::API2::Basic::PDF::Objind';

use strict;

our $VERSION = '2.033'; # VERSION

use PDF::API2::Basic::PDF::Filter;
use PDF::API2::Basic::PDF::Name;
use Scalar::Util qw(blessed);

no warnings qw[ deprecated recursion uninitialized ];

sub new
{
    my ($class, @opts) = @_;
    my ($self);

    $class = ref $class if ref $class;
    $self = $class->SUPER::new(@_);
    $self->{' realised'} = 1;
    if(scalar @opts > 1) {
        $self->{-isdict}=1;
        my %opt=@opts;
        foreach my $k (keys %opt) {
            $self->{$k} = $opt{$k};
        }
    } elsif(scalar @opts == 1) {
        $self->{-literal}=$opts[0];
    }
    return $self;
}

sub outobjdeep
{
    my ($self, $fh, $pdf, %opts) = @_;
    if($self->{-isdict})
    {
        if(defined $self->{' stream'})
        {
            $self->{Length} = length($self->{' stream'}) + 1;
        }
        else
        {
            delete $self->{Length};
        }
        $fh->print("<< ");
        foreach my $k (sort keys %{$self})
        {
            next if($k=~m|^[ \-]|o);
            $fh->print('/'.PDF::API2::Basic::PDF::Name::string_to_name($k).' ');
            if(ref($self->{$k}) eq 'ARRAY')
            {
                $fh->print('['.join(' ',@{$self->{$k}})."]\n");
            }
            elsif(ref($self->{$k}) eq 'HASH')
            {
                $fh->print('<<'.join(' ', map { '/'.PDF::API2::Basic::PDF::Name::string_to_name($_).' '.$self->{$k}->{$_} } sort keys %{$self->{$k}})." >>\n");
            }
            elsif(blessed($self->{$k}) and $self->{$k}->can('outobj'))
            {
                $self->{$k}->outobj($fh, $pdf, %opts);
                $fh->print("\n");
            }
            else
            {
                $fh->print("$self->{$k}\n");
            }
        }
        $fh->print(">>\n");
        if(defined $self->{' stream'})
        {
            $fh->print("stream\n$self->{' stream'}\nendstream"); # next is endobj which has the final cr
        }
    }
    else
    {
        $fh->print($self->{-literal}); # next is endobj which has the final cr
    }
}

sub val
{ $_[0]; }

1;
