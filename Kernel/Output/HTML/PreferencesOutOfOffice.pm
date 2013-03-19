# --
# Kernel/Output/HTML/PreferencesOutOfOffice.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesOutOfOffice;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params;
    if ( $Param{UserData}->{OutOfOffice} ) {
        $Param{OutOfOfficeOn} = 'checked="checked"';
    }
    else {
        $Param{OutOfOfficeOff} = 'checked="checked"';
    }
    $Param{OptionStart} = $Self->{LayoutObject}->BuildDateSelection(
        Format                 => 'DateInputFormat',
        Area                   => 'no',
        Prefix                 => 'OutOfOfficeStart',
        OutOfOfficeStartYear   => $Param{UserData}->{OutOfOfficeStartYear},
        OutOfOfficeStartMonth  => $Param{UserData}->{OutOfOfficeStartMonth},
        OutOfOfficeStartDay    => $Param{UserData}->{OutOfOfficeStartDay},
        OutOfOfficeStartHour   => 0,
        OutOfOfficeStartMinute => 0,
        YearPeriodPast         => 1,
        YearPeriodFuture       => 5,
        Validate               => 1,
    );
    $Param{OptionEnd} = $Self->{LayoutObject}->BuildDateSelection(
        Format               => 'DateInputFormat',
        Area                 => 'no',
        DiffTime             => 60 * 60 * 24 * 1,
        Prefix               => 'OutOfOfficeEnd',
        OutOfOfficeEndYear   => $Param{UserData}->{OutOfOfficeEndYear},
        OutOfOfficeEndMonth  => $Param{UserData}->{OutOfOfficeEndMonth},
        OutOfOfficeEndDay    => $Param{UserData}->{OutOfOfficeEndDay},
        OutOfOfficeEndHour   => 0,
        OutOfOfficeEndMinute => 0,
        YearPeriodPast       => 1,
        YearPeriodFuture     => 5,
        Validate             => 1,
    );

    push(
        @Params,
        {
            %Param,
            Block => 'OutOfOffice',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key (
        qw(OutOfOffice OutOfOfficeStartYear OutOfOfficeStartMonth OutOfOfficeStartDay OutOfOfficeEndYear OutOfOfficeEndMonth OutOfOfficeEndDay)
        )
    {

        $Param{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );

        if ( defined $Param{$Key} ) {

            # pref update db
            if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $Param{$Key},
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Self->{SessionObject}->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $Param{$Key},
                );
            }
        }
    }

    # also update the lastname to remove out of office message
    if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
        my %User = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserLastname',
            Value     => $User{UserLastname},
        );
    }

    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
