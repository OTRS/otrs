    # --
# Kernel/Modules/AdminSysConfig.pm - to change ConfigParameter
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSysConfig.pm,v 1.4 2005-04-19 08:30:46 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSysConfig;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";

use strict;
use Kernel::System::Config;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{SysConfigObject} = Kernel::System::Config->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my %Data;
    my $Group = "";
    my %InvalidValue;
    
    $Data{Search} = $Self->{ParamObject}->GetParam(Param => 'Search');
    # update config
    if ($Self->{Subaction} eq 'Update') {
        my $SubGroup = $Self->{ParamObject}->GetParam(Param => 'SysConfigSubGroup');
        my %List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(Name => $SubGroup);
        # list all Items
        foreach (keys %List) {
            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet(Name => $_);
            # ConfigElement String
            if (defined ($ItemHash{Setting}[1]{String})) {
                my $Content = $Self->{ParamObject}->GetParam(Param => $_);
                # Regex check
                if (defined ($ItemHash{Setting}[1]{String}[1]{Regex}) && !($Content =~ /$ItemHash{Setting}[1]{String}[1]{Regex}/)) {
                    $InvalidValue{$_} = 1;              
                }
                # write ConfigItem
                if (!$Self->{ConfigObject}->Set(Key => $_, Value => $Content)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            # ConfigElement PulldownMenue
            elsif (defined ($ItemHash{Setting}[1]{Option})) {
                my $Content = $Self->{ParamObject}->GetParam(Param => $_);
                # write ConfigItem
                if (!$Self->{ConfigObject}->Set(Key => $_, Value => $Content)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }

        }
        
        # Create Config
        $Self->{SysConfigObject}->CreateConfig();
        $Self->{Subaction} = 'Edit';
    }
    # edit config
    if ($Self->{Subaction} eq 'Edit') {
        my $SubGroup = $Self->{ParamObject}->GetParam(Param => 'SysConfigSubGroup');
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(Name => $SubGroup);
        #Language
        my $UserLang = $Self->{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage');     
        # list all Items
        foreach (@List) {
            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet(Name => $_);
            # Required
            my $Required = '';
            if ($ItemHash{Required} && $ItemHash{Required} == 1) {
                $Required = 'disabled';
            }
            # Valid
            my $Valid = '';
            my $Validstyle = 'passiv';
            if ($ItemHash{Valid} && $ItemHash{Valid} == 1) {
                $Valid = 'checked';
                $Validstyle = '';
            }
            #Description
            my %HashLang;
            foreach my $Index (1...$#{$ItemHash{Description}}) {
                $HashLang{$ItemHash{Description}[$Index]{Lang}} = $ItemHash{Description}[$Index]{Content};
            }
            my $Description;
            # Description in User Language
            if (defined $HashLang{$UserLang}) {
                $Description = $HashLang{$UserLang};
            }
            # Description in Default Language
            else {
                $Description = $HashLang{'en'};
            }
            
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementBlock',
                Data => {
                    Item        => $_,
                    Description => $Description,
                    Valid       => $Valid,
                    Validstyle  => $Validstyle,
                    Required    => $Required,
                },
            );

            # ListConfigItem
            $Self->ListConfigItem(Hash => \%ItemHash, InvalidValue => \%InvalidValue);
        }
        $Data{SubGroup} = $SubGroup;
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'SysConfig');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminSysConfigEdit', Data => \%Data);   
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # search config
    elsif ($Self->{Subaction} eq 'Search') {
    
    }
    # list subgroups
    elsif ($Self->{Subaction} eq 'SelectGroup') {
        $Group = $Self->{ParamObject}->GetParam(Param => 'SysConfigGroup');
        my %List = $Self->{SysConfigObject}->ConfigSubGroupList(Name => $Group);
        foreach (sort keys %List) {
            $Self->{LayoutObject}->Block(
                Name  => 'Row',
                Data  => {
                    SubGroup => $List{$_},
                    Group    => $Group,
                },
            );
        }
    }

    # SessionScreen
    if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    )) {
        return $Self->{LayoutObject}->ErrorScreen();
    }
    
    # list Groups
    my %List = $Self->{SysConfigObject}->ConfigGroupList();
    # create select Box
    $Data{Liste} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data     => \%List,
        Selected => $Group,
        Name     => 'SysConfigGroup',
    );
  
    $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'SysConfig');
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminSysConfig', Data => \%Data);
    $Output .= $Self->{LayoutObject}->Footer();    
    return $Output;
}


