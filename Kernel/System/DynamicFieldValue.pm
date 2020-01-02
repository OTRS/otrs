# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicFieldValue;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicFieldValue

=head1 DESCRIPTION

DynamicField values backend

=head1 PUBLIC INTERFACE

=head2 new()

create a DynamicFieldValue object. Do not use it directly, instead use:

    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ValueSet()

sets a dynamic field value. This is represented by one or more rows in the dynamic_field_value
table, each storing one text, date and int field. Please see how they will be returned by
L</ValueGet()>.

    my $Success = $DynamicFieldValueObject->ValueSet(
        FieldID  => $FieldID,                 # ID of the dynamic field
        ObjectID => $ObjectID,                # ID of the current object that the field
                                              #   must be linked to, e. g. TicketID
        Value    => [
            {
                ValueText          => 'some text',            # optional, one of these fields must be provided
                ValueDateTime      => '1977-12-12 12:00:00',  # optional
                ValueInt           => 123,                    # optional
            },
            ...
        ],
        UserID   => $UserID,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldID ObjectID Value)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # return if no Value was provided
    if ( ref $Param{Value} ne 'ARRAY' || !$Param{Value}->[0] )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Param{Value}!"
        );
        return;
    }

    my @Values;

    my $Counter = 0;
    VALUE:
    while (1) {
        if ( ref $Param{Value}->[$Counter] ne 'HASH' ) {
            last VALUE;
        }

        if (
            (
                !defined $Param{Value}->[$Counter]->{ValueText}

                # do not accept an empty string as it is the same as NULL on oracle
                || !length $Param{Value}->[$Counter]->{ValueText}
            )
            && !defined $Param{Value}->[$Counter]->{ValueInt}
            && !defined $Param{Value}->[$Counter]->{ValueDateTime}
            )
        {
            last VALUE;
        }

        my %Value = (
            ValueText     => scalar $Param{Value}->[$Counter]->{ValueText},
            ValueInt      => scalar $Param{Value}->[$Counter]->{ValueInt},
            ValueDateTime => scalar $Param{Value}->[$Counter]->{ValueDateTime},
        );

        # data validation
        return if !$Self->ValueValidate( Value => \%Value );

        # data conversions

        # set ValueDateTime column to NULL
        if ( exists $Value{ValueDateTime} && !$Value{ValueDateTime} ) {
            $Value{ValueDateTime} = undef;
        }

        # set Int Zero
        if ( defined $Value{ValueInt} && !$Value{ValueInt} ) {
            $Value{ValueInt} = '0';
        }

        push @Values, \%Value;
        $Counter++;
    }

    # delete existing value
    $Self->ValueDelete(
        FieldID  => $Param{FieldID},
        ObjectID => $Param{ObjectID},
        UserID   => $Param{UserID},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Value (@Values) {

        # create a new value entry
        return if !$DBObject->Do(
            SQL =>
                'INSERT INTO dynamic_field_value (field_id, object_id, value_text, value_date, value_int)'
                . ' VALUES (?, ?, ?, ?, ?)',
            Bind => [
                \$Param{FieldID}, \$Param{ObjectID},
                \$Value->{ValueText}, \$Value->{ValueDateTime}, \$Value->{ValueInt},
            ],
        );
    }

    # delete cache
    $Self->_DeleteFromCache(%Param);

    return 1;
}

=head2 ValueGet()

