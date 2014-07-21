# --
# Kernel/Output/HTML/PreferencesCustomService.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesCustomService;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::Service;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem))
    {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    $Self->{ServiceObject}       = Kernel::System::Service->new( %{$Self} );
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Service',
        TTL  => 60 * 60 * 24 * 20,
    );

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params;
    my @CustomServiceIDs;

    # check needed param, if no user id is given, do not show this box
    if ( !$Param{UserData}->{UserID} ) {
        return ();
    }

    # get all services
    my %ServiceList = $Self->{ServiceObject}->ServiceList(
        Valid  => 1,
        UserID => $Self->{UserID},
    );

    if ( $Self->{ParamObject}->GetArray( Param => 'ServiceID' ) ) {
        @CustomServiceIDs = $Self->{ParamObject}->GetArray( Param => 'ServiceID' );
    }
    elsif ( $Param{UserData}->{UserID} && !defined $CustomServiceIDs[0] ) {
        @CustomServiceIDs = $Self->{ServiceObject}->GetAllCustomServices(
            UserID => $Param{UserData}->{UserID}
        );
    }
    push(
        @Params,
        {
            %Param,
            Option => $Self->{LayoutObject}->BuildSelection(
                Data        => \%ServiceList,
                Name        => 'ServiceID',
                Multiple    => 1,
                Size        => 10,
                SelectedID  => \@CustomServiceIDs,
                Sort        => 'AlphanumericValue',
                Translation => 0,
                TreeView    => 1,

            ),
            Name => 'ServiceID',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{GetParam}->{ServiceID};
    return if ref $Param{GetParam}->{ServiceID} ne 'ARRAY';

    # delete old custom services
    $Self->{DBObject}->Do(
        SQL => "
            DELETE FROM personal_services
            WHERE user_id = ?",
        Bind => [ \$Param{UserData}->{UserID} ],
    );

    # add new custom services
    for my $ServiceID ( @{ $Param{GetParam}->{ServiceID} } ) {
        $Self->{DBObject}->Do(
            SQL => "
                INSERT INTO personal_services (service_id, user_id)
                VALUES (?, ?)",
            Bind => [ \$ServiceID, \$Param{UserData}->{UserID} ]
        );
    }

    my $CacheKey = 'GetAllCustomServices::' . $Param{UserData}->{UserID};
    $Self->{CacheInternalObject}->Delete( Key => $CacheKey );

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
