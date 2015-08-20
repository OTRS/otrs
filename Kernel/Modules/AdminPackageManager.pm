# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminPackageManager;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

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
                    return $LayoutObject->ErrorScreen(
                        Message =>
                            'Sorry, Apache::Reload is needed as PerlModule and '
                            .
                            'PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. '
                            .
                            'Alternatively, you can use the commandline tool bin/otrs.Console.pl to install packages!'
                    );
                }
            }
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # secure mode message (don't allow this action until secure mode is enabled)
    if ( !$ConfigObject->Get('SecureMode') ) {
        return $LayoutObject->SecureMode();
    }

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');

    # ------------------------------------------------------------ #
    # view diff file
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ViewDiff' ) {
        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';
        my $Location = $ParamObject->GetParam( Param => 'Location' );

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }
        my %Structure = $PackageObject->PackageParse( String => $Package );
        my $File = '';
        if ( ref $Structure{Filelist} eq 'ARRAY' ) {
            for my $Hash ( @{ $Structure{Filelist} } ) {
                if ( $Hash->{Location} eq $Location ) {
                    $File = $Hash->{Content};
                }
            }
        }
        my $LocalFile = $ConfigObject->Get('Home') . "/$Location";

        # do not allow to read file with including .. path (security related)
        $LocalFile =~ s/\.\.//g;
        if ( !$File ) {
            $LayoutObject->Block(
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
            $LayoutObject->Block(
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
            my $Content = $MainObject->FileRead(
                Location => $LocalFile,
                Mode     => 'binmode',
            );
            if ($Content) {
                $MainObject->Require('Text::Diff');
                my $Diff = Text::Diff::diff( \$File, $Content, { STYLE => 'OldStyle' } );
                $LayoutObject->Block(
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
                $LayoutObject->Block(
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
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ------------------------------------------------------------ #
    # view package
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'View' ) {
        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';
        my $Location = $ParamObject->GetParam( Param => 'Location' );
        my %Frontend;

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }

        # parse package
        my %Structure = $PackageObject->PackageParse( String => $Package );

        # online verification
        my $Verified = $PackageObject->PackageVerify(
            Package   => $Package,
            Structure => \%Structure,
        ) || 'unknown';
        my %VerifyInfo = $PackageObject->PackageVerifyInfo();

        # translate description
        if ( $LayoutObject->{LanguageObject} ) {
            $VerifyInfo{Description} = $LayoutObject->{LanguageObject}->Translate(
                $VerifyInfo{Description}
            );
        }

        # deploy check
        my $Deployed = $PackageObject->DeployCheck(
            Name    => $Name,
            Version => $Version,
        );
        my %DeployInfo = $PackageObject->DeployCheckInfo();
        $LayoutObject->Block(
            Name => 'Package',
            Data => {
                %Param, %Frontend,
                Name    => $Name,
                Version => $Version,
            },
        );

        my @RepositoryList = $PackageObject->RepositoryList(
            Result => 'short',
        );

        # if visible property is not enable, return error screen
        if (
            defined $Structure{PackageIsVisible}
            && exists $Structure{PackageIsVisible}->{Content}
            && !$Structure{PackageIsVisible}->{Content}
            )
        {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }

        PACKAGEACTION:
        for my $PackageAction (qw(DownloadLocal Rebuild Reinstall)) {

            if (
                $PackageAction eq 'DownloadLocal'
                && (
                    defined $Structure{PackageIsDownloadable}
                    && exists $Structure{PackageIsDownloadable}->{Content}
                    && !$Structure{PackageIsDownloadable}->{Content}
                )
                )
            {
                next PACKAGEACTION;
            }

            $LayoutObject->Block(
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
                        return $LayoutObject->Attachment(
                            Filename    => $Location,
                            ContentType => 'application/octet-stream',
                            Content     => $Hash->{Content},
                        );
                    }
                }
            }
        }
        my @DatabaseBuffer;

        # correct any 'dos-style' line endings - http://bugs.otrs.org/show_bug.cgi?id=9838
        ${$Package} =~ s{\r\n}{\n}xmsg;

        # create MD5 sum and add it into existing package structure
        my $MD5sum = $MainObject->MD5sum( String => $Package );

        $Structure{MD5sum} = {
            Tag     => 'MD5sum',
            Content => $MD5sum,
        };

        for my $Key ( sort keys %Structure ) {

            if ( ref $Structure{$Key} eq 'HASH' ) {

                if ( $Key =~ /^(Description|Filelist)$/ ) {
                    $LayoutObject->Block(
                        Name => "PackageItem$Key",
                        Data => {
                            Tag => $Key,
                            %{ $Structure{$Key} }
                        },
                    );
                }
                elsif ( $Key =~ /^Database(Install|Reinstall|Upgrade|Uninstall)$/ ) {

                    for my $Type (qw(pre post)) {
                        for my $Hash ( @{ $Structure{$Key}->{$Type} } ) {
                            if ( $Hash->{TagType} eq 'Start' ) {
                                if ( $Hash->{Tag} =~ /^Table/ ) {
                                    $LayoutObject->Block(
                                        Name => "PackageItemDatabase",
                                        Data => {
                                            %{$Hash},
                                            TagName => $Key,
                                            Type    => $Type
                                        },
                                    );
                                    push @DatabaseBuffer, $Hash;
                                }
                                else {
                                    $LayoutObject->Block(
                                        Name => "PackageItemDatabaseSub",
                                        Data => {
                                            %{$Hash},
                                            TagName => $Key,
                                        },
                                    );
                                    push @DatabaseBuffer, $Hash;
                                }
                            }
                            if ( $Hash->{Tag} =~ /^Table/ && $Hash->{TagType} eq 'End' ) {
                                push @DatabaseBuffer, $Hash;
                                my @SQL = $DBObject->SQLProcessor(
                                    Database => \@DatabaseBuffer
                                );
                                my @SQLPost = $DBObject->SQLProcessorPost();
                                push @SQL, @SQLPost;
                                for my $SQL (@SQL) {
                                    $LayoutObject->Block(
                                        Name => "PackageItemDatabaseSQL",
                                        Data => {
                                            TagName => $Key,
                                            SQL     => $SQL,
                                        },
                                    );
                                }
                                @DatabaseBuffer = ();
                            }
                        }
                    }
                }
                else {
                    $LayoutObject->Block(
                        Name => 'PackageItemGeneric',
                        Data => {
                            Tag => $Key,
                            %{ $Structure{$Key} }
                        },
                    );
                }
            }
            elsif ( ref $Structure{$Key} eq 'ARRAY' ) {

                for my $Hash ( @{ $Structure{$Key} } ) {
                    if ( $Key =~ /^(Description|ChangeLog)$/ ) {
                        $LayoutObject->Block(
                            Name => "PackageItem$Key",
                            Data => {
                                %{$Hash},
                                Tag => $Key,
                            },
                        );
                    }
                    elsif ( $Key =~ /^Code/ ) {
                        $Hash->{Content} = $LayoutObject->Ascii2Html(
                            Text           => $Hash->{Content},
                            HTMLResultMode => 1,
                            NewLine        => 72,
                        );
                        $LayoutObject->Block(
                            Name => "PackageItemCode",
                            Data => {
                                Tag => $Key,
                                %{$Hash}
                            },
                        );
                    }
                    elsif ( $Key =~ /^(Intro)/ ) {
                        if ( $Hash->{Format} && $Hash->{Format} =~ /plain/i ) {
                            $Hash->{Content} = '<pre class="contentbody">' . $Hash->{Content} . '</pre>';
                        }
                        $LayoutObject->Block(
                            Name => "PackageItemIntro",
                            Data => {
                                %{$Hash},
                                Tag => $Key,
                            },
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
                        $LayoutObject->Block(
                            Name => "PackageItemFilelistFile",
                            Data => {
                                Name    => $Name,
                                Version => $Version,
                                %{$Hash},
                            },
                        );

                        # check if is possible to download files
                        if (
                            !defined $Structure{PackageIsDownloadable}
                            || (
                                defined $Structure{PackageIsDownloadable}->{Content}
                                && $Structure{PackageIsDownloadable}->{Content} eq '1'
                            )
                            )
                        {
                            $LayoutObject->Block(
                                Name => "PackageItemFilelistFileLink",
                                Data => {
                                    Name    => $Name,
                                    Version => $Version,
                                    %{$Hash},
                                },
                            );
                        }

                        if ( $DeployInfo{File}->{ $Hash->{Location} } ) {
                            if ( $DeployInfo{File}->{ $Hash->{Location} } =~ /different/ ) {
                                $LayoutObject->Block(
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
                                $LayoutObject->Block(
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
                            $LayoutObject->Block(
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
                        $LayoutObject->Block(
                            Name => "PackageItemGeneric",
                            Data => {
                                %{$Hash},
                                Tag => $Key,
                            },
                        );
                    }
                }
            }
        }
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        if ( !$Deployed ) {
            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Data     => "$Name $Version - "
                    . $LayoutObject->{LanguageObject}
                    ->Translate("Package not correctly deployed! Please reinstall the package."),
                Link => $LayoutObject->{Baselink}
                    . 'Action=AdminPackageManager;Subaction=View;Name='
                    . $Name
                    . ';Version='
                    . $Version,
            );
        }

        if ( $Verified ne 'verified' ) {

            $Output .= $LayoutObject->Notify(
                Priority => 'Error',
                Data     => "$Name $Version - "
                    . $LayoutObject->{LanguageObject}->Translate(
                    "Package not verified by the OTRS Group! It is recommended not to use this package."
                    ),
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # view remote package
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ViewRemote' ) {
        my $File = $ParamObject->GetParam( Param => 'File' ) || '';
        my $Location = $ParamObject->GetParam( Param => 'Location' );
        my %Frontend;

        # download package
        my $Package = $PackageObject->PackageOnlineGet(
            Source => $Source,
            File   => $File,
        );

        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }
        elsif ( substr( $Package, 0, length('ErrorMessage:') ) eq 'ErrorMessage:' ) {

            # an error from the Package::CloudFileGet function
            return $LayoutObject->ErrorScreen( Message => $Package );
        }
        my %Structure = $PackageObject->PackageParse( String => $Package );
        $LayoutObject->Block(
            Name => 'Package',
            Data => { %Param, %Frontend, },
        );

        # allow to download only if package is allow to do it
        if (
            !defined $Structure{PackageIsDownloadable}
            || (
                defined $Structure{PackageIsDownloadable}->{Content}
                && $Structure{PackageIsDownloadable}->{Content} eq '1'
            )
            )
        {

            $LayoutObject->Block(
                Name => 'PackageDownloadRemote',
                Data => {
                    %Param, %Frontend,
                    File => $File,
                },
            );
        }

        # check if file is requested
        if ($Location) {
            if ( ref $Structure{Filelist} eq 'ARRAY' ) {
                for my $Hash ( @{ $Structure{Filelist} } ) {
                    if ( $Hash->{Location} eq $Location ) {
                        return $LayoutObject->Attachment(
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
                    $LayoutObject->Block(
                        Name => "PackageItem$Key",
                        Data => {
                            Tag => $Key,
                            %{ $Structure{$Key} }
                        },
                    );
                }
                elsif ( $Key =~ /^Database(Install|Reinstall|Upgrade|Uninstall)$/ ) {
                    for my $Type (qw(pre post)) {
                        for my $Hash ( @{ $Structure{$Key}->{$Type} } ) {
                            if ( $Hash->{TagType} eq 'Start' ) {
                                if ( $Hash->{Tag} =~ /^Table/ ) {
                                    $LayoutObject->Block(
                                        Name => "PackageItemDatabase",
                                        Data => {
                                            %{$Hash},
                                            TagName => $Key,
                                            Type    => $Type
                                        },
                                    );
                                    push @DatabaseBuffer, $Hash;
                                }
                                else {
                                    $LayoutObject->Block(
                                        Name => "PackageItemDatabaseSub",
                                        Data => {
                                            %{$Hash},
                                            TagName => $Key,
                                        },
                                    );
                                    push @DatabaseBuffer, $Hash;
                                }
                            }
                            if ( $Hash->{Tag} =~ /^Table/ && $Hash->{TagType} eq 'End' ) {
                                push @DatabaseBuffer, $Hash;
                                my @SQL = $DBObject->SQLProcessor(
                                    Database => \@DatabaseBuffer
                                );
                                my @SQLPost = $DBObject->SQLProcessorPost();
                                push @SQL, @SQLPost;
                                for my $SQL (@SQL) {
                                    $LayoutObject->Block(
                                        Name => "PackageItemDatabaseSQL",
                                        Data => {
                                            TagName => $Key,
                                            SQL     => $SQL,
                                        },
                                    );
                                }
                                @DatabaseBuffer = ();
                            }
                        }
                    }
                }
                else {
                    $LayoutObject->Block(
                        Name => 'PackageItemGeneric',
                        Data => {
                            Tag => $Key,
                            %{ $Structure{$Key} }
                        },
                    );
                }
            }
            elsif ( ref $Structure{$Key} eq 'ARRAY' ) {
                for my $Hash ( @{ $Structure{$Key} } ) {
                    if ( $Key =~ /^(Description|ChangeLog)$/ ) {
                        $LayoutObject->Block(
                            Name => "PackageItem$Key",
                            Data => {
                                %{$Hash},
                                Tag => $Key,
                            },
                        );
                    }
                    elsif ( $Key =~ /^Code/ ) {
                        $Hash->{Content} = $LayoutObject->Ascii2Html(
                            Text           => $Hash->{Content},
                            HTMLResultMode => 1,
                            NewLine        => 72,
                        );
                        $LayoutObject->Block(
                            Name => "PackageItemCode",
                            Data => {
                                Tag => $Key,
                                %{$Hash}
                            },
                        );
                    }
                    elsif ( $Key =~ /^(Intro)/ ) {
                        if ( $Hash->{Format} && $Hash->{Format} =~ /plain/i ) {
                            $Hash->{Content} = '<pre class="contentbody">' . $Hash->{Content} . '</pre>';
                        }
                        $LayoutObject->Block(
                            Name => "PackageItemIntro",
                            Data => {
                                %{$Hash},
                                Tag => $Key,
                            },
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
                        $LayoutObject->Block(
                            Name => 'PackageItemFilelistFile',
                            Data => {
                                Name    => $Structure{Name}->{Content},
                                Version => $Structure{Version}->{Content},
                                File    => $File,
                                %{$Hash},
                            },
                        );

                        # check if is possible to download files
                        if (
                            !defined $Structure{PackageIsDownloadable}
                            || (
                                defined $Structure{PackageIsDownloadable}->{Content}
                                && $Structure{PackageIsDownloadable}->{Content} eq '1'
                            )
                            )
                        {
                            $LayoutObject->Block(
                                Name => "PackageItemFilelistFileLink",
                                Data => {
                                    Name    => $Structure{Name}->{Content},
                                    Version => $Structure{Version}->{Content},
                                    File    => $File,
                                    %{$Hash},
                                },
                            );
                        }
                    }
                    else {
                        $LayoutObject->Block(
                            Name => 'PackageItemGeneric',
                            Data => {
                                %{$Hash},
                                Tag => $Key,
                            },
                        );
                    }
                }
            }
        }
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # download package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Download' ) {
        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }
        return $LayoutObject->Attachment(
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
        my $File = $ParamObject->GetParam( Param => 'File' ) || '';

        # download package
        my $Package = $PackageObject->PackageOnlineGet(
            Source => $Source,
            File   => $File,
        );

        # check
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }
        return $LayoutObject->Attachment(
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
        $LayoutObject->ChallengeTokenCheck();

        my $Source = $ParamObject->GetParam( Param => 'Source' ) || '';
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRepository',
            Value     => $Source,
        );
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # install package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Install' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
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
        $LayoutObject->ChallengeTokenCheck();

        my $File = $ParamObject->GetParam( Param => 'File' ) || '';

        # download package
        my $Package = $PackageObject->PackageOnlineGet(
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
        $LayoutObject->ChallengeTokenCheck();

        my $File = $ParamObject->GetParam( Param => 'File' ) || '';

        # download package
        my $Package = $PackageObject->PackageOnlineGet(
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
        $LayoutObject->ChallengeTokenCheck();

        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';
        my $IntroReinstallPre = $ParamObject->GetParam( Param => 'IntroReinstallPre' )
            || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show reinstall intro pre
        my %Structure = $PackageObject->PackageParse(
            String => $Package,
        );

        # intro screen
        my %Data;
        if ( $Structure{IntroReinstall} ) {
            %Data = $Self->_MessageGet(
                Info => $Structure{IntroReinstall},
                Type => 'pre'
            );
        }
        if ( %Data && !$IntroReinstallPre ) {
            $LayoutObject->Block(
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
            $LayoutObject->Block(
                Name => 'IntroCancel',
            );
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # reinstall screen
        else {
            $LayoutObject->Block(
                Name => 'Reinstall',
                Data => {
                    %Param,
                    Name    => $Structure{Name}->{Content},
                    Version => $Structure{Version}->{Content},
                },
            );
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # reinstall action package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ReinstallAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';
        my $IntroReinstallPost = $ParamObject->GetParam( Param => 'IntroReinstallPost' )
            || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show reinstall intro pre
        my %Structure = $PackageObject->PackageParse(
            String => $Package,
        );

        # intro screen
        if ( !$PackageObject->PackageReinstall( String => $Package ) ) {
            return $LayoutObject->ErrorScreen();
        }
        my %Data;
        if ( $Structure{IntroReinstall} ) {
            %Data = $Self->_MessageGet(
                Info => $Structure{IntroReinstall},
                Type => 'post'
            );
        }
        if ( %Data && !$IntroReinstallPost ) {
            $LayoutObject->Block(
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
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # redirect
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # uninstall package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Uninstall' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';
        my $IntroUninstallPre = $ParamObject->GetParam( Param => 'IntroUninstallPre' )
            || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }

        # check if we have to show uninstall intro pre
        my %Structure = $PackageObject->PackageParse(
            String => $Package,
        );

        # intro screen
        my %Data;
        if ( $Structure{IntroUninstall} ) {
            %Data = $Self->_MessageGet(
                Info => $Structure{IntroUninstall},
                Type => 'pre'
            );
        }
        if ( %Data && !$IntroUninstallPre ) {
            $LayoutObject->Block(
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
            $LayoutObject->Block(
                Name => 'IntroCancel',
            );
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # uninstall screen
        else {
            $LayoutObject->Block(
                Name => 'Uninstall',
                Data => {
                    %Param,
                    Name    => $Structure{Name}->{Content},
                    Version => $Structure{Version}->{Content},
                },
            );
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # uninstall action package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UninstallAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';
        my $IntroUninstallPost = $ParamObject->GetParam( Param => 'IntroUninstallPost' )
            || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }

        # parse package
        my %Structure = $PackageObject->PackageParse(
            String => $Package,
        );

        # unsinstall the package
        if ( !$PackageObject->PackageUninstall( String => $Package ) ) {
            return $LayoutObject->ErrorScreen();
        }

        # intro screen
        my %Data;
        if ( $Structure{IntroUninstall} ) {
            %Data = $Self->_MessageGet(
                Info => $Structure{IntroUninstall},
                Type => 'post'
            );
        }
        if ( %Data && !$IntroUninstallPost ) {
            my %Data = $Self->_MessageGet( Info => $Structure{IntroUninstallPost} );
            $LayoutObject->Block(
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
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # redirect
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # install package
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'InstallUpload' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $FormID = $ParamObject->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );

        my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

        # save package in upload cache
        if (%UploadStuff) {
            my $Added = $UploadCacheObject->FormIDAddFile(
                FormID => $FormID,
                %UploadStuff,
            );

            # if file got not added to storage
            # (e. g. because of 1 MB max_allowed_packet MySQL problem)
            if ( !$Added ) {
                $LayoutObject->FatalError();
            }
        }

        # get package from upload cache
        else {
            my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
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
            my $Feedback = $PackageObject->PackageIsInstalled( String => $UploadStuff{Content} );

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
        $LayoutObject->ChallengeTokenCheck();

        my $Name    = $ParamObject->GetParam( Param => 'Name' )    || '';
        my $Version = $ParamObject->GetParam( Param => 'Version' ) || '';

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $Name,
            Version => $Version,
            Result  => 'SCALAR',
        );
        if ( !$Package ) {
            return $LayoutObject->ErrorScreen( Message => 'No such package!' );
        }
        my %Structure = $PackageObject->PackageParse(
            String => $Package,
        );
        my $File = $PackageObject->PackageBuild(%Structure);
        return $LayoutObject->Attachment(
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
    if ( $ConfigObject->Get('Package::RepositoryList') ) {
        %List = %{ $ConfigObject->Get('Package::RepositoryList') };
    }
    my %RepositoryRoot;
    if ( $ConfigObject->Get('Package::RepositoryRoot') ) {
        %RepositoryRoot = $PackageObject->PackageOnlineRepositories();
    }

    # show cloud repo if system is registered
    my $RepositoryCloudList;
    my $RegistrationState = $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGet(
        Key => 'Registration::State',
    ) || '';
    if ( $RegistrationState eq 'registered' ) {

        $RepositoryCloudList =
            $PackageObject->RepositoryCloudList( NoCache => 1 );
    }

    # in case Source is present on repository cloud list
    # the call for retrieving data about it, should be performed
    # using the CloudService backend
    my $FromCloud = ( $RepositoryCloudList->{$Source} ? 1 : 0 );

    $Frontend{SourceList} = $LayoutObject->BuildSelection(
        Data        => { %List, %RepositoryRoot, %{$RepositoryCloudList}, },
        Name        => 'Source',
        Title       => 'Repository List',
        Max         => 40,
        Translation => 0,
        SelectedID  => $Source,
        Class       => "Modernize W100pc",
    );
    $LayoutObject->Block(
        Name => 'Overview',
        Data => { %Param, %Frontend, },
    );
    if ($Source) {

        my @List = $PackageObject->PackageOnlineList(
            URL       => $Source,
            Lang      => $LayoutObject->{UserLanguage},
            FromCloud => $FromCloud,
        );
        if ( !@List ) {
            $OutputNotify .= $LayoutObject->Notify(
                Priority => 'Error',
            );
            if ( !$OutputNotify ) {
                $OutputNotify .= $LayoutObject->Notify(
                    Priority => 'Info',
                    Info     => 'No packages, or no new packages, found in selected repository.',
                );
            }
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );

        }

        for my $Data (@List) {

            $LayoutObject->Block(
                Name => 'ShowRemotePackage',
                Data => {
                    %{$Data},
                    Source => $Source,
                },
            );

            # show documentation link
            my %DocFile = $Self->_DocumentationGet( Filelist => $Data->{Filelist} );
            if (%DocFile) {
                $LayoutObject->Block(
                    Name => 'ShowRemotePackageDocumentation',
                    Data => {
                        %{$Data},
                        Source => $Source,
                        %DocFile,
                    },
                );
            }

            if ( $Data->{Upgrade} ) {
                $LayoutObject->Block(
                    Name => 'ShowRemotePackageUpgrade',
                    Data => {
                        %{$Data},
                        Source => $Source,
                    },
                );
            }
            elsif ( !$Data->{Installed} ) {
                $LayoutObject->Block(
                    Name => 'ShowRemotePackageInstall',
                    Data => {
                        %{$Data},
                        Source => $Source,
                    },
                );
            }
        }
    }

    # if there are no remote packages to show, a msg is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    my @RepositoryList = $PackageObject->RepositoryList();

    # remove not visible packages
    @RepositoryList = map {
        (
            !defined $_->{PackageIsVisible}
                || ( $_->{PackageIsVisible}->{Content} && $_->{PackageIsVisible}->{Content} eq '1' )
            )
            ? $_
            : ()
    } @RepositoryList;

    # if there are no local packages to show, a msg is displayed
    if ( !@RepositoryList ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg2',
        );
    }

    # verify packages if we have some
    my %VerificationData;
    if (@RepositoryList) {
        %VerificationData = $PackageObject->PackageVerifyAll();
    }

    my %NotVerifiedPackages;
    my %UnknownVerficationPackages;

    for my $Package (@RepositoryList) {

        my %Data = $Self->_MessageGet( Info => $Package->{Description} );

        $LayoutObject->Block(
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

        if (
            $VerificationData{ $Package->{Name}->{Content} }
            && $VerificationData{ $Package->{Name}->{Content} } eq 'verified'
            )
        {
            $LayoutObject->Block(
                Name => 'ShowLocalPackageVerifyLogo',
            );
        }

        # show documentation link
        my %DocFile = $Self->_DocumentationGet( Filelist => $Package->{Filelist} );
        if (%DocFile) {
            $LayoutObject->Block(
                Name => 'ShowLocalPackageDocumentation',
                Data => {
                    Name    => $Package->{Name}->{Content},
                    Version => $Package->{Version}->{Content},
                    %DocFile,
                },
            );
        }

        if ( $Package->{Status} eq 'installed' ) {

            if (
                !defined $Package->{PackageIsRemovable}
                || (
                    defined $Package->{PackageIsRemovable}->{Content}
                    && $Package->{PackageIsRemovable}->{Content} eq '1'
                )
                )
            {

                $LayoutObject->Block(
                    Name => 'ShowLocalPackageUninstall',
                    Data => {
                        %{$Package},
                        Name    => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                        Vendor  => $Package->{Vendor}->{Content},
                        URL     => $Package->{URL}->{Content},
                    },
                );
            }

            if (
                !$PackageObject->DeployCheck(
                    Name    => $Package->{Name}->{Content},
                    Version => $Package->{Version}->{Content}
                )
                )
            {
                $NeedReinstall{ $Package->{Name}->{Content} } = $Package->{Version}->{Content};
                $LayoutObject->Block(
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
            $LayoutObject->Block(
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

        if (
            $VerificationData{ $Package->{Name}->{Content} }
            && $VerificationData{ $Package->{Name}->{Content} } eq 'not_verified'
            )
        {
            $NotVerifiedPackages{ $Package->{Name}->{Content} } = $Package->{Version}->{Content};
        }
        elsif (
            $VerificationData{ $Package->{Name}->{Content} }
            && $VerificationData{ $Package->{Name}->{Content} } eq 'unknown'
            )
        {
            $UnknownVerficationPackages{ $Package->{Name}->{Content} } = $Package->{Version}->{Content};
        }

    }

    # show file upload
    if ( $ConfigObject->Get('Package::FileUpload') ) {
        $LayoutObject->Block(
            Name => 'OverviewFileUpload',
            Data => {
                FormID => $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate(),
                %Errors,
            },
        );

        # check if we're on MySQL and show a max_allowed_packet notice
        # if the actual value for this setting is too low
        if ( $DBObject->{'DB::Type'} eq 'mysql' ) {

            # check the actual setting
            $DBObject->Prepare(
                SQL => "SHOW variables WHERE Variable_name = 'max_allowed_packet'",
            );

            my $MaxAllowedPacket            = 0;
            my $MaxAllowedPacketRecommended = 20;
            while ( my @Data = $DBObject->FetchrowArray() ) {
                if ( $Data[1] ) {
                    $MaxAllowedPacket = $Data[1] / 1024 / 1024;
                }
            }

            if ( $MaxAllowedPacket < $MaxAllowedPacketRecommended ) {
                $LayoutObject->Block(
                    Name => 'DatabasePackageSizeWarning',
                    Data => {
                        MaxAllowedPacket            => $MaxAllowedPacket,
                        MaxAllowedPacketRecommended => $MaxAllowedPacketRecommended,
                    },
                );
            }
        }
    }

    # FeatureAddons
    if ( $ConfigObject->Get('Package::ShowFeatureAddons') ) {
        my $FeatureAddonData = $Self->_GetFeatureAddonData();

        if ( ref $FeatureAddonData eq 'ARRAY' && scalar @{$FeatureAddonData} > 0 ) {
            $LayoutObject->Block(
                Name => 'FeatureAddonList',
            );

            for my $Item ( @{$FeatureAddonData} ) {
                $LayoutObject->Block(
                    Name => 'FeatureAddonData',
                    Data => $Item,
                );
            }
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $OutputNotify;
    for my $ReinstallKey ( sort keys %NeedReinstall ) {
        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Data     => "$ReinstallKey $NeedReinstall{$ReinstallKey} - "
                . $LayoutObject->{LanguageObject}
                ->Translate("Package not correctly deployed! Please reinstall the package."),
            Link => $LayoutObject->{Baselink}
                . 'Action=AdminPackageManager;Subaction=View;Name='
                . $ReinstallKey
                . ';Version='
                . $NeedReinstall{$ReinstallKey},
        );
    }

    VERIFICATION:
    for my $Package ( sort keys %NotVerifiedPackages ) {

        next VERIFICATION if !$Package;
        next VERIFICATION if !$NotVerifiedPackages{$Package};

        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Data     => "$Package $NotVerifiedPackages{$Package} - "
                . $LayoutObject->{LanguageObject}->Translate(
                "Package not verified by the OTRS Group! It is recommended not to use this package."
                ),
        );
    }

    VERIFICATION:
    for my $Package ( sort keys %UnknownVerficationPackages ) {

        next VERIFICATION if !$Package;
        next VERIFICATION if !$UnknownVerficationPackages{$Package};

        $Output .= $LayoutObject->Notify(
            Priority => 'Error',
            Data     => "$Package $UnknownVerficationPackages{$Package} - "
                . $LayoutObject->{LanguageObject}->Translate(
                "Package not verified due a communication issue with verification server!"
                ),
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminPackageManager',
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _MessageGet {
    my ( $Self, %Param ) = @_;

    my $Title       = '';
    my $Description = '';
    my $Use         = 0;

    my $Language = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage}
        || $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');

    if ( $Param{Info} ) {
        TAG:
        for my $Tag ( @{ $Param{Info} } ) {
            if ( $Param{Type} ) {
                next TAG if $Tag->{Type} !~ /^$Param{Type}/i;
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
    my $DefaultLanguage = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');

    # find documentation files
    FILE:
    for my $File ( @{ $Param{Filelist} } ) {

        next FILE if !$File;
        next FILE if !$File->{Location};

        my ( $Dir, $Filename ) = $File->{Location} =~ m{ \A doc/ ( .+ ) / ( .+? .pdf ) }xmsi;

        next FILE if !$Dir;
        next FILE if !$Filename;

        # take user language first
        if ( $Dir eq $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage} ) {
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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed params
    if ( !$Param{Package} ) {
        return $LayoutObject->ErrorScreen( Message => 'No such package!' );
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # redirect after finishing installation
    if ( $ParamObject->GetParam( Param => 'IntroInstallPost' ) ) {
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    my $IntroInstallPre    = $ParamObject->GetParam( Param => 'IntroInstallPre' )    || '';
    my $IntroInstallVendor = $ParamObject->GetParam( Param => 'IntroInstallVendor' ) || '';

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # parse package
    my %Structure = $PackageObject->PackageParse( String => $Param{Package} );

    # online verification
    my $Verified = $PackageObject->PackageVerify(
        Package   => $Param{Package},
        Structure => \%Structure,
    ) || 'verified';
    my %VerifyInfo = $PackageObject->PackageVerifyInfo();

    # translate description
    if ( $LayoutObject->{LanguageObject} ) {
        $VerifyInfo{Description} = $LayoutObject->{LanguageObject}->Translate(
            $VerifyInfo{Description}
        );
    }

    # vendor screen
    if ( !$IntroInstallVendor && !$IntroInstallPre && $Verified ne 'verified' ) {

        $LayoutObject->Block(
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

        $LayoutObject->Block(
            Name => 'IntroCancel',
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # intro screen
    my %Data;
    if ( $Structure{IntroInstall} ) {
        %Data = $Self->_MessageGet(
            Info => $Structure{IntroInstall},
            Type => 'pre'
        );
    }

    # get cloud repositories
    my $RepositoryCloudList =
        $PackageObject->RepositoryCloudList();

    # in case Source is present on repository cloud list
    # the package shold be retrieved using the CloudService backend
    my $FromCloud = 0;
    if ( $Param{Source} && $RepositoryCloudList->{ $Param{Source} } ) {
        $FromCloud = 1;
    }

    # intro before installation
    if ( %Data && !$IntroInstallPre ) {

        $LayoutObject->Block(
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

        if ( $Verified eq 'verified' ) {
            $LayoutObject->Block(
                Name => 'OTRSVerifyLogo',
            );
        }

        $LayoutObject->Block(
            Name => 'IntroCancel',
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # install package
    elsif (
        $PackageObject->PackageInstall(
            String    => $Param{Package},
            FromCloud => $FromCloud
        )
        )
    {

        # intro screen
        my %Data;
        if ( $Structure{IntroInstall} ) {
            %Data = $Self->_MessageGet(
                Info => $Structure{IntroInstall},
                Type => 'post'
            );
        }
        if (%Data) {
            $LayoutObject->Block(
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

            if ( $Verified eq 'verified' ) {
                $LayoutObject->Block(
                    Name => 'OTRSVerifyLogo',
                );
            }

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # redirect
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    return $LayoutObject->ErrorScreen();
}

sub _UpgradeHandling {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed params
    if ( !$Param{Package} ) {
        return $LayoutObject->ErrorScreen( Message => 'No such package!' );
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # redirect after finishing upgrade
    if ( $ParamObject->GetParam( Param => 'IntroUpgradePost' ) ) {
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    my $IntroUpgradePre = $ParamObject->GetParam( Param => 'IntroUpgradePre' ) || '';

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # check if we have to show upgrade intro pre
    my %Structure = $PackageObject->PackageParse(
        String => $Param{Package},
    );

    # intro screen
    my %Data;
    if ( $Structure{IntroUpgrade} ) {
        %Data = $Self->_MessageGet(
            Info => $Structure{IntroUpgrade},
            Type => 'pre'
        );
    }
    if ( %Data && !$IntroUpgradePre ) {
        $LayoutObject->Block(
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
        $LayoutObject->Block(
            Name => 'IntroCancel',
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPackageManager',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # upgrade
    elsif ( $PackageObject->PackageUpgrade( String => $Param{Package} ) ) {

        # intro screen
        my %Data;
        if ( $Structure{IntroUpgrade} ) {
            %Data = $Self->_MessageGet(
                Info => $Structure{IntroUpgrade},
                Type => 'post'
            );
        }
        if (%Data) {
            $LayoutObject->Block(
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
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminPackageManager',
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # redirect
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    return $LayoutObject->ErrorScreen();
}

sub _GetFeatureAddonData {
    my ( $Self, %Param ) = @_;

    my $Language = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage};

    # cleanup main language for languages like es_MX (es in this case)
    $Language = substr $Language, 0, 2;

    my $CacheKey  = "FeatureAddonData::$Language";
    my $CacheTTL  = 60 * 60 * 24;                    # 1 day
    my $CacheType = 'PackageManager';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $CacheResult = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return $CacheResult if ref $CacheResult eq 'ARRAY';

    my $CloudService = 'PublicFeeds';
    my $Operation    = 'FAOFeed';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        Language => $Language,
                    },
                },
            ],
        },
    );

    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Run');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {
        return "Can't connect to OTRS Feature Add-on list server!";
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        return "Can't get OTRS Feature Add-on list from server";
    }
    elsif ( !$OperationResult->{Success} ) {
        return $OperationResult->{ErrorMessage} || "Can't get OTRS Feature Add-on from server!";
    }

    my $FAOFeed = $OperationResult->{Data}->{FAOs};

    return if !IsArrayRefWithData($FAOFeed);

    # set cache
    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => $FAOFeed,
        TTL   => $CacheTTL,
    );

    return $FAOFeed;
}

1;
