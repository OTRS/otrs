# --
# Kernel/System/GenericAgent.pm - generic agent system module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: GenericAgent.pm,v 1.41 2008-06-19 18:18:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::GenericAgent;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.41 $) [1];

=head1 NAME

Kernel::System::GenericAgent - to manage the generic agent and jobs

=head1 SYNOPSIS

All functions to manage the generic agent and the generic agent jobs.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::Queue;
    use Kernel::System::Ticket;
    use Kernel::System::GenericAgent;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
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
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TimeObject TicketObject QueueObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # notice on STDOUT
    $Self->{NoticeSTDOUT} = $Param{NoticeSTDOUT} || 0;

    my %Map = (
        TicketNumber                 => 'SCALAR',
        Title                        => 'SCALAR',
        From                         => 'SCALAR',
        To                           => 'SCALAR',
        Cc                           => 'SCALAR',
        Subject                      => 'SCALAR',
        Body                         => 'SCALAR',
        TimeUnit                     => 'SCALAR',
        CustomerID                   => 'SCALAR',
        CustomerUserLogin            => 'SCALAR',
        Agent                        => 'SCALAR',
        TimeSearchType               => 'SCALAR',
        TicketCreateTimePointFormat  => 'SCALAR',
        TicketCreateTimePoint        => 'SCALAR',
        TicketCreateTimePointStart   => 'SCALAR',
        TicketCreateTimeStart        => 'SCALAR',
        TicketCreateTimeStartDay     => 'SCALAR',
        TicketCreateTimeStartMonth   => 'SCALAR',
        TicketCreateTimeStartYear    => 'SCALAR',
        TicketCreateTimeStop         => 'SCALAR',
        TicketCreateTimeStopDay      => 'SCALAR',
        TicketCreateTimeStopMonth    => 'SCALAR',
        TicketCreateTimeStopYear     => 'SCALAR',
        CloseTimeSearchType          => 'SCALAR',
        TicketCloseTimePointFormat   => 'SCALAR',
        TicketCloseTimePoint         => 'SCALAR',
        TicketCloseTimePointStart    => 'SCALAR',
        TicketCloseTimeStart         => 'SCALAR',
        TicketCloseTimeStartDay      => 'SCALAR',
        TicketCloseTimeStartMonth    => 'SCALAR',
        TicketCloseTimeStartYear     => 'SCALAR',
        TicketCloseTimeStop          => 'SCALAR',
        TicketCloseTimeStopDay       => 'SCALAR',
        TicketCloseTimeStopMonth     => 'SCALAR',
        TicketCloseTimeStopYear      => 'SCALAR',
        TimePendingSearchType        => 'SCALAR',
        TicketPendingTimePointFormat => 'SCALAR',
        TicketPendingTimePoint       => 'SCALAR',
        TicketPendingTimePointStart  => 'SCALAR',
        TicketPendingTimeStart       => 'SCALAR',
        TicketPendingTimeStartDay    => 'SCALAR',
        TicketPendingTimeStartMonth  => 'SCALAR',
        TicketPendingTimeStartYear   => 'SCALAR',
        TicketPendingTimeStop        => 'SCALAR',
        TicketPendingTimeStopDay     => 'SCALAR',
        TicketPendingTimeStopMonth   => 'SCALAR',
        TicketPendingTimeStopYear    => 'SCALAR',
        StateIDs                     => 'ARRAY',
        StateTypeIDs                 => 'ARRAY',
        QueueIDs                     => 'ARRAY',
        PriorityIDs                  => 'ARRAY',
        OwnerIDs                     => 'ARRAY',
        LockIDs                      => 'ARRAY',
        TypeIDs                      => 'ARRAY',
        ServiceIDs                   => 'ARRAY',
        SLAIDs                       => 'ARRAY',
        NewTitle                     => 'SCALAR',
        NewCustomerID                => 'SCALAR',
        NewCustomerUserLogin         => 'SCALAR',
        NewStateID                   => 'SCALAR',
        NewQueueID                   => 'SCALAR',
        NewPriorityID                => 'SCALAR',
        NewOwnerID                   => 'SCALAR',
        NewLockID                    => 'SCALAR',
        NewTypeID                    => 'SCALAR',
        NewServiceID                 => 'SCALAR',
        NewSLAID                     => 'SCALAR',
        TicketFreeKey1               => 'ARRAY',
        TicketFreeText1              => 'ARRAY',
        TicketFreeKey2               => 'ARRAY',
        TicketFreeText2              => 'ARRAY',
        TicketFreeKey3               => 'ARRAY',
        TicketFreeText3              => 'ARRAY',
        TicketFreeKey4               => 'ARRAY',
        TicketFreeText4              => 'ARRAY',
        TicketFreeKey5               => 'ARRAY',
        TicketFreeText5              => 'ARRAY',
        TicketFreeKey6               => 'ARRAY',
        TicketFreeText6              => 'ARRAY',
        TicketFreeKey7               => 'ARRAY',
        TicketFreeText7              => 'ARRAY',
        TicketFreeKey8               => 'ARRAY',
        TicketFreeText8              => 'ARRAY',
        TicketFreeKey9               => 'ARRAY',
        TicketFreeText9              => 'ARRAY',
        TicketFreeKey10              => 'ARRAY',
        TicketFreeText10             => 'ARRAY',
        TicketFreeKey11              => 'ARRAY',
        TicketFreeText11             => 'ARRAY',
        TicketFreeKey12              => 'ARRAY',
        TicketFreeText12             => 'ARRAY',
        TicketFreeKey13              => 'ARRAY',
        TicketFreeText13             => 'ARRAY',
        TicketFreeKey14              => 'ARRAY',
        TicketFreeText14             => 'ARRAY',
        TicketFreeKey15              => 'ARRAY',
        TicketFreeText15             => 'ARRAY',
        TicketFreeKey16              => 'ARRAY',
        TicketFreeText16             => 'ARRAY',
        ScheduleLastRun              => 'SCALAR',
        ScheduleLastRunUnixTime      => 'SCALAR',
        Valid                        => 'SCALAR',
        ScheduleDays                 => 'ARRAY',
        ScheduleMinutes              => 'ARRAY',
        ScheduleHours                => 'ARRAY',
    );

    $Self->{Map} = \%Map;

    return $Self;
}

