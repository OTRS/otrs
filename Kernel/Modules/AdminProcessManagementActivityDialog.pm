# --
# Kernel/Modules/AdminProcessManagementActivityDialog.pm - process management activity
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementActivityDialog;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::DynamicField;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::ActivityDialog;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (
        qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    # create additional objects
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{ProcessObject}      = Kernel::System::ProcessManagement::DB::Process->new( %{$Self} );
    $Self->{EntityObject}       = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ProcessObject}
        = Kernel::System::ProcessManagement::DB::Process->new( %{$Self} );
    $Self->{ActivityObject}
        = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::ActivityDialog->new( %{$Self} );

    # create available Fields list
    $Self->{AvailableFields} = {
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
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $Self->{AvailableFields}->{Service} = 'ServiceID';
        $Self->{AvailableFields}->{SLA}     = 'SLAID';
    }

    # add ticket type field, if option is activated in sysconfig.
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Self->{AvailableFields}->{Type} = 'TypeID';
    }

    # add responsible field, if option is activated in sysconfig.
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        $Self->{AvailableFields}->{Responsible} = 'ResponsibleID';
    }

    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldList(
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );

    for my $DynamicFieldName ( values %{$DynamicFieldList} ) {
        next if !$DynamicFieldName;

        # skip internal fields
        my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $DynamicFieldName,
        );
        next if $DynamicField->{InternalField};

        $Self->{AvailableFields}->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ActivityDialogID = $Self->{ParamObject}->GetParam( Param => 'ID' )       || '';
    my $EntityID         = $Self->{ParamObject}->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Self->{SessionObject}->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Self->{JSONObject}->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
                next FIELD if !$Self->{AvailableFields}->{$FieldName};

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

                $ActivityDialogData->{Config}->{Fields}->{$FieldDetail}
                    = $GetParam->{FieldDetails}->{$FieldDetail};
            }
        }

        # set correct Interface value
        my %Interfaces = (
            AgentInterface    => ['AgentInterface'],
            CustomerInterface => ['CustomerInterface'],
            BothInterfaces    => [ 'AgentInterface', 'CustomerInterface' ],
        );
        $ActivityDialogData->{Config}->{Interface}
            = $Interfaces{ $ActivityDialogData->{Config}->{Interface} };

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
            my $PermissionList = $Self->{ConfigObject}->Get('System::Permission');

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
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'ActivityDialog',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error generating a new EntityID for this ActivityDialog",
            );
        }

        # otherwise save configuration and return process screen
        my $ActivityDialogID = $Self->{ActivityDialogObject}->ActivityDialogAdd(
            Name     => $ActivityDialogData->{Name},
            EntityID => $EntityID,
            Config   => $ActivityDialogData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ActivityDialogID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the ActivityDialog",
            );
        }

        # set entity sync state
        my $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'ActivityDialog',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for ActivityDialog "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $ActivityDialogConfig = $Self->_GetActivityDialogConfig(
            EntityID => $EntityID,
        );

        my $ConfigJSON = $Self->{LayoutObject}->JSONEncode( Data => $ActivityDialogConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityDialogID,
                EntityID  => $ActivityDialogData->{EntityID},
                Subaction => 'ActivityDialogEdit'               # always use edit screen
            );

            my $RedirectField = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectID' ) || '';

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
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ActivityDialogID!",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get Activity Dialog data
        my $ActivityDialogData = $Self->{ActivityDialogObject}->ActivityDialogGet(
            ID     => $ActivityDialogID,
            UserID => $Self->{UserID},
        );

        # check for valid Activity Dialog data
        if ( !IsHashRefWithData($ActivityDialogData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
                next FIELD if !$Self->{AvailableFields}->{$FieldName};

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

                $ActivityDialogData->{Config}->{Fields}->{$FieldDetail}
                    = $GetParam->{FieldDetails}->{$FieldDetail};
            }
        }

        # set default values for fields in case they don't have details
        for my $FieldName ( sort keys %{ $ActivityDialogData->{Config}->{Fields} } ) {
            if ( !IsHashRefWithData( $ActivityDialogData->{Config}->{Fields}->{$FieldName} ) ) {
                $ActivityDialogData->{Config}->{Fields}->{$FieldName}->{DescriptionShort}
                    = $FieldName;
            }
        }

        # set correct Interface value
        my %Interfaces = (
            AgentInterface    => ['AgentInterface'],
            CustomerInterface => ['CustomerInterface'],
            BothInterfaces    => [ 'AgentInterface', 'CustomerInterface' ],
        );
        $ActivityDialogData->{Config}->{Interface}
            = $Interfaces{ $ActivityDialogData->{Config}->{Interface} };

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

            my $PermissionList = $Self->{ConfigObject}->Get('System::Permission');

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
        my $Success = $Self->{ActivityDialogObject}->ActivityDialogUpdate(
            ID       => $ActivityDialogID,
            Name     => $ActivityDialogData->{Name},
            EntityID => $ActivityDialogData->{EntityID},
            Config   => $ActivityDialogData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the ActivityDialog",
            );
        }

        # set entity sync state
        $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'ActivityDialog',
            EntityID   => $ActivityDialogData->{EntityID},
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for ActivityDialog "
                    . "entity:$ActivityDialogData->{EntityID}",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $ActivityDialogConfig = $Self->_GetActivityDialogConfig(
            EntityID => $ActivityDialogData->{EntityID},
        );

        my $ConfigJSON = $Self->{LayoutObject}->JSONEncode( Data => $ActivityDialogConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityDialogID,
                EntityID  => $ActivityDialogData->{EntityID},
                Subaction => 'ActivityDialogEdit'               # always use edit screen
            );

            my $RedirectField = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectID' ) || '';

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
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "This subaction is not valid",
        );
    }
}

