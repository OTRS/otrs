# --
# Kernel/Output/HTML/DashboardImage.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardImage.pm,v 1.4 2009-06-12 22:03:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardImage;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardImage',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    $Self->{LayoutObject}->Block(
        Name => $Self->{Config}->{Block},
        Data => {
            %{ $Self->{Config} },
            Name    => $Self->{Name},
            Content => $Content,
        },
    );

    if ( $Self->{Config}->{Link} ) {
        $Self->{LayoutObject}->Block(
            Name => $Self->{Config}->{Block} . 'More',
            Data => {
                %{ $Self->{Config} },
                Name    => $Self->{Name},
            },
        );
    }

    return 1;
}

1;
