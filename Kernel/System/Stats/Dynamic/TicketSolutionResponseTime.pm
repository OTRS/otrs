# --
# Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm - stats about ticket solution and response time
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TicketSolutionResponseTime;

use strict;
use warnings;

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
            Name             => 'Create Time',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
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
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CloseTime2',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
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

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {

        # get ticket type list
        my %Type = $Self->{TypeObject}->TypeList(
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

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
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

        # get field html
        my $DynamicFieldStatsParameter = $Self->{BackendObject}->StatsFieldParameterBuild(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
        );

        if ( IsHashRefWithData($DynamicFieldStatsParameter) ) {
            if ( IsHashRefWithData( $DynamicFieldStatsParameter->{Values} ) ) {

                my %ObjectAttribute = (
                    Name             => $DynamicFieldStatsParameter->{Name},
                    UseAsXvalue      => 1,
                    UseAsValueSeries => 1,
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

# REMARK: is the same code as in TicketAccountedTime.pm

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
        $Param{Restrictions}{KindsOfReporting} ||= ['SolutionAverageAllOver'];
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

sub _ReportingValues {
    my ( $Self, %Param ) = @_;
    my $SearchAttributes = $Param{SearchAttributes};

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
        next ATTRIBUTE if !$SearchAttributes->{$Attribute};
        $TicketSearch{$Attribute} = $SearchAttributes->{$Attribute};

        next ATTRIBUTE if !$AttributesToEscape{$Attribute};

        # escape search parameters for ticket search
        if ( ref $TicketSearch{$Attribute} ) {
            if ( ref $TicketSearch{$Attribute} eq 'ARRAY' ) {
                $TicketSearch{$Attribute} = [
                    map { $Self->{DBObject}->QueryStringEscape( QueryString => $_ ) }
                        @{ $TicketSearch{$Attribute} }
                ];
            }
        }
        else {
            $TicketSearch{$Attribute} = $Self->{DBObject}->QueryStringEscape(
                QueryString => $TicketSearch{$Attribute}
            );
        }
    }

    # do nothing, if there are no search attributes
    return map { $_ => 0 } @{ $Param{SelectedKindsOfReporting} } if !%TicketSearch;

    for my $ParameterName ( sort keys %TicketSearch ) {
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
                    Value              => $TicketSearch{$ParameterName},
                    );

                # add new search parameter
                $TicketSearch{$ParameterName} = $DynamicFieldStatsSearchParameter;
            }
        }
    }

    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {
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

    # get the involved tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        UserID     => 1,
        Result     => 'ARRAY',
        Permission => 'ro',
        Limit      => 100_000_000,
        StateType  => 'Closed',
        %TicketSearch,
    );

    # do nothing, if there are no tickets
    return map { $_ => 0 } @{ $Param{SelectedKindsOfReporting} } if !@TicketIDs;

    my $Counter        = 0;
    my $CounterAllOver = 0;

    my %SolutionAllOver;
    my %Solution;
    my %SolutionWorkingTime;
    my %Response;
    my %ResponseWorkingTime;

    for my $TicketID (@TicketIDs) {
        $CounterAllOver++;
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            Extended      => 1,
            DynamicFields => 0,
        );

        my $SolutionTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Ticket{SolutionTime},
        );

        $SolutionAllOver{$TicketID} = $SolutionTime - $Ticket{CreateTimeUnix};

        next if !defined $Ticket{SolutionInMin};

        # now collect only data of tickets which are affected by a escalation config

        $Counter++;
        $Solution{$TicketID}            = $SolutionAllOver{$TicketID};
        $SolutionWorkingTime{$TicketID} = $Ticket{SolutionInMin};

        if ( $Ticket{FirstResponse} ) {
            my $FirstResponse = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Ticket{FirstResponse},
            );

            $Response{$TicketID}            = $FirstResponse - $Ticket{CreateTimeUnix};
            $ResponseWorkingTime{$TicketID} = $Ticket{FirstResponseInMin};
        }
        else {
            $Response{$TicketID}            = 0;
            $ResponseWorkingTime{$TicketID} = 0;
        }
    }

    my %Reporting;
    my %SelectedKindsOfReporting = map { $_ => 1 } @{ $Param{SelectedKindsOfReporting} };

    # different solution averages
    if ( $SelectedKindsOfReporting{SolutionAverageAllOver} ) {
        $Reporting{SolutionAverageAllOver} = $Self->_GetAverage(
            Count   => $CounterAllOver,
            Content => \%SolutionAllOver,
        );
    }
    if ( $SelectedKindsOfReporting{SolutionAverage} ) {
        $Reporting{SolutionAverage} = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%Solution,
        );
    }
    if ( $SelectedKindsOfReporting{SolutionWorkingTimeAverage} ) {
        $Reporting{SolutionWorkingTimeAverage} = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%SolutionWorkingTime,
        );
    }

    # response average
    if ( $SelectedKindsOfReporting{ResponseAverage} ) {
        $Reporting{ResponseAverage} = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%Response,
        );
    }
    if ( $SelectedKindsOfReporting{ResponseWorkingTimeAverage} ) {
        $Reporting{ResponseWorkingTimeAverage} = $Self->_GetAverage(
            Count   => $Counter,
            Content => \%ResponseWorkingTime,
        );
    }

    # min max for standard solution
    if ( $SelectedKindsOfReporting{SolutionMinTimeAllOver} ) {
        if (%SolutionAllOver) {
            $Reporting{SolutionMinTimeAllOver} = ( sort { $a <=> $b } values %SolutionAllOver )[0];
        }
        else {
            $Reporting{SolutionMinTimeAllOver} = 0;
        }
    }
    if ( $SelectedKindsOfReporting{SolutionMaxTimeAllOver} ) {
        if (%SolutionAllOver) {
            $Reporting{SolutionMaxTimeAllOver} = ( sort { $b <=> $a } values %SolutionAllOver )[0];
        }
        else {
            $Reporting{SolutionMaxTimeAllOver} = 0;
        }
    }

    # min max for solution time with configured escalation
    if ( $SelectedKindsOfReporting{SolutionMinTime} ) {
        if (%Solution) {
            $Reporting{SolutionMinTime} = ( sort { $a <=> $b } values %Solution )[0];
        }
        else {
            $Reporting{SolutionMinTime} = 0;
        }
    }
    if ( $SelectedKindsOfReporting{SolutionMaxTime} ) {
        if (%Solution) {
            $Reporting{SolutionMaxTime} = ( sort { $b <=> $a } values %Solution )[0];
        }
        else {
            $Reporting{SolutionMaxTime} = 0;
        }
    }

    # min max for solution working time
    if ( $SelectedKindsOfReporting{SolutionMinWorkingTime} ) {
        if (%SolutionWorkingTime) {
            $Reporting{SolutionMinWorkingTime}
                = ( sort { $a <=> $b } values %SolutionWorkingTime )[0];
        }
        else {
            $Reporting{SolutionMinWorkingTime} = 0;
        }
    }
    if ( $SelectedKindsOfReporting{SolutionMaxWorkingTime} ) {
        if (%SolutionWorkingTime) {
            $Reporting{SolutionMaxWorkingTime}
                = ( sort { $b <=> $a } values %SolutionWorkingTime )[0];
        }
        else {
            $Reporting{SolutionMaxWorkingTime} = 0;
        }
    }

    # min max for response time
    if ( $SelectedKindsOfReporting{ResponseMinTime} ) {
        if (%Response) {
            $Reporting{ResponseMinTime} = ( sort { $a <=> $b } values %Response )[0];
        }
        else {
            $Reporting{ResponseMinTime} = 0;
        }
    }
    if ( $SelectedKindsOfReporting{ResponseMaxTime} ) {
        if (%Response) {
            $Reporting{ResponseMaxTime} = ( sort { $b <=> $a } values %Response )[0];
        }
        else {
            $Reporting{ResponseMaxTime} = 0;
        }
    }

    # min max for response working time
    if ( $SelectedKindsOfReporting{ResponseMinWorkingTime} ) {
        if (%ResponseWorkingTime) {
            $Reporting{ResponseMinWorkingTime}
                = ( sort { $a <=> $b } values %ResponseWorkingTime )[0];
        }
        else {
            $Reporting{ResponseMinWorkingTime} = 0;
        }
    }
    if ( $SelectedKindsOfReporting{ResponseMaxWorkingTime} ) {
        if (%ResponseWorkingTime) {
            $Reporting{ResponseMaxWorkingTime}
                = ( sort { $b <=> $a } values %ResponseWorkingTime )[0];
        }
        else {
            $Reporting{ResponseMaxWorkingTime} = 0;
        }
    }

    # add the number of values
    if ( $SelectedKindsOfReporting{NumberOfTickets} ) {
        $Reporting{NumberOfTickets} = $Counter;
    }
    if ( $SelectedKindsOfReporting{NumberOfTicketsAllOver} ) {
        $Reporting{NumberOfTicketsAllOver} = $CounterAllOver;
    }

    # get the correct data format
    # convert seconds in minutes

    for my $Key (
        qw(ResponseMaxTime ResponseMinTime SolutionMaxTime SolutionMinTime SolutionMaxTimeAllOver
        SolutionMinTimeAllOver SolutionAverageAllOver SolutionAverage ResponseAverage
        )
        )
    {
        if ( defined $Reporting{$Key} ) {
            $Reporting{$Key} = int( $Reporting{$Key} / 60 + 0.5 );
        }
    }

    # convert min in hh:mm
    KEY:
    for my $Key ( sort keys %Reporting ) {
        next KEY if $Key eq 'NumberOfTickets' || $Key eq 'NumberOfTicketsAllOver';
        my $Hours   = int( $Reporting{$Key} / 60 );
        my $Minutes = int( $Reporting{$Key} % 60 );
        $Reporting{$Key} = $Hours . 'h ' . $Minutes . 'm';
    }

    return %Reporting;
}

