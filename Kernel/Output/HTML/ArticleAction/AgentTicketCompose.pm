# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ArticleAction::AgentTicketCompose;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

# optional AclActionLookup
sub CheckAccess {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( $Param{ChannelName} eq 'Email' && $Param{Article}->{SenderType} eq 'system' ) {

        # skip email notifications
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if module is registered
    return if !$ConfigObject->Get('Frontend::Module')->{AgentTicketCompose};

    # check Acl
    return if !$Param{AclActionLookup}->{AgentTicketCompose};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketCompose');
    if ( $Config->{Permission} ) {
        my $Ok = $TicketObject->TicketPermission(
            Type     => $Config->{Permission},
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Param{UserID},
            LogNo    => 1,
        );
        return if !$Ok;
    }
    if ( $Config->{RequiredLock} ) {
        my $Locked = $TicketObject->TicketLockGet(
            TicketID => $Param{Ticket}->{TicketID}
        );
        if ($Locked) {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Param{Ticket}->{TicketID},
                OwnerID  => $Param{UserID},
            );
            return if !$AccessOk;
        }
    }

    return 1;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Ticket Article StandardTemplates Type UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get StandardResponsesStrg
    # my %StandardResponseHash = %{ $Param{StandardResponses} || {} };
    my %StandardResponseHash = %{ $Param{StandardTemplates}->{Answer} || {} };

    # get revers StandardResponseHash because we need to sort by Values
    # from %ReverseStandardResponseHash we get value of Key by %StandardResponseHash Value
    # and @StandardResponseArray is created as array of hashes with elements Key and Value

    my %ReverseStandardResponseHash = reverse %StandardResponseHash;
    my @StandardResponseArray       = map {
        {
            Key   => $ReverseStandardResponseHash{$_},
            Value => $_
        }
    } sort values %StandardResponseHash;

    # use this array twice (also for Reply All), so copy it first
    my @StandardResponseArrayReplyAll = @StandardResponseArray;

    # build HTML string
    my $StandardResponsesStrg = $LayoutObject->BuildSelection(
        Name         => 'ResponseID',
        ID           => 'ResponseID' . $Param{Article}->{ArticleID},
        Class        => 'Modernize Small',
        Data         => \@StandardResponseArray,
        PossibleNone => 1,
    );

    my @MenuItems;

    push @MenuItems, {
        ItemType              => 'Dropdown',
        DropdownType          => 'Reply',
        StandardResponsesStrg => $StandardResponsesStrg,
        Name                  => Translatable('Reply'),
        Class                 => 'AsPopup PopupType_TicketAction',
        Action                => 'AgentTicketCompose',
        FormID                => 'Reply' . $Param{Article}->{ArticleID},
        ResponseElementID     => 'ResponseID' . $Param{Article}->{ArticleID},
        Type                  => $Param{Type},
    };

    # check if reply all is needed
    my $Recipients = '';
    KEY:
    for my $Key (qw(From To Cc)) {
        next KEY if !$Param{Article}->{$Key};
        if ($Recipients) {
            $Recipients .= ', ';
        }
        $Recipients .= $Param{Article}->{$Key};
    }
    my $RecipientCount = 0;
    if ($Recipients) {
        my $EmailParser = Kernel::System::EmailParser->new(
            %{$Self},
            Mode => 'Standalone',
        );
        my @Addresses = $EmailParser->SplitAddressLine( Line => $Recipients );
        ADDRESS:
        for my $Address (@Addresses) {
            my $Email = $EmailParser->GetEmailAddress( Email => $Address );
            next ADDRESS if !$Email;
            my $IsLocal = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
                Address => $Email,
            );
            next ADDRESS if $IsLocal;
            $RecipientCount++;
        }
    }
    if ( $RecipientCount > 1 ) {

        $StandardResponsesStrg = $LayoutObject->BuildSelection(
            Name         => 'ResponseID',
            ID           => 'ResponseIDAll' . $Param{Article}->{ArticleID},
            Class        => 'Modernize Small',
            Data         => \@StandardResponseArrayReplyAll,
            PossibleNone => 1,
        );

        push @MenuItems, {
            ItemType              => 'Dropdown',
            DropdownType          => 'Reply',
            StandardResponsesStrg => $StandardResponsesStrg,
            Name                  => Translatable('Reply All'),
            Class                 => 'AsPopup PopupType_TicketAction',
            Action                => 'AgentTicketCompose',
            FormID                => 'ReplyAll' . $Param{Article}->{ArticleID},
            ReplyAll              => 1,
            ResponseElementID     => 'ResponseIDAll' . $Param{Article}->{ArticleID},
            Type                  => $Param{Type},
        };
    }

    return @MenuItems;
}

1;
