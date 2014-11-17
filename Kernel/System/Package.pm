# --
# Kernel/System/Package.pm - lib package manager
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Package;

use strict;
use warnings;

use MIME::Base64;
use File::Copy;

use Kernel::Config;
use Kernel::System::SysConfig;
use Kernel::System::WebUserAgent;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CloudService',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::JSON',
    'Kernel::System::Loader',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::XML',
);

=head1 NAME

Kernel::System::Package - to manage application packages/modules

=head1 SYNOPSIS

All functions to manage application packages/modules.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    $Self->{ConfigObject} = $Kernel::OM->Get('Kernel::Config');
    $Self->{MainObject}   = $Kernel::OM->Get('Kernel::System::Main');

    $Self->{PackageMap} = {
        Name            => 'SCALAR',
        Version         => 'SCALAR',
        Vendor          => 'SCALAR',
        BuildDate       => 'SCALAR',
        BuildHost       => 'SCALAR',
        License         => 'SCALAR',
        URL             => 'SCALAR',
        ChangeLog       => 'ARRAY',
        Description     => 'ARRAY',
        Framework       => 'ARRAY',
        OS              => 'ARRAY',
        PackageRequired => 'ARRAY',
        ModuleRequired  => 'ARRAY',
        IntroInstall    => 'ARRAY',
        IntroUninstall  => 'ARRAY',
        IntroUpgrade    => 'ARRAY',
        IntroReinstall  => 'ARRAY',
        PackageMerge    => 'ARRAY',

        # package flags
        PackageIsVisible      => 'SCALAR',
        PackageIsDownloadable => 'SCALAR',
        PackageIsRemovable    => 'SCALAR',

        # *(Pre|Post) - just for compat. to 2.2
        IntroInstallPre    => 'ARRAY',
        IntroInstallPost   => 'ARRAY',
        IntroUninstallPre  => 'ARRAY',
        IntroUninstallPost => 'ARRAY',
        IntroUpgradePre    => 'ARRAY',
        IntroUpgradePost   => 'ARRAY',
        IntroReinstallPre  => 'ARRAY',
        IntroReinstallPost => 'ARRAY',

        CodeInstall   => 'ARRAY',
        CodeUpgrade   => 'ARRAY',
        CodeUninstall => 'ARRAY',
        CodeReinstall => 'ARRAY',
    };
    $Self->{PackageMapFileList} = {
        File => 'ARRAY',
    };

    $Self->{PackageVerifyURL} = 'https://pav.otrs.com/otrs/public.pl';

    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # permission check
    if ( !$Self->_FileSystemCheck() ) {
        die "ERROR: Need write permission in OTRS home\n"
            . "Try: \$OTRS_HOME/bin/otrs.SetPermissions.pl !!!\n";
    }

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'Package::EventModulePost',
    );

    # reserve space for merged packages
    $Self->{MergedPackages} = {};

    return $Self;
}

=item RepositoryList()

returns a list of repository packages
using Result => 'short' will only return name, version, install_status md5sum and vendor
instead of the structure

    my @List = $PackageObject->RepositoryList();

    my @List = $PackageObject->RepositoryList(
        Result => 'short',
    );

=cut

sub RepositoryList {
    my ( $Self, %Param ) = @_;

    my $Result = 'Full';
    if ( defined $Param{Result} && lc $Param{Result} eq 'short' ) {
        $Result = 'Short';
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Cache = $CacheObject->Get(
        Type => "RepositoryList",
        Key  => $Result . 'List',
    );
    return @{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get repository list
    $DBObject->Prepare(
        SQL => 'SELECT name, version, install_status, content, vendor
                FROM package_repository
                ORDER BY name, create_time',
    );

    # fetch the data
    my @Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Package = (
            Name    => $Row[0],
            Version => $Row[1],
            Status  => $Row[2],
            Vendor  => $Row[4],
        );

        # correct any 'dos-style' line endings - http://bugs.otrs.org/show_bug.cgi?id=9838
        $Row[3] =~ s{\r\n}{\n}xmsg;
        $Package{MD5sum} = $Self->{MainObject}->MD5sum( String => \$Row[3] );

        # get package attributes
        if ( $Row[3] && $Result eq 'Short' ) {

            push @Data, {%Package};

        }
        elsif ( $Row[3] ) {

            my %Structure = $Self->PackageParse( String => \$Row[3] );
            push @Data, { %Package, %Structure };

        }
    }

    # set cache
    $CacheObject->Set(
        Type  => 'RepositoryList',
        Key   => $Result . 'List',
        Value => \@Data,
        TTL   => 30 * 24 * 60 * 60,
    );

    return @Data;
}

=item RepositoryGet()

get a package from local repository

    my $Package = $PackageObject->RepositoryGet(
        Name    => 'Application A',
        Version => '1.0',
    );

    my $PackageScalar = $PackageObject->RepositoryGet(
        Name    => 'Application A',
        Version => '1.0',
        Result  => 'SCALAR',
    );

=cut

sub RepositoryGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Name Version)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = $Param{Name} . $Param{Version};
    my $Cache    = $CacheObject->Get(
        Type => 'RepositoryGet',
        Key  => $CacheKey,
    );
    return $Cache if $Cache && $Param{Result} && $Param{Result} eq 'SCALAR';
    return ${$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get repository
    $DBObject->Prepare(
        SQL   => 'SELECT content FROM package_repository WHERE name = ? AND version = ?',
        Bind  => [ \$Param{Name}, \$Param{Version} ],
        Limit => 1,
    );

    # fetch data
    my $Package = '';
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Package = $Row[0];
    }

    if ( !$Package ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No such package: $Param{Name}-$Param{Version}!",
        );
        return;
    }

    # set cache
    $CacheObject->Set(
        Type  => 'RepositoryGet',
        Key   => $CacheKey,
        Value => \$Package,
        TTL   => 30 * 24 * 60 * 60,
    );

    return \$Package if $Param{Result} && $Param{Result} eq 'SCALAR';
    return $Package;
}

=item RepositoryAdd()

add a package to local repository

    $PackageObject->RepositoryAdd(
        String => $FileString,
        FromCloud => 0, # optional 1 or 0, it indicates if package came from Cloud or not
    );

=cut

sub RepositoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'String not defined!',
        );
        return;
    }

    # get from cloud flag
    $Param{FromCloud} //= 0;

    # get package attributes
    my %Structure = $Self->PackageParse(%Param);

    if ( !IsHashRefWithData( \%Structure ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Invalid Package!',
        );
        return;
    }
    if ( !$Structure{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }
    if ( !$Structure{Version} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Version!',
        );
        return;
    }

    # check if package already exists
    my $PackageExists = $Self->RepositoryGet(
        Name    => $Structure{Name}->{Content},
        Version => $Structure{Version}->{Content},
        Result  => 'SCALAR',
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ($PackageExists) {
        $DBObject->Do(
            SQL  => 'DELETE FROM package_repository WHERE name = ? AND version = ?',
            Bind => [ \$Structure{Name}->{Content}, \$Structure{Version}->{Content} ],
        );
    }

    # add new package
    my $FileName = $Structure{Name}->{Content} . '-' . $Structure{Version}->{Content} . '.xml';

    return if !$DBObject->Do(
        SQL => 'INSERT INTO package_repository (name, version, vendor, filename, '
            . ' content_type, content, install_status, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES  (?, ?, ?, ?, \'text/xml\', ?, \'not installed\', '
            . ' current_timestamp, 1, current_timestamp, 1)',
        Bind => [
            \$Structure{Name}->{Content}, \$Structure{Version}->{Content},
            \$Structure{Vendor}->{Content}, \$FileName, \$Param{String},
        ],
    );

    # cleanup cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'RepositoryList',
    );

    return 1;
}

=item RepositoryRemove()

remove a package from local repository

    $PackageObject->RepositoryRemove(
        Name    => 'Application A',
        Version => '1.0',
    );

=cut

sub RepositoryRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Name not defined!',
        );
        return;
    }

    # create sql
    my @Bind = ( \$Param{Name} );
    my $SQL  = 'DELETE FROM package_repository WHERE name = ?';
    if ( $Param{Version} ) {
        $SQL .= ' AND version = ?';
        push @Bind, \$Param{Version};
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind
    );

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # cleanup cache
    $CacheObject->CleanUp(
        Type => 'RepositoryList',
    );
    $CacheObject->CleanUp(
        Type => 'RepositoryGet',
    );

    return 1;
}

=item PackageInstall()

install a package

    $PackageObject->PackageInstall(
        String    => $FileString
        FromCloud => 1, # optional 1 or 0, it indicates if package's origin is Cloud or not
    );

=cut

sub PackageInstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'String not defined!',
        );
        return;
    }

    # get from cloud flag
    my $FromCloud = $Param{FromCloud} || 0;

    # conflict check
    my %Structure = $Self->PackageParse(%Param);

    # check if package is already installed
    if ( $Self->PackageIsInstalled( Name => $Structure{Name}->{Content} ) ) {
        if ( !$Param{Force} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => 'Package already installed, try upgrade!',
            );
            return $Self->PackageUpgrade(%Param);
        }
    }

    # check OS
    if ( $Structure{OS} && !$Param{Force} ) {
        return if !$Self->_OSCheck( OS => $Structure{OS} );
    }

    # check framework
    if ( $Structure{Framework} && !$Param{Force} ) {
        return if !$Self->_CheckFramework( Framework => $Structure{Framework} );
    }

    # check required packages
    if ( $Structure{PackageRequired} && !$Param{Force} ) {
        return if !$Self->_CheckPackageRequired(
            %Param,
            PackageRequired => $Structure{PackageRequired},
        );
    }

    # check required modules
    if ( $Structure{ModuleRequired} && !$Param{Force} ) {
        return if !$Self->_CheckModuleRequired(
            %Param,
            ModuleRequired => $Structure{ModuleRequired},
        );
    }

    # check merged packages
    if ( $Structure{PackageMerge} ) {

        # upgrade merged packages (no files)
        return if !$Self->_MergedPackages(
            %Param,
            Structure => \%Structure,
        );
    }

    # check files
    my $FileCheckOk = 1;
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            #print STDERR "Notice: Want to install $File->{Location}!\n";
        }
    }
    if ( !$FileCheckOk && !$Param{Force} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'File conflict, can\'t install package!',
        );
        return;
    }

    # check if one of this files is already intalled by an other package
    if ( %Structure && !$Param{Force} ) {
        return if !$Self->_PackageFileCheck(
            Structure => \%Structure,
        );
    }

    # install code (pre)
    if ( $Structure{CodeInstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeInstall},
            Type      => 'pre',
            Structure => \%Structure,
        );
    }

    # install database (pre)
    if ( $Structure{DatabaseInstall} && $Structure{DatabaseInstall}->{pre} ) {

        my $DatabaseInstall = $Self->_CheckDBMerged( Database => $Structure{DatabaseInstall}->{pre} );

        if ( IsArrayRefWithData($DatabaseInstall) ) {
            $Self->_Database( Database => $DatabaseInstall );
        }
    }

    # install files
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {
            $Self->_FileInstall( File => $File );
        }
    }

    # add package
    return if !$Self->RepositoryAdd(
        String    => $Param{String},
        FromCloud => $FromCloud
    );

    # update package status
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE package_repository SET install_status = \'installed\''
            . ' WHERE name = ? AND version = ?',
        Bind => [
            \$Structure{Name}->{Content},
            \$Structure{Version}->{Content},
        ],
    );

    # install config
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );
    $Self->{SysConfigObject}->WriteDefault();

    # install database (post)
    if ( $Structure{DatabaseInstall} && $Structure{DatabaseInstall}->{post} ) {

        my $DatabaseInstall = $Self->_CheckDBMerged( Database => $Structure{DatabaseInstall}->{post} );

        if ( IsArrayRefWithData($DatabaseInstall) ) {
            $Self->_Database( Database => $DatabaseInstall );
        }
    }

    # install code (post)
    if ( $Structure{CodeInstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeInstall},
            Type      => 'post',
            Structure => \%Structure,
        );
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['XMLParse'],
    );
    $Kernel::OM->Get('Kernel::System::Loader')->CacheDelete();

    # trigger event
    $Self->EventHandler(
        Event => 'PackageInstall',
        Data  => {
            Name    => $Structure{Name}->{Content},
            Vendor  => $Structure{Vendor}->{Content},
            Version => $Structure{Version}->{Content},
        },
        UserID => 1,
    );

    return 1;
}

