# --
# Kernel/Output/HTML/PreferencesSMIME.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesSMIME;

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem MainObject EncodeObject)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    return if !$Self->{ConfigObject}->Get('SMIME');

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

    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
        Param  => 'UserSMIMEKey',
        Source => 'String',
    );
    return 1 if !$UploadStuff{Content};

    my $CryptObject = Kernel::System::Crypt->new(
        LogObject    => $Self->{LogObject},
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        EncodeObject => $Self->{EncodeObject},
        CryptType    => 'SMIME',
        MainObject   => $Self->{MainObject},
    );
    return 1 if !$CryptObject;

    my %Result = $CryptObject->CertificateAdd( Certificate => $UploadStuff{Content} );
    if ( !$Result{Successful} ) {
        $Self->{Error} = $Result{Message};
        return;
    }
    else {
        my %Attributes = $CryptObject->CertificateAttributes(
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

    my $CryptObject = Kernel::System::Crypt->new(
        LogObject    => $Self->{LogObject},
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        EncodeObject => $Self->{EncodeObject},
        CryptType    => 'SMIME',
        MainObject   => $Self->{MainObject},
    );
    return 1 if !$CryptObject;

    # get preferences with key parameters
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Param{UserData}->{UserID},
    );

    # check if SMIMEFilename is there
    if ( !$Preferences{SMIMEFilename} ) {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => 'Need SMIMEFilename to get certificate of user: '
                . $Param{UserData}->{UserID},
        );
        return;
    }
    else {
        $Preferences{SMIMECert} = $CryptObject->CertificateGet(
            Filename => $Preferences{SMIMEFilename},
        );
    }

    # check if cert exists
    if ( !$Preferences{SMIMECert} ) {
        $Self->{LogObject}->Log(
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