get a dynamic field value. For each table row there will be one entry in the
result list.

    my $Value = $DynamicFieldValueObject->ValueGet(
        FieldID            => $FieldID,                 # ID of the dynamic field
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        #   is linked to, e. g. TicketID
    );

    Returns [
        {
            ID                 => 437,
            ValueText          => 'some text',
            ValueDateTime      => '1977-12-12 12:00:00',
            ValueInt           => 123,
        },
    ];

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldID ObjectID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    #
    # Special caching strategy: cache all fields of an object in one cache file.
    #   This avoids too many cache files on systems with many fields for many objects.
    #

    my $CacheKey = 'ValueGet::ObjectID::' . $Param{ObjectID};

    my $Cache = $CacheObject->Get(
        Type => 'DynamicFieldValue',
        Key  => $CacheKey,
    );

    # Check if a cache entry exists
    if ( ref $Cache eq 'HASH' ) {

        if ( exists $Cache->{ $Param{FieldID} } ) {
            return $Cache->{ $Param{FieldID} };
        }
        return [];
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # We'll populate cache with all object's dynamic fields to reduce
    # number of db accesses (only one db query for all dynamic fields till
    # cache expiration); return only specified one dynamic field
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT id, value_text, value_date, value_int, field_id
            FROM dynamic_field_value
            WHERE object_id = ?
            ORDER BY id',
        Bind => [ \$Param{ObjectID} ],
    );

    my %CacheData;

    while ( my @Data = $DBObject->FetchrowArray() ) {

        # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
        # and 0000-00-00 00:00:00 time stamps)
        if ( $Data[2] ) {
            if ( $Data[2] eq '0000-00-00 00:00:00' ) {
                $Data[2] = undef;
            }
            $Data[2] =~ s/^(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2})\..+?$/$1/;
        }

        push @{ $CacheData{ $Data[4] } }, {
            ID            => $Data[0],
            ValueText     => $Data[1],
            ValueDateTime => $Data[2],
            ValueInt      => $Data[3],
        };
    }

    # get the cache TTL (in seconds)
    my $CacheTTL = $Kernel::OM->Get('Kernel::Config')->Get('DynamicField::CacheTTL') || 60 * 60 * 12;

    # set cache
    $CacheObject->Set(
        Type  => 'DynamicFieldValue',
        Key   => $CacheKey,
        Value => \%CacheData,
        TTL   => $CacheTTL,
    );

    if ( exists $CacheData{ $Param{FieldID} } ) {
        return $CacheData{ $Param{FieldID} };
    }

    return [];
}

=head2 ValueDelete()

delete a Dynamic field value entry. All associated rows will be deleted.

    my $Success = $DynamicFieldValueObject->ValueDelete(
        FieldID            => $FieldID,                 # ID of the dynamic field
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        #   is linked to, e. g. TicketID
        UserID  => 123,
    );

    Returns 1.

=cut

sub ValueDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldID ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # delete dynamic field value
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM dynamic_field_value WHERE field_id = ? AND object_id = ?',
        Bind => [ \$Param{FieldID}, \$Param{ObjectID} ],
    );

    # delete cache
    $Self->_DeleteFromCache(%Param);

    return 1;
}

=head2 AllValuesDelete()

delete all entries of a dynamic field .

    my $Success = $DynamicFieldValueObject->AllValuesDelete(
        FieldID            => $FieldID,                 # ID of the dynamic field
        UserID  => 123,
    );

    Returns 1.

=cut

sub AllValuesDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # delete dynamic field value
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM dynamic_field_value WHERE field_id = ?',
        Bind => [ \$Param{FieldID} ],
    );

    # Cleanup entire cache!
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'DynamicFieldValue',
    );

    return 1;
}

=head2 ObjectValuesDelete()

Delete all entries of a dynamic field values for object ID.

    my $Success = $DynamicFieldValueObject->ObjectValuesDelete(
        ObjectType => 'Ticket',    # Dynamic Field object type ( e. g. Ticket, Article, FAQ)
        ObjectID   => $ObjectID,   # ID of the current object that the field
                                   #   is linked to, e. g. TicketID
        UserID     => 123,
    );

    Returns 1.

=cut

sub ObjectValuesDelete {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(ObjectID ObjectType UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Delete dynamic field value.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            DELETE FROM dynamic_field_value
                WHERE
                    field_id IN (
                        SELECT id FROM dynamic_field
                        WHERE object_type = ?
                    )
                    AND object_id = ?
        ',
        Bind => [ \$Param{ObjectType}, \$Param{ObjectID} ],
    );

    # Clear ValueGet cache.
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'DynamicFieldValue',
        Key  => 'ValueGet::ObjectID::' . $Param{ObjectID},
    );

    return 1;
}

