# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminDynamicFieldText;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

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
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->ErrorScreen(
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

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    if ( $GetParam{Name} ) {

        # check if name is alphanumeric
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                'The field does not contain only ASCII letters and numbers.';
        }

        # check if name is duplicated
        my %DynamicFieldsList = %{
            $DynamicFieldObject->DynamicFieldList(
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
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = 'The field must be numeric.';
        }
    }

    for my $ConfigParam (
        qw(ObjectType ObjectTypeName FieldType FieldTypeName DefaultValue ValidID Rows Cols Link)
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    $GetParam{RegExCounter} = $ParamObject->GetParam( Param => 'RegExCounter' ) || 0;

    my @RegExList = $Self->GetParamRegexList(
        GetParam => \%GetParam,
        Errors   => \%Errors,
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need ValidID",
        );
    }

    # return to add screen if errors
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            Mode => 'Add',
        );
    }

    # set specific config
    my $FieldConfig = {
        DefaultValue => $GetParam{DefaultValue},
        RegExList    => \@RegExList,
    };

    if ( $GetParam{FieldType} eq 'Text' ) {
        $FieldConfig->{Link} = $GetParam{Link},
    }

    if ( $GetParam{FieldType} eq 'TextArea' ) {
        $FieldConfig->{Rows} = $GetParam{Rows};
        $FieldConfig->{Cols} = $GetParam{Cols};
    }

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
        %Config = %{ $DynamicFieldData->{Config} };
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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $FieldID = $ParamObject->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need ID",
        );
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get dynamic field data
    my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
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

        # check if name is duplicated
        my %DynamicFieldsList = %{
            $DynamicFieldObject->DynamicFieldList(
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
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = 'The field must be numeric.';
        }
    }

    for my $ConfigParam (
        qw(ObjectType ObjectTypeName FieldType FieldTypeName DefaultValue ValidID Rows Cols Link)
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    $GetParam{RegExCounter} = $ParamObject->GetParam( Param => 'RegExCounter' ) || 0;

    my @RegExList = $Self->GetParamRegexList(
        GetParam => \%GetParam,
        Errors   => \%Errors,
    );

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need ValidID",
        );
    }

    # only for textarea
    if ( $GetParam{FieldType} eq 'TextArea' ) {
        if ( $GetParam{Rows} ) {

            # check if field order is numeric and positive
            if ( $GetParam{Rows} !~ m{\A (?: \d )+ \z}xms ) {

                # add server error error class
                $Errors{RowsServerError}        = 'ServerError';
                $Errors{RowsServerErrorMessage} = 'The field must be numeric.';
            }
        }
        if ( $GetParam{Cols} ) {

            # check if field order is numeric and positive
            if ( $GetParam{Cols} !~ m{\A (?: \d )+ \z}xms ) {

                # add server error error class
                $Errors{ColsServerError}        = 'ServerError';
                $Errors{ColsServerErrorMessage} = 'The field must be numeric.';
            }
        }
    }

    # return to change screen if errors
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            ID   => $FieldID,
            Mode => 'Change',
        );
    }

    # set specific config
    my $FieldConfig = {
        DefaultValue => $GetParam{DefaultValue},
        RegExList    => \@RegExList,
    };

    if ( $GetParam{FieldType} eq 'Text' ) {
        $FieldConfig->{Link} = $GetParam{Link};
    }

    if ( $GetParam{FieldType} eq 'TextArea' ) {
        $FieldConfig->{Rows} = $GetParam{Rows};
        $FieldConfig->{Cols} = $GetParam{Cols};
    }

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get all fields
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
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

    # define config field specific settings
    my $DefaultValue = ( defined $Param{DefaultValue} ? $Param{DefaultValue} : '' );

    # create the default value element
    $LayoutObject->Block(
        Name => 'DefaultValue' . $Param{FieldType},
        Data => {
            %Param,
            DefaultValue => $DefaultValue,
        },
    );

    # define config field specific settings
    my $Link = $Param{Link} || '';

    if ( $Param{FieldType} eq 'Text' ) {

        # create the default link element
        $LayoutObject->Block(
            Name => 'Link',
            Data => {
                %Param,
                Link => $Link,
            },
        );
    }

    if ( $Param{FieldType} eq 'TextArea' ) {

        # create the default value element
        $LayoutObject->Block(
            Name => 'ColsRowsValues',
            Data => {
                %Param,
                Rows => $Param{Rows},
                Cols => $Param{Cols},
            },
        );
    }

    my $ReadonlyInternalField = '';

    # Internal fields can not be deleted and name should not change.
    if ( $Param{InternalField} ) {
        $LayoutObject->Block(
            Name => 'InternalField',
            Data => {%Param},
        );
        $ReadonlyInternalField = 'readonly="readonly"';
    }

    # get the field id
    my $FieldID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ID' );

    # only if the dymamic field exists and should be edited,
    # not if the field is added for the first time
    if ($FieldID) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $FieldID,
        );

        my $FieldConfig = $DynamicField->{Config};

        if ( !$Param{RegExCounter} ) {

            my $RegExCounter = 0;
            for my $RegEx ( @{ $FieldConfig->{RegExList} } ) {

                $RegExCounter++;
                $Param{ 'RegEx_' . $RegExCounter }                     = $RegEx->{Value};
                $Param{ 'CustomerRegExErrorMessage_' . $RegExCounter } = $RegEx->{ErrorMessage};
            }

            $Param{RegExCounter} = $RegExCounter;
        }

        if ( $Param{RegExCounter} ) {

            REGEXENTRY:
            for my $CurrentRegExEntryID ( 1 .. $Param{RegExCounter} ) {

                # check existing regex
                next REGEXENTRY if !$Param{ 'RegEx_' . $CurrentRegExEntryID };

                $LayoutObject->Block(
                    Name => 'RegExRow',
                    Data => {
                        EntryCounter => $CurrentRegExEntryID,
                        RegEx        => $Param{ 'RegEx_' . $CurrentRegExEntryID },
                        RegExServerError =>
                            $Param{ 'RegEx_' . $CurrentRegExEntryID . 'ServerError' }
                            || '',
                        RegExServerErrorMessage =>
                            $Param{ 'RegEx_' . $CurrentRegExEntryID . 'ServerErrorMessage' } || '',
                        CustomerRegExErrorMessage =>
                            $Param{ 'CustomerRegExErrorMessage_' . $CurrentRegExEntryID },
                        CustomerRegExErrorMessageServerError =>
                            $Param{
                            'CustomerRegExErrorMessage_'
                                . $CurrentRegExEntryID
                                . 'ServerError'
                            }
                            || '',
                        CustomerRegExErrorMessageServerErrorMessage =>
                            $Param{
                            'CustomerRegExErrorMessage_'
                                . $CurrentRegExEntryID
                                . 'ServerErrorMessage'
                            }
                            || '',
                        }
                );
            }
        }
    }

    # generate output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldText',
        Data         => {
            %Param,
            RegExCounter          => $Param{RegExCounter},
            ValidityStrg          => $ValidityStrg,
            DynamicFieldOrderStrg => $DynamicFieldOrderStrg,
            DefaultValue          => $DefaultValue,
            ReadonlyInternalField => $ReadonlyInternalField,
            Link                  => $Link,
            }
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub GetParamRegexList {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Param{GetParam};
    my $Errors   = $Param{Errors};
    my @RegExList;

    # Check regex list
    if ( $GetParam->{RegExCounter} && $GetParam->{RegExCounter} =~ m{\A\d+\z}xms ) {

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        REGEXENTRY:
        for my $CurrentRegExEntryID ( 1 .. $GetParam->{RegExCounter} ) {

            # check existing regex
            $GetParam->{ 'RegEx_' . $CurrentRegExEntryID }
                = $ParamObject->GetParam( Param => 'RegEx_' . $CurrentRegExEntryID );

            next REGEXENTRY if !$GetParam->{ 'RegEx_' . $CurrentRegExEntryID };

            $GetParam->{ 'CustomerRegExErrorMessage_' . $CurrentRegExEntryID }
                = $ParamObject->GetParam( Param => 'CustomerRegExErrorMessage_' . $CurrentRegExEntryID );

            my $RegEx                     = $GetParam->{ 'RegEx_' . $CurrentRegExEntryID };
            my $CustomerRegExErrorMessage = $GetParam->{ 'CustomerRegExErrorMessage_' . $CurrentRegExEntryID };

            # is the regex valid?
            my $RegExCheck = eval {
                qr{$RegEx}xms
            };

            my $CurrentEntryErrors = 0;
            if ($@) {
                $Errors->{ 'RegEx_' . $CurrentRegExEntryID . 'ServerError' } = 'ServerError';

                # cut last part of regex error
                # 'Invalid regular expression (Unmatched [ in regex; marked by
                # <-- HERE in m/aaa[ <-- HERE / at
                # /opt/otrs/bin/cgi-bin/../../Kernel/Modules/AdminDynamicFieldText.pm line 452..
                my $ServerErrorMessage = $@;
                $ServerErrorMessage =~ s{ (in \s regex); .*$ }{ $1 }xms;
                $Errors->{ 'RegEx_' . $CurrentRegExEntryID . 'ServerErrorMessage' } = $ServerErrorMessage;

                $CurrentEntryErrors = 1;
            }

            # check required error message for regex
            if ( !$CustomerRegExErrorMessage ) {
                $Errors->{ 'CustomerRegExErrorMessage_' . $CurrentRegExEntryID . 'ServerError' } = 'ServerError';
                $Errors->{
                    'CustomerRegExErrorMessage_'
                        . $CurrentRegExEntryID
                        . 'ServerErrorMessage'
                } = 'This field is required.';

                $CurrentEntryErrors = 1;
            }

            next REGEXENTRY if $CurrentEntryErrors;

            push @RegExList, {
                'Value'        => $RegEx,
                'ErrorMessage' => $CustomerRegExErrorMessage,
            };
        }
    }

    return @RegExList;
}

1;
