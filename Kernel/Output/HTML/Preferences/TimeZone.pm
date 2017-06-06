# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::TimeZone;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw( UserID UserObject ConfigItem )) {
        die "Got no $Needed!" if !$Self->{$Needed};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my $PreferencesKey      = $Self->{ConfigItem}->{PrefKey};
    my $UserDefaultTimeZone = Kernel::System::DateTime->UserDefaultTimeZoneGet();
    my $TimeZones           = Kernel::System::DateTime->TimeZoneList();
    my %TimeZones           = map { $_ => $_ } sort @{$TimeZones};
    my $SelectedTimeZone    = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $PreferencesKey )
        || $Param{UserData}->{$PreferencesKey}
        || $UserDefaultTimeZone;

    my @Params = ();
    push(
        @Params,
        {
            %Param,
            Name       => $PreferencesKey,
            Data       => \%TimeZones,
            Block      => 'Option',
            SelectedID => $SelectedTimeZone,
        },
    );

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        for my $Value ( @{ $Param{GetParam}->{$Key} } ) {

            # pref update db
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $Value,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $Value,
                );
            }
        }
    }

    $Self->{Message} = Translatable('Time zone updated successfully!');
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
