# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::SMIME::CustomerCertificate::Fetch;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CheckItem',
    'Kernel::System::Crypt::SMIME',
    'Kernel::System::CustomerUser',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Fetch S/MIME certificates from customer backends.');
    $Self->AddOption(
        Name => 'add-all',
        Description =>
            "Add all found certificates from the customer backend into the system within the predefined search limit in customer backed (This operation might take some time).",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'email',
        Description => "Only get a certificate for the specified email address.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Fetching customer S/MIME certificates...</yellow>\n");

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $StopExecution;
    if ( !$ConfigObject->Get('SMIME') ) {
        $Self->Print("'S/MIME' is not activated in SysConfig, can't continue!\n");
        $StopExecution = 1;
    }
    elsif ( !$ConfigObject->Get('SMIME::FetchFromCustomer') ) {
        $Self->Print("'SMIME::FetchFromCustomer' is not activated in SysConfig, can't continue!\n");
        $StopExecution = 1;
    }

    if ($StopExecution) {
        $Self->Print("\n<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    if ( !$CryptObject ) {
        $Self->PrintError("S/MIME environment is not working!\n");
        $Self->Print("<red>Fail.</red>\n");
        return $Self->ExitCodeError();
    }

    # Get certificate for just one customer.
    if ( $Self->GetOption('email') ) {
        my $EmailAddress = $Self->GetOption('email');

        my $ValidEmail = $Kernel::OM->Get('Kernel::System::CheckItem')->CheckEmail(
            Address => $EmailAddress,
        );
        if ( !$ValidEmail ) {
            $Self->PrintError("  $EmailAddress NOT valid ($ValidEmail)\n");
            return $Self->ExitCodeError();
        }

        my @Files = $CryptObject->FetchFromCustomer(
            Search => $EmailAddress,
        );

        if ( !@Files ) {
            $Self->Print("  No new certificates found.\n");
        }

        for my $Filename (@Files) {
            my $Certificate = $CryptObject->CertificateGet(
                Filename => $Filename,
            );

            my %CertificateAttributes = $CryptObject->CertificateAttributes(
                Certificate => $Certificate,
                Filename    => $Filename,
            );

            $Self->Print("  Added certificate $CertificateAttributes{Fingerprint} (<yellow>$Filename</yellow>)\n");
        }

        $Self->Print("\n<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my ( $ListOfCertificates, $EmailsFromCertificates ) = $Self->_GetCurrentData();

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # Check customer user for UserSMIMECertificate property (Limit = CustomerUserSearchListLimit from customer backend)
    my %CustomerUsers = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => '*',
    );

    LOGIN:
    for my $Login ( sort keys %CustomerUsers ) {
        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $Login,
        );

        next LOGIN if !$CustomerUser{UserSMIMECertificate};

        $Self->Print("  Searching S/MIME certificates for <yellow>$Login</yellow>...");

        if ( $ListOfCertificates->{ $CustomerUser{UserSMIMECertificate} } ) {
            $Self->Print(" Already added\n");
            next LOGIN;
        }
        else {

            my @Files = $CryptObject->FetchFromCustomer(
                Search => $CustomerUser{UserEmail},
            );

            for my $Filename (@Files) {
                my $Certificate = $CryptObject->CertificateGet(
                    Filename => $Filename,
                );

                my %CertificateAttributes = $CryptObject->CertificateAttributes(
                    Certificate => $Certificate,
                    Filename    => $Filename,
                );
                $Self->Print(
                    "\n    Added certificate $CertificateAttributes{Fingerprint} (<yellow>$Filename</yellow>)\n"
                );
            }
        }
    }

    $Self->Print("\n<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub _GetCurrentData {
    my ( $Self, %Param ) = @_;

    my $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    # Get all existing certificates.
    my @CertList = $CryptObject->CertificateList();

    my %ListOfCertificates;
    my %EmailsFromCertificates;

    # Check all existing certificates for emails.
    CERTIFICATE:
    for my $Certname (@CertList) {

        my $CertificateString = $CryptObject->CertificateGet(
            Filename => $Certname,
        );

        my %CertificateAttributes = $CryptObject->CertificateAttributes(
            Certificate => $CertificateString,
            Filename    => $Certname,
        );

        # all SMIME certificates must have an Email Attribute
        next CERTIFICATE if !$CertificateAttributes{Email};

        my $ValidEmail = $Kernel::OM->Get('Kernel::System::CheckItem')->CheckEmail(
            Address => $CertificateAttributes{Email},
        );

        next CERTIFICATE if !$ValidEmail;

        # Remember certificate (don't need to be added again).
        $ListOfCertificates{$CertificateString} = $CertificateString;

        # Save email for checking for new certificate.
        $EmailsFromCertificates{ $CertificateAttributes{Email} } = 1;
    }

    return ( \%ListOfCertificates, \%EmailsFromCertificates );
}

1;
