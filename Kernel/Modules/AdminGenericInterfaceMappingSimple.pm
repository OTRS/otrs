# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceMappingSimple;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $WebserviceID = $ParamObject->GetParam( Param => 'WebserviceID' ) || '';
    my $Operation    = $ParamObject->GetParam( Param => 'Operation' )    || '';
    my $Invoker      = $ParamObject->GetParam( Param => 'Invoker' )      || '';
    my $Direction    = $ParamObject->GetParam( Param => 'Direction' )    || '';

    my $CommunicationType = IsStringWithData($Operation) ? 'Provider'  : 'Requester';
    my $ActionType        = IsStringWithData($Operation) ? 'Operation' : 'Invoker';
    my $Action = $Operation || $Invoker;

    # set mapping direction for display
    my $MappingDirection = $Direction eq 'MappingOutbound'
        ? 'Simple Mapping for Outgoing Data'
        : 'Simple Mapping for Incoming Data';

    # get configured Actions
    my $ActionsConfig = $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $ActionType . '::Module' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check for valid action backend
    if ( !IsHashRefWithData($ActionsConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message => "Could not get registered configuration for action type $ActionType",
        );
    }

    # check for WebserviceID
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => "Need WebserviceID!",
        );
    }

    # get web service object
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # get web service configuration
    my $WebserviceData =
        $WebserviceObject->WebserviceGet( ID => $WebserviceID );

    # check for valid web service configuration
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message => "Could not get data for WebserviceID $WebserviceID",
        );
    }

    # get the action type (back-end)
    my $ActionBackend = $WebserviceData->{Config}->{$CommunicationType}->{$ActionType}->{$Action}->{'Type'};

    # check for valid action backend
    if ( !$ActionBackend ) {
        return $LayoutObject->ErrorScreen(
            Message => "Could not get backend for $ActionType $Action",
        );
    }

    # get the configuration dialog for the action
    my $ActionFrontendModule = $ActionsConfig->{$ActionBackend}->{'ConfigDialog'};

    my $WebserviceName = $WebserviceData->{Name};

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # recreate structure for edit
        my %Mapping;

        my $MappingConfig = $WebserviceData->{Config}->{$CommunicationType}->
            {$ActionType}->{$Action}->{$Direction}->{Config};

        $Mapping{DefaultKeyMapTo} = $MappingConfig->{KeyMapDefault}->{MapTo};
        $Mapping{DefaultKeyType}  = $MappingConfig->{KeyMapDefault}->{MapType};

        $Mapping{DefaultValueMapTo} = $MappingConfig->{ValueMapDefault}->{MapTo};
        $Mapping{DefaultValueType}  = $MappingConfig->{ValueMapDefault}->{MapType};

        # add saved values
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

                # set value index
                $Mapping{ 'ValueCounter' . $KeyIndex } = $ValueIndex;
            }
        }

        # set Key index
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

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # if there is an error return to edit screen
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

        # set default key
        $NewMapping{KeyMapDefault}->{MapType} = $GetParam->{DefaultKeyType};
        $NewMapping{KeyMapDefault}->{MapTo}   = $GetParam->{DefaultKeyMapTo};

        # set default value
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

        # set new mapping
        $WebserviceData->{Config}->{$CommunicationType}->{$ActionType}->{$Action}->{$Direction}->{Config}
            = \%NewMapping;

        # otherwise save configuration and return to overview screen
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # check for successful web service update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not update configuration data for WebserviceID $WebserviceID",
            );
        }

        # save and finish button: go to web service.
        if ( $ParamObject->GetParam( Param => 'ReturnToAction' ) ) {
            my $RedirectURL = "Action=$ActionFrontendModule;Subaction=Change;$ActionType=$Action;"
                . "WebserviceID=$WebserviceID;";

            return $LayoutObject->Redirect(
                OP => $RedirectURL,
            );
        }

        # recreate structure for edit
        my %Mapping;

        my $MappingConfig = $WebserviceData->{Config}->{$CommunicationType}->
            {$ActionType}->{$Action}->{$Direction}->{Config};

        $Mapping{DefaultKeyMapTo} = $MappingConfig->{KeyMapDefault}->{MapTo};
        $Mapping{DefaultKeyType}  = $MappingConfig->{KeyMapDefault}->{MapType};

        $Mapping{DefaultValueMapTo} = $MappingConfig->{ValueMapDefault}->{MapTo};
        $Mapping{DefaultValueType}  = $MappingConfig->{ValueMapDefault}->{MapType};

        # add saved values
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

                # set value index
                $Mapping{ 'ValueCounter' . $KeyIndex } = $ValueIndex;
            }
        }

        # set Key index
        $Mapping{'KeyCounter'} = $KeyIndex;

        # check if stay on mapping screen or redirect to previous screen
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
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # set action for go back button
    $Param{LowerCaseActionType} = lc $Param{ActionType};

    # get layout object
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

    # select object for keys
    $Param{DefaultKeyTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'Keep',
                Value => 'Keep (leave unchanged)',
            },
            {
                Key   => 'Ignore',
                Value => 'Ignore (drop key/value pair)',
            },
            {
                Key   => 'MapTo',
                Value => 'MapTo (use provided value as default)',
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
                Value => 'Exact value(s)',
            },
            {
                Key   => 'KeyMapRegEx',
                Value => 'Regular expression',
            },
        ],
        Name         => 'KeyMapTypeStrg',
        PossibleNone => 0,
        Translate    => 0,
        Class        => 'Modernize',
    );

    # select objects for values
    $Param{DefaultValueTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 'Keep',
                Value => 'Keep (leave unchanged)',
            },
            {
                Key   => 'Ignore',
                Value => 'Ignore (drop Value/value pair)',
            },
            {
                Key   => 'MapTo',
                Value => 'MapTo (use provided value as default)',
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
                Value => 'Exact value(s)',
            },
            {
                Key   => 'ValueMapRegEx',
                Value => 'Regular expression',
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

    # set value index
    $LayoutObject->Block(
        Name => 'ValueTemplateRowIndex',
        Data => {
            KeyIndex   => '',
            ValueIndex => '0',
        },
    );

    # add saved values
    for my $KeyIndex ( 1 .. $MappingConfig->{KeyCounter} ) {
        my $KeyMapTypeStrgError = $Error{ 'KeyMapTypeStrg' . $KeyIndex } || '';

        # build map type selection
        my $KeyMapTypeStrg = $LayoutObject->BuildSelection(
            Data => [
                {
                    Key   => 'KeyMapExact',
                    Value => 'Exact value(s)',
                },
                {
                    Key   => 'KeyMapRegEx',
                    Value => 'Regular expression',
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
            my $ValueMapTypeStrg = $LayoutObject->BuildSelection(
                Data => [
                    {
                        Key   => 'ValueMapExact',
                        Value => 'Exact value(s)',
                    },
                    {
                        Key   => 'ValueMapRegEx',
                        Value => 'Regular expression',
                    },
                ],
                Name         => 'ValueMapTypeStrg' . $KeyIndex . '_' . $ValueIndex,
                SelectedID   => $MappingConfig->{ 'ValueMapTypeStrg' . $KeyIndex . '_' . $ValueIndex },
                Class        => 'Modernize Validate_Required ' . $ValueMapTypeStrgError,
                PossibleNone => 0,
                Translate    => 0,
            );

            # build map type selection
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

        # set index value
        $LayoutObject->Block(
            Name => 'ValueTemplateRowIndex',
            Data => {
                KeyIndex   => $KeyIndex,
                ValueIndex => $MappingConfig->{ 'ValueCounter' . $KeyIndex },
            },
        );

    }

    # set key index
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

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
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

    # get key counter param (it can be zero if just defaults where defined)
    $GetParam->{KeyCounter} =
        $ParamObject->GetParam( Param => 'KeyCounter' ) || 0;

    # get params for keys
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

        # get params for values
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

        # set new value index
        $GetParam->{ 'ValueCounter' . $KeyIndex } = $ValueIndex;
    }

    # set new key index
    $GetParam->{KeyCounter} = $KeyIndex;

    return $GetParam;
}
1;
