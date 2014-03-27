# --
# Kernel/System/EventHandler.pm - global object events
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: EventHandler.pm,v 1.7 2010-11-25 13:52:47 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::EventHandler;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::System::EventHandler - event handler lib

=head1 SYNOPSIS

All event handler functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item EventHandlerInit()

use vars qw(@ISA);
use Kernel::System::EventHandler;
push @ISA, 'Kernel::System::EventHandler';

    $Self->EventHandlerInit(

        # name of configured event modules
        Config     => 'Example::EventModule',

        # current object, $Self, used in events as "ExampleObject"
        BaseObject => 'ExampleObject',

        # served default objects in any event backend
        Objects    => {
            UserObject => $UserObject,
            XZY        => $XYZ,
        },
    );

e. g.

    $Self->EventHandlerInit(
        Config     => 'Ticket::EventModule',
        BaseObject => 'TicketObject',
        Objects    => {
            UserObject  => $UserObject,
            GroupObject => $GroupObject,
        },
    );

Example XML config:

    <ConfigItem Name="Example::EventModule###99-EscalationIndex" Required="0" Valid="1">
        <Description Lang="en">Example event module updates the example escalation index.</Description>
        <Description Lang="de">Example Event Modul aktualisiert den Example Eskalations-Index.</Description>
        <Group>Example</Group>
        <SubGroup>Core::Example</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Module">Kernel::System::Example::Event::ExampleEscalationIndex</Item>
                <Item Key="Event">(ExampleSLAUpdate|ExampleQueueUpdate|ExampleStateUpdate|ExampleCreate)</Item>
                <Item Key="SomeOption">Some Option accessable via $Param{Config}->{SomeOption} in Run() of event module.</Item>
                <Item Key="Transaction">(0|1)</Item>
            </Hash>
        </Setting>
    </ConfigItem>

=cut

=item EventHandlerInit()

use vars qw(@ISA);
use Kernel::System::EventHandler;
push @ISA, 'Kernel::System::EventHandler';

    $Self->EventHandlerInit(

        # name of configured event modules
        Config     => 'ITSM::EventModule',

        # current object, $Self, used in events as "ExampleObject"
        BaseObject => 'ExampleObject',

        # served default objects in any event backend
        Objects    => {
            UserObject => $UserObject,
            XYZ        => $XYZ,
        },
    );

e. g.

    $Self->EventHandlerInit(
        Config     => 'ITSM::EventModule',
        BaseObject => 'ChangeObject',
        Objects    => {},
    );

Example XML config:

    <ConfigItem Name="ITSM::EventModule###01-HistoryAdd" Required="0" Valid="1">
        <Description Lang="en">ITSM event module updates the history for Change and WorkOrder objects..</Description>
        <Description Lang="de">ITSM Event Modul aktualisiert die History von Change und WorkOrder Objekten.</Description>
        <Group>ITSM Change Management</Group>
        <SubGroup>Core::ITSMEvent</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Module">Kernel::System::ITSMChange::Event::HistoryAdd</Item>
                <Item Key="Event">(ChangeUpdate|WorkOrderUpdate|ChangeAdd|WorkOrderAdd)</Item>
                <Item Key="SomeOption">Some Option accessable via $Param{Config}->{SomeOption} in Run() of event module.</Item>
                <Item Key="Transaction">(0|1)</Item>
            </Hash>
        </Setting>
    </ConfigItem>
    <ConfigItem Name="ITSM::EventModule###02-HistoryAdd" Required="0" Valid="1">
        <Description Lang="en">ITSM event module updates the ConfigItem History.</Description>
        <Description Lang="de">ITSM Event Modul aktualisiert ConfigItem History.</Description>
        <Group>ITSM Configuration Management</Group>
        <SubGroup>Core::ITSMEvent</SubGroup>
        <Setting>
            <Hash>
                <Item Key="Module">Kernel::System::ITSMConfigurationManagement::Event::HistoryAdd</Item>
                <Item Key="Event">(ConfigItemUpdate|ConfigItemAdd)</Item>
                <Item Key="SomeOption">Some Option accessable via $Param{Config}->{SomeOption} in Run() of event module.</Item>
                <Item Key="Transaction">(0|1)</Item>
            </Hash>
        </Setting>
    </ConfigItem>

=cut

sub EventHandlerInit {
    my ( $Self, %Param ) = @_;

    $Self->{EventHandlerInit} = \%Param;

    return 1;
}

=item EventHandler()

call event handler, returns true if it's executed successfully

    $EventHandler->EventHandler(
        Event => 'TicketStateUpdate',
        Data  => {
            TicketID => 123,
        },
        UserID => 123,
    );

=cut

=item EventHandler()

call event handler, returns true if it's executed successfully

    $EventHandler->EventHandler(
        Event => 'ChangeUpdate',
        Data  => {
            ChangeID => 123,
        },
        UserID => 123,
    );

=cut

sub EventHandler {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get configured modules
    my $Modules = $Self->{ConfigObject}->Get( $Self->{EventHandlerInit}->{Config} );

    # return if there is no one
    return 1 if !$Modules;

    # remember events only on normal mode
    if ( !$Self->{EventHandlerTransaction} ) {
        push @{ $Self->{EventHandlerPipe} }, \%Param;
    }

    # load modules and execute
    MODULE:
    for my $Module ( sort keys %{$Modules} ) {

        # execute only if configured (regexp in Event of config is possible)
        if ( !$Modules->{$Module}->{Event} || $Param{Event} =~ /$Modules->{$Module}->{Event}/ ) {

            # next if we are not in transaction mode, but module is in transaction
            next MODULE if !$Param{Transaction} && $Modules->{$Module}->{Transaction};

            # next if we are in transaction mode, but module is not in transaction
            next MODULE if $Param{Transaction} && !$Modules->{$Module}->{Transaction};

            # load event module
            next MODULE if !$Self->{MainObject}->Require( $Modules->{$Module}->{Module} );

            # get all default objects if given
            my $ObjectRef = $Self->{EventHandlerInit}->{Objects};
            my %Objects;
            if ($ObjectRef) {
                %Objects = %{$ObjectRef};
            }

            # execute event backend
            my $Generic = $Modules->{$Module}->{Module}->new(
                %Objects,
                $Self->{EventHandlerInit}->{BaseObject} => $Self,
            );

            # compatable to old
            # OTRS 3.x: REMOVE ME
            if ( $Param{Data} ) {
                %Param = ( %Param, %{ $Param{Data} } );
            }

            $Generic->Run(
                %Param,
                Config => $Modules->{$Module},
            );
        }
    }

    return 1;
}

=item EventHandlerTransaction()

call all transaction backends for all triggered events till now

    $EventHandler->EventHandlerTransaction();

usually it's done in DESTROY of ExampleObject (e. g. Kernel::System::ExampleObject)

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
};

=cut

sub EventHandlerTransaction {
    my ( $Self, %Param ) = @_;

    # remember, we are in destroy mode, do not execute new events
    $Self->{EventHandlerTransaction} = 1;

    # execute events on end of transaction
    if ( $Self->{EventHandlerPipe} ) {
        for my $Params ( @{ $Self->{EventHandlerPipe} } ) {
            $Self->EventHandler(
                %Param,
                %{$Params},
                Transaction => 1,
            );
        }

        # delete event pipe
        $Self->{EventHandlerPipe} = undef;
    }

    # reset transaction mode
    $Self->{EventHandlerTransaction} = 0;

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

=head1 VERSION

$Revision: 1.7 $ $Date: 2010-11-25 13:52:47 $

=cut