=item PackageReinstall()

reinstall files of a package

    $PackageObject->PackageReinstall( String => $FileString );

=cut

sub PackageReinstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'String not defined!',
        );
        return;
    }

    # parse source file
    my %Structure = $Self->PackageParse(%Param);

    # check OS
    if ( $Structure{OS} && !$Param{Force} ) {
        return if !$Self->_OSCheck( OS => $Structure{OS} );
    }

    # check framework
    if ( $Structure{Framework} && !$Param{Force} ) {
        return if !$Self->_CheckFramework( Framework => $Structure{Framework} );
    }

    # reinstall code (pre)
    if ( $Structure{CodeReinstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeReinstall},
            Type      => 'pre',
            Structure => \%Structure,
        );
    }

    # install files
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            # install file
            $Self->_FileInstall(
                File      => $File,
                Reinstall => 1
            );
        }
    }

    # install config
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );
    $Self->{SysConfigObject}->WriteDefault();

    # reinstall code (post)
    if ( $Structure{CodeReinstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeReinstall},
            Type      => 'post',
            Structure => \%Structure,
        );
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['XMLParse'],
    );
    $Kernel::OM->Get('Kernel::System::Loader')->CacheDelete();

    # trigger event
    $Self->EventHandler(
        Event => 'PackageReinstall',
        Data  => {
            Name    => $Structure{Name}->{Content},
            Vendor  => $Structure{Vendor}->{Content},
            Version => $Structure{Version}->{Content},
        },
        UserID => 1,
    );

    return 1;
}

=item PackageUpgrade()

upgrade a package

    $PackageObject->PackageUpgrade( String => $FileString );

=cut

sub PackageUpgrade {
    my ( $Self, %Param ) = @_;

    my %InstalledStructure;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'String not defined!',
        );
        return;
    }

    # conflict check
    my %Structure = $Self->PackageParse(%Param);

    # check if package is already installed
    my $Installed        = 0;
    my $InstalledVersion = 0;
    for my $Package ( $Self->RepositoryList() ) {
        if ( $Structure{Name}->{Content} eq $Package->{Name}->{Content} ) {
            if ( $Package->{Status} =~ /^installed$/i ) {
                $Installed          = 1;
                $InstalledVersion   = $Package->{Version}->{Content};
                %InstalledStructure = %{$Package};
            }
        }
    }
    if ( !$Installed ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Package is not installed, can\'t upgrade!',
        );
        return;
    }

    # check OS
    if ( $Structure{OS} && !$Param{Force} ) {
        return if !$Self->_OSCheck( OS => $Structure{OS} );
    }

    # check framework
    if ( $Structure{Framework} && !$Param{Force} ) {
        return if !$Self->_CheckFramework( Framework => $Structure{Framework} );
    }

    # check required packages
    if ( $Structure{PackageRequired} && !$Param{Force} ) {

        return if !$Self->_CheckPackageRequired(
            %Param,
            PackageRequired => $Structure{PackageRequired},
        );
    }

    # check required modules
    if ( $Structure{ModuleRequired} && !$Param{Force} ) {

        return if !$Self->_CheckModuleRequired(
            %Param,
            ModuleRequired => $Structure{ModuleRequired},
        );
    }

    # check merged packages
    if ( $Structure{PackageMerge} ) {

        # upgrade merged packages (no files)
        return if !$Self->_MergedPackages(
            %Param,
            Structure => \%Structure,
        );
    }

    # check version
    my $CheckVersion = $Self->_CheckVersion(
        VersionNew       => $Structure{Version}->{Content},
        VersionInstalled => $InstalledVersion,
        Type             => 'Max',
    );

    if ( !$CheckVersion ) {

        if ( $Structure{Version}->{Content} eq $InstalledVersion ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Can't upgrade, package '$Structure{Name}->{Content}-$InstalledVersion' already installed!",
            );

            return if !$Param{Force};
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Can't upgrade, installed package '$InstalledVersion' is newer as '$Structure{Version}->{Content}'!",
            );

            return if !$Param{Force};
        }
    }

    # check if one of this files is already installed by an other package
    if ( %Structure && !$Param{Force} ) {
        return if !$Self->_PackageFileCheck(
            Structure => \%Structure,
        );
    }

    # remove old package
    return if !$Self->RepositoryRemove( Name => $Structure{Name}->{Content} );

    # add new package
    return if !$Self->RepositoryAdd( String => $Param{String} );

    # update package status
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE package_repository SET install_status = \'installed\''
            . ' WHERE name = ? AND version = ?',
        Bind => [
            \$Structure{Name}->{Content}, \$Structure{Version}->{Content},
        ],
    );

    # upgrade code (pre)
    if ( $Structure{CodeUpgrade} && ref $Structure{CodeUpgrade} eq 'ARRAY' ) {

        my @Parts;
        PART:
        for my $Part ( @{ $Structure{CodeUpgrade} } ) {

            if ( $Part->{Version} ) {

                # skip code upgrade block if its version is bigger than the new package version
                my $CheckVersion = $Self->_CheckVersion(
                    VersionNew       => $Part->{Version},
                    VersionInstalled => $Structure{Version}->{Content},
                    Type             => 'Max',
                );

                next PART if $CheckVersion;

                $CheckVersion = $Self->_CheckVersion(
                    VersionNew       => $Part->{Version},
                    VersionInstalled => $InstalledVersion,
                    Type             => 'Min',
                );

                if ( !$CheckVersion ) {
                    push @Parts, $Part;
                }
            }
            else {
                push @Parts, $Part;
            }
        }

        $Self->_Code(
            Code      => \@Parts,
            Type      => 'pre',
            Structure => \%Structure,
        );
    }

    # upgrade database (pre)
    if ( $Structure{DatabaseUpgrade}->{pre} && ref $Structure{DatabaseUpgrade}->{pre} eq 'ARRAY' ) {

        my @Parts;
        my $Use = 0;
        my $UseInstalled;
        my $NotUseTag;
        my $NotUseTagLevel;
        PARTDB:
        for my $Part ( @{ $Structure{DatabaseUpgrade}->{pre} } ) {

            if ( !$UseInstalled ) {

                if (
                    $Part->{TagType} eq 'End'
                    && $Part->{Tag} eq $NotUseTag
                    && $Part->{TagLevel} eq $NotUseTagLevel
                    )
                {
                    $UseInstalled = 1;
                }

                next PARTDB;

            }
            elsif (
                (
                    defined $Part->{IfPackage}
                    && !$Self->{MergedPackages}->{ $Part->{IfPackage} }
                )
                || (
                    defined $Part->{IfNotPackage}
                    &&
                    (
                        defined $Self->{MergedPackages}->{ $Part->{IfNotPackage} }
                        || $Self->PackageIsInstalled( Name => $Part->{IfNotPackage} )
                    )
                )
                )
            {
                # store Tag and TagLevel to be used later and found the end of this level
                $NotUseTag      = $Part->{Tag};
                $NotUseTagLevel = $Part->{TagLevel};

                $UseInstalled = 0;

                next PARTDB;
            }

            if ( $Part->{TagLevel} == 3 && $Part->{Version} ) {

                my $CheckVersion = $Self->_CheckVersion(
                    VersionNew       => $Part->{Version},
                    VersionInstalled => $InstalledVersion,
                    Type             => 'Min',
                );

                if ( !$CheckVersion ) {
                    $Use   = 1;
                    @Parts = ();
                    push @Parts, $Part;
                }
            }
            elsif ( $Use && $Part->{TagLevel} == 3 && $Part->{TagType} eq 'End' ) {
                $Use = 0;
                push @Parts, $Part;
                $Self->_Database( Database => \@Parts );
            }
            elsif ($Use) {
                push @Parts, $Part;
            }
        }
    }

    # uninstall old package files
    if ( $InstalledStructure{Filelist} && ref $InstalledStructure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $InstalledStructure{Filelist} } ) {

            # remove file
            $Self->_FileRemove( File => $File );
        }
    }

    # install files
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            # install file
            $Self->_FileInstall( File => $File );
        }
    }

    # install config
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );
    $Self->{SysConfigObject}->WriteDefault();

    # upgrade database (post)
    if ( $Structure{DatabaseUpgrade}->{post} && ref $Structure{DatabaseUpgrade}->{post} eq 'ARRAY' )
    {

        my @Parts;
        my $Use          = 0;
        my $UseInstalled = 1;
        my $NotUseTag;
        my $NotUseTagLevel;
        PARTDB:
        for my $Part ( @{ $Structure{DatabaseUpgrade}->{post} } ) {

            if ( !$UseInstalled ) {

                if (
                    $Part->{TagType} eq 'End'
                    && ( defined $NotUseTag      && $Part->{Tag} eq $NotUseTag )
                    && ( defined $NotUseTagLevel && $Part->{TagLevel} eq $NotUseTagLevel )
                    )
                {
                    $UseInstalled = 1;
                }

                next PARTDB;

            }
            elsif (
                (
                    defined $Part->{IfPackage}
                    && !$Self->{MergedPackages}->{ $Part->{IfPackage} }
                )
                || (
                    defined $Part->{IfNotPackage}
                    && (
                        defined $Self->{MergedPackages}->{ $Part->{IfNotPackage} }
                        || $Self->PackageIsInstalled( Name => $Part->{IfNotPackage} )
                    )
                )
                )
            {
                # store Tag and TagLevel to be used later and found the end of this level
                $NotUseTag      = $Part->{Tag};
                $NotUseTagLevel = $Part->{TagLevel};

                $UseInstalled = 0;

                next PARTDB;
            }

            if ( $Part->{TagLevel} == 3 && $Part->{Version} ) {

                my $CheckVersion = $Self->_CheckVersion(
                    VersionNew       => $Part->{Version},
                    VersionInstalled => $InstalledVersion,
                    Type             => 'Min',
                );

                if ( !$CheckVersion ) {
                    $Use   = 1;
                    @Parts = ();
                    push @Parts, $Part;
                }
            }
            elsif ( $Use && $Part->{TagLevel} == 3 && $Part->{TagType} eq 'End' ) {

                $Use = 0;
                push @Parts, $Part;
                $Self->_Database( Database => \@Parts );
            }
            elsif ($Use) {
                push @Parts, $Part;
            }
        }
    }

    # upgrade code (post)
    if ( $Structure{CodeUpgrade} && ref $Structure{CodeUpgrade} eq 'ARRAY' ) {

        my @Parts;
        PART:
        for my $Part ( @{ $Structure{CodeUpgrade} } ) {

            if ( $Part->{Version} ) {

                # skip code upgrade block if its version is bigger than the new package version
                my $CheckVersion = $Self->_CheckVersion(
                    VersionNew       => $Part->{Version},
                    VersionInstalled => $Structure{Version}->{Content},
                    Type             => 'Max',
                );

                next PART if $CheckVersion;

                $CheckVersion = $Self->_CheckVersion(
                    VersionNew       => $Part->{Version},
                    VersionInstalled => $InstalledVersion,
                    Type             => 'Min',
                );

                if ( !$CheckVersion ) {
                    push @Parts, $Part;
                }
            }
            else {
                push @Parts, $Part;
            }
        }

        $Self->_Code(
            Code      => \@Parts,
            Type      => 'post',
            Structure => \%Structure,
        );
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['XMLParse'],
    );
    $Kernel::OM->Get('Kernel::System::Loader')->CacheDelete();

    # trigger event
    $Self->EventHandler(
        Event => 'PackageUpgrade',
        Data  => {
            Name    => $Structure{Name}->{Content},
            Vendor  => $Structure{Vendor}->{Content},
            Version => $Structure{Version}->{Content},
        },
        UserID => 1,
    );

    return 1;
}

