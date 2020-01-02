# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::CustomerTicketPrint;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Check needed stuff.
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need TicketID!'),
        );
    }

    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Check permissions.
    my $Access = $TicketObject->TicketCustomerPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );

    # No permission, do not show ticket.
    return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' ) if !$Access;

    # Get ACL restrictions.
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data           => \%PossibleActions,
        Action         => $Self->{Action},
        TicketID       => $Self->{TicketID},
        ReturnType     => 'Action',
        ReturnSubType  => '-',
        CustomerUserID => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # Check if ACL restrictions exist.
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # Show error screen if ACL prohibits this action.
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
        }
    }

    # Get ticket data.
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 0,
    );

    # Assemble file name.
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Filename       = sprintf(
        'Ticket_%s_%s.pdf',
        $Ticket{TicketNumber},
        $DateTimeObject->Format( Format => '%Y-%m-%d_%H-%M' ),
    );

    # Return PDF document.
    my $PDFString = $Kernel::OM->Get('Kernel::Output::PDF::Ticket')->GeneratePDF(
        TicketID  => $Self->{TicketID},
        UserID    => $Self->{UserID},
        Interface => 'Customer',
    );

    return $LayoutObject->Attachment(
        Filename    => $Filename,
        ContentType => 'application/pdf',
        Content     => $PDFString,
        Type        => 'inline',
    );
}

1;
