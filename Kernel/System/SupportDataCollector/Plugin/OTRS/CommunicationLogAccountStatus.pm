# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::CommunicationLogAccountStatus;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog::DB',
    'Kernel::System::DateTime',
    'Kernel::System::MailAccount',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Communication Log Account Status (last 24 hours)');
}

sub Run {
    my $Self = shift;

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $DateTime              = $Kernel::OM->Create('Kernel::System::DateTime');
    $DateTime->Subtract( Days => 1 );

    my $Connections = $CommunicationLogDBObj->GetConnectionsObjectsAndCommunications(
        ObjectLogStartDate => $DateTime->ToString(),
    );

    if ( !$Connections || !@{$Connections} ) {
        $Self->AddResultInformation(
            Identifier => 'NoConnections',
            Label      => Translatable('No connections found.'),
        );
        return $Self->GetResults();
    }

    my %Account;

    CONNECTION:
    for my $Connection ( @{$Connections} ) {
        next CONNECTION if !$Connection->{AccountType};

        my $AccountKey = $Connection->{AccountType};
        if ( $Connection->{AccountID} ) {
            $AccountKey .= "::$Connection->{AccountID}";
        }

        if ( !$Account{$AccountKey} ) {
            $Account{$AccountKey} = {
                AccountID   => $Connection->{AccountID},
                AccountType => $Connection->{AccountType},
            };
        }

        $Account{$AccountKey}->{ $Connection->{ObjectLogStatus} } ||= [];

        push @{ $Account{$AccountKey}->{ $Connection->{ObjectLogStatus} } }, $Connection->{CommunicationID};
    }

    my @AllMailAccounts = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGetAll();

    my %MailAccounts = map { $_->{ID} ? ( "$_->{Type}::$_->{ID}" => $_ ) : ( $_->{Type} => $_ ) } @AllMailAccounts;

    for my $AccountKey ( sort keys %Account ) {

        my $HealthStatus = $Self->_CheckHealth( $Account{$AccountKey} );

        my $AccountLabel = $Account{$AccountKey}->{AccountType};
        if ( $Account{$AccountKey}->{AccountID} && $MailAccounts{$AccountKey} ) {

            my $MailAccount = $MailAccounts{$AccountKey};

            $AccountLabel = "$MailAccount->{Host} / $MailAccount->{Login} ($Account{$AccountKey}->{AccountType})";
        }
        elsif ( $Account{$AccountKey}->{AccountID} ) {
            $AccountLabel = $AccountKey;
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

    if ( IsArrayRefWithData( $Connections->{Failed} ) ) {
        $Health = 'Failed';
        if ( IsArrayRefWithData( $Connections->{Successful} ) ) {
            $Health = 'Warning';
        }
    }

    return $Health;

}

1;
