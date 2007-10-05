# --
# Kernel/System/Package.pm - lib package manager
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Package.pm,v 1.72 2007-10-05 09:25:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Package;

use strict;
use warnings;
use MIME::Base64;
use File::Copy;
use LWP::UserAgent;
use Kernel::System::XML;
use Kernel::System::Config;

use vars qw($VERSION $S);
$VERSION = qw($Revision: 1.72 $) [1];

=head1 NAME

Kernel::System::Package - to application packages/modules

=head1 SYNOPSIS

All functions to manage application packages/modules.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::Package;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $PackageObject = Kernel::System::Package->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
        TimeObject => $TimeObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject TimeObject MainObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }
    $Self->{XMLObject} = Kernel::System::XML->new(%Param);

    $Self->{PackageMap} = {
        Name               => 'SCALAR',
        Version            => 'SCALAR',
        Vendor             => 'SCALAR',
        BuildDate          => 'SCALAR',
        BuildHost          => 'SCALAR',
        License            => 'SCALAR',
        URL                => 'SCALAR',
        ChangeLog          => 'ARRAY',
        Description        => 'ARRAY',
        Framework          => 'ARRAY',
        OS                 => 'ARRAY',
        PackageRequired    => 'ARRAY',
        ModuleRequired     => 'ARRAY',
        IntroInstallPre    => 'ARRAY',
        IntroInstallPost   => 'ARRAY',
        IntroUninstallPre  => 'ARRAY',
        IntroUninstallPost => 'ARRAY',
        IntroReinstallPre  => 'ARRAY',
        IntroReinstallPost => 'ARRAY',
        IntroUpgradePre    => 'ARRAY',
        IntroUpgradePost   => 'ARRAY',
        CodeInstall        => 'SCALAR',
        CodeUpgrade        => 'SCALAR',
        CodeUninstall      => 'SCALAR',
        CodeReinstall      => 'SCALAR',
    };
    $Self->{PackageMapFileList} = { File => 'ARRAY', };

    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # permission check
    if ( !$Self->_FileSystemCheck() ) {
        die "ERROR: Need write permission in OTRS home\n"
            . "Try: \$OTRS_HOME/bin/SetPermissions.sh !!!\n";
    }

    return $Self;
}

=item RepositoryList()

returns a list of repository packages

    my @List = $PackageObject->RepositoryList();

=cut

sub RepositoryList {
    my ( $Self, %Param ) = @_;

    my @Data = ();

    # check needed stuff
    for (qw()) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    my $SQL
        = "SELECT name, version, install_status, content FROM package_repository ORDER BY name, create_time";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Package = (
            Name    => $Row[0],
            Version => $Row[1],
            Status  => $Row[2],
        );

        # get package attributes
        if ( $Row[3] ) {
            my %Structure = $Self->PackageParse( String => $Row[3] );
            push( @Data, { %Package, %Structure } );
        }
    }

    return (@Data);
}

=item RepositoryGet()

get a package from local repository

    my $Package = $PackageObject->RepositoryGet(
        Name => 'Application A',
        Version => '1.0',
    );

=cut

sub RepositoryGet {
    my ( $Self, %Param ) = @_;

    my $Package = '';

    # check needed stuff
    for (qw(Name Version)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    my $SQL = "SELECT content FROM package_repository WHERE "
        . " name = '$Param{Name}' AND version = '$Param{Version}'";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Package = $Row[0];
    }
    if ( !$Package ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "No such package $Param{Name}-$Param{Version}!",
        );
        return;
    }
    else {
        return $Package;
    }
}

=item RepositoryAdd()

add a package to local repository

    $PackageObject->RepositoryAdd(String => $FileString);

=cut

sub RepositoryAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # get package attributes
    my %Structure = $Self->PackageParse(%Param);
    if ( !$Structure{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Name!" );
        return;
    }
    if ( !$Structure{Version} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Version!" );
        return;
    }

    # check if package already exists
    if ($Self->RepositoryGet(
            Name    => $Structure{Name}->{Content},
            Version => $Structure{Version}->{Content}
        )
        )
    {

#        $Self->{LogObject}->Log(
#            Priority => 'error',
#            Message => "Package $Structure{Name}->{Content}-$Structure{Version}->{Content} already in local repository!",
#        );
#        return;
        my $SQL
            = "DELETE FROM package_repository WHERE "
            . " name = '"
            . $Self->{DBObject}->Quote( $Structure{Name}->{Content} ) . "'" . " AND "
            . " version = '"
            . $Self->{DBObject}->Quote( $Structure{Version}->{Content} ) . "'";
        $Self->{DBObject}->Do( SQL => $SQL );
    }
    my $SQL
        = "INSERT INTO package_repository (name, version, vendor, filename, "
        . " content_size, content_type, content, install_status, "
        . " create_time, create_by, change_time, change_by)"
        . " VALUES " . " ('"
        . $Self->{DBObject}->Quote( $Structure{Name}->{Content} ) . "', " . " '"
        . $Self->{DBObject}->Quote( $Structure{Version}->{Content} ) . "', " . " '"
        . $Self->{DBObject}->Quote( $Structure{Vendor}->{Content} ) . "', " . " '"
        . $Self->{DBObject}->Quote( $Structure{Name}->{Content} ) . "-"
        . $Self->{DBObject}->Quote( $Structure{Version}->{Content} )
        . ".xml', "
        . " '213', 'text/xml', ?, 'not installed', "
        . " current_timestamp, 1, current_timestamp, 1)";

    if ( $Self->{DBObject}->Do( SQL => $SQL, Bind => [ \$Param{String} ] ) ) {
        return 1;
    }
    else {
        return;
    }
}

=item RepositoryRemove()

remove a package from local repository

    $PackageObject->RepositoryRemove(
        Name => 'Application A',
        Version => '1.0',
    );

