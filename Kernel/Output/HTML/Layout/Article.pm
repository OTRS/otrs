# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Layout::Article;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Article - Helper functions for article rendering.

=head1 PUBLIC INTERFACE

=head2 ArticleFields()

Get article fields as returned by specific article backend.

    my %ArticleFields = $LayoutObject->ArticleFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
    );

Returns article fields hash:

    %ArticleFields = (
        Sender => {                     # mandatory
            Label => 'Sender',
            Value => 'John Smith',
            Prio  => 100,
        },
        Subject => {                    # mandatory
            Label => 'Subject',
            Value => 'Message',
            Prio  => 200,
        },
        ...
    );

=cut

sub ArticleFields {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticleFields(
        %Param,
        UserID => $Self->{UserID},
    );
}

=head2 ArticlePreview()

Get article content preview as returned by specific article backend.

    my $ArticlePreview = $LayoutObject->ArticlePreview(
        TicketID   => 123,     # (required)
        ArticleID  => 123,     # (required)
        ResultType => 'plain', # (optional) plain|HTML, default: HTML
        MaxLength  => 50,      # (optional) performs trimming (for plain result only)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'Hello, world!';

=cut

sub ArticlePreview {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticlePreview(
        %Param,
        UserID => $Self->{UserID},
    );
}

=head2 ArticleActions()

Get available article actions as returned by specific article backend.

    my @Actions = $LayoutObject->ArticleActions(
        TicketID  => 123,     # (required)
        ArticleID => 123,     # (required)
    );

Returns article action array:

     @Actions = (
        {
            ItemType              => 'Dropdown',
            DropdownType          => 'Reply',
            StandardResponsesStrg => $StandardResponsesStrg,
            Name                  => 'Reply',
            Class                 => 'AsPopup PopupType_TicketAction',
            Action                => 'AgentTicketCompose',
            FormID                => 'Reply' . $Article{ArticleID},
            ResponseElementID     => 'ResponseID',
            Type                  => $Param{Type},
        },
        {
            ItemType    => 'Link',
            Description => 'Forward article via mail',
            Name        => 'Forward',
            Class       => 'AsPopup PopupType_TicketAction',
            Link =>
                "Action=AgentTicketForward;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}"
        },
        ...
     );

=cut

sub ArticleActions {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticleActions(
        %Param,
        UserID => $Self->{UserID},
    );
}

sub _BackendGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # Determine channel name for this article.
    my $ChannelName = $ArticleBackendObject->ChannelNameGet();

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        "Kernel::Output::HTML::Article::$ChannelName",
    );
    return if !$Loaded;

    return $Kernel::OM->Get("Kernel::Output::HTML::Article::$ChannelName");
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
