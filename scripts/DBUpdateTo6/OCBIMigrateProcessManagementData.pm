# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::OCBIMigrateProcessManagementData;    ## no critic

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

scripts::DBUpdateTo6::OCBIMigrateProcessManagementData -  Create entries in new article table for OmniChannel base infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    PMTABLE:
    for my $Table (qw(pm_transition_action pm_activity_dialog)) {

        next PMTABLE if !$DBObject->Prepare(
            SQL => "
                SELECT id, config
                FROM $Table
                ORDER BY id ASC
            ",
        );

        my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

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

            # Map visible for customer / communication channel.
            my $IsVisibleForCustomer = 0;
            if ( $Table eq 'pm_transition_action' ) {
                if ( $Config->{Config}->{ArticleType} =~ /(-ext|phone|fax|sms|webrequest)/i ) {
                    $IsVisibleForCustomer = 1;
                }
                $Config->{Config}->{IsVisibleForCustomer} = $IsVisibleForCustomer;

                my $CommunicationChannel;
                if ( $Config->{Config}->{ArticleType} =~ /email-/i ) {
                    $CommunicationChannel = 'Email';
                }
                elsif ( $Config->{Config}->{ArticleType} =~ /phone/i ) {
                    $CommunicationChannel = 'Phone';
                }
                elsif ( $Config->{Config}->{ArticleType} =~ /chat-/i ) {
                    $CommunicationChannel = 'Chat';
                }
                else {
                    $CommunicationChannel = 'Internal';
                }
                delete $Config->{Config}->{ArticleType};
                $Config->{Config}->{CommunicationChannel} = $CommunicationChannel;
            }
            elsif ( $Table eq 'pm_activity_dialog' ) {

                if ( $Config->{Fields}->{Article}->{Config}->{ArticleType} =~ /(-ext|phone|fax|sms|webrequest)/i ) {
                    $IsVisibleForCustomer = 1;
                }
                $Config->{Fields}->{Article}->{Config}->{IsVisibleForCustomer} = $IsVisibleForCustomer;

                my $CommunicationChannel;
                if ( $Config->{Fields}->{Article}->{Config}->{ArticleType} =~ /email-/i ) {
                    $CommunicationChannel = 'Email';
                }
                elsif ( $Config->{Fields}->{Article}->{Config}->{ArticleType} =~ /phone/i ) {
                    $CommunicationChannel = 'Phone';
                }
                elsif ( $Config->{Fields}->{Article}->{Config}->{ArticleType} =~ /chat-/i ) {
                    $CommunicationChannel = 'Chat';
                }
                else {
                    $CommunicationChannel = 'Internal';
                }

                delete $Config->{Fields}->{Article}->{Config}->{ArticleType};
                $Config->{Fields}->{Article}->{CommunicationChannel} = $CommunicationChannel;
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
                Message  => "An error occurs during data migration for: $Table!",
            );
            return;
        }
    }

    return 1;
}

=head2 _MigrateData()

Adds multiple article entries to the article table. Returns 1 on success

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

    if ( !defined $Param{Table} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Table!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Data ( @{ $Param{Data} } ) {

        # Dump config as string.
        my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Data->{Config} );

        return if !$DBObject->Do(
            SQL => "
                UPDATE $Param{Table}
                SET config = ?
                WHERE id = ?
            ",
            Bind => [
                \$Config, \$Data->{ID},
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
