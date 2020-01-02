# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceErrorHandlingRequestRetry;

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

    # Check mandatory parameters.
    NEEDED:
    for my $Needed (qw(ScheduleRetry RetryIntervalStart RetryIntervalFactor RetryIntervalMax)) {
        next NEEDED if IsStringWithData( $RequestParams->{$Needed} );

        $Errors{ $Needed . 'ServerError' } = 'ServerError';
    }

    # Name already exists.
    my $ErrorHandling = $ParamObject->GetParam( Param => 'ErrorHandling' );
    if (
        !IsStringWithData($ErrorHandling)
        || $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{ErrorHandling}->{$ErrorHandling}
        )
    {
        $Errors{ErrorHandlingServerError} = 'ServerError';
    }

    # Max retry count must be empty or an integer.
    if (
        IsStringWithData( $RequestParams->{RetryCountMax} )
        && !IsPositiveInteger( $RequestParams->{RetryCountMax} )
        )
    {
        $Errors{RetryCountMaxServerError} = 'ServerError';
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

    # Check mandatory parameters.
    NEEDED:
    for my $Needed (qw(ScheduleRetry RetryIntervalStart RetryIntervalFactor RetryIntervalMax)) {
        next NEEDED if IsStringWithData( $RequestParams->{$Needed} );

        $Errors{ $Needed . 'ServerError' } = 'ServerError';
    }

    # Max retry count must be empty or an integer.
    if (
        IsStringWithData( $RequestParams->{RetryCountMax} )
        && !IsPositiveInteger( $RequestParams->{RetryCountMax} )
        )
    {
        $Errors{RetryCountMaxServerError} = 'ServerError';
    }

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
        RetryCountMax             => $Param{ErrorHandlingConfig}->{RetryCountMax} // 10,
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

    $TemplateData{ScheduleRetryFieldsHidden} = $Param{ErrorHandlingConfig}->{ScheduleRetry} ? '' : 'Hidden';

    $TemplateData{ScheduleRetryStrg} = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        ID           => 'ScheduleRetry',
        Name         => 'ScheduleRetry',
        SelectedID   => $Param{ErrorHandlingConfig}->{ScheduleRetry} // 0,
        PossibleNone => 0,
        Translate    => 1,
        Class        => 'Modernize Validate_Required Validate_Number',
    );

    # All possibly selectable time frames
    my %DateSelection = (
        0                => Translatable('0 seconds'),
        15               => Translatable('15 seconds'),
        30               => Translatable('30 seconds'),
        45               => Translatable('45 seconds'),
        60               => Translatable('1 minute'),
        60 * 2           => Translatable('2 minutes'),
        60 * 3           => Translatable('3 minutes'),
        60 * 4           => Translatable('4 minutes'),
        60 * 5           => Translatable('5 minutes'),
        60 * 10          => Translatable('10 minutes'),
        60 * 15          => Translatable('15 minutes'),
        60 * 30          => Translatable('30 minutes'),
        60 * 60          => Translatable('1 hour'),
        60 * 60 * 2      => Translatable('2 hours'),
        60 * 60 * 3      => Translatable('3 hours'),
        60 * 60 * 4      => Translatable('4 hours'),
        60 * 60 * 5      => Translatable('5 hours'),
        60 * 60 * 6      => Translatable('6 hours'),
        60 * 60 * 12     => Translatable('12 hours'),
        60 * 60 * 18     => Translatable('18 hours'),
        60 * 60 * 24     => Translatable('1 day'),
        60 * 60 * 24 * 2 => Translatable('2 days'),
        60 * 60 * 24 * 3 => Translatable('3 days'),
        60 * 60 * 24 * 4 => Translatable('4 days'),
        60 * 60 * 24 * 5 => Translatable('5 days'),
        60 * 60 * 24 * 6 => Translatable('6 days'),
        60 * 60 * 24 * 7 => Translatable('1 week'),
    );

    # Use all dates from 0 seconds to 1 day for RetryIntervalStart.
    my %RetryIntervalStartSelection
        = map { $_ => $DateSelection{$_} } grep { $_ >= 0 && $_ <= 60 * 60 * 24 } sort keys %DateSelection;
    $TemplateData{RetryIntervalStartStrg} = $LayoutObject->BuildSelection(
        Data         => \%RetryIntervalStartSelection,
        ID           => 'RetryIntervalStart',
        Name         => 'RetryIntervalStart',
        SelectedID   => $Param{ErrorHandlingConfig}->{RetryIntervalStart} // 60,
        PossibleNone => 0,
        Translate    => 1,
        Sort         => 'NumericKey',
        Class        => 'Modernize Validate_Required Validate_Number',
    );

    $TemplateData{RetryIntervalFactorStrg} = $LayoutObject->BuildSelection(
        Data => {
            1   => '1',
            1.5 => '1.5',
            2   => '2',
        },
        ID           => 'RetryIntervalFactor',
        Name         => 'RetryIntervalFactor',
        SelectedID   => $Param{ErrorHandlingConfig}->{RetryIntervalFactor} || 2,
        PossibleNone => 0,
        Translate    => 0,
        Class        => 'Modernize Validate_Required',
    );

    # Use all dates from 0 seconds to 1 day for RetryIntervalMax.
    my %RetryIntervalMaxSelection
        = map { $_ => $DateSelection{$_} } grep { $_ >= 0 && $_ <= 60 * 60 * 24 } sort keys %DateSelection;
    $TemplateData{RetryIntervalMaxStrg} = $LayoutObject->BuildSelection(
        Data         => \%RetryIntervalMaxSelection,
        ID           => 'RetryIntervalMax',
        Name         => 'RetryIntervalMax',
        SelectedID   => $Param{ErrorHandlingConfig}->{RetryIntervalMax} // 60 * 60,
        PossibleNone => 0,
        Translate    => 1,
        Sort         => 'NumericKey',
        Class        => 'Modernize Validate_Required Validate_Number',
    );

    # Use all dates from 1 minute to 1 week for RetryPeriodMax.
    my %RetryPeriodMaxSelection
        = map { $_ => $DateSelection{$_} } grep { $_ >= 60 && $_ <= 60 * 60 * 24 * 7 } sort keys %DateSelection;
    $TemplateData{RetryPeriodMaxStrg} = $LayoutObject->BuildSelection(
        Data         => \%RetryPeriodMaxSelection,
        ID           => 'RetryPeriodMax',
        Name         => 'RetryPeriodMax',
        SelectedID   => $Param{ErrorHandlingConfig}->{RetryPeriodMax} // 60 * 60 * 24,
        PossibleNone => 1,
        Translate    => 1,
        Sort         => 'NumericKey',
        Class        => 'Modernize Validate_Number',
    );

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
        ScheduleRetry RetryIntervalStart RetryIntervalFactor RetryIntervalMax RetryCountMax RetryPeriodMax
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
