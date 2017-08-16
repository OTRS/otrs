# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CommunicationLog::Transport::Email;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::MailAccount',
);

=head1 NAME

Kernel::System::Ticket::CommunicationLog::Transport::Email

=head1 DESCRIPTION

This class provides functions to retrieve transport specific information.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 CommunicationAccountLinkGet()

Returns relative link information if AccountType and AccountID are present.

=cut

sub CommunicationAccountLinkGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{AccountID};

    return "Action=AdminMailAccount;Subaction=Update;ID=$Param{AccountID}";
}

=head2 CommunicationAccountLabelGet()

Returns related account label if AccountType and AccountID are present.

=cut

sub CommunicationAccountLabelGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{AccountType};
    return if !$Param{AccountID};

    my %MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGet(
        ID => $Param{AccountID},
    );

    return if !%MailAccount;

    my $Label = "$MailAccount{Host} / $MailAccount{Login} ($Param{AccountType})";

    return $Label;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