=head2 ValueValidate()

checks if the given value is valid for the value type.

    my $Success = $DynamicFieldValueObject->ValueValidate(
        Value    =>  {
                ValueText          => 'some text',            # optional, one of these fields must be provided
                ValueDateTime      => '1977-12-12 12:00:00',  # optional
                ValueInt           => 123,                    # optional
            },
        UserID   => $UserID,
    );

=cut

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    return if !IsHashRefWithData( $Param{Value} );

    my %Value = %{ $Param{Value} };

    # validate date
    if ( $Value{ValueDateTime} ) {

        # get time object
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        # convert the DateTime value to system time to check errors
        my $SystemTime = $DateTimeObject->Set(
            String => $Value{ValueDateTime},
        );

        return if !defined $SystemTime;

        # convert back to time stamp to check errors
        my $TimeStamp = $DateTimeObject->ToString();

        return if !$TimeStamp;

        # compare if the date is the same
        return if !( $Value{ValueDateTime} eq $TimeStamp );
    }

    # validate integer
    if ( $Value{ValueInt} ) {

        if ( $Value{ValueInt} !~ m{\A  -? \d+ \z}smx ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Invalid Integer '$Value{ValueInt}'!"
            );

            return;
        }
    }

    return 1;
}

=head2 HistoricalValueGet()

get all distinct values from a field stored on the database

    my $HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
        FieldID   => $FieldID,                  # ID of the dynamic field
        ValueType => 'Text',                    # or 'DateTime' or 'Integer'. Default 'Text'
    );

    Returns:

    $HistoricalValues{
        ValueA => 'ValueA',
        ValueB => 'ValueB',
        ValueC => 'ValueC'
    };

=cut

sub HistoricalValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $ValueType = 'value_text';
    if ( $Param{ValueType} && $Param{ValueType} eq 'DateTime' ) {
        $ValueType = 'value_date';
    }
    elsif ( $Param{ValueType} && $Param{ValueType} eq 'Integer' ) {
        $ValueType = 'value_int';
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = join '::', 'HistoricalValueGet::FieldID', $Param{FieldID}, 'ValueType',
        $ValueType;

    my $Cache = $CacheObject->Get(
        Type => 'DynamicFieldValue',
        Key  => $CacheKey,
    );

    # get data from cache
    return $Cache if ($Cache);

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL =>
            "SELECT DISTINCT($ValueType) FROM dynamic_field_value WHERE field_id = ?",
        Bind => [ \$Param{FieldID} ],
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # check if the value is already stored
        if ( $Row[0] && !$Data{ $Row[0] } ) {

            if ( $ValueType eq 'value_date' ) {

                # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
                # and 0000-00-00 00:00:00 time stamps)
                if ( $Row[0] eq '0000-00-00 00:00:00' ) {
                    $Row[0] = undef;
                }
                $Row[0] =~ s/^(\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2})\..+?$/$1/;
            }

            # store the results
            $Data{ $Row[0] } = $Row[0];
        }
    }

    # get the cache TTL (in seconds)
    my $CacheTTL = $Kernel::OM->Get('Kernel::Config')->Get('DynamicField::CacheTTL') || 60 * 60 * 12;

    # set cache
    $CacheObject->Set(
        Type  => 'DynamicFieldValue',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => $CacheTTL,
    );

    return \%Data;
}

=head2 ValueSearch()

Searches/fetches dynamic field value.

    my $Value = $DynamicFieldValueObject->ValueSearch(
        FieldID            => 142,             # ID of dynamic field to search
        Search             => 'test',
        SearchSQL          => "dynamic_field_value.value_text = 'test'",
    );

    Returns [
        {
            ID            => 437,
            FieldID       => 123,
            ObjectID      => 133,
            ValueText     => 'some text',
            ValueDateTime => '1977-12-12 12:00:00',
            ValueInt      => 123,
        },
        # ...
    ];

=cut

