# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminSMIME;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ------------------------------------------------------------ #
    # check if feature is active
    # ------------------------------------------------------------ #
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('SMIME') ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $LayoutObject->Block( Name => 'Overview' );
        $LayoutObject->Block( Name => 'Notice' );
        $LayoutObject->Block( Name => 'Disabled' );
        $LayoutObject->Block( Name => 'OverviewResult' );
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );

        $Output .= $LayoutObject->Output( TemplateFile => 'AdminSMIME' );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # get SMIME objects
    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    if ( !$SMIMEObject ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Info     => Translatable("S/MIME environment is not working. Please check log for more info!"),
            Link     => $LayoutObject->{Baselink} . 'Action=AdminLog',
        );

        $LayoutObject->Block( Name => 'Overview' );
        $LayoutObject->Block( Name => 'Notice' );
        $LayoutObject->Block( Name => 'NotWorking' );
        $LayoutObject->Block( Name => 'OverviewResult' );
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSMIME',
        );

        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    $Param{Search} = $ParamObject->GetParam( Param => 'Search' );
    if ( !defined $Param{Search} ) {
        $Param{Search} = $Self->{SMIMESearch} || '';
    }
    if ( $Self->{Subaction} eq '' ) {
        $Param{Search} = '';
    }

    # get session object
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'SMIMESearch',
        Value     => $Param{Search},
    );

    $Param{Action} = $Self->{Subaction};

    # ------------------------------------------------------------ #
    # delete cert
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Filename = $ParamObject->GetParam( Param => 'Filename' ) || '';
        my $Type     = $ParamObject->GetParam( Param => 'Type' )     || '';
        if ( !$Filename ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need param Filename to delete!'),
            );
        }

        my @Result;
        my %Result;

        # remove private key
        if ( $Type eq 'key' ) {
            %Result = $SMIMEObject->PrivateRemove( Filename => $Filename );
            push @Result, \%Result if %Result;
        }

        # remove certificate and private key if exists
        else {
            my $Certificate = $SMIMEObject->CertificateGet( Filename => $Filename );
            my %Attributes  = $SMIMEObject->CertificateAttributes(
                Certificate => $Certificate,
            );

            %Result = $SMIMEObject->CertificateRemove( Filename => $Filename );
            push @Result, \%Result if %Result;

            # delete certificate from customer preferences
            if ( $Result{Successful} ) {

                # check if there are customers that have assigned the certificate in their
                # preferences
                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
                my %UserList           = $CustomerUserObject->SearchPreferences(
                    Key   => 'SMIMEFilename',
                    Value => $Filename,
                );

                # loop all customers that have assigned certificate in their preferences
                for my $UserID ( sort keys %UserList ) {

                    # reset all SMIME preferences for the customer
                    for my $PreferenceKey (qw(SMIMEHash SMIMEFingerprint SMIMEFilename)) {
                        my $Success = $CustomerUserObject->SetPreferences(
                            Key    => $PreferenceKey,
                            Value  => '',
                            UserID => $UserID,
                        );
                        if ( !$Success ) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'error',
                                Message =>
                                    "Could not reset preference $PreferenceKey for customer $UserID",
                            );
                        }
                    }
                }
            }

            if ( defined $Attributes{Private} && $Attributes{Private} eq 'Yes' ) {
                %Result = $SMIMEObject->PrivateRemove( Filename => $Filename );
                push @Result, \%Result if %Result;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Output .= $Self->_Overview( Result => \@Result );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSMIME',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # show add certificate form
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ShowAddCertificate' ) {
        return $Self->_MaskAdd(
            Type => 'Certificate',
            %Param,
        );
    }

    # ------------------------------------------------------------ #
    # add certificate
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddCertificate' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'SMIMESearch',
            Value     => '',
        );

        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );

        my %Errors;

        # check needed data
        if ( !%UploadStuff ) {
            $Errors{FileUploadInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add certificate
            my %Result = $SMIMEObject->CertificateAdd( Certificate => $UploadStuff{Content} );
            my @Result;
            push @Result, \%Result if %Result;

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            $Output .= $Self->_Overview(
                Result => \@Result,
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminSMIME',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();
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
        $LayoutObject->ChallengeTokenCheck();

        my ( %GetParam, %Errors );

        $GetParam{Secret} = $ParamObject->GetParam( Param => 'Secret' ) || '';

        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'SMIMESearch',
            Value     => '',
        );
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );

        # check needed data
        if ( !%UploadStuff ) {
            $Errors{FileUploadInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add private key
            my %Result = $SMIMEObject->PrivateAdd(
                Private => $UploadStuff{Content},
                Secret  => $GetParam{Secret},
            );

            my @Result;
            push @Result, \%Result if %Result;

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            $Output .= $Self->_Overview(
                Result => \@Result,
            );

            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminSMIME',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();
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
        my $Filename = $ParamObject->GetParam( Param => 'Filename' ) || '';
        if ( !$Filename ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need param Filename to download!'),
            );
        }

        my $Hash = $Filename;
        $Hash =~ s{(.+)\.\d}{$1}xms;

        my $Certificate = $SMIMEObject->CertificateGet( Filename => $Filename );
        my %Attributes  = $SMIMEObject->CertificateAttributes( Certificate => $Certificate );
        return $LayoutObject->Attachment(
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
        my $Filename = $ParamObject->GetParam( Param => 'Filename' ) || '';

        my $Type = $ParamObject->GetParam( Param => 'Type' ) || '';
        if ( !$Filename ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need param Filename to download!'),
            );
        }

        my $Hash = $Filename;
        $Hash =~ s{(.+)\.\d}{$1}xms;

        my $Download;

        # download key
        if ( $Type eq 'key' ) {
            my $Secret;
            ( $Download, $Secret ) = $SMIMEObject->PrivateGet( Filename => $Filename );
        }

        # download certificate
        else {
            $Download = $SMIMEObject->CertificateGet( Filename => $Filename );
        }

        return $LayoutObject->Attachment(
            ContentType => 'text/plain',
            Content     => $Download,
            Filename    => $Hash . '-' . $Type . '.pem',
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # SignerCertificates
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SignerRelations' ) {

        # look for needed parameters
        my $CertFingerprint = $ParamObject->GetParam( Param => 'Fingerprint' ) || '';
        my $Output          = $Self->_SignerCertificateOverview( CertFingerprint => $CertFingerprint );

        return $Output;
    }

    # ------------------------------------------------------------ #
    # SignerRelationAdd
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'SignerRelationAdd' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # look for needed parameters
        my $CertFingerprint = $ParamObject->GetParam( Param => 'CertFingerprint' ) || '';
        my $CAFingerprint   = $ParamObject->GetParam( Param => 'CAFingerprint' )   || '';

        if ( !$CertFingerprint || !$CAFingerprint ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Needed CertFingerprint and CAFingerprint!'),
            );
        }

        # relation already exists?
        my $Exists = $SMIMEObject->SignerCertRelationExists(
            CertFingerprint => $CertFingerprint,
            CAFingerprint   => $CAFingerprint,
        );

        my %Message;
        my $Error;
        my $Output;
        if ( $CertFingerprint eq $CAFingerprint ) {
            $Message{Priority} = 'Error';
            $Message{Message}  = Translatable('CAFingerprint must be different than CertFingerprint');
            $Error             = 1;
        }
        elsif ($Exists) {
            $Message{Priority} = 'Error';
            $Message{Message}  = Translatable('Relation exists!');
            $Error             = 1;
        }

        if ($Error) {
            $Output = $Self->_SignerCertificateOverview(
                CertFingerprint => $CertFingerprint,
                Message         => \%Message,
            );
        }
        else {
            my $Result = $SMIMEObject->SignerCertRelationAdd(
                CertFingerprint => $CertFingerprint,
                CAFingerprint   => $CAFingerprint,
                UserID          => $Self->{UserID},
            );

            if ($Result) {
                $Message{Priority} = 'Notify';
                $Message{Message}  = Translatable('Relation added!');
            }
            else {
                $Message{Priority} = 'Error';
                $Message{Message}  = Translatable('Impossible to add relation!');
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
        $LayoutObject->ChallengeTokenCheck();

        # look for needed parameters
        my $CertFingerprint = $ParamObject->GetParam( Param => 'CertFingerprint' ) || '';
        my $CAFingerprint   = $ParamObject->GetParam( Param => 'CAFingerprint' )   || '';

        if ( !$CertFingerprint && !$CAFingerprint ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Needed CertFingerprint and CAFingerprint!'),
            );
        }

        # relation exists?
        my $Exists = $SMIMEObject->SignerCertRelationExists(
            CertFingerprint => $CertFingerprint,
            CAFingerprint   => $CAFingerprint,
        );

        my %Message;
        my $Error;
        my $Output;
        if ( !$Exists ) {
            $Message{Priority} = 'Error';
            $Message{Message}  = Translatable('Relation doesn\'t exists');
            $Error             = 1;
        }

        if ($Error) {
            $Output = $Self->_SignerCertificateOverview(
                CertFingerprint => $CertFingerprint,
                Message         => \%Message,
            );
        }
        else {
            my $Success = $SMIMEObject->SignerCertRelationDelete(
                CertFingerprint => $CertFingerprint,
                CAFingerprint   => $CAFingerprint,
                UserID          => $Self->{UserID},
            );

            if ($Success) {
                $Message{Priority} = 'Notify';
                $Message{Message}  = Translatable('Relation deleted!');
            }
            else {
                $Message{Priority} = 'Error';
                $Message{Message}  = Translatable('Impossible to delete relation!');
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
        my $Filename = $ParamObject->GetParam( Param => 'Filename' ) || '';
        if ( !$Filename ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need param Filename to download!'),
            );
        }

        my $Output = $Self->_CertificateRead( Filename => $Filename );

        if ( !$Output ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'Certificate %s could not be read!',
                    $Filename
                ),
            );
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Output .= $Self->_Overview() || '';

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSMIME',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
    return;
}

sub _MaskAdd {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Action => $Param{Action}
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # show the right tt block
    $LayoutObject->Block(
        Name => 'OverviewAdd' . $Param{Type},
        Data => \%Param,
    );

    my $Output = $LayoutObject->Header();
    $Output .= $Param{Message}
        ? $LayoutObject->Notify(
        Priority => 'Error',
        Info     => $Param{Message},
        )
        : '';
    $Output .= $LayoutObject->NavigationBar();
    $LayoutObject->Block( Name => 'Hint' );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminSMIME',
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SMIMEObject  = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    if ( $SMIMEObject && $SMIMEObject->Check() ) {
        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Data     => $LayoutObject->{LanguageObject}->Translate("' . $SMIMEObject->Check() . '"),
        );
    }

    for my $Message ( @{ $Param{Result} } ) {
        my $Priority = ( $Message->{Successful} ? 'Notice' : 'Error' );
        $Output .= $LayoutObject->Notify(
            Priority => $Priority,
            Data     => $Message->{Message},
        );
    }

    my @List = ();
    if ($SMIMEObject) {
        @List = $SMIMEObject->Search();
    }
    $LayoutObject->Block( Name => 'Overview' );
    $LayoutObject->Block(
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

            if ( defined $Attributes->{EndDate} && $SMIMEObject->KeyExpiredCheck( EndDate => $Attributes->{EndDate} ) )
            {
                $Attributes->{Expired} = 1;
            }
            $LayoutObject->Block(
                Name => 'Row',
                Data => $Attributes,
            );
            if ( defined $Attributes->{Type} && $Attributes->{Type} eq 'key' ) {
                $LayoutObject->Block(
                    Name => 'CertificateRelationAdd',
                    Data => $Attributes,
                );
            }
            elsif ( defined $Attributes->{Type} && $Attributes->{Type} eq 'cert' ) {
                $LayoutObject->Block(
                    Name => 'CertificateRead',
                    Data => $Attributes,
                );
            }
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'SMIMEFilter' );
    $LayoutObject->Block( Name => 'OverviewHint' );

    return $Output;
}

