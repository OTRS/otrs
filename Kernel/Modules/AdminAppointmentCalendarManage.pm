# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminAppointmentCalendarManage;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::AsynchronousExecutor);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # Certain search parameters for ticket appointments should be stored as scalars, not array refs.
    $Self->{SearchParamScalar} = [
        'MIMEBase_From',
        'MIMEBase_To',
        'MIMEBase_Cc',
        'MIMEBase_Subject',
        'MIMEBase_Body',
        'MIMEBase_AttachmentName',
    ];

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get names of all parameters
    my @ParamNames = $ParamObject->GetParamNames();

    # get params
    my %GetParam;
    PARAMNAME:
    for my $Key (@ParamNames) {

        # Queue, OwnerIDs and ResponsibleIDs are multiple selection fields, get array instead.
        if (
            $Key    =~ /^QueueID_/
            || $Key =~ /^SearchParam_[0-9a-f]+_OwnerIDs$/
            || $Key =~ /^SearchParam_[0-9a-f]+_ResponsibleIDs$/
            )
        {
            my @ParamArray = $ParamObject->GetArray( Param => $Key );
            $GetParam{$Key} = \@ParamArray;
            next PARAMNAME;
        }

        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # Get user's permissions to associated modules which are displayed as links.
    for my $Module (qw(AgentAppointmentCalendarOverview AdminAppointmentImport)) {
        my $ModuleGroups = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')
            ->{$Module}->{Group} // [];

        if ( IsArrayRefWithData($ModuleGroups) ) {
            MODULE_GROUP:
            for my $ModuleGroup ( @{$ModuleGroups} ) {
                my $HasPermission = $GroupObject->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $ModuleGroup,
                    Type      => 'rw',
                );
                if ($HasPermission) {
                    $Param{ModulePermissions}->{$Module} = 1;
                    last MODULE_GROUP;
                }
            }
        }

        # Always allow links if no groups are specified.
        else {
            $Param{ModulePermissions}->{$Module} = 1;
        }
    }

    if ( $Self->{Subaction} eq 'New' ) {

        my $GroupSelection     = $Self->_GroupSelectionGet();
        my $ColorPalette       = $Self->_ColorPaletteGet();
        my $ValidSelection     = $Self->_ValidSelectionGet();
        my %TicketAppointments = $Self->_TicketAppointments();

        $LayoutObject->Block(
            Name => 'CalendarEdit',
            Data => {
                GroupID      => $GroupSelection,
                ValidID      => $ValidSelection,
                Subaction    => 'StoreNew',
                Color        => $ColorPalette->[ int rand( scalar @{$ColorPalette} ) ],
                Title        => Translatable('Add new Calendar'),
                WidgetStatus => 'Collapsed',
                %TicketAppointments,
            },
        );

        $LayoutObject->AddJSData(
            Key   => 'CalendarColorPalette',
            Value => $ColorPalette,
        );

        $Param{Action} = 'New';
    }
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {

        my %Error;

        # check name
        if ( !$GetParam{CalendarName} ) {
            $Error{'CalendarNameInvalid'} = 'ServerError';
        }
        else {

            # check if there is a calendar with same name
            my %Calendar = $CalendarObject->CalendarGet(
                CalendarName => $GetParam{CalendarName},
            );

            if (%Calendar) {
                $Error{CalendarNameInvalid} = "ServerError";
                $Error{CalendarNameExists}  = 1;
            }
        }

        $GetParam{TicketAppointments} = $Self->_GetTicketAppointmentParams(%GetParam);

        # Get queue create permissions for the user.
        my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'create',
        );

        my @ValidIDs = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        # Queue field in ticket appointments is mandatory, check if it's present and valid.
        for my $Rule ( @{ $GetParam{TicketAppointments} } ) {
            if ( defined $Rule->{QueueID} && IsArrayRefWithData( $Rule->{QueueID} ) ) {

                QUEUE_ID:
                for my $QueueID ( sort @{ $Rule->{QueueID} || [] } ) {
                    my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

                    if (
                        !grep { $_ eq $QueueData{ValidID} } @ValidIDs
                        || !$UserGroups{ $QueueData{GroupID} }
                        )
                    {
                        $Error{ $Rule->{RuleID} }->{QueueIDInvalid} = 'ServerError';
                        last QUEUE_ID;
                    }
                }
            }
            else {
                $Error{ $Rule->{RuleID} }->{QueueIDInvalid} = 'ServerError';
            }
        }

        if (%Error) {

            # get selections
            my $GroupSelection     = $Self->_GroupSelectionGet(%GetParam);
            my $ColorPalette       = $Self->_ColorPaletteGet();
            my $ValidSelection     = $Self->_ValidSelectionGet(%GetParam);
            my %TicketAppointments = $Self->_TicketAppointments();

            # get rule count
            my $RuleCount = scalar @{ $GetParam{TicketAppointments} || [] };

            $LayoutObject->Block(
                Name => 'CalendarEdit',
                Data => {
                    %Error,
                    %GetParam,
                    GroupID      => $GroupSelection,
                    ValidID      => $ValidSelection,
                    Subaction    => 'StoreNew',
                    Title        => Translatable('Add new Calendar'),
                    WidgetStatus => $RuleCount ? 'Expanded' : 'Collapsed',
                    %TicketAppointments,
                },
            );

            $LayoutObject->AddJSData(
                Key   => 'CalendarColor',
                Value => $GetParam{Color},
            );

            $LayoutObject->AddJSData(
                Key   => 'CalendarColorPalette',
                Value => $ColorPalette,
            );

            $LayoutObject->AddJSData(
                Key   => 'CalendarRuleCount',
                Value => $RuleCount,
            );

            # Show all ticket appointment rule blocks.
            my $RuleNumber = 1;
            my @RuleIDs;
            for my $Rule ( @{ $GetParam{TicketAppointments} || [] } ) {
                $Rule->{Error} = $Error{ $Rule->{RuleID} };
                my %TicketAppointmentRule = $Self->_TicketAppointments( %{$Rule} );
                $LayoutObject->Block(
                    Name => 'TicketAppointmentRule',
                    Data => {
                        RuleNumber => $RuleNumber++,
                        %{$Rule},
                        %TicketAppointmentRule,
                    },
                );

                # Show any search parameter blocks too.
                $Self->_ShowTicketAppointmentParams( %{$Rule} );

                # Save rule ID for button initialization.
                push @RuleIDs, $Rule->{RuleID};
            }
            $LayoutObject->AddJSData(
                Key   => 'RuleIDs',
                Value => \@RuleIDs,
            );

            $Param{Action} = 'New';

            return $Self->_Mask(%Param);
        }

        # create calendar
        my %Calendar = $CalendarObject->CalendarCreate(
            %GetParam,
            UserID => $Self->{UserID},
        );

        if ( !%Calendar ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('System was unable to create Calendar!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # Process ticket appointments in async call to core module method.
        $Self->AsyncCall(
            ObjectName     => 'Kernel::System::Calendar',
            FunctionName   => 'TicketAppointmentProcessCalendar',
            FunctionParams => {
                CalendarID => $Calendar{CalendarID},
            },
        );

        # If the user would like to continue editing the calendar, just redirect to the edit screen.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=Edit;CalendarID=$GetParam{CalendarID}"
            );
        }
        else {

            # Otherwise return to overview.
            return $LayoutObject->Redirect( OP => "Action=AdminAppointmentCalendarManage" );
        }
    }
    elsif ( $Self->{Subaction} eq 'Edit' ) {

        # get data
        my %GetParam;
        $GetParam{CalendarID} = $ParamObject->GetParam( Param => 'CalendarID' ) || '';

        if ( !$GetParam{CalendarID} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('No CalendarID!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # get calendar data
        my %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $GetParam{CalendarID},
            UserID     => $Self->{UserID},
        );

        if ( !%Calendar ) {

            # fake message
            return $LayoutObject->ErrorScreen(
                Message => Translatable('You have no access to this calendar!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # get selections
        my $GroupSelection     = $Self->_GroupSelectionGet(%Calendar);
        my $ColorPalette       = $Self->_ColorPaletteGet();
        my $ValidSelection     = $Self->_ValidSelectionGet(%Calendar);
        my %TicketAppointments = $Self->_TicketAppointments();

        my $RuleCount = scalar @{ $Calendar{TicketAppointments} || [] };

        $LayoutObject->Block(
            Name => 'CalendarEdit',
            Data => {
                %Calendar,
                GroupID      => $GroupSelection,
                ValidID      => $ValidSelection,
                Subaction    => 'Update',
                Title        => Translatable('Edit Calendar'),
                WidgetStatus => $RuleCount ? 'Expanded' : 'Collapsed',
                %TicketAppointments,
            },
        );

        $LayoutObject->AddJSData(
            Key   => 'CalendarColor',
            Value => $Calendar{Color},
        );

        $LayoutObject->AddJSData(
            Key   => 'CalendarColorPalette',
            Value => $ColorPalette,
        );

        $LayoutObject->AddJSData(
            Key   => 'CalendarRuleCount',
            Value => $RuleCount,
        );

        # Show all ticket appointment rule blocks.
        my $RuleNumber = 1;
        my @RuleIDs;
        for my $Rule ( @{ $Calendar{TicketAppointments} || [] } ) {
            my %TicketAppointmentRule = $Self->_TicketAppointments( %{$Rule} );
            $LayoutObject->Block(
                Name => 'TicketAppointmentRule',
                Data => {
                    RuleNumber => $RuleNumber++,
                    %{$Rule},
                    %TicketAppointmentRule,
                },
            );

            # Show any search parameter blocks too.
            $Self->_ShowTicketAppointmentParams( %{$Rule} );

            # Save rule ID for button initialization.
            push @RuleIDs, $Rule->{RuleID};
        }
        $LayoutObject->AddJSData(
            Key   => 'RuleIDs',
            Value => \@RuleIDs,
        );

        $Param{Action} = 'Update';
        $Param{Name}   = $Calendar{CalendarName};
    }
    elsif ( $Self->{Subaction} eq 'Update' ) {

        my %Error;

        # check needed stuff
        for my $Needed (qw(CalendarID CalendarName Color GroupID)) {
            if ( !$GetParam{$Needed} ) {
                $Error{ $Needed . 'Invalid' } = 'ServerError';

                return $Self->_Mask( %Param, %GetParam, %Error );
            }
        }

        # check if there is already a calendar with same name
        my %Calendar = $CalendarObject->CalendarGet(
            CalendarName => $GetParam{CalendarName},
            UserID       => $Self->{UserID},
        );

        if ( defined $Calendar{CalendarID} && $Calendar{CalendarID} != $GetParam{CalendarID} ) {
            $Error{CalendarNameInvalid} = "ServerError";
            $Error{CalendarNameExists}  = 1;
        }

        $GetParam{TicketAppointments} = $Self->_GetTicketAppointmentParams(%GetParam);

        # Get queue create permissions for the user.
        my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'create',
        );

        my @ValidIDs = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        # Queue field in ticket appointments is mandatory, check if it's present and valid.
        for my $Rule ( @{ $GetParam{TicketAppointments} } ) {
            if ( defined $Rule->{QueueID} && IsArrayRefWithData( $Rule->{QueueID} ) ) {

                QUEUE_ID:
                for my $QueueID ( sort @{ $Rule->{QueueID} || [] } ) {
                    my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

                    if (
                        !grep { $_ eq $QueueData{ValidID} } @ValidIDs
                        || !$UserGroups{ $QueueData{GroupID} }
                        )
                    {
                        $Error{ $Rule->{RuleID} }->{QueueIDInvalid} = 'ServerError';
                        last QUEUE_ID;
                    }
                }
            }
            else {
                $Error{ $Rule->{RuleID} }->{QueueIDInvalid} = 'ServerError';
            }
        }

        if (%Error) {

            # get selections
            my $GroupSelection     = $Self->_GroupSelectionGet(%GetParam);
            my $ColorPalette       = $Self->_ColorPaletteGet();
            my $ValidSelection     = $Self->_ValidSelectionGet(%GetParam);
            my %TicketAppointments = $Self->_TicketAppointments();

            my $RuleCount = scalar @{ $GetParam{TicketAppointments} || [] };

            $LayoutObject->Block(
                Name => 'CalendarEdit',
                Data => {
                    %Error,
                    %GetParam,
                    GroupID      => $GroupSelection,
                    ValidID      => $ValidSelection,
                    Subaction    => 'Update',
                    Title        => Translatable('Edit Calendar'),
                    WidgetStatus => $RuleCount ? 'Expanded' : 'Collapsed',
                    %TicketAppointments,
                },
            );

            $LayoutObject->AddJSData(
                Key   => 'CalendarColor',
                Value => $Calendar{Color},
            );

            $LayoutObject->AddJSData(
                Key   => 'CalendarColorPalette',
                Value => $ColorPalette,
            );

            $LayoutObject->AddJSData(
                Key   => 'CalendarRuleCount',
                Value => $RuleCount,
            );

            # Show all ticket appointment rule blocks.
            my $RuleNumber = 1;
            my @RuleIDs;
            for my $Rule ( @{ $GetParam{TicketAppointments} || [] } ) {
                $Rule->{Error} = $Error{ $Rule->{RuleID} };
                my %TicketAppointmentRule = $Self->_TicketAppointments( %{$Rule} );
                $LayoutObject->Block(
                    Name => 'TicketAppointmentRule',
                    Data => {
                        RuleNumber => $RuleNumber++,
                        %{$Rule},
                        %TicketAppointmentRule,
                    },
                );

                # Show any search parameter blocks too.
                $Self->_ShowTicketAppointmentParams( %{$Rule} );

                # Save rule ID for button initialization.
                push @RuleIDs, $Rule->{RuleID};
            }
            $LayoutObject->AddJSData(
                Key   => 'RuleIDs',
                Value => \@RuleIDs,
            );

            $Param{Action} = 'Update';
            $Param{Name}   = $Calendar{CalendarName};

            return $Self->_Mask(%Param);
        }

        # update calendar
        my $Success = $CalendarObject->CalendarUpdate(
            %GetParam,
            UserID => $Self->{UserID},
        );

        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Error updating the calendar!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # Process ticket appointments in async call to core module method.
        $Self->AsyncCall(
            ObjectName     => 'Kernel::System::Calendar',
            FunctionName   => 'TicketAppointmentProcessCalendar',
            FunctionParams => {
                CalendarID => $GetParam{CalendarID},
            },
        );

        # If the user would like to continue editing the calendar, just redirect to the edit screen.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=Edit;CalendarID=$GetParam{CalendarID}"
            );
        }
        else {

            # Otherwise return to overview.
            return $LayoutObject->Redirect( OP => "Action=AdminAppointmentCalendarManage" );
        }
    }
    elsif ( $Self->{Subaction} eq 'CalendarImport' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get the uploaded file content
        my $FormID      = $ParamObject->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );
        my $Content = $UploadStuff{Content};

        # check for overwriting option
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        # extract the team data from the uploaded file
        my $CalendarData = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $Content );
        if ( ref $CalendarData ne 'HASH' ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable("Couldn't read calendar configuration file."),
                Comment => Translatable('Please make sure your file is valid.'),
            );
        }

        # import the calendar
        my $Success = $CalendarObject->CalendarImport(
            Data                      => $CalendarData,
            OverwriteExistingEntities => $OverwriteExistingEntities,
            UserID                    => $Self->{UserID},
        );

        if ( !$Success ) {
            $Param{NotifyMessage} = {
                Priority => Translatable('Error'),
                Info     => Translatable('Could not import the calendar!'),
            };
        }
        else {
            $Param{NotifyMessage} = {
                Info => Translatable('Calendar imported!'),
            };
        }

        %Param = $Self->_Overview(%Param);
    }

    elsif ( $Self->{Subaction} eq 'CalendarExport' ) {

        # check for CalendarID
        my $CalendarID = $ParamObject->GetParam( Param => 'CalendarID' ) || '';
        if ( !$CalendarID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need CalendarID!'),
            );
        }

        # get calendar data
        my %CalendarData = $CalendarObject->CalendarExport(
            CalendarID => $CalendarID,
            UserID     => $Self->{UserID},
        );

        if ( !IsHashRefWithData( \%CalendarData ) ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Could not retrieve data for given CalendarID'),
            );
        }

        # convert the calendar data hash to string
        my $CalendarDataYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => \%CalendarData );

        # prepare calendar name to be part of the filename
        my $CalendarName = $CalendarData{CalendarData}->{CalendarName};
        $CalendarName =~ s/\s+/_/g;

        # send the result to the browser
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $CalendarDataYAML,
            Type        => 'attachment',
            Filename    => 'Export_Calendar_' . $CalendarName . '.yml',
            NoCache     => 1,
        );
    }

    else {

        if ( $ParamObject->GetParam( Param => 'ImportAppointmentsSuccess' ) || '' ) {
            $Param{NotifyMessage} = {
                Info => $LayoutObject->{LanguageObject}->Translate(
                    'Successfully imported %s appointment(s) to calendar %s.',
                    $ParamObject->GetParam( Param => 'Count' ) || 0,
                    $ParamObject->GetParam( Param => 'Name' )  || '',
                ),
            };
        }

        %Param = $Self->_Overview(%Param);
    }

    return $Self->_Mask(%Param);
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

    # get all calendars user has RW access to
    my @Calendars = $CalendarObject->CalendarList(
        UserID     => $Self->{UserID},
        Permission => 'rw',
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'CalendarFilter',
    );

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Title => Translatable('Calendars'),
        },
    );

    $Param{ValidCount} = 0;
    for my $Calendar (@Calendars) {

        # group name
        $Calendar->{Group} = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
            GroupID => $Calendar->{GroupID},
        );

        # valid text
        $Calendar->{Valid} = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
            ValidID => $Calendar->{ValidID},
        );
        if ( $Calendar->{ValidID} == 1 ) {
            $Param{ValidCount}++;
        }

        # get access tokens
        $Calendar->{AccessToken} = $CalendarObject->GetAccessToken(
            CalendarID => $Calendar->{CalendarID},
            UserLogin  => $Self->{UserLogin},
        );

        $LayoutObject->Block(
            Name => 'Calendar',
            Data => {
                %{$Calendar},
            },
        );
    }

    if ( scalar @Calendars == 0 ) {
        $LayoutObject->Block(
            Name => 'CalendarNoDataRow',
        );
    }
    $Param{Overview} = 1;

    $LayoutObject->Block(
        Name => 'MainActions',
        Data => {
            %Param,
        },
    );

    $LayoutObject->Block( Name => 'ActionImport' );

    return %Param;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # output page
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    if ( $Param{NotifyMessage} ) {
        $Output .= $LayoutObject->Notify(
            %{ $Param{NotifyMessage} },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminAppointmentCalendarManage',
        Data         => {
            Title => Translatable('Edit Calendar'),
            %Param,
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GroupSelectionGet {
    my ( $Self, %Param ) = @_;

    # get list of groups where user has RW permissions
    my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Self->{UserID},
        Type   => 'rw',
    );

    my $GroupSelection = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data        => \%GroupList,
        Name        => 'GroupID',
        SelectedID  => $Param{GroupID} || '',
        Translation => 0,
        Class       => 'Modernize Validate_Required',
    );

    return $GroupSelection;
}

sub _ColorPaletteGet {
    my ( $Self, %Param ) = @_;

    # get color palette
    my $CalendarColors = $Kernel::OM->Get('Kernel::Config')->Get('AppointmentCalendar::CalendarColors') || [
        '#000000', '#1E1E1E', '#3A3A3A', '#545453', '#6E6E6E', '#878687', '#888787', '#A09FA0',
        '#B8B8B8', '#D0D0D0', '#E8E8E8', '#FFFFFF', '#891100', '#894800', '#888501', '#458401',
        '#028401', '#018448', '#008688', '#004A88', '#001888', '#491A88', '#891E88', '#891648',
        '#FF2101', '#FF8802', '#FFFA03', '#83F902', '#05F802', '#03F987', '#00FDFF', '#008CFF',
        '#002EFF', '#8931FF', '#FF39FF', '#FF2987', '#FF726E', '#FFCE6E', '#FFFB6D', '#CEFA6E',
        '#68F96E', '#68FDFF', '#68FBD0', '#6ACFFF', '#6E76FF', '#D278FF', '#FF7AFF', '#FF7FD3',
    ];

    return $CalendarColors;
}

sub _ValidSelectionGet {
    my ( $Self, %Param ) = @_;

    my %Valid          = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my $ValidSelection = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data       => \%Valid,
        Name       => 'ValidID',
        ID         => 'ValidID',
        Class      => 'Modernize Validate_Required',
        SelectedID => $Param{ValidID} || 1,
        Title      => Translatable("Valid"),
    );

    return $ValidSelection;
}

