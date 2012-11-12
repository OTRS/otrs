# --
# Kernel/System/ProcessManagement/TransitionAction/StateSet.pm - A Module to set the ticket state
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: StateSet.pm,v 1.2 2012-11-12 11:42:16 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::StateSet;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

use utf8;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::StateSet - A module to set the ticket state

=head1 SYNOPSIS

All StateSet functions.

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
    use Kernel::System::ProcessManagement::TransitionAction::StateSet;

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
    my $StateSetActionObject = Kernel::System::ProcessManagement::TransitionAction::StateSet->new(
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

    my $StateSetResult = $StateSetActionObject->Run(
        UserID      => 123,
        Ticket      => \%Ticket, # required
        Config      => {
            State  => 'open',
            # or
            StateID => 3,

            #OR (DynamicField state mapping)
            DynamicField        => 'MasterSlave', # or DynamicField_MasterSlave
            DynamicFieldMapping => {
                Master           => {
                    State => 'open'
                }
                # or
                Master           => {
                    StateID => 3
                }
            },
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $StateSetResult = 1; # 0

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

    if (
        !$Param{Config}->{StateID}
        && !$Param{Config}->{State}
        &&
        (
            !$Param{Config}->{DynamicField}
            && !IsHashRefWithData( $Param{Config}->{DynamicFieldMapping} )
        )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No StateID/State or DynamicField and DynamicFieldMapping configured!",
        );
        return;
    }

    my $Success;

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
        $Success = $Self->{TicketObject}->TicketStateSet(
            TicketID => $Param{Ticket}->{TicketID},
            StateID  => $Param{Config}->{StateID},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Ticket StateID '
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
        $Success = $Self->{TicketObject}->TicketStateSet(
            TicketID => $Param{Ticket}->{TicketID},
            State    => $Param{Config}->{State},
            UserID   => $Param{UserID},
        );

        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Ticket State '
                    . $Param{Config}->{State}
                    . ' could not be updated for Ticket: '
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
    }
    elsif (
        defined $Param{Config}->{DynamicField}
        && IsHashRefWithData( $Param{Config}->{DynamicFieldMapping} )
        )
    {

        # check if the configured DynamicField is defined/has a value
        my $DynamicFieldValue = $Param{Ticket}->{ 'DynamicField_' . $Param{Config}->{DynamicField} }
            || $Param{Ticket}->{ $Param{Config}->{DynamicField} }
            || undef;

        # if the DynamicFieldValue is missing we got nothing to do
        if ( !$DynamicFieldValue ) {
            return 1;
        }

        # if the DynamicFieldValue isn't in our mapping we got nothing to do
        if ( !$Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue} ) {
            return 1;
        }

        # If we have the DynamicFieldValue in our Config but the the Value of that key isn't a hash
        # or doesn't contain StateID or State as hashkeys
        # we have a defective config and have to alert
        if (
            !IsHashRefWithData( $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue} )
            || (
                !$Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{StateID}
                && !$Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{State}
            )
            )
        {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Config error in StateSet ActionConfig: ' .
                    'Need Hash as Value inside DynamicFieldMappings->DynamicFieldValue: ' .
                    $DynamicFieldValue .
                    ' and State or StateID as Hashkeys inside that hash!',
            );
            return;
        }

        # If Ticket's State is already the same as the value we should set it to,
        # or StateID is already the same as the value we should set it to,
        # we got nothing to do and return success
        if (
            (
                $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{State}
                &&
                $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{State} eq
                $Param{Ticket}->{State}
            )
            ||
            (
                $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{StateID}
                &&
                $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{StateID} eq
                $Param{Ticket}->{StateID}
            )
            )
        {
            return 1;
        }

        if ( $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{State} ) {

            my %State = $Self->{StateObject}->StateGet(
                Name => $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{State}
            );

            if (%State) {
                $Success = $Self->{TicketObject}->TicketStateSet(
                    TicketID => $Param{Ticket}->{TicketID},
                    StateID  => $State{ID},
                    UserID   => $Param{UserID},
                );

                if ($Success) {
                    return 1;
                }
                else {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => 'Ticket State '
                            . $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{State}
                            . ' could not be updated for Ticket: '
                            . $Param{Ticket}->{TicketID} . '!',
                    );
                    return;
                }
            }

            # if we didn't find the state return 0
            # State object will error out that it didn't find what we were looking for
            else {
                return;
            }
        }
        elsif ( $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{StateID} ) {

            my %State = $Self->{StateObject}->StateGet(
                ID => $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{StateID}
            );

            if (%State) {
                $Success = $Self->{TicketObject}->TicketStateSet(
                    TicketID => $Param{Ticket}->{TicketID},
                    StateID  => $State{ID},
                    UserID   => $Param{UserID},
                );

                if ($Success) {
                    return 1;
                }
                else {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => 'Ticket StateID '
                            . $Param{Config}->{DynamicFieldMapping}->{$DynamicFieldValue}->{StateID}
                            . ' could not be updated for Ticket: '
                            . $Param{Ticket}->{TicketID} . '!',
                    );
                    return;
                }
            }

            # if we didn't find the state return 0
            # State object will error out that it didn't find what we were looking for
            else {
                return;
            }
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Couldn't update Ticket State - can't find valid State parameter!",
            );
            return;
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Couldn't update Ticket State - can't find valid State parameter!",
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

=head1 VERSION

$Revision: 1.2 $ $Date: 2012-11-12 11:42:16 $

=cut
