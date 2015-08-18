# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminACL;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

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

    my $ACLID = $ParamObject->GetParam( Param => 'ID' ) || '';

    my $SynchronizeMessage
        = 'ACL information from database is not in sync with the system configuration, please deploy all ACLs.';

    my $SynchronizedMessageVisible = 0;

    my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

    if ( $ACLObject->ACLsNeedSync() ) {

        # create a notification if system is not up to date
        $Param{NotifyData} = [
            {
                Info => $SynchronizeMessage,
            },
        ];
        $SynchronizedMessageVisible = 1;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ------------------------------------------------------------ #
    # ACLImport
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ACLImport' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $FormID = $ParamObject->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || '';

        my $ACLImport = $ACLObject->ACLImport(
            Content                   => $UploadStuff{Content},
            OverwriteExistingEntities => $OverwriteExistingEntities,
            UserID                    => $Self->{UserID},
        );

        if ( !$ACLImport->{Success} ) {
            my $Message = $ACLImport->{Message}
                || 'ACLs could not be Imported due to a unknown error,'
                . ' please check OTRS logs for more information';
            return $LayoutObject->ErrorScreen(
                Message => $Message,
            );
        }

        if ( $ACLImport->{AddedACLs} ) {
            push @{ $Param{NotifyData} }, {
                Info => 'The following ACLs have been added successfully: '
                    . $ACLImport->{AddedACLs},
            };
        }
        if ( $ACLImport->{UpdatedACLs} ) {
            push @{ $Param{NotifyData} }, {
                Info => 'The following ACLs have been updated successfully: '
                    . $ACLImport->{UpdatedACLs},
            };
        }
        if ( $ACLImport->{ACLErrors} ) {
            push @{ $Param{NotifyData} }, {
                Priority => 'Error',
                Info     => 'There where errors adding/updating the following ACLs: '
                    . $ACLImport->{ACLErrors}
                    . '. Please check the log file for more information.',
            };
        }

        if (
            ( $ACLImport->{UpdatedACLs} || $ACLImport->{AddedACLs} )
            && !$SynchronizedMessageVisible
            )
        {

            $Param{NotifyData} = [
                @{ $Param{NotifyData} || [] },
                {
                    Info => $SynchronizeMessage,
                },
            ];
        }

        return $Self->_ShowOverview(
            %Param,
        );
    }

    # ------------------------------------------------------------ #
    # ACLNew
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # ACLNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLNewAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get ACL data
        my $ACLData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new confguration
        $ACLData->{Name}           = $GetParam->{Name};
        $ACLData->{Comment}        = $GetParam->{Comment};
        $ACLData->{Description}    = $GetParam->{Description};
        $ACLData->{StopAfterMatch} = $GetParam->{StopAfterMatch} || 0;
        $ACLData->{ValidID}        = $GetParam->{ValidID};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{ValidID} ) {

            # add server error error class
            $Error{ValidIDServerError}        = 'ServerError';
            $Error{ValidIDServerErrorMessage} = 'This field is required';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ACLData => $ACLData,
                Action  => 'New',
            );
        }

        # otherwise save configuration and return to overview screen
        my $ACLID = $ACLObject->ACLAdd(
            Name           => $ACLData->{Name},
            Comment        => $ACLData->{Comment},
            Description    => $ACLData->{Description},
            StopAfterMatch => $ACLData->{StopAfterMatch},
            ValidID        => $ACLData->{ValidID},
            UserID         => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ACLID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the ACL",
            );
        }

        # redirect to edit screen
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=ACLEdit;ID=$ACLID" );
    }

    # ------------------------------------------------------------ #
    # ACLEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLEdit' ) {

        # check for ACLID
        if ( !$ACLID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need ACLID!",
            );
        }

        # get ACL data
        my $ACLData = $ACLObject->ACLGet(
            ID     => $ACLID,
            UserID => $Self->{UserID},
        );

        # check for valid ACL data
        if ( !IsHashRefWithData($ACLData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for ACLID $ACLID",
            );
        }

        my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

        if ( $ACLData->{ConfigMatch} ) {
            $ACLData->{ConfigMatch} = $JSONObject->Encode(
                Data => $ACLData->{ConfigMatch},
            );
        }

        if ( $ACLData->{ConfigChange} ) {
            $ACLData->{ConfigChange} = $JSONObject->Encode(
                Data => $ACLData->{ConfigChange},
            );
        }

        return $Self->_ShowEdit(
            %Param,
            ACLID   => $ACLID,
            ACLData => $ACLData,
            Action  => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # ACLEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLEditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get webserice configuration
        my $ACLData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new confguration
        $ACLData->{Name}           = $GetParam->{Name};
        $ACLData->{Comment}        = $GetParam->{Comment};
        $ACLData->{Description}    = $GetParam->{Description};
        $ACLData->{StopAfterMatch} = $GetParam->{StopAfterMatch} || 0;
        $ACLData->{ValidID}        = $GetParam->{ValidID};
        $ACLData->{ConfigMatch}    = $GetParam->{ConfigMatch} || '';
        $ACLData->{ConfigChange}   = $GetParam->{ConfigChange} || '';

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{ValidID} ) {

            # add server error error class
            $Error{ValidIDServerError}        = 'ServerError';
            $Error{ValidIDServerErrorMessage} = 'This field is required';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ACLData => $ACLData,
                Action  => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $ACLObject->ACLUpdate(
            ID             => $ACLID,
            Name           => $ACLData->{Name},
            Comment        => $ACLData->{Comment},
            Description    => $ACLData->{Description},
            StopAfterMatch => $ACLData->{StopAfterMatch} || 0,
            ValidID        => $ACLData->{ValidID},
            ConfigMatch    => $ACLData->{ConfigMatch} || '',
            ConfigChange   => $ACLData->{ConfigChange} || '',
            UserID         => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error updating the ACL",
            );
        }

        if ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' ) {

            # if the user would like to continue editing the ACL, just redirect to the edit screen
            return $LayoutObject->Redirect(
                OP =>
                    "Action=AdminACL;Subaction=ACLEdit;ID=$ACLID"
            );
        }
        else {

            # otherwise return to overview
            return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
        }
    }

    # ------------------------------------------------------------ #
    # Sync
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLDeploy' ) {

        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

        my $ACLDump = $ACLObject->ACLDump(
            ResultType => 'FILE',
            Location   => $Location,
            UserID     => $Self->{UserID},
        );

        if ($ACLDump) {

            my $Success = $ACLObject->ACLsNeedSyncReset();

            if ($Success) {
                return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
            }
            else {

                # show error if can't set state
                return $LayoutObject->ErrorScreen(
                    Message => "There was an error setting the entity sync status.",
                );
            }
        }
        else {

            # show error if can't synch
            return $LayoutObject->ErrorScreen(
                Message => "There was an error synchronizing the ACLs.",
            );
        }
    }

    # ------------------------------------------------------------ #
    # ACLDelete AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLDelete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check for ACLID
        return if !$ACLID;

        my $CheckResult = $Self->_CheckACLDelete( ID => $ACLID );

        my $JSON;
        if ( $CheckResult->{Success} ) {

            my $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => $Self->{UserID},
            );

            my %DeleteResult = (
                Success => $Success,
            );

            if ( !$Success ) {
                $DeleteResult{Message} = 'ACL $ACLID could not be deleted';
            }

            # build JSON output
            $JSON = $LayoutObject->JSONEncode(
                Data => {
                    %DeleteResult,
                },
            );
        }
        else {

            # build JSON output
            $JSON = $LayoutObject->JSONEncode(
                Data => {
                    %{$CheckResult},
                },
            );
        }

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ACLExport
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLExport' ) {

        my $ACLID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my $ACLData;
        my $ACLSingleData;
        my $Filename = 'Export_ACL.yml';

        if ($ACLID) {

            $ACLSingleData = $ACLObject->ACLGet(
                ID     => $ACLID,
                UserID => 1,
            );

            if ( !$ACLSingleData || !IsHashRefWithData($ACLSingleData) ) {
                return $LayoutObject->ErrorScreen(
                    Message => "There was an error getting data for ACL with ID " . $ACLID,
                );
            }

            my $ACLName = $ACLSingleData->{Name};
            $ACLName =~ s{[^a-zA-Z0-9-_]}{_}xmsg;    # cleanup name for saving

            $Filename = 'Export_ACL_' . $ACLName . '.yml';
            $ACLData  = [$ACLSingleData];
        }
        else {

            $ACLData = $ACLObject->ACLListGet(
                UserID   => 1,
                ValidIDs => [ '1', '2' ],
            );
        }

        # convert the ACL data hash to string
        my $ACLDataYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $ACLData );

        # send the result to the browser
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $ACLDataYAML,
            Type        => 'attachment',
            Filename    => $Filename,
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ACLCopy
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLCopy' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get ACL data
        my $ACLData = $ACLObject->ACLGet(
            ID     => $ACLID,
            UserID => $Self->{UserID},
        );
        if ( !$ACLData ) {
            return $LayoutObject->ErrorScreen(
                Message => "Unknown ACL $ACLID!",
            );
        }

        # create new ACL name
        my $ACLName =
            $ACLData->{Name}
            . ' ('
            . $LayoutObject->{LanguageObject}->Translate('Copy')
            . ')';

        # otherwise save configuration and return to overview screen
        my $ACLID = $ACLObject->ACLAdd(
            Name           => $ACLName,
            Comment        => $ACLData->{Comment},
            Description    => $ACLData->{Description},
            ConfigMatch    => $ACLData->{ConfigMatch} || '',
            ConfigChange   => $ACLData->{ConfigChange} || '',
            StopAfterMatch => $ACLData->{StopAfterMatch} || 0,
            ValidID        => '1',
            UserID         => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ACLID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the ACL",
            );
        }

        # return to overview
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # Overview
    # ------------------------------------------------------------ #
    else {
        return $Self->_ShowOverview(
            %Param,
        );
    }
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ACLObject    = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
    my $Output       = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $LayoutObject->Notify(
                %{$Notification},
            );
        }
    }

    # get ACL list
    my $ACLList = $ACLObject->ACLList( UserID => $Self->{UserID} );

    if ( IsHashRefWithData($ACLList) ) {

        # sort data numerically
        my @ACLIDsSorted = sort { $ACLList->{$a} cmp $ACLList->{$b} } keys %{$ACLList};

        # get each ACLs data
        for my $ACLID (@ACLIDsSorted) {

            my $ACLData = $ACLObject->ACLGet(
                ID     => $ACLID,
                UserID => $Self->{UserID},
            );

            # set the valid state
            $ACLData->{ValidID}
                = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $ACLData->{ValidID} );

            # print each ACL in overview table
            $LayoutObject->Block(
                Name => 'ACLRow',
                Data => {
                    %{$ACLData},
                },
            );
        }
    }
    else {

        # print no data found message
        $LayoutObject->Block(
            Name => 'ACLNoDataRow',
            Data => {},
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminACL',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get ACL information
    my $ACLData = $Param{ACLData} || {};

    # decide wether to show delete button
    if ( $Param{Action} eq 'Edit' && $ACLData && $ACLData->{ValidID} ne '1' ) {
        $LayoutObject->Block(
            Name => 'ACLDeleteAction',
            Data => {
                %{$ACLData},
            },
        );
    }

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $ACLData->{ValidID} || $ValidList{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    my $ACLKeysLevel1Match = $ConfigObject->Get('ACLKeysLevel1Match') || {};
    $Param{ACLKeysLevel1Match} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel1Match,
        Name         => 'ItemAdd',
        Class        => 'ItemAdd ItemAddLevel1',
        ID           => 'ItemAddLevel1Match',
        TreeView     => 1,
        PossibleNone => 1,
        Translation  => 0,
    );

    my $ACLKeysLevel1Change = $ConfigObject->Get('ACLKeysLevel1Change') || {};
    $Param{ACLKeysLevel1Change} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel1Change,
        Name         => 'ItemAdd',
        Class        => 'ItemAdd ItemAddLevel1',
        ID           => 'ItemAddLevel1Change',
        TreeView     => 1,
        PossibleNone => 1,
        Translation  => 0,
    );

    my $ACLKeysLevel2Possible = $ConfigObject->Get('ACLKeysLevel2::Possible') || {};
    $Param{ACLKeysLevel2Possible} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel2Possible,
        Name         => 'ItemAdd',
        ID           => 'Possible',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2PossibleAdd = $ConfigObject->Get('ACLKeysLevel2::PossibleAdd') || {};
    $Param{ACLKeysLevel2PossibleAdd} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel2PossibleAdd,
        Name         => 'ItemAdd',
        ID           => 'PossibleAdd',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2PossibleNot = $ConfigObject->Get('ACLKeysLevel2::PossibleNot') || {};
    $Param{ACLKeysLevel2PossibleNot} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel2PossibleNot,
        Name         => 'ItemAdd',
        ID           => 'PossibleNot',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2Properties = $ConfigObject->Get('ACLKeysLevel2::Properties') || {};
    $Param{ACLKeysLevel2Properties} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel2Properties,
        Name         => 'ItemAdd',
        ID           => 'Properties',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2PropertiesDatabase = $ConfigObject->Get('ACLKeysLevel2::PropertiesDatabase') || {};
    $Param{ACLKeysLevel2PropertiesDatabase} = $LayoutObject->BuildSelection(
        Data         => $ACLKeysLevel2PropertiesDatabase,
        Name         => 'ItemAdd',
        ID           => 'PropertiesDatabase',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    $Param{ACLKeysLevel4Prefixes} = $LayoutObject->BuildSelection(
        Data => {
            ''            => 'Exact match',
            '[Not]'       => 'Negated Exact match',
            '[RegExp]'    => 'Regex',
            '[regexp]'    => 'Regex (ignore case)',
            '[NotRegExp]' => 'Negated Regex',
            '[Notregexp]' => 'Negated Regex (ignore case)',
        },
        Name           => 'ItemPrefix',
        Class          => 'ItemPrefix',
        ID             => 'Prefixes',
        Sort           => 'IndividualKey',
        SortIndividual => [ '', '[Not]', '[RegExp]', '[regexp]', '[NotRegExp]', '[Notregexp]' ],
        Translation    => 0,
        AutoComplete   => 'off',
    );

    # get list of all possible dynamic fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        ObjectType => 'Ticket',
        ResultType => 'HASH',
    );
    my %DynamicFieldNames = reverse %{$DynamicFieldList};
    my %DynamicFields;
    for my $DynamicFieldName ( sort keys %DynamicFieldNames ) {
        $DynamicFields{ 'DynamicField_' . $DynamicFieldName } = $DynamicFieldName;
    }
    $Param{ACLKeysLevel3DynamicFields} = $LayoutObject->BuildSelection(
        Data         => \%DynamicFields,
        Name         => 'NewDataKeyDropdown',
        Class        => 'NewDataKeyDropdown',
        ID           => 'DynamicField',
        Translation  => 0,
        PossibleNone => 1,
    );

    # get list of all possible actions
    my @PossibleActionsList;
    my $ACLKeysLevel3Actions = $ConfigObject->Get('ACLKeysLevel3::Actions') || [];

    for my $Key ( sort keys %{$ACLKeysLevel3Actions} ) {
        push @PossibleActionsList, @{ $ACLKeysLevel3Actions->{$Key} };
    }

    $Param{ACLKeysLevel3Actions} = $LayoutObject->BuildSelection(
        Data         => \@PossibleActionsList,
        Name         => 'NewDataKeyDropdown',
        Class        => 'NewDataKeyDropdown Boolean',
        ID           => 'Action',
        Translation  => 0,
        PossibleNone => 1,
    );

    $Param{PossibleActionsList} = \@PossibleActionsList;

    if ( defined $ACLData->{StopAfterMatch} && $ACLData->{StopAfterMatch} == 1 ) {
        $Param{Checked} = 'checked="checked"';
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $LayoutObject->Notify(
                %{$Notification},
            );
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminACL$Param{Action}",
        Data         => {
            %Param,
            %{$ACLData},
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw( Name EntityID Comment Description StopAfterMatch ValidID ConfigMatch ConfigChange )
        )
    {
        $GetParam->{$ParamName}
            = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $ParamName ) || '';
    }

    if ( $GetParam->{ConfigMatch} ) {
        $GetParam->{ConfigMatch} = $JSONObject->Decode(
            Data => $GetParam->{ConfigMatch},
        );
        if ( !IsHashRefWithData( $GetParam->{ConfigMatch} ) ) {
            $GetParam->{ConfigMatch} = undef;
        }
    }

    if ( $GetParam->{ConfigChange} ) {
        $GetParam->{ConfigChange} = $JSONObject->Decode(
            Data => $GetParam->{ConfigChange},
        );
        if ( !IsHashRefWithData( $GetParam->{ConfigChange} ) ) {
            $GetParam->{ConfigChange} = undef;
        }
    }

    return $GetParam;
}

sub _CheckACLDelete {
    my ( $Self, %Param ) = @_;

    # get ACL data
    my $ACLData = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL')->ACLGet(
        ID     => $Param{ID},
        UserID => $Self->{UserID},
    );

    # check for valid ACL data
    if ( !IsHashRefWithData($ACLData) ) {
        return {
            Success => 0,
            Message => "Could not get data for ACLID $Param{ID}",
        };
    }

    return {
        Success => 1,
        ACLData => $ACLData,
    };
}

1;
