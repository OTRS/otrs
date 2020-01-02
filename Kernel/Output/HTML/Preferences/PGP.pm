# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Preferences::PGP;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Crypt::PGP',
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

    return if !$Kernel::OM->Get('Kernel::Config')->Get('PGP');

    my @Params = ();
    push(
        @Params,
        {
            %Param,
            Name     => $Self->{ConfigItem}->{PrefKey},
            Block    => 'Upload',
            Filename => $Param{UserData}->{PGPFilename},
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %UploadStuff = $Kernel::OM->Get('Kernel::System::Web::Request')->GetUploadAll(
        Param => 'UserPGPKey',
    );
    return 1 if !$UploadStuff{Content};

    my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');
    return 1 if !$PGPObject;

    my $Message = $PGPObject->KeyAdd( Key => $UploadStuff{Content} );
    if ( !$Message ) {
        $Self->{Error} = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
            Type => 'Error',
            What => 'Message',
        );
        return;
    }
    else {
        if ( $Message =~ /gpg: key (.*):/ ) {
            my @Result = $PGPObject->PublicKeySearch( Search => $1 );
            if ( $Result[0] ) {
                $UploadStuff{Filename}
                    = "$Result[0]->{Identifier}-$Result[0]->{Bit}-$Result[0]->{Key}.$Result[0]->{Type}";
            }
        }

        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'PGPKeyID',                   # new parameter PGPKeyID
            Value  => $1,                           # write KeyID on a per user base
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'PGPFilename',
            Value  => $UploadStuff{Filename},
        );

        #        $Self->{UserObject}->SetPreferences(
        #            UserID => $Param{UserData}->{UserID},
        #            Key => 'UserPGPKey',
        #            Value => $UploadStuff{Content},
        #        );
        #        $Self->{UserObject}->SetPreferences(
        #            UserID => $Param{UserData}->{UserID},
        #            Key => "PGPContentType",
        #            Value => $UploadStuff{ContentType},
        #        );
        $Self->{Message} = $Message;
        return 1;
    }
}

sub Download {
    my ( $Self, %Param ) = @_;

    my $PGPObject = $Kernel::OM->Get('Kernel::System::Crypt::PGP');
    return 1 if !$PGPObject;

    # get preferences with key parameters
    my %Preferences = $Self->{UserObject}->GetPreferences(
        UserID => $Param{UserData}->{UserID},
    );

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check if PGPKeyID is there
    if ( !$Preferences{PGPKeyID} ) {
        $LogObject->Log(
            Priority => 'Error',
            Message  => 'Need KeyID to get pgp public key of ' . $Param{UserData}->{UserID},
        );
        return ();
    }
    else {
        $Preferences{PGPKeyContent} = $PGPObject->PublicKeyGet(
            Key => $Preferences{PGPKeyID},
        );
    }

    # return content of key
    if ( !$Preferences{PGPKeyContent} ) {
        $LogObject->Log(
            Priority => 'Error',
            Message  => 'Couldn\'t get ASCII exported pubKey for KeyID ' . $Preferences{'PGPKeyID'},
        );
        return;
    }
    else {
        return (
            ContentType => 'text/plain',
            Content     => $Preferences{PGPKeyContent},
            Filename    => $Preferences{PGPFilename} || $Preferences{PGPKeyID} . '_pgp.asc',
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
