# --
# Kernel/System/Stats/Dynamic/TicketList.pm - reporting via ticket lists
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TicketList;

use strict;
use warnings;

use List::Util qw( first );
use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Ticket;
use Kernel::System::Type;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject EncodeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{QueueObject}        = Kernel::System::Queue->new( %{$Self} );
    $Self->{TicketObject}       = Kernel::System::Ticket->new( %{$Self} );
    $Self->{StateObject}        = Kernel::System::State->new( %{$Self} );
    $Self->{PriorityObject}     = Kernel::System::Priority->new( %{$Self} );
    $Self->{LockObject}         = Kernel::System::Lock->new( %{$Self} );
    $Self->{CustomerUser}       = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ServiceObject}      = Kernel::System::Service->new( %{$Self} );
    $Self->{SLAObject}          = Kernel::System::SLA->new( %{$Self} );
    $Self->{TypeObject}         = Kernel::System::Type->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new( %{$Self} );

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'Ticketlist';
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

    # get user list
    my %UserList = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    # get state list
    my %StateList = $Self->{StateObject}->StateList(
        UserID => 1,
    );

    # get state type list
    my %StateTypeList = $Self->{StateObject}->StateTypeList(
        UserID => 1,
    );

    # get queue list
    my %QueueList = $Self->{QueueObject}->GetAllQueues();

    # get priority list
    my %PriorityList = $Self->{PriorityObject}->PriorityList(
        UserID => 1,
    );

    # get lock list
    my %LockList = $Self->{LockObject}->LockList(
        UserID => 1,
    );

    my %Limit = (
        5         => 5,
        10        => 10,
        20        => 20,
        50        => 50,
        100       => 100,
        unlimited => 'unlimited',
    );

    my %TicketAttributes = %{ $Self->_TicketAttributes() };
    my %OrderBy
        = map { $_ => $TicketAttributes{$_} } grep { $_ ne 'Number' } keys %TicketAttributes;

    # remove non sortable (and orderable) Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # check if dynamic field is sortable
        my $IsSortable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsSortable',
        );

        # remove dynamic fields from the list if is not sortable
        if ( !$IsSortable ) {
            delete $OrderBy{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
        }
    }

    my %SortSequence = (
        Up   => 'ascending',
        Down => 'descending',
    );

    my @ObjectAttributes = (
        {
            Name             => 'Attributes to be printed',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 0,
            Element          => 'TicketAttributes',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Values           => \%TicketAttributes,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedAttributes(),

        },
        {
            Name             => 'Order by',
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'OrderBy',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%OrderBy,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedAttributes(),
        },
        {
            Name             => 'Sort sequence',
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'SortSequence',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%SortSequence,
        },
        {
            Name             => 'Limit',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Limit',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%Limit,
            Sort             => 'IndividualKey',
            SortIndividual   => [ '5', '10', '20', '50', '100', 'unlimited', ],
        },
        {
            Name             => 'Queue',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'QueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            TreeView         => 1,
            Values           => \%QueueList,
        },
        {
            Name             => 'State',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'State Historic',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateIDsHistoric',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'State Type',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeList,
        },
        {
            Name             => 'State Type Historic',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDsHistoric',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created in Queue',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreatedQueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            TreeView         => 1,
            Values           => \%QueueList,
        },
        {
            Name             => 'Created Priority',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created State',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'Lock',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'LockIDs',
            Block            => 'MultiSelectField',
            Values           => \%LockList,
        },
        {
            Name             => 'Title',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Title',
            Block            => 'InputField',
        },
        {
            Name             => 'CustomerUserLogin',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerUserLogin',
            Block            => 'InputField',
        },
        {
            Name             => 'From',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'From',
            Block            => 'InputField',
        },
        {
            Name             => 'To',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'To',
            Block            => 'InputField',
        },
        {
            Name             => 'Cc',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Cc',
            Block            => 'InputField',
        },
        {
            Name             => 'Subject',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Subject',
            Block            => 'InputField',
        },
        {
            Name             => 'Text',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Body',
            Block            => 'InputField',
        },
        {
            Name             => 'Create Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
        {
            Name             => 'Close Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CloseTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
        {
            Name             => 'Historic Time Range',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'HistoricTimeRange',
            TimePeriodFormat => 'DateInputFormat',       # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'HistoricTimeRangeTimeNewerDate',
                TimeStop  => 'HistoricTimeRangeTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'EscalationTime',
            TimePeriodFormat => 'DateInputFormatLong',    # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationTimeNewerDate',
                TimeStop  => 'TicketEscalationTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation - First Response Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'EscalationResponseTime',
            TimePeriodFormat => 'DateInputFormatLong',                # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationResponseTimeNewerDate',
                TimeStop  => 'TicketEscalationResponseTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation - Update Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'EscalationUpdateTime',
            TimePeriodFormat => 'DateInputFormatLong',        # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationUpdateTimeNewerDate',
                TimeStop  => 'TicketEscalationUpdateTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation - Solution Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'EscalationSolutionTime',
            TimePeriodFormat => 'DateInputFormatLong',          # 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketEscalationSolutionTimeNewerDate',
                TimeStop  => 'TicketEscalationSolutionTimeOlderDate',
            },
        },
    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        # get service list
        my %Service = $Self->{ServiceObject}->ServiceList(
            UserID => 1,
        );

        # get sla list
        my %SLA = $Self->{SLAObject}->SLAList(
            UserID => 1,
        );

        my @ObjectAttributeAdd = (
            {
                Name             => 'Service',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'ServiceIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                TreeView         => 1,
                Values           => \%Service,
            },
            {
                Name             => 'SLA',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'SLAIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%SLA,
            },
        );

        unshift @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {

        # get ticket type list
        my %Type = $Self->{TypeObject}->TypeList(
            UserID => 1,
        );

        my %ObjectAttribute1 = (
            Name             => 'Type',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'TypeIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%Type,
        );

        unshift @ObjectAttributes, \%ObjectAttribute1;
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name             => 'Agent/Owner',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'OwnerIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Created by Agent/Owner',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'CreatedUserIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Responsible',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'ResponsibleIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
        );

        push @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get CustomerID
        # (This way also can be the solution for the CustomerUserID)
        $Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT customer_id FROM ticket",
        );

        # fetch the result
        my %CustomerID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerID{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'MultiSelectField',
            Values           => \%CustomerID,
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }
    else {

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'InputField',
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }

    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

        my %ObjectAttribute = (
            Name             => 'Archive Search',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'SearchInArchive',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => {
                ArchivedTickets    => 'Archived tickets',
                NotArchivedTickets => 'Unarchived tickets',
                AllTickets         => 'All tickets',
            },
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip all fields not designed to be supported by statistics
        my $IsStatsCondition = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsStatsCondition',
        );

        next DYNAMICFIELD if !$IsStatsCondition;

        my $PossibleValuesFilter;

        my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );

        if ($IsACLReducible) {

            # get PossibleValues
            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{ $PossibleValues || {} };
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                Action        => 'AgentStats',
                Type          => 'DynamicField_' . $DynamicFieldConfig->{Name},
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData || {},
                UserID        => 1,
            );
            if ($ACL) {
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter}
                    = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }
        }

        # get dynamic field stats parameters
        my $DynamicFieldStatsParameter = $Self->{BackendObject}->StatsFieldParameterBuild(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
        );

        if ( IsHashRefWithData($DynamicFieldStatsParameter) ) {
            if ( IsHashRefWithData( $DynamicFieldStatsParameter->{Values} ) ) {

                # create object attributes (multiple values)
                my %ObjectAttribute = (
                    Name             => $DynamicFieldStatsParameter->{Name},
                    UseAsXvalue      => 0,
                    UseAsValueSeries => 0,
                    UseAsRestriction => 1,
                    Element          => $DynamicFieldStatsParameter->{Element},
                    Block            => 'MultiSelectField',
                    Values           => $DynamicFieldStatsParameter->{Values},
                    Translation      => 0,
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
                    Block            => 'InputField',
                );
                push @ObjectAttributes, \%ObjectAttribute;
            }
        }
    }

    return @ObjectAttributes;
}

sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my %TicketAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };
    my $SortedAttributesRef = $Self->_SortedAttributes();

    # check if a enumeration is requested
    my $AddEnumeration = 0;
    if ( $TicketAttributes{Number} ) {
        $AddEnumeration = 1;
        delete $TicketAttributes{Number};
    }

    # set default values if no sort or order attribute is given
    my $OrderRef = first { $_->{Element} eq 'OrderBy' } @{ $Param{ValueSeries} };
    my $OrderBy = $OrderRef ? $OrderRef->{SelectedValues}[0] : 'Age';
    my $SortRef = first { $_->{Element} eq 'SortSequence' } @{ $Param{ValueSeries} };
    my $Sort = $SortRef ? $SortRef->{SelectedValues}[0] : 'Down';
    my $Limit = $Param{Restrictions}{Limit};

    # check if we can use the sort and order function of TicketSearch
    my $OrderByIsValueOfTicketSearchSort = $Self->_OrderByIsValueOfTicketSearchSort(
        OrderBy => $OrderBy,
    );

    #
    # escape search attributes for ticket search
    #
    my %AttributesToEscape = (
        'CustomerID' => 1,
        'Title'      => 1,
    );

    ATTRIBUTE:
    for my $Key ( sort keys %{ $Param{Restrictions} } ) {

        next ATTRIBUTE if !$AttributesToEscape{$Key};

        if ( ref $Param{Restrictions}->{$Key} ) {
            if ( ref $Param{Restrictions}->{$Key} eq 'ARRAY' ) {
                $Param{Restrictions}->{$Key} = [
                    map { $Self->{DBObject}->QueryStringEscape( QueryString => $_ ) }
                        @{ $Param{Restrictions}->{$Key} }
                ];
            }
        }
        else {
            $Param{Restrictions}->{$Key} = $Self->{DBObject}->QueryStringEscape(
                QueryString => $Param{Restrictions}->{$Key}
            );
        }
    }

    my %DynamicFieldRestrictions;
    for my $ParameterName ( sort keys %{ $Param{Restrictions} } ) {
        if ( $ParameterName =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

            # loop over the dynamic fields configured
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                # skip all fields that does not match with current field name ($1)
                # without the 'DynamicField_' prefix
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                # skip all fields not designed to be supported by statistics
                my $IsStatsCondition = $Self->{BackendObject}->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsStatsCondition',
                );

                next DYNAMICFIELD if !$IsStatsCondition;

                # get new search parameter
                my $DynamicFieldStatsSearchParameter
                    = $Self->{BackendObject}->StatsSearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Param{Restrictions}->{$ParameterName},
                    );

                # add new search parameter
                $DynamicFieldRestrictions{$ParameterName} = $DynamicFieldStatsSearchParameter;
            }
        }
    }

    if ($OrderByIsValueOfTicketSearchSort) {

        # don't be irritated of the mixture OrderBy <> Sort and SortBy <> OrderBy
        # the meaning is in TicketSearch is different as in common handling
        $Param{Restrictions}{OrderBy} = $Sort;
        $Param{Restrictions}{SortBy}  = $OrderByIsValueOfTicketSearchSort;
        $Param{Restrictions}{Limit}   = !$Limit || $Limit eq 'unlimited' ? 100_000_000 : $Limit;
    }
    else {
        $Param{Restrictions}{Limit} = 100_000_000;
    }

    # OlderTicketsExclude for historic searches
    # takes tickets that were closed before the
    # start of the searched time periode
    my %OlderTicketsExclude;

    # NewerTicketExclude for historic searches
    # takes tickets that were created after the
    # searched time periode
    my %NewerTicketsExclude;
    my %StateList = $Self->{StateObject}->StateList( UserID => 1 );

    # UnixTimeStart & End:
    # The Time periode the historic search is executed
    # if no time periode has been selected we take
    # Unixtime 0 as StartTime and SystemTime as EndTime
    my $UnixTimeStart = 0;
    my $UnixTimeEnd   = $Self->{TimeObject}->SystemTime();

    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {
        $Param{Restrictions}->{SearchInArchive} ||= '';
        if ( $Param{Restrictions}->{SearchInArchive} eq 'AllTickets' ) {
            $Param{Restrictions}->{ArchiveFlags} = [ 'y', 'n' ];
        }
        elsif ( $Param{Restrictions}->{SearchInArchive} eq 'ArchivedTickets' ) {
            $Param{Restrictions}->{ArchiveFlags} = ['y'];
        }
        else {
            $Param{Restrictions}->{ArchiveFlags} = ['n'];
        }
    }

    if ( $Param{Restrictions}->{HistoricTimeRangeTimeNewerDate} ) {

        # Find tickets that were closed before the start of our
        # HistoricTimeRangeTimeNewerDate, these have to be excluded.
        # In order to reduce it quickly we reformat the result array
        # to a hash.
        my @OldToExclude = $Self->{TicketObject}->TicketSearch(
            UserID                   => 1,
            Result                   => 'ARRAY',
            Permission               => 'ro',
            TicketCloseTimeOlderDate => $Param{Restrictions}->{HistoricTimeRangeTimeNewerDate},
            ArchiveFlags             => $Param{Restrictions}->{ArchiveFlags},
            Limit                    => 100_000_000,
        );
        %OlderTicketsExclude = map { $_ => 1 } @OldToExclude;
        $UnixTimeStart = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{Restrictions}->{HistoricTimeRangeTimeNewerDate}
        );
    }
    if ( $Param{Restrictions}->{HistoricTimeRangeTimeOlderDate} ) {

        # Find tickets that were closed after the end of our
        # HistoricTimeRangeTimeOlderDate, these have to be excluded
        # in order to reduce it quickly we reformat the result array
        # to a hash.
        my @NewToExclude = $Self->{TicketObject}->TicketSearch(
            UserID                    => 1,
            Result                    => 'ARRAY',
            Permission                => 'ro',
            TicketCreateTimeNewerDate => $Param{Restrictions}->{HistoricTimeRangeTimeOlderDate},
            ArchiveFlags              => $Param{Restrictions}->{ArchiveFlags},
            Limit                     => 100_000_000,
        );
        %NewerTicketsExclude = map { $_ => 1 } @NewToExclude;
        $UnixTimeEnd = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{Restrictions}->{HistoricTimeRangeTimeOlderDate}
        );
    }

    # get the involved tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        UserID     => 1,
        Result     => 'ARRAY',
        Permission => 'ro',
        %{ $Param{Restrictions} },
        %DynamicFieldRestrictions,
    );

    # if we had Tickets we need to reduce the found tickets
    # to those not beeing in %OlderTicketsExclude
    # as well as not in %NewerTicketsExclude
    if ( %OlderTicketsExclude || %NewerTicketsExclude ) {
        @TicketIDs = grep {
            !defined $OlderTicketsExclude{$_}
                && !defined $NewerTicketsExclude{$_}
        } @TicketIDs;
    }

    # if we have to deal with history states
    if (
        (
            $Param{Restrictions}->{HistoricTimeRangeTimeNewerDate}
            || $Param{Restrictions}->{HistoricTimeRangeTimeOlderDate}
            || (
                defined $Param{Restrictions}->{StateTypeIDsHistoric}
                && ref $Param{Restrictions}->{StateTypeIDsHistoric} eq 'ARRAY'
            )
            || (
                defined $Param{Restrictions}->{StateIDsHistoric}
                && ref $Param{Restrictions}->{StateIDsHistoric} eq 'ARRAY'
            )
        )
        && @TicketIDs
        )
    {

        # start building the SQL query from back to front
        # what's fixed is the history_type_id we have to search for
        # 1 is ticketcreate
        # 27 is state update
        my $SQL = 'history_type_id IN (1,27) ORDER BY ticket_id ASC';

        $SQL = 'ticket_id IN ('
            . ( join ', ', @TicketIDs ) . ') AND ' . $SQL;

        my %StateIDs;

        # if we have certain state types we have to search for
        # build a hash holding all ticket StateIDs => StateNames
        # we are searching for
        if (
            defined $Param{Restrictions}->{StateTypeIDsHistoric}
            && ref $Param{Restrictions}->{StateTypeIDsHistoric} eq 'ARRAY'
            )
        {

            # getting the StateListType:
            # my %ListType = (
            #     1 => "new",
            #     2 => "open",
            #     3 => "closed",
            #     4 => "pending reminder",
            #     5 => "pending auto",
            #     6 => "removed",
            #     7 => "merged",
            # );
            my %ListType = $Self->{StateObject}->StateTypeList(
                UserID => 1,
            );

            # Takes the Array of StateTypeID's
            # example: (1, 3, 5, 6, 7)
            # maps the ID's to the StateTypeNames
            # results in a Hash containing the StateTypeNames
            # example:
            # %StateTypeHash = {
            #                  'closed' => 1,
            #                  'removed' => 1,
            #                  'pending auto' => 1,
            #                  'merged' => 1,
            #                  'new' => 1
            #               };
            my %StateTypeHash = map { $ListType{$_} => 1 }
                @{ $Param{Restrictions}->{StateTypeIDsHistoric} };

            # And now get the StatesByType
            # Result is a Hash {ID => StateName,}
            my @StateTypes = keys %StateTypeHash;
            %StateIDs = $Self->{StateObject}->StateGetStatesByType(
                StateType => [ keys %StateTypeHash ],
                Result    => 'HASH',
            );
        }

        # if we had certain states selected, add them to the
        # StateIDs Hash
        if (
            defined $Param{Restrictions}->{StateIDsHistoric}
            && ref $Param{Restrictions}->{StateIDsHistoric} eq 'ARRAY'
            )
        {

            # Validate the StateIDsHistoric list by
            # checking if they are in the %StateList hash
            # then taking all ValidState ID's and return a hash
            # holding { StateID => Name }
            my %Tmp = map { $_ => $StateList{$_} }
                grep { $StateList{$_} } @{ $Param{Restrictions}->{StateIDsHistoric} };
            %StateIDs = ( %StateIDs, %Tmp );
        }

        $SQL = 'SELECT ticket_id, state_id, create_time FROM ticket_history WHERE ' . $SQL;

        $Self->{DBObject}->Prepare( SQL => $SQL );

        # Structure:
        # Stores the last TicketState:
        # TicketID => [StateID, CreateTime]
        my %FoundTickets;

        # fetch the result
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                my $TicketID    = $Row[0];
                my $StateID     = $Row[1];
                my $RowTime     = $Row[2];
                my $RowTimeUnix = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $Row[2],
                );

                # Entries before StartTime
                if ( $RowTimeUnix < $UnixTimeStart ) {

                    # if the ticket was already stored
                    if ( $FoundTickets{$TicketID} ) {

                        # if the current state is in the searched states
                        # update the record
                        if ( $StateIDs{$StateID} ) {
                            $FoundTickets{$TicketID} = [ $StateID, $RowTimeUnix ];
                        }

                        # if it is not in the searched states
                        # a state change happend ->
                        # delete the record
                        else {
                            delete $FoundTickets{$TicketID};
                        }
                    }

                    # if the ticket was NOT already stored
                    # and the state is in the searched states
                    # store the record
                    elsif ( $StateIDs{$StateID} ) {
                        $FoundTickets{$TicketID} = [ $StateID, $RowTimeUnix ];
                    }
                }

                # Entries between Start and EndTime
                if (
                    $RowTimeUnix >= $UnixTimeStart
                    && $RowTimeUnix <= $UnixTimeEnd
                    )
                {

                    # if we found a record
                    # with the searched states
                    # add it to the FoundTickets
                    if ( $StateIDs{$StateID} ) {
                        $FoundTickets{$TicketID} = [ $StateID, $RowTimeUnix ];
                    }
                }
            }
        }

        # if we had tickets that matched our query
        # use them to get the details for the statistic
        if (%FoundTickets) {
            @TicketIDs = sort { $a <=> $b } keys %FoundTickets;
        }

        # if no Tickets were remaining,
        # after reducing the total amount by the ones
        # that had none of the searched states,
        # empty @TicketIDs
        else {
            @TicketIDs = ();
        }
    }

    # find out if the extended version of TicketGet is needed,
    my $Extended = $Self->_ExtendedAttributesCheck(
        TicketAttributes => \%TicketAttributes,
    );

    # find out if dynamic fields are required
    my $NeedDynamicFields = 0;
    DYNAMICFIELDSNEEDED:
    for my $ParameterName ( sort keys %TicketAttributes ) {
        if ( $ParameterName =~ m{\A DynamicField_ }xms ) {
            $NeedDynamicFields = 1;
            last DYNAMICFIELDSNEEDED;
        }
    }

    # generate the ticket list
    my @StatArray;
    for my $TicketID (@TicketIDs) {
        my @ResultRow;
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            Extended      => $Extended,
            DynamicFields => $NeedDynamicFields,
        );

        # add the accounted time if needed
        if ( $TicketAttributes{AccountedTime} ) {
            $Ticket{AccountedTime}
                = $Self->{TicketObject}->TicketAccountedTimeGet( TicketID => $TicketID );
        }

        $Ticket{SolutionTime}                ||= '';
        $Ticket{SolutionDiffInMin}           ||= 0;
        $Ticket{SolutionInMin}               ||= 0;
        $Ticket{FirstResponse}               ||= '';
        $Ticket{FirstResponseDiffInMin}      ||= 0;
        $Ticket{FirstResponseInMin}          ||= 0;
        $Ticket{FirstLock}                   ||= '';
        $Ticket{SolutionTimeDestinationDate} ||= '';
        $Ticket{EscalationDestinationIn}     ||= '';
        $Ticket{EscalationDestinationDate}   ||= '';
        $Ticket{EscalationTimeWorkingTime}   ||= 0;

        for my $ParameterName ( sort keys %Ticket ) {
            if ( $ParameterName =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

                # loop over the dynamic fields configured
                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                    next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                    # skip all fields that does not match with current field name ($1)
                    # without the 'DynamicField_' prefix
                    next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                    # prevent unitilization errors
                    if ( !defined $Ticket{$ParameterName} ) {
                        $Ticket{$ParameterName} = '';
                        next DYNAMICFIELD;
                    }

                    # convert from stored keys to values for certain Dynamic Fields like
                    # Dropdown, Checkbox and Multiselect
                    my $ValueLookup = $Self->{BackendObject}->ValueLookup(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Key                => $Ticket{$ParameterName},
                    );

                    # get field value in plain text
                    my $ValueStrg = $Self->{BackendObject}->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $ValueLookup,
                    );

                    if ( $ValueStrg->{Value} ) {

                        # change raw value from ticket to a plain text value
                        $Ticket{$ParameterName} = $ValueStrg->{Value};
                    }
                }
            }
        }

        ATTRIBUTE:
        for my $Attribute ( @{$SortedAttributesRef} ) {
            next ATTRIBUTE if !$TicketAttributes{$Attribute};
            push @ResultRow, $Ticket{$Attribute};
        }
        push @StatArray, \@ResultRow;
    }

    # use a individual sort if the sort mechanismn of the TicketSearch is not useable
    if ( !$OrderByIsValueOfTicketSearchSort ) {
        @StatArray = $Self->_IndividualResultOrder(
            StatArray          => \@StatArray,
            OrderBy            => $OrderBy,
            Sort               => $Sort,
            SelectedAttributes => \%TicketAttributes,
            Limit              => $Limit,
        );
    }

    # add a enumeration in front of each row
    if ($AddEnumeration) {
        my $Counter = 0;
        for my $Row (@StatArray) {
            unshift @{$Row}, ++$Counter;
        }
    }

    return @StatArray;
}

