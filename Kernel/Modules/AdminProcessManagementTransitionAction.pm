# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementTransitionAction;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    my $TransitionActionID = $ParamObject->GetParam( Param => 'ID' )       || '';
    my $EntityID           = $ParamObject->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # get needed objects
    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $EntityObject           = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity');
    my $TransitionActionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');

    # ------------------------------------------------------------ #
    # TransitionActionNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TransitionActionNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # TransitionActionNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionActionNewAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get transition action data
        my $TransitionActionData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $TransitionActionData->{Name}             = $GetParam->{Name};
        $TransitionActionData->{Config}->{Module} = $GetParam->{Module};
        $TransitionActionData->{Config}->{Config} = $GetParam->{Config};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Module} ) {

            # add server error error class
            $Error{ModuleServerError}        = 'ServerError';
            $Error{ModuleServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Config} ) {
            return $LayoutObject->ErrorScreen(
                Message => "At least one valid config parameter is required.",
            );
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                TransitionActionData => $TransitionActionData,
                Action               => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $EntityObject->EntityIDGenerate(
            EntityType => 'TransitionAction',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error generating a new EntityID for this TransitionAction",
            );
        }

        # otherwise save configuration and return process screen
        my $TransitionActionID = $TransitionActionObject->TransitionActionAdd(
            Name     => $TransitionActionData->{Name},
            Module   => $TransitionActionData->{Module},
            EntityID => $EntityID,
            Config   => $TransitionActionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$TransitionActionID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the TransitionAction",
            );
        }

        # set entitty sync state
        my $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'TransitionAction',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error setting the entity sync status for TransitionAction "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $TransitionActionConfig = $Self->_GetTransitionActionConfig(
            EntityID => $EntityID,
        );

        my $ConfigJSON = $LayoutObject->JSONEncode( Data => $TransitionActionConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionActionID,
                EntityID  => $EntityID,
                Subaction => 'TransitionActionEdit'    # always use edit screen
            );

            my $RedirectAction    = $ParamObject->GetParam( Param => 'PopupRedirectAction' )    || '';
            my $RedirectSubaction = $ParamObject->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID        = $ParamObject->GetParam( Param => 'PopupRedirectID' )        || '';
            my $RedirectEntityID  = $ParamObject->GetParam( Param => 'PopupRedirectEntityID' )  || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => $RedirectAction,
                    Subaction => $RedirectSubaction,
                    ID        => $RedirectID,
                    EntityID  => $RedirectID,
                },
                ConfigJSON => $ConfigJSON,
            );
        }
        else {

            # remove last screen
            my $LastScreen = $Self->_PopSessionScreen();

            # check if needed to return to main screen or to be redirected to last screen
            if ( $LastScreen->{Action} eq 'AdminProcessManagement' ) {

                # close the popup
                return $Self->_PopupResponse(
                    ClosePopup => 1,
                    ConfigJSON => $ConfigJSON,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ConfigJSON,
                );
            }
        }
    }

    # ------------------------------------------------------------ #
    # TransitionActionEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionActionEdit' ) {

        # check for TransitionActionID
        if ( !$TransitionActionID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need TransitionActionID!",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get TransitionAction data
        my $TransitionActionData = $TransitionActionObject->TransitionActionGet(
            ID     => $TransitionActionID,
            UserID => $Self->{UserID},
        );

        # check for valid TransitionAction data
        if ( !IsHashRefWithData($TransitionActionData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for TransitionActionID $TransitionActionID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            TransitionActionID   => $TransitionActionID,
            TransitionActionData => $TransitionActionData,
            Action               => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # TransitionActionEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionActionEditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get transition action data
        my $TransitionActionData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $TransitionActionData->{Name}             = $GetParam->{Name};
        $TransitionActionData->{EntityID}         = $GetParam->{EntityID};
        $TransitionActionData->{Config}->{Module} = $GetParam->{Module};
        $TransitionActionData->{Config}->{Config} = $GetParam->{Config};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Module} ) {

            # add server error error class
            $Error{ModuleServerError}        = 'ServerError';
            $Error{ModuleServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Config} ) {
            return $LayoutObject->ErrorScreen(
                Message => "At least one valid config parameter is required.",
            );
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                TransitionActionData => $TransitionActionData,
                Action               => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $TransitionActionObject->TransitionActionUpdate(
            ID       => $TransitionActionID,
            EntityID => $TransitionActionData->{EntityID},
            Name     => $TransitionActionData->{Name},
            Module   => $TransitionActionData->{Module},
            Config   => $TransitionActionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error updating the TransitionAction",
            );
        }

        # set entitty sync state
        $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'TransitionAction',
            EntityID   => $TransitionActionData->{EntityID},
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error setting the entity sync status for TransitionAction "
                    . "entity:$TransitionActionData->{EntityID}",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $TransitionActionConfig = $Self->_GetTransitionActionConfig(
            EntityID => $TransitionActionData->{EntityID},
        );

        my $ConfigJSON = $LayoutObject->JSONEncode( Data => $TransitionActionConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionActionID,
                EntityID  => $TransitionActionData->{EntityID},
                Subaction => 'TransitionActionEdit'               # always use edit screen
            );

            my $RedirectAction    = $ParamObject->GetParam( Param => 'PopupRedirectAction' )    || '';
            my $RedirectSubaction = $ParamObject->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID        = $ParamObject->GetParam( Param => 'PopupRedirectID' )        || '';
            my $RedirectEntityID  = $ParamObject->GetParam( Param => 'PopupRedirectEntityID' )  || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => $RedirectAction,
                    Subaction => $RedirectSubaction,
                    ID        => $RedirectID,
                    EntityID  => $RedirectID,
                },
                ConfigJSON => $ConfigJSON,
            );
        }
        else {

            # remove last screen
            my $LastScreen = $Self->_PopSessionScreen();

            # check if needed to return to main screen or to be redirected to last screen
            if ( $LastScreen->{Action} eq 'AdminProcessManagement' ) {

                # close the popup
                return $Self->_PopupResponse(
                    ClosePopup => 1,
                    ConfigJSON => $ConfigJSON,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ConfigJSON,
                );
            }
        }
    }

    # ------------------------------------------------------------ #
    # Close popup
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ClosePopup' ) {

        # close the popup
        return $Self->_PopupResponse(
            ClosePopup => 1,
        );
    }

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $LayoutObject->ErrorScreen(
            Message => "This subaction is not valid",
        );
    }
}

