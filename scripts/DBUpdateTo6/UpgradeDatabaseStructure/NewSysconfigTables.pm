# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewSysconfigTables;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewSysconfigTables - Adds tables for new sysconfig

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        '<Table Name="sysconfig_default">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="name" Required="true" Size="250" Type="VARCHAR"/>
            <Column Name="description" Required="true" Type="LONGBLOB"/>
            <Column Name="navigation" Required="true" Size="200" Type="VARCHAR"/>

            <!-- Attributes and Flags from XML -->
            <Column Name="is_invisible" Required="true" Type="SMALLINT"/>
            <Column Name="is_readonly" Required="true" Type="SMALLINT"/>
            <Column Name="is_required" Required="true" Type="SMALLINT"/>
            <Column Name="is_valid" Required="true" Type="SMALLINT"/>
            <Column Name="has_configlevel" Required="true" Type="SMALLINT"/>
            <Column Name="user_modification_possible" Required="true" Type="SMALLINT"/>
            <Column Name="user_modification_active" Required="true" Type="SMALLINT"/>
            <Column Name="user_preferences_group" Required="false" Size="250" Type="VARCHAR"/>

            <!-- XML content -->
            <Column Name="xml_content_raw" Required="true" Type="LONGBLOB"/>
            <Column Name="xml_content_parsed" Required="true" Type="LONGBLOB"/>
            <Column Name="xml_filename" Required="true" Size="250" Type="VARCHAR"/>
            <Column Name="effective_value" Required="true" Type="LONGBLOB"/>

            <!-- Indicates that this settings value changed and needs to be deployed -->
            <Column Name="is_dirty" Required="true" Type="SMALLINT"/>

            <!-- columns for locking -->
            <Column Name="exclusive_lock_guid" Required="true" Size="32" Type="VARCHAR"/>
            <Column Name="exclusive_lock_user_id" Required="false" Type="INTEGER"/>
            <Column Name="exclusive_lock_expiry_time" Required="false" Type="DATE"/>

            <!-- Usual metadata -->
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>

            <Unique Name="sysconfig_default_name">
                <UniqueColumn Name="name"/>
            </Unique>

            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
                <Reference Local="exclusive_lock_user_id" Foreign="id"/>
            </ForeignKey>
        </Table>',

        '<Table Name="sysconfig_default_version">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="sysconfig_default_id" Type="INTEGER" />
            <Column Name="name" Required="true" Size="250" Type="VARCHAR"/>
            <Column Name="description" Required="true" Type="LONGBLOB"/>
            <Column Name="navigation" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="is_invisible" Required="true" Type="SMALLINT"/>
            <Column Name="is_readonly" Required="true" Type="SMALLINT"/>
            <Column Name="is_required" Required="true" Type="SMALLINT"/>
            <Column Name="is_valid" Required="true" Type="SMALLINT"/>
            <Column Name="has_configlevel" Required="true" Type="SMALLINT"/>
            <Column Name="user_modification_possible" Required="true" Type="SMALLINT"/>
            <Column Name="user_modification_active" Required="true" Type="SMALLINT"/>
            <Column Name="user_preferences_group" Required="false" Size="250" Type="VARCHAR"/>
            <Column Name="xml_content_raw" Required="true" Type="LONGBLOB"/>
            <Column Name="xml_content_parsed" Required="true" Type="LONGBLOB"/>
            <Column Name="xml_filename" Required="true" Size="250" Type="VARCHAR"/>
            <Column Name="effective_value" Required="true" Type="LONGBLOB"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>

            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>

            <ForeignKey ForeignTable="sysconfig_default">
                <Reference Local="sysconfig_default_id" Foreign="id"/>
            </ForeignKey>

            <Index Name="scfv_sysconfig_default_id_name">
                <IndexColumn Name="sysconfig_default_id" />
                <IndexColumn Name="name" />
            </Index>
        </Table>',

        '<Table Name="sysconfig_modified">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="sysconfig_default_id" Required="true" Type="INTEGER"/>
            <Column Name="name" Required="true" Size="250" Type="VARCHAR"/>
            <Column Name="user_id" Required="false" Type="INTEGER"/>
            <Column Name="is_valid" Required="true" Type="SMALLINT"/>
            <Column Name="user_modification_active" Required="true" Type="SMALLINT"/>
            <Column Name="effective_value" Required="true" Type="LONGBLOB"/>

            <!-- Filled in case a setting is reset to default value, this modified value is deleted during deployment -->
            <Column Name="reset_to_default" Required="true" Type="SMALLINT"/>

            <!-- Indicates that this settings value changed and needs to be deployed -->
            <Column Name="is_dirty" Required="true" Type="SMALLINT"/>

            <!-- Usual metadata -->
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>

            <Unique Name="sysconfig_modified_per_user">
                <UniqueColumn Name="sysconfig_default_id"/>
                <UniqueColumn Name="user_id"/>
            </Unique>

            <ForeignKey ForeignTable="sysconfig_default">
                <Reference Local="sysconfig_default_id" Foreign="id"/>
            </ForeignKey>

            <ForeignKey ForeignTable="users">
                <Reference Local="user_id" Foreign="id"/>
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </Table>',

        '<Table Name="sysconfig_modified_version">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="sysconfig_default_version_id" Required="true" Type="INTEGER"/>
            <Column Name="name" Required="true" Size="250" Type="VARCHAR"/>
            <Column Name="user_id" Required="false" Type="INTEGER"/>
            <Column Name="is_valid" Required="true" Type="SMALLINT"/>
            <Column Name="user_modification_active" Required="true" Type="SMALLINT"/>
            <Column Name="effective_value" Required="true" Type="LONGBLOB"/>
            <Column Name="reset_to_default" Required="true" Type="SMALLINT"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <Column Name="change_time" Required="true" Type="DATE"/>
            <Column Name="change_by" Required="true" Type="INTEGER"/>

            <ForeignKey ForeignTable="sysconfig_default_version">
                <Reference Local="sysconfig_default_version_id" Foreign="id"/>
            </ForeignKey>

            <ForeignKey ForeignTable="users">
                <Reference Local="user_id" Foreign="id"/>
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </Table>',

        '<Table Name="sysconfig_deployment_lock">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="exclusive_lock_guid" Required="false" Size="32" Type="VARCHAR"/>
            <Column Name="exclusive_lock_user_id" Required="false" Type="INTEGER"/>
            <Column Name="exclusive_lock_expiry_time" Required="false" Type="DATE"/>

            <ForeignKey ForeignTable="users">
                <Reference Local="exclusive_lock_user_id" Foreign="id"/>
            </ForeignKey>
        </Table>',

        '<Table Name="sysconfig_deployment">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="comments" Required="false" Size="250" Type="VARCHAR"/>
            <Column Name="user_id" Required="false" Type="INTEGER"/>

            <!-- Perl content to be written to the Perl cache file -->
            <Column Name="effective_value" Required="true" Type="LONGBLOB"/>

            <!-- Usual metadata -->
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>

            <ForeignKey ForeignTable="users">
                <Reference Local="user_id" Foreign="id"/>
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKey>
        </Table>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
