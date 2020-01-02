# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::EventsTicketCalendar;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    # get dynamic fields list
    my $DynamicFieldsList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['Ticket'],
    );

    if ( !IsArrayRefWithData($DynamicFieldsList) ) {
        $DynamicFieldsList = [];
    }

    # create a dynamic field lookup table (by name)
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldsList} ) {
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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Queues = $ConfigObject->{DashboardEventsTicketCalendar}->{Queues};

    # get start and end time from config
    my $StartTimeDynamicField = $ConfigObject->Get('DashboardEventsTicketCalendar::DynamicFieldStartTime')
        || 'TicketCalendarStartTime';
    my $EndTimeDynamicField =
        $ConfigObject->Get('DashboardEventsTicketCalendar::DynamicFieldEndTime')
        || 'TicketCalendarEndTime';

    $Param{CalendarWidth} = $ConfigObject->{DashboardEventsTicketCalendar}->{CalendarWidth};

    my %QueuesAll = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues(
        UserID => $Self->{UserID},
    );

    my $EventTicketFields  = $ConfigObject->Get('DashboardEventsTicketCalendar::TicketFieldsForEvents');
    my $EventDynamicFields = $ConfigObject->Get('DashboardEventsTicketCalendar::DynamicFieldsForEvents');

    my %DynamicFieldTimeSearch = (
        'DynamicField_' . $StartTimeDynamicField => {
            GreaterThanEquals => '1970-01-01 00:00:00',
        },
        'DynamicField_' . $EndTimeDynamicField => {
            GreaterThanEquals => '1970-01-01 00:00:00',
        },
    );

    my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    my %QueuesConfigured;
    for my $Queue ( @{$Queues} ) {
        for my $QueueID ( sort keys %QueuesAll ) {
            if ( $QueuesAll{$QueueID} eq $Queue ) {
                $QueuesConfigured{$QueueID} = $QueuesAll{$QueueID};
            }
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Tickets;
    if (%QueuesConfigured) {
        %Tickets = $TicketObject->TicketSearch(
            SortBy   => $ConfigObject->{'SortBy::Default'} || 'Age',
            QueueIDs => [ sort keys %QueuesConfigured ],
            UserID   => $Self->{UserID},
            StateIDs => \@ViewableStateIDs,
            Result   => 'HASH',
            %DynamicFieldTimeSearch,
        );
    }

    my @EventsDisplayed;

    my $Counter = 1;
    my $Limit   = scalar keys %Tickets;

    # get needed objects
    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $UserObject            = $Kernel::OM->Get('Kernel::System::User');
    my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    my $Content;

    if (%Tickets) {
        TICKET:
        for my $TicketID ( sort keys %Tickets ) {

            my %TicketDetail = $TicketObject->TicketGet(
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

                # end time should be greater than start time
                my $StartTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $TicketDetail{ 'DynamicField_' . $StartTimeDynamicField }
                    },
                );

                my $EndTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $TicketDetail{ 'DynamicField_' . $EndTimeDynamicField }
                    },
                );

                # check if start time is after end time
                if ( $StartTimeObject > $EndTimeObject ) {

                    # turn start and end time around for the calendar view
                    my $NewStartTimeObject = $EndTimeObject;
                    my $NewEndTimeObject   = $StartTimeObject;
                    $StartTimeObject = $NewStartTimeObject;
                    $EndTimeObject   = $NewEndTimeObject;

                   # we also need to turn the time in the tooltip around, otherwiese the time bar display would be wrong
                    $TicketDetail{ 'DynamicField_' . $StartTimeDynamicField } = $StartTimeObject->ToString();
                    $TicketDetail{ 'DynamicField_' . $EndTimeDynamicField }   = $EndTimeObject->ToString();

                    # show a notification bar to indicate that the start and end time are set in a wrong way
                    $Content .= $LayoutObject->Notify(
                        Priority => 'Warning',
                        Info     => Translatable('The start time of a ticket has been set after the end time!'),
                        Link     => "index.pl?Action=AgentTicketZoom;TicketID=$TicketID",
                    );
                }

                my %Data;

                # set start/end time individual units
                # ex: SYear; EMinute
                my $SetDataDateTimeUnits = sub {
                    my ( $Type, $Details ) = @_;

                    my $Prefix = substr( $Type, 0, 1 );
                    for my $Unit (qw(Year Month Day Hour Minute Second)) {
                        my $Value = $Details->{$Unit};
                        if ( $Unit eq 'Month' ) {
                            $Value -= 1;
                        }

                        $Data{"${Prefix}${Unit}"} = $Value;
                    }

                    return;
                };

                $SetDataDateTimeUnits->( Start => $StartTimeObject->Get() );
                $SetDataDateTimeUnits->( End   => $EndTimeObject->Get() );
                #

                $Data{ID}        = $TicketID;
                $Data{Title}     = $TicketDetail{Title};
                $Data{Color}     = $Self->{TicketColors}->{$TicketID};
                $Data{AllDay}    = 'false';
                $Data{Url}       = "index.pl?Action=AgentTicketZoom;TicketID=$TicketID";
                $Data{QueueName} = $QueuesAll{ $TicketDetail{QueueID} };
                $Data{QueueName} =~ s/.*[\:]([^\:]+)$/$1/;
                $Data{Description} = "";

                # add 1 second to end date as workaround
                # for a bug on full calendar when start and end
                # dates are exactly the same (ESecond is 00 normally)
                $Data{ESecond}++;

                push @{ $Self->{EventsTicketCalendar} }, \%Data;

                # add ticket info container
                $LayoutObject->Block(
                    Name => 'EventInfo',
                    Data => \%Data,
                );

                # define container for dynamic fields
                my @EventTicketDynamicFields;

                # add ticket field for the event
                if ( IsHashRefWithData($EventTicketFields) ) {

                    # include dynamic fields container
                    $LayoutObject->Block(
                        Name => 'EventTicketFieldContainer',
                        Data => \%Data,
                    );

                    # include dynamic fields
                    TICKETFIELD:
                    for my $Key ( sort keys %{$EventTicketFields} ) {

                        next TICKETFIELD if !$Key;
                        next TICKETFIELD if !$EventTicketFields->{$Key};

                        # skip dynamic fields, will them added later
                        if ( $Key =~ m{\A DynamicField_(.*) \z}msx ) {
                            my $DynamicFieldName = $Key;
                            $DynamicFieldName =~ s{\A DynamicField_ }{}msxg;
                            push @EventTicketDynamicFields, $DynamicFieldName;
                            next TICKETFIELD;
                        }

                        if ( $Key eq 'CustomerName' && $TicketDetail{CustomerUserID} ) {
                            $TicketDetail{$Key} = $CustomerUserObject->CustomerName(
                                UserLogin => $TicketDetail{CustomerUserID},
                            );
                        }

                        if ( $Key eq 'CustomerCompanyName' && $TicketDetail{CustomerID} ) {
                            my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
                                CustomerID => $TicketDetail{CustomerID},
                            );
                            $TicketDetail{$Key} = $CustomerCompany{$Key};
                        }

                        if ( ( $Key eq 'Owner' || $Key eq 'Responsible' ) && $TicketDetail{$Key} ) {
                            my %UserData = $UserObject->GetUserData(
                                User => $TicketDetail{$Key},
                            );
                            $TicketDetail{$Key} = $UserData{UserFullname};
                        }

                        # translate state and priority name
                        if ( ( $Key eq 'State' || $Key eq 'Priority' ) && $TicketDetail{$Key} ) {
                            $TicketDetail{$Key} = $LayoutObject->{LanguageObject}->Translate( $TicketDetail{$Key} );
                        }

                        $LayoutObject->Block(
                            Name => 'CalendarEventInfoTicketFieldElement',
                            Data => {
                                InfoLabel => $EventTicketFields->{$Key},
                                InfoValue => $TicketDetail{$Key},
                            },
                        );
                    }
                }

                # merge event ticket dynamic fields
                my $DynamicFieldsForEvent = [ @{$EventDynamicFields}, @EventTicketDynamicFields ];

                # add dynamic field for the event
                if ( IsArrayRefWithData($DynamicFieldsForEvent) ) {

                    # include dynamic fields container
                    $LayoutObject->Block(
                        Name => 'EventDynamicFieldContainer',
                        Data => \%Data,
                    );

                    # include dynamic fields
                    DYNAMICFIELD:
                    for my $Item ( @{$DynamicFieldsForEvent} ) {

                        next DYNAMICFIELD if !$Item;
                        next DYNAMICFIELD if !$Self->{DynamicFieldLookup}->{$Item}->{Label};

                        # check if we need to format the date
                        my $DisplayValue
                            = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->DisplayValueRender(
                            DynamicFieldConfig => $Self->{DynamicFieldLookup}->{$Item},
                            Value              => $TicketDetail{ 'DynamicField_' . $Item },
                            LayoutObject       => $LayoutObject,
                            );

                        $LayoutObject->Block(
                            Name => 'CalendarEventInfoDynamicFieldElement',
                            Data => {
                                InfoLabel => $Self->{DynamicFieldLookup}->{$Item}->{Label},
                                InfoValue => $DisplayValue->{Value},
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

    $LayoutObject->Block(
        Name => 'CalendarDiv',
        Data => {
            CalendarWidth => $ConfigObject->{DashboardEventsTicketCalendar}->{CalendarWidth}
                || 95,
        }
    );

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'EventsTicketCalendar',
        Value => $Self->{EventsTicketCalendar},
    );
    $LayoutObject->AddJSData(
        Key   => 'FirstDay',
        Value => $ConfigObject->Get('CalendarWeekDayStart') || 0,
    );

    $Content .= $LayoutObject->Output(
        TemplateFile => 'DashboardEventsTicketCalendar',
        Data         => {},
    );

    return $Content;
}

1;
