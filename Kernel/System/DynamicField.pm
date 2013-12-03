# --
# Kernel/System/DynamicField.pm - DynamicFields configuration backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField;

use strict;
use warnings;

use Kernel::System::YAML;

use Kernel::System::Cache;
use Kernel::System::Valid;
use Kernel::System::VariableCheck qw(:all);

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
    $Self->{YAMLObject}  = Kernel::System::YAML->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL}
        = int( $Self->{ConfigObject}->Get('DynamicField::CacheTTL') || 3600 );

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( $Self->{DBObject}->GetDatabaseFunction('CaseSensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

=item DynamicFieldAdd()

add new Dynamic Field config

returns id of new Dynamic field if successful or undef otherwise

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        InternalField => 0,             # optional, 0 or 1, internal fields are protected
        Name        => 'NameForField',  # mandatory
        Label       => 'a description', # mandatory, label to show
        FieldOrder  => 123,             # mandatory, display order
        FieldType   => 'Text',          # mandatory, selects the DF backend to use for this field
        ObjectType  => 'Article',       # this controls which object the dynamic field links to
                                        # allow only lowercase letters
        Config      => $ConfigHashRef,  # it is stored on YAML format
                                        # to individual articles, otherwise to tickets
        Reorder     => 1,               # or 0, to trigger reorder function, default 1
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
    if ( $Param{Name} !~ m{ \A [a-z|A-Z|\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid letters on Name:$Param{Name}!"
        );
        return;
    }

    # check if Name already exists
    return if !$Self->{DBObject}->Prepare(
        SQL   => "SELECT id FROM dynamic_field WHERE $Self->{Lower}(name) = $Self->{Lower}(?)",
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    my $NameExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $NameExists = 1;
    }

    if ($NameExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The name $Param{Name} already exists for a dynamic field!"
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
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);

    my $InternalField = $Param{InternalField} ? 1 : 0;

    # sql
    return if !$Self->{DBObject}->Do(
        SQL =>
            'INSERT INTO dynamic_field (internal_field, name, label, field_Order, field_type, object_type,'
            .
            ' config, valid_id, create_time, create_by, change_time, change_by)' .
            ' VALUES (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$InternalField, \$Param{Name}, \$Param{Label}, \$Param{FieldOrder}, \$Param{FieldType},
            \$Param{ObjectType}, \$Config, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID}
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicFieldValue',
    );

    my $DynamicField = $Self->DynamicFieldGet(
        Name => $Param{Name},
    );

    return if !$DynamicField->{ID};

    if ( !exists $Param{Reorder} || $Param{Reorder} ) {

        # re-order field list
        $Self->_DynamicFieldReorder(
            ID         => $DynamicField->{ID},
            FieldOrder => $DynamicField->{FieldOrder},
            Mode       => 'Add',
        );
    }

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
        ID            => 123,
        InternalField => 0,
        Name          => 'NameForField',
        Label         => 'The label to show',
        FieldOrder    => 123,
        FieldType     => 'Text',
        ObjectType    => 'Article',
        Config        => $ConfigHashRef,
        ValidID       => 1,
        CreateTime    => '2011-02-08 15:08:00',
        ChangeTime    => '2011-06-11 17:22:00',
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
    return $Cache if $Cache;

    # sql
    if ( $Param{ID} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, internal_field, name, label, field_order, field_type, object_type, config,'
                .
                ' valid_id, create_time, change_time ' .
                'FROM dynamic_field WHERE id = ?',
            Bind => [ \$Param{ID} ],
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL =>
                'SELECT id, internal_field, name, label, field_order, field_type, object_type, config,'
                .
                ' valid_id, create_time, change_time ' .
                'FROM dynamic_field WHERE name = ?',
            Bind => [ \$Param{Name} ],
        );
    }

    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my $Config = $Self->{YAMLObject}->Load( Data => $Data[7] ) || {};

        %Data = (
            ID            => $Data[0],
            InternalField => $Data[1],
            Name          => $Data[2],
            Label         => $Data[3],
            FieldOrder    => $Data[4],
            FieldType     => $Data[5],
            ObjectType    => $Data[6],
            Config        => $Config,
            ValidID       => $Data[8],
            CreateTime    => $Data[9],
            ChangeTime    => $Data[10],
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
        Reorder     => 1,               # or 0, to trigger reorder function, default 1
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

    my $Reorder;
    if ( !exists $Param{Reorder} || $Param{Reorder} eq 1 ) {
        $Reorder = 1;
    }

    # dump config as string
    my $Config = $Self->{YAMLObject}->Dump( Data => $Param{Config} );

    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #    part of the data already had it.
    utf8::upgrade($Config);

    # check needed structure for some fields
    if ( $Param{Name} !~ m{ \A [a-z|A-Z|\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid letters on Name:$Param{Name} or ObjectType:$Param{ObjectType}!",
        );
        return;
    }

    # check if Name already exists
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM dynamic_field "
            . "WHERE $Self->{Lower}(name) = $Self->{Lower}(?) "
            . "AND id != ?",
        Bind => [ \$Param{Name}, \$Param{ID} ],
        LIMIT => 1,
    );

    my $NameExists;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $NameExists = 1;
    }

    if ($NameExists) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The name $Param{Name} already exists for a dynamic field!",
        );
        return;
    }

    if ( $Param{FieldOrder} !~ m{ \A [\d]+ \z }xms ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Not valid number on FieldOrder:$Param{FieldOrder}!",
        );
        return;
    }

    # get the old dynamic field data
    my $DynamicField = $Self->DynamicFieldGet(
        ID => $Param{ID},
    );

    # check if FieldOrder is changed
    my $ChangedOrder;
    if ( $DynamicField->{FieldOrder} ne $Param{FieldOrder} ) {
        $ChangedOrder = 1;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE dynamic_field SET name = ?, label = ?, field_order =?, field_type = ?, '
            . 'object_type = ?, config = ?, valid_id = ?, change_time = current_timestamp, '
            . ' change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Label}, \$Param{FieldOrder}, \$Param{FieldType},
            \$Param{ObjectType}, \$Config, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicFieldValue',
    );

    # re-order field list if a change in the order was made
    if ( $Reorder && $ChangedOrder ) {
        my $Success = $Self->_DynamicFieldReorder(
            ID            => $Param{ID},
            FieldOrder    => $Param{FieldOrder},
            Mode          => 'Update',
            OldFieldOrder => $DynamicField->{FieldOrder},
        );
    }

    return 1;
}

