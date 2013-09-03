# --
# Kernel/Modules/AdminACL.pm - ACL administration
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminACL;

use strict;
use warnings;

use Kernel::System::YAML;
use Kernel::System::Valid;
use Kernel::System::JSON;
use Kernel::System::DynamicField;
use Kernel::System::ACL::DB::ACL;

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
    $Self->{ValidObject}        = Kernel::System::Valid->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{YAMLObject}         = Kernel::System::YAML->new( %{$Self} );
    $Self->{ACLObject}          = Kernel::System::ACL::DB::ACL->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ACLID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

    my $SynchronizeMessage
        = 'ACL information from database is not in sync with the system configuration, please deploy all ACLs.';

    my $SynchronizedMessageVisible = 0;
    if ( $Self->{ACLObject}->ACLsNeedSync() ) {

        # create a notification if system is not up to date
        $Param{NotifyData} = [
            {
                Info => $SynchronizeMessage,
            },
        ];
        $SynchronizedMessageVisible = 1;
    }

    # ------------------------------------------------------------ #
    # ACLImport
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ACLImport' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $FormID = $Self->{ParamObject}->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        my $OverwriteExistingEntities
            = $Self->{ParamObject}->GetParam( Param => 'OverwriteExistingEntities' ) || '';

        my $ACLData = $Self->{YAMLObject}->Load( Data => $UploadStuff{Content} );

        if ( ref $ACLData ne 'ARRAY' ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message =>
                    "Couldn't read ACL configuration file. Please make sure the file is valid.",
            );
        }

        my @UpdatedACLs;
        my @AddedACLs;
        my @ACLErrors;

        ACL:
        for my $ACL ( @{$ACLData} ) {

            next ACL if !$ACL;
            next ACL if ref $ACL ne 'HASH';

            my @ExistingACLs
                = @{ $Self->{ACLObject}->ACLListGet( UserID => $Self->{UserID} ) || [] };
            @ExistingACLs = grep { $_->{Name} eq $ACL->{Name} } @ExistingACLs;

            if ( $OverwriteExistingEntities && $ExistingACLs[0] ) {
                my $Success = $Self->{ACLObject}->ACLUpdate(
                    %{ $ExistingACLs[0] },
                    Name           => $ACL->{Name},
                    Comment        => $ACL->{Comment},
                    Description    => $ACL->{Description} || '',
                    StopAfterMatch => $ACL->{StopAfterMatch} || 0,
                    ConfigMatch    => $ACL->{ConfigMatch} || undef,
                    ConfigChange   => $ACL->{ConfigChange} || undef,
                    ValidID        => $ACL->{ValidID} || 1,
                    UserID         => $Self->{UserID},
                );

                if ($Success) {
                    push @UpdatedACLs, $ACL->{Name};
                }
                else {
                    push @ACLErrors, $ACL->{Name};
                }

            }
            else {

                # now add the ACL
                my $Success = $Self->{ACLObject}->ACLAdd(
                    Name           => $ACL->{Name},
                    Comment        => $ACL->{Comment},
                    Description    => $ACL->{Description} || '',
                    ConfigMatch    => $ACL->{ConfigMatch} || undef,
                    ConfigChange   => $ACL->{ConfigChange} || undef,
                    StopAfterMatch => $ACL->{StopAfterMatch},
                    ValidID        => $ACL->{ValidID} || 1,
                    UserID         => $Self->{UserID},
                );

                if ($Success) {
                    push @AddedACLs, $ACL->{Name};
                }
                else {
                    push @ACLErrors, $ACL->{Name};
                }
            }
        }

        my $UpdatedACLsStrg = join( ', ', @UpdatedACLs ) || '';
        my $AddedACLsStrg   = join( ', ', @AddedACLs )   || '';
        my $ACLErrorsStrg   = join( ', ', @ACLErrors )   || '';

        if ($AddedACLsStrg) {
            push @{ $Param{NotifyData} }, {
                Info => 'The following ACLs have been added successfully: ' . $AddedACLsStrg,
            };
        }
        if ($UpdatedACLsStrg) {
            push @{ $Param{NotifyData} }, {
                Info => 'The following ACLs have been updated successfully: ' . $UpdatedACLsStrg,
            };
        }
        if ($ACLErrorsStrg) {
            push @{ $Param{NotifyData} }, {
                Priority => 'Error',
                Info     => 'There where errors adding/updating the following ACLs: '
                    . $ACLErrorsStrg
                    . '. Please check the log file for more information.',
            };
        }

        if ( ( $UpdatedACLsStrg || $AddedACLsStrg ) && !$SynchronizedMessageVisible ) {

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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
        my $ACLID = $Self->{ACLObject}->ACLAdd(
            Name           => $ACLData->{Name},
            Comment        => $ACLData->{Comment},
            Description    => $ACLData->{Description},
            StopAfterMatch => $ACLData->{StopAfterMatch},
            ValidID        => $ACLData->{ValidID},
            UserID         => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ACLID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the ACL",
            );
        }

        # redirect to edit screen
        return $Self->{LayoutObject}
            ->Redirect( OP => "Action=$Self->{Action};Subaction=ACLEdit;ID=$ACLID" );
    }

    # ------------------------------------------------------------ #
    # ACLEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLEdit' ) {

        # check for ACLID
        if ( !$ACLID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ACLID!",
            );
        }

        # get ACL data
        my $ACLData = $Self->{ACLObject}->ACLGet(
            ID     => $ACLID,
            UserID => $Self->{UserID},
        );

        # check for valid ACL data
        if ( !IsHashRefWithData($ACLData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for ACLID $ACLID",
            );
        }

        if ( $ACLData->{ConfigMatch} ) {
            $ACLData->{ConfigMatch} = $Self->{JSONObject}->Encode(
                Data => $ACLData->{ConfigMatch},
            );
        }

        if ( $ACLData->{ConfigChange} ) {
            $ACLData->{ConfigChange} = $Self->{JSONObject}->Encode(
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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
        my $Success = $Self->{ACLObject}->ACLUpdate(
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
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the ACL",
            );
        }

        if ( $Self->{ParamObject}->GetParam( Param => 'ContinueAfterSave' ) eq '1' ) {

            # if the user would like to continue editing the ACL, just redirect to the edit screen
            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=AdminACL;Subaction=ACLEdit;ID=$ACLID"
            );
        }
        else {

            # otherwise return to overview
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
    }

    # ------------------------------------------------------------ #
    # Sync
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLDeploy' ) {

        my $Location
            = $Self->{ConfigObject}->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

        my $ACLDump = $Self->{ACLObject}->ACLDump(
            ResultType => 'FILE',
            Location   => $Location,
            UserID     => $Self->{UserID},
        );

        if ($ACLDump) {

            my $Success = $Self->{ACLObject}->ACLsNeedSyncReset();

            if ($Success) {
                return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
            }
            else {

                # show error if can't set state
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "There was an error setting the entity sync status.",
                );
            }
        }
        else {

            # show error if can't synch
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error synchronizing the ACLs.",
            );
        }
    }

    # ------------------------------------------------------------ #
    # ACLDelete AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLDelete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check for ACLID
        return if !$ACLID;

        my $CheckResult = $Self->_CheckACLDelete( ID => $ACLID );

        my $JSON;
        if ( $CheckResult->{Success} ) {

            my $Success = $Self->{ACLObject}->ACLDelete(
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
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    %DeleteResult,
                },
            );
        }
        else {

            # build JSON output
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    %{$CheckResult},
                },
            );
        }

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ACLExport
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ACLExport' ) {

        my $ACLID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        my $ACLData;
        my $ACLSingleData;
        my $Filename = 'Export_ACL.yml';

        if ($ACLID) {

            $ACLSingleData = $Self->{ACLObject}->ACLGet(
                ID     => $ACLID,
                UserID => 1,
            );

            if ( !$ACLSingleData || !IsHashRefWithData($ACLSingleData) ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "There was an error getting data for ACL with ID " . $ACLID,
                );
            }

            my $ACLName = $ACLSingleData->{Name};
            $ACLName =~ s{[^a-zA-Z0-9-_]}{_}xmsg;    # cleanup name for saving

            $Filename = 'Export_ACL_' . $ACLName . '.yml';
            $ACLData  = [$ACLSingleData];
        }
        else {

            $ACLData = $Self->{ACLObject}->ACLListGet(
                UserID => 1,
                ValidIDs => [ '1', '2' ],
            );
        }

        # convert the ACL data hash to string
        my $ACLDataYAML = $Self->{YAMLObject}->Dump( Data => $ACLData );

        # send the result to the browser
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Self->{LayoutObject}->{Charset},
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
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get ACL data
        my $ACLData = $Self->{ACLObject}->ACLGet(
            ID     => $ACLID,
            UserID => $Self->{UserID},
        );
        if ( !$ACLData ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Unknown ACL $ACLID!",
            );
        }

        # create new ACL name
        my $ACLName =
            $ACLData->{Name}
            . ' ('
            . $Self->{LayoutObject}->{LanguageObject}->Get('Copy')
            . ')';

        # otherwise save configuration and return to overview screen
        my $ACLID = $Self->{ACLObject}->ACLAdd(
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
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the ACL",
            );
        }

        # return to overview
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
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

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                %{$Notification},
            );
        }
    }

    # get ACL list
    my $ACLList = $Self->{ACLObject}->ACLList( UserID => $Self->{UserID} );

    if ( IsHashRefWithData($ACLList) ) {

        # sort data numerically
        my @ACLIDsSorted = sort { $ACLList->{$a} cmp $ACLList->{$b} } keys %{$ACLList};

        # get each ACLs data
        for my $ACLID (@ACLIDsSorted) {

            my $ACLData = $Self->{ACLObject}->ACLGet(
                ID     => $ACLID,
                UserID => $Self->{UserID},
            );

            # set the valid state
            $ACLData->{ValidID}
                = $Self->{ValidObject}->ValidLookup( ValidID => $ACLData->{ValidID} );

            # print each ACL in overview table
            $Self->{LayoutObject}->Block(
                Name => 'ACLRow',
                Data => {
                    %{$ACLData},
                },
            );
        }
    }
    else {

        # print no data found message
        $Self->{LayoutObject}->Block(
            Name => 'ACLNoDataRow',
            Data => {},
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminACL',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get ACL information
    my $ACLData = $Param{ACLData} || {};

    # decide wether to show delete button
    if ( $Param{Action} eq 'Edit' && $ACLData && $ACLData->{ValidID} ne '1' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ACLDeleteAction',
            Data => {
                %{$ACLData},
            },
        );
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $ACLData->{ValidID} || $ValidList{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    my $ACLKeysLevel1Match = $Self->{ConfigObject}->Get('ACLKeysLevel1Match') || {};
    $Param{ACLKeysLevel1Match} = $Self->{LayoutObject}->BuildSelection(
        Data         => $ACLKeysLevel1Match,
        Name         => 'ItemAdd',
        Class        => 'ItemAdd ItemAddLevel1',
        ID           => 'ItemAddLevel1Match',
        TreeView     => 1,
        PossibleNone => 1,
        Translation  => 0,
    );

    my $ACLKeysLevel1Change = $Self->{ConfigObject}->Get('ACLKeysLevel1Change') || {};
    $Param{ACLKeysLevel1Change} = $Self->{LayoutObject}->BuildSelection(
        Data         => $ACLKeysLevel1Change,
        Name         => 'ItemAdd',
        Class        => 'ItemAdd ItemAddLevel1',
        ID           => 'ItemAddLevel1Change',
        TreeView     => 1,
        PossibleNone => 1,
        Translation  => 0,
    );

    my $ACLKeysLevel2Possible = $Self->{ConfigObject}->Get('ACLKeysLevel2::Possible') || {};
    $Param{ACLKeysLevel2Possible} = $Self->{LayoutObject}->BuildSelection(
        Data         => $ACLKeysLevel2Possible,
        Name         => 'ItemAdd',
        ID           => 'Possible',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2PossibleNot = $Self->{ConfigObject}->Get('ACLKeysLevel2::PossibleNot') || {};
    $Param{ACLKeysLevel2PossibleNot} = $Self->{LayoutObject}->BuildSelection(
        Data         => $ACLKeysLevel2PossibleNot,
        Name         => 'ItemAdd',
        ID           => 'PossibleNot',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2Properties = $Self->{ConfigObject}->Get('ACLKeysLevel2::Properties') || {};
    $Param{ACLKeysLevel2Properties} = $Self->{LayoutObject}->BuildSelection(
        Data         => $ACLKeysLevel2Properties,
        Name         => 'ItemAdd',
        ID           => 'Properties',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    my $ACLKeysLevel2PropertiesDatabase
        = $Self->{ConfigObject}->Get('ACLKeysLevel2::PropertiesDatabase') || {};
    $Param{ACLKeysLevel2PropertiesDatabase} = $Self->{LayoutObject}->BuildSelection(
        Data         => $ACLKeysLevel2PropertiesDatabase,
        Name         => 'ItemAdd',
        ID           => 'PropertiesDatabase',
        Class        => 'ItemAdd LevelToBeAdded',
        Translation  => 0,
        PossibleNone => 1,
    );

    $Param{ACLKeysLevel4Prefixes} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            ''         => 'Standard',
            '[RegExp]' => 'Regex',
            '[regexp]' => 'Regex (ignore case)',
        },
        Name           => 'ItemPrefix',
        Class          => 'ItemPrefix',
        ID             => 'Prefixes',
        Sort           => 'IndividualKey',
        SortIndividual => [ '', '[RegExp]', '[regexp]' ],
        Translation    => 0,
    );

    # get list of all possible dynamic fields
    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldList(
        ObjectType => 'Ticket',
        ResultType => 'HASH',
    );
    my %DynamicFieldNames = reverse %{$DynamicFieldList};
    my %DynamicFields;
    for my $DynamicFieldName ( sort keys %DynamicFieldNames ) {
        $DynamicFields{ 'DynamicField_' . $DynamicFieldName } = $DynamicFieldName;
    }
    $Param{ACLKeysLevel3DynamicFields} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%DynamicFields,
        Name         => 'NewDataKeyDropdown',
        Class        => 'NewDataKeyDropdown',
        ID           => 'DynamicField',
        Translation  => 0,
        PossibleNone => 1,
    );

    # get list of all possible actions
    my @PossibleActionsList;
    my $ACLKeysLevel3Actions
        = $Self->{ConfigObject}->Get('ACLKeysLevel3::Actions') || [];

    for my $Key ( sort keys %{$ACLKeysLevel3Actions} ) {
        push @PossibleActionsList, @{ $ACLKeysLevel3Actions->{$Key} };
    }

    $Param{ACLKeysLevel3Actions} = $Self->{LayoutObject}->BuildSelection(
        Data         => \@PossibleActionsList,
        Name         => 'NewDataKeyDropdown',
        Class        => 'NewDataKeyDropdown Boolean',
        ID           => 'Action',
        Translation  => 0,
        PossibleNone => 1,
    );

    if ( defined $ACLData->{StopAfterMatch} && $ACLData->{StopAfterMatch} == 1 ) {
        $Param{Checked} = 'checked="checked"';
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                %{$Notification},
            );
        }
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminACL$Param{Action}",
        Data         => {
            %Param,
            %{$ACLData},
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
        qw( Name EntityID Comment Description StopAfterMatch ValidID ConfigMatch ConfigChange )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    if ( $GetParam->{ConfigMatch} ) {
        $GetParam->{ConfigMatch} = $Self->{JSONObject}->Decode(
            Data => $GetParam->{ConfigMatch},
        );
        if ( !IsHashRefWithData( $GetParam->{ConfigMatch} ) ) {
            $GetParam->{ConfigMatch} = undef;
        }
    }

    if ( $GetParam->{ConfigChange} ) {
        $GetParam->{ConfigChange} = $Self->{JSONObject}->Decode(
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
    my $ACLData = $Self->{ACLObject}->ACLGet(
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
