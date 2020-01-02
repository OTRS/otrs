# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ArticleAction::AgentTicketEmailResend;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub CheckAccess {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check basic conditions.
    if ( $Param{ChannelName} ne 'Email' ) {
        return;
    }

    # Check previous article transmission status.
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        %{ $Param{Article} },
    );
    my $TransmissionStatus = $ArticleBackendObject->ArticleTransmissionStatus(
        ArticleID => $Param{Article}->{ArticleID},
    );
    return if !IsHashRefWithData($TransmissionStatus);

    # Only show resend action if previous transmission failed.
    if (
        $TransmissionStatus->{Status}
        && $TransmissionStatus->{Status} ne 'Failed'
        )
    {
        return;
    }

    my $ActionName = 'AgentTicketEmailResend';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if module is registered.
    return if !$ConfigObject->Get('Frontend::Module')->{$ActionName};

    # Check ACLs.
    return if !$Param{AclActionLookup}->{$ActionName};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Config = $ConfigObject->Get("Ticket::Frontend::$ActionName");
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

    for my $Needed (qw(Ticket Article UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %MenuItem = (
        ItemType    => 'Link',
        Description => Translatable('Resend this article'),
        Name        => Translatable('Resend'),
        Class       => 'AsPopup PopupType_TicketAction',
        Link =>
            "Action=AgentTicketEmailResend;TicketID=$Param{Ticket}->{TicketID};ArticleID=$Param{Article}->{ArticleID}",
    );

    return ( \%MenuItem );
}

1;
