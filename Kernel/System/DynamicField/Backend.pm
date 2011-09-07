# --
# Kernel/System/DynamicField/Backend.pm - Interface for DynamicField backends
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Backend.pm,v 1.28 2011-09-07 21:06:02 cg Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

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

=item EditLabelRender()

creates the label HTML to be used in edit masks.

    my $LabelHTML = $BackendObject->EditLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub EditLabelRender { }

=item EditFieldRender()

creates the field HTML to be used in edit masks.

    my $FieldHTML = $BackendObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,      # complete config of the DynamicField
        PossibleValuesFilter => ['value1', 'value2'],     # Optional. Some backends may support this.
                                                          #     This may be needed to realize ACL support for ticket masks,
                                                          #     where the possible values can be limited with and ACL.
        Value              => 'Any value',                # Optional
        Mandatory          => 1,                          # 0 or 1,
        Class              => 'AnyCSSClass OrOneMore',   # Optional
        ServerError        => 1,                          # 0 or 1,
        ErrorMessage       => $ErrorMessage,              # Optional or a default will be used in error case
    );

=cut

sub EditFieldRender {
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
    for my $Needed (qw(ID FieldType ObjectType)) {
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
        && !IsHashRefWithData( $Param{PossibleValuesFilter} )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "The possible values filter is invalid",
        );
        return;
    }

    # set the dynamic filed specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # call EditFieldRender on the specific backend
    my $HTMLStrings = $Self->{$DynamicFieldBackend}->EditFieldRender(
        %Param
    );

    return $HTMLStrings;

}

=item DisplayLabelRender()

creates the label HTML to be used in display masks.

    my $LabelHTML = $BackendObject->DisplayLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub DisplayLabelRender { }

=item DisplayFieldRender()

creates the field HTML to be used in display masks.

    my $FieldHTML = $BackendObject->DisplayFieldRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        Mandatory          => 1,                        # 0 or 1,
    );

=cut

sub DisplayFieldRender { }

=item HandleEditRequest()

when a form with dynamic fields was submitted, this function will handle the request by
extracting the request parameter(s) for the current dynamic field and storing the value in the database.

    my $Success = $BackendObject->HandleEditRequest(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field must be linked to, e. g. TicketID
        ParamObject        => $ParamObject,             # the current request data
    );

=cut

sub HandleEditRequest { }

=item EditFieldValueGet()

extracts the value of a dynamic field from the param object

    my $Value = $BackendObject->EditFieldValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ParamObject        => $ParamObject,             # the current request data
    );

    Returns

    $Value = $Value                                     # depending on each field type e.g.
                                                        #   $Value = 'a text';
                                                        #   $Value = '1977-12-12 12:00:00';
                                                        #   $Value = 1;

=cut

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DynamicFieldConfig ParamObject)) {
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

    # set the dynamic filed specific backend
    my $DynamicFieldBackend = 'DynamicField' . $Param{DynamicFieldConfig}->{FieldType} . 'Object';

    if ( !$Self->{$DynamicFieldBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{DynamicFieldConfig}->{FieldType} is invalid!"
        );
        return;
    }

    # return GetParam from the specific backend
    return $Self->{$DynamicFieldBackend}->EditFieldValueGet(%Param);
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

    # set the dynamic filed specific backend
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
    if ( defined $OldValue && defined $NewValue && $OldValue eq $NewValue ) {
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

    # set the dyanamic filed object handler
    my $DynamicFieldObjectHandler =
        'DynamicField' . $Param{DynamicFieldConfig}->{ObjectType} . 'HandlerObject';

    # If an ObjectType handler is registered, use it.
    if ( ref $Self->{$DynamicFieldObjectHandler} ) {
        return $Self->{$DynamicFieldObjectHandler}->PostValueSet(%Param);
    }

    return 1;
}

=item ValueGet()

get a dynamic field value.

    my $Value = $BackendObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
    );

    Return

    $Value = $AValue                                    # depends on backend type, i. e.
                                                        # Text, $Value =  'a string'
                                                        # DateTime, $Value = '1977-12-12 12:00:00'
                                                        # Chackbox, $Value = 1
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

=item IsSearchable()

returns if the current field backend is searchable or not.

    my $Searchable = $BackendObject->IsSearchable();   # 1 or 0

=cut

sub IsSearchable { }

=item FieldRequestedInSearch()

determines if the current search request

    my $SQL = $BackendObject->FieldRequestedInSearch(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchParams       => $SearchParams,            # current search parameters
    );

=cut

# TODO: search SQL may need operator for free time fields (older/newer), depends on HTML structure
sub FieldRequestedInSearch { }

=item SearchSQLGet()

returns the SQL WHERE part that needs to be used to search in a particular
dynamic field. The table must already be joined.

    my $SQL = $BackendObject->SearchSQLGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        TableAlias         => $TableAlias,              # the alias of the already joined dynamic_field_value table to use
        SearchTerm         => $SearchTerm,
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

=item SearchLabelRender()

creates the label HTML to be used in edit masks.

    my $FieldHTML = $BackendObject->SearchLabelRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchTemplate     => $TemplateDate,            # optional, search template data to load
    );

=cut

sub SearchLabelRender { }

=item SearchFieldRender()

creates the field HTML to be used in search masks.

    my $FieldHTML = $BackendObject->SearchFieldRender(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        SearchTemplate     => $TemplateDate,            # optional, search template data to load
    );

=cut

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.28 $ $Date: 2011-09-07 21:06:02 $

=cut
