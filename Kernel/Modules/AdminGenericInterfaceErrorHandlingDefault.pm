# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceErrorHandlingDefault;

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

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $WebserviceID = $ParamObject->GetParam( Param => 'WebserviceID' );
    if ( !IsPositiveInteger($WebserviceID) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $WebserviceID,
    );
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    my $CommunicationType = $ParamObject->GetParam( Param => 'CommunicationType' );
    if ( !IsStringWithData($CommunicationType) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need communication type!'),
        );
    }
    if (
        $CommunicationType ne 'Requester'
        && $CommunicationType ne 'Provider'
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => Translatable("Communication type needs to be 'Requester' or 'Provider'!"),
        );
    }

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddAction(
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
        );
    }
    elsif ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
        );
    }
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
        );
    }
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
        );
    }
    elsif ( $Self->{Subaction} eq 'PriorityAction' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_PriorityAction(
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
        );
    }

    # Fall-back if missing or other sub-action.
    return $LayoutObject->ErrorScreen(
        Message => Translatable('Invalid Subaction!'),
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ErrorHandlingType = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ErrorHandlingType' );
    if ( !IsStringWithData($ErrorHandlingType) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ErrorHandlingType!'),
        );
    }
    if ( !$Self->_ErrorHandlingTypeCheck( ErrorHandlingType => $ErrorHandlingType ) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}
                ->Translate( 'ErrorHandlingType %s is not registered', $ErrorHandlingType ),
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Action              => 'Add',
        ErrorHandlingConfig => {
            Type => $ErrorHandlingType,
        },
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ErrorHandlingType = $ParamObject->GetParam( Param => 'ErrorHandlingType' );
    if ( !IsStringWithData($ErrorHandlingType) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ErrorHandlingType!'),
        );
    }
    if ( !$Self->_ErrorHandlingTypeCheck( ErrorHandlingType => $ErrorHandlingType ) ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}
                ->Translate( 'ErrorHandlingType %s is not registered', $ErrorHandlingType ),
        );
    }

    my %Errors;
    my $RequestParams = $Self->_RequestParamsGet();

    # Name already exists.
    my $ErrorHandling = $ParamObject->GetParam( Param => 'ErrorHandling' );
    if (
        !IsStringWithData($ErrorHandling)
        || $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling}
        )
    {
        $Errors{ErrorHandlingServerError} = 'ServerError';
    }

    my $ErrorHandlingConfig = {
        %{$RequestParams},
        Type => $ErrorHandlingType,
    };

    # Validation errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            Action              => 'Add',
            ErrorHandling       => $ErrorHandling,
            ErrorHandlingConfig => {
                %{$ErrorHandlingConfig},
                ErrorHandling => $ErrorHandling,
            },
        );
    }

    # Add module to config.
    $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling}
        = $ErrorHandlingConfig;

    # Add module to priority list.
    my $WebserviceErrorHandlingPriority
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority};
    if ( IsArrayRefWithData($WebserviceErrorHandlingPriority) ) {
        push @{$WebserviceErrorHandlingPriority}, $ErrorHandling;
    }
    else {
        $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority} = [$ErrorHandling];
    }

    my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );
    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update web service'),
        );
    }

    # Save button: stay in edit mode.
    my $RedirectURL =
        'Action='
        . $Self->{Action}
        . ';Subaction=Change;WebserviceID='
        . $Param{WebserviceID}
        . ';ErrorHandling='
        . $LayoutObject->LinkEncode($ErrorHandling)
        . ';ErrorHandlingType='
        . $LayoutObject->LinkEncode($ErrorHandlingType)
        . ';CommunicationType='
        . $LayoutObject->LinkEncode( $Param{CommunicationType} )
        . ';';

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $ErrorHandling = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ErrorHandling' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !IsStringWithData($ErrorHandling) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ErrorHandling'),
        );
    }

    my $ErrorHandlingConfig
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling};
    if ( !IsHashRefWithData($ErrorHandlingConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}
                ->Translate( 'Could not determine config for error handler %s', $ErrorHandling ),
        );
    }

    return $Self->_ShowScreen(
        %Param,
        Action              => 'Change',
        ErrorHandling       => $ErrorHandling,
        ErrorHandlingConfig => {
            %{$ErrorHandlingConfig},
            ErrorHandling => $ErrorHandling,
        },
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $OldErrorHandling = $ParamObject->GetParam( Param => 'OldErrorHandling' );
    if ( !IsStringWithData($OldErrorHandling) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Need %s', 'OldErrorHandling' ),
        );
    }

    my %Errors;
    my $ErrorHandling = $ParamObject->GetParam( Param => 'ErrorHandling' );
    if ( !IsStringWithData($ErrorHandling) ) {
        $Errors{ErrorHandlingServerError} = 'ServerError';
    }

    my $ErrorHandlingConfig = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}
        ->{$OldErrorHandling};
    if ( !IsHashRefWithData($ErrorHandlingConfig) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}
                ->Translate( 'Could not determine config for error handler %s', $OldErrorHandling ),
        );
    }

    # Error handler was renamed, avoid conflicts.
    if ( $OldErrorHandling ne $ErrorHandling ) {

        # New name already exists, bail out.
        if (
            $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling}
            )
        {
            $Errors{ErrorHandlingServerError} = 'ServerError';
        }

        # OK, remove old error handler. New one will be added below.
        if ( !%Errors ) {
            delete $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}
                ->{$OldErrorHandling};
        }
    }

    my $RequestParams = $Self->_RequestParamsGet();

    $ErrorHandlingConfig = {
        %{$RequestParams},
        Type => $ErrorHandlingConfig->{Type},
    };

    # Validation errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            Action              => 'Change',
            ErrorHandling       => $OldErrorHandling,
            ErrorHandlingConfig => {
                %{$ErrorHandlingConfig},
                ErrorHandling => $ErrorHandling,
            },
        );
    }

    # Update config.
    $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling}
        = $ErrorHandlingConfig;

    # Update priority array if necessary.
    if ( $OldErrorHandling ne $ErrorHandling ) {
        my $ErrorHandlingPriority
            = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority};
        my ($OldErrorHandlingIndex) = grep { $ErrorHandlingPriority->[$_] eq $OldErrorHandling }
            ( 0 .. scalar @{$ErrorHandlingPriority} - 1 );
        if ( IsStringWithData($OldErrorHandlingIndex) ) {
            $ErrorHandlingPriority->[$OldErrorHandlingIndex] = $ErrorHandling;
        }
    }

    my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );
    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not update web service'),
        );
    }

    # if the user would like to continue editing the queue, just redirect to the edit screen
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
            . $Param{WebserviceID}
            . ';ErrorHandling='
            . $LayoutObject->LinkEncode($ErrorHandling)
            . ';CommunicationType='
            . $LayoutObject->LinkEncode( $Param{CommunicationType} )
            . ';';
    }
    else {

        # otherwise return to overview
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

    my $ErrorHandling = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ErrorHandling' );
    if ( !IsStringWithData($ErrorHandling) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ErrorHandling!',
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    if (
        !IsHashRefWithData(
            $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling}
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine config for error handler $ErrorHandling",
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    # Delete error handling module.
    delete $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling};

    # Remove entry from priority.
    @{ $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority} }
        = grep { $_ ne $ErrorHandling }
        @{ $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority} };

    my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
        %{ $Param{WebserviceData} },
        UserID => $Self->{UserID},
    );

    return $Self->_JSONResponse( Success => $Success );
}

