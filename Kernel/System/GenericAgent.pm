# --
# Kernel/System/GenericAgent.pm - generic agent system module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericAgent;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::GenericAgent - to manage the generic agent jobs

=head1 SYNOPSIS

All functions to manage the generic agent and the generic agent jobs.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::Queue;
    use Kernel::System::Ticket;
    use Kernel::System::GenericAgent;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $QueueObject = Kernel::System::Queue->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );
    my $GenericAgentObject = Kernel::System::GenericAgent->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        TimeObject   => $TimeObject,
        TicketObject => $TicketObject,
        QueueObject  => $QueueObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(DBObject ConfigObject LogObject TimeObject TicketObject QueueObject MainObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # notice on STDOUT
    $Self->{NoticeSTDOUT} = $Param{NoticeSTDOUT} || 0;

    my %Map = (
        TicketNumber            => 'SCALAR',
        Title                   => 'SCALAR',
        From                    => 'SCALAR',
        To                      => 'SCALAR',
        Cc                      => 'SCALAR',
        Subject                 => 'SCALAR',
        Body                    => 'SCALAR',
        TimeUnit                => 'SCALAR',
        CustomerID              => 'SCALAR',
        CustomerUserLogin       => 'SCALAR',
        Agent                   => 'SCALAR',
        StateIDs                => 'ARRAY',
        StateTypeIDs            => 'ARRAY',
        QueueIDs                => 'ARRAY',
        PriorityIDs             => 'ARRAY',
        OwnerIDs                => 'ARRAY',
        LockIDs                 => 'ARRAY',
        TypeIDs                 => 'ARRAY',
        ResponsibleIDs          => 'ARRAY',
        ServiceIDs              => 'ARRAY',
        SLAIDs                  => 'ARRAY',
        NewTitle                => 'SCALAR',
        NewCustomerID           => 'SCALAR',
        NewCustomerUserLogin    => 'SCALAR',
        NewStateID              => 'SCALAR',
        NewQueueID              => 'SCALAR',
        NewPriorityID           => 'SCALAR',
        NewOwnerID              => 'SCALAR',
        NewLockID               => 'SCALAR',
        NewTypeID               => 'SCALAR',
        NewResponsibleID        => 'SCALAR',
        NewServiceID            => 'SCALAR',
        NewSLAID                => 'SCALAR',
        ScheduleLastRun         => 'SCALAR',
        ScheduleLastRunUnixTime => 'SCALAR',
        Valid                   => 'SCALAR',
        ScheduleDays            => 'ARRAY',
        ScheduleMinutes         => 'ARRAY',
        ScheduleHours           => 'ARRAY',
    );

    # add time attributes
    for my $Type (
        qw(Time ChangeTime CloseTime TimePending EscalationTime EscalationResponseTime EscalationUpdateTime EscalationSolutionTime)
        )
    {
        my $Key = $Type . 'SearchType';
        $Map{$Key} = 'SCALAR';
    }
    for my $Type (
        qw(TicketCreate TicketChange TicketClose TicketPending TicketEscalation TicketEscalationResponse TicketEscalationUpdate TicketEscalationSolution)
        )
    {
        for my $Attribute (
            qw(PointFormat Point PointStart Start StartDay StartMonth StartYear Stop StopDay StopMonth StopYear)
            )
        {
            my $Key = $Type . 'Time' . $Attribute;
            $Map{$Key} = 'SCALAR';
        }
    }

    # Add Dynamic Fields attributes
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get the field type of the dynamic fields for edit and search
        my $FieldValueType = $Self->{BackendObject}->TemplateValueTypeGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            FieldType          => 'All',
        );

        # Add field type to Map
        if ( IsHashRefWithData($FieldValueType) ) {
            for my $FieldName ( sort keys %{$FieldValueType} ) {
                $Map{$FieldName} = $FieldValueType->{$FieldName};
            }
        }
    }

    $Self->{Map} = \%Map;

    return $Self;
}

=item JobRun()

run a generic agent job

    $GenericAgentObject->JobRun(
        Job    => 'JobName',
        UserID => 1,
    );

=cut