sub ValueSearch {
    my ( $Self, %Param ) = @_;

    # check mandatory parameters
    if ( !$Param{FieldID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need FieldID!"
        );
        return;
    }

    for my $Param (qw( Search SearchSQL )) {
        if ( !defined $Param{$Param} || !length $Param{$Param} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Param!"
            );
            return;
        }
    }

    my @Values;

    # Cache handling
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType      = 'DynamicFieldValue';
    my $CacheKey       = 'ValueSearch::' . $Param{FieldID};
    my $CacheSearchKey = $Param{Search};

    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    # Check if a cache entry exists
    if (
        IsHashRefWithData($Cache)
        && exists $Cache->{$CacheSearchKey}
        && IsArrayRefWithData( $Cache->{$CacheSearchKey} )
        )
    {
        for my $Value ( @{ $Cache->{$CacheSearchKey} } ) {
            push @Values, $Value;
        }
    }

    return \@Values if @Values;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT id, field_id, object_id, value_text, value_date, value_int
        FROM  dynamic_field_value
        WHERE  dynamic_field_value.field_id = ?
            AND ';

    $SQL .= $Param{SearchSQL};

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => [
            \$Param{FieldID},

            # @{ $QueryCondition{Values} },
        ],
    );

    while ( my @Data = $DBObject->FetchrowArray() ) {
        push @Values, {
            ID        => $Data[0],
            FieldID   => $Data[1],
            ObjectID  => $Data[2],
            ValueText => $Data[3],
            ValueDate => $Data[4],
            ValueInt  => $Data[5],
        };
    }

    # get the cache TTL (in seconds)
    my $CacheTTL = $Kernel::OM->Get('Kernel::Config')->Get('DynamicField::CacheTTL') || 60 * 60 * 12;

    # set cache for new field ID if it isn't set yet.
    # note: it's possible there is no database record for a given field ID. in this case, an empty
    # but defined value has to be stored. Otherwise there would be a database query the next time.
    if ( !ref $Cache || ref $Cache ne 'HASH' ) {
        $Cache = {
            $CacheSearchKey => undef,
        };
    }

    if (@Values) {
        for my $Value (@Values) {
            push @{ $Cache->{$CacheSearchKey} }, $Value;
        }
    }
    else {
        $Cache->{$CacheSearchKey} = undef;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => $Cache,
        TTL   => $CacheTTL,
    );

    return \@Values;
}

#
# Deletes all needed cache entries for a given DynamicFieldValue.
#
sub _DeleteFromCache {

    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldID ObjectID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Clear ValueGet cache
    $CacheObject->Delete(
        Type => 'DynamicFieldValue',
        Key  => 'ValueGet::ObjectID::' . $Param{ObjectID},
    );

    # Clear HistoricalValueGet caches
    $CacheObject->Delete(
        Type => 'DynamicFieldValue',
        Key  => 'HistoricalValueGet::FieldID::' . $Param{FieldID} . '::ValueType::Text',
    );
    $CacheObject->Delete(
        Type => 'DynamicFieldValue',
        Key  => 'HistoricalValueGet::FieldID::' . $Param{FieldID} . '::ValueType::DateTime',
    );
    $CacheObject->Delete(
        Type => 'DynamicFieldValue',
        Key  => 'HistoricalValueGet::FieldID::' . $Param{FieldID} . '::ValueType::Integer',
    );

    # Make sure to clear appropriate cache according to data value type.
    if ( IsArrayRefWithData( $Param{Value} ) ) {
        my $ValueType = 'value_text';
        if ( $Param{Value}->[0]->{ValueDateTime} ) {
            $ValueType = 'value_date';
        }
        elsif ( $Param{Value}->[0]->{ValueInt} ) {
            $ValueType = 'value_int';
        }
        $CacheObject->Delete(
            Type => 'DynamicFieldValue',
            Key  => 'HistoricalValueGet::FieldID::' . $Param{FieldID} . '::ValueType::' . $ValueType,
        );
    }

    $CacheObject->Delete(
        Type => 'DynamicFieldValue',
        Key  => 'ValueSearch::' . $Param{FieldID},
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
