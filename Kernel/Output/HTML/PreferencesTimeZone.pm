# --
# Kernel/Output/HTML/PreferencesTimeZone.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PreferencesTimeZone.pm,v 1.12 2009-02-20 12:05:39 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesTimeZone;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if !$Self->{$_};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    return if !$Self->{ConfigObject}->Get('TimeZoneUser');
    return if $Self->{ConfigObject}->Get('TimeZoneUserBrowserAutoOffset');
    return
        if $Self->{ConfigObject}->Get('TimeZoneUserBrowserAutoOffset')
            && !$Self->{LayoutObject}->{BrowserJavaScriptSupport};

    my @Params = ();
    push(
        @Params,
        {
            %Param,
            Name => $Self->{ConfigItem}->{PrefKey},
            Data => {
                '0'   => '+ 0',
                '+1'  => '+ 1',
                '+2'  => '+ 2',
                '+3'  => '+ 3',
                '+4'  => '+ 4',
                '+5'  => '+ 5',
                '+6'  => '+ 6',
                '+7'  => '+ 7',
                '+8'  => '+ 8',
                '+9'  => '+ 9',
                '+10' => '+10',
                '+11' => '+11',
                '+12' => '+12',
                '-1'  => '- 1',
                '-2'  => '- 2',
                '-3'  => '- 3',
                '-4'  => '- 4',
                '-5'  => '- 5',
                '-6'  => '- 6',
                '-7'  => '- 7',
                '-8'  => '- 8',
                '-9'  => '- 9',
                '-10' => '-10',
                '-11' => '-11',
                '-12' => '-12',
            },
            SelectedID => $Self->{ParamObject}->GetParam( Param => 'UserTimeZone' )
                || $Param{UserData}->{UserTimeZone}
                || '0',
            Block => 'Option',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for (@Array) {

            # pref update db
            if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $_,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Self->{SessionObject}->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $_,
                );
            }
        }
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
