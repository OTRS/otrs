# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebservice;

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

    # get needed objects
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $YAMLObject       = $Kernel::OM->Get('Kernel::System::YAML');

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        # check for valid web service configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
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
    # sub-action ChangeAction: write basic config and return to edit
    #                          screen to continue with the rest of
    #                          the configuration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        # check for valid web service configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $WebserviceData->{Name}                                 = $GetParam->{Name};
        $WebserviceData->{Config}->{Description}                = $GetParam->{Description};
        $WebserviceData->{Config}->{RemoteSystem}               = $GetParam->{RemoteSystem};
        $WebserviceData->{Config}->{Debugger}->{DebugThreshold} = $GetParam->{DebugThreshold};
        $WebserviceData->{Config}->{Debugger}->{TestMode}       = 0;
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
                # the transport need to be configured independently
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
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{ $GetParam->{Name} } &&
            $WebserviceList{ $GetParam->{Name} } ne $WebserviceID
            )
        {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'There is another web service with the same name.';
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
        my $Success = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # show error if cant update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error updating the web service",
            );
        }

        # define notification
        my $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" updated!',
            $WebserviceData->{Name},
        );

        # Save and finish button: go to web service.
        if ( $ParamObject->GetParam( Param => 'ReturnToWebservice' ) ) {
            my $RedirectURL = "Action=AdminGenericInterfaceWebservice;";
            return $LayoutObject->Redirect(
                OP => $RedirectURL,
            );
        }

        # return to edit to continue changing the configuration
        return $Self->_ShowEdit(
            %Param,
            Notify         => $Notify,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
            Action         => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # sub-action Add: show edit screen (empty)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' ) {

        return $Self->_ShowEdit(
            Action => 'Add',
        );
    }

    # ------------------------------------------------------------ #
    # sub-action AddAction: create a web service and return to edit
    #                       screen to continue with the rest of
    #                       the configuration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get web service configuration
        my $WebserviceData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $WebserviceData->{Name}                                 = $GetParam->{Name};
        $WebserviceData->{Config}->{Description}                = $GetParam->{Description};
        $WebserviceData->{Config}->{RemoteSystem}               = $GetParam->{RemoteSystem};
        $WebserviceData->{Config}->{Debugger}->{DebugThreshold} = $GetParam->{DebugThreshold};
        $WebserviceData->{Config}->{Debugger}->{TestMode}       = 0;
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
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{ $GetParam->{Name} } &&
            $WebserviceList{ $GetParam->{Name} } ne $WebserviceID
            )
        {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'There is another web service with the same name.';
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
        my $ID = $WebserviceObject->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # show error if cant create
        if ( !$ID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the web service",
            );
        }

        # set WebserviceID to the new created web service
        $WebserviceID = $ID;

        # define notification
        my $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" created!',
            $WebserviceData->{Name},
        );

        # return to edit to continue changing the configuration
        return $Self->_ShowEdit(
            %Param,
            Notify         => $Notify,
            WebserviceID   => $WebserviceID,
            WebserviceData => $WebserviceData,
            Action         => 'Change',
        );
    }

    # ------------------------------------------------------------ #
    # sub action Export: create a YAML file with the configuration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Export' ) {

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID
        );

        # set Framework Version information for import purposes
        $WebserviceData->{Config}->{FrameworkVersion} = $Kernel::OM->Get('Kernel::Config')->Get('Version');

        # check for valid web service configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # dump configuration into a YAML structure
        my $YAMLContent = $YAMLObject->Dump( Data => $WebserviceData->{Config} );

        # return YAML to download
        my $YAMLFile = $WebserviceData->{Name};
        return $LayoutObject->Attachment(
            Filename    => $YAMLFile . '.yml',
            ContentType => "text/plain; charset=" . $LayoutObject->{UserCharset},
            Content     => $YAMLContent,
        );
    }

    # -------------------------------------------------------------- #
    # sub-action Delete: delete web service and return value to dialog
    # -------------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        my $Success = $WebserviceObject->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => $Self->{UserID},
        );

        # build JSON output
        my $JSON = $LayoutObject->JSONEncode(
            Data => {
                Success           => $Success,
                DeletedWebservice => $WebserviceData->{Name},
            },
        );

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # -------------------------------------------------------------- #
    # sub-action Clone: clone web service and return value to dialog
    # -------------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Clone' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check for WebserviceID
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need WebserviceID!",
            );
        }

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        # check for valid web service configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        my $CloneName = $ParamObject->GetParam( Param => 'CloneName' ) || '';

        if ( !$CloneName ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need Name!",
            );
        }

        # set new configuration
        $WebserviceData->{Name} = $CloneName;

        # check if name is duplicated
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if ( $WebserviceList{$CloneName} ) {
            return $LayoutObject->ErrorScreen(
                Message => "There is another web service with the same name.",
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $WebserviceObject->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the web service.",
            );
        }

        # define notification
        my $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" created!',
            $WebserviceData->{Name},
        );

        # return to overview
        return $Self->_ShowOverview(
            %Param,
            Notify => $Notify,
            Action => 'Overview',
        );
    }

    # ------------------------------------------------------------ #
    # sub-action Import: parse the file and return to overview
    #                    if name errors return to add screen
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Import' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get the web service config file from the http request
        my %ConfigFile = $ParamObject->GetUploadAll(
            Param => 'ConfigFile',
        );

        # check for file
        if ( !%ConfigFile ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need a file to import!",
            );
        }

        my $ImportedConfig;

        # read configuration from a YAML structure
        $ImportedConfig = $YAMLObject->Load( Data => $ConfigFile{Content} );

        # display any YAML error message as a normal otrs error message
        if ( !IsHashRefWithData($ImportedConfig) ) {
            return $LayoutObject->ErrorScreen(
                Message => 'The imported file has not valid YAML content!'
                    . ' Please check OTRS log for details',
            );
        }

        # check if imported configuration has current framework version otherwise update it
        if (
            !$ImportedConfig->{FrameworkVersion}
            || $ImportedConfig->{FrameworkVersion} ne $Kernel::OM->Get('Kernel::Config')->Get('Version')
            )
        {
            $ImportedConfig = $Self->_UpdateConfiguration( Configuration => $ImportedConfig );
        }

        # remove framework information since is not needed anymore
        delete $ImportedConfig->{FrameworkVersion};

        # get web service name
        my $WebserviceName = $ConfigFile{Filename};

        # remove file extension
        $WebserviceName =~ s{\.[^.]+$}{}g;

        # check required parameters
        my %Error;
        if ( !$WebserviceName ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        my $WebserviceData;

        # set WebserviceData
        $WebserviceData->{Name}    = $WebserviceName;
        $WebserviceData->{Config}  = $ImportedConfig;
        $WebserviceData->{ValidID} = 1;

        # check if name is duplicated
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{$WebserviceName} &&
            $WebserviceList{$WebserviceName} ne $WebserviceID
            )
        {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'There is another web service with the same name.';
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
        my $Success = $WebserviceObject->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # define notification
        my $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" created!',
            $WebserviceData->{Name},
        );

        return $Self->_ShowOverview(
            %Param,
            Notify => $Notify,
            Action => 'Overview',
        );
    }

    # ------------------------------------------------------------ #
    # sub-action DeleteAction: delete an operation or invoker
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            WebserviceID => $WebserviceID,
        );
    }

    # ------------------------------------------------------------ #
    # default: show start screen
    # ------------------------------------------------------------ #

    # get Deleted web service if any
    my $DeletedWebservice = $ParamObject->GetParam( Param => 'DeletedWebservice' ) || '';

    my $Notify;

    if ($DeletedWebservice) {

        # define notification
        $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" deleted!',
            $DeletedWebservice,
        );

    }

    return $Self->_ShowOverview(
        %Param,
        Notify => $Notify,
        Action => 'Overview',
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # show notifications if any
    if ( $Param{Notify} ) {
        $Output .= $LayoutObject->Notify(
            Info => $Param{Notify},
        );
    }

    # call all needed tt blocks
    $LayoutObject->Block(
        Name => 'Main',
        Data => \%Param,
    );
    $LayoutObject->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Web Services',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'OverviewHeader' );
    $LayoutObject->Block( Name => 'OverviewResult' );

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # get web services list
    my $WebserviceList = $WebserviceObject->WebserviceList(
        Valid => 0,
    );

    # check if no web services are registered
    if ( !IsHashRefWithData($WebserviceList) ) {
        $LayoutObject->Block( Name => 'NoDataFoundMsg' );
    }

    #otherwise show all web services
    else {
        WEBSERVICEID:
        for my $WebserviceID (
            sort { $WebserviceList->{$a} cmp $WebserviceList->{$b} }
            keys %{$WebserviceList}
            )
        {
            next WEBSERVICEID if !$WebserviceID;

            # get web service data
            my $Webservice = $WebserviceObject->WebserviceGet( ID => $WebserviceID );
            next WEBSERVICEID if !$Webservice;

            # convert ValidID to text
            my $ValidStrg = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
                ValidID => $Webservice->{ValidID},
            );

            if ( !$Webservice->{Config} || !IsHashRefWithData( $Webservice->{Config} ) ) {

                # write an error message to the OTRS log
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Configuration of WebserviceID $WebserviceID is invalid!",
                );

                # notify the user of problems loading this web service
                $Output .= $LayoutObject->Notify(
                    Priority => 'Error',
                );

                # continue loading the list of web services
                next WEBSERVICEID;
            }

            # prepare data to output
            my $Data = {
                ID           => $WebserviceID,
                Name         => $Webservice->{Name},
                Description  => $Webservice->{Config}->{Description} || '-',
                RemoteSystem => $Webservice->{Config}->{RemoteSystem} || '-',
                ProviderTransport =>
                    $Webservice->{Config}->{Provider}->{Transport}->{Type} || '-',
                RequesterTransport =>
                    $Webservice->{Config}->{Requester}->{Transport}->{Type} || '-',
                Valid => $ValidStrg,
            };

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => $Data,
            );
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceWebservice',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $WebserviceData = $Param{WebserviceData};

    my $DebuggerData = $WebserviceData->{Config}->{Debugger} || {};

    my $ProviderData = $WebserviceData->{Config}->{Provider} || {};

    my $RequesterData = $WebserviceData->{Config}->{Requester} || {};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # show notifications if any
    if ( $Param{Notify} ) {
        $Output .= $LayoutObject->Notify(
            Info => $Param{Notify},
        );
    }

    # call all needed tt blocks
    $LayoutObject->Block(
        Name => 'Main',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Web Services',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    if ( $Param{Action} eq 'Change' && $WebserviceData->{Name} ) {
        $LayoutObject->Block(
            Name => 'WebservicePathElementNoLink',
            Data => {
                Name => $WebserviceData->{Name},
                Link => 'Action=AdminGenericInterfaceWebservice;Subaction=' . $Param{Action}
                    . ';WebserviceID=' . $Param{WebserviceID},
                Nav => '',
            },
        );
    }
    elsif ( $Param{Action} eq 'Add' ) {
        $LayoutObject->Block(
            Name => 'WebservicePathElementNoLink',
            Data => {
                Name => 'New Web service',
                Link => 'Action=AdminGenericInterfaceWebservice;Subaction=' . $Param{Action},
                Nav  => '',
            },
        );
    }

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'ActionClone',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'ActionExport',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'ActionImport',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'ActionHistory',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'ActionDelete',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'ActionDebugger',
            Data => \%Param,
        );
    }
    elsif ( $Param{Action} eq 'Add' ) {
        $LayoutObject->Block(
            Name => 'ActionImport',
            Data => \%Param,
        );
    }
    $LayoutObject->Block( Name => 'Hint' );

    my %GeneralData = (
        Name         => $WebserviceData->{Name},
        Description  => $WebserviceData->{Config}->{Description},
        RemoteSystem => $WebserviceData->{Config}->{RemoteSystem},
    );

    # define the debug Thresholds (this needs to be hard-coded)
    my %DebugThreshold = (
        debug  => 'Debug',
        info   => 'Info',
        notice => 'Notice',
        error  => 'Error',
    );

    # create the DebugThreshold select
    my $DebugThresholdStrg = $LayoutObject->BuildSelection(
        Data           => \%DebugThreshold,
        Name           => 'DebugThreshold',
        SelectedID     => $DebuggerData->{DebugThreshold} || '',
        PossibleNone   => 0,
        Translate      => 1,
        Class          => 'Modernize HideTrigger',
        Sort           => 'IndividualKey',
        SortIndividual => [ 'debug', 'info', 'notice', 'error' ],

    );

    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # create the validity select
    my $ValidtyStrg = $LayoutObject->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $WebserviceData->{ValidID} || 1,
        PossibleNone => 0,
        Translate    => 1,
        Class        => 'Modernize HideTrigger',
    );

    # prevent HTML validation waring
    if ( !$Param{NameServerErrorMessage} ) {
        $Param{NameServerErrorMessage} = '-';
    }

    $LayoutObject->Block(
        Name => 'Details',
        Data => {
            %Param,
            %GeneralData,
            DebugThresholdStrg => $DebugThresholdStrg,
            ValidtyStrg        => $ValidtyStrg,
        },
    );

    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # set transports data
    my %GITransports;
    my $GITransportConfig = $ConfigObject->Get('GenericInterface::Transport::Module');
    TRANSPORT:
    for my $Transport ( sort keys %{$GITransportConfig} ) {
        next TRANSPORT if !$Transport;
        $GITransports{$Transport} = $GITransportConfig->{$Transport}->{ConfigDialog};
    }

    # get operations data
    my %GIOperations;
    my $GIOperationConfig = $ConfigObject->Get('GenericInterface::Operation::Module');
    OPERATION:
    for my $Operation ( sort keys %{$GIOperationConfig} ) {
        next OPERATION if !$Operation;
        $GIOperations{$Operation} = $GIOperationConfig->{$Operation}->{ConfigDialog};
    }

    # get operations data
    my %GIInvokers;
    my $GIInvokerConfig = $ConfigObject->Get('GenericInterface::Invoker::Module');
    INVOKER:
    for my $Invoker ( sort keys %{$GIInvokerConfig} ) {
        next INVOKER if !$Invoker;
        $GIInvokers{$Invoker} = $GIInvokerConfig->{$Invoker}->{ConfigDialog};
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

        for my $Transport ( sort keys %GITransports ) {
            push @TransportList, $Transport;
        }

        # create the list of transports
        my $TransportsStrg = $LayoutObject->BuildSelection(
            Data          => \@TransportList,
            Name          => $CommunicationType . 'TransportList',
            SelectedValue => $CommTypeConfig{$CommunicationType}->{SelectedTransport},
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize HideTrigger',
        );

        # get the controllers config for Requesters or Providers
        my %GIControllers = %{ $CommTypeConfig{$CommunicationType}->{ControllerData} };

        my @ControllerList;

        for my $Action ( sort keys %GIControllers ) {
            push @ControllerList, $Action;
        }

        # create the list of controllers
        my $ControllersStrg = $LayoutObject->BuildSelection(
            Data         => \@ControllerList,
            Name         => $CommTypeConfig{$CommunicationType}->{ActionType} . 'List',
            Sort         => 'AlphanumericValue',
            PossibleNone => 1,
            Class        => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'DetailsCommunicationType',
            Data => {
                %Param,
                CommunicationType => $CommunicationType,
                Title             => $CommTypeConfig{$CommunicationType}->{Title},
                TransportsStrg    => $TransportsStrg,
                ActionType        => $CommTypeConfig{$CommunicationType}->{ActionType},
                ControllersStrg   => $ControllersStrg,
                ActionsTitle      => $CommTypeConfig{$CommunicationType}->{ActionsTitle},
            },
        );

        $LayoutObject->Block(
            Name => 'DetailsCommunicationTypeExplanation' . $CommunicationType,
        );

        # check if selected transport can be configured and show the "configure button"
        if (
            $CommTypeConfig{$CommunicationType}->{SelectedTransport} &&
            $GITransports{ $CommTypeConfig{$CommunicationType}->{SelectedTransport} }
            )
        {

            $LayoutObject->Block(
                Name => 'DetailsTransportPropertiesButton',
                Data => {
                    CommunicationType => $CommunicationType,
                },
            );
        }

        $LayoutObject->Block(
            Name => 'DetailsCommunicationTypeActionsExplanation' . $CommunicationType,
        );

        # flag to display a message if at least one controller was not found
        my $NoControllerFound;

        if ( !IsHashRefWithData( $CommTypeConfig{$CommunicationType}->{ActionsConfig} ) ) {
            $LayoutObject->Block(
                Name => 'DetailsActionsNoDataFoundMsg',
                Data => {},
            );
        }
        else {

            # output operation and invoker tables
            for my $ActionName (
                sort keys %{ $CommTypeConfig{$CommunicationType}->{ActionsConfig} }
                )
            {

                # get control information
                my $ActionDetails = $CommTypeConfig{$CommunicationType}->{ActionsConfig}->{$ActionName};

                # create output data
                my %ActionData = (
                    Name            => $ActionName,
                    Description     => $ActionDetails->{Description} || '-',
                    Controller      => $ActionDetails->{Type},
                    MappingInbound  => $ActionDetails->{MappingInbound}->{Type} || '-',
                    MappingOutbound => $ActionDetails->{MappingOutbound}->{Type} || '-',
                    Module          => $GIControllers{ $ActionDetails->{Type} },
                    ActionType      => $CommTypeConfig{$CommunicationType}->{ActionType},
                );

                my $ControllerClass = '';
                if ( !$GIControllers{ $ActionData{Controller} } ) {
                    $NoControllerFound = 1;
                    $ControllerClass   = 'Error';
                }

                $LayoutObject->Block(
                    Name => 'DetailsActionsRow',
                    Data => {
                        %Param,
                        %ActionData,
                        ControllerClass => $ControllerClass,
                    },
                );

                if ( !$GIControllers{ $ActionData{Controller} } ) {
                    $LayoutObject->Block(
                        Name => 'DetailsActionsRowDelete',
                        Data => {
                            %Param,
                            %ActionData,
                        },
                    );
                }
                else {
                    $LayoutObject->Block(
                        Name => 'DetailsActionsRowLink',
                        Data => {
                            %Param,
                            %ActionData,
                        },
                    );
                }
            }
        }

        if ($NoControllerFound) {
            $LayoutObject->Block(
                Name => 'DetailsActionsNoControllerFoundMsg',
                Data => {
                    %Param,
                    ActionType => lc $CommTypeConfig{$CommunicationType}->{ActionType},
                },
            );
        }

    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericInterfaceWebservice',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _OutputGIConfig {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # parse the transport config as JSON structure
    my $TransportConfig = $LayoutObject->JSONEncode(
        Data => $Param{GITransports},
    );

    # parse the operation config as JSON structure
    my $OpertaionConfig = $LayoutObject->JSONEncode(
        Data => $Param{GIOperations},
    );

    # parse the operation config as JSON structure
    my $InvokerConfig = $LayoutObject->JSONEncode(
        Data => $Param{GIInvokers},
    );

    $LayoutObject->Block(
        Name => 'ConfigSet',
        Data => {
            TransportConfig => $TransportConfig,
            OperationConfig => $OpertaionConfig,
            InvokerConfig   => $InvokerConfig,
        },
    );

    return 1;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
    for my $ParamName (
        qw( Name Description RemoteSystem DebugThreshold ValidID )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }

    $GetParam->{ProviderTransport} =
        $ParamObject->GetParam( Param => 'ProviderTransportList' ) || '';

    $GetParam->{RequesterTransport} =
        $ParamObject->GetParam( Param => 'RequesterTransportList' ) || '';

    return $GetParam;
}

