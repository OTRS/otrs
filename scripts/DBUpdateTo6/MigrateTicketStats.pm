# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketStats;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketStats - Migrate ticket stats to new ticket search article field names.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Process all affected article fields in stat restriction parameters.
    my %SearchParamMap = (
        Body    => 'MIMEBase_Body',
        Cc      => 'MIMEBase_Cc',
        From    => 'MIMEBase_From',
        Subject => 'MIMEBase_Subject',
        To      => 'MIMEBase_To',
    );

    # Change parameters directly in the database, since at this point in migration not all used ticket statistic
    #   modules might be available.
    for my $SearchParam ( sort keys %SearchParamMap ) {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT xml_key, xml_content_key
                FROM xml_storage
                WHERE xml_type = ? AND xml_content_key LIKE ? AND xml_content_value = ?
            ',
            Bind => [
                \'Stats',
                \"[0]{'otrs_stats'}[1]{'UseAsRestriction'}[%]{'Element'}",
                \$SearchParam,
            ],
        );

        my %Update;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Update{ $Row[0] } = $Row[1];
        }

        for my $XMLKey ( sort keys %Update ) {
            return if !$DBObject->Prepare(
                SQL => '
                    UPDATE xml_storage
                    SET xml_content_value = ?
                    WHERE xml_type = ? AND xml_key = ? AND xml_content_key = ?
                ',
                Bind => [
                    \$SearchParamMap{$SearchParam},
                    \'Stats',
                    \$XMLKey,
                    \$Update{$XMLKey},
                ],
            );
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
