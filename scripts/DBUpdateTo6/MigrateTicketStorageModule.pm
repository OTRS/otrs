# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketStorageModule;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketStorageModule - Migrate Ticket::StorageModule -> MIMEBase::StorageModule.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $FilePath = "$Home/Kernel/Config/Backups/ZZZAutoOTRS5.pm";

    if ( !-f $FilePath ) {
        print "\nCould not find Kernel/Config/Backups/ZZZAutoOTRS5.pm, skipping... ";
        return 1;
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %OTRS5Config;
    $Kernel::OM->Get('Kernel::System::Main')->Require(
        'Kernel::Config::Backups::ZZZAutoOTRS5'
    );
    Kernel::Config::Backups::ZZZAutoOTRS5->Load( \%OTRS5Config );

    if (
        $OTRS5Config{'Ticket::StorageModule'}
        && $OTRS5Config{'Ticket::StorageModule'} eq 'Kernel::System::Ticket::ArticleStorageFS'
        )
    {
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => 'Ticket::Article::Backend::MIMEBase###ArticleStorage',
            Force  => 1,
            UserID => 1,
        );

        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'Ticket::Article::Backend::MIMEBase###ArticleStorage',
            IsValid           => 1,
            EffectiveValue    => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS',
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            print "\nUnable to migrate Ticket::StorageModule.\n";
            return;
        }
    }

    if ( $OTRS5Config{'Ticket::StorageModule::CheckAllBackends'} ) {
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => 'Ticket::Article::Backend::MIMEBase###CheckAllStorageBackends',
            Force  => 1,
            UserID => 1,
        );

        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'Ticket::Article::Backend::MIMEBase###CheckAllStorageBackends',
            IsValid           => 1,
            EffectiveValue    => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            print "\nUnable to migrate Ticket::StorageModule::CheckAllBackends.\n";
            return;
        }
    }

    if ( $OTRS5Config{'ArticleDir'} ) {
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => 'Ticket::Article::Backend::MIMEBase###ArticleDataDir',
            Force  => 1,
            UserID => 1,
        );

        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'Ticket::Article::Backend::MIMEBase###ArticleDataDir',
            IsValid           => 1,
            EffectiveValue    => $OTRS5Config{'ArticleDir'},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            print "\nUnable to migrate ArticleDir.\n";
            return;
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
