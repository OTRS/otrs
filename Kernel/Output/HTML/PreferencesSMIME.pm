# --
# Kernel/Output/HTML/PreferencesSMIME.pm
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PreferencesSMIME.pm,v 1.1 2004-12-28 01:19:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesSMIME;

use strict;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get env
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Param {
    my $Self = shift;
    my %Param = @_;
    my @Params = ();
    if (!$Self->{ConfigObject}->Get('SMIME')) {
        return ();
    }
    push (@Params, {
            %Param,
            Name => $Param{PrefKey},
            Block => 'Upload',
            Filename => $Param{UserData}->{"SMIMEFilename"},
        },
    );
    return @Params;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
        Param => "UserSMIMEKey",
        Source => 'String',
    );
    if (!%UploadStuff) {
        return 1;
    }
    my $CryptObject = Kernel::System::Crypt->new(
        LogObject => $Self->{LogObject},
        DBObject => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        CryptType => 'SMIME',
    );
    if (!$CryptObject) {
        return 1;
    }
    my $Message = $CryptObject->CertificateAdd(Certificate => $UploadStuff{Content});
    if (!$Message) {
        $Self->{Error} = $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => 'Message',
        );
        return;
    }
    else {
        my %Attributes = $CryptObject->CertificateAttributes(
            Certificate => $UploadStuff{Content},
        );
        if ($Attributes{Hash}) {
            $UploadStuff{Filename} = "$Attributes{Hash}.pem";
        }
#        $Self->{UserObject}->SetPreferences(
#            UserID => $Param{UserData}->{UserID},
#            Key => 'UserPGPKey',
#            Value => $UploadStuff{Content},
#        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key => "SMIMEFilename",
            Value => $UploadStuff{Filename},
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key => "SMIMEContentType",
            Value => $UploadStuff{ContentType},
        );
        $Self->{Message} = $Message;
        return 1;
    }
}
sub Download {
    my $Self = shift;
    my %Param = @_;
    return (
        Content => 123,
        ContentType => ,
        Filename => ,
    );
}
sub Error {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Error} || '';
}
sub Message {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Message} || '';
}
1;