sub GetHeaderLine {
    my ( $Self, %Param ) = @_;
    my %SelectedAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };

    my $TicketAttributes    = $Self->_TicketAttributes();
    my $SortedAttributesRef = $Self->_SortedAttributes();
    my @HeaderLine;

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributesRef} ) {
        next ATTRIBUTE if !$SelectedAttributes{$Attribute};
        push @HeaderLine, $TicketAttributes->{$Attribute};
    }
    return \@HeaderLine;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

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
                    $ID->{Content} = $Self->{QueueObject}->QueueLookup( QueueID => $ID->{Content} );
                }
            }
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                my %StateList = $Self->{StateObject}->StateList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $StateList{ $ID->{Content} };
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $PriorityList{ $ID->{Content} };
                }
            }
            elsif (
                $ElementName    eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $Self->{UserObject}->UserLookup( UserID => $ID->{Content} );
                }
            }

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

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
                    if ( $Self->{QueueObject}->QueueLookup( Queue => $ID->{Content} ) ) {
                        $ID->{Content}
                            = $Self->{QueueObject}->QueueLookup( Queue => $ID->{Content} );
                    }
                    else {
                        $Self->{LogObject}->Log(
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

                    my %State = $Self->{StateObject}->StateGet(
                        Name  => $ID->{Content},
                        Cache => 1,
                    );
                    if ( $State{ID} ) {
                        $ID->{Content} = $State{ID};
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find state $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
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
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find priority $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif (
                $ElementName    eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    if ( $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} ) ) {
                        $ID->{Content} = $Self->{UserObject}->UserLookup(
                            UserLogin => $ID->{Content}
                        );
                    }
                    else {
                        $Self->{LogObject}->Log(
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

sub _TicketAttributes {
    my $Self = shift;

    my %TicketAttributes = (
        Number => 'Number',    # only a counter for a better readability
        TicketNumber => $Self->{ConfigObject}->Get('Ticket::Hook'),

        #TicketID       => 'TicketID',
        Age   => 'Age',
        Title => 'Title',
        Queue => 'Queue',

        #QueueID        => 'QueueID',
        State => 'State',

        #StateID        => 'StateID',
        Priority => 'Priority',

        #PriorityID     => 'PriorityID',
        CustomerID => 'CustomerID',
        Changed    => 'Changed',
        Created    => 'Created',

        #CreateTimeUnix => 'CreateTimeUnix',
        CustomerUserID => 'Customer User',
        Lock           => 'lock',

        #LockID         => 'LockID',
        UnlockTimeout       => 'UnlockTimeout',
        AccountedTime       => 'Accounted time',       # the same wording is in AgentTicketPrint.dtl
        RealTillTimeNotUsed => 'RealTillTimeNotUsed',

        #GroupID        => 'GroupID',
        StateType => 'StateType',
        UntilTime => 'UntilTime',
        Closed    => 'Close Time',
        FirstLock => 'First Lock',

        EscalationResponseTime => 'EscalationResponseTime',
        EscalationUpdateTime   => 'EscalationUpdateTime',
        EscalationSolutionTime => 'EscalationSolutionTime',

        EscalationDestinationIn => 'EscalationDestinationIn',

        # EscalationDestinationTime => 'EscalationDestinationTime',
        EscalationDestinationDate => 'EscalationDestinationDate',
        EscalationTimeWorkingTime => 'EscalationTimeWorkingTime',
        EscalationTime            => 'EscalationTime',

        FirstResponse                    => 'FirstResponse',
        FirstResponseInMin               => 'FirstResponseInMin',
        FirstResponseDiffInMin           => 'FirstResponseDiffInMin',
        FirstResponseTimeWorkingTime     => 'FirstResponseTimeWorkingTime',
        FirstResponseTimeEscalation      => 'FirstResponseTimeEscalation',
        FirstResponseTimeNotification    => 'FirstResponseTimeNotification',
        FirstResponseTimeDestinationTime => 'FirstResponseTimeDestinationTime',
        FirstResponseTimeDestinationDate => 'FirstResponseTimeDestinationDate',
        FirstResponseTime                => 'FirstResponseTime',

        UpdateTimeEscalation      => 'UpdateTimeEscalation',
        UpdateTimeNotification    => 'UpdateTimeNotification',
        UpdateTimeDestinationTime => 'UpdateTimeDestinationTime',
        UpdateTimeDestinationDate => 'UpdateTimeDestinationDate',
        UpdateTimeWorkingTime     => 'UpdateTimeWorkingTime',
        UpdateTime                => 'UpdateTime',

        SolutionTime                => 'SolutionTime',
        SolutionInMin               => 'SolutionInMin',
        SolutionDiffInMin           => 'SolutionDiffInMin',
        SolutionTimeWorkingTime     => 'SolutionTimeWorkingTime',
        SolutionTimeEscalation      => 'SolutionTimeEscalation',
        SolutionTimeNotification    => 'SolutionTimeNotification',
        SolutionTimeDestinationTime => 'SolutionTimeDestinationTime',
        SolutionTimeDestinationDate => 'SolutionTimeDestinationDate',
        SolutionTimeWorkingTime     => 'SolutionTimeWorkingTime',
    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $TicketAttributes{Service} = 'Service';

        #$TicketAttributes{ServiceID} = 'ServiceID',
        $TicketAttributes{SLA}   = 'SLA';
        $TicketAttributes{SLAID} = 'SLAID';
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $TicketAttributes{Type} = 'Type';

        #$TicketAttributes{TypeID} = 'TypeID';
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {
        $TicketAttributes{Owner} = 'Agent/Owner';

        #$TicketAttributes{OwnerID}        = 'OwnerID';
        # ? $TicketAttributes{CreatedUserIDs}  = 'Created by Agent/Owner';
        $TicketAttributes{Responsible} = 'Responsible';

        #$TicketAttributes{ResponsibleID}  = 'ResponsibleID';
    }

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        $TicketAttributes{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
            = $DynamicFieldConfig->{Label}
    }

    return \%TicketAttributes;
}

sub _SortedAttributes {
    my $Self = shift;

    my @SortedAttributes = qw(
        Number
        TicketNumber
        Age
        Title
        Created
        Changed
        Closed
        Queue
        State
        Priority
        CustomerUserID
        CustomerID
        Service
        SLA
        Type
        Owner
        Responsible
        AccountedTime
        EscalationDestinationIn
        EscalationDestinationTime
        EscalationDestinationDate
        EscalationTimeWorkingTime
        EscalationTime

        FirstResponse
        FirstResponseInMin
        FirstResponseDiffInMin
        FirstResponseTimeWorkingTime
        FirstResponseTimeEscalation
        FirstResponseTimeNotification
        FirstResponseTimeDestinationTime
        FirstResponseTimeDestinationDate
        FirstResponseTime

        UpdateTimeEscalation
        UpdateTimeNotification
        UpdateTimeDestinationTime
        UpdateTimeDestinationDate
        UpdateTimeWorkingTime
        UpdateTime

        SolutionTime
        SolutionInMin
        SolutionDiffInMin
        SolutionTimeWorkingTime
        SolutionTimeEscalation
        SolutionTimeNotification
        SolutionTimeDestinationTime
        SolutionTimeDestinationDate
        SolutionTimeWorkingTime

        FirstLock
        Lock
        StateType
        UntilTime
        UnlockTimeout
        EscalationResponseTime
        EscalationSolutionTime
        EscalationUpdateTime
        RealTillTimeNotUsed
    );

    # cycle trought the Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # add dynamic field attribute
        push @SortedAttributes, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@SortedAttributes;
}

sub _ExtendedAttributesCheck {
    my ( $Self, %Param ) = @_;

    my @ExtendedAttributes = qw(
        FirstResponse
        FirstResponseInMin
        FirstResponseDiffInMin
        FirstResponseTimeWorkingTime
        Closed
        SolutionTime
        SolutionInMin
        SolutionDiffInMin
        SolutionTimeWorkingTime
        FirstLock
    );

    ATTRIBUTE:
    for my $Attribute (@ExtendedAttributes) {
        return 1 if $Param{TicketAttributes}{$Attribute};
    }

    return;
}

sub _OrderByIsValueOfTicketSearchSort {
    my ( $Self, %Param ) = @_;

    my %SortOptions = (
        Age                    => 'Age',
        Created                => 'Age',
        CustomerID             => 'CustomerID',
        EscalationResponseTime => 'EscalationResponseTime',
        EscalationSolutionTime => 'EscalationSolutionTime',
        EscalationTime         => 'EscalationTime',
        EscalationUpdateTime   => 'EscalationUpdateTime',
        Lock                   => 'Lock',
        Owner                  => 'Owner',
        Priority               => 'Priority',
        Queue                  => 'Queue',
        Responsible            => 'Responsible',
        SLA                    => 'SLA',
        Service                => 'Service',
        State                  => 'State',
        TicketNumber           => 'Ticket',
        TicketEscalation       => 'TicketEscalation',
        Title                  => 'Title',
        Type                   => 'Type',
    );

    # cycle trought the Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # get dynamic field sortable condition
        my $IsSortable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsSortable',
        );

        # add dynamic field if is sortable
        if ($IsSortable) {
            $SortOptions{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                = 'DynamicField_' . $DynamicFieldConfig->{Name};
        }
    }

    return $SortOptions{ $Param{OrderBy} } if $SortOptions{ $Param{OrderBy} };
    return;
}

sub _IndividualResultOrder {
    my ( $Self, %Param ) = @_;
    my @Unsorted = @{ $Param{StatArray} };
    my @Sorted;

    # find out the positon of the values which should be
    # used for the order
    my $Counter          = 0;
    my $SortedAttributes = $Self->_SortedAttributes();

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributes} ) {
        next ATTRIBUTE if !$Param{SelectedAttributes}{$Attribute};
        last ATTRIBUTE if $Attribute eq $Param{OrderBy};
        $Counter++;
    }

    # order after a individual attribute
    if ( $Param{OrderBy} eq 'AccountedTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionTime' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionDiffInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponse' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseDiffInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstLock' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'StateType' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'UntilTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'UnlockTimeout' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationResponseTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationUpdateTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationSolutionTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'RealTillTimeNotUsed' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "There is no possibility to order the stats by $Param{OrderBy}! Sort it alpha numerical",
        );
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }

    # make a reverse sort if needed
    if ( $Param{Sort} eq 'Down' ) {
        @Sorted = reverse @Sorted;
    }

    # take care about the limit
    if ( $Param{Limit} && $Param{Limit} ne 'unlimited' ) {
        my $Count = 0;
        @Sorted = grep { ++$Count <= $Param{Limit} } @Sorted;
    }

    return @Sorted;
}

1;