=item DynamicFieldDelete()

delete a Dynamic field entry. You need to make sure that all values are
deleted before calling this function, otherwise it will fail on DBMS which check
referential integrity.

returns 1 if successful or undef otherwise

    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => 123,
        UserID  => 123,
        Reorder => 1,               # or 0, to trigger reorder function, default 1
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

    # re-order before delete
    if ( !exists $Param{Reorder} || $Param{Reorder} ) {
        my $Success = $Self->_DynamicFieldReorder(
            ID         => $DynamicField->{ID},
            FieldOrder => $DynamicField->{FieldOrder},
            Mode       => 'Delete',
        );
    }

    # delete dynamic field
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM dynamic_field WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicFieldValue',
    );

    return 1;
}

=item DynamicFieldList()

get DynamicField list ordered by the the "Field Order" field in the DB

    my $List = $DynamicFieldObject->DynamicFieldList();

    or

    my $List = $DynamicFieldObject->DynamicFieldList(
        Valid => 0,             # optional, defaults to 1

        # object  type (optional) as STRING or as ARRAYREF
        ObjectType => 'Ticket',
        ObjectType => ['Ticket', 'Article'],

        ResultType => 'HASH',   # optional, 'ARRAY' or 'HASH', defaults to 'ARRAY'

        FieldFilter => {        # optional, only active fields (non 0) will be returned
            ItemOne   => 1,
            ItemTwo   => 2,
            ItemThree => 1,
            ItemFour  => 1,
            ItemFive  => 0,
        },

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

    # to store fieldIDs whitelist
    my %AllowedFieldIDs;

    if ( defined $Param{FieldFilter} && ref $Param{FieldFilter} eq 'HASH' ) {

        # fill the fieldIDs whitelist
        FIELDNAME:
        for my $FieldName ( sort keys %{ $Param{FieldFilter} } ) {
            next FIELDNAME if !$Param{FieldFilter}->{$FieldName};

            my $FieldConfig = $Self->DynamicFieldGet( Name => $FieldName );
            next FIELDNAME if !IsHashRefWithData($FieldConfig);
            next FIELDNAME if !$FieldConfig->{ID};

            $AllowedFieldIDs{ $FieldConfig->{ID} } = 1,
        }
    }

    # check cache
    my $Valid = 1;
    if ( defined $Param{Valid} && $Param{Valid} eq '0' ) {
        $Valid = 0;
    }

    # set cache key object type component depending on the ObjectType parameter
    my $ObjectType = 'All';
    if ( IsArrayRefWithData( $Param{ObjectType} ) ) {
        $ObjectType = join '_', sort @{ $Param{ObjectType} };
    }
    elsif ( IsStringWithData( $Param{ObjectType} ) ) {
        $ObjectType = $Param{ObjectType};
    }

    my $ResultType = $Param{ResultType} || 'ARRAY';
    $ResultType = $ResultType eq 'HASH' ? 'HASH' : 'ARRAY';

    my $CacheKey
        = 'DynamicFieldList::Valid::'
        . $Valid
        . '::ObjectType::'
        . $ObjectType
        . '::ResultType::'
        . $ResultType;
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # check if FieldFilter is not set
        if ( !defined $Param{FieldFilter} ) {

            # return raw data from cache
            return $Cache;
        }
        elsif ( ref $Param{FieldFilter} ne 'HASH' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'FieldFilter must be a HASH reference!',
            );
            return;
        }

        # otherwise apply the filter
        my $FilteredData;

        # check if cache is ARRAY ref
        if ( $ResultType eq 'ARRAY' ) {

            FIELDID:
            for my $FieldID ( @{$Cache} ) {
                next FIELDID if !$AllowedFieldIDs{$FieldID};

                push @{$FilteredData}, $FieldID;
            }

            # return filtered data from cache
            return $FilteredData;
        }

        # otherwise is a HASH ref
        else {

            FIELDID:
            for my $FieldID ( sort keys %{$Cache} ) {
                next FIELDID if !$AllowedFieldIDs{$FieldID};

                $FilteredData->{$FieldID} = $Cache->{$FieldID}
            }
        }

        # return filtered data from cache
        return $FilteredData;
    }

    else {
        my $SQL = 'SELECT id, name, field_order FROM dynamic_field';

        if ($Valid) {
            $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';

            if ( $Param{ObjectType} ) {
                if ( IsStringWithData( $Param{ObjectType} ) && $Param{ObjectType} ne 'All' ) {
                    $SQL .=
                        " AND object_type = '"
                        . $Self->{DBObject}->Quote( $Param{ObjectType} ) . "'";
                }
                elsif ( IsArrayRefWithData( $Param{ObjectType} ) ) {
                    my $ObjectTypeString =
                        join ',',
                        map "'" . $Self->{DBObject}->Quote($_) . "'",
                        @{ $Param{ObjectType} };
                    $SQL .= " AND object_type IN ($ObjectTypeString)";

                }
            }
        }
        else {
            if ( $Param{ObjectType} ) {
                if ( IsStringWithData( $Param{ObjectType} ) && $Param{ObjectType} ne 'All' ) {
                    $SQL .=
                        " WHERE object_type = '"
                        . $Self->{DBObject}->Quote( $Param{ObjectType} ) . "'";
                }
                elsif ( IsArrayRefWithData( $Param{ObjectType} ) ) {
                    my $ObjectTypeString =
                        join ',',
                        map "'" . $Self->{DBObject}->Quote($_) . "'",
                        @{ $Param{ObjectType} };
                    $SQL .= " WHERE object_type IN ($ObjectTypeString)";
                }
            }
        }

        $SQL .= " ORDER BY field_order, id";

        return if !$Self->{DBObject}->Prepare( SQL => $SQL );

        if ( $ResultType eq 'HASH' ) {
            my %Data;

            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $Data{ $Row[0] } = $Row[1];
            }

            # set cache
            $Self->{CacheObject}->Set(
                Type  => 'DynamicField',
                Key   => $CacheKey,
                Value => \%Data,
                TTL   => $Self->{CacheTTL},
            );

            # check if FieldFilter is not set
            if ( !defined $Param{FieldFilter} ) {

                # return raw data from DB
                return \%Data;
            }
            elsif ( ref $Param{FieldFilter} ne 'HASH' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => 'FieldFilter must be a HASH reference!',
                );
                return;
            }

            my %FilteredData;
            FIELDID:
            for my $FieldID ( sort keys %Data ) {
                next FIELDID if !$AllowedFieldIDs{$FieldID};

                $FilteredData{$FieldID} = $Data{$FieldID};
            }

            # return filtered data from DB
            return \%FilteredData;
        }

        else {

            my @Data;
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                push @Data, $Row[0];
            }

            # set cache
            $Self->{CacheObject}->Set(
                Type  => 'DynamicField',
                Key   => $CacheKey,
                Value => \@Data,
                TTL   => $Self->{CacheTTL},
            );

            # check if FieldFilter is not set
            if ( !defined $Param{FieldFilter} ) {

                # return raw data from DB
                return \@Data;
            }
            elsif ( ref $Param{FieldFilter} ne 'HASH' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => 'FieldFilter must be a HASH reference!',
                );
                return;
            }

            my @FilteredData;
            FIELDID:
            for my $FieldID (@Data) {
                next FIELDID if !$AllowedFieldIDs{$FieldID};

                push @FilteredData, $FieldID;
            }

            # return filtered data from DB
            return \@FilteredData;
        }
    }

    return;
}

