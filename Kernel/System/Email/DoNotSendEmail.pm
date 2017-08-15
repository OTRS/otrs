# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::DoNotSendEmail;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{Type} = 'DoNotSendEmail';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => 'Received message for emulated sending without real external connections.',
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => 'Validating message contents.',
    );

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {

            my $ErrorMessage = "Need $_!";

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $ErrorMessage,
            );

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::Email::DoNotSendEmail',
                Value         => $ErrorMessage,
            );

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
    }

    # from
    if ( !defined $Param{From} ) {
        $Param{From} = '';
    }

    # recipient
    my $ToString = join ', ', @{ $Param{ToArray} };

    $Param{CommunicationLogObject}->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => "Sending email from '$Param{From}' to '$ToString'.",
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => 'Kernel::System::Email::DoNotSendEmail',
        Value         => "Email successfully sent!",
    );

    $Param{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return {
        Success => 1,
    };
}

1;
