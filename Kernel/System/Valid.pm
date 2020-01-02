# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Valid;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Valid - valid lib

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'Valid';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 ValidList()

return a valid list as hash

    my %List = $ValidObject->ValidList();

=cut

sub ValidList {
    my ( $Self, %Param ) = @_;

    # read cache
    my $CacheKey = 'ValidList';
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get list from database
    return if !$DBObject->Prepare( SQL => 'SELECT id, name FROM valid' );

    # fetch the result
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data
    );

    return %Data;
}

=head2 ValidLookup()

returns the id or the name of a valid

    my $ValidID = $ValidObject->ValidLookup(
        Valid => 'valid',
    );

    my $Valid = $ValidObject->ValidLookup(
        ValidID => 1,
    );

=cut

sub ValidLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Valid} && !$Param{ValidID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Valid or ValidID!',
        );
        return;
    }

    # get (already cached) valid list
    my %ValidList = $Self->ValidList();

    my $Key;
    my $Value;
    my $ReturnData;
    if ( $Param{ValidID} ) {
        $Key        = 'ValidID';
        $Value      = $Param{ValidID};
        $ReturnData = $ValidList{ $Param{ValidID} };
    }
    else {
        $Key   = 'Valid';
        $Value = $Param{Valid};
        my %ValidListReverse = reverse %ValidList;
        $ReturnData = $ValidListReverse{ $Param{Valid} };
    }

    # check if data exists
    if ( !defined $ReturnData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No $Key for $Value found!",
        );
        return;
    }

    return $ReturnData;
}

=head2 ValidIDsGet()

return all valid ids as array

    my @List = $ValidObject->ValidIDsGet();

=cut

sub ValidIDsGet {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Self->ValidLookup(
        Valid => 'valid',
    );

    return if !$ValidID;
    return ($ValidID);
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