=item DynamicFieldListGet()

get DynamicField list with complete data ordered by the "Field Order" field in the DB

    my $List = $DynamicFieldObject->DynamicFieldListGet();

    or

    my $List = $DynamicFieldObject->DynamicFieldListGet(
        Valid        => 0,            # optional, defaults to 1

        # object  type (optional) as STRING or as ARRAYREF
        ObjectType => 'Ticket',
        ObjectType => ['Ticket', 'Article'],

        FieldFilter => {        # optional, only active fields (non 0) will be returned
            nameforfield => 1,
            fieldname    => 2,
            other        => 0,
            otherfield   => 0,
        },

    );

Returns:

    $List = (
        {
            ID          => 123,
            InternalField => 0,
            Name        => 'nameforfield',
            Label       => 'The label to show',
            FieldType   => 'Text',
            ObjectType  => 'Article',
            Config      => $ConfigHashRef,
            ValidID     => 1,
            CreateTime  => '2011-02-08 15:08:00',
            ChangeTime  => '2011-06-11 17:22:00',
        },
        {
            ID            => 321,
            InternalField => 0,
            Name          => 'fieldname',
            Label         => 'It is not a label',
            FieldType     => 'Text',
            ObjectType    => 'Ticket',
            Config        => $ConfigHashRef,
            ValidID       => 1,
            CreateTime    => '2010-09-11 10:08:00',
            ChangeTime    => '2011-01-01 01:01:01',
        },
        ...
    );