sub JobRun {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Job UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( $Self->{NoticeSTDOUT} ) {
        print "Job: '$Param{Job}'\n";
    }

    # get job from param
    my %Job;
    my %DynamicFieldSearchTemplate;
    if ( $Param{Config} ) {
        %Job = %{ $Param{Config} };

        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Run GenericAgent Job '$Param{Job}' from config file.",
        );
    }

    # get db job
    else {

        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Run GenericAgent Job '$Param{Job}' from db.",
        );

        # get job data
        my %DBJobRaw = $Self->JobGet( Name => $Param{Job} );

        # updated last run time
        $Self->_JobUpdateRunTime( Name => $Param{Job}, UserID => $Param{UserID} );

        # rework
        for my $Key ( sort keys %DBJobRaw ) {
            if ( $Key =~ /^New/ ) {
                my $NewKey = $Key;
                $NewKey =~ s/^New//;
                $Job{New}->{$NewKey} = $DBJobRaw{$Key};
            }
            else {

                # skip dynamic fields
                if ( $Key !~ m{ DynamicField_ }xms ) {
                    $Job{$Key} = $DBJobRaw{$Key};
                }
            }

            # convert dynamic fields
            if ( $Key =~ m{ \A DynamicField_ }xms ) {
                $Job{New}->{$Key} = $DBJobRaw{$Key};
            }
            elsif ( $Key =~ m{ \A Search_DynamicField_ }xms ) {
                $DynamicFieldSearchTemplate{$Key} = $DBJobRaw{$Key};
            }
        }
        if ( exists $Job{SearchInArchive} && $Job{SearchInArchive} eq 'ArchivedTickets' ) {
            $Job{ArchiveFlags} = ['y'];
        }
        if ( exists $Job{SearchInArchive} && $Job{SearchInArchive} eq 'AllTickets' ) {
            $Job{ArchiveFlags} = [ 'y', 'n' ];
        }
    }

    # set dynamic fields search parameters
    my %DynamicFieldSearchParameters;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get field value from the information extracted from Generic Agent job
        my $Value = $Self->{BackendObject}->SearchFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            Profile            => \%DynamicFieldSearchTemplate,
        ) || '';

        if ($Value) {

            # get search attibutes
            my $SearchParameter = $Self->{BackendObject}->CommonSearchFieldParameterBuild(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
            );

            # add search attribute to the search structure
            $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                = $SearchParameter;
        }
    }

    my %Tickets;

    # escalation tickets
    if ( $Job{Escalation} ) {

        my @Tickets = $Self->{TicketObject}->TicketSearch(
            Result                           => 'ARRAY',
            Limit                            => 100,
            TicketEscalationTimeOlderMinutes => -( 3 * 8 * 60 ),       # 3 days, roughly
            Permission                       => 'rw',
            UserID                           => $Param{UserID} || 1,
        );

        for (@Tickets) {
            if ( !$Job{Queue} ) {
                $Tickets{$_} = $Self->{TicketObject}->TicketNumberLookup( TicketID => $_ );
            }
            else {
                my %Ticket = $Self->{TicketObject}->TicketGet(
                    TicketID      => $_,
                    DynamicFields => 0,
                );
                if ( $Ticket{Queue} eq $Job{Queue} ) {
                    $Tickets{$_} = $Ticket{TicketNumber};
                }
            }
        }
    }

    # pending tickets
    elsif ( $Job{PendingReminder} || $Job{PendingAuto} ) {
        my $Type = '';
        if ( $Job{PendingReminder} ) {
            $Type = 'PendingReminder';
        }
        else {
            $Type = 'PendingAuto';
        }
        if ( !$Job{Queue} ) {
            %Tickets = (
                $Self->{TicketObject}->TicketSearch(
                    %Job,
                    %DynamicFieldSearchParameters,
                    ConditionInline => 1,
                    StateType       => $Type,
                    Limit           => $Param{Limit} || 4000,
                    UserID          => $Param{UserID},
                ),
                %Tickets
            );
        }
        elsif ( ref $Job{Queue} eq 'ARRAY' ) {
            for ( @{ $Job{Queue} } ) {
                if ( $Self->{NoticeSTDOUT} ) {
                    print " For Queue: $_\n";
                }
                %Tickets = (
                    $Self->{TicketObject}->TicketSearch(
                        %Job,
                        %DynamicFieldSearchParameters,
                        ConditionInline => 1,
                        Queues          => [$_],
                        StateType       => $Type,
                        Limit           => $Param{Limit} || 4000,
                        UserID          => $Param{UserID},
                    ),
                    %Tickets
                );
            }
        }
        else {
            %Tickets = (
                $Self->{TicketObject}->TicketSearch(
                    %Job,
                    %DynamicFieldSearchParameters,
                    ConditionInline => 1,
                    StateType       => $Type,
                    Queues          => [ $Job{Queue} ],
                    Limit           => $Param{Limit} || 4000,
                    UserID          => $Param{UserID},
                ),
                %Tickets
            );
        }
        for ( sort keys %Tickets ) {
            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID      => $_,
                DynamicFields => 0,
            );
            if ( $Ticket{UntilTime} > 1 ) {
                delete $Tickets{$_};
            }
        }
    }

    # get regular tickets
    else {
        if ( !$Job{Queue} ) {

            # check min. one search arg
            my $Count = 0;
            for ( sort keys %Job ) {
                if ( $_ !~ /^(New|Name|Valid|Schedule)/ && $Job{$_} ) {
                    $Count++;
                }
            }

            # also search in Dynamic fields search attributes
            for my $DynamicFieldName ( sort keys %DynamicFieldSearchParameters ) {
                $Count++;
            }

            # log no search attribute
            if ( !$Count ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Attention: Can't run GenericAgent Job '$Param{Job}' because no "
                        . "search attributes are used!.",
                );
                return;
            }

            # search tickets
            if ( $Self->{NoticeSTDOUT} ) {
                print " For all Queues: \n";
            }
            %Tickets = $Self->{TicketObject}->TicketSearch(
                %Job,
                %DynamicFieldSearchParameters,
                ConditionInline => 1,
                Limit           => $Param{Limit} || 4000,
                UserID          => $Param{UserID},
            );
        }
        elsif ( ref $Job{Queue} eq 'ARRAY' ) {
            for ( @{ $Job{Queue} } ) {
                if ( $Self->{NoticeSTDOUT} ) {
                    print " For Queue: $_\n";
                }
                %Tickets = (
                    $Self->{TicketObject}->TicketSearch(
                        %Job,
                        %DynamicFieldSearchParameters,
                        ConditionInline => 1,
                        Queues          => [$_],
                        Limit           => $Param{Limit} || 4000,
                        UserID          => $Param{UserID},
                    ),
                    %Tickets
                );
            }
        }
        else {
            %Tickets = $Self->{TicketObject}->TicketSearch(
                %Job,
                %DynamicFieldSearchParameters,
                ConditionInline => 1,
                Queues          => [ $Job{Queue} ],
                Limit           => $Param{Limit} || 4000,
                UserID          => $Param{UserID},
            );
        }
    }

    # process each ticket
    for ( sort keys %Tickets ) {
        $Self->_JobRunTicket(
            Config       => \%Job,
            Job          => $Param{Job},
            TicketID     => $_,
            TicketNumber => $Tickets{$_},
            UserID       => $Param{UserID},
        );
    }
    return 1;
}