sub _UpdateConfiguration {
    my ( $Self, %Param ) = @_;

    my $Configuration = $Param{Configuration};

    # this function needs to be extended for further otrs versions
    # it could be that newer otrs versions has different configuration options
    # migration from previous version should be automatic and needs to be done here
    return $Configuration;
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # get web service configuration
    my $WebserviceData = $WebserviceObject->WebserviceGet(
        ID => $Param{WebserviceID},
    );

    # get needed params
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ActionType  = $ParamObject->GetParam( Param => 'ActionType' );
    my $ActionName  = $ParamObject->GetParam( Param => 'ActionName' );

    # set the communication type to Provider or Requester
    my $CommunicationType = $ActionType eq 'Operation' ? 'Provider' : 'Requester';

    return if !$WebserviceData->{Config}->{$CommunicationType}->{$ActionType};

    # get the configuration config for the communication type (all operations or all invokers)
    my %ActionTypeConfig = %{ $WebserviceData->{Config}->{$CommunicationType}->{$ActionType} };

    my $Success;

    # delete communication type
    if ( $ActionTypeConfig{$ActionName} ) {
        delete $ActionTypeConfig{$ActionName};

        # update web service configuration
        my %Config = %{ $WebserviceData->{Config} };
        $Config{$CommunicationType}->{$ActionType} = \%ActionTypeConfig;

        # update web service
        $Success = $WebserviceObject->WebserviceUpdate(
            %{$WebserviceData},
            Config => \%Config,
            UserID => $Self->{UserID},
        );
    }
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success,
        },
    );

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
