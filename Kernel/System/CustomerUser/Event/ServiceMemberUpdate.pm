# --
# Kernel/System/CustomerUser/Event/ServiceMemberUpdate.pm - update service members if customer login changes
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerUser::Event::ServiceMemberUpdate;

use strict;
use warnings;

use Kernel::System::Service;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw( ConfigObject EncodeObject LogObject MainObject DBObject )
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw( Data Event Config UserID )) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw( UserLogin NewData OldData )) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    # only update CustomerUser <> Service if fields have really changed
    if ( $Param{Data}->{OldData}->{UserLogin} ne $Param{Data}->{NewData}->{UserLogin} ) {

        # instantiate service object
        $Self->{ServiceObject} = Kernel::System::Service->new( %{$Self} );

        my @Services = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            CustomerUserLogin => $Param{Data}->{OldData}->{UserLogin},
            Result            => 'ARRAY',
            DefaultServices   => 0,
        );

        for my $ServiceID (@Services) {

            # first remove old customer id as service member
            $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $Param{Data}->{OldData}->{UserLogin},
                ServiceID         => $ServiceID,
                Active            => 0,
                UserID            => 1,
            );

            # add new customer id as service member
            $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $Param{Data}->{NewData}->{UserLogin},
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );
        }
    }
    return 1;
}

1;