=cut

sub DynamicFieldListGet {
    my ( $Self, %Param ) = @_;

    # check cache
    my $Valid = 1;
    if ( defined $Param{Valid} && $Param{Valid} eq '0' ) {
        $Valid = 0;
    }

    # set cache key object type component depending on the ObjectType parameter
    my $ObjectType = 'All';
    if ( IsArrayRefWithData( $Param{ObjectType} ) ) {
        $ObjectType = join '_', sort @{ $Param{ObjectType} };
    }
    elsif ( IsStringWithData( $Param{ObjectType} ) ) {
        $ObjectType = $Param{ObjectType};
    }

    my $CacheKey = 'DynamicFieldListGet::Valid::' . $Valid . '::ObjectType::' . $ObjectType;
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'DynamicField',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # check if FieldFilter is not set
        if ( !defined $Param{FieldFilter} ) {

            # return raw data from cache
            return $Cache;
        }
        elsif ( ref $Param{FieldFilter} ne 'HASH' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'FieldFilter must be a HASH reference!',
            );
            return;
        }

        my $FilteredData;

        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$Cache} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
            next DYNAMICFIELD if !$Param{FieldFilter}->{ $DynamicFieldConfig->{Name} };

            push @{$FilteredData}, $DynamicFieldConfig,
        }

        # return filtered data from cache
        return $FilteredData;
    }

    my @Data;
    my $SQL = 'SELECT id, name, field_order FROM dynamic_field';

    if ($Valid) {
        $SQL .= ' WHERE valid_id IN (' . join ', ', $Self->{ValidObject}->ValidIDsGet() . ')';

        if ( $Param{ObjectType} ) {
            if ( IsStringWithData( $Param{ObjectType} ) && $Param{ObjectType} ne 'All' ) {
                $SQL .=
                    " AND object_type = '" . $Self->{DBObject}->Quote( $Param{ObjectType} ) . "'";
            }
            elsif ( IsArrayRefWithData( $Param{ObjectType} ) ) {
                my $ObjectTypeString =
                    join ',',
                    map "'" . $Self->{DBObject}->Quote($_) . "'",
                    @{ $Param{ObjectType} };
                $SQL .= " AND object_type IN ($ObjectTypeString)";

            }
        }
    }
    else {
        if ( $Param{ObjectType} ) {
            if ( IsStringWithData( $Param{ObjectType} ) && $Param{ObjectType} ne 'All' ) {
                $SQL .=
                    " WHERE object_type = '" . $Self->{DBObject}->Quote( $Param{ObjectType} ) . "'";
            }
            elsif ( IsArrayRefWithData( $Param{ObjectType} ) ) {
                my $ObjectTypeString =
                    join ',',
                    map "'" . $Self->{DBObject}->Quote($_) . "'",
                    @{ $Param{ObjectType} };
                $SQL .= " WHERE object_type IN ($ObjectTypeString)";
            }
        }
    }

    $SQL .= " ORDER BY field_order, id";

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

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'DynamicField',
        Key   => $CacheKey,
        Value => \@Data,
        TTL   => $Self->{CacheTTL},
    );

    # check if FieldFilter is not set
    if ( !defined $Param{FieldFilter} ) {

        # return raw data from DB
        return \@Data;
    }
    elsif ( ref $Param{FieldFilter} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'FieldFilter must be a HASH reference!',
        );
        return;
    }

    my $FilteredData;

    DYNAMICFIELD:
    for my $DynamicFieldConfig (@Data) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        next DYNAMICFIELD if !$Param{FieldFilter}->{ $DynamicFieldConfig->{Name} };

        push @{$FilteredData}, $DynamicFieldConfig,
    }

    # return filtered data from DB
    return $FilteredData;
}

