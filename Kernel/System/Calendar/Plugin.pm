# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Plugin;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::LinkObject',
);

=head1 NAME

Kernel::System::Calendar::Plugin - Plugin lib

=head1 DESCRIPTION

Abstraction layer for appointment plugins.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TeamObject = $Kernel::OM->Get('Kernel::System::Calendar::Plugin');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get registered plugin modules
    my $PluginConfig = $Kernel::OM->Get('Kernel::Config')->Get("AppointmentCalendar::Plugin");

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # load plugin modules
    PLUGIN:
    for my $PluginKey ( sort keys %{$PluginConfig} ) {

        my $GenericModule = $PluginConfig->{$PluginKey}->{Module};
        next PLUGIN if !$GenericModule;

        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load plugin module $GenericModule! $@");
        }

        $Self->{Plugins}->{$PluginKey}->{PluginName}   = $PluginConfig->{$PluginKey}->{Name} // $GenericModule;
        $Self->{Plugins}->{$PluginKey}->{PluginModule} = $GenericModule->new( %{$Self} );

        my $PluginURL = $PluginConfig->{$PluginKey}->{URL};
        $PluginURL =~ s{<OTRS_CONFIG_(.+?)>}{$Kernel::OM->Get('Kernel::Config')->Get($1)}egx;
        $Self->{Plugins}->{$PluginKey}->{PluginURL} = $PluginURL;
    }

    return $Self;
}

=head2 PluginList()

returns the hash of registered plugins

    my $PluginList = $PluginObject->PluginList();

=cut

sub PluginList {
    my ( $Self, %Param ) = @_;

    my %PluginList = map {
        $_ => {
            PluginName => $Self->{Plugins}->{$_}->{PluginName},
            PluginURL  => $Self->{Plugins}->{$_}->{PluginURL},
        }
    } keys %{ $Self->{Plugins} };

    return \%PluginList;
}

=head2 PluginKeys()

returns the hash of proper plugin keys for lowercase matching

    my $PluginKeys = $PluginObject->PluginKeys();

=cut

sub PluginKeys {
    my ( $Self, %Param ) = @_;

    my %PluginKeys = map {
        lc $_ => $_
    } keys %{ $Self->{Plugins} };

    return \%PluginKeys;
}

=head2 PluginLinkAdd()

link appointment by plugin

    my $Success = $PluginObject->PluginLinkAdd(
        AppointmentID => 1,
        PluginKey     => '0100-Ticket',
        PluginData    => '42',
        UserID        => 1,
    );

=cut

sub PluginLinkAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID PluginKey PluginData UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    my $Success = $Self->{Plugins}->{ $Param{PluginKey} }->{PluginModule}->LinkAdd(
        %Param,
    );

    return $Success;
}

=head2 PluginLinkList()

returns list of links for supplied appointment

    my $LinkList = $PluginObject->PluginLinkList(
        AppointmentID => 1,
        PluginKey     => '0100-Ticket',
        UserID        => 1,
    );

=cut

sub PluginLinkList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID PluginKey UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{PluginURL} = $Self->{Plugins}->{ $Param{PluginKey} }->{PluginURL};

    my $LinkList = $Self->{Plugins}->{ $Param{PluginKey} }->{PluginModule}->LinkList(%Param);

    return $LinkList;
}

=head2 PluginLinkDelete()

removes all links for an appointment

    my $Success = $PluginObject->PluginLinkDelete(
        AppointmentID => 1,
        UserID        => 1,
    );

=cut

sub PluginLinkDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(AppointmentID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Success = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkDeleteAll(
        Object => 'Appointment',
        Key    => $Param{AppointmentID},
        UserID => $Param{UserID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Unable to delete plugin links!",
        );
    }

    return $Success;
}

=head2 PluginSearch()

search for plugin objects

    my $ResultList = $PluginObject->PluginSearch(
        PluginKey => $PluginKey,        # (required)

        Search    => $Search,           # (required) Search string
                                        # or
        ObjectID  => $ObjectID          # (required) Object ID

        UserID    => $Self->{UserID},   # (required)
    );

=cut

sub PluginSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PluginKey UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    if ( !$Param{Search} && !$Param{ObjectID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need either Search or ObjectID!',
        );
        return;
    }

    my $ResultList = $Self->{Plugins}->{ $Param{PluginKey} }->{PluginModule}->Search(
        %Param,
    );

    return $ResultList;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
