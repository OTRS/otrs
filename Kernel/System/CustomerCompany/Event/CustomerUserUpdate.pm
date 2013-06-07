# --
# Kernel/System/CustomerCompany/Event/CustomerUserUpdate.pm - update customer users if company changes
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerCompany::Event::CustomerUserUpdate;

use strict;
use warnings;

use Kernel::System::CustomerUser;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw( ConfigObject EncodeObject LogObject MainObject DBObject)
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
    for (qw( CustomerID OldCustomerID )) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    return 1 if $Param{Data}->{CustomerID} eq $Param{Data}->{OldCustomerID};

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    my %CustomerUsers = $Self->{CustomerUserObject}->CustomerSearch(
        CustomerID => $Param{Data}->{OldCustomerID},
        Valid      => 0,
    );

    for my $CustomerUserLogin ( keys %CustomerUsers ) {
        my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $CustomerUserLogin,
        );

        # we do not need to 'change' the password (this would re-hash it!)
        delete $CustomerData{UserPassword};
        $Self->{CustomerUserObject}->CustomerUserUpdate(
            %CustomerData,
            ID             => $CustomerUserLogin,
            UserCustomerID => $Param{Data}->{CustomerID},
            UserID         => $Param{UserID},
        );
    }

    return 1;
}

1;