sub _PriorityAction {
    my ( $Self, %Param ) = @_;

    my $PriorityJSON = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Priority' );
    if ( !$PriorityJSON ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no priority JSON array to save!',
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    my $Priority = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $PriorityJSON,
    );
    if ( !IsArrayRefWithData($Priority) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no priority array to save!',
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    # Check if priority content matches original content (safety check - we should only change order, not elements).
    my @PrioritySorted = sort @{$Priority};
    my @OldPrioritySorted
        = sort @{ $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority} };
    my $DataIsDifferent = DataIsDifferent(
        Data1 => \@PrioritySorted,
        Data2 => \@OldPrioritySorted,
    );
    if ($DataIsDifferent) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Priority array content could not be verified!',
        );
        return $Self->_JSONResponse( Success => 0 );
    }

    # Save the new priority.
    $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandlingPriority} = $Priority;
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

    $LayoutObject->Block(
        Name => 'Title' . $Param{Action},
        Data => \%Param,
    );
    $LayoutObject->Block(
        Name => 'Navigation' . $Param{Action},
        Data => \%Param,
    );

    my %TemplateData = (
        ErrorHandlingType         => $Param{ErrorHandlingConfig}->{Type},
        Description               => $Param{ErrorHandlingConfig}->{Description},
        ErrorCode                 => $Param{ErrorHandlingConfig}->{ErrorCode},
        ErrorMessage              => $Param{ErrorHandlingConfig}->{ErrorMessage},
        ErrorHandling             => $Param{ErrorHandlingConfig}->{ErrorHandling},
        OldErrorHandling          => $Param{ErrorHandling},
        ErrorMessageContentFilter => $Param{ErrorHandlingConfig}->{ErrorMessageContentFilter},
    );

    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->AddJSData(
            Key   => 'ErrorHandling',
            Value => {
                CommunicationType   => $Param{CommunicationType},
                ErrorHandlingModule => $Param{ErrorHandling},
                WebserviceID        => $Param{WebserviceID},
                ErrorHandlingType   => $Param{ErrorHandlingConfig}->{Type},
            },
        );
    }

    my @ErrorStageFilter;

    if ( $Param{CommunicationType} eq 'Requester' ) {

        @ErrorStageFilter = (
            {
                Key   => 'RequesterRequestPrepare',
                Value => Translatable('Invoker processing outgoing request data'),
            },
            {
                Key   => 'RequesterRequestMap',
                Value => Translatable('Mapping outgoing request data'),
            },
            {
                Key   => 'RequesterRequestPerform',
                Value => Translatable('Transport processing request into response'),
            },
            {
                Key   => 'RequesterResponseMap',
                Value => Translatable('Mapping incoming response data'),
            },
            {
                Key   => 'RequesterResponseProcess',
                Value => Translatable('Invoker processing incoming response data'),
            },
        );
    }
    else {

        @ErrorStageFilter = (
            {
                Key   => 'ProviderRequestReceive',
                Value => Translatable('Transport receiving incoming request data'),
            },
            {
                Key   => 'ProviderRequestMap',
                Value => Translatable('Mapping incoming request data'),
            },
            {
                Key   => 'ProviderRequestProcess',
                Value => Translatable('Operation processing incoming request data'),
            },
            {
                Key   => 'ProviderResponseMap',
                Value => Translatable('Mapping outgoing response data'),
            },
            {
                Key   => 'ProviderResponseTransmit',
                Value => Translatable('Transport sending outgoing response data'),
            },
        );
    }
    $TemplateData{ErrorStageFilterStrg} = $LayoutObject->BuildSelection(
        Data         => \@ErrorStageFilter,
        ID           => 'ErrorStageFilter',
        Name         => 'ErrorStageFilter',
        SelectedID   => $Param{ErrorHandlingConfig}->{ErrorStageFilter},
        PossibleNone => 1,
        Multiple     => 1,
        Translate    => 1,
        Class        => 'Modernize',
    );

    $TemplateData{StopAfterMatchStrg} = $LayoutObject->BuildSelection(
        Data => {
            'backend' => Translatable('skip same backend modules only'),
            'all'     => Translatable('skip all modules'),
        },
        ID           => 'StopAfterMatch',
        Name         => 'StopAfterMatch',
        SelectedID   => $Param{ErrorHandlingConfig}->{StopAfterMatch},
        PossibleNone => 1,
        Translate    => 1,
        Class        => 'Modernize',
    );

    if ( $Param{CommunicationType} eq 'Provider' ) {
        my %Operations
            = map { $_ => $_ } sort keys %{ $Param{WebserviceData}->{Config}->{Provider}->{Operation} || {} };
        my $OperationDeletedText = $LayoutObject->{LanguageObject}->Translate('Operation deleted');
        SELECTEDOPERATION:
        for my $SelectedOperation ( @{ $Param{ErrorHandlingConfig}->{OperationFilter} || [] } ) {
            next SELECTEDOPERATION if $Operations{$SelectedOperation};
            $Operations{$SelectedOperation} = $SelectedOperation . " ($OperationDeletedText)";
        }
        my $OperationFilterStrg = $LayoutObject->BuildSelection(
            Data         => \%Operations,
            ID           => 'OperationFilter',
            Name         => 'OperationFilter',
            SelectedID   => $Param{ErrorHandlingConfig}->{OperationFilter},
            Multiple     => 1,
            PossibleNone => 1,
            Translate    => 0,
            Class        => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'OperationFilter',
            Data => {
                OperationFilterStrg => $OperationFilterStrg,
            },
        );
    }
    else {
        my %Invokers = map { $_ => $_ } sort keys %{ $Param{WebserviceData}->{Config}->{Requester}->{Invoker} || {} };
        my $InvokerDeletedText = $LayoutObject->{LanguageObject}->Translate('Invoker deleted');
        SELECTEDINVOKER:
        for my $SelectedInvoker ( @{ $Param{ErrorHandlingConfig}->{InvokerFilter} || [] } ) {
            next SELECTEDINVOKER if $Invokers{$SelectedInvoker};
            $Invokers{$SelectedInvoker} = $SelectedInvoker . " ($InvokerDeletedText)";
        }
        my $InvokerFilterStrg = $LayoutObject->BuildSelection(
            Data         => \%Invokers,
            ID           => 'InvokerFilter',
            Name         => 'InvokerFilter',
            SelectedID   => $Param{ErrorHandlingConfig}->{InvokerFilter},
            Multiple     => 1,
            PossibleNone => 1,
            Translate    => 0,
            Class        => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'InvokerFilter',
            Data => {
                InvokerFilterStrg => $InvokerFilterStrg,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => {
            %Param,
            %TemplateData,
            ErrorHandling  => $Param{ErrorHandling},
            WebserviceName => $Param{WebserviceData}->{Name},
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _RequestParamsGet {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %GetParam;
    for my $StringParam (
        qw(
        Description ErrorCode ErrorMessage
        ErrorMessageContentFilter StopAfterMatch
        )
        )
    {
        $GetParam{$StringParam} = $ParamObject->GetParam( Param => $StringParam ) // '';
    }
    for my $ArrayParam (qw(InvokerFilter OperationFilter ErrorStageFilter)) {
        $GetParam{$ArrayParam} = [ $ParamObject->GetArray( Param => $ArrayParam ) ];
    }

    return \%GetParam;
}

=head2 _ErrorHandlingTypeCheck()

checks if a given ErrorHandlingType is registered in the system.

=cut

sub _ErrorHandlingTypeCheck {
    my ( $Self, %Param ) = @_;

    return if !$Param{ErrorHandlingType};

    my $ErrorHandlingConfig = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::ErrorHandling::Module');
    return if !IsHashRefWithData($ErrorHandlingConfig);

    return if !IsHashRefWithData( $ErrorHandlingConfig->{ $Param{ErrorHandlingType} } );
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
