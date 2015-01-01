# --
# Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm - provides a TransportHTTPSOAP view for admins
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceTransportHTTPREST;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::Valid;
use Kernel::System::JSON;
use YAML;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );
    $Self->{JSONObject}  = Kernel::System::JSON->new( %{$Self} );
    $Self->{WebserviceObject} =
        Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceID = $Self->{ParamObject}->GetParam( Param => 'WebserviceID' )
        || '';
    my $CommunicationType = $Self->{ParamObject}->GetParam( Param => 'CommunicationType' )
        || '';

    # ------------------------------------------------------------ #
    # subaction Change: load webservice and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' || $Self->{Subaction} eq 'Change' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get webserice configuration
        my $WebserviceData =
            $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
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
    # subaction ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get webserice configuration
        my $WebserviceData =
            $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # get parameter from web browser
        my $GetParam;
        for my $ParamName (
            qw(
            Host DefaultCommand Authentication User Password UseX509
            X509CertFile X509KeyFile X509CAFile MaxLength KeepAlive
            )
            )
        {
            $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
        }

        # check required parameters
        my %Error;

        # to store the clean new configuration locally
        my $TransportConfig;

        # check if is not provider (requester)
        if ( $CommunicationType ne 'Provider' ) {

            NEEDED:
            for my $ParamName (
                qw( Host DefaultCommand )
                )
            {
                if ( !$GetParam->{$ParamName} ) {

                    # add server error error class
                    $Error{ $ParamName . 'ServerError' }        = 'ServerError';
                    $Error{ $ParamName . 'ServerErrorMessage' } = 'This field is required';

                    next NEEDED;
                }

                $TransportConfig->{$ParamName} = $GetParam->{$ParamName};
            }

            my $Invokers = $WebserviceData->{Config}->{$CommunicationType}->{Invoker};
            if ( IsHashRefWithData($Invokers) ) {

                INVOKER:
                for my $CurrentInvoker ( sort keys %{$Invokers} ) {

                    my $Controller = $Self->{ParamObject}->GetParam(
                        Param => 'InvokerControllerMapping' . $CurrentInvoker,
                    );

                    if ( !$Controller ) {
                        $Error{ 'InvokerControllerMapping' . $CurrentInvoker . 'ServerError' } = 'ServerError';
                        $Error{
                            'InvokerControllerMapping'
                                . $CurrentInvoker
                                . 'ServerErrorMessage'
                        } = 'This field is required';
                        next INVOKER;
                    }

                    $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Controller} = $Controller;

                    my $Command = $Self->{ParamObject}->GetParam(
                        Param => 'Command' . $CurrentInvoker
                    );
                    next INVOKER if !$Command;

                    $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Command} = $Command;
                }
            }

            # check for BasicAuth Authentication
            if ( $GetParam->{Authentication} && $GetParam->{Authentication} eq 'BasicAuth' ) {

                # get BasicAuth settings
                $TransportConfig->{Authentication}->{Type}     = $GetParam->{Authentication};
                $TransportConfig->{Authentication}->{User}     = $GetParam->{User};
                $TransportConfig->{Authentication}->{Password} = $GetParam->{Password};

                if ( !$GetParam->{User} ) {

                    # add server error error class
                    $Error{'UserServerError'} = 'ServerError';
                }
            }

            # check SSL options
            if ( $GetParam->{UseX509} && $GetParam->{UseX509} eq 'Yes' ) {

                # get X509 auth settings
                $TransportConfig->{X509}->{UseX509} = $GetParam->{UseX509};

                NEEDED:
                for my $Needed (qw(CertFile KeyFile)) {

                    if ( !$GetParam->{ 'X509' . $Needed } ) {

                        # add server error error class
                        $Error{ 'X509' . $Needed . 'ServerError' } = 'ServerError';
                        next NEEDED;
                    }

                    $TransportConfig->{X509}->{ 'X509' . $Needed } = $GetParam->{ 'X509' . $Needed };
                }

                # This param is optional so use it just if we have at least a length
                if ( $GetParam->{'X509CAFile'} && length $GetParam->{'X509CAFile'} ) {
                    $TransportConfig->{X509}->{'X509CAFile'} = $GetParam->{'X509CAFile'};
                }
            }
        }

        # otherwise is provider
        else {

            NEEDED:
            for my $ParamName (
                qw( MaxLength KeepAlive )
                )
            {
                if ( !defined $GetParam->{$ParamName} ) {

                    # add server error error class
                    $Error{ $ParamName . 'ServerError' }        = 'ServerError';
                    $Error{ $ParamName . 'ServerErrorMessage' } = 'This field is required';

                    next NEEDED;
                }

                $TransportConfig->{$ParamName} = $GetParam->{$ParamName};
            }

            my $Operations = $WebserviceData->{Config}->{$CommunicationType}->{Operation};
            if ( IsHashRefWithData($Operations) ) {

                OPERATION:
                for my $CurrentOperation ( sort keys %{$Operations} ) {

                    my $Route = $Self->{ParamObject}->GetParam(
                        Param => 'RouteOperationMapping' . $CurrentOperation,
                    );

                    if ( !$Route ) {
                        $Error{ 'RouteOperationMapping' . $CurrentOperation . 'ServerError' } = 'ServerError';
                        $Error{ 'RouteOperationMapping' . $CurrentOperation . 'ServerErrorMessage' }
                            = 'This field is required';
                        next OPERATION;
                    }

                    $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{Route} = $Route;

                    my @RequestMethod = $Self->{ParamObject}->GetArray(
                        Param => 'RequestMethod' . $CurrentOperation,
                    );
                    next OPERATION if !scalar @RequestMethod;

                    $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{RequestMethod} = \@RequestMethod;
                }
            }

            $TransportConfig->{KeepAlive} = $GetParam->{KeepAlive};
            $TransportConfig->{MaxLength} = $GetParam->{MaxLength};

            # set error for non integer contents
            if ( $GetParam->{MaxLength} !~ m{\A\d+\Z}sxi ) {

                # add server error error class
                $Error{MaxLengthServerError}        = 'ServerError';
                $Error{MaxLengthServerErrorMessage} = 'This field should be an integer number.';
            }
        }

        # set new configuration
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config} = $TransportConfig;

        # if there is an error return to edit screen
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

        # otherwise save configuration and return to overview screen
        my $Success = $Self->{WebserviceObject}->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # Save button: stay in edit mode.
        my $RedirectURL = "Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Change;"
            . "WebserviceID=$WebserviceID;CommunicationType=$CommunicationType;";

        # Save and finish button: go to Webservice.
        if ( $Self->{ParamObject}->GetParam( Param => 'ReturnToWebservice' ) ) {
            $RedirectURL = "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;";

        }

        return $Self->{LayoutObject}->Redirect(
            OP => $RedirectURL,
        );
    }

    return $Self->{LayoutObject}->ErrorScreen(
        Message => "Need Subaction!",
    );
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # configuration
    $Param{Type}           = 'HTTP::REST';
    $Param{WebserviceName} = $Param{WebserviceData}->{Name};
    my $TransportConfig = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }
        ->{Transport}->{Config};

    # extract display parameters from transport config
    $Param{Host}           = $TransportConfig->{Host};
    $Param{DefaultCommand} = $TransportConfig->{DefaultCommand};
    $Param{Authentication} = $TransportConfig->{Authentication}->{Type};
    $Param{User}           = $TransportConfig->{Authentication}->{User};
    $Param{Password}       = $TransportConfig->{Authentication}->{Password};
    $Param{UseX509}        = $TransportConfig->{X509}->{UseX509};
    $Param{X509CertFile}   = $TransportConfig->{X509}->{X509CertFile};
    $Param{X509KeyFile}    = $TransportConfig->{X509}->{X509KeyFile};
    $Param{X509CAFile}     = $TransportConfig->{X509}->{X509CAFile};
    $Param{KeepAlive}      = $TransportConfig->{KeepAlive};
    $Param{MaxLength}      = $TransportConfig->{MaxLength};

    # call bread crumbs blocks
    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Web Services',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => $Param{WebserviceName},
            Link => 'Action=AdminGenericInterfaceWebservice;Subaction=' . $Param{Action}
                . ';WebserviceID=' . $Param{WebserviceID},
            Nav => '',
        },
    );

    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => $Param{CommunicationType} . ' Transport ' . $Param{Type},
            Link => 'Action=AdminGenericInterfaceTransportHTTPREST;Subaction=' . $Param{Action}
                . ';CommunicationType=' . $Param{CommunicationType}
                . ';WebserviceID=' . $Param{WebserviceID},
            Nav => '',
        },
    );

    my @PossibleRequestMethods = qw(GET POST PUT PATCH DELETE HEAD OPTIONS CONNECT TRACE);

    # check if communication type is not provider (requester)
    if ( $Param{CommunicationType} ne 'Provider' ) {

        # create Authentication types select
        $Param{DefaultCommandStrg} = $Self->{LayoutObject}->BuildSelection(
            Data          => \@PossibleRequestMethods,
            Name          => 'DefaultCommand',
            SelectedValue => $Param{DefaultCommand} || 'GET',
            Sort          => 'AlphanumericValue',
        );

        # create Authentication types select
        $Param{AuthenticationStrg} = $Self->{LayoutObject}->BuildSelection(
            Data          => ['BasicAuth'],
            Name          => 'Authentication',
            SelectedValue => $Param{Authentication} || '-',
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
        );

        # hide and disable authentication methods if they are not selected
        $Param{BasicAuthHidden} = 'Hidden';
        if ( $Param{Authentication} && $Param{Authentication} eq 'BasicAuth' )
        {
            $Param{BasicAuthHidden}      = '';
            $Param{UserValidateRequired} = 'Validate_Required';
        }

        # create use X509 select
        $Param{UseX509Strg} = $Self->{LayoutObject}->BuildSelection(
            Data => [ 'No', 'Yes' ],
            Name => 'UseX509',
            SelectedValue => $Param{UseX509} || 'No',
            PossibleNone  => 0,
            Sort          => 'AlphanumericValue',
        );

        # hide and disable X509 options if they are not selected
        $Param{X509Hidden} = 'Hidden';
        if ( $Param{UseX509} && $Param{UseX509} eq 'Yes' )
        {
            $Param{X509Hidden}                   = '';
            $Param{X509CertFileValidateRequired} = 'Validate_Required';
            $Param{X509KeyFileValidateRequired}  = 'Validate_Required';
            $Param{X509CAFileValidateRequired}   = 'Validate_Required';
        }

        # call Endpoint block
        $Self->{LayoutObject}->Block(
            Name => 'Endpoint',
            Data => \%Param,
        );
    }

    # call provider or requester specific bocks
    $Self->{LayoutObject}->Block(
        Name => 'Transport' . $Param{CommunicationType},
        Data => \%Param,
    );

    # check if communication type is not provider (requester)
    my $SaveAndFinishOK;
    if ( $Param{CommunicationType} ne 'Provider' ) {

        my $Invokers = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Invoker};
        if ( IsHashRefWithData($Invokers) ) {

            for my $CurrentInvoker ( sort keys %{$Invokers} ) {

                my $CommandStrg = $Self->{LayoutObject}->BuildSelection(
                    Data => \@PossibleRequestMethods,
                    Name => 'Command' . $CurrentInvoker,
                    SelectedValue =>
                        $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}->{Command}
                        || '-',
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                );

                $Self->{LayoutObject}->Block(
                    Name => 'InvokerControllerMapping',
                    Data => {
                        Invoker => $CurrentInvoker,
                        Controller =>
                            $TransportConfig->{InvokerControllerMapping}->{$CurrentInvoker}
                            ->{Controller},
                        CommandStrg => $CommandStrg,
                        ServerError =>
                            $Param{ 'InvokerControllerMapping' . $CurrentInvoker . 'ServerError' }
                            || '',
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

        if ( $Param{Host} && $Param{DefaultCommand} ) {
            $SaveAndFinishOK = 1;
        }
    }

    # otherwise is provider
    else {
        my $Operations = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Operation};
        if ( IsHashRefWithData($Operations) ) {

            for my $CurrentOperation ( sort keys %{$Operations} ) {

                my $RequestMethodStrg = $Self->{LayoutObject}->BuildSelection(
                    Data          => \@PossibleRequestMethods,
                    Name          => 'RequestMethod' . $CurrentOperation,
                    SelectedValue => $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}
                        ->{RequestMethod} || ['-'],
                    PossibleNone => 1,
                    Multiple     => 1,
                    Sort         => 'AlphanumericValue',
                );

                $Self->{LayoutObject}->Block(
                    Name => 'RouteOperationMapping',
                    Data => {
                        Operation => $CurrentOperation,
                        Route =>
                            $TransportConfig->{RouteOperationMapping}->{$CurrentOperation}->{Route},
                        RequestMethodStrg => $RequestMethodStrg,
                        ServerError =>
                            $Param{ 'RouteOperationMapping' . $CurrentOperation . 'ServerError' }
                            || '',
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

        $Param{KeepAliveStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                0 => 'No',
                1 => 'Yes',
            },
            Name         => 'KeepAlive',
            SelectedID   => $Param{KeepAlive} || 0,
            PossibleNone => 0,
            Translation  => 1,
        );

        if ( $Param{MaxLength} && defined $Param{KeepAlive} ) {
            $SaveAndFinishOK = 1;
        }
    }

    # call save and finish block
    if ($SaveAndFinishOK) {
        $Self->{LayoutObject}->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceTransportHTTPREST',
        Data         => { %Param, },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
