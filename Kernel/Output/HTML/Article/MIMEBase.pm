# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Article::MIMEBase;

use strict;
use warnings;

use parent 'Kernel::Output::HTML::Article::Base';

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
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

Returns common article fields for a MIMEBase article.

    my %ArticleFields = $MIMEBaseObject->ArticleFields(
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
        PGP => {
            Label => 'PGP',             # mandatory
            Value => 'Value',           # mandatory
            Class => 'Class',           # optional
            ...
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

    my %Result;

    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        %Param,
        DynamicFields => 1,
        RealNames     => 1,
    );

    # cleanup subject
    $Article{Subject} = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSubjectClean(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => $Article{Subject} || '',
        Size         => 0,
    );

    $Result{Subject} = {
        Label => 'Subject',
        Value => $Article{Subject},
    };

    # run article view modules
    my $Config = $ConfigObject->Get('Ticket::Frontend::ArticleViewModule');

    if ( ref $Config eq 'HASH' ) {
        my %Jobs = %{$Config};

        JOB:
        for my $Job ( sort keys %Jobs ) {

            # load module
            next JOB if !$MainObject->Require( $Jobs{$Job}->{Module} );

            my $Object = $Jobs{$Job}->{Module}->new(
                TicketID  => $Self->{TicketID},
                ArticleID => $Param{ArticleID},
                UserID    => $Param{UserID},
            );

            # run module
            my @Data = $Object->Check(
                Article => \%Article,
                %Ticket, Config => $Jobs{$Job}
            );
            for my $DataRef (@Data) {
                if ( !$DataRef->{Successful} ) {
                    $DataRef->{Result} = 'Error';
                }
                else {
                    $DataRef->{Result} = 'Notice';
                }

                $Result{ $DataRef->{Key} } = {
                    Label => $DataRef->{Key},
                    Value => $DataRef->{Value},
                    Class => $DataRef->{Result},
                };

                for my $Warning ( @{ $DataRef->{Warnings} } ) {
                    $Result{ $DataRef->{Key} } = {
                        Label => $Warning->{Key},
                        Value => $Warning->{Value},
                        Class => $Warning->{Result},
                    };
                }
            }

            # TODO: Check how to implement this.
            # # filter option
            # $Object->Filter(
            #     Article => \%Article,
            #     %Ticket, Config => $Jobs{$Job}
            # );
        }
    }

    # TODO: RowData is not used anywhere? Check block in the TT.

    # do some strips && quoting
    my $RecipientDisplayType = $ConfigObject->Get('Ticket::Frontend::DefaultRecipientDisplayType') || 'Realname';
    my $SenderDisplayType    = $ConfigObject->Get('Ticket::Frontend::DefaultSenderDisplayType')    || 'Realname';
    KEY:
    for my $Key (qw(From To Cc)) {
        next KEY if !$Article{$Key};

        my $DisplayType = $Key eq 'From'             ? $SenderDisplayType : $RecipientDisplayType;
        my $HiddenType  = $DisplayType eq 'Realname' ? 'Value'            : 'Realname';
        $Result{$Key} = {
            Label                => $Key,
            Value                => $Article{$Key},
            Realname             => $Article{ $Key . 'Realname' },
            ArticleID            => $Article{ArticleID},
            $HiddenType . Hidden => 'Hidden',
        };
        if ( $Key eq 'From' ) {
            $Result{Sender} = {
                Label                => Translatable('Sender'),
                Value                => $Article{From},
                Realname             => $Article{FromRealname},
                $HiddenType . Hidden => 'Hidden',
                }
        }
    }

    # Assign priority.
    my $Priority = 100;
    for my $Key (qw(From To Cc)) {
        if ( $Result{$Key} ) {
            $Result{$Key}->{Prio} = $Priority;
            $Priority += 100;
        }
    }

    my @FieldsWithoutPrio = grep { !$Result{$_}->{Prio} } keys %Result;

    for my $Key (@FieldsWithoutPrio) {
        $Result{$Key}->{Prio} = 100000;
    }

    return %Result;
}

=head2 ArticlePreview()

Returns article preview for a MIMEBase article.

    $ArticleBaseObject->ArticlePreview(
        TicketID    => 123,     # (required)
        ArticleID   => 123,     # (required)
        ResultType  => 'plain', # (optional) plain|HTML. Default HTML.
        MaxLength   => 50,      # (optional) performs trimming (for plain result only)
        UserID      => 123,     # (required)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'Hello, world!';

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

    my $Result;

    if ( $Param{ResultType} && $Param{ResultType} eq 'plain' ) {

        # plain
        $Result = $Article{Body};

        if ( $Param{MaxLength} ) {

            # trim
            $Result = substr( $Result, 0, $Param{MaxLength} );
        }
    }
    else {
        my $HTMLBodyAttachmentID = $Self->HTMLBodyAttachmentIDGet(%Param);

        if ($HTMLBodyAttachmentID) {

            # Preview doesn't include inline images...
            my %Data = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $Param{ArticleID},
                FileID    => $HTMLBodyAttachmentID,
                UserID    => $Param{UserID},
            );

            $Result = $Data{Content};
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "HTML attachment can't be found (TicketID=$Param{TicketID}, ArticleID=$Param{ArticleID})!",
            );
        }
    }

    return $Result;
}

=head2 HTMLBodyAttachmentIDGet()

Returns HTMLBodyAttachmentID.

    my $HTMLBodyAttachmentID = $ArticleBaseObject->HTMLBodyAttachmentIDGet(
        TicketID    => 123,     # (required)
        ArticleID   => 123,     # (required)
        UserID      => 123,     # (required)
    );

Returns

    $HTMLBodyAttachmentID = 23;

=cut

sub HTMLBodyAttachmentIDGet {
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

    # Get a HTML attachment.
    my %AttachmentIndexHTMLBody = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID    => $Param{ArticleID},
        OnlyHTMLBody => 1,
        UserID       => $Param{UserID},
    );

    my ($HTMLBodyAttachmentID) = sort keys %AttachmentIndexHTMLBody;

    return $HTMLBodyAttachmentID;
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
        else {
            # TODO: Review if it's needed.
        }
    }

    # sort

    return @Actions;
}

1;