sub _SignerCertificateOverview {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$Param{CertFingerprint} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Needed Fingerprint'),
        );
    }

    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    my @SignerCertResults = $SMIMEObject->PrivateSearch(
        Search => $Param{CertFingerprint},
    );
    my %SignerCert;
    %SignerCert = %{ $SignerCertResults[0] } if @SignerCertResults;

    # get all certificates
    my @AvailableCerts = $SMIMEObject->CertificateSearch();

    # get all relations for that certificate @ActualRelations
    my @ActualRelations = $SMIMEObject->SignerCertRelationGet(
        CertFingerprint => $Param{CertFingerprint},
    );

    # get needed data from actual relations
    my @RelatedCerts;
    for my $RelatedCert (@ActualRelations) {
        my @Certificate = $SMIMEObject->CertificateSearch(
            Search => $RelatedCert->{CAFingerprint},
        );
        push @RelatedCerts, $Certificate[0] if $Certificate[0];
    }

    # filter the list, show as available cert just those which are not in the list of related certs
    # and is not equal to the actual Certificate Fingerprint
    my @ShowCertList;
    my %RelatedCerts = map { $_->{Fingerprint} => 1 } @RelatedCerts;
    @ShowCertList = grep {
        !defined $RelatedCerts{ $_->{Fingerprint} }
            && $_->{Fingerprint} ne $Param{CertFingerprint}
    } @AvailableCerts;

    $LayoutObject->Block( Name => 'Overview' );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );
    $LayoutObject->Block( Name => 'SignerCertHint' );

    $LayoutObject->Block(
        Name => 'SignerCertificates',
        Data => {
            CertFingerprint => $SignerCert{Subject},
        },
    );

    if (@RelatedCerts) {
        for my $ActualRelation (@RelatedCerts) {
            $LayoutObject->Block(
                Name => 'RelatedCertsRow',
                Data => {
                    %{$ActualRelation},
                    CertFingerprint => $Param{CertFingerprint},
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'RelatedCertsNoDataFoundMsg',
        );
    }

    if (@ShowCertList) {
        for my $AvailableCert (@ShowCertList) {
            $LayoutObject->Block(
                Name => 'AvailableCertsRow',
                Data => {
                    %{$AvailableCert},
                    CertFingerprint => $Param{CertFingerprint},
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'AvailableCertsNoDataFoundMsg',
        );
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    if ( $Param{Message} ) {
        my %Message = %{ $Param{Message} };
        $Output .= $LayoutObject->Notify(
            Priority => $Message{Type},
            Info     => $Message{Message},
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminSMIME',
        Data         => {
            %Param,
            Subtitle => Translatable('Handle Private Certificate Relations'),
        },
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _CertificateRead {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header(
        Value => $Param{Filename},
        Type  => 'Small',
    );

    my $SMIMEObject = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

    # get the certificate content as plain text
    my $CertificateText = $SMIMEObject->CertificateRead(%Param);

    return if !$CertificateText;

    # convert content to html string
    $Param{CertificateText} = $LayoutObject->Ascii2Html(
        Text           => $CertificateText,
        HTMLResultMode => 1,
    );

    $Output
        .= $LayoutObject->Output(
        TemplateFile => 'AdminSMIMECertRead',
        Data         => \%Param
        );

    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );
    return $Output;

}

1;
