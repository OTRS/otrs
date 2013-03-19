# --
# Kernel/GenericInterface/Operation/Session/SessionCreate.pm - GenericInterface SessionCreate operation backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Session::SessionCreate;

use strict;
use warnings;

use Kernel::GenericInterface::Operation::Common;
use Kernel::GenericInterface::Operation::Session::Common;
use Kernel::System::VariableCheck qw(IsStringWithData IsHashRefWithData);

use vars qw(@ISA);

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::SessionCreate - GenericInterface Session Create Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
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

    # create additional objects
    $Self->{CommonObject} = Kernel::GenericInterface::Operation::Common->new( %{$Self} );
    $Self->{SessionCommonObject}
        = Kernel::GenericInterface::Operation::Session::Common->new( %{$Self} );

    return $Self;
}

=item Run()

Retrieve a new session id value.

    my $Result = $OperationObject->Run(
        Data => {
            UserLogin         => 'Agent1',
            CustomerUserLogin => 'Customer1',       # optional, provide UserLogin or CustomerUserLogin
            Password          => 'some password',   # plain text password
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            SessionID => $SessionID,
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        return $Self->{CommonObject}->ReturnError(
            ErrorCode    => 'SessionCreate.MissingParameter',
            ErrorMessage => "SessionCreate: The request is empty!",
        );
    }

    for my $Needed (qw( Password )) {
        if ( !$Param{Data}->{$Needed} ) {
            return $Self->{CommonObject}->ReturnError(
                ErrorCode    => 'SessionCreate.MissingParameter',
                ErrorMessage => "SessionCreate: $Needed parameter is missing!",
            );
        }
    }

    my $SessionID = $Self->{SessionCommonObject}->CreateSessionID(
        %Param,
    );

    if ( !$SessionID ) {
        return $Self->{CommonObject}->ReturnError(
            ErrorCode    => 'SessionCreate.AuthFail',
            ErrorMessage => "SessionCreate: Authorization failing!",
        );
    }

    return {
        Success => 1,
        Data    => {
            SessionID => $SessionID,
        },
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
