# --
# Kernel/Modules/AdminGenericAgent.pm - admin generic agent interface
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AdminGenericAgent.pm,v 1.93.2.3 2011-06-15 09:57:36 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGenericAgent;

use strict;
use warnings;

use Kernel::System::Priority;
use Kernel::System::Lock;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::Type;
use Kernel::System::GenericAgent;
use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.93.2.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{PriorityObject}     = Kernel::System::Priority->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{LockObject}         = Kernel::System::Lock->new(%Param);
    $Self->{ServiceObject}      = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}          = Kernel::System::SLA->new(%Param);
    $Self->{TypeObject}         = Kernel::System::Type->new(%Param);
    $Self->{GenericAgentObject} = Kernel::System::GenericAgent->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # create local object
    my $CheckItemObject = Kernel::System::CheckItem->new( %{$Self} );

    # secure mode message (don't allow this action till secure mode is enabled)
    if ( !$Self->{ConfigObject}->Get('SecureMode') ) {
        $Self->{LayoutObject}->SecureMode();
    }

    # get config data
    $Self->{Profile}    = $Self->{ParamObject}->GetParam( Param => 'Profile' )    || '';
    $Self->{OldProfile} = $Self->{ParamObject}->GetParam( Param => 'OldProfile' ) || '';
    $Self->{Subaction}  = $Self->{ParamObject}->GetParam( Param => 'Subaction' )  || '';

    # ---------------------------------------------------------- #
    # run a generic agent job -> "run now"
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'RunNow' ) {
        my $Run = $Self->{GenericAgentObject}->JobRun(
            Job    => $Self->{Profile},
            UserID => 1,
        );

        # redirect
        if ($Run) {
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}", );
        }

        # redirect
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # --------------------------------------------------------------- #
    # save generic agent job and show a view of all affected tickets
    # --------------------------------------------------------------- #
    # show result site
    if ( $Self->{Subaction} eq 'UpdateAction' ) {

        my ( %GetParam, %Errors );

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get single params
        for my $Parameter (
            qw(TicketNumber Title From To Cc Subject Body CustomerID
            CustomerUserLogin Agent SearchInArchive
            NewTitle
            NewCustomerID NewCustomerUserLogin
            NewStateID NewQueueID NewPriorityID NewOwnerID
            NewTypeID NewServiceID NewSLAID
            NewNoteFrom NewNoteSubject NewNoteBody NewNoteTimeUnits NewModule
            NewParamKey1 NewParamKey2 NewParamKey3 NewParamKey4
            NewParamValue1 NewParamValue2 NewParamValue3 NewParamValue4
            NewParamKey5 NewParamKey6 NewParamKey7 NewParamKey8
            NewParamValue5 NewParamValue6 NewParamValue7 NewParamValue8
            NewLockID NewDelete NewCMD NewSendNoNotification NewArchiveFlag
            ScheduleLastRun Valid
            )
            )
        {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );

            # remove leading and trailing blank spaces
            $CheckItemObject->StringClean( StringRef => \$GetParam{$Parameter} )
                if $GetParam{$Parameter};
        }

        for my $Type (
            qw(Time CloseTime TimePending EscalationTime EscalationResponseTime EscalationUpdateTime EscalationSolutionTime)
            )
        {
            my $Key = $Type . 'SearchType';
            $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
        }
        for my $Type (
            qw(
            TicketCreate           TicketClose              TicketPending
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
                $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
            }

            # validate data
            for my $Attribute (
                qw(TimeStartDay TimeStartMonth TimeStopMonth TimeStopDay)
                )
            {
                my $Key = $Type . $Attribute;
                $GetParam{$Key} = sprintf( '%02d', $GetParam{$Key} ) if $GetParam{$Key};
            }
        }

        # get new free field params
        for my $ID ( 1 .. 16 ) {

            # ticket free keys
            if ( defined( $Self->{ParamObject}->GetParam( Param => "NewTicketFreeKey$ID" ) ) ) {
                $GetParam{"NewTicketFreeKey$ID"} = $Self->{ParamObject}->GetParam(
                    Param => 'NewTicketFreeKey' . $ID,
                );

                # remove leading and trailing blank spaces
                $CheckItemObject->StringClean( StringRef => \$GetParam{"NewTicketFreeKey$ID"} )
                    if ( $GetParam{"NewTicketFreeKey$ID"} );
            }

            # ticket free text
            if (
                $Self->{ParamObject}->GetParam( Param => "NewTicketFreeText$ID" )
                || (
                    defined( $Self->{ParamObject}->GetParam( Param => "NewTicketFreeText$ID" ) )
                    && $Self->{ConfigObject}->Get("TicketFreeText$ID")
                )
                )
            {
                $GetParam{"NewTicketFreeText$ID"} = $Self->{ParamObject}->GetParam(
                    Param => 'NewTicketFreeText' . $ID,
                );

                # remove leading and trailing blank spaces
                $CheckItemObject->StringClean( StringRef => \$GetParam{"NewTicketFreeText$ID"} )
                    if ( $GetParam{"NewTicketFreeText$ID"} );
            }
        }

        # get array params
        for my $Parameter (
            qw(LockIDs StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
            TypeIDs ServiceIDs SLAIDs
            ScheduleDays ScheduleMinutes ScheduleHours
            )
            )
        {

            # get search array params (get submitted params)
            if ( $Self->{ParamObject}->GetArray( Param => $Parameter ) ) {
                @{ $GetParam{$Parameter} } = $Self->{ParamObject}->GetArray( Param => $Parameter );
            }
        }

        # get free field params
        for my $ID ( 1 .. 16 ) {

            # get search array params for free key (get submitted params)
            if ( $Self->{ParamObject}->GetArray( Param => "TicketFreeKey$ID" ) ) {
                @{ $GetParam{"TicketFreeKey$ID"} } = $Self->{ParamObject}->GetArray(
                    Param => 'TicketFreeKey' . $ID,
                );
            }

            # get search array params for free text (get submitted params)
            if ( $Self->{ConfigObject}->Get("TicketFreeText$ID") ) {
                if ( $Self->{ParamObject}->GetArray( Param => "TicketFreeText$ID" ) ) {
                    @{ $GetParam{"TicketFreeText$ID"} } = $Self->{ParamObject}->GetArray(
                        Param => 'TicketFreeText' . $ID,
                    );
                }
            }
            else {
                my @Array = $Self->{ParamObject}->GetArray( Param => 'TicketFreeText' . $ID );
                if ( $Array[0] ) {
                    @{ $GetParam{"TicketFreeText$ID"} } = @Array;
                }
            }
        }

        # check needed data
        if ( !$Self->{Profile} ) {
            $Errors{ProfileInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            if ( $Self->{OldProfile} ) {

                # remove/clean up old profile stuff
                $Self->{GenericAgentObject}->JobDelete(
                    Name   => $Self->{OldProfile},
                    UserID => $Self->{UserID},
                );
            }

            # insert new profile params
            $Self->{GenericAgentObject}->JobAdd(
                Name   => $Self->{Profile},
                Data   => \%GetParam,
                UserID => $Self->{UserID},
            );

            # get time settings
            my %Map = (
                TicketCreate             => 'Time',
                TicketClose              => 'CloseTime',
                TicketPending            => 'TimePending',
                TicketEscalation         => 'EscalationTime',
                TicketEscalationResponse => 'EscalationResponseTime',
                TicketEscalationUpdate   => 'EscalationUpdateTime',
                TicketEscalationSolution => 'EscalationSolutionTime',
            );
            for my $Type (
                qw(
                TicketCreate           TicketClose                  TicketPending
                TicketEscalation       TicketEscalationResponse
                TicketEscalationUpdate TicketEscalationSolution
                )
                )
            {
                my $SearchType = $Map{$Type} . 'SearchType';
                if ( !$GetParam{$SearchType} || $GetParam{$SearchType} eq 'None' ) {

                    # do nothing with time stuff
                }
                elsif ( $GetParam{$SearchType} eq 'TimeSlot' ) {
                    for my $DatePart (qw(Month Day)) {
                        $GetParam{ $Type . "TimeStart$DatePart" }
                            = sprintf( '%02d', $GetParam{ $Type . "TimeStart$DatePart" } );
                        $GetParam{ $Type . "TimeStop$DatePart" }
                            = sprintf( '%02d', $GetParam{ $Type . "TimeStop$DatePart" } );
                    }
                    if (
                        $GetParam{ $Type . 'TimeStartDay' }
                        && $GetParam{ $Type . 'TimeStartMonth' }
                        && $GetParam{ $Type . 'TimeStartYear' }
                        )
                    {
                        $GetParam{ $Type . 'TimeNewerDate' }
                            = $GetParam{ $Type . 'TimeStartYear' } . '-'
                            . $GetParam{ $Type . 'TimeStartMonth' } . '-'
                            . $GetParam{ $Type . 'TimeStartDay' }
                            . ' 00:00:01';
                    }
                    if (
                        $GetParam{ $Type . 'TimeStopDay' }
                        && $GetParam{ $Type . 'TimeStopMonth' }
                        && $GetParam{ $Type . 'TimeStopYear' }
                        )
                    {
                        $GetParam{ $Type . 'TimeOlderDate' }
                            = $GetParam{ $Type . 'TimeStopYear' } . '-'
                            . $GetParam{ $Type . 'TimeStopMonth' } . '-'
                            . $GetParam{ $Type . 'TimeStopDay' }
                            . ' 23:59:59';
                    }
                }
                elsif ( $GetParam{$SearchType} eq 'TimePoint' ) {
                    if (
                        $GetParam{ $Type . 'TimePoint' }
                        && $GetParam{ $Type . 'TimePointStart' }
                        && $GetParam{ $Type . 'TimePointFormat' }
                        )
                    {
                        my $Time = 0;
                        if ( $GetParam{ $Type . 'TimePointFormat' } eq 'minute' ) {
                            $Time = $GetParam{ $Type . 'TimePoint' };
                        }
                        elsif ( $GetParam{ $Type . 'TimePointFormat' } eq 'hour' ) {
                            $Time = $GetParam{ $Type . 'TimePoint' } * 60;
                        }
                        elsif ( $GetParam{ $Type . 'TimePointFormat' } eq 'day' ) {
                            $Time = $GetParam{ $Type . 'TimePoint' } * 60 * 24;
                        }
                        elsif ( $GetParam{ $Type . 'TimePointFormat' } eq 'week' ) {
                            $Time = $GetParam{ $Type . 'TimePoint' } * 60 * 24 * 7;
                        }
                        elsif ( $GetParam{ $Type . 'TimePointFormat' } eq 'month' ) {
                            $Time = $GetParam{ $Type . 'TimePoint' } * 60 * 24 * 30;
                        }
                        elsif ( $GetParam{ $Type . 'TimePointFormat' } eq 'year' ) {
                            $Time = $GetParam{ $Type . 'TimePoint' } * 60 * 24 * 365;
                        }
                        if ( $GetParam{ $Type . 'TimePointStart' } eq 'Before' ) {
                            $GetParam{ $Type . 'TimeOlderMinutes' } = $Time;
                        }
                        else {
                            $GetParam{ $Type . 'TimeNewerMinutes' } = $Time;
                        }
                    }
                }
            }

            if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

                $GetParam{SearchInArchive} ||= '';
                if ( $GetParam{SearchInArchive} eq 'AllTickets' ) {
                    $GetParam{ArchiveFlags} = [ 'y', 'n' ];
                }
                elsif ( $GetParam{SearchInArchive} eq 'ArchivedTickets' ) {
                    $GetParam{ArchiveFlags} = ['y'];
                }
                else {
                    $GetParam{ArchiveFlags} = ['n'];
                }
            }

            # focus of "From To Cc Subject Body"
            for my $Parameter (qw(From To Cc Subject Body)) {
                if ( defined $GetParam{$Parameter} && $GetParam{$Parameter} ne '' ) {
                    $GetParam{$Parameter} = $GetParam{$Parameter};
                }
            }

            # perform ticket search
            my $Counter = $Self->{TicketObject}->TicketSearch(
                Result          => 'COUNT',
                SortBy          => 'Age',
                OrderBy         => 'Down',
                UserID          => 1,
                Limit           => 60_000,
                ConditionInline => 1,
                %GetParam,
            ) || 0;
            my @TicketIDs = $Self->{TicketObject}->TicketSearch(
                Result          => 'ARRAY',
                SortBy          => 'Age',
                OrderBy         => 'Down',
                UserID          => 1,
                Limit           => 30,
                ConditionInline => 1,
                %GetParam,
            );

            $Self->{LayoutObject}->Block( Name => 'ActionList', );
            $Self->{LayoutObject}->Block( Name => 'ActionOverview', );
            $Self->{LayoutObject}->Block(
                Name => 'Result',
                Data => {
                    %Param,
                    Name        => $Self->{Profile},
                    AffectedIDs => $Counter,
                },
            );

            if (@TicketIDs) {
                $Self->{LayoutObject}->Block( Name => 'ResultBlock' );
                for my $TicketID (@TicketIDs) {

                    # get first article data
                    my %Data = $Self->{TicketObject}->ArticleFirstArticle(
                        TicketID => $TicketID,
                    );
                    $Data{Age}
                        = $Self->{LayoutObject}->CustomerAge( Age => $Data{Age}, Space => ' ' );
                    $Data{css} = "PriorityID-$Data{PriorityID}";

                    # user info
                    my %UserInfo = $Self->{UserObject}->GetUserData(
                        User => $Data{Owner},
                    );
                    $Data{UserLastname}  = $UserInfo{UserLastname};
                    $Data{UserFirstname} = $UserInfo{UserFirstname};

                    $Self->{LayoutObject}->Block(
                        Name => 'Ticket',
                        Data => \%Data,
                    );
                }
                if ( $GetParam{NewDelete} ) {
                    $Self->{LayoutObject}->Block( Name => 'DeleteWarning' );
                }
            }

            # html search mask output
            my $Output = $Self->{LayoutObject}->Header( Title => 'Affected Tickets' );
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminGenericAgent',
                Data         => \%Param,
            );

            # build footer
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # something went wrong
        my $JobDataReference;
        $JobDataReference = $Self->_MaskUpdate(
            %Param,
            %GetParam,
            %Errors,
        );

        # generate search mask
        my $Output = $Self->{LayoutObject}->Header( Title => 'Edit' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data         => $JobDataReference,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit generic agent job
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Update' ) {
        my $JobDataReference;
        $JobDataReference = $Self->_MaskUpdate(%Param);

        # generate search mask
        my $Output = $Self->{LayoutObject}->Header( Title => 'Edit' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data         => $JobDataReference,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # delete an generic agent job
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Delete' && $Self->{Profile} ) {
        if ( $Self->{Profile} ) {
            $Self->{GenericAgentObject}->JobDelete(
                Name   => $Self->{Profile},
                UserID => $Self->{UserID},
            );
        }
    }

    # ---------------------------------------------------------- #
    # overview of all generic agent jobs
    # ---------------------------------------------------------- #
    $Self->{LayoutObject}->Block( Name => 'ActionList', );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd', );
    $Self->{LayoutObject}->Block( Name => 'Overview', );
    my %Jobs = $Self->{GenericAgentObject}->JobList();

    # if there are any data, it is shown
    if (%Jobs) {
        my $Counter = 1;
        for my $JobKey ( sort keys %Jobs ) {
            my %JobData = $Self->{GenericAgentObject}->JobGet( Name => $JobKey );

            # css setting and text for valid or invalid jobs
            if ( $JobData{Valid} ) {
                $JobData{ShownValid} = 'valid';
            }
            else {
                $JobData{ShownValid} = 'invalid';
            }

            # seperate each searchresult line by using several css

            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {%JobData},
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    # generate search mask
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericAgent',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _MaskUpdate {
    my ( $Self, %Param ) = @_;

    my %JobData;

    if ( $Self->{Profile} ) {

        # get db job data
        %JobData = $Self->{GenericAgentObject}->JobGet( Name => $Self->{Profile} );
    }
    $JobData{Profile} = $Self->{Profile};

    my %ShownUsers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    $JobData{OwnerStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ShownUsers,
        Name       => 'OwnerIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $JobData{OwnerIDs},
    );
    $JobData{NewOwnerStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ShownUsers,
        Name       => 'NewOwnerID',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $JobData{NewOwnerID},
    );
    my %Hours;
    for my $Number ( 0 .. 23 ) {
        $Hours{$Number} = sprintf( "%02d", $Number );
    }
    $JobData{ScheduleHoursList} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Hours,
        Name       => 'ScheduleHours',
        Size       => 6,
        Multiple   => 1,
        SelectedID => $JobData{ScheduleHours},
    );
    $JobData{ScheduleMinutesList} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            '00' => '00',
            10   => '10',
            20   => '20',
            30   => '30',
            40   => '40',
            50   => '50',
        },
        Name       => 'ScheduleMinutes',
        Size       => 6,
        Multiple   => 1,
        SelectedID => $JobData{ScheduleMinutes},
    );
    $JobData{ScheduleDaysList} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
            0 => 'Sun',
        },
        Sort       => 'NumericKey',
        Name       => 'ScheduleDays',
        Size       => 7,
        Multiple   => 1,
        SelectedID => $JobData{ScheduleDays},
    );

    $JobData{StatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{StateObject}->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'StateIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $JobData{StateIDs},
    );
    $JobData{NewStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{StateObject}->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'NewStateID',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $JobData{NewStateID},
    );
    $JobData{QueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data               => { $Self->{QueueObject}->GetAllQueues(), },
        Size               => 5,
        Multiple           => 1,
        Name               => 'QueueIDs',
        SelectedIDRefArray => $JobData{QueueIDs},
        OnChangeSubmit     => 0,
    );
    $JobData{NewQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data           => { $Self->{QueueObject}->GetAllQueues(), },
        Size           => 5,
        Multiple       => 1,
        Name           => 'NewQueueID',
        SelectedID     => $JobData{NewQueueID},
        OnChangeSubmit => 0,
    );
    $JobData{PrioritiesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{PriorityObject}->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'PriorityIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $JobData{PriorityIDs},
    );
    $JobData{NewPrioritiesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{PriorityObject}->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'NewPriorityID',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $JobData{NewPriorityID},
    );

    # get time option
    my %Map = (
        TicketCreate             => 'Time',
        TicketClose              => 'CloseTime',
        TicketPending            => 'TimePending',
        TicketEscalation         => 'EscalationTime',
        TicketEscalationResponse => 'EscalationResponseTime',
        TicketEscalationUpdate   => 'EscalationUpdateTime',
        TicketEscalationSolution => 'EscalationSolutionTime',
    );
    for my $Type (
        qw( TicketCreate           TicketClose              TicketPending
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
        $JobData{ $Type . 'TimePoint' } = $Self->{LayoutObject}->BuildSelection(
            Data       => \%Counter,
            Name       => $Type . 'TimePoint',
            SelectedID => $JobData{ $Type . 'TimePoint' },
        );
        $JobData{ $Type . 'TimePointStart' } = $Self->{LayoutObject}->BuildSelection(
            Data => {
                Last   => 'last',
                Before => 'before',
            },
            Name => $Type . 'TimePointStart',
            SelectedID => $JobData{ $Type . 'TimePointStart' } || 'Last',
        );
        $JobData{ $Type . 'TimePointFormat' } = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => $Type . 'TimePointFormat',
            SelectedID => $JobData{ $Type . 'TimePointFormat' },
        );
        $JobData{ $Type . 'TimeStart' } = $Self->{LayoutObject}->BuildDateSelection(
            %JobData,
            Prefix   => $Type . 'TimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( 60 * 60 * 24 ) * 30,
            Validate => 1,
        );
        $JobData{ $Type . 'TimeStop' } = $Self->{LayoutObject}->BuildDateSelection(
            %JobData,
            Prefix   => $Type . 'TimeStop',
            Format   => 'DateInputFormat',
            Validate => 1,
        );
    }

    $JobData{DeleteOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'NewDelete',
        SelectedID => $JobData{NewDelete} || 0,
    );
    $JobData{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'Valid',
        SelectedID => defined( $JobData{Valid} ) ? $JobData{Valid} : 1,
    );
    $JobData{LockOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{LockObject}->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'LockIDs',
        Multiple   => 1,
        Size       => 3,
        SelectedID => $JobData{LockIDs},
    );
    $JobData{NewLockOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{LockObject}->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'NewLockID',
        Size       => 3,
        Multiple   => 1,
        SelectedID => $JobData{NewLockID},
    );

    # REMARK: we changed the wording "Send no notifications" to
    # "Send agent/customer notifications on changes" in frontend.
    # But the backend code is still the same (compatiblity).
    # Because of this case we changed 1=>'Yes' to 1=>'No'
    $JobData{SendNoNotificationOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            '1' => 'No',
            '0' => 'Yes'
        },
        Name => 'NewSendNoNotification',
        SelectedID => $JobData{NewSendNoNotification} || 0,
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList', );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview', );
    $Self->{LayoutObject}->Block(
        Name => 'Edit',
        Data => {
            %Param,
            %JobData,
        },
    );

    # check if the schedule options are selected
    if (
        !defined $JobData{ScheduleDays}->[0]
        || !defined $JobData{ScheduleHours}->[0]
        || !defined $JobData{ScheduleMinutes}->[0]
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'JobScheduleWarning',
        );
    }

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TypeObject}->TypeList( UserID => $Self->{UserID}, );
        $JobData{TypesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeIDs',
            SelectedID  => $JobData{TypeIDs},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => \%JobData,
        );
        $JobData{NewTypesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Type,
            Name        => 'NewTypeID',
            SelectedID  => $JobData{NewTypeID},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'NewTicketType',
            Data => \%JobData,
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        # get list type
        my %Service = $Self->{ServiceObject}->ServiceList( UserID => $Self->{UserID}, );
        $JobData{ServicesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceIDs',
            SelectedID  => $JobData{ServiceIDs},
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
        );
        $JobData{NewServicesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Service,
            Name        => 'NewServiceID',
            SelectedID  => $JobData{NewServiceID},
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
        );
        my %SLA = $Self->{SLAObject}->SLAList( UserID => $Self->{UserID}, );
        $JobData{SLAsStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%SLA,
            Name        => 'SLAIDs',
            SelectedID  => $JobData{SLAIDs},
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
        );
        $JobData{NewSLAsStrg} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%SLA,
            Name        => 'NewSLAID',
            SelectedID  => $JobData{NewSLAID},
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%JobData},
        );
        $Self->{LayoutObject}->Block(
            Name => 'NewTicketService',
            Data => {%JobData},
        );
    }

    # prepare archive
    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

        $JobData{'SearchInArchiveStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                ArchivedTickets    => 'Archived tickets',
                NotArchivedTickets => 'Unarchived tickets',
                AllTickets         => 'All tickets',
            },
            Name => 'SearchInArchive',
            SelectedID => $JobData{SearchInArchive} || 'AllTickets',
        );

        $Self->{LayoutObject}->Block(
            Name => 'SearchInArchive',
            Data => {%JobData},
        );

        $JobData{'NewArchiveFlagStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                y => 'archive tickets',
                n => 'restore tickets from archive',
            },
            Name         => 'NewArchiveFlag',
            PossibleNone => 1,
            SelectedID   => $JobData{NewArchiveFlag} || '',
        );

        $Self->{LayoutObject}->Block(
            Name => 'NewArchiveFlag',
            Data => {%JobData},
        );
    }

    # get free text config options
    my %TicketFreeText;
    my %TicketFreeTextData;
    for my $Count ( 1 .. 16 ) {
        $TicketFreeText{ 'TicketFreeKey' . $Count } = $Self->{TicketObject}->TicketFreeTextGet(
            Type   => 'TicketFreeKey' . $Count,
            FillUp => 1,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $TicketFreeText{ 'TicketFreeText' . $Count } = $Self->{TicketObject}->TicketFreeTextGet(
            Type   => 'TicketFreeText' . $Count,
            FillUp => 1,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );

        $TicketFreeTextData{ 'TicketFreeKey' . $Count } = $JobData{ 'TicketFreeKey' . $Count };
        $TicketFreeTextData{ 'TicketFreeText' . $Count }
            = $JobData{ 'TicketFreeText' . $Count };
    }

    # generate the free text fields
    my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
        Config     => \%TicketFreeText,
        Ticket     => \%TicketFreeTextData,
        NullOption => 1,
    );

    # Free field settings
    my $Flag = 1;
    COUNT:
    for my $Count ( 1 .. 16 ) {

        next COUNT if ref $Self->{ConfigObject}->Get( 'TicketFreeKey' . $Count ) ne 'HASH';

        # $Flag to show the whole freefield block
        if ($Flag) {
            $Self->{LayoutObject}->Block( Name => 'TicketFreeField' );
            $Flag = 0;
        }

        # output free text field
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeFieldElement',
            Data => {
                TicketFreeKey  => $TicketFreeTextHTML{ 'TicketFreeKeyField' . $Count },
                TicketFreeText => $TicketFreeTextHTML{ 'TicketFreeTextField' . $Count },
                ValueID        => 'TicketFreeText' . $Count
            },
        );
    }

    # New free field settings
    $Flag = 1;
    for my $ID ( 1 .. 16 ) {
        if ( ref( $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) ) eq 'HASH' ) {

            # $Flag to show the hole freefield block
            if ($Flag) {
                $Self->{LayoutObject}->Block( Name => 'NewTicketFreeField', );
                $Flag = 0;
            }

            # generate free key
            my %TicketFreeKey    = %{ $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) };
            my @FreeKey          = keys %TicketFreeKey;
            my $NewTicketFreeKey = '';

            if ( $#FreeKey == 0 ) {
                $NewTicketFreeKey = $TicketFreeKey{ $FreeKey[0] };
            }
            else {
                $NewTicketFreeKey = $Self->{LayoutObject}->BuildSelection(
                    Data        => \%TicketFreeKey,
                    Name        => 'NewTicketFreeKey' . $ID,
                    Size        => 4,
                    Multiple    => 1,
                    Translation => 0,
                    SelectedID  => $JobData{ 'NewTicketFreeKey' . $ID },
                );
            }

            # generate free text
            my $NewTicketFreeText = '';
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeText' . $ID ) ) {
                my $Value = $JobData{ 'NewTicketFreeText' . $ID } || '';
                $NewTicketFreeText
                    = '<input type="text" name="NewTicketFreeText'
                    . $ID
                    . '" size="30" value="'
                    . $Value . '">';
            }
            else {
                my %TicketFreeText = %{ $Self->{ConfigObject}->Get( 'TicketFreeText' . $ID ) };
                $NewTicketFreeText = $Self->{LayoutObject}->BuildSelection(
                    Data        => \%TicketFreeText,
                    Name        => 'NewTicketFreeText' . $ID,
                    Size        => 4,
                    Multiple    => 1,
                    Translation => 0,
                    SelectedID  => $JobData{ 'NewTicketFreeText' . $ID },
                );
            }

            $Self->{LayoutObject}->Block(
                Name => 'NewTicketFreeFieldElement',
                Data => {
                    NewTicketFreeKey  => $NewTicketFreeKey,
                    NewTicketFreeText => $NewTicketFreeText,
                    ValueID           => 'NewTicketFreeText' . $ID
                },
            );
        }
    }
    return \%JobData;
}

1;
