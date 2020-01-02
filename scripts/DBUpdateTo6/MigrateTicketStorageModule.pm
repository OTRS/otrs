# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    my $Verbose  = $Param{CommandlineOptions}->{Verbose} || 0;

    if ( !-f $FilePath ) {
        print "    Could not find Kernel/Config/Backups/ZZZAutoOTRS5.pm, skipping...\n" if $Verbose;
        return 1;
    }

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
        my $Result = $Self->SettingUpdate(
            Name           => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
            IsValid        => 1,
            EffectiveValue => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS',
            UserID         => 1,
        );

        if ( !$Result ) {
            print "\n    Error:Unable to migrate Ticket::StorageModule. \n\n";
            return;
        }
    }

    if ( $OTRS5Config{'Ticket::StorageModule::CheckAllBackends'} ) {
        my $Result = $Self->SettingUpdate(
            Name           => 'Ticket::Article::Backend::MIMEBase::CheckAllStorageBackends',
            IsValid        => 1,
            EffectiveValue => 1,
            UserID         => 1,
        );

        if ( !$Result ) {
            print "\n    Error:Unable to migrate Ticket::StorageModule::CheckAllBackends. \n";
            return;
        }
    }

    if ( $OTRS5Config{'ArticleDir'} ) {
        my $Result = $Self->SettingUpdate(
            Name           => 'Ticket::Article::Backend::MIMEBase::ArticleDataDir',
            IsValid        => 1,
            EffectiveValue => $OTRS5Config{'ArticleDir'},
            UserID         => 1,
        );

        if ( !$Result ) {
            print "\n    Error:Unable to migrate ArticleDir. \n\n";
            return;
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
