# --
# Kernel/Output/HTML/TicketMenuResponsible.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketMenuResponsible.pm,v 1.2 2006-08-27 22:29:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::TicketMenuResponsible;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Ticket}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Ticket!");
        return;
    }

    if ($Self->{ConfigObject}->Get('Ticket::Responsible') && !defined($Param{ACL}->{$Param{Config}->{Action}}) || $Param{ACL}->{$Param{Config}->{Action}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Menu',
            Data => { },
        );
        if ($Param{Counter}) {
            $Self->{LayoutObject}->Block(
                Name => 'MenuItemSplit',
                Data => { },
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'MenuItem',
            Data => {
                %{$Param{Config}},
                %{$Param{Ticket}},
                %Param,
            },
        );
        $Param{Counter}++;
    }

    return $Param{Counter};
}

1;