sub _UserSelectionGet {
    my ( $Self, %Param ) = @_;

    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList( Type => 'Long' );

    my $UserSelection = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data => \%UserList,
        Name => ( $Param{RuleID} && $Param{ParamName} )
        ? 'SearchParam_' . $Param{RuleID} . '_' . $Param{ParamName}
        : 'SearchParamUser',
        Multiple   => 1,
        Class      => 'SearchParam Modernize Validate_Required',
        SelectedID => $Param{ParamValue} || [],
    );

    # Add param name as data attribute for later reference in JS.
    if ( $Param{ParamName} ) {
        $UserSelection =~ s/<select/<select data-param="$Param{ParamName}"/;
    }

    return $UserSelection;
}

sub _TicketAppointments {
    my ( $Self, %Param ) = @_;

    # get field id suffix
    my $FieldID = '';
    if ( $Param{RuleID} ) {
        $FieldID = '_' . $Param{RuleID};
    }

    my %TicketAppointments;

    # get create permission queues
    my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Self->{UserID},
        Type   => 'create',
    );

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    my %Queues = $QueueObject->QueueList();
    my %AvailableQueues;

    # build selection string
    QUEUEID:
    for my $QueueID ( sort keys %Queues ) {
        my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

        # permission check, can we create new tickets in queue
        next QUEUEID if !$UserGroups{ $QueueData{GroupID} };

        $AvailableQueues{$QueueID} = $QueueData{Name};
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $TicketAppointments{QueueIDStrg} = $LayoutObject->AgentQueueListOption(
        Class              => 'Validate_Required Modernize ' . ( $Param{Error}->{QueueIDInvalid} // '' ),
        Data               => \%AvailableQueues,
        Multiple           => 1,
        Size               => 0,
        Name               => 'QueueID' . $FieldID,
        TreeView           => $TreeView,
        OnChangeSubmit     => 0,
        SelectedIDRefArray => $Param{QueueID},
    );

    # get ticket appointment types
    my $TicketAppointmentConfig = $ConfigObject->Get('AppointmentCalendar::TicketAppointmentType') // {};
    my @AppointmentTypes;
    my @DynamicFieldTypes;

    TYPE:
    for my $TypeKey ( sort keys %{$TicketAppointmentConfig} ) {
        next TYPE if !$TicketAppointmentConfig->{$TypeKey}->{Key};
        next TYPE if !$TicketAppointmentConfig->{$TypeKey}->{Name};

        if ( $TypeKey =~ /DynamicField$/ ) {
            my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

            # get list of all valid date and date/time dynamic fields
            my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
                ObjectType => 'Ticket',
            );

            DYNAMICFIELD:
            for my $DynamicField ( @{$DynamicFieldList} ) {
                if ( $DynamicField->{FieldType} ne 'Date' && $DynamicField->{FieldType} ne 'DateTime' ) {
                    next DYNAMICFIELD;
                }

                push @DynamicFieldTypes, {
                    Key   => sprintf( $TicketAppointmentConfig->{$TypeKey}->{Key},  $DynamicField->{Name} ),
                    Value => sprintf( $TicketAppointmentConfig->{$TypeKey}->{Name}, $DynamicField->{Name} ),
                };
            }

            next TYPE;
        }

        push @AppointmentTypes, {
            Key   => $TicketAppointmentConfig->{$TypeKey}->{Key},
            Value => $TicketAppointmentConfig->{$TypeKey}->{Name},
        };
    }

    my @StartDateTypes = ( @AppointmentTypes, @DynamicFieldTypes );
    $TicketAppointments{StartDateStrg} = $LayoutObject->BuildSelection(
        Class      => 'Modernize',
        Data       => \@StartDateTypes,
        Multiple   => 0,
        Size       => 0,
        Name       => 'StartDate' . $FieldID,
        SelectedID => $Param{StartDate},
    );

    my @EndPlusTypes = (
        {
            Key   => 'Plus_5',
            Value => $LayoutObject->{LanguageObject}->Translate('+5 minutes'),
        },
        {
            Key   => 'Plus_15',
            Value => $LayoutObject->{LanguageObject}->Translate('+15 minutes'),
        },
        {
            Key   => 'Plus_30',
            Value => $LayoutObject->{LanguageObject}->Translate('+30 minutes'),
        },
        {
            Key   => 'Plus_60',
            Value => $LayoutObject->{LanguageObject}->Translate('+1 hour'),
        },
    );

    my @EndDateTypes = ( @EndPlusTypes, @DynamicFieldTypes );
    $TicketAppointments{EndDateStrg} = $LayoutObject->BuildSelection(
        Class      => 'Modernize',
        Data       => \@EndDateTypes,
        Multiple   => 0,
        Size       => 0,
        Name       => 'EndDate' . $FieldID,
        SelectedID => $Param{EndDate},
    );

    my $SearchParamsConfig =
        $ConfigObject->Get('AppointmentCalendar::TicketAppointmentSearchParam') // {};

    # Translate search parameter labels prior to sorting.
    for my $ParamName ( sort keys %{$SearchParamsConfig} ) {
        $SearchParamsConfig->{$ParamName} = $LayoutObject->{LanguageObject}->Translate(
            $SearchParamsConfig->{$ParamName}
        );
    }

    # Sort search parameter list by translated labels.
    my @SearchParams;
    for my $ParamName ( sort { $SearchParamsConfig->{$a} cmp $SearchParamsConfig->{$b} } keys %{$SearchParamsConfig} ) {
        push @SearchParams, {
            Key      => $ParamName,
            Value    => $SearchParamsConfig->{$ParamName},
            Disabled => $Param{SearchParam}->{$ParamName} || 0,
        };
    }

    $TicketAppointments{SearchParamsStrg} = $LayoutObject->BuildSelection(
        Class    => 'SearchParams Modernize',
        Data     => \@SearchParams,
        Multiple => 0,
        Size     => 0,
        Name     => 'SearchParams' . $FieldID,
    );

    $TicketAppointments{SearchParamUser} = $Self->_UserSelectionGet();

    if ( !defined $Param{RuleID} ) {
        $LayoutObject->AddJSData(
            Key   => 'TicketAppointments',
            Value => \%TicketAppointments,
        );
    }

    return %TicketAppointments;
}

