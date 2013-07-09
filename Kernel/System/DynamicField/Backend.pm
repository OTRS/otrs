# --
# Kernel/System/DynamicField/Backend.pm - Interface for DynamicField backends
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Backend;

use strict;
use warnings;

use Scalar::Util qw(weaken);
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::DynamicField::Backend

=head1 SYNOPSIS

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a DynamicField backend object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::DynamicField::Backend;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
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
    my $DynamicFieldObject = Kernel::System::DynamicField::Backend->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        TimeObject          => $TimeObject,
        MainObject          => $MainObject,
        DBObject            => $DBObject,
        # Optional: pass TicketObject pass if you already have one (for cache consistency reasons)
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject DBObject TimeObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    # get the Dynamic Field Backends configuration
    my $DynamicFieldsConfig = $Self->{ConfigObject}->Get('DynamicFields::Backend');

    # check Configuration format
    if ( !IsHashRefWithData($DynamicFieldsConfig) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Dynamic field configuration is not valid!",
        );
        return;
    }

    # create all registered backend modules
    for my $FieldType ( sort keys %{$DynamicFieldsConfig} ) {

        # check if the registration for each field type is valid
        if ( !$DynamicFieldsConfig->{$FieldType}->{Module} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Registration for field type $FieldType is invalid!",
            );
            return;
        }

        # set the backend file
        my $BackendModule = $DynamicFieldsConfig->{$FieldType}->{Module};

        # check if backend field exists
        if ( !$Self->{MainObject}->Require($BackendModule) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't load dynamic field backend module for field type $FieldType!",
            );
            return;
        }

        # create a backend object
        my $BackendObject = $BackendModule->new( %{$Self} );

        if ( !$BackendObject ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Couldn't create a backend object for field type $FieldType!",
            );
            return;
        }

        if ( ref $BackendObject ne $BackendModule ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Backend object for field type $FieldType was not created successfuly!",
            );
            return;
        }

        # remember the backend object
        $Self->{ 'DynamicField' . $FieldType . 'Object' } = $BackendObject;
    }

    # get the Dynamic Field Objects configuration
    my $DynamicFieldObjectTypeConfig = $Self->{ConfigObject}->Get('DynamicFields::ObjectType');

    # check Configuration format
    if ( IsHashRefWithData($DynamicFieldObjectTypeConfig) ) {

        # create all registered ObjectType handler modules
        for my $ObjectType ( sort keys %{$DynamicFieldObjectTypeConfig} ) {

            # check if the registration for each field type is valid
            if ( !$DynamicFieldObjectTypeConfig->{$ObjectType}->{Module} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Registration for object type $ObjectType is invalid!",
                );
                return;
            }

            # set the backend file
            my $ObjectHandlerModule = $DynamicFieldObjectTypeConfig->{$ObjectType}->{Module};

            # check if backend field exists
            if ( !$Self->{MainObject}->Require($ObjectHandlerModule) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Can't load dynamic field object handler module for object type $ObjectType!",
                );
                return;
            }

            # create a backend object
            my $ObjectHandlerObject = $ObjectHandlerModule->new(
                %{$Self},
                %Param,    # pass %Param too, for optional arguments like TicketObject
            );

            if ( !$ObjectHandlerObject ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Couldn't create a handler object for object type $ObjectType!",
                );
                return;
            }

            if ( ref $ObjectHandlerObject ne $ObjectHandlerModule ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Handler object for object type $ObjectType was not created successfuly!",
                );
                return;
            }

            # remember the backend object
            $Self->{ 'DynamicField' . $ObjectType . 'HandlerObject' } = $ObjectHandlerObject;
        }
    }

    return $Self;
}

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $BackendObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        ParamObject          => $ParamObject,
        PossibleValuesFilter => {                         # Optional. Some backends may support this.
            'Key1' => 'Value1',                           #     This may be needed to realize ACL support for ticket masks,
            'Key2' => 'Value2',                           #     where the possible values can be limited with and ACL.
        },
        Template             => {                         # Optional data structure of GenericAgent etc.
                Owner => 2,                               # Value is accessable via field name (DynamicField_ + field name)
                Title => 'Generic Agent Job was here'     # and could be a scalar, Hash- or ArrayRef
                ...
                DynamicField_ExampleField1 => 'Value 1'
            }
        Value                => 'Any value',              # Optional
        Mandatory            => 1,                        # 0 or 1,
        Class                => 'AnyCSSClass OrOneMore',  # Optional
        ServerError          => 1,                        # 0 or 1,
        ErrorMessage         => $ErrorMessage,            # Optional or a default will be used in error case
        UseDefaultValue      => 1,                        # 0 or 1, 1 default
        OverridePossibleNone => 1,                        # Optional, 0 or 1. If defined orverrides the Possible None
                                                          #     setting of all dynamic fields (where applies) with the
                                                          #     defined value
        ConfirmationNeeded   => 0,                        # Optional, 0 or 1, default 0. To display a confirmation element
                                                          #     on fields that apply (like checkbox)
        AJAXUpdate           => 1,                        # Optional, 0 ir 1. To create JS code for field change to update
                                                          #     the form using ACLs triggered by the field.
        UpdatableFields      => [                         # Optional, to use if AJAXUpdate is 1. List of fields to display a
            NetxStateID,                                  #     spinning wheel when reloading via AJAXUpdate.
            PriorityID,
        ],
    );

    Returns {
        Field => $HTMLString,
        Label => $LabelString,
    };

