# --
# Kernel/System/Email/DoNotSendEmail.pm - modul dummy to send no emails
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DoNotSendEmail.pm,v 1.3 2009-02-16 11:48:19 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::DoNotSendEmail;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(ConfigObject LogObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # from
    if ( !defined $Param{From} ) {
        $Param{From} = '';
    }

    # recipient
    my $ToString = '';
    for my $To ( @{ $Param{ToArray} } ) {
        if ($ToString) {
            $ToString .= ", ";
        }
        $ToString .= $To;
    }

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent email to '$ToString' from '$Param{From}'.",
        );
    }

    return 1;
}

1;
