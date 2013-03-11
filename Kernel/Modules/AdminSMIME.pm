# --
# Kernel/Modules/AdminSMIME.pm - to add/update/delete smime keys
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSMIME;

use strict;
use warnings;

use Kernel::System::Crypt;
use Kernel::System::CustomerUser;

use vars qw($VERSION);

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
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

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
    # delete cert
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' ) || '';
        my $Type     = $Self->{ParamObject}->GetParam( Param => 'Type' )     || '';
        if ( !$Filename ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Filename to delete!',
            );
        }

        my @Result;
        my %Result;

        # remove private key
        if ( $Type eq 'key' ) {
            %Result = $Self->{CryptObject}->PrivateRemove( Filename => $Filename );
            push @Result, \%Result if %Result;
        }

        # remove certificate and private key if exists
        else {
            my $Certificate = $Self->{CryptObject}->CertificateGet( Filename => $Filename );
            my %Attributes
                = $Self->{CryptObject}->CertificateAttributes( Certificate => $Certificate, );

            %Result = $Self->{CryptObject}->CertificateRemove( Filename => $Filename );
            push @Result, \%Result if %Result;

            # delete certificate from customer preferences
            if ( $Result{Successful} ) {

                # check if there are customers that have assigned the certificate in their
                # preferences
                my %UserList = $Self->{CustomerUserObject}->SearchPreferences(
                    Key   => 'SMIMEFilename',
                    Value => $Filename,
                );

                # loop all customers that have assigned certificate in their preferences
                for my $UserID ( sort keys %UserList ) {

                    # reset all SMIME preferences for the customer
                    for my $PreferenceKey (qw(SMIMEHash SMIMEFingerprint SMIMEFilename)) {
                        my $Success = $Self->{CustomerUserObject}->SetPreferences(
                            Key    => $PreferenceKey,
                            Value  => '',
                            UserID => $UserID,
                        );
                        if ( !$Success ) {
                            $Self->{LogObject}->Log(
                                Priority => 'error',
                                Message =>
                                    "Could not reset preference $PreferenceKey for customer $UserID",
                            );
                        }
                    }
                }
            }

            if ( defined $Attributes{Private} && $Attributes{Private} eq 'Yes' ) {
                %Result = $Self->{CryptObject}->PrivateRemove( Filename => $Filename );
                push @Result, \%Result if %Result;
            }
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Output .= $Self->_Overview( Result => \@Result );

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
            my %Result
                = $Self->{CryptObject}->CertificateAdd( Certificate => $UploadStuff{Content} );
            my @Result;
            push @Result, \%Result if %Result;

            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            $Output .= $Self->_Overview( Result => \@Result, );

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSMIME',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # something has gone wrong
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
            my %Result = $Self->{CryptObject}->PrivateAdd(
                Private => $UploadStuff{Content},
                Secret  => $GetParam{Secret},
            );

            my @Result;
            push @Result, \%Result if %Result;

            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            $Output .= $Self->_Overview( Result => \@Result, );

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSMIME',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # something has gone wrong
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
        my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' ) || '';
        if ( !$Filename ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Filename to download!',
            );
        }

        my $Hash = $Filename;
        $Hash =~ s{(.+)\.\d}{$1}xms;

        my $Certificate = $Self->{CryptObject}->CertificateGet( Filename => $Filename );
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
        my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' ) || '';

        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Filename ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Filename to download!',
            );
        }

        my $Hash = $Filename;
        $Hash =~ s{(.+)\.\d}{$1}xms;

        my $Download;

        # download key
        if ( $Type eq 'key' ) {
            my $Secret;
            ( $Download, $Secret ) = $Self->{CryptObject}->PrivateGet( Filename => $Filename );
        }

        # download certificate
        else {
            $Download = $Self->{CryptObject}->CertificateGet( Filename => $Filename );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $Download,
            Filename    => "$Hash.pem",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # SignerCertificates
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SignerRelations' ) {

        # look for needed parameters
        my $CertFingerprint = $Self->{ParamObject}->GetParam( Param => 'Fingerprint' ) || '';
        my $Output = $Self->_SignerCertificateOverview( CertFingerprint => $CertFingerprint );

        return $Output;
    }

    # ------------------------------------------------------------ #
    # SignerRelationAdd
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SignerRelationAdd' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # look for needed parameters
        my $CertFingerprint = $Self->{ParamObject}->GetParam( Param => 'CertFingerprint' ) || '';
        my $CAFingerprint   = $Self->{ParamObject}->GetParam( Param => 'CAFingerprint' )   || '';

        if ( !$CertFingerprint || !$CAFingerprint ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Needed CertFingerprint and CAFingerprint',
            );
        }

        # relation already exists?
        my $Exists = $Self->{CryptObject}->SignerCertRelationExists(
            CertFingerprint => $CertFingerprint,
            CAFingerprint   => $CAFingerprint,
        );

        my %Message;
        my $Error;
        my $Output;
        if ( $CertFingerprint eq $CAFingerprint ) {
            $Message{Priority} = 'Error';
            $Message{Message}  = 'CAFingerprint must be different than CertFingerprint';
            $Error             = 1;
        }
        elsif ($Exists) {
            $Message{Priority} = 'Error';
            $Message{Message}  = 'Relation exists!';
            $Error             = 1;
        }

        if ($Error) {
            $Output = $Self->_SignerCertificateOverview(
                CertFingerprint => $CertFingerprint,
                Message         => \%Message,
            );
        }
        else {
            my $Result = $Self->{CryptObject}->SignerCertRelationAdd(
                CertFingerprint => $CertFingerprint,
                CAFingerprint   => $CAFingerprint,
                UserID          => $Self->{UserID},
            );

            if ($Result) {
                $Message{Priority} = 'Notify';
                $Message{Message}  = 'Relation added!';
            }
            else {
                $Message{Priority} = 'Error';
                $Message{Message}  = 'Imposible to add relation!';
            }

            $Output = $Self->_SignerCertificateOverview(
                CertFingerprint => $CertFingerprint,
                Message         => \%Message,
            );
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # SignerRelationDelete
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SignerRelationDelete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # look for needed parameters
        my $CertFingerprint = $Self->{ParamObject}->GetParam( Param => 'CertFingerprint' ) || '';
        my $CAFingerprint   = $Self->{ParamObject}->GetParam( Param => 'CAFingerprint' )   || '';

        if ( !$CertFingerprint && !$CAFingerprint ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Needed CertFingerprint and CAFingerprint!',
            );
        }

        # relation exists?
        my $Exists = $Self->{CryptObject}->SignerCertRelationExists(
            CertFingerprint => $CertFingerprint,
            CAFingerprint   => $CAFingerprint,
        );

        my %Message;
        my $Error;
        my $Output;
        if ( !$Exists ) {
            $Message{Priority} = 'Error';
            $Message{Message}  = 'Relation doesn\'t exists';
            $Error             = 1;
        }

        if ($Error) {
            $Output = $Self->_SignerCertificateOverview(
                CertFingerprint => $CertFingerprint,
                Message         => \%Message,
            );
        }
        else {
            my $Success = $Self->{CryptObject}->SignerCertRelationDelete(
                CertFingerprint => $CertFingerprint,
                CAFingerprint   => $CAFingerprint,
                UserID          => $Self->{UserID},
            );

            if ($Success) {
                $Message{Priority} = 'Notify';
                $Message{Message}  = 'Relation deleted!';
            }
            else {
                $Message{Priority} = 'Error';
                $Message{Message}  = 'Imposible to delete relation!';
            }

            $Output = $Self->_SignerCertificateOverview(
                CertFingerprint => $CertFingerprint,
                Message         => \%Message,
            );
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # read certificate
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Read' ) {
        my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' ) || '';
        if ( !$Filename ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'Need param Filename to download!'
            );
        }

        my $Output = $Self->_CertificateRead( Filename => $Filename );

        if ( !$Output ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Certificate $Filename could not be read!"
            );
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Output .= $Self->_Overview() || '';

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
    $Self->{LayoutObject}->Block( Name => 'Hint' );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSMIME',
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output;

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

    for my $Message ( @{ $Param{Result} } ) {
        my $Priority = ( $Message->{Successful} ? 'Notice' : 'Error' );
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => $Priority,
            Data     => $Message->{Message},
        );
    }

    my @List = ();
    if ( $Self->{CryptObject} ) {
        @List = $Self->{CryptObject}->Search();
    }
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
    );
    if (@List) {
        for my $Attributes (@List) {

            # check if there is an invalid file in the SMIME directories and add explicit
            # attributes to make it more easy to identify
            if ( !defined $Attributes->{Type} && !defined $Attributes->{Subject} ) {
                $Attributes->{Type}    = 'Invalid';
                $Attributes->{Subject} = "The file: '$Attributes->{Filename}' is invalid";
            }
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => $Attributes,
            );
            if ( defined $Attributes->{Type} && $Attributes->{Type} eq 'key' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'CertificateRelationAdd',
                    Data => $Attributes,
                );
            }
            elsif ( defined $Attributes->{Type} && $Attributes->{Type} eq 'cert' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'CertificateRead',
                    Data => $Attributes,
                );
            }
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

    return $Output;
}

