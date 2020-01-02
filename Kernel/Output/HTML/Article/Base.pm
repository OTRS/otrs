# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Article::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Queue',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleFields()

Returns article fields for specific article backend.

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
        DynamicField_Item => {          # optional
            Label => 'Item',
            Value => 'Value',
            Prio  => 300,
        },
        ...
    );

=cut

sub ArticleFields {
    die 'Virtual method in base class must not be called.';
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
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleActions()

Returns article actions for current channel, based on registration in the config.

    my @Actions = $LayoutObject->ArticleActions(
        TicketID    => 123,      # (required)
        ArticleID   => 123,      # (required)
        UserID      => 1,        # (required)
        Type        => 'Static', # (required) Static or OnLoad
    );

Returns an array of hashes for every single action that should be displayed:

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

    for my $Needed (qw(TicketID ArticleID Type UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my @Actions;

    # Get article data.
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # Determine channel name for this Article.
    my $ChannelName = $ArticleBackendObject->ChannelNameGet();

    my $ActionsConfig = $ConfigObject->Get('Ticket::Frontend::Article::Actions');

    my $Config = {};
    if ( IsHashRefWithData($ActionsConfig) ) {
        $Config = $ActionsConfig->{$ChannelName};
    }
    return () if !$Config;

    # Get ACL restrictions.
    my %PossibleActions;
    my $Counter = 0;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Get all registered actions.
    if ( ref $ConfigObject->Get('Frontend::Module') eq 'HASH' ) {

        my %Actions = %{ $ConfigObject->Get('Frontend::Module') };

        # Only use those actions that start with 'Agent'.
        %PossibleActions = map { ++$Counter => $_ }
            grep { substr( $_, 0, length 'Agent' ) eq 'Agent' }
            sort keys %Actions;
    }

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => 'AgentTicketZoom',
        TicketID      => $Param{Ticket}->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Param{UserID},
    );

    my %AclAction = %PossibleActions;
    if ($ACL) {
        %AclAction = $TicketObject->TicketAclActionData();
    }

    my %AclActionLookup = reverse %AclAction;

    # Get ticket attributes.
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    my $BackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);
    my %Article       = $BackendObject->ArticleGet(%Param);

    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
        QueueID       => $Ticket{QueueID},
        TemplateTypes => 1,
        Valid         => 1,
    );

    ACTION:
    for my $Action ( sort { $Config->{$a}->{Prio} <=> $Config->{$b}->{Prio} } keys %{$Config} ) {
        next ACTION if !$Config->{$Action}->{Valid};

        if ( $Config->{$Action}->{Module} ) {
            my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                $Config->{$Action}->{Module},
                Silent => 1,
            );
            next ACTION if !$Loaded;

            my $ModuleObject = $Kernel::OM->Get( $Config->{$Action}->{Module} );

            # Check access.
            next ACTION if !$ModuleObject->CheckAccess(
                Ticket          => \%Ticket,
                Article         => \%Article,
                ChannelName     => $ChannelName,
                AclActionLookup => \%AclActionLookup,
                UserID          => $Param{UserID},
            );

            my @ActionConfig = $ModuleObject->GetConfig(
                Ticket            => \%Ticket,
                Article           => \%Article,
                StandardTemplates => \%StandardTemplates,
                UserID            => $Param{UserID},
                Type              => $Param{Type},
            );

            push @Actions, @ActionConfig;
        }
    }

    return @Actions;
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
    die 'Virtual method in base class must not be called.';
}

1;
