# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::CmdOutput;

use strict;
use warnings;

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

    # command to run
    my $Cmd = $Self->{Config}->{Cmd};

    my $CmdOutput = qx{$Cmd 2>&1};

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$CmdOutput );

    my $Content = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'AgentDashboardCmdOutput',
        Data         => {
            CmdOutput => $CmdOutput,
            %{ $Self->{Config} },
        },
    );

    return $Content;
}

1;
