# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::CreateTicketNumberCounterTables;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo6::CreateTicketNumberCounterTables - Create ticket number counter tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $Verbose       = $Param{CommandlineOptions}->{Verbose} || 0;

    # Get list of all installed packages.
    my @RepositoryList = $PackageObject->RepositoryList();

    # Check if the ticket number counter tables already exist, by testing if OTRSTicketNumberCounterDatabase package is
    #   installed.
    my $PackageVersion;
    my $DBUpdateNeeded;

    PACKAGE:
    for my $Package (@RepositoryList) {

        # Package is not the OTRSTicketNumberCounterDatabase package.
        next PACKAGE if $Package->{Name}->{Content} ne 'OTRSTicketNumberCounterDatabase';

        $PackageVersion = $Package->{Version}->{Content};
    }

    if ($PackageVersion) {
        if ($Verbose) {
            print "\n    Found package OTRSTicketNumberCounterDatabase $PackageVersion, skipping database upgrade...\n";
        }
        return 1;
    }

    # Define the XML data for the ticket number counter tables.
    my @XMLStrings = (
        '
            <TableCreate Name="ticket_number_counter">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="counter" Required="true" Type="BIGINT" />
                <Column Name="counter_uid" Required="true" Size="32" Type="VARCHAR" />
                <Column Name="create_time" Type="DATE" />
                <Unique Name="ticket_number_counter_uid">
                    <UniqueColumn Name="counter_uid" />
                </Unique>
                <Index Name="ticket_number_counter_create_time">
                    <IndexColumn Name="create_time" />
                </Index>
            </TableCreate>
        ',
    );

    # execute XML DB string.
    XML_STRING:
    for my $XMLString (@XMLStrings) {

        # Skip existing tables.
        if ( $XMLString =~ /<TableCreate Name="([a-z_]+)">/ ) {
            my $TableName = $1;

    # Get list of existing OTRS tables, in order to check if ticket number counter already exist. This is needed because
    #   update script might be executed multiple times, and by then OTRSTicketNumberCounterDatabase package has already
    #   been merged so we cannot rely on its existence. Please see bug#12788 for more information.
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            if ($TableExists) {
                print "\n        - Table '$TableName' already exists, skipping...\n\n" if $Verbose;
                next XML_STRING;
            }
        }

        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
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
