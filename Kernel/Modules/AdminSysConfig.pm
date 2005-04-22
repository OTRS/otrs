# --
# Kernel/Modules/AdminSysConfig.pm - to change ConfigParameter
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSysConfig.pm,v 1.9 2005-04-22 14:27:15 rk Exp $
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
$VERSION = '$Revision: 1.9 $';
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
        my $Group = $Self->{ParamObject}->GetParam(Param => 'SysConfigGroup');
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(Group => $Group, SubGroup => $SubGroup);
        # list all Items
        foreach (@List) {
            # Get all Attributes from Item
            my %ItemHash = $Self->{SysConfigObject}->ConfigItemGet(Name => $_);
            # Get ElementAktiv (checkbox)
            my $Aktiv = 0;
            if (($ItemHash{Required} && $ItemHash{Required} == 1) || $Self->{ParamObject}->GetParam(Param => $_.'ItemAktiv') == 1) {
                $Aktiv = 1;
            }
            # ConfigElement String
            if (defined ($ItemHash{Setting}[1]{String})) {
                # Get Value (Content)
                my $Content = $Self->{ParamObject}->GetParam(Param => $_);
                # Regex check
                if (defined ($ItemHash{Setting}[1]{String}[1]{Regex}) && $ItemHash{Setting}[1]{String}[1]{Regex} != "" && !($Content =~ /$ItemHash{Setting}[1]{String}[1]{Regex}/)) {
                    $InvalidValue{$_} = 1;              
                }
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => $Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            # ConfigElement TextArea
            if (defined ($ItemHash{Setting}[1]{TextArea})) {
                # Get Value (Content)
                my $Content = $Self->{ParamObject}->GetParam(Param => $_);
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => $Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            # ConfigElement PulldownMenue
            elsif (defined ($ItemHash{Setting}[1]{Option})) {
                my $Content = $Self->{ParamObject}->GetParam(Param => $_);
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => $Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            # ConfigElement Hash
            elsif (defined ($ItemHash{Setting}[1]{Hash})) {
                my @Keys   = $Self->{ParamObject}->GetArray(Param => $_.'Key[]');
                my @Values = $Self->{ParamObject}->GetArray(Param => $_.'Content[]');
                my %Content;
                foreach my $Index (0...$#Keys) {
                    # Delete Hash Element?
                    if (!$Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#DeleteHashElement'.($Index+1))) {
                        $Content{$Keys[$Index]} = $Values[$Index];
                    }
                }
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => \%Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            # ConfigElement Array
            elsif (defined ($ItemHash{Setting}[1]{Array})) {
                my @Content = $Self->{ParamObject}->GetArray(Param => $_.'Content[]');
                #Delete Array Element
                foreach my $Index (0...$#Content) {
                    if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#DeleteArrayElement'.($Index+1))) {
                        splice(@Content,$Index,1);
                    }
                }
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => \@Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            # ConfigElement TimeVacationDaysOneTime
            elsif (defined ($ItemHash{Setting}[1]{TimeVacationDaysOneTime})) {
                my @Year   = $Self->{ParamObject}->GetArray(Param => $_.'year[]');
                my @Month  = $Self->{ParamObject}->GetArray(Param => $_.'month[]');
                my @Day    = $Self->{ParamObject}->GetArray(Param => $_.'day[]');
                my @Values = $Self->{ParamObject}->GetArray(Param => $_.'Content[]');
                my %Content;
                foreach my $Index (0...@Year) {
                    # Delete TimeVacationDaysOneTime Element?
                    if (!$Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#DeleteTimeVacationDaysOneTimeElement'.$Index)) {
                        $Content{$Year[$Index]}{$Month[$Index]}{$Day[$Index]} = $Values[$Index];
                    }
                }
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => \%Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }            
            }
            # ConfigElement TimeVacationDays
            elsif (defined ($ItemHash{Setting}[1]{TimeVacationDays})) {
                my @Month  = $Self->{ParamObject}->GetArray(Param => $_.'month[]');
                my @Day    = $Self->{ParamObject}->GetArray(Param => $_.'day[]');
                my @Values = $Self->{ParamObject}->GetArray(Param => $_.'Content[]');
                my %Content;
                foreach my $Index (0...@Month) {
                    # Delete TimeVacationDays Element?
                    if (!$Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#DeleteTimeVacationDaysElement'.$Index)) {
                        $Content{$Month[$Index]}{$Day[$Index]} = $Values[$Index];;
                    }
                }
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => \%Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }            
            }
            # ConfigElement TimeWorkingHours
            elsif (defined ($ItemHash{Setting}[1]{TimeWorkingHours})) {
                my %Content;
                foreach my $Index (1...$#{$ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}}) {
                    my $Weekday = $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Name};
                    my @Hours   = $Self->{ParamObject}->GetArray(Param => $_.$Weekday.'[]');
                    $Content{$Weekday} = \@Hours;
                }
                # write ConfigItem
                if (!$Self->{SysConfigObject}->ConfigItemUpdate(Key => $_, Value => \%Content, Valid => $Aktiv)) {
                    $Self->{LayoutObject}->FatalError(Message => "Can't write ConfigItem!");
                }
            }
            
        }
        $Self->{Subaction} = 'Edit';
    }
    # edit config
    if ($Self->{Subaction} eq 'Edit') {
        my $SubGroup = $Self->{ParamObject}->GetParam(Param => 'SysConfigSubGroup');
        my $Group = $Self->{ParamObject}->GetParam(Param => 'SysConfigGroup');
        my @List = $Self->{SysConfigObject}->ConfigSubGroupConfigItemList(Group => $Group, SubGroup => $SubGroup);
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
                    ItemKey     => $_,
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
        $Data{Group} = $Group;
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
                ElementKey => $ItemHash{Name},
                Content    => $ItemHash{Setting}[1]{String}[1]{Content},
                Valid      => $Valid,   
            },
        );
    }
    # ConfigElement TextArea
    if (defined ($ItemHash{Setting}[1]{TextArea})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTextArea',
            Data => {
                ElementKey => $ItemHash{Name},
                Content    => $ItemHash{Setting}[1]{TextArea}[1]{Content},
                Valid      => $Valid,   
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
            Name       => $ItemHash{Name},
        );
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementSelect',
            Data => {
                Item        => $ItemHash{Name},
                Liste       => $PulldownMenue, 
            },
        );
    }
    # ConfigElement Hash
    elsif (defined ($ItemHash{Setting}[1]{Hash})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementHash',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );
        # New HashElement
        if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#NewHashElement')) {
            push (@{$ItemHash{Setting}[1]{Hash}[1]{Item}}, {Key => '', Content => ''});
        }      
        # Hashelements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{Hash}[1]{Item}}) {
            #SubHash
            if (defined($ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash})) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent2',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Content    => '##SubHash##',
                        Index      => $Index,
                    },
                );
                # New SubHashElement
                if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#HashElement'.$Index.'#NewSubElement')) {
                    push (@{$ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item}}, {Key => '', Content => ''});
                }      
                # SubHashElements
                foreach my $Index2 (1...$#{$ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item}}) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementSubHashContent',
                        Data => {
                            ElementKey => $ItemHash{Name},
                            Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item}[$Index2]{Key},
                            Content    => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Hash}[1]{Item}[$Index2]{Content},
                            Index      => $Index,
                            Index2     => $Index2,
                        },
                    );
                }
            }
            #SubArray
            elsif (defined($ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array})) {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent2',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Content    => '##SubHash##',
                        Index      => $Index,
                    },
                );
                # New SubArrayElement
                if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#HashElement'.$Index.'#NewSubElement')) {
                    push (@{$ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array}[1]{Item}}, {Content => ''});
                }      
                # SubArrayElements                
                foreach my $Index2 (1...$#{$ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array}[1]{Item}}) {
                    $Self->{LayoutObject}->Block(
                        Name => 'ConfigElementSubArrayContent',
                        Data => {
                            ElementKey => $ItemHash{Name},
                            Content    => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Array}[1]{Item}[$Index2]{Content},
                            Index      => $Index,
                            Index2     => $Index2,
                        },
                    );
                }                
            }
            #SubOption
            elsif (defined($ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option})) {
                # Pulldownmenue
                my %Hash;
                foreach my $Index2 (1...$#{$ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{Item}}) {
                    $Hash{$ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{Item}[$Index2]{Key}} = $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{Item}[$Index2]{Content};
                }
                my $PulldownMenue = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data       => \%Hash,
                    SelectedID => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Option}[1]{SelectedID},
                    Name       => $ItemHash{Name},
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent3',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Liste       => $PulldownMenue, 
                        Index      => $Index,
                    },
                );
            }            
            # StandardElement
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementHashContent',
                    Data => {
                        ElementKey => $ItemHash{Name},
                        Key        => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Key},
                        Content    => $ItemHash{Setting}[1]{Hash}[1]{Item}[$Index]{Content},
                        Index      => $Index,
                    },
                );            
            }           
        }               
    }
    # ConfigElement Array
    elsif (defined ($ItemHash{Setting}[1]{Array})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementArray',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );
        # New ArrayElement
        if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#NewArrayElement')) {
            push (@{$ItemHash{Setting}[1]{Array}[1]{Item}}, {Content => ''});
        }
        # Arrayelements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{Array}[1]{Item}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementArrayContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Content    => $ItemHash{Setting}[1]{Array}[1]{Item}[$Index]{Content},
                    Index      => $Index,
                },
            );
        }               
    }
    # ConfigElement FrontendModuleReg
    if (defined ($ItemHash{Setting}[1]{FrontendModuleReg})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementFrontendModuleReg',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );
        
        
        
        # NavBar
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{FrontendModuleReg}[1]{NavBar}}) {
        $Self->{LogObject}->Dumper(jkl => $ItemHash{Setting}[1]{FrontendModuleReg});
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementFrontendModuleRegContentNavBar',
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
    # ConfigElement TimeVacationDaysOneTime
    if (defined ($ItemHash{Setting}[1]{TimeVacationDaysOneTime})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeVacationDaysOneTime',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );
        # New TimeVacationDaysOneTimeElement
        if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#NewTimeVacationDaysOneTimeElement')) {
            push (@{$ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}}, {Key => '', Content => ''});
        }      
        # TimeVacationDaysOneTimeelements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeVacationDaysOneTimeContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Year       => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Year},
                    Month      => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Month},
                    Day        => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Day},
                    Content    => $ItemHash{Setting}[1]{TimeVacationDaysOneTime}[1]{Item}[$Index]{Content},                  
                    Index      => $Index,
                },
            );           
        }
    }
    # ConfigElement TimeVacationDays
    if (defined ($ItemHash{Setting}[1]{TimeVacationDays})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeVacationDays',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );
        # New TimeVacationDaysElement
        if ($Self->{ParamObject}->GetParam(Param => $ItemHash{Name}.'#NewTimeVacationDaysElement')) {
            push (@{$ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}}, {Key => '', Content => ''});
        }      
        # TimeVacationDaysElements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeVacationDaysContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Month      => $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Month},
                    Day        => $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Day},
                    Content    => $ItemHash{Setting}[1]{TimeVacationDays}[1]{Item}[$Index]{Content},                  
                    Index      => $Index,
                },
            );           
        }
    }
    # ConfigElement TimeWorkingHours
    if (defined ($ItemHash{Setting}[1]{TimeWorkingHours})) {
        $Self->{LayoutObject}->Block(
            Name => 'ConfigElementTimeWorkingHours',
            Data => {
                ElementKey => $ItemHash{Name},
            },
        );
        # TimeWorkingHoursElements
        foreach my $Index (1...$#{$ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}}) {
            $Self->{LayoutObject}->Block(
                Name => 'ConfigElementTimeWorkingHoursContent',
                Data => {
                    ElementKey => $ItemHash{Name},
                    Weekday    => $ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Name},
                    Index      => $Index,
                },
            );
            # Hours
            my @ArrayHours = ('','','','','','','','','','','','','','','','','','','','','','','','','');
            # Aktiv Hours
            if (defined($ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Hour})) {
                foreach my $Index2 (1...$#{$ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Hour}}) {
                    $ArrayHours[$ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Hour}[$Index2]{Content}] = 'checked';
                }            
            }
            foreach my $Z (1...24) {                
                $Self->{LayoutObject}->Block(
                    Name => 'ConfigElementTimeWorkingHoursHours',
                    Data => {
                        ElementKey => $ItemHash{Name}.$ItemHash{Setting}[1]{TimeWorkingHours}[1]{Day}[$Index]{Name},
                        Hour       => $Z,
                        Aktiv      => $ArrayHours[$Z],
                    },
                );
            }          
        }
        
        
    }
    
}

# --
1;