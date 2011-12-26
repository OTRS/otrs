# --
# Kernel/GenericInterface/Operation/Ticket/Common.pm - Ticket common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.6 2011-12-26 17:56:21 cr Exp $
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
use Kernel::System::Valid;
use Kernel::System::GenericInterface::Webservice;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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
    $Self->{QueueObject}      = Kernel::System::Queue->new( %{$Self} );
    $Self->{LockObject}       = Kernel::System::Lock->new( %{$Self} );
    $Self->{ValidObject}      = Kernel::System::Valid->new( %{$Self} );
    $Self->{WebserviceObject} = Kernel::System::GenericInterface::Webservice->new( %{$Self} );

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

    my %Queue;

    # check for Queue name sent
    if (
        $Param{Queue}
        && $Param{Queue} ne ''
        && !$Param{QueueID}
        )
    {
        %Queue = $Self->{QueueObject}->QueueGet(
            Name => $Param{Queue},
        );

    }

    # otherwise use QueueID
    elsif ( $Param{QueueID} ) {
        %Queue = $Self->{QueueObject}->QueueGet(
            ID => $Param{QueueID},
        );
    }
    else {
        return
    }

    # return false if queue data is empty
    return if !IsHashRefWithData( \%Queue );

    # return false if queue is not valid
    return if $Self->{ValidObject}->ValidLookup( ValidID => $Queue{ValidID} ) ne 'valid';

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

$Revision: 1.6 $ $Date: 2011-12-26 17:56:21 $

=cut
