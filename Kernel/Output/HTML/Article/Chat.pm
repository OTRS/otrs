# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
    'Kernel::System::Main',
    'Kernel::System::Queue',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head2 ArticleFields()

Returns common article fields for a Chat article.

    my %ArticleFields = $ChatObject->ArticleFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
        UserID    => 123,   # (required)
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
    for my $Needed (qw(TicketID ArticleID UserID)) {
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

    $ArticleBaseObject->ArticlePreview(
        TicketID    => 123,     # (required)
        ArticleID   => 123,     # (required)
        ResultType  => 'plain', # (optional) plain|HTML. Default HTML.
        MaxLength   => 50,      # (optional) performs trimming (for plain result only)
        UserID      => 123,     # (required)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'John Doe [2017-06-08 15:46:51] Hello, world!';

=cut

sub ArticlePreview {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID UserID)) {
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

=head2 ArticleActions()

Returns article actions.

    my @Actions = $ArticleBaseObject->ArticleActions(
        TicketID    => 123,      # (required)
        ArticleID   => 123,      # (required)
        UserID      => 1,        # (required)
        Type        => 'Static', # (required) Static or OnLoad
    );

Returns:
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
    for my $Needed (qw(TicketID ArticleID Type UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my @Actions;

    my $ActionsConfig = $ConfigObject->Get('Ticket::Frontend::Article::Actions');

    my $Config = {};
    if ( IsHashRefWithData($ActionsConfig) ) {
        $Config = $ActionsConfig->{Chat};
    }
    return () if !$Config;

    # get ACL restrictions
    my %PossibleActions;
    my $Counter = 0;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get all registered Actions
    if ( ref $ConfigObject->Get('Frontend::Module') eq 'HASH' ) {

        my %Actions = %{ $ConfigObject->Get('Frontend::Module') };

        # only use those Actions that stats with Agent
        %PossibleActions = map { ++$Counter => $_ }
            grep { substr( $_, 0, length 'Agent' ) eq 'Agent' }
            sort keys %Actions;
    }

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => 'AgentTicketZoom',            # TODO: review. $Self->{Action},
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

    # get ticket attributes
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
                Silent => 1,    # TODO: Remove later
            );
            next ACTION if !$Loaded;

            my $ModuleObject = $Kernel::OM->Get( $Config->{$Action}->{Module} );

            # check access
            next ACTION if !$ModuleObject->CheckAccess(
                Ticket          => \%Ticket,
                Article         => \%Article,
                ChannelName     => 'Chat',
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
        else {
            # TODO: Review if it's needed.
        }
    }

    # sort

    return @Actions;
}

1;
