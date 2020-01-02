# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::User',
    'Kernel::System::HTMLUtils',
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
        Config => {
            SenderType           => 'agent',                            # (required) agent|system|customer
            IsVisibleForCustomer => 1,                                  # 0 or 1
            CommunicationChannel => 'Internal',                         # Internal|Phone|Email|..., default: Internal

            %DataPayload,                                               # some parameters depending of each communication channel, please check ArticleCreate() on each
                                                                        #   communication channel for the full list of optional and mandatory parameters

            TimeUnit => 123,                                            # optional, to set the accounting time
            UserID   => 123,                                            # optional, to override the UserID from the logged user
       },
    );

    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketArticleCreateResult = 1; # 0

    Internal article example:

    my $TicketArticleCreateResult = $TicketArticleCreateActionObject->Run(
        UserID => 123,
        Ticket => {
            TicketNumber => '20101027000001',
            Title        => 'some title',
            TicketID     => 123,
            State        => 'some state',
            # ... (all ticket properties)
        },
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config => {
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            CommunicationChannel => 'Internal',

            # Internal article data payload.
            From           => 'Some Agent <email@example.com>',
            To             => 'Some Customer A <customer-a@example.com>',
            Subject        => 'some short description',
            Body           => 'the message text',
            Charset        => 'ISO-8859-15',
            MimeType       => 'text/plain',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UnlockOnAway   => 1,
        },
    );

    Chat article example:

    my $TicketArticleCreateResult = $TicketArticleCreateActionObject->Run(
        UserID => 123,
        Ticket => {
            TicketNumber       => '20101027000001',
            Title              => 'some title',
            TicketID           => 123,
            State              => 'some state',
            # ... (all ticket properties, as the result from Kernel::System::Ticket::TicketGet)
        },
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config => {
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            CommunicationChannel => 'Internal',

            # Internal article data payload.
            From             => 'Some Agent <email@example.com>',
            To               => 'Some Customer A <customer-a@example.com>',
            Subject          => 'some short description',
            Body             => 'the message text',
            Charset          => 'ISO-8859-15',
            MimeType         => 'text/plain',
            HistoryType      => 'OwnerUpdate',
            HistoryComment   => 'Some free text!',
            UnlockOnAway     => 1,
        },
    );

    Chat article example:

    my $TicketArticleCreateResult = $TicketArticleCreateActionObject->Run(
        UserID => 123,
        Ticket => {
            TicketNumber => '20101027000001',
            Title        => 'some title',
            TicketID     => 123,
            State        => 'some state',
            # ... (all ticket properties, as the result from Kernel::System::Ticket::TicketGet)
        },
        ProcessEntityID            => 'P123',
        ActivityEntityID           => 'A123',
        SequenceFlowEntityID       => 'T123',
        SequenceFlowActionEntityID => 'TA123',
        Config                   => {
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            CommunicationChannel => 'Internal',

            # Chat article data payload.
            ChatMessageList => [
                {
                    ID              => 1,
                    MessageText     => 'My chat message',
                    CreateTime      => '2014-04-04 10:10:10',
                    SystemGenerated => 0,
                    ChatterID       => '123',
                    ChatterType     => 'User',
                    ChatterName     => 'John Doe',
                },
                # ...
            ],
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
        },
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

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Convert DynamicField value to HTML string, see bug#14229.
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    if ( $Param{Config}->{Body} =~ /OTRS_TICKET_DynamicField_/ ) {
        MATCH:
        for my $Match ( sort keys %{ $Param{Ticket} } ) {
            if ( $Match =~ m/DynamicField_(.*)/ && $Param{Ticket}->{$Match} ) {

                my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    Name => $1,
                );

                # Check if there is HTML content.
                my $IsHTMLContent = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsHTMLContent',
                );

                # Avoid duble conversion to HTML for dynamic fields with HTML content.
                next MATCH if $IsHTMLContent;
                $Param{Ticket}->{$Match} = $HTMLUtilsObject->ToHTML(
                    String => $Param{Ticket}->{$Match},
                );
            }
        }
    }

    # Use ticket attributes if needed.
    $Self->_ReplaceTicketAttributes(%Param);
    $Self->_ReplaceAdditionalAttributes(%Param);

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

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
