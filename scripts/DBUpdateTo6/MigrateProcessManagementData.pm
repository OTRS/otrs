# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateProcessManagementData;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::YAML',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateProcessManagementData -  Migrate process management data to set 'visible for customer' and  'communication channel' values.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    # get the needed ArticleTypeMapping from a YML file
    my $TaskConfig         = $Self->GetTaskConfig( Module => 'MigrateArticleData' );
    my %ArticleTypeMapping = %{ $TaskConfig->{ArticleTypeMapping} };

    PMTABLE:
    for my $Table (qw(pm_transition_action pm_activity_dialog)) {

        next PMTABLE if !$DBObject->Prepare(
            SQL => "SELECT id, config
                FROM $Table
                ORDER BY id ASC",
        );

        my @Data;

        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            my $Config = $YAMLObject->Load( Data => $Row[1] );

            if (
                !$Config->{Config}->{ArticleType}
                && !$Config->{Fields}->{Article}->{Config}->{ArticleType}
                )
            {
                next ROW;
            }

            if ( $Table eq 'pm_transition_action' ) {

                my $IsVisibleForCustomer = $ArticleTypeMapping{ $Config->{Config}->{ArticleType} }->{Visible} || 0;
                my $CommunicationChannel
                    = $ArticleTypeMapping{ $Config->{Config}->{ArticleType} }->{Channel} || 'Internal';

                $Config->{Config}->{IsVisibleForCustomer} = $IsVisibleForCustomer;
                $Config->{Config}->{CommunicationChannel} = $CommunicationChannel;

                delete $Config->{Config}->{ArticleType};
            }

            elsif ( $Table eq 'pm_activity_dialog' ) {

                my $IsVisibleForCustomer
                    = $ArticleTypeMapping{ $Config->{Fields}->{Article}->{Config}->{ArticleType} }->{Visible} || 0;
                my $CommunicationChannel
                    = $ArticleTypeMapping{ $Config->{Fields}->{Article}->{Config}->{ArticleType} }->{Channel}
                    || 'Internal';

                $Config->{Fields}->{Article}->{Config}->{IsVisibleForCustomer} = $IsVisibleForCustomer;
                $Config->{Fields}->{Article}->{Config}->{CommunicationChannel} = $CommunicationChannel;

                delete $Config->{Fields}->{Article}->{Config}->{ArticleType};
            }

            my %CurrentRow = (
                ID     => $Row[0],
                Config => $Config,
            );
            push @Data, \%CurrentRow;
        }

        # No data means migration is not needed.
        next PMTABLE if !@Data;

        my $MigrationResult = $Self->_MigrateData(
            Data  => \@Data,
            Table => $Table,
        );

        if ( !$MigrationResult ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "An error occured during data migration for: $Table!",
            );
            return;
        }
    }

    return 1;
}

=head2 _MigrateData()

Migrates the config for process management data.

    my $Result = $DBUpdateTo6Object->_MigrateData(
        Data => \@Data,
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

    if ( !defined $Param{Table} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Table!",
        );
        return;
    }

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    for my $Data ( @{ $Param{Data} } ) {

        # Dump config as string.
        my $Config = $YAMLObject->Dump( Data => $Data->{Config} );

        return if !$DBObject->Do(
            SQL => "
                UPDATE $Param{Table}
                SET config = ?
                WHERE id = ?
            ",
            Bind => [
                \$Config,
                \$Data->{ID},
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
