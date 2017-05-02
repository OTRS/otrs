# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::Base;    ## no critic

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

scripts::DBUpdateTo6::Base - Base class for migrations.

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $DBUpdateTo6Object->RebuildConfig(
        UnitTestMode => 1,      # (optional) Prevent discarding all objects at the end
    );

=cut

sub RebuildConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            CleanUp => 1,
            Force   => 1,
            UserID  => 1,
        )
        )
    {
        die "There was a problem writing XML to DB.";
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments => $Param{Comments} || "Configuration Rebuild",
            AllSettings  => 1,
            Force        => 1,
            NoValidation => 1,
            UserID       => 1,
        )
        )
    {
        die "There was a problem writing ZZZAAuto.pm.";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    print "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanup()

Clean up the cache.

    $DBUpdateTo6Object->CacheCleanup();

=cut

sub CacheCleanup {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    return 1;
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
