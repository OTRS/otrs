# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceMappingXSLT;
## nofilter(TidyAll::Plugin::OTRS::Perl::Require)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

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
        ? 'XSLT Mapping for Outgoing Data'
        : 'XSLT Mapping for Incoming Data';

    # get configured Actions
    my $ActionsConfig = $Kernel::OM->Get('Kernel::Config')->Get( 'GenericInterface::' . $ActionType . '::Module' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # make sure required libraries (XML::LibXML and XML::LibXSLT) are installed
    LIBREQUIRED:
    for my $LibRequired (qw(XML::LibXML XML::LibXSLT)) {
        my $LibFound = $Kernel::OM->Get('Kernel::System::Main')->Require(
            $LibRequired,

            #Silent => 1,
        );
        next LIBREQUIRED if $LibFound;

        return $LayoutObject->ErrorScreen(
            Message => "Could not find required library $LibRequired",
        );
    }

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
    if ( $Self->{Subaction} eq 'Change' ) {

        # recreate structure for edit
        my %Mapping;
        my $MappingConfig = $WebserviceData->{Config}->{$CommunicationType}->
            {$ActionType}->{$Action}->{$Direction}->{Config};

        $Mapping{Template} = $MappingConfig->{Template};

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
        $NewMapping{Template} = $GetParam->{Template};

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

        $Mapping{Template} = $MappingConfig->{Template};

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

    $Param{Template} = $MappingConfig->{Template};
    $Param{TemplateError} = $Error{Template} || '';

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

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
    $GetParam->{Template} = $ParamObject->GetParam( Param => 'Template' ) || '';

    # check validity
    my $LibXML  = XML::LibXML->new();
    my $LibXSLT = XML::LibXSLT->new();
    my ( $StyleDoc, $StyleSheet );
    eval {
        $StyleDoc = $LibXML->load_xml(
            string   => $GetParam->{Template},
            no_cdata => 1,
        );
    };
    if ( !$StyleDoc ) {
        $GetParam->{Error}->{Template} = 'ServerError';
        return $GetParam;
    }
    eval {
        $StyleSheet = $LibXSLT->parse_stylesheet($StyleDoc);
    };
    if ( !$StyleSheet ) {
        $GetParam->{Error}->{Template} = 'ServerError';
        return $GetParam;
    }

    return $GetParam;
}

1;
