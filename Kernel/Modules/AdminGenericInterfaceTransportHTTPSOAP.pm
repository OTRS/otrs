# --
# Kernel/Modules/AdminGenericInterfaceTransportHTTPSOAP.pm - provides a TransportHTTPSOAP view for admins
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericInterfaceTransportHTTPSOAP.pm,v 1.5 2011-06-25 00:25:35 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceTransportHTTPSOAP;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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
            return $Self->{LayoutObject}
                ->ErrorScreen( Message => "Need WebserviceID!", );
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

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $Self->{LayoutObject}
                ->ErrorScreen( Message => "Need WebserviceID!", );
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
        my $GetParam = $Self->_GetParams;

        # check required parameters
        my %Error;
        for my $ParamName (
            qw( NameSpace Encoding )
            )
        {
            if ( !$GetParam->{$ParamName} ) {

                # add server error error class
                $Error{ $ParamName . 'ServerError' } = 'ServerError';
                $Error{ $ParamName . 'ServerErrorMessage' } =
                    'This field is required';
            }
        }

        # check if endpoind is required
        if ( $CommunicationType ne 'Provider' && !$GetParam->{Endpoint} ) {

            # add server error error class
            $Error{EndpointServerError} = 'ServerError';
            $Error{EndpointServerErrorMessage} =
                'This field is required';
        }

        # set new confguration
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Type} = 'HTTP::SOAP';
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config}->{Endpoint}
            = $GetParam->{Endpoint};
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config}->{NameSpace}
            = $GetParam->{NameSpace};
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config}->{Encoding}
            = $GetParam->{Encoding};
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config}->{SOAPAction}
            = $GetParam->{SOAPAction};
        $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Config}->{MaxLength}
            = $GetParam->{MaxLength};

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
        my $RedirectURL
            = "Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Change;WebserviceID=$WebserviceID;CommunicationType=$CommunicationType;";

        # Save and finish button: go to Webservice.
        if ( $Self->{ParamObject}->GetParam( Param => 'ReturnToWebservice' ) ) {
            $RedirectURL
                = "Action=AdminGenericInterfaceWebservice;Subaction=Change;WebserviceID=$WebserviceID;";

        }

        return $Self->{LayoutObject}->Redirect(
            OP => $RedirectURL,
        );

    }

}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    #configuration
    $Param{Type}           = 'HTTP::SOAP';
    $Param{WebserviceName} = $Param{WebserviceData}->{Name};
    $Param{Endpoint}
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config}
        ->{Endpoint};
    $Param{NameSpace}
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config}
        ->{NameSpace};
    $Param{Encoding}
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config}
        ->{Encoding};
    $Param{SOAPAction}
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config}
        ->{SOAPAction};
    $Param{MaxLength}
        = $Param{WebserviceData}->{Config}->{ $Param{CommunicationType} }->{Transport}->{Config}
        ->{MaxLength};

    # check if endpoind is required
    if ( $Param{CommunicationType} ne 'Provider' ) {
        $Param{EndpointValidateRequired} = 'Validate_Required';
    }
    $Self->{LayoutObject}->Block(
        Name => 'TransportEndpoint' . $Param{CommunicationType},
    );

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
            Link => 'Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=' . $Param{Action}
                . ';CommunicationType=' . $Param{CommunicationType}
                . ';WebserviceID=' . $Param{WebserviceID},
            Nav => '',
        },
    );

    if ( $Param{NameSpace} ) {
        $Self->{LayoutObject}->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericInterfaceTransportHTTPSOAP',
        Data         => { %Param, },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw( Endpoint NameSpace Encoding SOAPAction MaxLength )
        )
    {
        $GetParam->{$ParamName} =
            $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }
    return $GetParam;
}
1;
