# --
# Kernel/GenericInterface/Operation/Ticket/Common.pm - Ticket common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.9 2011-12-26 20:55:22 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::Common;

use strict;
use warnings;

use Kernel::System::Queue;
use Kernel::System::Lock;
use Kernel::System::Type;
use Kernel::System::CustomerUser;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::Valid;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::Common - common operation functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Operation::Ticket::Common;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SolManCommonObject = Kernel::GenericInterface::Operation::Ticket::Common->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw( DebuggerObject MainObject TimeObject ConfigObject LogObject DBObject EncodeObject WebserviceID)
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
    $Self->{QueueObject}        = Kernel::System::Queue->new( %{$Self} );
    $Self->{LockObject}         = Kernel::System::Lock->new( %{$Self} );
    $Self->{TypeObject}         = Kernel::System::Type->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ServiceObject}      = Kernel::System::Service->new( %{$Self} );
    $Self->{SLAObject}          = Kernel::System::SLA->new( %{$Self} );
    $Self->{StateObject}        = Kernel::System::State->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );
    $Self->{WebserviceObject}   = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

    # get webservice configuration
    $Self->{Webservice} = $Self->{WebserviceObject}->WebserviceGet(
        ID => $Param{WebserviceID},
    );

    if ( !IsHashRefWithData( $Self->{Webservice} ) ) {
        return $Self->_ReturnError(
            ErrorCode => 'Webservice.InvalidConfiguration',
            ErrorMessage =>
                'Could not determine Web service configuration'
                . ' in Kernel::GenericInterface::Operation::Ticket::Common::new()',
        );
    }

    return $Self;
}

=item AuthUser()

performs user authenrication

    my $Success = $CommonObject->AuthUser(
        UserLogin => 'Agent',
        Password  => 'some password',           # plain text password
        CrypPaswd => '50/\/\3 p455\/\/0rd',     # cripted password with the current crypt algorithm
    );

    returns

    $Success = 1;                               # || 0

=cut

sub AuthUser {
    my ( $Self, %Param ) = @_;

    #TODO Implement
    return 1;
}

=item ReturnError()

helper function to return an error message.

    my $Return = $CommonObject->ReturnError(
        ErrorCode    => Ticket.AccessDenied,
        ErrorMessage => 'You dont have rights to access this ticket',
    );

=cut

sub ReturnError {
    my ( $Self, %Param ) = @_;

    $Self->{DebuggerObject}->Error(
        Summary => $Param{ErrorCode},
        Data    => $Param{ErrorMessage},
    );

    # return structure
    return {
        Success      => 1,
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
        Data         => {
            Error => {
                ErrorCode    => $Param{ErrorCode},
                ErrorMessage => $Param{ErrorMessage},
            },
        },
    };
}

=item ValidateQueue()

