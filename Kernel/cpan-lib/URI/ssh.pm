package URI::ssh;
require URI::_login;
@ISA=qw(URI::_login);

# ssh://[USER@]HOST[:PORT]/SRC

sub default_port { 22 }

sub secure { 1 }

1;
