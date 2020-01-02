# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceMappingXSLT;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    # Set possible values handling strings.
    $Self->{EmptyString}   = '_RegEx_EmptyString_Dont_Use_It_String_Please';
    $Self->{DeletedString} = '_RegEx_DeletedString_Dont_Use_It_String_Please';

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
        ? Translatable('XSLT Mapping for Outgoing Data')
        : Translatable('XSLT Mapping for Incoming Data');

    # Get configured Actions.
    my $ActionsConfig = $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $ActionType . '::Module' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Make sure required libraries (XML::LibXML and XML::LibXSLT) are installed.
    LIBREQUIRED:
    for my $LibRequired (qw(XML::LibXML XML::LibXSLT)) {
        my $LibFound = $Kernel::OM->Get('Kernel::System::Main')->Require(
            $LibRequired,
        );
        next LIBREQUIRED if $LibFound;

        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Could not find required library %s', $LibRequired ),
        );
    }

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

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # Get web service con configuration.
    my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    # Get the action type (back-end),
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

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # Recreate structure for edit.
        my %Mapping;
        my $MappingConfig = $WebserviceData->{Config}->{$CommunicationType}->
            {$ActionType}->{$Action}->{$Direction}->{Config};

        $Mapping{Template}              = $MappingConfig->{Template};
        $Mapping{DataInclude}           = $MappingConfig->{DataInclude};
        $Mapping{PreRegExFilter}        = $MappingConfig->{PreRegExFilter};
        $Mapping{PreRegExValueCounter}  = $MappingConfig->{PreRegExValueCounter};
        $Mapping{PostRegExFilter}       = $MappingConfig->{PostRegExFilter};
        $Mapping{PostRegExValueCounter} = $MappingConfig->{PostRegExValueCounter};

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

        # Get parameter from web browser.
        my $GetParam = $Self->_GetParams();

        # If there is an error return to edit screen.
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
        $NewMapping{Template}              = $GetParam->{Template};
        $NewMapping{DataInclude}           = $GetParam->{DataInclude};
        $NewMapping{PreRegExFilter}        = $GetParam->{PreRegExFilter};
        $NewMapping{PreRegExValueCounter}  = $GetParam->{PreRegExValueCounter};
        $NewMapping{PostRegExFilter}       = $GetParam->{PostRegExFilter};
        $NewMapping{PostRegExValueCounter} = $GetParam->{PostRegExValueCounter};

        # Set new mapping.
        $WebserviceData->{Config}->{$CommunicationType}->{$ActionType}->{$Action}->{$Direction}->{Config}
            = \%NewMapping;

        # Otherwise save configuration and return to overview screen.
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

        # If the user would like to continue editing the invoker config, just redirect to the edit screen.
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

    # Add rich text editor config.
    if ( $LayoutObject->{BrowserRichText} ) {
        $LayoutObject->SetRichTextParameters(
            Data => {
                %Param,
                RichTextHeight => '600',
                RichTextWidth  => '99%',
                RichTextType   => 'CodeMirror',
            },
        );
    }

    # Render pre regex filters.
    $Self->_RegExFiltersOutput(
        %{$MappingConfig},
        Type => 'Pre',
    );

    my %DataIncludeOptionMap = (
        Requester => {
            MappingOutbound => [
                {
                    Key   => 'RequesterRequestInput',
                    Value => Translatable('Outgoing request data before processing (RequesterRequestInput)'),
                },
                {
                    Key   => 'RequesterRequestPrepareOutput',
                    Value => Translatable('Outgoing request data before mapping (RequesterRequestPrepareOutput)'),
                },
            ],
            MappingInbound => [
                {
                    Key   => 'RequesterRequestInput',
                    Value => Translatable('Outgoing request data before processing (RequesterRequestInput)'),
                },
                {
                    Key   => 'RequesterRequestPrepareOutput',
                    Value => Translatable('Outgoing request data before mapping (RequesterRequestPrepareOutput)'),
                },
                {
                    Key   => 'RequesterRequestMapOutput',
                    Value => Translatable('Outgoing request data after mapping (RequesterRequestMapOutput)'),
                },
                {
                    Key   => 'RequesterResponseInput',
                    Value => Translatable('Incoming response data before mapping (RequesterResponseInput)'),
                },
                {
                    Key => 'RequesterErrorHandlingOutput',
                    Value =>
                        Translatable('Outgoing error handler data after error handling (RequesterErrorHandlingOutput)'),
                },
            ],
        },
        Provider => {
            MappingOutbound => [
                {
                    Key   => 'ProviderRequestInput',
                    Value => Translatable('Incoming request data before mapping (ProviderRequestInput)'),
                },
                {
                    Key   => 'ProviderRequestMapOutput',
                    Value => Translatable('Incoming request data after mapping (ProviderRequestMapOutput)'),
                },
                {
                    Key   => 'ProviderResponseInput',
                    Value => Translatable('Outgoing response data before mapping (ProviderResponseInput)'),
                },
                {
                    Key => 'ProviderErrorHandlingOutput',
                    Value =>
                        Translatable('Outgoing error handler data after error handling (ProviderErrorHandlingOutput)'),
                },
            ],
            MappingInbound => [
                {
                    Key   => 'ProviderRequestInput',
                    Value => Translatable('Incoming request data before mapping (ProviderRequestInput)'),
                },
            ],
        },
    );
    $Param{DataIncludeSelect} = $LayoutObject->BuildSelection(
        Data         => $DataIncludeOptionMap{ $Param{CommunicationType} }->{ $Param{Direction} },
        Name         => 'DataInclude',
        SelectedID   => $MappingConfig->{DataInclude},
        PossibleNone => 1,
        Translation  => 1,
        Multiple     => 1,
        Class        => 'Modernize W50pc',
    );

    $LayoutObject->Block(
        Name => 'ConfigBlock',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ConfigBlockTemplate',
        Data => {
            %Param,
            Template      => $MappingConfig->{Template},
            TemplateError => $Error{Template} || '',
        },
    );

    # Render post regex filters.
    $Self->_RegExFiltersOutput(
        %{$MappingConfig},
        Type => 'Post',
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceMappingXSLT',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web browser.
    $GetParam->{Template} = $ParamObject->GetParam( Param => 'Template' ) || '';
    my @DataInclude = $ParamObject->GetArray( Param => 'DataInclude' );
    $GetParam->{DataInclude} = \@DataInclude;

    # Check validity.
    my $LibXML  = XML::LibXML->new();
    my $LibXSLT = XML::LibXSLT->new();
    my ( $StyleDoc, $StyleSheet );
    eval {
        $StyleDoc = XML::LibXML->load_xml(
            string   => $GetParam->{Template},
            no_cdata => 1,
        );
    };
    if ( !$StyleDoc ) {
        $GetParam->{Error}->{Template} = 'ServerError';
    }
    eval {
        my $LibXSLT = XML::LibXSLT->new();
        $StyleSheet = $LibXSLT->parse_stylesheet($StyleDoc);
    };
    if ( !$StyleSheet ) {
        $GetParam->{Error}->{Template} = 'ServerError';
    }

    # Get RegEx params.
    my %RegExFilterConfig;
    TYPE:
    for my $Type (qw(Pre Post)) {
        my $ValueCounter = $ParamObject->GetParam( Param => $Type . 'ValueCounter' ) // 0;
        next TYPE if !$ValueCounter;

        my $EmptyValueCounter = 0;
        my @RegExConfig;
        VALUEINDEX:
        for my $ValueIndex ( 1 .. $ValueCounter ) {
            my $Key = $ParamObject->GetParam( Param => $Type . 'Key' . '_' . $ValueIndex ) // '';

            # Check if key was deleted by the user and skip it.
            next VALUEINDEX if $Key eq $Self->{DeletedString};

            # Check if the original value is empty.
            if ( !IsStringWithData($Key) ) {

                # Change the empty value to a predefined string.
                $Key = $Self->{EmptyString} . $EmptyValueCounter++;
                $GetParam->{Error}->{ $Type . 'RegExFilter' }->{$Key} = 1;
            }

            push @RegExConfig, {
                Search  => $Key,
                Replace => $ParamObject->GetParam( Param => $Type . 'Value' . '_' . $ValueIndex ) // '',
            };
        }

        $GetParam->{ $Type . 'RegExFilter' }       = \@RegExConfig;
        $GetParam->{ $Type . 'RegExValueCounter' } = scalar @RegExConfig;
    }

    return $GetParam;
}

