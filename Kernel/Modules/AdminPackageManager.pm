# --
# Kernel/Modules/AdminPackageManager.pm - manage software packages
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminPackageManager;

use strict;
use warnings;

use XML::FeedPP;

use Kernel::System::Package;
use Kernel::System::Web::UploadCache;
use Kernel::System::Cache;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{PackageObject}     = Kernel::System::Package->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{CacheObject}       = Kernel::System::Cache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->{UserRepository} || '';
    my %Errors;

    # ------------------------------------------------------------ #
    # check mod perl version and Apache::Reload
    # ------------------------------------------------------------ #

    if ( exists $ENV{MOD_PERL} ) {
        if ( defined $mod_perl::VERSION ) {    ## no critic
            if ( $mod_perl::VERSION >= 1.99 ) {    ## no critic

                # check if Apache::Reload is loaded
                my $ApacheReload = 0;
                for my $Module ( sort keys %INC ) {
                    $Module =~ s/\//::/g;
                    $Module =~ s/\.pm$//g;
                    if ( $Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload' ) {
                        $ApacheReload = 1;
                    }
                }
                if ( !$ApacheReload ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message =>
                            'Sorry, Apache::Reload is needed as PerlModule and '
                            .
                            'PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. '
                            .
                            'Alternatively, you can use the cmd tool bin/otrs.PackageManager.pl to install packages!'
                    );
                }
            }
        }
    }

    # secure mode message (don't allow this action until secure mode is enabled)
    if ( !$Self->{ConfigObject}->Get('SecureMode') ) {
        $Self->{LayoutObject}->SecureMode();
    }

    # ------------------------------------------------------------ #
    # view diff file
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ViewDiff' ) {
        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $Location = $Self->{ParamObject}->GetParam( Param => 'Location' );

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }
        my %Structure = $Self->{PackageObject}->PackageParse( String => $Package );
        my $File = '';
        if ( ref $Structure{Filelist} eq 'ARRAY' ) {
            for my $Hash ( @{ $Structure{Filelist} } ) {
                if ( $Hash->{Location} eq $Location ) {
                    $File = $Hash->{Content};
                }
            }
        }
        my $LocalFile = $Self->{ConfigObject}->Get('Home') . "/$Location";

        # do not allow to read file with including .. path (security related)
        $LocalFile =~ s/\.\.//g;
        if ( !$File ) {
            $Self->{LayoutObject}->Block(
                Name => 'FileDiff',
                Data => {
                    Location => $Location,
                    Name     => $Name,
                    Version  => $Version,
                    Diff     => "No such file $LocalFile in package!",
                },
            );
        }
        elsif ( !-e $LocalFile ) {
            $Self->{LayoutObject}->Block(
                Name => 'FileDiff',
                Data => {
                    Location => $Location,
                    Name     => $Name,
                    Version  => $Version,
                    Diff     => "No such file $LocalFile in local file system!",
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
        my %Frontend;

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
        for my $PackageAction (qw(DownloadLocal Rebuild Reinstall)) {
            $Self->{LayoutObject}->Block(
                Name => 'Package' . $PackageAction,
                Data => {
                    %Param,
                    %Frontend,
                    Name    => $Name,
                    Version => $Version,
                },
            );
        }

        # check if file is requested
        if ($Location) {
            if ( ref $Structure{Filelist} eq 'ARRAY' ) {
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
        my @DatabaseBuffer;
        for my $Key ( sort keys %Structure ) {
            if ( ref $Structure{$Key} eq 'HASH' ) {
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
                                    push @DatabaseBuffer, $Hash;
                                }
                                else {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabaseSub",
                                        Data => { %{$Hash}, TagName => $Key, },
                                    );
                                    push @DatabaseBuffer, $Hash;
                                }
                            }
                            if ( $Hash->{Tag} =~ /^Table/ && $Hash->{TagType} eq 'End' ) {
                                push @DatabaseBuffer, $Hash;
                                my @SQL = $Self->{DBObject}->SQLProcessor(
                                    Database => \@DatabaseBuffer
                                );
                                my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
                                push @SQL, @SQLPost;
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
                        Name => 'PackageItemGeneric',
                        Data => { Tag => $Key, %{ $Structure{$Key} } },
                    );
                }
            }
            elsif ( ref $Structure{$Key} eq 'ARRAY' ) {
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
                                        Icon    => 'IconNotReady',
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
                                        Icon    => 'IconNotReadyGrey',
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
                                    Icon    => 'IconReady',
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
                    . ' - $Text{"Package not correctly deployed! Please reinstall the package."}',
                Link => '$Env{"Baselink"}Action=$Env{"Action"};Subaction=View;Name='
                    . $Name
                    . ';Version='
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
                    . ';Version='
                    . $Version,
            );
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # view remote package
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ViewRemote' ) {
        my $File = $Self->{ParamObject}->GetParam( Param => 'File' ) || '';
        my $Location = $Self->{ParamObject}->GetParam( Param => 'Location' );
        my %Frontend;

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
            if ( ref $Structure{Filelist} eq 'ARRAY' ) {
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
        my @DatabaseBuffer;
        for my $Key ( sort keys %Structure ) {
            if ( ref $Structure{$Key} eq 'HASH' ) {
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
                                    push @DatabaseBuffer, $Hash;
                                }
                                else {
                                    $Self->{LayoutObject}->Block(
                                        Name => "PackageItemDatabaseSub",
                                        Data => { %{$Hash}, TagName => $Key, },
                                    );
                                    push @DatabaseBuffer, $Hash;
                                }
                            }
                            if ( $Hash->{Tag} =~ /^Table/ && $Hash->{TagType} eq 'End' ) {
                                push @DatabaseBuffer, $Hash;
                                my @SQL = $Self->{DBObject}->SQLProcessor(
                                    Database => \@DatabaseBuffer
                                );
                                my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
                                push @SQL, @SQLPost;
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
                        Name => 'PackageItemGeneric',
                        Data => { Tag => $Key, %{ $Structure{$Key} } },
                    );
                }
            }
            elsif ( ref $Structure{$Key} eq 'ARRAY' ) {
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
                            Name => 'PackageItemFilelistFile',
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
                            Name => 'PackageItemGeneric',
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

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
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

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

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

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );

        return $Self->_InstallHandling( Package => $Package );
    }

    # ------------------------------------------------------------ #
    # install remote package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'InstallRemote' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $File = $Self->{ParamObject}->GetParam( Param => 'File' ) || '';

        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            Source => $Source,
            File   => $File,
        );

        return $Self->_InstallHandling(
            Package => $Package,
            Source  => $Source,
            File    => $File,
        );
    }

    # ------------------------------------------------------------ #
    # upgrade remote package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpgradeRemote' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $File = $Self->{ParamObject}->GetParam( Param => 'File' ) || '';

        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            File   => $File,
            Source => $Source,
        );

        return $Self->_UpgradeHandling(
            Package => $Package,
            File    => $File,
            Source  => $Source,
        );
    }

    # ------------------------------------------------------------ #
    # reinstall package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Reinstall' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroReinstallPre = $Self->{ParamObject}->GetParam( Param => 'IntroReinstallPre' )
            || '';

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show reinstall intro pre
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
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # reinstall action package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ReinstallAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroReinstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroReinstallPost' )
            || '';

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show reinstall intro pre
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

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroUninstallPre = $Self->{ParamObject}->GetParam( Param => 'IntroUninstallPre' )
            || '';

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
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
            );
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminPackageManager',
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
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # uninstall action package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UninstallAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';
        my $IntroUninstallPost = $Self->{ParamObject}->GetParam( Param => 'IntroUninstallPost' )
            || '';

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

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $FormID = $Self->{ParamObject}->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        # save package in upload cache
        if (%UploadStuff) {
            my $Added = $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $FormID,
                %UploadStuff,
            );

            # if file got not added to storage
            # (e. g. because of 1 MB max_allowed_packet MySQL problem)
            if ( !$Added ) {
                $Self->{LayoutObject}->FatalError();
            }
        }

        # get package from upload cache
        else {
            my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
                FormID => $FormID,
            );
            if ( !@AttachmentData || ( $AttachmentData[0] && !%{ $AttachmentData[0] } ) ) {
                $Errors{FileUploadInvalid} = 'ServerError';
            }
            else {
                %UploadStuff = %{ $AttachmentData[0] };
            }
        }
        if ( !%Errors ) {
            my $Feedback
                = $Self->{PackageObject}->PackageIsInstalled( String => $UploadStuff{Content} );

            if ($Feedback) {
                return $Self->_UpgradeHandling(
                    Package => $UploadStuff{Content},
                    FormID  => $FormID,
                );
            }
            return $Self->_InstallHandling(
                Package => $UploadStuff{Content},
                FormID  => $FormID,
            );
        }
    }

    # ------------------------------------------------------------ #
    # rebuild package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'RebuildPackage' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Name    = $Self->{ParamObject}->GetParam( Param => 'Name' )    || '';
        my $Version = $Self->{ParamObject}->GetParam( Param => 'Version' ) || '';

        # get package
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
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
    my %Frontend;
    my %NeedReinstall;
    my %List;
    my $OutputNotify = '';
    if ( $Self->{ConfigObject}->Get('Package::RepositoryList') ) {
        %List = %{ $Self->{ConfigObject}->Get('Package::RepositoryList') };
    }
    my %RepositoryRoot;
    if ( $Self->{ConfigObject}->Get('Package::RepositoryRoot') ) {
        %RepositoryRoot = $Self->{PackageObject}->PackageOnlineRepositories();
    }
    $Frontend{SourceList} = $Self->{LayoutObject}->BuildSelection(
        Data => { %List, %RepositoryRoot, },
        Name => 'Source',
        Max  => 40,
        Translation => 0,
        SelectedID  => $Source,
        Class       => "W100pc",
    );
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => { %Param, %Frontend, },
    );
    if ($Source) {
        my @List = $Self->{PackageObject}->PackageOnlineList(
            URL  => $Source,
            Lang => $Self->{LayoutObject}->{UserLanguage},
        );
        if ( !@List ) {
            $OutputNotify .= $Self->{LayoutObject}->Notify( Priority => 'Error', );
            if ( !$OutputNotify ) {
                $OutputNotify .= $Self->{LayoutObject}->Notify(
                    Priority => 'Info',
                    Info     => 'No packages, or no new packages, found in selected repository.',
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );

        }

        for my $Data (@List) {

            $Self->{LayoutObject}->Block(
                Name => 'ShowRemotePackage',
                Data => {
                    %{$Data},
                    Source => $Source,
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

    # if there are no remote packages to show, a msg is displayed
    else {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    my @RepositoryList = $Self->{PackageObject}->RepositoryList();

    # if there are no local packages to show, a msg is displayed
    if ( !@RepositoryList ) {
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg2',
        );
    }

    for my $Package (@RepositoryList) {

        my %Data = $Self->_MessageGet( Info => $Package->{Description} );

        $Self->{LayoutObject}->Block(
            Name => 'ShowLocalPackage',
            Data => {
                %{$Package},
                %Data,
                Name    => $Package->{Name}->{Content},
                Version => $Package->{Version}->{Content},
                Vendor  => $Package->{Vendor}->{Content},
                URL     => $Package->{URL}->{Content},
            },
        );

        # show documentation link
        my %DocFile = $Self->_DocumentationGet( Filelist => $Package->{Filelist} );
        if (%DocFile) {
            $Self->{LayoutObject}->Block(
                Name => 'ShowLocalPackageDocumentation',
                Data => {
                    Name    => $Package->{Name}->{Content},
                    Version => $Package->{Version}->{Content},
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
            Data => {
                FormID => $Self->{UploadCacheObject}->FormIDCreate(),
                %Errors,
            },
        );
    }

    # FeatureAddons
    if ( $Self->{ConfigObject}->Get('Package::ShowFeatureAddons') ) {
        my $FeatureAddonData = $Self->_GetFeatureAddonData();

        if ( ref $FeatureAddonData eq 'ARRAY' && scalar @{$FeatureAddonData} > 0 ) {
            $Self->{LayoutObject}->Block(
                Name => 'FeatureAddonList',
            );

            for my $Item ( @{$FeatureAddonData} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'FeatureAddonData',
                    Data => $Item,
                );
            }
        }
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $OutputNotify;
    for my $ReinstallKey ( sort keys %NeedReinstall ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Data     => "$ReinstallKey $NeedReinstall{$ReinstallKey}"
                . ' - $Text{"Package not correctly deployed! Please reinstall the package."}',
            Link => '$Env{"Baselink"}Action=$Env{"Action"};Subaction=View;Name='
                . $ReinstallKey
                . ';Version='
                . $NeedReinstall{$ReinstallKey},
        );
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminPackageManager',
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _MessageGet {
    my ( $Self, %Param ) = @_;

    my $Title       = '';
    my $Description = '';
    my $Use         = 0;

    my $Language = $Self->{LayoutObject}->{UserLanguage}
        || $Self->{ConfigObject}->Get('DefaultLanguage');

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

            if ( $Tag->{Lang} eq $Language ) {
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
        if ( $Dir eq $Self->{LayoutObject}->{UserLanguage} ) {
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
    if ($DocumentationFileUserLanguage) {
        $Doc{Location} = $DocumentationFileUserLanguage;
    }
    elsif ($DocumentationFileDefaultLanguage) {
        $Doc{Location} = $DocumentationFileDefaultLanguage;
    }
    elsif ($DocumentationFile) {
        $Doc{Location} = $DocumentationFile;
    }
    elsif ($DocumentationFileFallback) {
        $Doc{Location} = $DocumentationFileFallback;
    }
    return %Doc;
}

sub _InstallHandling {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Package} ) {
        return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
    }

    # redirect after finishing installation
    if ( $Self->{ParamObject}->GetParam( Param => 'IntroInstallPost' ) ) {
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    my $IntroInstallPre    = $Self->{ParamObject}->GetParam( Param => 'IntroInstallPre' )    || '';
    my $IntroInstallVendor = $Self->{ParamObject}->GetParam( Param => 'IntroInstallVendor' ) || '';

    # parse package
    my %Structure = $Self->{PackageObject}->PackageParse( String => $Param{Package} );

    # online verification
    my $Verified = $Self->{PackageObject}->PackageVerify(
        Package   => $Param{Package},
        Structure => \%Structure,
    );
    my %VerifyInfo = $Self->{PackageObject}->PackageVerifyInfo();

    # vendor screen
    if ( !$IntroInstallVendor && !$IntroInstallPre && !$Verified ) {
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
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # intro screen
    my %Data;
    if ( $Structure{IntroInstall} ) {
        %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'pre' );
    }

    # intro before installation
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
        $Self->{LayoutObject}->Block(
            Name => 'IntroCancel',
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # install package
    elsif ( $Self->{PackageObject}->PackageInstall( String => $Param{Package} ) ) {

        # intro screen
        my %Data;
        if ( $Structure{IntroInstall} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroInstall}, Type => 'post' );
        }
        if (%Data) {
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
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    return $Self->{LayoutObject}->ErrorScreen();
}

sub _UpgradeHandling {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Package} ) {
        return $Self->{LayoutObject}->ErrorScreen( Message => 'No such package!' );
    }

    # redirect after finishing upgrade
    if ( $Self->{ParamObject}->GetParam( Param => 'IntroUpgradePost' ) ) {
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    my $IntroUpgradePre = $Self->{ParamObject}->GetParam( Param => 'IntroUpgradePre' ) || '';

    # check if we have to show upgrade intro pre
    my %Structure = $Self->{PackageObject}->PackageParse( String => $Param{Package}, );

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
                Subaction => $Self->{Subaction},
                Type      => 'IntroUpgradePre',
                Name      => $Structure{Name}->{Content},
                Version   => $Structure{Version}->{Content},
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'IntroCancel',
        );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # upgrade
    elsif ( $Self->{PackageObject}->PackageUpgrade( String => $Param{Package} ) ) {

        # intro screen
        my %Data;
        if ( $Structure{IntroUpgrade} ) {
            %Data = $Self->_MessageGet( Info => $Structure{IntroUpgrade}, Type => 'post' );
        }
        if (%Data) {
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
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    return $Self->{LayoutObject}->ErrorScreen();
}

sub _GetFeatureAddonData {
    my ( $Self, %Param ) = @_;

    # Default URL
    my $FeedURL = 'http://www.otrs.com/en/?type=104';

    my $Language = $Self->{LayoutObject}->{UserLanguage};

    # Check if URL for UserLanguage is available
    if ( $Language =~ m/^de/ ) {
        $FeedURL = 'http://www.otrs.com/de/?type=104';
    }

    if ( $Language =~ m/^es/ ) {
        $FeedURL = 'http://www.otrs.com/es/?type=104';
    }

    my $CacheKey  = "FeatureAddonData::$FeedURL";
    my $CacheTTL  = 60 * 60 * 24;                   # 1 day
    my $CacheType = 'PackageManager';

    my $CacheResult = $Self->{CacheObject}->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return $CacheResult if ref $CacheResult eq 'ARRAY';

    # set proxy settings can't use Kernel::System::WebAgent because of used
    # XML::FeedPP to get RSS files
    my $Proxy = $Self->{ConfigObject}->Get('WebUserAgent::Proxy');
    if ($Proxy) {
        $ENV{CGI_HTTP_PROXY} = $Proxy;
    }

    # get content
    my $Feed = eval {
        XML::FeedPP->new(
            $FeedURL,
            'xml_deref' => 1,
            'utf8_flag' => 1,
        );
    };

    return if !$Feed;

    my @Result;
    my $Count = 0;
    ITEM:
    for my $Item ( $Feed->get_item() ) {
        $Count++;
        last ITEM if $Count > 100;

        #        my $Time = $Item->pubDate();
        #        my $Ago;
        #        if ($Time) {
        #            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
        #                String => $Time,
        #            );
        #            $Ago = $Self->{TimeObject}->SystemTime() - $SystemTime;
        #            $Ago = $Self->{LayoutObject}->CustomerAge(
        #                Age   => $Ago,
        #                Space => ' ',
        #            );
        #        }

        push @Result, {
            Title       => $Item->title(),
            Link        => $Item->link(),
            Description => $Item->description(),
        };
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Result,
        TTL   => $CacheTTL,
    );

    return \@Result;
}

1;
