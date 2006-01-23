# --
# Kernel/Modules/AdminGenericAgent.pm - admin generic agent interface
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminGenericAgent.pm,v 1.20.2.1 2006-01-23 17:11:12 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminGenericAgent;

use strict;
use Kernel::System::Priority;
use Kernel::System::State;
use Kernel::System::Lock;
use Kernel::System::GenericAgent;

use vars qw($VERSION);
$VERSION = '$Revision: 1.20.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{LockObject} = Kernel::System::Lock->new(%Param);
    $Self->{GenericAgentObject} = Kernel::System::GenericAgent->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # get confid data
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 1;
    $Self->{SearchLimit} = $Self->{ConfigObject}->Get('SearchLimit') || 500;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam(Param => 'SortBy') || 'Age';
    $Self->{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || 'Down';
    $Self->{Profile} = $Self->{ParamObject}->GetParam(Param => 'Profile') || '';
    $Self->{OldProfile} = $Self->{ParamObject}->GetParam(Param => 'OldProfile') || '';
    $Self->{SaveProfile} = 1;
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam(Param => 'TakeLastSearch') || '';
    $Self->{SelectTemplate} = $Self->{ParamObject}->GetParam(Param => 'SelectTemplate') || '';
    $Self->{EraseTemplate} = $Self->{ParamObject}->GetParam(Param => 'EraseTemplate') || '';
    # get db job data
    my %DBParam = $Self->{GenericAgentObject}->JobGet(Name => $Self->{Profile}) if ($Self->{Profile});

    # run job now
    if ($Self->{Subaction} eq 'RunNow' && %DBParam) {
        $Self->{GenericAgentObject}->JobRun(
            Job => $Self->{Profile},
            UserID => 1,
        );
        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}",
        );
    }

    # create new job
    if ($Self->{Subaction} eq 'Add' && $Self->{Profile}) {
        # insert new profile params
        $Self->{GenericAgentObject}->JobAdd(
            Name => $Self->{Profile},
            Data => {
                ScheduleLastRun => '',
            },
        );
        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}&Subaction=LoadProfile&Profile=$Self->{Profile}",
        );
    }

    # get signle params
    my %GetParam = ();
    foreach (qw(TicketNumber From To Cc Subject Body CustomerID CustomerUserLogin
      Agent TimeSearchType
      TicketCreateTimePointFormat TicketCreateTimePoint
      TicketCreateTimePointStart
      TicketCreateTimeStart TicketCreateTimeStartDay TicketCreateTimeStartMonth
      TicketCreateTimeStartYear
      TicketCreateTimeStop TicketCreateTimeStopDay TicketCreateTimeStopMonth
      TicketCreateTimeStopYear
      NewCustomerID NewCustomerUserLogin
      NewStateID NewQueueID NewPriorityID NewOwnerID
      NewNoteFrom NewNoteSubject NewNoteBody NewModule
      NewParamKey1 NewParamKey2 NewParamKey3 NewParamKey4
      NewParamValue1 NewParamValue2 NewParamValue3 NewParamValue4
      NewParamKey5 NewParamKey6 NewParamKey7 NewParamKey8
      NewParamValue5 NewParamValue6 NewParamValue7 NewParamValue8
      NewLockID NewDelete NewCMD
      ScheduleLastRun Valid
    )) {
        # load profiles string params (press load profile)
        if (($Self->{Subaction} eq 'LoadProfile' && $Self->{Profile}) || $Self->{TakeLastSearch}) {
            $GetParam{$_} = $DBParam{$_};
        }
        # get search string params (get submitted params)
        else {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
            # remove white space on the end
            if ($GetParam{$_}) {
                $GetParam{$_} =~ s/\s$//g;
            }
        }
    }
    # get array params
    foreach (qw(LockIDs StateIDs StateTypeIDs QueueIDs PriorityIDs UserIDs
      ScheduleDays ScheduleMinutes ScheduleHours
      TicketFreeKey1 TicketFreeText1 TicketFreeKey2 TicketFreeText2
      TicketFreeKey3 TicketFreeText3 TicketFreeKey4 TicketFreeText4
      TicketFreeKey5 TicketFreeText5 TicketFreeKey6 TicketFreeText6
      TicketFreeKey7 TicketFreeText7 TicketFreeKey8 TicketFreeText8)) {
        # load profile array params (press load profile)
        if (($Self->{Subaction} eq 'LoadProfile' && $Self->{Profile}) || $Self->{TakeLastSearch}) {
            if ($DBParam{$_}) {
                $GetParam{$_} = $DBParam{$_};
            }
        }
        # get search array params (get submitted params)
        else {
            if ($Self->{ParamObject}->GetArray(Param => $_)) {
                if ($Self->{ParamObject}->GetArray(Param => $_)) {
                    @{$GetParam{$_}} = $Self->{ParamObject}->GetArray(Param => $_);
                }
            }
        }
    }
    # get time option
    if (!$GetParam{TimeSearchType}) {
        $GetParam{'TimeSearchType::None'} = 'checked';
    }
    elsif ($GetParam{TimeSearchType} eq 'TimePoint') {
        $GetParam{'TimeSearchType::TimePoint'} = 'checked';
    }
    elsif ($GetParam{TimeSearchType} eq 'TimeSlot') {
        $GetParam{'TimeSearchType::TimeSlot'} = 'checked';
    }
    # show result site
    if ($Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate}) {
        # fill up profile name (e.g. with last-search)
        if (!$Self->{Profile} || !$Self->{SaveProfile}) {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(Message => 'Need Job Name!');
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # save search profile (under last-search or real profile name)
        $Self->{SaveProfile} = 1;
        # remember last search values
        if ($Self->{SaveProfile} && $Self->{Profile}) {
            # remove/clean up old profile stuff
            $Self->{GenericAgentObject}->JobDelete(Name => $Self->{OldProfile});
            # insert new profile params
            $Self->{GenericAgentObject}->JobAdd(Name => $Self->{Profile}, Data => \%GetParam);
        }
        # get time settings
        if (!$GetParam{TimeSearchType}) {
            # do noting ont time stuff
        }
        elsif ($GetParam{TimeSearchType} eq 'TimeSlot') {
          foreach (qw(Month Day)) {
              if ($GetParam{"TicketCreateTimeStart$_"} <= 9) {
                  $GetParam{"TicketCreateTimeStart$_"} = '0'.$GetParam{"TicketCreateTimeStart$_"};
              }
          }
          foreach (qw(Month Day)) {
              if ($GetParam{"TicketCreateTimeStop$_"} <= 9) {
                  $GetParam{"TicketCreateTimeStop$_"} = '0'.$GetParam{"TicketCreateTimeStop$_"};
              }
          }
          if ($GetParam{TicketCreateTimeStartDay} && $GetParam{TicketCreateTimeStartMonth} && $GetParam{TicketCreateTimeStartYear}) {
              $GetParam{TicketCreateTimeNewerDate} = $GetParam{TicketCreateTimeStartYear}.
                '-'.$GetParam{TicketCreateTimeStartMonth}.
                '-'.$GetParam{TicketCreateTimeStartDay}.
                ' 00:00:01';
          }
          if ($GetParam{TicketCreateTimeStopDay} && $GetParam{TicketCreateTimeStopMonth} && $GetParam{TicketCreateTimeStopYear}) {
              $GetParam{TicketCreateTimeOlderDate} = $GetParam{TicketCreateTimeStopYear}.
                '-'.$GetParam{TicketCreateTimeStopMonth}.
                '-'.$GetParam{TicketCreateTimeStopDay}.
                ' 23:59:59';
          }
        }
        elsif ($GetParam{TimeSearchType} eq 'TimePoint') {
          if ($GetParam{TicketCreateTimePoint} && $GetParam{TicketCreateTimePointStart} && $GetParam{TicketCreateTimePointFormat}) {
            my $Time = 0;
            if ($GetParam{TicketCreateTimePointFormat} eq 'minute') {
                $Time = $GetParam{TicketCreateTimePoint};
            }
            elsif ($GetParam{TicketCreateTimePointFormat} eq 'hour') {
                $Time = $GetParam{TicketCreateTimePoint} * 60;
            }
            elsif ($GetParam{TicketCreateTimePointFormat} eq 'day') {
                $Time = $GetParam{TicketCreateTimePoint} * 60 * 24;
            }
            elsif ($GetParam{TicketCreateTimePointFormat} eq 'week') {
                $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 7;
            }
            elsif ($GetParam{TicketCreateTimePointFormat} eq 'month') {
                $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 30;
            }
            elsif ($GetParam{TicketCreateTimePointFormat} eq 'year') {
                $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 365;
            }
            if ($GetParam{TicketCreateTimePointStart} eq 'Before') {
                $GetParam{TicketCreateTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketCreateTimeNewerMinutes} = $Time;
            }
          }
        }
        # focus of "From To Cc Subject Body"
        foreach (qw(From To Cc Subject Body)) {
            if (defined($GetParam{$_}) && $GetParam{$_} ne '') {
                $GetParam{$_} = "$GetParam{$_}";
            }
        }
        # perform ticket search
        my $Counter = 0;
        my @ViewableIDs = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            SortBy => $Self->{SortBy},
            OrderBy => $Self->{Order},
            Limit => $Self->{SearchLimit},
            UserID => 1,
            %GetParam,
        );
        # start page
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if ($GetParam{NewDelete}) {
            $Param{Message} = 'You use the DELETE option! Take care, all deleted Tickets are lost!!!'.@ViewableIDs.' Tickets affected! You really want to use this job?';
        }
        else {
            $Param{Message} = @ViewableIDs.' Tickets affected! You really want to use this job?';
        }
        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => { %Param, Name => $Self->{Profile}, },
        );
        foreach (0..$#ViewableIDs) {
            # get first article data
            my %Data = $Self->{TicketObject}->ArticleFirstArticle(TicketID => $ViewableIDs[$_]);
            $Self->{LayoutObject}->Block(
                Name => 'Ticket',
                Data => { %Data },
            );
            # just show 25 tickts
            if ($_ > 25) {
                last;
            }
        }
        # html search mask output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data => \%Param,
        );
        # build footer
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # empty search site
    else {
        # delete profile
        if ($Self->{EraseTemplate} && $Self->{Profile}) {
            $Self->{GenericAgentObject}->JobDelete(Name => $Self->{Profile});
            %GetParam = ();
            $Self->{Profile} = '';
        }
        # set profile to zero
        elsif (!$Self->{SelectTemplate}) {
#            $Self->{Profile} = '';
        }
        # generate search mask
        my $Output = $Self->{LayoutObject}->Header();
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..8) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                Type => "TicketFreeKey$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                Type => "TicketFreeText$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            NullOption => 1,
            Ticket => \%GetParam,
            Config => \%TicketFreeText,
        );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->MaskForm(
            %GetParam,
            %TicketFreeTextHTML,
            Profile => $Self->{Profile},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub MaskForm {
    my $Self = shift;
    my %Param = @_;
    # --
    # get user of own groups
    # --
    my %ShownUsers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    $Param{'UserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%ShownUsers,
        Name => 'UserIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{UserIDs},
    );
    $Param{'NewOwnerStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%ShownUsers,
        Name => 'NewOwnerID',
        Multiple => 1,
        Size => 5,
        SelectedID => $Param{NewOwnerID},
    );
    my %Hours = ();
    foreach (0..23) {
        $Hours{$_} = sprintf("%02d", $_);
    }
    $Param{'ScheduleHours'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%Hours,
        Name => 'ScheduleHours',
        Size => 6,
        Multiple => 1,
        SelectedIDRefArray => $Param{ScheduleHours},
    );
    my %Minutes = ();
    foreach (1..59) {
        $Minutes{$_} = sprintf("%02d", $_);
    }
    $Param{'ScheduleMinutes'} = $Self->{LayoutObject}->OptionStrgHashRef(
#        Data => \%Minutes,
        Data => {
            '00' => '00',
            10 => '10',
            20 => '20',
            30 => '30',
            40 => '40',
            50 => '50',
        },
        Name => 'ScheduleMinutes',
        Size => 6,
        Multiple => 1,
        SelectedIDRefArray => $Param{ScheduleMinutes},
    );
    $Param{'ScheduleDays'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
            0 => 'Sun',
        },
        SortBy => 'Key',
        Name => 'ScheduleDays',
        Size => 6,
        Multiple => 1,
        SelectedIDRefArray => $Param{ScheduleDays},
    );
    if ($Self->{Subaction} ne 'LoadProfile') {
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param },
        );
        my %Jobs = $Self->{GenericAgentObject}->JobList();
        foreach (sort keys %Jobs) {
            my %JobData = $Self->{GenericAgentObject}->JobGet(Name => $_);
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => { %JobData },
           );
        }
    }
    $Param{'StatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{StateObject}->StateList(
#             UserID => $Self->{UserID},
             UserID => 1,
             Action => $Self->{Action},
             ),
        },
        Name => 'StateIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{StateIDs},
    );
    $Param{'NewStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{StateObject}->StateList(
#             UserID => $Self->{UserID},
             UserID => 1,
             Action => $Self->{Action},
             )
        },
        Name => 'NewStateID',
        Multiple => 1,
        Size => 5,
        SelectedID => $Param{NewStateID},
    );
    $Param{'QueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { $Self->{QueueObject}->GetAllQueues(),},
        Size => 5,
        Multiple => 1,
        Name => 'QueueIDs',
        SelectedIDRefArray => $Param{QueueIDs},
        OnChangeSubmit => 0,
    );
    $Param{'NewQueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { $Self->{QueueObject}->GetAllQueues(),},
        Size => 5,
        Multiple => 1,
        Name => 'NewQueueID',
        SelectedID => $Param{NewQueueID},
        OnChangeSubmit => 0,
    );
    $Param{'PriotitiesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{PriorityObject}->PriorityList(
#            UserID => $Self->{UserID},
            UserID => 1,
            Action => $Self->{Action},
            ),
        },
        Name => 'PriorityIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{PriorityIDs},
    );
    $Param{'NewPriotitiesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{PriorityObject}->PriorityList(
#            UserID => $Self->{UserID},
            UserID => 1,
            Action => $Self->{Action},
            ),
        },
        Name => 'NewPriorityID',
        Multiple => 1,
        Size => 5,
        SelectedID => $Param{NewPriorityID},
    );
    $Param{'TicketCreateTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1 => ' 1',
            2 => ' 2',
            3 => ' 3',
            4 => ' 4',
            5 => ' 5',
            6 => ' 6',
            7 => ' 7',
            8 => ' 8',
            9 => ' 9',
            10 => '10',
            11 => '11',
            12 => '12',
            13 => '13',
            14 => '14',
            15 => '15',
            16 => '16',
            17 => '17',
            18 => '18',
            19 => '19',
            20 => '20',
            21 => '21',
            22 => '22',
            23 => '23',
            24 => '24',
            25 => '25',
            26 => '26',
            27 => '27',
            28 => '28',
            29 => '29',
            30 => '30',
            31 => '31',
            32 => '32',
            33 => '33',
            34 => '34',
            35 => '35',
            36 => '36',
            37 => '37',
            38 => '38',
            39 => '39',
            40 => '40',
            41 => '41',
            42 => '42',
            43 => '43',
            44 => '44',
            45 => '45',
            46 => '46',
            47 => '47',
            48 => '48',
            49 => '49',
            50 => '50',
            51 => '51',
            52 => '52',
            53 => '53',
            54 => '54',
            55 => '55',
            56 => '56',
            57 => '57',
            58 => '58',
            59 => '59',
        },
        Name => 'TicketCreateTimePoint',
        SelectedID => $Param{TicketCreateTimePoint},
    );
    $Param{'TicketCreateTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            'Last' => 'last',
            'Before' => 'before',
        },
        Name => 'TicketCreateTimePointStart',
        SelectedID => $Param{TicketCreateTimePointStart} || 'Last',
    );
    $Param{'TicketCreateTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            minute => 'minute(s)',
            hour => 'hour(s)',
            day => 'day(s)',
            week => 'week(s)',
            month => 'month(s)',
            year => 'year(s)',
        },
        Name => 'TicketCreateTimePointFormat',
        SelectedID => $Param{TicketCreateTimePointFormat},
    );
    $Param{TicketCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketCreateTimeStart',
        Format => 'DateInputFormat',
        DiffTime => -((60*60*24)*30),
    );
    $Param{TicketCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketCreateTimeStop',
        Format => 'DateInputFormat',
    );
    $Param{'DeleteOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'NewDelete',
        SelectedID => $Param{NewDelete},
    );
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Valid',
        SelectedID => defined($Param{Valid}) ? $Param{Valid} : 1,
    );
    $Param{'LockOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{LockObject}->LockList(
#            UserID => $Self->{UserID},
            UserID => 1,
            Action => $Self->{Action},
            ),
        },
        Name => 'LockIDs',
        Multiple => 1,
        Size => 3,
        LanguageTranslation => 0,
        SelectedIDRefArray => $Param{LockIDs},
    );
    $Param{'NewLockOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{LockObject}->LockList(
#            UserID => $Self->{UserID},
            UserID => 1,
            Action => $Self->{Action},
            ),
        },
        Name => 'NewLockID',
        Multiple => 1,
        Size => 3,
        LanguageTranslation => 0,
        SelectedID => $Param{NewLockID},
    );

    if ($Self->{Profile} && $Self->{Subaction} eq 'LoadProfile') {
        $Self->{LayoutObject}->Block(
            Name => 'Edit',
            Data => { %Param },
        );
    }
    # html search mask output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminGenericAgent',
        Data => \%Param,
    );
    return $Output;
}
# --

1;
