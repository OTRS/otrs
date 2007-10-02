# --
# Kernel/Output/HTML/PreferencesPGP.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PreferencesPGP.pm,v 1.10 2007-10-02 10:40:12 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesPGP;

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get env
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem MainObject))
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params = ();
    if ( !$Self->{ConfigObject}->Get('PGP') ) {
        return ();
    }
    push(
        @Params,
        {   %Param,
            Name     => $Self->{ConfigItem}->{PrefKey},
            Block    => 'Upload',
            Filename => $Param{UserData}->{"PGPFilename"},
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
        Param  => "UserPGPKey",
        Source => 'String',
    );
    if ( !$UploadStuff{Content} ) {
        return 1;
    }
    my $CryptObject = Kernel::System::Crypt->new(
        LogObject    => $Self->{LogObject},
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        CryptType    => 'PGP',
        MainObject   => $Self->{MainObject},
    );
    if ( !$CryptObject ) {
        return 1;
    }
    my $Message = $CryptObject->KeyAdd( Key => $UploadStuff{Content} );
    if ( !$Message ) {
        $Self->{Error} = $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => 'Message',
        );
        return;
    }
    else {
        if ( $Message =~ /gpg: key (.*):/ ) {
            my @Result = $CryptObject->PublicKeySearch( Search => $1 );
            if ( $Result[0] ) {
                $UploadStuff{Filename}
                    = "$Result[0]->{Identifier}-$Result[0]->{Bit}-$Result[0]->{Key}.$Result[0]->{Type}";
            }
        }

        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => "PGPKeyID",                   # new parameter PGPKeyID
            Value  => $1,                           # write KeyID on a per user base
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => "PGPFilename",
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

    my $CryptObject = Kernel::System::Crypt->new(
        LogObject    => $Self->{LogObject},
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        CryptType    => 'PGP',
        MainObject   => $Self->{MainObject},
    );
    if ( !$CryptObject ) {
        return 1;
    }

    # get preferences with key parameters
    my %Preferences = $Self->{UserObject}->GetPreferences( UserID => $Param{UserData}->{UserID}, );

    # check if PGPKeyID is there
    if ( !$Preferences{'PGPKeyID'} ) {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => 'Need KeyID to get pgp public key of ' . $Param{UserData}->{UserID},
        );
        return ();
    }
    else {
        $Preferences{'PGPKeyContent'}
            = $CryptObject->PublicKeyGet( Key => $Preferences{'PGPKeyID'}, );
    }

    # return content of key
    if ( !$Preferences{'PGPKeyContent'} ) {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => 'Couldn\'t get ASCII exported pubKey for KeyID ' . $Preferences{'PGPKeyID'},
        );
        return;
    }
    else {
        return (
            ContentType => 'text/plain',
            Content     => $Preferences{'PGPKeyContent'},
            Filename    => $Preferences{'PGPFilename'} || $Preferences{'PGPKeyID'} . '_pgp.asc',
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