sub ListConfigItem {
    my $Self = shift;
    my %Param = @_;
    my %ItemHash    = %{$Param{Hash}};
    my %InvalidValue = %{$Param{InvalidValue}};
    my $Valid = '';

    # ConfigElement String
    if (defined ($ItemHash{Setting}[1]{String})) {
        if (defined ($InvalidValue{$_})) {
            $Valid = 'Invalid Value!';
        }
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementString',
            Data => {
                Item    => $_,
                Content => $ItemHash{Setting}[1]{String}[1]{Content},
                Valid   => $Valid,   
            },
        );
    }
    # ConfigElement TextArea
    if (defined ($ItemHash{Setting}[1]{TextArea})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTextArea',
            Data => {
                Item    => $_,
                Content => $ItemHash{Setting}[1]{TextArea}[1]{Content},
                Valid   => $Valid,   
            },
        );
    }    
    # ConfigElement PulldownMenue
    elsif (defined ($ItemHash{Setting}[1]{Option})) {
        my %Hash;
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{Option}[1]{Item}}) {
            $Hash{$ItemHash{Setting}[1]{Option}[1]{Item}[$Index]{Key}} = $ItemHash{Setting}[1]{Option}[1]{Item}[$Index]{Content};
        }
        my $PulldownMenue = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => \%Hash,
            SelectedID => $ItemHash{Setting}[1]{Option}[1]{SelectedID},
            Name       => $_,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementSelect',
            Data => {
                Item        => $_, 
                Liste       => $PulldownMenue, 
            },
        );
    }
    # ConfigElement Hash
    elsif (defined ($ItemHash{Setting}[1]{Hash})) {
        my %Hash;
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementHash',
            Data => {
                Item        => $_, 
            },
        );
        # Hashelements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{Hash}[1]{Item}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementHashContent',
                Data => {
                    Key     => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                    Content => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Content},
                },
            );                
        }               
    }
    # ConfigElement Array
    elsif (defined ($ItemHash{Setting}[1]{Array})) {
        my %Hash;
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementArray',
            Data => {
                Item        => $_, 
            },
        );
        # Arrayelements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{Array}[1]{Item}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementArrayContent',
                Data => {
                    Content => $ItemHash{Setting}[1]{Array}[1]{Item}[$Index]{Content},
                },
            );                
        }               
    }
    # ConfigElement FrontendModuleReg
    if (defined ($ItemHash{Setting}[1]{FrontendModuleReg})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementFrontendModuleReg',
            Data => {
                Item        => $_,
            },
        );
        # NavBar
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContent',
                Data => {
                    Item        => $_,
                    Key         => $_,
                    Content     => $ItemHash{Setting}[1]{String}[1]{Content},
                },
            );
            # Array Element Group
            foreach my $ArrayElement qw(Group GroupRo) {
                foreach my $Index (1...$#{$ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}[$Index]{$ArrayElement}}) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementFrontendModuleRegContent'.$ArrayElement,
                        Data => {
                            Item        => $_,
                            Key         => $_,
                        },
                    );
                }
            }
        }
        # NavBarModule
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBarModule}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContentNavBarModule',
                Data => {
                    Item        => $_,
                    Key         => $_,
                    Content     => $ItemHash{Setting}[1]{String}[1]{Content},
                },
            );
        }
    }
}

# --
1;