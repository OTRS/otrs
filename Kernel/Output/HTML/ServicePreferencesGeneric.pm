# --
# Kernel/Output/HTML/ServicePreferencesGeneric.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: ServicePreferencesGeneric.pm,v 1.2 2009-07-07 15:45:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ServicePreferencesGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get env
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem ServiceObject)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params = ();
    my $GetParam = $Self->{ParamObject}->GetParam( Param => $Self->{ConfigItem}->{PrefKey} );
    if ( !defined($GetParam) ) {
        $GetParam = defined( $Param{ServiceData}->{ $Self->{ConfigItem}->{PrefKey} } )
            ? $Param{ServiceData}->{ $Self->{ConfigItem}->{PrefKey} }
            : $Self->{ConfigItem}->{DataSelected};
    }
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            SelectedID => $GetParam,
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
            $Self->{ServiceObject}->ServicePreferencesSet(
                ServiceID => $Param{ServiceData}->{ServiceID},
                Key       => $Key,
                Value     => $_,
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