=cut

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject ParamObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # check PossibleValuesFilter (general)
    if (
        defined $Param{PossibleValuesFilter}
        && ref $Param{PossibleValuesFilter} ne 'HASH'
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The possible values filter is invalid",
        );
        return;
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # set use default value as default if not specified
    if ( !defined $Param{UseDefaultValue} ) {
        $Param{UseDefaultValue} = 1;
    }

    # call EditFieldRender on the specific backend
    my $HTMLStrings = $Self->{$DynamicFieldBackend}->EditFieldRender(
        %Param
    );

    return $HTMLStrings;

}

=item DisplayValueRender()

creates value and title strings to be used in display masks. Supports HTML output
and will transform dates to the current user's timezone.

    my $ValueStrg = $BackendObject->DisplayValueRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Value              => 'Any value',              # Optional
        HTMLOutput         => 1,                        # or 0, default 1, to return HTML ready
                                                        #    values
        ValueMaxChars      => 20,                       # Optional (for HTMLOutput only)
        TitleMaxChars      => 20,                       # Optional (for HTMLOutput only)
        LayoutObject       => $LayoutObject,
    );

    Returns

    $ValueStrg = {
        Title => $Title,
        Value => $Value,
        Link  => $link,
    }
=cut

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call DisplayValueRender on the specific backend
    my $ValueStrg = $Self->{$DynamicFieldBackend}->DisplayValueRender(
        %Param
    );

    return $ValueStrg;
}

=item ValueSet()

sets a dynamic field value.

    my $Success = $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        Value              => $Value,                   # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    my $OldValue = $Self->ValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ObjectID           => $Param{ObjectID},
    );

    my $NewValue = $Param{Value};

    # do not proceed if there is nothing to update
    if ( !DataIsDifferent( Data1 => \$OldValue, Data2 => \$NewValue ) ) {
        return 1;
    }

    # call ValueSet on the specific backend
    my $Success = $Self->{$DynamicFieldBackend}->ValueSet(%Param);

    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not update field $Param{DynamicFieldConfig}->{Name} for "
                . "$Param{DynamicFieldConfig}->{ObjectType} ID $Param{ObjectID} !",
        );
        return;
    }

    # set the dyanamic field object handler
    my $DynamicFieldObjectHandler =
        'DynamicField' . $Param{DynamicFieldConfig}->{ObjectType} . 'HandlerObject';

    # If an ObjectType handler is registered, use it.
    if ( ref $Self->{$DynamicFieldObjectHandler} ) {
        return $Self->{$DynamicFieldObjectHandler}->PostValueSet(%Param);
    }

    return 1;
}

