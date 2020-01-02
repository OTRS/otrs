# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

    my $PreferencesKey   = $Self->{ConfigItem}->{PrefKey};
    my $TimeZones        = Kernel::System::DateTime->TimeZoneList();
    my %TimeZones        = map { $_ => $_ } sort @{$TimeZones};
    my $SelectedTimeZone = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $PreferencesKey );

    # Use stored time zone only if it's valid. It can happen that user preferences store an old-style offset which is
    #   not valid anymore. Please see bug#13374 for more information.
    if (
        $Param{UserData}->{$PreferencesKey}
        && Kernel::System::DateTime->IsTimeZoneValid( TimeZone => $Param{UserData}->{$PreferencesKey} )
        )
    {
        $SelectedTimeZone = $Param{UserData}->{$PreferencesKey};
    }

    $SelectedTimeZone ||= Kernel::System::DateTime->UserDefaultTimeZoneGet();

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
