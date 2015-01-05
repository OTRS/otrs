# --
# Kernel/Output/HTML/DashboardMOTD.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: DashboardMOTD.pm,v 1.1 2009-09-21 13:15:50 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardMOTD;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
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

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'Motd',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    return $Content;
}

1;
