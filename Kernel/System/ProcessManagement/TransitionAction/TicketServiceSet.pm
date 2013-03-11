# --
# Kernel/System/ProcessManagement/TransitionAction/TicketServiceSet.pm - A Module to set the ticket service
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketServiceSet;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

use utf8;
use Kernel::System::Service;

use vars qw($VERSION);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketServiceSet - A module to set the ticket Service

=head1 SYNOPSIS

All TicketServiceSet functions.

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
    use Kernel::System::ProcessManagement::TransitionAction::TicketServiceSet;

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
    my $TicketServiceSetActionObject
        = Kernel::System::ProcessManagement::TransitionAction::TicketServiceSet->new(
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

    $Self->{ServiceObject} = Kernel::System::Service->new(
        %Param,
        DBObject   => $Self->{DBObject},
        MainObject => $Self->{MainObject},
        TimeObject => $Self->{TimeObject},
    );

    return $Self;
}

=item Run()

    Run Data

    my $TicketServiceSetResult = $TicketServiceSetActionObject->Run(
        UserID      => 123,
        Ticket      => \%Ticket, # required
        Config      => {
            Service => 'MyService::Subservice',
            # or
            ServiceID => 123,
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketServiceSetResult = 1; # 0

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

    # Check if we have Ticket to deal with
    if ( !IsHashRefWithData( $Param{Ticket} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Ticket has no values!",
        );
        return;
    }

    # Check if we have a ConfigHash
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Config has no values!",
        );
        return;
    }

    if ( !$Param{Config}->{ServiceID} && !$Param{Config}->{Service} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Service or ServiceID configured!",
        );
        return;
    }

    if ( !$Param{Ticket}->{CustomerUserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "To set a service the ticket requires a customer!",
        );
        return;
    }

    my $Success;

    # If Ticket's ServiceID is already the same as the Value we
    # should set it to, we got nothing to do and return success
    if (
        defined $Param{Config}->{ServiceID}
        && defined $Param{Ticket}->{ServiceID}
        && $Param{Config}->{ServiceID} eq $Param{Ticket}->{ServiceID}
        )
    {
        return 1;
    }

    # If Ticket's ServiceID is not the same as the Value we
    # should set it to, set the ServiceID
    elsif (
        (
            defined $Param{Config}->{ServiceID}
            && defined $Param{Ticket}->{ServiceID}
            && $Param{Config}->{ServiceID} ne $Param{Ticket}->{ServiceID}
        )
        || !defined $Param{Ticket}->{ServiceID}
        )
    {

        # check if serivce is assigned to Customer User otherwise return
        $Success = $Self->_CheckService(
            UserLogin => $Param{Ticket}->{CustomerUserID},
            ServiceID => $Param{Config}->{ServiceID}
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'ServiceID '
                    . $Param{Config}->{ServiceID}
                    . ' is not assigned to Customer User '
                    . $Param{Ticket}->{CustomerUserID}
            );
            return;
        }

        # set ticket service
        $Success = $Self->{TicketObject}->TicketServiceSet(
            TicketID  => $Param{Ticket}->{TicketID},
            ServiceID => $Param{Config}->{ServiceID},
            UserID    => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Ticket ServiceID '
                    . $Param{Config}->{ServiceID}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }

    # If Ticket's Service is already the same as the Value we
    # should set it to, we got nothing to do and return success
    elsif (
        defined $Param{Config}->{Service}
        && defined $Param{Ticket}->{Service}
        && $Param{Config}->{Service} eq $Param{Ticket}->{Service}
        )
    {
        return 1;
    }

    # If Ticket's Service is not the same as the Value we
    # should set it to, set the Service
    elsif (
        (
            defined $Param{Config}->{Service}
            && defined $Param{Ticket}->{Service}
            && $Param{Config}->{Service} ne $Param{Ticket}->{Service}
        )
        || !defined $Param{Ticket}->{Service}

        )
    {

        my $ServiceID = $Self->{ServiceObject}->ServiceLookup(
            Name => $Param{Config}->{Service},
        );

        if ( !$ServiceID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Service '
                    . $Param{Config}->{Service}
                    . ' is invalid!'
            );
            return;
        }

        # check if service is assigned to Customer User, otherwise return
        $Success = $Self->_CheckService(
            UserLogin => $Param{Ticket}->{CustomerUserID},
            ServiceID => $ServiceID,
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Service '
                    . $Param{Config}->{Service}
                    . ' is not assigned to Customer User '
                    . $Param{Ticket}->{CustomerUserID}
            );
            return;
        }

        # set ticket service
        $Success = $Self->{TicketObject}->TicketServiceSet(
            TicketID => $Param{Ticket}->{TicketID},
            Service  => $Param{Config}->{Service},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Ticket Service '
                    . $Param{Config}->{Service}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Couldn't update Ticket Service - can't find valid Service parameter!",
        );
        return;
    }

    return $Success;
}

=item _CheckService()

checks if a service is assigned to a customer user

    my $Success = _CheckService(
        UserLogin => 'some user',
        ServiceID => 123,
    );

    Returns:

    $Success = 1;       # or undef
=cut

sub _CheckService {
    my ( $Self, %Param ) = @_;

    # get a list of assigned services to the customer user
    my %Services = $Self->{ServiceObject}->CustomerUserServiceMemberList(
        CustomerUserLogin => $Param{UserLogin},
        Result            => 'HASH',
        DefaultServices   => 1,
    );

    # return failure if there are no assigned services for this customer user
    return if !IsHashRefWithData( \%Services );

    # return failure if the the service is not assigned to the customer
    return if !$Services{ $Param{ServiceID} };

    # otherwise return success
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
