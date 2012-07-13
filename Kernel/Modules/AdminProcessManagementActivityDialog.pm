# --
# Kernel/Modules/AdminProcessManagementActivityDialog.pm - process management activity
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagementActivityDialog.pm,v 1.4 2012-07-13 21:43:21 cr Exp $
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
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity::ActivityDialog;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

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
    $Self->{EntityObject}       = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::Activity::ActivityDialog->new( %{$Self} );

    # create available Fields list
    $Self->{AvailableFields} = {
        State          => 'StateID',
        Priority       => 'PriorityID',
        Lock           => 'LockID',
        Queue          => 'QueueID',
        CustomerID     => 'CustomerID',
        CustomerUserID => 'CustomerUserID',
        Owner          => 'OwnerID',
        Type           => 'TypeID',
        SLA            => 'SLAID',
        Service        => 'Service',
        Responsible    => 'ResponsibleID',
        PendingTime    => 'PendingTime',
        Title          => 'Title',
    };

    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldList(
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );

    for my $DynamicFieldName ( values %{$DynamicFieldList} ) {
        next if !$DynamicFieldName;

        $Self->{AvailableFields}->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ActivityDialogID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

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
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ActivityDialogData->{Name}                       = $GetParam->{Name};
        $ActivityDialogData->{EntityID}                   = $GetParam->{EntityID};
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
        my $PermissionList = $Self->{ConfigObject}->Get('System::Permission');

        my %PermissionLookup = map { $_ => 1 } @{$PermissionList};

        if ( !$PermissionLookup{ $GetParam->{Permission} } )
        {

            # add server error error class
            $Error{PermissionServerError} = 'ServerError';
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
                Message => "There was an error generating a new EntityID for this activity dialog",
            );
        }

        # otherwise save configuration and return process screen
        my $ActivityDialogID = $Self->{ActivityDialogObject}->ActivityDialogAdd(
            Name     => $ActivityDialogData->{Name},
            EntityID => $EntityID,
            Config   => $ActivityDialogData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if cant create
        if ( !$ActivityDialogID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the activity dialog",
            );
        }

        # close the popup
        $Self->{LayoutObject}->PopupClose(
            Reload => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ActivityEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityDialogEdit' ) {

        # check for ActivityDialogID
        if ( !$ActivityDialogID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ActivityDialogID!",
            );
        }

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
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ActivityDialogData->{Name}                       = $GetParam->{Name};
        $ActivityDialogData->{EntityID}                   = $GetParam->{EntityID};
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
        my $PermissionList = $Self->{ConfigObject}->Get('System::Permission');

        my %PermissionLookup = map { $_ => 1 } @{$PermissionList};

        if ( !$PermissionLookup{ $GetParam->{Permission} } )
        {

            # add server error error class
            $Error{PermissionServerError} = 'ServerError';
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

        # show error if cant update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the activity dialog",
            );
        }

        # close the popup
        $Self->{LayoutObject}->PopupClose(
            Reload => 1,
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

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get Activity Dialog information
    my $ActivityDialogData = $Param{ActivityDialogData} || {};

    # localize available fields
    my %AvailableFields = %{ $Self->{AvailableFields} };

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        # get used fields by the activity dialog
        my %AssignedFields;

        if ( IsHashRefWithData( $ActivityDialogData->{Config}->{Fields} ) ) {
            FIELD:
            for my $Field ( keys %{ $ActivityDialogData->{Config}->{Fields} } ) {
                next FIELD if !$Field;
                next FIELD if !$ActivityDialogData->{Config}->{Fields}->{$Field};

                $AssignedFields{$Field} = 1;
            }
        }

        # remove used fields from available list
        for my $Field ( keys %AssignedFields ) {
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
        for my $Field ( sort keys %AssignedFields ) {
            $Self->{LayoutObject}->Block(
                Name => 'AssignedFieldRow',
                Data => {
                    Field => $Field,
                },
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

    # create permssion selection
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

    # create permssion selection
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
        qw( Name EntityID DescriptionShort DescriptionLong Permission RequiredLock SubmitAdviceText
        SubmitButtonText )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    $GetParam->{Fields} = $Self->{JSONObject}->Decode(
        Data => $Self->{ParamObject}->GetParam( Param => 'Fields' ) || '',
    );

    return $GetParam;
}

1;
