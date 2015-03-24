# --
# Kernel/System/Console/Command/Maint/SMIME/KeysRefresh.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::SMIME::KeysRefresh;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::SMIME',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Normalize SMIME private secrets and rename all certificates to the correct hash.');
    $Self->AddOption(
        Name        => 'verbose',
        Description => "Print detailed command output.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'force',
        Description => "force to execute even if SMIME is not enabled in SysConfig.",
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
        die "SMIME is not activated in SysConfig!\n";
    }

    my $OpenSSLBin = $ConfigObject->Get('SMIME::Bin');
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
        die "Private keys directory $PrivatePath does not exist\n";
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
        die "No SMIME support!.\n"
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DetailLevel = $Self->GetOption('verbose') ? 'Details' : 'ShortDetails';

    if ( $DetailLevel ne 'Details' ) {
        $Self->Print("<yellow>Refreshing SMIME Keys...</yellow>\n");
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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
