# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::PostMaster::Filter

=head1 DESCRIPTION

All postmaster database filters

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $PMFilterObject = $Kernel::OM->Get('Kernel::System::PostMaster::Filter');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 FilterList()

get all filter

    my %FilterList = $PMFilterObject->FilterList();

=cut

sub FilterList {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT f_name FROM postmaster_filter',
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[0];
    }

    return %Data;
}

=head2 FilterAdd()

add a filter

    $PMFilterObject->FilterAdd(
        Name           => 'some name',
        StopAfterMatch => 0,
        Match = {
            From => 'email@example.com',
            Subject => '^ADV: 123',
        },
        Set {
            'X-OTRS-Queue' => 'Some::Queue',
        },
    );

=cut

sub FilterAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name StopAfterMatch Match Set)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %Not = %{ $Param{Not} || {} };

    for my $Type (qw(Match Set)) {

        my %Data = %{ $Param{$Type} };

        for my $Key ( sort keys %Data ) {

            return if !$DBObject->Do(
                SQL =>
                    'INSERT INTO postmaster_filter (f_name, f_stop, f_type, f_key, f_value, f_not)'
                    . ' VALUES (?, ?, ?, ?, ?, ?)',
                Bind => [
                    \$Param{Name}, \$Param{StopAfterMatch}, \$Type,
                    \$Key, \$Data{$Key}, \$Not{$Key}
                ],
            );
        }
    }

    return 1;
}

=head2 FilterDelete()

delete a filter

    $PMFilterObject->FilterDelete(
        Name => '123',
    );

=cut

sub FilterDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL  => 'DELETE FROM postmaster_filter WHERE f_name = ?',
        Bind => [ \$Param{Name} ],
    );

    return 1;
}

=head2 FilterGet()

get filter properties, returns HASH ref Match and Set

    my %Data = $PMFilterObject->FilterGet(
        Name => '132',
    );

=cut

sub FilterGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL =>
            'SELECT f_type, f_key, f_value, f_name, f_stop, f_not FROM postmaster_filter WHERE f_name = ?',
        Bind => [ \$Param{Name} ],
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] }->{ $Row[1] } = $Row[2];
        $Data{Name}                   = $Row[3];
        $Data{StopAfterMatch}         = $Row[4];

        if ( $Row[0] eq 'Match' ) {
            $Data{Not}->{ $Row[1] } = $Row[5];
        }
    }

    return %Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
