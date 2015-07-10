# this is a back compatibility wrapper around File::Temp. DO NOT
# use this package outside of CGI, i won't provide any help if
# you use it directly and your code breaks horribly.
package CGI::File::Temp;

$CGI::File::Temp::VERSION = '4.21';

use parent File::Temp;
use parent Fh;

use overload
    '""'  => \&asString,
    'cmp' => \&compare,
    'fallback'=>1;

# back compatibility method since we now return a File::Temp object
# as the filehandle (which isa IO::Handle) so calling ->handle on
# it will fail. FIXME: deprecate this method in v5+
sub handle { return shift; };

sub compare {
    my ( $self,$value ) = @_;
    return "$self" cmp $value;
}

sub _mp_filename {
	my ( $self,$filename ) = @_;
	${*$self}->{ _mp_filename } = $filename
		if $filename;
	return ${*$self}->{_mp_filename};
}

sub asString {
    my ( $self ) = @_;
	return $self->_mp_filename;
}

1;

