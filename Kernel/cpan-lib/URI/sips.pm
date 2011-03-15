package URI::sips;
require URI::sip;
@ISA=qw(URI::sip);

sub default_port { 5061 }

sub secure { 1 }

1;