=item PackageUninstall()

uninstall a package

    $PackageObject->PackageUninstall( String => $FileString );

=cut

sub PackageUninstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'String not defined!'
        );
        return;
    }

    # parse source file
    my %Structure = $Self->PackageParse(%Param);

    # check depends
    if ( !$Param{Force} ) {
        return if !$Self->_CheckPackageDepends( Name => $Structure{Name}->{Content} );
    }

    # uninstall code (pre)
    if ( $Structure{CodeUninstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeUninstall},
            Type      => 'pre',
            Structure => \%Structure,
        );
    }

    # uninstall database (pre)
    if ( $Structure{DatabaseUninstall} && $Structure{DatabaseUninstall}->{pre} ) {
        $Self->_Database( Database => $Structure{DatabaseUninstall}->{pre} );
    }

    # files
    my $FileCheckOk = 1;
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            # remove file
            $Self->_FileRemove( File => $File );
        }
    }

    # remove old packages
    $Self->RepositoryRemove( Name => $Structure{Name}->{Content} );

    # install config
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );
    $Self->{SysConfigObject}->WriteDefault();

    # uninstall database (post)
    if ( $Structure{DatabaseUninstall} && $Structure{DatabaseUninstall}->{post} ) {
        $Self->_Database( Database => $Structure{DatabaseUninstall}->{post} );
    }

    # uninstall code (post)
    if ( $Structure{CodeUninstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeUninstall},
            Type      => 'post',
            Structure => \%Structure,
        );
    }

    # install config
    $Self->{ConfigObject} = Kernel::Config->new( %{$Self} );

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['XMLParse'],
    );
    $Kernel::OM->Get('Kernel::System::Loader')->CacheDelete();

    # trigger event
    $Self->EventHandler(
        Event => 'PackageUninstall',
        Data  => {
            Name    => $Structure{Name}->{Content},
            Vendor  => $Structure{Vendor}->{Content},
            Version => $Structure{Version}->{Content},
        },
        UserID => 1,
    );

    return 1;
}

=item PackageOnlineRepositories()

returns a list of available online repositories

    my %List = $PackageObject->PackageOnlineRepositories();

=cut

sub PackageOnlineRepositories {
    my ( $Self, %Param ) = @_;

    # check if online repository should be fetched
    return () if !$Self->{ConfigObject}->Get('Package::RepositoryRoot');

    # get repository list
    my $XML = '';
    URL:
    for my $URL ( @{ $Self->{ConfigObject}->Get('Package::RepositoryRoot') } ) {

        $XML = $Self->_Download( URL => $URL );

        last URL if $XML;
    }

    return if !$XML;

    my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );

    my %List;
    my $Name = '';

    TAG:
    for my $Tag (@XMLARRAY) {

        # just use start tags
        next TAG if $Tag->{TagType} ne 'Start';

        # reset package data
        if ( $Tag->{Tag} eq 'Repository' ) {
            $Name = '';
        }
        elsif ( $Tag->{Tag} eq 'Name' ) {
            $Name = $Tag->{Content};
        }
        elsif ( $Tag->{Tag} eq 'URL' ) {
            if ($Name) {
                $List{ $Tag->{Content} } = $Name;
            }
        }
    }

    return %List;
}

=item PackageOnlineList()

returns a list of available on-line packages

    my @List = $PackageObject->PackageOnlineList(
        URL  => '',
        Lang => 'en',
        Cache => 0,   # (optional) do not use cached data
        FromCloud => 1, # optional 1 or 0, it indicates if a Cloud Service
                        # should be used for getting the packages list
    );

=cut

sub PackageOnlineList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(URL Lang)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }
    if ( !defined $Param{Cache} ) {

        if ( $Param{URL} =~ m{ \.otrs\.org\/ }xms ) {
            $Param{Cache} = 1;
        }
        else {
            $Param{Cache} = 0;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = $Param{URL} . '-' . $Param{Lang};
    if ( $Param{Cache} ) {
        my $Cache = $CacheObject->Get(
            Type => 'PackageOnlineList',
            Key  => $CacheKey,
        );
        return @{$Cache} if $Cache;
    }

    my @Packages;
    my %Package;
    my $Filelist;
    if ( !$Param{FromCloud} ) {

        my $XML = $Self->_Download( URL => $Param{URL} . '/otrs.xml' );
        return if !$XML;

        my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );

        if ( !@XMLARRAY ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Unable to parse repository index document.',
            );
            return;
        }

        TAG:
        for my $Tag (@XMLARRAY) {

            # remember package
            if ( $Tag->{TagType} eq 'End' && $Tag->{Tag} eq 'Package' ) {
                if (%Package) {
                    push @Packages, {%Package};
                }
                next TAG;
            }

            # just use start tags
            next TAG if $Tag->{TagType} ne 'Start';

            # reset package data
            if ( $Tag->{Tag} eq 'Package' ) {
                %Package  = ();
                $Filelist = 0;
            }
            elsif ( $Tag->{Tag} eq 'Framework' ) {
                push @{ $Package{Framework} }, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'Filelist' ) {
                $Filelist = 1;
            }
            elsif ( $Filelist && $Tag->{Tag} eq 'FileDoc' ) {
                push @{ $Package{Filelist} }, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'Description' ) {
                if ( !$Package{Description} ) {
                    $Package{Description} = $Tag->{Content};
                }
                if ( $Tag->{Lang} eq $Param{Lang} ) {
                    $Package{Description} = $Tag->{Content};
                }
            }
            else {
                $Package{ $Tag->{Tag} } = $Tag->{Content};
            }
        }

    }
    else {

        # On this case a cloud service is used, a URL is not
        # needed, instead a operation name, present on the URL
        # parameter in order to match with the previous structure
        my $Operation = $Param{URL};

        # get list from cloud
        my $ListResult = $Self->CloudFileGet(
            Operation => $Operation,
        );

        # check result structure
        return if !IsHashRefWithData($ListResult);

        my $CurrentFramework = $Kernel::OM->Get('Kernel::Config')->Get('Version');
        FRAMEWORKVERSION:
        for my $FrameworkVersion ( sort keys %{$ListResult} ) {

            if ( $CurrentFramework =~ m{ \A $FrameworkVersion }xms ) {

                @Packages = @{ $ListResult->{$FrameworkVersion} };
                last FRAMEWORKVERSION;
            }
        }
    }

    # if not packages found, just return
    return if !@Packages;

    # just framework packages
    my @NewPackages;
    my $PackageForRequestedFramework = 0;
    for my $Package (@Packages) {

        my $FWCheckOk = 0;

        if ( $Package->{Framework} ) {

            if (
                $Self->_CheckFramework(
                    Framework => $Package->{Framework},
                    NoLog     => 1
                )
                )
            {
                $FWCheckOk                    = 1;
                $PackageForRequestedFramework = 1;
            }
        }

        if ($FWCheckOk) {
            push @NewPackages, $Package;
        }
    }

    # return if there are packages, just not for this framework version
    if ( @Packages && !$PackageForRequestedFramework ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                'No packages for your framework version found in this repository, it only contains packages for other framework versions.',
        );
    }
    @Packages = @NewPackages;

    # just the newest packages
    my %Newest;
    for my $Package (@Packages) {

        if ( !$Newest{ $Package->{Name} } ) {
            $Newest{ $Package->{Name} } = $Package;
        }
        else {

            my $CheckVersion = $Self->_CheckVersion(
                VersionNew       => $Package->{Version},
                VersionInstalled => $Newest{ $Package->{Name} }->{Version},
                Type             => 'Min',
            );

            if ( !$CheckVersion ) {
                $Newest{ $Package->{Name} } = $Package;
            }
        }
    }

    # get possible actions
    @NewPackages = ();
    my @LocalList = $Self->RepositoryList();

    for my $Data ( sort keys %Newest ) {

        my $InstalledSameVersion = 0;

        PACKAGE:
        for my $Package (@LocalList) {

            next PACKAGE if $Newest{$Data}->{Name} ne $Package->{Name}->{Content};

            $Newest{$Data}->{Local} = 1;

            next PACKAGE if $Package->{Status} ne 'installed';

            $Newest{$Data}->{Installed} = 1;

            if (
                !$Self->_CheckVersion(
                    VersionNew       => $Newest{$Data}->{Version},
                    VersionInstalled => $Package->{Version}->{Content},
                    Type             => 'Min',
                )
                )
            {
                $Newest{$Data}->{Upgrade} = 1;
            }

            # check if version or lower is already installed
            elsif (
                !$Self->_CheckVersion(
                    VersionNew       => $Newest{$Data}->{Version},
                    VersionInstalled => $Package->{Version}->{Content},
                    Type             => 'Max',
                )
                )
            {
                $InstalledSameVersion = 1;
            }
        }

        # add package if not already installed
        if ( !$InstalledSameVersion ) {
            push @NewPackages, $Newest{$Data};
        }
    }

    @Packages = @NewPackages;

    # set cache
    if ( $Param{Cache} ) {
        $CacheObject->Set(
            Type  => 'PackageOnlineList',
            Key   => $CacheKey,
            Value => \@Packages,
            TTL   => 60 * 60,
        );
    }

    return @Packages;
}

