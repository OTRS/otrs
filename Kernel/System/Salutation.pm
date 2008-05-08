# --
# Kernel/System/Salutation.pm - All salutation related function should be here eventually
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Salutation.pm,v 1.6 2008-05-08 09:36:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Salutation;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::System::Salutation - salutation lib

=head1 SYNOPSIS

All salutation functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Salutation;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject   = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $SalutationObject = Kernel::System::Salutation->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
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
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item SalutationAdd()

add new salutations

    my $ID = $SalutationObject->SalutationAdd(
        Name    => 'New Salutation',
        Text    => "--\nSome Salutation Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub SalutationAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name Text ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO salutation (name, text, comments, valid_id, '
            . ' create_time, create_by, change_time, change_by) VALUES '
            . ' (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Text}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new salutation id
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM salutation WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item SalutationGet()

get salutations attributes

    my %Salutation = $SalutationObject->SalutationGet(
        ID => 123,
    );

=cut

sub SalutationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name, text, comments, valid_id, change_time, create_time '
            . 'FROM salutation WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
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
            Message  => "SalutationID '$Param{ID}' not found!"
        );
        return;
    }

    # return data
    return %Data;
}

=item SalutationUpdate()

update salutation attributes

    $SalutationObject->SalutationUpdate(
        ID      => 123,
        Name    => 'New Salutation',
        Text    => "--\nSome Salutation Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub SalutationUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name Text ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE salutation SET name = ?, text = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Text}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{ID},
        ],
    );
}

=item SalutationList()

get salutation list

    my %List = $SalutationObject->SalutationList();

    my %List = $SalutationObject->SalutationList(
        Valid => 0,
    );

=cut

sub SalutationList {
    my ( $Self, %Param ) = @_;

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
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.6 $ $Date: 2008-05-08 09:36:19 $

=cut
