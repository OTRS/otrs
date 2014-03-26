# --
# Kernel/System/SupportDataCollector/Plugin/Database/mysql/TableStatus.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::TableStatus;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    if ( $Self->{DBObject}->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    # table check
    my $File = $Self->{ConfigObject}->Get('Home') . '/scripts/database/otrs-schema.xml';
    if ( !-f $File ) {
        $Self->AddResultProblem(
            Label   => 'Table Check',
            Value   => '',
            Message => "Internal Error: Could not open file."
        );
    }

    my $ContentRef = $Self->{MainObject}->FileRead(
        Location => $File,
        Mode     => 'utf8',
    );
    if ( !ref $ContentRef && !${$ContentRef} ) {
        $Self->AddResultProblem(
            Label   => 'Table Status',
            Value   => '',
            Message => "Internal Error: Could not read file."
        );
    }

    my @Problems;

    my @XMLHash = $Self->{XMLObject}->XMLParse2XMLHash( String => ${$ContentRef} );
    TABLE:
    for my $Table ( @{ $XMLHash[1]->{database}->[1]->{Table} } ) {
        next TABLE if !$Table;

        if (
            $Self->{DBObject}->Prepare( SQL => "CHECK TABLE $Table->{Name} FAST QUICK" )
            )
        {
            my $Status;
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $Status = $Row[3];    # look at field 'Msg_text'
            }
            next TABLE if $Status =~ /^(OK|Table\sis\salready\sup\sto\sdate)/i;
            push @Problems, "$Table->{Name}\[$Status\]";
        }
        else {
            push @Problems, "$Table->{Name}\[missing\]";
        }
    }
    if ( !@Problems ) {
        $Self->AddResultOk(
            Label => 'Table Status',
            Value => '',
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => 'Table Status',
            Value   => join( ', ', @Problems ),
            Message => "Tables found which do not have a regular status."

        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