=item PackageOnlineGet()

download of an online package and put it into the local repository

    $PackageObject->PackageOnlineGet(
        Source => 'http://host.example.com/',
        File   => 'SomePackage-1.0.opm',
    );

=cut

sub PackageOnlineGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(File Source)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    #check if file might be retrieved from cloud
    my $RepositoryCloudList = $Self->RepositoryCloudList();
    if ( IsHashRefWithData($RepositoryCloudList) && $RepositoryCloudList->{ $Param{Source} } ) {

        my $PackageFromCloud;

        # On this case a cloud service is used, Source contains an
        # operation name in order to match with the previous structure
        my $Operation = $Param{Source} . 'FileGet';

        # download package from cloud
        my $PackageResult = $Self->CloudFileGet(
            Operation => $Operation,
            Data      => {
                File => $Param{File},
            },
        );

        if (
            IsHashRefWithData($PackageResult)
            && $PackageResult->{Package}
            )
        {
            $PackageFromCloud = $PackageResult->{Package};
        }
        elsif ( IsStringWithData($PackageResult) ) {
            return 'ErrorMessage:' . $PackageResult;

        }

        return $PackageFromCloud;
    }

    return $Self->_Download( URL => $Param{Source} . '/' . $Param{File} );
}

=item DeployCheck()

check if package (files) is deployed, returns true if it's ok

    $PackageObject->DeployCheck(
        Name    => 'Application A',
        Version => '1.0',
    );

=cut

sub DeployCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Name Version)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    my $Package = $Self->RepositoryGet( %Param, Result => 'SCALAR' );
    my %Structure = $Self->PackageParse( String => $Package );

    $Self->{DeployCheckInfo} = undef;

    return 1 if !$Structure{Filelist};
    return 1 if ref $Structure{Filelist} ne 'ARRAY';

    my $Hit = 0;
    for my $File ( @{ $Structure{Filelist} } ) {

        my $LocalFile = $Self->{Home} . '/' . $File->{Location};

        if ( !-e $LocalFile ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{Name}-$Param{Version}: No such file: $LocalFile!",
            );

            $Self->{DeployCheckInfo}->{File}->{ $File->{Location} } = 'No file installed!';
            $Hit = 1;
        }
        elsif ( -e $LocalFile ) {

            my $Content = $Self->{MainObject}->FileRead(
                Location => $Self->{Home} . '/' . $File->{Location},
                Mode     => 'binmode',
            );

            if ($Content) {

                if ( ${$Content} ne $File->{Content} ) {

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "$Param{Name}-$Param{Version}: $LocalFile is different!",
                    );

                    $Hit = 1;
                    $Self->{DeployCheckInfo}->{File}->{ $File->{Location} } = 'File is different!';
                }
            }
            else {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't read $LocalFile!",
                );

                $Self->{DeployCheckInfo}->{File}->{ $File->{Location} } = 'Can\' read File!';
            }
        }
    }

    return if $Hit;
    return 1;
}

=item DeployCheckInfo()

returns the info of the latest DeployCheck(), what's not deployed correctly

    my %Hash = $PackageObject->DeployCheckInfo();

=cut

sub DeployCheckInfo {
    my ( $Self, %Param ) = @_;

    return %{ $Self->{DeployCheckInfo} }
        if $Self->{DeployCheckInfo};

    return ();
}

=item PackageVerify()

check if package is verified by the vendor

    $PackageObject->PackageVerify(
        Package   => $Package,
        Structure => \%Structure,
    );

or

    $PackageObject->PackageVerify(
        Package => $Package,
        Name    => 'FAQ',
    );

=cut

sub PackageVerify {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Package} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Package!",
        );

        return;
    }
    if ( !$Param{Structure} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Structure or Name!',
        );

        return;
    }

    # define package verification info
    my $PackageVerifyInfo = {
        Description =>
            "<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>",
        Title =>
            'Package not verified by the OTRS Group! It is recommended not to use this package.',
    };

    # investigate name
    my $Name = $Param{Structure}->{Name}->{Content} || $Param{Name};

    # correct any 'dos-style' line endings - http://bugs.otrs.org/show_bug.cgi?id=9838
    $Param{Package} =~ s{\r\n}{\n}xmsg;

    # create MD5 sum
    my $Sum = $Self->{MainObject}->MD5sum( String => $Param{Package} );

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # lookup cache
    my $CachedValue = $CacheObject->Get(
        Type => 'PackageVerification',
        Key  => $Sum,
    );
    if ($CachedValue) {
        $Self->{PackageVerifyInfo} = $PackageVerifyInfo;

        return $CachedValue;
    }

    my $CloudService = 'PackageManagement';
    my $Operation    = 'PackageVerify';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        Package => [
                            {
                                Name   => $Name,
                                MD5sum => $Sum,
                            }
                        ],
                    },
                },
            ],
        },
    );

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful, in such case set the package as verified
    return 'unknown' if !IsHashRefWithData($RequestResult);

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    # if there was no result for this specific operation or the operation was not success, then
    # set the package as verified
    return 'unknown' if !IsHashRefWithData($OperationResult);
    return 'unknown' if !$OperationResult->{Success};

    my $VerificationData = $OperationResult->{Data};

    # extract response
    my $PackageVerify = $VerificationData->{$Name};

    return 'unknown' if !$PackageVerify;
    return 'unknown' if $PackageVerify ne 'not_verified' && $PackageVerify ne 'verified';

    # set package verification info
    if ( $PackageVerify eq 'not_verified' ) {
        $Self->{PackageVerifyInfo} = $PackageVerifyInfo;
    }

    # set cache
    $CacheObject->Set(
        Type  => 'PackageVerification',
        Key   => $Sum,
        Value => $PackageVerify,
        TTL   => 30 * 24 * 60 * 60,       # 30 days
    );

    return $PackageVerify;
}

=item PackageVerifyInfo()

returns the info of the latest PackageVerify()

    my %Hash = $PackageObject->PackageVerifyInfo();

=cut

sub PackageVerifyInfo {
    my ( $Self, %Param ) = @_;

    return () if !$Self->{PackageVerifyInfo};
    return () if ref $Self->{PackageVerifyInfo} ne 'HASH';
    return () if !%{ $Self->{PackageVerifyInfo} };

    return %{ $Self->{PackageVerifyInfo} };
}

=item PackageVerifyAll()

check if all installed packages are installed by the vendor
returns a hash with package names and verification status.

    my %VerificationInfo = $PackageObject->PackageVerifyAll();

returns:

    %VerificationInfo = (
        FAQ     => 'verified',
        Support => 'verified',
        MyHack  => 'not_verified',
    );

=cut

sub PackageVerifyAll {
    my ( $Self, %Param ) = @_;

    # get installed package list
    my @PackageList = $Self->RepositoryList(
        Result => 'Short',
    );

    return () if !@PackageList;

    # create a mapping of Package Name => md5 pairs
    my %PackageList = map { $_->{Name} => $_->{MD5sum} } @PackageList;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my %Result;
    my @PackagesToVerify;

    # first check the cache for each package
    for my $Package (@PackageList) {

        my $Verification = $CacheObject->Get(
            Type => 'PackageVerification',
            Key  => $Package->{MD5sum},
        );

        # add to result if we have it already
        if ($Verification) {
            $Result{ $Package->{Name} } = $Verification;
        }
        else {
            $Result{ $Package->{Name} } = 'unknown';
            push @PackagesToVerify, {
                Name   => $Package->{Name},
                MD5sum => $Package->{MD5sum},
            };
        }
    }

    return %Result if !@PackagesToVerify;

    my $CloudService = 'PackageManagement';
    my $Operation    = 'PackageVerify';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        Package => \@PackagesToVerify,
                    },
                },
            ],
        },
    );

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful, then return all packages as verified (or cache)
    return %Result if !IsHashRefWithData($RequestResult);

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    # if no operation result found or it was not successful the return all packages as verified
    # (or cache)
    return %Result if !IsHashRefWithData($OperationResult);
    return %Result if !$OperationResult->{Success};

    my $VerificationData = $OperationResult->{Data};

    PACKAGE:
    for my $Package ( sort keys %Result ) {

        next PACKAGE if !$Package;
        next PACKAGE if !$VerificationData->{$Package};

        # extract response
        my $PackageVerify = $VerificationData->{$Package};

        next PACKAGE if !$PackageVerify;
        next PACKAGE if $PackageVerify ne 'not_verified' && $PackageVerify ne 'verified';

        # process result
        $Result{$Package} = $PackageVerify;

        # set cache
        $CacheObject->Set(
            Type  => 'PackageVerification',
            Key   => $PackageList{$Package},
            Value => $PackageVerify,
            TTL   => 30 * 24 * 60 * 60,        # 30 days
        );
    }

    return %Result;
}

=item PackageBuild()

build an opm package

    my $Package = $PackageObject->PackageBuild(
        Name => {
            Content => 'SomePackageName',
        },
        Version => {
            Content => '1.0',
        },
        Vendor => {
            Content => 'OTRS AG',
        },
        URL => {
            Content => 'L<http://otrs.org/>',
        },
        License => {
            Content => 'GNU GENERAL PUBLIC LICENSE Version 2, June 1991',
        }
        Description => [
            {
                Lang    => 'en',
                Content => 'english description',
            },
            {
                Lang    => 'de',
                Content => 'german description',
            },
        ],
        Filelist = [
            {
                Location   => 'Kernel/System/Lala.pm'
                Permission => '644',
                Content    => $FileInString,
            },
            {
                Location   => 'Kernel/System/Lulu.pm'
                Permission => '644',
                Content    => $FileInString,
            },
        ],
    );

=cut

