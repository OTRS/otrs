# --
# Kernel/System/YAML.pm - YAML wrapper
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

=head1 NAME

Kernel::System::YAML - YAML wrapper functions

=head1 SYNOPSIS

Functions for YAML serialization / deserialization.

=over 4

=cut

=item new()

create a YAML object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::YAML;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );

    my $YAMLObject = Kernel::System::YAML->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject EncodeObject LogObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item Dump()

Dump a perl data structure to a YAML string.

    my $YAMLString = $YAMLObject->Dump(
        Data     => $Data,
    );

=cut

sub Dump {
    my ( $Self, %Param ) = @_;

    # check for needed data
    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    my $Result = YAML::Any::Dump( $Param{Data} ) || "--- ''\n";

    # Make sure the resulting string has the UTF-8 flag.
    Encode::_utf8_on($Result);

    return $Result;
}

=item Load()

Load a YAML string to a perl data structure.
This string must be a encoded in UTF8.

    my $PerlStructureScalar = $YAMLObject->Load(
        Data => $YAMLString,
    );

=cut

sub Load {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return if !defined $Param{Data};

    if ( Encode::is_utf8( $Param{Data} ) ) {
        Encode::_utf8_off( $Param{Data} );
    }

    my $Result;

    if ( !eval { $Result = YAML::Any::Load( $Param{Data} ) } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Loading the YAML string failed: ' . $@,
        );
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'YAML data was: "' . $Param{Data} . '"',
        );
        return;
    }

    # YAML does not set the UTF8 flag on strings that need it,
    #   do that manually now
    if ( defined $Result ) {
        _AddUTF8Flag( \$Result );
    }

    return $Result;
}

=begin Internal:

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
