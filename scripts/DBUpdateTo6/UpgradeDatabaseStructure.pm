# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::XML',
    'Kernel::System::Console::Command::Maint::Database::Check',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure - Upgrades the database structure to OTRS 6.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # enable auto-flushing of STDOUT
    $| = 1;    ## no critic

    my @Tasks = (
        {
            Message =>
                'Add table for dynamic field object names and add an index to speed up searching dynamic field text values.',
            Module => 'DynamicFieldChanges',
        },
        {
            Message => 'Add new sysconfig tables.',
            Module  => 'NewSysconfigTables',
        },
        {
            Message => 'Remove no longer needed MD5 columns from some tables.',
            Module  => 'RemoveMD5Columns',
        },
        {
            Message => 'Add new communication channel table and insert data.',
            Module  => 'NewCommunicationChannelTable',
        },
        {
            Message => 'Change article table structure and prepare renaming of article tables.',
            Module  => 'ArticleTableChangesPreRename',
        },
        {
            Message => 'Rename article tables.',
            Module  => 'ArticleTableChangesRename',
        },
        {
            Message => 'Create new article table and change some table structures after renaming of article tables.',
            Module  => 'ArticleTableChangesPostRename',
        },
        {
            Message => 'Change the structure of ticket_history table and add new history type.',
            Module  => 'TicketHistoryTableChanges',
        },
        {
            Message => 'Add new tables for customer relations.',
            Module  => 'NewCustomerRelationTables',
        },
        {
            Message => 'Add new table for chat data.',
            Module  => 'NewChatDataTable',
        },
        {
            Message => 'Change the password columns in the user/customer user tables.',
            Module  => 'PasswordColumnChanges',
        },
        {
            Message => 'Adds new table for article search index.',
            Module  => 'NewArticleSearchIndexTable',
        },
    );

    print "\n";

    TASK:
    for my $Task (@Tasks) {

        next TASK if !$Task;
        next TASK if !$Task->{Module};

        print "\n   $Task->{Message}";

        my $ModuleName = "scripts::DBUpdateTo6::UpgradeDatabaseStructure::$Task->{Module}";
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            next TASK;
        }

        # Run module.
        $Kernel::OM->ObjectParamAdd(
            "scripts::DBUpdateTo6::UpgradeDatabaseStructure::$Task->{Module}" => {
                Opts => $Self->{Opts},
            },
        );

        my $Object = $Kernel::OM->Create($ModuleName);
        if ( !$Object ) {
            print "  Was not possible to create object for: $ModuleName.";
            die;
        }

        my $Success = $Object->Run(%Param);

        if ($Success) {
            print ".. done.\n";
        }
        else {
            print ".. error.\n";
            die;
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

    # check DB connection is possible
    my $ConnectionCheck = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Database::Check')->Execute();

    if ( !defined $ConnectionCheck || $ConnectionCheck ne 0 ) {
        print "Error: Not possible to perform DB connection!";
        return;
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