=item ValueDelete()

deletes a dynamic field value.

    my $Success = $BackendObject->ValueDelete(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        UserID             => 123,
    );

=cut

sub ValueDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    return $Self->{$DynamicFieldBackend}->ValueDelete(%Param);
}

=item AllValuesDelete()

deletes all values of a dynamic field.

    my $Success = $BackendObject->AllValuesDelete(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        UserID             => 123,
    );

=cut

sub AllValuesDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    return $Self->{$DynamicFieldBackend}->AllValuesDelete(%Param);
}

=item ValueValidate()

validates a dynamic field value.

    my $Success = $BackendObject->ValueValidate(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Value              => $Value,                   # Value to store, depends on backend type
        UserID             => 123,
    );

=cut

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call ValueValidate on the specific backend
    return $Self->{$DynamicFieldBackend}->ValueValidate(%Param);
}

=item ValueGet()

get a dynamic field value.

    my $Value = $BackendObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
    );

    Return $Value                                       # depends on backend type, i. e.
                                                        # Text, $Value =  'a string'
                                                        # DateTime, $Value = '1977-12-12 12:00:00'
                                                        # Checkbox, $Value = 1
=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call ValueGet on the specific backend
    return $Self->{$DynamicFieldBackend}->ValueGet(%Param);
}

=item SearchSQLGet()

returns the SQL WHERE part that needs to be used to search in a particular
dynamic field. The table must already be joined.

    my $SQL = $BackendObject->SearchSQLGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        TableAlias         => $TableAlias,              # the alias of the already joined dynamic_field_value table to use
        SearchTerm         => $SearchTerm,              # What to look for. Placeholders in LIKE searches must be passed as %.
        Operator           => $Operator,                # One of [Equals, Like, GreaterThan, GreaterThanEquals, SmallerThan, SmallerThanEquals]
                                                        #   The supported operators differ for the different backends.
    );

=cut

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig TableAlias Operator)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # Ignore empty searches
    return if ( !defined $Param{SearchTerm} || $Param{SearchTerm} eq '' );

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    return $Self->{$DynamicFieldBackend}->SearchSQLGet(%Param);
}

=item SearchSQLOrderFieldGet()

returns the SQL field needed for ordering based on a dynamic field.

    my $SQL = $BackendObject->SearchSQLOrderFieldGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        TableAlias         => $TableAlias,              # the alias of the already joined dynamic_field_value table to use
    );

=cut

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig TableAlias)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!",
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    return $Self->{$DynamicFieldBackend}->SearchSQLOrderFieldGet(%Param);
}

=item EditFieldValueGet()