sub _GetAverage {
    my ( $Self, %Param ) = @_;
    return 0 if !$Param{Count};

    my $Sum = 0;
    for my $Value ( values %{ $Param{Content} } ) {
        $Sum += $Value;
    }
    return $Sum / $Param{Count};
}

sub _KindsOfReporting {
    my $Self = shift;

    my %KindsOfReporting = (
        SolutionAverageAllOver => 'Solution Average',
        SolutionMinTimeAllOver => 'Solution Min Time',
        SolutionMaxTimeAllOver => 'Solution Max Time',
        NumberOfTicketsAllOver => 'Number of Tickets',
        SolutionAverage        => 'Solution Average (affected by escalation configuration)',
        SolutionMinTime        => 'Solution Min Time (affected by escalation configuration)',
        SolutionMaxTime        => 'Solution Max Time (affected by escalation configuration)',
        SolutionWorkingTimeAverage =>
            'Solution Working Time Average (affected by escalation configuration)',
        SolutionMinWorkingTime =>
            'Solution Min Working Time (affected by escalation configuration)',
        SolutionMaxWorkingTime =>
            'Solution Max Working Time (affected by escalation configuration)',
        ResponseAverage => 'Response Average (affected by escalation configuration)',
        ResponseMinTime => 'Response Min Time (affected by escalation configuration)',
        ResponseMaxTime => 'Response Max Time (affected by escalation configuration)',
        ResponseWorkingTimeAverage =>
            'Response Working Time Average (affected by escalation configuration)',
        ResponseMinWorkingTime =>
            'Response Min Working Time (affected by escalation configuration)',
        ResponseMaxWorkingTime =>
            'Response Max Working Time (affected by escalation configuration)',
        NumberOfTickets => 'Number of Tickets (affected by escalation configuration)',
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
