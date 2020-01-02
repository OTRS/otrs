# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceMappingSimple;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{DeletedString} = '_GenericInterface_Mapping_Simple_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $WebserviceID = $ParamObject->GetParam( Param => 'WebserviceID' ) || '';
    my $Operation    = $ParamObject->GetParam( Param => 'Operation' )    || '';
    my $Invoker      = $ParamObject->GetParam( Param => 'Invoker' )      || '';
    my $Direction    = $ParamObject->GetParam( Param => 'Direction' )    || '';

    my $CommunicationType = IsStringWithData($Operation) ? 'Provider'  : 'Requester';
    my $ActionType        = IsStringWithData($Operation) ? 'Operation' : 'Invoker';
    my $Action = $Operation || $Invoker;

    # Set mapping direction for display.
    my $MappingDirection = $Direction eq 'MappingOutbound'
        ? Translatable('Simple Mapping for Outgoing Data')
        : Translatable('Simple Mapping for Incoming Data');

    # Get configured Actions.
    my $ActionsConfig = $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $ActionType . '::Module' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Check for valid action backend.
    if ( !IsHashRefWithData($ActionsConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}
                ->Translate( 'Could not get registered configuration for action type %s', $ActionType ),
        );
    }

    # Check for WebserviceID.
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    # Get web service object.
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # Get web service configuration
    my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    # Get the action type (back-end).
    my $ActionBackend = $WebserviceData->{Config}->{$CommunicationType}->{$ActionType}->{$Action}->{'Type'};

    # Check for valid action backend.
    if ( !$ActionBackend ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get backend for %s %s', $ActionType, $Action ),
        );
    }

    # Get the configuration dialog for the action.
    my $ActionFrontendModule = $ActionsConfig->{$ActionBackend}->{'ConfigDialog'};

    my $WebserviceName = $WebserviceData->{Name};

    # -------------------------------------------------------------- #
    # sub-action Add or Change: load web service and show edit screen
    # -------------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # Recreate structure for edit.
        my %Mapping;

        my $MappingConfig = $WebserviceData->{Config}->{$CommunicationType}->
            {$ActionType}->{$Action}->{$Direction}->{Config};

        $Mapping{DefaultKeyMapTo} = $MappingConfig->{KeyMapDefault}->{MapTo};
        $Mapping{DefaultKeyType}  = $MappingConfig->{KeyMapDefault}->{MapType};

        $Mapping{DefaultValueMapTo} = $MappingConfig->{ValueMapDefault}->{MapTo};
        $Mapping{DefaultValueType}  = $MappingConfig->{ValueMapDefault}->{MapType};

        # Add saved values.
        my $KeyIndex = 0;
        for my $KeyMapType (qw( KeyMapExact KeyMapRegEx )) {
            for my $Key ( sort keys %{ $MappingConfig->{$KeyMapType} } ) {
                $KeyIndex++;
                my $NewKey = $MappingConfig->{$KeyMapType}->{$Key};

                $Mapping{ 'KeyName' . $KeyIndex }        = $Key;
                $Mapping{ 'KeyMapNew' . $KeyIndex }      = $NewKey;
                $Mapping{ 'KeyMapTypeStrg' . $KeyIndex } = $KeyMapType;

                my $ValueIndex = 0;
                for my $ValueMapType (qw( ValueMapExact ValueMapRegEx )) {
                    for my $ValueName (
                        sort keys %{ $MappingConfig->{ValueMap}->{$NewKey}->{$ValueMapType} }
                        )
                    {
                        $ValueIndex++;
                        my $NewVal = $MappingConfig->{ValueMap}->{$NewKey}->{$ValueMapType}->{$ValueName};

                        $Mapping{ 'ValueName' . $KeyIndex . '_' . $ValueIndex }        = $ValueName;
                        $Mapping{ 'ValueMapNew' . $KeyIndex . '_' . $ValueIndex }      = $NewVal;
                        $Mapping{ 'ValueMapTypeStrg' . $KeyIndex . '_' . $ValueIndex } = $ValueMapType;
                    }
                }

                # Set value index.
                $Mapping{ 'ValueCounter' . $KeyIndex } = $ValueIndex;
            }
        }

        # Set Key index.
        $Mapping{'KeyCounter'} = $KeyIndex;

        return $Self->_ShowEdit(
            %Param,
            WebserviceID         => $WebserviceID,
            WebserviceName       => $WebserviceName,
            WebserviceData       => \%Mapping,
            Operation            => $Operation,
            Invoker              => $Invoker,
            Direction            => $Direction,
            MappingDirection     => $MappingDirection,
            CommunicationType    => $CommunicationType,
            ActionType           => $ActionType,
            Action               => $Action,
            ActionFrontendModule => $ActionFrontendModule,
            Subaction            => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # sub-action ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #
    else {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $GetParam = $Self->_GetParams();

        # Ff there is an error return to edit screen
        if ( $GetParam->{Error} ) {
            return $Self->_ShowEdit(
                %Param,
                WebserviceID         => $WebserviceID,
                WebserviceName       => $WebserviceName,
                WebserviceData       => $GetParam,
                Operation            => $Operation,
                Invoker              => $Invoker,
                Direction            => $Direction,
                MappingDirection     => $MappingDirection,
                CommunicationType    => $CommunicationType,
                ActionType           => $ActionType,
                Action               => $Action,
                ActionFrontendModule => $ActionFrontendModule,
                Subaction            => 'Change',
            );
        }

        my %NewMapping;

        # Set default key.
        $NewMapping{KeyMapDefault}->{MapType} = $GetParam->{DefaultKeyType};
        $NewMapping{KeyMapDefault}->{MapTo}   = $GetParam->{DefaultKeyMapTo};

        # Set default value.
        $NewMapping{ValueMapDefault}->{MapType} = $GetParam->{DefaultValueType};
        $NewMapping{ValueMapDefault}->{MapTo}   = $GetParam->{DefaultValueMapTo};

        for my $KeyCounter ( 1 .. $GetParam->{KeyCounter} ) {
            $NewMapping{ $GetParam->{ 'KeyMapTypeStrg' . $KeyCounter } }->{ $GetParam->{ 'KeyName' . $KeyCounter } }
                = $GetParam->{ 'KeyMapNew' . $KeyCounter };

            for my $ValueCounter ( 1 .. $GetParam->{ 'ValueCounter' . $KeyCounter } ) {
                $NewMapping{ValueMap}->{ $GetParam->{ 'KeyMapNew' . $KeyCounter } }
                    ->{ $GetParam->{ 'ValueMapTypeStrg' . $KeyCounter . '_' . $ValueCounter } }
                    ->{ $GetParam->{ 'ValueName' . $KeyCounter . '_' . $ValueCounter } }
                    = $GetParam->{ 'ValueMapNew' . $KeyCounter . '_' . $ValueCounter };
            }
        }

        # Set new mapping.
        $WebserviceData->{Config}->{$CommunicationType}->{$ActionType}->{$Action}->{$Direction}->{Config}
            = \%NewMapping;

        # Save configuration and return to edit or overview screen.
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # Check for successful web service update.
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not update configuration data for WebserviceID %s', $WebserviceID ),
            );
        }

        # If the user would like to continue editing the invoker config, just redirect to the edit screen
        my $RedirectURL;
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {

            $RedirectURL =
                'Action='
                . $Self->{Action}
                . ';Subaction=Change;WebserviceID='
                . $WebserviceID
                . ";$ActionType="
                . $LayoutObject->LinkEncode($Action)
                . ';Direction='
                . $Direction
                . ';';
        }
        else {

            # Otherwise return to overview.
            $RedirectURL =
                'Action='
                . $ActionFrontendModule
                . ';Subaction=Change;'
                . ";$ActionType="
                . $LayoutObject->LinkEncode($Action)
                . ';WebserviceID='
                . $WebserviceID
                . ';';
        }

        return $LayoutObject->Redirect(
            OP => $RedirectURL,
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # Set action for go back button.
    $Param{LowerCaseActionType} = lc $Param{ActionType};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my $MappingConfig = $Param{WebserviceData};
    my %Error;
    if ( defined $Param{WebserviceData}->{Error} ) {
        %Error = %{ $Param{WebserviceData}->{Error} };
    }
    $Param{DeletedString} = $Self->{DeletedString};

    $Param{DefaultKeyMapTo} = $MappingConfig->{DefaultKeyMapTo};

    my $DefaultKeyType = $MappingConfig->{DefaultKeyType} || '';
    $Param{DefaultKeyMapToHidden} = $DefaultKeyType ne 'MapTo' ? 'Hidden' : 'Validate_Required';

    $Param{DefaultKeyMapToError} = $Error{DefaultKeyMapTo} || '';
    $Param{DefaultKeyTypeError}  = $Error{DefaultKeyType}  || '';

    $Param{DefaultValueMapTo} = $MappingConfig->{DefaultValueMapTo};

    my $DefaultValueType = $MappingConfig->{DefaultValueType} || '';
    $Param{DefaultValueMapToHidden} = $DefaultValueType ne 'MapTo' ? 'Hidden' : 'Validate_Required';

    $Param{DefaultValueMapToError} = $Error{DefaultValueMapTo} || '';
    $Param{DefaultValueTypeError}  = $Error{DefaultValueType}  || '';

    # Select object for keys.
    $Param{DefaultKeyTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'Keep',
                Value => Translatable('Keep (leave unchanged)'),
            },
            {
                Key   => 'Ignore',
                Value => Translatable('Ignore (drop key/value pair)'),
            },
            {
                Key   => 'MapTo',
                Value => Translatable('Map to (use provided value as default)'),
            },
        ],
        Name         => 'DefaultKeyType',
        Class        => 'Modernize DefaultType ' . $Param{DefaultKeyTypeError},
        SelectedID   => $MappingConfig->{DefaultKeyType},
        PossibleNone => 0,
        Translate    => 0,
    );
    $Param{KeyMapTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'KeyMapExact',
                Value => Translatable('Exact value(s)'),
            },
            {
                Key   => 'KeyMapRegEx',
                Value => Translatable('Regular expression'),
            },
        ],
        Name         => 'KeyMapTypeStrg',
        PossibleNone => 0,
        Translate    => 0,
        Class        => 'Modernize',
    );

    # Select objects for values.
    $Param{DefaultValueTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'Keep',
                Value => Translatable('Keep (leave unchanged)'),
            },
            {
                Key   => 'Ignore',
                Value => Translatable('Ignore (drop Value/value pair)'),
            },
            {
                Key   => 'MapTo',
                Value => Translatable('Map to (use provided value as default)'),
            },
        ],
        Name         => 'DefaultValueType',
        Class        => 'Modernize DefaultType ' . $Param{DefaultKeyTypeError},
        SelectedID   => $MappingConfig->{DefaultValueType},
        PossibleNone => 0,
        Translate    => 0,
    );

    $Param{ValueMapTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'ValueMapExact',
                Value => Translatable('Exact value(s)'),
            },
            {
                Key   => 'ValueMapRegEx',
                Value => Translatable('Regular expression'),
            },
        ],
        Name         => 'ValueMapTypeStrg',
        PossibleNone => 0,
        Translate    => 0,
        Class        => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'KeyTemplate',
        Data => {
            Classes => 'KeyTemplate Hidden',
            %Param,
            %Error,
        },
    );

    # Set value index.
    $LayoutObject->Block(
        Name => 'ValueTemplateRowIndex',
        Data => {
            KeyIndex   => '',
            ValueIndex => '0',
        },
    );

    # Add saved values.
    for my $KeyIndex ( 1 .. $MappingConfig->{KeyCounter} ) {
        my $KeyMapTypeStrgError = $Error{ 'KeyMapTypeStrg' . $KeyIndex } || '';

        # Build map type selection.
        my $KeyMapTypeStrg = $LayoutObject->BuildSelection(
            Data => [
                {
                    Key   => 'KeyMapExact',
                    Value => Translatable('Exact value(s)'),
                },
                {
                    Key   => 'KeyMapRegEx',
                    Value => Translatable('Regular expression'),
                },
            ],
            Name         => 'KeyMapTypeStrg' . $KeyIndex,
            SelectedID   => $MappingConfig->{ 'KeyMapTypeStrg' . $KeyIndex },
            Class        => 'Modernize Validate_Required ' . $KeyMapTypeStrgError,
            PossibleNone => 0,
            Translate    => 0,
        );
        $LayoutObject->Block(
            Name => 'KeyTemplate',
            Data => {
                KeyIndex       => $KeyIndex,
                KeyName        => $MappingConfig->{ 'KeyName' . $KeyIndex },
                KeyNameError   => $Error{ 'KeyName' . $KeyIndex },
                KeyMapNew      => $MappingConfig->{ 'KeyMapNew' . $KeyIndex },
                KeyMapNewError => $Error{ 'KeyMapNew' . $KeyIndex },
                KeyMapTypeStrg => $KeyMapTypeStrg,
            },
        );

        for my $ValueIndex ( 1 .. $MappingConfig->{ 'ValueCounter' . $KeyIndex } ) {
            my $ValueMapTypeStrgError = $Error{ 'ValueMapTypeStrg' . $KeyIndex . '_' . $ValueIndex } || '';
            my $ValueMapTypeStrg      = $LayoutObject->BuildSelection(
                Data => [
                    {
                        Key   => 'ValueMapExact',
                        Value => Translatable('Exact value(s)'),
                    },
                    {
                        Key   => 'ValueMapRegEx',
                        Value => Translatable('Regular expression'),
                    },
                ],
                Name         => 'ValueMapTypeStrg' . $KeyIndex . '_' . $ValueIndex,
                SelectedID   => $MappingConfig->{ 'ValueMapTypeStrg' . $KeyIndex . '_' . $ValueIndex },
                Class        => 'Modernize Validate_Required ' . $ValueMapTypeStrgError,
                PossibleNone => 0,
                Translate    => 0,
            );

            # Build map type selection.
            $LayoutObject->Block(
                Name => 'ValueTemplateRow',
                Data => {
                    KeyIndex         => $KeyIndex,
                    ValueIndex       => $ValueIndex,
                    ValueName        => $MappingConfig->{ 'ValueName' . $KeyIndex . '_' . $ValueIndex },
                    ValueNameError   => $Error{ 'ValueName' . $KeyIndex . '_' . $ValueIndex } || '',
                    ValueMapNew      => $MappingConfig->{ 'ValueMapNew' . $KeyIndex . '_' . $ValueIndex },
                    ValueMapNewError => $Error{ 'ValueMapNew' . $KeyIndex . '_' . $ValueIndex } || '',
                    ValueMapTypeStrg => $ValueMapTypeStrg,
                },
            );
        }

        # Set index value.
        $LayoutObject->Block(
            Name => 'ValueTemplateRowIndex',
            Data => {
                KeyIndex   => $KeyIndex,
                ValueIndex => $MappingConfig->{ 'ValueCounter' . $KeyIndex },
            },
        );

    }

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'MappingSimple',
        Value => {
            WebServiceID  => $Param{WebserviceID},
            DeletedString => $Param{DeletedString},
        },
    );

    # Set key index.
    $LayoutObject->Block(
        Name => 'KeyCounter',
        Data => {
            KeyIndex => $MappingConfig->{KeyCounter} || 0,
        },
    );

    $LayoutObject->Block(
        Name => 'ValueTemplate',
        Data => { %Param, },
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceMappingSimple',
        Data         => { %Param, },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web browser.
    PARAM_NAME:
    for my $ParamName (
        qw(
        DefaultKeyType DefaultKeyMapTo DefaultValueType DefaultValueMapTo
        )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
        if ( $GetParam->{$ParamName} eq '' ) {
            if ( $ParamName =~ /(DefaultKeyMapTo|DefaultValueMapTo)/i ) {
                my $ParamPart = substr( $ParamName, 0, -5 );
                if ( $ParamObject->GetParam( Param => $ParamPart . 'Type' ) ne 'MapTo' ) {
                    next PARAM_NAME;
                }
            }
            $GetParam->{Error}->{$ParamName} = 'ServerError';
        }
    }

    # Get key counter param (it can be zero if just defaults where defined).
    $GetParam->{KeyCounter} =
        $ParamObject->GetParam( Param => 'KeyCounter' ) || 0;

    # Get params for keys.
    my $KeyIndex = 0;
    KEYCOUNTER:
    for my $KeyCounter ( 1 .. $GetParam->{KeyCounter} ) {
        next KEYCOUNTER if !$ParamObject->GetParam( Param => 'KeyIndex' . $KeyCounter );

        $KeyIndex++;
        KEY_ITEM:
        for my $KeyItem (qw(KeyMapTypeStrg KeyName KeyMapNew ValueCounter)) {
            my $KeyAux = $ParamObject->GetParam( Param => $KeyItem . $KeyCounter ) // '';
            $GetParam->{ $KeyItem . $KeyIndex } = $KeyAux;

            if ( $KeyItem eq 'ValueCounter' && $KeyAux eq '' ) {
                $GetParam->{ $KeyItem . $KeyIndex } = 0;
                next KEY_ITEM;
            }

            if ( $KeyAux eq '' ) {
                $GetParam->{Error}->{ $KeyItem . $KeyIndex } = 'ServerError';
            }
        }

        # Get params for values.
        my $ValueIndex = 0;
        COUNTER:
        for my $ValueCounter ( 1 .. $GetParam->{ 'ValueCounter' . $KeyIndex } ) {
            my $Suffix = $KeyCounter . '_' . $ValueCounter;

            if ( $ParamObject->GetParam( Param => 'ValueName' . $Suffix ) eq $Self->{DeletedString} ) {
                next COUNTER;
            }

            $ValueIndex++;

            for my $ValueItem (qw(ValueMapTypeStrg ValueName ValueMapNew)) {
                my $ValAux = $ParamObject->GetParam( Param => $ValueItem . $Suffix ) // '';
                $GetParam->{ $ValueItem . $KeyIndex . '_' . $ValueIndex } = $ValAux;

                if ( $ValAux eq '' ) {
                    $GetParam->{Error}->{ $ValueItem . $KeyIndex . '_' . $ValueIndex } = 'ServerError';
                }
            }
        }

        # Set new value index.
        $GetParam->{ 'ValueCounter' . $KeyIndex } = $ValueIndex;
    }

    # Set new key index.
    $GetParam->{KeyCounter} = $KeyIndex;

    return $GetParam;
}

1;