extracts the value of a dynamic field from the param object.

    my $Value = $BackendObject->EditFieldValueGet(
        DynamicFieldConfig   => $DynamicFieldConfig,    # complete config of the DynamicField
        ParamObject          => $ParamObject,           # the current request data
        LayoutObject         => $LayoutObject,          # used to transform dates to user time zone
        TransformDates       => 1                       # 1 || 0, default 1, to transform the dynamic fields that
                                                        #   use dates to the user time zone (i.e. Date, DateTime
                                                        #   dynamic fields)
        Template             => $Template,
        ReturnValueStructure => 0,                      # 0 || 1, default 0
                                                        #   Returns special structure
                                                        #   (only for backend internal use).
        ReturnTemplateStructure => 0,                   # 0 || 1, default 0
                                                        #   Returns the structured values as got from the http request
    );

    Returns $Value;                                     # depending on each field type e.g.
                                                        #   $Value = 'a text';
                                                        #   $Value = '1977-12-12 12:00:00';
                                                        #   $Value = 1;

    my $Value = $BackendObject->EditFieldValueGet(
        DynamicFieldConfig   => $DynamicFieldConfig,    # complete config of the DynamicField
        ParamObject          => $ParamObject,           # the current request data
        TransformDates       => 0                       # 1 || 0, default 1, to transform the dynamic fields that
                                                        #   use dates to the user time zone (i.e. Date, DateTime
                                                        #   dynamic fields)

        Template             => $Template               # stored values from DB like Search profile or Generic Agent job
        ReturnValueStructure => 1,                      # 0 || 1, default 0
                                                        #   Returns the structured values as got from the http request
                                                        #   (only for backend internal use).
    );

    Returns $Value;                                     # depending on each field type e.g.
                                                        #   $Value = 'a text';
                                                        #   $Value = {
                                                                Used   => 1,
                                                                Year   => '1977',
                                                                Month  => '12',
                                                                Day    => '12',
                                                                Hour   => '12',
                                                                Minute => '00'
                                                            },
                                                        #   $Value = 1;
=cut

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check for the data source
    if ( !$Param{ParamObject} && !$Param{Template} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ParamObject or Template!" );
        return;
    }

    # define transform dates parameter
    if ( !defined $Param{TransformDates} ) {
        $Param{TransformDates} = 1;
    }

    # check needed objects for transform dates
    if ( $Param{TransformDates} && !$Param{LayoutObject} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need LayoutObject to transform dates!"
        );
        return;
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return value from the specific backend
    return $Self->{$DynamicFieldBackend}->EditFieldValueGet(%Param);
}

=item EditFieldValueValidate()

validate the current value for the dynamic field

    my $Result = $BackendObject->EditFieldValueValidate(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        PossibleValuesFilter => {                         # Optional. Some backends may support this.
            'Key1' => 'Value1',                           #     This may be needed to realize ACL support for ticket masks,
            'Key2' => 'Value2',                           #     where the possible values can be limited with and ACL.
        },
        ParamObject          => $Self->{ParamObject}      # To get the values directly from the web request
        Mandatory            => 1,                        # 0 or 1,
    );

    Returns

    $Result = {
        ServerError        => 1,                          # 0 or 1,
        ErrorMessage       => $ErrorMessage,              # Optional or a default will be used in error case
    }

=cut

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{DynamicFieldConfig} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need DynamicFieldConfig!" );
        return;
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # check PossibleValuesFilter (general)
    if (
        defined $Param{PossibleValuesFilter}
        && ref $Param{PossibleValuesFilter} ne 'HASH'
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The possible values filter is invalid",
        );
        return;
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return validation structure from the specific backend
    return $Self->{$DynamicFieldBackend}->EditFieldValueValidate(%Param);

}

=item IsSortable()

returns if the current field backend is sortable or not.

    my $Sortable = $BackendObject->IsSortable();   # 1 or 0

=cut

sub IsSortable {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call IsSortable on the specific backend
    return $Self->{$DynamicFieldBackend}->IsSortable(
        %Param
    );
}

=item SearchFieldRender()

creates the field HTML to be used in search masks.

    my $FieldHTML = $BackendObject->SearchFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        ParamObject          => $ParamObject,
        Profile              => $ProfileData,             # search template data to load
        PossibleValuesFilter => {                         # optional. Some backends may support this.
            'Key1' => 'Value1',                           #     This may be needed to realize ACL support for ticket masks,
            'Key2' => 'Value2',                           #     where the possible values can be limited with and ACL.
        },
        DefaultValue         => $Value,                   # optional, depending on each field type e.g
                                                          #   $Value = a text';
                                                          #   $Value
                                                          #       = 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartYear=1977;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartMonth=12;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartDay=12;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartHour=00;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartMinute=00;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartSecond=00;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopYear=2011;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopMonth=09;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopDay=29;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopHour=23;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopMinute=59;'
                                                          #       . 'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopSecond=59;';
                                                          #
                                                          #   $Value =  1;
        ConfirmationCheckboxes => 0                       # or 1, to dislay confirmation checkboxes
        UseLabelHints          => 1                       # or 0, default 1. To display seach hints in labels
    );

    Returns {
        Field => $HTMLString,
        Label => $LabelString,
    };

