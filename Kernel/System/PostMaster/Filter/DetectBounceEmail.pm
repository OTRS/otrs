# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::DetectBounceEmail;

use strict;
use warnings;

use Sisimai::Data;
use Sisimai::Message;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Ensure that the flag X-OTRS-Bounce doesn't exist if we didn't analysed it yet.
    delete $Param{GetParam}->{'X-OTRS-Bounce'};

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => ref($Self),
        Value         => 'Checking if is a Bounce e-mail.',
    );

    my $BounceMessage = Sisimai::Message->new( data => $Self->{ParserObject}->GetPlainEmail() );

    return 1 if !$BounceMessage;

    my $BounceData = Sisimai::Data->make( data => $BounceMessage );

    return 1 if !$BounceData || !@{$BounceData};

    my $MessageID = $BounceData->[0]->messageid();

    return 1 if !$MessageID;

    $MessageID = sprintf '<%s>', $MessageID;

    $Param{GetParam}->{'X-OTRS-Bounce'}                   = 1;
    $Param{GetParam}->{'X-OTRS-Bounce-OriginalMessageID'} = $MessageID;
    $Param{GetParam}->{'X-OTRS-Bounce-ErrorMessage'}      = $Param{GetParam}->{Body};
    $Param{GetParam}->{'X-OTRS-Loop'}                     = 1;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => ref($Self),
        Value         => sprintf(
            'Detected Bounce for e-mail "%s"',
            $MessageID,
        ),
    );

    return 1;
}

1;
