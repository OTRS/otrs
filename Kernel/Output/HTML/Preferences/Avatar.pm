# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Preferences::Avatar;

use strict;
use warnings;

use Digest::MD5 qw(md5_hex);

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::Config',
    'Kernel::System::AuthSession',
    'Kernel::System::Encode',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my $AvatarEngine = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::AvatarEngine');
    my $Return       = {
        AvatarEngine => $AvatarEngine,
    };

    if ( $AvatarEngine eq 'Gravatar' && $Self->{UserEmail} ) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Self->{UserEmail} );
        $Return->{Avatar} = '//www.gravatar.com/avatar/' . md5_hex( lc $Self->{UserEmail} ) . '?s=45&d=mp';
    }

    return $Return;
}

sub Run {
    my ( $Self, %Param ) = @_;

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