sub _GetTicketAppointmentParams {
    my ( $Self, %Param ) = @_;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # create data structure
    my %TicketAppointmentParams;
    for my $Key ( sort keys %Param ) {
        for my $Field (qw(StartDate EndDate QueueID SearchParam)) {
            if ( $Key =~ /^${Field}_([A-Za-z0-9]+)/ ) {
                my $RuleID = $1;

                # if rule id is integer, generate random guid
                if ( IsInteger($RuleID) ) {
                    $TicketAppointmentParams{$RuleID}->{RuleID} = $MainObject->GenerateRandomString(
                        Length     => 32,
                        Dictionary => [ 0 .. 9, 'a' .. 'f' ],    # hexadecimal
                    );
                }

                # otherwise, use it as-is
                else {
                    $TicketAppointmentParams{$RuleID}->{RuleID} = $RuleID;
                }
                if ( $Field eq 'SearchParam' ) {
                    if ( $Key =~ /^SearchParam_${RuleID}_([A-Za-z_]+)$/ ) {
                        my $SearchParam = $1;

                        # Store search params:
                        #   - as scalar, per TicketSearch() documentation
                        #   - as array ref, multiple selection
                        #   - as array ref, single value
                        if ( grep { $SearchParam eq $_ } @{ $Self->{SearchParamScalar} } ) {
                            $TicketAppointmentParams{$RuleID}->{SearchParam}->{$SearchParam} = $Param{$Key};
                        }
                        elsif ( ref $Param{$Key} eq 'ARRAY' ) {
                            $TicketAppointmentParams{$RuleID}->{SearchParam}->{$SearchParam} = $Param{$Key};
                        }
                        else {
                            $TicketAppointmentParams{$RuleID}->{SearchParam}->{$SearchParam} = [ $Param{$Key} ];
                        }
                    }
                }
                else {
                    $TicketAppointmentParams{$RuleID}->{$Field} = $Param{$Key};
                }
            }
        }
    }

    # transform to array
    my @TicketAppointmentData;
    for my $RuleID ( sort keys %TicketAppointmentParams ) {
        push @TicketAppointmentData, $TicketAppointmentParams{$RuleID};
    }

    return \@TicketAppointmentData;
}

sub _ShowTicketAppointmentParams {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $ParamName ( sort keys %{ $Param{SearchParam} } ) {
        my $ParamValue;
        my $ParamStrg;

        if ( grep { $ParamName eq $_ } @{ $Self->{SearchParamScalar} } ) {
            $ParamValue = $Param{SearchParam}->{$ParamName};
        }
        elsif ( ref $Param{SearchParam}->{$ParamName} eq 'ARRAY' ) {
            $ParamValue = $Param{SearchParam}->{$ParamName}->[0] // '';
        }

        # OwnerIDs and ResponsibleIDs are multiple selection user fields.
        if ( $ParamName eq 'OwnerIDs' || $ParamName eq 'ResponsibleIDs' ) {
            $ParamStrg = $Self->_UserSelectionGet(
                ParamName  => $ParamName,
                ParamValue => $Param{SearchParam}->{$ParamName} // [],
                %Param,
            );
        }

        $LayoutObject->Block(
            Name => 'TicketAppointmentRuleSearchParam',
            Data => {
                ParamName  => $ParamName,
                ParamValue => $ParamValue,
                ParamStrg  => $ParamStrg,
                %Param,
            },
        );
    }

    return;
}

1;
