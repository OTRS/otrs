# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate - A module to create an article

=head1 DESCRIPTION

All TicketArticleCreate functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $TicketArticleCreateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

    Run Data

    my $TicketArticleCreateResult = $TicketArticleCreateActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            SenderType           => 'agent',                            # (required) agent|system|customer
            IsVisibleForCustomer => 1,                                  # 0 or 1
            CommunicationChannel => 'Internal',                         # Internal|Phone|Email|..., default: Internal

            %DataPayload,                                               # some parameters depending of each communication channel

            TimeUnit => 123                                             # optional, to set the acouting time
            UserID   => 123,                                            # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketArticleCreateResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Define a common message to output in case of any error.
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # Check for missing or wrong params.
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    $Param{Config}->{CommunicationChannel} ||= 'Internal';

    if ( !defined $Param{Config}->{IsVisibleForCustomer} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Config -> IsVisibleForCustomer",
        );

        return;
    }

    # Override UserID if specified as a parameter in the TA config.
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # Use ticket attributes if needed.
    $Self->_ReplaceTicketAttributes(%Param);

    # Convert scalar items into array references.
    for my $Attribute (
        qw(ForceNotificationToUserID ExcludeNotificationToUserID ExcludeMuteNotificationToUserID)
        )
    {
        if ( IsStringWithData( $Param{Config}->{$Attribute} ) ) {
            $Param{Config}->{$Attribute} = $Self->_ConvertScalar2ArrayRef(
                Data => $Param{Config}->{$Attribute},
            );
        }
    }

    # If "From" is not set and MIME based article is to be created.
    if (
        !$Param{Config}->{From}
        && $Param{Config}->{CommunicationChannel} =~ m{\AEmail|Internal|Phone\z}msxi
        )
    {

        # Get current user data
        my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $Param{UserID},
        );

        # Set "From" field according to user - UserFullname <UserEmail>.
        $Param{Config}->{From} = $User{UserFullname} . ' <' . $User{UserEmail} . '>';
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
        ChannelName => $Param{Config}->{CommunicationChannel}
    );

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        %{ $Param{Config} },
        TicketID => $Param{Ticket}->{TicketID},
        UserID   => $Param{UserID},
    );

    if ( !$ArticleID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't create article for Ticket: "
                . $Param{Ticket}->{TicketID} . '!',
        );
        return;
    }

    # Set time units.
    if ( $Param{Config}->{TimeUnit} ) {
        $Kernel::OM->Get('Kernel::System::Ticket')->TicketAccountTime(
            TicketID  => $Param{Ticket}->{TicketID},
            ArticleID => $ArticleID,
            TimeUnit  => $Param{Config}->{TimeUnit},
            UserID    => $Param{UserID},
        );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
