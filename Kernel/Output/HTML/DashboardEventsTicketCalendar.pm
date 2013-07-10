# --
# Kernel/Output/HTML/DashboardEventsTicketCalendar.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardEventsTicketCalendar;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::CustomerUser;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID QueueObject)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # create extra needed object
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # get dynamic fields list
    $Self->{DynamicFieldsList} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['Ticket'],
    );

    if ( !IsArrayRefWithData( $Self->{DynamicFieldsList} ) ) {
        $Self->{DynamicFieldsList} = [];
    }

    # create a dynamic field lookup table (by name)
    DYNAMICFIELD:
    for my $DynamicField ( @{ $Self->{DynamicFieldsList} } ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);
        next DYNAMICFIELD if !$DynamicField->{Name};
        $Self->{DynamicFieldLookup}->{ $DynamicField->{Name} } = $DynamicField;
    }

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Queues = $Self->{ConfigObject}->{DashboardEventsTicketCalendar}->{Queues};

    # get start and end time from config
    my $StartTimeDynamicField
        = $Self->{ConfigObject}->Get('DashboardEventsTicketCalendar::DynamicFieldStartTime')
        || 'TicketCalendarStartTime';
    my $EndTimeDynamicField =
        $Self->{ConfigObject}->Get('DashboardEventsTicketCalendar::DynamicFieldEndTime')
        || 'TicketCalendarEndTime';

    $Param{CalendarWidth} = $Self->{ConfigObject}->{DashboardEventsTicketCalendar}->{CalendarWidth};

    my %QueuesAll = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
    );

    my $EventTicketFields
        = $Self->{ConfigObject}->Get('DashboardEventsTicketCalendar::TicketFieldsForEvents');
    my $EventDynamicFields
        = $Self->{ConfigObject}->Get('DashboardEventsTicketCalendar::DynamicFieldsForEvents');

    my %DynamicFieldTimeSearch = (
        'DynamicField_' . $StartTimeDynamicField => {
            GreaterThanEquals => '1970-01-01 00:00:00',
        },
        'DynamicField_' . $EndTimeDynamicField => {
            GreaterThanEquals => '1970-01-01 00:00:00',
        },
    );

    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    my %QueuesConfigured;
    for my $Queue (@$Queues) {
        for my $QueueID ( sort keys %QueuesAll ) {
            if ( $QueuesAll{$QueueID} eq $Queue ) {
                $QueuesConfigured{$QueueID} = $QueuesAll{$QueueID};
            }
        }
    }
    my %Tickets = $Self->{TicketObject}->TicketSearch(
        SortBy => $Self->{ConfigObject}->{'SortBy::Default'} || 'Age',
        QueueIDs => [ sort keys %QueuesConfigured ],
        UserID   => $Self->{UserID},
        StateIDs => \@ViewableStateIDs,
        Result   => 'HASH',
        %DynamicFieldTimeSearch,
    );
    my @EventsDisplayed;

    my $Counter = 1;
    my $Limit   = scalar keys %Tickets;
    if (%Tickets) {
        for my $TicketID ( sort keys %Tickets ) {

            my %TicketDetail = $Self->{TicketObject}->TicketGet(
                TicketID      => $TicketID,
                DynamicFields => 1,
                UserID        => $Self->{UserID},
            );

            if (
                %TicketDetail &&
                $TicketDetail{ 'DynamicField_' . $StartTimeDynamicField } &&
                $TicketDetail{ 'DynamicField_' . $EndTimeDynamicField }
                )
            {

                my %Data;
                $Data{ID}    = $TicketID;
                $Data{Title} = $TicketDetail{Title};
                $TicketDetail{ 'DynamicField_' . $StartTimeDynamicField }
                    =~ /(\d+)\-(\d+)\-(\d+)\ (\d+)\:(\d+)\:(\d+)/;
                $Data{SYear}   = $1;
                $Data{SMonth}  = $2 - 1;
                $Data{SDay}    = $3;
                $Data{SHour}   = $4;
                $Data{SMinute} = $5;
                $Data{SSecond} = $6;
                $TicketDetail{ 'DynamicField_' . $EndTimeDynamicField }
                    =~ /(\d+)\-(\d+)\-(\d+)\ (\d+)\:(\d+)\:(\d+)/;
                $Data{EYear}     = $1;
                $Data{EMonth}    = $2 - 1;
                $Data{EDay}      = $3;
                $Data{EHour}     = $4;
                $Data{EMinute}   = $5;
                $Data{ESecond}   = $6;
                $Data{Color}     = $Self->{TicketColors}->{$TicketID};
                $Data{AllDay}    = 'false';
                $Data{Url}       = "index.pl?Action=AgentTicketZoom;TicketID=$TicketID";
                $Data{QueueName} = $QueuesAll{ $TicketDetail{QueueID} };
                $Data{QueueName} =~ s/.*[\:]([^\:]+)$/$1/;
                $Data{Description} = "";

                $Self->{LayoutObject}->Block(
                    Name => 'CalendarEvent',
                    Data => \%Data,
                );

                if ( $Counter < $Limit ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'CalendarEventComma',
                    );
                }

                # add ticket info container
                $Self->{LayoutObject}->Block(
                    Name => 'EventInfo',
                    Data => \%Data,
                );

                # add ticket field for the event
                if ( IsHashRefWithData($EventTicketFields) ) {

                    # include dynamic fields container
                    $Self->{LayoutObject}->Block(
                        Name => 'EventTicketFieldContainer',
                        Data => \%Data,
                    );

                    # include dynamic fields
                    TICKETFIELD:
                    for my $Key ( sort keys %{$EventTicketFields} ) {

                        next TICKETFIELD if !$Key;
                        next TICKETFIELD if !$EventTicketFields->{$Key};

                        if ( $Key eq 'CustomerUserID' && $TicketDetail{$Key} ) {
                            $TicketDetail{$Key} = $Self->{CustomerUserObject}->CustomerName(
                                UserLogin => $TicketDetail{$Key},
                            );
                        }

                        $Self->{LayoutObject}->Block(
                            Name => 'CalendarEventInfoTicketFieldElement',
                            Data => {
                                InfoLabel => $EventTicketFields->{$Key},
                                InfoValue => $TicketDetail{$Key},
                            },
                        );
                    }
                }

                # add dynamic field for the event
                if ( IsArrayRefWithData($EventDynamicFields) ) {

                    # include dynamic fields container
                    $Self->{LayoutObject}->Block(
                        Name => 'EventDynamicFieldContainer',
                        Data => \%Data,
                    );

                    # include dynamic fields
                    DYNAMICFIELD:
                    for my $Item ( @{$EventDynamicFields} ) {

                        next DYNAMICFIELD if !$Item;
                        next DYNAMICFIELD if !$Self->{DynamicFieldLookup}->{$Item}->{Label};

                        $Self->{LayoutObject}->Block(
                            Name => 'CalendarEventInfoDynamicFieldElement',
                            Data => {
                                InfoLabel => $Self->{DynamicFieldLookup}->{$Item}->{Label},
                                InfoValue => $TicketDetail{ 'DynamicField_' . $Item },
                            },
                        );
                    }
                }

                $Counter++;
            }
            else {
                $Limit-- if ( $Limit > 0 );
            }
        }
    }
    if ( $Counter < $Limit ) {
        $Self->{LayoutObject}->Block(
            Name => 'CalendarEventComma',
        );
    }

    $Self->{LayoutObject}->Block(
        Name => 'CalendarDiv',
        Data => {
            CalendarWidth => $Self->{ConfigObject}->{DashboardEventsTicketCalendar}->{CalendarWidth}
                || 95,
            }
    );

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'DashboardEventsTicketCalendar',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    return $Content;
}

1;