=cut

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig LayoutObject Profile)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    if ( !defined $Param{UseLabelHints} ) {
        $Param{UseLabelHints} = 1;
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call SearchFieldRender on the specific backend
    my $HTMLStrings = $Self->{$DynamicFieldBackend}->SearchFieldRender(
        %Param
    );

    return $HTMLStrings;

}

=item SearchFieldValueGet()

extracts the value of a dynamic field from the param object or search profile.

    my $Value = $BackendObject->SearchFieldValueGet(
        DynamicFieldConfig     => $DynamicFieldConfig,    # complete config of the DynamicField
        ParamObject            => $ParamObject,           # the current request data
        Profile                => $ProfileData,           # the serach profile
        ReturnProfileStructure => 0,                      # 0 || 1, default 0
                                                          #   Returns the structured values as got from the http request
    );

    Returns $Value;                                       # depending on each field type e.g.
                                                          #   $Value = 'a text';
                                                          #   $Value = {
                                                          #      'DynamicField_' . $DynamicFieldConfig->{Name} => 1,
                                                          #       ValueStart {
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartYear'   => '1977',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartMonth'  => '12',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartDay'    => '12',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartHour'   => '00',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartMinute' => '00',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartSecond' => '00',
                                                          #       },
                                                          #       ValueStop {
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopYear'    => '2011',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopMonth'   => '09',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopDay'     => '29',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopHour'    => '23',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopMinute'  => '59',
                                                          #           'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopSecond'  => '59',
                                                          #       },
                                                          #   },
                                                          #   $Value = 1;

    my $Value = $BackendObject->SearchFieldValueGet(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        ParamObject          => $ParamObject,             # the current request data
        Profile              => $ProfileData,             # the serach profile
        ReturnProfileStructure => 1,                      # 0 || 1, default 0
                                                          #   Returns the structured values as got from the http request
    );

    Returns $Value;                                       # depending on each field type e.g.
                                                          #   $Value =  {
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} => 'a text';
                                                          #   };
                                                          #   $Value = {
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name}                 => 1,
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartYear'   => '1977',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartMonth'  => '12',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartDay'    => '12',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartHour'   => '00',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartMinute' => '00',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StartSecond' => '00',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopYear'    => '2011',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopMonth'   => '09',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopDay'     => '29',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopHour'    => '23',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopMinute'  => '59',
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} . 'StopSecond'  => '59',
                                                          #   };
                                                          #   $Value =  {
                                                          #       'DynamicField_' . $DynamicFieldConfig->{Name} = 1;
                                                          #   };
=cut

sub SearchFieldValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check ParamObject and Profile
    if ( !$Param{ParamObject} && !$Param{Profile} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ParamObject or Profile!" );
        return;
    }

    if ( $Param{ParamObject} && $Param{Profile} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Only ParamObject or Profile must be specified but not both!"
        );
        return;
    }

    # check if profile is a hash reference
    if ( $Param{Profile} && ref $Param{Profile} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The search profile is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return value from the specific backend
    return $Self->{$DynamicFieldBackend}->SearchFieldValueGet(%Param);
}

=item SearchFieldParameterBuild()