sub PackageBuild {
    my ( $Self, %Param ) = @_;

    my $XML = '';
    my $Home = $Param{Home} || $Self->{ConfigObject}->Get('Home');

    # check needed stuff
    for my $Needed (qw(Name Version Vendor License Description)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    # find framework, may we need do some things different to be compat. to 2.2
    my $Framework;
    if ( $Param{Framework} ) {

        FW:
        for my $FW ( @{ $Param{Framework} } ) {

            next FW if $FW->{Content} !~ /2\.2\./;

            $Framework = '2.2';

            last FW;
        }
    }

    # build xml
    if ( !$Param{Type} ) {
        $XML .= '<?xml version="1.0" encoding="utf-8" ?>';
        $XML .= "\n";
        $XML .= '<otrs_package version="1.1">';
        $XML .= "\n";
    }

    TAG:
    for my $Tag (
        qw(Name Version Vendor URL License ChangeLog Description Framework OS
        IntroInstall IntroUninstall IntroReinstall IntroUpgrade
        PackageIsVisible PackageIsDownloadable PackageIsRemovable PackageMerge
        PackageRequired ModuleRequired CodeInstall CodeUpgrade CodeUninstall CodeReinstall)
        )
    {

        # don't use CodeInstall CodeUpgrade CodeUninstall CodeReinstall in index mode
        if ( $Param{Type} && $Tag =~ /(Code|Intro)(Install|Upgrade|Uninstall|Reinstall)/ ) {
            next TAG;
        }

        if ( ref $Param{$Tag} eq 'HASH' ) {

            my %OldParam;
            for my $Item (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                $OldParam{$Item} = $Param{$Tag}->{$Item} || '';
                delete $Param{$Tag}->{$Item};
            }

            $XML .= "    <$Tag";

            for my $Item ( sort keys %{ $Param{$Tag} } ) {
                $XML .= " $Item=\"" . $Self->_Encode( $Param{$Tag}->{$Item} ) . "\"";
            }

            $XML .= ">";
            $XML .= $Self->_Encode( $OldParam{Content} ) . "</$Tag>\n";
        }
        elsif ( ref $Param{$Tag} eq 'ARRAY' ) {

            for my $Item ( @{ $Param{$Tag} } ) {

                my $TagSub = $Tag;
                my %Hash   = %{$Item};
                my %OldParam;

                for my $HashParam (
                    qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)
                    )
                {
                    $OldParam{$HashParam} = $Hash{$HashParam} || '';
                    delete $Hash{$HashParam};
                }

                # compat. to 2.2
                if ( $Framework && $Tag =~ /^Intro/ ) {
                    if ( $Hash{Type} eq 'pre' ) {
                        $Hash{Type} = 'Pre';
                    }
                    else {
                        $Hash{Type} = 'Post';
                    }
                    $TagSub = $Tag . $Hash{Type};
                    delete $Hash{Type};
                }

                $XML .= "    <$TagSub";

                for my $Item ( sort keys %Hash ) {
                    $XML .= " $Item=\"" . $Self->_Encode( $Hash{$Item} ) . "\"";
                }

                $XML .= ">";
                $XML .= $Self->_Encode( $OldParam{Content} ) . "</$TagSub>\n";
            }
        }
    }

    # don't use Build* in index mode
    if ( !$Param{Type} ) {

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        my $Time = $TimeObject->SystemTime2TimeStamp(
            SystemTime => $TimeObject->SystemTime(),
        );

        $XML .= "    <BuildDate>" . $Time . "</BuildDate>\n";
        $XML .= "    <BuildHost>" . $Self->{ConfigObject}->Get('FQDN') . "</BuildHost>\n";
    }
    if ( $Param{Filelist} ) {

        $XML .= "    <Filelist>\n";

        FILE:
        for my $File ( @{ $Param{Filelist} } ) {

            my %OldParam;

            for my $Item (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                $OldParam{$Item} = $File->{$Item} || '';
                delete $File->{$Item};
            }

            # do only use doc/* Filelist in index mode
            next FILE if $Param{Type} && $File->{Location} !~ /^doc\//;

            if ( !$Param{Type} ) {
                $XML .= "        <File";
            }
            else {
                $XML .= "        <FileDoc";
            }
            for my $Item ( sort keys %{$File} ) {
                if ( $Item ne 'Tag' && $Item ne 'Content' && $Item ne 'TagType' && $Item ne 'Size' )
                {
                    $XML
                        .= " "
                        . $Self->_Encode($Item) . "=\""
                        . $Self->_Encode( $File->{$Item} ) . "\"";
                }
            }

            # don't use content in in index mode
            if ( !$Param{Type} ) {
                $XML .= " Encode=\"Base64\">";
                my $FileContent = $Self->{MainObject}->FileRead(
                    Location => $Home . '/' . $File->{Location},
                    Mode     => 'binmode',
                );

                return if !defined $FileContent;

                $XML .= encode_base64( ${$FileContent}, '' );
                $XML .= "</File>\n";
            }
            else {
                $XML .= " >";
                $XML .= "</FileDoc>\n";
            }
        }
        $XML .= "    </Filelist>\n";
    }

    # don't use Database* in index mode
    return $XML if $Param{Type};

    TAG:
    for my $Item (qw(DatabaseInstall DatabaseUpgrade DatabaseReinstall DatabaseUninstall)) {

        if ( ref $Param{$Item} ne 'HASH' ) {
            next TAG;
        }

        for my $Type ( sort %{ $Param{$Item} } ) {

            if ( $Param{$Item}->{$Type} ) {

                my $Counter = 1;
                for my $Tag ( @{ $Param{$Item}->{$Type} } ) {

                    if ( $Tag->{TagType} eq 'Start' ) {

                        my $Space = '';
                        for ( 1 .. $Counter ) {
                            $Space .= '    ';
                        }

                        $Counter++;
                        $XML .= $Space . "<$Tag->{Tag}";

                        if ( $Tag->{TagLevel} == 3 ) {
                            $XML .= " Type=\"$Type\"";
                        }

                        for my $Key ( sort keys %{$Tag} ) {

                            if (
                                $Key ne 'Tag'
                                && $Key ne 'Content'
                                && $Key ne 'TagType'
                                && $Key ne 'TagLevel'
                                && $Key ne 'TagCount'
                                && $Key ne 'TagKey'
                                && $Key ne 'TagLastLevel'
                                )
                            {
                                if ( defined( $Tag->{$Key} ) ) {
                                    $XML .= ' '
                                        . $Self->_Encode($Key) . '="'
                                        . $Self->_Encode( $Tag->{$Key} ) . '"';
                                }
                            }
                        }

                        $XML .= ">";

                        if ( $Tag->{TagLevel} <= 3 || $Tag->{Tag} =~ /(Foreign|Reference|Index)/ ) {
                            $XML .= "\n";
                        }
                    }
                    if (
                        defined( $Tag->{Content} )
                        && $Tag->{TagLevel} >= 4
                        && $Tag->{Tag} !~ /(Foreign|Reference|Index)/
                        )
                    {
                        $XML .= $Self->_Encode( $Tag->{Content} );
                    }
                    if ( $Tag->{TagType} eq 'End' ) {

                        $Counter = $Counter - 1;
                        if ( $Tag->{TagLevel} > 3 && $Tag->{Tag} !~ /(Foreign|Reference|Index)/ ) {
                            $XML .= "</$Tag->{Tag}>\n";
                        }
                        else {

                            my $Space = '';

                            for ( 1 .. $Counter ) {
                                $Space .= '    ';
                            }

                            $XML .= $Space . "</$Tag->{Tag}>\n";
                        }
                    }
                }
            }
        }
    }

    $XML .= '</otrs_package>';

    return $XML;
}

=item PackageParse()

parse a package

    my %Structure = $PackageObject->PackageParse( String => $FileString );

=cut

sub PackageParse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'String not defined!',
        );
        return;
    }

    # create checksum
    my $CookedString = ref $Param{String} ? ${ $Param{String} } : $Param{String};

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$CookedString );

    # create checksum
    my $Checksum = $Self->{MainObject}->MD5sum(
        String => \$CookedString,
    );

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    if ($Checksum) {
        my $Cache = $CacheObject->Get(
            Type => 'PackageParse',
            Key  => $Checksum,

            # Don't store complex structure in memory as it will be modified later.
            CacheInMemory => 0,
        );
        return %{$Cache} if $Cache;
    }

    # get xml object
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLARRAY = eval {
        $XMLObject->XMLParse(%Param);
    };

    if ( !IsArrayRefWithData( \@XMLARRAY ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid XMLParse in PackageParse()!",
        );
        return;
    }

    my %Package;

    # parse package
    my %PackageMap = %{ $Self->{PackageMap} };

    TAG:
    for my $Tag (@XMLARRAY) {

        next TAG if $Tag->{TagType} ne 'Start';

        if ( $PackageMap{ $Tag->{Tag} } && $PackageMap{ $Tag->{Tag} } eq 'SCALAR' ) {
            $Package{ $Tag->{Tag} } = $Tag;
        }
        elsif ( $PackageMap{ $Tag->{Tag} } && $PackageMap{ $Tag->{Tag} } eq 'ARRAY' ) {

            # For compat. to 2.2 - convert Intro(Install|Upgrade|Unintall)(Pre|Post) to
            # e. g. <IntroInstall Type="post">.
            if ( $Tag->{Tag} =~ /^(Intro(Install|Upgrade|Uninstall))(Pre|Post)/ ) {
                $Tag->{Tag}  = $1;
                $Tag->{Type} = lc $3;
            }

            # Set default type of Code* and Intro* to post.
            elsif ( $Tag->{Tag} =~ /^(Code|Intro)/ && !$Tag->{Type} ) {
                $Tag->{Type} = 'post';
            }

            push @{ $Package{ $Tag->{Tag} } }, $Tag;
        }
    }

    # define names and locations that are not allowed for files in a package
    my $FilesNotAllowed = [
        'Kernel/Config.pm$',
        'Kernel/Config/Files/ZZZAuto.pm$',
        'Kernel/Config/Files/ZZZAAuto.pm$',
        'Kernel/Config/Files/ZZZProcessManagement.pm$',
        'var/tmp/Cache',
        'var/log/',
        '\.\./',
        '^/',
    ];

    my $Open = 0;
    TAG:
    for my $Tag (@XMLARRAY) {

        if ( $Open && $Tag->{Tag} eq 'Filelist' ) {
            $Open = 0;
        }
        elsif ( !$Open && $Tag->{Tag} eq 'Filelist' ) {
            $Open = 1;
            next TAG;
        }

        if ( $Open && $Tag->{TagType} eq 'Start' ) {

            # check for allowed file names and locations
            FILECHECK:
            for my $FileNotAllowed ( @{$FilesNotAllowed} ) {

                next FILECHECK if $Tag->{Location} !~ m{ $FileNotAllowed }xms;

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Invalid file/location '$Tag->{Location}' in PackageParse()!",
                );

                next TAG;
            }

            # get attachment size
            {
                if ( $Tag->{Content} ) {

                    my $ContentPlain = 0;

                    if ( $Tag->{Encode} && $Tag->{Encode} eq 'Base64' ) {
                        $Tag->{Encode}  = '';
                        $Tag->{Content} = decode_base64( $Tag->{Content} );
                    }

                    $Tag->{Size} = bytes::length( $Tag->{Content} );
                }
            }

            push @{ $Package{Filelist} }, $Tag;
        }
    }

    for my $Key (qw(DatabaseInstall DatabaseUpgrade DatabaseReinstall DatabaseUninstall)) {

        my $Type = 'post';

        TAG:
        for my $Tag (@XMLARRAY) {

            if ( $Open && $Tag->{Tag} eq $Key ) {
                $Open = 0;
                push( @{ $Package{$Key}->{$Type} }, $Tag );
            }
            elsif ( !$Open && $Tag->{Tag} eq $Key ) {

                $Open = 1;

                if ( $Tag->{Type} ) {
                    $Type = $Tag->{Type};
                }
            }

            next TAG if !$Open;

            push @{ $Package{$Key}->{$Type} }, $Tag;
        }
    }

    # check if a structure is present
    if ( !%Package ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid package structure in PackageParse()!",
        );
        return;
    }

    # set cache
    if ($Checksum) {
        $CacheObject->Set(
            Type  => 'PackageParse',
            Key   => $Checksum,
            Value => \%Package,
            TTL   => 30 * 24 * 60 * 60,

            # Don't store complex structure in memory as it will be modified later.
            CacheInMemory => 0,
        );
    }

    return %Package;
}