sub _GetActivityDialogConfig {
    my ( $Self, %Param ) = @_;

    # Get new ActivityDialog Config as JSON
    my $ProcessDump = $Self->{ProcessObject}->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );

    my %ActivityDialogConfig;
    $ActivityDialogConfig{ActivityDialog} = ();
    $ActivityDialogConfig{ActivityDialog}->{ $Param{EntityID} }
        = $ProcessDump->{ActivityDialog}->{ $Param{EntityID} };

    return \%ActivityDialogConfig;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get Activity Dialog information
    my $ActivityDialogData = $Param{ActivityDialogData} || {};

    # check if last screen action is main screen
    if ( $Self->{ScreensPath}->[-1]->{Action} eq 'AdminProcessManagement' ) {

        # show close popup link
        $Self->{LayoutObject}->Block(
            Name => 'ClosePopup',
            Data => {},
        );
    }
    else {

        # show go back link
        $Self->{LayoutObject}->Block(
            Name => 'GoBack',
            Data => {
                Action    => $Self->{ScreensPath}->[-1]->{Action}    || '',
                Subaction => $Self->{ScreensPath}->[-1]->{Subaction} || '',
                ID        => $Self->{ScreensPath}->[-1]->{ID}        || '',
                EntityID  => $Self->{ScreensPath}->[-1]->{EntityID}  || '',
            },
        );
    }

    # localize available fields
    my %AvailableFields = %{ $Self->{AvailableFields} };

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

        # display available fields
        for my $Field ( sort keys %AvailableFields ) {
            $Self->{LayoutObject}->Block(
                Name => 'AvailableFieldRow',
                Data => {
                    Field => $Field,
                },
            );
        }

        # display used fields
        ASSIGNEDFIELD:
        for my $Field ( @{ $ActivityDialogData->{Config}->{FieldOrder} } ) {
            next ASSIGNEDFIELD if !$AssignedFields{$Field};

            my $FieldConfig = $ActivityDialogData->{Config}->{Fields}->{$Field};

            my $FieldConfigJSON = $Self->{JSONObject}->Encode(
                Data => $FieldConfig,
            );

            $Self->{LayoutObject}->Block(
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

            $Self->{LayoutObject}->Block(
                Name => 'EditWarning',
                Data => {
                    ActivityList => join( ', ', @{$AffectedActivities} ),
                    }
            );
        }

        $Param{Title} = "Edit Activity Dialog \"$ActivityDialogData->{Name}\"";
    }
    else {

        # display available fields
        for my $Field ( sort keys %AvailableFields ) {
            $Self->{LayoutObject}->Block(
                Name => 'AvailableFieldRow',
                Data => {
                    Field => $Field,
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
            $ActivityDialogData->{Config}->{Interface}
                = $ActivityDialogData->{Config}->{Interface}->[0];
        }
        else {
            $ActivityDialogData->{Config}->{Interface} = 'AgentInterface';
        }
    }
    else {
        $ActivityDialogData->{Config}->{Interface} = 'AgentInterface';
    }

    # create interface selection
    $Param{InterfaceSelection} = $Self->{LayoutObject}->BuildSelection(
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
    );

    # create permission selection
    $Param{PermissionSelection} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('System::Permission') || ['rw'],
        Name       => 'Permission',
        ID         => 'Permission',
        SelectedID => $ActivityDialogData->{Config}->{Permission}      || '',
        Sort       => 'AlphanumericKey',
        Translation  => 1,
        PossibleNone => 1,
        Class        => $Param{PermissionServerError} || '',
    );

    # create "required lock" selection
    $Param{RequiredLockSelection} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name        => 'RequiredLock',
        ID          => 'RequiredLock',
        SelectedID  => $ActivityDialogData->{Config}->{RequiredLock} || 0,
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => $Param{RequiredLockServerError} || '',
    );

    # create Display selection
    $Param{DisplaySelection} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0 => 'Do not show Field',
            1 => 'Show Field',
            2 => 'Show Field As Mandatory',
        },
        Name        => 'Display',
        ID          => 'Display',
        Sort        => 'AlphanumericKey',
        Translation => 1,
    );

    # create ArticleType selection
    $Param{ArticleTypeSelection} = $Self->{LayoutObject}->BuildSelection(
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
    );

    # extract parameters from config
    $Param{DescriptionShort} = $Param{ActivityDialogData}->{Config}->{DescriptionShort};
    $Param{DescriptionLong}  = $Param{ActivityDialogData}->{Config}->{DescriptionLong};
    $Param{SubmitAdviceText} = $Param{ActivityDialogData}->{Config}->{SubmitAdviceText};
    $Param{SubmitButtonText} = $Param{ActivityDialogData}->{Config}->{SubmitButtonText};

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementActivityDialog",
        Data         => {
            %Param,
            %{$ActivityDialogData},
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw( Name EntityID Interface DescriptionShort DescriptionLong Permission RequiredLock SubmitAdviceText
        SubmitButtonText )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    my $Fields = $Self->{ParamObject}->GetParam( Param => 'Fields' ) || '';

    if ($Fields) {
        $GetParam->{Fields} = $Self->{JSONObject}->Decode(
            Data => $Fields,
        );
    }
    else {
        $GetParam->{Fields} = '';
    }

    my $FieldDetails = $Self->{ParamObject}->GetParam( Param => 'FieldDetails' ) || '';

    if ($FieldDetails) {
        $GetParam->{FieldDetails} = $Self->{JSONObject}->Decode(
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
    my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Self->{SessionObject}->UpdateSessionID(
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
    my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return 1;
}

sub _PopupResponse {
    my ( $Self, %Param ) = @_;

    if ( $Param{Redirect} && $Param{Redirect} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'Redirect',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
                %{ $Param{Screen} },
            },
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'ClosePopup',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
            },
        );
    }

    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementPopupResponse",
        Data         => {},
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

sub _CheckActivityDialogUsage {
    my ( $Self, %Param ) = @_;

    # get a list of parents with all the details
    my $List = $Self->{ActivityObject}->ActivityListGet(
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