build the search parameters to be passed to the search engine.

    my $DynamicFieldSearchParameter = $BackendObject->SearchFieldParameterBuild(
        DynamicFieldConfig   => $DynamicFieldConfig,    # complete config of the DynamicField
        LayoutObject         => $LayoutObject,          # optional
        Profile              => $ProfileData,           # the search profile
    );

    Returns

    $DynamicFieldSearchParameter = {
        Parameter {
            Equals => $Value,                           # Available operatiors:

                                                        #   Equals            => 123,
                                                        #   Like              => 'value*',
                                                        #   GreaterThan       => '2001-01-01 01:01:01',
                                                        #   GreaterThanEquals => '2001-01-01 01:01:01',
                                                        #   SmallerThan       => '2002-02-02 02:02:02',
                                                        #   SmallerThanEquals => '2002-02-02 02:02:02',
        },
        Display => $DisplayValue,                       # the value to be displayed in the search terms section
    };
=cut

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig Profile)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return value from the specific backend
    return $Self->{$DynamicFieldBackend}->SearchFieldParameterBuild(%Param);
}

=item StatsFieldParameterBuild()
    my $DynamicFieldStatsParameter =  $BackendObject->StatsFieldParameterBuild(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        PossibleValuesFilter => ['value1', 'value2'],     # Optional. Some backends may support this.
                                                          #     This may be needed to realize ACL support for ticket masks,
                                                          #     where the possible values can be limited with and ACL.
    );

    returns

    $DynamicFieldStatsParameter = {
        Values => {
            $Key1 => $Value1,
            $Key2 => $Value2,
        },
        Name               => 'DynamicField_' . $DynamicFieldConfig->{Label},
        Element            => 'DynamicField_' . $DynamicFieldConfig->{Name},
        TranslatableValues => 1,
    };
=cut

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return value from the specific backend
    return $Self->{$DynamicFieldBackend}->StatsFieldParameterBuild(%Param);

}

=item StatsSearchFieldParameterBuild()

build the search parameters to be passed to the search engine within the stats module.

    my $DynamicFieldStatsSearchParameter = $BackendObject->StatsSearchFieldParameterBuild(
        DynamicFieldConfig   => $DynamicFieldConfig,    # complete config of the DynamicField
        Value                => $Value,                 # the serach profile
    );

    Returns

    $DynamicFieldStatsSearchParameter = {
            Equals => $Value,                           # Available operatiors:

                                                        #   Equals            => 123,
                                                        #   Like              => 'value*',
                                                        #   GreaterThan       => '2001-01-01 01:01:01',
                                                        #   GreaterThanEquals => '2001-01-01 01:01:01',
                                                        #   SmallerThan       => '2002-02-02 02:02:02',
                                                        #   SmallerThanEquals => '2002-02-02 02:02:02',
        },
    };
=cut

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig Value)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return value from the specific backend
    return $Self->{$DynamicFieldBackend}->StatsSearchFieldParameterBuild(%Param);

}

=item ReadableValueRender()

creates value and title strings to be used for storage (e. g. TicketHistory).
Produces text output and does not transform time zones of dates.

    my $ValueStrg = $BackendObject->ReadableValueRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Value              => 'Any value',              # Optional
        ValueMaxChars      => 20,                       # Optional
        TitleMaxChars      => 20,                       # Optional
    );

    Returns

    $ValueStrg = {
        Title => $Title,
        Value => $Value,
    }
=cut

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{DynamicFieldConfig} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need DynamicFieldConfig!" );
        return;
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call DisplayValueRender on the specific backend
    my $ValueStrg = $Self->{$DynamicFieldBackend}->ReadableValueRender(
        %Param
    );

    return $ValueStrg;
}

=item TemplateValueTypeGet()

