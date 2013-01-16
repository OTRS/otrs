# --
# Kernel/System/YAML.pm - YAML wrapper
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# $Id: YAML.pm,v 1.3 2013-01-16 09:02:28 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::YAML;

use strict;
use warnings;

use YAML::Any qw();
use Encode qw();

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::System::YAML - YAML wrapper functions

=head1 SYNOPSIS

Call this module directly without instantiating.

=over 4

=cut

sub Dump {
    my $Result = YAML::Any::Dump(@_);

    # Make sure the resulting string has the UTF-8 flag.
    Encode::_utf8_on($Result);

    return $Result;
}

sub Load {
    my $Result = eval {
        if ( Encode::is_utf8( $_[0] ) ) {
            Encode::_utf8_off( $_[0] );
        }
        YAML::Any::Load(@_);
    };

    _AddUTF8Flag( \$Result ) if defined $Result;

    return $Result;
}

=item _AddUTF8Flag()

adds the UTF8 flag to all elements in a complex data structure.

=cut

sub _AddUTF8Flag {
    my ($Data) = @_;

    if ( !ref ${$Data} ) {
        Encode::_utf8_on( ${$Data} );
        return;
    }

    if ( ref ${$Data} eq 'SCALAR' ) {
        return _AddUTF8Flag( ${$Data} );
    }

    if ( ref ${$Data} eq 'HASH' ) {
        KEY:
        for my $Key ( sort keys %{ ${$Data} } ) {
            next KEY if !defined ${$Data}->{$Key};
            _AddUTF8Flag( \${$Data}->{$Key} );
        }
        return;
    }

    if ( ref ${$Data} eq 'ARRAY' ) {
        KEY:
        for my $Key ( 0 .. $#{ ${$Data} } ) {
            next KEY if !defined ${$Data}->[$Key];
            _AddUTF8Flag( \${$Data}->[$Key] );
        }
        return;
    }

    if ( ref ${$Data} eq 'REF' ) {
        return _AddUTF8Flag( ${$Data} );
    }

    #$Self->{LogObject}->Log(
    #    Priority => 'error',
    #    Message  => "Unknown ref '" . ref( ${$Data} ) . "'!",
    #);

    return;
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

$Revision: 1.3 $ $Date: 2013-01-16 09:02:28 $

=cut
