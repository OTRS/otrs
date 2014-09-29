# --
# Kernel/System/Stats/Dynamic/TicketAccountedTime.pm - stats for accounted ticket time
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TicketAccountedTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
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
    'Kernel::System::Ticket',
    'Kernel::System::Type',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DBSlaveObject} = $Param{DBSlaveObject} || $Kernel::OM->Get('Kernel::System::DB');

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'TicketAccountedTime';
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 1,
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

    # get user list
    my %UserList = $UserObject->UserList(
        Type  => 'Long',
        Valid => $ValidAgent,
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
            Name             => 'Evaluation by',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'KindsOfReporting',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedKindsOfReporting(),
            Values           => $Self->_KindsOfReporting(),
        },
        {
            Name             => 'Queue',
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
            Name             => 'State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'State Type',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateTypeIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateTypeList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created in Queue',
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
            Name             => 'Created Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedPriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Created State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreatedStateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },
        {
            Name             => 'Lock',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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
            Name             => 'Ticket/Article Accounted Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ArticleAccountedTime',
            TimePeriodFormat => 'DateInputFormat',                 # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'ArticleAccountedTimeNewerDate',
                TimeStop  => 'ArticleAccountedTimeOlderDate',
            },
        },
        {
            Name             => 'Ticket Create Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',      # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
        {
            Name             => 'Last changed times',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'LastChangeTime',
            TimePeriodFormat => 'DateInputFormat',      # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketLastChangeTimeNewerDate',
                TimeStop  => 'TicketLastChangeTimeOlderDate',
            },
        },
        {
            Name             => 'Change times',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ChangeTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketChangeTimeNewerDate',
                TimeStop  => 'TicketChangeTimeOlderDate',
            },
        },
        {
            Name             => 'Ticket Close Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CloseTime2',
            TimePeriodFormat => 'DateInputFormat',     # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
        {
            Name             => 'Escalation',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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

    if ( $ConfigObject->Get('Ticket::Service') ) {

        # get service list
        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            UserID => 1,
        );

        # get sla list
        my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => 1,
        );

        my @ObjectAttributeAdd = (
            {
                Name             => 'Service',
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
                Name             => 'SLA',
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
            Name             => 'Type',
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

    if ( $ConfigObject->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name             => 'Accounted time by Agent',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'AccountedByAgent',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Agent/Owner',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'OwnerIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Created by Agent/Owner',
                UseAsXvalue      => 1,
                UseAsValueSeries => 1,
                UseAsRestriction => 1,
                Element          => 'CreatedUserIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Responsible',
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

    if ( $ConfigObject->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get CustomerID
        # (This way also can be the solution for the CustomerUserID)
        $Self->{DBSlaveObject}->Prepare(
            SQL => "SELECT DISTINCT customer_id FROM ticket",
        );

        # fetch the result
        my %CustomerID;
        while ( my @Row = $Self->{DBSlaveObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerID{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => 'CustomerID',
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
                %{$PossibleValuesFilter}
                    = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }
        }

        # get field html
        my $DynamicFieldStatsParameter
            = $DynamicFieldBackendObject->StatsFieldParameterBuild(
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
                my $TimePeriodFormat
                    = $DynamicFieldStatsParameter->{TimePeriodFormat} || 'DateInputFormatLong';

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
                    Block            => $DynamicFieldStatsParameter->{Block},
                );
                push @ObjectAttributes, \%ObjectAttribute;
            }
        }
    }

    return @ObjectAttributes;
}

sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my @StatArray;
    if ( $Param{XValue}{Element} && $Param{XValue}{Element} eq 'KindsOfReporting' ) {

        for my $Row ( sort keys %{ $Param{TableStructure} } ) {
            my @ResultRow        = ($Row);
            my %SearchAttributes = ( %{ $Param{TableStructure}{$Row}[0] } );

            my %Reporting = $Self->_ReportingValues(
                SearchAttributes         => \%SearchAttributes,
                SelectedKindsOfReporting => $Param{XValue}{SelectedValues},
            );

            KIND:
            for my $Kind ( @{ $Self->_SortedKindsOfReporting() } ) {
                next KIND if !defined $Reporting{$Kind};
                push @ResultRow, $Reporting{$Kind};
            }
            push @StatArray, \@ResultRow;
        }
    }
    else {
        my $KindsOfReportingRef = $Self->_KindsOfReporting();
        $Param{Restrictions}{KindsOfReporting} ||= ['TotalTime'];
        my $NumberOfReportingKinds   = scalar @{ $Param{Restrictions}{KindsOfReporting} };
        my $SelectedKindsOfReporting = $Param{Restrictions}{KindsOfReporting};

        delete $Param{Restrictions}{KindsOfReporting};
        for my $Row ( sort keys %{ $Param{TableStructure} } ) {
            my @ResultRow = ($Row);

            for my $Cell ( @{ $Param{TableStructure}{$Row} } ) {
                my %SearchAttributes = %{$Cell};
                my %Reporting        = $Self->_ReportingValues(
                    SearchAttributes         => \%SearchAttributes,
                    SelectedKindsOfReporting => $SelectedKindsOfReporting,
                );

                my $CellContent = '';

                if ( $NumberOfReportingKinds == 1 ) {
                    my @Values = values %Reporting;
                    $CellContent = $Values[0];
                }
                else {

                    KIND:
                    for my $Kind ( @{ $Self->_SortedKindsOfReporting() } ) {
                        next KIND if !defined $Reporting{$Kind};
                        $CellContent
                            .= "$Reporting{$Kind} (" . $KindsOfReportingRef->{$Kind} . "), ";
                    }
                }
                push @ResultRow, $CellContent;
            }
            push @StatArray, \@ResultRow;
        }
    }
    return @StatArray;

}

sub GetHeaderLine {

    my ( $Self, %Param ) = @_;

    if ( $Param{XValue}{Element} eq 'KindsOfReporting' ) {

        my %Selected = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };

        my $Attributes = $Self->_KindsOfReporting();
        my @HeaderLine = ('Evaluation by');
        my $SortedRef  = $Self->_SortedKindsOfReporting();

        ATTRIBUTE:
        for my $Attribute ( @{$SortedRef} ) {
            next ATTRIBUTE if !$Selected{$Attribute};
            push @HeaderLine, $Attributes->{$Attribute};
        }
        return \@HeaderLine;

    }
    return;

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
                        $ID->{Content}
                            = $QueueObject->QueueLookup( Queue => $ID->{Content} );
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

sub _ReportingValues {
    my ( $Self, %Param ) = @_;
    my $SearchAttributes = $Param{SearchAttributes};
    my @Where;

    #
    # escape search attributes for ticket search
    #
    my %AttributesToEscape = (
        'CustomerID' => 1,
        'Title'      => 1,
    );

    # get ticket search relevant attributes
    my %TicketSearch;
    ATTRIBUTE:
    for my $Attribute ( @{ $Self->_AllowedTicketSearchAttributes() } ) {

        # special handling for dynamic field date/time fields
        if ( $Attribute =~ m{ \A DynamicField_ }xms ) {
            SEARCHATTRIBUTE:
            for my $SearchAttribute ( sort keys %{$SearchAttributes} ) {
                next SEARCHATTRIBUTE if $SearchAttribute !~ m{ \A \Q$Attribute\E _ }xms;
                $TicketSearch{$SearchAttribute} = $SearchAttributes->{$SearchAttribute};

                # don't exist loop
                # there can be more than one attribute param per allowed attribute
            }
        }
        else {
            next ATTRIBUTE if !$SearchAttributes->{$Attribute};
            $TicketSearch{$Attribute} = $SearchAttributes->{$Attribute};
        }

        next ATTRIBUTE if !$AttributesToEscape{$Attribute};

        # escape search parameters for ticket search
        if ( ref $TicketSearch{$Attribute} ) {
            if ( ref $TicketSearch{$Attribute} eq 'ARRAY' ) {
                $TicketSearch{$Attribute} = [
                    map { $Self->{DBSlaveObject}->QueryStringEscape( QueryString => $_ ) }
                        @{ $TicketSearch{$Attribute} }
                ];
            }
        }
        else {
            $TicketSearch{$Attribute} = $Self->{DBSlaveObject}->QueryStringEscape(
                QueryString => $TicketSearch{$Attribute}
            );
        }
    }

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $ParameterName ( sort keys %TicketSearch ) {
        if (
            $ParameterName =~ m{ \A DynamicField_ ( [a-zA-Z\d]+ ) (?: _ ( [a-zA-Z\d]+ ) )? \z }xms
            )
        {
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
                my $DynamicFieldStatsSearchParameter
                    = $DynamicFieldBackendObject->StatsSearchFieldParameterBuild(
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

    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {
        $SearchAttributes->{SearchInArchive} ||= '';
        if ( $SearchAttributes->{SearchInArchive} eq 'AllTickets' ) {
            $TicketSearch{ArchiveFlags} = [ 'y', 'n' ];
        }
        elsif ( $SearchAttributes->{SearchInArchive} eq 'ArchivedTickets' ) {
            $TicketSearch{ArchiveFlags} = ['y'];
        }
        else {
            $TicketSearch{ArchiveFlags} = ['n'];
        }
    }

    if (%TicketSearch) {

        # get the involved tickets
        my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            UserID     => 1,
            Result     => 'ARRAY',
            Permission => 'ro',
            Limit      => 100_000_000,
            %TicketSearch,
        );

        # do nothing, if there are no tickets
        if ( !@TicketIDs ) {
            my %Reporting;
            for my $Kind ( @{ $Param{SelectedKindsOfReporting} } ) {
                $Reporting{$Kind} = 0;
            }
            return %Reporting;
        }

        # get db type
        my $DBType = $Self->{DBSlaveObject}->{'DB::Type'};

        # here comes a workaround for ORA-01795: maximum number of expressions in a list is 1000
        # for oracle we make sure, that we don 't get more than 1000 ticket ids in a list
        # so instead of "ticket_id IN ( 1, 2, 3, ... 2001 )", we are splitting this up to
        # "ticket_id IN ( 1, 2, 3, ... 1000 ) OR ticket_id IN ( 1001, 1002, ... 2000)"
        # see bugzilla #9723: http://bugs.otrs.org/show_bug.cgi?id=9723
        if ( $DBType eq 'oracle' ) {

            # save number of TicketIDs
            my $TicketAmount = scalar @TicketIDs;

            # init vars
            my @TicketIDStrings;
            my $TicktIDString   = '';
            my $TicketIDCounter = 1;

            # build array of strings with a maximum of 1000 ticket ids
            for my $TicketID (@TicketIDs) {

                # start building string
                if ( $TicketIDCounter == 1 ) {
                    $TicktIDString .= $TicketID;
                }
                else {
                    $TicktIDString .= ', ' . $TicketID;
                }

                # at 1000 elements push them into array
                if ( $TicketIDCounter == 1000 ) {

                    # push string with maximum of 1000 values
                    push @TicketIDStrings, $TicktIDString;

                    # subtract 1000 from remaining ticket amount
                    # we use this to push the remaining tickets
                    $TicketAmount = $TicketAmount - 1000;

                    # reset variables
                    $TicktIDString   = '';
                    $TicketIDCounter = 0;
                }
                $TicketIDCounter++;
            }

            # check if there are tickets left
            if ($TicketAmount) {

                # push remaining tickets
                push @TicketIDStrings, $TicktIDString;
            }

            # init used vars for the following loop
            my $TicketStringCounter = 1;
            my $TicketString        = '';

            # build sql string
            for my $TicketIDString (@TicketIDStrings) {
                if ( $TicketStringCounter == 1 ) {
                    $TicketString .= "ticket_id IN ( $TicketIDString )";
                }
                else {
                    $TicketString .= " OR ticket_id IN ( $TicketIDString )";
                }
                $TicketStringCounter++;
            }

            push @Where, $TicketString;
        }
        else {

            # for all other databases, just join all TicketIDs in a string
            my $TicketString = join ', ', @TicketIDs;
            push @Where, "ticket_id IN ( $TicketString )";
        }
    }

    if ( $SearchAttributes->{AccountedByAgent} ) {
        my @AccountedByAgent = map { $Self->{DBSlaveObject}->Quote( $_, 'Integer' ) }
            @{ $SearchAttributes->{AccountedByAgent} };
        my $String = join ', ', @AccountedByAgent;
        push @Where, "create_by IN ( $String )";
    }

    if (
        $SearchAttributes->{ArticleAccountedTimeOlderDate}
        && $SearchAttributes->{ArticleAccountedTimeNewerDate}
        )
    {
        my $Start
            = $Self->{DBSlaveObject}->Quote( $SearchAttributes->{ArticleAccountedTimeNewerDate} );
        my $Stop
            = $Self->{DBSlaveObject}->Quote( $SearchAttributes->{ArticleAccountedTimeOlderDate} );
        push @Where, "create_time >= '$Start' AND create_time <= '$Stop'";
    }
    my $WhereString = '';
    if (@Where) {
        $WhereString = 'WHERE ' . join ' AND ', @Where;
    }

    # ask only for the needed kinds to get a better performance
    my %SelectedKindsOfReporting = map { $_ => 1 } @{ $Param{SelectedKindsOfReporting} };
    my %Reporting;

    if ( $SelectedKindsOfReporting{TotalTime} ) {

        # db query
        $Self->{DBSlaveObject}->Prepare(
            SQL => "SELECT SUM(time_unit) FROM time_accounting $WhereString"
        );

        while ( my @Row = $Self->{DBSlaveObject}->FetchrowArray() ) {
            $Reporting{TotalTime} = $Row[0] ? int( $Row[0] * 100 ) / 100 : 0;
        }
    }
    if (
        !$SelectedKindsOfReporting{TicketAverage}
        && !$SelectedKindsOfReporting{TicketMinTime}
        && !$SelectedKindsOfReporting{TicketMaxTime}
        && !$SelectedKindsOfReporting{NumberOfTickets}
        && !$SelectedKindsOfReporting{ArticleAverage}
        && !$SelectedKindsOfReporting{ArticleMaxTime}
        && !$SelectedKindsOfReporting{ArticleMinTime}
        && !$SelectedKindsOfReporting{NumberOfArticles}
        )
    {
        return %Reporting;
    }

    # db query
    $Self->{DBSlaveObject}->Prepare(
        SQL => "SELECT ticket_id, article_id, time_unit FROM time_accounting $WhereString"
    );

    my %TicketID;
    my %ArticleID;
    my $Time = 0;
    while ( my @Row = $Self->{DBSlaveObject}->FetchrowArray() ) {
        $TicketID{ $Row[0] }  += $Row[2];
        $ArticleID{ $Row[1] } += $Row[2];
        $Time                 += $Row[2];
    }

    my @TicketTimeLine  = sort { $a <=> $b } values %TicketID;
    my @ArticleTimeLine = sort { $a <=> $b } values %ArticleID;

    if ( $SelectedKindsOfReporting{TicketAverage} ) {
        my $NumberOfTickets = scalar keys %TicketID;
        my $Average = $NumberOfTickets ? $Time / $NumberOfTickets : 0;
        $Reporting{TicketAverage} = sprintf( "%.2f", $Average );
    }
    if ( $SelectedKindsOfReporting{TicketMinTime} ) {
        $Reporting{TicketMinTime} = $TicketTimeLine[0] || 0;
    }
    if ( $SelectedKindsOfReporting{TicketMaxTime} ) {
        $Reporting{TicketMaxTime} = $TicketTimeLine[-1] || 0;
    }
    if ( $SelectedKindsOfReporting{NumberOfTickets} ) {
        $Reporting{NumberOfTickets} = scalar keys %TicketID;
    }
    if ( $SelectedKindsOfReporting{ArticleAverage} ) {
        my $NumberOfArticles = scalar keys %ArticleID;
        my $Average = $NumberOfArticles ? $Time / $NumberOfArticles : 0;
        $Reporting{ArticleAverage} = sprintf( "%.2f", $Average );
    }
    if ( $SelectedKindsOfReporting{ArticleMinTime} ) {
        $Reporting{ArticleMinTime} = $ArticleTimeLine[0] || 0;
    }
    if ( $SelectedKindsOfReporting{ArticleMaxTime} ) {
        $Reporting{ArticleMaxTime} = $ArticleTimeLine[-1] || 0;
    }
    if ( $SelectedKindsOfReporting{NumberOfArticles} ) {
        $Reporting{NumberOfArticles} = scalar keys %ArticleID;
    }

    return %Reporting;
}

sub _KindsOfReporting {
    my $Self = shift;

    my %KindsOfReporting = (
        TotalTime        => 'Total Time',
        TicketAverage    => 'Ticket Average',
        TicketMinTime    => 'Ticket Min Time',
        TicketMaxTime    => 'Ticket Max Time',
        NumberOfTickets  => 'Number of Tickets',
        ArticleAverage   => 'Article Average',
        ArticleMinTime   => 'Article Min Time',
        ArticleMaxTime   => 'Article Max Time',
        NumberOfArticles => 'Number of Articles',
    );
    return \%KindsOfReporting;
}

sub _SortedKindsOfReporting {
    my $Self = shift;

    my @SortedKindsOfReporting = qw(
        TotalTime
        TicketAverage
        TicketMinTime
        TicketMaxTime
        NumberOfTickets
        ArticleAverage
        ArticleMinTime
        ArticleMaxTime
        NumberOfArticles
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
        CustomerUserLogin
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
        TicketPendingTimeNewerDate
        TicketPendingTimeOlderDate
        TicketEscalationTimeNewerDate
        TicketEscalationTimeOlderDate
        TicketEscalationUpdateTimeNewerDate
        TicketEscalationUpdateTimeOlderDate
        TicketEscalationResponseTimeNewerDate
        TicketEscalationResponseTimeOlderDate
        TicketEscalationSolutionTimeNewerDate
        TicketEscalationSolutionTimeOlderDate
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