gets the value type (SCALAR or ARRAY) for a field stored on a template, like a Search Profile or a
Generic Agent job

    my $ValueType = $BackendObject->TemplateValueTypeGet(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
        FieldType => 'Edit',                             # or 'Search' or 'All'
    );

    returns

    $ValueType = {
        'DynamicField_ . '$DynamicFieldConfig->{Name} => 'SCALAR',
    }

    my $ValueType = $Self->{BackendObject}->TemplateValueTypeGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        FieldType => 'Search',
    );

    returns

    $ValueType = {
        'Search_DynamicField_' . $DynamicFieldConfig->{Name} => 'ARRAY',
    }

    my $ValueType = $Self->{BackendObject}->TemplateValueTypeGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        FieldType => 'All',
    );

    returns

    $ValueType = {
        'DynamicField_ . '$DynamicFieldConfig->{Name} => 'SCALAR',
        'Search_DynamicField_' . $DynamicFieldConfig->{Name} => 'ARRAY',
    }
=cut

sub TemplateValueTypeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig FieldType)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set FieldType to All as a fallback
    if ( $Param{FieldType} ne 'Edit' && $Param{FieldType} ne 'Search' ) {
        $Param{FieldType} = 'All';
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call TemplateValueTypeGet on the specific backend
    my $ValueType = $Self->{$DynamicFieldBackend}->TemplateValueTypeGet(
        %Param
    );

    return $ValueType;
}

=item IsAJAXUpdateable()

returns if the current field backend is updateable via AJAX or not.

    my $Updateable = $BackendObject->IsAJAXUpdateable(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
    );

    Returns:

    $Updateable                                 # 1 or 0

=cut

sub IsAJAXUpdateable {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call IsAJAXUpdateable on the specific backend
    return $Self->{$DynamicFieldBackend}->IsAJAXUpdateable(
        %Param
    );
}

=item RandomValueSet()

sets a dynamic field random value.

    my $Result = $BackendObject->RandomValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        UserID             => 123,
    );

    returns:

    $Result {
        Success => 1                # or undef
        Value   => $RandomValue     # or undef
    }
=cut

sub RandomValueSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call RandomValueSet on the specific backend
    my $Result = $Self->{$DynamicFieldBackend}->RandomValueSet(%Param);

    if ( !$Result->{Success} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not update field $Param{DynamicFieldConfig}->{Name} for "
                . "$Param{DynamicFieldConfig}->{ObjectType} ID $Param{ObjectID} !",
        );
        return;
    }

    # set the dyanamic field object handler
    my $DynamicFieldObjectHandler =
        'DynamicField' . $Param{DynamicFieldConfig}->{ObjectType} . 'HandlerObject';

    # If an ObjectType handler is registered, use it.
    if ( ref $Self->{$DynamicFieldObjectHandler} ) {
        my $PostSuccess = $Self->{$DynamicFieldObjectHandler}->PostValueSet(
            %Param,
            Value => $Result->{Value},
        );
    }

    return $Result
}

=item IsMatchable()

returns if the current field backend value can be matched with an object attribute list or not.

    my $Matchable = $BackendObject->IsMatchable(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
    );

    Returns:

    $Matchable                                 # 1 or 0

=cut

sub IsMatchable {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call IsMatchable on the specific backend
    return $Self->{$DynamicFieldBackend}->IsMatchable(
        %Param
    );
}

=item ObjectMatch()

return if the current field values matches with the value got in an objects attribute structure (
like the result of a TicketGet() )

    my $Match = $BackendObject->ObjectMatch(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
        Value              => $Value,                    # single value to match
        ObjectAttributes   => $ObjectAttributes,         # the complete set of attributes from an object
                                                         #      ( i.e. the result of a TicketGet() )
    );

    Returns:

    $Match                                 # 1 or 0

=cut

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ObjectAttributes)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    if ( !defined $Param{Value} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Value!" );
        return;
    }

    # do not perform the action if the ObjectAttributes parameter is empty
    return if !IsHashRefWithData( $Param{ObjectAttributes} );

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call ObjectMatch on the specific backend
    return $Self->{$DynamicFieldBackend}->ObjectMatch(
        %Param
    );
}

=item HistoricalValuesGet()

