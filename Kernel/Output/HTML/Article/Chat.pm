# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Article::Chat;

use strict;
use warnings;

use parent 'Kernel::Output::HTML::Article::Base';

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Article::Base',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head2 ArticleFields()

Returns common article fields for a Chat article.

    my %ArticleFields = $LayoutObject->ArticleFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
    );

Returns:

    %ArticleFields = (
        Sender => {                     # mandatory
            Label => 'Sender',
            Value => 'John Doe',
            Prio  => 100,
        },
        Subject => {                    # mandatory
            Label => 'Subject',
            Value => 'Article subject',
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

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(
        %Param,
    );

    my $Sender;
    my $SenderRealname;

    if ( IsArrayRefWithData( $Article{ChatMessageList} ) ) {

        # Get ID and type of first person in conversation.
        if (
            IsHashRefWithData( $Article{ChatMessageList}->[0] )
            && $Article{ChatMessageList}->[0]->{ChatterType}
            )
        {

            # Get agent data.
            if ( $Article{ChatMessageList}->[0]->{ChatterType} eq 'User' ) {
                my %AgentData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                    UserID        => $Article{ChatMessageList}->[0]->{ChatterID},
                    NoOutOfOffice => 1,
                );
                $Sender         = "$AgentData{UserFullname} <$AgentData{UserEmail}>";
                $SenderRealname = $AgentData{UserFullname};
            }

            # Get customer data.
            elsif ( $Article{ChatMessageList}->[0]->{ChatterType} eq 'Customer' ) {
                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
                my %CustomerData       = $CustomerUserObject->CustomerUserDataGet(
                    User => $Article{ChatMessageList}->[0]->{ChatterID},
                );
                my $CustomerName = $CustomerUserObject->CustomerName(
                    UserLogin => $Article{ChatMessageList}->[0]->{ChatterID},
                );
                $Sender         = "$CustomerName <$CustomerData{UserEmail}>";
                $SenderRealname = $CustomerName;
            }
        }
    }

    my $SenderDisplayType = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::DefaultSenderDisplayType')
        || 'Realname';
    my $HiddenType = $SenderDisplayType eq 'Realname' ? 'Value' : 'Realname';

    my %Result = (
        Sender => {
            Label                => 'Sender',
            Value                => $Sender,
            Realname             => $SenderRealname,
            Prio                 => 100,
            $HiddenType . Hidden => 'Hidden',
        },
        Subject => {
            Label => 'Subject',
            Value => $Kernel::OM->Get('Kernel::Language')->Translate('Chat'),
            Prio  => 200,
        },
    );

    return %Result;
}

=head2 ArticlePreview()

Returns article preview for a Chat article.

    $LayoutObject->ArticlePreview(
        TicketID   => 123,     # (required)
        ArticleID  => 123,     # (required)
        ResultType => 'plain', # (optional) plain|HTML. Default HTML.
        MaxLength  => 50,      # (optional) performs trimming (for plain result only)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'John Doe [2017-06-08 15:46:51] Hello, world!';

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

    if ( $Param{MaxLength} && !IsPositiveInteger( $Param{MaxLength} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "MaxLength must be positive integer!"
        );

        return;
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(
        %Param,
        DynamicFields => 0,
    );

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'ArticleContent/Chat',
        Data         => {
            ChatMessages => $Article{ChatMessageList},
        },
    );

    if ( $Param{ResultType} && $Param{ResultType} eq 'plain' ) {

        $Result = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Result,
        );

        $Result =~ s{\n\s*\n}{\n}g;    # Remove extra new lines.
        $Result =~ s/[^\S\n]+/ /g;     # Remove extra spaces.

        if ( $Param{MaxLength} ) {

            # trim
            $Result = substr( $Result, 0, $Param{MaxLength} );
        }
    }

    return $Result;
}

=head2 ArticleCustomerRecipientsGet()

Get customer users from an article to use as recipients.

    my @CustomerUserIDs = $LayoutObject->ArticleCustomerRecipientsGet(
        TicketID  => 123,     # (required)
        ArticleID => 123,     # (required)
    );

Returns array of customer user IDs who should receive a message:

    @CustomerUserIDs = (
        'customer-1',
        'customer-2',
        ...
    );

=cut

sub ArticleCustomerRecipientsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Article = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param)->ArticleGet(%Param);
    return if !%Article;

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    my @CustomerUserIDs;

    CHAT_MESSAGE:
    for my $ChatMessage ( @{ $Article{ChatMessageList} // [] } ) {

        # Process all chat messages where the sender was a customer.
        next CHAT_MESSAGE if !$ChatMessage->{ChatterType} eq 'Customer';

        # Get single customer user from customer backend based on the ID address.
        my %CustomerSearch = $CustomerUserObject->CustomerSearch(
            UserLogin => $ChatMessage->{ChatterID},
            Limit     => 1,
        );
        next CHAT_MESSAGE if !%CustomerSearch;

        # Save customer user ID if not already present in the list.
        for my $CustomerUserID ( sort keys %CustomerSearch ) {
            push @CustomerUserIDs, $CustomerUserID if !grep { $_ eq $CustomerUserID } @CustomerUserIDs;
        }
    }

    return @CustomerUserIDs;
}

1;
