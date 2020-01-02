# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericInterfaceWebservice;

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $WebserviceID = $ParamObject->GetParam( Param => 'WebserviceID' ) || '';

    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $YAMLObject       = $Kernel::OM->Get('Kernel::System::YAML');

    # ------------------------------------------------------------ #
    # sub-action Change: load web service and show edit screen
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

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
                    $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
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
                    $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
            );
        }

        # Get parameter from web browser.
        my $GetParam = $Self->_GetParams();

        # Set new configuration.
        $WebserviceData->{Name}                                 = $GetParam->{Name};
        $WebserviceData->{Config}->{Description}                = $GetParam->{Description};
        $WebserviceData->{Config}->{RemoteSystem}               = $GetParam->{RemoteSystem};
        $WebserviceData->{Config}->{Debugger}->{DebugThreshold} = $GetParam->{DebugThreshold};
        $WebserviceData->{Config}->{Debugger}->{TestMode}       = 0;
        $WebserviceData->{ValidID}                              = $GetParam->{ValidID};

        for my $CommunicationType (qw( Provider Requester )) {

            # Check if selected type is different from the one on the current configuration.
            if (
                $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Type} ne
                $GetParam->{ $CommunicationType . 'Transport' }
                )
            {

                # Delete current communication type transport.
                delete $WebserviceData->{Config}->{$CommunicationType}->{Transport};

                # Replace the current transport type with the new selected one
                #   the rest of the configuration will be empty
                #   the transport need to be configured independently.
                $WebserviceData->{Config}->{$CommunicationType}->{Transport}->{Type}
                    = $GetParam->{ $CommunicationType . 'Transport' };
            }
        }

        # Check required parameters.
        my %Error;
        if ( !$GetParam->{Name} ) {

            # Add server error error class.
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('This field is required');
        }

        # Check if name is duplicated.
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{ $GetParam->{Name} } &&
            $WebserviceList{ $GetParam->{Name} } ne $WebserviceID
            )
        {

            # Add server error error class.
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('There is another web service with the same name.');
        }

        # If there is an error return to edit screen.
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                WebserviceID   => $WebserviceID,
                WebserviceData => $WebserviceData,
                Action         => 'Change',
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

        # Show error if cant update.
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error updating the web service.'),
            );
        }

        # If the user would like to continue editing the invoker config, just redirect to the edit screen.
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
                . $WebserviceID
                . ';';
        }
        else {

            # Otherwise return to overview.
            $RedirectURL =
                'Action=AdminGenericInterfaceWebservice'
                . ';';
        }

        return $LayoutObject->Redirect( OP => $RedirectURL );
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

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        # Get web service configuration.
        my $WebserviceData;

        # Get parameter from web browser.
        my $GetParam = $Self->_GetParams();

        # Set new configuration.
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

        # Check required parameters.
        my %Error;
        if ( !$GetParam->{Name} ) {

            # Add server error error class.
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('This field is required');
        }

        # Check if name is duplicated.
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{ $GetParam->{Name} } &&
            $WebserviceList{ $GetParam->{Name} } ne $WebserviceID
            )
        {

            # Add server error error class.
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('There is another web service with the same name.');
        }

        # If there is an error return to edit screen.
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                WebserviceID   => $WebserviceID,
                WebserviceData => $WebserviceData,
                Action         => 'Add',
            );
        }

        # Otherwise save configuration and return to overview screen.
        my $ID = $WebserviceObject->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        # Show error if cant create.
        if ( !$ID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error creating the web service.'),
            );
        }

        # Set WebserviceID to the new created web service.
        $WebserviceID = $ID;

        # Define notification.
        my $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" created!',
            $WebserviceData->{Name},
        );

        # Return to edit to continue changing the configuration.
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

        # Check for WebserviceID.
        if ( !$WebserviceID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need WebserviceID!'),
            );
        }

        # Get web service configuration.
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID
        );

        # Set Framework Version information for import purposes.
        $WebserviceData->{Config}->{FrameworkVersion} = $Kernel::OM->Get('Kernel::Config')->Get('Version');

        # Check for valid web service configuration.
        if ( !IsHashRefWithData($WebserviceData) ) {
            return $LayoutObject->ErrorScreen(
                Message =>
                    $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
            );
        }

        # Dump configuration into a YAML structure.
        my $YAMLContent = $YAMLObject->Dump( Data => $WebserviceData->{Config} );

        # Return YAML to download.
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

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        # get web service configuration
        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        my $Success = $WebserviceObject->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => $Self->{UserID},
        );

        # Build JSON output.
        my $JSON = $LayoutObject->JSONEncode(
            Data => {
                Success           => $Success,
                DeletedWebservice => $WebserviceData->{Name},
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

    # -------------------------------------------------------------- #
    # sub-action Clone: clone web service and return value to dialog
    # -------------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Clone' ) {

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
                Message => $LayoutObject->{LanguageObject}
                    ->Translate( 'Could not get data for WebserviceID %s', $WebserviceID ),
            );
        }

        my $CloneName = $ParamObject->GetParam( Param => 'CloneName' ) || '';

        if ( !$CloneName ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need Name!'),
            );
        }

        # Set new configuration.
        $WebserviceData->{Name} = $CloneName;

        # Check if name is duplicated.
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if ( $WebserviceList{$CloneName} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There is another web service with the same name.'),
            );
        }

        # Otherwise save configuration and return to overview screen.
        my $Success = $WebserviceObject->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error creating the web service.'),
            );
        }

        # Define notification.
        my $Notify = $LayoutObject->{LanguageObject}->Translate(
            'Web service "%s" created!',
            $WebserviceData->{Name},
        );

        # Return to overview.
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

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $ImportedConfig;

        my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        # Get web service name.
        my $WebserviceName;
        my $ExampleWebServiceFilename = $ParamObject->GetParam( Param => 'ExampleWebService' ) || '';
        my $FileWithoutExtension;

        if ($ExampleWebServiceFilename) {
            $ExampleWebServiceFilename =~ s{/+|\.{2,}}{}smx;    # remove slashes and ..

            if ( !$ExampleWebServiceFilename ) {
                return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
                    Message => Translatable('Need ExampleWebService!'),
                );
            }

            # Extract file name.
            $ExampleWebServiceFilename =~ m{(.*?)\.yml$}smx;
            $FileWithoutExtension = $1;

            # Run _pre.pm if available.
            if ( -e "$Home/var/webservices/examples/" . $FileWithoutExtension . "_pre.pm" ) {

                my $BackendName = 'var::webservices::examples::' . $FileWithoutExtension . '_pre';

                my $Loaded = $MainObject->Require(
                    $BackendName,
                );

                if ( !$Loaded ) {
                    return $LayoutObject->ErrorScreen(
                        Message => $LayoutObject->{LanguageObject}->Translate( 'Could not load %s.', $BackendName ),
                    );

                }

                my $BackendPre = $Kernel::OM->Get(
                    $BackendName,
                );

                if ( $BackendPre->can('DependencyCheck') ) {
                    my %Result = $BackendPre->DependencyCheck();
                    if ( !$Result{Success} && $Result{ErrorMessage} ) {

                        return $Self->_ShowEdit(
                            DependencyErrorMessage => $Result{ErrorMessage},
                            %Param,
                            Action => 'Add',
                        );
                    }
                }

                my %Status = $BackendPre->Run();
                if ( !$Status{Success} ) {

                    # Show the error screen.
                    return $LayoutObject->ErrorScreen(
                        Message => $Status{Error},
                    );
                }
            }

            my $Content = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => "$Home/var/webservices/examples/$ExampleWebServiceFilename",
                Mode     => 'utf8',
            );

            if ( !$Content ) {
                return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
                    Message =>
                        $LayoutObject->{LanguageObject}->Translate( 'Could not read %s!', $ExampleWebServiceFilename ),
                );
            }

            $Content = ${ $Content || \'' };

            # Read configuration from a YAML structure.
            $ImportedConfig = $YAMLObject->Load( Data => $Content );
            $WebserviceName = $ExampleWebServiceFilename;
        }
        else {

            # Get the web service config file from the http request.
            my %ConfigFile = $ParamObject->GetUploadAll(
                Param => 'ConfigFile',
            );

            # Check for file.
            if ( !%ConfigFile ) {
                return $LayoutObject->ErrorScreen(
                    Message => Translatable('Need a file to import!'),
                );
            }

            # Read configuration from a YAML structure.
            $ImportedConfig = $YAMLObject->Load( Data => $ConfigFile{Content} );

            # Get web service name (optional), otherwise use filename of config file.
            $WebserviceName = $ParamObject->GetParam( Param => 'WebserviceName' ) || '';
            if ( !IsStringWithData($WebserviceName) ) {

                $WebserviceName = $ConfigFile{Filename};
            }
        }

        # Display any YAML error message as a normal otrs error message.
        if ( !IsHashRefWithData($ImportedConfig) ) {
            return $LayoutObject->ErrorScreen(
                Message =>
                    Translatable('The imported file has not valid YAML content! Please check OTRS log for details'),
            );
        }

        # Check if imported configuration has current framework version otherwise update it.
        if (
            !$ImportedConfig->{FrameworkVersion}
            || $ImportedConfig->{FrameworkVersion} ne $Kernel::OM->Get('Kernel::Config')->Get('Version')
            )
        {
            $ImportedConfig = $Self->_UpdateConfiguration( Configuration => $ImportedConfig );
        }

        # Remove framework information since is not needed anymore.
        delete $ImportedConfig->{FrameworkVersion};

        # Remove file extension.
        $WebserviceName =~ s{\.[^.]+$}{}g;

        # Check required parameters.
        my %Error;
        if ( !$WebserviceName ) {

            # Add server error error class.
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('This field is required');
        }

        my $WebserviceData;

        # Set WebserviceData.
        $WebserviceData->{Name}    = $WebserviceName;
        $WebserviceData->{Config}  = $ImportedConfig;
        $WebserviceData->{ValidID} = 1;

        # Check if name is duplicated.
        my %WebserviceList = %{ $WebserviceObject->WebserviceList() };

        %WebserviceList = reverse %WebserviceList;

        if (
            $WebserviceList{$WebserviceName} &&
            $WebserviceList{$WebserviceName} ne $WebserviceID
            )
        {

            # Add server error error class.
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = Translatable('There is another web service with the same name.');
        }

        # If there is an error return to edit screen.
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                WebserviceID   => $WebserviceID,
                WebserviceData => $WebserviceData,
                Action         => 'Add',
            );
        }

        # Otherwise save configuration and return to overview screen.
        my $Success = $WebserviceObject->WebserviceAdd(
            Name    => $WebserviceData->{Name},
            Config  => $WebserviceData->{Config},
            ValidID => $WebserviceData->{ValidID},
            UserID  => $Self->{UserID},
        );

        if (
            $FileWithoutExtension
            && -e "$Home/var/webservices/examples/" . $FileWithoutExtension . "_post.pm"
            )
        {
            my $BackendName = 'var::webservices::examples::' . $FileWithoutExtension . '_post';

            my $Loaded = $MainObject->Require(
                $BackendName,
            );

            if ($Loaded) {
                my $BackendPost = $Kernel::OM->Get(
                    $BackendName,
                );

                my %Status = $BackendPost->Run();
                if ( !$Status{Success} ) {

                    # Show the error screen.
                    return $LayoutObject->ErrorScreen(
                        Message => $Status{Error},
                    );
                }
            }
        }

        # Define notification.
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

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_DeleteAction(
            WebserviceID => $WebserviceID,
        );
    }

    # ------------------------------------------------------------ #
    # default: show start screen
    # ------------------------------------------------------------ #

    # Get Deleted web service if any.
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

    # Call all needed tt blocks.
    $LayoutObject->Block(
        Name => 'Main',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'OverviewHeader' );
    $LayoutObject->Block( Name => 'OverviewResult' );

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # Get web services list.
    my $WebserviceList = $WebserviceObject->WebserviceList(
        Valid => 0,
    );

    # Check if no web services are registered.
    if ( !IsHashRefWithData($WebserviceList) ) {
        $LayoutObject->Block( Name => 'NoDataFoundMsg' );
    }

    # Otherwise show all web services.
    else {
        WEBSERVICEID:
        for my $WebserviceID (
            sort { $WebserviceList->{$a} cmp $WebserviceList->{$b} }
            keys %{$WebserviceList}
            )
        {
            next WEBSERVICEID if !$WebserviceID;

            # Get web service data.
            my $Webservice = $WebserviceObject->WebserviceGet( ID => $WebserviceID );
            next WEBSERVICEID if !$Webservice;

            # Convert ValidID to text.
            my $ValidStrg = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
                ValidID => $Webservice->{ValidID},
            );

            if ( !$Webservice->{Config} || !IsHashRefWithData( $Webservice->{Config} ) ) {

                # Write an error message to the OTRS log.
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Configuration of WebserviceID $WebserviceID is invalid!",
                );

                # Notify the user of problems loading this web service.
                $Output .= $LayoutObject->Notify(
                    Priority => 'Error',
                );

                # Continue loading the list of web services.
                next WEBSERVICEID;
            }

            # Prepare data to output.
            my $Data = {
                ID                 => $WebserviceID,
                Name               => $Webservice->{Name},
                Description        => $Webservice->{Config}->{Description} || '-',
                RemoteSystem       => $Webservice->{Config}->{RemoteSystem} || '-',
                ProviderTransport  => $Webservice->{Config}->{Provider}->{Transport}->{Type} || '-',
                RequesterTransport => $Webservice->{Config}->{Requester}->{Transport}->{Type} || '-',
                Valid              => $ValidStrg,
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

    my $ErrorHandlingProvider         = $WebserviceData->{Config}->{Provider}->{ErrorHandling}         || {};
    my $ErrorHandlingPriorityProvider = $WebserviceData->{Config}->{Provider}->{ErrorHandlingPriority} || [];

    my $ErrorHandlingRequester         = $WebserviceData->{Config}->{Requester}->{ErrorHandling}         || {};
    my $ErrorHandlingPriorityRequester = $WebserviceData->{Config}->{Requester}->{ErrorHandlingPriority} || [];

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    if ( $Param{DependencyErrorMessage} ) {
        $Output .= $LayoutObject->Notify(
            Priority => 'Notice',
            Data     => $Param{DependencyErrorMessage},

        );
    }

    # Show notifications if any.
    if ( $Param{Notify} ) {
        $Output .= $LayoutObject->Notify(
            Info => $Param{Notify},
        );
    }

    $LayoutObject->Block(
        Name => 'Main',
        Data => \%Param,
    );

    if ( $Param{Action} eq 'Add' ) {

        my @ExampleWebServices = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/webservices/examples',
            Filter    => '*.yml',
            Silent    => 1,
        );

        my %ExampleWebServicesData;

        for my $ExampleWebServiceFilename (@ExampleWebServices) {
            my $Key = $ExampleWebServiceFilename;
            $Key =~ s{^.*/([^/]+)$}{$1}smx;
            my $Value = $Key;
            $Value =~ s{^(.+).yml}{$1}smx;
            $Value =~ s{_}{ }smxg;
            $ExampleWebServicesData{$Key} = $Value;
        }

        my %Frontend;

        if ( %ExampleWebServicesData && $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled() ) {
            $Frontend{ExampleWebServiceList} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
                Name         => 'ExampleWebService',
                Data         => \%ExampleWebServicesData,
                PossibleNone => 1,
                Translation  => 0,
                Class        => 'Modernize Validate_Required',
            );
        }

        # Enable Example web services.
        $LayoutObject->Block(
            Name => 'ExampleWebServices',
            Data => {
                %Frontend,
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

    # Define the debug Thresholds (this needs to be hard-coded).
    my %DebugThreshold = (
        debug  => Translatable('Debug'),
        info   => Translatable('Info'),
        notice => Translatable('Notice'),
        error  => Translatable('Error'),
    );

    # Create the DebugThreshold select.
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

    # Create the validity select.
    my $ValidtyStrg = $LayoutObject->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $WebserviceData->{ValidID} || 1,
        PossibleNone => 0,
        Translate    => 1,
        Class        => 'Modernize HideTrigger',
    );

    # Prevent HTML validation waring.
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

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Set transports data.
    my %GITransports;
    my $GITransportConfig = $ConfigObject->Get('GenericInterface::Transport::Module');
    TRANSPORT:
    for my $Transport ( sort keys %{$GITransportConfig} ) {
        next TRANSPORT if !$Transport;
        $GITransports{$Transport} = $GITransportConfig->{$Transport}->{ConfigDialog};
    }

    # Get operation data.
    my %GIOperations;
    my $GIOperationConfig = $ConfigObject->Get('GenericInterface::Operation::Module');
    OPERATION:
    for my $Operation ( sort keys %{$GIOperationConfig} ) {
        next OPERATION if !$Operation;
        $GIOperations{$Operation} = $GIOperationConfig->{$Operation}->{ConfigDialog};
    }

    # Get invoker data.
    my %GIInvokers;
    my $GIInvokerConfig = $ConfigObject->Get('GenericInterface::Invoker::Module');
    INVOKER:
    for my $Invoker ( sort keys %{$GIInvokerConfig} ) {
        next INVOKER if !$Invoker;
        $GIInvokers{$Invoker} = $GIInvokerConfig->{$Invoker}->{ConfigDialog};
    }

    # Get error handling modules data.
    my %GIErrorHandlingModules;
    my $GIErrorHandlingModuleConfig = $ConfigObject->Get('GenericInterface::ErrorHandling::Module');
    ERRORHANDLINGMODULE:
    for my $ErrorHandlingModules ( sort keys %{$GIErrorHandlingModuleConfig} ) {
        next ERRORHANDLINGMODULE if !$ErrorHandlingModules;
        $GIErrorHandlingModules{$ErrorHandlingModules}
            = $GIErrorHandlingModuleConfig->{$ErrorHandlingModules}->{ConfigDialog};
    }

    $Self->_OutputGIConfig(
        GITransports           => \%GITransports,
        GIOperations           => \%GIOperations,
        GIInvokers             => \%GIInvokers,
        GIErrorHandlingModules => \%GIErrorHandlingModules,
    );

    # Meta configuration for output blocks.
    my %CommTypeConfig = (
        Provider => {
            Title                 => Translatable('OTRS as provider'),
            SelectedTransport     => $ProviderData->{Transport}->{Type},
            ActionType            => 'Operation',
            ActionsTitle          => Translatable('Operations'),
            ActionsConfig         => $ProviderData->{Operation},
            ControllerData        => \%GIOperations,
            ErrorHandling         => $ErrorHandlingProvider,
            ErrorHandlingPriority => $ErrorHandlingPriorityProvider,
        },
        Requester => {
            Title                 => Translatable('OTRS as requester'),
            SelectedTransport     => $RequesterData->{Transport}->{Type},
            ActionType            => 'Invoker',
            ActionsTitle          => Translatable('Invokers'),
            ActionsConfig         => $RequesterData->{Invoker},
            ControllerData        => \%GIInvokers,
            ErrorHandling         => $ErrorHandlingRequester,
            ErrorHandlingPriority => $ErrorHandlingPriorityRequester,
        },

    );

    for my $CommunicationType (qw(Provider Requester)) {

        my @TransportList;

        for my $Transport ( sort keys %GITransports ) {
            push @TransportList, $Transport;
        }

        # Create the list of transports.
        my $TransportsStrg = $LayoutObject->BuildSelection(
            Data          => \@TransportList,
            Name          => $CommunicationType . 'TransportList',
            SelectedValue => $CommTypeConfig{$CommunicationType}->{SelectedTransport},
            PossibleNone  => 1,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize HideTrigger',
        );

        my $ErrorModuleConfig = $ConfigObject->Get('GenericInterface::ErrorHandling::Module');

        my @ErrorModules;

        ERRORMODULEKEY:
        for my $ErrorModuleKey ( sort keys %{$ErrorModuleConfig} ) {

            next ERRORMODULEKEY if !$ErrorModuleKey;
            next ERRORMODULEKEY if !IsHashRefWithData( $ErrorModuleConfig->{$ErrorModuleKey} );
            next ERRORMODULEKEY if !IsStringWithData( $ErrorModuleConfig->{$ErrorModuleKey}->{Name} );
            next ERRORMODULEKEY if !IsStringWithData( $ErrorModuleConfig->{$ErrorModuleKey}->{ConfigDialog} );

            # Check for active communication type filter.
            if (
                IsStringWithData( $ErrorModuleConfig->{$ErrorModuleKey}->{CommunicationTypeFilter} )
                && $ErrorModuleConfig->{$ErrorModuleKey}->{CommunicationTypeFilter} ne $CommunicationType
                )
            {
                next ERRORMODULEKEY;
            }

            push @ErrorModules, {
                Key   => $ErrorModuleKey,
                Value => $ErrorModuleConfig->{$ErrorModuleKey}->{Name},
            };
        }

        # Create the list of error handling modules.
        $Param{ErrorHandlingStrg} = $LayoutObject->BuildSelection(
            Data         => \@ErrorModules,
            Name         => $CommunicationType . 'ErrorHandling',
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Class        => 'Modernize ConfigureErrorHandling',
        );

        # Get the controllers config for Requesters or Providers.

        my %GIControllers = %{ $CommTypeConfig{$CommunicationType}->{ControllerData} };

        my @ControllerList;

        for my $Action ( sort keys %GIControllers ) {
            push @ControllerList, $Action;
        }

        # Create the list of controllers.
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

        # Check if selected transport can be configured and show the "configure button".
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

        # Flag to display a message if at least one controller was not found.
        my $NoControllerFound;

        if ( !IsHashRefWithData( $CommTypeConfig{$CommunicationType}->{ActionsConfig} ) ) {
            $LayoutObject->Block(
                Name => 'DetailsActionsNoDataFoundMsg',
                Data => {},
            );
        }
        else {

            # Output operation and invoker tables.
            for my $ActionName (
                sort keys %{ $CommTypeConfig{$CommunicationType}->{ActionsConfig} }
                )
            {

                # Get control information.
                my $ActionDetails = $CommTypeConfig{$CommunicationType}->{ActionsConfig}->{$ActionName};

                # Create output data.
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

        # Check error handling modules and priority for consistency,
        #   correct possible inconsistencies and save the web service.
        my $ErrorConfigUpdated = 0;

        my $ErrorHandlingModulesCheck = join '',
            sort @{ $CommTypeConfig{$CommunicationType}->{ErrorHandlingPriority} || [] };

        my $ErrorHandlingPriorityCheck = join '',
            sort keys %{ $CommTypeConfig{$CommunicationType}->{ErrorHandling} || {} };

        if ( $ErrorHandlingModulesCheck ne $ErrorHandlingPriorityCheck ) {

            my @CorrectedErrorHandlingModules
                = sort keys %{ $CommTypeConfig{$CommunicationType}->{ErrorHandling} || [] };

            $CommTypeConfig{$CommunicationType}->{ErrorHandlingPriority} = \@CorrectedErrorHandlingModules;

            $ErrorConfigUpdated = 1;
        }

        # Check for type and set RequestRetry as default.
        for my $CurrentErrorHandlingModule ( sort keys %{ $CommTypeConfig{$CommunicationType}->{ErrorHandling} || {} } )
        {

            if (
                !defined $CommTypeConfig{$CommunicationType}->{ErrorHandling}->{$CurrentErrorHandlingModule}->{Type}
                )
            {
                $CommTypeConfig{$CommunicationType}->{ErrorHandling}->{$CurrentErrorHandlingModule}->{Type}
                    = 'RequestRetry';

                $ErrorConfigUpdated = 1;
            }
        }

        # Update config if needed.
        if ($ErrorConfigUpdated) {

            $WebserviceData->{Config}->{$CommunicationType}->{ErrorHandling}
                = $CommTypeConfig{$CommunicationType}->{ErrorHandling};
            $WebserviceData->{Config}->{$CommunicationType}->{ErrorHandlingPriority}
                = $CommTypeConfig{$CommunicationType}->{ErrorHandlingPriority};

            $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
                %{$WebserviceData},
                UserID => $Self->{UserID},
            );
        }

        # No error handling modules defined.
        if ( !IsHashRefWithData( $CommTypeConfig{$CommunicationType}->{ErrorHandling} ) ) {
            $LayoutObject->Block(
                Name => 'ErrorHandlingRowNoDataFoundMsg',
            );
        }

        # List available error handling modules.
        else {

            ERRORHANDLINGMODULE:
            for my $ErrorHandlingModule ( @{ $CommTypeConfig{$CommunicationType}->{ErrorHandlingPriority} || [] } ) {

                next ERRORHANDLINGMODULE if !$ErrorHandlingModule;
                next ERRORHANDLINGMODULE
                    if !IsHashRefWithData(
                    $CommTypeConfig{$CommunicationType}->{ErrorHandling}->{$ErrorHandlingModule}
                    );

                next ERRORHANDLINGMODULE
                    if !$CommTypeConfig{$CommunicationType}->{ErrorHandling}->{$ErrorHandlingModule}->{Type};

                my $ErrorModuleAction = $ErrorModuleConfig->{
                    $CommTypeConfig{$CommunicationType}->{ErrorHandling}
                        ->{$ErrorHandlingModule}->{Type}
                }->{ConfigDialog};

                next ERRORHANDLINGMODULE if !$ErrorModuleAction;

                $LayoutObject->Block(
                    Name => 'ErrorHandlingRow',
                    Data => {
                        ErrorHandling => $ErrorHandlingModule,
                        Description =>
                            $CommTypeConfig{$CommunicationType}->{ErrorHandling}->{$ErrorHandlingModule}->{Description},
                        ErrorHandlingType =>
                            $CommTypeConfig{$CommunicationType}->{ErrorHandling}->{$ErrorHandlingModule}->{Type},
                        Dialog            => $ErrorModuleAction,
                        CommunicationType => $CommunicationType,
                        WebserviceID      => $Param{WebserviceID},

                    }
                );
            }
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

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'Webservice',
        Value => {
            Transport     => $Param{GITransports},
            Operation     => $Param{GIOperations},
            Invoker       => $Param{GIInvokers},
            ErrorHandling => $Param{GIErrorHandlingModules},
        },
    );

    return 1;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web browser.
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

    # This function needs to be extended for further otrs versions
    #   it could be that newer otrs versions has different configuration options
    #   migration from previous version should be automatic and needs to be done here
    return $Configuration;
}

sub _DeleteAction {
    my ( $Self, %Param ) = @_;

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    # Get web service configuration.
    my $WebserviceData = $WebserviceObject->WebserviceGet(
        ID => $Param{WebserviceID},
    );

    # Get needed params.
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ActionType  = $ParamObject->GetParam( Param => 'ActionType' );
    my $ActionName  = $ParamObject->GetParam( Param => 'ActionName' );

    # Set the communication type to Provider or Requester.
    my $CommunicationType = $ActionType eq 'Operation' ? 'Provider' : 'Requester';

    return if !$WebserviceData->{Config}->{$CommunicationType}->{$ActionType};

    # Get the configuration config for the communication type (all operations or all invokers).
    my %ActionTypeConfig = %{ $WebserviceData->{Config}->{$CommunicationType}->{$ActionType} };

    my $Success;

    # Delete communication type.
    if ( $ActionTypeConfig{$ActionName} ) {
        delete $ActionTypeConfig{$ActionName};

        # Update web service configuration.
        my %Config = %{ $WebserviceData->{Config} };
        $Config{$CommunicationType}->{$ActionType} = \%ActionTypeConfig;

        # Update web service.
        $Success = $WebserviceObject->WebserviceUpdate(
            %{$WebserviceData},
            Config => \%Config,
            UserID => $Self->{UserID},
        );
    }
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build JSON output.
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success,
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
