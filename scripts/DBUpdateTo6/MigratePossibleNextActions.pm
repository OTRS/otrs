# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)
package scripts::DBUpdateTo6::MigratePossibleNextActions;

use strict;
use warnings;

use base qw(scripts::DBUpdateTo6);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::MigratePossibleNextActions - Migrate possible next actions.

=head1 DESCRIPTION

Migrate possible next actions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DBUpdateTo6Object = $Kernel::OM->Get('scripts::DBUpdateTo6::MigratePossibleNextActions');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SettingName = 'PossibleNextActions';
    my $PossibleNextActions = $Kernel::OM->Get('Kernel::Config')->Get($SettingName) || {};

    # create a lookup array to no not modify the looping variable
    my @Actions = sort keys %{ $PossibleNextActions // {} };

    my $Updated;
    ACTION:
    for my $Action (@Actions) {

        # skip all keys that looks like an URL (e.g. TT Env('CGIHandle')
        #   or staring with http(s), ftp(s), matilto:, ot www.)
        next ACTION if $Action =~ m{\A \[% [\s]+ Env\( }msxi;
        next ACTION if $Action =~ m{\A http [s]? :// }msxi;
        next ACTION if $Action =~ m{\A ftp [s]? :// }msxi;
        next ACTION if $Action =~ m{\A mailto : }msxi;
        next ACTION if $Action =~ m{\A www \. }msxi;

        # remember the value for the current key
        my $ActionValue = $PossibleNextActions->{$Action};

        # remove current key and add the inverted key value pair
        delete $PossibleNextActions->{$Action};
        $PossibleNextActions->{$ActionValue} = $Action;

        $Updated = 1;
    }

    return 1 if !$Updated;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $SettingName,
        Force  => 1,
        UserID => 1,
    );

    my %Result = $SysConfigObject->SettingUpdate(
        Name              => $SettingName,
        IsValid           => 1,
        EffectiveValue    => $PossibleNextActions,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    return $Result{Success};
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
