# --
# Kernel/System/ProcessManagement/TransitionAction/TicketLockSet.pm - A Module to unlock a ticket
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketLockSet;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

use utf8;

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketLockSet - A module to unlock a ticket

=head1 SYNOPSIS

All TicketLockSet functions.

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
    use Kernel::System::ProcessManagement::TransitionAction::TicketLockSet;

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
    my $TicketLockSetActionObject = Kernel::System::ProcessManagement::TransitionAction::TicketLockSet->new(
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

    $Self->{LockObject} = Kernel::System::Lock->new(
        %Param,
        DBObject   => $Self->{DBObject},
        MainObject => $Self->{MainObject},
        TimeObject => $Self->{TimeObject},
    );

    return $Self;
}

=item Run()

    Run Data

    my $TicketLockSetResult = $TicketLockSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            Lock  => 'lock',
            # or
            LockID => 1,
            UserID => 123,                      # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketLockSetResult = 1; # 0

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

    if ( !$Param{Config}->{LockID} && !$Param{Config}->{Lock} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No Lock or LockID configured!",
        );
        return;
    }

    my $Success;

    # If Ticket's LockID is already the same as the Value we
    # should set it to, we got nothing to do and return success
    if (
        defined $Param{Config}->{LoclID}
        && $Param{Config}->{LockID} eq $Param{Ticket}->{LockID}
        )
    {
        return 1;
    }

    # If Ticket's LockID is not the same as the Value we
    # should set it to, set the LockID
    elsif (
        defined $Param{Config}->{LockID}
        && $Param{Config}->{LockID} ne $Param{Ticket}->{LockID}
        )
    {
        $Success = $Self->{TicketObject}->TicketLockSet(
            TicketID => $Param{Ticket}->{TicketID},
            LockID   => $Param{Config}->{LockID},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . 'Ticket LockID '
                    . $Param{Config}->{LockID}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }

    # If Ticket's Lock is already the same as the Value we
    # should set it to, we got nothing to do and return success
    elsif (
        defined $Param{Config}->{Lock}
        && $Param{Config}->{Lock} eq $Param{Ticket}->{Lock}
        )
    {
        return 1;
    }

    # If Ticket's Lock is not the same as the Value we
    # should set it to, set the Lock
    elsif (
        defined $Param{Config}->{Lock}
        && $Param{Config}->{Lock} ne $Param{Ticket}->{Lock}
        )
    {
        $Success = $Self->{TicketObject}->TicketLockSet(
            TicketID => $Param{Ticket}->{TicketID},
            Lock     => $Param{Config}->{Lock},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . 'Ticket Lock '
                    . $Param{Config}->{Lock}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't update Ticket Lock - can't find valid Lock parameter!",
        );
        return;
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
