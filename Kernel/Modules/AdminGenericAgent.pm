# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminGenericAgent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # secure mode message (don't allow this action till secure mode is enabled)
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        return $LayoutObject->SecureMode();
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get config data
    $Self->{Profile}    = $ParamObject->GetParam( Param => 'Profile' )    || '';
    $Self->{OldProfile} = $ParamObject->GetParam( Param => 'OldProfile' ) || '';
    $Self->{Subaction}  = $ParamObject->GetParam( Param => 'Subaction' )  || '';

    # get needed objects
    my $CheckItemObject    = $Kernel::OM->Get('Kernel::System::CheckItem');
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    # ---------------------------------------------------------- #
    # run a generic agent job -> "run now"
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'RunNow' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Run = $GenericAgentObject->JobRun(
            Job    => $Self->{Profile},
            UserID => 1,
        );

        # redirect
        if ($Run) {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action}",
            );
        }

        # redirect
        return $LayoutObject->ErrorScreen();
    }

    if ( $Self->{Subaction} eq 'Run' ) {

        return $Self->_MaskRun();
    }

    # --------------------------------------------------------------- #
    # save generic agent job and show a view of all affected tickets
    # --------------------------------------------------------------- #
    # show result site
    if ( $Self->{Subaction} eq 'UpdateAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my ( %GetParam, %Errors );

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get single params
        for my $Parameter (
            qw(TicketNumber Title MIMEBase_From MIMEBase_To MIMEBase_Cc MIMEBase_Subject MIMEBase_Body CustomerID
            CustomerUserLogin Agent SearchInArchive
            NewTitle
            NewCustomerID NewPendingTime NewPendingTimeType NewCustomerUserLogin
            NewStateID NewQueueID NewPriorityID NewOwnerID NewResponsibleID
            NewTypeID NewServiceID NewSLAID
            NewNoteFrom NewNoteSubject NewNoteBody NewNoteIsVisibleForCustomer NewNoteTimeUnits NewModule
            NewParamKey1 NewParamKey2 NewParamKey3 NewParamKey4
            NewParamValue1 NewParamValue2 NewParamValue3 NewParamValue4
            NewParamKey5 NewParamKey6 NewParamKey7 NewParamKey8
            NewParamValue5 NewParamValue6 NewParamValue7 NewParamValue8
            NewLockID NewDelete NewCMD NewSendNoNotification NewArchiveFlag
            ScheduleLastRun Valid
            )
            )
        {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );

            # remove leading and trailing blank spaces
            if ( $GetParam{$Parameter} ) {
                $CheckItemObject->StringClean(
                    StringRef => \$GetParam{$Parameter},
                );
            }
        }

        for my $Type (
            qw(Time ChangeTime CloseTime LastChangeTime LastCloseTime TimePending EscalationTime EscalationResponseTime EscalationUpdateTime EscalationSolutionTime)
            )
        {
            my $Key = $Type . 'SearchType';
            $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
        }
        for my $Type (
            qw(
            TicketCreate           TicketChange
            TicketClose            TicketLastChange
            TicketLastClose
            TicketPending
            TicketEscalation       TicketEscalationResponse
            TicketEscalationUpdate TicketEscalationSolution
            )
            )
        {
            for my $Attribute (
                qw(
                TimePoint TimePointFormat TimePointStart
                TimeStart TimeStartDay TimeStartMonth TimeStopMonth
                TimeStop TimeStopDay TimeStopYear TimeStartYear
                )
                )
            {
                my $Key = $Type . $Attribute;
                $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
            }

            # validate data
            for my $Attribute (
                qw(TimeStartDay TimeStartMonth TimeStopMonth TimeStopDay)
                )
            {
                my $Key = $Type . $Attribute;

                if ( $GetParam{$Key} ) {
                    $GetParam{$Key} = sprintf( '%02d', $GetParam{$Key} );
                }
            }
        }

        # get dynamic fields to set from web request
        # to store dynamic fields profile data
        my %DynamicFieldValues;

        # get dynamic field backend object
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # extract the dynamic field value from the web request
            my $DynamicFieldValue = $DynamicFieldBackendObject->EditFieldValueGet(
                DynamicFieldConfig      => $DynamicFieldConfig,
                ParamObject             => $ParamObject,
                LayoutObject            => $LayoutObject,
                ReturnTemplateStructure => 1,
            );

            # set the complete value structure in GetParam to store it later in the Generic Agent Job
            if ( IsHashRefWithData($DynamicFieldValue) ) {
                %DynamicFieldValues = ( %DynamicFieldValues, %{$DynamicFieldValue} );
            }
        }

        # get array params
        for my $Parameter (
            qw(LockIDs StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs ResponsibleIDs
            TypeIDs ServiceIDs SLAIDs
            ScheduleDays ScheduleMinutes ScheduleHours
            EventValues
            )
            )
        {

            # get search array params (get submitted params)
            if ( $ParamObject->GetArray( Param => $Parameter ) ) {
                @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
            }
        }

        # get Dynamic fields for search from web request
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # extract the dynamic field value from the web request
                my $DynamicFieldValue = $DynamicFieldBackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    ReturnProfileStructure => 1,
                    LayoutObject           => $LayoutObject,
                    Type                   => $Preference->{Type},
                );

                # set the complete value structure in %DynamicFieldValues to store it later in the
                # Generic Agent Job
                if ( IsHashRefWithData($DynamicFieldValue) ) {
                    %DynamicFieldValues = ( %DynamicFieldValues, %{$DynamicFieldValue} );
                }
            }
        }

        # check needed data
        if ( !$Self->{Profile} ) {
            $Errors{ProfileInvalid} = 'ServerError';
        }

        # Check length of fields from Add Note section.
        if ( length $GetParam{NewNoteFrom} > 200 ) {
            $Errors{NewNoteFromServerError} = 'ServerError';
        }
        if ( length $GetParam{NewNoteSubject} > 200 ) {
            $Errors{NewNoteSubjectServerError} = 'ServerError';
        }
        if ( length $GetParam{NewNoteBody} > 200 ) {
            $Errors{NewNoteBodyServerError} = 'ServerError';
        }

        # Check if ticket selection contains stop words
        my %StopWordsServerErrors = $Self->_StopWordsServerErrorsGet(
            MIMEBase_From    => $GetParam{MIMEBase_From},
            MIMEBase_To      => $GetParam{MIMEBase_To},
            MIMEBase_Cc      => $GetParam{MIMEBase_Cc},
            MIMEBase_Subject => $GetParam{MIMEBase_Subject},
            MIMEBase_Body    => $GetParam{MIMEBase_Body},
        );
        %Errors = ( %Errors, %StopWordsServerErrors );

        # if no errors occurred
        if ( !%Errors ) {

            if ( $Self->{OldProfile} ) {

                # remove/clean up old profile stuff
                $GenericAgentObject->JobDelete(
                    Name   => $Self->{OldProfile},
                    UserID => $Self->{UserID},
                );
            }

            # insert new profile params
            my $JobAddResult = $GenericAgentObject->JobAdd(
                Name => $Self->{Profile},
                Data => {
                    %GetParam,
                    %DynamicFieldValues,
                },
                UserID => $Self->{UserID},
            );

            if ($JobAddResult) {

                # if the user would like to continue editing the generic agent job, just redirect to the edit screen
                if (
                    defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                    && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                    )
                {
                    my $Profile = $Self->{Profile} || '';
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=Update;Profile=$Profile" );
                }
                else {

                    # otherwise return to overview
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
                }

            }
            else {
                $Errors{ProfileInvalid}    = 'ServerError';
                $Errors{ProfileInvalidMsg} = 'AddError';
            }
        }

        # something went wrong
        my $JobDataReference;
        $JobDataReference = $Self->_MaskUpdate(
            %Param,
            %GetParam,
            %DynamicFieldValues,
            %Errors,
            StopWordsAlreadyChecked => 1,
        );

        # generate search mask
        my $Output = $LayoutObject->Header(
            Title => Translatable('Edit'),
        );
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminGenericAgent',
            Data         => $JobDataReference,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit generic agent job
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Update' ) {
        my $JobDataReference;
        $JobDataReference = $Self->_MaskUpdate(%Param);

        # generate search mask
        my $Output = $LayoutObject->Header(
            Title => Translatable('Edit'),
        );

        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminGenericAgent',
            Data         => $JobDataReference,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # Update dynamic fields for generic agent job by AJAX
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'AddDynamicField' ) {
        my $DynamicFieldID = $ParamObject->GetParam( Param => 'DynamicFieldID' );
        my $Type           = $ParamObject->GetParam( Param => 'Type' ) || '';
        my $SelectedValue  = $ParamObject->GetParam( Param => 'SelectedValue' );
        my $Widget         = $ParamObject->GetParam( Param => 'Widget' );

        my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        my %JobData;
        if ( $Self->{Profile} ) {
            %JobData = $Kernel::OM->Get('Kernel::System::GenericAgent')->JobGet(
                Name => $Self->{Profile},
            );
        }
        $JobData{Profile}   = $Self->{Profile};
        $JobData{Subaction} = $Self->{Subaction};

        my $DynamicFieldHTML;
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # Get field HTML.
        if ( $Widget eq 'Select' ) {
            $DynamicFieldHTML = $DynamicFieldBackendObject->SearchFieldRender(
                DynamicFieldConfig     => $DynamicFieldConfig,
                Profile                => \%JobData,
                LayoutObject           => $LayoutObject,
                ConfirmationCheckboxes => 1,
                Type                   => $Type,
            );
        }
        elsif ( $Widget eq 'Update' ) {
            my $PossibleValuesFilter;

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # Get PossibleValues.
                my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # Check if field has PossibleValues property in its configuration.
                if ( IsHashRefWithData($PossibleValues) ) {

                    # Convert possible values key => value to key => key for ACLs using a Hash slice.
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                    # Set possible values filter from ACLs.
                    my $ACL = $TicketObject->TicketAcl(
                        Action        => $Self->{Action},
                        Type          => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        ReturnType    => 'Ticket',
                        ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data          => \%AclData,
                        UserID        => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # Convert Filer key => key back to key => value using map.
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }
            $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                LayoutObject         => $LayoutObject,
                ParamObject          => $ParamObject,
                UseDefaultValue      => 0,
                OverridePossibleNone => 1,
                ConfirmationNeeded   => 1,
                NoIgnoreField        => 1,
                Template             => \%JobData,
                MaxLength            => 200,
            );
        }

        $DynamicFieldHTML->{ID} = $SelectedValue;

        my $Output = $LayoutObject->JSONEncode(
            Data => $DynamicFieldHTML,
        );

        # Send JSON response.
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $Output,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ---------------------------------------------------------- #
    # delete an generic agent job
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Delete' && $Self->{Profile} ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        if ( $Self->{Profile} ) {
            $GenericAgentObject->JobDelete(
                Name   => $Self->{Profile},
                UserID => $Self->{UserID},
            );
        }
    }

    # ---------------------------------------------------------- #
    # overview of all generic agent jobs
    # ---------------------------------------------------------- #
    $LayoutObject->Block(
        Name => 'ActionList',
    );
    $LayoutObject->Block(
        Name => 'ActionAdd',
    );
    $LayoutObject->Block(
        Name => 'Filter',
    );
    $LayoutObject->Block(
        Name => 'Overview',
    );

    my %Jobs = $GenericAgentObject->JobList();

    # if there are any data, it is shown
    if (%Jobs) {
        my $Counter = 1;
        for my $JobKey ( sort keys %Jobs ) {
            my %JobData = $GenericAgentObject->JobGet( Name => $JobKey );

            # css setting and text for valid or invalid jobs
            $JobData{ShownValid} = $JobData{Valid} ? 'valid' : 'invalid';

            # separate each search result line by using several css
            $LayoutObject->Block(
                Name => 'Row',
                Data => {%JobData},
            );
        }
    }

    # otherwise a no data found message is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    # generate search mask
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericAgent',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _MaskUpdate {
    my ( $Self, %Param ) = @_;

    my %JobData;

    if ( $Self->{Profile} ) {

        # get db job data
        %JobData = $Kernel::OM->Get('Kernel::System::GenericAgent')->JobGet(
            Name => $Self->{Profile},
        );
    }
    $JobData{Profile}   = $Self->{Profile};
    $JobData{Subaction} = $Self->{Subaction};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my %ShownUsers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $JobData{OwnerStrg} = $LayoutObject->BuildSelection(
        Data        => \%ShownUsers,
        Name        => 'OwnerIDs',
        Multiple    => 1,
        Size        => 5,
        Translation => 0,
        SelectedID  => $JobData{OwnerIDs},
        Class       => 'Modernize',
    );
    $JobData{NewOwnerStrg} = $LayoutObject->BuildSelection(
        Data        => \%ShownUsers,
        Name        => 'NewOwnerID',
        Size        => 5,
        Multiple    => 0,
        Translation => 0,
        SelectedID  => $JobData{NewOwnerID},
        Class       => 'Modernize',
    );
    my %Hours;
    for my $Number ( 0 .. 23 ) {
        $Hours{$Number} = sprintf( "%02d", $Number );
    }
    $JobData{ScheduleHoursList} = $LayoutObject->BuildSelection(
        Data        => \%Hours,
        Name        => 'ScheduleHours',
        Size        => 6,
        Multiple    => 1,
        Translation => 0,
        SelectedID  => $JobData{ScheduleHours},
        Class       => 'Modernize',
    );
    my %Minutes;
    for my $Number ( 0 .. 59 ) {
        $Minutes{$Number} = sprintf( "%02d", $Number );
    }
    $JobData{ScheduleMinutesList} = $LayoutObject->BuildSelection(
        Data        => \%Minutes,
        Name        => 'ScheduleMinutes',
        Size        => 6,
        Multiple    => 1,
        Translation => 0,
        SelectedID  => $JobData{ScheduleMinutes},
        Class       => 'Modernize',
    );
    $JobData{ScheduleDaysList} = $LayoutObject->BuildSelection(
        Data => {
            1 => Translatable('Mon'),
            2 => Translatable('Tue'),
            3 => Translatable('Wed'),
            4 => Translatable('Thu'),
            5 => Translatable('Fri'),
            6 => Translatable('Sat'),
            0 => Translatable('Sun'),
        },
        Sort       => 'NumericKey',
        Name       => 'ScheduleDays',
        Size       => 7,
        Multiple   => 1,
        SelectedID => $JobData{ScheduleDays},
        Class      => 'Modernize',
    );

    # get state object
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    $JobData{StatesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $StateObject->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'StateIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $JobData{StateIDs},
        Class      => 'Modernize',
    );
    $JobData{NewStatesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $StateObject->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'NewStateID',
        Size       => 5,
        Multiple   => 0,
        SelectedID => $JobData{NewStateID},
        Class      => 'Modernize',
    );
    $JobData{NewPendingTimeTypeStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => 60,
                Value => Translatable('minute(s)'),
            },
            {
                Key   => 3600,
                Value => Translatable('hour(s)'),
            },
            {
                Key   => 86400,
                Value => Translatable('day(s)'),
            },
            {
                Key   => 2592000,
                Value => Translatable('month(s)'),
            },
            {
                Key   => 31536000,
                Value => Translatable('year(s)'),
            },

        ],
        Name        => 'NewPendingTimeType',
        Size        => 1,
        Multiple    => 0,
        SelectedID  => $JobData{NewPendingTimeType},
        Translation => 1,
        Title       => $LayoutObject->{LanguageObject}->Translate('Time unit'),
        Class       => 'Modernize',
    );

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    $JobData{QueuesStrg} = $LayoutObject->AgentQueueListOption(
        Data               => { $QueueObject->GetAllQueues(), },
        Size               => 5,
        Multiple           => 1,
        Name               => 'QueueIDs',
        SelectedIDRefArray => $JobData{QueueIDs},
        TreeView           => $TreeView,
        OnChangeSubmit     => 0,
        Class              => 'Modernize',
    );
    $JobData{NewQueuesStrg} = $LayoutObject->AgentQueueListOption(
        Data           => { $QueueObject->GetAllQueues(), },
        Size           => 5,
        Multiple       => 0,
        Name           => 'NewQueueID',
        SelectedID     => $JobData{NewQueueID},
        TreeView       => $TreeView,
        OnChangeSubmit => 0,
        Class          => 'Modernize',
    );

    # get priority object
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    $JobData{PrioritiesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $PriorityObject->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'PriorityIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $JobData{PriorityIDs},
        Class      => 'Modernize',
    );
    $JobData{NewPrioritiesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $PriorityObject->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'NewPriorityID',
        Size       => 5,
        Multiple   => 0,
        SelectedID => $JobData{NewPriorityID},
        Class      => 'Modernize',
    );

    # get time option
    my %Map = (
        TicketCreate             => 'Time',
        TicketChange             => 'ChangeTime',
        TicketClose              => 'CloseTime',
        TicketLastChange         => 'LastChangeTime',
        TicketLastClose          => 'LastCloseTime',
        TicketPending            => 'TimePending',
        TicketEscalation         => 'EscalationTime',
        TicketEscalationResponse => 'EscalationResponseTime',
        TicketEscalationUpdate   => 'EscalationUpdateTime',
        TicketEscalationSolution => 'EscalationSolutionTime',
    );
    for my $Type (
        qw(
        TicketCreate           TicketClose
        TicketChange           TicketLastChange
        TicketLastClose
        TicketPending
        TicketEscalation       TicketEscalationResponse
        TicketEscalationUpdate TicketEscalationSolution
        )
        )
    {
        my $SearchType = $Map{$Type} . 'SearchType';
        if ( !$JobData{$SearchType} ) {
            $JobData{ $SearchType . '::None' } = 'checked="checked"';
        }
        elsif ( $JobData{$SearchType} eq 'TimePoint' ) {
            $JobData{ $SearchType . '::TimePoint' } = 'checked="checked"';
        }
        elsif ( $JobData{$SearchType} eq 'TimeSlot' ) {
            $JobData{ $SearchType . '::TimeSlot' } = 'checked="checked"';
        }

        my %Counter;
        for my $Number ( 1 .. 60 ) {
            $Counter{$Number} = sprintf( "%02d", $Number );
        }

        # time
        $JobData{ $Type . 'TimePoint' } = $LayoutObject->BuildSelection(
            Data        => \%Counter,
            Name        => $Type . 'TimePoint',
            SelectedID  => $JobData{ $Type . 'TimePoint' },
            Translation => 0,
        );
        $JobData{ $Type . 'TimePointStart' } = $LayoutObject->BuildSelection(
            Data => {
                Last   => Translatable('within the last ...'),
                Next   => Translatable('within the next ...'),
                Before => Translatable('more than ... ago'),
            },
            Name       => $Type . 'TimePointStart',
            SelectedID => $JobData{ $Type . 'TimePointStart' } || 'Last',
        );
        $JobData{ $Type . 'TimePointFormat' } = $LayoutObject->BuildSelection(
            Data => {
                minute => Translatable('minute(s)'),
                hour   => Translatable('hour(s)'),
                day    => Translatable('day(s)'),
                week   => Translatable('week(s)'),
                month  => Translatable('month(s)'),
                year   => Translatable('year(s)'),
            },
            Name       => $Type . 'TimePointFormat',
            SelectedID => $JobData{ $Type . 'TimePointFormat' },
        );
        $JobData{ $Type . 'TimeStart' } = $LayoutObject->BuildDateSelection(
            %JobData,
            Prefix   => $Type . 'TimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( 60 * 60 * 24 ) * 30,
            Validate => 1,
        );
        $JobData{ $Type . 'TimeStop' } = $LayoutObject->BuildDateSelection(
            %JobData,
            Prefix   => $Type . 'TimeStop',
            Format   => 'DateInputFormat',
            Validate => 1,
        );
    }

    $JobData{DeleteOption} = $LayoutObject->BuildSelection(
        Data       => $ConfigObject->Get('YesNoOptions'),
        Name       => 'NewDelete',
        SelectedID => $JobData{NewDelete} || 0,
        Class      => 'Modernize',
    );
    $JobData{ValidOption} = $LayoutObject->BuildSelection(
        Data       => $ConfigObject->Get('YesNoOptions'),
        Name       => 'Valid',
        SelectedID => defined( $JobData{Valid} ) ? $JobData{Valid} : 1,
        Class      => 'Modernize',
    );

    # get lock object
    my $LockObject = $Kernel::OM->Get('Kernel::System::Lock');

    $JobData{LockOption} = $LayoutObject->BuildSelection(
        Data => {
            $LockObject->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'LockIDs',
        Multiple   => 1,
        Size       => 3,
        SelectedID => $JobData{LockIDs},
        Class      => 'Modernize',
    );
    $JobData{NewLockOption} = $LayoutObject->BuildSelection(
        Data => {
            $LockObject->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'NewLockID',
        Size       => 3,
        Multiple   => 0,
        SelectedID => $JobData{NewLockID},
        Class      => 'Modernize',
    );

    # Show server errors if ticket selection contains stop words
    my %StopWordsServerErrors;
    if ( !$Param{StopWordsAlreadyChecked} ) {
        %StopWordsServerErrors = $Self->_StopWordsServerErrorsGet(
            MIMEBase_From    => $JobData{MIMEBase_From},
            MIMEBase_To      => $JobData{MIMEBase_To},
            MIMEBase_Cc      => $JobData{MIMEBase_Cc},
            MIMEBase_Subject => $JobData{MIMEBase_Subject},
            MIMEBase_Body    => $JobData{MIMEBase_Body},
        );
    }

    # REMARK: we changed the wording "Send no notifications" to
    # "Send agent/customer notifications on changes" in frontend.
    # But the backend code is still the same (compatibility).
    # Because of this case we changed 1=>'Yes' to 1=>'No'
    $JobData{SendNoNotificationOption} = $LayoutObject->BuildSelection(
        Data => {
            '1' => Translatable('No'),
            '0' => Translatable('Yes'),
        },
        Name       => 'NewSendNoNotification',
        SelectedID => $JobData{NewSendNoNotification} || 0,
        Class      => 'Modernize',
    );

    $JobData{AllowCustomScriptExecution} = $ConfigObject->Get('Ticket::GenericAgentAllowCustomScriptExecution') || 0;
    $JobData{AllowCustomModuleExecution} = $ConfigObject->Get('Ticket::GenericAgentAllowCustomModuleExecution') || 0;

    $LayoutObject->Block(
        Name => 'ActionList',
    );
    $LayoutObject->Block(
        Name => 'ActionOverview',
    );
    $LayoutObject->Block(
        Name => 'Edit',
        Data => {
            %JobData,
            %Param,
            %StopWordsServerErrors,
        },
    );

    # check for profile errors
    if ( defined $Param{ProfileInvalid} ) {
        $Param{ProfileInvalidMsg} //= '';
        $LayoutObject->Block(
            Name => 'ProfileInvalidMsg' . $Param{ProfileInvalidMsg},
        );
    }

    # check if the schedule options are selected
    if (
        !defined $JobData{ScheduleDays}->[0]
        || !defined $JobData{ScheduleHours}->[0]
        || !defined $JobData{ScheduleMinutes}->[0]
        )
    {
        $LayoutObject->Block(
            Name => 'JobScheduleWarning',
        );
    }

    # build type string
    if ( $ConfigObject->Get('Ticket::Type') ) {
        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
            UserID => $Self->{UserID},
        );
        $JobData{TypesStrg} = $LayoutObject->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeIDs',
            SelectedID  => $JobData{TypeIDs},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
            Class       => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'TicketType',
            Data => \%JobData,
        );
        $JobData{NewTypesStrg} = $LayoutObject->BuildSelection(
            Data        => \%Type,
            Name        => 'NewTypeID',
            SelectedID  => $JobData{NewTypeID},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 0,
            Translation => 0,
            Class       => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'NewTicketType',
            Data => \%JobData,
        );
    }

    # build service string
    if ( $ConfigObject->Get('Ticket::Service') ) {

        # get list type
        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            Valid        => 1,
            KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren') // 0,
            UserID       => $Self->{UserID},
        );
        my %NewService = %Service;
        $JobData{ServicesStrg} = $LayoutObject->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceIDs',
            SelectedID  => $JobData{ServiceIDs},
            Size        => 5,
            Multiple    => 1,
            TreeView    => $TreeView,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );
        $JobData{NewServicesStrg} = $LayoutObject->BuildSelection(
            Data        => \%NewService,
            Name        => 'NewServiceID',
            SelectedID  => $JobData{NewServiceID},
            Size        => 5,
            Multiple    => 0,
            TreeView    => $TreeView,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );
        my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => $Self->{UserID},
        );
        $JobData{SLAsStrg} = $LayoutObject->BuildSelection(
            Data        => \%SLA,
            Name        => 'SLAIDs',
            SelectedID  => $JobData{SLAIDs},
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );
        $JobData{NewSLAsStrg} = $LayoutObject->BuildSelection(
            Data        => \%SLA,
            Name        => 'NewSLAID',
            SelectedID  => $JobData{NewSLAID},
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 0,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'TicketService',
            Data => {%JobData},
        );
        $LayoutObject->Block(
            Name => 'NewTicketService',
            Data => {%JobData},
        );
    }

    # ticket responsible string
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        $JobData{ResponsibleStrg} = $LayoutObject->BuildSelection(
            Data        => \%ShownUsers,
            Name        => 'ResponsibleIDs',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            SelectedID  => $JobData{ResponsibleIDs},
            Class       => 'Modernize',
        );
        $JobData{NewResponsibleStrg} = $LayoutObject->BuildSelection(
            Data        => \%ShownUsers,
            Name        => 'NewResponsibleID',
            Size        => 5,
            Multiple    => 0,
            Translation => 0,
            SelectedID  => $JobData{NewResponsibleID},
            Class       => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'TicketResponsible',
            Data => {%JobData},
        );
        $LayoutObject->Block(
            Name => 'NewTicketResponsible',
            Data => {%JobData},
        );
    }

    # prepare archive
    if ( $ConfigObject->Get('Ticket::ArchiveSystem') ) {

        $JobData{'SearchInArchiveStrg'} = $LayoutObject->BuildSelection(
            Data => {
                ArchivedTickets    => Translatable('Archived tickets'),
                NotArchivedTickets => Translatable('Unarchived tickets'),
                AllTickets         => Translatable('All tickets'),
            },
            Name       => 'SearchInArchive',
            SelectedID => $JobData{SearchInArchive} || 'AllTickets',
            Class      => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'SearchInArchive',
            Data => {%JobData},
        );

        $JobData{'NewArchiveFlagStrg'} = $LayoutObject->BuildSelection(
            Data => {
                'y' => Translatable('archive tickets'),
                'n' => Translatable('restore tickets from archive'),
            },
            Name         => 'NewArchiveFlag',
            PossibleNone => 1,
            SelectedID   => $JobData{NewArchiveFlag} || '',
            Class        => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'NewArchiveFlag',
            Data => {%JobData},
        );
    }

    # create dynamic field HTML for set with historical data options
    my $PrintDynamicFieldsSearchHeader = 1;

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @AddDynamicFields;
    my %DynamicFieldsJS;

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get search field preferences
        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        # Translate dynamic field label.
        my $TranslatedDynamicFieldLabel = $LayoutObject->{LanguageObject}->Translate(
            $DynamicFieldConfig->{Label},
        );

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            # Translate the suffix.
            my $TranslatedSuffix = $LayoutObject->{LanguageObject}->Translate(
                $Preference->{LabelSuffix},
            ) || '';

            if ($TranslatedSuffix) {
                $TranslatedSuffix = ' (' . $TranslatedSuffix . ')';
            }

            my $Key  = 'Search_DynamicField_' . $DynamicFieldConfig->{Name} . $Preference->{Type};
            my $Text = $TranslatedDynamicFieldLabel . $TranslatedSuffix;

            # Save all dynamic fields for JS.
            $DynamicFieldsJS{$Key} = {
                ID   => $DynamicFieldConfig->{ID},
                Type => $Preference->{Type},
                Text => $Text,
            };

            # Decide if dynamic field go to add fields dropdown or selected fields area.
            if ( defined $JobData{$Key} ) {

                # Get field HTML.
                my $DynamicFieldHTML = $DynamicFieldBackendObject->SearchFieldRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => \%JobData,
                    DefaultValue =>
                        $Self->{Config}->{Defaults}->{DynamicField}->{ $DynamicFieldConfig->{Name} },
                    LayoutObject           => $LayoutObject,
                    ConfirmationCheckboxes => 1,
                    Type                   => $Preference->{Type},
                );

                next PREFERENCE if !IsHashRefWithData($DynamicFieldHTML);

                $LayoutObject->Block(
                    Name => 'SelectedDynamicFields',
                    Data => {
                        Label => $DynamicFieldHTML->{Label},
                        Field => $DynamicFieldHTML->{Field},
                        ID    => $Key,
                    },
                );
            }
            else {
                push @AddDynamicFields, {
                    Key   => $Key,
                    Value => $Text,
                };
            }
        }
    }

    my $DynamicFieldsStrg = $LayoutObject->BuildSelection(
        PossibleNone => 1,
        Data         => \@AddDynamicFields,
        Name         => 'AddDynamicFields',
        Multiple     => 0,
        Class        => 'Modernize',
    );
    $LayoutObject->Block(
        Name => 'AddDynamicFields',
        Data => {
            DynamicFieldsStrg => $DynamicFieldsStrg,
        },
    );

    # create dynamic field HTML for set with historical data options
    my $PrintDynamicFieldsEditHeader = 1;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my @AddNewDynamicFields;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # Check if field is Attachment type ( from OTRSDynamicFieldAttachment )
        #   this field is not updatable by Generic Agent
        my $IsAttachement = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsAttachement',
        );
        next DYNAMICFIELD if $IsAttachement;

        my $PossibleValuesFilter;

        my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );

        if ($IsACLReducible) {

            # get PossibleValues
            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData($PossibleValues) ) {

                # convert possible values key => value to key => key for ACLs using a Hash slice
                my %AclData = %{$PossibleValues};
                @AclData{ keys %AclData } = keys %AclData;

                # get ticket object
                my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                # set possible values filter from ACLs
                my $ACL = $TicketObject->TicketAcl(
                    Action        => $Self->{Action},
                    Type          => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    ReturnType    => 'Ticket',
                    ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data          => \%AclData,
                    UserID        => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $TicketObject->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                        keys %Filter;
                }
            }
        }

        my $Key  = 'DynamicField_' . $DynamicFieldConfig->{Name};
        my $Used = 0;
        if ( defined $JobData{ $Key . 'Used' } ) {
            $Key .= 'Used';
            $Used = 1;
        }

        # Save all new dynamic fields for JS.
        $DynamicFieldsJS{$Key} = {
            ID   => $DynamicFieldConfig->{ID},
            Text => $DynamicFieldConfig->{Name},
        };

        # Decide if dynamic field go to add fields dropdown or selected fields area.
        #
        # First statement part - if we have a defined value.
        #
        # Second statement part - if we have empty value which can be valid if
        # current dynamic field has empty value in its configuration (PossibleNone).
        #
        # Third statement part - it is for Date, DateTime and similar fields which has
        # a checkbox "flag" for including its value to GA config. It must return
        # false if checkbox is unchecked (in DB value is 0, not empty string or undef),
        # otherwise must be true (for other dynamic fields or checked checkbox).
        if (
            defined $JobData{$Key}
            && (
                $DynamicFieldConfig->{Config}->{PossibleNone}
                || $JobData{$Key} ne ''
            )
            && ( !$Used || $JobData{$Key} )
            )
        {

            # Get field HTML.
            my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                LayoutObject         => $LayoutObject,
                ParamObject          => $ParamObject,
                UseDefaultValue      => 0,
                OverridePossibleNone => 1,
                ConfirmationNeeded   => 1,
                NoIgnoreField        => 1,
                Template             => \%JobData,
                MaxLength            => 200,
            );

            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldHTML);

            $LayoutObject->Block(
                Name => 'SelectedNewDynamicFields',
                Data => {
                    Label => $DynamicFieldHTML->{Label},
                    Field => $DynamicFieldHTML->{Field},
                    ID    => $Key,
                },
            );
        }
        else {
            push @AddNewDynamicFields, {
                Key   => $Key,
                Value => $DynamicFieldConfig->{Name},
            };
        }
    }

    my $NewDynamicFieldsStrg = $LayoutObject->BuildSelection(
        PossibleNone => 1,
        Data         => \@AddNewDynamicFields,
        Name         => 'AddNewDynamicFields',
        Multiple     => 0,
        Class        => 'Modernize',
    );
    $LayoutObject->Block(
        Name => 'AddNewDynamicFields',
        Data => {
            NewDynamicFieldsStrg => $NewDynamicFieldsStrg,
        },
    );
    $LayoutObject->AddJSData(
        Key   => 'DynamicFieldsJS',
        Value => \%DynamicFieldsJS,
    );

    # get event object
    my $EventObject = $Kernel::OM->Get('Kernel::System::Event');

    # get registered event triggers from the config
    my %RegisteredEvents = $EventObject->EventList(
        ObjectTypes => [ 'Ticket', 'Article' ],
    );

    # create the event triggers table
    for my $Event ( @{ $JobData{EventValues} || [] } ) {

        # set the event type ( event object like Article or Ticket)
        my $EventType;
        EVENTTYPE:
        for my $Type ( sort keys %RegisteredEvents ) {
            if ( grep { $_ eq $Event } @{ $RegisteredEvents{$Type} } ) {
                $EventType = $Type;
                last EVENTTYPE;
            }
        }

        # paint each event row in event triggers table
        $LayoutObject->Block(
            Name => 'EventRow',
            Data => {
                Event     => $Event,
                EventType => $EventType || '-',
            },
        );
    }

    my @EventTypeList;
    my $SelectedEventType = $ParamObject->GetParam( Param => 'EventType' ) || 'Ticket';

    # create event trigger selectors (one for each type)
    TYPE:
    for my $Type ( sort keys %RegisteredEvents ) {

        # refresh event list for each event type

        # paint each selector
        my $EventStrg = $LayoutObject->BuildSelection(
            PossibleNone => 0,
            Data         => $RegisteredEvents{$Type} || [],
            Name         => $Type . 'Event',
            Sort         => 'AlphanumericValue',
            PossibleNone => 0,
            Class        => 'Modernize EventList GenericInterfaceSpacing',
            Title        => $LayoutObject->{LanguageObject}->Translate('Event'),
        );

        $LayoutObject->Block(
            Name => 'EventAdd',
            Data => {
                EventStrg => $EventStrg,
            },
        );

        push @EventTypeList, $Type;
    }

    # create event type selector
    my $EventTypeStrg = $LayoutObject->BuildSelection(
        Data          => \@EventTypeList,
        Name          => 'EventType',
        Sort          => 'AlphanumericValue',
        SelectedValue => $SelectedEventType,
        PossibleNone  => 0,
        Class         => 'Modernize',
        Title         => $LayoutObject->{LanguageObject}->Translate('Type'),
    );
    $LayoutObject->Block(
        Name => 'EventTypeStrg',
        Data => {
            EventTypeStrg => $EventTypeStrg,
        },
    );

    return \%JobData;
}