=item JobList()

returns a hash of jobs

    my %List = $GenericAgentObject->JobList();

=cut

sub JobList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT DISTINCT(job_name) FROM generic_agent_jobs',
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[0];
    }
    return %Data;
}

=item JobGet()

returns a hash of the job data

    my %Job = $GenericAgentObject->JobGet(Name => 'JobName');

=cut

sub JobGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT job_key, job_value FROM generic_agent_jobs WHERE job_name = ?',
        Bind => [ \$Param{Name} ],
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Self->{Map}->{ $Row[0] } && $Self->{Map}->{ $Row[0] } eq 'ARRAY' ) {
            push @{ $Data{ $Row[0] } }, $Row[1];
        }
        else {
            $Data{ $Row[0] } = $Row[1];
        }
    }
    for my $Key ( sort keys %Data ) {
        if ( $Key =~ /(NewParam)Key(\d)/ ) {
            if ( $Data{"$1Value$2"} ) {
                $Data{"New$Data{$Key}"} = $Data{"$1Value$2"};
            }
        }
    }

    # get time settings
    my %Map = (
        TicketCreate             => 'Time',
        TicketChange             => 'ChangeTime',
        TicketClose              => 'CloseTime',
        TicketPending            => 'TimePending',
        TicketEscalation         => 'EscalationTime',
        TicketEscalationResponse => 'EscalationResponseTime',
        TicketEscalationUpdate   => 'EscalationUpdateTime',
        TicketEscalationSolution => 'EscalationSolutionTime',
    );
    for my $Type (
        qw(TicketCreate TicketChange TicketClose TicketPending TicketEscalation TicketEscalationResponse TicketEscalationUpdate TicketEscalationSolution)
        )
    {
        my $SearchType = $Map{$Type} . 'SearchType';

        if ( !$Data{$SearchType} || $Data{$SearchType} eq 'None' ) {

            # do nothing on time stuff
            for (
                qw(TimeStartMonth TimeStopMonth TimeStopDay
                TimeStartDay TimeStopYear TimePoint
                TimeStartYear TimePointFormat TimePointStart)
                )
            {
                delete $Data{ $Type . $_ };
            }
        }
        elsif ( $Data{$SearchType} && $Data{$SearchType} eq 'TimeSlot' ) {
            for (qw(TimePoint TimePointFormat TimePointStart)) {
                delete $Data{ $Type . $_ };
            }
            for (qw(Month Day)) {
                $Data{ $Type . "TimeStart$_" } = sprintf( '%02d', $Data{ $Type . "TimeStart$_" } );
                $Data{ $Type . "TimeStop$_" }  = sprintf( '%02d', $Data{ $Type . "TimeStop$_" } );
            }
            if (
                $Data{ $Type . 'TimeStartDay' }
                && $Data{ $Type . 'TimeStartMonth' }
                && $Data{ $Type . 'TimeStartYear' }
                )
            {
                $Data{ $Type . 'TimeNewerDate' }
                    = $Data{ $Type . 'TimeStartYear' } . '-'
                    . $Data{ $Type . 'TimeStartMonth' } . '-'
                    . $Data{ $Type . 'TimeStartDay' }
                    . ' 00:00:01';
            }
            if (
                $Data{ $Type . 'TimeStopDay' }
                && $Data{ $Type . 'TimeStopMonth' }
                && $Data{ $Type . 'TimeStopYear' }
                )
            {
                $Data{ $Type . 'TimeOlderDate' }
                    = $Data{ $Type . 'TimeStopYear' } . '-'
                    . $Data{ $Type . 'TimeStopMonth' } . '-'
                    . $Data{ $Type . 'TimeStopDay' }
                    . ' 23:59:59';
            }
        }
        elsif ( $Data{$SearchType} && $Data{$SearchType} eq 'TimePoint' ) {
            for (
                qw(TimeStartMonth TimeStopMonth TimeStopDay
                TimeStartDay TimeStopYear TimeStartYear)
                )
            {
                delete $Data{ $Type . $_ };
            }
            if (
                $Data{ $Type . 'TimePoint' }
                && $Data{ $Type . 'TimePointStart' }
                && $Data{ $Type . 'TimePointFormat' }
                )
            {
                my $Time = 0;
                if ( $Data{ $Type . 'TimePointFormat' } eq 'minute' ) {
                    $Time = $Data{ $Type . 'TimePoint' };
                }
                elsif ( $Data{ $Type . 'TimePointFormat' } eq 'hour' ) {
                    $Time = $Data{ $Type . 'TimePoint' } * 60;
                }
                elsif ( $Data{ $Type . 'TimePointFormat' } eq 'day' ) {
                    $Time = $Data{ $Type . 'TimePoint' } * 60 * 24;
                }
                elsif ( $Data{ $Type . 'TimePointFormat' } eq 'week' ) {
                    $Time = $Data{ $Type . 'TimePoint' } * 60 * 24 * 7;
                }
                elsif ( $Data{ $Type . 'TimePointFormat' } eq 'month' ) {
                    $Time = $Data{ $Type . 'TimePoint' } * 60 * 24 * 30;
                }
                elsif ( $Data{ $Type . 'TimePointFormat' } eq 'year' ) {
                    $Time = $Data{ $Type . 'TimePoint' } * 60 * 24 * 356;
                }
                if ( $Data{ $Type . 'TimePointStart' } eq 'Before' ) {
                    $Data{ $Type . 'TimeOlderMinutes' } = $Time;
                }
                else {
                    $Data{ $Type . 'TimeNewerMinutes' } = $Time;
                }
            }
        }
    }

    # check valid
    if ( %Data && !defined $Data{Valid} ) {
        $Data{Valid} = 1;
    }
    if (%Data) {
        $Data{Name} = $Param{Name};
    }
    return %Data;
}

