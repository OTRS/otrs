# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Email::Test;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::CommunicationLog',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{CacheKey}  = 'Emails';
    $Self->{CacheType} = 'EmailTest';

    $Self->{Type} = 'Test';

    return $Self;
}

sub Send {
    my ( $Self, %Param ) = @_;

    my $Class = ref $Self;

    # Get and delete the communication-log object from the Params because all the
    # other params will be cached (necessary for the unit tests).
    my $CommunicationLogObject = delete $Param{CommunicationLogObject};

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => $Class,
        Value         => 'Received message for emulated sending without real external connections.',
    );

    # get already stored emails from cache
    my $Emails = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Key  => $Self->{CacheKey},
        Type => $Self->{CacheType},
    ) // [];

    # recipient
    my $ToString = join ', ', @{ $Param{ToArray} };

    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => $Class,
        Value         => sprintf( "Sending email from '%s' to '%s'.", $Param{From} // '', $ToString ),
    );

    push @{$Emails}, \%Param;

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Key   => $Self->{CacheKey},
        Type  => $Self->{CacheType},
        Value => $Emails,
        TTL   => 60 * 60 * 24,
    );

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Priority      => 'Info',
        Key           => $Class,
        Value         => "Email successfully sent!",
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return {
        Success => 1,
    };
}

sub EmailsGet {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Key  => $Self->{CacheKey},
        Type => $Self->{CacheType},
    ) // [];
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );
}

1;
