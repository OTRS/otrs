# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceTransportHTTPREST;

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
    $Self->{EmptyString}     = '_AdditionalHeaders_EmptyString_Dont_Use_It_String_Please';
    $Self->{DuplicateString} = '_AdditionalHeaders_DuplicatedString_Dont_Use_It_String_Please';
    $Self->{DeletedString}   = '_AdditionalHeaders_DeletedString_Dont_Use_It_String_Please';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject      = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $WebserviceID      = $ParamObject->GetParam( Param => 'WebserviceID' )      || '';
    my $CommunicationType = $ParamObject->GetParam( Param => 'CommunicationType' ) || '';

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # Check for WebserviceID.
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need WebserviceID!'),
            );
        }

        # Get web service configuration.
        my $WebserviceData = $WebserviceObject->WebserviceGet( ID => $WebserviceID );

        # Check for valid web service configuration.
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
            );
        }

        return $Self->_ShowEdit(
            %Param,
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
            Action            => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # invalid sub-action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} ne 'ChangeAction' ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need valid Subaction!'),
        );
    }

    # ------------------------------------------------------------ #
    # sub-action ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #

    # Challenge token check for write action.
    $LayoutObject->ChallengeTokenCheck();

    # Check for WebserviceID.
    if ( !$WebserviceID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need WebserviceID!'),
        );
    }

    # Get web service configuration.
    my $WebserviceData = $WebserviceObject->WebserviceGet(
        ID => $WebserviceID,
    );

    # Check for valid web service configuration.
    if ( !IsHashRefWithData($WebserviceData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
        );
    }

    # Get parameter from web browser.
    my $GetParam = $Self->_GetParams();

    # Check required parameters.
    my %Error;

    # To store the clean new configuration locally.
    my $TransportConfig;

    # Get requester specific settings.
    if ( $CommunicationType eq 'Requester' ) {

        NEEDED:
        for my $Needed (qw( Host DefaultCommand Timeout )) {
            $TransportConfig->{$Needed} = $GetParam->{$Needed};
            next NEEDED if defined $GetParam->{$Needed};

            $Error{ $Needed . 'ServerError' }        = 'ServerError';
            $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
        }

        # Set error for non integer content.
        if ( $GetParam->{Timeout} && !IsInteger( $GetParam->{Timeout} ) ) {
            $Error{TimeoutServerError}        = 'ServerError';
            $Error{TimeoutServerErrorMessage} = Translatable('This field should be an integer.');
        }

        # Check authentication options.
        if ( $GetParam->{AuthType} && $GetParam->{AuthType} eq 'BasicAuth' ) {

            # Get BasicAuth settings.
            for my $ParamName (qw( AuthType BasicAuthUser BasicAuthPassword )) {
                $TransportConfig->{Authentication}->{$ParamName} = $GetParam->{$ParamName};
            }
            NEEDED:
            for my $Needed (qw( BasicAuthUser BasicAuthPassword )) {
                next NEEDED if defined $GetParam->{$Needed} && length $GetParam->{$Needed};

                $Error{ $Needed . 'ServerError' }        = 'ServerError';
                $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
            }
        }

        # Check proxy options.
        if ( $GetParam->{UseProxy} && $GetParam->{UseProxy} eq 'Yes' ) {

            # Get Proxy settings.
            for my $ParamName (qw( UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude )) {
                $TransportConfig->{Proxy}->{$ParamName} = $GetParam->{$ParamName};
            }
        }

        # Check SSL options.
        if ( $GetParam->{UseSSL} && $GetParam->{UseSSL} eq 'Yes' ) {

            # Get SSL authentication settings.
            for my $ParamName (qw( UseSSL SSLPassword )) {
                $TransportConfig->{SSL}->{$ParamName} = $GetParam->{$ParamName};
            }
            PARAMNAME:
            for my $ParamName (qw( SSLCertificate SSLKey SSLCAFile SSLCADir )) {
                $TransportConfig->{SSL}->{$ParamName} = $GetParam->{$ParamName};

                # Check if file/directory exists and is accessible.
                next PARAMNAME if !$GetParam->{$ParamName};
                if ( $ParamName eq 'SSLCADir' ) {
                    next PARAMNAME if -d $GetParam->{$ParamName};
                }
                else {
                    next PARAMNAME if -f $GetParam->{$ParamName};
                }
                $Error{ $ParamName . 'ServerError' }        = 'ServerError';
                $Error{ $ParamName . 'ServerErrorMessage' } = Translatable('File or Directory not found.');
            }
        }

        my $Invokers = $WebserviceData->{Config}->{$CommunicationType}->{Invoker};

        if ( IsHashRefWithData($Invokers) ) {

            INVOKER:
            for my $CurrentInvoker ( sort keys %{$Invokers} ) {

                my $Controller = $ParamObject->GetParam(
                    Param => 'InvokerControllerMapping' . $CurrentInvoker,
                );

                if ( !$Controller ) {
                    $Error{ 'InvokerControllerMapping' . $CurrentInvoker . 'ServerError' } = 'ServerError';
                    $Error{
                        'InvokerControllerMapping'
                            . $CurrentInvoker
                            . 'ServerErrorMessage'
                    } = Translatable('This field is required');
                    next INVOKER;
                }

                $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Controller} = $Controller;

                my $Command = $ParamObject->GetParam(
                    Param => 'Command' . $CurrentInvoker
                );
                next INVOKER if !$Command;

                $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Command} = $Command;
            }
        }
    }

    # Get provider specific settings.
    else {

        NEEDED:
        for my $Needed (qw( MaxLength KeepAlive )) {
            $TransportConfig->{$Needed} = $GetParam->{$Needed};
            next NEEDED if defined $GetParam->{$Needed};

            $Error{ $Needed . 'ServerError' }        = 'ServerError';
            $Error{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required');
        }

        # Set error for non integer content.
        if ( $GetParam->{MaxLength} && !IsInteger( $GetParam->{MaxLength} ) ) {
            $Error{MaxLengthServerError}        = 'ServerError';
            $Error{MaxLengthServerErrorMessage} = Translatable('This field should be an integer.');
        }

        my $Operations = $WebserviceData->{Config}->{$CommunicationType}->{Operation};

        if ( IsHashRefWithData($Operations) ) {

            OPERATION:
            for my $CurrentOperation ( sort keys %{$Operations} ) {

                my $Route = $ParamObject->GetParam(
                    Param => 'RouteOperationMapping' . $CurrentOperation,
                );

                if ( !$Route ) {
                    $Error{ 'RouteOperationMapping' . $CurrentOperation . 'ServerError' } = 'ServerError';
                    $Error{ 'RouteOperationMapping' . $CurrentOperation . 'ServerErrorMessage' }
                        = Translatable('This field is required');
                    next OPERATION;
                }

                $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{Route} = $Route;

                my @RequestMethod = $ParamObject->GetArray(
                    Param => 'RequestMethod' . $CurrentOperation,
                );
                next OPERATION if !scalar @RequestMethod;

                $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{RequestMethod} = \@RequestMethod;
            }
        }

        # Get additional headers.
        $TransportConfig->{AdditionalHeaders} = $Self->_GetAdditionalHeaders();
    }

    # Set new configuration.
    $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config} = $TransportConfig;

    # If there is an error return to edit screen.
    if ( IsHashRefWithData( \%Error ) ) {
        return $Self->_ShowEdit(
            %Error,
            %Param,
            WebserviceID      => $WebserviceID,
            WebserviceData    => $WebserviceData,
            CommunicationType => $CommunicationType,
            Action            => 'Change',
        );
    }

    # Otherwise save configuration and return to overview screen.
    my $Success = $WebserviceObject->WebserviceUpdate(
        ID      => $WebserviceID,
        Name    => $WebserviceData->{Name},
        Config  => $WebserviceData->{Config},
        ValidID => $WebserviceData->{ValidID},
        UserID  => $Self->{UserID},
    );

    # If the user would like to continue editing the transport config, just redirect to the edit screen.
    if (
        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
        )
    {
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Change;WebserviceID=$WebserviceID;CommunicationType=$CommunicationType;",
        );
    }
    else {

        # Otherwise return to overview.
        return $LayoutObject->Redirect(
            OP => "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;",
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    $Param{Type}           = 'HTTP::REST';
    $Param{WebserviceName} = $Param{WebserviceData}->{Name};
    my $TransportConfig = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config};

    # Extract display parameters from transport config.
    for my $ParamName (
        qw(
        Host DefaultCommand KeepAlive MaxLength Timeout
        AdditionalHeaders
        )
        )
    {
        $Param{$ParamName} = $TransportConfig->{$ParamName};
    }
    for my $ParamName (qw( AuthType BasicAuthUser BasicAuthPassword )) {
        $Param{$ParamName} = $TransportConfig->{Authentication}->{$ParamName};
    }
    for my $ParamName (qw( UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir )) {
        $Param{$ParamName} = $TransportConfig->{SSL}->{$ParamName};
    }
    for my $ParamName (qw( UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude )) {
        $Param{$ParamName} = $TransportConfig->{Proxy}->{$ParamName};
    }

    my @PossibleRequestMethods = qw(GET POST PUT PATCH DELETE HEAD OPTIONS CONNECT TRACE);

    # Check if communication type is requester.
    if ( $Param{CommunicationType} eq 'Requester' ) {

        # create default command types select
        $Param{DefaultCommandStrg} = $LayoutObject->BuildSelection(
            Data          => \@PossibleRequestMethods,
            Name          => 'DefaultCommand',
            SelectedValue => $Param{DefaultCommand} || 'GET',
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create Timeout select.
        $Param{TimeoutStrg} = $LayoutObject->BuildSelection(
            Data          => [ '30', '60', '90', '120', '150', '180', '210', '240', '270', '300' ],
            Name          => 'Timeout',
            SelectedValue => $Param{Timeout} || '120',
            Sort          => 'NumericValue',
            Class         => 'Modernize',
        );

        # Create Authentication types select.
        $Param{AuthenticationStrg} = $LayoutObject->BuildSelection(
            Data          => ['BasicAuth'],
            Name          => 'AuthType',
            SelectedValue => $Param{AuthType} || '-',
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable authentication methods if they are not selected.
        $Param{BasicAuthHidden} = 'Hidden';
        if ( $Param{AuthType} && $Param{AuthType} eq 'BasicAuth' ) {
            $Param{BasicAuthHidden}                   = '';
            $Param{BasicAuthUserServerError}          = 'Validate_Required';
            $Param{BasicAuthPasswordValidateRequired} = 'Validate_Required';
        }

        # Create use Proxy select.
        $Param{UseProxyStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'UseProxy',
            SelectedValue => $Param{UseProxy} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Create Proxy exclude select.
        $Param{ProxyExcludeStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'ProxyExclude',
            SelectedValue => $Param{ProxyExclude} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable Proxy options if they are not selected.
        $Param{ProxyHidden} = 'Hidden';
        if ( $Param{UseProxy} && $Param{UseProxy} eq 'Yes' )
        {
            $Param{ProxyHidden} = '';
        }

        # Create use SSL select.
        $Param{UseSSLStrg} = $LayoutObject->BuildSelection(
            Data => {
                'No'  => Translatable('No'),
                'Yes' => Translatable('Yes'),
            },
            Name          => 'UseSSL',
            SelectedValue => $Param{UseSSL} || Translatable('No'),
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize',
        );

        # Hide and disable SSL options if they are not selected.
        $Param{SSLHidden} = 'Hidden';
        if ( $Param{UseSSL} && $Param{UseSSL} eq 'Yes' )
        {
            $Param{SSLHidden} = '';
        }

        my $Invokers = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Invoker};
        if ( IsHashRefWithData($Invokers) ) {

            for my $CurrentInvoker ( sort keys %{$Invokers} ) {

                my $CommandStrg = $LayoutObject->BuildSelection(
                    Data => \@PossibleRequestMethods,
                    Name => 'Command' . $CurrentInvoker,
                    SelectedValue =>
                        $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Command}
                        || '-',
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Class        => 'Modernize',
                );

                $LayoutObject->Block(
                    Name => 'InvokerControllerMapping',
                    Data => {
                        Invoker     => $CurrentInvoker,
                        Controller  => $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Controller},
                        CommandStrg => $CommandStrg,
                        ServerError => $Param{ 'InvokerControllerMapping' . $CurrentInvoker . 'ServerError' } || '',
                        ServerErrorMessage => $Param{
                            'InvokerControllerMapping'
                                . $CurrentInvoker
                                . 'ServerErrorMessage'
                            }
                            || '',
                    },
                );
            }
        }
    }

    # Check if communication type is requester.
    elsif ( $Param{CommunicationType} eq 'Provider' ) {
        my $Operations = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Operation};
        if ( IsHashRefWithData($Operations) ) {

            for my $CurrentOperation ( sort keys %{$Operations} ) {

                my $RequestMethodStrg = $LayoutObject->BuildSelection(
                    Data          => \@PossibleRequestMethods,
                    Name          => 'RequestMethod' . $CurrentOperation,
                    SelectedValue => $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{RequestMethod}
                        || ['-'],
                    PossibleNone => 1,
                    Multiple     => 1,
                    Sort         => 'AlphanumericValue',
                    Class        => 'Modernize',
                );

                $LayoutObject->Block(
                    Name => 'RouteOperationMapping',
                    Data => {
                        Operation         => $CurrentOperation,
                        Route             => $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{Route},
                        RequestMethodStrg => $RequestMethodStrg,
                        ServerError => $Param{ 'RouteOperationMapping' . $CurrentOperation . 'ServerError' } || '',
                        ServerErrorMessage => $Param{
                            'RouteOperationMapping'
                                . $CurrentOperation
                                . 'ServerErrorMessage'
                            }
                            || '',
                    },
                );
            }
        }

        $Param{KeepAliveStrg} = $LayoutObject->BuildSelection(
            Data => {
                0 => Translatable('No'),
                1 => Translatable('Yes'),
            },
            Name         => 'KeepAlive',
            SelectedID   => $Param{KeepAlive} || 0,
            PossibleNone => 0,
            Translation  => 1,
            Class        => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'AdditionalHeaders',
            Data => {
                %Param,
            },
        );

        # Output the possible values and errors within (if any).
        my $ValueCounter = 1;
        for my $Key ( sort keys %{ $Param{AdditionalHeaders} || {} } ) {
            $LayoutObject->Block(
                Name => 'ValueRow',
                Data => {
                    Key          => $Key,
                    ValueCounter => $ValueCounter,
                    Value        => $Param{AdditionalHeaders}->{$Key},
                },
            );

            $ValueCounter++;
        }

        # Create the possible values template.
        $LayoutObject->Block(
            Name => 'ValueTemplate',
            Data => {
                %Param,
            },
        );

        # Set value counter.
        $Param{ValueCounter} = $ValueCounter;
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceTransportHTTPREST',
        Data         => { %Param, },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $GetParam;

    # Get parameters from web browser.
    for my $ParamName (
        qw(
        Host DefaultCommand MaxLength KeepAlive Timeout
        AuthType BasicAuthUser BasicAuthPassword
        UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude
        UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir
        )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }
    return $GetParam;
}

sub _GetAdditionalHeaders {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get ValueCounters.
    my $ValueCounter = $ParamObject->GetParam( Param => 'ValueCounter' ) || 0;

    # Get possible values.
    my $AdditionalHeaderConfig;
    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {
        my $Key = $ParamObject->GetParam( Param => 'Key' . '_' . $ValueIndex ) // '';

        # Check if key was deleted by the user and skip it.
        next VALUEINDEX if $Key eq $Self->{DeletedString};

        # Skip empty key.
        next VALUEINDEX if $Key eq '';

        my $Value = $ParamObject->GetParam( Param => 'Value' . '_' . $ValueIndex ) // '';
        $AdditionalHeaderConfig->{$Key} = $Value;
    }

    return $AdditionalHeaderConfig;
}

1;
