# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::PostMaster::LoopProtection::DB;

use strict;
use warnings;

use parent 'Kernel::System::PostMaster::LoopProtectionCommon';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
);

sub SendEmail {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $To = $Param{To} || return;

    # insert log
    return if !$DBObject->Do(
        SQL => "INSERT INTO ticket_loop_protection (sent_to, sent_date)"
            . " VALUES ('"
            . $DBObject->Quote($To)
            . "', '$Self->{LoopProtectionDate}')",
    );

    # delete old enrties
    return if !$DBObject->Do(
        SQL => "DELETE FROM ticket_loop_protection WHERE "
            . " sent_date != '$Self->{LoopProtectionDate}'",
    );

    return 1;
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $To    = $Param{To} || return;
    my $Count = 0;

    # check existing logfile
    my $SQL = "SELECT count(*) FROM ticket_loop_protection "
        . " WHERE sent_to = '" . $DBObject->Quote($To) . "' AND "
        . " sent_date = '$Self->{LoopProtectionDate}'";

    $DBObject->Prepare( SQL => $SQL );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }

    my $Max = $Self->{PostmasterMaxEmailsPerAddress}{ lc $To } // $Self->{PostmasterMaxEmails};

    # check possible loop
    if ( $Max && $Count >= $Max ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "LoopProtection: send no more emails to '$To'! Max. count of $Self->{PostmasterMaxEmails} has been reached!",
        );
        return;
    }

    return 1;
}

1;