sub _MaskRun {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %JobData;

    if ( $Self->{Profile} ) {
        %JobData = $Kernel::OM->Get('Kernel::System::GenericAgent')->JobGet( Name => $Self->{Profile} );
        if ( exists $JobData{SearchInArchive} && $JobData{SearchInArchive} eq 'ArchivedTickets' ) {
            $JobData{ArchiveFlags} = ['y'];
        }
        if ( exists $JobData{SearchInArchive} && $JobData{SearchInArchive} eq 'AllTickets' ) {
            $JobData{ArchiveFlags} = [ 'y', 'n' ];
        }
    }
    else {
        $LayoutObject->FatalError(
            Message => Translatable('Need Profile!'),
        );
    }
    $JobData{Profile} = $Self->{Profile};
    $Param{Subaction} = $Self->{Subaction};
    $Param{Profile}   = $Self->{Profile};

    # dynamic fields search parameters for ticket search
    my %DynamicFieldSearchParameters;

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get search field preferences
        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            if (
                !$JobData{
                    'Search_DynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . $Preference->{Type}
                }
                )
            {
                next PREFERENCE;
            }

            # extract the dynamic field value from the profile
            my $SearchParameter = $DynamicFieldBackendObject->SearchFieldParameterBuild(
                DynamicFieldConfig => $DynamicFieldConfig,
                Profile            => \%JobData,
                LayoutObject       => $LayoutObject,
                Type               => $Preference->{Type},
            );

            # set search parameter
            if ( defined $SearchParameter ) {
                $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                    = $SearchParameter->{Parameter};
            }
        }
    }

    # remove residual dynamic field data from job definition
    # they are passed through dedicated variable anyway
    PARAM_NAME:
    for my $ParamName ( sort keys %JobData ) {
        next PARAM_NAME if !( $ParamName =~ /^DynamicField_/ );
        delete $JobData{$ParamName};
    }

    # get needed objects
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

    # perform ticket search
    my $GenericAgentTicketSearch = $ConfigObject->Get("Ticket::GenericAgentTicketSearch") || {};
    my $Counter                  = $TicketObject->TicketSearch(
        Result          => 'COUNT',
        SortBy          => 'Age',
        OrderBy         => 'Down',
        UserID          => 1,
        Limit           => 60_000,
        ConditionInline => $GenericAgentTicketSearch->{ExtendedSearchCondition},
        %JobData,
        %DynamicFieldSearchParameters,
    ) || 0;

    my @TicketIDs = $TicketObject->TicketSearch(
        Result          => 'ARRAY',
        SortBy          => 'Age',
        OrderBy         => 'Down',
        UserID          => 1,
        Limit           => 30,
        ConditionInline => $GenericAgentTicketSearch->{ExtendedSearchCondition},
        %JobData,
        %DynamicFieldSearchParameters,
    );

    $LayoutObject->Block(
        Name => 'ActionList',
    );
    $LayoutObject->Block(
        Name => 'ActionOverview',
    );
    $LayoutObject->Block(
        Name => 'Result',
        Data => {
            %Param,
            Name        => $Self->{Profile},
            AffectedIDs => $Counter,
        },
    );

    my $RunLimit = $ConfigObject->Get('Ticket::GenericAgentRunLimit');
    if ( $Counter > $RunLimit ) {
        $LayoutObject->Block(
            Name => 'RunLimit',
            Data => {
                Counter  => $Counter,
                RunLimit => $RunLimit,
            },
        );
    }

    if (@TicketIDs) {
        $LayoutObject->Block(
            Name => 'ResultBlock',
        );
        for my $TicketID (@TicketIDs) {

            # Get ticket data.
            my %Ticket = $TicketObject->TicketGet(
                TicketID      => $TicketID,
                DynamicFields => 0,
            );

            # Get article data.
            my @Articles = $ArticleObject->ArticleList(
                TicketID  => $TicketID,
                OnlyFirst => 1,
            );
            my %Article;
            for my $Article (@Articles) {
                %Article = $ArticleObject->BackendForArticle( %{$Article} )->ArticleGet( %{$Article} );
            }

            my %Data = ( %Ticket, %Article );

            # Set missing information for tickets without articles.
            if ( !%Article ) {
                $Data{Subject} = $Data{Title};
            }

            $Data{Age} = $LayoutObject->CustomerAge(
                Age   => $Data{Age},
                Space => ' ',
            );
            $Data{css} = "PriorityID-$Data{PriorityID}";

            # user info
            my %UserInfo = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                User => $Data{Owner},
            );
            $Data{UserLastname}  = $UserInfo{UserLastname};
            $Data{UserFirstname} = $UserInfo{UserFirstname};
            $Data{UserFullname}  = $UserInfo{UserFullname};
            $LayoutObject->Block(
                Name => 'Ticket',
                Data => \%Data,
            );
        }

        if ( $JobData{NewDelete} ) {
            $LayoutObject->Block(
                Name => 'DeleteWarning',
            );
        }
    }

    # HTML search mask output
    my $Output = $LayoutObject->Header(
        Title => Translatable('Affected Tickets'),
    );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericAgent',
        Data         => \%Param,
    );

    # build footer
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _StopWordsServerErrorsGet {
    my ( $Self, %Param ) = @_;

    if ( !%Param ) {
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
            Message => Translatable('Got no values to check.'),
        );
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my %StopWordsServerErrors;
    if ( !$ArticleObject->SearchStringStopWordsUsageWarningActive() ) {
        return %StopWordsServerErrors;
    }

    my %SearchStrings;

    FIELD:
    for my $Field ( sort keys %Param ) {
        next FIELD if !defined $Param{$Field};
        next FIELD if !length $Param{$Field};

        $SearchStrings{$Field} = $Param{$Field};
    }

    if (%SearchStrings) {

        my $StopWords = $ArticleObject->SearchStringStopWordsFind(
            SearchStrings => \%SearchStrings,
        );

        FIELD:
        for my $Field ( sort keys %{$StopWords} ) {
            next FIELD if !defined $StopWords->{$Field};
            next FIELD if ref $StopWords->{$Field} ne 'ARRAY';
            next FIELD if !@{ $StopWords->{$Field} };

            $StopWordsServerErrors{ $Field . 'Invalid' } = 'ServerError';
            $StopWordsServerErrors{ $Field . 'InvalidTooltip' }
                = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
                ->Translate('Please remove the following words because they cannot be used for the ticket selection:')
                . ' '
                . join( ',', sort @{ $StopWords->{$Field} } );
        }
    }

    return %StopWordsServerErrors;
}

1;