sub _RegExFiltersOutput {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @RegExFilter;
    if ( IsArrayRefWithData( $Param{ $Param{Type} . 'RegExFilter' } ) ) {
        @RegExFilter = @{ $Param{ $Param{Type} . 'RegExFilter' } };
    }

    $LayoutObject->Block(
        Name => 'ConfigBlock',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ConfigBlockRegExFilter',
        Data => {
            Type          => $Param{Type},
            ValueCounter  => $Param{ $Param{Type} . 'RegExValueCounter' } // 0,
            DeletedString => $Self->{DeletedString},
            Collapsed     => !@RegExFilter ? 'Collapsed' : undef,
        },
    );

    # Create the possible values template.
    $LayoutObject->Block(
        Name => 'ValueTemplate',
        Data => {
            %Param,
        },
    );

    return 1 if !@RegExFilter;

    # Output the possible entries and errors within (if any).
    my $ValueCounter = 1;
    for my $RegEx (@RegExFilter) {

        # Needed for server side validation.
        my $KeyError;
        my $KeyErrorStrg;

        # To set the correct original value.
        my $KeyClone = $RegEx->{Search};

        # Check for errors.
        if ( $Param{Error}->{ $Param{Type} . 'RegExFilter' }->{ $RegEx->{Search} } ) {

            # If the original value was empty it has been changed in _GetParams to a predefined
            #   string and need to be set to empty again.
            $KeyClone = '';

            # Set the error class.
            $KeyError     = 'ServerError';
            $KeyErrorStrg = Translatable('This field is required.');
        }

        # Create a value map row.
        $LayoutObject->Block(
            Name => 'ValueRow',
            Data => {
                Type         => $Param{Type},
                KeyError     => $KeyError,
                KeyErrorStrg => $KeyErrorStrg || Translatable('This field is required.'),
                Key          => $KeyClone,
                ValueCounter => $ValueCounter,
                Value        => $RegEx->{Replace},
            },
        );
    }
    continue {
        ++$ValueCounter;
    }

    return 1;
}

1;