returns the list of database values for a defined dynamic field. This function is used to calculate
ACLs in Search Dialog

    my $HistorialValues = $BackendObject->HistoricalValuesGet(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
    );

    Returns:

    $HistoricalValues = {
        '1'     => '1',
        'Item1' => 'Item1',
        'Item2' => 'Item2',
    }

=cut

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call HistorialValuesGet on the specific backend
    return $Self->{$DynamicFieldBackend}->HistoricalValuesGet(
        %Param
    );
}

=item ValueLookup()

returns the display value for a value key for a defined Dynamic Field. This function is meaningfull
for those Dynamic Fields that stores a value different than the value that is shown ( e.g. a
Dropdown field could store Key = 1 and Display Value = One ) other fields return the same value
as the value key

    my $Value = $BackendObject->ValueLookup(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
        Key                => 'sotred value',             # could also be an array ref for
                                                         #    MultipleSelect fields
        LanguageObject     => $LanguageObject,            # optional, used to get value translations
    );

    Returns:

    $Value = 'value to display';

=cut

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{DynamicFieldConfig} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need DynamicFieldConfig!" );
        return;
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType Config Name)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # remove LanguageObject param if is not a real LanguageObject
    if ( defined $Param{LanguageObject} && ref $Param{LanguageObject} ne 'Kernel::Language' ) {
        delete $Param{LanguageObject};
    }

    # call ValueLookup on the specific backend
    return $Self->{$DynamicFieldBackend}->ValueLookup(
        %Param,
    );
}

=item PossibleValuesGet()

returns the list of possible values for a dynamic field

    my $PossibleValues = $BackendObject->PossibleValuesGet(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
    );

    Returns:

    $PossibleValues = {
        ''  => '-',             # 'none' value if defined in the dynamic field configuration
        '1' => 'Item1',
        '2' => 'Item2',
    }

=cut

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # verify if function is available
    return if !$Self->{$DynamicFieldBackend}->can('PossibleValuesGet');

    # call PossibleValuesGet on the specific backend
    return $Self->{$DynamicFieldBackend}->PossibleValuesGet(
        %Param
    );
}

=item BuildSelectionDataGet()

returns the list of possible values for a dynamic field as needed for BuildSelection or
BuildSelectionJSON if TreeView parameter is set in the DynamicFieldConfig the result will be
an ArrayHashRef, otherwise the result will be a HashRef.

    my $DataValues = $BackendObject->BuildSelectionDataGet(
        DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
        PossibleValues     => $PossibleValues,           # field possible values (could be reduced
                                                         #    by ACLs)
        Value              => $Value,                    # optional scalar, ArrayRef or HashRef
                                                         #    depending on dynamic field the
    );

    Returns:

    $DataValues = {
        ''  => '-',
        '1' => 'Item1',
        '2' => 'Item2',
    }

    or

    $DataValues = [
        {
            Key   => '',
            Value => '-',
        },
        {
            Key   => '1',
            Value => 'Item1'
        },
        {
            Key      => '1::A',
            Value    => 'Item1-A',
            Disabled => 1,
        },
        {
            Key      => '1::A::1',
            Value    => 'Item1-A-1',
            Selected => 1,
        },
        {
            Key      => '2',
            Value    => 'Item2',
        },
    ];


=cut

sub BuildSelectionDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig PossibleValues)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check DynamicFieldConfig (general)
    if ( !IsHashRefWithData( $Param{DynamicFieldConfig} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The field configuration is invalid",
        );
        return;
    }

    # check DynamicFieldConfig (internally)
    for my $Needed (qw(ID FieldType ObjectType)) {
        if ( !$Param{DynamicFieldConfig}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in DynamicFieldConfig!"
            );
            return;
        }
    }

    # set the dynamic field specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # verify if function is available
    return if !$Self->{$DynamicFieldBackend}->can('BuildSelectionDataGet');

    # call PossibleValuesGet on the specific backend
    return $Self->{$DynamicFieldBackend}->BuildSelectionDataGet(
        %Param
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
