# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::CreateTicketNumberCounterTables;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::XML',
);

=head1 NAME

scripts::DBUpdateTo6::CreateTicketNumberCounterTables - Create ticket number counter tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $XMLObject     = $Kernel::OM->Get('Kernel::System::XML');

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
        print "\nFound package OTRSTicketNumberCounterDatabase $PackageVersion, skipping database upgrade...\n";
        return 1;
    }

    # Get list of existing OTRS tables, in order to check if ticket number counter already exist. This is needed because
    #   update script might be executed multiple times, and by then OTRSTicketNumberCounterDatabase package has already
    #   been merged so we cannot rely on its existence. Please see bug#12788 for more information.
    my @OTRSTables = $DBObject->ListTables();

    # Define the XML data for the ticket number counter tables.
    my @XMLStrings = (
        '
            <TableCreate Name="exclusive_lock">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="lock_key" Required="true" Size="255" Type="VARCHAR" />
                <Column Name="lock_uid" Required="true" Size="32" Type="VARCHAR" />
                <Column Name="create_time" Type="DATE" />
                <Column Name="expiry_time" Type="DATE" />
                <Unique Name="exclusive_lock_lock_uid">
                    <UniqueColumn Name="lock_uid" />
                </Unique>
                <Index Name="exclusive_lock_expiry_time">
                    <IndexColumn Name="expiry_time" />
                </Index>
            </TableCreate>
        ', '
            <TableCreate Name="ticket_number_counter">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="counter" Required="true" Type="BIGINT" />
                <Column Name="counter_uid" Required="true" Size="32" Type="VARCHAR" />
                <Column Name="create_time" Type="DATE" />
                <Unique Name="ticket_number_counter_uid">
                    <UniqueColumn Name="counter_uid" />
                </Unique>
            </TableCreate>
        ',
    );

    # Create database specific SQL and PostSQL commands out of XML.
    my @SQL;
    my @SQLPost;
    XML_STRING:
    for my $XMLString (@XMLStrings) {

        # Skip existing tables.
        if ( $XMLString =~ /<TableCreate Name="([a-z_]+)">/ ) {
            my $TableName = $1;
            if ( grep { $_ eq $TableName } @OTRSTables ) {
                print "\nTable '$TableName' already exists, skipping... ";
                next XML_STRING;
            }
        }

        my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

        # Create database specific SQL.
        push @SQL, $DBObject->SQLProcessor(
            Database => \@XMLARRAY,
        );

        # Create database specific PostSQL.
        push @SQLPost, $DBObject->SQLProcessorPost();
    }

    # Execute SQL.
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
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
