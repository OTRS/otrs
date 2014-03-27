# --
# Kernel/Modules/AdminSMIME.pm - to add/update/delete smime keys
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AdminSMIME.pm,v 1.34.2.2 2011-05-09 20:44:32 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSMIME;

use strict;
use warnings;

use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.34.2.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (
        qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{CryptObject} = Kernel::System::Crypt->new( %Param, CryptType => 'SMIME' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{Search} = $Self->{ParamObject}->GetParam( Param => 'Search' );
    if ( !defined $Param{Search} ) {
        $Param{Search} = $Self->{SMIMESearch} || '';
    }
    if ( $Self->{Subaction} eq '' ) {
        $Param{Search} = '';
    }
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'SMIMESearch',
        Value     => $Param{Search},
    );

    # ------------------------------------------------------------ #
    # delete key
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {
        my $Hash = $Self->{ParamObject}->GetParam( Param => 'Hash' ) || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Hash ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Hash to delete!', );
        }
        my $Message = '';

        # remove private key
        if ( $Type eq 'key' ) {
            $Message = $Self->{CryptObject}->PrivateRemove( Hash => $Hash );
        }

        # remove certificate and private key if exists
        else {
            my $Certificate = $Self->{CryptObject}->CertificateGet( Hash => $Hash );
            my %Attributes
                = $Self->{CryptObject}->CertificateAttributes( Certificate => $Certificate, );
            $Message = $Self->{CryptObject}->CertificateRemove( Hash => $Hash );
            if ( $Attributes{Private} eq 'Yes' ) {
                $Message .= $Self->{CryptObject}->PrivateRemove( Hash => $Hash );
            }
        }

        my @List = $Self->{CryptObject}->Search( Search => $Param{Search} );
        if (@List) {
            for my $Key (@List) {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => { %{$Key} },
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }
        $Self->_Overview;
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        if ( $Message && $Message != 1 ) {
            $Output .= $Self->{LayoutObject}->Notify( Info => $Message );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSMIME',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show add certificate form
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ShowAddCertificate' ) {
        $Self->_MaskAdd(
            Type => 'Certificate',
            %Param,
        );
    }

    # ------------------------------------------------------------ #
    # add certificate
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddCertificate' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'SMIMESearch',
            Value     => '',
        );

        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        my %Errors;

        # check needed data
        if ( !%UploadStuff ) {
            $Errors{FileUploadInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add certificate
            my $NewCertificate
                = $Self->{CryptObject}->CertificateAdd( Certificate => $UploadStuff{Content} );

            if ($NewCertificate) {
                my @List = $Self->{CryptObject}->Search();
                if (@List) {
                    for my $Key (@List) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Row',
                            Data => { %{$Key} },
                        );
                    }
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'NoDataFoundMsg',
                        Data => {},
                    );
                }
                $Self->{LayoutObject}->Block(
                    Name => 'ActionList',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ActionAdd',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'SMIMEFilter',
                );
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => $NewCertificate );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminSMIME',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Errors{Message} = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # someting has gone wrong
        return $Self->_MaskAdd(
            Type => 'Certificate',
            %Param,
            %Errors,
        );
    }

    # ------------------------------------------------------------ #
    # show add private form
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ShowAddPrivate' ) {
        return $Self->_MaskAdd(
            Type => 'Private',
            %Param,
        );
    }

    # ------------------------------------------------------------ #
    # add private
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddPrivate' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my ( %GetParam, %Errors );

        $GetParam{Secret} = $Self->{ParamObject}->GetParam( Param => 'Secret' ) || '';

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'SMIMESearch',
            Value     => '',
        );
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        # check needed data
        if ( !%UploadStuff ) {
            $Errors{FileUploadInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add private key
            my $NewPrivate = $Self->{CryptObject}->PrivateAdd(
                Private => $UploadStuff{Content},
                Secret  => $GetParam{Secret},
            );

            if ($NewPrivate) {
                my @List = $Self->{CryptObject}->Search( Search => $Param{Search} );
                if (@List) {
                    for my $Key (@List) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Row',
                            Data => { %{$Key} },
                        );
                    }
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'NoDataFoundMsg',
                        Data => {},
                    );
                }
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => $NewPrivate );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminSMIME',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Errors{Message} = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # someting has gone wrong
        return $Self->_MaskAdd(
            Type => 'Private',
            %Param,
            %Errors,
        );
    }

    # ------------------------------------------------------------ #
    # download fingerprint
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DownloadFingerprint' ) {
        my $Hash = $Self->{ParamObject}->GetParam( Param => 'Hash' ) || '';
        if ( !$Hash ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Hash to download!', );
        }
        my $Certificate = $Self->{CryptObject}->CertificateGet( Hash => $Hash );
        my %Attributes = $Self->{CryptObject}->CertificateAttributes( Certificate => $Certificate );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $Attributes{Fingerprint},
            Filename    => "$Hash.txt",
            Type        => 'inline',
        );
    }

    # ------------------------------------------------------------ #
    # download key
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        my $Hash = $Self->{ParamObject}->GetParam( Param => 'Hash' ) || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Hash ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Hash to download!', );
        }
        my $Download = '';

        # download key
        if ( $Type eq 'key' ) {
            my $Secret = '';
            ( $Download, $Secret ) = $Self->{CryptObject}->PrivateGet( Hash => $Hash );
        }

        # download certificate
        else {
            $Download = $Self->{CryptObject}->CertificateGet( Hash => $Hash );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $Download,
            Filename    => "$Hash.pem",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check if SMIME is activated in the sysconfig first
        if ( !$Self->{ConfigObject}->Get('SMIME') ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"Please activate %s first!", "SMIME"}',
                Link =>
                    '$Env{"Baselink"}Action=AdminSysConfig;Subaction=Edit;SysConfigGroup=Framework;SysConfigSubGroup=Crypt::SMIME',
            );
        }

        # check if SMIME Paths are writable
        for my $PathKey (qw(SMIME::CertPath SMIME::PrivatePath)) {
            if ( !-w $Self->{ConfigObject}->Get($PathKey) ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Data     => '$Text{"%s is not writable!", "'
                        . "$PathKey "
                        . $Self->{ConfigObject}->Get($PathKey) . '"}',
                    Link =>
                        '$Env{"Baselink"}Action=AdminSysConfig;Subaction=Edit;SysConfigGroup=Framework;SysConfigSubGroup=Crypt::SMIME',
                );
            }
        }
        if ( !$Self->{CryptObject} && $Self->{ConfigObject}->Get('SMIME') ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"Cannot create %s!", "CryptObject"}',
                Link =>
                    '$Env{"Baselink"}Action=AdminSysConfig;Subaction=Edit;SysConfigGroup=Framework;SysConfigSubGroup=Crypt::SMIME',
            );
        }
        if ( $Self->{CryptObject} && $Self->{CryptObject}->Check() ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"' . $Self->{CryptObject}->Check() . '"}',
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSMIME',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MaskAdd {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'ActionList',
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionOverview',
    );

    # show the right dtl block
    $Self->{LayoutObject}->Block(
        Name => 'OverviewAdd' . $Param{Type},
        Data => \%Param,
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Param{Message}
        ? $Self->{LayoutObject}->Notify(
        Priority => 'Error',
        Info     => $Param{Message},
        )
        : '';
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSMIME',
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my @List = ();
    if ( $Self->{CryptObject} ) {
        @List = $Self->{CryptObject}->Search();
    }
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
    );
    if (@List) {
        for my $Attributes (@List) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => $Attributes,
            );
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    $Self->{LayoutObject}->Block(
        Name => 'ActionList',
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionAdd',
    );
    $Self->{LayoutObject}->Block(
        Name => 'SMIMEFilter',
    );
    return 1;
}

1;
