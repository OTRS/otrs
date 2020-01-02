# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::CreateAppointmentCalendarTables;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo6::CreateAppointmentCalendarTables - Create appointment calendar tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $Verbose       = $Param{CommandlineOptions}->{Verbose} || 0;

    # Get list of all installed packages.
    my @RepositoryList = $PackageObject->RepositoryList();

    # Check if the appointment calendar tables already exist, by testing if OTRSAppointmentCalendar package is
    #   installed. Also check if version is lower than 5.0.2, in order to execute some database upgrade statements.
    my $PackageVersion;
    my $DBUpdateNeeded;

    PACKAGE:
    for my $Package (@RepositoryList) {

        # Package is not the OTRSAppointmentCalendar package.
        next PACKAGE if $Package->{Name}->{Content} ne 'OTRSAppointmentCalendar';

        $PackageVersion = $Package->{Version}->{Content};

        if ($PackageVersion) {
            $DBUpdateNeeded = $Self->_CheckVersion(
                Version1 => '5.0.2',
                Version2 => $PackageVersion,
                Type     => 'Max',
            );
        }
    }

    if ($PackageVersion) {

        print "\n    Found package OTRSAppointmentCalendar $PackageVersion" if $Verbose;

        # Database upgrade is needed, because current version is not the latest.
        if ($DBUpdateNeeded) {
            print ", executing database upgrade...\n" if $Verbose;

            my @XMLStrings = (
                '
                    <TableAlter Name="calendar">
                        <UniqueDrop Name="calendar_id" />
                    </TableAlter>
                ', '
                    <TableAlter Name="calendar_appointment">
                        <UniqueDrop Name="calendar_appointment_id" />
                    </TableAlter>
                ',
            );

            return if !$Self->ExecuteXMLDBArray(
                XMLArray => \@XMLStrings,
            );

            return 1;
        }

        # Appointment calendar tables exist and are up to date, so we do not have to create or upgrade them here.
        print ", skipping database upgrade...\n" if $Verbose;

        return 1;
    }

    # Define the XML data for the appointment calendar tables.
    my @XMLStrings = (
        '
            <Table Name="calendar">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="group_id" Required="true" Type="INTEGER" />
                <Column Name="name" Required="true" Size="200" Type="VARCHAR" />
                <Column Name="salt_string" Required="true" Size="64" Type="VARCHAR" />
                <Column Name="color" Required="true" Size="7" Type="VARCHAR" />
                <Column Name="ticket_appointments" Required="false" Type="LONGBLOB" />
                <Column Name="valid_id" Required="true" Type="SMALLINT" />
                <Column Name="create_time" Required="true" Type="DATE" />
                <Column Name="create_by" Required="true" Type="INTEGER" />
                <Column Name="change_time" Required="true" Type="DATE" />
                <Column Name="change_by" Required="true" Type="INTEGER" />
                <Unique Name="calendar_name">
                    <UniqueColumn Name="name" />
                </Unique>
                <ForeignKey ForeignTable="groups">
                    <Reference Local="group_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="valid">
                    <Reference Local="valid_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id" />
                    <Reference Local="change_by" Foreign="id" />
                </ForeignKey>
            </Table>
        ', '
            <Table Name="calendar_appointment">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="parent_id" Type="BIGINT" />
                <Column Name="calendar_id" Required="true" Type="BIGINT" />
                <Column Name="unique_id" Required="true" Size="255" Type="VARCHAR" />
                <Column Name="title" Required="true" Size="255" Type="VARCHAR" />
                <Column Name="description" Size="3800" Type="VARCHAR" />
                <Column Name="location" Size="255" Type="VARCHAR" />
                <Column Name="start_time" Required="true" Type="DATE" />
                <Column Name="end_time" Required="true" Type="DATE" />
                <Column Name="all_day" Type="SMALLINT" />
                <Column Name="notify_time" Type="DATE" />
                <Column Name="notify_template" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom_unit_count" Type="BIGINT" />
                <Column Name="notify_custom_unit" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom_unit_point" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom_date" Type="DATE" />
                <Column Name="team_id" Size="3800" Type="VARCHAR" />
                <Column Name="resource_id" Size="3800" Type="VARCHAR" />
                <Column Name="recurring" Type="SMALLINT" />
                <Column Name="recur_type" Size="20" Type="VARCHAR" />
                <Column Name="recur_freq" Size="255" Type="VARCHAR" />
                <Column Name="recur_count" Type="INTEGER" />
                <Column Name="recur_interval" Type="INTEGER" />
                <Column Name="recur_until" Type="DATE" />
                <Column Name="recur_id" Type="DATE" />
                <Column Name="recur_exclude" Size="3800" Type="VARCHAR" />
                <Column Name="ticket_appointment_rule_id" Size="32" Type="VARCHAR" />
                <Column Name="create_time" Type="DATE" />
                <Column Name="create_by" Type="INTEGER" />
                <Column Name="change_time" Type="DATE" />
                <Column Name="change_by" Type="INTEGER" />
                <ForeignKey ForeignTable="calendar">
                    <Reference Local="calendar_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="calendar_appointment">
                    <Reference Local="parent_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id" />
                    <Reference Local="change_by" Foreign="id" />
                </ForeignKey>
            </Table>
        ', '
            <Table Name="calendar_appointment_ticket">
                <Column Name="calendar_id" Required="true" Type="BIGINT" />
                <Column Name="ticket_id" Required="true" Type="BIGINT" />
                <Column Name="rule_id" Required="true" Size="32" Type="VARCHAR" />
                <Column Name="appointment_id" Required="true" Type="BIGINT" />
                <Unique Name="calendar_appointment_ticket_calendar_id_ticket_id_rule_id">
                    <UniqueColumn Name="calendar_id" />
                    <UniqueColumn Name="ticket_id" />
                    <UniqueColumn Name="rule_id" />
                </Unique>
                <Index Name="calendar_appointment_ticket_calendar_id">
                    <IndexColumn Name="calendar_id" />
                </Index>
                <Index Name="calendar_appointment_ticket_ticket_id">
                    <IndexColumn Name="ticket_id" />
                </Index>
                <Index Name="calendar_appointment_ticket_rule_id">
                    <IndexColumn Name="rule_id" />
                </Index>
                <Index Name="calendar_appointment_ticket_appointment_id">
                    <IndexColumn Name="appointment_id" />
                </Index>
                <ForeignKey ForeignTable="calendar">
                    <Reference Local="calendar_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="ticket">
                    <Reference Local="ticket_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="calendar_appointment">
                    <Reference Local="appointment_id" Foreign="id" />
                </ForeignKey>
            </Table>
        ',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

=head2 _CheckVersion()

Compares two version numbers in a specified manner.

    my $Result = $DBUpdateTo6Object->_CheckVersion(
        Version1 => '1.3.1',    # (required)
        Version2 => '1.2.4',    # (required)
        Type     => 'Min',      # (required) Type of comparison to test for:
                                #            Min - Version2 should be same or higher than Version1
                                #            Max - Version2 should be lower than Version1
    );

Returns 1 if comparison condition is met (see Type parameter for more info).

=cut

sub _CheckVersion {
    my ( $Self, %Param ) = @_;

    for (qw(Version1 Version2 Type)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$_ not defined!",
            );
            return;
        }
    }

    for my $Type (qw(Version1 Version2)) {
        my @Parts = split( /\./, $Param{$Type} );
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            if ( defined $Parts[$_] ) {
                $Param{$Type} .= sprintf( "%04d", $Parts[$_] );
            }
            else {
                $Param{$Type} .= '0000';
            }
        }
        $Param{$Type} = int( $Param{$Type} );
    }

    if ( $Param{Type} eq 'Min' ) {
        return 1 if ( $Param{Version2} >= $Param{Version1} );
        return;
    }
    elsif ( $Param{Type} eq 'Max' ) {
        return 1 if ( $Param{Version2} < $Param{Version1} );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Invalid Type!',
    );
    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
