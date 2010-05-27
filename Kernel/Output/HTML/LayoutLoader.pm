# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.5 2010-05-27 09:39:22 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

use Kernel::System::Loader;

sub CreateCSSLoaderCalls {
    my ( $Self, %Param ) = @_;

    my $Home = $Self->{ConfigObject}->Get('Home');

    {
        my $CommonCSSList = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSList} ) {
            for my $CSSFile ( @{ $CommonCSSList->{$Key} } ) {
                push(
                    @FileList,
                    $Home . '/var/httpd/htdocs/skins/Agent/default/css/' . $CSSFile
                );
            }
        }

        my $MinifiedFile = $Self->CreateMinifiedFile(
            List            => \@FileList,
            Type            => 'CSS',
            TargetDirectory => $Home
                . '/var/httpd/htdocs/skins/Agent/default/css-cache/',
            TargetFilenamePrefix => 'CommonCSS',
        );

        $Self->Block(
            Name => 'CommonCSS',
            Data => {
                Skin     => 'default',
                Filename => $MinifiedFile,
            },
        );
    }

    {
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE7');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            for my $CSSFile ( @{ $CommonCSSIE7List->{$Key} } ) {
                push(
                    @FileList,
                    $Home . '/var/httpd/htdocs/skins/Agent/default/css/' . $CSSFile
                );
            }
        }

        my $MinifiedFile = $Self->CreateMinifiedFile(
            List            => \@FileList,
            Type            => 'CSS',
            TargetDirectory => $Home
                . '/var/httpd/htdocs/skins/Agent/default/css-cache/',
            TargetFilenamePrefix => 'CommonCSS_IE7',
        );

        $Self->Block(
            Name => 'CommonCSS_IE7',
            Data => {
                Skin     => 'default',
                Filename => $MinifiedFile,
            },
        );
    }

    {
        my $CommonCSSIE8List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE8');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE8List} ) {
            for my $CSSFile ( @{ $CommonCSSIE8List->{$Key} } ) {
                push(
                    @FileList,
                    $Home . '/var/httpd/htdocs/skins/Agent/default/css/' . $CSSFile
                );
            }
        }

        my $MinifiedFile = $Self->CreateMinifiedFile(
            List            => \@FileList,
            Type            => 'CSS',
            TargetDirectory => $Home
                . '/var/httpd/htdocs/skins/Agent/default/css-cache/',
            TargetFilenamePrefix => 'CommonCSS_IE8',
        );

        $Self->Block(
            Name => 'CommonCSS_IE8',
            Data => {
                Skin     => 'default',
                Filename => $MinifiedFile,
            },
        );
    }

}

sub CreateMinifiedFile {
    my ( $Self, %Param ) = @_;

    $Self->{LoaderObject} ||= Kernel::System::Loader->new( %{$Self} );

    my $List = $Param{List};
    if ( ref $List ne 'ARRAY' || !@{$List} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need List!",
        );
        return;
    }

    my $TargetDirectory = $Param{TargetDirectory};
    if ( !$TargetDirectory || !-d $TargetDirectory ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need valid TargetDirectory, got '$TargetDirectory'!",
        );
        return;
    }

    my $TargetFilenamePrefix = $Param{TargetFilenamePrefix} ? "$Param{TargetFilenamePrefix}_" : '';

    my %ValidTypeParams = (
        CSS        => 1,
        JavaScript => 1,
    );

    if ( !$Param{Type} || !$ValidTypeParams{ $Param{Type} } ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $FileString;
    for my $Location ( @{$List} ) {
        my $FileMTime = $Self->{MainObject}->FileGetMTime(
            Location => $Location
        );

        # For the caching, use both filename and mtime to make sure that
        #   caches are correctly regenerated on changes.
        $FileString .= "$Location:$FileMTime:";
    }

    # also include the config timestamp in the caching to reload the data on config changes
    my $ConfigTimestamp = $Self->LoaderCreateClientCacheTimestamp();

    $FileString .= $ConfigTimestamp;

    my $Filename = $TargetFilenamePrefix . $Self->{MainObject}->MD5sum(
        String => \$FileString,
    );

    if ( $Param{Type} eq 'CSS' ) {
        $Filename .= '.css';
    }
    elsif ( $Param{Type} eq 'JavaScript' ) {
        $Filename .= '.js';

    }

    if ( !-r "$TargetDirectory/$Filename" ) {
        my $Content = $Self->{LoaderObject}->GetMinifiedFileList(
            List => $List,
            Type => $Param{Type},
        );

        my $FileLocation = $Self->{MainObject}->FileWrite(
            Directory => $TargetDirectory,
            Filename  => $Filename,
            Content   => \$Content,
        );
    }

    return $Filename;
}

sub LoaderCreateClientCacheTimestamp {
    my ($Self) = @_;

    my $Dir = $Self->{ConfigObject}->Get('Home');

    my @Files = glob("$Dir/Kernel/Config/Files/*.pm");

    push( @Files, "$Dir/Kernel/Config.pm" );

    my $StringFile = "";
    for my $File (@Files) {
        my $FileMTime = $Self->{MainObject}->FileGetMTime(
            Location => $File,
        );
        $File =~ s/^.*\/(.+?)/$1/g;
        $StringFile .= $File . $FileMTime;
    }

    my $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$StringFile,
    );
    return $MD5Sum;
}

1;
