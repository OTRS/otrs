# --
# Kernel/System/DynamicFieldValue.pm - DynamicField values backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicFieldValue.pm,v 1.5 2011-08-27 13:46:29 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicFieldValue;

use strict;
use warnings;

#use Kernel::System::CacheInternal;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

=head1 NAME

Kernel::System::DynamicFieldValue

=head1 SYNOPSIS

DynamicField values backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a DynamicFieldValue backend object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CacheInternal;
    use Kernel::System::DB;
    use Kernel::System::DynamicFieldValue;

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
    my $CacheInternalObject = Kernel::System::CacheInternal->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $DynamicFieldValueObject = Kernel::System::DynamicFieldValue->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        CacheInternalObject => $CacheInternalObject,
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

    return $Self;
}

=item ValueSet()

sets a dynamic field value.

    my $Success = $DynamicFieldValueObject->ValueSet(
        FieldID            => $FieldID,                 # ID of the dynamic field
        ObjectType         => $ObjectType,              # the type of object e. g. Ticket,
                                                        # Article, etc
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        ValueText          => 'some text',              # optional
        ValueDateTime      => '1977-12-12 12:00:00',    # optional
        ValueInt           => 123,                      # optional
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(FieldID ObjectType ObjectID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # try to get the value (if it was already set)
    my $Value = $Self->ValueGet(
        FieldID    => $Param{FieldID},
        ObjectType => $Param{ObjectType},
        ObjectID   => $Param{ObjectID},
    );

    # return on ValueGet error
    return if !defined $Value;

    # check if value register does not exist
    if ( !$Value->{ID} ) {

        # create a new value
        return if !$Self->{DBObject}->Do(
            SQL =>
                'INSERT INTO dynamic_field_value (field_id, object_type, object_id,'
                . ' value_text, value_date, value_int)'
                . ' VALUES (?, ?, ?, ?, ?, ?)',
            Bind => [
                \$Param{FieldID},   \$Param{ObjectType},    \$Param{ObjectID},
                \$Param{ValueText}, \$Param{ValueDateTime}, \$Param{ValueInt},
            ],
        );

        return 1;
    }

    # otherwise update field value
    return if !$Self->{DBObject}->Do(
        SQL =>
            'UPDATE dynamic_field_value SET value_text = ?, value_date = ?, value_int = ?'
            . ' WHERE field_id = ? AND object_type = ? AND object_id =?',
        Bind => [
            \$Param{ValueText}, \$Param{ValueDateTime}, \$Param{ValueInt},
            \$Param{FieldID},   \$Param{ObjectType},    \$Param{ObjectID},
        ],
    );

    return 1;
}

=item ValueGet()

get a dynamic field value.

    my $Value = $DynamicFieldValueObject->ValueGet(
        FieldID            => $FieldID,                 # ID of the dynamic field
        ObjectType         => $ObjectType,              # the type of object e. g. Ticket,
                                                        # Article, etc
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
    );

    Returns:

    $Value = {
        ID                 => 123,
        ValueText          => 'some text',
        ValueDateTime      => '1977-12-12 12:00:00',
        ValueInt           => 123,
    }

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(FieldID ObjectType ObjectID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Value;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, value_text, value_date, value_int'
            . ' FROM dynamic_field_value'
            . ' WHERE field_id = ? AND object_type = ? AND object_id = ?',
        Bind => [ \$Param{FieldID}, \$Param{ObjectType}, \$Param{ObjectID} ],
    );

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        %Value = (
            ID            => $Data[0],
            ValueText     => $Data[1],
            ValueDateTime => $Data[2],
            ValueInt      => $Data[3],
        );
    }

    # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
    # and 0000-00-00 00:00:00 time stamps)
    if ( $Value{ValueDateTime} ) {
        if ( $Value{ValueDateTime} eq '0000-00-00 00:00:00' ) {
            $Value{ValueDateTime} = '';
        }
        $Value{ValueDateTime} =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
    }
    return \%Value;
}

=item ValueDelete()

delete a Dynamic field value entry

returns 1 if successful or undef otherwise

    my $Success = $DynamicFieldValueObject->ValueDelete(
        FieldID            => $FieldID,                 # ID of the dynamic field
        ObjectType         => $ObjectType,              # the type of object e. g. Ticket,
                                                        # Article, etc
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        UserID  => 123,
    );

=cut

sub ValueDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(FieldID ObjectType ObjectID UserID)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if exists
    my $Value = $Self->ValueGet(
        FieldID    => $Param{FieldID},
        ObjectType => $Param{ObjectType},
        ObjectID   => $Param{ObjectID},
    );
    return if !IsHashRefWithData($Value);

    # delete dynamic field value
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM dynamic_field_value'
            . ' WHERE field_id = ? AND object_type = ? AND object_id = ?',
        Bind => [ \$Param{FieldID}, \$Param{ObjectType}, \$Param{ObjectID} ],
    );

    return 1;
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

$Revision: 1.5 $ $Date: 2011-08-27 13:46:29 $

=cut