=cut

sub RepositoryRemove {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # db quote
    for ( keys %Param ) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }

    # sql
    my $SQL = "DELETE FROM package_repository WHERE " . " name = '$Param{Name}'";
    if ( $Param{Version} ) {
        $SQL .= " AND version = '$Param{Version}'";
    }
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

sub _CheckFramework {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Framework)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # regexp modify
    $Param{Framework} =~ s/\./\\\./g;
    $Param{Framework} =~ s/x/.+?/gi;
    if ( $Self->{ConfigObject}->Get('Version') =~ /^$Param{Framework}$/i ) {
        return 1;
    }
    else {
        return;
    }
}

sub _CheckVersion {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Version1 Version2 Type)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for my $Type (qw(Version1 Version2)) {
        my @Parts = split( /\./, $Param{$Type} );
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            $Param{$Type} .= sprintf( "%04d", $Parts[$_] || 0 );
        }
        $Param{$Type} = int( $Param{$Type} );
    }
    if ( $Param{Type} eq 'Min' ) {
        if ( $Param{Version2} >= $Param{Version1} ) {
            return 1;
        }
        else {
            return;
        }
    }
    elsif ( $Param{Type} eq 'Max' ) {
        if ( $Param{Version2} < $Param{Version1} ) {
            return 1;
        }
        else {
            return;
        }
    }
    else {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Invalid Type!" );
        return;
    }
}

sub _CheckPackageRequired {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(PackageRequired)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check required packages
    if ( $Param{PackageRequired} && ref( $Param{PackageRequired} ) eq 'ARRAY' ) {
        for my $Package ( @{ $Param{PackageRequired} } ) {
            my $Installed        = 0;
            my $InstalledVersion = 0;
            for my $Local ( $Self->RepositoryList() ) {
                if (   $Local->{Name}->{Content} eq $Package->{Content}
                    && $Local->{Status} eq 'installed' )
                {
                    $Installed        = 1;
                    $InstalledVersion = $Local->{Version}->{Content};
                    last;
                }
            }
            if ( !$Installed && !$Param{Force} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't install package, because package "
                        . "$Package->{Content} v$Package->{Version} is required!",
                );
                return;
            }
            elsif ( $Installed && !$Param{Force} ) {
                if (!$Self->_CheckVersion(
                        Version1 => $Package->{Version},
                        Version2 => $InstalledVersion,
                        Type     => 'Min'
                    )
                    )
                {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Sorry, can't install package, because "
                            . "package $Package->{Content} v$Package->{Version} is required!",
                    );
                    return;
                }
            }
        }
    }
    return 1;
}

sub _CheckModuleRequired {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ModuleRequired)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check required perl modules
    if ( $Param{ModuleRequired} && ref( $Param{ModuleRequired} ) eq 'ARRAY' ) {
        for my $Module ( @{ $Param{ModuleRequired} } ) {
            my $Installed        = 0;
            my $InstalledVersion = 0;

            # check if module is installed
            if ( $Self->{MainObject}->Require( $Module->{Content} ) ) {
                $Installed = 1;

                # check version if installed module
                $InstalledVersion = $Module->{Content}->VERSION;
            }
            if ( !$Installed ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Sorry, can't install package, because module "
                        . "$Module->{Content} v$Module->{Version} is required "
                        . "and not installed!",
                );
                if ( !$Param{Force} ) {
                    return;
                }
                else {
                    return 1;
                }
            }
            else {
                if ($InstalledVersion
                    && !$Self->_CheckVersion(
                        Version1 => $Module->{Version},
                        Version2 => $InstalledVersion,
                        Type     => 'Min'
                    )
                    )
                {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Sorry, can't install package, because module "
                            . "$Module->{Content} v$Module->{Version} is required and "
                            . "$InstalledVersion is installed! You need to upgrade "
                            . "$Module->{Content} to $Module->{Version} or higher first!",
                    );
                    if ( !$Param{Force} ) {
                        return;
                    }
                    else {
                        return 1;
                    }
                }
            }
        }
    }
    return 1;
}

sub _CheckPackageDepends {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for my $Local ( $Self->RepositoryList() ) {
        if (   $Local->{PackageRequired}
            && ref( $Local->{PackageRequired} ) eq 'ARRAY'
            && $Local->{Name}->{Content} ne $Param{Name}
            && $Local->{Status} eq 'installed' )
        {
            for my $Module ( @{ $Local->{PackageRequired} } ) {
                if ( $Param{Name} eq $Module->{Content} && !$Param{Force} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message =>
                            "Sorry, can't uninstall package, because package $Param{Name} is depends on package $Local->{Name}->{Content}!",
                    );
                    return;
                }
            }
        }
    }
    return 1;
}

=item PackageInstall()

install a package

    $PackageObject->PackageInstall(String => $FileString);

=cut

