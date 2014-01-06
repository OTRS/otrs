# --
# Kernel/System/Web/Request.pm - a wrapper for CGI.pm or Apache::Request.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Request.pm,v 1.41.2.1 2012-12-03 11:42:02 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::Request;

use strict;
use warnings;

use File::Path qw();

use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.41.2.1 $) [1];

=head1 NAME

Kernel::System::Web::Request - global CGI interface

=head1 SYNOPSIS

All cgi param functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create param object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Web::Request;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $ParamObject = Kernel::System::Web::Request->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        EncodeObject => $EncodeObject,
        MainObject   => $MainObject,
        WebRequest   => CGI::Fast->new(), # optional, e. g. if fast cgi is used
    );

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

    for my $Object (qw(ConfigObject LogObject EncodeObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );

    # Simple Common Gateway Interface Class
    use CGI qw(:cgi);

    # send errors to web server error log
    use CGI::Carp;

    # max 5 MB posts
    $CGI::POST_MAX = $Self->{ConfigObject}->Get('WebMaxFileUpload') || 1024 * 1024 * 5;

    # query object (in case use already existing WebRequest, e. g. fast cgi)
    $Self->{Query} = $Param{WebRequest} || new CGI;

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

    return if !cgi_error();
    return cgi_error() . ' - POST_MAX=' . ( $CGI::POST_MAX / 1024 ) . 'KB';
}

=item GetParam()

to get params

    my $Param = $ParamObject->GetParam(
        Param => 'ID',
    );

=cut

sub GetParam {
    my ( $Self, %Param ) = @_;

    my $Value = $Self->{Query}->param( $Param{Param} );
    $Self->{EncodeObject}->EncodeInput( \$Value );

    if (
        $Param{TrimLeft}
        || $Param{TrimRight}
        || $Param{RemoveAllNewlines}
        || $Param{RemoveAllTabs}
        || $Param{RemoveAllSpaces}
        )
    {
        $Self->{CheckItemObject}->StringClean(
            StringRef => \$Value,
            %Param,
        );
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
        $Self->{EncodeObject}->EncodeInput( \$Name );
    }

    return @ParamNames;
}

=item GetArray()

to get array params

    my @Param = $ParamObject->GetArray( Param => 'ID' );

=cut

sub GetArray {
    my ( $Self, %Param ) = @_;

    my @Values = $Self->{Query}->param( $Param{Param} );
    $Self->{EncodeObject}->EncodeInput( \@Values );

    if (
        $Param{TrimLeft}
        || $Param{TrimRight}
        || $Param{RemoveAllNewlines}
        || $Param{RemoveAllTabs}
        || $Param{RemoveAllSpaces}
        )
    {
        for my $Value (@Values) {
            $Self->{CheckItemObject}->StringClean(
                StringRef => \$Value,
                %Param,
            );
        }
    }

    return @Values;
}

=item GetUploadAll()

to get file upload

    my %File = $ParamObject->GetUploadAll(
        Param  => 'FileParam',
        Source => 'string',
    );

    to get file upload without uft-8 encoding

    my %File = $ParamObject->GetUploadAll(
        Param  => 'FileParam',
        Source => 'string',
    );

    print "Filename: $File{Filename}\n";
    print "ContentType: $File{ContentType}\n";
    print "Content: $File{Content}\n";

    If param Source is file, the the content contains the file location
    in your local file system.

=cut

sub GetUploadAll {
    my ( $Self, %Param ) = @_;

    # get upload
    my $Upload = $Self->{Query}->upload( $Param{Param} );
    return if !$Upload;

    # get real file name
    my $UploadFilenameOrig = $Self->GetParam( Param => $Param{Param} ) || 'unkown';
    my $NewFileName = "$UploadFilenameOrig";    # use "" to get filename of anony. object
    $Self->{EncodeObject}->EncodeInput( \$NewFileName );

    # replace all devices like c: or d: and dirs for IE!
    $NewFileName =~ s/.:\\(.*)/$1/g;
    $NewFileName =~ s/.*\\(.+?)/$1/g;

    # return a string
    my $Content;
    if ( $Param{Source} && lc $Param{Source} eq 'string' ) {

        while (<$Upload>) {
            $Content .= $_;
        }
        close $Upload;
    }

    # return file location in file system
    else {

        # delete upload dir if exists
        my $Path = "/tmp/$$";
        if ( -d $Path ) {
            File::Path::remove_tree($Path);
        }

        # create upload dir
        File::Path::make_path( $Path, { mode => 0700 } );

        $Content = "$Path/$NewFileName";

        open my $Out, '>', $Content or die $!;
        while (<$Upload>) {
            print $Out $_;
        }
        close $Out;
    }

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
        Secure  => 1,           # optional, set secure attribute to disable cookie on HTTP (HTTPS only)
    );

=cut

sub SetCookie {
    my ( $Self, %Param ) = @_;

    return $Self->{Query}->cookie(
        -name    => $Param{Key},
        -value   => $Param{Value},
        -expires => $Param{Expires},
        -secure  => $Param{Secure},
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.41.2.1 $ $Date: 2012-12-03 11:42:02 $

=cut
