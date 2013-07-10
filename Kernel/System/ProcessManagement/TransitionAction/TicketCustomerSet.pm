# --
# Kernel/System/ProcessManagement/TransitionAction/TicketCustomerSet.pm - A Module to set the ticket customer
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

use utf8;

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet - A module to set a new ticket customer

=head1 SYNOPSIS

All TicketCustomerSet functions.

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
    use Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet;

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
    my $TicketCustomerSetActionObject = Kernel::System::ProcessManagement::TransitionAction::TicketCustomerSet->new(
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

    return $Self;
}

=item Run()

    Run Data

    my $TicketCustomerSetResult = $TicketCustomerSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',     # optional
        ActivityEntityID         => 'A123',     # optional
        TransitionEntityID       => 'T123',     # optional
        TransitionActionEntityID => 'TA123',    # optional
        Config                   => {
            CustomerID     => 'client123',
            # or
            CustomerUserID => 'client-user-123',

            #OR (Framework wording)
            No             => 'client123',
            # or
            User           => 'client-user-123',

            UserID => 123,                      # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketCustomerSetResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID Ticket Config)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # define a common message to output in case of any error
    my $CommonMessage;
    if ( $Param{ProcessEntityID} ) {
        $CommonMessage .= "Process: $Param{ProcessEntityID}";
    }
    if ( $Param{ActivityEntityID} ) {
        $CommonMessage .= " Activity: $Param{ActivityEntityID}";
    }
    if ( $Param{TransitionEntityID} ) {
        $CommonMessage .= " Transition: $Param{TransitionEntityID}";
    }
    if ( $Param{TransitionActionEntityID} ) {
        $CommonMessage .= " TransitionAction: $Param{TransitionActionEntityID}";
    }
    if ($CommonMessage) {

        # add a separator
        $CommonMessage .= " - ";
    }
    else {

        # otherwise at least define it to prevent errors
        $CommonMessage = '';
    }

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

    if (
        !$Param{Config}->{CustomerID}
        && !$Param{Config}->{No}
        && !$Param{Config}->{CustomerUserID}
        && !$Param{Config}->{User}
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No CustomerID/No or CustomerUserID/User configured!",
        );
        return;
    }

    if ( !$Param{Config}->{CustomerID} && $Param{Config}->{No} ) {
        $Param{Config}->{CustomerID} = $Param{Config}->{No};
    }
    if ( !$Param{Config}->{CustomerUserID} && $Param{Config}->{User} ) {
        $Param{Config}->{CustomerUserID} = $Param{Config}->{User};
    }

    if (
        defined $Param{Config}->{CustomerID}
        &&
        (
            !defined $Param{Ticket}->{CustomerID}
            || $Param{Config}->{CustomerID} ne $Param{Ticket}->{CustomerID}
        )
        )
    {
        my $Success = $Self->{TicketObject}->TicketCustomerSet(
            TicketID => $Param{Ticket}->{TicketID},
            No       => $Param{Config}->{CustomerID},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . 'Ticket CustomerID: '
                    . $Param{Config}->{CustomerID}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
            return;
        }
    }

    if (
        defined $Param{Config}->{CustomerUserID}
        &&
        (
            !defined $Param{Ticket}->{CustomerUserID}
            || $Param{Config}->{CustomerUserID} ne $Param{Ticket}->{CustomerUserID}
        )
        )
    {
        my $Success = $Self->{TicketObject}->TicketCustomerSet(
            TicketID => $Param{Ticket}->{TicketID},
            User     => $Param{Config}->{CustomerUserID},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . 'Ticket CustomerUserID: '
                    . $Param{Config}->{CustomerUserID}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
            return;
        }
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