=item PackageExport()

export files of an package

    $PackageObject->PackageExport(
        String => $FileString,
        Home   => '/path/to/export'
    );

=cut

sub PackageExport {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(String Home)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    # parse source file
    my %Structure = $Self->PackageParse(%Param);

    return 1 if !$Structure{Filelist};
    return 1 if ref $Structure{Filelist} ne 'ARRAY';

    # install files
    for my $File ( @{ $Structure{Filelist} } ) {

        $Self->_FileInstall(
            File => $File,
            Home => $Param{Home},
        );
    }

    return 1;
}

=item PackageIsInstalled()

returns true if the package is already installed

    $PackageObject->PackageIsInstalled(
        String => $PackageString,    # Attribute String or Name is required
        Name   => $NameOfThePackage,
    );

=cut

sub PackageIsInstalled {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{String} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need String (PackageString) or Name (Name of the package)!',
        );
        return;
    }

    if ( $Param{String} ) {
        my %Structure = $Self->PackageParse(%Param);
        $Param{Name} = $Structure{Name}->{Content};
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => "SELECT name FROM package_repository "
            . "WHERE name = ? AND install_status = 'installed'",
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    my $Flag = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Flag = 1;
    }

    return $Flag;
}

=item PackageInstallDefaultFiles()

returns true if the distribution package (located under ) can get installed

    $PackageObject->PackageInstallDefaultFiles();

=cut

sub PackageInstallDefaultFiles {
    my ( $Self, %Param ) = @_;

    my $Directory    = $Self->{ConfigObject}->Get('Home') . '/var/packages';
    my @PackageFiles = $Self->{MainObject}->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.opm',
    );

    # read packages and install
    LOCATION:
    for my $Location (@PackageFiles) {

        # read package
        my $ContentSCALARRef = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        next LOCATION if !$ContentSCALARRef;

        # install package (use eval to be safe)
        eval {
            $Self->PackageInstall( String => ${$ContentSCALARRef} );
        };

        next LOCATION if !$@;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $@,
        );
    }

    return 1;
}

=item PackageFileGetMD5Sum()

generates a MD5 Sum for all files in a given package

    my $MD5Sum = $PackageObject->PackageFileGetMD5Sum(
        Name => 'Package Name',
        Version => 123.0,
    );

returns:
    $MD5SumLookup = {
        'Direcoty/File1' => 'f3f30bd59afadf542770d43edb280489'
        'Direcoty/File2' => 'ccb8a0b86adf125a36392e388eb96778'
    };

=cut

sub PackageFileGetMD5Sum {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name Version)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = $Param{Name} . $Param{Version};
    my $Cache    = $CacheObject->Get(
        Type => 'PackageFileGetMD5Sum',
        Key  => $CacheKey,
    );
    return $Cache if IsHashRefWithData($Cache);

    # get the package contents
    my $Package = $Self->RepositoryGet(
        %Param,
        Result => 'SCALAR',
    );
    my %Structure = $Self->PackageParse( String => $Package );

    return 1 if !$Structure{Filelist};
    return 1 if ref $Structure{Filelist} ne 'ARRAY';

    # cleanup the Home variable (remove tailing "/")
    my $Home = $Self->{Home};
    $Home =~ s{\/\z}{};

    my %MD5SumLookup;
    for my $File ( @{ $Structure{Filelist} } ) {

        my $LocalFile = $Home . '/' . $File->{Location};

        # generate the MD5Sum
        my $MD5Sum = $Self->{MainObject}->MD5sum(
            String => \$File->{Content},
        );

        $MD5SumLookup{$LocalFile} = $MD5Sum;
    }

    # set cache
    $CacheObject->Set(
        Type  => 'PackageFileGetMD5Sum',
        Key   => $CacheKey,
        Value => \%MD5SumLookup,
        TTL   => 6 * 30 * 24 * 60 * 60,    # 6 Months (Aprox)
    );

    return \%MD5SumLookup;
}

=begin Internal:

=cut

sub _Download {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{URL} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'URL not defined!',
        );
        return;
    }

    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        Timeout => $Self->{ConfigObject}->Get('Package::Timeout'),
        Proxy   => $Self->{ConfigObject}->Get('Package::Proxy'),
    );

    my %Response = $WebUserAgentObject->Request(
        URL => $Param{URL},
    );

    return if !$Response{Content};
    return ${ $Response{Content} };
}

sub _Database {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Database} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Database not defined!',
        );
        return;
    }

    if ( ref $Param{Database} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need array ref in Database param!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @SQL = $DBObject->SQLProcessor(
        Database => $Param{Database},
    );

    for my $SQL (@SQL) {
        print STDERR "Notice: $SQL\n";
        $DBObject->Do( SQL => $SQL );
    }

    my @SQLPost = $DBObject->SQLProcessorPost();

    for my $SQL (@SQLPost) {
        print STDERR "Notice: $SQL\n";
        $DBObject->Do( SQL => $SQL );
    }

    return 1;
}

sub _Code {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Code Type Structure)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    # check format
    if ( ref $Param{Code} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need array ref in Code param!',
        );
        return;
    }

    # execute code
    CODE:
    for my $Code ( @{ $Param{Code} } ) {

        next CODE if !$Code->{Content};
        next CODE if $Param{Type} !~ /^$Code->{Type}$/i;

        # if the merged packages was already installed or not
        if (
            (
                defined $Code->{IfPackage}
                && !$Self->{MergedPackages}->{ $Code->{IfPackage} }
            )
            || (
                defined $Code->{IfNotPackage}
                && (
                    $Self->{MergedPackages}->{ $Code->{IfNotPackage} }
                    || $Self->PackageIsInstalled( Name => $Code->{IfNotPackage} )
                )
            )
            )
        {
            next CODE;
        }

        print STDERR "Code: $Code->{Content}\n";

        if ( !eval $Code->{Content} . "\n1;" ) {    ## no critic
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Code: $@",
            );
            return;
        }
    }

    return 1;
}

sub _OSCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{OS} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'OS not defined!',
        );
        return;
    }

    # check format
    if ( ref $Param{OS} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need array ref in OS param!',
        );
        return;
    }

    # check OS
    my $OSCheck   = 0;
    my $CurrentOS = $^O;
    my @TestedOS;

    OS:
    for my $OS ( @{ $Param{OS} } ) {
        next OS if !$OS->{Content};
        push @TestedOS, $OS->{Content};
        next OS if $CurrentOS !~ /^$OS->{Content}$/i;

        $OSCheck = 1;
        last OS;
    }

    return 1 if $OSCheck;
    return   if $Param{NoLog};

    my $PossibleOS = join ', ', @TestedOS;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Sorry, can't install/upgrade package, because OS of package "
            . "($PossibleOS) does not match your OS ($CurrentOS)!",
    );

    return;
}

sub _CheckFramework {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Framework} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Framework not defined!',
        );
        return;
    }

    # check format
    if ( ref $Param{Framework} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need array ref in Framework param!',
        );
        return;
    }

    my $FWCheck           = 0;
    my $CurrentFramework  = $Self->{ConfigObject}->Get('Version');
    my $PossibleFramework = '';

    if ( ref $Param{Framework} eq 'ARRAY' ) {

        FW:
        for my $FW ( @{ $Param{Framework} } ) {

            next FW if !$FW;

            $PossibleFramework .= $FW->{Content} . ';';

            # regexp modify
            my $Framework = $FW->{Content};
            $Framework =~ s/\./\\\./g;
            $Framework =~ s/x/.+?/gi;

            next FW if $CurrentFramework !~ /^$Framework$/i;

            $FWCheck = 1;

            last FW;
        }
    }

    return 1 if $FWCheck;
    return   if $Param{NoLog};

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Sorry, can't install/upgrade package, because the framework version required"
            . " by the package ($PossibleFramework) does not match your Framework ($CurrentFramework)!",
    );

    return;
}

=item _CheckVersion()

Compare the two version strings $VersionNew and $VersionInstalled.
The type is either 'Min' or 'Max'.
'Min' returns a true value if $VersionInstalled >= $VersionNew.
'Max' returns a true value if $VersionInstalled < $VersionNew.
Otherwise undef is returned in scalar context.

    my $CheckOk = $PackageObject->_CheckVersion(
        VersionNew       => '1.3.92',
        VersionInstalled => '1.3.91',
        Type             => 'Min',     # 'Min' or 'Max'
        ExternalPackage  => 1,         # optional
    )

=cut

sub _CheckVersion {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(VersionNew VersionInstalled Type)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }

    # check Type
    if ( $Param{Type} ne 'Min' && $Param{Type} ne 'Max' ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Invalid Type!',
        );
        return;
    }

    # prepare parts hash
    my %Parts;
    TYPE:
    for my $Type (qw(VersionNew VersionInstalled)) {

        # split version string
        my @ThisParts = split /\./, $Param{$Type};

        $Parts{$Type} = \@ThisParts;
        $Parts{ $Type . 'Num' } = scalar @ThisParts;
    }

    # if it is not an external package, and the versions are different
    # we want to add a 0 at the end of the shorter version number
    # (1.2.3 will be modified to 1.2.3.0)
    # This is important to compare with a test-release version number
    if ( !$Param{ExternalPackage} && $Parts{VersionNewNum} ne $Parts{VersionInstalledNum} ) {

        TYPE:
        for my $Type (qw(VersionNew VersionInstalled)) {

            next TYPE if $Parts{ $Type . 'Num' } > 3;

            # add a zero at the end if number has less than 4 digits
            push @{ $Parts{$Type} }, 0;
            $Parts{ $Type . 'Num' } = scalar @{ $Parts{$Type} };
        }
    }

    COUNT:
    for my $Count ( 0 .. 5 ) {

        $Parts{VersionNew}->[$Count]       ||= 0;
        $Parts{VersionInstalled}->[$Count] ||= 0;

        next COUNT if $Parts{VersionNew}->[$Count] eq $Parts{VersionInstalled}->[$Count];

        # compare versions
        if ( $Param{Type} eq 'Min' ) {
            return 1 if $Parts{VersionInstalled}->[$Count] >= $Parts{VersionNew}->[$Count];
            return;
        }
        elsif ( $Param{Type} eq 'Max' ) {
            return 1 if $Parts{VersionInstalled}->[$Count] < $Parts{VersionNew}->[$Count];
            return;
        }
    }

    return 1 if $Param{Type} eq 'Min';
    return;
}

