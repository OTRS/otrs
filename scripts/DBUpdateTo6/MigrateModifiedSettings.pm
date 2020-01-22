# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateModifiedSettings;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::SysConfig',
    'Kernel::System::Storable',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateModifiedSettings - Migrate config modified values that are changed from default OTRS 6 to 7 .

This script assumes that SysConfig settings has not been cleaned up.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;
    my $Success = 1;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $StorableObject  = $Kernel::OM->Get('Kernel::System::Storable');
    my @ModifiedSettings;

    my %MigrationSettings = $Self->SettingsToMigrate();

    SETTINGNAME:
    for my $SettingName ( sort keys %MigrationSettings ) {

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        if ( !%Setting ) {
            print "\n        - Could not get existing $SettingName!";
            $Success = 0;
            next SETTINGNAME;
        }

        if ( IsArrayRefWithData( $Setting{EffectiveValue} ) ) {

            # Create a local clone of the value to prevent any modification.
            my $EffectiveValue = $StorableObject->Clone(
                Data => $Setting{EffectiveValue},
            );

            for my $Item ( 0 .. $#{$EffectiveValue} ) {

                for my $OldValue ( sort keys %{ $MigrationSettings{$SettingName} } ) {
                    if ( $EffectiveValue->[$Item] eq $OldValue ) {
                        $EffectiveValue->[$Item] = $MigrationSettings{$SettingName}->{$OldValue};

                        my %Setting = (
                            Name           => $SettingName,
                            EffectiveValue => $EffectiveValue,
                            IsValid        => 1,
                        );

                        push @ModifiedSettings, \%Setting;
                    }
                }
            }
        }
        elsif ( IsHashRefWithData( $Setting{EffectiveValue} ) ) {

            # Create a local clone of the value to prevent any modification.
            my $EffectiveValue = $StorableObject->Clone(
                Data => $Setting{EffectiveValue},
            );

            for my $Item ( sort keys %{$EffectiveValue} ) {

                for my $OldValue ( sort keys %{ $MigrationSettings{$SettingName} } ) {
                    if ( $EffectiveValue->{$Item} eq $OldValue ) {
                        $EffectiveValue->{$Item} = $MigrationSettings{$SettingName}->{$OldValue};

                        my %Setting = (
                            Name           => $SettingName,
                            EffectiveValue => $EffectiveValue,
                            IsValid        => 1,
                        );

                        push @ModifiedSettings, \%Setting;
                    }
                }
            }
        }
        else {

            for my $OldValue ( sort keys %{ $MigrationSettings{$SettingName} } ) {
                if ( $Setting{EffectiveValue} eq $OldValue ) {
                    $Setting{EffectiveValue} = $MigrationSettings{$SettingName}->{$OldValue};

                    my %Setting = (
                        Name           => $SettingName,
                        EffectiveValue => [ $Setting{EffectiveValue} ],
                        IsValid        => 1,
                    );

                    push @ModifiedSettings, \%Setting;
                }
            }
        }
    }

    if ( IsArrayRefWithData( \@ModifiedSettings ) ) {

        if ($Verbose) {
            print "\n        - Updating settings...";
        }

        my $Result = $SysConfigObject->SettingsSet(
            UserID   => 1,
            Comments => "Deploy settings with migration module",
            Settings => \@ModifiedSettings,
        );
        if ($Result) {
            if ($Verbose) {
                print 'OK';
            }
        }
        else {
            if ($Verbose) {
                print 'Fail';
            }
            print "\n          - There was an error updating settings";
            $Success = 0;
        }
    }

    print "\n\n" if $Verbose;

    return $Success;
}

sub SettingsToMigrate {
    my ( $Self, %Param ) = @_;

    return (
        'Loader::Agent::CommonJS###000-Framework' => {
            'thirdparty/jquery-jstree-3.3.4/jquery.jstree.js' => 'thirdparty/jquery-jstree-3.3.7/jquery.jstree.js',
            'thirdparty/jquery-3.2.1/jquery.js'               => 'thirdparty/jquery-3.4.1/jquery.js',
        },
        'Loader::Customer::CommonJS###000-Framework' => {
            'thirdparty/jquery-jstree-3.3.4/jquery.jstree.js' => 'thirdparty/jquery-jstree-3.3.7/jquery.jstree.js',
            'thirdparty/jquery-3.2.1/jquery.js'               => 'thirdparty/jquery-3.4.1/jquery.js',
        },
    );
}

1;