=item DynamicFieldOrderReset()

sets the order of all dynamic fields based on a consecutive number list starting with number 1.
This function will remove duplicate order numbers and gaps in the numbering.

    my $Success = $DynamicFieldObject->DynamicFieldOrderReset();

Returns:

    $Success = 1;                        # or 0 in case of error

=cut

sub DynamicFieldOrderReset {
    my ( $Self, %Param ) = @_;

    # get all fields
    my $DynamicFieldList = $Self->DynamicFieldListGet(
        Valid => 0,
    );

    # to set the field order
    my $Counter;

    # loop through all the dynamic fields
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        # prepare the new field order
        $Counter++;

        # skip wrong fields (if any)
        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        # skip fields with the correct order
        next DYNAMICFIELD if $DynamicField->{FieldOrder} eq $Counter;

        $DynamicField->{FieldOrder} = $Counter;

        # update the database
        my $Success = $Self->DynamicFieldUpdate(
            %{$DynamicField},
            UserID  => 1,
            Reorder => 0,
        );

        # check if the update was successful
        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'An error was detected while re ordering the field list on field '
                    . "DynamicField->{Name}!",
            );
            return;
        }
    }

    return 1;
}

=item DynamicFieldOrderCheck()

checks for duplicate order numbers and gaps in the numbering.

    my $Success = $DynamicFieldObject->DynamicFieldOrderCheck();

Returns:

    $Success = 1;                       # or 0 in case duplicates or gaps in the dynamic fields
                                        #    order numbering

=cut

sub DynamicFieldOrderCheck {
    my ( $Self, %Param ) = @_;

    # get all fields
    my $DynamicFieldList = $Self->DynamicFieldListGet(
        Valid => 0,
    );

    # to had a correct order reference
    my $Counter;

    # flag to be activated if the order is not correct
    my $OrderError;

    # loop through all the dynamic fields
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {
        $Counter++;

        # skip wrong fields (if any)
        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

        # skip fields with correct order
        next DYNAMICFIELD if $DynamicField->{FieldOrder} eq $Counter;

        # when finding a field with wrong order, set OrderError flag and exit loop
        $OrderError = 1;
        last DYNAMICFIELD
    }

    return if $OrderError;

    return 1;
}

=begin Internal:

=cut

=item _DynamicFieldReorder()

re-order the list of fields.

    $Success = $DynamicFieldObject->_DynamicFieldReorder(
        ID         => 123,              # mandatory, the field ID that triggers the re-order
        Mode       => 'Add',            # || Update || Delete
        FieldOrder => 2,                # mandatory, the FieldOrder from the trigger field
    );

    $Success = $DynamicFieldObject->_DynamicFieldReorder(
        ID            => 123,           # mandatory, the field ID that triggers the re-order
        Mode          => 'Update',      # || Update || Delete
        FieldOrder    => 2,             # mandatory, the FieldOrder from the trigger field
        OldFieldOrder => 10,            # mandatory for Mode = 'Update', the FieldOrder before the
                                        # update
    );

=cut

