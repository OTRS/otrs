# --
# Kernel/Modules/AdminSMIME.pm - to add/update/delete pgp keys
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminSMIME.pm,v 1.16.2.1 2008-07-24 10:09:13 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminSMIME;

use strict;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    $Self->{CryptObject} = Kernel::System::Crypt->new(%Param, CryptType => 'SMIME');

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Search} = $Self->{ParamObject}->GetParam(Param => 'Search');
    if (!defined($Param{Search})) {
        $Param{Search} = $Self->{SMIMESearch} || '';
    }
    if ($Self->{Subaction} eq '' ) {
        $Param{Search} = '';
    }
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'SMIMESearch',
        Value => $Param{Search},
    );

    # delete key
    if ($Self->{Subaction} eq 'Delete') {
        my $Hash = $Self->{ParamObject}->GetParam(Param => 'Hash') || '';
        my $Type = $Self->{ParamObject}->GetParam(Param => 'Type') || '';
        if (!$Hash) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Hash to delete!',
            );
        }
        my $Message = '';
        # remove private key
        if ($Type eq 'key') {
            $Message = $Self->{CryptObject}->PrivateRemove(Hash => $Hash);
        }
        # remove certificate and private key if exists
        else {
            my $Certificate = $Self->{CryptObject}->CertificateGet(Hash => $Hash);
            my %Attributes = $Self->{CryptObject}->CertificateAttributes(
                Certificate => $Certificate,
            );
            $Message = $Self->{CryptObject}->CertificateRemove(Hash => $Hash);
            if ($Attributes{Private} eq 'Yes') {
                $Message .= $Self->{CryptObject}->PrivateRemove(Hash => $Hash);
            }
        }

        my @List = $Self->{CryptObject}->Search(Search => $Param{Search});
        foreach my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if ($Message) {
            $Output .= $Self->{LayoutObject}->Notify(Info => $Message);
        }
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminSMIMEForm', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # add certivicate
    elsif ($Self->{Subaction} eq 'AddCertificate') {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'SMIMESearch',
            Value => '',
        );
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'String',
        );
        if (!%UploadStuff) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need Certificate!',
            );
        }
        my $Message = $Self->{CryptObject}->CertificateAdd(Certificate => $UploadStuff{Content});
        if (!$Message) {
            $Message = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => 'Message',
            );
        }
        my @List = $Self->{CryptObject}->Search(Search => $Param{Search});
        foreach my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify(Info => $Message);
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminSMIMEForm', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # add private
    elsif ($Self->{Subaction} eq 'AddPrivate') {
        my $Secret = $Self->{ParamObject}->GetParam(Param => 'Secret') || '';
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'SMIMESearch',
            Value => '',
        );
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'String',
        );
        if (!%UploadStuff) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need Private Key!',
            );
        }
        my $Message = $Self->{CryptObject}->PrivateAdd(
            Private => $UploadStuff{Content},
            Secret => $Secret,
        );
        if (!$Message) {
            $Message = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => 'Message',
            );
        }
        my @List = $Self->{CryptObject}->Search(Search => $Param{Search});
        foreach my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont => '</font>',
                    %{$Key},
                },
            );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify(Info => $Message);
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminSMIMEForm', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # download fingerprint
    elsif ($Self->{Subaction} eq 'DownloadFingerprint') {
        my $Hash = $Self->{ParamObject}->GetParam(Param => 'Hash') || '';
        if (!$Hash) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Hash to download!',
            );
        }
        my $Certificate = $Self->{CryptObject}->CertificateGet(Hash => $Hash);
        my %Attributes = $Self->{CryptObject}->CertificateAttributes(Certificate => $Certificate);
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content => $Attributes{Fingerprint},
            Filename => "$Hash.txt",
            Type => 'inline',
        );
    }
    # download key
    elsif ($Self->{Subaction} eq 'Download') {
        my $Hash = $Self->{ParamObject}->GetParam(Param => 'Hash') || '';
        my $Type = $Self->{ParamObject}->GetParam(Param => 'Type') || '';
        if (!$Hash) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Hash to download!',
            );
        }
        my $Download = '';
        # download key
        if ($Type eq 'key') {
            my $Secret = '';
            ($Download, $Secret) = $Self->{CryptObject}->PrivateGet(Hash => $Hash);
        }
        # download certificate
        else {
            $Download = $Self->{CryptObject}->CertificateGet(Hash => $Hash);
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content => $Download,
            Filename => "$Hash.pem",
            Type => 'attachment',
        );
    }
    # search key
    else {
        my @List = ();
        if ($Self->{CryptObject}) {
            @List = $Self->{CryptObject}->Search(Search => $Param{Search});
        }
        foreach my $Key (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    StartFont => '<font color ="red">',
                    StopFont => '</font>',
                    %{$Key},
                },
            );
        }
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if (!$Self->{CryptObject}) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data => '$Text{"You need to activate %s first to use it!", "SMIME"}',
                Link => '$Env{"Baselink"}Action=AdminSysConfig&Subaction=Edit&SysConfigGroup=Framework&SysConfigSubGroup=Crypt::SMIME"',
            );
        }
        if ($Self->{CryptObject} && $Self->{CryptObject}->Check()) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data => '$Text{"'.$Self->{CryptObject}->Check().'"}',
            );
        }
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminSMIMEForm', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}

1;
