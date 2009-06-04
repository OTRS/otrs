# --
# Kernel/Modules/AgentDashboard.pm - a global dashbard
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentDashboard.pm,v 1.1 2009-06-04 23:42:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentDashboard;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # load backends
    my $Config = $Self->{ConfigObject}->Get('DashboardBackend');
    if ( !$Config ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No such config for Dashboard',
        );
    }

    # update settings
    if ( $Self->{Subaction} eq 'Update' ) {

        my @Backends = $Self->{ParamObject}->GetArray( Param => 'Backend' );
        my $Data = '';
        for my $Backend (@Backends) {
            $Data .= $Backend . ';';
        }

        # update ssession
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'AgentDashboardBackend',
            Value     => $Data,
        );

        # update preferences
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => 'AgentDashboardBackend',
            Value  => $Data,
        );

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$Self->{Action}"
        );
    }

    # show dashboard
    $Self->{LayoutObject}->Block(
        Name => 'Content',
        Data => { },
    );

    # load settings
    my %Backends;
    if ( $Self->{AgentDashboardBackend} ) {
        my @Backend = split /;/, $Self->{AgentDashboardBackend};
        for my $Key (@Backend) {
            $Backends{$Key} = 1;
        }
    }
    else {
        for my $Name ( sort keys %{$Config} ) {
            next if !$Config->{$Name}->{Default};
            $Backends{$Name} = 1;
        }
    }

    # try every backend
    for my $Name ( sort keys %{$Config} ) {

        # add backend to settings selection
        my $Checked = '';
        if ( $Backends{$Name} ) {
            $Checked = 'checked';
        }
        $Self->{LayoutObject}->Block(
            Name => 'ContentSettings',
            Data => {
                %{ $Config->{$Name} },
                Name    => $Name,
                Checked => $Checked,
            },
        );
        next if !$Backends{$Name};

        # execute backends
        my $Module = $Config->{$Name}->{Module};
        next if !$Self->{MainObject}->Require($Module);
        my $Object = $Module->new(
            %{$Self},
            Config => $Config->{$Name},
        );
        $Object->Run();
    }

    # get output back
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboard',
        Data         => \%Param
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