=item JobRun()

run an generic agent job

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
    my %Job = ();
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
        for my $Key ( keys %DBJobRaw ) {
            if ( $Key =~ /^New/ ) {
                my $NewKey = $Key;
                $NewKey =~ s/^New//;
                $Job{New}->{$NewKey} = $DBJobRaw{$Key};
            }
            else {
                $Job{$Key} = $DBJobRaw{$Key};
            }
        }
    }

    my %Tickets = ();

    # escalation tickets
    if ( $Job{Escalation} ) {
        if ( !$Job{Queue} ) {
            my @Tickets = $Self->{TicketObject}->GetOverTimeTickets();
            for (@Tickets) {
                $Tickets{$_} = $Self->{TicketObject}->TicketNumberLookup( TicketID => $_ );
            }
        }
        else {
            my @Tickets = $Self->{TicketObject}->GetOverTimeTickets();
            for (@Tickets) {
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $_ );
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
                    StateType => $Type,
                    Limit     => $Param{Limit} || 4000,
                    UserID    => $Param{UserID},
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
                        Queues    => [$_],
                        StateType => $Type,
                        Limit     => $Param{Limit} || 4000,
                        UserID    => $Param{UserID},
                    ),
                    %Tickets
                );
            }
        }
        else {
            %Tickets = (
                $Self->{TicketObject}->TicketSearch(
                    %Job,
                    StateType => $Type,
                    Queues    => [ $Job{Queue} ],
                    Limit     => $Param{Limit} || 4000,
                    UserID    => $Param{UserID},
                ),
                %Tickets
            );
        }
        for ( keys %Tickets ) {
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $_ );
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
            for ( keys %Job ) {
                if ( $_ !~ /^(New|Name|Valid|ScheduleLast)/ && $Job{$_} ) {
                    $Count++;
                }
            }

            # log no search attribut
            if ( !$Count ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Attention: Can't run GenericAgent Job '$Param{Job}' because no "
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
                Limit => $Param{Limit} || 4000,
                UserID => $Param{UserID},
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
                        Queues => [$_],
                        Limit  => $Param{Limit} || 4000,
                        UserID => $Param{UserID},
                    ),
                    %Tickets
                );
            }
        }
        else {
            %Tickets = $Self->{TicketObject}->TicketSearch(
                %Job,
                Queues => [ $Job{Queue} ],
                Limit  => $Param{Limit} || 4000,
                UserID => $Param{UserID},
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

# =item _JobRunTicket()
#
# run an generic agent job on a ticket
#
#     $GenericAgentObject->_JobRunTicket(
#         TicketID => 123,
#         TicketNumber => '2004081400001',
#         Config => {
#             %Job,
#         },
#         UserID => 1,
#     );
#
# =cut

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

    # move ticket
    if ( $Param{Config}->{New}->{Queue} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Move Ticket $Ticket to Queue '$Param{Config}->{New}->{Queue}'\n";
        }
        $Self->{TicketObject}->MoveTicket(
            QueueID => $Self->{QueueObject}->QueueLookup(
                Queue => $Param{Config}->{New}->{Queue},
                Cache => 1,
            ),
            UserID             => $Param{UserID},
            TicketID           => $Param{TicketID},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
        );
    }
    if ( $Param{Config}->{New}->{QueueID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Move Ticket $Ticket to QueueID '$Param{Config}->{New}->{QueueID}'\n";
        }
        $Self->{TicketObject}->MoveTicket(
            QueueID            => $Param{Config}->{New}->{QueueID},
            UserID             => $Param{UserID},
            TicketID           => $Param{TicketID},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
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
            UserID         => $Param{UserID},
            HistoryType    => 'AddNote',
            HistoryComment => 'Generic Agent note added.',
        );
        if ( $ArticleID && $Param{Config}->{New}->{Note}->{TimeUnit} ) {
            $Self->{TicketObject}->TicketAccountTime(
                TicketID  => $Param{TicketID},
                ArticleID => $ArticleID,
                TimeUnit  => $Param{Config}->{New}->{Note}->{TimeUnit},
                UserID    => $Param{UserID},
            );
        }
    }

    # set new state
    if ( $Param{Config}->{New}->{State} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - changed state of Ticket $Ticket to '$Param{Config}->{New}->{State}'\n";
        }
        $Self->{TicketObject}->StateSet(
            TicketID           => $Param{TicketID},
            UserID             => $Param{UserID},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
            State              => $Param{Config}->{New}->{State},
        );
    }
    if ( $Param{Config}->{New}->{StateID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - changed state id of ticket $Ticket to '$Param{Config}->{New}->{StateID}'\n";
        }
        $Self->{TicketObject}->StateSet(
            TicketID           => $Param{TicketID},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
            UserID             => $Param{UserID},
            StateID            => $Param{Config}->{New}->{StateID},
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
        $Self->{TicketObject}->SetCustomerData(
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
        $Self->{TicketObject}->PrioritySet(
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
        $Self->{TicketObject}->PrioritySet(
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
        $Self->{TicketObject}->OwnerSet(
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
            TicketID           => $Param{TicketID},
            UserID             => $Param{UserID},
            NewUser            => $Param{Config}->{New}->{Owner},
        );
    }
    if ( $Param{Config}->{New}->{OwnerID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set owner id of Ticket $Ticket to '$Param{Config}->{New}->{OwnerID}'\n";
        }
        $Self->{TicketObject}->OwnerSet(
            TicketID           => $Param{TicketID},
            UserID             => $Param{UserID},
            NewUserID          => $Param{Config}->{New}->{OwnerID},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
        );
    }

    # set new lock
    if ( $Param{Config}->{New}->{Lock} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set lock of Ticket $Ticket to '$Param{Config}->{New}->{Lock}'\n";
        }
        $Self->{TicketObject}->LockSet(
            TicketID           => $Param{TicketID},
            UserID             => $Param{UserID},
            Lock               => $Param{Config}->{New}->{Lock},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
        );
    }
    if ( $Param{Config}->{New}->{LockID} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - set lock id of Ticket $Ticket to '$Param{Config}->{New}->{LockID}'\n";
        }
        $Self->{TicketObject}->LockSet(
            TicketID           => $Param{TicketID},
            UserID             => $Param{UserID},
            LockID             => $Param{Config}->{New}->{LockID},
            SendNoNotification => $Param{Config}->{New}->{SendNoNotification} || 0,
        );
    }

    # set ticket free text options
    for ( 1 .. 16 ) {
        if (
            defined $Param{Config}->{New}->{"TicketFreeKey$_"}
            || defined $Param{Config}->{New}->{"TicketFreeText$_"}
            )
        {
            my %Data = ();
            $Data{TicketID} = $Param{TicketID};
            $Data{UserID}   = $Param{UserID};
            $Data{Counter}  = $_;

            if ( defined $Param{Config}->{New}->{"TicketFreeKey$_"} ) {
                $Data{Key} = $Param{Config}->{New}->{"TicketFreeKey$_"};
            }

            # insert the freefieldkey, if only one key is possible
            if (
                !$Data{Key}
                && ref $Self->{ConfigObject}->Get( 'TicketFreeKey' . $_ ) eq 'HASH'
                )
            {
                my %TicketFreeKey = %{ $Self->{ConfigObject}->Get( 'TicketFreeKey' . $_ ) };
                my @FreeKey       = keys %TicketFreeKey;

                if ( $#FreeKey == 0 ) {
                    $Data{Key} = $TicketFreeKey{ $FreeKey[0] };
                }
            }

            if ( defined $Param{Config}->{New}->{"TicketFreeText$_"} ) {
                $Data{Value} = $Param{Config}->{New}->{"TicketFreeText$_"};
            }

            if ( $Self->{NoticeSTDOUT} ) {
                if ( defined $Data{Key} ) {
                    print "  - set ticket free text of Ticket $Ticket to Key: '$Data{Key}'\n";
                }
                if ( defined $Data{Value} ) {
                    print "  - set ticket free text of Ticket $Ticket to Text: '$Data{Value}'\n";
                }
            }
            $Self->{TicketObject}->TicketFreeTextSet(%Data);
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
            my $Object = $Param{Config}->{New}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );
            $Object->Run( %{ $Param{Config} }, TicketID => $Param{TicketID} );
        }
    }

    # cmd
    if ( $Param{Config}->{New}->{CMD} ) {
        if ( $Self->{NoticeSTDOUT} ) {
            print "  - Execut '$Param{Config}->{New}->{CMD}' for Ticket $Ticket.\n";
        }
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Execut '$Param{Config}->{New}->{CMD}' for Ticket $Ticket.",
        );
        system("$Param{Config}->{New}->{CMD} $Param{TicketNumber} $Param{TicketID} ");
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
    $Self->{DBObject}->Prepare( SQL => 'SELECT job_name FROM generic_agent_jobs' );
    my %Data = ();
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
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT job_key, job_value FROM generic_agent_jobs WHERE job_name = ?',
        Bind => [ \$Param{Name} ],
    );
    my %Data = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Self->{Map}->{ $Row[0] } && $Self->{Map}->{ $Row[0] } eq 'ARRAY' ) {
            push @{ $Data{ $Row[0] } }, $Row[1];
        }
        else {
            $Data{ $Row[0] } = $Row[1];
        }
    }
    for my $Key ( keys %Data ) {
        if ( $Key =~ /(NewParam)Key(\d)/ ) {
            if ( $Data{"$1Value$2"} ) {
                $Data{"New$Data{$Key}"} = $Data{"$1Value$2"};
            }
        }
    }

    # get create time settings
    if ( !$Data{'TimeSearchType'} || $Data{'TimeSearchType'} eq 'None' ) {

        # do noting on time stuff
        for (
            qw(TicketCreateTimeStartMonth TicketCreateTimeStopMonth TicketCreateTimeStopDay
            TicketCreateTimeStartDay TicketCreateTimeStopYear TicketCreateTimePoint
            TicketCreateTimeStartYear TicketCreateTimePointFormat TicketCreateTimePointStart)
            )
        {
            delete( $Data{$_} );
        }
    }
    elsif ( $Data{'TimeSearchType'} && $Data{'TimeSearchType'} eq 'TimeSlot' ) {
        for (qw(TicketCreateTimePoint TicketCreateTimePointFormat TicketCreateTimePointStart)) {
            delete( $Data{$_} );
        }
        for (qw(Month Day)) {
            if ( $Data{"TicketCreateTimeStart$_"} <= 9 ) {
                $Data{"TicketCreateTimeStart$_"} = '0' . $Data{"TicketCreateTimeStart$_"};
            }
        }
        for (qw(Month Day)) {
            if ( $Data{"TicketCreateTimeStop$_"} <= 9 ) {
                $Data{"TicketCreateTimeStop$_"} = '0' . $Data{"TicketCreateTimeStop$_"};
            }
        }
        if (
            $Data{TicketCreateTimeStartDay}
            && $Data{TicketCreateTimeStartMonth}
            && $Data{TicketCreateTimeStartYear}
            )
        {
            $Data{TicketCreateTimeNewerDate}
                = $Data{TicketCreateTimeStartYear} . '-'
                . $Data{TicketCreateTimeStartMonth} . '-'
                . $Data{TicketCreateTimeStartDay}
                . ' 00:00:01';
        }
        if (
            $Data{TicketCreateTimeStopDay}
            && $Data{TicketCreateTimeStopMonth}
            && $Data{TicketCreateTimeStopYear}
            )
        {
            $Data{TicketCreateTimeOlderDate}
                = $Data{TicketCreateTimeStopYear} . '-'
                . $Data{TicketCreateTimeStopMonth} . '-'
                . $Data{TicketCreateTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $Data{'TimeSearchType'} && $Data{'TimeSearchType'} eq 'TimePoint' ) {
        for (
            qw(TicketCreateTimeStartMonth TicketCreateTimeStopMonth TicketCreateTimeStopDay
            TicketCreateTimeStartDay TicketCreateTimeStopYear TicketCreateTimeStartYear)
            )
        {
            delete( $Data{$_} );
        }
        if (
            $Data{TicketCreateTimePoint}
            && $Data{TicketCreateTimePointStart}
            && $Data{TicketCreateTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $Data{TicketCreateTimePointFormat} eq 'minute' ) {
                $Time = $Data{TicketCreateTimePoint};
            }
            elsif ( $Data{TicketCreateTimePointFormat} eq 'hour' ) {
                $Time = $Data{TicketCreateTimePoint} * 60;
            }
            elsif ( $Data{TicketCreateTimePointFormat} eq 'day' ) {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24;
            }
            elsif ( $Data{TicketCreateTimePointFormat} eq 'week' ) {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24 * 7;
            }
            elsif ( $Data{TicketCreateTimePointFormat} eq 'month' ) {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24 * 30;
            }
            elsif ( $Data{TicketCreateTimePointFormat} eq 'year' ) {
                $Time = $Data{TicketCreateTimePoint} * 60 * 24 * 356;
            }
            if ( $Data{TicketCreateTimePointStart} eq 'Before' ) {
                $Data{TicketCreateTimeOlderMinutes} = $Time;
            }
            else {
                $Data{TicketCreateTimeNewerMinutes} = $Time;
            }
        }
    }

    # get close time settings
    if ( !$Data{'CloseTimeSearchType'} || $Data{'CloseTimeSearchType'} eq 'None' ) {

        # do noting on time stuff
        for (
            qw(TicketCloseTimeStartMonth TicketCloseTimeStopMonth TicketCloseTimeStopDay
            TicketCloseTimeStartDay TicketCloseTimeStopYear TicketCloseTimePoint
            TicketCloseTimeStartYear TicketCloseTimePointFormat TicketCloseTimePointStart)
            )
        {
            delete( $Data{$_} );
        }
    }
    elsif ( $Data{'CloseTimeSearchType'} && $Data{'CloseTimeSearchType'} eq 'TimeSlot' ) {
        for (qw(TicketCloseTimePoint TicketCloseTimePointFormat TicketCloseTimePointStart)) {
            delete( $Data{$_} );
        }
        for (qw(Month Day)) {
            if ( $Data{"TicketCloseTimeStart$_"} <= 9 ) {
                $Data{"TicketCloseTimeStart$_"} = '0' . $Data{"TicketCloseTimeStart$_"};
            }
        }
        for (qw(Month Day)) {
            if ( $Data{"TicketCloseTimeStop$_"} <= 9 ) {
                $Data{"TicketCloseTimeStop$_"} = '0' . $Data{"TicketCloseTimeStop$_"};
            }
        }
        if (
            $Data{TicketCloseTimeStartDay}
            && $Data{TicketCloseTimeStartMonth}
            && $Data{TicketCloseTimeStartYear}
            )
        {
            $Data{TicketCloseTimeNewerDate}
                = $Data{TicketCloseTimeStartYear} . '-'
                . $Data{TicketCloseTimeStartMonth} . '-'
                . $Data{TicketCloseTimeStartDay}
                . ' 00:00:01';
        }
        if (
            $Data{TicketCloseTimeStopDay}
            && $Data{TicketCloseTimeStopMonth}
            && $Data{TicketCloseTimeStopYear}
            )
        {
            $Data{TicketCloseTimeOlderDate}
                = $Data{TicketCloseTimeStopYear} . '-'
                . $Data{TicketCloseTimeStopMonth} . '-'
                . $Data{TicketCloseTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $Data{'CloseTimeSearchType'} && $Data{'CloseTimeSearchType'} eq 'TimePoint' ) {
        for (
            qw(TicketCloseTimeStartMonth TicketCloseTimeStopMonth TicketCloseTimeStopDay
            TicketCloseTimeStartDay TicketCloseTimeStopYear TicketCloseTimeStartYear)
            )
        {
            delete( $Data{$_} );
        }
        if (
            $Data{TicketCloseTimePoint}
            && $Data{TicketCloseTimePointStart}
            && $Data{TicketCloseTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $Data{TicketCloseTimePointFormat} eq 'minute' ) {
                $Time = $Data{TicketCloseTimePoint};
            }
            elsif ( $Data{TicketCloseTimePointFormat} eq 'hour' ) {
                $Time = $Data{TicketCloseTimePoint} * 60;
            }
            elsif ( $Data{TicketCloseTimePointFormat} eq 'day' ) {
                $Time = $Data{TicketCloseTimePoint} * 60 * 24;
            }
            elsif ( $Data{TicketCloseTimePointFormat} eq 'week' ) {
                $Time = $Data{TicketCloseTimePoint} * 60 * 24 * 7;
            }
            elsif ( $Data{TicketCloseTimePointFormat} eq 'month' ) {
                $Time = $Data{TicketCloseTimePoint} * 60 * 24 * 30;
            }
            elsif ( $Data{TicketCloseTimePointFormat} eq 'year' ) {
                $Time = $Data{TicketCloseTimePoint} * 60 * 24 * 356;
            }
            if ( $Data{TicketCloseTimePointStart} eq 'Before' ) {
                $Data{TicketCloseTimeOlderMinutes} = $Time;
            }
            else {
                $Data{TicketCloseTimeNewerMinutes} = $Time;
            }
        }
    }

    # get pending time settings
    if ( !$Data{'TimePendingSearchType'} || $Data{'TimePendingSearchType'} eq 'None' ) {

        # do noting on time stuff
        for (
            qw(TicketPendingTimeStartMonth TicketPendingTimeStopMonth TicketPendingTimeStopDay
            TicketPendingTimeStartDay TicketPendingTimeStopYear TicketPendingTimePoint
            TicketPendingTimeStartYear TicketPendingTimePointFormat TicketPendingTimePointStart)
            )
        {
            delete( $Data{$_} );
        }
    }
    elsif ( $Data{'TimePendingSearchType'} && $Data{'TimePendingSearchType'} eq 'TimeSlot' ) {
        for (qw(TicketPendingTimePoint TicketPendingTimePointFormat TicketPendingTimePointStart)) {
            delete( $Data{$_} );
        }
        for (qw(Month Day)) {
            if ( $Data{"TicketPendingTimeStart$_"} <= 9 ) {
                $Data{"TicketPendingTimeStart$_"} = '0' . $Data{"TicketPendingTimeStart$_"};
            }
        }
        for (qw(Month Day)) {
            if ( $Data{"TicketPendingTimeStop$_"} <= 9 ) {
                $Data{"TicketPendingTimeStop$_"} = '0' . $Data{"TicketPendingTimeStop$_"};
            }
        }
        if (
            $Data{TicketPendingTimeStartDay}
            && $Data{TicketPendingTimeStartMonth}
            && $Data{TicketPendingTimeStartYear}
            )
        {
            $Data{TicketPendingTimeNewerDate}
                = $Data{TicketPendingTimeStartYear} . '-'
                . $Data{TicketPendingTimeStartMonth} . '-'
                . $Data{TicketPendingTimeStartDay}
                . ' 00:00:01';
        }
        if (
            $Data{TicketPendingTimeStopDay}
            && $Data{TicketPendingTimeStopMonth}
            && $Data{TicketPendingTimeStopYear}
            )
        {
            $Data{TicketPendingTimeOlderDate}
                = $Data{TicketPendingTimeStopYear} . '-'
                . $Data{TicketPendingTimeStopMonth} . '-'
                . $Data{TicketPendingTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $Data{'TimePendingSearchType'} && $Data{'TimePendingSearchType'} eq 'TimePoint' ) {
        for (
            qw(TicketPendingTimeStartMonth TicketPendingTimeStopMonth TicketPendingTimeStopDay
            TicketPendingTimeStartDay TicketPendingTimeStopYear TicketPendingTimeStartYear)
            )
        {
            delete( $Data{$_} );
        }
        if (
            $Data{TicketPendingTimePoint}
            && $Data{TicketPendingTimePointStart}
            && $Data{TicketPendingTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $Data{TicketPendingTimePointFormat} eq 'minute' ) {
                $Time = $Data{TicketPendingTimePoint};
            }
            elsif ( $Data{TicketPendingTimePointFormat} eq 'hour' ) {
                $Time = $Data{TicketPendingTimePoint} * 60;
            }
            elsif ( $Data{TicketPendingTimePointFormat} eq 'day' ) {
                $Time = $Data{TicketPendingTimePoint} * 60 * 24;
            }
            elsif ( $Data{TicketPendingTimePointFormat} eq 'week' ) {
                $Time = $Data{TicketPendingTimePoint} * 60 * 24 * 7;
            }
            elsif ( $Data{TicketPendingTimePointFormat} eq 'month' ) {
                $Time = $Data{TicketPendingTimePoint} * 60 * 24 * 30;
            }
            elsif ( $Data{TicketPendingTimePointFormat} eq 'year' ) {
                $Time = $Data{TicketPendingTimePoint} * 60 * 24 * 356;
            }
            if ( $Data{TicketPendingTimePointStart} eq 'Before' ) {
                $Data{TicketPendingTimeOlderMinutes} = $Time;
            }
            else {
                $Data{TicketPendingTimeNewerMinutes} = $Time;
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
            Vaild => 1,
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
    for my $Key ( keys %{ $Param{Data} } ) {
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

deletes an job from the database

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

sub _JobUpdateRunTime {
    my ( $Self, %Param ) = @_;

    my @Data = ();

    # check needed stuff
    for (qw(Name UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if job name already exists
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT job_key, job_value FROM generic_agent_jobs WHERE job_name = ?',
        Bind => [ \$Param{Name} ],
    );
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
    for my $Key ( keys %Insert ) {
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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.41 $ $Date: 2008-06-19 18:18:35 $

=cut
