# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get communication log object and MessageID
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # checking mandatory configuration options
    for my $Option (qw(NumberRegExp DynamicFieldName SenderType IsVisibleForCustomer)) {
        if ( !defined $Param{JobConfig}->{$Option} && !$Param{JobConfig}->{$Option} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Value         => "Missing configuration for $Option for postmaster filter.",
            );
            return 1;
        }
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
        Value         => "Starting filter '$Param{JobConfig}->{Name}'",
    );

    # check if sender is of interest
    return 1 if !$Param{GetParam}->{From};

    if ( defined $Param{JobConfig}->{FromAddressRegExp} && $Param{JobConfig}->{FromAddressRegExp} )
    {

        if ( $Param{GetParam}->{From} !~ /$Param{JobConfig}->{FromAddressRegExp}/i ) {
            return 1;
        }
    }

    my $NumberRegExp = $Param{JobConfig}->{NumberRegExp};

    # search in the subject
    if ( $Param{JobConfig}->{SearchInSubject} ) {

        # try to get external ticket number from email subject
        my @SubjectLines = split /\n/, $Param{GetParam}->{Subject};
        LINE:
        for my $Line (@SubjectLines) {
            if ( $Line =~ m{$NumberRegExp}ms ) {
                $Self->{Number} = $1;
                last LINE;
            }
        }

        if ( $Self->{Number} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Value         => "Found number: '$Self->{Number}' in subject",
            );
        }
        else {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
                Value         => "No number found in subject: '" . join( '', @SubjectLines ) . "'",
            );
        }
    }

    # search in the body
    if ( $Param{JobConfig}->{SearchInBody} ) {

        # split the body into separate lines
        my @BodyLines = split /\n/, $Param{GetParam}->{Body};

        # traverse lines and return first match
        LINE:
        for my $Line (@BodyLines) {
            if ( $Line =~ m{$NumberRegExp}ms ) {

                # get the found element value
                $Self->{Number} = $1;
                last LINE;
            }
        }
    }

    # we need to have found an external number to proceed.
    if ( !$Self->{Number} ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Value         => "Could not find external ticket number => Ignoring",
        );
        return 1;
    }
    else {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Value         => "Found number $Self->{Number}",
        );
    }

    # is there a ticket for this ticket number?
    my %Query = (
        Result => 'ARRAY',
        Limit  => 1,
        UserID => 1,
    );

    # check if we should only find the ticket number in tickets with a given state type
    if ( defined $Param{JobConfig}->{TicketStateTypes} && $Param{JobConfig}->{TicketStateTypes} ) {

        $Query{StateTypeIDs} = [];
        my @StateTypeIDs;

        # if StateTypes contains semicolons, use that for split,
        # otherwise split on spaces (for compat)
        if ( $Param{JobConfig}->{TicketStateTypes} =~ m{;} ) {
            @StateTypeIDs = split ';', $Param{JobConfig}->{TicketStateTypes};
        }
        else {
            @StateTypeIDs = split ' ', $Param{JobConfig}->{TicketStateTypes};
        }

        STATETYPE:
        for my $StateType (@StateTypeIDs) {

            next STATETYPE if !$StateType;

            my $StateTypeID = $Kernel::OM->Get('Kernel::System::State')->StateTypeLookup(
                StateType => $StateType,
            );

            if ($StateTypeID) {
                push @{ $Query{StateTypeIDs} }, $StateTypeID;
            }
        }
    }

    # dynamic field search condition
    $Query{ 'DynamicField_' . $Param{JobConfig}->{'DynamicFieldName'} } = {
        Equals => $Self->{Number},
    };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # search tickets
    my @TicketIDs = $TicketObject->TicketSearch(%Query);

    # get the first and only ticket id
    my $TicketID = shift @TicketIDs;

    # ok, found ticket to deal with
    if ($TicketID) {

        # get ticket number
        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
            UserID   => 1,
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Value         => "Found ticket $TicketNumber open for external number $Self->{Number}. Updating.",
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # build subject
        my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
        my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');
        $Param{GetParam}->{Subject} .= " [$TicketHook$TicketHookDivider$TicketNumber]";

        # Set ticket number for later usage in ETNR follow-up module (see bug#14944).
        $Param{GetParam}->{'X-OTRS-FollowUp-RecognizedTicketNumber'} = $TicketNumber;

        # set sender type and article type.
        $Param{GetParam}->{'X-OTRS-FollowUp-SenderType'}           = $Param{JobConfig}->{SenderType};
        $Param{GetParam}->{'X-OTRS-FollowUp-IsVisibleForCustomer'} = $Param{JobConfig}->{IsVisibleForCustomer};

        # also set these parameters. It could be that the follow up is rejected by Reject.pm
        #   (follow-ups not allowed), but the original article will still be attached to the ticket.
        $Param{GetParam}->{'X-OTRS-SenderType'}           = $Param{JobConfig}->{SenderType};
        $Param{GetParam}->{'X-OTRS-IsVisibleForCustomer'} = $Param{JobConfig}->{IsVisibleForCustomer};

    }
    else {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::Filter::ExternalTicketNumberRecognition',
            Value         => "Creating new ticket for external ticket '$Self->{Number}'",
        );

        # get the dynamic field name and description from JobConfig, set as headers
        my $TicketDynamicFieldName = $Param{JobConfig}->{'DynamicFieldName'};
        $Param{GetParam}->{ 'X-OTRS-DynamicField-' . $TicketDynamicFieldName } = $Self->{Number};

        # set sender type and article type
        $Param{GetParam}->{'X-OTRS-SenderType'}           = $Param{JobConfig}->{SenderType};
        $Param{GetParam}->{'X-OTRS-IsVisibleForCustomer'} = $Param{JobConfig}->{IsVisibleForCustomer};
    }

    return 1;
}

1;
