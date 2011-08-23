# --
# Kernel/System/DynamicField.pm - DynamicFields configuration backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicField.pm,v 1.19 2011-08-23 02:45:41 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField;

use strict;
use warnings;

use YAML;
use Kernel::System::Valid;
use Kernel::System::CacheInternal;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Cache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

=head1 NAME

Kernel::System::DynamicField

=head1 SYNOPSIS

DynamicFields backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a DynamicField object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::DynamicField;

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
    my $DynamicFieldObject = Kernel::System::DynamicField->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        DBObject            => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject DBObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('DynamicField::CacheTTL') || 3600 );
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'DynamicField',
        TTL  => $Self->{CacheTTL},
    );

    return $Self;
}

=item DynamicFieldAdd()

add new Dynamic Field config

returns id of new Dynamic field if successful or undef otherwise

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        Name        => 'NameForField',  # mandatory
        Label       => 'a description', # mandatory, label to show
        FieldOrder  => 123,             # mandatory, display order
        FieldType   => 'Text',          # mandatory, selects the DF backend to use for this field
        ObjectType  => 'Article',       # this controls which object the dynamic field links to
                                        # allow only lowercase letters
        Config      => $ConfigHashRef,  # it is stored on YAML format
                                        # to individual articles, otherwise to tickets
        ValidID     => 1,
        UserID      => 123,
    );

Returns:

    $ID = 567;

=cut

sub DynamicFieldAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Name Label FieldOrder FieldType ObjectType Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check needed structure for some fields
    if ( $Param{Name} !~ m{ \A [a-z|\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid letters on Name:$Param{Name}!"
        );
        return;
    }

    if ( $Param{FieldOrder} !~ m{ \A [\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid number on FieldOrder:$Param{FieldOrder}!"
        );
        return;
    }

    # dump config as string
    my $Config = YAML::Dump( $Param{Config} );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO dynamic_field (name, label, field_Order, field_type, object_type,' .
            'config, valid_id, create_time, create_by, change_time, change_by)' .
            ' VALUES (?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Label}, \$Param{FieldOrder}, \$Param{FieldType},
            \$Param{ObjectType}, \$Config, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    my $DynamicField = $Self->DynamicFieldGet(
        Name => $Param{Name},
    );

    # return ; if no $DynamicField->{ID}
    return if !$DynamicField->{ID};

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    # TODO Reindex order on all dynamic fields

    return $DynamicField->{ID};
}

=item DynamicFieldGet()

get Dynamic Field attributes

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID   => 123,             # ID or Name must be provided
        Name => 'DynamicField',
    );

Returns:

    $DynamicField = {
        ID          => 123,
        Name        => 'NameForField',
        Label       => 'The label to show',
        FieldOrder  => 123,
        FieldType   => 'Text',
        ObjectType  => 'Article',
        Config      => $ConfigHashRef,
        ValidID     => 1,
        CreateTime  => '2011-02-08 15:08:00',
        ChangeTime  => '2011-06-11 17:22:00',
    };

=cut

sub DynamicFieldGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID or Name!' );
        return;
    }

    # check cache
    my $CacheKey;

    if ( $Param{ID} ) {
        $CacheKey = 'DynamicFieldGet::ID::' . $Param{ID};
    }
    else {
        $CacheKey = 'DynamicFieldGet::Name::' . $Param{Name};

    }
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    # get data from cache
    if ($Cache) {
        return $Cache;
    }

    my %Data;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, name, label, field_order, field_type, object_type, config,' .
                ' valid_id, create_time, change_time ' .
                'FROM dynamic_field WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, name, label, field_order, field_type, object_type, config,' .
                ' valid_id, create_time, change_time ' .
                'FROM dynamic_field WHERE name = ?',
            Bind => [ \$Param{Name} ],
        );
    }

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my $Config = YAML::Load( $Data[6] );

        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            Label      => $Data[2],
            FieldOrder => $Data[3],
            FieldType  => $Data[4],
            ObjectType => $Data[5],
            Config     => $Config,
            ValidID    => $Data[7],
            CreateTime => $Data[8],
            ChangeTime => $Data[9],
        );
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'DynamicField',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $Self->{CacheTTL},
    );

    return \%Data;
}

=item DynamicFieldUpdate()

update Dynamic Field content into database

returns 1 on success or undef on error

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        ID          => 1234,            # mandatory
        Name        => 'NameForField',  # mandatory
        Label       => 'a description', # mandatory, label to show
        FieldOrder  => 123,             # mandatory, display order
        FieldType   => 'Text',          # mandatory, selects the DF backend to use for this field
        ObjectType  => 'Article',       # this controls which object the dynamic field links to
                                        # allow only lowercase letters
        Config      => $ConfigHashRef,  # it is stored on YAML format
                                        # to individual articles, otherwise to tickets
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub DynamicFieldUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID Name Label FieldOrder FieldType ObjectType Config ValidID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # dump config as string
    my $Config = YAML::Dump( $Param{Config} );

    # check needed structure for some fields
    if ( $Param{Name} !~ m{ \A [a-z|\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid letters on Name:$Param{Name} or ObjectType:$Param{ObjectType}!"
        );
        return;
    }

    if ( $Param{FieldOrder} !~ m{ \A [\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid number on FieldOrder:$Param{FieldOrder}!"
        );
        return;
    }

    # TODO get the current unmodified record
    # TODO compare the order from the current to the updated

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE dynamic_field SET name = ?, label = ?, field_order =?, field_type = ?, '
            . 'object_type = ?, config = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Label}, \$Param{ObjectType}, \$Param{FieldType},
            \$Param{ObjectType}, \$Config, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    # TODO if order was changed, Re-index all dynamic fields

    return 1;
}

=item DynamicFieldDelete()

delete a Dynamic field entry

returns 1 if successful or undef otherwise

    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => 123,
        UserID  => 123,
    );

