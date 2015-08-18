# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldMultiselect;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    # set possible values handling strings
    $Self->{EmptyString}     = '_DynamicFields_EmptyString_Dont_Use_It_String_Please';
    $Self->{DuplicateString} = '_DynamicFields_DuplicatedString_Dont_Use_It_String_Please';
    $Self->{DeletedString}   = '_DynamicFields_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

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
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
        );
    }
    return $LayoutObject->ErrorScreen(
        Message => "Undefined subaction.",
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my %GetParam;
    for my $Needed (qw(ObjectType FieldType FieldOrder)) {
        $GetParam{$Needed} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Needed );
        if ( !$Needed ) {
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout') > ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # get the object type and field type display name
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ObjectTypeName
        = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName} || '';

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
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = 'This field is required.';
        }
    }

    # get the TreeView option and set it to '0' if it is undefined
    $GetParam{TreeView} = $ParamObject->GetParam( Param => 'TreeView' );
    $GetParam{TreeView} = defined $GetParam{TreeView} && $GetParam{TreeView} ? '1' : '0';

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    if ( $GetParam{Name} ) {

        # check if name is alphanumeric
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                'The field does not contain only ASCII letters and numbers.';
        }

        # get dynamic field list
        my $DynamicFieldsList = $DynamicFieldObject->DynamicFieldList(
            Valid      => 0,
            ResultType => 'HASH',
        ) || {};

        # check if name is duplicated
        my %DynamicFieldsList = %{$DynamicFieldsList};
        %DynamicFieldsList = reverse %DynamicFieldsList;

        if ( $DynamicFieldsList{ $GetParam{Name} } ) {

            # add server error error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = 'There is another field with the same name.';
        }
    }

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = 'The field must be numeric.';
        }
    }

    for my $ConfigParam (
        qw(
        ObjectType ObjectTypeName FieldType FieldTypeName DefaultValue PossibleNone
        TranslatableValues ValidID
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
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
    };

    # create a new field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
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
        return $LayoutObject->ErrorScreen(
            Message => "Could not create the new field",
        );
    }

    return $LayoutObject->Redirect(
        OP => "Action=AdminDynamicField",
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my %GetParam;

    for my $Needed (qw(ObjectType FieldType)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$Needed ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need $Needed",
            );
        }
    }

    # get the object type and field type display name
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ObjectTypeName
        = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName} || '';

    my $FieldID = $ParamObject->GetParam( Param => 'ID' );

    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need ID",
        );
    }

    # get dynamic field data
    my $DynamicFieldData = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        ID => $FieldID,
    );

    # check for valid dynamic field configuration
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $LayoutObject->ErrorScreen(
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

        # set TranslatalbeValues
        $Config{TranslatableValues} = $DynamicFieldData->{Config}->{TranslatableValues};

        # set TreeView
        $Config{TreeView} = $DynamicFieldData->{Config}->{TreeView};
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
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = 'This field is required.';
        }
    }

    # get the TreeView option and set it to '0' if it is undefined
    $GetParam{TreeView} = $ParamObject->GetParam( Param => 'TreeView' );
    $GetParam{TreeView} = defined $GetParam{TreeView} && $GetParam{TreeView} ? '1' : '0';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $FieldID = $ParamObject->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need ID",
        );
    }

    # get dynamic field data
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldData   = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    # check for valid dynamic field configuration
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $LayoutObject->ErrorScreen(
            Message => "Could not get data for dynamic field $FieldID",
        );
    }

    if ( $GetParam{Name} ) {

        # check if name is lowercase
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                'The field does not contain only ASCII letters and numbers.';
        }

        # get dynamic field list
        my $DynamicFieldsList = $DynamicFieldObject->DynamicFieldList(
            Valid      => 0,
            ResultType => 'HASH',
        ) || {};

        # check if name is duplicated
        my %DynamicFieldsList = %{$DynamicFieldsList};
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
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = 'The field must be numeric.';
        }
    }

    for my $ConfigParam (
        qw(
        ObjectType ObjectTypeName FieldType FieldTypeName PossibleNone
        TranslatableValues ValidID
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    # get default values
    my @DefaultValues = $ParamObject->GetArray( Param => 'DefaultValue' );
    $GetParam{DefaultValue} = \@DefaultValues;

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
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
    };

    # update dynamic field (FieldType and ObjectType cannot be changed; use old values)
    my $UpdateSuccess = $DynamicFieldObject->DynamicFieldUpdate(
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
        return $LayoutObject->ErrorScreen(
            Message => "Could not update the field $GetParam{Name}",
        );
    }

    return $LayoutObject->Redirect(
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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # get all fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
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
    my $CurrentlyText = $LayoutObject->{LanguageObject}->Translate('Currently') . ': ';
    for my $OrderNumber ( sort @DynamicfieldOrderList ) {
        $OrderNamesList{$OrderNumber} = $OrderNumber;
        if ( $DynamicfieldNamesList{$OrderNumber} && $OrderNumber ne $Param{FieldOrder} ) {
            $OrderNamesList{$OrderNumber} = $OrderNumber . ' - '
                . $CurrentlyText
                . $DynamicfieldNamesList{$OrderNumber}
        }
    }

    my $DynamicFieldOrderStrg = $LayoutObject->BuildSelection(
        Data          => \%OrderNamesList,
        Name          => 'FieldOrder',
        SelectedValue => $Param{FieldOrder} || 1,
        PossibleNone  => 0,
        Translation   => 0,
        Sort          => 'NumericKey',
        Class         => 'Modernize W75pc Validate_Number',
    );

    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # create the Validity select
    my $ValidityStrg = $LayoutObject->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $Param{ValidID} || 1,
        PossibleNone => 0,
        Translation  => 1,
        Class        => 'Modernize W50pc',
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
                $KeyClone = $Param{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key};

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
        $LayoutObject->Block(
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
    $LayoutObject->Block(
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
    my $DefaultValueStrg = $LayoutObject->BuildSelection(
        Data         => \%DefaultValuesList,
        Name         => 'DefaultValue',
        SelectedID   => $DefaultValue,
        PossibleNone => 1,

        # Don't make is translatable because this will confuse the user (also current JS
        # is not prepared)
        Translation => 0,

        #        # Multiple selections, now is going to be supported
        Multiple => 1,
        Class    => 'Modernize W50pc',
    );

    my $PossibleNone = $Param{PossibleNone} || '0';

    # create translatable values option list
    my $PossibleNoneStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'PossibleNone',
        SelectedID => $PossibleNone,
        Class      => 'Modernize W50pc',
    );

    my $TranslatableValues = $Param{TranslatableValues} || '0';

    # create translatable values option list
    my $TranslatableValuesStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'TranslatableValues',
        SelectedID => $TranslatableValues,
        Class      => 'Modernize W50pc',
    );

    my $TreeView = $Param{TreeView} || '0';

    # create treeview option list
    my $TreeViewStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name       => 'TreeView',
        SelectedID => $TreeView,
        Class      => 'Modernize W50pc',
    );

    my $ReadonlyInternalField = '';

    # Internal fields can not be deleted and name should not change.
    if ( $Param{InternalField} ) {
        $LayoutObject->Block(
            Name => 'InternalField',
            Data => {%Param},
        );
        $ReadonlyInternalField = 'readonly="readonly"';
    }

    # generate output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldMultiselect',
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
            }
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetPossibleValues {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
    # get ValueCounters
    my $ValueCounter          = $ParamObject->GetParam( Param => 'ValueCounter' ) || 0;
    my $EmptyValueCounter     = 0;
    my $DuplicateValueCounter = 0;
    my $PossibleValueConfig;

    # get possible values
    my $Values;
    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {
        my $Key = $ParamObject->GetParam( Param => 'Key' . '_' . $ValueIndex );
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

        my $Value = $ParamObject->GetParam( Param => 'Value' . '_' . $ValueIndex );
        $Value = ( defined $Value ? $Value : '' );
        $PossibleValueConfig->{$Key} = $Value;
    }
    return $PossibleValueConfig;
}

1;