sub PackageInstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # conflict check
    my %Structure = $Self->PackageParse(%Param);

    # check if package is already installed
    for my $Package ( $Self->RepositoryList() ) {
        if ( $Structure{Name}->{Content} eq $Package->{Name}->{Content} ) {
            if ( $Package->{Status} =~ /^installed$/i ) {
                if ( !$Param{Force} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message  => "Package already installed, try upgrade!",
                    );
                    return $Self->PackageUpgrade(%Param);
                }
            }
        }
    }

    # check OS
    my $OSCheckOk = 1;
    if ( $Structure{OS} && ref( $Structure{OS} ) eq 'ARRAY' ) {
        $OSCheckOk = 0;
        for my $OS ( @{ $Structure{OS} } ) {
            if ( $^O =~ /^$OS$/i ) {
                $OSCheckOk = 1;
            }
        }
    }
    if ( !$OSCheckOk && !$Param{Force} ) {
        my $CurrOS = $^O;
        my $PkgOS  = '<unknown OS>';
        if ( defined $Structure{OS} && scalar( @{ $Structure{OS} } ) > 0 ) {
            $PkgOS = $Structure{OS}->[0];
        }
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Sorry, can't install package, because OS of package ($PkgOS) does not match your OS ($CurrOS)!!",
        );
        return;
    }

    # check framework
    my $FWCheckOk = 0;
    if ( $Structure{Framework} && ref( $Structure{Framework} ) eq 'ARRAY' ) {
        for my $FW ( @{ $Structure{Framework} } ) {
            if ( $Self->_CheckFramework( Framework => $FW->{Content} ) ) {
                $FWCheckOk = 1;
            }
        }
    }
    if ( !$FWCheckOk && !$Param{Force} ) {
        my $FwVersion    = $Self->{ConfigObject}->Get('Version');
        my $PkgFwVersion = '<unknown version>';
        if ( defined $Structure{Framework} && scalar( @{ $Structure{Framework} } ) > 0 ) {
            $PkgFwVersion = $Structure{Framework}->[0]->{Content};
        }
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Sorry, can't install package, because the framework version required"
                . " by the package ($PkgFwVersion) does not match your Framework ($FwVersion)!!",
        );
        return;
    }

    # check required packages
    if ( $Structure{PackageRequired} && ref( $Structure{PackageRequired} ) eq 'ARRAY' ) {
        if ( !$Self->_CheckPackageRequired( %Param, PackageRequired => $Structure{PackageRequired} )
            && !$Param{Force} )
        {
            return;
        }
    }

    # check required modules
    if ( $Structure{ModuleRequired} && ref( $Structure{ModuleRequired} ) eq 'ARRAY' ) {
        if (   !$Self->_CheckModuleRequired( %Param, ModuleRequired => $Structure{ModuleRequired} )
            && !$Param{Force} )
        {
            return;
        }
    }

    # check files
    my $FileCheckOk = 1;
    if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            #            print STDERR "Notice: Want to install $File->{Location}!\n";
        }
    }
    if ( !$FileCheckOk && !$Param{Force} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "File conflict, can't install package!",
        );
        return;
    }

    # check if one of this files is already intalled by an other package
    for my $Package ( $Self->RepositoryList() ) {
        if ( $Structure{Name}->{Content} ne $Package->{Name}->{Content} ) {
            for my $FileNew ( @{ $Structure{Filelist} } ) {
                for my $FileOld ( @{ $Package->{Filelist} } ) {
                    $FileNew->{Location} =~ s/\/\//\//g;
                    $FileOld->{Location} =~ s/\/\//\//g;
                    if ( $FileNew->{Location} eq $FileOld->{Location} ) {
                        if ( !$Param{Force} ) {
                            $Self->{LogObject}->Log(
                                Priority => 'error',
                                Message =>
                                    "Can't install package, file $FileNew->{Location} already "
                                    . "used in package $Package->{Name}->{Content}-$Package->{Version}->{Content}!",
                            );
                            return;
                        }
                    }
                }
            }
        }
    }

    # add package
    if ( $Self->RepositoryAdd( String => $Param{String} ) ) {

        # update package status
        my $SQL
            = "UPDATE package_repository SET install_status = 'installed'"
            . " WHERE "
            . " name = '"
            . $Self->{DBObject}->Quote( $Structure{Name}->{Content} ) . "'" . " AND "
            . " version = '"
            . $Self->{DBObject}->Quote( $Structure{Version}->{Content} ) . "'";
        $Self->{DBObject}->Do( SQL => $SQL );

        # install files
        if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
            for my $File ( @{ $Structure{Filelist} } ) {

                # install file
                $Self->_FileInstall( %{$File} );
            }
        }

        # install config
        $Self->{SysConfigObject} = Kernel::System::Config->new( %{$Self} );
        $Self->{SysConfigObject}->WriteDefault();

        # install code
        if ( $Structure{CodeInstall} && $Structure{CodeInstall}->{Content} ) {
            if ( $Structure{CodeInstall}->{Content} ) {
                print STDERR "Code: $Structure{CodeInstall}->{Content}\n";
                if ( !eval $Structure{CodeInstall}->{Content} . "\n1;" ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "CodeInstall: $@",
                    );
                }
            }
        }

        # install database
        if ( $Structure{DatabaseInstall} && ref( $Structure{DatabaseInstall} ) eq 'ARRAY' ) {
            my @SQL = $Self->{DBObject}->SQLProcessor( Database => $Structure{DatabaseInstall}, );
            for my $SQL (@SQL) {
                print STDERR "Notice: $SQL\n";
                $Self->{DBObject}->Do( SQL => $SQL );
            }
            my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
            for my $SQL (@SQLPost) {
                print STDERR "Notice: $SQL\n";
                $Self->{DBObject}->Do( SQL => $SQL );
            }
        }
        return 1;
    }
    else {
        return;
    }
}

=item PackageReinstall()

reinstall files of a package

    $PackageObject->PackageReinstall(String => $FileString);

=cut

sub PackageReinstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # parse source file
    my %Structure = $Self->PackageParse(%Param);

    # install files
    if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            # install file
            #            print STDERR "Notice: Reinstall $File->{Location}!\n";
            $Self->_FileInstall( %{$File}, Reinstall => 1 );
        }
    }

    # install config
    $Self->{SysConfigObject} = Kernel::System::Config->new( %{$Self} );
    $Self->{SysConfigObject}->WriteDefault();

    # install code
    if ( $Structure{CodeReinstall} && $Structure{CodeReinstall}->{Content} ) {
        if ( $Structure{CodeReinstall}->{Content} ) {
            print STDERR "Code: $Structure{CodeReinstall}->{Content}\n";
            if ( !eval $Structure{CodeReinstall}->{Content} . "\n1;" ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "CodeReinstall: $@",
                );
            }
        }
    }
    return 1;
}

