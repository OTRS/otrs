package URI::tn3270;

use strict;
use warnings;

our $VERSION = "1.69";

use parent 'URI::_login';

sub default_port { 23 }

1;
