# --
# Kernel/Modules/AdminGenericInterfaceWebservice.pm - provides a webservice view for admins
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebservice;

use strict;
use warnings;

use vars qw($VERSION);

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::Valid;
use Kernel::System::YAML;

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
    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
    $Self->{YAMLObject}       = Kernel::System::YAML->new( %{$Self} );

    # get configurations
    # get configured transports
    $Self->{GITransportConfig} = $Self->{ConfigObject}->Get('GenericInterface::Transport::Module');

    # get configured operations
    $Self->{GIOperationConfig} = $Self->{ConfigObject}->Get('GenericInterface::Operation::Module');

    # get configured invokers
    $Self->{GIInvokerConfig} = $Self->{ConfigObject}->Get('GenericInterface::Invoker::Module');

    #  get Framework version
    $Self->{FrameworkVersion} = $Self->{ConfigObject}->Get('Version');

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
    # subaction ChangeAction: write basic config and return to edit
    #                         screen to continue with the rest of
    #                         the configuration
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
        my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new confguration
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

        # show error if cant update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the webservice",
            );
        }

        # define notification
        my $Notify = 'Webservice "%s" updated!", "' . $WebserviceData->{Name};

        # Save and finish button: go to Webservice.
        if ( $Self->{ParamObject}->GetParam( Param => 'ReturnToWebservice' ) ) {
            my $RedirectURL
                = "Action=AdminGenericInterfaceWebservice;";
            return $Self->{LayoutObject}->Redirect(
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
    # subaction Add: show edit screen (empty)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Add' ) {

        return $Self->_ShowEdit(
            Action => 'Add',
        );
    }

    # ------------------------------------------------------------ #
    # subaction AddAction: create a webservice and return to edit
    #                      screen to continue with the rest of
    #                      the configuration
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get webserice configuration
        my $WebserviceData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new confguration
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
        my $ID = $Self->{WebserviceObject}->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # show error if cant create
        if ( !$ID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the webservice",
            );
        }

        # set WebserviceID to the new created web service
        $WebserviceID = $ID;

        # define notification
        my $Notify = 'Webservice "%s" created!", "' . $WebserviceData->{Name};

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

        # set Framework Version information for import purposes
        $WebserviceData->{Config}->{FrameworkVersion} = $Self->{FrameworkVersion};

        # check for valid webservice configuration
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for WebserviceID $WebserviceID",
            );
        }

        # dump configuration into a YAML structure
        my $YAMLContent = $Self->{YAMLObject}->Dump( Data => $WebserviceData->{Config} );

        # return yaml to download
        my $YAMLFile = $WebserviceData->{Name};
        return $Self->{LayoutObject}->Attachment(
            Filename    => $YAMLFile . '.yml',
            ContentType => "text/plain; charset=" . $Self->{LayoutObject}->{UserCharset},
            Content     => $YAMLContent,
        );
    }

    # ------------------------------------------------------------ #
    # subaction Delete: delete webservice and return value to dialog
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get webserice configuration
        my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );

        my $Success = $Self->{WebserviceObject}->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => $Self->{UserID},
        );

        # build JSON output
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => {
                Success           => $Success,
                DeletedWebservice => $WebserviceData->{Name},
            },
        );

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # subaction Clone: clone webservice and return value to dialog
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Clone' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

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

        my $CloneName = $Self->{ParamObject}->GetParam( Param => 'CloneName' ) || '';

        if ( !$CloneName ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need Name!",
            );
        }

        # set new confguration
        $WebserviceData->{Name} = $CloneName;

        # check if name is duplicated
        my %WebserviceList = %{ $Self->{WebserviceObject}->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if ( $WebserviceList{$CloneName} ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There is another webservice with the same name.",
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $Self->{WebserviceObject}->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the webservice.",
            );
        }

        # define notification
        my $Notify = 'Webservice "%s" created!", "' . $WebserviceData->{Name};

        # return to overview
        return $Self->_ShowOverview(
            %Param,
            Notify => $Notify,
            Action => 'Overview',
        );
    }

    # ------------------------------------------------------------ #
    # subaction Import: parse the file and return to overview
    #                   if name errors return to add screen
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Import' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get the webservice config file from the http request
        my %ConfigFile = $Self->{ParamObject}->GetUploadAll(
            Param  => 'ConfigFile',
            Source => 'string',
        );

        # check for file
        if ( !%ConfigFile ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need a file to import!",
            );
        }

        my $ImportedConfig;

        # read configuration from a YAML structure
        $ImportedConfig = $Self->{YAMLObject}->Load( Data => $ConfigFile{Content} );

        # display any YAML error message as a normal otrs error message
        if ( !IsHashRefWithData($ImportedConfig) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'The imported file has not valid YAML content!'
                    . ' Please check OTRS log for details',
            );
        }

        # check if imported configuration has current framework version otherwise update it
        if ( $ImportedConfig->{FrameworkVersion} ne $Self->{FrameworkVersion} ) {
            $ImportedConfig = $Self->_UpdateConfiguration( Configuration => $ImportedConfig );
        }

        # remove framework information since is not needed anymore
        delete $ImportedConfig->{FrameworkVersion};

        # get webservice name
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
        my %WebserviceList = %{ $Self->{WebserviceObject}->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{$WebserviceName} &&
            $WebserviceList{$WebserviceName} ne $WebserviceID
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

        # define notification
        my $Notify = 'Webservice "%s" created!", "' . $WebserviceData->{Name};

        return $Self->_ShowOverview(
            %Param,
            Notify => $Notify,
            Action => 'Overview',
        );
    }

    # ------------------------------------------------------------ #
    # subaction DeleteAction: delete an operation or invoker
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DeleteAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            WebserviceID => $WebserviceID,
        );
    }

    # ------------------------------------------------------------ #
    # default: show start screen
    # ------------------------------------------------------------ #

    # get Deleted Webservice if any
    my $DeletedWebservice = $Self->{ParamObject}->GetParam( Param => 'DeletedWebservice' ) || '';

    my $Notify;

    if ($DeletedWebservice) {

        # define notification
        $Notify = 'Webservice "%s" deleted!", "' . $DeletedWebservice;

    }

    return $Self->_ShowOverview(
        %Param,
        Notify => $Notify,
        Action => 'Overview',
    );
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show notifications if any
    if ( $Param{Notify} ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Info => $Param{Notify},
        );
    }

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Web Services',
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
        for my $WebserviceID (
            sort { $WebserviceList->{$a} cmp $WebserviceList->{$b} }
            keys %{$WebserviceList}
            )
        {
            next WEBSERVICEID if !$WebserviceID;

            # get webservice data
            my $Webservice = $Self->{WebserviceObject}->WebserviceGet( ID => $WebserviceID );
            next WEBSERVICEID if !$Webservice;

            # convert ValidID to text
            my $ValidStrg = $Self->{ValidObject}->ValidLookup(
                ValidID => $Webservice->{ValidID},
            );

            if ( !$Webservice->{Config} || !IsHashRefWithData( $Webservice->{Config} ) ) {

                # write an error message to the OTRS log
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Configuration of WebserviceID $WebserviceID is invalid!",
                );

                # notify the user of problems loading this webservice
                $Output .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                );

                # continue loading the list of webservices
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

    # show notifications if any
    if ( $Param{Notify} ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Info => $Param{Notify},
        );
    }

    # call all needed dtl blocks
    $Self->{LayoutObject}->Block(
        Name => 'Main',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block(
        Name => 'WebservicePathElement',
        Data => {
            Name => 'Web Services',
            Link => 'Action=AdminGenericInterfaceWebservice',
            Nav  => '',
        },
    );
    if ( $Param{Action} eq 'Change' && $WebserviceData->{Name} ) {
        $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block(
            Name => 'WebservicePathElementNoLink',
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
    $Self->{LayoutObject}->Block( Name => 'Hint' );

    my %GeneralData = (
        Name         => $WebserviceData->{Name},
        Description  => $WebserviceData->{Config}->{Description},
        RemoteSystem => $WebserviceData->{Config}->{RemoteSystem},
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
        Data           => \%DebugThreshold,
        Name           => 'DebugThreshold',
        SelectedID     => $DebuggerData->{DebugThreshold} || '',
        PossibleNone   => 0,
        Translate      => 1,
        Class          => 'HideTrigger',
        Sort           => 'IndividualKey',
        SortIndividual => [ 'debug', 'info', 'notice', 'error' ],

    );

    my %ValidList = $Self->{ValidObject}->ValidList();

    # create the Validty select
    my $ValidtyStrg = $Self->{LayoutObject}->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $WebserviceData->{ValidID} || 1,
        PossibleNone => 0,
        Translate    => 1,
        Class        => 'HideTrigger',
    );

    # prevent html validation waring
    if ( !$Param{NameServerErrorMessage} ) {
        $Param{NameServerErrorMessage} = '-';
    }

    $Self->{LayoutObject}->Block(
        Name => 'Details',
        Data => {
            %Param,
            %GeneralData,
            DebugThresholdStrg => $DebugThresholdStrg,
            ValidtyStrg        => $ValidtyStrg,
            }
    );

    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block(
            Name => 'SaveAndFinishButton',
            Data => \%Param
        );
    }

    # set transports data
    my %GITransports;
    for my $Transport ( sort keys %{ $Self->{GITransportConfig} } ) {
        next if !$Transport;
        $GITransports{$Transport} = $Self->{GITransportConfig}->{$Transport}->{ConfigDialog};
    }

    # get operations data
    my %GIOperations;
    for my $Operation ( sort keys %{ $Self->{GIOperationConfig} } ) {
        next if !$Operation;
        $GIOperations{$Operation} = $Self->{GIOperationConfig}->{$Operation}->{ConfigDialog};
    }

    # get operations data
    my %GIInvokers;
    for my $Invoker ( sort keys %{ $Self->{GIInvokerConfig} } ) {
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

        for my $Transport ( sort keys %GITransports ) {
            push @TransportList, $Transport;
        }

        # create the list of transports
        my $TransportsStrg = $Self->{LayoutObject}->BuildSelection(
            Data          => \@TransportList,
            Name          => $CommunicationType . 'TransportList',
            SelectedValue => $CommTypeConfig{$CommunicationType}->{SelectedTransport},
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'HideTrigger',
        );

        # get the controllers config for Requesters or Providers
        my %GIControllers = %{ $CommTypeConfig{$CommunicationType}->{ControllerData} };

        my @ControllerList;

        for my $Action ( sort keys %GIControllers ) {
            push @ControllerList, $Action;
        }

        # create the list of controllers
        my $ControllersStrg = $Self->{LayoutObject}->BuildSelection(
            Data         => \@ControllerList,
            Name         => $CommTypeConfig{$CommunicationType}->{ActionType} . 'List',
            Sort         => 'AlphanumericValue',
            PossibleNone => 1,
            Class        => 'HideOnChange',
        );

        $Self->{LayoutObject}->Block(
            Name => 'DetailsCommunicationType',
            Data => {
                %Param,
                CommunicationType => $CommunicationType,
                Title             => $CommTypeConfig{$CommunicationType}->{Title},
                TransportsStrg    => $TransportsStrg,
                ActionType        => $CommTypeConfig{$CommunicationType}->{ActionType},
                ControllersStrg   => $ControllersStrg,
                ActionsTitle      => $CommTypeConfig{$CommunicationType}->{ActionsTitle},
                }
        );

        $Self->{LayoutObject}->Block(
            Name => 'DetailsCommunicationTypeExplanation' . $CommunicationType,
        );

        # check if selected trasnport can be configured and show the "configure button"
        if (
            $CommTypeConfig{$CommunicationType}->{SelectedTransport} &&
            $GITransports{ $CommTypeConfig{$CommunicationType}->{SelectedTransport} }
            )
        {

            $Self->{LayoutObject}->Block(
                Name => 'DetailsTransportPropertiesButton',
                Data => {
                    CommunicationType => $CommunicationType,
                    }
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'DetailsCommunicationTypeActionsExplanation' . $CommunicationType,
        );

        # flag to display a message if at leat one controller was not found
        my $NoControllerFound;

        if ( !IsHashRefWithData( $CommTypeConfig{$CommunicationType}->{ActionsConfig} ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'DetailsActionsNoDataFoundMsg',
                Data => {},
            );
        }
        else {

            # output Opertions and Invokers tables
            for my $ActionName (
                sort keys %{ $CommTypeConfig{$CommunicationType}->{ActionsConfig} }
                )
            {

                # get control information
                my $ActionDetails
                    = $CommTypeConfig{$CommunicationType}->{ActionsConfig}->{$ActionName};

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
                    $ControllerClass   = 'Error',
                }

                $Self->{LayoutObject}->Block(
                    Name => 'DetailsActionsRow',
                    Data => {
                        %Param,
                        %ActionData,
                        ControllerClass => $ControllerClass,
                    },
                );

                if ( !$GIControllers{ $ActionData{Controller} } ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DetailsActionsRowDelete',
                        Data => {
                            %Param,
                            %ActionData,
                        },
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
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
            $Self->{LayoutObject}->Block(
                Name => 'DetailsActionsNoControllerFoundMsg',
                Data => {
                    %Param,
                    ActionType => lc $CommTypeConfig{$CommunicationType}->{ActionType},
                },
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
    my $TransportConfig = $Self->{LayoutObject}->JSONEncode(
        Data => $Param{GITransports},
    );

    # parse the operation config as JSON strucutre
    my $OpertaionConfig = $Self->{LayoutObject}->JSONEncode(
        Data => $Param{GIOperations},
    );

    # parse the operation config as JSON strucutre
    my $InvokerConfig = $Self->{LayoutObject}->JSONEncode(
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
        qw( Name Description RemoteSystem DebugThreshold ValidID )
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

sub _UpdateConfiguration {
    my ( $Self, %Param ) = @_;

    my $Configuration = $Param{Configuration};

    # this function needs to be extended for further otrs versions
    # it could be that newwer otrs versions has different configuration options
    # migration from previos version sould be automatic and needs to be done here
    return $Configuration;
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    # get webserice configuration
    my $WebserviceData = $Self->{WebserviceObject}->WebserviceGet( ID => $Param{WebserviceID} );

    # get needed params
    my $ActionType = $Self->{ParamObject}->GetParam( Param => 'ActionType' );
    my $ActionName = $Self->{ParamObject}->GetParam( Param => 'ActionName' );

    # set the communication type to Provider or Requester
    my $CommunicationType = $ActionType eq 'Operation' ? 'Provider' : 'Requester';

    return if !$WebserviceData->{Config}->{$CommunicationType}->{$ActionType};

    # get the configuration config for the comunnication type (all operations or all invokers)
    my %ActionTypeConfig = %{ $WebserviceData->{Config}->{$CommunicationType}->{$ActionType} };

    my $Success;

    # delete communication type
    if ( $ActionTypeConfig{$ActionName} ) {
        delete $ActionTypeConfig{$ActionName};

        # update webservice configuration
        my %Config = %{ $WebserviceData->{Config} };
        $Config{$CommunicationType}->{$ActionType} = \%ActionTypeConfig;

        # update webservice
        $Success = $Self->{WebserviceObject}->WebserviceUpdate(
            %{$WebserviceData},
            Config => \%Config,
            UserID => $Self->{UserID},
        );
    }

    # build JSON output
    my $JSON = $Self->{LayoutObject}->JSONEncode(
        Data => {
            Success => $Success,
        },
    );

    # send JSON response
    return $Self->{LayoutObject}->Attachment(
        ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
