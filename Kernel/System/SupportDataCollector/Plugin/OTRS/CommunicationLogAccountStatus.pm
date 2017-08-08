# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::CommunicationLogAccountStatus;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::DateTime',
    'Kernel::System::MailAccount',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Communication Log Account Status (last 24 hours)');
}

sub Run {
    my $Self = shift;

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );

    my $DateTime = $Kernel::OM->Create('Kernel::System::DateTime');
    $DateTime->Subtract( Days => 1 );

    my $Connections = $CommunicationLogObject->GetConnectionsObjectsAndCommunications(
        StartDate => $DateTime->ToString(),
    );

    if ( !scalar @$Connections ) {
        $Self->AddResultInformation(
            Identifier => 'NoConnections',
            Label      => Translatable('No connections found.'),
        );
        return $Self->GetResults();
    }

    my %Account;

    for my $Connection (@$Connections) {

        my $AccountKey = $Connection->{AccountType};
        if ( $Connection->{AccountID} ) {
            $AccountKey .= "::$Connection->{AccountID}";
        }

        $Account{$AccountKey}->{AccountID}   = $Connection->{AccountID};
        $Account{$AccountKey}->{AccountType} = $Connection->{AccountType};
        push @{ $Account{$AccountKey}->{ $Connection->{Status} } }, $Connection->{CommunicationID};
    }

    my @AllMailAccounts = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGetAll();

    my %Accounts = map {
        $_->{ID}
            ?
            ( "$_->{Type}::$_->{ID}" => $_ )
            :
            ( $_->{Type} => $_ )
    } @AllMailAccounts;

    for my $AccountKey ( sort keys %Account ) {

        my $HealthStatus = $Self->_CheckHealth( $Account{$AccountKey} );

        my $AccountLabel = $Account{$AccountKey}->{AccountType};
        if ( $Account{$AccountKey}->{AccountID} ) {

            my $MailAccount = $Accounts{$AccountKey};

            $AccountLabel = "$MailAccount->{Host} / $MailAccount->{Login} ($Account{$AccountKey}->{AccountType})";
        }

        if ( $HealthStatus eq 'Success' ) {
            $Self->AddResultOk(
                Identifier => $AccountKey,
                Label      => $AccountLabel,
                Value      => Translatable('ok'),
            );
        }
        elsif ( $HealthStatus eq 'Failed' ) {
            $Self->AddResultProblem(
                Identifier => $AccountKey,
                Label      => $AccountLabel,
                Value      => Translatable('permanent connection errors'),
            );
        }
        elsif ( $HealthStatus eq 'Warning' ) {
            $Self->AddResultWarning(
                Identifier => $AccountKey,
                Label      => $AccountLabel,
                Value      => Translatable('intermittent connection errors'),
            );

        }
    }

    return $Self->GetResults();

}

sub _CheckHealth {
    my ( $Self, $Connections ) = @_;

    # Success if all is Successful;
    # Failed if all is Failed;
    # Warning if has both Successful and Failed Connections;

    my $Health = 'Success';

    if ( scalar $Connections->{Failed} ) {
        $Health = 'Failed';
        if ( scalar $Connections->{Successful} ) {
            $Health = 'Warning';
        }
    }

    return $Health;

}

1;
