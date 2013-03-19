# --
# Kernel/Output/HTML/NotificationOutofOfficeCheck.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationOutofOfficeCheck;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TimeObject UserObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %UserData = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
    return '' if ( !$UserData{OutOfOffice} );

    my $Time = $Self->{TimeObject}->SystemTime();

    my $Start
        = "$UserData{OutOfOfficeStartYear}-$UserData{OutOfOfficeStartMonth}-$UserData{OutOfOfficeStartDay} 00:00:00";

    my $TimeStart = $Self->{TimeObject}->TimeStamp2SystemTime(
        String => $Start,
    );
    my $End
        = "$UserData{OutOfOfficeEndYear}-$UserData{OutOfOfficeEndMonth}-$UserData{OutOfOfficeEndDay} 23:59:59";
    my $TimeEnd = $Self->{TimeObject}->TimeStamp2SystemTime(
        String => $End,
    );
    if ( $TimeStart < $Time && $TimeEnd > $Time ) {
        return $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link     => '$Env{"Baselink"}Action=AgentPreferences',
            Data =>
                '$Text{"You have Out of Office enabled, would you like to disable it?"}',
        );
    }
    else {
        return '';
    }
}

1;
