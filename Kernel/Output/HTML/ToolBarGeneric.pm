# --
# Kernel/Output/HTML/ToolBarGeneric.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarGeneric;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID UserObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Priority = $Param{Config}->{'Priority'};
    my %Return   = ();

    # check if there is extended data available
    my %Data;
    if ($Param{Config}->{Data} && %{$Param{Config}->{Data}}) {
        %Data = %{$Param{Config}->{Data}};
    }

    $Return{ $Priority++ } = {
        Block       => $Param{Config}->{Block},
        Description => $Param{Config}->{Description},
        Name        => $Param{Config}->{Name},
        Size        => $Param{Config}->{Size},
        Fulltext    => '',
        Image       => '',
        AccessKey   => '',
        %Data,
    };
    return %Return;
}

1;
