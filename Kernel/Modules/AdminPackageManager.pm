# --
# Kernel/Modules/AdminPackageManager.pm - manage software packages
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminPackageManager.pm,v 1.10 2004-12-06 22:56:32 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPackageManager;

use strict;
use Kernel::System::Package;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{PackageObject} = Kernel::System::Package->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Source = $Self->{UserRepository} || '';
    # ------------------------------------------------------------ #
    # view package
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'View') {
        my $Name = $Self->{ParamObject}->GetParam(Param => 'Name') || '';
        my $Version = $Self->{ParamObject}->GetParam(Param => 'Version') || '';
        my %Frontend = ();
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name => $Name,
            Version => $Version,
        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        $Self->{LayoutObject}->Block(
            Name => 'Package',
            Data => { %Param, %Frontend, Name => $Name, Version => $Version, },
        );
        my %Structur = $Self->{PackageObject}->PackageParse(String => $Package);

        foreach my $Key (sort keys %Structur) {
            if (ref($Structur{$Key}) eq 'HASH') {
                $Self->{LayoutObject}->Block(
                    Name => 'PackageItem',
                    Data => {Tag => $Key, %{$Structur{$Key}}},
                );
            }
            elsif (ref($Structur{$Key}) eq 'ARRAY') {
                foreach my $Hash (@{$Structur{$Key}}) {
                    $Self->{LayoutObject}->Block(
                        Name => "PackageItem$Key",
                        Data => {Tag => $Key, %{$Hash}},
                    );
                }
            }
        }
        my $Output = $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Package Manager');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminPackageManager', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ------------------------------------------------------------ #
    # download package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Download') {
        my $Name = $Self->{ParamObject}->GetParam(Param => 'Name') || '';
        my $Version = $Self->{ParamObject}->GetParam(Param => 'Version') || '';
        my %Frontend = ();
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name => $Name,
            Version => $Version,
        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            return $Self->{LayoutObject}->Attachment(
                Content => $Package,
                ContentType => 'plain/xml',
                Filename => "$Name-$Version.opm",
                Type => 'attachment',
            );
        }
    }
    # ------------------------------------------------------------ #
    # change repository
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'ChangeRepository') {
        my $Source = $Self->{ParamObject}->GetParam(Param => 'Source') || '';
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'UserRepository',
            Value => $Source,
        );
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
    }
    # ------------------------------------------------------------ #
    # install package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Install') {
        my $Name = $Self->{ParamObject}->GetParam(Param => 'Name') || '';
        my $Version = $Self->{ParamObject}->GetParam(Param => 'Version') || '';
        my %Frontend = ();
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name => $Name,
            Version => $Version,
        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            if ($Self->{PackageObject}->PackageInstall(String => $Package)) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
    }
    # ------------------------------------------------------------ #
    # install remote package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'InstallRemote') {
        my $File = $Self->{ParamObject}->GetParam(Param => 'File') || '';
        my %Frontend = ();
        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            Source => $Source,
            File => $File,
        );
        # check
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            if ($Self->{PackageObject}->PackageInstall(String => $Package)) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
    }
    # ------------------------------------------------------------ #
    # upgrade remote package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'UpgradeRemote') {
        my $File = $Self->{ParamObject}->GetParam(Param => 'File') || '';
        my %Frontend = ();
        # download package
        my $Package = $Self->{PackageObject}->PackageOnlineGet(
            File => $File,
            Source => $Source,
        );
        # check
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        # get package
#        $Package = $Self->{PackageObject}->RepositoryGet(
#            Name => $Name,
#            Version => $Version,
#        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            if ($Self->{PackageObject}->PackageUpgrade(String => $Package)) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
    }
    # ------------------------------------------------------------ #
    # uninstall package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Uninstall') {
        my $Name = $Self->{ParamObject}->GetParam(Param => 'Name') || '';
        my $Version = $Self->{ParamObject}->GetParam(Param => 'Version') || '';
        my %Frontend = ();
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name => $Name,
            Version => $Version,
        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Uninstall',
                Data => {
                    %Param,
                    Name => $Name,
                    Version => $Version,
                },
            );
            my $Output = $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Package Manager');
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminPackageManager', Data => \%Param);
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # ------------------------------------------------------------ #
    # uninstall action package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'UninstallAction') {
        my $Name = $Self->{ParamObject}->GetParam(Param => 'Name') || '';
        my $Version = $Self->{ParamObject}->GetParam(Param => 'Version') || '';
        my %Frontend = ();
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name => $Name,
            Version => $Version,
        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            if ($Self->{PackageObject}->PackageUninstall(String => $Package)) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
    }
    # ------------------------------------------------------------ #
    # install package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'InstallPackage') {
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => "file_upload",
            Source => 'string',
        );
        if (!%UploadStuff) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'Need File');
        }
        else {
            if ($Self->{PackageObject}->PackageInstall(String => $UploadStuff{Content})) {
                return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
            }
            else {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
    }
    # ------------------------------------------------------------ #
    # rebuild package
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'RebuildPackage') {
        my $Name = $Self->{ParamObject}->GetParam(Param => 'Name') || '';
        my $Version = $Self->{ParamObject}->GetParam(Param => 'Version') || '';
        my %Frontend = ();
        my $Package = $Self->{PackageObject}->RepositoryGet(
            Name => $Name,
            Version => $Version,
        );
        if (!$Package) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'No such package!');
        }
        else {
            my %Structur = $Self->{PackageObject}->PackageParse(
                String => $Package,
            );
            my $File = $Self->{PackageObject}->PackageBuild(%Structur);
            return $Self->{LayoutObject}->Attachment(
                Content => $File,
                ContentType => 'plain/xml',
                Filename => "$Name-$Version.opm",
                Type => 'attachment',
            );
        }
    }
    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my %Frontend = ();
        $Frontend{'SourceList'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('Package::RepositoryList'),
            Name => 'Source',
            SelectedID => $Source,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, %Frontend, },
        );
        if ($Source) {
            my @List = $Self->{PackageObject}->PackageOnlineList(URL => $Source, Lang => $Self->{UserLanguage});
            foreach my $Data (@List) {
                $Self->{LayoutObject}->Block(
                    Name => 'ShowRemotePackage',
                    Data => {
                        %{$Data},
                        Source => $Source,
                    },
                );
                if ($Data->{Upgrade}) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ShowRemotePackageUpgrade',
                        Data => {
                            %{$Data},
                            Source => $Source,
                        },
                    );
                }
                elsif (!$Data->{Installed}) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ShowRemotePackageInstall',
                        Data => {
                            %{$Data},
                            Source => $Source,
                        },
                    );
                }
            }
        }

        foreach my $Package ($Self->{PackageObject}->RepositoryList()) {
            my $Description = '';
            foreach my $Tag (@{$Package->{Description}}) {
                # just use start tags
                if ($Tag->{TagType} ne 'Start') {
                    next;
                }
                if ($Tag->{Tag} eq 'Description') {
                    if (!$Description) {
                        $Description = $Tag->{Content};
                    }
                    if ($Tag->{Lang} eq $Self->{UserLanguage}) {
                        $Description = $Tag->{Content};
                    }
                }
            }

            $Self->{LayoutObject}->Block(
                Name => 'ShowLocalPackage',
                Data => { %{$Package},
                    Name => $Package->{Name}->{Content},
                    Version => $Package->{Version}->{Content},
                    Vendor => $Package->{Vendor}->{Content},
                    URL => $Package->{URL}->{Content},
                    Description => $Description,
                },
            );
            if ($Package->{Status} eq 'installed') {
                $Self->{LayoutObject}->Block(
                    Name => 'ShowLocalPackageUninstall',
                    Data => { %{$Package},
                        Name => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                        Vendor => $Package->{Vendor}->{Content},
                        URL => $Package->{URL}->{Content},
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ShowLocalPackageInstall',
                    Data => { %{$Package},
                        Name => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                        Vendor => $Package->{Vendor}->{Content},
                        URL => $Package->{URL}->{Content},
                    },
                );
            }
        }
        my $Output = $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Package Manager');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminPackageManager', Data => \%Param);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
1;
