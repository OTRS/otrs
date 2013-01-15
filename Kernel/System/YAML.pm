# --
# Kernel/System/YAML.pm - YAML wrapper
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# $Id: YAML.pm,v 1.1 2013-01-15 17:43:26 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::YAML;

use strict;
use warnings;

use YAML::Any qw();

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::YAML - YAML wrapper functions

=head1 SYNOPSIS

Call this module directly without instantiating.

=over 4

=cut

sub Dump {
    my $Result = YAML::Any::Dump(@_);

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Result);

    return $Result;
}

sub Load {
    my $Result = eval {
        YAML::Any::Load(@_);
    };

    return $Result;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2013-01-15 17:43:26 $

=cut
