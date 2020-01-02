# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::SMIME::KeysRefresh;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::SMIME',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Normalize S/MIME private secrets and rename all certificates to the correct hash.');
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

    my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin') || '/usr/bin/openssl';
    if ( !-e $OpenSSLBin ) {
        die "OpenSSL binary $OpenSSLBin does not exists!\n";
    }
    elsif ( !-x $OpenSSLBin ) {
        die "OpenSSL binary $OpenSSLBin is not executable!\n";
    }

    my $CertPath = $ConfigObject->Get('SMIME::CertPath');
    if ( !-e $CertPath ) {
        die "Certificates directory $CertPath does not exist!\n";
    }
    elsif ( !-d $CertPath ) {
        die "Certificates directory $CertPath is not really a directory!\n";
    }
    elsif ( !-w $CertPath ) {
        die "Certificates directory $CertPath is not writable!\n";
    }

    my $PrivatePath = $ConfigObject->Get('SMIME::PrivatePath');
    if ( !-e $PrivatePath ) {
        die "Private keys directory $PrivatePath does not exist!\n";
    }
    elsif ( !-d $PrivatePath ) {
        die "Private keys directory $PrivatePath is not really a directory!\n";
    }
    elsif ( !-w $PrivatePath ) {
        die "Private keys directory $PrivatePath is not writable!\n";
    }

    my $CryptObject;
    eval {
        $CryptObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    };
    if ( !$CryptObject ) {
        die "No S/MIME support!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DetailLevel = $Self->GetOption('verbose') ? 'Details' : 'ShortDetails';

    if ( $DetailLevel ne 'Details' ) {
        $Self->Print("<yellow>Refreshing S/MIME keys...</yellow>\n");
    }

    my $CheckCertPathResult = $Kernel::OM->Get('Kernel::System::Crypt::SMIME')->CheckCertPath();

    if ( $CheckCertPathResult->{$DetailLevel} ) {
        $Self->Print( $CheckCertPathResult->{$DetailLevel} );
    }

    if ( !$CheckCertPathResult->{Success} ) {
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
