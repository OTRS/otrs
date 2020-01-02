# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Preferences::SMIME;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Crypt::SMIME',
    'Kernel::Config',
    'Kernel::System::Web::Request',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw( UserID UserObject ConfigItem )) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    return if !$Kernel::OM->Get('Kernel::Config')->Get('SMIME');

    my @Params = ();
    push(
        @Params,
        {
            %Param,
            Name     => $Self->{ConfigItem}->{PrefKey},
            Block    => 'Upload',
            Filename => $Param{UserData}->{SMIMEFilename},
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %UploadStuff = $Kernel::OM->Get('Kernel::System::Web::Request')->GetUploadAll(
        Param => 'UserSMIMEKey',
    );
    return 1 if !$UploadStuff{Content};

    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    return 1 if !$SMIMEObject;

    my %Result = $SMIMEObject->CertificateAdd( Certificate => $UploadStuff{Content} );
    if ( !$Result{Successful} ) {
        $Self->{Error} = $Result{Message};
        return;
    }
    else {
        my %Attributes = $SMIMEObject->CertificateAttributes(
            Certificate => $UploadStuff{Content},
        );
        if ( $Result{Filename} ) {
            $UploadStuff{Filename} = $Result{Filename};
        }

        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'SMIMEHash',
            Value  => $Attributes{Hash},
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'SMIMEFingerprint',
            Value  => $Attributes{Fingerprint},
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'SMIMEFilename',
            Value  => $UploadStuff{Filename},
        );

        $Self->{Message} = $Result{Message};
        return 1;
    }
}

sub Download {
    my ( $Self, %Param ) = @_;

    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');
    return 1 if !$SMIMEObject;

    # get preferences with key parameters
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Param{UserData}->{UserID},
    );

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check if SMIMEFilename is there
    if ( !$Preferences{SMIMEFilename} ) {
        $LogObject->Log(
            Priority => 'Error',
            Message  => 'Need SMIMEFilename to get certificate of user: '
                . $Param{UserData}->{UserID},
        );
        return;
    }
    else {
        $Preferences{SMIMECert} = $SMIMEObject->CertificateGet(
            Filename => $Preferences{SMIMEFilename},
        );
    }

    # check if cert exists
    if ( !$Preferences{SMIMECert} ) {
        $LogObject->Log(
            Priority => 'Error',
            Message  => 'Couldn\'t get cert' . $Preferences{SMIMEFilename},
        );
        return;
    }
    else {
        return (
            ContentType => 'text/plain',
            Content     => $Preferences{SMIMECert},
            Filename    => $Preferences{SMIMEFilename},
        );
    }
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