sub _GetTransitionActionConfig {
    my ( $Self, %Param ) = @_;

    # Get new Transition Config as JSON
    my $ProcessDump = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );

    my %TransitionActionConfig;
    $TransitionActionConfig{TransitionAction} = ();
    $TransitionActionConfig{TransitionAction}->{ $Param{EntityID} }
        = $ProcessDump->{TransitionAction}->{ $Param{EntityID} };

    return \%TransitionActionConfig;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get TransitionAction information
    my $TransitionActionData = $Param{TransitionActionData} || {};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if last screen action is main screen
    if ( $Self->{ScreensPath}->[-1]->{Action} eq 'AdminProcessManagement' ) {

        # show close popup link
        $LayoutObject->Block(
            Name => 'ClosePopup',
            Data => {},
        );
    }
    else {

        # show go back link
        $LayoutObject->Block(
            Name => 'GoBack',
            Data => {
                Action          => $Self->{ScreensPath}->[-1]->{Action}          || '',
                Subaction       => $Self->{ScreensPath}->[-1]->{Subaction}       || '',
                ID              => $Self->{ScreensPath}->[-1]->{ID}              || '',
                EntityID        => $Self->{ScreensPath}->[-1]->{EntityID}        || '',
                StartActivityID => $Self->{ScreensPath}->[-1]->{StartActivityID} || '',
            },
        );
    }

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {
        $Param{Title} = "Edit Transition Action \"$TransitionActionData->{Name}\"";
    }
    else {
        $Param{Title} = 'Create New Transition Action';
    }

    my $Output = $LayoutObject->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        my $Index       = 1;
        my @ConfigItems = sort keys %{ $TransitionActionData->{Config}->{Config} };
        for my $Key (@ConfigItems) {

            $LayoutObject->Block(
                Name => 'ConfigItemEditRow',
                Data => {
                    Key   => $Key,
                    Value => $TransitionActionData->{Config}->{Config}->{$Key},
                    Index => $Index,
                },
            );
            $Index++;
        }

        # display other affected transitions by editing this activity (if applicable)
        my $AffectedProcesses = $Self->_CheckTransitionActionUsage(
            EntityID => $TransitionActionData->{EntityID},
        );

        if ( @{$AffectedProcesses} ) {

            $LayoutObject->Block(
                Name => 'EditWarning',
                Data => {
                    ProcessList => join( ', ', @{$AffectedProcesses} ),
                    }
            );
        }

    }
    else {
        $LayoutObject->Block(
            Name => 'ConfigItemInitRow',
        );
    }

    # lookup existing Transition Actions on disk
    my $Directory
        = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/System/ProcessManagement/TransitionAction';
    my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.pm',
    );
    my %TransitionAction;
    ITEM:
    for my $Item (@List) {

        # remove .pm
        $Item =~ s/^.*\/(.+?)\.pm$/$1/;
        next ITEM if $Item eq 'Base';
        $TransitionAction{ 'Kernel::System::ProcessManagement::TransitionAction::' . $Item } = $Item;
    }

    # build TransitionAction string
    $Param{ModuleStrg} = $LayoutObject->BuildSelection(
        Data         => \%TransitionAction,
        Name         => 'Module',
        PossibleNone => 1,
        SelectedID   => $TransitionActionData->{Config}->{Module},
        Class        => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ModuleInvalid'} || '' ),
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementTransitionAction",
        Data         => {
            %Param,
            %{$TransitionActionData},
            Name => $TransitionActionData->{Name},
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
    for my $ParamName (
        qw( Name Module EntityID )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }

    # get config params
    my @ParamNames = $ParamObject->GetParamNames();
    my ( @ConfigParamKeys, @ConfigParamValues );

    for my $ParamName (@ParamNames) {

        # get keys
        if ( $ParamName =~ m{ConfigKey\[(\d+)\]}xms ) {
            push @ConfigParamKeys, $1;
        }

        # get values
        if ( $ParamName =~ m{ConfigValue\[(\d+)\]}xms ) {
            push @ConfigParamValues, $1;
        }
    }

    if ( @ConfigParamKeys != @ConfigParamValues ) {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->ErrorScreen(
            Message => "Error: Not all keys seem to have values or vice versa.",
        );
    }

    my ( $KeyValue, $ValueValue );
    for my $Key (@ConfigParamKeys) {
        $KeyValue   = $ParamObject->GetParam( Param => "ConfigKey[$Key]" );
        $ValueValue = $ParamObject->GetParam( Param => "ConfigValue[$Key]" );
        $GetParam->{Config}->{$KeyValue} = $ValueValue;
    }

    return $GetParam;
}

sub _PopSessionScreen {
    my ( $Self, %Param ) = @_;

    my $LastScreen;

    if ( defined $Param{OnlyCurrent} && $Param{OnlyCurrent} == 1 ) {

        # check if last screen action is current screen action
        if ( $Self->{ScreensPath}->[-1]->{Action} eq $Self->{Action} ) {

            # remove last screen
            $LastScreen = pop @{ $Self->{ScreensPath} };
        }
    }
    else {

        # remove last screen
        $LastScreen = pop @{ $Self->{ScreensPath} };
    }

    # convert screens path to string (JSON)
    my $JSONScreensPath = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return $LastScreen;
}

sub _PushSessionScreen {
    my ( $Self, %Param ) = @_;

    # add screen to the screen path
    push @{ $Self->{ScreensPath} }, {
        Action => $Self->{Action} || '',
        Subaction => $Param{Subaction},
        ID        => $Param{ID},
        EntityID  => $Param{EntityID},
    };

    # convert screens path to string (JSON)
    my $JSONScreensPath = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return 1;
}

sub _PopupResponse {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( $Param{Redirect} && $Param{Redirect} eq 1 ) {
        $LayoutObject->Block(
            Name => 'Redirect',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
                %{ $Param{Screen} },
            },
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {
        $LayoutObject->Block(
            Name => 'ClosePopup',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
            },
        );
    }

    my $Output = $LayoutObject->Header( Type => 'Small' );
    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementPopupResponse",
        Data         => {},
    );
    $Output .= $LayoutObject->Footer( Type => 'Small' );

    return $Output;
}

sub _CheckTransitionActionUsage {
    my ( $Self, %Param ) = @_;

    # get a list of parents with all the details
    my $List = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessListGet(
        UserID => 1,
    );

    my @Usage;

    # search entity id in all parents
    PARENT:
    for my $ParentData ( @{$List} ) {
        next PARENT if !$ParentData;
        next PARENT if !$ParentData->{TransitionActions};
        ENTITY:
        for my $EntityID ( @{ $ParentData->{TransitionActions} } ) {
            if ( $EntityID eq $Param{EntityID} ) {
                push @Usage, $ParentData->{Name};
                last ENTITY;
            }
        }
    }

    return \@Usage;
}

1;
