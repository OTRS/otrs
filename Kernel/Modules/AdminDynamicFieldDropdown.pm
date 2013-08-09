# --
# Kernel/Modules/AdminDynamicFieldDropdown.pm - provides a dynamic fields text config view for admins
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldDropdown;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::DynamicField;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );

    # get configured object types
    $Self->{ObjectTypeConfig} = $Self->{ConfigObject}->Get('DynamicFields::ObjectType');

    # get the fields config
    $Self->{FieldTypeConfig} = $Self->{ConfigObject}->Get('DynamicFields::Backend') || {};

    # set possible values handling strings
    $Self->{EmptyString}     = '_DynamicFields_EmptyString_Dont_Use_It_String_Please';
    $Self->{DuplicateString} = '_DynamicFields_DuplicatedString_Dont_Use_It_String_Please';
    $Self->{DeletedString}   = '_DynamicFields_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_AddAction(
            %Param,
        );
    }
    if ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            %Param,
        );
    }
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
        );
    }
    return $Self->{LayoutObject}->ErrorScreen(
        Message => "Undefined subaction.",
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my %GetParam;
    for my $Needed (qw(ObjectType FieldType FieldOrder)) {
        $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );
        if ( !$Needed ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # get the object type and field type display name
    my $ObjectTypeName = $Self->{ObjectTypeConfig}->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName  = $Self->{FieldTypeConfig}->{ $GetParam{FieldType} }->{DisplayName}   || '';

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        Mode           => 'Add',
        ObjectTypeName => $ObjectTypeName,
        FieldTypeName  => $FieldTypeName,
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my %Errors;
    my %GetParam;

    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = 'This field is required.';
        }
    }

    # get the TreeView option and set it to '0' if it is undefined
    $GetParam{TreeView} = $Self->{ParamObject}->GetParam( Param => 'TreeView' );
    $GetParam{TreeView} = defined $GetParam{TreeView} && $GetParam{TreeView} ? '1' : '0';

    if ( $GetParam{Name} ) {

        # check if name is alphanumeric
        if ( $GetParam{Name} !~ m{\A ( ?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                'The field does not contain only ASCII letters and numbers.';
        }

        # check if name is duplicated
        my %DynamicFieldsList = %{
            $Self->{DynamicFieldObject}->DynamicFieldList(
                Valid      => 0,
                ResultType => 'HASH',
                )
        };

        %DynamicFieldsList = reverse %DynamicFieldsList;

        if ( $DynamicFieldsList{ $GetParam{Name} } ) {

            # add server error error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = 'There is another field with the same name.';
        }
    }

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A ( ?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = 'The field must be numeric.';
        }
    }

    for my $ConfigParam (
        qw(
        ObjectType ObjectTypeName FieldType FieldTypeName DefaultValue PossibleNone
        TranslatableValues ValidID Link
        )
        )
    {
        $GetParam{$ConfigParam} = $Self->{ParamObject}->GetParam( Param => $ConfigParam );
    }

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need ValidID",
        );
    }

    my $PossibleValues = $Self->_GetPossibleValues();

    # set errors for possible values entries
    KEY:
    for my $Key ( sort keys %{$PossibleValues} ) {

        # check for empty original values
        if ( $Key =~ m{\A $Self->{EmptyString} (?: \d+)}smx ) {

            # set a true entry in KeyEmptyError
            $Errors{'PossibleValueErrors'}->{'KeyEmptyError'}->{$Key} = 1;
        }

        # otherwise check for duplicate original values
        elsif ( $Key =~ m{\A (.+) - $Self->{DuplicateString} (?: \d+)}smx ) {

            # set an entry in OrigValueDuplicateError with the duplicate key as value
            $Errors{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key} = $1;
        }

        # check for empty new values
        if ( !defined $PossibleValues->{$Key} ) {

            # set a true entry in NewValueEmptyError
            $Errors{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} = 1;
        }
    }

    # return to add screen if errors
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            PossibleValues => $PossibleValues,
            Mode           => 'Add',
        );
    }

    # set specific config
    my $FieldConfig = {
        PossibleValues     => $PossibleValues,
        TreeView           => $GetParam{TreeView},
        DefaultValue       => $GetParam{DefaultValue},
        PossibleNone       => $GetParam{PossibleNone},
        TranslatableValues => $GetParam{TranslatableValues},
        Link               => $GetParam{Link},
    };

    # create a new field
    my $FieldID = $Self->{DynamicFieldObject}->DynamicFieldAdd(
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $GetParam{FieldType},
        ObjectType => $GetParam{ObjectType},
        Config     => $FieldConfig,
        ValidID    => $GetParam{ValidID},
        UserID     => $Self->{UserID},
    );

    if ( !$FieldID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not create the new field",
        );
    }

    return $Self->{LayoutObject}->Redirect(
        OP => "Action=AdminDynamicField",
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %GetParam;
    for my $Needed (qw(ObjectType FieldType)) {
        $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );
        if ( !$Needed ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # get the object type and field type display name
    my $ObjectTypeName = $Self->{ObjectTypeConfig}->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName  = $Self->{FieldTypeConfig}->{ $GetParam{FieldType} }->{DisplayName}   || '';

    my $FieldID = $Self->{ParamObject}->GetParam( Param => 'ID' );

    if ( !$FieldID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need ID",
        );
    }

    # get dynamic field data
    my $DynamicFieldData = $Self->{DynamicFieldObject}->DynamicFieldGet(
        ID => $FieldID,
    );

    # check for valid dynamic field configuration
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not get data for dynamic field $FieldID",
        );
    }

    my %Config = ();

    # extract configuration
    if ( IsHashRefWithData( $DynamicFieldData->{Config} ) ) {

        # set PossibleValues
        $Config{PossibleValues} = {};
        if ( IsHashRefWithData( $DynamicFieldData->{Config}->{PossibleValues} ) ) {
            $Config{PossibleValues} = $DynamicFieldData->{Config}->{PossibleValues};
        }

        # set DefaultValue
        $Config{DefaultValue} = $DynamicFieldData->{Config}->{DefaultValue};

        # set PossibleNone
        $Config{PossibleNone} = $DynamicFieldData->{Config}->{PossibleNone};

        # set TranslatableValues
        $Config{TranslatableValues} = $DynamicFieldData->{Config}->{TranslatableValues};

        # set TreeView
        $Config{TreeView} = $DynamicFieldData->{Config}->{TreeView};

        # set Link
        $Config{Link} = $DynamicFieldData->{Config}->{Link};
    }

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        %${DynamicFieldData},
        %Config,
        ID             => $FieldID,
        Mode           => 'Change',
        ObjectTypeName => $ObjectTypeName,
        FieldTypeName  => $FieldTypeName,
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my %Errors;
    my %GetParam;

    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = 'This field is required.';
        }
    }

    # get the TreeView option and set it to '0' if it is undefined
    $GetParam{TreeView} = $Self->{ParamObject}->GetParam( Param => 'TreeView' );
    $GetParam{TreeView} = defined $GetParam{TreeView} && $GetParam{TreeView} ? '1' : '0';

    my $FieldID = $Self->{ParamObject}->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need ID",
        );
    }

    # get dynamic field data
    my $DynamicFieldData = $Self->{DynamicFieldObject}->DynamicFieldGet(
        ID => $FieldID,
    );

    # check for valid dynamic field configuration
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not get data for dynamic field $FieldID",
        );
    }

    if ( $GetParam{Name} ) {

        # check if name is lowercase
        if ( $GetParam{Name} !~ m{\A ( ?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                'The field does not contain only ASCII letters and numbers.';
        }

        # check if name is duplicated
        my %DynamicFieldsList = %{
            $Self->{DynamicFieldObject}->DynamicFieldList(
                Valid      => 0,
                ResultType => 'HASH',
                )
        };

        %DynamicFieldsList = reverse %DynamicFieldsList;

        if (
            $DynamicFieldsList{ $GetParam{Name} } &&
            $DynamicFieldsList{ $GetParam{Name} } ne $FieldID
            )
        {

            # add server error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = 'There is another field with the same name.';
        }

        # if it's an internal field, it's name should not change
        if (
            $DynamicFieldData->{InternalField} &&
            $DynamicFieldsList{ $GetParam{Name} } ne $FieldID
            )
        {

            # add server error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = 'The name for this field should not change.';
            $Param{InternalField}           = $DynamicFieldData->{InternalField};
        }
    }

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A ( ?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = 'The field must be numeric.';
        }
    }

    for my $ConfigParam (
        qw(
        ObjectType ObjectTypeName FieldType FieldTypeName DefaultValue PossibleNone
        TranslatableValues ValidID Link
        )
        )
    {
        $GetParam{$ConfigParam} = $Self->{ParamObject}->GetParam( Param => $ConfigParam );
    }

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need ValidID",
        );
    }

    my $PossibleValues = $Self->_GetPossibleValues();

    # set errors for possible values entries
    KEY:
    for my $Key ( sort keys %{$PossibleValues} ) {

        # check for empty original values
        if ( $Key =~ m{\A $Self->{EmptyString} (?: \d+)}smx ) {

            # set a true entry in KeyEmptyError
            $Errors{'PossibleValueErrors'}->{'KeyEmptyError'}->{$Key} = 1;
        }

        # otherwise check for duplicate original values
        elsif ( $Key =~ m{\A (.+) - $Self->{DuplicateString} (?: \d+)}smx ) {

            # set an entry in OrigValueDuplicateError with the duplicate key as value
            $Errors{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key} = $1;
        }

        # check for empty new values
        if ( !defined $PossibleValues->{$Key} ) {

            # set a true entry in NewValueEmptyError
            $Errors{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} = 1;
        }
    }

    # return to change screen if errors
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            PossibleValues => $PossibleValues,
            ID             => $FieldID,
            Mode           => 'Change',
        );
    }

    # set specific config
    my $FieldConfig = {
        PossibleValues     => $PossibleValues,
        TreeView           => $GetParam{TreeView},
        DefaultValue       => $GetParam{DefaultValue},
        PossibleNone       => $GetParam{PossibleNone},
        TranslatableValues => $GetParam{TranslatableValues},
        Link               => $GetParam{Link},
    };

    # update dynamic field (FieldType and ObjectType cannot be changed; use old values)
    my $UpdateSuccess = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
        ID         => $FieldID,
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $DynamicFieldData->{FieldType},
        ObjectType => $DynamicFieldData->{ObjectType},
        Config     => $FieldConfig,
        ValidID    => $GetParam{ValidID},
        UserID     => $Self->{UserID},
    );

    if ( !$UpdateSuccess ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not update the field $GetParam{Name}",
        );
    }

    return $Self->{LayoutObject}->Redirect(
        OP => "Action=AdminDynamicField",
    );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    $Param{DisplayFieldName} = 'New';

    if ( $Param{Mode} eq 'Change' ) {
        $Param{ShowWarning}      = 'ShowWarning';
        $Param{DisplayFieldName} = $Param{Name};
    }

    $Param{DeletedString} = $Self->{DeletedString};

    # header
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get all fields
    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    my %DynamicfieldNamesList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
        $DynamicfieldNamesList{ $Dynamicfield->{FieldOrder} } = $Dynamicfield->{Label};
    }

    # when adding we need to create an extra order number for the new field
    if ( $Param{Mode} eq 'Add' ) {

        # get the last element form the order list and add 1
        my $LastOrderNumber = $DynamicfieldOrderList[-1];
        $LastOrderNumber++;

        # add this new order number to the end of the list
        push @DynamicfieldOrderList, $LastOrderNumber;
    }

    # show the names of the other fields to ease ordering
    my %OrderNamesList;
    my $CurrentlyText = $Self->{LayoutObject}->{LanguageObject}->Get('Currently') . ': ';
    for my $OrderNumber ( sort @DynamicfieldOrderList ) {
        $OrderNamesList{$OrderNumber} = $OrderNumber;
        if ( $DynamicfieldNamesList{$OrderNumber} && $OrderNumber ne $Param{FieldOrder} ) {
            $OrderNamesList{$OrderNumber}
                = $OrderNumber . ' - '
                . $CurrentlyText
                . $DynamicfieldNamesList{$OrderNumber}
        }
    }

    my $DynamicFieldOrderStrg = $Self->{LayoutObject}->BuildSelection(
        Data          => \%OrderNamesList,
        Name          => 'FieldOrder',
        SelectedValue => $Param{FieldOrder} || 1,
        PossibleNone  => 0,
        Translation   => 0,
        Sort          => 'NumericKey',
        Class         => 'W75pc Validate_Number',
    );

    my %ValidList = $Self->{ValidObject}->ValidList();

    # create the Validity select
    my $ValidityStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $Param{ValidID} || 1,
        PossibleNone => 0,
        Translation  => 1,
        Class        => 'W50pc',
    );

    # define as 0 to get the real value in the HTML
    my $ValueCounter = 0;

    # set PossibleValues
    my %PossibleValues;
    if ( IsHashRefWithData( $Param{PossibleValues} ) ) {
        %PossibleValues = %{ $Param{PossibleValues} };
    }

    # output the possible values and errors within (if any)
    for my $Key ( sort keys %PossibleValues ) {

        $ValueCounter++;

        # needed for server side validation
        my $KeyError;
        my $KeyErrorStrg;
        my $ValueError;

        # to set the correct original value
        my $KeyClone = $Key;

        # check for errors
        if ( $Param{'PossibleValueErrors'} ) {

            # check for errors on original value (empty)
            if ( $Param{'PossibleValueErrors'}->{'KeyEmptyError'}->{$Key} ) {

                # if the original value was empty it has been changed in _GetParams to a predefined
                # string and need to be set to empty again
                $KeyClone = '';

                # set the error class
                $KeyError     = 'ServerError';
                $KeyErrorStrg = 'This field is required.'
            }

            # check for errors on original value (duplicate)
            elsif ( $Param{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key} ) {

                # if the original value was empty it has been changed in _GetParams to a predefined
                # string and need to be set to the original value again
                $KeyClone
                    = $Param{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key};

                # set the error class
                $KeyError     = 'ServerError';
                $KeyErrorStrg = 'This field value is duplicated.'
            }

            # check for error on value
            if ( $Param{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} ) {

                # set the error class
                $ValueError = 'ServerError';
            }
        }

        # create a value map row
        $Self->{LayoutObject}->Block(
            Name => 'ValueRow',
            Data => {
                KeyError     => $KeyError,
                KeyErrorStrg => $KeyErrorStrg || 'This field is required.',
                Key          => $KeyClone,
                ValueCounter => $ValueCounter,
                Value        => $PossibleValues{$Key},
                ValueError   => $ValueError,
            },
        );
    }

    # create the possible values template
    $Self->{LayoutObject}->Block(
        Name => 'ValueTemplate',
        Data => {
            %Param,
        },
    );

    # check and build the Default Value list based on Possible Values
    my %DefaultValuesList;
    POSSIBLEVALUE:
    for my $ValueItem ( sort keys %PossibleValues ) {
        next POSSIBLEVALUE if !defined $ValueItem;
        next POSSIBLEVALUE if !defined $PossibleValues{$ValueItem};
        $DefaultValuesList{$ValueItem} = $PossibleValues{$ValueItem}
    }

    my $DefaultValue = ( defined $Param{DefaultValue} ? $Param{DefaultValue} : '' );

    # create the default value select
    my $DefaultValueStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \%DefaultValuesList,
        Name         => 'DefaultValue',
        SelectedID   => $DefaultValue,
        PossibleNone => 1,

        # Don't make is translatable because this will confuse the user (also current JS
        # is not prepared)
        Translation => 0,

        # Multiple selections are currently not supported
        Multiple => 0,
        Class    => 'W50pc',
    );

    my $PossibleNone = $Param{PossibleNone} || '0';

    # create translatable values option list
    my $PossibleNoneStrg = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'PossibleNone',
        SelectedID => $PossibleNone,
        Class      => 'W50pc',
    );

    my $TranslatableValues = $Param{TranslatableValues} || '0';

    # create translatable values option list
    my $TranslatableValuesStrg = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'TranslatableValues',
        SelectedID => $TranslatableValues,
        Class      => 'W50pc',
    );

    my $TreeView = $Param{TreeView} || '0';

    # create treeview option list
    my $TreeViewStrg = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'TreeView',
        SelectedID => $TreeView,
        Class      => 'W50pc',
    );

    my $Link = $Param{Link} || '';

    my $ReadonlyInternalField = '';

    # Internal fields can not be deleted and name should not change.
    if ( $Param{InternalField} ) {
        $Self->{LayoutObject}->Block(
            Name => 'InternalField',
            Data => {%Param},
        );
        $ReadonlyInternalField = 'readonly="readonly"';
    }

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminDynamicFieldDropdown',
        Data         => {
            %Param,
            ValidityStrg           => $ValidityStrg,
            DynamicFieldOrderStrg  => $DynamicFieldOrderStrg,
            ValueCounter           => $ValueCounter,
            DefaultValueStrg       => $DefaultValueStrg,
            PossibleNoneStrg       => $PossibleNoneStrg,
            TreeViewStrg           => $TreeViewStrg,
            TranslatableValuesStrg => $TranslatableValuesStrg,
            ReadonlyInternalField  => $ReadonlyInternalField,
            Link                   => $Link,
            }
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GetPossibleValues {
    my ( $Self, %Param ) = @_;

    my $PossibleValueConfig;

    # get parameters from web browser
    # get ValueCounters
    my $ValueCounter          = $Self->{ParamObject}->GetParam( Param => 'ValueCounter' ) || 0;
    my $EmptyValueCounter     = 0;
    my $DuplicateValueCounter = 0;

    # get possible values
    my $Values;
    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {
        my $Key = $Self->{ParamObject}->GetParam( Param => 'Key' . '_' . $ValueIndex );
        $Key = ( defined $Key ? $Key : '' );

        # check if key was deleted by the user and skip it
        next VALUEINDEX if $Key eq $Self->{DeletedString};

        # check if the original value is empty
        if ( $Key eq '' ) {

            # change the empty value to a predefined string
            $Key = $Self->{EmptyString} . int $EmptyValueCounter;
            $EmptyValueCounter++;
        }

        # otherwise check for duplicate
        elsif ( exists $PossibleValueConfig->{$Key} ) {

            # append a predefined unique string to make this value unique
            $Key .= '-' . $Self->{DuplicateString} . $DuplicateValueCounter;
            $DuplicateValueCounter++;
        }

        my $Value = $Self->{ParamObject}->GetParam( Param => 'Value' . '_' . $ValueIndex );
        $Value = ( defined $Value ? $Value : '' );
        $PossibleValueConfig->{$Key} = $Value;
    }
    return $PossibleValueConfig;
}

1;