sub _DynamicFieldReorder {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ID FieldOrder Mode)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => 'Need $Needed!' );
            return;
        }
    }

    if ( $Param{Mode} eq 'Update' ) {

        # check needed stuff
        if ( !$Param{OldFieldOrder} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => 'Need OldFieldOrder!' );
            return;
        }
    }

    # get the Dynamic Field trigger
    my $DynamicFieldTrigger = $Self->DynamicFieldGet(
        ID => $Param{ID},
    );

    # extract the field order form the params
    my $TriggerFieldOrder = $Param{FieldOrder};

    # get all fields
    my $DynamicFieldList = $Self->DynamicFieldListGet(
        Valid => 0,
    );

    # to store the fields that need to be updated
    my @NeedToUpdateList;

    # to add or subtract the field order by 1
    my $Substract;

    # update and add has different algorithms to select the fields to be updated
    # check if update
    if ( $Param{Mode} eq 'Update' ) {
        my $OldFieldOrder = $Param{OldFieldOrder};

        # if the new order and the old order are equal no operation should be performed
        # this is a double check from DynamicFieldUpdate (is case of the function is called
        # from outside)
        return if $TriggerFieldOrder eq $OldFieldOrder;

        # set subtract mode for selected fields
        if ( $TriggerFieldOrder > $OldFieldOrder ) {
            $Substract = 1;
        }

        # identify fields that needs to be updated
        DYNAMICFIELD:
        for my $DynamicField ( @{$DynamicFieldList} ) {

            # skip wrong fields (if any)
            next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

            my $CurrentOrder = $DynamicField->{FieldOrder};

            # skip fields with lower order number
            next DYNAMICFIELD
                if $CurrentOrder < $OldFieldOrder && $CurrentOrder < $TriggerFieldOrder;

            # skip trigger field
            next DYNAMICFIELD
                if ( $CurrentOrder eq $TriggerFieldOrder && $DynamicField->{ID} eq $Param{ID} );

            # skip this and the rest if has greater order number
            last DYNAMICFIELD
                if $CurrentOrder > $OldFieldOrder && $CurrentOrder > $TriggerFieldOrder;

            push @NeedToUpdateList, $DynamicField;
        }
    }

    # check if delete action
    elsif ( $Param{Mode} eq 'Delete' ) {

        $Substract = 1;

        # identify fields that needs to be updated
        DYNAMICFIELD:
        for my $DynamicField ( @{$DynamicFieldList} ) {

            # skip wrong fields (if any)
            next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

            my $CurrentOrder = $DynamicField->{FieldOrder};

            # skip fields with lower order number
            next DYNAMICFIELD
                if $CurrentOrder < $TriggerFieldOrder;

            # skip trigger field
            next DYNAMICFIELD
                if ( $CurrentOrder eq $TriggerFieldOrder && $DynamicField->{ID} eq $Param{ID} );

            push @NeedToUpdateList, $DynamicField;
        }
    }

    # otherwise is add action
    else {

        # identify fields that needs to be updated
        DYNAMICFIELD:
        for my $DynamicField ( @{$DynamicFieldList} ) {

            # skip wrong fields (if any)
            next DYNAMICFIELD if !IsHashRefWithData($DynamicField);

            my $CurrentOrder = $DynamicField->{FieldOrder};

            # skip fields with lower order number
            next DYNAMICFIELD
                if $CurrentOrder < $TriggerFieldOrder;

            # skip trigger field
            next DYNAMICFIELD
                if ( $CurrentOrder eq $TriggerFieldOrder && $DynamicField->{ID} eq $Param{ID} );

            push @NeedToUpdateList, $DynamicField;
        }
    }

    # update the fields order incrementing or decrementing by 1
    for my $DynamicField (@NeedToUpdateList) {

        # hash ref validation is not needed since it was validated before
        # check if need to add or subtract
        if ($Substract) {

            # subtract 1 to the dynamic field order value
            $DynamicField->{FieldOrder}--;
        }
        else {

            # add 1 to the dynamic field order value
            $DynamicField->{FieldOrder}++;
        }

        # update the database
        my $Success = $Self->DynamicFieldUpdate(
            %{$DynamicField},
            UserID  => 1,
            Reorder => 0,
        );

        # check if the update was successful
        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'An error was detected while re ordering the field list on field '
                    . "DynamicField->{Name}!",
            );
            return;
        }
    }

    # delete cache
    $Self->{CacheObject}->CleanUp(
        Type => 'DynamicField',
    );

    return 1;
}

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
