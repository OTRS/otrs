# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateArticleSearchIndex;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateArticleSearchIndex - Migrate article search index module.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $FilePath = "$Home/Kernel/Config/Backups/ZZZAutoOTRS5.pm";

    if ( !-f $FilePath ) {
        print "\n  Could not find Kernel/Config/Backups/ZZZAutoOTRS5.pm, skipping... ";
        return 1;
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %OTRS5Config;
    $Kernel::OM->Get('Kernel::System::Main')->Require(
        'Kernel::Config::Backups::ZZZAutoOTRS5'
    );
    Kernel::Config::Backups::ZZZAutoOTRS5->Load( \%OTRS5Config );

    if ( $OTRS5Config{'Ticket::SearchIndexModule'} ) {
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => 'Ticket::SearchIndexModule',
            Force  => 1,
            UserID => 1,
        );

        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'Ticket::SearchIndexModule',
            IsValid           => 1,
            EffectiveValue    => 'Kernel::System::Ticket::ArticleSearchIndex::DB',
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            print "\n  Unable to migrate Ticket::SearchIndexModule.\n";
            return;
        }

        # Turn off filtering of stop words if previous article search index module was set to RuntimeDB. Effectively,
        #   this will mimic old search behavior.
        if ( $OTRS5Config{'Ticket::SearchIndexModule'} eq 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB' ) {
            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                Name   => 'Ticket::SearchIndex::FilterStopWords',
                Force  => 1,
                UserID => 1,
            );

            my %Result = $SysConfigObject->SettingUpdate(
                Name              => 'Ticket::SearchIndex::FilterStopWords',
                IsValid           => 1,
                EffectiveValue    => 0,
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );

            if ( !$Result{Success} ) {
                print "\n  Unable to migrate Ticket::SearchIndex::FilterStopWords.\n";
                return;
            }
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
