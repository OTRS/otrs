# --
# Kernel/Modules/AdminGenericInterfaceWebservice.pm - provides a webservice view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceWebservice.pm,v 1.4 2011-05-13 20:49:32 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebservice;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::Valid;
use Kernel::System::JSON;

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

        return $Self->_ShowChange(
            %Param,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
        );
    }

    # default: show start screen
    return $Self->_ShowOverview(
        %Param,
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

sub _ShowChange {
    my ( $Self, %Param ) = @_;

    my $WebserviceData = $Param{WebserviceData};

    my $DebuggerData = $WebserviceData->{Config}->{Debugger};

    my $ProviderData = $WebserviceData->{Config}->{Provider};

    my $RequesterData = $WebserviceData->{Config}->{Requester};

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
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

    my $DebugThresholdStrg = $Self->{LayoutObject}->BuildSelection(
        Data          => \%DebugThreshold,
        Name          => 'DebugThreshold',
        SelectedValue => $DebugThreshold{ $DebuggerData->{DebugThreshold} },
        PossibleNone  => 0,
        Translate     => 1,
    );

    my $DebugTestStrg = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name         => 'DebugTest',
        SelectedID   => $DebuggerData->{DebugTest},
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
            Name => 'DetailsControl',
            Data => {
                CommunicationType => $CommunicationType,
                Title             => $CommTypeConfig{$CommunicationType}->{Title},
                TransportsStrg    => $TransportsStrg,
                ActionType        => $CommTypeConfig{$CommunicationType}->{ActionType},
                ControllersStrg   => $ControllersStrg,
                ActionsTitle      => $CommTypeConfig{$CommunicationType}->{ActionsTitle},
                }
        );

        # output Opertions and Invokers tables
        for my $ActionName ( keys %{ $CommTypeConfig{$CommunicationType}->{ActionsConfig} } ) {

            # get control information
            my $ActionDails = $CommTypeConfig{$CommunicationType}->{ActionsConfig}->{$ActionName};

            my $Mapping = 'No';
            if ( $ActionDails->{MappingInbound} or $ActionDails->{MappingInbound} ) {
                $Mapping = 'Yes';
            }

            my %ActionData = (
                Name       => $ActionName,
                Controller => $ActionDails->{Type},
                Mapping    => $Mapping,
                Module     => $GIControllers{ $ActionDails->{Type} },
                ActionLink => $CommTypeConfig{$CommunicationType}->{ActionType} . "=" . $ActionName,
            );

            $Self->{LayoutObject}->Block(
                Name => 'DetailsControlRow',
                Data => {
                    %Param,
                    %ActionData,
                    }
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

1;
