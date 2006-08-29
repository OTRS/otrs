# --
# Kernel/System/Ticket/Event/TicketFreeFieldDefault.pm - a event module for default ticket free text settings
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketFreeFieldDefault.pm,v 1.2 2006-08-29 17:25:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Event::TicketFreeFieldDefault;
use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID Event Config UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $ConfigSettings = $Self->{ConfigObject}->Get('Ticket::TicketFreeFieldDefault');
    foreach (keys %{$ConfigSettings}) {
        my $Element = $ConfigSettings->{$_};
        if ($Param{Event} eq $Element->{Event}) {
            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
            # do some stuff
            $Self->{TicketObject}->TicketFreeTextSet(
                Counter  => $Element->{Counter},
                Key      => $Element->{Key},
                Value    => $Element->{Value},
                TicketID => $Param{TicketID},
                UserID   => $Param{UserID},
            );
        }
    }
}
# --
1;
