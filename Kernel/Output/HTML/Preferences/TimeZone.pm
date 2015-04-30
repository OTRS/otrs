# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::TimeZone;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Web::Request',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw( UserID UserObject ConfigItem)) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return if !$ConfigObject->Get('TimeZoneUser');
    return if $ConfigObject->Get('TimeZoneUserBrowserAutoOffset');
    return
        if $ConfigObject->Get('TimeZoneUserBrowserAutoOffset')
        && !$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{BrowserJavaScriptSupport};

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
            SelectedID => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'UserTimeZone' )
                || $Param{UserData}->{UserTimeZone}
                || '0',
            Block => 'Option',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for (@Array) {

            # pref update db
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $_,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
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
