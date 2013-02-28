# --
# Kernel/System/Package.pm - lib package manager
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use Kernel::System::Cache;
use Kernel::System::Loader;
use Kernel::System::SysConfig;
use Kernel::System::WebUserAgent;
use Kernel::System::XML;

use vars qw($VERSION $S);
$VERSION = qw($Revision: 1.142 $) [1];

=head1 NAME

Kernel::System::Package - to manage application packages/modules

=head1 SYNOPSIS

All functions to manage application packages/modules.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::Package;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $PackageObject = Kernel::System::Package->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject TimeObject MainObject EncodeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{XMLObject}    = Kernel::System::XML->new( %{$Self} );
    $Self->{CacheObject}  = Kernel::System::Cache->new( %{$Self} );
    $Self->{LoaderObject} = Kernel::System::Loader->new( %{$Self} );

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
    $Self->{PackageMapFileList} = { File => 'ARRAY', };

    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # permission check
    if ( !$Self->_FileSystemCheck() ) {
        die "ERROR: Need write permission in OTRS home\n"
            . "Try: \$OTRS_HOME/bin/otrs.SetPermissions.pl !!!\n";
    }

    return $Self;
}

=item RepositoryList()

returns a list of repository packages

    my @List = $PackageObject->RepositoryList();

=cut

sub RepositoryList {
    my ( $Self, %Param ) = @_;

    # check cache
    my $Cache = $Self->{CacheObject}->Get(
        Type => 'RepositoryList',
        Key  => 'NoKey',
    );
    return @{$Cache} if $Cache;

    # get repository list
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT name, version, install_status, content '
            . 'FROM package_repository ORDER BY name, create_time',
    );

    # fetch the data
    my @Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Package = (
            Name    => $Row[0],
            Version => $Row[1],
            Status  => $Row[2],
        );

        # get package attributes
        if ( $Row[3] ) {
            my %Structure = $Self->PackageParse( String => \$Row[3] );
            push @Data, { %Package, %Structure };
        }
    }

    # set cache
    $Self->{CacheObject}->Set(
        Type  => 'RepositoryList',
        Key   => 'NoKey',
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
    for (qw(Name Version)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check cache
    my $CacheKey = $Param{Name} . $Param{Version};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'RepositoryGet',
        Key  => $CacheKey,
    );
    return $Cache if $Cache && $Param{Result} && $Param{Result} eq 'SCALAR';
    return ${$Cache} if $Cache;

    # get repository
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT content FROM package_repository WHERE name = ? AND version = ?',
        Bind  => [ \$Param{Name}, \$Param{Version} ],
        Limit => 1,
    );

    # fetch data
    my $Package = '';
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Package = $Row[0];
    }

    if ( !$Package ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "No such package: $Param{Name}-$Param{Version}!",
        );
        return;
    }

    # set cache
    $Self->{CacheObject}->Set(
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

    $PackageObject->RepositoryAdd( String => $FileString );

=cut

sub RepositoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
        return;
    }

    # get package attributes
    my %Structure = $Self->PackageParse(%Param);
    if ( !$Structure{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name!' );
        return;
    }
    if ( !$Structure{Version} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Version!' );
        return;
    }

    # check if package already exists
    my $PackageExists = $Self->RepositoryGet(
        Name    => $Structure{Name}->{Content},
        Version => $Structure{Version}->{Content},
        Result  => 'SCALAR',
    );

    if ($PackageExists) {
        $Self->{DBObject}->Do(
            SQL => 'DELETE FROM package_repository WHERE name = ? AND version = ?',
            Bind => [ \$Structure{Name}->{Content}, \$Structure{Version}->{Content} ],
        );
    }

    # add new package
    my $FileName = $Structure{Name}->{Content} . '-' . $Structure{Version}->{Content} . '.xml';
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO package_repository (name, version, vendor, filename, '
            . ' content_size, content_type, content, install_status, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES  (?, ?, ?, ?, \'213\', \'text/xml\', ?, \'not installed\', '
            . ' current_timestamp, 1, current_timestamp, 1)',
        Bind => [
            \$Structure{Name}->{Content}, \$Structure{Version}->{Content},
            \$Structure{Vendor}->{Content}, \$FileName, \$Param{String},
        ],
    );

    # cleanup cache
    $Self->{CacheObject}->CleanUp(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Name not defined!' );
        return;
    }

    # create sql
    my @Bind = ( \$Param{Name} );
    my $SQL  = 'DELETE FROM package_repository WHERE name = ?';
    if ( $Param{Version} ) {
        $SQL .= ' AND version = ?';
        push @Bind, \$Param{Version};
    }

    return if !$Self->{DBObject}->Do( SQL => $SQL, Bind => \@Bind );

    # cleanup cache
    $Self->{CacheObject}->CleanUp(
        Type => 'RepositoryList',
    );
    $Self->{CacheObject}->CleanUp(
        Type => 'RepositoryGet',
    );

    return 1;
}

