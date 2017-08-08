# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CommunicationLog::LogModule::Email;

use strict;
use warnings;

use parent qw(Kernel::System::CommunicationLog::LogModule::Base);

our @ObjectDependencies = (
    'Kernel::System::MailAccount',
);

=head1 NAME

Kernel::System::Ticket::CommunicationLog::LogModule::Test - log module class for mail transport

=head1 DESCRIPTION

This class provides functions to log test module related information.

Inherits from L<Kernel::System::CommunicationLog::LogModule::Base>, please have a look there for its API.

=cut

=head2 ObjectAccountLinkGet()

Returns relative link information if AccountType and AccountID are present.

=cut

sub ObjectAccountLinkGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{AccountID};

    return "Action=AdminMailAccount;Subaction=Update;ID=$Param{AccountID}";
}

=head2 ObjectAccountLabelGet()

Returns related account label if AccountType and AccountID are present.

=cut

sub ObjectAccountLabelGet {
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
