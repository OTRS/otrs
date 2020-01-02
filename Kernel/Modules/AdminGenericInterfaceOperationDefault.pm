# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceOperationDefault;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $WebserviceID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'WebserviceID' );
    if ( !IsStringWithData($WebserviceID) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    $LayoutObject->AddJSData(
        Key   => 'WebserviceID',
        Value => $WebserviceID
    );

    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $WebserviceID,
    );
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }

    return $LayoutObject->ErrorScreen(
        Message => Translatable('Invalid Subaction!'),
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Self->_ParamsGet(
        Definition => [
            {
                Name      => 'OperationType',
                Type      => 'String',
                Mandatory => 1,
                Check     => 'OperationType',
            },
        ],
    );

    if ( $GetParam->{Error} ) {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->ErrorScreen(
            Message => $GetParam->{Error},
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Mode            => 'Add',
        OperationConfig => {
            Type => $GetParam->{OperationType},
        },
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Self->_ParamsGet(
        Definition => [
            {
                Name      => 'OperationType',
                Type      => 'String',
                Mandatory => 1,
                Check     => 'OperationType',
            },
            {
                Name    => 'Operation',
                Type    => 'String',
                Default => '',
            },
            {
                Name    => 'Description',
                Type    => 'String',
                Default => '',
            },
            {
                Name  => 'MappingInbound',
                Type  => 'String',
                Check => 'MappingType',
            },
            {
                Name  => 'MappingOutbound',
                Type  => 'String',
                Check => 'MappingType',
            },
            {
                Name    => 'IncludeTicketData',
                Type    => 'String',
                Default => 0,
            },
        ],
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( $GetParam->{Error} ) {
        return $LayoutObject->ErrorScreen(
            Message => $GetParam->{Error},
        );
    }

    my $WebserviceData = $Param{WebserviceData};
    my %Errors;
    if ( !IsStringWithData( $GetParam->{Operation} ) ) {
        $Errors{OperationServerError} = 'ServerError';
    }

    # Operation with same name already exists.
    elsif ( IsHashRefWithData( $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} } ) ) {
        $Errors{OperationServerError} = 'ServerError';
    }

    my $OperationConfig = {
        Description       => $GetParam->{Description},
        Type              => $GetParam->{OperationType},
        IncludeTicketData => $GetParam->{IncludeTicketData},
    };

    # Validation errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %{$GetParam},
            %Errors,
            Mode            => 'Add',
            OperationConfig => $OperationConfig,
        );
    }

    DIRECTION:
    for my $Direction (qw(MappingInbound MappingOutbound)) {
        next DIRECTION if !$GetParam->{$Direction};

        # Mapping added, initialize with empty config.
        $OperationConfig->{$Direction} = {
            Type => $GetParam->{$Direction},
        };
    }

    $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} } = $OperationConfig;

    my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );
    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update web service'),
        );
    }

    my $RedirectURL =
        'Action='
        . $Self->{Action}
        . ';Subaction=Change;WebserviceID='
        . $Param{WebserviceID}
        . ';Operation='
        . $LayoutObject->LinkEncode( $GetParam->{Operation} )
        . ';';

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Self->_ParamsGet(
        Definition => [
            {
                Name      => 'Operation',
                Type      => 'String',
                Mandatory => 1,
            },
        ],
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( $GetParam->{Error} ) {
        return $LayoutObject->ErrorScreen(
            Message => $GetParam->{Error},
        );
    }

    my $WebserviceData  = $Param{WebserviceData};
    my $OperationConfig = $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} };
    if ( !IsHashRefWithData($OperationConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}
                ->Translate( 'Could not determine config for operation %s', $GetParam->{Operation} ),
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Mode            => 'Change',
        Operation       => $GetParam->{Operation},
        OperationConfig => $OperationConfig,
        MappingInbound  => $OperationConfig->{MappingInbound}->{Type},
        MappingOutbound => $OperationConfig->{MappingOutbound}->{Type},
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Self->_ParamsGet(
        Definition => [
            {
                Name      => 'OldOperation',
                Type      => 'String',
                Mandatory => 1,
            },
            {
                Name    => 'Operation',
                Type    => 'String',
                Default => '',
            },
            {
                Name    => 'Description',
                Type    => 'String',
                Default => '',
            },
            {
                Name  => 'MappingInbound',
                Type  => 'String',
                Check => 'MappingType',
            },
            {
                Name  => 'MappingOutbound',
                Type  => 'String',
                Check => 'MappingType',
            },
            {
                Name    => 'IncludeTicketData',
                Type    => 'String',
                Default => 0,
            },
            {
                Name    => 'ContinueAfterSave',
                Type    => 'String',
                Default => '',
            },
        ],
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( $GetParam->{Error} ) {
        return $LayoutObject->ErrorScreen(
            Message => $GetParam->{Error},
        );
    }

    my $WebserviceData  = $Param{WebserviceData};
    my $OperationConfig = delete $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam->{OldOperation} };
    if ( !IsHashRefWithData($OperationConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}
                ->Translate( 'Could not determine config for operation %s', $GetParam->{OldOperation} ),
        );
    }

    my %Errors;
    if ( !IsStringWithData( $GetParam->{Operation} ) ) {
        $Errors{OperationServerError} = 'ServerError';
    }

    # Operation was renamed and new name already exists.
    elsif (
        $GetParam->{OldOperation} ne $GetParam->{Operation}
        && IsHashRefWithData( $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} } )
        )
    {
        $Errors{OperationServerError} = 'ServerError';
    }

    $OperationConfig->{Description}       = $GetParam->{Description};
    $OperationConfig->{IncludeTicketData} = $GetParam->{IncludeTicketData};

    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %{$GetParam},
            %Errors,
            Mode            => 'Change',
            Operation       => $GetParam->{OldOperation},
            OperationConfig => $OperationConfig,
            NewOperation    => $GetParam->{Operation},
        );
    }

    # If mapping types were not changed, keep the mapping configuration.
    DIRECTION:
    for my $Direction (qw(MappingInbound MappingOutbound)) {

        # No mapping set, make sure it is not present in the configuration.
        if ( !$GetParam->{$Direction} ) {
            delete $OperationConfig->{$Direction};
            next DIRECTION;
        }

        # Mapping added or changed, initialize with empty config.
        my $OldMapping = $OperationConfig->{$Direction}->{Type};
        if ( !$OldMapping || ( $OldMapping && $GetParam->{$Direction} ne $OldMapping ) ) {
            $OperationConfig->{$Direction} = {
                Type => $GetParam->{$Direction},
            };
        }
    }

    # Update operation config.
    $WebserviceData->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} } = $OperationConfig;

    # Take care of error handlers with operation filters if operation was renamed.
    if (
        $GetParam->{OldOperation} ne $GetParam->{Operation}
        && IsHashRefWithData( $WebserviceData->{Config}->{Provider}->{ErrorHandling} )
        )
    {
        my $ErrorHandlingConfig = $WebserviceData->{Config}->{Provider}->{ErrorHandling};

        ERRORHANDLING:
        for my $ErrorHandling ( sort keys %{$ErrorHandlingConfig} ) {
            next ERRORHANDLING if !IsHashRefWithData( $ErrorHandlingConfig->{$ErrorHandling} );

            my $OperationFilter = $ErrorHandlingConfig->{$ErrorHandling}->{OperationFilter};
            next ERRORHANDLING if !IsArrayRefWithData($OperationFilter);

            next ERRORHANDLING if !grep { $_ eq $GetParam->{OldOperation} } @{$OperationFilter};

            # Rename operation in error handling operation filter to keep consistency.
            my @NewOperationFilter
                = map { $_ eq $GetParam->{OldOperation} ? $GetParam->{Operation} : $_ } @{$OperationFilter};
            $ErrorHandlingConfig->{$ErrorHandling}->{OperationFilter} = \@NewOperationFilter;
        }

        $WebserviceData->{Config}->{Provider}->{ErrorHandling} = $ErrorHandlingConfig;
    }

    my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{$WebserviceData},
        UserID => $Self->{UserID},
    );
    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update web service'),
        );
    }

    # If the user would like to continue editing the operation config, just redirect to the edit screen.
    my $RedirectURL;
    if ( $GetParam->{ContinueAfterSave} eq 1 ) {
        $RedirectURL =
            'Action='
            . $Self->{Action}
            . ';Subaction=Change;WebserviceID='
            . $Param{WebserviceID}
            . ';Operation='
            . $LayoutObject->LinkEncode( $GetParam->{Operation} )
            . ';';
    }

    # Otherwise return to overview.
    else {
        $RedirectURL =
            'Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID='
            . $Param{WebserviceID}
            . ';';
    }

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Self->_ParamsGet(
        Definition => [
            {
                Name      => 'Operation',
                Type      => 'String',
                Mandatory => 1,
            },
        ],
    );

    if ( $GetParam->{Error} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $GetParam->{Error},
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    if ( !IsHashRefWithData( $Param{WebserviceData}->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} } ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine config for operation $GetParam->{Operation}",
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    # Remove operation from config.
    delete $Param{WebserviceData}->{Config}->{Provider}->{Operation}->{ $GetParam->{Operation} };
    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );

    return $Self->_JSONResponse( Success => $Success );
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $LayoutObject->AddJSData(
        Key   => 'Operation',
        Value => $Param{Operation},
    );

    my %TemplateData = (
        Description   => $Param{OperationConfig}->{Description},
        OperationType => $Param{OperationConfig}->{Type},
        Operation     => $Param{Operation},
        NewOperation  => $Param{NewOperation} // $Param{Operation},
    );

    # Handle mapping.
    my $MappingModules    = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Mapping::Module') || {};
    my @MappingModuleList = sort keys %{$MappingModules};
    DIRECTION:
    for my $Direction (qw(MappingInbound MappingOutbound)) {
        my $OldMapping = $Param{OperationConfig}->{$Direction}->{Type};
        my $Mapping    = $Param{$Direction};

        $TemplateData{ $Direction . 'Strg' } = $LayoutObject->BuildSelection(
            Data          => \@MappingModuleList,
            Name          => $Direction,
            SelectedValue => $Mapping,
            Sort          => 'AlphanumericValue',
            PossibleNone  => 1,
            Class         => 'Modernize RegisterChange',
        );

        # Only show configure button if we have an unchanged existing mapping type.
        next DIRECTION if !$OldMapping;
        next DIRECTION if !$Mapping;
        next DIRECTION if $Mapping ne $OldMapping;
        next DIRECTION if !$MappingModules->{$Mapping}->{ConfigDialog};

        $LayoutObject->Block(
            Name => $Direction . 'ConfigureButton',
            Data => {
                $Direction . ConfigDialog => $MappingModules->{$Mapping}->{ConfigDialog},
            },
        );
    }

    if (
        $TemplateData{OperationType} eq 'Ticket::TicketCreate'
        || $TemplateData{OperationType} eq 'Ticket::TicketUpdate'
        )
    {
        $TemplateData{IncludeTicketDataStrg} = $LayoutObject->BuildSelection(
            Data => {
                0 => Translatable('No'),
                1 => Translatable('Yes'),
            },
            Name       => 'IncludeTicketData',
            SelectedID => $Param{OperationConfig}->{IncludeTicketData} // 0,
            Sort       => 'NumericKey',
            Class      => 'Modernize W50pc',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => {
            %Param,
            %TemplateData,
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _ParamsGet {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my %GetParam;
    DEFINITION:
    for my $Definition ( @{ $Param{Definition} } ) {
        my $Name = $Definition->{Name};

        if ( $Definition->{Type} eq 'String' ) {
            $GetParam{$Name} = $ParamObject->GetParam( Param => $Name ) // $Definition->{Default};
            next DEFINITION if IsStringWithData( $GetParam{$Name} );

            next DEFINITION if !$Definition->{Mandatory};
            $GetParam{Error} = $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Name );
            return \%GetParam;
        }
    }

    # Type checks.
    DEFINITION:
    for my $Definition ( @{ $Param{Definition} } ) {
        next DEFINITION if !$Definition->{Check};

        my $Name = $Definition->{Name};
        next DEFINITION if !defined $GetParam{$Name};

        if ( $Definition->{Check} eq 'OperationType' ) {
            next DEFINITION if $Self->_OperationTypeCheck( OperationType => $GetParam{$Name} );

            $GetParam{Error}
                = $LayoutObject->{LanguageObject}->Translate( 'OperationType %s is not registered', $GetParam{$Name} );
            return \%GetParam;
        }

        if ( $Definition->{Check} eq 'MappingType' ) {
            next DEFINITION if !IsStringWithData( $GetParam{Name} );
            next DEFINITION if $Self->_MappingTypeCheck( MappingType => $GetParam{$Name} );

            $GetParam{Error}
                = $LayoutObject->{LanguageObject}->Translate( 'MappingType %s is not registered', $GetParam{$Name} );
            return \%GetParam;
        }
    }

    return \%GetParam;
}

sub _OperationTypeCheck {
    my ( $Self, %Param ) = @_;

    return if !$Param{OperationType};

    my $Operations = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::Module');
    return if !IsHashRefWithData($Operations);

    return if !IsHashRefWithData( $Operations->{ $Param{OperationType} } );
    return 1;
}

sub _MappingTypeCheck {
    my ( $Self, %Param ) = @_;

    return if !$Param{MappingType};

    my $Mappings = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Mapping::Module');
    return if !IsHashRefWithData($Mappings);

    return if !IsHashRefWithData( $Mappings->{ $Param{MappingType} } );
    return 1;
}

sub _JSONResponse {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build JSON output.
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Param{Success} // 0,
        },
    );

    # Send JSON response.
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
