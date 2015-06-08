# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::Theme;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Web::Request',
    'Kernel::System::User',
    'Kernel::System::AuthSession',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID ConfigItem)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $PossibleThemesRef = $ConfigObject->Get('Frontend::Themes')
        || {};
    my %PossibleThemes = %{$PossibleThemesRef};
    my $Home           = $ConfigObject->Get('Home');

    my %ActiveThemes;

    # prepare the list of active themes
    for my $PossibleTheme ( sort keys %PossibleThemes ) {
        if ( $PossibleThemes{$PossibleTheme} == 1 )
        {    # only add a theme if it is set to 1 in sysconfig
            my $ThemeDir = $Home . "/Kernel/Output/HTML/Templates/" . $PossibleTheme;
            if ( -d $ThemeDir ) {    # .. and if the theme dir exists
                $ActiveThemes{$PossibleTheme} = $PossibleTheme;
            }
        }
    }

    # only show the theme preference if there are two or more themes to choose from
    return if scalar keys %ActiveThemes < 2;

    my @Params;
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Data       => \%ActiveThemes,
            HTMLQuote  => 0,
            SelectedID => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'UserTheme' )
                || $Param{UserData}->{UserTheme}
                || $ConfigObject->Get('DefaultTheme'),
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
            if ( !$Kernel::OM->Get('Kernel::Config')->Get('DemoSystem') ) {
                $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
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
