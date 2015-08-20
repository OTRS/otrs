# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementActivityDialog;

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

    my $ActivityDialogID = $ParamObject->GetParam( Param => 'ID' )       || '';
    my $EntityID         = $ParamObject->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # get needed objects
    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $EntityObject         = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity');
    my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create available Fields list
    my $AvailableFieldsList = {
        Article     => 'Article',
        State       => 'StateID',
        Priority    => 'PriorityID',
        Lock        => 'LockID',
        Queue       => 'QueueID',
        CustomerID  => 'CustomerID',
        Owner       => 'OwnerID',
        PendingTime => 'PendingTime',
        Title       => 'Title',
    };

    # add service and SLA fields, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Service') ) {
        $AvailableFieldsList->{Service} = 'ServiceID';
        $AvailableFieldsList->{SLA}     = 'SLAID';
    }

    # add ticket type field, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Type') ) {
        $AvailableFieldsList->{Type} = 'TypeID';
    }

    # add responsible field, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        $AvailableFieldsList->{Responsible} = 'ResponsibleID';
    }

    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );

    DYNAMICFIELD:
    for my $DynamicFieldName ( values %{$DynamicFieldList} ) {

        next DYNAMICFIELD if !$DynamicFieldName;

        # do not show internal fields for process management
        next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementProcessID';
        next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementActivityID';

        $AvailableFieldsList->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
    }

    # ------------------------------------------------------------ #
    # ActivityDialogNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ActivityDialogNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # ActivityDialogNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityDialogNewAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get Activity Dialog data
        my $ActivityDialogData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new confguration
        $ActivityDialogData->{Name}                       = $GetParam->{Name};
        $ActivityDialogData->{EntityID}                   = $GetParam->{EntityID};
        $ActivityDialogData->{Config}->{Interface}        = $GetParam->{Interface};
        $ActivityDialogData->{Config}->{DescriptionShort} = $GetParam->{DescriptionShort};
        $ActivityDialogData->{Config}->{DescriptionLong}  = $GetParam->{DescriptionLong};
        $ActivityDialogData->{Config}->{Permission}       = $GetParam->{Permission};
        $ActivityDialogData->{Config}->{RequiredLock}     = $GetParam->{RequiredLock} || 0;
        $ActivityDialogData->{Config}->{SubmitAdviceText} = $GetParam->{SubmitAdviceText};
        $ActivityDialogData->{Config}->{SubmitButtonText} = $GetParam->{SubmitButtonText};
        $ActivityDialogData->{Config}->{Fields}           = {};
        $ActivityDialogData->{Config}->{FieldOrder}       = [];

        if ( IsArrayRefWithData( $GetParam->{Fields} ) ) {

            FIELD:
            for my $FieldName ( @{ $GetParam->{Fields} } ) {
                next FIELD if !$FieldName;
                next FIELD if !$AvailableFieldsList->{$FieldName};

                # set fields hash
                $ActivityDialogData->{Config}->{Fields}->{$FieldName} = {};

                # set field order array
                push @{ $ActivityDialogData->{Config}->{FieldOrder} }, $FieldName;
            }
        }

        # add field detail config to fields
        if ( IsHashRefWithData( $GetParam->{FieldDetails} ) ) {
            FIELDDETAIL:
            for my $FieldDetail ( sort keys %{ $GetParam->{FieldDetails} } ) {
                next FIELDDETAIL if !$FieldDetail;
                next FIELDDETAIL if !$ActivityDialogData->{Config}->{Fields}->{$FieldDetail};

                $ActivityDialogData->{Config}->{Fields}->{$FieldDetail} = $GetParam->{FieldDetails}->{$FieldDetail};
            }
        }

        # set correct Interface value
        my %Interfaces = (
            AgentInterface    => ['AgentInterface'],
            CustomerInterface => ['CustomerInterface'],
            BothInterfaces    => [ 'AgentInterface', 'CustomerInterface' ],
        );
        $ActivityDialogData->{Config}->{Interface} = $Interfaces{ $ActivityDialogData->{Config}->{Interface} };

        if ( !$ActivityDialogData->{Config}->{Interface} ) {
            $ActivityDialogData->{Config}->{Interface} = $Interfaces{Agent};
        }

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{DescriptionShort} ) {

            # add server error error class
            $Error{DescriptionShortServerError} = 'ServerError';
            $Error{DecriptionShortErrorMessage} = 'This field is required';
        }

        # check if permission exists
        if ( defined $GetParam->{Permission} && $GetParam->{Permission} ne '' ) {
            my $PermissionList = $ConfigObject->Get('System::Permission');

            my %PermissionLookup = map { $_ => 1 } @{$PermissionList};

            if ( !$PermissionLookup{ $GetParam->{Permission} } )
            {

                # add server error error class
                $Error{PermissionServerError} = 'ServerError';
            }
        }

        # check if required lock exists
        if ( $GetParam->{RequiredLock} && $GetParam->{RequiredLock} ne 1 ) {

            # add server error error class
            $Error{RequiredLockServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ActivityDialogData => $ActivityDialogData,
                Action             => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $EntityObject->EntityIDGenerate(
            EntityType => 'ActivityDialog',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error generating a new EntityID for this ActivityDialog",
            );
        }

        # otherwise save configuration and return process screen
        my $ActivityDialogID = $ActivityDialogObject->ActivityDialogAdd(
            Name     => $ActivityDialogData->{Name},
            EntityID => $EntityID,
            Config   => $ActivityDialogData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ActivityDialogID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the ActivityDialog",
            );
        }

        # set entity sync state
        my $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'ActivityDialog',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error setting the entity sync status for ActivityDialog "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $ActivityDialogConfig = $Self->_GetActivityDialogConfig(
            EntityID => $EntityID,
        );

        my $ConfigJSON = $LayoutObject->JSONEncode( Data => $ActivityDialogConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityDialogID,
                EntityID  => $ActivityDialogData->{EntityID},
                Subaction => 'ActivityDialogEdit'               # always use edit screen
            );

            my $RedirectField = $ParamObject->GetParam( Param => 'PopupRedirectID' ) || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => 'AdminProcessManagementField',
                    Subaction => 'FieldEdit',
                    Field     => $RedirectField,
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
    # ActivityDialogEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityDialogEdit' ) {

        # check for ActivityDialogID
        if ( !$ActivityDialogID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need ActivityDialogID!",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get Activity Dialog data
        my $ActivityDialogData = $ActivityDialogObject->ActivityDialogGet(
            ID     => $ActivityDialogID,
            UserID => $Self->{UserID},
        );

        # check for valid Activity Dialog data
        if ( !IsHashRefWithData($ActivityDialogData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for ActivityDialogID $ActivityDialogID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            ActivityDialogID   => $ActivityDialogID,
            ActivityDialogData => $ActivityDialogData,
            Action             => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # ActvityDialogEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityDialogEditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get Activity Dialog Data
        my $ActivityDialogData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new confguration
        $ActivityDialogData->{Name}                       = $GetParam->{Name};
        $ActivityDialogData->{EntityID}                   = $GetParam->{EntityID};
        $ActivityDialogData->{Config}->{Interface}        = $GetParam->{Interface};
        $ActivityDialogData->{Config}->{DescriptionShort} = $GetParam->{DescriptionShort};
        $ActivityDialogData->{Config}->{DescriptionLong}  = $GetParam->{DescriptionLong};
        $ActivityDialogData->{Config}->{Permission}       = $GetParam->{Permission};
        $ActivityDialogData->{Config}->{RequiredLock}     = $GetParam->{RequiredLock} || 0;
        $ActivityDialogData->{Config}->{SubmitAdviceText} = $GetParam->{SubmitAdviceText};
        $ActivityDialogData->{Config}->{SubmitButtonText} = $GetParam->{SubmitButtonText};
        $ActivityDialogData->{Config}->{Fields}           = {};
        $ActivityDialogData->{Config}->{FieldOrder}       = [];

        if ( IsArrayRefWithData( $GetParam->{Fields} ) ) {

            FIELD:
            for my $FieldName ( @{ $GetParam->{Fields} } ) {
                next FIELD if !$FieldName;
                next FIELD if !$AvailableFieldsList->{$FieldName};

                # set fields hash
                $ActivityDialogData->{Config}->{Fields}->{$FieldName} = {};

                # set field order array
                push @{ $ActivityDialogData->{Config}->{FieldOrder} }, $FieldName;
            }
        }

        # add field detail config to fields
        if ( IsHashRefWithData( $GetParam->{FieldDetails} ) ) {
            FIELDDETAIL:
            for my $FieldDetail ( sort keys %{ $GetParam->{FieldDetails} } ) {
                next FIELDDETAIL if !$FieldDetail;
                next FIELDDETAIL if !$ActivityDialogData->{Config}->{Fields}->{$FieldDetail};

                $ActivityDialogData->{Config}->{Fields}->{$FieldDetail} = $GetParam->{FieldDetails}->{$FieldDetail};
            }
        }

        # set default values for fields in case they don't have details
        for my $FieldName ( sort keys %{ $ActivityDialogData->{Config}->{Fields} } ) {
            if ( !IsHashRefWithData( $ActivityDialogData->{Config}->{Fields}->{$FieldName} ) ) {
                $ActivityDialogData->{Config}->{Fields}->{$FieldName}->{DescriptionShort} = $FieldName;
            }
        }

        # set correct Interface value
        my %Interfaces = (
            AgentInterface    => ['AgentInterface'],
            CustomerInterface => ['CustomerInterface'],
            BothInterfaces    => [ 'AgentInterface', 'CustomerInterface' ],
        );
        $ActivityDialogData->{Config}->{Interface} = $Interfaces{ $ActivityDialogData->{Config}->{Interface} };

        if ( !$ActivityDialogData->{Config}->{Interface} ) {
            $ActivityDialogData->{Config}->{Interface} = $Interfaces{Agent};
        }

        # check required parameters
        my %Error;

        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{DescriptionShort} ) {

            # add server error error class
            $Error{DescriptionShortServerError} = 'ServerError';
            $Error{DecriptionShortErrorMessage} = 'This field is required';
        }

        # check if permission exists
        if ( defined $GetParam->{Permission} && $GetParam->{Permission} ne '' ) {

            my $PermissionList = $ConfigObject->Get('System::Permission');

            my %PermissionLookup = map { $_ => 1 } @{$PermissionList};

            if ( !$PermissionLookup{ $GetParam->{Permission} } )
            {

                # add server error error class
                $Error{PermissionServerError} = 'ServerError';
            }
        }

        # check if required lock exists
        if ( $GetParam->{RequiredLock} && $GetParam->{RequiredLock} ne 1 ) {

            # add server error error class
            $Error{RequiredLockServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ActivityDialogData => $ActivityDialogData,
                Action             => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $ActivityDialogObject->ActivityDialogUpdate(
            ID       => $ActivityDialogID,
            Name     => $ActivityDialogData->{Name},
            EntityID => $ActivityDialogData->{EntityID},
            Config   => $ActivityDialogData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error updating the ActivityDialog",
            );
        }

        # set entity sync state
        $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'ActivityDialog',
            EntityID   => $ActivityDialogData->{EntityID},
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error setting the entity sync status for ActivityDialog "
                    . "entity:$ActivityDialogData->{EntityID}",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $ActivityDialogConfig = $Self->_GetActivityDialogConfig(
            EntityID => $ActivityDialogData->{EntityID},
        );

        my $ConfigJSON = $LayoutObject->JSONEncode( Data => $ActivityDialogConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityDialogID,
                EntityID  => $ActivityDialogData->{EntityID},
                Subaction => 'ActivityDialogEdit'               # always use edit screen
            );

            my $RedirectField = $ParamObject->GetParam( Param => 'PopupRedirectID' ) || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => 'AdminProcessManagementField',
                    Subaction => 'FieldEdit',
                    Field     => $RedirectField,
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

sub _GetActivityDialogConfig {
    my ( $Self, %Param ) = @_;

    # Get new ActivityDialog Config as JSON
    my $ProcessDump = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );

    my %ActivityDialogConfig;
    $ActivityDialogConfig{ActivityDialog} = ();
    $ActivityDialogConfig{ActivityDialog}->{ $Param{EntityID} } = $ProcessDump->{ActivityDialog}->{ $Param{EntityID} };

    return \%ActivityDialogConfig;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get Activity Dialog information
    my $ActivityDialogData = $Param{ActivityDialogData} || {};

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
                Action    => $Self->{ScreensPath}->[-1]->{Action}    || '',
                Subaction => $Self->{ScreensPath}->[-1]->{Subaction} || '',
                ID        => $Self->{ScreensPath}->[-1]->{ID}        || '',
                EntityID  => $Self->{ScreensPath}->[-1]->{EntityID}  || '',
            },
        );
    }

    # create available Fields list
    my $AvailableFieldsList = {
        Article     => 'Article',
        State       => 'StateID',
        Priority    => 'PriorityID',
        Lock        => 'LockID',
        Queue       => 'QueueID',
        CustomerID  => 'CustomerID',
        Owner       => 'OwnerID',
        PendingTime => 'PendingTime',
        Title       => 'Title',
    };

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # add service and SLA fields, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Service') ) {
        $AvailableFieldsList->{Service} = 'ServiceID';
        $AvailableFieldsList->{SLA}     = 'SLAID';
    }

    # add ticket type field, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Type') ) {
        $AvailableFieldsList->{Type} = 'TypeID';
    }

    # add responsible field, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        $AvailableFieldsList->{Responsible} = 'ResponsibleID';
    }

    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );

    DYNAMICFIELD:
    for my $DynamicFieldName ( values %{$DynamicFieldList} ) {

        next DYNAMICFIELD if !$DynamicFieldName;

        # do not show internal fields for process management
        next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementProcessID';
        next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementActivityID';

        $AvailableFieldsList->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
    }

    # localize available fields
    my %AvailableFields = %{$AvailableFieldsList};

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        # get used fields by the activity dialog
        my %AssignedFields;

        if ( IsHashRefWithData( $ActivityDialogData->{Config}->{Fields} ) ) {
            FIELD:
            for my $Field ( sort keys %{ $ActivityDialogData->{Config}->{Fields} } ) {
                next FIELD if !$Field;
                next FIELD if !$ActivityDialogData->{Config}->{Fields}->{$Field};

                $AssignedFields{$Field} = 1;
            }
        }

        # remove used fields from available list
        for my $Field ( sort keys %AssignedFields ) {
            delete $AvailableFields{$Field};
        }

        # sort by translated field names
        my %AvailableFieldsTranslated;
        for my $Field ( sort keys %AvailableFields ) {
            my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
            $AvailableFieldsTranslated{$Field} = $Translation;
        }

        # display available fields
        for my $Field (
            sort { $AvailableFieldsTranslated{$a} cmp $AvailableFieldsTranslated{$b} }
            keys %AvailableFieldsTranslated
            )
        {
            $LayoutObject->Block(
                Name => 'AvailableFieldRow',
                Data => {
                    Field               => $Field,
                    FieldnameTranslated => $AvailableFieldsTranslated{$Field},
                },
            );
        }

        # display used fields
        ASSIGNEDFIELD:
        for my $Field ( @{ $ActivityDialogData->{Config}->{FieldOrder} } ) {
            next ASSIGNEDFIELD if !$AssignedFields{$Field};

            my $FieldConfig = $ActivityDialogData->{Config}->{Fields}->{$Field};

            my $FieldConfigJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => $FieldConfig,
            );

            $LayoutObject->Block(
                Name => 'AssignedFieldRow',
                Data => {
                    Field       => $Field,
                    FieldConfig => $FieldConfigJSON,
                },
            );
        }

        # display other affected processes by editing this activity (if applicable)
        my $AffectedActivities = $Self->_CheckActivityDialogUsage(
            EntityID => $ActivityDialogData->{EntityID},
        );

        if ( @{$AffectedActivities} ) {

            $LayoutObject->Block(
                Name => 'EditWarning',
                Data => {
                    ActivityList => join( ', ', @{$AffectedActivities} ),
                    }
            );
        }

        $Param{Title} = "Edit Activity Dialog \"$ActivityDialogData->{Name}\"";
    }
    else {

        # sort by translated field names
        my %AvailableFieldsTranslated;
        for my $Field ( sort keys %AvailableFields ) {
            my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
            $AvailableFieldsTranslated{$Field} = $Translation;
        }

        # display available fields
        for my $Field (
            sort { $AvailableFieldsTranslated{$a} cmp $AvailableFieldsTranslated{$b} }
            keys %AvailableFieldsTranslated
            )
        {
            $LayoutObject->Block(
                Name => 'AvailableFieldRow',
                Data => {
                    Field               => $Field,
                    FieldnameTranslated => $AvailableFieldsTranslated{$Field},
                },
            );
        }

        $Param{Title} = 'Create New Activity Dialog';
    }

    # get interface infos
    if ( defined $ActivityDialogData->{Config}->{Interface} ) {
        my $InterfaceLength = scalar @{ $ActivityDialogData->{Config}->{Interface} };
        if ( $InterfaceLength == 2 ) {
            $ActivityDialogData->{Config}->{Interface} = 'BothInterfaces';
        }
        elsif ( $InterfaceLength == 1 ) {
            $ActivityDialogData->{Config}->{Interface} = $ActivityDialogData->{Config}->{Interface}->[0];
        }
        else {
            $ActivityDialogData->{Config}->{Interface} = 'AgentInterface';
        }
    }
    else {
        $ActivityDialogData->{Config}->{Interface} = 'AgentInterface';
    }

    # create interface selection
    $Param{InterfaceSelection} = $LayoutObject->BuildSelection(
        Data => {
            AgentInterface    => 'Agent Interface',
            CustomerInterface => 'Customer Interface',
            BothInterfaces    => 'Agent and Customer Interface',
        },
        Name         => 'Interface',
        ID           => 'Interface',
        SelectedID   => $ActivityDialogData->{Config}->{Interface} || '',
        Sort         => 'AlphanumericKey',
        Translation  => 1,
        PossibleNone => 0,
        Class        => 'Modernize',
    );

    # create permission selection
    $Param{PermissionSelection} = $LayoutObject->BuildSelection(
        Data       => $Kernel::OM->Get('Kernel::Config')->Get('System::Permission') || ['rw'],
        Name       => 'Permission',
        ID         => 'Permission',
        SelectedID => $ActivityDialogData->{Config}->{Permission}                   || '',
        Sort       => 'AlphanumericKey',
        Translation  => 1,
        PossibleNone => 1,
        Class        => 'Modernize' . ( $Param{PermissionServerError} || '' ),
    );

    # create "required lock" selection
    $Param{RequiredLockSelection} = $LayoutObject->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name        => 'RequiredLock',
        ID          => 'RequiredLock',
        SelectedID  => $ActivityDialogData->{Config}->{RequiredLock} || 0,
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'Modernize ' . ( $Param{RequiredLockServerError} || '' ),
    );

    # create Display selection
    $Param{DisplaySelection} = $LayoutObject->BuildSelection(
        Data => {
            0 => 'Do not show Field',
            1 => 'Show Field',
            2 => 'Show Field As Mandatory',
        },
        Name        => 'Display',
        ID          => 'Display',
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'Modernize',
    );

    # create ArticleType selection
    $Param{ArticleTypeSelection} = $LayoutObject->BuildSelection(
        Data => [
            'note-internal',
            'note-external',
            'note-report',
            'phone',
            'fax',
            'sms',
            'webrequest',
        ],
        SelectedValue => 'note-internal',
        Name          => 'ArticleType',
        ID            => 'ArticleType',
        Sort          => 'Alphanumeric',
        Translation   => 1,
        Class         => 'Modernize',
    );

    # extract parameters from config
    $Param{DescriptionShort} = $Param{ActivityDialogData}->{Config}->{DescriptionShort};
    $Param{DescriptionLong}  = $Param{ActivityDialogData}->{Config}->{DescriptionLong};
    $Param{SubmitAdviceText} = $Param{ActivityDialogData}->{Config}->{SubmitAdviceText};
    $Param{SubmitButtonText} = $Param{ActivityDialogData}->{Config}->{SubmitButtonText};

    my $Output = $LayoutObject->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementActivityDialog",
        Data         => {
            %Param,
            %{$ActivityDialogData},
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
        qw( Name EntityID Interface DescriptionShort DescriptionLong Permission RequiredLock SubmitAdviceText
        SubmitButtonText )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }

    my $Fields = $ParamObject->GetParam( Param => 'Fields' ) || '';
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    if ($Fields) {
        $GetParam->{Fields} = $JSONObject->Decode(
            Data => $Fields,
        );
    }
    else {
        $GetParam->{Fields} = '';
    }

    my $FieldDetails = $ParamObject->GetParam( Param => 'FieldDetails' ) || '';

    if ($FieldDetails) {
        $GetParam->{FieldDetails} = $JSONObject->Decode(
            Data => $FieldDetails,
        );
    }
    else {
        $GetParam->{FieldDetails} = '';
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
    my $JSONScreensPath = my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->JSONEncode(
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
    my $JSONScreensPath = my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->JSONEncode(
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

sub _CheckActivityDialogUsage {
    my ( $Self, %Param ) = @_;

    # get a list of parents with all the details
    my $List = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity')->ActivityListGet(
        UserID => 1,
    );

    my @Usage;

    # search entity id in all parents
    PARENT:
    for my $ParentData ( @{$List} ) {
        next PARENT if !$ParentData;
        next PARENT if !$ParentData->{ActivityDialogs};
        ENTITY:
        for my $EntityID ( @{ $ParentData->{ActivityDialogs} } ) {
            if ( $EntityID eq $Param{EntityID} ) {
                push @Usage, $ParentData->{Name};
                last ENTITY;
            }
        }
    }

    return \@Usage;
}

1;