=item PackageUpgrade()

upgrade a package

    $PackageObject->PackageUpgrade(String => $FileString);

=cut

sub PackageUpgrade {
    my ( $Self, %Param ) = @_;

    my %InstalledStructure = ();

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
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
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "Package is not installed, can't upgrade!" );
        return;
    }

    # version check
    if (!$Self->_CheckVersion(
            Version1 => $Structure{Version}->{Content},
            Version2 => $InstalledVersion,
            Type     => 'Max'
        )
        )
    {
        if ( $Structure{Version}->{Content} eq $InstalledVersion ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Can't upgrade, package '$Structure{Name}->{Content}-$InstalledVersion' already installed!",
            );
            if ( !$Param{Force} ) {
                return;
            }
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Can't upgrade, installed package '$InstalledVersion' is newer as '$Structure{Version}->{Content}'!",
            );
            if ( !$Param{Force} ) {
                return;
            }
        }
    }

    # check if one of this files is already intalled by an other package
    for my $Package ( $Self->RepositoryList() ) {
        if ( $Structure{Name}->{Content} ne $Package->{Name}->{Content} ) {
            for my $FileNew ( @{ $Structure{Filelist} } ) {
                for my $FileOld ( @{ $Package->{Filelist} } ) {
                    $FileNew->{Location} =~ s/\/\//\//g;
                    $FileOld->{Location} =~ s/\/\//\//g;
                    if ( $FileNew->{Location} eq $FileOld->{Location} ) {
                        if ( !$Param{Force} ) {
                            $Self->{LogObject}->Log(
                                Priority => 'error',
                                Message =>
                                    "Can't upgrade package, file $FileNew->{Location} already "
                                    . "used in package $Package->{Name}->{Content}-$Package->{Version}->{Content}!",
                            );
                            return;
                        }
                    }
                }
            }
        }
    }

    # check OS
    my $OSCheckOk = 1;
    if ( $Structure{OS} && ref( $Structure{OS} ) eq 'ARRAY' ) {
        $OSCheckOk = 0;
        for my $OS ( @{ $Structure{OS} } ) {
            if ( $^O =~ /^$OS$/i ) {
                $OSCheckOk = 1;
            }
        }
    }
    if ( !$OSCheckOk && !$Param{Force} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Sorry, can't install package, because package is not for your OS!!",
        );
        return;
    }

    # check framework
    my $FWCheckOk = 0;
    if ( $Structure{Framework} && ref( $Structure{Framework} ) eq 'ARRAY' ) {
        for my $FW ( @{ $Structure{Framework} } ) {
            if ( $Self->_CheckFramework( Framework => $FW->{Content} ) ) {
                $FWCheckOk = 1;
            }
        }
    }
    if ( !$FWCheckOk && !$Param{Force} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Sorry, can't install package, because package is not for your Framework!!",
        );
        return;
    }

    # check required packages
    if ( $Structure{PackageRequired} && ref( $Structure{PackageRequired} ) eq 'ARRAY' ) {
        if ( !$Self->_CheckPackageRequired( %Param, PackageRequired => $Structure{PackageRequired} )
            && !$Param{Force} )
        {
            return;
        }
    }

    # check required modules
    if ( $Structure{ModuleRequired} && ref( $Structure{ModuleRequired} ) eq 'ARRAY' ) {
        if (   !$Self->_CheckModuleRequired( %Param, ModuleRequired => $Structure{ModuleRequired} )
            && !$Param{Force} )
        {
            return;
        }
    }

    # remove old packages
    $Self->RepositoryRemove( Name => $Structure{Name}->{Content} );
    if ( $Self->RepositoryAdd( String => $Param{String} ) ) {

        # update package status
        my $SQL
            = "UPDATE package_repository SET install_status = 'installed'"
            . " WHERE "
            . " name = '"
            . $Self->{DBObject}->Quote( $Structure{Name}->{Content} ) . "'" . " AND "
            . " version = '"
            . $Self->{DBObject}->Quote( $Structure{Version}->{Content} ) . "'";
        $Self->{DBObject}->Do( SQL => $SQL );

        # uninstall old package files
        if ( $InstalledStructure{Filelist} && ref( $InstalledStructure{Filelist} ) eq 'ARRAY' ) {
            for my $File ( @{ $InstalledStructure{Filelist} } ) {

                # remove file
                $Self->_FileRemove( %{$File} );
            }
        }

        # install files
        if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
            for my $File ( @{ $Structure{Filelist} } ) {

                # install file
                $Self->_FileInstall( %{$File} );
            }
        }

        # install config
        $Self->{SysConfigObject} = Kernel::System::Config->new( %{$Self} );
        $Self->{SysConfigObject}->WriteDefault();

        # install code
        if ( $Structure{CodeUpgrade} && $Structure{CodeUpgrade}->{Content} ) {
            if ( $Structure{CodeUpgrade}->{Content} ) {
                print STDERR "Code: $Structure{CodeUpgrade}->{Content}\n";
                if ( !eval $Structure{CodeUpgrade}->{Content} ) {
                    print STDERR "CodeError: $@\n";
                }
            }
        }

        # upgrade database
        if ( $Structure{DatabaseUpgrade} && ref( $Structure{DatabaseUpgrade} ) eq 'ARRAY' ) {
            my @Part = ();
            my $Use  = 0;
            for my $S ( @{ $Structure{DatabaseUpgrade} } ) {
                if ( $S->{TagLevel} == 3 && $S->{Version} ) {
                    if (!$Self->_CheckVersion(
                            Version1 => $S->{Version},
                            Version2 => $InstalledVersion,
                            Type     => 'Min'
                        )
                        )
                    {
                        $Use  = 1;
                        @Part = ();
                        push( @Part, $S );
                    }
                }
                elsif ( $Use && $S->{TagLevel} == 3 && $S->{TagType} eq 'End' ) {
                    $Use = 0;
                    push( @Part, $S );
                    my @SQL = $Self->{DBObject}->SQLProcessor( Database => \@Part );
                    for my $SQL (@SQL) {
                        print STDERR "Notice: $SQL\n";
                        $Self->{DBObject}->Do( SQL => $SQL );
                    }
                    my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
                    for my $SQL (@SQLPost) {
                        print STDERR "Notice: $SQL\n";
                        $Self->{DBObject}->Do( SQL => $SQL );
                    }
                }
                elsif ($Use) {
                    push( @Part, $S );
                }
            }
        }
        return 1;
    }
    else {
        return;
    }
}

