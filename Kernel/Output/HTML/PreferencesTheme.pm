# --
# Kernel/Output/HTML/PreferencesTheme.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesTheme;

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

    my $PossibleThemesRef = $Self->{ConfigObject}->Get('Frontend::Themes')
        || {};
    my %PossibleThemes = %{$PossibleThemesRef};
    my $Home           = $Self->{ConfigObject}->Get('Home');

    my %ActiveThemes;

    # prepare the list of active themes
    for my $PossibleTheme ( sort keys %PossibleThemes ) {
        if ( $PossibleThemes{$PossibleTheme} == 1 )
        {    # only add a theme if it is set to 1 in sysconfig
            my $ThemeDir = $Home . "/Kernel/Output/HTML/" . $PossibleTheme;
            if ( -d $ThemeDir ) {    # .. and if the theme dir exists
                $ActiveThemes{$PossibleTheme} = $PossibleTheme;
            }
        }
    }

    my @Params;
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Data       => \%ActiveThemes,
            HTMLQuote  => 0,
            SelectedID => $Self->{ParamObject}->GetParam( Param => 'UserTheme' )
                || $Param{UserData}->{UserTheme}
                || $Self->{ConfigObject}->Get('DefaultTheme'),
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
