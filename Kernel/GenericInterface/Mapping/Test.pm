# --
# Kernel/GenericInterface/Mapping/Test.pm - GenericInterface test data mapping backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.5 2011-02-08 15:17:19 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::Test;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

=head1 NAME

Kernel::GenericInterface::Mapping::Test

=head1 SYNOPSIS

GenericInterface test data mapping backend

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MainObject MappingConfig)) {
        return { ErrorMessage => "Got no $Needed!" } if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    return { ErrorMessage => 'MappingConfig is no hash reference!' }
        if ref $Self->{MappingConfig} ne 'HASH';
    return { ErrorMessage => 'Config param in MappingConfig is no hash reference!' }
        if ref $Self->{MappingConfig}->{Config} ne 'HASH';

    return $Self;
}

sub Map {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( ref $Param{Data} ne 'HASH' ) {
        return {
            Success      => 0,
            ErrorMessage => 'Data is not a hash reference!',
        };
    }
    if ( !%{ $Param{Data} } ) {
        return {
            Success      => 0,
            ErrorMessage => 'Got no Data!',
        };
    }

    if (
        $Self->{MappingConfig}->{Config}->{TestOption}
        && ref $Self->{MappingConfig}->{Config}->{TestOption}
        )
    {
        return {
            Success      => 0,
            ErrorMessage => 'Config param TestOption is not a string!',
        };
    }

    # just return the input data if we have no test instructions otherwise
    if ( !%{ $Self->{MappingConfig}->{Config}->{TestOption} } ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # parse data according to configuration
    my $ReturnData = {};
    if ( $Self->{MappingConfig}->{Config}->{TestOption} eq 'ToUpper' ) {
        $ReturnData = $Self->_ToUpper( Data => $Param{Data} );
    }
    elsif ( $Self->{MappingConfig}->{Config}->{TestOption} eq 'ToLower' ) {
        $ReturnData = $Self->_ToLower( Data => $Param{Data} );
    }
    elsif ( $Self->{MappingConfig}->{Config}->{TestOption} eq 'Empty' ) {
        $ReturnData = $Self->_Empty( Data => $Param{Data} );
    }
    else {
        $ReturnData = $Param{Data};
    }

    # return result
    my $Return = {
        Success => 1,
        Data    => $ReturnData,
    };
    return $Return;
}

sub _ToUpper {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = uc $Param{Data}->{$Key};
    }

    return $ReturnData;
}

sub _ToLower {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = lc $Param{Data}->{$Key};
    }

    return $ReturnData;
}

sub _Empty {
    my ( $Self, %Param ) = @_;

    my $ReturnData = {};
    for my $Key ( keys %{ $Param{Data} } ) {
        $ReturnData->{$Key} = '';
    }

    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.5 $ $Date: 2011-02-08 15:17:19 $

=cut