sub _CheckPackageRequired {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{PackageRequired} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'PackageRequired not defined!',
        );
        return;
    }

    return 1 if !$Param{PackageRequired};
    return 1 if ref $Param{PackageRequired} ne 'ARRAY';

    # get repository list
    my @RepositoryList = $Self->RepositoryList();

    # check required packages
    PACKAGE:
    for my $Package ( @{ $Param{PackageRequired} } ) {

        next PACKAGE if !$Package;

        my $Installed        = 0;
        my $InstalledVersion = 0;

        LOCAL:
        for my $Local (@RepositoryList) {

            next LOCAL if $Local->{Name}->{Content} ne $Package->{Content};
            next LOCAL if $Local->{Status} ne 'installed';

            $Installed        = 1;
            $InstalledVersion = $Local->{Version}->{Content};
            last LOCAL;
        }

        if ( !$Installed ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Sorry, can't install package, because package "
                    . "$Package->{Content} v$Package->{Version} is required!",
            );
            return;
        }

        my $VersionCheck = $Self->_CheckVersion(
            VersionNew       => $Package->{Version},
            VersionInstalled => $InstalledVersion,
            Type             => 'Min',
        );

        next PACKAGE if $VersionCheck;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Sorry, can't install package, because "
                . "package $Package->{Content} v$Package->{Version} is required!",
        );
        return;
    }

    return 1;
}

sub _CheckModuleRequired {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{ModuleRequired} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ModuleRequired not defined!',
        );
        return;
    }

    # check required perl modules
    if ( $Param{ModuleRequired} && ref $Param{ModuleRequired} eq 'ARRAY' ) {

        MODULE:
        for my $Module ( @{ $Param{ModuleRequired} } ) {

            next MODULE if !$Module;

            my $Installed        = 0;
            my $InstalledVersion = 0;

            # check if module is installed
            if ( $Self->{MainObject}->Require( $Module->{Content} ) ) {
                $Installed = 1;

                # check version if installed module
                $InstalledVersion = $Module->{Content}->VERSION;    ## no critic
            }
            if ( !$Installed ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't install package, because module "
                        . "$Module->{Content} v$Module->{Version} is required "
                        . "and not installed!",
                );
                return;
            }

            # return if no version is required
            return 1 if !$Module->{Version};

            # return if no module version is available
            return 1 if !$InstalledVersion;

            # check version
            my $Ok = $Self->_CheckVersion(
                VersionNew       => $Module->{Version},
                VersionInstalled => $InstalledVersion,
                Type             => 'Min',
                ExternalPackage  => 1,
            );

            if ( !$Ok ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't install package, because module "
                        . "$Module->{Content} v$Module->{Version} is required and "
                        . "$InstalledVersion is installed! You need to upgrade "
                        . "$Module->{Content} to $Module->{Version} or higher first!",
                );
                return;
            }
        }
    }

    return 1;
}

sub _CheckPackageDepends {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Name not defined!',
        );
        return;
    }

    for my $Local ( $Self->RepositoryList() ) {

        if (
            $Local->{PackageRequired}
            && ref $Local->{PackageRequired} eq 'ARRAY'
            && $Local->{Name}->{Content} ne $Param{Name}
            && $Local->{Status} eq 'installed'
            )
        {
            for my $Module ( @{ $Local->{PackageRequired} } ) {
                if ( $Param{Name} eq $Module->{Content} && !$Param{Force} ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message =>
                            "Sorry, can't uninstall package $Param{Name}, "
                            . "because package $Local->{Name}->{Content} depends on it!",
                    );
                    return;
                }
            }
        }
    }

    return 1;
}

sub _PackageFileCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Structure} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Structure not defined!',
        );
        return;
    }

    # check if one of the files is already installed by another package
    PACKAGE:
    for my $Package ( $Self->RepositoryList() ) {

        next PACKAGE if $Param{Structure}->{Name}->{Content} eq $Package->{Name}->{Content};

        for my $FileNew ( @{ $Param{Structure}->{Filelist} } ) {

            FILEOLD:
            for my $FileOld ( @{ $Package->{Filelist} } ) {

                $FileNew->{Location} =~ s/\/\//\//g;
                $FileOld->{Location} =~ s/\/\//\//g;

                next FILEOLD if $FileNew->{Location} ne $FileOld->{Location};

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't install/upgrade package, file $FileNew->{Location} already "
                        . "used in package $Package->{Name}->{Content}-$Package->{Version}->{Content}!",
                );

                return;
            }
        }
    }

    return 1;
}

sub _FileInstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(File)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }
    for my $Item (qw(Location Content Permission)) {
        if ( !defined $Param{File}->{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Item not defined in File!",
            );
            return;
        }
    }

    my $Home = $Param{Home} || $Self->{Home};

    # check Home
    if ( !-e $Home ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }

    # get real file name in fs
    my $RealFile = $Home . '/' . $Param{File}->{Location};
    $RealFile =~ s/\/\//\//g;

    # backup old file (if reinstall, don't overwrite .backup and .save files)
    if ( -e $RealFile ) {
        if ( $Param{File}->{Type} && $Param{File}->{Type} =~ /^replace$/i ) {
            if ( !$Param{Reinstall} || ( $Param{Reinstall} && !-e "$RealFile.backup" ) ) {
                move( $RealFile, "$RealFile.backup" );
            }
        }
        else {

            # check if we reinstall the same file, create a .save if it is not the same
            my $Save = 0;
            if ( $Param{Reinstall} && !-e "$RealFile.save" ) {

                # check if it's not the same
                my $Content = $Self->{MainObject}->FileRead(
                    Location => $RealFile,
                    Mode     => 'binmode',
                );
                if ( $Content && ${$Content} ne $Param{File}->{Content} ) {

                    # check if it's a framework file, create .save file
                    my %File = $Self->_ReadDistArchive( Home => $Home );
                    if ( $File{ $Param{File}->{Location} } ) {
                        $Save = 1;
                    }
                }
            }

            # if it's no reinstall or reinstall and framework file but different, back it up
            if ( !$Param{Reinstall} || ( $Param{Reinstall} && $Save ) ) {
                move( $RealFile, "$RealFile.save" );
            }
        }
    }

    # check directory of location (in case create a directory)
    if ( $Param{File}->{Location} =~ /^(.*)\/(.+?|)$/ ) {

        my $Directory        = $1;
        my @Directories      = split( /\//, $Directory );
        my $DirectoryCurrent = $Home;

        DIRECTORY:
        for my $Directory (@Directories) {

            $DirectoryCurrent .= '/' . $Directory;

            next DIRECTORY if -d $DirectoryCurrent;

            if ( mkdir $DirectoryCurrent ) {
                print STDERR "Notice: Create Directory $DirectoryCurrent!\n";
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't create directory: $DirectoryCurrent: $!",
                );
            }
        }
    }

    # write file
    return if !$Self->{MainObject}->FileWrite(
        Location   => $RealFile,
        Content    => \$Param{File}->{Content},
        Mode       => 'binmode',
        Permission => $Param{File}->{Permission},
    );

    print STDERR "Notice: Install $RealFile ($Param{File}->{Permission})!\n";

    return 1;
}

sub _FileRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(File)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );
            return;
        }
    }
    for my $Item (qw(Location)) {
        if ( !defined $Param{File}->{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Item not defined in File!",
            );
            return;
        }
    }

    my $Home = $Param{Home} || $Self->{Home};

    # check Home
    if ( !-e $Home ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }

    # get real file name in fs
    my $RealFile = $Home . '/' . $Param{File}->{Location};
    $RealFile =~ s/\/\//\//g;

    # check if file exists
    if ( !-e $RealFile ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such file: $RealFile!",
        );
        return;
    }

    # check if we should backup this file, if it is touched/different
    if ( $Param{File}->{Content} ) {
        my $Content = $Self->{MainObject}->FileRead(
            Location => $RealFile,
            Mode     => 'binmode',
        );
        if ( $Content && ${$Content} ne $Param{File}->{Content} ) {
            print STDERR "Notice: Backup for changed file: $RealFile.backup\n";
            copy( $RealFile, "$RealFile.custom_backup" );
        }
    }

    # check if it's a framework file and if $RealFile.(backup|save) exists
    # then do not remove it!
    my %File = $Self->_ReadDistArchive( Home => $Home );
    if ( $File{ $Param{File}->{Location} } && ( !-e "$RealFile.backup" && !-e "$RealFile.save" ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't remove file $RealFile, because it a framework file and no "
                . "other one exists!",
        );
        return;
    }

    # remove old file
    if ( !$Self->{MainObject}->FileDelete( Location => $RealFile ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't remove file $RealFile: $!!",
        );
        return;
    }

    print STDERR "Notice: Removed file: $RealFile\n";

    # restore old file (if exists)
    if ( -e "$RealFile.backup" ) {
        print STDERR "Notice: Recovered: $RealFile.backup\n";
        move( "$RealFile.backup", $RealFile );
    }

    # restore old file (if exists)
    elsif ( -e "$RealFile.save" ) {
        print STDERR "Notice: Recovered: $RealFile.save\n";
        move( "$RealFile.save", $RealFile );
    }

    return 1;
}

sub _ReadDistArchive {
    my ( $Self, %Param ) = @_;

    my $Home = $Param{Home} || $Self->{Home};

    # check cache
    return %{ $Self->{Cache}->{DistArchive}->{$Home} }
        if $Self->{Cache}->{DistArchive}->{$Home};

    # check if ARCHIVE exists
    if ( !-e "$Home/ARCHIVE" ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such file: $Home/ARCHIVE!",
        );
        return;
    }

    # read ARCHIVE file
    my $Content = $Self->{MainObject}->FileRead(
        Directory => $Home,
        Filename  => 'ARCHIVE',
        Result    => 'ARRAY',
    );

    my %File;
    if ($Content) {

        for my $ContentRow ( @{$Content} ) {

            my @Row = split /::/, $ContentRow;
            $Row[1] =~ s/\/\///g;
            $Row[1] =~ s/(\n|\r)//g;

            $File{ $Row[1] } = $Row[0];
        }
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open $Home/ARCHIVE: $!",
        );
    }

    # set in memory cache
    $Self->{Cache}->{DistArchive}->{$Home} = \%File;

    return %File;
}

sub _FileSystemCheck {
    my ( $Self, %Param ) = @_;

    my $Home = $Param{Home} || $Self->{Home};

    # check Home
    if ( !-e $Home ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }

    # create test files in following directories
    for my $Filepath (
        qw(/bin/ /Kernel/ /Kernel/System/ /Kernel/Output/ /Kernel/Output/HTML/ /Kernel/Modules/)
        )
    {
        my $Location = "$Home/$Filepath/check_permissons.$$";
        my $Content  = 'test';

        # create test file
        my $Write = $Self->{MainObject}->FileWrite(
            Location => $Location,
            Content  => \$Content,
        );

        # return false if not created
        return if !$Write;

        # delete test file
        $Self->{MainObject}->FileDelete( Location => $Location );
    }

    return 1;
}

sub _Encode {
    my ( $Self, $Text ) = @_;

    return $Text if !defined $Text;

    $Text =~ s/&/&amp;/g;
    $Text =~ s/</&lt;/g;
    $Text =~ s/>/&gt;/g;
    $Text =~ s/"/&quot;/g;

    return $Text;
}

=item _PackageUninstallMerged()

