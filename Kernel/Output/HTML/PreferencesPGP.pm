# --
# Kernel/Output/HTML/PreferencesPGP.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PreferencesPGP.pm,v 1.2 2005-03-27 11:40:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesPGP;

use strict;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Param {
    my $Self = shift;
    my %Param = @_;
    my @Params = ();
    if (!$Self->{ConfigObject}->Get('PGP')) {
        return ();
    }
    push (@Params, {
            %Param,
            Name => $Self->{ConfigItem}->{PrefKey},
            Block => 'Upload',
            Filename => $Param{UserData}->{"PGPFilename"},
        },
    );
    return @Params;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
        Param => "UserPGPKey",
        Source => 'String',
    );
    if (!%UploadStuff) {
        return 1;
    }
    my $CryptObject = Kernel::System::Crypt->new(
        LogObject => $Self->{LogObject},
        DBObject => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        CryptType => 'PGP',
    );
    if (!$CryptObject) {
        return 1;
    }
    my $Message = $CryptObject->KeyAdd(Key => $UploadStuff{Content});
    if (!$Message) {
        $Self->{Error} = $Self->{LogObject}->GetLogEntry(
            Type => 'Error',
            What => 'Message',
        );
        return;
    }
    else {
        if ($Message =~ /gpg: key (.*):/) {
            my @Result = $CryptObject->PublicKeySearch(Search => $1);
            if ($Result[0]) {
                $UploadStuff{Filename} = "$Result[0]->{Identifier}-$Result[0]->{Bit}-$Result[0]->{Key}.$Result[0]->{Type}";
            }
        }
print STDERR "$UploadStuff{Filename}, ------------\n";
#        $Self->{UserObject}->SetPreferences(
#            UserID => $Param{UserData}->{UserID},
#            Key => 'UserPGPKey',
#            Value => $UploadStuff{Content},
#        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key => "PGPFilename",
            Value => $UploadStuff{Filename},
        );
        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key => "PGPContentType",
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
