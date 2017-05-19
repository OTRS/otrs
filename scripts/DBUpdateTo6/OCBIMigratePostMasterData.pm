# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::OCBIMigratePostMasterData;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::XML',
    'Kernel::System::YAML'
);

=head1 NAME

scripts::DBUpdateTo6::OCBIMigratePostMasterData -  Migrate PostMaster data.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    PFTABLE:
    for my $Field (qw(X-OTRS-ArticleType X-OTRS-FollowUp-ArticleType)) {

        next PFTABLE if !$DBObject->Prepare(
            SQL => "
                SELECT f_name, f_key, f_value
                FROM postmaster_filter
                WHERE f_key = ?
                ORDER BY f_name ASC
            ",
            Bind => [ \$Field ],
        );

        my $NewKeyValue = (
            $Field eq 'X-OTRS-ArticleType' ? 'X-OTRS-IsVisibleForCustomer' : 'X-OTRS-FollowUp-IsVisibleForCustomer'
        );
        my @Data;

        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            next ROW if !$Row[1];

            # Map visible for customer.
            my $IsVisibleForCustomer = 0;
            if ( $Row[2] =~ /(-ext|phone|fax|sms|webrequest)/i ) {
                $IsVisibleForCustomer = 1;
            }

            my %CurrentRow = (
                Name   => $Row[0],
                OldKey => $Field,
                Key    => $NewKeyValue,
                Value  => $IsVisibleForCustomer
            );
            push @Data, \%CurrentRow;
        }

        # No data means migration is not needed.
        next PFTABLE if !@Data;

        my $MigrationResult = $Self->_MigrateData(
            Data => \@Data,
        );

        if ( !$MigrationResult ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "An error occurs during data migration for: $Field!",
            );
            return;
        }
    }

    return 1;
}

=head2 _MigrateData()

Change ArticleType data to IsVisibleForAgent in postmaster+filter table. Returns 1 on success

    my $Result = $DBUpdateTo6Object->_MigrateData(
        Data => \@OldArticleData, # Old structure content
    );

=cut

sub _MigrateData {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data!",
        );
        return;
    }

    # Check needed stuff.
    if ( ref $Param{Data} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data must be an array reference!",
        );
        return;
    }

    if ( !@{ $Param{Data} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data array must not be empty!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Data ( @{ $Param{Data} } ) {

        return if !$DBObject->Do(
            SQL => "
                UPDATE postmaster_filter
                SET f_key = ?, f_value = ?
                WHERE f_name = ? and f_key = ?
            ",
            Bind => [
                \$Data->{Key}, \$Data->{Value}, \$Data->{Name}, \$Data->{OldKey},
            ],
        );
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
