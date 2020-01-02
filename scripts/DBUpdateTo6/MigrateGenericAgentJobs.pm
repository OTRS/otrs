# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateGenericAgentJobs;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateGenericAgentJobs - Migrate GA job configurations to new ticket search article field names.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Rename old-style article fields in generic agent job definitions.
    return if !$Self->_MigrateOldStyleArticleFields();

    # Change ArticleType data to IsVisibleForAgent in postmaster+filter table.
    return if !$Self->_MigrateArticleTypeToIsVisibleForCustomer();

    return 1;
}

=head2 _MigrateOldStyleArticleFields()

Rename old-style article fields in generic agent job definitions.

    my $Result = $DBUpdateTo6Object->_MigrateOldStyleArticleFields(
        Data => \@OldData,  # Old structure content
    );

Returns 1 on success.

=cut

sub _MigrateOldStyleArticleFields {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Rename old-style article fields in search parameters.
    my %KeyMap = (
        Body    => 'MIMEBase_Body',
        Cc      => 'MIMEBase_Cc',
        From    => 'MIMEBase_From',
        Subject => 'MIMEBase_Subject',
        To      => 'MIMEBase_To',
    );

    KEY:
    for my $OldKey ( sort keys %KeyMap ) {
        my @Data;

        next KEY if !$DBObject->Prepare(
            SQL => 'SELECT DISTINCT job_key
                FROM generic_agent_jobs
                WHERE job_key = ?
            ',
            Bind => [ \$OldKey ],
        );

        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {
            next ROW if !$Row[0];

            my %CurrentRow = (
                OldKey => $OldKey,
                Key    => $KeyMap{$OldKey},
            );
            push @Data, \%CurrentRow;
        }
        next KEY if !@Data;

        my $MigrationResult = $Self->_MigrateData(
            Data => \@Data,
        );

        if ( !$MigrationResult ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "An error occurred during data migration for: $OldKey!",
            );
            return;
        }
    }

    return 1;
}

=head2 _MigrateArticleTypeToIsVisibleForCustomer()

Change ArticleType data to IsVisibleForAgent in postmaster+filter table.

Returns 1 on success.

=cut

sub _MigrateArticleTypeToIsVisibleForCustomer {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get the needed ArticleTypeMapping from a YML file
    my $TaskConfig         = $Self->GetTaskConfig( Module => 'MigrateArticleData' );
    my %ArticleTypeMapping = %{ $TaskConfig->{ArticleTypeMapping} };

    GABTABLE:
    for my $Field (qw(NewArticleType NewNoteArticleType)) {

        next GABTABLE if !$DBObject->Prepare(
            SQL => '
                SELECT job_name, job_key, job_value
                FROM generic_agent_jobs
                WHERE job_key = ?
                ORDER BY job_name ASC
            ',
            Bind => [ \$Field ],
        );

        my $NewKeyValue;
        if ( $Field eq 'NewArticleType' ) {
            $NewKeyValue = 'NewIsVisibleForCustomer';
        }
        else {
            $NewKeyValue = 'NewNoteIsVisibleForCustomer';
        }

        my @Data;

        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            my $JobName  = $Row[0];
            my $JobKey   = $Row[1];
            my $JobValue = $Row[2];

            next ROW if !$JobKey;

            # Map visible for customer.
            my $IsVisibleForCustomer = $ArticleTypeMapping{$JobValue}->{Visible} || 0;

            my %CurrentRow = (
                Name   => $JobName,
                OldKey => $Field,
                Key    => $NewKeyValue,
                Value  => $IsVisibleForCustomer,
            );
            push @Data, \%CurrentRow;
        }

        # No data means migration is not needed.
        next GABTABLE if !@Data;

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

Perform DB changes.

Returns 1 on success.

=cut

sub _MigrateData {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    if ( ref $Param{Data} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Data must be an array reference!',
        );
        return;
    }

    if ( !@{ $Param{Data} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Data array must not be empty!',
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Data ( @{ $Param{Data} } ) {

        if ( defined $Data->{Name} ) {
            return if !$DBObject->Do(
                SQL => '
                    UPDATE generic_agent_jobs
                    SET job_key = ?,
                        job_value = ?
                    WHERE job_name = ?
                    AND job_key = ?
                ',
                Bind => [
                    \$Data->{Key},
                    \$Data->{Value},
                    \$Data->{Name},
                    \$Data->{OldKey},
                ],
            );
        }
        else {
            return if !$DBObject->Do(
                SQL => '
                    UPDATE generic_agent_jobs
                    SET job_key = ?
                    WHERE job_key = ?
                ',
                Bind => [
                    \$Data->{Key},
                    \$Data->{OldKey},
                ],
            );
        }
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
