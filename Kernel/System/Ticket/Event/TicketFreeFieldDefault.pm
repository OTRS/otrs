# --
# Kernel/System/Ticket/Event/TicketFreeFieldDefault.pm - a event module for default ticket free text settings
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: TicketFreeFieldDefault.pm,v 1.11 2010-11-04 10:03:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketFreeFieldDefault;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    my $ConfigSettings = $Self->{ConfigObject}->Get('Ticket::TicketFreeFieldDefault');
    for ( keys %{$ConfigSettings} ) {
        my $Element = $ConfigSettings->{$_};
        if ( $Param{Event} eq $Element->{Event} ) {
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{Data}->{TicketID} );

            # do not set default free text if already set
            next if $Ticket{ 'TicketFreeText' . $Element->{Counter} };

            # do some stuff
            $Self->{TicketObject}->TicketFreeTextSet(
                Counter  => $Element->{Counter},
                Key      => $Element->{Key},
                Value    => $Element->{Value},
                TicketID => $Param{Data}->{TicketID},
                UserID   => $Param{UserID},
            );
        }
    }
    return 1;
}

1;
