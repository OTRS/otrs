# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Dynamic::TicketSolutionResponseTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::State',
    'Kernel::System::Stats',
    'Kernel::System::Ticket',
    'Kernel::System::DateTime',
    'Kernel::System::Type',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'TicketSolutionResponseTime';
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 0,
    );

    return %Behaviours;
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
    my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
    my $StateObject    = $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');
    my $LockObject     = $Kernel::OM->Get('Kernel::System::Lock');

    my $ValidAgent = 0;
    if (
        defined $ConfigObject->Get('Stats::UseInvalidAgentInStats')
        && ( $ConfigObject->Get('Stats::UseInvalidAgentInStats') == 0 )
        )
    {
        $ValidAgent = 1;
    }

    # Get user list without the out of office message, because of the caching in the statistics
    #   and not meaningful with a date selection.
    my %UserList = $UserObject->UserList(
        Type          => 'Long',
        Valid         => $ValidAgent,
        NoOutOfOffice => 1,
    );

    # get state list
    my %StateList = $StateObject->StateList(
        UserID => 1,
    );

    # get state type list
    my %StateTypeList = $StateObject->StateTypeList(
        UserID => 1,
    );

    # get queue list
    my %QueueList = $QueueObject->GetAllQueues();

    # get priority list
    my %PriorityList = $PriorityObject->PriorityList(
        UserID => 1,
    );

    # get lock list
    my %LockList = $LockObject->LockList(
        UserID => 1,
    );

    my @ObjectAttributes = (
        {
            Name             => Translatable('Evaluation by'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'KindsOfReporting',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedKindsOfReporting(),
            Values           => $Self->_KindsOfReporting(),
        },
        {
            Name             => Translatable('Queue'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'QueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            TreeView         => 1,
            Values           => \%QueueList,
        },
        {
            Name             => Translatable('State'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => Translatable('State Type'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeList,
        },
        {
            Name             => Translatable('Priority'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => Translatable('Created in Queue'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedQueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            TreeView         => 1,
            Values           => \%QueueList,
        },
        {
            Name             => Translatable('Created Priority'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => Translatable('Created State'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => Translatable('Lock'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'LockIDs',
            Block            => 'MultiSelectField',
            Values           => \%LockList,
        },
        {
            Name             => Translatable('Title'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Title',
            Block            => 'InputField',
        },
        {
            Name             => Translatable('From'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'MIMEBase_From',
            Block            => 'InputField',
        },
        {
            Name             => Translatable('To'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'MIMEBase_To',
            Block            => 'InputField',
        },
        {
            Name             => Translatable('Cc'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'MIMEBase_Cc',
            Block            => 'InputField',
        },
        {
            Name             => Translatable('Subject'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'MIMEBase_Subject',
            Block            => 'InputField',
        },
        {
            Name             => Translatable('Text'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'MIMEBase_Body',
            Block            => 'InputField',
        },
        {
            Name             => Translatable('Create Time'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',             # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Last changed times'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'LastChangeTime',
            TimePeriodFormat => 'DateInputFormat',                    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketLastChangeTimeNewerDate',
                TimeStop  => 'TicketLastChangeTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Change times'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ChangeTime',
            TimePeriodFormat => 'DateInputFormat',              # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketChangeTimeNewerDate',
                TimeStop  => 'TicketChangeTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Close Time'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CloseTime2',
            TimePeriodFormat => 'DateInputFormat',            # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
    );

    if ( $ConfigObject->Get('Ticket::Service') ) {

        # get service list
        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren'),
            UserID       => 1,
        );

        # get sla list
        my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => 1,
        );

        my @ObjectAttributeAdd = (
            {
                Name             => Translatable('Service'),
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'ServiceIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                TreeView         => 1,
                Values           => \%Service,
            },
            {
                Name             => Translatable('SLA'),
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'SLAIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%SLA,
            },
        );

        unshift @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $ConfigObject->Get('Ticket::Type') ) {

        # get ticket type list
        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
            UserID => 1,
        );

        my %ObjectAttribute1 = (
            Name             => Translatable('Type'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'TypeIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%Type,
        );

        unshift @ObjectAttributes, \%ObjectAttribute1;
    }

    if ( $ConfigObject->Get('Ticket::ArchiveSystem') ) {

        my %ObjectAttribute = (
            Name             => Translatable('Archive Search'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'SearchInArchive',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => {
                ArchivedTickets    => Translatable('Archived tickets'),
                NotArchivedTickets => Translatable('Unarchived tickets'),
                AllTickets         => Translatable('All tickets'),
            },
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }

    if ( $ConfigObject->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name             => Translatable('Agent/Owner'),
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'OwnerIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => Translatable('Created by Agent/Owner'),
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'CreatedUserIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => Translatable('Responsible'),
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'ResponsibleIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
        );

        push @ObjectAttributes, @ObjectAttributeAdd;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $ConfigObject->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get all CustomerIDs which are related to a ticket.
        $DBObject->Prepare(
            SQL => "SELECT DISTINCT customer_id FROM ticket",
        );

        # fetch the result
        my %CustomerID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerID{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => Translatable('Customer ID'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'MultiSelectField',
            Values           => \%CustomerID,
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }
    else {

        my @CustomerIDAttributes = (
            {
                Name             => Translatable('CustomerID (complex search)'),
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'CustomerID',
                Block            => 'InputField',
            },
            {
                Name             => Translatable('CustomerID (exact match)'),
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'CustomerIDRaw',
                Block            => 'InputField',
            },
        );

        push @ObjectAttributes, @CustomerIDAttributes;
    }

    if ( $ConfigObject->Get('Stats::CustomerUserLoginsAsMultiSelect') ) {

        # Get all CustomerUserLogins which are related to a tiket.
        $DBObject->Prepare(
            SQL => "SELECT DISTINCT customer_user_id FROM ticket",
        );

        # fetch the result
        my %CustomerUserIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerUserIDs{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => Translatable('Assigned to Customer User Login'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CustomerUserLoginRaw',
            Block            => 'MultiSelectField',
            Values           => \%CustomerUserIDs,
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }
    else {

        my @CustomerIDAttributes = (
            {
                Name             => Translatable('Assigned to Customer User Login (complex search)'),
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'CustomerUserLogin',
                Block            => 'InputField',
            },
            {
                Name               => Translatable('Assigned to Customer User Login (exact match)'),
                UseAsXvalue        => 0,
                UseAsValueSeries   => 0,
                UseAsRestriction   => 1,
                Element            => 'CustomerUserLoginRaw',
                Block              => 'InputField',
                CSSClass           => 'CustomerAutoCompleteSimple',
                HTMLDataAttributes => {
                    'customer-search-type' => 'CustomerUser',
                },
            },
        );

        push @ObjectAttributes, @CustomerIDAttributes;
    }

    # Add always the field for the customer user login accessible tickets as auto complete field.
    my %ObjectAttribute = (
        Name               => Translatable('Accessible to Customer User Login (exact match)'),
        UseAsXvalue        => 0,
        UseAsValueSeries   => 0,
        UseAsRestriction   => 1,
        Element            => 'CustomerUserID',
        Block              => 'InputField',
        CSSClass           => 'CustomerAutoCompleteSimple',
        HTMLDataAttributes => {
            'customer-search-type' => 'CustomerUser',
        },
    );
    push @ObjectAttributes, \%ObjectAttribute;

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip all fields not designed to be supported by statistics
        my $IsStatsCondition = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsStatsCondition',
        );

        next DYNAMICFIELD if !$IsStatsCondition;

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

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{ $PossibleValues || {} };
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                Action        => 'AgentStats',
                Type          => 'DynamicField_' . $DynamicFieldConfig->{Name},
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData || {},
                UserID        => 1,
            );
            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }
        }

        # get field html
        my $DynamicFieldStatsParameter = $DynamicFieldBackendObject->StatsFieldParameterBuild(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
        );

        if ( IsHashRefWithData($DynamicFieldStatsParameter) ) {

            # backward compatibility
            if ( !$DynamicFieldStatsParameter->{Block} ) {
                $DynamicFieldStatsParameter->{Block} = 'InputField';
                if ( IsHashRefWithData( $DynamicFieldStatsParameter->{Values} ) ) {
                    $DynamicFieldStatsParameter->{Block} = 'MultiSelectField';
                }
            }
            if ( $DynamicFieldStatsParameter->{Block} eq 'Time' ) {

                # create object attributes (date/time fields)
                my $TimePeriodFormat = $DynamicFieldStatsParameter->{TimePeriodFormat} || 'DateInputFormatLong';

                my %ObjectAttribute = (
                    Name             => $DynamicFieldStatsParameter->{Name},
                    UseAsXvalue      => 1,
                    UseAsValueSeries => 1,
                    UseAsRestriction => 1,
                    Element          => $DynamicFieldStatsParameter->{Element},
                    TimePeriodFormat => $TimePeriodFormat,
                    Block            => $DynamicFieldStatsParameter->{Block},
                    TimePeriodFormat => $TimePeriodFormat,
                    Values           => {
                        TimeStart =>
                            $DynamicFieldStatsParameter->{Element}
                            . '_GreaterThanEquals',
                        TimeStop =>
                            $DynamicFieldStatsParameter->{Element}
                            . '_SmallerThanEquals',
                    },
                );
                push @ObjectAttributes, \%ObjectAttribute;
            }
            elsif ( $DynamicFieldStatsParameter->{Block} eq 'MultiSelectField' ) {

                # create object attributes (multiple values)
                my %ObjectAttribute = (
                    Name             => $DynamicFieldStatsParameter->{Name},
                    UseAsXvalue      => 1,
                    UseAsValueSeries => 1,
                    UseAsRestriction => 1,
                    Element          => $DynamicFieldStatsParameter->{Element},
                    Block            => $DynamicFieldStatsParameter->{Block},
                    Values           => $DynamicFieldStatsParameter->{Values},
                    Translation      => $DynamicFieldStatsParameter->{TranslatableValues} || 0,
                    IsDynamicField   => 1,
                    ShowAsTree       => $DynamicFieldConfig->{Config}->{TreeView} || 0,
                );
                push @ObjectAttributes, \%ObjectAttribute;
            }
            else {

                # create object attributes (text fields)
                my %ObjectAttribute = (
                    Name             => $DynamicFieldStatsParameter->{Name},
                    UseAsXvalue      => 0,
                    UseAsValueSeries => 0,
                    UseAsRestriction => 1,
                    Element          => $DynamicFieldStatsParameter->{Element},
                    Block            => $DynamicFieldStatsParameter->{Block},
                );
                push @ObjectAttributes, \%ObjectAttribute;
            }
        }
    }

    return @ObjectAttributes;
}

sub GetStatElementPreview {
    my ( $Self, %Param ) = @_;

    return int rand 50;
}

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Escape search attributes for ticket search.
    my %AttributesToEscape = (
        'CustomerID' => 1,
        'Title'      => 1,
    );

    # Map the CustomerID search parameter to CustomerIDRaw search parameter for the
    #   exact search match, if the 'Stats::CustomerIDAsMultiSelect' is active.
    if ( $ConfigObject->Get('Stats::CustomerIDAsMultiSelect') ) {
        $Param{CustomerIDRaw} = $Param{CustomerID};
    }

    # Get ticket search relevant attributes.
    my %TicketSearch;
    ATTRIBUTE:
    for my $Attribute ( @{ $Self->_AllowedTicketSearchAttributes() } ) {

        # Special handling for dynamic field date/time fields.
        if ( $Attribute =~ m{ \A DynamicField_ }xms ) {

            SEARCHATTRIBUTE:
            for my $SearchAttribute ( sort keys %Param ) {
                next SEARCHATTRIBUTE if $SearchAttribute !~ m{ \A \Q$Attribute\E }xms;
                $TicketSearch{$SearchAttribute} = $Param{$SearchAttribute};

                # Don't exist loop , there can be more than one attribute param per allowed attribute.
            }
        }
        else {
            next ATTRIBUTE if !$Param{$Attribute};
            $TicketSearch{$Attribute} = $Param{$Attribute};
        }

        next ATTRIBUTE if !$AttributesToEscape{$Attribute};

        # escape search parameters for ticket search
        if ( ref $TicketSearch{$Attribute} ) {
            if ( ref $TicketSearch{$Attribute} eq 'ARRAY' ) {
                $TicketSearch{$Attribute} = [
                    map { $DBObject->QueryStringEscape( QueryString => $_ ) }
                        @{ $TicketSearch{$Attribute} }
                ];
            }
        }
        else {
            $TicketSearch{$Attribute} = $DBObject->QueryStringEscape(
                QueryString => $TicketSearch{$Attribute}
            );
        }
    }

    # Do nothing, if there are no search attributes.
    return 0 if !%TicketSearch;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $ParameterName ( sort keys %TicketSearch ) {

        if ( $ParameterName =~ m{ \A DynamicField_ ( [a-zA-Z\d]+ ) (?: _ ( [a-zA-Z\d]+ ) )? \z }xms ) {
            my $FieldName = $1;
            my $Operator  = $2;

            # loop over the dynamic fields configured
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                # skip all fields that do not match with current field name
                # without the 'DynamicField_' prefix
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $FieldName;

                # skip all fields not designed to be supported by statistics
                my $IsStatsCondition = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsStatsCondition',
                );

                next DYNAMICFIELD if !$IsStatsCondition;

                # get new search parameter
                my $DynamicFieldStatsSearchParameter = $DynamicFieldBackendObject->StatsSearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $TicketSearch{$ParameterName},
                    Operator           => $Operator,
                );

                # add new search parameter
                if ( !IsHashRefWithData( $TicketSearch{"DynamicField_$FieldName"} ) ) {
                    $TicketSearch{"DynamicField_$FieldName"} =
                        $DynamicFieldStatsSearchParameter;
                }

                # extend search parameter
                elsif ( IsHashRefWithData($DynamicFieldStatsSearchParameter) ) {
                    $TicketSearch{"DynamicField_$FieldName"} = {
                        %{ $TicketSearch{"DynamicField_$FieldName"} },
                        %{$DynamicFieldStatsSearchParameter},
                    };
                }
            }
        }
    }

    if ( $ConfigObject->Get('Ticket::ArchiveSystem') ) {
        $Param{SearchInArchive} ||= '';
        if ( $Param{SearchInArchive} eq 'AllTickets' ) {
            $TicketSearch{ArchiveFlags} = [ 'y', 'n' ];
        }
        elsif ( $Param{SearchInArchive} eq 'ArchivedTickets' ) {
            $TicketSearch{ArchiveFlags} = ['y'];
        }
        else {
            $TicketSearch{ArchiveFlags} = ['n'];
        }
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Get all involved tickets.
    my @TicketIDs = $TicketObject->TicketSearch(
        UserID     => 1,
        Result     => 'ARRAY',
        Permission => 'ro',
        Limit      => 100_000_000,
        StateType  => 'Closed',
        %TicketSearch,
    );

    # Do nothing, if there are no tickets.
    return 0 if !@TicketIDs;

    my $Counter        = 0;
    my $CounterAllOver = 0;

    my %SolutionAllOver;
    my %Solution;
    my %SolutionWorkingTime;

    # Response is only the first response and nothing with the update time.
    my %Response;
    my %ResponseWorkingTime;

    TICKET:
    for my $TicketID (@TicketIDs) {
        $CounterAllOver++;
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            Extended      => 1,
            DynamicFields => 0,
        );

        # If ticket does not have closed time, skip to next ticket.
        next TICKET if !defined $Ticket{Closed};

        my $CreatedDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Ticket{Created}
            },
        );
        my $ClosedDateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Ticket{Closed}
            },
        );

        my $Delta = $ClosedDateTimeObject->Delta( DateTimeObject => $CreatedDateTimeObject );
        $SolutionAllOver{$TicketID} = $Delta->{AbsoluteSeconds};

        next TICKET if !defined $Ticket{SolutionInMin};

        # Now collect only data of tickets which are affected by a escalation config
        $Counter++;
        $Solution{$TicketID}            = $SolutionAllOver{$TicketID};
        $SolutionWorkingTime{$TicketID} = $Ticket{SolutionInMin};

        if ( $Ticket{FirstResponse} ) {

            my $FirstResponseDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Ticket{FirstResponse}
                },
            );

            my $Delta = $FirstResponseDateTimeObject->Delta( DateTimeObject => $CreatedDateTimeObject );
            $Response{$TicketID}            = $Delta->{AbsoluteSeconds};
            $ResponseWorkingTime{$TicketID} = $Ticket{FirstResponseInMin};
        }
        else {
            $Response{$TicketID}            = 0;
            $ResponseWorkingTime{$TicketID} = 0;
        }
    }

    my $SelectedKindOfReporting = 'SolutionAverageAllOver';
    if ( IsArrayRefWithData( $Param{KindsOfReporting} ) ) {
        $SelectedKindOfReporting = $Param{KindsOfReporting}->[0];
    }

    my $Reporting = 0;

    # different solution averages
    if ( $SelectedKindOfReporting eq 'SolutionAverageAllOver' ) {
        $Reporting = $Self->_GetAverage(
            Count   => $CounterAllOver,
            Content => \%SolutionAllOver,
        );
    }
    if ( $SelectedKindOfReporting eq 'SolutionAverage' ) {
        $Reporting = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%Solution,
        );
    }
    if ( $SelectedKindOfReporting eq 'SolutionWorkingTimeAverage' ) {
        $Reporting = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%SolutionWorkingTime,
        );
    }

    # response average
    if ( $SelectedKindOfReporting eq 'ResponseAverage' ) {
        $Reporting = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%Response,
        );
    }
    if ( $SelectedKindOfReporting eq 'ResponseWorkingTimeAverage' ) {
        $Reporting = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%ResponseWorkingTime,
        );
    }

    # min max for standard solution
    if ( $SelectedKindOfReporting eq 'SolutionMinTimeAllOver' ) {
        if (%SolutionAllOver) {
            $Reporting = ( sort { $a <=> $b } values %SolutionAllOver )[0];
        }
        else {
            $Reporting = 0;
        }
    }
    if ( $SelectedKindOfReporting eq 'SolutionMaxTimeAllOver' ) {
        if (%SolutionAllOver) {
            $Reporting = ( sort { $b <=> $a } values %SolutionAllOver )[0];
        }
        else {
            $Reporting = 0;
        }
    }

    # min max for solution time with configured escalation
    if ( $SelectedKindOfReporting eq 'SolutionMinTime' ) {
        if (%Solution) {
            $Reporting = ( sort { $a <=> $b } values %Solution )[0];
        }
        else {
            $Reporting = 0;
        }
    }
    if ( $SelectedKindOfReporting eq 'SolutionMaxTime' ) {
        if (%Solution) {
            $Reporting = ( sort { $b <=> $a } values %Solution )[0];
        }
        else {
            $Reporting = 0;
        }
    }

    # min max for solution working time
    if ( $SelectedKindOfReporting eq 'SolutionMinWorkingTime' ) {
        if (%SolutionWorkingTime) {
            $Reporting = ( sort { $a <=> $b } values %SolutionWorkingTime )[0];
        }
        else {
            $Reporting = 0;
        }
    }
    if ( $SelectedKindOfReporting eq 'SolutionMaxWorkingTime' ) {
        if (%SolutionWorkingTime) {
            $Reporting = ( sort { $b <=> $a } values %SolutionWorkingTime )[0];
        }
        else {
            $Reporting = 0;
        }
    }

    # min max for response time
    if ( $SelectedKindOfReporting eq 'ResponseMinTime' ) {
        if (%Response) {
            $Reporting = ( sort { $a <=> $b } values %Response )[0];
        }
        else {
            $Reporting = 0;
        }
    }
    if ( $SelectedKindOfReporting eq 'ResponseMaxTime' ) {
        if (%Response) {
            $Reporting = ( sort { $b <=> $a } values %Response )[0];
        }
        else {
            $Reporting = 0;
        }
    }

    # min max for response working time
    if ( $SelectedKindOfReporting eq 'ResponseMinWorkingTime' ) {
        if (%ResponseWorkingTime) {
            $Reporting = ( sort { $a <=> $b } values %ResponseWorkingTime )[0];
        }
        else {
            $Reporting = 0;
        }
    }
    if ( $SelectedKindOfReporting eq 'ResponseMaxWorkingTime' ) {
        if (%ResponseWorkingTime) {
            $Reporting = ( sort { $b <=> $a } values %ResponseWorkingTime )[0];
        }
        else {
            $Reporting = 0;
        }
    }

    # Add the number of values.
    if ( $SelectedKindOfReporting eq 'NumberOfTickets' ) {
        $Reporting = $Counter;
    }
    if ( $SelectedKindOfReporting eq 'NumberOfTicketsAllOver' ) {
        $Reporting = $CounterAllOver;
    }

    # Convert seconds in minutes.
    my %LookupKindsOfReportingConvertSecondsInMinutes = (
        ResponseMaxTime        => 1,
        ResponseMinTime        => 1,
        SolutionMaxTime        => 1,
        SolutionMinTime        => 1,
        SolutionMaxTimeAllOver => 1,
        SolutionMinTimeAllOver => 1,
        SolutionAverageAllOver => 1,
        SolutionAverage        => 1,
        ResponseAverage        => 1,
    );

    if ( $Reporting && $LookupKindsOfReportingConvertSecondsInMinutes{$SelectedKindOfReporting} ) {
        $Reporting = int( $Reporting / 60 + 0.5 );
    }

    # Convert min in hh:mm.
    if ( $SelectedKindOfReporting ne 'NumberOfTickets' && $SelectedKindOfReporting ne 'NumberOfTicketsAllOver' ) {
        $Reporting = $Kernel::OM->Get('Kernel::System::Stats')->_HumanReadableAgeGet(
            Age => $Reporting * 60,
        );
    }

    return $Reporting;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
    my $StateObject    = $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'QueueIDs' || $ElementName eq 'CreatedQueueIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $QueueObject->QueueLookup( QueueID => $ID->{Content} );
                }
            }
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                my %StateList = $StateObject->StateList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $StateList{ $ID->{Content} };
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $PriorityObject->PriorityList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $PriorityList{ $ID->{Content} };
                }
            }
            elsif (
                $ElementName eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $UserObject->UserLookup( UserID => $ID->{Content} );
                }
            }

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
    my $StateObject    = $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'QueueIDs' || $ElementName eq 'CreatedQueueIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    if ( $QueueObject->QueueLookup( Queue => $ID->{Content} ) ) {
                        $ID->{Content} = $QueueObject->QueueLookup( Queue => $ID->{Content} );
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find the queue $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %State = $StateObject->StateGet(
                        Name  => $ID->{Content},
                        Cache => 1,
                    );
                    if ( $State{ID} ) {
                        $ID->{Content} = $State{ID};
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find state $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $PriorityObject->PriorityList( UserID => 1 );
                my %PriorityIDs;
                for my $Key ( sort keys %PriorityList ) {
                    $PriorityIDs{ $PriorityList{$Key} } = $Key;
                }
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    if ( $PriorityIDs{ $ID->{Content} } ) {
                        $ID->{Content} = $PriorityIDs{ $ID->{Content} };
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find priority $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif (
                $ElementName eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    if ( $UserObject->UserLookup( UserLogin => $ID->{Content} ) ) {
                        $ID->{Content} = $UserObject->UserLookup(
                            UserLogin => $ID->{Content}
                        );
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find user $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub _GetAverage {
    my ( $Self, %Param ) = @_;
    return 0 if !$Param{Count};

    my $Sum = 0;
    for my $Value ( values %{ $Param{Content} } ) {
        $Sum += $Value || 0;
    }
    return $Sum / $Param{Count};
}

sub _KindsOfReporting {
    my $Self = shift;

    my %KindsOfReporting = (
        SolutionAverageAllOver => Translatable('Solution Average'),
        SolutionMinTimeAllOver => Translatable('Solution Min Time'),
        SolutionMaxTimeAllOver => Translatable('Solution Max Time'),
        NumberOfTicketsAllOver => Translatable('Number of Tickets'),
        SolutionAverage        => Translatable('Solution Average (affected by escalation configuration)'),
        SolutionMinTime        => Translatable('Solution Min Time (affected by escalation configuration)'),
        SolutionMaxTime        => Translatable('Solution Max Time (affected by escalation configuration)'),
        SolutionWorkingTimeAverage =>
            Translatable('Solution Working Time Average (affected by escalation configuration)'),
        SolutionMinWorkingTime =>
            Translatable('Solution Min Working Time (affected by escalation configuration)'),
        SolutionMaxWorkingTime =>
            Translatable('Solution Max Working Time (affected by escalation configuration)'),
        ResponseAverage => Translatable('First Response Average (affected by escalation configuration)'),
        ResponseMinTime => Translatable('First Response Min Time (affected by escalation configuration)'),
        ResponseMaxTime => Translatable('First Response Max Time (affected by escalation configuration)'),
        ResponseWorkingTimeAverage =>
            Translatable('First Response Working Time Average (affected by escalation configuration)'),
        ResponseMinWorkingTime =>
            Translatable('First Response Min Working Time (affected by escalation configuration)'),
        ResponseMaxWorkingTime =>
            Translatable('First Response Max Working Time (affected by escalation configuration)'),
        NumberOfTickets => Translatable('Number of Tickets (affected by escalation configuration)'),
    );
    return \%KindsOfReporting;
}

sub _SortedKindsOfReporting {
    my $Self = shift;

    my @SortedKindsOfReporting = qw(
        SolutionAverageAllOver
        SolutionMinTimeAllOver
        SolutionMaxTimeAllOver
        NumberOfTicketsAllOver
        SolutionAverage
        SolutionMinTime
        SolutionMaxTime
        SolutionWorkingTimeAverage
        SolutionMinWorkingTime
        SolutionMaxWorkingTime
        ResponseAverage
        ResponseMinTime
        ResponseMaxTime
        ResponseWorkingTimeAverage
        ResponseMinWorkingTime
        ResponseMaxWorkingTime
        NumberOfTickets
    );
    return \@SortedKindsOfReporting;
}

sub _AllowedTicketSearchAttributes {
    my $Self = shift;

    my @Attributes = qw(
        TicketNumber
        Title
        Queues
        QueueIDs
        Types
        TypeIDs
        States
        StateIDs
        StateType
        StateTypeIDs
        Priorities
        PriorityIDs
        Services
        ServiceIDs
        SLAs
        SLAIDs
        Locks
        LockIDs
        OwnerIDs
        ResponsibleIDs
        WatchUserIDs
        CustomerID
        CustomerIDRaw
        CustomerUserLogin
        CustomerUserLoginRaw
        CreatedUserIDs
        CreatedTypes
        CreatedTypeIDs
        CreatedPriorities
        CreatedPriorityIDs
        CreatedStates
        CreatedStateIDs
        CreatedQueues
        CreatedQueueIDs
        From
        To
        Subject
        Body
        TicketCreateTimeNewerDate
        TicketCreateTimeOlderDate
        TicketChangeTimeNewerDate
        TicketChangeTimeOlderDate
        TicketLastChangeTimeNewerDate
        TicketLastChangeTimeOlderDate
        TicketCloseTimeNewerDate
        TicketCloseTimeOlderDate
    );

    # loop over the dynamic fields configured
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # add dynamic field to Attribute list
        push @Attributes, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@Attributes;
}

1;
