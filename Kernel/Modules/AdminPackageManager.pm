# --
# Kernel/Modules/AdminPackageManager.pm - manage software packages
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminPackageManager.pm,v 1.69 2008-11-16 16:14:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminPackageManager;

use strict;
use warnings;

use Kernel::System::Package;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.69 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{PackageObject}    = Kernel::System::Package->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->{UserRepository} || '';

    # ------------------------------------------------------------ #
    # check mod perl version and Apache::Reload
    # ------------------------------------------------------------ #
    if ( exists $ENV{MOD_PERL} ) {
        if ( defined $mod_perl::VERSION ) {
            if ( $mod_perl::VERSION >= 1.99 ) {

                # check if Apache::Reload is loaded
                my $ApacheReload = 0;
                for my $Module ( keys %INC ) {
                    $Module =~ s/\//::/g;
                    $Module =~ s/\.pm$//g;
                    if ( $Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload' ) {
                        $ApacheReload = 1;
                    }
                }
                if ( !$ApacheReload ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message =>
                            'Sorry, Apache::Reload or Apache2::Reload is needed as PerlModule and ".
                            "PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf!'
                    );
                }
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message =>
                        'Sorry, for this interface is mod_perl2 with Apache2::Reload required. ".
                        "Other way you need to use the cmd tool bin/opm.pl to install packages!'
                );
            }
        }
    }

    # ------------------------------------------------------------ #
    # view diff file
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ViewDiff' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $Location = $Self->{ParamObject}->GetParam( Param => 'Location' );
        my %Frontend = ();
        my $Package  = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package );
        my $File = '';
        if ( !$Location ) {

        }
        if ( ref( $Structure{Filelist} ) eq 'ARRAY' ) {
            for my $Hash ( @{ $Structure{Filelist} } ) {
                if ( $Hash->{Location} eq $Location ) {
                    $File = $Hash->{Content};
                }
            }
        }
        my $LocalFile = $Self->{ConfigObject}->Get('Home') . "/$Location";
        if ( !-e $LocalFile ) {
            $Self->{LayoutObject}->Block(
                Name => "FileDiff",
                Data => {
                    Location => $Location,
                    Name     => $Name,
                    Version  => $Version,
                    Diff     => "No such file $LocalFile!",
                },
            );
        }
        elsif ( -e $LocalFile ) {
            my $Content = $Self->{MainObject}->FileRead(
                Location => $LocalFile,
                Mode     => 'binmode',
            );
            if ($Content) {
                $Self->{MainObject}->Require('Text::Diff');
                my $Diff = Text::Diff::diff( \$File, $Content, { STYLE => 'OldStyle' } );
                $Self->{LayoutObject}->Block(
                    Name => "FileDiff",
                    Data => {
                        Location => $Location,
                        Name     => $Name,
                        Version  => $Version,
                        Diff     => $Diff,
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => "FileDiff",
                    Data => {
                        Location => $Location,
                        Name     => $Name,
                        Version  => $Version,
                        Diff     => "Can't read $LocalFile!",
                    },
                );
            }
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # view package
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'View' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $Location = $Self->{ParamObject}->GetParam( Param => 'Location' );
        my %Frontend = ();

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # parse package
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package );

        # online verification
        my $Verified = $Self->{PackageObject}->PackageVerify(
            Package   => $Package,
            Structure => \%Structure,
        );
        my %VerifyInfo = $Self->{PackageObject}->PackageVerifyInfo();

        # deploy check
        my $Deployed = $Self->{PackageObject}->DeployCheck(
            Name    => $Name,
            Version => $Version,
        );
        my %DeployInfo = $Self->{PackageObject}->DeployCheckInfo();
        $Self->{LayoutObject}->Block(
            Name => 'Package',
            Data => { %Param, %Frontend, Name => $Name, Version => $Version, },
        );
        for (qw(DownloadLocal Rebuild Reinstall)) {
            $Self->{LayoutObject}->Block(
                Name => 'Package' . $_,
                Data => { %Param, %Frontend, Name => $Name, Version => $Version, },
            );
        }

        # check if file is requested
        if ($Location) {
            if ( ref( $Structure{Filelist} ) eq 'ARRAY' ) {
                for my $Hash ( @{ $Structure{Filelist} } ) {
                    if ( $Hash->{Location} eq $Location ) {
                        return $Self->{LayoutObject}->Attachment(
                            Filename    => $Location,
                            ContentType => 'application/octet-stream',
                            Content     => $Hash->{Content},
                        );
                    }
                }
            }
        }
        my @DatabaseBuffer = ();
        for my $Key ( sort keys %Structure ) {
            if ( ref( $Structure{$Key} ) eq 'HASH' ) {
                if ( $Key =~ /^(Description|Filelist)$/ ) {
                    $Self->{LayoutObject}->Block(
                        Name => "PackageItem$Key",
                        Data => { Tag => $Key, %{ $Structure{$Key} } },
                    );
                }
                elsif ( $Key =~ /^Database(Install|Reinstall|Upgrade|Uninstall)$/ ) {
                    for my $Type (qw(pre post)) {
                        for my $Hash ( @{ $Structure{$Key}->{$Type} } ) {
                            if ( $Hash->{TagType} eq 'Start' ) {
                                if ( $Hash->{Tag} =~ /^Table/ ) {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabase",
                                        Data => { %{$Hash}, TagName => $Key, Type => $Type },
                                    );
                                    push( @DatabaseBuffer, $Hash );
                                }
                                else {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabaseSub",
                                        Data => { %{$Hash}, TagName => $Key, },
                                    );
                                    push( @DatabaseBuffer, $Hash );
                                }
                            }
                            if ( $Hash->{Tag} =~ /^Table/ && $Hash->{TagType} eq 'End' ) {
                                push( @DatabaseBuffer, $Hash );
                                my @SQL = $Self->{DBObject}->SQLProcessor(
                                    Database => \@DatabaseBuffer
                                );
                                my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
                                push( @SQL, @SQLPost );
                                for my $SQL (@SQL) {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabaseSQL",
                                        Data => { TagName => $Key, SQL => $SQL, },
                                    );
                                }
                                @DatabaseBuffer = ();
                            }
                        }
                    }
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => "PackageItemGeneric",
                        Data => { Tag => $Key, %{ $Structure{$Key} } },
                    );
                }
            }
            elsif ( ref( $Structure{$Key} ) eq 'ARRAY' ) {
                for my $Hash ( @{ $Structure{$Key} } ) {
                    if ( $Key =~ /^(Description|ChangeLog)$/ ) {
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItem$Key",
                            Data => { %{$Hash}, Tag => $Key, },
                        );
                    }
                    elsif ( $Key =~ /^Code/ ) {
                        $Hash->{Content} = $Self->{LayoutObject}->Ascii2Html(
                            Text           => $Hash->{Content},
                            HTMLResultMode => 1,
                            NewLine        => 72,
                        );
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemCode",
                            Data => { Tag => $Key, %{$Hash} },
                        );
                    }
                    elsif ( $Key =~ /^(Intro)/ ) {
                        if ( $Hash->{Format} && $Hash->{Format} =~ /plain/i ) {
                            $Hash->{Content}
                                = '<pre class="contentbody">' . $Hash->{Content} . '</pre>';
                        }
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemIntro",
                            Data => { %{$Hash}, Tag => $Key, },
                        );
                    }
                    elsif ( $Hash->{Tag} =~ /^(File)$/ ) {

                        # add human readable file size
                        if ( $Hash->{Size} ) {

                            # remove meta data in files
                            if ( $Hash->{Size} > ( 1024 * 1024 ) ) {
                                $Hash->{Size} = sprintf "%.1f MBytes",
                                    ( $Hash->{Size} / ( 1024 * 1024 ) );
                            }
                            elsif ( $Hash->{Size} > 1024 ) {
                                $Hash->{Size} = sprintf "%.1f KBytes", ( ( $Hash->{Size} / 1024 ) );
                            }
                            else {
                                $Hash->{Size} = $Hash->{Size} . ' Bytes';
                            }
                        }
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemFilelistFile",
                            Data => {
                                Name    => $Name,
                                Version => $Version,
                                %{$Hash},
                            },
                        );
                        if ( $DeployInfo{File}->{ $Hash->{Location} } ) {
                            if ( $DeployInfo{File}->{ $Hash->{Location} } =~ /different/ ) {
                                $Self->{LayoutObject}->Block(
                                    Name => "PackageItemFilelistFileNoteDiff",
                                    Data => {
                                        Name    => $Name,
                                        Version => $Version,
                                        %{$Hash},
                                        Message => $DeployInfo{File}->{ $Hash->{Location} },
                                        Image   => 'notready.png',
                                    },
                                );
                            }
                            else {
                                $Self->{LayoutObject}->Block(
                                    Name => "PackageItemFilelistFileNote",
                                    Data => {
                                        Name    => $Name,
                                        Version => $Version,
                                        %{$Hash},
                                        Message => $DeployInfo{File}->{ $Hash->{Location} },
                                        Image   => 'notready-sw.png',
                                    },
                                );
                            }
                        }
                        else {
                            $Self->{LayoutObject}->Block(
                                Name => "PackageItemFilelistFileNote",
                                Data => {
                                    Name    => $Name,
                                    Version => $Version,
                                    %{$Hash},
                                    Message => 'ok',
                                    Image   => 'ready.png',
                                },
                            );
                        }
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemGeneric",
                            Data => { %{$Hash}, Tag => $Key, },
                        );
                    }
                }
            }
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        if ( !$Deployed ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => "$Name $Version"
                    . ' - $Text{"Package not correctly deployed! You should reinstall the Package again!"}',
                Link => '$Env{"Baselink"}Action=$Env{"Action"}&Subaction=View&Name='
                    . $Name
                    . '&Version='
                    . $Version,
            );
        }
        if ( !$Verified ) {
            my %VerifyInfo = $Self->{PackageObject}->DeployCheckInfo();
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data =>
                    '$Text{"Package verification failed!"} $Text{"For more info see:"} http://otrs.org/verify/',
                Link => 'http://otrs.org/verify?Name'
                    . $Name
                    . '&Version='
                    . $Version,
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # view remote package
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ViewRemote' ) {
        my $File     = $Self->{ParamObject}->GetParam( Param => 'File' ) || '';
        my $Location = $Self->{ParamObject}->GetParam( Param => 'Location' );
        my %Frontend = ();

        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            Source => $Source,
            File   => $File,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package );
        $Self->{LayoutObject}->Block(
            Name => 'Package',
            Data => { %Param, %Frontend, },
        );
        $Self->{LayoutObject}->Block(
            Name => 'PackageDownloadRemote',
            Data => { %Param, %Frontend, File => $File, },
        );

        # check if file is requested
        if ($Location) {
            if ( ref( $Structure{Filelist} ) eq 'ARRAY' ) {
                for my $Hash ( @{ $Structure{Filelist} } ) {
                    if ( $Hash->{Location} eq $Location ) {
                        return $Self->{LayoutObject}->Attachment(
                            Filename    => $Location,
                            ContentType => 'application/octet-stream',
                            Content     => $Hash->{Content},
                        );
                    }
                }
            }
        }
        my @DatabaseBuffer = ();
        for my $Key ( sort keys %Structure ) {
            if ( ref( $Structure{$Key} ) eq 'HASH' ) {
                if ( $Key =~ /^(Description|Filelist)$/ ) {
                    $Self->{LayoutObject}->Block(
                        Name => "PackageItem$Key",
                        Data => { Tag => $Key, %{ $Structure{$Key} } },
                    );
                }
                elsif ( $Key =~ /^Database(Install|Reinstall|Upgrade|Uninstall)$/ ) {
                    for my $Type (qw(pre post)) {
                        for my $Hash ( @{ $Structure{$Key}->{$Type} } ) {
                            if ( $Hash->{TagType} eq 'Start' ) {
                                if ( $Hash->{Tag} =~ /^Table/ ) {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabase",
                                        Data => { %{$Hash}, TagName => $Key, Type => $Type },
                                    );
                                    push( @DatabaseBuffer, $Hash );
                                }
                                else {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabaseSub",
                                        Data => { %{$Hash}, TagName => $Key, },
                                    );
                                    push( @DatabaseBuffer, $Hash );
                                }
                            }
                            if ( $Hash->{Tag} =~ /^Table/ && $Hash->{TagType} eq 'End' ) {
                                push( @DatabaseBuffer, $Hash );
                                my @SQL = $Self->{DBObject}->SQLProcessor(
                                    Database => \@DatabaseBuffer
                                );
                                my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
                                push( @SQL, @SQLPost );
                                for my $SQL (@SQL) {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabaseSQL",
                                        Data => { TagName => $Key, SQL => $SQL, },
                                    );
                                }
                                @DatabaseBuffer = ();
                            }
                        }
                    }
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => "PackageItemGeneric",
                        Data => { Tag => $Key, %{ $Structure{$Key} } },
                    );
                }
            }
            elsif ( ref( $Structure{$Key} ) eq 'ARRAY' ) {
                for my $Hash ( @{ $Structure{$Key} } ) {
                    if ( $Key =~ /^(Description|ChangeLog)$/ ) {
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItem$Key",
                            Data => { %{$Hash}, Tag => $Key, },
                        );
                    }
                    elsif ( $Key =~ /^Code/ ) {
                        $Hash->{Content} = $Self->{LayoutObject}->Ascii2Html(
                            Text           => $Hash->{Content},
                            HTMLResultMode => 1,
                            NewLine        => 72,
                        );
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemCode",
                            Data => { Tag => $Key, %{$Hash} },
                        );
                    }
                    elsif ( $Key =~ /^(Intro)/ ) {
                        if ( $Hash->{Format} && $Hash->{Format} =~ /plain/i ) {
                            $Hash->{Content}
                                = '<pre class="contentbody">' . $Hash->{Content} . '</pre>';
                        }
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemIntro",
                            Data => { %{$Hash}, Tag => $Key, },
                        );
                    }
                    elsif ( $Hash->{Tag} =~ /^(File)$/ ) {

                        # add human readable file size
                        if ( $Hash->{Size} ) {

                            # remove meta data in files
                            if ( $Hash->{Size} > ( 1024 * 1024 ) ) {
                                $Hash->{Size} = sprintf "%.1f MBytes",
                                    ( $Hash->{Size} / ( 1024 * 1024 ) );
                            }
                            elsif ( $Hash->{Size} > 1024 ) {
                                $Hash->{Size} = sprintf "%.1f KBytes", ( ( $Hash->{Size} / 1024 ) );
                            }
                            else {
                                $Hash->{Size} = $Hash->{Size} . ' Bytes';
                            }
                        }
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemFilelistFile",
                            Data => {
                                Name    => $Structure{Name}->{Content},
                                Version => $Structure{Version}->{Content},
                                File    => $File,
                                %{$Hash},
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => "PackageItemGeneric",
                            Data => { %{$Hash}, Tag => $Key, },
                        );
                    }
                }
            }
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # download package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my %Frontend = ();
        my $Package  = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }
        return $Self->{LayoutObject}->Attachment(
            Content     => $Package,
            ContentType => 'application/octet-stream',
            Filename    => "$Name-$Version.opm",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # download remote package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'DownloadRemote' ) {
        my $File = $Self->{ParamObject}->GetParam( Param => 'File' ) || '';
        my %Frontend = ();

        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            Source => $Source,
            File   => $File,
        );

        # check
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }
        return $Self->{LayoutObject}->Attachment(
            Content     => $Package,
            ContentType => 'application/octet-stream',
            Filename    => $File,
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # change repository
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeRepository' ) {
        my $Source = $Self->{ParamObject}->GetParam( Param => 'Source' ) || '';
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRepository',
            Value     => $Source,
        );
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # install package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Install' ) {
        my $Name             = $Self->{ParamObject}->GetParam( Param => 'Name' )             || '';
        my $Version          = $Self->{ParamObject}->GetParam( Param => 'Version' )          || '';
        my $IntroInstallPre  = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPre' )  || '';
        my $IntroInstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPost' ) || '';
        my $IntroInstallVendor = $Self->{ParamObject}->GetParam( Param => 'IntroInstallVendor' )
            || '';
        my %Frontend = ();

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # parse package
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # online verification
        my $Verified = $Self->{PackageObject}->PackageVerify(
            Package   => $Package,
            Structure => \%Structure,
        );
        my %VerifyInfo = $Self->{PackageObject}->PackageVerifyInfo();

        # vendor screen
        if ( !$IntroInstallVendor && !$IntroInstallPre && !$IntroInstallPost && !$Verified ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %VerifyInfo,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroInstallVendor',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # intro screen
        my %Data;
        if ( $Structure{IntroInstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'pre' );
        }
        if ( %Data && !$IntroInstallPre ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroInstallPre',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # install package
        elsif ( $Self->{PackageObject}->PackageInstall( String => $Package ) ) {

            # intro screen
            my %Data;
            if ( $Structure{IntroInstall} ) {
                %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'post' );
            }
            if ( %Data && !$IntroInstallPost ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Intro',
                    Data => {
                        %Param,
                        %Data,
                        Subaction => 'Install',
                        Type      => 'IntroInstallPost',
                        Name      => $Structure{Name}->{Content},
                        Version   => $Structure{Version}->{Content},
                    },
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminPackageManager',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }

            # redirect
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # install remote package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'InstallRemote' ) {
        my $File             = $Self->{ParamObject}->GetParam( Param => 'File' )             || '';
        my $IntroInstallPre  = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPre' )  || '';
        my $IntroInstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPost' ) || '';
        my $IntroInstallVendor = $Self->{ParamObject}->GetParam( Param => 'IntroInstallVendor' )
            || '';
        my %Frontend = ();

        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            Source => $Source,
            File   => $File,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # parse package
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # online verification
        my $Verified = $Self->{PackageObject}->PackageVerify(
            Package   => $Package,
            Structure => \%Structure,
        );
        my %VerifyInfo = $Self->{PackageObject}->PackageVerifyInfo();

        # vendor screen
        if ( !$IntroInstallVendor && !$IntroInstallPre && !$IntroInstallPost && !$Verified ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %VerifyInfo,
                    Source    => $Source,
                    File      => $File,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroInstallVendor',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # intro screen
        my %Data;
        if ( $Structure{IntroInstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'pre' );
        }
        if ( %Data && !$IntroInstallPre ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Source    => $Source,
                    File      => $File,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroInstallPre',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # install
        elsif ( $Self->{PackageObject}->PackageInstall( String => $Package ) ) {

            # intro screen
            my %Data;
            if ( $Structure{IntroInstall} ) {
                %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'post' );
            }
            if ( %Data && !$IntroInstallPost ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Intro',
                    Data => {
                        %Param,
                        %Data,
                        Subaction => '',
                        Type      => 'IntroInstallPost',
                        Name      => $Structure{Name}->{Content},
                        Version   => $Structure{Version}->{Content},
                    },
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminPackageManager',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }

            # redirect
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # upgrade remote package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpgradeRemote' ) {
        my $File             = $Self->{ParamObject}->GetParam( Param => 'File' )             || '';
        my $IntroUpgradePre  = $Self->{ParamObject}->GetParam( Param => 'IntroUpgradePre' )  || '';
        my $IntroUpgradePost = $Self->{ParamObject}->GetParam( Param => 'IntroUpgradePost' ) || '';
        my %Frontend         = ();

        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            File   => $File,
            Source => $Source,
        );

        # check
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show uninstall intro pre
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # intro screen
        my %Data;
        if ( $Structure{IntroUpgrade} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroUpgrade}, Type => 'pre' );
        }
        if ( %Data && !$IntroUpgradePre ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Source    => $Source,
                    File      => $File,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroUpgradePre',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # upgrade
        elsif ( $Self->{PackageObject}->PackageUpgrade( String => $Package ) ) {

            # intro screen
            my %Data;
            if ( $Structure{IntroUpgrade} ) {
                %Data = $Self->_MessageGet( Info => $Structure{IntroUpgrade}, Type => 'post' );
            }
            if ( %Data && !$IntroUpgradePost ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Intro',
                    Data => {
                        %Param,
                        %Data,
                        Subaction => '',
                        Type      => 'IntroUpgradePost',
                        Name      => $Structure{Name}->{Content},
                        Version   => $Structure{Version}->{Content},
                    },
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminPackageManager',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }

            # redirect
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # reinstall package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Reinstall' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroReinstallPre = $Self->{ParamObject}->GetParam( Param => 'IntroReinstallPre' )
            || '';
        my %Frontend = ();
        my $Package  = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show uninstall intro pre
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # intro screen
        my %Data;
        if ( $Structure{IntroReinstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroReinstall}, Type => 'pre' );
        }
        if ( %Data && !$IntroReinstallPre ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroReinstallPre',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # reinstall screen
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Reinstall',
                Data => {
                    %Param,
                    Name    => $Structure{Name}->{Content},
                    Version => $Structure{Version}->{Content},
                },
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # reinstall action package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ReinstallAction' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroReinstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroReinstallPost' )
            || '';
        my %Frontend = ();
        my $Package  = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show uninstall intro pre
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # intro screen
        if ( !$Self->{PackageObject}->PackageReinstall( String => $Package ) ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        my %Data;
        if ( $Structure{IntroReinstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroReinstall}, Type => 'post' );
        }
        if ( %Data && !$IntroReinstallPost ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Subaction => '',
                    Type      => 'IntroReinstallPost',
                    Name      => $Name,
                    Version   => $Version,
                },
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # uninstall package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Uninstall' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroUninstallPre = $Self->{ParamObject}->GetParam( Param => 'IntroUninstallPre' )
            || '';
        my %Frontend = ();
        my $Package  = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show uninstall intro pre
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # intro screen
        my %Data;
        if ( $Structure{IntroUninstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroUninstall}, Type => 'pre' );
        }
        if ( %Data && !$IntroUninstallPre ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroUninstallPre',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # uninstall screen
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Uninstall',
                Data => {
                    %Param,
                    Name    => $Structure{Name}->{Content},
                    Version => $Structure{Version}->{Content},
                },
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # uninstall action package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UninstallAction' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my %Frontend = ();
        my $IntroUninstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroUninstallPost' )
            || '';
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # parse package
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );

        # unsinstall the package
        if ( !$Self->{PackageObject}->PackageUninstall( String => $Package ) ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # intro screen
        my %Data;
        if ( $Structure{IntroUninstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroUninstall}, Type => 'post' );
        }
        if ( %Data && !$IntroUninstallPost ) {
            my %Data = $Self->_MessageGet( Info => $Structure{IntroUninstallPost} );
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    Subaction => '',
                    Type      => 'IntroUninstallPost',
                    Name      => $Name,
                    Version   => $Version,
                },
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # install package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'InstallUpload' ) {
        my $IntroInstallPre  = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPre' )  || '';
        my $IntroInstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPost' ) || '';
        my $IntroInstallVendor = $Self->{ParamObject}->GetParam( Param => 'IntroInstallVendor' )
            || '';
        my $FormID = $Self->{ParamObject}->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'string',
        );

        # save package in upload cache
        if (%UploadStuff) {
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $FormID,
                %UploadStuff,
            );
        }

        # get package from upload cache
        else {
            my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
                FormID => $FormID,
            );
            if ( !@AttachmentData || ( $AttachmentData[0] && !%{ $AttachmentData[0] } ) ) {
                return $Self->{LayoutObject}->ErrorScreen( Message => 'Need File/Package!' );
            }
            else {
                %UploadStuff = %{ $AttachmentData[0] };
            }
        }

        # parse package
        my %Structure = $Self->{PackageObject}->PackageParse( String => $UploadStuff{Content}, );

        # online verification
        my $Verified = $Self->{PackageObject}->PackageVerify(
            Package   => $UploadStuff{Content},
            Structure => \%Structure,
        );
        my %VerifyInfo = $Self->{PackageObject}->PackageVerifyInfo();

        # vendor screen
        if ( !$IntroInstallVendor && !$IntroInstallPre && !$IntroInstallPost && !$Verified ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %VerifyInfo,
                    FormID    => $FormID,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroInstallVendor',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # intro screen
        my %Data;
        if ( $Structure{IntroInstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'pre' );
        }
        if ( %Data && !$IntroInstallPre ) {
            $Self->{LayoutObject}->Block(
                Name => 'Intro',
                Data => {
                    %Param,
                    %Data,
                    FormID    => $FormID,
                    Subaction => $Self->{Subaction},
                    Type      => 'IntroInstallPre',
                    Name      => $Structure{Name}->{Content},
                    Version   => $Structure{Version}->{Content},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'IntroCancel',
                Data => {},
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # install
        elsif ( $Self->{PackageObject}->PackageInstall( String => $UploadStuff{Content} ) ) {

            # intro screen
            my %Data;
            if ( $Structure{IntroInstall} ) {
                %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'post' );
            }
            if ( %Data && !$IntroInstallPost ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Intro',
                    Data => {
                        %Param,
                        %Data,
                        Subaction => '',
                        Type      => 'IntroInstallPost',
                        Name      => $Structure{Name}->{Content},
                        Version   => $Structure{Version}->{Content},
                    },
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminPackageManager',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }

            # remove pre submited package
            $Self->{UploadCachObject}->FormIDRemove( FormID => $FormID );
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # ------------------------------------------------------------ #
    # rebuild package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'RebuildPackage' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my %Frontend = ();
        my $Package  = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package, );
        my $File = $Self->{PackageObject}->PackageBuild(%Structure);
        return $Self->{LayoutObject}->Attachment(
            Content     => $File,
            ContentType => 'application/octet-stream',
            Filename    => "$Name-$Version-rebuild.opm",
            Type        => 'attachment',
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my %Frontend      = ();
        my %NeedReinstall = ();
        my %List          = ();
        my $OutputNotify  = '';
        if ( $Self->{ConfigObject}->Get('Package::RepositoryList') ) {
            %List = %{ $Self->{ConfigObject}->Get('Package::RepositoryList') };
        }
        my %RepositoryRoot = ();
        if ( $Self->{ConfigObject}->Get('Package::RepositoryRoot') ) {
            %RepositoryRoot = $Self->{PackageObject}->PackageOnlineRepositories();
        }
        $Frontend{'SourceList'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => { %List, %RepositoryRoot, },
            Name => 'Source',
            Max  => 40,
            SelectedID => $Source,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, %Frontend, },
        );
        if ($Source) {
            my @List = $Self->{PackageObject}->PackageOnlineList(
                URL => $Source,
                Lang => $Self->{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage'),
            );
            if ( !@List ) {
                $OutputNotify .= $Self->{LayoutObject}->Notify( Priority => 'Error', );
                if ( !$OutputNotify ) {
                    $OutputNotify .= $Self->{LayoutObject}->Notify(
                        Priority => 'Info',
                        Info     => 'No Packages or no new Packages in selected Online Repository!',
                    );
                }
            }
            my $CssClass = '';
            for my $Data (@List) {

                # set output class
                if ( $CssClass && $CssClass eq 'searchactive' ) {
                    $CssClass = 'searchpassive';
                }
                else {
                    $CssClass = 'searchactive';
                }
                $Self->{LayoutObject}->Block(
                    Name => 'ShowRemotePackage',
                    Data => {
                        %{$Data},
                        Source   => $Source,
                        CssClass => $CssClass,
                    },
                );

                # show documentation link
                my %DocFile = $Self->_DocumentationGet( Filelist => $Data->{Filelist} );
                if (%DocFile) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ShowRemotePackageDocumentation',
                        Data => {
                            %{$Data},
                            Source => $Source,
                            %DocFile,
                        },
                    );
                }

                if ( $Data->{Upgrade} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ShowRemotePackageUpgrade',
                        Data => { %{$Data}, Source => $Source, },
                    );
                }
                elsif ( !$Data->{Installed} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ShowRemotePackageInstall',
                        Data => { %{$Data}, Source => $Source, },
                    );
                }
            }
        }
        my $CssClass = '';
        for my $Package ( $Self->{PackageObject}->RepositoryList() ) {

            # set output class
            if ( $CssClass && $CssClass eq 'searchactive' ) {
                $CssClass = 'searchpassive';
            }
            else {
                $CssClass = 'searchactive';
            }
            my %Data = $Self->_MessageGet( Info => $Package->{Description} );

            $Self->{LayoutObject}->Block(
                Name => 'ShowLocalPackage',
                Data => {
                    %{$Package},
                    %Data,
                    Name     => $Package->{Name}->{Content},
                    Version  => $Package->{Version}->{Content},
                    Vendor   => $Package->{Vendor}->{Content},
                    URL      => $Package->{URL}->{Content},
                    CssClass => $CssClass,
                },
            );

            # show documentation link
            my %DocFile = $Self->_DocumentationGet( Filelist => $Package->{Filelist} );
            if (%DocFile) {
                $Self->{LayoutObject}->Block(
                    Name => 'ShowLocalPackageDocumentation',
                    Data => {
                        Name     => $Package->{Name}->{Content},
                        Version  => $Package->{Version}->{Content},
                        %DocFile,
                    },
                );
            }

            if ( $Package->{Status} eq 'installed' ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ShowLocalPackageUninstall',
                    Data => {
                        %{$Package},
                        Name    => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                        Vendor  => $Package->{Vendor}->{Content},
                        URL     => $Package->{URL}->{Content},
                    },
                );
                if (
                    !$Self->{PackageObject}->DeployCheck(
                        Name    => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content}
                    )
                    )
                {
                    $NeedReinstall{ $Package->{Name}->{Content} } = $Package->{Version}->{Content};
                    $Self->{LayoutObject}->Block(
                        Name => 'ShowLocalPackageReinstall',
                        Data => {
                            %{$Package},
                            Name    => $Package->{Name}->{Content},
                            Version => $Package->{Version}->{Content},
                            Vendor  => $Package->{Vendor}->{Content},
                            URL     => $Package->{URL}->{Content},
                        },
                    );
                }
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ShowLocalPackageInstall',
                    Data => {
                        %{$Package},
                        Name    => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                        Vendor  => $Package->{Vendor}->{Content},
                        URL     => $Package->{URL}->{Content},
                    },
                );
            }
        }

        # show file upload
        if ( $Self->{ConfigObject}->Get('Package::FileUpload') ) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewFileUpload',
                Data => { FormID => $Self->{UploadCachObject}->FormIDCreate(), }
            );
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $OutputNotify;
        for ( sort keys %NeedReinstall ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data     => "$_ $NeedReinstall{$_}"
                    . ' - $Text{"Package not correctly deployed! You should reinstall the Package again!"}',
                Link => '$Env{"Baselink"}Action=$Env{"Action"}&Subaction=View&Name='
                    . $_
                    . '&Version='
                    . $NeedReinstall{$_},
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MessageGet {
    my ( $Self, %Param ) = @_;

    my $Title       = '';
    my $Description = '';
    my $Use         = 0;
    if ( $Param{Info} ) {
        for my $Tag ( @{ $Param{Info} } ) {
            if ( $Param{Type} ) {
                next if $Tag->{Type} !~ /^$Param{Type}/i;
            }
            $Use = 1;
            if ( $Tag->{Format} && $Tag->{Format} =~ /plain/i ) {
                $Tag->{Content} = '<pre class="contentbody">' . $Tag->{Content} . '</pre>';
            }
            if ( !$Description && $Tag->{Lang} eq 'en' ) {
                $Description = $Tag->{Content};
                $Title       = $Tag->{Title};
            }
            if (
                ( $Self->{UserLanguage} && $Tag->{Lang} eq $Self->{UserLanguage} )
                || (
                    !$Self->{UserLanguage}
                    && $Tag->{Lang} eq $Self->{ConfigObject}->Get('DefaultLanguage')
                )
                )
            {
                $Description = $Tag->{Content};
                $Title       = $Tag->{Title};
            }
        }
        if ( !$Description && $Use ) {
            for my $Tag ( @{ $Param{Info} } ) {
                if ( !$Description ) {
                    $Description = $Tag->{Content};
                    $Title       = $Tag->{Title};
                }
            }
        }
    }
    return if !$Description && !$Title;
    return (
        Description => $Description,
        Title       => $Title,
    );
}

sub _DocumentationGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{Filelist};
    return if ref $Param{Filelist} ne 'ARRAY';

    # find the correct user language documentation file
    my $DocumentationFileUserLanguage;

    # find the correct default language documentation file
    my $DocumentationFileDefaultLanguage;

    # find the correct en documentation file
    my $DocumentationFile;

    # remember fallback file
    my $DocumentationFileFallback;

    # get default language
    my $DefaultLanguage = $Self->{ConfigObject}->Get('DefaultLanguage');

    # find documentation files
    FILE:
    for my $File ( @{ $Param{Filelist} } ) {

        next FILE if !$File;
        next FILE if !$File->{Location};

        my ( $Dir, $Filename ) = $File->{Location} =~ m{ \A doc/ ( .+ ) / ( .+? .pdf ) }xmsi;

        next FILE if !$Dir;
        next FILE if !$Filename;

        # take user language first
        if ( $Dir eq $Self->{UserLanguage} ) {
            $DocumentationFileUserLanguage = $File->{Location};
        }

        # take default language next
        elsif ( $Dir eq $DefaultLanguage ) {
            $DocumentationFileDefaultLanguage = $File->{Location};
        }

        # take en language next
        elsif ( $Dir eq 'en' && !$DocumentationFile ) {
            $DocumentationFile = $File->{Location};
        }

        # remember fallback file
        $DocumentationFileFallback = $File->{Location};
    }

    # set fallback file (if exists) as documentation file
    my %Doc;
    if ( $DocumentationFileUserLanguage ) {
        $Doc{Location} = $DocumentationFileUserLanguage;
    }
    elsif ( $DocumentationFileDefaultLanguage ) {
        $Doc{Location} = $DocumentationFileDefaultLanguage;
    }
    elsif ( $DocumentationFile ) {
        $Doc{Location} = $DocumentationFile;
    }
    elsif ( $DocumentationFileFallback ) {
        $Doc{Location} = $DocumentationFileFallback;
    }
    return %Doc;
}

1;