=item JobAdd()

adds a new job to the database

    $GenericAgentObject->JobAdd(
        Name => 'JobName',
        Data => {
            Queue => 'SomeQueue',
            ...
            Valid => 1,
        },
        UserID => 123,
    );

=cut

sub JobAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name Data UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if job name already exists
    my %Check = $Self->JobGet( Name => $Param{Name} );
    if (%Check) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't add job '$Param{Name}', job already exists!",
        );
        return;
    }

    # insert data into db
    for my $Key ( sort keys %{ $Param{Data} } ) {
        if ( ref $Param{Data}->{$Key} eq 'ARRAY' ) {
            for my $Item ( @{ $Param{Data}->{$Key} } ) {
                if ( defined $Item ) {
                    $Self->{DBObject}->Do(
                        SQL => 'INSERT INTO generic_agent_jobs '
                            . '(job_name, job_key, job_value) VALUES (?, ?, ?)',
                        Bind => [ \$Param{Name}, \$Key, \$Item ],
                    );
                }
            }
        }
        else {
            if ( defined $Param{Data}->{$Key} ) {
                $Self->{DBObject}->Do(
                    SQL => 'INSERT INTO generic_agent_jobs '
                        . '(job_name, job_key, job_value) VALUES (?, ?, ?)',
                    Bind => [ \$Param{Name}, \$Key, \$Param{Data}->{$Key} ],
                );
            }
        }
    }
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "New GenericAgent job '$Param{Name}' added (UserID=$Param{UserID}).",
    );
    return 1;
}

