# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::Phone;

use strict;
use warnings;

use parent 'Kernel::System::Ticket::Article::Backend::MIMEBase';

our @ObjectDependencies = ();

=head1 NAME

Kernel::System::Ticket::Article::Backend::Phone - backend class for phone articles

=head1 DESCRIPTION

This class provides functions to manipulate phone articles in the database.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase>, please have a look there for its API.

=cut

sub ChannelNameGet {
    return 'Phone';
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
