# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Session::SessionGet;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData IsHashRefWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Session::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Session::SessionGet - GenericInterface Session Get Operation backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=head2 Run()

Get session information.

    my $Result = $OperationObject->Run(
        Data => {
            SessionID => '1234567890123456',
        },
    );
    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            UserSessionStart    => '1293801801',
            UserRemoteAddr      => '127.0.0.1',
            UserRemoteUserAgent => 'Some User Agent x.x',
            UserLastname        => 'SomeLastName',
            UserFirstname       => 'SomeFirstname',
            # and other preferences values
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !IsHashRefWithData( $Param{Data} ) ) {

        return $Self->ReturnError(
            ErrorCode    => 'SessionGet.MissingParameter',
            ErrorMessage => "SessionGet: The request is empty!",
        );
    }

    if ( !$Param{Data}->{SessionID} ) {
        return $Self->ReturnError(
            ErrorCode    => 'SessionGet.MissingParameter',
            ErrorMessage => "SessionGet: SessionID is missing!",
        );
    }

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # Honor SessionCheckRemoteIP, SessionMaxIdleTime, etc.
    my $Valid = $SessionObject->CheckSessionID(
        SessionID => $Param{Data}->{SessionID},
    );
    if ( !$Valid ) {
        return $Self->ReturnError(
            ErrorCode    => 'SessionGet.SessionInvalid',
            ErrorMessage => 'SessionGet: SessionID is Invalid!',
        );
    }

    my %SessionDataRaw = $SessionObject->GetSessionIDData(
        SessionID => $Param{Data}->{SessionID},
    );

    # Filter out some sensitive values
    delete $SessionDataRaw{UserPw};
    delete $SessionDataRaw{UserChallengeToken};

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my @SessionData;
    for my $DataKey ( sort keys %SessionDataRaw ) {

        my $Value = $SessionDataRaw{$DataKey};
        my %Data  = (
            Key   => $DataKey,
            Value => $Value,
        );

        if ( ref $Value ) {
            $Data{Value} = $JSONObject->Encode(
                Data     => $Value,
                SortKeys => 1,
            );
            $Data{Serialized} = 1;
        }

        push @SessionData, \%Data;
    }

    return {
        Success => 1,
        Data    => {
            SessionData => \@SessionData,
        },
    };

}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
