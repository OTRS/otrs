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

use Kernel::System::CacheInternal;

use vars qw(@ISA $VERSION);

=head1 NAME

Kernel::System::Valid - valid lib

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Valid;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ValidObject = Kernel::System::Valid->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        EncodeObject => $EncodeObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject EncodeObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Valid',
        TTL  => 60 * 60 * 24 * 20,
    );

    return $Self;
}

=item ValidList()

return a valid list as hash

    my %List = $ValidObject->ValidList();

=cut

sub ValidList {
    my ( $Self, %Param ) = @_;

    # read cache
    my $CacheKey = 'ValidList';
    my $Cache    = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return %{$Cache} if $Cache;

    # get list from database
    return if !$Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM valid' );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Data
    );

    return %Data;
}

=item ValidLookup()

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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Valid or ValidID!'
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No $Key for $Value found!",
        );
        return;
    }

    return $ReturnData;
}

=item ValidIDsGet()

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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

=cut
