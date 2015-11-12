# --
# Kernel/System/Web/Request.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::Request;

use strict;
use warnings;

use CGI ();
use CGI::Carp;
use File::Path qw();

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CheckItem',
    'Kernel::System::Encode',
);

=head1 NAME

Kernel::System::Web::Request - global CGI interface

=head1 SYNOPSIS

All cgi param functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create param object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Web::Request' => {
            WebRequest   => CGI::Fast->new(), # optional, e. g. if fast cgi is used
        }
    );
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

If Kernel::System::Web::Request is instantiated several times, they will share the
same CGI data (this can be helpful in filters which do not have access to the
ParamObject, for example.

If you need to reset the CGI data before creating a new instance, use

    CGI::initialize_globals();

before calling Kernel::System::Web::Request->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # max 5 MB posts
    $CGI::POST_MAX = $ConfigObject->Get('WebMaxFileUpload') || 1024 * 1024 * 5;    ## no critic

    # we need to modify the tempdir
    # for windows because the users
    # group do not have enough rights
    # for the default tempdir c:\windows\temp
    # so we use a directory in otrs as tempdir (bug#10522)
    if ( $^O eq 'MSWin32' ) {
        $CGITempFile::TMPDIRECTORY = $ConfigObject->Get('TempDir');
    }

    # query object (in case use already existing WebRequest, e. g. fast cgi)
    $Self->{Query} = $Param{WebRequest} || CGI->new();

    return $Self;
}

=item Error()

to get the error back

    if ( $ParamObject->Error() ) {
        print STDERR $ParamObject->Error() . "\n";
    }

=cut

sub Error {
    my ( $Self, %Param ) = @_;

    # Workaround, do not check cgi_error() with perlex, CGI module is not
    # working with perlex.
    if ( $ENV{'GATEWAY_INTERFACE'} && $ENV{'GATEWAY_INTERFACE'} =~ /^CGI-PerlEx/ ) {
        return;
    }

    return if !$Self->{Query}->cgi_error();
    ## no critic
    return $Self->{Query}->cgi_error() . ' - POST_MAX=' . ( $CGI::POST_MAX / 1024 ) . 'KB';
    ## use critic
}

=item GetParam()

to get single request parameters.
By default, trimming is performed on the data.

    my $Param = $ParamObject->GetParam(
        Param => 'ID',
        Raw   => 1,     # optional, input data is not changed
    );

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $Value = $Self->{Query}->param( $Param{Param} );
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Value );

    my $Raw = defined $Param{Raw} ? $Param{Raw} : 0;

    if ( !$Raw ) {

        # If it is a plain string, perform trimming
        if ( ref \$Value eq 'SCALAR' ) {
            $Kernel::OM->Get('Kernel::System::CheckItem')->StringClean(
                StringRef => \$Value,
                TrimLeft  => 1,
                TrimRight => 1,
            );
        }
    }

    return $Value;
}

=item GetParamNames()

to get names of all parameters passed to the script.

    my @ParamNames = $ParamObject->GetParamNames();

Example:

Called URL: index.pl?Action=AdminSysConfig;Subaction=Save;Name=Config::Option::Valid

    my @ParamNames = $ParamObject->GetParamNames();
    print join " :: ", @ParamNames;
    #prints Action :: Subaction :: Name

=cut

sub GetParamNames {
    my $Self = shift;

    # fetch all names
    my @ParamNames = $Self->{Query}->param();

    # is encode needed?
    for my $Name (@ParamNames) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Name );
    }

    return @ParamNames;
}

=item GetArray()

to get array request parameters.
By default, trimming is performed on the data.

    my @Param = $ParamObject->GetArray(
        Param => 'ID',
        Raw   => 1,     # optional, input data is not changed
    );

=cut

sub GetArray {
    my ( $Self, %Param ) = @_;

    my @Values = $Self->{Query}->param( $Param{Param} );

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \@Values );

    my $Raw = defined $Param{Raw} ? $Param{Raw} : 0;

    if ( !$Raw ) {

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        for my $Value (@Values) {
            $CheckItemObject->StringClean(
                StringRef => \$Value,
                TrimLeft  => 1,
                TrimRight => 1,
            );
        }
    }

    return @Values;
}

=item GetUploadAll()

gets file upload data.

    my %File = $ParamObject->GetUploadAll(
        Param  => 'FileParam',  # the name of the request parameter containing the file data
    );

    returns (
        Filename    => 'abc.txt',
        ContentType => 'text/plain',
        Content     => 'Some text',
    );

=cut

sub GetUploadAll {
    my ( $Self, %Param ) = @_;

    # get upload
    my $Upload = $Self->{Query}->upload( $Param{Param} );
    return if !$Upload;

    # get real file name
    my $UploadFilenameOrig = $Self->GetParam( Param => $Param{Param} ) || 'unkown';

    my $NewFileName = "$UploadFilenameOrig";    # use "" to get filename of anony. object
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$NewFileName );

    # replace all devices like c: or d: and dirs for IE!
    $NewFileName =~ s/.:\\(.*)/$1/g;
    $NewFileName =~ s/.*\\(.+?)/$1/g;

    # return a string
    my $Content;
    while (<$Upload>) {
        $Content .= $_;
    }
    close $Upload;

    # Check if content is there, IE is always sending file uploads without content.
    return if !$Content;

    my $ContentType = $Self->_GetUploadInfo(
        Filename => $UploadFilenameOrig,
        Header   => 'Content-Type',
    );

    return (
        Filename    => $NewFileName,
        Content     => $Content,
        ContentType => $ContentType,
    );
}

sub _GetUploadInfo {
    my ( $Self, %Param ) = @_;

    # get file upload info
    my $FileInfo = $Self->{Query}->uploadInfo( $Param{Filename} );

    # return if no upload info exists
    return 'application/octet-stream' if !$FileInfo;

    # return if no content type of upload info exists
    return 'application/octet-stream' if !$FileInfo->{ $Param{Header} };

    # return content type of upload info
    return $FileInfo->{ $Param{Header} };
}

=item SetCookie()

set a cookie

    $ParamObject->SetCookie(
        Key     => ID,
        Value   => 123456,
        Expires => '+3660s',
        Path    => 'otrs/',     # optional, only allow cookie for given path
        Secure  => 1,           # optional, set secure attribute to disable cookie on HTTP (HTTPS only)
        HTTPOnly => 1,          # optional, sets HttpOnly attribute of cookie to prevent access via JavaScript
    );

=cut

sub SetCookie {
    my ( $Self, %Param ) = @_;

    $Param{Path} ||= '';

    return $Self->{Query}->cookie(
        -name     => $Param{Key},
        -value    => $Param{Value},
        -expires  => $Param{Expires},
        -secure   => $Param{Secure} || '',
        -httponly => $Param{HTTPOnly} || '',
        -path     => '/' . $Param{Path},
    );
}

=item GetCookie()

get a cookie

    my $String = $ParamObject->GetCookie(
        Key => ID,
    );

=cut

sub GetCookie {
    my ( $Self, %Param ) = @_;

    return $Self->{Query}->cookie( $Param{Key} );
}

=item IsAJAXRequest()

checks if the current request was sent by AJAX

    my $IsAJAXRequest = $ParamObject->IsAJAXRequest();

=cut

sub IsAJAXRequest {
    my ( $Self, %Param ) = @_;

    return ( $Self->{Query}->http('X-Requested-With') // '' ) eq 'XMLHttpRequest' ? 1 : 0;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
