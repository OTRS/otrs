# --
# Kernel/System/PostMaster/Filter.pm - all functions to add/delete/list pm db filters
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Filter.pm,v 1.11 2007-10-02 10:34:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::Filter;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

=head1 NAME

Kernel::System::Postmaster::Filter

=head1 SYNOPSIS

All postmaster database filters

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Postmaster::Filter;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $PMFilterObject = Kernel::System::Postmaster::Filter->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item FilterList()

get all filter

    my %FilterList = $PSFilterObject->FilterList();

=cut

sub FilterList {
    my ( $Self, %Param ) = @_;

    my %Data = ();
    my $SQL  = "SELECT f_name FROM postmaster_filter ";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[0];
    }
    return %Data;
}

=item FilterAdd()

add a filter

    $PMFilterObject->FilterAdd(
        Name => 'some name',
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
    for (qw(Name Match Set)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for my $Type ( 'Match', 'Set' ) {
        my %Data = %{ $Param{$Type} };
        for ( keys %Data ) {
            $Data{$_} = $Self->{DBObject}->Quote( $Data{$_} ) || '';
            my $SQL = "INSERT INTO postmaster_filter (f_name, f_type, f_key, f_value) "
                . " VALUES ('$Param{Name}', '$Type', '$_', '$Data{$_}')";
            if ( !$Self->{DBObject}->Do( SQL => $SQL ) ) {
                return;
            }
        }
    }
    return 1;
}

=item FilterDelete()

delete a filter

    $PMFilterObject->FilterDelete(
        Name => '123',
    );

=cut

sub FilterDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Param{Name} = $Self->{DBObject}->Quote( $Param{Name} ) || '';
    if ( $Self->{DBObject}
        ->Prepare( SQL => "DELETE FROM postmaster_filter WHERE f_name = '$Param{Name}'" ) )
    {
        return 1;
    }
    else {
        return;
    }
}

=item FilterGet()

get filter properties, returns HASH ref Match and Set

    my %Data = $PMFilterObject->FilterGet(
        Name => '132',
    );

=cut

sub FilterGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    my %Data = ();
    my $SQL
        = "SELECT f_type, f_key, f_value, f_name FROM postmaster_filter WHERE f_name = '$Param{Name}'";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] }->{ $Row[1] } = $Row[2];
        $Data{Name} = $Row[3];
    }
    return %Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.11 $ $Date: 2007-10-02 10:34:46 $

=cut
