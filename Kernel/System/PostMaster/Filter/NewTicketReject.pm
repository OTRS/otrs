# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::NewTicketReject;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Email',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get communication log object and MessageID
    $Self->{CommunicationLogObject}    = $Param{CommunicationLogObject}    || die "Got no CommunicationLogObject!";
    $Self->{CommunicationLogMessageID} = $Param{CommunicationLogMessageID} || die "Got no CommunicationLogMessageID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(JobConfig GetParam)) {
        if ( !$Param{$_} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectType => 'Message',
                ObjectID   => $Self->{CommunicationLogMessageID},
                Priority   => 'Error',
                Key        => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value      => "Need $_!",
            );
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get config options
    my %Config;
    my @Match;
    my @Set;
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        %Config = %{ $Param{JobConfig} };
        if ( $Config{Match} ) {
            @Match = @{ $Config{Match} };
        }
        if ( $Config{Set} ) {
            @Set = @{ $Config{Set} };
        }
    }

    # match 'Match => ???' stuff
    my $Matched    = '';
    my $MatchedNot = 0;
    for my $Index ( 0 .. ( scalar @Match ) - 1 ) {
        my $Key   = $Match[$Index]->{Key};
        my $Value = $Match[$Index]->{Value};

        if ( $Param{GetParam}->{$Key} && $Param{GetParam}->{$Key} =~ /$Value/i ) {

            $Matched = $1 || '1';

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectType => 'Message',
                ObjectID   => $Self->{CommunicationLogMessageID},
                Priority   => 'Debug',
                Key        => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value      => "'$Param{GetParam}->{$Key}' =~ /$Value/i matched!",
            );
        }
        else {

            $MatchedNot = 1;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectType => 'Message',
                ObjectID   => $Self->{CommunicationLogMessageID},
                Priority   => 'Debug',
                Key        => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value      => "'$Param{GetParam}->{$Key}' =~ /$Value/i matched NOT!",
            );
        }
    }
    if ( $Matched && !$MatchedNot ) {

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # check if new ticket
        my $Tn = $TicketObject->GetTNByString( $Param{GetParam}->{Subject} );

        return 1 if $Tn && $TicketObject->TicketCheckNumber( Tn => $Tn );

        # set attributes if ticket is created
        for my $SetItem (@Set) {
            my $Key   = $SetItem->{Key};
            my $Value = $SetItem->{Value};

            $Param{GetParam}->{$Key} = $Value;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectType => 'Message',
                ObjectID   => $Self->{CommunicationLogMessageID},
                Priority   => 'Notice',
                Key        => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value      => "Set param '$Key' to '$Value' (Message-ID: $Param{GetParam}->{'Message-ID'})",
            );
        }

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # send bounce mail
        my $Subject = $ConfigObject->Get(
            'PostMaster::PreFilterModule::NewTicketReject::Subject'
        );
        my $Body = $ConfigObject->Get(
            'PostMaster::PreFilterModule::NewTicketReject::Body'
        );
        my $Sender = $ConfigObject->Get(
            'PostMaster::PreFilterModule::NewTicketReject::Sender'
        ) || '';

        $Kernel::OM->Get('Kernel::System::Email')->Send(
            From       => $Sender,
            To         => $Param{GetParam}->{From},
            Subject    => $Subject,
            Body       => $Body,
            Charset    => 'utf-8',
            MimeType   => 'text/plain',
            Loop       => 1,
            Attachment => [
                {
                    Filename    => 'email.txt',
                    Content     => $Param{GetParam}->{Body},
                    ContentType => 'application/octet-stream',
                }
            ],
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectType => 'Message',
            ObjectID   => $Self->{CommunicationLogMessageID},
            Priority   => 'Notice',
            Key        => 'Kernel::System::PostMaster::Filter::NewTicketReject',
            Value      => "Send reject mail to '$Param{GetParam}->{From}'!",
        );
    }

    return 1;
}

1;
