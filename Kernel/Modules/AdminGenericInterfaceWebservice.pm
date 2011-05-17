# --
# Kernel/Modules/AdminGenericInterfaceWebservice.pm - provides a webservice view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceWebservice.pm,v 1.10 2011-05-17 11:57:19 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebservice;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create addtional objects
    $Self->{ValidObject}      = Kernel::System::Valid->new( %{$Self} );
    $Self->{JSONObject}       = Kernel::System::JSON->new( %{$Self} );
    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    # get configurations
    # get configured transports
    $Self->{GITransportConfig} = $Self->{ConfigObject}->Get('GenericInterface::Transport::Module');

    # get configured operations
    $Self->{GIOperationConfig} = $Self->{ConfigObject}->Get('GenericInterface::Operation::Module');

    # get configured invokers
    $Self->{GIInvokerConfig} = $Self->{ConfigObject}->Get('GenericInterface::Invoker::Module');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $WebserviceID = $Self->{ParamObject}->GetParam( Param => 'WebserviceID' ) || '';

    # ------------------------------------------------------------ #
    # subaction Change: load webservice and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get webserice configuration
        my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
            Action         => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # subaction ChangeAction: write config and return to overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get webserice configuration
        my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $WebserviceData->{Name}                                 = $GetParam->{Name};
        $WebserviceData->{Config}->{Name}                       = $GetParam->{Name};
        $WebserviceData->{Config}->{Description}                = $GetParam->{Description};
        $WebserviceData->{Config}->{RemoteSystem}               = $GetParam->{RemoteSystem};
        $WebserviceData->{Config}->{Protocol}                   = $GetParam->{Protocol};
        $WebserviceData->{Config}->{Debugger}->{DebugThreshold} = $GetParam->{DebugThreshold};
        $WebserviceData->{Config}->{Debugger}->{TestMode}       = $GetParam->{TestMode};
        $WebserviceData->{ValidID}                              = $GetParam->{ValidID};

        for my $CommunicationType (qw( Provider Requester )) {

            # check if selected type is different from the one on the current configuration
            if (
                $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Type} ne
                $GetParam->{ $CommunicationType . 'Transport' }
                )
            {

                # delete current communication type transport
                delete $WebserviceData->{Config}->{$CommunicationType}->{Transport};

                # replace the current transport type with the new selected one
                # the rest of the configuration will be empty
                # the trasport need to be configured impendently
                $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Type} =
                    $GetParam->{ $CommunicationType . 'Transport' };
            }
        }

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        # check if name is duplicated
        my %WebserviceList = %{ $Self->{WebserviceObject}->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{ $GetParam->{Name} } &&
            $WebserviceList{ $GetParam->{Name} } ne $WebserviceID
            )
        {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'There is another webservice with the same name.';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                WebserviceID   => $WebserviceID,
                WebserviceData => $WebserviceData,
                Action         => 'Change',
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

        return $Self->_ShowOverview(
            %Param,
            Action => 'Overview',
        );
    }

    # ------------------------------------------------------------ #
    # subaction Add: show edit screen (empty)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' ) {

        return $Self->_ShowEdit(
            Action => 'Add',
        );
    }

    # ------------------------------------------------------------ #
    # subaction AddAction: create a webservice and return to overview
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # get webserice configuration
        my $WebserviceData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $WebserviceData->{Name}                                 = $GetParam->{Name};
        $WebserviceData->{Config}->{Name}                       = $GetParam->{Name};
        $WebserviceData->{Config}->{Description}                = $GetParam->{Description};
        $WebserviceData->{Config}->{RemoteSystem}               = $GetParam->{RemoteSystem};
        $WebserviceData->{Config}->{Protocol}                   = $GetParam->{Protocol};
        $WebserviceData->{Config}->{Debugger}->{DebugThreshold} = $GetParam->{DebugThreshold};
        $WebserviceData->{Config}->{Debugger}->{TestMode}       = $GetParam->{TestMode};
        $WebserviceData->{ValidID}                              = $GetParam->{ValidID};

        for my $CommunicationType (qw( Provider Requester )) {

            $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Type} =
                $GetParam->{ $CommunicationType . 'Transport' };
        }

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        # check if name is duplicated
        my %WebserviceList = %{ $Self->{WebserviceObject}->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{ $GetParam->{Name} } &&
            $WebserviceList{ $GetParam->{Name} } ne $WebserviceID
            )
        {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'There is another webservice with the same name.';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                WebserviceID   => $WebserviceID,
                WebserviceData => $WebserviceData,
                Action         => 'Add',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $Self->{WebserviceObject}->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        return $Self->_ShowOverview(
            %Param,
            Action => 'Overview',
        );
    }

    # ------------------------------------------------------------ #
    # subaction Export: create a YAML file with the configuration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Export' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get webserice configuration
        my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # dump configuration into a YAML structure
        my $YAMLContent = YAML::Dump( $WebserviceData->{Config} );

        # return yaml to download
        my $YAMLFile = $WebserviceData->{Name};
        return $Self->{LayoutObject}->Attachment(
            Filename    => $YAMLFile . '.yaml',
            ContentType => "text/plain; charset=" . $Self->{LayoutObject}->{UserCharset},
            Content     => $YAMLContent,
        );
    }

    # ------------------------------------------------------------ #
    # default: show start screen
    # ------------------------------------------------------------ #
    return $Self->_ShowOverview(
        %Param,
        Action => 'Overview',
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Webservices',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
    $Self->{LayoutObject}->Block( Name => 'OverviewHeader' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get webservices list
    my $WebserviceList = $Self->{WebserviceObject}->WebserviceList( Valid => 0 );

    # check if no webservices are registered
    if ( !IsHashRefWithData($WebserviceList) ) {
        $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
    }

    #otherwise show all webservices
    else {
        WEBSERVICEID:
        for my $WebserviceID ( keys %{$WebserviceList} ) {
            next WEBSERVICEID if !$WebserviceID;

            # get webservice data
            my $Webservice = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );
            next WEBSERVICEID if !$Webservice;

            # convert ValidID to text
            my $ValidStrg = $Self->{ValidObject}->ValidLookup(
                ValidID => $Webservice->{ValidID},
            );

            # prepare data to output
            my $Data = {
                ID           => $WebserviceID,
                Name         => $Webservice->{Name},
                Description  => $Webservice->{Config}->{Description},
                RemoteSystem => $Webservice->{Config}->{RemoteSystem},
                Protocol     => $Webservice->{Config}->{Protocol},
                Valid        => $ValidStrg,
            };

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => $Data,
            );
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceWebservice',
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $WebserviceData = $Param{WebserviceData};

    my $DebuggerData = $WebserviceData->{Config}->{Debugger} || {};

    my $ProviderData = $WebserviceData->{Config}->{Provider} || {};

    my $RequesterData = $WebserviceData->{Config}->{Requester} || {};

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Webservices',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    if ( $Param{Action} eq 'Change' && $WebserviceData->{Name} ) {
        $Self->{LayoutObject}->Block(
            Name => 'WebservicePathElement',
            Data => {
                Name => $WebserviceData->{Name},
                Link => 'Action=AdminGenericInterfaceWebservice;Subaction=' . $Param{Action}
                    . ';WebserviceID=' . $Param{WebserviceID},
                Nav => '',
            },
        );
    }
    elsif ( $Param{Action} eq 'Add' ) {
        $Self->{LayoutObject}->Block(
            Name => 'WebservicePathElement',
            Data => {
                Name => 'New Webservice',
                Link => 'Action=AdminGenericInterfaceWebservice;Subaction=' . $Param{Action},
                Nav  => '',
            },
        );
    }

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ActionClone',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ActionExport',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ActionImport',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ActionHistory',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ActionDelete',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ActionDebugger',
            Data => \%Param,
        );
    }
    elsif ( $Param{Action} eq 'Add' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ActionImport',
            Data => \%Param,
        );
    }

    my %GeneralData = (
        Name         => $WebserviceData->{Name},
        Description  => $WebserviceData->{Config}->{Description},
        RemoteSystem => $WebserviceData->{Config}->{RemoteSystem},
        Protocol     => $WebserviceData->{Config}->{Protocol},
    );

    # define the debug Thresholds (this needs to be hardcoded)
    my %DebugThreshold = (
        debug  => 'Debug',
        info   => 'Info',
        notice => 'Notice',
        error  => 'Error',
    );

    # create the DebugThreshold select
    my $DebugThresholdStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \%DebugThreshold,
        Name         => 'DebugThreshold',
        SelectedID   => $DebuggerData->{DebugThreshold} || '',
        PossibleNone => 0,
        Translate    => 1,
    );

    # create the DebugT test select
    my $DebugTestStrg = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name         => 'TestMode',
        SelectedID   => $DebuggerData->{TestMode},
        PossibleNone => 0,
        Translate    => 1,
    );

    my %ValidList = $Self->{ValidObject}->ValidList();

    # create the Validty select
    my $ValidtyStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $WebserviceData->{ValidID} || 1,
        PossibleNone => 0,
        Translate    => 1,
    );

    $Self->{LayoutObject}->Block(
        Name => 'Details',
        Data => {
            %Param,
            %GeneralData,
            DebugThresholdStrg => $DebugThresholdStrg,
            DebugTestStrg      => $DebugTestStrg,
            ValidtyStrg        => $ValidtyStrg,
            }
    );

    # set transports data
    my %GITransports;
    for my $Transport ( keys %{ $Self->{GITransportConfig} } ) {
        next if !$Transport;
        $GITransports{$Transport} = $Self->{GITransportConfig}->{$Transport}->{ConfigDialog};
    }

    # get operations data
    my %GIOperations;
    for my $Operation ( keys %{ $Self->{GIOperationConfig} } ) {
        next if !$Operation;
        $GIOperations{$Operation} = $Self->{GIOperationConfig}->{$Operation}->{ConfigDialog};
    }

    # get operations data
    my %GIInvokers;
    for my $Invoker ( keys %{ $Self->{GIInvokerConfig} } ) {
        next if !$Invoker;
        $GIInvokers{$Invoker} = $Self->{GIInvokerConfig}->{$Invoker}->{ConfigDialog};
    }

    $Self->_OutputGIConfig(
        GITransports => \%GITransports,
        GIOperations => \%GIOperations,
        GIInvokers   => \%GIInvokers,
    );

    # meta configuration for output blocks
    my %CommTypeConfig = (
        Provider => {
            Title             => 'OTRS as provider',
            SelectedTransport => $ProviderData->{Transport}->{Type},
            ActionType        => 'Operation',
            ActionsTitle      => 'Operations',
            ActionsConfig     => $ProviderData->{Operation},
            ControllerData    => \%GIOperations,
        },
        Requester => {
            Title             => 'OTRS as requester',
            SelectedTransport => $RequesterData->{Transport}->{Type},
            ActionType        => 'Invoker',
            ActionsTitle      => 'Invokers',
            ActionsConfig     => $RequesterData->{Invoker},
            ControllerData    => \%GIInvokers,
        },

    );

    for my $CommunicationType (qw(Provider Requester)) {

        my @TransportList;

        for my $Transport ( keys %GITransports ) {
            push @TransportList, $Transport;
        }

        # create the list of transports
        my $TransportsStrg = $Self->{LayoutObject}->BuildSelection(
            Data          => \@TransportList,
            Name          => $CommunicationType . 'TransportList',
            SelectedValue => $CommTypeConfig{$CommunicationType}->{SelectedTransport},
            Sort          => 'AlphanumericValue',
        );

        # get the controllers config for Requesters or Providers
        my %GIControllers = %{ $CommTypeConfig{$CommunicationType}->{ControllerData} };

        my @ControllerList;

        for my $Action ( keys %GIControllers ) {
            push @ControllerList, $Action;
        }

        # create the list of controllers
        my $ControllersStrg = $Self->{LayoutObject}->BuildSelection(
            Data => \@ControllerList,
            Name => $CommTypeConfig{$CommunicationType}->{ActionType} . 'List',
            Sort => 'AlphanumericValue',
        );

        $Self->{LayoutObject}->Block(
            Name => 'DetailsCommunicationType',
            Data => {
                CommunicationType => $CommunicationType,
                Title             => $CommTypeConfig{$CommunicationType}->{Title},
                TransportsStrg    => $TransportsStrg,
                ActionType        => $CommTypeConfig{$CommunicationType}->{ActionType},
                ControllersStrg   => $ControllersStrg,
                ActionsTitle      => $CommTypeConfig{$CommunicationType}->{ActionsTitle},
                }
        );

        if ( !IsHashRefWithData( $CommTypeConfig{$CommunicationType}->{ActionsConfig} ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'DetailsActionsNoDataFoundMsg',
                Data => {},
            );
        }
        else {

            # output Opertions and Invokers tables
            for my $ActionName ( keys %{ $CommTypeConfig{$CommunicationType}->{ActionsConfig} } ) {

                # get control information
                my $ActionDails
                    = $CommTypeConfig{$CommunicationType}->{ActionsConfig}->{$ActionName};

                # set mapping string
                my $Mapping = 'No';
                if ( $ActionDails->{MappingInbound} or $ActionDails->{MappingInbound} ) {
                    $Mapping = 'Yes';
                }

                # create output data
                my %ActionData = (
                    Name       => $ActionName,
                    Controller => $ActionDails->{Type},
                    Mapping    => $Mapping,
                    Module     => $GIControllers{ $ActionDails->{Type} },
                    ActionLink => $CommTypeConfig{$CommunicationType}->{ActionType} . "="
                        . $ActionName,
                );

                $Self->{LayoutObject}->Block(
                    Name => 'DetailsActionsRow',
                    Data => {
                        %Param,
                        %ActionData,
                    },
                );
            }
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceWebservice',
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _OutputGIConfig {
    my ( $Self, %Param ) = @_;

    # parse the transport config as JSON strucutre
    my $TransportConfig = $Self->{JSONObject}->Encode(
        Data => $Param{GITransports},
    );

    # parse the operation config as JSON strucutre
    my $OpertaionConfig = $Self->{JSONObject}->Encode(
        Data => $Param{GIOperations},
    );

    # parse the operation config as JSON strucutre
    my $InvokerConfig = $Self->{JSONObject}->Encode(
        Data => $Param{GIInvokers},
    );

    $Self->{LayoutObject}->Block(
        Name => 'ConfigSet',
        Data => {
            TransportConfig => $TransportConfig,
            OperationConfig => $OpertaionConfig,
            InvokerConfig   => $InvokerConfig,
            }
    );
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw( Name Description RemoteSystem Protocol DebugThreshold TestMode ValidID )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    $GetParam->{ProviderTransport} =
        $Self->{ParamObject}->GetParam( Param => 'ProviderTransportList' ) || '';

    $GetParam->{RequesterTransport} =
        $Self->{ParamObject}->GetParam( Param => 'RequesterTransportList' ) || '';

    return $GetParam;
}
1;