=item PackageUninstall()

uninstall a package

    $PackageObject->PackageUninstall(String => $FileString);

=cut

sub PackageUninstall {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # parse source file
    my %Structure = $Self->PackageParse(%Param);

    # check depends
    if ( !$Self->_CheckPackageDepends( Name => $Structure{Name}->{Content} ) && !$Param{Force} ) {
        return;
    }

    # files
    my $FileCheckOk = 1;
    if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            # remove file
            $Self->_FileRemove( %{$File} );
        }
    }

    # remove old packages
    $Self->RepositoryRemove( Name => $Structure{Name}->{Content} );

    # install config
    $Self->{SysConfigObject} = Kernel::System::Config->new( %{$Self} );
    $Self->{SysConfigObject}->WriteDefault();
    if ( !$FileCheckOk ) {

        #        return;
    }

    # uninstall code
    if ( $Structure{CodeUninstall} && $Structure{CodeUninstall}->{Content} ) {
        if ( $Structure{CodeUninstall}->{Content} ) {
            print STDERR "Code: $Structure{CodeUninstall}->{Content}\n";
            if ( !eval $Structure{CodeUninstall}->{Content} . "\n1;" ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "CodeUninstall: $@",
                );
            }
        }
    }

    # uninstall database
    if ( $Structure{DatabaseUninstall} && ref( $Structure{DatabaseUninstall} ) eq 'ARRAY' ) {
        my @SQL = $Self->{DBObject}->SQLProcessor( Database => $Structure{DatabaseUninstall}, );
        for my $SQL (@SQL) {
            print STDERR "Notice: $SQL\n";
            $Self->{DBObject}->Do( SQL => $SQL );
        }
        my @SQLPost = $Self->{DBObject}->SQLProcessorPost();
        for my $SQL (@SQLPost) {
            print STDERR "Notice: $SQL\n";
            $Self->{DBObject}->Do( SQL => $SQL );
        }
    }
    return 1;
}

=item PackageOnlineRepositories()

returns a list of available online repositories

    my %List = $PackageObject->PackageOnlineRepositories();

=cut

sub PackageOnlineRepositories {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check if online repository should be fetched
    if ( !$Self->{ConfigObject}->Get('Package::RepositoryRoot') ) {
        return ();
    }

    # get repository list
    my $XML = '';
    for ( @{ $Self->{ConfigObject}->Get('Package::RepositoryRoot') } ) {
        $XML = $Self->_Download( URL => $_ );
        if ($XML) {
            last;
        }
    }
    if ( !$XML ) {
        return ();
    }
    my @XMLARRAY = $Self->{XMLObject}->XMLParse( String => $XML );
    my %List     = ();
    my $Name     = '';
    for my $Tag (@XMLARRAY) {

        # just use start tags
        if ( $Tag->{TagType} ne 'Start' ) {
            next;
        }

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

returns a list of available online packages

    my @List = $PackageObject->PackageOnlineList();

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
    my $XML = $Self->_Download( URL => $Param{URL} . "/otrs.xml" );
    if ( !$XML ) {
        return;
    }
    my @XMLARRAY = $Self->{XMLObject}->XMLParse( String => $XML );
    if ( !@XMLARRAY ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Unable to parse Online Repository index document!",
        );
        return;
    }
    my @Packages = ();
    my %Package  = ();
    for my $Tag (@XMLARRAY) {

        # remember package
        if ( $Tag->{TagType} eq 'End' && $Tag->{Tag} eq 'Package' ) {
            if (%Package) {
                push( @Packages, {%Package} );
            }
            next;
        }

        # just use start tags
        if ( $Tag->{TagType} ne 'Start' ) {
            next;
        }

        # reset package data
        if ( $Tag->{Tag} eq 'Package' ) {
            %Package = ();
        }
        elsif ( $Tag->{Tag} eq 'Framework' ) {
            push( @{ $Package{Framework} }, $Tag );
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
    my @NewPackages                  = ();
    my $PackageForRequestedFramework = 0;
    for my $Package (@Packages) {
        my $FWCheckOk = 0;
        if ( $Package->{Framework} && ref( $Package->{Framework} ) eq 'ARRAY' ) {
            for my $FW ( @{ $Package->{Framework} } ) {
                if ( $Self->_CheckFramework( Framework => $FW->{Content} ) ) {
                    $FWCheckOk                    = 1;
                    $PackageForRequestedFramework = 1;
                }
            }
        }
        if ($FWCheckOk) {
            push( @NewPackages, $Package );
        }
    }

    # return of there are packages but not for this framework
    if ( @Packages && !$PackageForRequestedFramework ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!",
        );
    }
    @Packages = @NewPackages;

    # just the newest packages
    my %Newest = ();
    for my $Package (@Packages) {
        if ( !$Newest{ $Package->{Name} } ) {
            $Newest{ $Package->{Name} } = $Package;
        }
        else {
            if (!$Self->_CheckVersion(
                    Version1 => $Package->{Version},
                    Version2 => $Newest{ $Package->{Name} }->{Version},
                    Type     => 'Min'
                )
                )
            {
                $Newest{ $Package->{Name} } = $Package;
            }
        }
    }

    # get possible actions
    @NewPackages = ();
    my @LocalList = $Self->RepositoryList();
    for my $Data ( sort keys %Newest ) {
        my $InstalledSameVersion = 0;
        for my $Package (@LocalList) {
            if ( $Newest{$Data}->{Name} eq $Package->{Name}->{Content} ) {
                $Newest{$Data}->{Local} = 1;
                if ( $Package->{Status} eq 'installed' ) {
                    $Newest{$Data}->{Installed} = 1;
                    if (!$Self->_CheckVersion(
                            Version1 => $Newest{$Data}->{Version},
                            Version2 => $Package->{Version}->{Content},
                            Type     => 'Min'
                        )
                        )
                    {
                        $Newest{$Data}->{Upgrade} = 1;
                    }

                    # check if version or lower is already installed
                    elsif (
                        !$Self->_CheckVersion(
                            Version1 => $Newest{$Data}->{Version},
                            Version2 => $Package->{Version}->{Content},
                            Type     => 'Max'
                        )
                        )
                    {
                        $InstalledSameVersion = 1;
                    }
                }
            }
        }

        # add package if not already installed
        if ( !$InstalledSameVersion ) {
            push( @NewPackages, $Newest{$Data} );
        }
    }
    @Packages = @NewPackages;

    return @Packages;
}

=item PackageOnlineGet()

donwload of an online package and put it int to the local reposetory

    $PackageObject->PackageOnlineGet(
        Source => 'http://host/',
        File => 'SomePackage-1.0.opm',
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
    return $Self->_Download( URL => $Param{Source} . "/$Param{File}" );
}

=item DeployCheck()

check if package (files) is deployed, returns true if it's ok

    $PackageObject->DeployCheck(
        Name => 'Application A',
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
    my $Package = $Self->RepositoryGet(%Param);
    my %Structure = $Self->PackageParse( String => $Package );
    $Self->{DeployCheckInfo} = undef;
    if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
        my $Hit = 0;
        for my $File ( @{ $Structure{Filelist} } ) {
            my $LocalFile = "$Self->{Home}/$File->{Location}";
            if ( !-e $LocalFile ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "$Param{Name}-$Param{Version}: No such $LocalFile!"
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
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "$Param{Name}-$Param{Version}: $LocalFile is different!",
                        );
                        $Hit = 1;
                        $Self->{DeployCheckInfo}->{File}->{ $File->{Location} }
                            = 'File is different!';
                    }
                }
                else {
                    $Self->{LogObject}
                        ->Log( Priority => 'error', Message => "Can't read $LocalFile!" );
                }
            }
        }
        if ($Hit) {
            return;
        }
    }
    return 1;
}

