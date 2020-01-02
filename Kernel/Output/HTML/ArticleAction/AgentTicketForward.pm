# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ArticleAction::AgentTicketForward;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
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

    if (
        $Param{ChannelName} eq 'Internal'
        && $Param{Article}->{SenderType} ne 'customer'
        )
    {

        # skip notes and notifications
        return;
    }

    if ( $Param{ChannelName} eq 'Email' && $Param{Article}->{SenderType} eq 'system' ) {

        # skip email notifications
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if module is registered
    return if !$ConfigObject->Get('Frontend::Module')->{AgentTicketForward};

    # check Acl
    return if !$Param{AclActionLookup}->{AgentTicketForward};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketForward');
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

    my @MenuItems;

    if ( IsHashRefWithData( $Param{StandardTemplates}->{Forward} ) ) {

        # get StandardResponsesStrg
        my %StandardForwardHash = %{ $Param{StandardTemplates}->{Forward} };

        # get revers @StandardForwardHash because we need to sort by Values
        # from %ReverseStandarForward we get value of Key by %StandardForwardHash Value
        # and @StandardForwardArray is created as array of hashes with elements Key and Value
        my %ReverseStandarForward = reverse %StandardForwardHash;

        my @StandardForwardArray = map {
            {
                Key   => $ReverseStandarForward{$_},
                Value => $_
            }
        } sort values %StandardForwardHash;

        # build HTML string
        my $StandardForwardsStrg = $LayoutObject->BuildSelection(
            Name         => 'ForwardTemplateID',
            ID           => 'ForwardTemplateID',
            Class        => 'Modernize Small',
            Data         => \@StandardForwardArray,
            PossibleNone => 1
        );

        push @MenuItems, {
            ItemType             => 'Dropdown',
            DropdownType         => 'Forward',
            StandardForwardsStrg => $StandardForwardsStrg,
            Name                 => Translatable('Forward'),
            Class                => 'AsPopup PopupType_TicketAction',
            Action               => 'AgentTicketForward',
            FormID               => 'Forward' . $Param{Article}->{ArticleID},
            ForwardElementID     => 'ForwardTemplateID',
            Type                 => $Param{Type},
        };
    }
    else {

        push @MenuItems, {
            ItemType    => 'Link',
            Description => Translatable('Forward article via mail'),
            Name        => Translatable('Forward'),
            Class       => 'AsPopup PopupType_TicketAction',
            Link =>
                "Action=AgentTicketForward;TicketID=$Param{Ticket}->{TicketID};ArticleID=$Param{Article}->{ArticleID}"
        };
    }

    return @MenuItems;
}

1;
