# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::ArticleAction::AgentTicketPlain;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

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

    # check basic conditions
    if ( $Param{ChannelName} ne 'Email' ) {
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if module is registered
    return if !$ConfigObject->Get('Frontend::Module')->{AgentTicketPlain};
    return if !$ConfigObject->Get('Ticket::Frontend::PlainView');

    # check Acl
    return if !$Param{AclActionLookup}->{AgentTicketPlain};

    my $Ok = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $Param{Ticket}->{TicketID},
        UserID   => $Param{UserID},
        LogNo    => 1,
    );
    return if !$Ok;

    return 1;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
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
        Description => Translatable('View the source for this Article'),
        Name        => Translatable('Plain Format'),
        Class       => 'AsPopup PopupType_TicketAction',
        Link =>
            "Action=AgentTicketPlain;TicketID=$Param{Ticket}->{TicketID};ArticleID=$Param{Article}->{ArticleID}",
    );

    return ( \%MenuItem );
}

1;
