# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::SMIME::FetchFromCustomer;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::SMIME',
    'Kernel::System::User',
    'Kernel::System::CustomerUser',
    'Kernel::System::CheckItem',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Refresh existing keys for new ones from the LDAP.');
    $Self->AddOption(
        Name        => 'verbose',
        Description => "Print detailed command output.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'force',
        Description => "Execute even if S/MIME is not enabled in SysConfig.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'renew',
        Description => "Only renew existing certificates from customer-users.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'add-all',
        Description =>
            "Add all found certificates from the LDAP into the system within the predefined search limit in customer backed (this operation might take some time).",
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

sub PreRun {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    if ( $Self->GetOption('force') ) {
        $ConfigObject->Set(
            Key   => 'SMIME',
            Value => 1,
        );
    }

    my $SMIMEActivated = $ConfigObject->Get('SMIME');
    if ( !$SMIMEActivated ) {
        die "S/MIME is not activated in SysConfig!\n";
    }

    my $Message = $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->Check();

    die $Message if $Message;

    my $SMIMESyncActivated = $ConfigObject->Get('SMIME::FetchFromCustomer');
    if ( !$SMIMESyncActivated ) {
        die "'S/MIME from LDAP' synchronization is not activated in SysConfig!\n";
    }

    my $CryptObject;
    eval {
        $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    };
    if ( !$CryptObject ) {
        die "No S/MIME support!.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Count     = 1;
    my $CertCount = 0;

    my $DetailLevel = $Self->GetOption('verbose') ? 'Details' : 'ShortDetails';

    if ( $DetailLevel ne 'Details' ) {
        $Self->Print("<yellow>$Count) Refreshing S/MIME keys...</yellow>\n");
        $Count++;
    }

    my $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    # Get all existing certificates.
    my @CertList = $CryptObject->CertificateList();

    # only when Email specified
    if ( $Self->GetOption('email') ) {
        my $Emailaddress = $Self->GetOption('email');

        my $ValidEmail = $Kernel::OM->Get('Kernel::System::CheckItem')->CheckEmail(
            Address => $Emailaddress,
        );
        if ( !$ValidEmail ) {
            $Self->Print("<red>$Count) $Emailaddress NOT valid ($ValidEmail)</red>\n");
            return 1;
        }

        if ( $DetailLevel ne 'Details' ) {
            $Self->Print("<yellow>$Count) '$Emailaddress' is a valid email ($ValidEmail)</yellow>\n");
            $Count++;
        }
        my @Files = $CryptObject->FetchFromCustomer(
            Search => $Emailaddress
        );

        $CertCount += @Files;

        if ( $CertCount > 0 ) {
            if ( $DetailLevel ne 'Details' ) {
                $Self->Print("$CertCount added\n");
            }
        }
        @CertList = @Files;
    }

    my %ListOfEmailCertificates;
    my @ActiveCustomerUserCertificates;

    # Check all existing certificates for emails.
    CERTIFICATE:
    for my $Certname (@CertList) {

        if ( $DetailLevel ne 'Details' ) {
            $Self->Print( 'CN: ' . $Certname . "\n" );
        }

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
        $ListOfEmailCertificates{$CertificateString} = $CertificateString;

        # Save email for checking for new certificate.
        push @ActiveCustomerUserCertificates, $CertificateAttributes{Email};
    }
    if ( $DetailLevel ne 'Details' ) {
        $Self->Print(
            "<yellow>$Count) Found " . @ActiveCustomerUserCertificates . " Customer-Certificate...</yellow>\n"
        );
        $Count++;
    }

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # Check saved CustomerUser-emails for userSMIMECertificate
    if ( $Self->GetOption('renew') && @ActiveCustomerUserCertificates ) {
        if ( $DetailLevel ne 'Details' ) {
            $Self->Print("<yellow>$Count) Only renew existing Customer-Certificates...</yellow>\n");
            $Count++;
        }
        my %CustomerUsers = $CustomerUserObject->CustomerSearch(
            PostMasterSearch => @ActiveCustomerUserCertificates,
        );

        # if not AddAll
        CUSTOMERUSER:
        for my $Login ( sort keys %CustomerUsers ) {
            if ( $DetailLevel ne 'Details' ) {
                $Self->Print( 'CU: ' . $Login . "\n" );
            }
            my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                User => $Login,
            );

            # Add Certificate if available
            if ( $CustomerUser{SMIMECertificate} ) {

                # Certificate already existing
                next CUSTOMERUSER if $ListOfEmailCertificates{ $CustomerUser{SMIMECertificate} };

                my $ConvertedCertificate = $CryptObject->ConvertCertFormat(
                    String => $CustomerUser{SMIMECertificate},
                );

                my %Result = $CryptObject->CertificateAdd(
                    Certificate => $ConvertedCertificate,
                );
                if ( $Result{Successful} && $Result{Successful} == 1 ) {
                    if ( $DetailLevel ne 'Details' ) {
                        $Self->Print("$Result{Filename} added\n");
                    }
                    $CertCount++;
                }
            }
        }
    }

    if ( $Self->GetOption('add-all') ) {

        #check LDAP-Users for userSMIMECertificate (Limit = CustomerUserSearchListLimit from LDAP-Config)
        my %CustomerUsers = $CustomerUserObject->CustomerSearch(
            Search => '*',
        );
        %CustomerUsers = (
            %CustomerUsers,
            $CustomerUserObject->CustomerSearch(
                PostMasterSearch => '*',
            )
        );
        if ( $DetailLevel ne 'Details' ) {
            $Self->Print("<yellow>$Count) Get all users to check them...</yellow>\n");
        }
        for my $Login ( sort keys %CustomerUsers ) {
            my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                User => $Login,
            );
            if ( $DetailLevel ne 'Details' ) {
                $Self->Print("CU: $Login\n");
            }

            # only add, if CustomerUser has Certificate, and Certificate not already in List available
            if ( $CustomerUser{SMIMECertificate} && !$ListOfEmailCertificates{ $CustomerUser{SMIMECertificate} } ) {
                if ( $DetailLevel ne 'Details' ) {
                    $Self->Print("Add? - ");
                }

                my $ConvertedCertificate = $CryptObject->ConvertCertFormat(
                    String => $CustomerUser{SMIMECertificate}
                );

                my %Result = $CryptObject->CertificateAdd(
                    Certificate => $ConvertedCertificate,
                );

                if ( $Result{Successful} && $Result{Successful} == 1 ) {
                    if ( $DetailLevel ne 'Details' ) {
                        $Self->Print("$Result{Filename} added");
                    }
                    $CertCount++;
                }
                if ( $DetailLevel ne 'Details' ) {
                    $Self->Print("\n");
                }
            }
        }
    }

    my $CheckCertPathResult = $CryptObject->CheckCertPath();

    if ( $CheckCertPathResult->{$DetailLevel} ) {
        $Self->Print( $CheckCertPathResult->{$DetailLevel} );
    }

    if ( !$CheckCertPathResult->{Success} ) {
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done. ($CertCount)</green>\n");
    return $Self->ExitCodeOk();
}

1;
