# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::NewTicketReject;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(JobConfig GetParam)) {
        if ( !$Param{$_} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value         => "Need $_!",
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

        if ( IsArrayRefWithData( $Config{Match} ) ) {
            @Match = @{ $Config{Match} };
        }
        elsif ( IsHashRefWithData( $Config{Match} ) ) {

            for my $Key ( sort keys %{ $Config{Match} } ) {
                push @Match, {
                    Key   => $Key,
                    Value => $Config{Match}->{$Key},
                };
            }
        }

        if ( IsArrayRefWithData( $Config{Set} ) ) {
            @Set = @{ $Config{Set} };
        }
        elsif ( IsHashRefWithData( $Config{Set} ) ) {

            for my $Key ( sort keys %{ $Config{Set} } ) {
                push @Set, {
                    Key   => $Key,
                    Value => $Config{Set}->{$Key},
                };
            }
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
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value         => "'$Param{GetParam}->{$Key}' =~ /$Value/i matched!",
            );
        }
        else {

            $MatchedNot = 1;

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value         => "'$Param{GetParam}->{$Key}' =~ /$Value/i matched NOT!",
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
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::Filter::NewTicketReject',
                Value         => "Set param '$Key' to '$Value' (Message-ID: $Param{GetParam}->{'Message-ID'})",
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
            ObjectLogType => 'Message',
            Priority      => 'Notice',
            Key           => 'Kernel::System::PostMaster::Filter::NewTicketReject',
            Value         => "Send reject mail to '$Param{GetParam}->{From}'!",
        );
    }

    return 1;
}

1;
