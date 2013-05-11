# --
# Kernel/System/ProcessManagement/TransitionAction/TicketStateSet.pm - A Module to set the ticket state
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketStateSet;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

use utf8;
use Kernel::System::State;

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketStateSet - A module to set the ticket state

=head1 SYNOPSIS

All TicketStateSet functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Ticket;
    use Kernel::System::ProcessManagement::TransitionAction::TicketStateSet;

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
    my $TicketObject = Kernel::System::Ticket->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );
    my $TicketStateSetActionObject = Kernel::System::ProcessManagement::TransitionAction::TicketStateSet->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        EncodeObject       => $EncodeObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        TicketObject       => $TicketObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject LogObject EncodeObject DBObject MainObject TimeObject TicketObject)
        )
    {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{StateObject} = Kernel::System::State->new(
        %Param,
        DBObject   => $Self->{DBObject},
        MainObject => $Self->{MainObject},
        TimeObject => $Self->{TimeObject},
    );

    return $Self;
}

=item Run()

    Run Data

    my $TicketStateSetResult = $TicketStateSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            State   => 'open',
            # or
            StateID => 3,

            PendingTimeDiff => 123,             # optional, used for pending states, difference in seconds from
                                                #   current time to desired penting time (e.g. a value of 3600 means
                                                #   that the pending time will be 1hr after the Transition Action is
                                                #   executed)
            UserID  => 123,                     # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketStateSetResult = 1; # 0

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (
        qw(UserID Ticket ProcessEntityID ActivityEntityID TransitionEntityID
            TransitionActionEntityID Config
            )
            )
        {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        ." Transition: $Param{TransitionEntityID}"
        ." TransitionAction: $Param{TransitionActionEntityID} - ";

    # Check if we have Ticket to deal with
    if ( !IsHashRefWithData( $Param{Ticket} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage . "Ticket has no values!",
        );
        return;
    }

    # Check if we have a ConfigHash
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage . "Config has no values!",
        );
        return;
    }

    # override UserID if specified as a parameter in the TA config
    if ( IsNumber( $Param{Config}->{UserID} ) ) {
        $Param{UserID} = $Param{Config}->{UserID};
        delete $Param{Config}->{UserID};
    }

    if ( !$Param{Config}->{StateID} && !$Param{Config}->{State} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No State or StateID configured!",
        );
        return;
    }

    my $Success;
    my %StateData;

    # If Ticket's StateID is already the same as the Value we
    # should set it to, we got nothing to do and return success
    if (
        defined $Param{Config}->{StateID}
        && $Param{Config}->{StateID} eq $Param{Ticket}->{StateID}
        )
    {
        return 1;
    }

    # If Ticket's StateID is not the same as the Value we
    # should set it to, set the StateID
    elsif (
        defined $Param{Config}->{StateID}
        && $Param{Config}->{StateID} ne $Param{Ticket}->{StateID}
        )
    {
        %StateData = $Self->{StateObject}->StateGet(
            ID => $Param{Config}->{StateID},
        );
        $Success = $Self->{TicketObject}->TicketStateSet(
            TicketID => $Param{Ticket}->{TicketID},
            StateID  => $Param{Config}->{StateID},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . 'Ticket StateID '
                    . $Param{Config}->{StateID}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }

    # If Ticket's State is already the same as the Value we
    # should set it to, we got nothing to do and return success
    elsif (
        defined $Param{Config}->{State}
        && $Param{Config}->{State} eq $Param{Ticket}->{State}
        )
    {
        return 1;
    }

    # If Ticket's State is not the same as the Value we
    # should set it to, set the State
    elsif (
        defined $Param{Config}->{State}
        && $Param{Config}->{State} ne $Param{Ticket}->{State}
        )
    {
        %StateData = $Self->{StateObject}->StateGet(
            Name => $Param{Config}->{State},
        );
        $Success = $Self->{TicketObject}->TicketStateSet(
            TicketID => $Param{Ticket}->{TicketID},
            State    => $Param{Config}->{State},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . 'Ticket State '
                    . $Param{Config}->{State}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't update Ticket State - can't find valid State parameter!",
        );
        return;
    }

    # set pending time
    if (
        $Success
        && IsHashRefWithData( \%StateData )
        && $StateData{TypeName} =~ m{\A pending}msxi
        && IsNumber( $Param{Config}->{PendingTimeDiff} )
        )
    {

        # get current time
        my $PendingTime = $Self->{TimeObject}->SystemTime();

        # add PendingTimeDiff
        $PendingTime += $Param{Config}->{PendingTimeDiff};

        # convert pending time to time stamp
        my $PendingTimeString = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $PendingTime,
        );

        # set pending time
        $Self->{TicketObject}->TicketPendingTimeSet(
            UserID   => $Param{UserID},
            TicketID => $Param{Ticket}->{TicketID},
            String   => $PendingTimeString,
        );
    }

    return $Success;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
