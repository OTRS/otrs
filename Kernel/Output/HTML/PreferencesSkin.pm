# --
# Kernel/Output/HTML/PreferencesSkin.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesSkin;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;
    my $PossibleSkins = $Self->{ConfigObject}->Get('Loader::Agent::Skin') || {};
    my $Home = $Self->{ConfigObject}->Get('Home');
    my %ActiveSkins;

    # prepare the list of active skins
    for my $PossibleSkin ( values %{$PossibleSkins} ) {
        if (
            $Self->{LayoutObject}->SkinValidate(
                Skin     => $PossibleSkin->{InternalName},
                SkinType => 'Agent'
            )
            )
        {
            $ActiveSkins{ $PossibleSkin->{InternalName} } = $PossibleSkin->{VisibleName};
        }
    }

    my @Params;
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Data       => \%ActiveSkins,
            HTMLQuote  => 0,
            SelectedID => $Self->{ParamObject}->GetParam( Param => 'UserSkin' )
                || $Param{UserData}->{UserSkin}
                || $Self->{ConfigObject}->Get('Loader::Agent::DefaultSelectedSkin'),
            Block => 'Option',
            Max   => 100,
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for my $Value (@Array) {

            # pref update db
            if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
                $Self->{UserObject}->SetPreferences(
                    UserID => $Param{UserData}->{UserID},
                    Key    => $Key,
                    Value  => $Value,
                );
            }

            # update SessionID
            if ( $Param{UserData}->{UserID} eq $Self->{UserID} ) {
                $Self->{SessionObject}->UpdateSessionID(
                    SessionID => $Self->{SessionID},
                    Key       => $Key,
                    Value     => $Value,
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