=item PackageInstall()

install a package

    $PackageObject->PackageInstall( String => $FileString );

=cut

sub PackageInstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{String} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
        return;
    }

    # conflict check
    my %Structure = $Self->PackageParse(%Param);

    # check if package is already installed
    if ( $Self->PackageIsInstalled( Name => $Structure{Name}->{Content} ) ) {
        if ( !$Param{Force} ) {
            $Self->{LogObject}->Log(
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

    # check files
    my $FileCheckOk = 1;
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            #print STDERR "Notice: Want to install $File->{Location}!\n";
        }
    }
    if ( !$FileCheckOk && !$Param{Force} ) {
        $Self->{LogObject}->Log(
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
        $Self->_Database( Database => $Structure{DatabaseInstall}->{pre} );
    }

    # install files
    if ( $Structure{Filelist} && ref $Structure{Filelist} eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {
            $Self->_FileInstall( File => $File );
        }
    }

    # add package
    return if !$Self->RepositoryAdd( String => $Param{String} );

    # update package status
    return if !$Self->{DBObject}->Do(
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
        $Self->_Database( Database => $Structure{DatabaseInstall}->{post} );
    }

    # install code (post)
    if ( $Structure{CodeInstall} ) {
        $Self->_Code(
            Code      => $Structure{CodeInstall},
            Type      => 'post',
            Structure => \%Structure,
        );
    }

    $Self->{CacheObject}->CleanUp();
    $Self->{LoaderObject}->CacheDelete();

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
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
            $Self->_FileInstall( File => $File, Reinstall => 1 );
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

    $Self->{CacheObject}->CleanUp();
    $Self->{LoaderObject}->CacheDelete();

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
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
        $Self->{LogObject}->Log(
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

    # check version
    my $CheckVersion = $Self->_CheckVersion(
        VersionNew       => $Structure{Version}->{Content},
        VersionInstalled => $InstalledVersion,
        Type             => 'Max',
    );

    if ( !$CheckVersion ) {

        if ( $Structure{Version}->{Content} eq $InstalledVersion ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Can't upgrade, package '$Structure{Name}->{Content}-$InstalledVersion' already installed!",
            );

            return if !$Param{Force};
        }
        else {
            $Self->{LogObject}->Log(
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
    return if !$Self->{DBObject}->Do(
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
        for my $Part ( @{ $Structure{DatabaseUpgrade}->{pre} } ) {

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
        my $Use = 0;
        for my $Part ( @{ $Structure{DatabaseUpgrade}->{post} } ) {

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

    $Self->{CacheObject}->CleanUp();
    $Self->{LoaderObject}->CacheDelete();

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
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

    $Self->{CacheObject}->CleanUp();
    $Self->{LoaderObject}->CacheDelete();

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

    my @XMLARRAY = $Self->{XMLObject}->XMLParse( String => $XML );

    my %List;
    my $Name = '';
    for my $Tag (@XMLARRAY) {

        # just use start tags
        next if $Tag->{TagType} ne 'Start';

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
    );

=cut

sub PackageOnlineList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(URL Lang)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
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

    # check cache
    my $CacheKey = $Param{URL} . '-' . $Param{Lang};
    if ( $Param{Cache} ) {
        my $Cache = $Self->{CacheObject}->Get(
            Type => 'PackageOnlineList',
            Key  => $CacheKey,
        );
        return @{$Cache} if $Cache;
    }

    my $XML = $Self->_Download( URL => $Param{URL} . '/otrs.xml' );

    return if !$XML;

    my @XMLARRAY = $Self->{XMLObject}->XMLParse( String => $XML );

    if ( !@XMLARRAY ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Unable to parse repository index document.',
        );
        return;
    }

    my @Packages;
    my %Package;
    my $Filelist;
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

    # just framework packages
    my @NewPackages;
    my $PackageForRequestedFramework = 0;
    for my $Package (@Packages) {

        my $FWCheckOk = 0;

        if ( $Package->{Framework} ) {

            if ( $Self->_CheckFramework( Framework => $Package->{Framework}, NoLog => 1 ) ) {
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
        $Self->{LogObject}->Log(
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
        $Self->{CacheObject}->Set(
            Type  => 'PackageOnlineList',
            Key   => $CacheKey,
            Value => \@Packages,
            TTL   => 60 * 60,
        );
    }

    return @Packages;
}

=item PackageOnlineGet()

download of an online package and put it int to the local repository

    $PackageObject->PackageOnlineGet(
        Source => 'L<http://host.example.com/>',
        File   => 'SomePackage-1.0.opm',
    );

=cut

sub PackageOnlineGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(File Source)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
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
    for (qw(Name Version)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
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

            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Param{Name}-$Param{Version}: No such file: $LocalFile!"
            );

            $Self->{DeployCheckInfo}->{File}->{ $File->{Location} } = 'No file installed!';
            $Hit = 1;
        }
        elsif ( -e $LocalFile ) {

            # md5 alternative for file deploy check (may will have better performance?)
            #                my $MD5File = $Self->{MainObject}->MD5sum(
            #                    Filename => $LocalFile,
            #                );
            #                if ($MD5File) {
            #                    my $MD5Package = $Self->{MainObject}->MD5sum(
            #                        String => \$File->{Content},
            #                    );
            #                    if ( $MD5File ne $MD5Package ) {
            my $Content = $Self->{MainObject}->FileRead(
                Location => $Self->{Home} . '/' . $File->{Location},
                Mode     => 'binmode',
            );

            if ($Content) {

                if ( ${$Content} ne $File->{Content} ) {

                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "$Param{Name}-$Param{Version}: $LocalFile is different!",
                    );

                    $Hit = 1;
                    $Self->{DeployCheckInfo}->{File}->{ $File->{Location} } = 'File is different!';
                }
            }
            else {

                $Self->{LogObject}->Log(
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
this code is not implemented yet

    $PackageObject->PackageVerify(
        Package   => $Package,
        Structure => \%Structure,
    );

=cut

sub PackageVerify {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Package Structure)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # disable verifying
    return 1;

    # check input type (not used at this moment)
    if ( ref $Param{Package} ) {
        $Param{Package} = ${ $Param{Package} };
    }

    $Self->{PackageVerifyInfo} = undef;

    # vendor name check
    if ( $Param{Structure}->{Vendor}->{Content} =~ /^otrs/i ) {
        return 1;
    }

    # verify info
    $Self->{PackageVerifyInfo} = {
        Description => "This package is not deployed by the OTRS Project. The OTRS "
            . "Project is not responsible if you run into problems by using this package. "
            . "Please contact <a href=\"mailto:sales\@otrs.com?Subject=Package "
            . $Param{Structure}->{Name}->{Content}
            . "Version=" . $Param{Structure}->{Name}->{Content}
            . "\">sales\@otrs.com</a> if you have any "
            . "problems.<br>For more info see: "
            . "<a href=\"http://otrs.org/verify?Name="
            . $Param{Structure}->{Name}->{Content}
            . "&Version="
            . $Param{Structure}->{Version}->{Content}
            . "\">http://otrs.org/verify/</a>",
        Title => 'Package Verification failed (not deployed by the OTRS Project)',

    };

    return;
}

=item PackageVerifyInfo()

returns the info of the latest PackageVerify(), what's not correctly

    my %Hash = $PackageObject->PackageVerifyInfo();

=cut

sub PackageVerifyInfo {
    my ( $Self, %Param ) = @_;

    return %{ $Self->{PackageVerifyInfo} }
        if $Self->{PackageVerifyInfo};

    return ();
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
    for (qw(Name Version Vendor License Description)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
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

    for my $Tag (
        qw(Name Version Vendor URL License ChangeLog Description Framework OS
        IntroInstall IntroUninstall IntroReinstall IntroUpgrade
        PackageRequired ModuleRequired CodeInstall CodeUpgrade CodeUninstall CodeReinstall)
        )
    {

        # don't use CodeInstall CodeUpgrade CodeUninstall CodeReinstall in index mode
        if ( $Param{Type} && $Tag =~ /(Code|Intro)(Install|Upgrade|Uninstall|Reinstall)/ ) {
            next;
        }

        if ( ref $Param{$Tag} eq 'HASH' ) {

            my %OldParam;
            for (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                $OldParam{$_} = $Param{$Tag}->{$_};
                delete $Param{$Tag}->{$_};
            }

            $XML .= "    <$Tag";

            for ( sort keys %{ $Param{$Tag} } ) {
                $XML .= " $_=\"" . $Self->_Encode( $Param{$Tag}->{$_} ) . "\"";
            }

            $XML .= ">";
            $XML .= $Self->_Encode( $OldParam{Content} ) . "</$Tag>\n";
        }
        elsif ( ref $Param{$Tag} eq 'ARRAY' ) {

            for ( @{ $Param{$Tag} } ) {

                my $TagSub = $Tag;
                my %Hash   = %{$_};
                my %OldParam;

                for (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                    $OldParam{$_} = $Hash{$_};
                    delete $Hash{$_};
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

                for ( sort keys %Hash ) {
                    $XML .= " $_=\"" . $Self->_Encode( $Hash{$_} ) . "\"";
                }

                $XML .= ">";
                $XML .= $Self->_Encode( $OldParam{Content} ) . "</$TagSub>\n";
            }
        }
        else {

#            $XML .= "  <$Tag></$Tag>\n";
#            $Self->{LogObject}->Log(Priority => 'error', Message => "Invalid Ref data in tag $Tag!");
#            return;
        }
    }

    # don't use Build* in index mode
    if ( !$Param{Type} ) {

        my $Time = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );

        $XML .= "    <BuildDate>" . $Time . "</BuildDate>\n";
        $XML .= "    <BuildHost>" . $Self->{ConfigObject}->Get('FQDN') . "</BuildHost>\n";
    }
    if ( $Param{Filelist} ) {

        $XML .= "    <Filelist>\n";

        for my $File ( @{ $Param{Filelist} } ) {

            my %OldParam;

            for (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                $OldParam{$_} = $File->{$_} || '';
                delete $File->{$_};
            }

            # do only use doc/* Filelist in index mode
            next if $Param{Type} && $File->{Location} !~ /^doc\//;

            if ( !$Param{Type} ) {
                $XML .= "        <File";
            }
            else {
                $XML .= "        <FileDoc";
            }
            for ( sort keys %{$File} ) {
                if ( $_ ne 'Tag' && $_ ne 'Content' && $_ ne 'TagType' && $_ ne 'Size' ) {
                    $XML .= " " . $Self->_Encode($_) . "=\"" . $Self->_Encode( $File->{$_} ) . "\"";
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

    for (qw(DatabaseInstall DatabaseUpgrade DatabaseReinstall DatabaseUninstall)) {

        if ( ref $Param{$_} ne 'HASH' ) {
            next;
        }

        for my $Type ( sort %{ $Param{$_} } ) {

            if ( $Param{$_}->{$Type} ) {

                my $Counter = 1;
                for my $Tag ( @{ $Param{$_}->{$Type} } ) {

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

                        for ( sort keys %{$Tag} ) {

                            if (
                                $_ ne 'Tag'
                                && $_ ne 'Content'
                                && $_ ne 'TagType'
                                && $_ ne 'TagLevel'
                                && $_ ne 'TagCount'
                                && $_ ne 'TagKey'
                                && $_ ne 'TagLastLevel'
                                )
                            {
                                if ( defined( $Tag->{$_} ) ) {
                                    $XML .= ' '
                                        . $Self->_Encode($_) . '="'
                                        . $Self->_Encode( $Tag->{$_} ) . '"';
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'String not defined!' );
        return;
    }

    # create checksum
    my $CookedString = ref $Param{String} ? ${ $Param{String} } : $Param{String};

    $Self->{EncodeObject}->EncodeOutput( \$CookedString );

    # create cecksum
    my $Checksum = $Self->{MainObject}->MD5sum(
        String => \$CookedString,
    );

    # check cache
    if ($Checksum) {
        my $Cache = $Self->{CacheObject}->Get(
            Type => 'PackageParse',
            Key  => $Checksum,
        );
        return %{$Cache} if $Cache;
    }

    my @XMLARRAY = $Self->{XMLObject}->XMLParse(%Param);

    # cleanup global vars
    undef $Self->{Package};

    # parse package
    my %PackageMap = %{ $Self->{PackageMap} };

    TAG:
    for my $Tag (@XMLARRAY) {

        next TAG if $Tag->{TagType} ne 'Start';

        if ( $PackageMap{ $Tag->{Tag} } && $PackageMap{ $Tag->{Tag} } eq 'SCALAR' ) {
            $Self->{Package}->{ $Tag->{Tag} } = $Tag;
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

            push @{ $Self->{Package}->{ $Tag->{Tag} } }, $Tag;
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

                $Self->{LogObject}->Log(
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

            push @{ $Self->{Package}->{Filelist} }, $Tag;
        }
    }

    for my $Key (qw(DatabaseInstall DatabaseUpgrade DatabaseReinstall DatabaseUninstall)) {

        my $Type = 'post';

        TAG:
        for my $Tag (@XMLARRAY) {

            if ( $Open && $Tag->{Tag} eq $Key ) {
                $Open = 0;
                push( @{ $Self->{Package}->{$Key}->{$Type} }, $Tag );
            }
            elsif ( !$Open && $Tag->{Tag} eq $Key ) {

                $Open = 1;

                if ( $Tag->{Type} ) {
                    $Type = $Tag->{Type};
                }
            }

            next TAG if !$Open;

            push @{ $Self->{Package}->{$Key}->{$Type} }, $Tag;
        }
    }

    # return package structur
    my %Return = %{ $Self->{Package} };
    undef $Self->{Package};

    # set cache
    if ($Checksum) {
        $Self->{CacheObject}->Set(
            Type  => 'PackageParse',
            Key   => $Checksum,
            Value => \%Return,
            TTL   => 30 * 24 * 60 * 60,
        );
    }

    return %Return;
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
    for (qw(String Home)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need String (PackageString) or Name (Name of the package)!'
        );
        return;
    }

    if ( $Param{String} ) {
        my %Structure = $Self->PackageParse(%Param);
        $Param{Name} = $Structure{Name}->{Content};
    }

    $Self->{DBObject}->Prepare(
        SQL => "SELECT name FROM package_repository "
            . "WHERE name = ? AND install_status = 'installed'",
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    my $Flag = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

        # install package (use eval to be save)
        eval {
            $Self->PackageInstall( String => ${$ContentSCALARRef} );
        };

        next LOCATION if !$@;

        $Self->{LogObject}->Log( Priority => 'error', Message => $@ );
    }

    return 1;
}

=begin Internal:

=cut

sub _Download {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !defined $Param{URL} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'URL not defined!' );
        return;
    }

    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject    => $Self->{LogObject},
        MainObject   => $Self->{MainObject},
        Timeout      => $Self->{ConfigObject}->Get('Package::Timeout'),
        Proxy        => $Self->{ConfigObject}->Get('Package::Proxy'),
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Database not defined!' );
        return;
    }

    if ( ref $Param{Database} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need array ref in Database param!'
        );
        return;
    }

    my @SQL = $Self->{DBObject}->SQLProcessor(
        Database => $Param{Database},
    );

    for my $SQL (@SQL) {
        print STDERR "Notice: $SQL\n";
        $Self->{DBObject}->Do( SQL => $SQL );
    }

    my @SQLPost = $Self->{DBObject}->SQLProcessorPost();

    for my $SQL (@SQLPost) {
        print STDERR "Notice: $SQL\n";
        $Self->{DBObject}->Do( SQL => $SQL );
    }

    return 1;
}

sub _Code {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Code Type Structure)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check format
    if ( ref $Param{Code} ne 'ARRAY' ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need array ref in Code param!' );
        return;
    }

    # code exec
    CODE:
    for my $Code ( @{ $Param{Code} } ) {

        next CODE if !$Code->{Content};
        next CODE if $Param{Type} !~ /^$Code->{Type}$/i;

        print STDERR "Code: $Code->{Content}\n";

        if ( !eval $Code->{Content} . "\n1;" ) {    ## no critic
            $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'OS not defined!' );
        return;
    }

    # check format
    if ( ref $Param{OS} ne 'ARRAY' ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need array ref in OS param!' );
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

    $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Framework not defined!' );
        return;
    }

    # check format
    if ( ref $Param{Framework} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need array ref in Framework param!'
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

    $Self->{LogObject}->Log(
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
    for (qw(VersionNew VersionInstalled Type)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$_ not defined!",
            );
            return;
        }
    }

    # check Type
    if ( $Param{Type} ne 'Min' && $Param{Type} ne 'Max' ) {

        $Self->{LogObject}->Log(
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
    # This is important to compare with a test releaseversion number
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'PackageRequired not defined!' );
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
            $Self->{LogObject}->Log(
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

        $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'ModuleRequired not defined!' );
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
                $Self->{LogObject}->Log(
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
                $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Name not defined!' );
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
                    $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Structure not defined!' );
        return;
    }

    # check if one of this files is already intalled by an other package
    PACKAGE:
    for my $Package ( $Self->RepositoryList() ) {

        next PACKAGE if $Param{Structure}->{Name}->{Content} eq $Package->{Name}->{Content};

        for my $FileNew ( @{ $Param{Structure}->{Filelist} } ) {

            for my $FileOld ( @{ $Package->{Filelist} } ) {

                $FileNew->{Location} =~ s/\/\//\//g;
                $FileOld->{Location} =~ s/\/\//\//g;

                next if $FileNew->{Location} ne $FileOld->{Location};

                $Self->{LogObject}->Log(
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
    for (qw(File)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for (qw(Location Content Permission)) {
        if ( !defined $Param{File}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined in File!" );
            return;
        }
    }

    my $Home = $Param{Home} || $Self->{Home};

    # check Home
    if ( !-e $Home ) {
        $Self->{LogObject}->Log(
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

            # check if we reinstall the same file, create a .save it not the same one
            my $Save = 0;
            if ( $Param{Reinstall} && !-e "$RealFile.save" ) {

                # check if it's not the same
                my $Content = $Self->{MainObject}->FileRead(
                    Location => $RealFile,
                    Mode     => 'binmode',
                );
                if ( $Content && ${$Content} ne $Param{File}->{Content} ) {

                    # check if it's framework file, create .save file
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
                $Self->{LogObject}->Log(
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
    for (qw(File)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for (qw(Location)) {
        if ( !defined $Param{File}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined in File!" );
            return;
        }
    }

    my $Home = $Param{Home} || $Self->{Home};

    # check Home
    if ( !-e $Home ) {
        $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log(
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

    # check if it's framework file and if $RealFile.(backup|save) exists
    # then do not remove it!
    my %File = $Self->_ReadDistArchive( Home => $Home );
    if ( $File{ $Param{File}->{Location} } && ( !-e "$RealFile.backup" && !-e "$RealFile.save" ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't remove file $RealFile, because it a framework file and no "
                . "other one exists!",
        );
        return;
    }

    # remove old file
    if ( !$Self->{MainObject}->FileDelete( Location => $RealFile ) ) {
        $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log(
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }

    # create test files in following directories
    for (qw(/bin/ /Kernel/ /Kernel/System/ /Kernel/Output/ /Kernel/Output/HTML/ /Kernel/Modules/)) {
        my $Location = "$Home/$_/check_permissons.$$";
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

    $Text =~ s/&/&amp;/g;
    $Text =~ s/</&lt;/g;
    $Text =~ s/>/&gt;/g;
    $Text =~ s/"/&quot;/g;

    return $Text;
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

=head1 VERSION

$Revision: 1.142 $ $Date: 2012-11-20 15:37:04 $

=cut
