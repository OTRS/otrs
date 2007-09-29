# --
# Kernel/System/Salutation.pm - All salutation related function should be here eventually
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Salutation.pm,v 1.2 2007-09-29 11:03:39 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Salutation;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::Salutation - salutation lib

=head1 SYNOPSIS

All salutation functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Salutation;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $SalutationObject = Kernel::System::Salutation->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
        TimeObject => $TimeObject,
    );

=cut

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item SalutationAdd()

add new salutations

    my $ID = $SalutationObject->SalutationAdd(
        Name => 'New Salutation',
        Text => "--\nSome Salutation Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub SalutationAdd {
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    for (qw(Name Text ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # quote params
    for (qw(Name Text Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }
    my $SQL
        = "INSERT INTO salutation (name, text, comments, valid_id, "
        . " create_time, create_by, change_time, change_by)"
        . " VALUES "
        . " ('$Param{Name}', '$Param{Text}', '$Param{Comment}', $Param{ValidID}, "
        . " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {

        # get new salutation id
        my $SQL = "SELECT id FROM salutation WHERE name = '$Param{Name}'";
        my $ID  = '';
        $Self->{DBObject}->Prepare( SQL => $SQL );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }
        return $ID;
    }
    else {
        return;
    }
}

=item SalutationGet()

get salutations attributes

    my %Salutation = $SalutationObject->SalutationGet(
        ID => 123,
    );

=cut

sub SalutationGet {
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # quote params
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "SELECT id, name, text, comments, valid_id, change_time, create_time "
        . " FROM "
        . " salutation "
        . " WHERE "
        . " id = $Param{ID}";
    if ( $Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        my %Data = ();
        while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
            %Data = (
                ID         => $Data[0],
                Name       => $Data[1],
                Text       => $Data[2],
                Comment    => $Data[3],
                ValidID    => $Data[4],
                ChangeTime => $Data[5],
                CreateTime => $Data[6],
            );
        }

        # no data found
        if ( !%Data ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "SalutationType '$Param{Name}' not found!"
            );
        }

        # return data
        return %Data;
    }
    else {
        return;
    }
}

=item SalutationUpdate()

update salutation attributes

    $SalutationObject->SalutationUpdate(
        ID => 123,
        Name => 'New Salutation',
        Text => "--\nSome Salutation Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub SalutationUpdate {
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    for (qw(ID Name Text ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # quote params
    for (qw(Name Text Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "UPDATE salutation SET name = '$Param{Name}', "
        . " text = '$Param{Text}', "
        . " comments = '$Param{Comment}', "
        . " valid_id = $Param{ValidID}, "
        . " change_time = current_timestamp, change_by = $Param{UserID} "
        . " WHERE id = $Param{ID}";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

=item SalutationList()

get salutation list

    my %List = $SalutationObject->SalutationList();

    my %List = $SalutationObject->SalutationList(
        Valid => 0,
    );

=cut

sub SalutationList {
    my $Self  = shift;
    my %Param = @_;
    my $Valid = 1;

    # check needed stuff
    if ( !$Param{Valid} && defined( $Param{Valid} ) ) {
        $Valid = 0;
    }

    # sql
    return $Self->{DBObject}->GetTableData(
        What  => 'id, name',
        Valid => $Valid,
        Clamp => 1,
        Table => 'salutation',
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2007-09-29 11:03:39 $

=cut
