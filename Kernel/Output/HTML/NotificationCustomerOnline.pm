# --
# Kernel/Output/HTML/NotificationCustomerOnline.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationCustomerOnline.pm,v 1.8 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationCustomerOnline;

use strict;
use warnings;

use Kernel::System::AuthSession;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TimeObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{SessionObject} = Kernel::System::AuthSession->new(%Param);
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get session info
    my %Online      = ();
    my @Sessions    = $Self->{SessionObject}->GetAllSessionIDs();
    my $IdleMinutes = $Param{Config}->{IdleMinutes} || 60 * 2;
    for (@Sessions) {
        my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $_, );
        if (
            $Data{UserType} eq 'Customer'
            && $Data{UserLastRequest}
            && $Data{UserLastRequest} + ( $IdleMinutes * 60 ) > $Self->{TimeObject}->SystemTime()
            && $Data{UserFirstname}
            && $Data{UserLastname}
            )
        {
            $Online{ $Data{UserID} } = "$Data{UserFirstname} $Data{UserLastname}";
            if ( $Param{Config}->{ShowEmail} ) {
                $Online{ $Data{UserID} } .= " ($Data{UserEmail})";
            }
        }
    }
    for ( sort { $Online{$a} cmp $Online{$b} } keys %Online ) {
        if ( $Param{Message} ) {
            $Param{Message} .= ', ';
        }
        $Param{Message} .= "$Online{$_}";
    }
    if ( $Param{Message} ) {
        return $Self->{LayoutObject}->Notify( Info => 'Online Customer: %s", "' . $Param{Message} );
    }
    else {
        return '';
    }
}

1;