ONLY CALL THIS METHOD FROM A DATABASE UPGRADING SCRIPT DURING FRAMEWORK UPDATES
OR FROM A CODEUPGRADE SECTION IN AN SOPM FILE OF A PACKAGE THAT INCLUDES A MERGED FEATURE ADDON.

Uninstall an already framework (or module) merged package.

Package files that are not in the framework ARCHIVE file will be deleted, DatabaseUninstall() and
CodeUninstall are not called.

    $Success = $PackageObject->_PackageUninstallMerged(
        Name        => 'some package name',
        Home        => 'OTRS Home path',      # Optional
        DeleteSaved => 1,                     # or 0, 1 Default, Optional: if set to 1 it also
                                              # delete .save files
    );

=cut

sub _PackageUninstallMerged {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name (Name of the package)!',
        );
        return;
    }

    my $Home = $Param{Home} || $Self->{Home};

    # check Home
    if ( !-e $Home ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }

    if ( !defined $Param{DeleteSaved} ) {
        $Param{DeleteSaved} = 1;
    }

    # check if the package is installed, otherwise return success (nothing to do)
    my $PackageInstalled = $Self->PackageIsInstalled(
        Name => $Param{Name},
    );
    return 1 if !$PackageInstalled;

    # get the package details
    my @PackageList       = $Self->RepositoryList();
    my %PackageListLookup = map { $_->{Name}->{Content} => $_ } @PackageList;
    my %PackageDetails    = %{ $PackageListLookup{ $Param{Name} } };

    # get the list of framework files
    my %FrameworkFiles = $Self->_ReadDistArchive( Home => $Home );

    # can not continue if there are no framework files
    return if !%FrameworkFiles;

    # remove unneeded files (if exists)
    if ( IsArrayRefWithData( $PackageDetails{Filelist} ) ) {

        FILE:
        for my $FileHash ( @{ $PackageDetails{Filelist} } ) {

            my $File = $FileHash->{Location};

            # get real file name in fs
            my $RealFile = $Home . '/' . $File;
            $RealFile =~ s/\/\//\//g;

            # check if file exists
            if ( -e $RealFile ) {

                # check framework files (use $File instead of $RealFile)
                if ( $FrameworkFiles{$File} ) {

                    if ( $Param{DeleteSaved} ) {

                        # check if file was overridden by the package
                        my $SavedFile = $RealFile . '.save';
                        if ( -e $SavedFile ) {

                            # remove old file
                            if ( !$Self->{MainObject}->FileDelete( Location => $SavedFile ) ) {
                                $Kernel::OM->Get('Kernel::System::Log')->Log(
                                    Priority => 'error',
                                    Message  => "Can't remove file $SavedFile: $!!",
                                );
                                return;
                            }
                            print STDERR "Notice: Removed old backup file: $SavedFile\n";
                        }
                    }

                    # skip framework file
                    print STDERR "Notice: Skiped framework file: $RealFile\n";
                    next FILE;
                }

                # remove old file
                if ( !$Self->{MainObject}->FileDelete( Location => $RealFile ) ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can't remove file $RealFile: $!!",
                    );
                    return;
                }
                print STDERR "Notice: Removed file: $RealFile\n";
            }
        }
    }

    # delete package from the database
    my $PackageRemove = $Self->RepositoryRemove(
        Name => $Param{Name},
    );

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['XMLParse'],
    );
    $Kernel::OM->Get('Kernel::System::Loader')->CacheDelete();

    return $PackageRemove;
}

sub _MergedPackages {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Structure}->{PackageMerge} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'PackageMerge not defined!',
        );

        return;
    }

    return 1 if !$Param{Structure}->{PackageMerge};
    return 1 if ref $Param{Structure}->{PackageMerge} ne 'ARRAY';

    # get repository list
    my @RepositoryList = $Self->RepositoryList();
    my %PackageListLookup = map { $_->{Name}->{Content} => $_ } @RepositoryList;

    # check required packages
    PACKAGE:
    for my $Package ( @{ $Param{Structure}->{PackageMerge} } ) {

        next PACKAGE if !$Package;

        my $Installed        = 0;
        my $InstalledVersion = 0;
        my $TargetVersion    = $Package->{TargetVersion};
        my %PackageDetails;

        # check if the package is installed, otherwise go next package (nothing to do)
        my $PackageInstalled = $Self->PackageIsInstalled(
            Name => $Package->{Name},
        );

        # do nothing if package is not installed
        next PACKAGE if !$PackageInstalled;

        # get complete package info
        %PackageDetails = %{ $PackageListLookup{ $Package->{Name} } };

        # verify package version
        $InstalledVersion = $PackageDetails{Version}->{Content};

        # store package name and version for
        # use it on code and database installation
        # for principal package
        $Self->{MergedPackages}->{ $Package->{Name} } = $InstalledVersion;

        my $CheckTargetVersion = $Self->_CheckVersion(
            VersionNew       => $TargetVersion,
            VersionInstalled => $InstalledVersion,
            Type             => 'Max',
        );

        if ( $TargetVersion eq $InstalledVersion ) {

            # do nothing, installed version is the correct one,
            # code and database are up to date
        }

        # merged package shouldn't be newer than the known mergeable target version
        elsif ( !$CheckTargetVersion ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Sorry, can't install package, because package "
                    . "$Package->{Name} v$InstalledVersion newer than required v$TargetVersion!",
            );

            return;
        }
        else {

            # upgrade code (merge)
            if (
                $Param{Structure}->{CodeUpgrade}
                && ref $Param{Structure}->{CodeUpgrade} eq 'ARRAY'
                )
            {

                my @Parts;
                PART:
                for my $Part ( @{ $Param{Structure}->{CodeUpgrade} } ) {

                    if ( $Part->{Version} ) {

                        # if VersionNew >= VersionInstalled add code for execution
                        my $CheckVersion = $Self->_CheckVersion(
                            VersionNew       => $Part->{Version},
                            VersionInstalled => $TargetVersion,
                            Type             => 'Min',
                        );

                        if ($CheckVersion) {
                            push @Parts, $Part;
                        }
                    }
                    else {
                        push @Parts, $Part;
                    }
                }

                $Self->_Code(
                    Code      => \@Parts,
                    Type      => 'merge',
                    Structure => $Param{Structure},
                );
            }

            # upgrade database (merge)
            if (
                $Param{Structure}->{DatabaseUpgrade}->{merge}
                && ref $Param{Structure}->{DatabaseUpgrade}->{merge} eq 'ARRAY'
                )
            {

                my @Parts;
                my $Use = 0;
                for my $Part ( @{ $Param{Structure}->{DatabaseUpgrade}->{merge} } ) {

                    if ( $Part->{TagLevel} == 3 && $Part->{Version} ) {

                        my $CheckVersion = $Self->_CheckVersion(
                            VersionNew       => $Part->{Version},
                            VersionInstalled => $InstalledVersion,
                            Type             => 'Min',
                        );

                        if ( !$CheckVersion ) {
                            $Use   = 1;
                            @Parts = ();
                            push @Parts, $Part;
                        }
                    }
                    elsif ( $Use && $Part->{TagLevel} == 3 && $Part->{TagType} eq 'End' ) {
                        $Use = 0;
                        push @Parts, $Part;
                        $Self->_Database( Database => \@Parts );
                    }
                    elsif ($Use) {
                        push @Parts, $Part;
                    }
                }
            }

        }

        # purge package
        if ( IsArrayRefWithData( $PackageDetails{Filelist} ) ) {
            for my $File ( @{ $PackageDetails{Filelist} } ) {

                # remove file
                $Self->_FileRemove( File => $File );
            }
        }

        # remove merged package from repository
        return if !$Self->RepositoryRemove(
            Name    => $Package->{Name},
            Version => $InstalledVersion,
        );
    }

    return 1;
}

sub _CheckDBMerged {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Database} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Database not defined!',
        );

        return;
    }

    if ( ref $Param{Database} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need array ref in Database param!',
        );

        return;
    }

    my @Parts;
    my $Use = 1;
    my $NotUseTag;
    my $NotUseTagLevel;
    PART:
    for my $Part ( @{ $Param{Database} } ) {

        if ( $Use eq 0 ) {

            if (
                $Part->{TagType} eq 'End'
                && $Part->{Tag} eq $NotUseTag
                && $Part->{TagLevel} eq $NotUseTagLevel
                )
            {
                $Use = 1;
            }

            next PART;

        }
        elsif (
            (
                defined $Part->{IfPackage}
                && !$Self->{MergedPackages}->{ $Part->{IfPackage} }
            )
            || (
                defined $Part->{IfNotPackage}
                && defined $Self->{MergedPackages}->{ $Part->{IfNotPackage} }
            )
            )
        {
            # store Tag and TagLevel to be used later and found the end of this level
            $NotUseTag      = $Part->{Tag};
            $NotUseTagLevel = $Part->{TagLevel};

            $Use = 0;
            next PART;
        }

        push @Parts, $Part;
    }

    return \@Parts;
}

=item RepositoryCloudList()

returns a list of available cloud repositories

    my $List = $PackageObject->RepositoryCloudList();

=cut

sub RepositoryCloudList {
    my ( $Self, %Param ) = @_;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $CacheKey = "Repository::List::From::Cloud";
    my $Cache    = $CacheObject->Get(
        Type => 'RepositoryCloudList',
        Key  => $CacheKey,
    );

    $Param{NoCache} //= 0;

    # check if use cache is needed
    if ( !$Param{NoCache} ) {
        return $Cache if IsHashRefWithData($Cache);
    }

    my $RepositoryResult = $Self->CloudFileGet(
        Operation => 'RepositoryListAvailable',
    );

    return if !IsHashRefWithData($RepositoryResult);

    # set cache
    $CacheObject->Set(
        Type  => 'RepositoryCloudList',
        Key   => $CacheKey,
        Value => $RepositoryResult,
        TTL   => 60 * 60,
    );

    return $RepositoryResult;
}

=item CloudFileGet()

returns a file from cloud

    my $List = $PackageObject->CloudFileGet(
        Operation => 'OperationName', # used as operation name by the Cloud Service API
                                      # Possible operation names:
                                      # - RepositoryListAvailable
                                      # - FAOListAssigned
                                      # - FAOListAssignedFileGet
    );

=cut

sub CloudFileGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{Operation} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Operation not defined!',
        );
        return;
    }

    my %Data;
    if ( IsHashRefWithData( $Param{Data} ) ) {
        %Data = %{ $Param{Data} };
    }

    my $CloudService = 'PackageManagement';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Param{Operation},
                    Data      => \%Data,
                },
            ],
        },
    );

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {
        my $ErrorMessage = "Can't connect to cloud server!";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );
        return $ErrorMessage;
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Param{Operation},
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        my $ErrorMessage = "Can't get result from server";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );
        return $ErrorMessage;
    }
    elsif ( !$OperationResult->{Success} ) {
        my $ErrorMessage = $OperationResult->{ErrorMessage}
            || "Can't get list from server!";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );
        return $ErrorMessage;
    }

    # return if not correct structure
    return if !IsHashRefWithData( $OperationResult->{Data} );

    # return repo list
    return $OperationResult->{Data};

}

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