=item JobDelete()

deletes a job from the database

    $GenericAgentObject->JobDelete(Name => 'JobName');

=cut

sub JobDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete job
    $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM generic_agent_jobs WHERE job_name = ?',
        Bind => [ \$Param{Name} ],
    );
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "GenericAgent job '$Param{Name}' deleted (UserID=$Param{UserID}).",
    );
    return 1;
}

=begin Internal:

=cut

=item _JobRunTicket()

run a generic agent job on a ticket

    $GenericAgentObject->_JobRunTicket(
        TicketID => 123,
        TicketNumber => '2004081400001',
        Config => {
            %Job,
        },
        UserID => 1,
    );

=cut

sub _JobRunTicket {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID TicketNumber Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Ticket = "($Param{TicketNumber}/$Param{TicketID})";

    # disable sending emails
    if ( $Param{Config}->{New}->{SendNoNotification} ) {
        $Self->{TicketObject}->{SendNoNotification} = 1;
    }

    # move ticket
    if ( $Param{Config}->{New}->{Queue} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Move Ticket $Ticket to Queue '$Param{Config}->{New}->{Queue}'\n";
        }
        $Self->{TicketObject}->TicketQueueSet(
            QueueID => $Self->{QueueObject}->QueueLookup(
                Queue => $Param{Config}->{New}->{Queue},
                Cache => 1,
            ),
            UserID   => $Param{UserID},
            TicketID => $Param{TicketID},
        );
    }
    if ( $Param{Config}->{New}->{QueueID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Move Ticket $Ticket to QueueID '$Param{Config}->{New}->{QueueID}'\n";
        }
        $Self->{TicketObject}->TicketQueueSet(
            QueueID  => $Param{Config}->{New}->{QueueID},
            UserID   => $Param{UserID},
            TicketID => $Param{TicketID},
        );
    }

    # add note if wanted
    if ( $Param{Config}->{New}->{Note}->{Body} || $Param{Config}->{New}->{NoteBody} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Add note to Ticket $Ticket\n";
        }
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID    => $Param{TicketID},
            ArticleType => $Param{Config}->{New}->{Note}->{ArticleType} || 'note-internal',
            SenderType  => 'agent',
            From        => $Param{Config}->{New}->{Note}->{From}
                || $Param{Config}->{New}->{NoteFrom}
                || 'GenericAgent',
            Subject => $Param{Config}->{New}->{Note}->{Subject}
                || $Param{Config}->{New}->{NoteSubject}
                || 'Note',
            Body => $Param{Config}->{New}->{Note}->{Body} || $Param{Config}->{New}->{NoteBody},
            MimeType       => 'text/plain',
            Charset        => 'utf-8',
            UserID         => $Param{UserID},
            HistoryType    => 'AddNote',
            HistoryComment => 'Generic Agent note added.',
            NoAgentNotify  => $Param{Config}->{New}->{SendNoNotification} || 0,
        );
        my $TimeUnits = $Param{Config}->{New}->{Note}->{TimeUnits}
            || $Param{Config}->{New}->{NoteTimeUnits};
        if ( $ArticleID && $TimeUnits ) {
            $Self->{TicketObject}->TicketAccountTime(
                TicketID  => $Param{TicketID},
                ArticleID => $ArticleID,
                TimeUnit  => $TimeUnits,
                UserID    => $Param{UserID},
            );
        }
    }

    # set new state
    if ( $Param{Config}->{New}->{State} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - changed state of Ticket $Ticket to '$Param{Config}->{New}->{State}'\n";
        }
        $Self->{TicketObject}->TicketStateSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            State    => $Param{Config}->{New}->{State},
        );
    }
    if ( $Param{Config}->{New}->{StateID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - changed state id of ticket $Ticket to '$Param{Config}->{New}->{StateID}'\n";
        }
        $Self->{TicketObject}->TicketStateSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            StateID  => $Param{Config}->{New}->{StateID},
        );
    }

    # set customer id and customer user
    if ( $Param{Config}->{New}->{CustomerID} || $Param{Config}->{New}->{CustomerUserLogin} ) {
        if ( $Param{Config}->{New}->{CustomerID} ) {
            if ( $Self->{NoticeSTDOUT} ) {
                print
                    "  - set customer id of Ticket $Ticket to '$Param{Config}->{New}->{CustomerID}'\n";
            }
        }
        if ( $Param{Config}->{New}->{CustomerUserLogin} ) {
            if ( $Self->{NoticeSTDOUT} ) {
                print
                    "  - set customer user id of Ticket $Ticket to '$Param{Config}->{New}->{CustomerUserLogin}'\n";
            }
        }
        $Self->{TicketObject}->TicketCustomerSet(
            TicketID => $Param{TicketID},
            No       => $Param{Config}->{New}->{CustomerID} || '',
            User     => $Param{Config}->{New}->{CustomerUserLogin} || '',
            UserID   => $Param{UserID},
        );
    }

    # set new title
    if ( $Param{Config}->{New}->{Title} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set title of Ticket $Ticket to '$Param{Config}->{New}->{Title}'\n";
        }
        $Self->{TicketObject}->TicketTitleUpdate(
            Title    => $Param{Config}->{New}->{Title},
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );
    }

    # set new type
    if ( $Param{Config}->{New}->{Type} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set type of Ticket $Ticket to '$Param{Config}->{New}->{Type}'\n";
        }
        $Self->{TicketObject}->TicketTypeSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            Type     => $Param{Config}->{New}->{Type},
        );
    }
    if ( $Param{Config}->{New}->{TypeID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set type id of Ticket $Ticket to '$Param{Config}->{New}->{TypeID}'\n";
        }
        $Self->{TicketObject}->TicketTypeSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            TypeID   => $Param{Config}->{New}->{TypeID},
        );
    }

    # set new service
    if ( $Param{Config}->{New}->{Service} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set service of Ticket $Ticket to '$Param{Config}->{New}->{Service}'\n";
        }
        $Self->{TicketObject}->TicketServiceSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            Service  => $Param{Config}->{New}->{Service},
        );
    }
    if ( $Param{Config}->{New}->{ServiceID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set service id of Ticket $Ticket to '$Param{Config}->{New}->{ServiceID}'\n";
        }
        $Self->{TicketObject}->TicketServiceSet(
            TicketID  => $Param{TicketID},
            UserID    => $Param{UserID},
            ServiceID => $Param{Config}->{New}->{ServiceID},
        );
    }

    # set new sla
    if ( $Param{Config}->{New}->{SLA} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set sla of Ticket $Ticket to '$Param{Config}->{New}->{SLA}'\n";
        }
        $Self->{TicketObject}->TicketSLASet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            SLA      => $Param{Config}->{New}->{SLA},
        );
    }
    if ( $Param{Config}->{New}->{SLAID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set sla id of Ticket $Ticket to '$Param{Config}->{New}->{SLAID}'\n";
        }
        $Self->{TicketObject}->TicketSLASet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            SLAID    => $Param{Config}->{New}->{SLAID},
        );
    }

    # set new priority
    if ( $Param{Config}->{New}->{Priority} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set priority of Ticket $Ticket to '$Param{Config}->{New}->{Priority}'\n";
        }
        $Self->{TicketObject}->TicketPrioritySet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            Priority => $Param{Config}->{New}->{Priority},
        );
    }
    if ( $Param{Config}->{New}->{PriorityID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print
                "  - set priority id of Ticket $Ticket to '$Param{Config}->{New}->{PriorityID}'\n";
        }
        $Self->{TicketObject}->TicketPrioritySet(
            TicketID   => $Param{TicketID},
            UserID     => $Param{UserID},
            PriorityID => $Param{Config}->{New}->{PriorityID},
        );
    }

    # set new owner
    if ( $Param{Config}->{New}->{Owner} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set owner of Ticket $Ticket to '$Param{Config}->{New}->{Owner}'\n";
        }
        $Self->{TicketObject}->TicketOwnerSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            NewUser  => $Param{Config}->{New}->{Owner},
        );
    }
    if ( $Param{Config}->{New}->{OwnerID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set owner id of Ticket $Ticket to '$Param{Config}->{New}->{OwnerID}'\n";
        }
        $Self->{TicketObject}->TicketOwnerSet(
            TicketID  => $Param{TicketID},
            UserID    => $Param{UserID},
            NewUserID => $Param{Config}->{New}->{OwnerID},
        );
    }

    # set new responsible
    if ( $Param{Config}->{New}->{Responsible} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print
                "  - set responsible of Ticket $Ticket to '$Param{Config}->{New}->{Responsible}'\n";
        }
        $Self->{TicketObject}->TicketResponsibleSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            NewUser  => $Param{Config}->{New}->{Responsible},
        );
    }
    if ( $Param{Config}->{New}->{ResponsibleID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print
                "  - set responsible id of Ticket $Ticket to '$Param{Config}->{New}->{ResponsibleID}'\n";
        }
        $Self->{TicketObject}->TicketResponsibleSet(
            TicketID  => $Param{TicketID},
            UserID    => $Param{UserID},
            NewUserID => $Param{Config}->{New}->{ResponsibleID},
        );
    }

    # set new lock
    if ( $Param{Config}->{New}->{Lock} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set lock of Ticket $Ticket to '$Param{Config}->{New}->{Lock}'\n";
        }
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            Lock     => $Param{Config}->{New}->{Lock},
        );
    }
    if ( $Param{Config}->{New}->{LockID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set lock id of Ticket $Ticket to '$Param{Config}->{New}->{LockID}'\n";
        }
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
            LockID   => $Param{Config}->{New}->{LockID},
        );
    }

    # set new dynamic fields options
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        my $Value = $Self->{BackendObject}->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            Template           => $Param{Config}->{New},
            TransformDates     => 0,
        );

        if ( defined $Value && $Value ne '' ) {
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Param{TicketID},
                Value              => $Value,
                UserID             => 1,
            );

            if ($Success) {
                if ( $Self->{NoticeSTDOUT} ) {
                    my $ValueStrg = $Self->{BackendObject}->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                    );
                    print "  - set ticket dynamic field $DynamicFieldConfig->{Name} "
                        . "of Ticket $Ticket to $ValueStrg->{Title} '\n";
                }
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Coud not set dynamic field $DynamicFieldConfig->{Name} "
                        . "for Ticket $Ticket.",
                );
            }
        }
    }

    # run module
    if ( $Param{Config}->{New}->{Module} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Use module ($Param{Config}->{New}->{Module}) for Ticket $Ticket.\n";
        }
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Use module ($Param{Config}->{New}->{Module}) for Ticket $Ticket.",
        );
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Try to load module: $Param{Config}->{New}->{Module}!",
            );
        }
        if ( $Self->{MainObject}->Require( $Param{Config}->{New}->{Module} ) ) {

            # protect parent process
            eval {
                my $Object = $Param{Config}->{New}->{Module}->new(
                    %{$Self},
                    Debug => $Self->{Debug},
                );
                if ($Object) {
                    $Object->Run(
                        %{ $Param{Config} },
                        TicketID => $Param{TicketID},
                    );
                }
            };
            if ($@) {
                $Self->{LogObject}->Log( Priority => 'error', Message => $@ );
            }
        }
    }

    # set new archive flag
    if (
        $Param{Config}->{New}->{ArchiveFlag}
        && $Self->{ConfigObject}->Get('Ticket::ArchiveSystem')
        )
    {
        if ( $Self->{NoticeSTDOUT} ) {
            print
                "  - set archive flag of Ticket $Ticket to '$Param{Config}->{New}->{ArchiveFlag}'\n";
        }
        $Self->{TicketObject}->TicketArchiveFlagSet(
            TicketID    => $Param{TicketID},
            UserID      => $Param{UserID},
            ArchiveFlag => $Param{Config}->{New}->{ArchiveFlag},
        );
    }

    # cmd
    if ( $Param{Config}->{New}->{CMD} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Execute '$Param{Config}->{New}->{CMD}' for Ticket $Ticket.\n";
        }
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Execute '$Param{Config}->{New}->{CMD}' for Ticket $Ticket.",
        );
        system("$Param{Config}->{New}->{CMD} $Param{TicketNumber} $Param{TicketID} ");

        if ( $? ne 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Command returned a nonzero return code: rc=$?, err=$!",
            );
        }
    }

    # delete ticket
    if ( $Param{Config}->{New}->{Delete} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Delete Ticket $Ticket.\n";
        }
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Delete Ticket $Ticket.",
        );
        $Self->{TicketObject}->TicketDelete(
            UserID   => $Param{UserID},
            TicketID => $Param{TicketID},
        );
    }
    return 1;
}

sub _JobUpdateRunTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if job name already exists
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT job_key, job_value FROM generic_agent_jobs WHERE job_name = ?',
        Bind => [ \$Param{Name} ],
    );
    my @Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Row[0] =~ /^(ScheduleLastRun|ScheduleLastRunUnixTime)/ ) {
            push @Data, { Key => $Row[0], Value => $Row[1] };
        }
    }

    # update new run time
    my %Insert = (
        ScheduleLastRun => $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $Self->{TimeObject}->SystemTime()
        ),
        ScheduleLastRunUnixTime => $Self->{TimeObject}->SystemTime(),
    );
    for my $Key ( sort keys %Insert ) {
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO generic_agent_jobs (job_name,job_key, job_value) VALUES (?, ?, ?)',
            Bind => [ \$Param{Name}, \$Key, \$Insert{$Key} ],
        );
    }

    # remove old times
    for my $Time (@Data) {
        $Self->{DBObject}->Do(
            SQL => 'DELETE FROM generic_agent_jobs WHERE '
                . 'job_name = ? AND job_key = ? AND job_value = ?',
            Bind => [ \$Param{Name}, \$Time->{Key}, \$Time->{Value} ],
        );
    }
    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
