# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::SMIME::CustomerCertificate::Renew;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CheckItem',
    'Kernel::System::Crypt::SMIME',
    'Kernel::System::CustomerUser',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Renew existing SMIME certificates from customer backends.');
    $Self->AddOption(
        Name        => 'force',
        Description => "Execute even if SMIME is not enabled in SysConfig.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    if ( $Self->GetOption('force') ) {
        $ConfigObject->Set(
            Key   => 'SMIME',
            Value => 1,
        );
    }

    if ( !$ConfigObject->Get('SMIME') ) {
        die "SMIME is not activated in SysConfig!\n";
    }

    my $Message = $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->Check();

    die $Message if $Message;

    my $CryptObject;
    eval {
        $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    };
    if ( !$CryptObject ) {
        die "No SMIME support!.\n"
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Renewing existing customer SMIME certificates...</yellow>\n");

    if ( !$Kernel::OM->Get('Kernel::Config')->Get('SMIME::FetchFromCustomer') ) {
        $Self->Print("'SMIME::FetchFromCustomer' is not activated in SysConfig, nothing to do!\n");
        $Self->Print("\n<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my ( $ListOfCertificates, $EmailsFromCertificates ) = $Self->_GetCurrentData();

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CryptObject        = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    EMAIL:
    for my $Email ( sort keys %{$EmailsFromCertificates} ) {

        my %UserList = $CustomerUserObject->CustomerSearch(
            PostMasterSearch => $Email,
            Limit            => 1,
        );

        next EMAIL if !%UserList;

        my @UserLogins = sort keys %UserList;

        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $UserLogins[0],
        );

        next EMAIL if !%CustomerUser;
        next EMAIL if !$CustomerUser{UserSMIMECertificate};
        next EMAIL if $ListOfCertificates->{ $CustomerUser{UserSMIMECertificate} };

        my @Files = $CryptObject->FetchFromCustomer(
            Search => $Email,
        );

        for my $Filename (@Files) {
            my $Certificate = $CryptObject->CertificateGet(
                Filename => $Filename,
            );

            my %CertificateAttributes = $CryptObject->CertificateAttributes(
                Certificate => $Certificate,
                Filename    => $Filename,
            );

            $Self->Print("  Found new SMIME certificates for <yellow>$UserLogins[0]</yellow> ...\n");
            $Self->Print("    Added certificate $CertificateAttributes{Fingerprint} (<yellow>$Filename</yellow>)\n")
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
