# --
# Kernel/Modules/AdminPGP.pm - to add/update/delete pgp keys
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminPGP;

use strict;
use warnings;

use Kernel::System::Crypt;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject EncodeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{CryptObject} = Kernel::System::Crypt->new( %Param, CryptType => 'PGP' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # check if feature is active
    # ------------------------------------------------------------ #
    if ( !$Self->{ConfigObject}->Get('PGP') ) {

        my $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'Disabled' );

        $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPGP' );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    $Param{Search} = $Self->{ParamObject}->GetParam( Param => 'Search' );
    if ( !defined( $Param{Search} ) ) {
        $Param{Search} = $Self->{PGPSearch} || '';
    }
    if ( $Self->{Subaction} eq '' ) {
        $Param{Search} = '';
    }

    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'PGPSearch',
        Value     => $Param{Search},
    );

    # ------------------------------------------------------------ #
    # delete key
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionSearch' );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
        $Self->{LayoutObject}->Block( Name => 'Hint' );
        $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

        my $Key  = $Self->{ParamObject}->GetParam( Param => 'Key' )  || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Key ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Key to delete!', );
        }
        my $Success = '';
        if ( $Type eq 'sec' ) {
            $Success = $Self->{CryptObject}->SecretKeyDelete( Key => $Key );
        }
        else {
            $Success = $Self->{CryptObject}->PublicKeyDelete( Key => $Key );
        }
        my @List = $Self->{CryptObject}->KeySearch( Search => $Param{Search} );
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
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        my $Message = '';
        if ($Success) {
            $Message = "Key $Key deleted!";
        }
        else {
            $Message = $Self->{LogObject}->GetLogEntry(
                Type => 'Error',
                What => 'Message',
            );
        }
        $Output .= $Self->{LayoutObject}->Notify( Info => $Message );

        $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPGP', Data => \%Param );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add key (form)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
        $Self->{LayoutObject}->Block( Name => 'AddKey' );

        $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPGP' );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add key
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddKey' ) {

        my %Errors;

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'PGPSearch',
            Value     => '',
        );
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
        );
        if ( !%UploadStuff ) {
            $Errors{FileUploadInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add pgp key
            my $KeyAdd = $Self->{CryptObject}->KeyAdd( Key => $UploadStuff{Content} );

            if ($KeyAdd) {
                $Self->{LayoutObject}->Block( Name => 'Overview' );
                $Self->{LayoutObject}->Block( Name => 'ActionList' );
                $Self->{LayoutObject}->Block( Name => 'ActionSearch' );
                $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
                $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

                my @List = $Self->{CryptObject}->KeySearch( Search => '' );
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

                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => $KeyAdd );

                $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPGP' );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
        $Self->{LayoutObject}->Block(
            Name => 'AddKey',
            Data => \%Errors,
        );
        $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPGP' );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # download key
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Key  = $Self->{ParamObject}->GetParam( Param => 'Key' )  || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Key ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Key to download!', );
        }
        my $KeyString = '';
        if ( $Type eq 'sec' ) {
            $KeyString = $Self->{CryptObject}->SecretKeyGet( Key => $Key );
        }
        else {
            $KeyString = $Self->{CryptObject}->PublicKeyGet( Key => $Key );
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $KeyString,
            Filename    => "$Key.asc",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # download fingerprint
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DownloadFingerprint' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Key  = $Self->{ParamObject}->GetParam( Param => 'Key' )  || '';
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || '';
        if ( !$Key ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'Need param Key to download!', );
        }
        my $Download = '';
        if ( $Type eq 'sec' ) {
            my @Result = $Self->{CryptObject}->PrivateKeySearch( Search => $Key );
            if ( $Result[0] ) {
                $Download = $Result[0]->{Fingerprint};
            }
        }
        else {
            my @Result = $Self->{CryptObject}->PublicKeySearch( Search => $Key );
            if ( $Result[0] ) {
                $Download = $Result[0]->{Fingerprint};
            }
        }
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain',
            Content     => $Download,
            Filename    => "$Key.txt",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # search key
    # ------------------------------------------------------------ #
    else {

        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionSearch' );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
        $Self->{LayoutObject}->Block( Name => 'Hint' );
        $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

        my @List = ();
        if ( $Self->{CryptObject} ) {
            @List = $Self->{CryptObject}->KeySearch( Search => $Param{Search} );
        }
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
        my $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if ( $Self->{CryptObject}->Check() ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => '$Text{"' . $Self->{CryptObject}->Check() . '"}',
            );
        }
        $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'AdminPGP', Data => \%Param );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