sub _SignerCertificateOverview {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CertFingerprint} ) {
        return $Self->{LayoutObject}->ErrorScreen( Message => 'Needed Fingerprint', );
    }

    my @SignerCertResults = $Self->{CryptObject}->PrivateSearch(
        Search => $Param{CertFingerprint},
    );
    my %SignerCert;
    %SignerCert = %{ $SignerCertResults[0] } if @SignerCertResults;

    # get all certificates
    my @AvailableCerts = $Self->{CryptObject}->CertificateSearch();

    # get all relations for that certificate @ActualRelations
    my @ActualRelations = $Self->{CryptObject}->SignerCertRelationGet(
        CertFingerprint => $Param{CertFingerprint},
    );

    # get needed data from actual relations
    my @RelatedCerts;
    for my $RelatedCert (@ActualRelations) {
        my @Certificate = $Self->{CryptObject}->CertificateSearch(
            Search => $RelatedCert->{CAFingerprint},
        );
        push @RelatedCerts, $Certificate[0] if $Certificate[0];
    }

    # filter the list, show as available cert just those which are not in the list of related certs
    # and is not equal to the actual Certificate Fingerprint
    my @ShowCertList;
    my %RelatedCerts = map { $_->{Fingerprint} => 1 } @RelatedCerts;
    @ShowCertList = grep ( !defined $RelatedCerts{ $_->{Fingerprint} }
            && $_->{Fingerprint} ne $Param{CertFingerprint}, @AvailableCerts );

    $Self->{LayoutObject}->Block(
        Name => 'ActionList',
    );
    $Self->{LayoutObject}->Block(
        Name => 'ActionOverview',
    );
    $Self->{LayoutObject}->Block(
        Name => 'SignerCertHint',
    );

    $Self->{LayoutObject}->Block(
        Name => 'SignerCertificates',
        Data => {
            CertFingerprint => $SignerCert{Subject},
        },
    );

    if (@RelatedCerts) {
        for my $ActualRelation (@RelatedCerts) {
            $Self->{LayoutObject}->Block(
                Name => 'RelatedCertsRow',
                Data => {
                    %{$ActualRelation},
                    CertFingerprint => $Param{CertFingerprint},
                },
            );
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'RelatedCertsNoDataFoundMsg',
        );
    }

    if (@ShowCertList) {
        for my $AvailableCert (@ShowCertList) {
            $Self->{LayoutObject}->Block(
                Name => 'AvailableCertsRow',
                Data => {
                    %{$AvailableCert},
                    CertFingerprint => $Param{CertFingerprint},
                },
            );
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'AvailableCertsNoDataFoundMsg',
        );
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    if ( $Param{Message} ) {
        my %Message = %{ $Param{Message} };
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => $Message{Type},
            Info     => $Message{Message},
        );
    }

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
        Data         => {
            %Param,
            Subtitle => 'Handle Private Certificate Relations',
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _CertificateRead {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Filename},
        Type  => 'Small',
    );

    # get the certificate content as plain text
    my $CertificateText = $Self->{CryptObject}->CertificateRead(%Param);

    return if !$CertificateText;

    # convert content to html string
    $Param{CertificateText} = $Self->{LayoutObject}->Ascii2Html(
        Text           => $CertificateText,
        HTMLResultMode => 1,
    );

    $Output
        .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminSMIMECertRead', Data => \%Param );

    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );
    return $Output;

}
1;