checks if the given queue or queue ID is valid.

    my $Sucess = $CommonObject->ValidateQueue(
        QueueID => 123,
    );

    my $Sucess = $CommonObject->ValidateQueue(
        Queue   => 'some queue',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateQueue {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{QueueID} && !$Param{Queue};

    my %QueueData;

    # check for Queue name sent
    if (
        $Param{Queue}
        && $Param{Queue} ne ''
        && !$Param{QueueID}
        )
    {
        %QueueData = $Self->{QueueObject}->QueueGet(
            Name => $Param{Queue},
        );

    }

    # otherwise use QueueID
    elsif ( $Param{QueueID} ) {
        %QueueData = $Self->{QueueObject}->QueueGet(
            ID => $Param{QueueID},
        );
    }
    else {
        return;
    }

    # return false if queue data is empty
    return if !IsHashRefWithData( \%QueueData );

    # return false if queue is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $QueueData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateLock()

checks if the given lock or lock ID is valid.

    my $Sucess = $CommonObject->ValidateLock(
        LockID => 123,
    );

    my $Sucess = $CommonObject->ValidateLock(
        Lock   => 'some lock',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateLock {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{LockID} && !$Param{Lock};

    # check for Lock name sent
    if (
        $Param{Lock}
        && $Param{Lock} ne ''
        && !$Param{LockID}
        )
    {
        my $LockID = $Self->{LockObject}->LockLookup(
            Lock => $Param{Lock},
        );
        return if !$LockID;
    }

    # otherwise use LockID
    elsif ( $Param{LockID} ) {
        my $Lock = $Self->{LockObject}->LockLookup(
            LockID => $Param{LockID},
        );
        use Data::Dumper;
        return if !$Lock;
    }
    else {
        return;
    }

    return 1;
}

=item ValidateType()

checks if the given type or type ID is valid.

    my $Sucess = $CommonObject->ValidateType(
        TypeID => 123,
    );

    my $Sucess = $CommonObject->ValidateType(
        Type   => 'some type',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateType {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{TypeID} && !$Param{Type};

    my %TypeData;

    # check for Type name sent
    if (
        $Param{Type}
        && $Param{Type} ne ''
        && !$Param{TypeID}
        )
    {
        %TypeData = $Self->{TypeObject}->TypeGet(
            Name => $Param{Type},
        );
    }

    # otherwise use TypeID
    elsif ( $Param{TypeID} ) {
        %TypeData = $Self->{TypeObject}->TypeGet(
            ID => $Param{TypeID},
        );
    }
    else {
        return;
    }

    # return false if type data is empty
    return if !IsHashRefWithData( \%TypeData );

    # return false if type is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $TypeData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateCustomer()

checks if the given customer user or customer ID is valid.

    my $Sucess = $CommonObject->ValidateCustomer(
        CustomerID => 123,
    );

    my $Sucess = $CommonObject->ValidateCustomer(
        CustomerUser   => 'some type',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateCustomer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{CustomerUser};

    my %CustomerData;

    # check for customer user sent
    if (
        $Param{CustomerUser}
        && $Param{CustomerUser} ne ''
        )
    {
        %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Param{CustomerUser},
        );
    }

    else {
        return;
    }

    # return false if customer data is empty
    return if !IsHashRefWithData( \%CustomerData );

    # return false if type is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $CustomerData{ValidID} ) ne 'valid';

    return 1;
}

=item ValidateService()

checks if the given service or service ID is valid.

    my $Sucess = $CommonObject->ValidateService(
        ServiceID    => 123,
        CustomerUser => 'Test',
    );

    my $Sucess = $CommonObject->ValidateService(
        Service      => 'some service',
        CustomerUser => 'Test',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateService {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{ServiceID} && !$Param{Service};
    return if !$Param{CustomerUser};

    my %ServiceData;

    # check for Service name sent
    if (
        $Param{Service}
        && $Param{Service} ne ''
        && !$Param{ServiceID}
        )
    {
        %ServiceData = $Self->{ServiceObject}->ServiceGet(
            Name   => $Param{Service},
            UserID => 1,
        );
    }

    # otherwise use ServiceID
    elsif ( $Param{ServiceID} ) {
        %ServiceData = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $Param{ServiceID},
            UserID    => 1,
        );
    }
    else {
        return;
    }

    # return false if service data is empty
    return if !IsHashRefWithData( \%ServiceData );

    # return false if service is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $ServiceData{ValidID} ) ne 'valid';

    # get customer services
    my %CustomerServices = $Self->{ServiceObject}->CustomerUserServiceMemberList(
        CustomerUserLogin => $Param{CustomerUser},
        Result            => 'HASH',
        DefaultServices   => 1,
    );

    # return if user does not have pemission to use the service
    return if !$CustomerServices{ $ServiceData{ServiceID} };

    return 1;
}

=item ValidateSLA()

checks if the given service or service ID is valid.

    my $Sucess = $CommonObject->ValidateSLA(
        SLAID     => 12,
        ServiceID => 123,       # || Service => 'some service'
    );

    my $Sucess = $CommonObject->ValidateService(
        SLA       => 'some SLA',
        ServiceID => 123,       # || Service => 'some service'
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateSLA {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{SLAID}     && !$Param{SLA};
    return if !$Param{ServiceID} && !$Param{Service};

    my %SLAData;

    # check for SLA name sent
    if (
        $Param{SLA}
        && $Param{SLA} ne ''
        && !$Param{SLAID}
        )
    {
        my $SLAID = $Self->{SLAObject}->SLALookup(
            Name => $Param{SLA},
        );
        %SLAData = $Self->{SLAObject}->SLAGet(
            SLAID  => $SLAID,
            UserID => 1,
        );
    }

    # otherwise use SLAID
    elsif ( $Param{SLAID} ) {
        %SLAData = $Self->{SLAObject}->SLAGet(
            SLAID  => $Param{SLAID},
            UserID => 1,
        );
    }
    else {
        return;
    }

    # return false if SLA data is empty
    return if !IsHashRefWithData( \%SLAData );

    # return false if SLA is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $SLAData{ValidID} ) ne 'valid';

    # get Sservice ID
    my $ServiceID;
    if (
        $Param{Service}
        && $Param{Service} ne ''
        && !$Param{ServiceID}
        )
    {
        $ServiceID = $Self->{ServiceObject}->ServiceLookup( Name => $Param{Service} ) || 0;
    }
    else {
        $ServiceID = $Param{ServiceID} || 0;
    }

    return if !$ServiceID;

    # check if SLA belogns to service
    my $SLABelongsToService;

    SERVICEID:
    for my $SLAServiceID ( @{ $SLAData{ServiceIDs} } ) {
        next SERVICEID if !$SLAServiceID;
        if ( $SLAServiceID eq $ServiceID ) {
            $SLABelongsToService = 1;
            last SERVICEID;
        }
    }

    # return if SLA does not beong to the service
    return if !$SLABelongsToService;

    return 1;
}

=item ValidateState()

checks if the given state or state ID is valid.

    my $Sucess = $CommonObject->ValidateState(
        StateID => 123,
    );

    my $Sucess = $CommonObject->ValidateState(
        State   => 'some state',
    );

    returns
    $Success = 1            # or 0

=cut

sub ValidateState {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    return if !$Param{StateID} && !$Param{State};

    my %StateData;

    # check for State name sent
    if (
        $Param{State}
        && $Param{State} ne ''
        && !$Param{StateID}
        )
    {
        %StateData = $Self->{StateObject}->StateGet(
            Name => $Param{State},
        );

    }

    # otherwise use StateID
    elsif ( $Param{StateID} ) {
        %StateData = $Self->{StateObject}->StateGet(
            ID => $Param{StateID},
        );
    }
    else {
        return;
    }

    # return false if state data is empty
    return if !IsHashRefWithData( \%StateData );

    # return false if queue is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $StateData{ValidID} ) ne 'valid';

    return 1;
}

=begin Internal:

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.9 $ $Date: 2011-12-26 20:55:22 $

=cut