=cut

sub DynamicFieldDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $DynamicField = $Self->DynamicFieldGet(
        ID => $Param{ID},
    );
    return if !IsHashRefWithData($DynamicField);

    # delete Dynamic field
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM dynamic_field WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    return 1;
}

=item DynamicFieldList()

get DynamicField list ordered by the the "Field Order" field in the DB

    my $List = $DynamicFieldObject->DynamicFieldList();

    or

    my $List = $DynamicFieldObject->DynamicFieldList(
        Valid => 0,             # optional, defaults to 1
        ResultType => 'HASH',   # optional, 'ARRAY' or 'HASH', defaults to 'ARRAY'
    );

Returns:

    $List = {
        1 => 'ItemOne',
        2 => 'ItemTwo',
        3 => 'ItemThree',
        4 => 'ItemFour',
    };

    or

    $List = (
        1,
        2,
        3,
        4
    );

=cut

sub DynamicFieldList {
    my ( $Self, %Param ) = @_;

    # check cache
    my $Valid = 1;
    if ( !$Param{Valid} ) {
        $Valid = '0';
    }
    my $CacheKey = 'DynamicFieldList::Valid::' . $Valid;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    my $ResultType = $Param{ResultType} || '';
    $ResultType = ( $ResultType eq 'HASH' ? $ResultType : 'ARRAY' );

    if ( $Cache && $Cache eq $ResultType ) {

        # get data from cache
        return $Cache;
    }

    my $SQL = 'SELECT id, name, field_order FROM dynamic_field';

    if ( !defined $Param{Valid} || $Param{Valid} eq 1 ) {
        $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';
    }
    $SQL .= " order by field_order";

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    if ( $ResultType eq 'HASH' ) {
        my %Data;

        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Data{ $Row[0] } = $Row[1];
        }

        if (%Data) {

            # set cache
            $Self->{CacheObject}->Set(
                Type  => 'DynamicField',
                Key   => $CacheKey,
                Value => \%Data,
                TTL   => $Self->{CacheTTL},
            );
        }

        return \%Data;

    }
    else {

        my @Data;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push @Data, $Row[0];
        }

        if (@Data) {

            # set cache
            $Self->{CacheObject}->Set(
                Type  => 'DynamicField',
                Key   => $CacheKey,
                Value => \@Data,
                TTL   => $Self->{CacheTTL},
            );
        }

        return \@Data;
    }

    return;
}

=item DynamicFieldListGet()

get DynamicField list with complete data ordered by the "Field Order" field in the DB

    my $List = $DynamicFieldObject->DynamicFieldListGet();

    or

    my $List = $DynamicFieldObject->DynamicFieldListGet(
        Valid => 0, # optional, defaults to 1
    );

Returns:

    $List = (
        {
            ID          => 123,
            Name        => 'NameForField',
            Label       => 'The label to show',
            FieldType   => 'Text',
            ObjectType  => 'Article',
            Config      => $ConfigHashRef,
            ValidID     => 1,
            CreateTime  => '2011-02-08 15:08:00',
            ChangeTime  => '2011-06-11 17:22:00',
        },
        {
            ID          => 321,
            Name        => 'FieldName',
            Label       => 'It is not a label',
            FieldType   => 'Text',
            ObjectType  => 'Ticket',
            Config      => $ConfigHashRef,
            ValidID     => 1,
            CreateTime  => '2010-09-11 10:08:00',
            ChangeTime  => '2011-01-01 01:01:01',
        },
        ...
    );

=cut

sub DynamicFieldListGet {
    my ( $Self, %Param ) = @_;

    # check cache
    my $Valid = 1;
    if ( !$Param{Valid} ) {
        $Valid = '0';
    }

    my $CacheKey = 'DynamicFieldListGet::Valid::' . $Valid;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        return $Cache;
    }

    my @Data;
    my $SQL = 'SELECT id, name, field_order FROM dynamic_field';

    if ( !defined $Param{Valid} || $Param{Valid} eq 1 ) {
        $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';
    }
    $SQL .= " order by field_order";

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    my @DynamicFieldIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @DynamicFieldIDs, $Row[0];
    }

    for my $ItemID (@DynamicFieldIDs) {

        my $DynamicField = $Self->DynamicFieldGet(
            ID => $ItemID,
        );
        push @Data, $DynamicField;
    }

    if (@Data) {

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'DynamicField',
            Key   => $CacheKey,
            Value => \@Data,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \@Data;

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

$Revision: 1.19 $ $Date: 2011-08-23 02:45:41 $

=cut
