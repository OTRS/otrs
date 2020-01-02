# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketHistoryGet;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Ticket::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketHistoryGet - GenericInterface Ticket History Get Operation backend

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
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=head2 Run()

perform TicketHistoryGet Operation. This function is able to return
one or more ticket entries in one call.

    my $Result = $OperationObject->Run(
        Data => {
            UserLogin            => 'some agent login',                            # UserLogin or SessionID is required
            SessionID            => 123,
            Password             => 'some password',                               # if UserLogin is sent then Password is required
            TicketID             => '32,33',                                       # required, could be coma separated IDs or an Array
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            TicketHistory => [
                {
                    TicketID => 123,
                    History  => [
                        # ...
                    ],
                },
            ],
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Result = $Self->Init(
        WebserviceID => $Self->{WebserviceID},
    );

    if ( !$Result->{Success} ) {
        return $Self->ReturnError(
            ErrorCode    => 'Webservice.InvalidConfiguration',
            ErrorMessage => $Result->{ErrorMessage},
        );
    }

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    if ( !$UserID ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketHistoryGet.AuthFail',
            ErrorMessage => "TicketHistoryGet: Authorization failing!",
        );
    }
    if ( $UserType ne 'User' ) {
        return $Self->ReturnError(
            ErrorCode    => 'TicketHistoryGet.AuthFail',
            ErrorMessage => "TicketHistoryGet: User needs to an Agent!",
        );
    }

    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            return $Self->ReturnError(
                ErrorCode    => 'TicketHistoryGet.MissingParameter',
                ErrorMessage => "TicketHistoryGet: $Needed parameter is missing!",
            );
        }
    }
    my $ErrorMessage = '';

    # All needed variables.
    my @TicketIDs;
    if ( IsStringWithData( $Param{Data}->{TicketID} ) ) {
        @TicketIDs = split( /,/, $Param{Data}->{TicketID} );
    }
    elsif ( IsArrayRefWithData( $Param{Data}->{TicketID} ) ) {
        @TicketIDs = @{ $Param{Data}->{TicketID} };
    }
    else {
        return $Self->ReturnError(
            ErrorCode    => 'TicketHistoryGet.WrongStructure',
            ErrorMessage => "TicketHistoryGet: Structure for TicketID is not correct!",
        );
    }

    TICKET:
    for my $TicketID (@TicketIDs) {

        my $Access = $Self->CheckAccessPermissions(
            TicketID => $TicketID,
            UserID   => $UserID,
            UserType => $UserType,
        );

        next TICKET if $Access;

        return $Self->ReturnError(
            ErrorCode    => 'TicketHistoryGet.AccessDenied',
            ErrorMessage => "TicketHistoryGet: User does not have access to the ticket $TicketID!",
        );
    }

    my $ReturnData = {
        Success => 1,
    };

    my @Histories;

    my %SafeAttributes = (
        TicketID      => 1,
        ArticleID     => 1,
        Name          => 1,
        CreateBy      => 1,
        CreateTime    => 1,
        HistoryType   => 1,
        QueueID       => 1,
        OwnerID       => 1,
        PriorityID    => 1,
        StateID       => 1,
        HistoryTypeID => 1,
        TypeID        => 1,
    );

    # start ticket loop
    TICKET:
    for my $TicketID (@TicketIDs) {

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my @LinesRaw = $TicketObject->HistoryGet(
            TicketID => $TicketID,
            UserID   => $UserID,
        );

        my @Lines;
        for my $Line (@LinesRaw) {

            my %Attributes;

            ATTRIBUTE:
            for my $Attribute ( sort keys %{$Line} ) {
                next ATTRIBUTE if !$SafeAttributes{$Attribute};

                $Attributes{$Attribute} = $Line->{$Attribute};
            }

            push @Lines, \%Attributes;
        }

        push @Histories, {
            TicketID => $TicketID,
            History  => \@Lines,
        };
    }

    if ( !scalar @Histories ) {
        $ErrorMessage = 'Could not get Ticket history data'
            . ' in Kernel::GenericInterface::Operation::Ticket::TicketHistoryGet::Run()';

        return $Self->ReturnError(
            ErrorCode    => 'TicketHistoryGet.NotTicketData',
            ErrorMessage => "TicketHistoryGet: $ErrorMessage",
        );
    }

    # set ticket data into return structure
    $ReturnData->{Data}->{TicketHistory} = \@Histories;

    # return result
    return $ReturnData;
}

1;

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
