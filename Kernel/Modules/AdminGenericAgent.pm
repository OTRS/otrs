# --
# Kernel/Modules/AdminGenericAgent.pm - admin generic agent interface
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminGenericAgent.pm,v 1.28 2006-06-22 14:07:55 tr Exp $
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
$VERSION = '$Revision: 1.28 $';
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

    $Self->{PriorityObject}     = Kernel::System::Priority->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{LockObject}         = Kernel::System::Lock->new(%Param);
    $Self->{GenericAgentObject} = Kernel::System::GenericAgent->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self   = shift;
    my %Param  = @_;
    my $Output = '';
    # get confid data
    $Self->{Profile}    = $Self->{ParamObject}->GetParam(Param => 'Profile')    || '';
    $Self->{OldProfile} = $Self->{ParamObject}->GetParam(Param => 'OldProfile') || '';
    $Self->{Subaction}  = $Self->{ParamObject}->GetParam(Param => 'Subaction')  || '';

    # ---------------------------------------------------------- #
    # run a generic agent job -> "run now"
    # ---------------------------------------------------------- #

    if ($Self->{Subaction} eq 'RunNow') {
        $Self->{GenericAgentObject}->JobRun(
            Job => $Self->{Profile},
            UserID => 1,
        );
        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}",
        );
    }

    # ---------------------------------------------------------- #
    # add a new generic agent job
    # ---------------------------------------------------------- #

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
            OP => "Action=$Self->{Action}&Subaction=Update&Profile=$Self->{Profile}",
        );
    }

    # --------------------------------------------------------------- #
    # save generic agent job and show a view of all affected tickets
    # --------------------------------------------------------------- #

    # show result site
    if ($Self->{Subaction} eq 'UpdateAction') {
        # fill up profile name (e.g. with last-search)
        if (!$Self->{Profile}) {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(Message => 'Need Job Name!');
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # get single params
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
            NewLockID NewDelete NewCMD NewSendNoNotification
            ScheduleLastRun Valid
            NewTicketFreeKey1 NewTicketFreeText1 NewTicketFreeKey2 NewTicketFreeText2
            NewTicketFreeKey3 NewTicketFreeText3 NewTicketFreeKey4 NewTicketFreeText4
            NewTicketFreeKey5 NewTicketFreeText5 NewTicketFreeKey6 NewTicketFreeText6
            NewTicketFreeKey7 NewTicketFreeText7 NewTicketFreeKey8 NewTicketFreeText8
            NewTicketFreeKey9 NewTicketFreeText9 NewTicketFreeKey10 NewTicketFreeText10
            NewTicketFreeKey11 NewTicketFreeText11 NewTicketFreeKey12 NewTicketFreeText12
            NewTicketFreeKey13 NewTicketFreeText13 NewTicketFreeKey14 NewTicketFreeText14
            NewTicketFreeKey15 NewTicketFreeText15 NewTicketFreeKey16 NewTicketFreeText16
        )) {

            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
            # remove white space on the end
            if ($GetParam{$_}) {
                $GetParam{$_} =~ s/\s+$//g;
                $GetParam{$_} =~ s/^\s+//g;
            }
        }

        # get array params
        foreach (qw(LockIDs StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
            ScheduleDays ScheduleMinutes ScheduleHours
            TicketFreeKey1 TicketFreeText1 TicketFreeKey2 TicketFreeText2
            TicketFreeKey3 TicketFreeText3 TicketFreeKey4 TicketFreeText4
            TicketFreeKey5 TicketFreeText5 TicketFreeKey6 TicketFreeText6
            TicketFreeKey7 TicketFreeText7 TicketFreeKey8 TicketFreeText8
            TicketFreeKey9 TicketFreeText9 TicketFreeKey10 TicketFreeText10
            TicketFreeKey11 TicketFreeText11 TicketFreeKey12 TicketFreeText12
            TicketFreeKey13 TicketFreeText13 TicketFreeKey14 TicketFreeText14
            TicketFreeKey15 TicketFreeText15 TicketFreeKey16 TicketFreeText16
        )) {
            # get search array params (get submitted params)
            if ($Self->{ParamObject}->GetArray(Param => $_)) {
                @{$GetParam{$_}} = $Self->{ParamObject}->GetArray(Param => $_);
            }
        }

        # remove/clean up old profile stuff
        $Self->{GenericAgentObject}->JobDelete(Name => $Self->{OldProfile});
        # insert new profile params
        $Self->{GenericAgentObject}->JobAdd(Name => $Self->{Profile}, Data => \%GetParam);

        # get time settings
        if (!$GetParam{TimeSearchType}) {
            # do noting on time stuff
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
            Result  => 'ARRAY',
            SortBy  => 'Age',
            OrderBy => 'Down',
            UserID  => 1,
            %GetParam,
        );
        if ($GetParam{NewDelete}) {
            $Param{DeleteMessage} = 'You use the DELETE option! Take care, all deleted Tickets are lost!!!';
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
        if ($ViewableIDs[0]) {
            $Self->{LayoutObject}->Block(
                Name => 'ResultBlock',
            );
            foreach (0..$#ViewableIDs) {
                # get first article data
                my %Data = $Self->{TicketObject}->ArticleFirstArticle(TicketID => $ViewableIDs[$_]);
                $Data{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Data{Age}, Space => ' ');
                $Data{css} = "PriorityID-$Data{PriorityID}";
                # user info
                my %UserInfo = $Self->{UserObject}->GetUserData(
                    User => $Data{Owner},
                    Cached => 1
                );
                $Data{UserLastname}  = $UserInfo{UserLastname};
                $Data{UserFirstname} = $UserInfo{UserFirstname};

                $Self->{LayoutObject}->Block(
                    Name => 'Ticket',
                    Data => \%Data,
                );
                # just show 25 tickts
                if ($_ > 25) {
                    last;
                }
            }
        }
        # html search mask output
        $Output  = $Self->{LayoutObject}->Header(Title => "Affected Tickets");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # actually not useful because of the admin module link field
        #if ($Param{DeleteMessage}) {
        #    $Output .= $Self->{LayoutObject}->Notify(
        #        Info => $Param{DeleteMessage},
        #        Priority => 'Warning',
        #    );
        #}
        #if ($Param{Message}) {
        #    $Output .= $Self->{LayoutObject}->Notify(
        #        Info => $Param{Message},
        #        Priority => 'Warning',
        #    );
        #}

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data => \%Param,
        );
        # build footer
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # edit generic agent job
    # ---------------------------------------------------------- #
    if ($Self->{Subaction} eq 'Update' && $Self->{Profile}) {
        # get db job data
        my %Param = $Self->{GenericAgentObject}->JobGet(Name => $Self->{Profile});
        $Param{Profile} = $Self->{Profile};
        my %ShownUsers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        $Param{'OwnerStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data     => \%ShownUsers,
            Name     => 'OwnerIDs',
            Multiple => 1,
            Size     => 5,
            SelectedIDRefArray => $Param{OwnerIDs},
        );
        $Param{'NewOwnerStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%ShownUsers,
            Name       => 'NewOwnerID',
            Size       => 5,
            SelectedID => $Param{NewOwnerID},
        );
        my %Hours = ();
        foreach (0..23) {
            $Hours{$_} = sprintf("%02d", $_);
        }
        $Param{'ScheduleHours'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data     => \%Hours,
            Name     => 'ScheduleHours',
            Size     => 6,
            Multiple => 1,
            SelectedIDRefArray => $Param{ScheduleHours},
        );
        $Param{'ScheduleMinutes'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                '00' => '00',
                10 => '10',
                20 => '20',
                30 => '30',
                40 => '40',
                50 => '50',
            },
            Name     => 'ScheduleMinutes',
            Size     => 6,
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
            SortBy   => 'Key',
            Name     => 'ScheduleDays',
            Size     => 6,
            Multiple => 1,
            SelectedIDRefArray => $Param{ScheduleDays},
        );

        $Param{'StatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{StateObject}->StateList(
                UserID => 1,
                Action => $Self->{Action},
                ),
            },
            Name     => 'StateIDs',
            Multiple => 1,
            Size     => 5,
            SelectedIDRefArray => $Param{StateIDs},
        );
        $Param{'NewStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{StateObject}->StateList(
                UserID => 1,
                Action => $Self->{Action},
                )
            },
            Name     => 'NewStateID',
            Size     => 5,
            SelectedID => $Param{NewStateID},
        );
        $Param{'QueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => { $Self->{QueueObject}->GetAllQueues(),},
            Size     => 5,
            Multiple => 1,
            Name     => 'QueueIDs',
            SelectedIDRefArray => $Param{QueueIDs},
            OnChangeSubmit => 0,
        );
        $Param{'NewQueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => { $Self->{QueueObject}->GetAllQueues(),},
            Size => 5,
            Name => 'NewQueueID',
            SelectedID => $Param{NewQueueID},
            OnChangeSubmit => 0,
        );
        $Param{'PriotitiesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{PriorityObject}->PriorityList(
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
                UserID => 1,
                Action => $Self->{Action},
                ),
            },
            Name => 'NewPriorityID',
            Size => 5,
            SelectedID => $Param{NewPriorityID},
        );

        # get time option
        if (!$Param{TimeSearchType}) {
            $Param{'TimeSearchType::None'} = 'checked';
        }
        elsif ($Param{TimeSearchType} eq 'TimePoint') {
            $Param{'TimeSearchType::TimePoint'} = 'checked';
        }
        elsif ($Param{TimeSearchType} eq 'TimeSlot') {
            $Param{'TimeSearchType::TimeSlot'} = 'checked';
        }

        my %Counter = ();
        foreach (1..60) {
            $Counter{$_} = sprintf("%02d", $_);
        }
        $Param{'TicketCreateTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%Counter,
            Name       => 'TicketCreateTimePoint',
            SelectedID => $Param{TicketCreateTimePoint},
        );
        $Param{'TicketCreateTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => {
                'Last'   => 'last',
                'Before' => 'before',
            },
            Name => 'TicketCreateTimePointStart',
            SelectedID => $Param{TicketCreateTimePointStart} || 'Last',
        );
        $Param{'TicketCreateTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
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
                UserID => 1,
                Action => $Self->{Action},
                ),
            },
            Name => 'LockIDs',
            Multiple => 1,
            Size => 3,
            LanguageTranslation => 1,
            SelectedIDRefArray => $Param{LockIDs},
        );
        $Param{'NewLockOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { $Self->{LockObject}->LockList(
                UserID => 1,
                Action => $Self->{Action},
                ),
            },
            Name => 'NewLockID',
            Size => 3,
            LanguageTranslation => 0,
            SelectedID => $Param{NewLockID},
        );

        $Param{'SendNoNotificationOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name => 'NewSendNoNotification',
            SelectedID => $Param{NewSendNoNotification} || 0,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Edit',
            Data => \%Param,
        );

        # Free field settings
        my $Flag = 1;
        foreach my $ID (1..16) {
            if (ref($Self->{ConfigObject}->Get('TicketFreeKey' . $ID)) eq 'HASH') {
                # $Flag to shcw the hole freefield block
                if ($Flag) {
                    $Self->{LayoutObject}->Block(
                        Name => 'TicketFreeField',
                    );
                    $Flag = 0;
                }

                # generate free key
                my %TicketFreeKey = %{$Self->{ConfigObject}->Get('TicketFreeKey' . $ID)};
                my @FreeKey = keys %TicketFreeKey;
                my $TicketFreeKey  = '';

                if ($#FreeKey == 0) {
                    $TicketFreeKey = $TicketFreeKey{$FreeKey[0]};
                }
                else {
                    $TicketFreeKey = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data => \%TicketFreeKey,
                        Name => 'TicketFreeKey' . $ID,
                        Size => 4,
                        Multiple => 1,
                        LanguageTranslation => 0,
                        SelectedIDRefArray => $Param{'TicketFreeKey' . $ID},
                    );
                }

                # generate free text
                my $TicketFreeText  = '';
                if (!$Self->{ConfigObject}->Get('TicketFreeText' . $ID)) {
                    $TicketFreeText = '<input type="text" name="TicketFreeText' . $ID . '" size="30" value="' . $Param{'TicketFreeText' . $ID}[0] . '">';
                }
                else {
                    my %TicketFreeText = %{$Self->{ConfigObject}->Get('TicketFreeText' . $ID)};
                    if (!$TicketFreeText{''}) {
                        $TicketFreeText{''} = '';
                    }

                    $TicketFreeText = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data => \%TicketFreeText,
                        Name => 'TicketFreeText' . $ID,
                        Size => 4,
                        Multiple => 1,
                        LanguageTranslation => 0,
                        SelectedIDRefArray => $Param{'TicketFreeText' . $ID},
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
        foreach my $ID (1..16) {
            if (ref($Self->{ConfigObject}->Get('TicketFreeKey' . $ID)) eq 'HASH') {

                # $Falg to shcw the hole freefield block
                if ($Flag) {
                    $Self->{LayoutObject}->Block(
                        Name => 'NewTicketFreeField',
                    );
                    $Flag = 0;
                }

                # generate free key
                my %TicketFreeKey = %{$Self->{ConfigObject}->Get('TicketFreeKey' . $ID)};
                my @FreeKey = keys %TicketFreeKey;
                my $NewTicketFreeKey  = '';

                if ($#FreeKey == 0) {
                    $NewTicketFreeKey = $TicketFreeKey{$FreeKey[0]};
                }
                else {
                    $NewTicketFreeKey = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data => \%TicketFreeKey,
                        Name => 'NewTicketFreeKey' . $ID,
                        Size => 4,
                        LanguageTranslation => 0,
                        SelectedID => $Param{'NewTicketFreeKey' . $ID},
                    );
                }

                # generate free text
                my $NewTicketFreeText  = '';
                if (!$Self->{ConfigObject}->Get('TicketFreeText' . $ID)) {
                    $NewTicketFreeText = '<input type="text" name="NewTicketFreeText' . $ID . '" size="30" value="' . $Param{'NewTicketFreeText' . $ID} . '">';
                }
                else {
                    my %TicketFreeText = %{$Self->{ConfigObject}->Get('TicketFreeText' . $ID)};
                    if (!$TicketFreeText{''}) {
                        $TicketFreeText{''} = '';
                    }

                    $NewTicketFreeText = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data => \%TicketFreeText,
                        Name => 'NewTicketFreeText' . $ID,
                        Size => 4,
                        LanguageTranslation => 0,
                        SelectedID => $Param{'NewTicketFreeText' . $ID},
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
        my $Output = $Self->{LayoutObject}->Header(Title => "Edit");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGenericAgent',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # delete an generic agent job
    # ---------------------------------------------------------- #

    if ($Self->{Subaction} eq 'Delete' && $Self->{Profile}) {
        if ($Self->{Profile}) {
            $Self->{GenericAgentObject}->JobDelete(Name => $Self->{Profile});
        }
    }

    # ---------------------------------------------------------- #
    # overview of all generic agent jobs
    # ---------------------------------------------------------- #

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
    );

    my %Jobs = $Self->{GenericAgentObject}->JobList();
    my $Counter = 1;
    foreach (sort keys %Jobs) {
        my %JobData = $Self->{GenericAgentObject}->JobGet(Name => $_);

        # css setting and text for valid or invalid jobs
        if ($JobData{Valid}) {
            $JobData{ShownValid} = "valid";
            $JobData{cssValid}   = "";
        }
        else {
            $JobData{ShownValid} = "invalid";
            $JobData{cssValid}   = "contentvaluepassiv";

        }

        # seperate each searchresult line by using several css
        $Counter++;
        if ($Counter % 2) {
            $JobData{css}        = "searchpassive";
        }
        else {
            $JobData{css}        = "searchactive";
        }


        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => { %JobData },
        );
    }

    # generate search mask
    $Output = $Self->{LayoutObject}->Header(Title => "Overview");
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
    TemplateFile => 'AdminGenericAgent',
    Data => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