=item DeployCheckInfo()

returns the info of the latest DeployCheck(), what's not deployed correctly

    my %Hash = $PackageObject->DeployCheckInfo();

=cut

sub DeployCheckInfo {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw()) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    if ( $Self->{DeployCheckInfo} ) {
        return %{ $Self->{DeployCheckInfo} };
    }
    else {
        return ();
    }
}

=item PackageBuild()

build a opm package

    my $Package = $PackageObject->PackageBuild(
        Name => {
            Content => 'SomePackageName',
        },
        Version => {
            Content => '1.0',
        },
        Vendor => {
            Content => 'OTRS GmbH',
        },
        URL => {
            Content => 'http://otrs.org/',
        },
        License => {
            Content => 'GNU GENERAL PUBLIC LICENSE Version 2, June 1991',
        }
        Description => [
            {
                Lang => 'en',
                Content => 'english description',
            },
            {
                Lang => 'de',
                Content => 'german description',
            },
        ],
        Filelist = [
            {
                Location => 'Kernel/System/Lala.pm'
                Permission => '644',
                Content => $FileInString,
            },
            {
                Location => 'Kernel/System/Lulu.pm'
                Permission => '644',
                Content => $FileInString,
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
    if ( !$Param{Type} ) {
        $XML .= '<?xml version="1.0" encoding="utf-8" ?>';
        $XML .= "\n";
        $XML .= '<otrs_package version="1.0">';
        $XML .= "\n";
    }
    for my $Tag (
        qw(Name Version Vendor URL License ChangeLog Description Framework OS
        IntroInstallPre IntroInstallPost IntroUninstallPre IntroUninstallPost
        IntroReinstallPre IntroReinstallPost IntroUpgradePre IntroUpgradePost
        PackageRequired CodeInstall CodeUpgrade CodeUninstall CodeReinstall)
        )
    {

        # dont use CodeInstall CodeUpgrade CodeUninstall CodeReinstall in index mode
        if ( $Param{Type} && $Tag =~ /(Code|Intro)(Install|Upgrade|Uninstall|Reinstall)/ ) {
            next;
        }
        if ( ref( $Param{$Tag} ) eq 'HASH' ) {
            my %OldParam = ();
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
        elsif ( ref( $Param{$Tag} ) eq 'ARRAY' ) {
            for ( @{ $Param{$Tag} } ) {
                my %Hash     = %{$_};
                my %OldParam = ();
                for (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                    $OldParam{$_} = $Hash{$_};
                    delete $Hash{$_};
                }
                $XML .= "    <$Tag";
                for ( keys %Hash ) {
                    $XML .= " $_=\"" . $Self->_Encode( $Hash{$_} ) . "\"";
                }
                $XML .= ">";
                $XML .= $Self->_Encode( $OldParam{Content} ) . "</$Tag>\n";
            }
        }
        else {

#            $XML .= "  <$Tag></$Tag>\n";
#            $Self->{LogObject}->Log(Priority => 'error', Message => "Invalid Ref data in tag $Tag!");
#            return;
        }
    }

    # dont use Build*, Filelist and Database* in index mode
    if ( $Param{Type} ) {
        return $XML;
    }
    $XML
        .= "    <BuildDate>"
        . $Self->{TimeObject}
        ->SystemTime2TimeStamp( SystemTime => $Self->{TimeObject}->SystemTime(), )
        . "</BuildDate>\n";
    $XML .= "    <BuildHost>" . $Self->{ConfigObject}->Get('FQDN') . "</BuildHost>\n";
    if ( $Param{Filelist} ) {
        $XML .= "    <Filelist>\n";
        for my $File ( @{ $Param{Filelist} } ) {
            my %OldParam = ();
            for (qw(Content Encode TagType Tag TagLevel TagCount TagKey TagLastLevel)) {
                $OldParam{$_} = $File->{$_} || '';
                delete $File->{$_};
            }

            $XML .= "        <File";
            for ( sort keys %{$File} ) {
                if ( $_ ne 'Tag' && $_ ne 'Content' && $_ ne 'TagType' && $_ ne 'Size' ) {
                    $XML .= " " . $Self->_Encode($_) . "=\"" . $Self->_Encode( $File->{$_} ) . "\"";
                }
            }
            $XML .= " Encode=\"Base64\">";
            my $FileContent = $Self->{MainObject}->FileRead(
                Location => $Home . '/' . $File->{Location},
                Mode     => 'binmode',
            );
            if ( !$FileContent ) {
                $Self->{MainObject}->Die("Can't open: $File->{Location}: $!");
            }
            $XML .= encode_base64( ${$FileContent}, '' );
            $XML .= "</File>\n";
        }
        $XML .= "    </Filelist>\n";
    }
    for (qw(DatabaseInstall DatabaseUpgrade DatabaseReinstall DatabaseUninstall)) {
        if ( $Param{$_} ) {
            my $Counter = 2;
            $XML .= "    <$_>\n";
            for my $Tag ( @{ $Param{$_} } ) {
                if ( $Tag->{TagType} eq 'Start' ) {
                    my $Space = '';
                    for ( 1 .. $Counter ) {
                        $Space .= '    ';
                    }
                    $Counter++;
                    $XML .= $Space . "<$Tag->{Tag}";
                    for ( sort keys %{$Tag} ) {
                        if (   $_ ne 'Tag'
                            && $_ ne 'Content'
                            && $_ ne 'TagType'
                            && $_ ne 'TagLevel'
                            && $_ ne 'TagCount'
                            && $_ ne 'TagKey'
                            && $_ ne 'TagLastLevel' )
                        {
                            if ( defined( $Tag->{$_} ) ) {
                                $XML
                                    .= " "
                                    . $Self->_Encode($_) . "=\""
                                    . $Self->_Encode( $Tag->{$_} ) . "\"";
                            }
                        }
                    }
                    $XML .= ">";
                    if ( $Tag->{TagLevel} <= 3 || $Tag->{Tag} =~ /(Foreign|Reference|Index)/ ) {
                        $XML .= "\n";
                    }
                }
                if (   defined( $Tag->{Content} )
                    && $Tag->{TagLevel} >= 4
                    && $Tag->{Tag} !~ /(Foreign|Reference|Index)/ )
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
            $XML .= "    </$_>\n";
        }
    }
    $XML .= '</otrs_package>';
    return $XML;
}

=item PackageParse()

parse a package

    my %Structure = $PackageObject->PackageParse(String => $FileString);

=cut

sub PackageParse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    my @XMLARRAY = $Self->{XMLObject}->XMLParse(%Param);

    # cleanup global vars
    undef $Self->{Package};

    # parse package
    my %PackageMap = %{ $Self->{PackageMap} };
    for my $Tag (@XMLARRAY) {
        if ( $Tag->{TagType} ne 'Start' ) {
            next;
        }
        if ( $PackageMap{ $Tag->{Tag} } && $PackageMap{ $Tag->{Tag} } eq 'SCALAR' ) {
            $Self->{Package}->{ $Tag->{Tag} } = $Tag;
        }
        elsif ( $PackageMap{ $Tag->{Tag} } && $PackageMap{ $Tag->{Tag} } eq 'ARRAY' ) {
            push( @{ $Self->{Package}->{ $Tag->{Tag} } }, $Tag );
        }
    }
    my $Open = 0;
    for my $Tag (@XMLARRAY) {
        if ( $Open && $Tag->{Tag} eq "Filelist" ) {
            $Open = 0;
        }
        elsif ( !$Open && $Tag->{Tag} eq "Filelist" ) {
            $Open = 1;
            next;
        }
        if ( $Open && $Tag->{TagType} eq 'Start' ) {

            # get attachment size
            {
                if ( $Tag->{Content} ) {
                    my $ContentPlain = 0;
                    if ( $Tag->{Encode} && $Tag->{Encode} eq 'Base64' ) {
                        $Tag->{Encode}  = '';
                        $Tag->{Content} = decode_base64( $Tag->{Content} );
                    }
                    use bytes;
                    $Tag->{Size} = length( $Tag->{Content} );
                    no bytes;
                }
            }
            push( @{ $Self->{Package}->{Filelist} }, $Tag );
        }
    }
    for (qw(DatabaseInstall DatabaseUpgrade DatabaseReinstall DatabaseUninstall)) {
        for my $Tag (@XMLARRAY) {
            if ( $Open && $Tag->{Tag} eq $_ ) {
                $Open = 0;
            }
            elsif ( !$Open && $Tag->{Tag} eq $_ ) {
                $Open = 1;
                next;
            }
            if ($Open) {
                push( @{ $Self->{Package}->{$_} }, $Tag );
            }
        }
    }

    # return package structur
    my %Return = %{ $Self->{Package} };
    undef $Self->{Package};
    return %Return;
}

=item PackageExport()

export files of an package

    $PackageObject->PackageExport(
        String => $FileString,
        Home => '/path/to/export'
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

    # install files
    if ( $Structure{Filelist} && ref( $Structure{Filelist} ) eq 'ARRAY' ) {
        for my $File ( @{ $Structure{Filelist} } ) {

            # install file
            $Self->_FileInstall( %{$File}, Home => $Param{Home} );
        }
    }
    return 1;
}

sub _Download {
    my ( $Self, %Param ) = @_;

    my $Content = '';

    # check needed stuff
    for (qw(URL)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # init agent
    my $UserAgent = LWP::UserAgent->new();

    # set timeout
    $UserAgent->timeout( $Self->{ConfigObject}->Get('Package::Timeout') || 15 );

    # set user agent
    $UserAgent->agent(
        $Self->{ConfigObject}->Get('Product') . ' ' . $Self->{ConfigObject}->Get('Version') );

    # set proxy
    if ( $Self->{ConfigObject}->Get('Package::Proxy') ) {
        $UserAgent->proxy( [ 'http', 'ftp' ], $Self->{ConfigObject}->Get('Package::Proxy') );
    }

    # get file
    my $Response = $UserAgent->get( $Param{URL} );
    if ( $Response->is_success() ) {
        return $Response->content();
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't get file from $Param{URL}: " . $Response->status_line(),
        );
        return;
    }
}

sub _FileInstall {
    my ( $Self, %Param ) = @_;

    my $Home = $Param{Home} || $Self->{Home};

    # check needed stuff
    for (qw(Location Content Permission)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check Home
    if ( !-e $Home ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }
    my $RealFile = "$Home/$Param{Location}";

    # backup old file (if reinstall, don't overwrite .backup an .save files)
    if ( -e $RealFile ) {
        if ( $Param{Type} && $Param{Type} =~ /^replace$/i ) {
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
                    Location => $Home . '/' . $Param{Location},
                    Mode     => 'binmode',
                );
                if ( $Content && ${$Content} ne $Param{Content} ) {

                    # check if it's framework file
                    $RealFile =~ s/\/\///g;
                    my %File = $Self->_ReadDistArchive();
                    if ( $File{$RealFile} ) {
                        $Save = 1;
                    }
                }
            }
            if ( !$Param{Reinstall} || ( $Param{Reinstall} && $Save ) ) {
                move( $RealFile, "$RealFile.save" );
            }
        }
    }

    # check directory of loaction (in case create a directory)
    if ( $Param{Location} =~ /^(.*)\/(.+?|)$/ ) {
        my $Directory        = $1;
        my @Directories      = split( /\//, $Directory );
        my $DirectoryCurrent = $Home;
        for (@Directories) {
            $DirectoryCurrent .= "/$_";
            if ( !-d $DirectoryCurrent ) {
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
    }

    # write file
    if ($Self->{MainObject}->FileWrite(
            Location   => $Home . '/' . $Param{Location},
            Content    => \$Param{Content},
            Mode       => 'binmode',
            Permission => $Param{Permission},
        )
        )
    {
        print STDERR "Notice: Install $Param{Location} ($Param{Permission})!\n";
    }
    return 1;
}

sub _FileRemove {
    my ( $Self, %Param ) = @_;

    my $Home = $Param{Home} || $Self->{Home};

    # check needed stuff
    for (qw(Location)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check Home
    if ( !-e $Home ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }
    my $RealFile = "$Home/$Param{Location}";

    # check if file exists
    if ( -e $RealFile ) {

        # check if we should backup this file, if it is touched/different
        if ( $Param{Content} ) {
            my $Content = $Self->{MainObject}->FileRead(
                Location => $Home . '/' . $Param{Location},
                Mode     => 'binmode',
            );
            if ( $Content && ${$Content} ne $Param{Content} ) {
                print STDERR "Notice: Backup for changed file: $RealFile.backup\n";
                copy( $RealFile, "$RealFile.custom_backup" );
            }
        }

        # remove old file
        if ( $Self->{MainObject}->FileDelete( Location => $Home . '/' . $Param{Location} ) ) {
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
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't remove file $RealFile: $!!",
            );
            return;
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such file: $RealFile!",
        );
        return;
    }
}

sub _ReadDistArchive {
    my ( $Self, %Param ) = @_;

    my %File = ();
    my $Home = $Param{Home} || $Self->{Home};
    if ( -e "$Home/ARCHIVE" ) {
        my $Content = $Self->{MainObject}->FileRead(
            Directory => $Home,
            Filename  => 'ARCHIVE',
            Result    => 'ARRAY',
        );
        if ($Content) {
            for ( @{$Content} ) {
                my @Row = split( /::/, $_ );
                $Row[1] =~ s/\/\///g;
                $File{ $Row[1] } = $Row[0];
            }
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't open $Home/ARCHIVE: $!",
            );
        }
    }
    return %File;
}

sub _FileSystemCheck {
    my ( $Self, %Param ) = @_;

    my $Home = $Param{Home} || $Self->{Home};

    # check needed stuff
    for (qw()) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }

    # check Home
    if ( !-e $Home ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such home directory: $Home!",
        );
        return;
    }
    for (qw(/bin/ /Kernel/ /Kernel/System/ /Kernel/Output/ /Kernel/Output/HTML/ /Kernel/Modules/)) {
        my $Directory = "$Home/$_";
        my $Filename  = "check_permissons.$$";
        my $FH;
        my $Content = 'test';
        if ($Self->{MainObject}->FileWrite(
                Location => $Directory . '/' . $Filename,
                Content  => \$Content,
            )
            )
        {
            $Self->{MainObject}->FileDelete( Location => $Directory . '/' . $Filename );
        }
        else {
            return;
        }
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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.72 $ $Date: 2007-10-05 09:25:07 $

=cut
