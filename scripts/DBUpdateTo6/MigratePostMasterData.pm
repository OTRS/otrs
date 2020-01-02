# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigratePostMasterData;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::MigratePostMasterData -  Migrate PostMaster data.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get the needed ArticleTypeMapping from a YML file
    my $TaskConfig         = $Self->GetTaskConfig( Module => 'MigrateArticleData' );
    my %ArticleTypeMapping = %{ $TaskConfig->{ArticleTypeMapping} };

    PFTABLE:
    for my $Field (qw(X-OTRS-ArticleType X-OTRS-FollowUp-ArticleType)) {

        next PFTABLE if !$DBObject->Prepare(
            SQL => 'SELECT f_name, f_key, f_value
                FROM postmaster_filter
                WHERE f_key = ?
                ORDER BY f_name ASC',
            Bind => [ \$Field ],
        );

        my $NewKeyValue;
        if ( $Field eq 'X-OTRS-ArticleType' ) {
            $NewKeyValue = 'X-OTRS-IsVisibleForCustomer';
        }
        else {
            $NewKeyValue = 'X-OTRS-FollowUp-IsVisibleForCustomer';
        }

        my @Data;

        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            my $FilterName  = $Row[0];
            my $FilterKey   = $Row[1];
            my $FilterValue = $Row[2];

            next ROW if !$FilterKey;

            # Map visible for customer.
            my $IsVisibleForCustomer = $ArticleTypeMapping{$FilterValue}->{Visible} || 0;

            my %CurrentRow = (
                Name   => $FilterName,
                OldKey => $Field,
                Key    => $NewKeyValue,
                Value  => $IsVisibleForCustomer,
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
            SQL => 'UPDATE postmaster_filter
                SET f_key = ?,
                    f_value = ?
                WHERE f_name = ?
                AND f_key = ?',
            Bind => [
                \$Data->{Key},
                \$Data->{Value},
                \$Data->{Name},
                \$Data->{OldKey},
            ],
        );
    }

    return 1;
}

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    # try to get the needed ArticleTypeMapping from a YML file
    my $TaskConfig = $Self->GetTaskConfig( Module => 'MigrateArticleData' );
    return if !$TaskConfig;

    my %ArticleTypeMapping = %{ $TaskConfig->{ArticleTypeMapping} };
    return if !%ArticleTypeMapping;

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
