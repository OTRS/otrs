# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::SysConfigCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::State',
    'Kernel::System::SysConfig',
    'Kernel::System::Type',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateArticleData -  Create entries in new article table for OmniChannel base infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %EntityData = $Self->_EntitySettingsGet();

    my %Queues = $Kernel::OM->Get('Kernel::System::Queue')->QueueList(
        Valid => 1,
    );
    my @QueuesAllowed = values %Queues;

    my %Priorities = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
        Valid => 1,
    );
    my @PrioritiesAllowed = values %Priorities;

    my %States = $Kernel::OM->Get('Kernel::System::State')->StateList(
        UserID => 1,
        Valid  => 1,
    );
    my @StatesAllowed = values %States;

    my %Types = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
        Valid => 1,
    );
    my @TypesAllowed = values %Types;

    my @InconsistentSettings;

    for my $Entity ( sort keys %EntityData ) {

        my @AllowedEffectiveValues;

        if ( $Entity eq 'Queue' ) {
            @AllowedEffectiveValues = @QueuesAllowed;
        }
        elsif ( $Entity eq 'Priority' ) {
            @AllowedEffectiveValues = @PrioritiesAllowed;
        }
        elsif ( $Entity eq 'State' ) {
            @AllowedEffectiveValues = @StatesAllowed;
        }
        elsif ( $Entity eq 'Type' ) {
            @AllowedEffectiveValues = @TypesAllowed;
        }

        SETTING:
        for my $SettingName ( @{ $EntityData{$Entity} } ) {

            # Get setting old value.
            my $OldEffectiveValue = $Self->_EffectiveValueGet(
                SettingName => $SettingName,
            );

            next SETTING if !defined $OldEffectiveValue;

            if ( !grep { $_ eq $OldEffectiveValue } @AllowedEffectiveValues ) {
                push @InconsistentSettings, $SettingName;
            }
        }
    }

    # Check if there are invalid settings.
    my @InvalidSettings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationInvalidList();

    for my $SettingName (@InvalidSettings) {

        # Add it to the list only if setting is not there already.
        if ( !grep { $_ eq $SettingName } @InconsistentSettings ) {
            push @InconsistentSettings, $SettingName;
        }
    }

    if (@InconsistentSettings) {
        print "\n\n    Inconsistent SysConfig settings detected, please update them manually:\n";
        print "\n    " . join "\n    ", @InconsistentSettings;
    }

    return 1;
}

sub _EffectiveValueGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(SettingName)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Split setting name (###).
    my @Name = split '###', $Param{SettingName};

    my $OldEffectiveValue;

    for my $NamePart (@Name) {
        if ( defined $OldEffectiveValue ) {
            if ( defined $OldEffectiveValue->{$NamePart} ) {
                $OldEffectiveValue = $OldEffectiveValue->{$NamePart};
            }
            else {
                # Old configuration doesn't contain modified value for this setting.
                return;
            }
        }
        else {
            $OldEffectiveValue = $ConfigObject->Get($NamePart);
            return $OldEffectiveValue if !defined $OldEffectiveValue;
        }
    }

    return $OldEffectiveValue
}

sub _EntitySettingsGet {
    my ( $Self, %Param ) = @_;

    my %Result = (
        DynamicField => [

            # Framework

        ],
        Queue => [

            # Framework
            'Ticket::Frontend::CustomerTicketMessage###QueueDefault',
            'PostmasterDefaultQueue',
            'Process::DefaultQueue',
        ],
        Priority => [

            # Framework
            'Process::DefaultPriority',
            'Ticket::Frontend::AgentTicketFreeText###PriorityDefault',
            'Ticket::Frontend::AgentTicketPhone###Priority',
            'Ticket::Frontend::AgentTicketEmail###Priority',
            'Ticket::Frontend::AgentTicketClose###PriorityDefault',
            'Ticket::Frontend::AgentTicketNote###PriorityDefault',
            'Ticket::Frontend::AgentTicketOwner###PriorityDefault',
            'Ticket::Frontend::AgentTicketPending###PriorityDefault',
            'Ticket::Frontend::AgentTicketPriority###PriorityDefault',
            'Ticket::Frontend::AgentTicketResponsible###PriorityDefault',
            'Ticket::Frontend::AgentTicketBulk###PriorityDefault',
            'Ticket::Frontend::CustomerTicketMessage###PriorityDefault',
            'Ticket::Frontend::CustomerTicketZoom###PriorityDefault',
            'PostmasterDefaultPriority',

            # OTRSBusiness
            'Ticket::Frontend::AgentTicketSMS###Priority',

            # OTRSMasterSlave
            'Ticket::Frontend::AgentTicketMasterSlave###PriorityDefault',
        ],
        State => [

            # Framework
            'Process::DefaultState',
            'Ticket::Frontend::AgentTicketFreeText###StateDefault',
            'Ticket::Frontend::AgentTicketPhoneOutbound###State',
            'Ticket::Frontend::AgentTicketPhoneInbound###State',
            'Ticket::Frontend::AgentTicketPhone###StateDefault',
            'Ticket::Frontend::AgentTicketEmail###StateDefault',
            'Ticket::Frontend::AgentTicketClose###StateDefault',
            'Ticket::Frontend::AgentTicketNote###StateDefault',
            'Ticket::Frontend::AgentTicketOwner###StateDefault',
            'Ticket::Frontend::AgentTicketPending###StateDefault',
            'Ticket::Frontend::AgentTicketPriority###StateDefault',
            'Ticket::Frontend::AgentTicketResponsible###StateDefault',
            'Ticket::Frontend::AgentTicketBulk###StateDefault',
            'Ticket::Frontend::AgentTicketBounce###StateDefault',
            'Ticket::Frontend::AgentTicketCompose###StateDefault',
            'Ticket::Frontend::AgentTicketForward###StateDefault',
            'Ticket::Frontend::AgentTicketEmailOutbound###StateDefault',
            'Ticket::Frontend::CustomerTicketMessage###StateDefault',
            'Ticket::Frontend::CustomerTicketZoom###StateDefault',
            'PostmasterDefaultState',
            'PostmasterFollowUpState',
            'PostmasterFollowUpStateClosed',

            # OTRSBusiness
            'Ticket::Frontend::AgentTicketSMSOutbound###StateDefault',
            'Ticket::Frontend::AgentTicketSMS###StateDefault',

            # OTRSMasterSlave
            'Ticket::Frontend::AgentTicketMasterSlave###StateDefault',
        ],
        Type => [

            # Framework
            'Ticket::Type::Default',
            'Ticket::Frontend::CustomerTicketMessage###TicketTypeDefault',
        ],
    );

    return %Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
