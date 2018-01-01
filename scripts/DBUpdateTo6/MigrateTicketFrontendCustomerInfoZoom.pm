# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketFrontendCustomerInfoZoom;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketFrontendCustomerInfoZoom - Migrate customer information widget configuration in
ticket zoom screen.

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

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %OTRS5Config;
    $Kernel::OM->Get('Kernel::System::Main')->Require(
        'Kernel::Config::Backups::ZZZAutoOTRS5'
    );
    Kernel::Config::Backups::ZZZAutoOTRS5->Load( \%OTRS5Config );

    if (
        !defined $OTRS5Config{'Ticket::Frontend::CustomerInfoZoom'}
        || $OTRS5Config{'Ticket::Frontend::CustomerInfoZoom'}
        )
    {
        return 1;
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => 'Ticket::Frontend::AgentTicketZoom###Widgets###0200-CustomerInformation',
        Force  => 1,
        UserID => 1,
    );

    my %Result = $SysConfigObject->SettingUpdate(
        Name              => 'Ticket::Frontend::AgentTicketZoom###Widgets###0200-CustomerInformation',
        IsValid           => 0,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        print "\n    Error: Unable to migrate Ticket::Frontend::CustomerInfoZoom.\n";
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
