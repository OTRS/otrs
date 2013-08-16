# --
# Kernel/Output/HTML/PreferencesColumnFilters.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesColumnFilters;

use strict;
use warnings;

use Kernel::System::JSON;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # create additional objects
    $Self->{JSONObject} = Kernel::System::JSON->new( %{$Self} );

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params;
    my $GetParam = $Self->{ParamObject}->GetParam( Param => 'FilterAction' );

    push(
        @Params,
        {
            Name => $Self->{ConfigItem}->{PrefKey},
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $FilterAction = $Self->{ParamObject}->GetParam( Param => 'FilterAction' );

    for my $Key ( sort keys %{ $Param{GetParam} } ) {

        # pref update db
        if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
            $Self->{UserObject}->SetPreferences(
                UserID => $Param{UserData}->{UserID},
                Key    => $Key . '-' . $FilterAction,
                Value  => $Self->{JSONObject}->Encode( Data => $Param{GetParam}->{$Key} ),
            );
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
