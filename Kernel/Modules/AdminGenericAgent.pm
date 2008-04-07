# --
# Kernel/Modules/AdminGenericAgent.pm - admin generic agent interface
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminGenericAgent.pm,v 1.47 2008-04-07 16:56:38 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
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

    my $Output = '';

    # get confid data
    $Self->{Profile}    = $Self->{ParamObject}->GetParam( Param => 'Profile' )    || '';
    $Self->{OldProfile} = $Self->{ParamObject}->GetParam( Param => 'OldProfile' ) || '';
    $Self->{Subaction}  = $Self->{ParamObject}->GetParam( Param => 'Subaction' )  || '';

    # ---------------------------------------------------------- #
    # run a generic agent job -> "run now"
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'RunNow' ) {
        if ($Self->{GenericAgentObject}->JobRun(
                Job    => $Self->{Profile},
                UserID => 1,
            )
            )
        {

            # redirect
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}", );
        }
        # redirect
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # ---------------------------------------------------------- #
    # add a new generic agent job
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Add' && $Self->{Profile} ) {

        # insert new profile params
        $Self->{GenericAgentObject}->JobAdd(
            Name   => $Self->{Profile},
            Data   => { ScheduleLastRun => '', },
            UserID => $Self->{UserID},
        );

        # redirect
        return $Self->{LayoutObject}
            ->Redirect( OP => "Action=$Self->{Action}&Subaction=Update&Profile=$Self->{Profile}", );
    }

    # --------------------------------------------------------------- #
    # save generic agent job and show a view of all affected tickets
    # --------------------------------------------------------------- #
    # show result site
    if ( $Self->{Subaction} eq 'UpdateAction' ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} ) {
            $Output = $Self->{LayoutObject}->Header( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->Warning( Message => 'Need Job Name!' );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # get single params
        my %GetParam = ();
        for (
            qw(TicketNumber Title From To Cc Subject Body CustomerID CustomerUserLogin Agent
            TimeSearchType TicketCreateTimePointFormat TicketCreateTimePoint
            TicketCreateTimePointStart
            TicketCreateTimeStart TicketCreateTimeStartDay TicketCreateTimeStartMonth
            TicketCreateTimeStartYear
            TicketCreateTimeStop TicketCreateTimeStopDay TicketCreateTimeStopMonth
            TicketCreateTimeStopYear
            TimePendingSearchType TicketPendingTimePointFormat TicketPendingTimePoint
            TicketPendingTimePointStart
            TicketPendingTimeStart TicketPendingTimeStartDay TicketPendingTimeStartMonth
            TicketPendingTimeStartYear
            TicketPendingTimeStop TicketPendingTimeStopDay TicketPendingTimeStopMonth
            TicketPendingTimeStopYear
            NewTitle
            NewCustomerID NewCustomerUserLogin
            NewStateID NewQueueID NewPriorityID NewOwnerID
            NewTypeID NewServiceID NewSLAID
            NewNoteFrom NewNoteSubject NewNoteBody NewModule
            NewParamKey1 NewParamKey2 NewParamKey3 NewParamKey4
            NewParamValue1 NewParamValue2 NewParamValue3 NewParamValue4
            NewParamKey5 NewParamKey6 NewParamKey7 NewParamKey8
            NewParamValue5 NewParamValue6 NewParamValue7 NewParamValue8
            NewLockID NewDelete NewCMD NewSendNoNotification
            ScheduleLastRun Valid
            )
            )
        {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );

            # remove white space on the end
            if ( $GetParam{$_} ) {
                $GetParam{$_} =~ s/\s+$//g;
                $GetParam{$_} =~ s/^\s+//g;
            }
        }

        # get new free field params
        for my $ID ( 1 .. 16 ) {

            # ticket free keys
            if ( defined( $Self->{ParamObject}->GetParam( Param => "NewTicketFreeKey$ID" ) ) ) {
                $GetParam{"NewTicketFreeKey$ID"}
                    = $Self->{ParamObject}->GetParam( Param => "NewTicketFreeKey" . $ID );

                # remove white space on the end
                if ( $GetParam{"NewTicketFreeKey$ID"} ) {
                    $GetParam{"NewTicketFreeKey$ID"} =~ s/\s+$//g;
                    $GetParam{"NewTicketFreeKey$ID"} =~ s/^\s+//g;
                }
            }

            # ticket free text
            if ($Self->{ParamObject}->GetParam( Param => "NewTicketFreeText$ID" )
                || ( defined( $Self->{ParamObject}->GetParam( Param => "NewTicketFreeText$ID" ) )
                    && $Self->{ConfigObject}->Get("TicketFreeText$ID") )
                )
            {
                $GetParam{"NewTicketFreeText$ID"}
                    = $Self->{ParamObject}->GetParam( Param => "NewTicketFreeText$ID" );

                # remove white space on the end
                if ( $GetParam{"NewTicketFreeText$ID"} ) {
                    $GetParam{"NewTicketFreeText$ID"} =~ s/\s+$//g;
                    $GetParam{"NewTicketFreeText$ID"} =~ s/^\s+//g;
                }
            }
        }

        # get array params
        for (
            qw(LockIDs StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
            TypeIDs ServiceIDs SLAIDs
            ScheduleDays ScheduleMinutes ScheduleHours
            )
            )
        {

            # get search array params (get submitted params)
            if ( $Self->{ParamObject}->GetArray( Param => $_ ) ) {
                @{ $GetParam{$_} } = $Self->{ParamObject}->GetArray( Param => $_ );
            }
        }

        # get free field params
        for my $ID ( 1 .. 16 ) {

            # get search array params for free key (get submitted params)
            if ( $Self->{ParamObject}->GetArray( Param => "TicketFreeKey$ID" ) ) {
                @{ $GetParam{"TicketFreeKey$ID"} }
                    = $Self->{ParamObject}->GetArray( Param => "TicketFreeKey$ID" );
            }

            # get search array params for free text (get submitted params)

            if ( $Self->{ConfigObject}->Get("TicketFreeText$ID") ) {
                if ( $Self->{ParamObject}->GetArray( Param => "TicketFreeText$ID" ) ) {
                    @{ $GetParam{"TicketFreeText$ID"} }
                        = $Self->{ParamObject}->GetArray( Param => "TicketFreeText$ID" );
                }
            }
            else {
                my @Array = $Self->{ParamObject}->GetArray( Param => "TicketFreeText$ID" );
                if ( $Array[0] ) {
                    @{ $GetParam{"TicketFreeText$ID"} } = @Array;
                }
            }
        }

        # remove/clean up old profile stuff
        $Self->{GenericAgentObject}->JobDelete(
            Name   => $Self->{OldProfile},
            UserID => $Self->{UserID},
        );

        # insert new profile params
        $Self->{GenericAgentObject}->JobAdd(
            Name   => $Self->{Profile},
            Data   => \%GetParam,
            UserID => $Self->{UserID},
        );

        # get time settings
        if ( !$GetParam{TimeSearchType} || $GetParam{TimeSearchType} eq 'None' ) {

            # do noting on time stuff
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                if ( $GetParam{"TicketCreateTimeStart$_"} <= 9 ) {
                    $GetParam{"TicketCreateTimeStart$_"}
                        = '0' . $GetParam{"TicketCreateTimeStart$_"};
                }
            }
            for (qw(Month Day)) {
                if ( $GetParam{"TicketCreateTimeStop$_"} <= 9 ) {
                    $GetParam{"TicketCreateTimeStop$_"} = '0' . $GetParam{"TicketCreateTimeStop$_"};
                }
            }
            if (   $GetParam{TicketCreateTimeStartDay}
                && $GetParam{TicketCreateTimeStartMonth}
                && $GetParam{TicketCreateTimeStartYear} )
            {
                $GetParam{TicketCreateTimeNewerDate}
                    = $GetParam{TicketCreateTimeStartYear} . '-'
                    . $GetParam{TicketCreateTimeStartMonth} . '-'
                    . $GetParam{TicketCreateTimeStartDay}
                    . ' 00:00:01';
            }
            if (   $GetParam{TicketCreateTimeStopDay}
                && $GetParam{TicketCreateTimeStopMonth}
                && $GetParam{TicketCreateTimeStopYear} )
            {
                $GetParam{TicketCreateTimeOlderDate}
                    = $GetParam{TicketCreateTimeStopYear} . '-'
                    . $GetParam{TicketCreateTimeStopMonth} . '-'
                    . $GetParam{TicketCreateTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
            if (   $GetParam{TicketCreateTimePoint}
                && $GetParam{TicketCreateTimePointStart}
                && $GetParam{TicketCreateTimePointFormat} )
            {
                my $Time = 0;
                if ( $GetParam{TicketCreateTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketCreateTimePoint};
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketCreateTimePointStart} eq 'Before' ) {
                    $GetParam{TicketCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCreateTimeNewerMinutes} = $Time;
                }
            }
        }

        # get time settings
        if ( !$GetParam{TimePendingSearchType} || $GetParam{TimePendingSearchType} eq 'None' ) {

            # do noting on time stuff
        }
        elsif ( $GetParam{TimePendingSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                if ( $GetParam{"TicketPendingTimeStart$_"} <= 9 ) {
                    $GetParam{"TicketPendingTimeStart$_"}
                        = '0' . $GetParam{"TicketPendingTimeStart$_"};
                }
            }
            for (qw(Month Day)) {
                if ( $GetParam{"TicketPendingTimeStop$_"} <= 9 ) {
                    $GetParam{"TicketPendingTimeStop$_"}
                        = '0' . $GetParam{"TicketPendingTimeStop$_"};
                }
            }
            if (   $GetParam{TicketPendingTimeStartDay}
                && $GetParam{TicketPendingTimeStartMonth}
                && $GetParam{TicketPendingTimeStartYear} )
            {
                $GetParam{TicketPendingTimeNewerDate}
                    = $GetParam{TicketPendingTimeStartYear} . '-'
                    . $GetParam{TicketPendingTimeStartMonth} . '-'
                    . $GetParam{TicketPendingTimeStartDay}
                    . ' 00:00:01';
            }
            if (   $GetParam{TicketPendingTimeStopDay}
                && $GetParam{TicketPendingTimeStopMonth}
                && $GetParam{TicketPendingTimeStopYear} )
            {
                $GetParam{TicketPendingTimeOlderDate}
                    = $GetParam{TicketPendingTimeStopYear} . '-'
                    . $GetParam{TicketPendingTimeStopMonth} . '-'
                    . $GetParam{TicketPendingTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{TimePendingSearchType} eq 'TimePoint' ) {
            if (   $GetParam{TicketPendingTimePoint}
                && $GetParam{TicketPendingTimePointStart}
                && $GetParam{TicketPendingTimePointFormat} )
            {
                my $Time = 0;
                if ( $GetParam{TicketPendingTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketPendingTimePoint};
                }
                elsif ( $GetParam{TicketPendingTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketPendingTimePoint} * 60;
                }
                elsif ( $GetParam{TicketPendingTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketPendingTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketPendingTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketPendingTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketPendingTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketPendingTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketPendingTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketPendingTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketPendingTimePointStart} eq 'Before' ) {
                    $GetParam{TicketPendingTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketPendingTimeNewerMinutes} = $Time;
                }
            }
        }

        # focus of "From To Cc Subject Body"
        for (qw(From To Cc Subject Body)) {
            if ( defined( $GetParam{$_} ) && $GetParam{$_} ne '' ) {
                $GetParam{$_} = "$GetParam{$_}";
            }
        }

        # perform ticket search
        my $Counter     = 0;
        my @ViewableIDs = $Self->{TicketObject}->TicketSearch(
            Result  => 'ARRAY',
            SortBy  => 'Age',
            OrderBy => 'Down',
            UserID  => 1,
            %GetParam,
        );
        if ( $GetParam{NewDelete} ) {
            $Param{DeleteMessage}
                = 'You use the DELETE option! Take care, all deleted Tickets are lost!!!';
        }
        if (@ViewableIDs) {
            $Param{AffectedIDs} = $#ViewableIDs + 1;
        }
        else {
            $Param{AffectedIDs} = 0;
        }

        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => { %Param, Name => $Self->{Profile}, },
        );
        if ( $ViewableIDs[0] ) {
            $Self->{LayoutObject}->Block( Name => 'ResultBlock', );
            for ( 0 .. $#ViewableIDs ) {

                # get first article data
                my %Data
                    = $Self->{TicketObject}->ArticleFirstArticle( TicketID => $ViewableIDs[$_] );
                $Data{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Data{Age}, Space => ' ' );
                $Data{css} = "PriorityID-$Data{PriorityID}";

                # user info
                my %UserInfo = $Self->{UserObject}->GetUserData(
                    User   => $Data{Owner},
                    Cached => 1
                );
                $Data{UserLastname}  = $UserInfo{UserLastname};
                $Data{UserFirstname} = $UserInfo{UserFirstname};

                $Self->{LayoutObject}->Block(
                    Name => 'Ticket',
                    Data => \%Data,
                );

                # just show 25 tickts
                last if $_ > 25;
            }
        }

        # html search mask output
        $Output = $Self->{LayoutObject}->Header( Title => 'Affected Tickets' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data         => \%Param,
        );

        # build footer
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit generic agent job
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Update' && $Self->{Profile} ) {

        # get db job data
        my %Param = $Self->{GenericAgentObject}->JobGet( Name => $Self->{Profile} );
        $Param{Profile} = $Self->{Profile};

        my %ShownUsers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        $Param{OwnerStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data               => \%ShownUsers,
            Name               => 'OwnerIDs',
            Multiple           => 1,
            Size               => 5,
            SelectedIDRefArray => $Param{OwnerIDs},
        );
        $Param{NewOwnerStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%ShownUsers,
            Name       => 'NewOwnerID',
            Size       => 5,
            Multiple   => 1,
            SelectedID => $Param{NewOwnerID},
        );
        my %Hours = ();
        for ( 0 .. 23 ) {
            $Hours{$_} = sprintf( "%02d", $_ );
        }
        $Param{ScheduleHours} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data               => \%Hours,
            Name               => 'ScheduleHours',
            Size               => 6,
            Multiple           => 1,
            SelectedIDRefArray => $Param{ScheduleHours},
        );
        $Param{ScheduleMinutes} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                '00' => '00',
                10   => '10',
                20   => '20',
                30   => '30',
                40   => '40',
                50   => '50',
            },
            Name               => 'ScheduleMinutes',
            Size               => 6,
            Multiple           => 1,
            SelectedIDRefArray => $Param{ScheduleMinutes},
        );
        $Param{ScheduleDays} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                1 => 'Mon',
                2 => 'Tue',
                3 => 'Wed',
                4 => 'Thu',
                5 => 'Fri',
                6 => 'Sat',
                0 => 'Sun',
            },
            SortBy             => 'Key',
            Name               => 'ScheduleDays',
            Size               => 6,
            Multiple           => 1,
            SelectedIDRefArray => $Param{ScheduleDays},
        );

        $Param{StatesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{StateObject}->StateList(
                    UserID => 1,
                    Action => $Self->{Action},
                ),
            },
            Name               => 'StateIDs',
            Multiple           => 1,
            Size               => 5,
            SelectedIDRefArray => $Param{StateIDs},
        );
        $Param{NewStatesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{StateObject}->StateList(
                    UserID => 1,
                    Action => $Self->{Action},
                ),
            },
            Name       => 'NewStateID',
            Size       => 5,
            Multiple   => 1,
            SelectedID => $Param{NewStateID},
        );
        $Param{QueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data               => { $Self->{QueueObject}->GetAllQueues(), },
            Size               => 5,
            Multiple           => 1,
            Name               => 'QueueIDs',
            SelectedIDRefArray => $Param{QueueIDs},
            OnChangeSubmit     => 0,
        );
        $Param{NewQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data           => { $Self->{QueueObject}->GetAllQueues(), },
            Size           => 5,
            Multiple       => 1,
            Name           => 'NewQueueID',
            SelectedID     => $Param{NewQueueID},
            OnChangeSubmit => 0,
        );
        $Param{PrioritiesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{PriorityObject}->PriorityList(
                    UserID => 1,
                    Action => $Self->{Action},
                ),
            },
            Name               => 'PriorityIDs',
            Multiple           => 1,
            Size               => 5,
            SelectedIDRefArray => $Param{PriorityIDs},
        );
        $Param{NewPrioritiesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{PriorityObject}->PriorityList(
                    UserID => 1,
                    Action => $Self->{Action},
                ),
            },
            Name       => 'NewPriorityID',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $Param{NewPriorityID},
        );

        # get create time option
        if ( !$Param{TimeSearchType} ) {
            $Param{'TimeSearchType::None'} = 'checked';
        }
        elsif ( $Param{TimeSearchType} eq 'TimePoint' ) {
            $Param{'TimeSearchType::TimePoint'} = 'checked';
        }
        elsif ( $Param{TimeSearchType} eq 'TimeSlot' ) {
            $Param{'TimeSearchType::TimeSlot'} = 'checked';
        }

        # get pending time option
        if ( !$Param{TimePendingSearchType} ) {
            $Param{'TimePendingSearchType::None'} = 'checked';
        }
        elsif ( $Param{TimePendingSearchType} eq 'TimePoint' ) {
            $Param{'TimePendingSearchType::TimePoint'} = 'checked';
        }
        elsif ( $Param{TimePendingSearchType} eq 'TimeSlot' ) {
            $Param{'TimePendingSearchType::TimeSlot'} = 'checked';
        }

        my %Counter = ();
        for ( 1 .. 60 ) {
            $Counter{$_} = sprintf( "%02d", $_ );
        }

        # create time
        $Param{TicketCreateTimePoint} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%Counter,
            Name       => 'TicketCreateTimePoint',
            SelectedID => $Param{TicketCreateTimePoint},
        );
        $Param{TicketCreateTimePointStart} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                'Last'   => 'last',
                'Before' => 'before',
            },
            Name       => 'TicketCreateTimePointStart',
            SelectedID => $Param{TicketCreateTimePointStart} || 'Last',
        );
        $Param{TicketCreateTimePointFormat} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketCreateTimePointFormat',
            SelectedID => $Param{TicketCreateTimePointFormat},
        );
        $Param{TicketCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => 'TicketCreateTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => 'TicketCreateTimeStop',
            Format => 'DateInputFormat',
        );

        # pending time
        $Param{TicketPendingTimePoint} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%Counter,
            Name       => 'TicketPendingTimePoint',
            SelectedID => $Param{TicketPendingTimePoint},
        );
        $Param{TicketPendingTimePointStart} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                'Last'   => 'last',
                'Before' => 'before',
            },
            Name       => 'TicketPendingTimePointStart',
            SelectedID => $Param{TicketPendingTimePointStart} || 'Last',
        );
        $Param{TicketPendingTimePointFormat} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketPendingTimePointFormat',
            SelectedID => $Param{TicketPendingTimePointFormat},
        );
        $Param{TicketPendingTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => 'TicketPendingTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketPendingTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => 'TicketPendingTimeStop',
            Format => 'DateInputFormat',
        );
        $Param{DeleteOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name       => 'NewDelete',
            SelectedID => $Param{NewDelete},
        );
        $Param{ValidOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name       => 'Valid',
            SelectedID => defined( $Param{Valid} ) ? $Param{Valid} : 1,
        );
        $Param{LockOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{LockObject}->LockList(
                    UserID => 1,
                    Action => $Self->{Action},
                ),
            },
            Name               => 'LockIDs',
            Multiple           => 1,
            Size               => 3,
            SelectedIDRefArray => $Param{LockIDs},
        );
        $Param{NewLockOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                $Self->{LockObject}->LockList(
                    UserID => 1,
                    Action => $Self->{Action},
                ),
            },
            Name       => 'NewLockID',
            Size       => 3,
            Multiple   => 1,
            SelectedID => $Param{NewLockID},
        );

        $Param{SendNoNotificationOption} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name       => 'NewSendNoNotification',
            SelectedID => $Param{NewSendNoNotification} || 0,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Edit',
            Data => \%Param,
        );

        # add ticket title
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketTitle',
                Data => { %Param },
            );
            $Self->{LayoutObject}->Block(
                Name => 'NewTicketTitle',
                Data => { %Param },
            );
        }

        # build type string
        if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
            my %Type = $Self->{TypeObject}->TypeList( UserID => $Self->{UserID}, );
            $Param{'TypesStrg'} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%Type,
                Name        => 'TypeIDs',
                SelectedID  => $Param{TypeIDs},
                Sort        => 'AlphanumericValue',
                Size        => 3,
                Multiple    => 1,
                Translation => 0,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketType',
                Data => {%Param},
            );
            $Param{NewTypesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%Type,
                Name        => 'NewTypeID',
                SelectedID  => $Param{NewTypeID},
                Sort        => 'AlphanumericValue',
                Size        => 3,
                Multiple    => 1,
                Translation => 0,
            );
            $Self->{LayoutObject}->Block(
                Name => 'NewTicketType',
                Data => {%Param},
            );
        }

        # build service string
        if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

            # get list type
            my $TreeView = 0;
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
                $TreeView = 1;
            }
            my %Service = $Self->{ServiceObject}->ServiceList( UserID => $Self->{UserID}, );
            $Param{ServicesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%Service,
                Name        => 'ServiceIDs',
                SelectedID  => $Param{ServiceIDs},
                TreeView    => $TreeView,
                Sort        => 'TreeView',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
            );
            $Param{NewServicesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%Service,
                Name        => 'NewServiceID',
                SelectedID  => $Param{NewServiceID},
                TreeView    => $TreeView,
                Sort        => 'TreeView',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
            );
            my %SLA = $Self->{SLAObject}->SLAList( UserID => $Self->{UserID}, );
            $Param{SLAsStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%SLA,
                Name        => 'SLAIDs',
                SelectedID  => $Param{SLAIDs},
                Sort        => 'AlphanumericValue',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
            );
            $Param{NewSLAsStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%SLA,
                Name       => 'NewSLAID',
                SelectedID => $Param{NewSLAID},
                Sort        => 'AlphanumericValue',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketService',
                Data => {%Param},
            );
            $Self->{LayoutObject}->Block(
                Name => 'NewTicketService',
                Data => {%Param},
            );
        }

        # Free field settings
        my $Flag = 1;
        for my $ID ( 1 .. 16 ) {
            if ( ref( $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) ) eq 'HASH' ) {

                # $Flag to show the whole freefield block
                if ($Flag) {
                    $Self->{LayoutObject}->Block( Name => 'TicketFreeField' );
                    $Flag = 0;
                }

                # generate free key
                my %TicketFreeKey = %{ $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) };
                my @FreeKey       = keys %TicketFreeKey;
                my $TicketFreeKey = '';

                if ( $#FreeKey == 0 ) {
                    $TicketFreeKey = $TicketFreeKey{ $FreeKey[0] };
                }
                else {
                    $TicketFreeKey = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data                => \%TicketFreeKey,
                        Name                => 'TicketFreeKey' . $ID,
                        Size                => 4,
                        Multiple            => 1,
                        LanguageTranslation => 0,
                        SelectedIDRefArray  => $Param{ 'TicketFreeKey' . $ID },
                    );
                }

                # generate free text
                my $TicketFreeText = '';
                if ( !$Self->{ConfigObject}->Get( 'TicketFreeText' . $ID ) ) {
                    $TicketFreeText
                        = '<input type="text" name="TicketFreeText'
                        . $ID
                        . '" size="30" value="'
                        . ( $Param{ 'TicketFreeText' . $ID }[0] || '' ) . '">';
                }
                else {
                    my %TicketFreeText = %{ $Self->{ConfigObject}->Get( 'TicketFreeText' . $ID ) };
                    $TicketFreeText = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data                => \%TicketFreeText,
                        Name                => 'TicketFreeText' . $ID,
                        Size                => 4,
                        Multiple            => 1,
                        LanguageTranslation => 0,
                        SelectedIDRefArray  => $Param{ 'TicketFreeText' . $ID },
                    );
                }

                $Self->{LayoutObject}->Block(
                    Name => 'TicketFreeFieldElement',
                    Data => {
                        TicketFreeKey  => $TicketFreeKey,
                        TicketFreeText => $TicketFreeText,
                    },
                );
            }
        }

        # New free field settings
        $Flag = 1;
        for my $ID ( 1 .. 16 ) {
            if ( ref( $Self->{ConfigObject}->Get( 'TicketFreeKey' . $ID ) ) eq 'HASH' ) {

                # $Falg to shcw the hole freefield block
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
                    $NewTicketFreeKey = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data                => \%TicketFreeKey,
                        Name                => 'NewTicketFreeKey' . $ID,
                        Size                => 4,
                        Multiple            => 1,
                        LanguageTranslation => 0,
                        SelectedID          => $Param{ 'NewTicketFreeKey' . $ID },
                    );
                }

                # generate free text
                my $NewTicketFreeText = '';
                if ( !$Self->{ConfigObject}->Get( 'TicketFreeText' . $ID ) ) {
                    $NewTicketFreeText
                        = '<input type="text" name="NewTicketFreeText'
                        . $ID
                        . '" size="30" value="'
                        . $Param{ 'NewTicketFreeText' . $ID } . '">';
                }
                else {
                    my %TicketFreeText = %{ $Self->{ConfigObject}->Get( 'TicketFreeText' . $ID ) };
                    $NewTicketFreeText = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data                => \%TicketFreeText,
                        Name                => 'NewTicketFreeText' . $ID,
                        Size                => 4,
                        Multiple            => 1,
                        LanguageTranslation => 0,
                        SelectedID          => $Param{ 'NewTicketFreeText' . $ID },
                    );
                }

                $Self->{LayoutObject}->Block(
                    Name => 'NewTicketFreeFieldElement',
                    Data => {
                        NewTicketFreeKey  => $NewTicketFreeKey,
                        NewTicketFreeText => $NewTicketFreeText,
                    },
                );
            }
        }

        # generate search mask
        my $Output = $Self->{LayoutObject}->Header( Title => 'Edit' );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data         => \%Param,
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
    $Self->{LayoutObject}->Block( Name => 'Overview', );
    my %Jobs    = $Self->{GenericAgentObject}->JobList();
    my $Counter = 1;
    for ( sort keys %Jobs ) {
        my %JobData = $Self->{GenericAgentObject}->JobGet( Name => $_ );

        # css setting and text for valid or invalid jobs
        if ( $JobData{Valid} ) {
            $JobData{ShownValid} = 'valid';
            $JobData{cssValid}   = '';
        }
        else {
            $JobData{ShownValid} = 'invalid';
            $JobData{cssValid}   = 'contentvaluepassiv';
        }

        # seperate each searchresult line by using several css
        $Counter++;
        $JobData{css} = $Counter % 2 ? 'searchpassive' : 'searchactive';

        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {%JobData},
        );
    }

    # generate search mask
    $Output = $Self->{LayoutObject}->Header( Title => 'Overview' );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericAgent',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
