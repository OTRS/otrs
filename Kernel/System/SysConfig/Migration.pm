# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SysConfig::Migration;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

use Kernel::System::VariableCheck qw( :all );

=head1 NAME

Kernel::System::SysConfig::Migration - System configuration settings migration tools.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigMigrationObject = $Kernel::OM->Get('Kernel::System::SysConfig::Migration');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 MigrateXMLStructure()

Migrate XML file content from OTRS 5 to OTRS 6.

    my $Result = $SysConfigMigrationObject->MigrateXMLStructure(
        Content => '
            <?xml version="1.0" encoding="utf-8" ?>
            <otrs_config version="1.0" init="Framework">
                ...
            </otrs_config>',
        Name => 'Framework',
    );

Returns:

    $Result = '
        <?xml version="1.0" encoding="utf-8" ?>
        <otrs_config version="2.0" init="Framework">
            ...
        </otrs_config>';

=cut

sub MigrateXMLStructure {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Content Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Init = "";
    if ( $Param{Content} =~ m{<otrs_config.*?init="(.*?)"} ) {
        $Init = $1;
    }

    # Stop if we don't have Init (configuration xml file is corrupt or invalid).
    return if !$Init;

    # Stop if its a configuration file is not from OTRS 5 or prior (OTRS 6 uses version 2.0).
    return if !$Param{Content} =~ m{^<otrs_config.*?version="1.0"}gsmx;

    # Split settings - prevent deleting some settings due to greedy RegEx. Each array item contains
    #   only one setting.
    my @Settings = split( "</ConfigItem>", $Param{Content} );

    my %InitToLoaderMapping = (
        Framework   => '001-',
        Application => '002-',
        Config      => '003-',
        Changes     => '004-',
    );

    my %NavigationLookup = $Self->NavigationLookupGet();

    for my $Setting (@Settings) {

        # Update version (from 1.0 to 2.0).
        $Setting =~ s{^(<otrs_config.*?version)="1.0"}{$1="2.0"}gsmx;
        $Setting .= "</ConfigItem>";

        # Update to preferences group
        if ( $Setting =~ m{PreferencesGroups###} && $Setting =~ m{<Item Key="Column">} ) {
            $Setting =~ s{<Item\s+Key="Column">}{<Item Key="PreferenceGroup">}gsmx;
        }

        # Check if FrontendModuleReg.
        if ( $Setting =~ m{<FrontendModuleReg>} ) {

            # Extract Loader and delete.
            my $Loader;
            if ( $Setting =~ s{\s+<Loader>(.*?)</Loader>$}{}gsmx ) {
                $Loader = $1;
            }

            # Extract NavBar and delete
            my $NavBar;

            if ( $Setting =~ s{\s+<NavBar>(.*)</NavBar>$}{}gsmx ) {
                $NavBar = "<NavBar>\n$1</NavBar>\n";
            }

            # Extract NavBarModule and delete
            my $NavBarModule;
            if ( $Setting =~ s{\s+<NavBarModule>(.*?)</NavBarModule>$}{}gsmx ) {
                $NavBarModule = $1;
            }

            # Extract FrontendModuleReg and delete.
            $Setting =~ s{<FrontendModuleReg>(.*?)</FrontendModuleReg>}{}gsmx;
            my $FrontendModuleReg = $1;

            # Split on new line.
            my @Lines = split( "\n", $FrontendModuleReg );

            LINE:
            for my $Line (@Lines) {

                my $Tag;

                # Extract tag name.
                if ( $Line =~ m{</(.*?)>} ) {
                    $Tag = $1;
                }

                next LINE if !$Tag;

                # Create Item to replace $Tag.
                $Line =~ s{<$Tag(.*?)</$Tag>}{<Item Key="$Tag"$1</Item>}gsmx;
            }

            $FrontendModuleReg = join( "\n", @Lines );

            my %GroupItems;

            @Lines = split( "\n", $FrontendModuleReg );
            my @OutputLines;

            LINE:
            for my $Line (@Lines) {
                next LINE if !$Line;

                $Line =~ m{Item Key="(.*?)"};
                my $ItemKey = $1 || '';

                if ( $ItemKey eq 'Group' || $ItemKey eq 'GroupRo' ) {
                    $Line =~ m{<Item.*?>(.*?)</Item>}gsmg;
                    my $Value = $1;

                    if ( $GroupItems{$ItemKey} ) {
                        push @{ $GroupItems{$ItemKey} }, $Value;

                        # Skip this line.
                        next LINE;
                    }
                    else {
                        $GroupItems{$ItemKey} = [$Value];

                        # Put Placeholder.
                        $Line =~ s{^(\s+)<Item.*?</Item>.*?$}{$1 PLACEHOLDER_$ItemKey _END}gsmx;
                    }
                }

                $Line = "    $Line";
                push @OutputLines, $Line;
            }

            $FrontendModuleReg = join( "\n", @OutputLines );
            my $FirstItem = 1;

            for my $Key ( sort keys %GroupItems ) {

                if ( ref $GroupItems{$Key} eq 'ARRAY' ) {
                    my $ArrayItems = '';
                    if ($FirstItem) {
                        $ArrayItems .= "\n";
                    }

                    $ArrayItems .= sprintf "%-*s%s", 20, "",
                        "<Item Key=\"$Key\">\n";
                    $ArrayItems .= sprintf "%-*s%s", 24, "",
                        "<Array>\n";

                    for my $ArrayItem ( @{ $GroupItems{$Key} } ) {
                        if ($ArrayItem) {
                            $ArrayItems .= sprintf "%-*s%s", 28, "",
                                "<Item>$ArrayItem</Item>\n";
                        }
                    }
                    $ArrayItems .= sprintf "%-*s%s", 24, "",
                        "</Array>\n";
                    $ArrayItems .= sprintf "%-*s%s", 20, "",
                        "</Item>";

                    $FrontendModuleReg =~ s{^\s+PLACEHOLDER_$Key\s_END.*?$}{$ArrayItems}gsmx;
                }
                $FirstItem = 0;
            }

            # Make sure each FrontendModuleReg has Group and GroupRo items
            for my $GroupTag (qw(GroupRo Group)) {
                if ( $FrontendModuleReg !~ m{<Item Key="$GroupTag"} ) {

                    my $MissingTag = sprintf "%-*s%s", 20, "",
                        "<Item Key=\"$GroupTag\">\n";

                    $MissingTag .= sprintf "%-*s%s", 24, "",
                        "<Array>\n";
                    $MissingTag .= sprintf "%-*s%s", 24, "",
                        "</Array>\n";
                    $MissingTag .= sprintf "%-*s%s", 20, "",
                        "</Item>\n";

                    # prepend
                    $FrontendModuleReg = $MissingTag .= $FrontendModuleReg;
                }
            }

            # check if NavBarName exists
            if ( $FrontendModuleReg !~ m{<Item Key="NavBarName"} ) {
                $FrontendModuleReg .= sprintf "%-*s%s", 4, "",
                    "<Item Key=\"NavBarName\"></Item>\n";
                $FrontendModuleReg .= sprintf "%-*s", 16, "";
            }

            my $FirstCharacter = substr $FrontendModuleReg, 0, 1;
            if ( $FirstCharacter ne "\n" ) {
                $FrontendModuleReg = "\n$FrontendModuleReg";
            }

            my $Value = "<Value>\n";
            $Value .= sprintf "%-*s%s", 12, "", "<Item ValueType=\"FrontendRegistration\">\n";
            $Value .= sprintf "%-*s%s", 16, "", "<Hash>";
            $Value .= $FrontendModuleReg;
            $Value .= "</Hash>\n";
            $Value .= sprintf "%-*s%s", 12, "", "</Item>\n";
            $Value .= sprintf "%-*s%s", 8,  "", "</Value>";

            $Setting =~ s{<Setting>.*?</Setting>}{$Value}gsmx;

            # Put Loader stuff in a separated setting.
            if (
                $Loader
                && $Setting =~ m{<ConfigItem\s+Name="(.*?)"(.*?)>}gsmx
                )
            {
                my $LoaderSetting = sprintf "%-*s%s", 4, "", "<ConfigItem Name=\"$1\"$2>";

                my $LoaderName = ( $InitToLoaderMapping{$Init} // '005-' )
                    . $Param{Name};

                $LoaderSetting =~ s{Name=".*?\#\#\#(.*?)" (.*?)>}{Name="Loader::Module::$1###$LoaderName"$2>}gsmx;

                $LoaderSetting .= sprintf(
                    "\n%-*s%s",
                    8,
                    "",
                    "<Description Translatable=\"1\">Loader module registration for the agent interface.</Description>"
                );

                if ( $Setting =~ m{<SubGroup>(.*?)</SubGroup>} ) {
                    my $NavigationStr = $NavigationLookup{$1} || $1;

                    $NavigationStr .= "::Loader";
                    $LoaderSetting .= sprintf( "\n%-*s%s", 8, "", "<Navigation>$NavigationStr</Navigation>" );
                }

                $LoaderSetting .= sprintf( "\n%-*s%s", 8,  "", "<Value>" );
                $LoaderSetting .= sprintf( "\n%-*s%s", 12, "", "<Hash>" );

                my @LoaderLines = split( "\n", $Loader );
                my ( @CSS, @JS );

                # Check for CSS and JS content.
                for my $Line (@LoaderLines) {
                    if ( $Line =~ m{<CSS>(.*?)</CSS>} ) {
                        push @CSS, $1;
                    }

                    if ( $Line =~ m{<JavaScript>(.*?)</JavaScript>} ) {
                        push @JS, $1;
                    }
                }

                if ( scalar @CSS ) {
                    $LoaderSetting .= sprintf( "\n%-*s%s", 16, "", "<Item Key=\"CSS\">" );
                    $LoaderSetting .= sprintf( "\n%-*s%s", 20, "", "<Array>" );
                }

                for my $CSSItem (@CSS) {
                    $LoaderSetting .= sprintf( "\n%-*s%s", 24, "", "<Item>$CSSItem</Item>" );
                }

                if ( scalar @CSS ) {
                    $LoaderSetting .= sprintf( "\n%-*s%s", 20, "", "</Array>" );
                    $LoaderSetting .= sprintf( "\n%-*s%s", 16, "", "</Item>" );
                }

                if ( scalar @JS ) {
                    $LoaderSetting .= sprintf( "\n%-*s%s", 16, "", "<Item Key=\"JavaScript\">" );
                    $LoaderSetting .= sprintf( "\n%-*s%s", 20, "", "<Array>" );
                }

                for my $JSItem (@JS) {
                    $LoaderSetting .= sprintf( "\n%-*s%s", 24, "", "<Item>$JSItem</Item>" );
                }

                if ( scalar @JS ) {
                    $LoaderSetting .= sprintf( "\n%-*s%s", 20, "", "</Array>" );
                    $LoaderSetting .= sprintf( "\n%-*s%s", 16, "", "</Item>" );
                }

                $LoaderSetting .= sprintf( "\n%-*s%s", 12, "", "</Hash>" );
                $LoaderSetting .= sprintf( "\n%-*s%s", 8,  "", "</Value>" );
                $LoaderSetting .= sprintf( "\n%-*s%s", 4,  "", "</ConfigItem>" );

                $Setting .= "\n" . $LoaderSetting;
            }

            if ( $NavBar && $Setting =~ m{<ConfigItem\s+Name="(.*?)"(.*?)>}gsmx ) {
                my $Name    = $1;
                my $Options = $2;
                my $Index   = 1;

                my @NavBars = split m{<\/NavBar>\s+?<NavBar}, $NavBar;

                my $Navigation = '';

                $Name =~ s{Frontend::Module}{Frontend::Navigation}gsmx;

                for my $NavBarItem (@NavBars) {

                    $Navigation .= sprintf "%-*s%s", 4, "", "<Setting Name=\"$Name###$Index\"$Options>\n";
                    $Navigation .= sprintf "%-*s%s", 8, "",
                        "<Description Translatable=\"1\">Main menu for the agent interface.</Description>";

                    if ( $Setting =~ m{<SubGroup>(.*?)</SubGroup>} ) {
                        my $NavigationStr = $NavigationLookup{$1} || $1;
                        $NavigationStr .= "::MainMenu";
                        $Navigation .= sprintf( "\n%-*s%s", 8, "", "<Navigation>$NavigationStr</Navigation>" );
                    }

                    $Navigation .= sprintf( "\n%-*s%s", 8,  "", "<Value>" );
                    $Navigation .= sprintf( "\n%-*s%s", 12, "", "<Hash>" );

                    for my $NavBarTag (qw(Group GroupRo)) {
                        my @Items;

                        while ( $NavBarItem =~ s{<$NavBarTag>(.*?)<\/$NavBarTag}{}smx ) {
                            push @Items, $1;
                        }

                        $Navigation .= sprintf( "\n%-*s%s", 16, "", "<Item Key=\"$NavBarTag\">" );
                        $Navigation .= sprintf( "\n%-*s%s", 20, "", "<Array>" );

                        for my $Value (@Items) {
                            $Navigation .= sprintf( "\n%-*s%s", 24, "", "<Item>$Value</Item>" );
                        }

                        if (
                            !scalar @Items
                            && $GroupItems{$NavBarTag}
                            )
                        {
                            # take group items from FrontendModuleReg
                            for my $Value ( @{ $GroupItems{$NavBarTag} } ) {
                                if ($Value) {
                                    $Navigation .= sprintf( "\n%-*s%s", 24, "", "<Item>$Value</Item>" );
                                }
                            }
                        }

                        $Navigation .= sprintf( "\n%-*s%s", 20, "", "</Array>" );
                        $Navigation .= sprintf( "\n%-*s%s", 16, "", "</Item>" );
                    }

                    for my $NavBarTag (qw(Description Name Link LinkOption NavBar Type Block AccessKey Prio)) {
                        my $Value      = '';
                        my $Attributes = '';

                        if ( $NavBarItem =~ m{<$NavBarTag>(.*?)<\/$NavBarTag} ) {
                            $Value = $1;
                        }
                        elsif ( $NavBarItem =~ m{<$NavBarTag\s(.*?)>(.*?)<\/$NavBarTag} ) {
                            $Attributes = " $1";
                            $Value      = $2;
                        }
                        $Navigation .= sprintf(
                            "\n%-*s%s", 16, "",
                            "<Item Key=\"$NavBarTag\"$Attributes>$Value</Item>",
                        );
                    }

                    $Navigation .= sprintf( "\n%-*s%s", 12, "", "</Hash>" );
                    $Navigation .= sprintf( "\n%-*s%s", 8,  "", "</Value>" );
                    $Navigation .= sprintf( "\n%-*s%s", 4,  "", "</ConfigItem>\n" );    # We rename ConfigItems later

                    $Index++;
                }

                $Setting .= "\n" . $Navigation;
            }

            if ( $NavBarModule && $Setting =~ m{<ConfigItem\s+Name="(.*?)"(.*?)>}gsmx ) {

                # FrontendNavigationModule

                my $Name    = $1;
                my $Options = $2;

                $Name =~ s{Frontend::Module}{Frontend::NavigationModule}gsmx;

                my $NavigationModule = sprintf "%-*s%s", 4, "", "<Setting Name=\"$Name\"$Options>\n";
                $NavigationModule .= sprintf "%-*s%s", 8, "",
                    "<Description Translatable=\"1\">Admin area navigation for the agent interface.</Description>";

                if ( $Setting =~ m{<SubGroup>(.*?)</SubGroup>} ) {
                    my $NavigationStr = $NavigationLookup{$1} || $1;

                    $NavigationStr .= '::AdminOverview';
                    $NavigationModule .= sprintf( "\n%-*s%s", 8, "", "<Navigation>$NavigationStr</Navigation>" );
                }

                $NavigationModule .= sprintf( "\n%-*s%s", 8,  "", "<Value>" );
                $NavigationModule .= sprintf( "\n%-*s%s", 12, "", "<Hash>" );

                for my $NavBarTag (qw(Group GroupRo)) {
                    my @Items;

                    while ( $NavBarModule =~ s{<$NavBarTag>(.*?)<\/$NavBarTag}{}smx ) {
                        push @Items, $1;
                    }

                    $NavigationModule .= sprintf( "\n%-*s%s", 16, "", "<Item Key=\"$NavBarTag\">" );
                    $NavigationModule .= sprintf( "\n%-*s%s", 20, "", "<Array>" );

                    for my $Value (@Items) {
                        $NavigationModule .= sprintf( "\n%-*s%s", 24, "", "<Item>$Value</Item>" );
                    }

                    if (
                        !scalar @Items
                        && $GroupItems{$NavBarTag}
                        )
                    {
                        # take group items from FrontendModuleReg
                        for my $Value ( @{ $GroupItems{$NavBarTag} } ) {
                            if ($Value) {
                                $NavigationModule .= sprintf( "\n%-*s%s", 24, "", "<Item>$Value</Item>" );
                            }
                        }
                    }

                    $NavigationModule .= sprintf( "\n%-*s%s", 20, "", "</Array>" );
                    $NavigationModule .= sprintf( "\n%-*s%s", 16, "", "</Item>" );
                }

                for my $NavBarTag (qw(Module Name Block Description IconBig IconSmall Prio)) {
                    my $Value      = '';
                    my $Attributes = '';

                    if ( $NavBarModule =~ m{<$NavBarTag>(.*?)<\/$NavBarTag} ) {
                        $Value = $1;
                    }
                    elsif ( $NavBarModule =~ m{<$NavBarTag\s(.*?)>(.*?)<\/$NavBarTag} ) {
                        $Attributes = " $1";
                        $Value      = $2;
                    }
                    $NavigationModule .= sprintf(
                        "\n%-*s%s", 16, "",
                        "<Item Key=\"$NavBarTag\"$Attributes>$Value</Item>",
                    );
                }

                $NavigationModule .= sprintf( "\n%-*s%s", 12, "", "</Hash>" );
                $NavigationModule .= sprintf( "\n%-*s%s", 8,  "", "</Value>" );
                $NavigationModule .= sprintf( "\n%-*s%s", 4,  "", "</ConfigItem>\n" );    # We rename ConfigItems later

                $Setting .= "\n" . $NavigationModule;
            }
        }

        # Rename Regex to ValueRegex.
        $Setting =~ s{^(\s+<String\s+)Regex="(.*?)"}{$1ValueRegex="$2"}gsmx;

        # Check for known old validation modules.
        for my $ValidateModule (qw(StateValidate PriorityValidate QueueValidate)) {

            if ( $Setting =~ m{<ValidateModule>.*?$ValidateModule</ValidateModule>}gsm ) {

                # Remove ValidateModule tag.
                $Setting =~ s{^\s+<ValidateModule>.*?::$ValidateModule</ValidateModule>}{}gsmx;

                my $Entity;
                if ( $ValidateModule eq 'StateValidate' ) {
                    $Entity = 'State';
                }
                elsif ( $ValidateModule eq 'PriorityValidate' ) {
                    $Entity = 'Priority';
                }
                elsif ( $ValidateModule eq 'QueueValidate' ) {
                    $Entity = 'Queue';
                }

                # Update string tag.
                $Setting =~ s{<String(.*?)>(.*?)</String>}
                    {<Item ValueType="Entity" ValueEntityType="$Entity"$1>$2</Item>}gsmx;
            }
        }

        # Update file path.
        $Setting =~ s{<String\s+ValueRegex="(.*?)"\s+Check="File".*?>(.*?)<\/String>}
            {<Item ValueRegex="$1" ValueType="File">$2</Item>}gsmx;

        # Update file directory.
        $Setting =~ s{<String\s+ValueRegex="(.*?)"\s+Check="Directory".*?>(.*?)<\/String>}
            {<Item ValueRegex="$1" ValueType="Directory">$2</Item>}gsmx;

        # Replace No/Yes drop-down with Checkbox.
        $Setting =~ s{
                ^(\s+)                               # match space
                <Option.*?SelectedID="(\d)"          # match SelectedID inside Option tag
                .*? Key="0" .*?>No<                  # match No
                .*? Key="1" .*?>Yes</Item>           # match Yes
                \s+?</Option>?                       # match end of option
            }
            {$1<Item ValueType="Checkbox">$2</Item>}gsmx;
        $Setting =~ s{
                ^(\s+)                               # match space
                <Option.*?SelectedID=""              # match empty SelectedID inside Option tag
                .*? Key="0" .*?>No<                  # match No
                .*? Key="1" .*?>Yes</Item>           # match Yes
                \s+?</Option>?                       # match end of option
            }
            {$1<Item ValueType="Checkbox">0</Item>}gsmx;

        # Replace Yes/No drop-down with Checkbox
        $Setting =~ s{
                    ^(\s+)                               # match space
                    <Option.*?SelectedID="(\d)"          # match SelectedID inside Option tag
                    .*? Key="1" .*?>Yes<                 # match Yes
                    .*? Key="0" .*?>No</Item>            # match No
                    \s+?</Option>                        # match end of option
                }
                {$1<Item ValueType="Checkbox">$2</Item>}gsmx;
        $Setting =~ s{
                    ^(\s+)                               # match space
                    <Option.*?SelectedID=""              # match empty SelectedID inside Option tag
                    .*? Key="1" .*?>Yes<                 # match Yes
                    .*? Key="0" .*?>No</Item>            # match No
                    \s+?</Option>                        # match end of option
                }
                {$1<Item ValueType="Checkbox">0</Item>}gsmx;

        # Check if this Setting contains Option with Items.
        if ( $Setting =~ m{<Option.*?<Item.*?</Option>}gsm ) {
            my @Items = split( '</Item>', $Setting );

            for my $Item (@Items) {

                # Set the ValueType 'Option' tag to the main item.
                $Item =~ s{<Item\s+Key="(.*?)"(.*?)>(.*?)$}{<Item ValueType="Option" Value="$1"$2>$3}gsmx;

                # Convert Options to children Item.
                $Item =~ s{<Option(.*?)>}{<Item ValueType="Select"$1>}gsmx;

                # Convert </Option> to </Item>
                $Item =~ s{</Option>}{</Item>}gsmx;
            }

            $Setting = join( '</Item>', @Items );
        }
        elsif ( $Setting =~ m{<Option\s+Location="(.*?)"\s+SelectedID="(.*?)".*?</Option>}gsm ) {
            my ( $Location, $SelectedID ) = ( $1, $2 );

            $Setting =~ s{<Option.*?</Option>}
                {<Item ValueType="PerlModule" ValueFilter="$Location">$SelectedID</Item>}gsmx;
        }

        # Update WorkingHours.
        if ( $Setting =~ m{TimeWorkingHours} ) {
            my @Days = split( "</Day>", $Setting );
            pop @Days;    # contains not needed item

            my $WorkingHoursString = '';
            my $SpaceString        = '';

            for my $Day (@Days) {

                # Check if this item contains string and update to WorkingHours ValueType.
                if ( $Day =~ s{^(\s+)<TimeWorkingHours>}{$1<Item ValueType="WorkingHours">}gsmx ) {
                    if ($1) {
                        $SpaceString = $1;
                    }
                }

                # Set Day ValueType tag.
                $Day =~ s{<Day\s+Name="(.*?)">}{<Item ValueType="Day" ValueName="$1">}gsmx;

                # Set Hour ValueType tag.
                $Day =~ s{<Hour>(\d+)</Hour>}{<Item ValueType="Hour">$1</Item>}gsmx;

                # Add block closure tag on the last item.
                if ( $Day eq $Days[-1] ) {
                    $Day .= "</Item>\n$SpaceString</Item>";
                }
            }

            my $DaysString = join( '</Item>', @Days );

            $Setting =~ s{.*?<TimeWorkingHours>.*?</TimeWorkingHours>}{$DaysString}gsmx;
        }

        # Update VacationDays.
        if ( $Setting =~ m{<(TimeVacationDays.*?)>} ) {
            my $Type = $1;

            my $TypeNew;
            if ( $Type eq 'TimeVacationDays' ) {
                $TypeNew = "VacationDays";
            }
            else {
                $TypeNew = "VacationDaysOneTime";
            }

            # Update item tags to the new format.
            $Setting =~ s{Year=}{ValueYear=}gsmx;
            $Setting =~ s{Month=}{ValueMonth=}gsmx;
            $Setting =~ s{Day=}{ValueDay=}gsmx;

            # Update TimeVacationDays tags.
            $Setting =~ s{<$Type>}{<Item ValueType="$TypeNew">}gsmx;
            $Setting =~ s{</$Type>}{</Item>}gsmx;
        }

        # Update DynamicField Settings
        my $Hashtag = '###';
        my @DFoptions;
        if (
            $Setting =~ m{Name=(.*?)\#\#\#(|FollowUp|ProcessWidget|SearchOverview|SearchCSV)DynamicField\"} ||
            $Setting =~ m{Name=(.*?)(\#\#\#DefaultColumns|DefaultOverviewColumns)}                          ||
            $Setting =~ m{Name=\"(AgentCustomerInformationCenter::Backend|DashboardBackend)\#\#\#}          ||
            $Setting =~ m{Name=\"LinkObject::ComplexTable\#\#\#Ticket\"}
            )
        {

            # 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default
            if (
                $Setting
                =~ m{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sEnabled,\s2\s=\sEnabled\sand\sshown\sby\sdefault.}
                )
            {
                @DFoptions = ( '0 - Disabled', '1 - Enabled', '2 - Enabled and shown by default' );
                $Setting
                    =~ s{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sEnabled,\s2\s=\sEnabled\sand\sshown\sby\sdefault.}{}gsmx;
            }

            # 0 = Disabled, 1 = Enabled, 2 = Enabled and required.
            elsif (
                $Setting =~ m{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sEnabled,\s2\s=\sEnabled\sand\srequired.}
                )
            {
                @DFoptions = ( '0 - Disabled', '1 - Enabled', '2 - Enabled and required' );
                $Setting
                    =~ s{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sEnabled,\s2\s=\sEnabled\sand\srequired.}{}gsmx;
            }

            # 0 = Disabled, 1 = Available, 2 = Enabled by default.
            elsif (
                $Setting =~ m{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sAvailable,\s2\s=\sEnabled\sby\sdefault.} ||
                $Setting =~ m{Name=\"DashboardBackend\#\#\#0140-RunningTicketProcess\"}
                )
            {
                @DFoptions = ( '0 - Disabled', '1 - Available', '2 - Enabled by default' );
                $Setting
                    =~ s{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sAvailable,\s2\s=\sEnabled\sby\sdefault.}{}gmsx;
            }

            # 0 = Disabled, 1 = Enabled.
            elsif (
                $Setting =~ m{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sEnabled.}
                )
            {
                @DFoptions = ( '0 - Disabled', '1 - Enabled' );
                $Setting =~ s{\sPossible\ssettings:\s0\s=\sDisabled,\s1\s=\sEnabled.}{}gsmx;
            }
            my $ReplacementString;

            my $DFCount = 0;
            if (@DFoptions) {
                $ReplacementString = "\n\t\t\t<Hash>\n" .
                    "\t\t\t\t<DefaultItem ValueType=\"Select\">\n";
                for my $DFoption (@DFoptions) {
                    ## nofilter (TidyAll::Plugin::OTRS::Perl::Translatable)
                    $ReplacementString
                        .= "\t\t\t\t\t<Item ValueType=\"Option\" Value=\"$DFCount\" Translatable=\"1\">$DFoption</Item>\n";
                    $DFCount++;
                }
                $ReplacementString .= "\t\t\t\t</DefaultItem>\n" .
                    "\t\t\t</Hash>\n";
            }

            if ($ReplacementString) {

                # DynamicFields
                $Setting =~ s{
                    Name=(.*?)\#\#\#(|FollowUp|ProcessWidget|SearchOverview|SearchCSV)DynamicField\"(.*?)
                    <Setting>(\s+)<Hash>(\s+)<\/Hash>
                }
                     {Name=$1$Hashtag$2DynamicField"$3<Value>$ReplacementString}gsmx;    #"

                # DefaultColumns
                $ReplacementString =~ s{\n\t\t\t<Hash>\n}{\n\t<Hash>\n};
                $ReplacementString =~ s{\n}{\n\t\t};
                $ReplacementString =~ s{\t\t\t</Hash>\n}{};
                $ReplacementString .= "\t\t<Item Key=\"Age\">2</Item>";
                my $DefaultColumnsHashtag = $Hashtag . 'DefaultColumns';

                $Setting =~ s{
                    Name=(.*?)\#\#\#DefaultColumns\"(.*?)
                    <Setting>(\s+)<Hash>(\s+)<Item\sKey=\"Age\">2</Item>
                }
                     {Name=$1$DefaultColumnsHashtag"$2<Value>$ReplacementString}gsmx;    #"
                $Setting =~ s{
                    Name=(.*?)DefaultOverviewColumns\"(.*?)
                    <Setting>(\s+)<Hash>(\s+)<Item\sKey=\"Age\">2</Item>
                }
                     {Name=$1DefaultOverviewColumns"$2<Value>$ReplacementString}gsmx;    #"

                # AgentCustomerInformationCenter-||DashboardBackend
                my $BackendReplacement = "<Item Key=\"DefaultColumns\">" .
                    $ReplacementString . "\n";
                $BackendReplacement =~ s{\n\t}{\n\t\t\t}gsmx;
                $Setting =~ s{
                    Name=\"(DashboardBackend|AgentCustomerInformationCenter::Backend)\#\#\#(.*?)\"(.*?)
                    <Item\sKey=\"DefaultColumns\">(\s+)<Hash>(\s+)<Item\sKey=\"Age\">2</Item>
                }
                     {Name="$1$Hashtag$2"$3$BackendReplacement}gsmx;

                if ( $Setting =~ m{Name=\"LinkObject::ComplexTable\#\#\#Ticket\"} ) {
                    my $LinkBackendReplace = $BackendReplacement;
                    $LinkBackendReplace =~ s{DefaultItem>(\s+)<Item\sKey}{DefaultItem>\n\t\t\t\t\t\t<Item Key}gsmx;
                    $LinkBackendReplace =~ s{\t\t<Item\sKey=\"Age\">2</Item>}{<Item Key="Age">1</Item>}gsmx;
                    $Setting =~ s{
                    <Item\sKey=\"DefaultColumns\">(\s+)<Hash>(\s+)<Item\sKey=\"Age\">1</Item>
                    }
                    {$LinkBackendReplace}gsmx;
                }

                # fill dropdowns with existing values
                $Setting =~ s{<\/DefaultItem>(\s*?)<Item\sKey="(.*?)">(0|1|2)<}
                {<\/DefaultItem>$1\t\t<Item Key="$2" SelectedID="$3"><}gsmx;
                while (
                    $Setting =~ m{"(0|1|2)"><\/Item>(\s*)<Item\sKey="(.*?)">(0|1|2)<}
                    )
                {
                    if ( $2 ne 'Default' ) {
                        $Setting =~ s{><\/Item>(\s*)<Item\sKey="(.*?)">(0|1|2)<}
                        {></Item>$1<Item Key="$2" SelectedID="$3"><}gsmx;
                    }
                }

                $Setting =~ s{><\/Item>(\s*)<Item\sKey="Default"\sSelectedID="(0|1)"><}
                    {></Item>\n\t\t\t\t<Item Key="Default">$2<}gsmx;

                # replace tab with spaces
                $Setting =~ s{\t}{    }gsmx;

                # FAQ.xml
                # LinkObject::ComplexTable###FAQ

                # ITSMTicket.xml
                # Ticket::Frontend::AgentTicketAddtlITSMField###DynamicField
                # Ticket::Frontend::AgentTicketDecision###DynamicField

                # TicketITSMTicket.xml
                # Ticket::Frontend::AgentTicketPhone###DynamicField
                # Ticket::Frontend::AgentTicketEmail###DynamicField
                # Ticket::Frontend::AgentTicketSearch###DynamicField
                # Ticket::Frontend::AgentTicketZoom###DynamicField
                # Ticket::Frontend::AgentTicketPriority###DynamicField
                # Ticket::Frontend::AgentTicketClose###DynamicField
                # Ticket::Frontend::AgentTicketCompose###DynamicField
                # Ticket::Frontend::CustomerTicketZoom###DynamicField
            }
        }

        # Remove Group.
        $Setting =~ s{\s+<Group>(.*?)</Group>}{}gsmx;

        # Update SubGroup to the Navigation.
        $Setting =~ s{SubGroup>}{Navigation>}gsmx;

        my @NavigationValues = $Setting =~ m{<Navigation>(.*?)</Navigation>}g;
        if ( scalar @NavigationValues ) {
            my $NavigationValue = $NavigationValues[0];
            my $NavigationStr = $NavigationLookup{$NavigationValue} || $NavigationValue;

            if (
                scalar @NavigationValues < 2
                || !grep { $NavigationStr eq $_ } (
                    'Frontend::Admin::ModuleRegistration',
                    'Frontend::Agent::ModuleRegistration',
                    'Frontend::Customer::ModuleRegistration',
                    )
                )
            {
                $Setting =~ s{<Navigation>.*?</Navigation>}{<Navigation>$NavigationStr</Navigation>}gsmx;
            }
        }

        # Update Setting to the Value.
        $Setting =~ s{Setting>}{Value>}gsmx;

        # # Add missing RegEx to all Numbers
        $Setting =~ s{<String>(\d+)</String>$}
            {<Item ValueType="String" ValueRegex="^\\d+\$">$1</Item>}gsmx;

        $Setting =~ s{<String\sValueRegex="">(\d+)</String>}
            {<Item ValueType="String" ValueRegex="^\\d+\$">$1</Item>}gsmx;

        $Setting =~ s{<String\sValueRegex="\\d\+">(\d+?)</String>}
            {<Item ValueType="String" ValueRegex="^\\d+\$">$1</Item>}gsmx;

        $Setting =~ s{<String\sValueRegex="\[(.*?)">(\d+)</String>}
            {<Item ValueType="String" ValueRegex="^[$1">$2</Item>}gmsx;

        # Update string and text-area to items with its corresponding ValueType.
        $Setting =~ s{<TextArea(.*?)</TextArea>}{<Item ValueType="Textarea"$1</Item>}gsmx;
        $Setting =~ s{<String(.*?)</String>}{<Item ValueType="String"$1</Item>}gsmx;

        # Convert password strings
        $Setting =~ s{<Item\sValueType="String"(.*?)Type="Password"(.*?)$}
            {<Item ValueType="Password"$2}gsmx;
        $Setting =~ s{<Item\sKey="Password">(.*?)$}
            {<Item Key="Password" ValueType="Password">$1}gsmx;

        # Convert TicketType to Entity
        $Setting =~ s{<Item\sValueType="String"\sValueRegex=""(.*?)>Unclassified(.*?)$}
            {<Item ValueType="Entity" ValueEntityType="Type"$1>Unclassified$2}gsmx;

        $Setting =~ m{<ConfigItem\sName="(.*?)"}gsmx;
        my $SettingName = $1;

        my @SettingsUserModificationPossible = (
            'Frontend::Admin::AdminNotificationEvent###RichTextHeight',
            'Frontend::Admin::AdminNotificationEvent###RichTextWidth',
            'Frontend::CustomerUser::Item###1-GoogleMaps',
            'Frontend::CustomerUser::Item###15-OpenTickets',
            'Frontend::CustomerUser::Item###16-OpenTicketsForCustomerUserLogin',
            'Frontend::CustomerUser::Item###17-ClosedTickets',
            'Frontend::CustomerUser::Item###18-ClosedTicketsForCustomerUserLogin',
            'Frontend::CustomerUser::Item###2-Google',
            'Frontend::CustomerUser::Item###2-LinkedIn',
            'Frontend::CustomerUser::Item###3-XING',
            'Frontend::ToolBarModule###110-Ticket::AgentTicketQueue',
            'Frontend::ToolBarModule###120-Ticket::AgentTicketStatus',
            'Frontend::ToolBarModule###130-Ticket::AgentTicketEscalation',
            'Frontend::ToolBarModule###140-Ticket::AgentTicketPhone',
            'Frontend::ToolBarModule###150-Ticket::AgentTicketEmail',
            'Frontend::ToolBarModule###160-Ticket::AgentTicketProcess',
            'Frontend::ToolBarModule###210-Ticket::TicketSearchProfile',
            'Frontend::ToolBarModule###220-Ticket::TicketSearchFulltext',
            'Frontend::ToolBarModule###230-CICSearchCustomerID',
            'Frontend::ToolBarModule###240-CICSearchCustomerUser',
            'Ticket::Frontend::AgentTicketBounce###StateDefault',
            'Ticket::Frontend::AgentTicketBulk###ArticleTypeDefault',
            'Ticket::Frontend::AgentTicketBulk###Owner',
            'Ticket::Frontend::AgentTicketBulk###Priority',
            'Ticket::Frontend::AgentTicketBulk###PriorityDefault',
            'Ticket::Frontend::AgentTicketBulk###Responsible',
            'Ticket::Frontend::AgentTicketBulk###State',
            'Ticket::Frontend::AgentTicketBulk###StateDefault',
            'Ticket::Frontend::AgentTicketBulk###TicketType',
            'Ticket::Frontend::AgentTicketClose###ArticleTypeDefault',
            'Ticket::Frontend::AgentTicketClose###Body',
            'Ticket::Frontend::AgentTicketClose###InformAgent',
            'Ticket::Frontend::AgentTicketClose###InvolvedAgent',
            'Ticket::Frontend::AgentTicketClose###Note',
            'Ticket::Frontend::AgentTicketClose###NoteMandatory',
            'Ticket::Frontend::AgentTicketClose###Owner',
            'Ticket::Frontend::AgentTicketClose###OwnerMandatory',
            'Ticket::Frontend::AgentTicketClose###Priority',
            'Ticket::Frontend::AgentTicketClose###PriorityDefault',
            'Ticket::Frontend::AgentTicketClose###Queue',
            'Ticket::Frontend::AgentTicketClose###Responsible',
            'Ticket::Frontend::AgentTicketClose###ResponsibleMandatory',
            'Ticket::Frontend::AgentTicketClose###RichTextHeight',
            'Ticket::Frontend::AgentTicketClose###RichTextWidth',
            'Ticket::Frontend::AgentTicketClose###Service',
            'Ticket::Frontend::AgentTicketClose###ServiceMandatory',
            'Ticket::Frontend::AgentTicketClose###SLAMandatory',
            'Ticket::Frontend::AgentTicketClose###State',
            'Ticket::Frontend::AgentTicketClose###StateDefault',
            'Ticket::Frontend::AgentTicketClose###Subject',
            'Ticket::Frontend::AgentTicketClose###TicketType',
            'Ticket::Frontend::AgentTicketClose###Title',
            'Ticket::Frontend::AgentTicketCompose###DefaultArticleType',
            'Ticket::Frontend::AgentTicketCompose###StateDefault',
            'Ticket::Frontend::AgentTicketCustomer::CustomerIDReadOnly',
            'Ticket::Frontend::AgentTicketEmail::CustomerIDReadOnly',
            'Ticket::Frontend::AgentTicketEmail###ArticleType',
            'Ticket::Frontend::AgentTicketEmail###Body',
            'Ticket::Frontend::AgentTicketEmail###Priority',
            'Ticket::Frontend::AgentTicketEmail###RichTextHeight',
            'Ticket::Frontend::AgentTicketEmail###RichTextWidth',
            'Ticket::Frontend::AgentTicketEmail###ServiceMandatory',
            'Ticket::Frontend::AgentTicketEmail###SLAMandatory',
            'Ticket::Frontend::AgentTicketEmail###StateDefault',
            'Ticket::Frontend::AgentTicketEmail###Subject',
            'Ticket::Frontend::AgentTicketEmailOutbound###ArticleTypeDefault',
            'Ticket::Frontend::AgentTicketEmailOutbound###RichTextHeight',
            'Ticket::Frontend::AgentTicketEmailOutbound###RichTextWidth',
            'Ticket::Frontend::AgentTicketEmailOutbound###StateDefault',
            'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
            'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            'Ticket::Frontend::AgentTicketForward###ArticleTypeDefault',
            'Ticket::Frontend::AgentTicketForward###RichTextHeight',
            'Ticket::Frontend::AgentTicketForward###RichTextWidth',
            'Ticket::Frontend::AgentTicketForward###StateDefault',
            'Ticket::Frontend::AgentTicketFreeText###ArticleTypeDefault',
            'Ticket::Frontend::AgentTicketFreeText###Body',
            'Ticket::Frontend::AgentTicketFreeText###InformAgent',
            'Ticket::Frontend::AgentTicketFreeText###InvolvedAgent',
            'Ticket::Frontend::AgentTicketFreeText###Note',
            'Ticket::Frontend::AgentTicketFreeText###NoteMandatory',
            'Ticket::Frontend::AgentTicketFreeText###Owner',
            'Ticket::Frontend::AgentTicketFreeText###OwnerMandatory',
            'Ticket::Frontend::AgentTicketFreeText###Priority',
            'Ticket::Frontend::AgentTicketFreeText###PriorityDefault',
            'Ticket::Frontend::AgentTicketFreeText###Queue',
            'Ticket::Frontend::AgentTicketFreeText###Responsible',
            'Ticket::Frontend::AgentTicketFreeText###ResponsibleMandatory',
            'Ticket::Frontend::AgentTicketFreeText###RichTextHeight',
            'Ticket::Frontend::AgentTicketFreeText###RichTextWidth',
            'Ticket::Frontend::AgentTicketFreeText###Service',
            'Ticket::Frontend::AgentTicketFreeText###ServiceMandatory',
            'Ticket::Frontend::AgentTicketFreeText###SLAMandatory',
            'Ticket::Frontend::AgentTicketFreeText###State',
            'Ticket::Frontend::AgentTicketFreeText###StateDefault',
            'Ticket::Frontend::AgentTicketFreeText###Subject',
            'Ticket::Frontend::AgentTicketFreeText###TicketType',
            'Ticket::Frontend::AgentTicketFreeText###Title',
            'Ticket::Frontend::AgentTicketLockedView###Order::Default',
            'Ticket::Frontend::AgentTicketLockedView###SortBy::Default',
            'Ticket::Frontend::AgentTicketMerge###RichTextHeight',
            'Ticket::Frontend::AgentTicketMerge###RichTextWidth',
            'Ticket::Frontend::AgentTicketMove###Body',
            'Ticket::Frontend::AgentTicketMove###NextScreen',
            'Ticket::Frontend::AgentTicketMove###Note',
            'Ticket::Frontend::AgentTicketMove###NoteMandatory',
            'Ticket::Frontend::AgentTicketMove###Priority',
            'Ticket::Frontend::AgentTicketMove###RichTextHeight',
            'Ticket::Frontend::AgentTicketMove###RichTextWidth',
            'Ticket::Frontend::AgentTicketMove###State',
            'Ticket::Frontend::AgentTicketMove###Subject',
            'Ticket::Frontend::AgentTicketNote###ArticleTypeDefault',
            'Ticket::Frontend::AgentTicketNote###Body',
            'Ticket::Frontend::AgentTicketNote###InformAgent',
            'Ticket::Frontend::AgentTicketNote###InvolvedAgent',
            'Ticket::Frontend::AgentTicketNote###Note',
            'Ticket::Frontend::AgentTicketNote###NoteMandatory',
            'Ticket::Frontend::AgentTicketNote###Owner',
            'Ticket::Frontend::AgentTicketNote###OwnerMandatory',
            'Ticket::Frontend::AgentTicketNote###Priority',
            'Ticket::Frontend::AgentTicketNote###PriorityDefault',
            'Ticket::Frontend::AgentTicketNote###Queue',
            'Ticket::Frontend::AgentTicketNote###Responsible',
            'Ticket::Frontend::AgentTicketNote###ResponsibleMandatory',
            'Ticket::Frontend::AgentTicketNote###RichTextHeight',
            'Ticket::Frontend::AgentTicketNote###RichTextWidth',
            'Ticket::Frontend::AgentTicketNote###Service',
            'Ticket::Frontend::AgentTicketNote###ServiceMandatory',
            'Ticket::Frontend::AgentTicketNote###SLAMandatory',
            'Ticket::Frontend::AgentTicketNote###State',
            'Ticket::Frontend::AgentTicketNote###StateDefault',
            'Ticket::Frontend::AgentTicketNote###Subject',
            'Ticket::Frontend::AgentTicketNote###TicketType',
            'Ticket::Frontend::AgentTicketNote###Title',
            'Ticket::Frontend::AgentTicketQueue###Blink',
            'Ticket::Frontend::AgentTicketQueue###HideEmptyQueues',
            'Ticket::Frontend::AgentTicketQueue###HighlightAge1',
            'Ticket::Frontend::AgentTicketQueue###HighlightAge2',
            'Ticket::Frontend::AgentTicketQueue###Order::Default',
            'Ticket::Frontend::AgentTicketQueue###QueueSort',
            'Ticket::Frontend::AgentTicketQueue###SortBy::Default',
            'Ticket::Frontend::AgentTicketSearch###Defaults###ArticleCreateTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###ArticleCreateTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Body',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Cc',
            'Ticket::Frontend::AgentTicketSearch###Defaults###CustomerID',
            'Ticket::Frontend::AgentTicketSearch###Defaults###CustomerUserLogin',
            'Ticket::Frontend::AgentTicketSearch###Defaults###DynamicField',
            'Ticket::Frontend::AgentTicketSearch###Defaults###From',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Fulltext',
            'Ticket::Frontend::AgentTicketSearch###Defaults###QueueIDs',
            'Ticket::Frontend::AgentTicketSearch###Defaults###SearchInArchive',
            'Ticket::Frontend::AgentTicketSearch###Defaults###StateIDs',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Subject',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketChangeTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketChangeTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCloseTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCloseTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCreateTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCreateTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketEscalationTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketEscalationTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketNumber',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Title',
            'Ticket::Frontend::AgentTicketSearch###Defaults###To',
            'Ticket::Frontend::AgentTicketSearch###Order::Default',
            'Ticket::Frontend::AgentTicketSearch###SortBy::Default',
            'Ticket::Frontend::AgentTicketService###Order::Default',
            'Ticket::Frontend::AgentTicketService###SortBy::Default',
            'Ticket::Frontend::AgentTicketStatusView###Order::Default',
            'Ticket::Frontend::AgentTicketStatusView###SortBy::Default',
            'Ticket::Frontend::AgentTicketWatchView###Order::Default',
            'Ticket::Frontend::AgentTicketWatchView###SortBy::Default',
            'Ticket::Frontend::AgentTicketZoom###ProcessDisplay',
            'Ticket::Frontend::HTMLArticleHeightDefault',
            'Ticket::Frontend::HTMLArticleHeightMax',
            'Ticket::Frontend::MaxArticlesPerPage',
            'Ticket::Frontend::PendingDiffTime',
            'Ticket::Frontend::PlainView',
            'Ticket::Frontend::TicketArticleFilter',
            'Ticket::Frontend::ZoomCollectMeta',
            'Ticket::Frontend::ZoomExpandSort',
            'Ticket::Frontend::ZoomRichTextForce',
            'Ticket::UseArticleColors',
            'Ticket::ZoomTimeDisplay',
            'TimeInputFormat',
        );

        if ( grep { $SettingName eq $_ } @SettingsUserModificationPossible ) {
            $Setting =~ s{(ConfigItem\sName=".*?")}{$1 UserModificationPossible="1"}gsmx;
        }

        my @SettingsUserModificationActive = (
            'Frontend::ToolBarModule###110-Ticket::AgentTicketQueue',
            'Frontend::ToolBarModule###120-Ticket::AgentTicketStatus',
            'Frontend::ToolBarModule###130-Ticket::AgentTicketEscalation',
            'Frontend::ToolBarModule###140-Ticket::AgentTicketPhone',
            'Frontend::ToolBarModule###150-Ticket::AgentTicketEmail',
            'Frontend::ToolBarModule###160-Ticket::AgentTicketProcess',
            'Frontend::ToolBarModule###210-Ticket::TicketSearchProfile',
            'Frontend::ToolBarModule###230-CICSearchCustomerID',
            'Frontend::ToolBarModule###240-CICSearchCustomerUser',
            'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
            'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            'Ticket::Frontend::AgentTicketLockedView###Order::Default',
            'Ticket::Frontend::AgentTicketLockedView###SortBy::Default',
            'Ticket::Frontend::AgentTicketMove###NextScreen',
            'Ticket::Frontend::AgentTicketQueue###Blink',
            'Ticket::Frontend::AgentTicketQueue###HideEmptyQueues',
            'Ticket::Frontend::AgentTicketQueue###Order::Default',
            'Ticket::Frontend::AgentTicketQueue###QueueSort',
            'Ticket::Frontend::AgentTicketQueue###SortBy::Default',
            'Ticket::Frontend::AgentTicketSearch###Defaults###ArticleCreateTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###ArticleCreateTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Body',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Cc',
            'Ticket::Frontend::AgentTicketSearch###Defaults###CustomerID',
            'Ticket::Frontend::AgentTicketSearch###Defaults###CustomerUserLogin',
            'Ticket::Frontend::AgentTicketSearch###Defaults###DynamicField',
            'Ticket::Frontend::AgentTicketSearch###Defaults###From',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Fulltext',
            'Ticket::Frontend::AgentTicketSearch###Defaults###QueueIDs',
            'Ticket::Frontend::AgentTicketSearch###Defaults###SearchInArchive',
            'Ticket::Frontend::AgentTicketSearch###Defaults###StateIDs',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Subject',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketChangeTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketChangeTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCloseTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCloseTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCreateTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCreateTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketEscalationTimePoint',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketEscalationTimeSlot',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketNumber',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Title',
            'Ticket::Frontend::AgentTicketSearch###Defaults###To',
            'Ticket::Frontend::AgentTicketSearch###Order::Default',
            'Ticket::Frontend::AgentTicketSearch###SortBy::Default',
            'Ticket::Frontend::AgentTicketService###Order::Default',
            'Ticket::Frontend::AgentTicketService###SortBy::Default',
            'Ticket::Frontend::AgentTicketStatusView###Order::Default',
            'Ticket::Frontend::AgentTicketStatusView###SortBy::Default',
            'Ticket::Frontend::AgentTicketWatchView###Order::Default',
            'Ticket::Frontend::AgentTicketWatchView###SortBy::Default',
            'Ticket::Frontend::PendingDiffTime',
            'Ticket::Frontend::ZoomExpandSort',
            'Ticket::ZoomTimeDisplay',
        );

        if ( grep { $SettingName eq $_ } @SettingsUserModificationActive ) {
            $Setting =~ s{(ConfigItem\sName=".*?")}{$1 UserModificationActive="1"}gsmx;
        }

        my @SettingsToDisable = (
            'PGP::Bin',
            'SMIME::Bin',
            'SMIME::CertPath',
            'SMIME::PrivatePath',
        );

        if ( grep { $SettingName eq $_ } @SettingsToDisable ) {
            $Setting =~ s{(ConfigItem\sName=".*?"\sRequired=)"1"(\sValid=)"1"}{$1"0"$2"0"}gsmx;
        }

        my %SettingsUserPreferencesGroup = (
            'Frontend::Admin::AdminNotificationEvent###RichTextHeight'                   => 'Advanced',
            'Frontend::Admin::AdminNotificationEvent###RichTextWidth'                    => 'Advanced',
            'Frontend::CustomerUser::Item###1-GoogleMaps'                                => 'Advanced',
            'Frontend::CustomerUser::Item###15-OpenTickets'                              => 'Advanced',
            'Frontend::CustomerUser::Item###16-OpenTicketsForCustomerUserLogin'          => 'Advanced',
            'Frontend::CustomerUser::Item###17-ClosedTickets'                            => 'Advanced',
            'Frontend::CustomerUser::Item###18-ClosedTicketsForCustomerUserLogin'        => 'Advanced',
            'Frontend::CustomerUser::Item###2-Google'                                    => 'Advanced',
            'Frontend::CustomerUser::Item###2-LinkedIn'                                  => 'Advanced',
            'Frontend::CustomerUser::Item###3-XING'                                      => 'Advanced',
            'Frontend::ToolBarModule###110-Ticket::AgentTicketQueue'                     => 'Advanced',
            'Frontend::ToolBarModule###120-Ticket::AgentTicketStatus'                    => 'Advanced',
            'Frontend::ToolBarModule###130-Ticket::AgentTicketEscalation'                => 'Advanced',
            'Frontend::ToolBarModule###140-Ticket::AgentTicketPhone'                     => 'Advanced',
            'Frontend::ToolBarModule###150-Ticket::AgentTicketEmail'                     => 'Advanced',
            'Frontend::ToolBarModule###160-Ticket::AgentTicketProcess'                   => 'Advanced',
            'Frontend::ToolBarModule###210-Ticket::TicketSearchProfile'                  => 'Advanced',
            'Frontend::ToolBarModule###220-Ticket::TicketSearchFulltext'                 => 'Advanced',
            'Frontend::ToolBarModule###230-CICSearchCustomerID'                          => 'Advanced',
            'Frontend::ToolBarModule###240-CICSearchCustomerUser'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketBounce###StateDefault'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###ArticleTypeDefault'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###Owner'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###Priority'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###PriorityDefault'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###Responsible'                            => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###State'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###StateDefault'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketBulk###TicketType'                             => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###ArticleTypeDefault'                    => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Body'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###InformAgent'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###InvolvedAgent'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Note'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###NoteMandatory'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Owner'                                 => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###OwnerMandatory'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Priority'                              => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###PriorityDefault'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Queue'                                 => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Responsible'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###ResponsibleMandatory'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###RichTextHeight'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###RichTextWidth'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Service'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###ServiceMandatory'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###SLAMandatory'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###State'                                 => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###StateDefault'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Subject'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###TicketType'                            => 'Advanced',
            'Ticket::Frontend::AgentTicketClose###Title'                                 => 'Advanced',
            'Ticket::Frontend::AgentTicketCompose###DefaultArticleType'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketCompose###StateDefault'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketCustomer::CustomerIDReadOnly'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail::CustomerIDReadOnly'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###ArticleType'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###Body'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###Priority'                              => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###RichTextHeight'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###RichTextWidth'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###ServiceMandatory'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###SLAMandatory'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###StateDefault'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketEmail###Subject'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketEmailOutbound###ArticleTypeDefault'            => 'Advanced',
            'Ticket::Frontend::AgentTicketEmailOutbound###RichTextHeight'                => 'Advanced',
            'Ticket::Frontend::AgentTicketEmailOutbound###RichTextWidth'                 => 'Advanced',
            'Ticket::Frontend::AgentTicketEmailOutbound###StateDefault'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketEscalationView###Order::Default'               => 'Advanced',
            'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default'              => 'Advanced',
            'Ticket::Frontend::AgentTicketForward###ArticleTypeDefault'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketForward###RichTextHeight'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketForward###RichTextWidth'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketForward###StateDefault'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###ArticleTypeDefault'                 => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Body'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###InformAgent'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###InvolvedAgent'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Note'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###NoteMandatory'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Owner'                              => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###OwnerMandatory'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Priority'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###PriorityDefault'                    => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Queue'                              => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Responsible'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###ResponsibleMandatory'               => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###RichTextHeight'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###RichTextWidth'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Service'                            => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###ServiceMandatory'                   => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###SLAMandatory'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###State'                              => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###StateDefault'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Subject'                            => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###TicketType'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketFreeText###Title'                              => 'Advanced',
            'Ticket::Frontend::AgentTicketLockedView###Order::Default'                   => 'Advanced',
            'Ticket::Frontend::AgentTicketLockedView###SortBy::Default'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketMerge###RichTextHeight'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketMerge###RichTextWidth'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###Body'                                   => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###NextScreen'                             => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###Note'                                   => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###NoteMandatory'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###Priority'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###RichTextHeight'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###RichTextWidth'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###State'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketMove###Subject'                                => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###ArticleTypeDefault'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Body'                                   => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###InformAgent'                            => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###InvolvedAgent'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Note'                                   => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###NoteMandatory'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Owner'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###OwnerMandatory'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Priority'                               => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###PriorityDefault'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Queue'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Responsible'                            => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###ResponsibleMandatory'                   => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###RichTextHeight'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###RichTextWidth'                          => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Service'                                => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###ServiceMandatory'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###SLAMandatory'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###State'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###StateDefault'                           => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Subject'                                => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###TicketType'                             => 'Advanced',
            'Ticket::Frontend::AgentTicketNote###Title'                                  => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###Blink'                                 => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###HideEmptyQueues'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###HighlightAge1'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###HighlightAge2'                         => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###Order::Default'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###QueueSort'                             => 'Advanced',
            'Ticket::Frontend::AgentTicketQueue###SortBy::Default'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###ArticleCreateTimePoint'    => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###ArticleCreateTimeSlot'     => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Body'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Cc'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###CustomerID'                => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###CustomerUserLogin'         => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###DynamicField'              => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###From'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Fulltext'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###QueueIDs'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###SearchInArchive'           => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###StateIDs'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Subject'                   => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketChangeTimePoint'     => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketChangeTimeSlot'      => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCloseTimePoint'      => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCloseTimeSlot'       => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCreateTimePoint'     => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketCreateTimeSlot'      => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketEscalationTimePoint' => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketEscalationTimeSlot'  => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###TicketNumber'              => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###Title'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Defaults###To'                        => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###Order::Default'                       => 'Advanced',
            'Ticket::Frontend::AgentTicketSearch###SortBy::Default'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketService###Order::Default'                      => 'Advanced',
            'Ticket::Frontend::AgentTicketService###SortBy::Default'                     => 'Advanced',
            'Ticket::Frontend::AgentTicketStatusView###Order::Default'                   => 'Advanced',
            'Ticket::Frontend::AgentTicketStatusView###SortBy::Default'                  => 'Advanced',
            'Ticket::Frontend::AgentTicketWatchView###Order::Default'                    => 'Advanced',
            'Ticket::Frontend::AgentTicketWatchView###SortBy::Default'                   => 'Advanced',
            'Ticket::Frontend::AgentTicketZoom###ProcessDisplay'                         => 'Advanced',
            'Ticket::Frontend::HTMLArticleHeightDefault'                                 => 'Advanced',
            'Ticket::Frontend::HTMLArticleHeightMax'                                     => 'Advanced',
            'Ticket::Frontend::MaxArticlesPerPage'                                       => 'Advanced',
            'Ticket::Frontend::PendingDiffTime'                                          => 'Advanced',
            'Ticket::Frontend::PlainView'                                                => 'Advanced',
            'Ticket::Frontend::TicketArticleFilter'                                      => 'Advanced',
            'Ticket::Frontend::ZoomCollectMeta'                                          => 'Advanced',
            'Ticket::Frontend::ZoomExpandSort'                                           => 'Advanced',
            'Ticket::Frontend::ZoomRichTextForce'                                        => 'Advanced',
            'Ticket::UseArticleColors'                                                   => 'Advanced',
            'Ticket::ZoomTimeDisplay'                                                    => 'Advanced',
            'TimeInputFormat'                                                            => 'Advanced',
        );

        if ( $SettingsUserPreferencesGroup{$SettingName} ) {
            $Setting
                =~ s{(ConfigItem\sName=".*?")}{$1 UserPreferencesGroup="$SettingsUserPreferencesGroup{$SettingName}"}gsmx;
        }
    }

    my $Result = join( "", @Settings );

    # Rename ConfigItem to Setting.
    $Result =~ s{<ConfigItem}{<Setting}gsmx;
    $Result =~ s{</ConfigItem}{</Setting}gsmx;

    # Remove empty lines
    $Result =~ s{>\n\n\s}{>\n }gsmx;

    # Remove white space at the end of the file
    $Result =~ s{</otrs_config>.*}{</otrs_config>}gsmx;

    # Add new line at the end
    $Result .= "\n";

    return $Result;
}

=head2 MigrateConfigEffectiveValues()

Migrate the configs effective values to the new format for OTRS 6.

    my $Result = $SysConfigMigrationObject->MigrateConfigEffectiveValues(
        FileClass       => $FileClass,
        FilePath        => $FilePath,
        NoOutput        => 1,                                       # ( 0 | 1 ) optional, default 0.
                                                                    # if set to 1 no info output will be printed to the screen.
        PackageSettings => [                                        # (optional) only migrate the given package settings
            'Frontend::Module###AdminGeneralCatalog',
            'Frontend::NavigationModule###AdminGeneralCatalog',
            'GeneralCatalogPreferences###Comment2',
            'GeneralCatalogPreferences###Permissions',
            'Loader::Agent::CommonJS###100-GeneralCatalog'
        ],
        ReturnMigratedSettingsCounts => 1,                          # (optional) returns an array with counts of un/successful migrated settings
    );

Returns:

    $Result = 1;    # True on success or false on error.
                    # or
                    # if ReturnMigratedSettingsCounts parameter is set
    $Result =  {
        AllSettingsCount      => 1,
        MissingSettings       => [],
        UnsuccessfullSettings => [],
    };

=cut

sub MigrateConfigEffectiveValues {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FileClass FilePath)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %OTRS5Config;
    delete $INC{ $Param{FilePath} };
    $Kernel::OM->Get('Kernel::System::Main')->Require( $Param{FileClass} );
    $Param{FileClass}->Load( \%OTRS5Config );

    # get all OTRS 6 default settings
    my @DefaultSettings = $SysConfigObject->ConfigurationList();

    # search for settings with ### in the name
    # my @SearchResult = grep /###/, sort values %DefaultSettings;
    my @SearchResult = grep { $_->{Name} =~ m{###} } @DefaultSettings;

    # find all the setting which have sublevels and store them in a hash
    my %SettingsWithSubLevels;
    for my $Setting (@SearchResult) {

        my @SettingNameParts = split /###/, $Setting->{Name};

        my $FirstLevelKey = shift @SettingNameParts;
        my $LastLevelKey  = pop @SettingNameParts;

        if (@SettingNameParts) {
            $SettingsWithSubLevels{$FirstLevelKey}->{ $SettingNameParts[0] }->{$LastLevelKey} = 1;
        }
        else {
            $SettingsWithSubLevels{$FirstLevelKey}->{$LastLevelKey} = 1;
        }
    }

    # build a lookup hash of all given package settings
    my %PackageSettingLookup;
    if ( IsArrayRefWithData( $Param{PackageSettings} ) ) {
        %PackageSettingLookup = map { $_ => 1 } @{ $Param{PackageSettings} };
    }

    # to store settings which do not exist in OTRS 6
    my @MissingSettings;

    # to store unsuccessfull settings which could not be migrated
    my @UnsuccessfullSettings;

    SETTINGNAME:
    for my $SettingName ( sort keys %OTRS5Config ) {

        # skip loader common settings
        next SETTINGNAME if $SettingName eq 'Loader::Agent::CommonCSS';
        next SETTINGNAME if $SettingName eq 'Loader::Agent::CommonJS';
        next SETTINGNAME if $SettingName eq 'Loader::Customer::CommonCSS';
        next SETTINGNAME if $SettingName eq 'Loader::Customer::CommonJS';

        # skip no longer existing sysconfig settings
        next SETTINGNAME if $SettingName eq 'CustomerPreferencesView';
        next SETTINGNAME if $SettingName eq 'DisableMSIFrameSecurityRestricted';
        next SETTINGNAME if $SettingName eq 'Frontend::AnimationEnabled';
        next SETTINGNAME if $SettingName eq 'LogModule::SysLog::LogSock';
        next SETTINGNAME if $SettingName eq 'PreferencesView';
        next SETTINGNAME if $SettingName eq 'Ticket::Frontend::ComposeExcludeCcRecipients';
        next SETTINGNAME if $SettingName eq 'TimeZoneUser';
        next SETTINGNAME if $SettingName eq 'TimeZoneUserBrowserAutoOffset';
        next SETTINGNAME if $SettingName eq 'Ticket::StorageModule';
        next SETTINGNAME if $SettingName eq 'Ticket::StorageModule::CheckAllBackends';
        next SETTINGNAME if $SettingName eq 'ArticleDir';

        # check if this OTRS5 setting has subhashes in the name
        if ( $SettingsWithSubLevels{$SettingName} ) {

            SETTINGKEYFIRSTLEVEL:
            for my $SettingKeyFirstLevel ( sort keys %{ $OTRS5Config{$SettingName} } ) {

                # there is a second level
                # example: Ticket::Frontend::AgentTicketZoom###Widgets###0100-TicketInformation
                if (
                    $SettingsWithSubLevels{$SettingName}->{$SettingKeyFirstLevel}
                    && IsHashRefWithData( $SettingsWithSubLevels{$SettingName}->{$SettingKeyFirstLevel} )
                    && IsHashRefWithData( $OTRS5Config{$SettingName}->{$SettingKeyFirstLevel} )
                    )
                {

                    SETTINGKEYSECONDLEVEL:
                    for my $SettingKeySecondLevel (
                        sort keys %{ $OTRS5Config{$SettingName}->{$SettingKeyFirstLevel} }
                        )
                    {

                        # get the effective value from the OTRS 5 config
                        my $OTRS5EffectiveValue
                            = $OTRS5Config{$SettingName}->{$SettingKeyFirstLevel}->{$SettingKeySecondLevel};

                        # build the new setting key
                        my $NewSettingKey
                            = $SettingName . '###' . $SettingKeyFirstLevel . '###' . $SettingKeySecondLevel;

                        # check and convert config name if it has been renamed in OTRS 6
                        # otherwise it will use the given old name
                        $NewSettingKey = _LookupNewConfigName(
                            OldName => $NewSettingKey,
                        );

                        # skip settings which are not in the given package settings
                        if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingKey} ) {
                            next SETTINGKEYSECONDLEVEL;
                        }

                        # try to get the default setting from OTRS 6 for the new setting name
                        my %OTRS6Setting = $SysConfigObject->SettingGet(
                            Name  => $NewSettingKey,
                            NoLog => 1,
                        );

                        # skip settings which already have been modified in the meantime
                        next SETTINGKEYSECONDLEVEL if $OTRS6Setting{ModifiedID};

                        # skip this setting if it is a readonly setting
                        next SETTINGKEYSECONDLEVEL if $OTRS6Setting{IsReadonly};

                        # log if there is a setting that can not be found in OTRS 6 (might come from packages)
                        if ( !%OTRS6Setting ) {
                            push @MissingSettings, $NewSettingKey;
                            next SETTINGKEYSECONDLEVEL;
                        }

                        # check if the setting value structure from OTRS 5 is still valid on OTRS6
                        my %Result = $SysConfigObject->SettingEffectiveValueCheck(
                            EffectiveValue   => $OTRS5EffectiveValue,
                            XMLContentParsed => $OTRS6Setting{XMLContentParsed},
                            NoValidation     => 1,
                            UserID           => 1,
                        );

                        if ( !$Result{Success} ) {
                            push @UnsuccessfullSettings, $NewSettingKey;
                            next SETTINGKEYSECONDLEVEL;
                        }

                        # lock the setting
                        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                            Name   => $NewSettingKey,
                            Force  => 1,
                            UserID => 1,
                        );

                        # update the setting
                        %Result = $SysConfigObject->SettingUpdate(
                            Name              => $NewSettingKey,
                            IsValid           => 1,
                            EffectiveValue    => $OTRS5EffectiveValue,
                            ExclusiveLockGUID => $ExclusiveLockGUID,
                            NoValidation      => 1,
                            UserID            => 1,
                        );

                        # unlock the setting again
                        $SysConfigObject->SettingUnlock(
                            Name => $NewSettingKey,
                        );

                        if ( !$Result{Success} ) {
                            push @UnsuccessfullSettings, $NewSettingKey;
                            next SETTINGKEYSECONDLEVEL;
                        }
                    }
                }

                # there is only one level
                # example: Ticket::Frontend::AgentTicketService###StripEmptyLines
                else {

                    # get the effective value from the OTRS 5 config
                    my $OTRS5EffectiveValue = $OTRS5Config{$SettingName}->{$SettingKeyFirstLevel};

                    # build the new setting key
                    my $NewSettingKey = $SettingName . '###' . $SettingKeyFirstLevel;

                    # check and convert config name if it has been renamed in OTRS 6
                    # otherwise it will use the given old name
                    $NewSettingKey = _LookupNewConfigName(
                        OldName => $NewSettingKey,
                    );

                    # skip settings which are not in the given package settings
                    if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingKey} ) {
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # try to get the default setting from OTRS 6 for the modified setting name
                    my %OTRS6Setting = $SysConfigObject->SettingGet(
                        Name  => $NewSettingKey,
                        NoLog => 1,
                    );

                    # skip settings which already have been modified in the meantime
                    next SETTINGKEYFIRSTLEVEL if $OTRS6Setting{ModifiedID};

                    # skip this setting if it is a readonly setting
                    next SETTINGKEYFIRSTLEVEL if $OTRS6Setting{IsReadonly};

                    # log if there is a setting that can not be found in OTRS 6 (might come from packages)
                    if ( !%OTRS6Setting ) {
                        push @MissingSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # migrate frontend module registrations
                    if (
                        $SettingName eq 'Frontend::Module'
                        || $SettingName eq 'CustomerFrontend::Module'
                        || $SettingName eq 'PublicFrontend::Module'
                        )
                    {

                        # migrate (and split) the frontend module settings
                        my $Result = _MigrateFrontendModuleSetting(
                            FrontendModuleName  => $SettingKeyFirstLevel,
                            OTRS5EffectiveValue => $OTRS5EffectiveValue,
                            OTRS6Setting        => \%OTRS6Setting,
                        );

                        # success
                        next SETTINGKEYFIRSTLEVEL if $Result;

                        # error
                        push @UnsuccessfullSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # migrate preferences groups settings
                    if ( $SettingName eq 'PreferencesGroups' ) {

                        # delete no longer needed column key
                        delete $OTRS5EffectiveValue->{Column};

                        # add new PreferenceGroup key from OTRS 6
                        $OTRS5EffectiveValue->{PreferenceGroup} = $OTRS6Setting{EffectiveValue}->{PreferenceGroup};
                    }

                    # check if the setting value structure from OTRS 5 is still valid on OTRS6
                    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
                        EffectiveValue   => $OTRS5EffectiveValue,
                        XMLContentParsed => $OTRS6Setting{XMLContentParsed},
                        NoValidation     => 1,
                        UserID           => 1,
                    );

                    if ( !$Result{Success} ) {
                        push @UnsuccessfullSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }

                    # lock the setting
                    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                        Name   => $NewSettingKey,
                        Force  => 1,
                        UserID => 1,
                    );

                    # update the setting
                    %Result = $SysConfigObject->SettingUpdate(
                        Name              => $NewSettingKey,
                        IsValid           => 1,
                        EffectiveValue    => $OTRS5EffectiveValue,
                        ExclusiveLockGUID => $ExclusiveLockGUID,
                        NoValidation      => 1,
                        UserID            => 1,
                    );

                    # unlock the setting again
                    $SysConfigObject->SettingUnlock(
                        Name => $NewSettingKey,
                    );

                    if ( !$Result{Success} ) {
                        push @UnsuccessfullSettings, $NewSettingKey;
                        next SETTINGKEYFIRSTLEVEL;
                    }
                }
            }
        }

        # setting has no subhashes in the name
        # example: Cache::Module
        else {

            # skip TimeZone::Calendar settings (they are handled else where)
            next SETTINGNAME if $SettingName =~ m{ \A TimeZone::Calendar[1-9] \z }xms;

            # check and convert config name if it has been renamed in OTRS 6
            # otherwise it will use the given old name
            my $NewSettingName = _LookupNewConfigName(
                OldName => $SettingName,
            );

            # skip settings which are not in the given package settings
            if ( %PackageSettingLookup && !$PackageSettingLookup{$NewSettingName} ) {
                next SETTINGNAME;
            }

            # get the (default) setting from OTRS 6 for this setting name
            my %OTRS6Setting = $SysConfigObject->SettingGet(
                Name  => $NewSettingName,
                NoLog => 1,
            );

            # skip this setting if it has already been modified in the meantime
            next SETTINGNAME if $OTRS6Setting{ModifiedID};

            # skip this setting if it is a readonly setting
            next SETTINGNAME if $OTRS6Setting{IsReadonly};

            # Log if there is a setting that can not be found in OTRS 6 (might come from packages)
            if ( !%OTRS6Setting ) {
                push @MissingSettings, $NewSettingName;
                next SETTINGNAME;
            }

            my $OTRS5EffectiveValue = $OTRS5Config{$NewSettingName};

            # the ticket number generator random is dropped from OTRS 6, enforce that DateChecksum is set instead
            if (
                $NewSettingName eq 'Ticket::NumberGenerator'
                && $OTRS5EffectiveValue eq 'Kernel::System::Ticket::Number::Random'
                )
            {
                $OTRS5EffectiveValue = 'Kernel::System::Ticket::Number::DateChecksum';
            }

            # check if the setting value structure from OTRS 5 is still valid on OTRS6
            my %Result = $SysConfigObject->SettingEffectiveValueCheck(
                EffectiveValue   => $OTRS5EffectiveValue,
                XMLContentParsed => $OTRS6Setting{XMLContentParsed},
                NoValidation     => 1,
                UserID           => 1,
            );

            if ( !$Result{Success} ) {

                push @UnsuccessfullSettings, $NewSettingName;
                next SETTINGNAME;
            }

            # lock the setting
            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                Name   => $NewSettingName,
                Force  => 1,
                UserID => 1,
            );

            # update the setting
            %Result = $SysConfigObject->SettingUpdate(
                Name              => $NewSettingName,
                IsValid           => 1,
                EffectiveValue    => $OTRS5EffectiveValue,
                ExclusiveLockGUID => $ExclusiveLockGUID,
                NoValidation      => 1,
                UserID            => 1,
            );

            # unlock the setting again
            $SysConfigObject->SettingUnlock(
                Name => $NewSettingName,
            );

            if ( !$Result{Success} ) {
                push @UnsuccessfullSettings, $NewSettingName;
                next SETTINGNAME;
            }
        }
    }

    # do not print the following status output if not wanted
    return 1 if $Param{NoOutput};

    my $AllSettingsCount = scalar keys %OTRS5Config;

    # TODO: Add explanation for the following output values
    print "AllSettingsCount: " . $AllSettingsCount . "\n";
    print "MissingCount: " . scalar @MissingSettings . "\n";
    print "UnsuccessfullCount: " . scalar @UnsuccessfullSettings . "\n\n";

    # TODO: Maybe do not show the missing settings in the final version, just the Missing count above.
    if (@MissingSettings) {
        print "\nMissing Settings: \n";
        for my $Setting (@MissingSettings) {
            print $Setting . "\n";
        }
    }

    if (@UnsuccessfullSettings) {
        print "\nUnsuccessfull Settings: \n";
        for my $Setting (@UnsuccessfullSettings) {
            print $Setting . "\n";
        }
    }

    print "\n\n";

    if ( $Param{ReturnMigratedSettingsCounts} ) {
        return {
            AllSettingsCount      => $AllSettingsCount,
            MissingSettings       => \@MissingSettings,
            UnsuccessfullSettings => \@UnsuccessfullSettings,
        };
    }

    return 1;
}

=head2 NavigationLookupGet()

Get a list of all old Sub-Groups and the corresponding new navigation.

    my %NavigationLookup = $SysConfigMigrationObject->NavigationLookupGet();

Returns:

    %NavigationLookup = (
        'Old::Subgroup' => 'New::Navigation',
        # ...
    );

=cut

sub NavigationLookupGet {
    my ( $Self, %Param ) = @_;

    return (
        'CloudService::Admin::ModuleRegistration'      => 'CloudService::Admin::ModuleRegistration',
        'ConfigLog'                                    => 'ConfigLog',
        'ConfigSwitch'                                 => 'ConfigSwitch',
        'Core'                                         => 'Core',
        'Core::AppointmentCalendar::Event'             => 'Core::Event::AppointmentCalendar',
        'Core::Cache'                                  => 'Core::Cache',
        'Core::CustomerCompany'                        => 'Core::CustomerCompany',
        'Core::CustomerUser'                           => 'Core::CustomerUser',
        'Core::Daemon::ModuleRegistration'             => 'Daemon::ModuleRegistration',
        'Core::DynamicField'                           => 'Core::DynamicFields',
        'Core::Fetchmail'                              => 'Core::Email',
        'Core::FulltextSearch'                         => 'Core::Ticket::FulltextSearch',
        'Core::LinkObject'                             => 'Core::LinkObject',
        'Core::Log'                                    => 'Core::Log',
        'Core::MIME-Viewer'                            => 'Frontend::Agent::MIMEViewer',
        'Core::MirrorDB'                               => 'Core::DB::Mirror',
        'Core::OTRSBusiness'                           => 'Core::OTRSBusiness',
        'Core::Package'                                => 'Core::Package',
        'Core::PDF'                                    => 'Core::PDF',
        'Core::PerformanceLog'                         => 'Core::PerformanceLog',
        'Core::PostMaster'                             => 'Core::Email::PostMaster',
        'Core::Queue'                                  => 'Core::Queue',
        'Core::ReferenceData'                          => 'Core::ReferenceData',
        'Core::Sendmail'                               => 'Core::Email',
        'Core::Session'                                => 'Core::Session',
        'Core::SOAP'                                   => 'Core::SOAP',
        'Core::Stats'                                  => 'Core::Stats',
        'Core::Ticket'                                 => 'Core::Ticket',
        'Core::TicketACL'                              => 'Core::Ticket::ACL',
        'Core::TicketBulkAction'                       => 'Frontend::Agent::View::TicketBulk',
        'Core::TicketDynamicFieldDefault'              => 'Core::Ticket::DynamicFieldDefault',
        'Core::TicketWatcher'                          => 'Core::Ticket',
        'Core::Time'                                   => 'Core::Time',
        'Core::Time::Calendar1'                        => 'Core::Time::Calendar1',
        'Core::Time::Calendar2'                        => 'Core::Time::Calendar2',
        'Core::Time::Calendar3'                        => 'Core::Time::Calendar3',
        'Core::Time::Calendar4'                        => 'Core::Time::Calendar4',
        'Core::Time::Calendar5'                        => 'Core::Time::Calendar5',
        'Core::Time::Calendar6'                        => 'Core::Time::Calendar6',
        'Core::Time::Calendar7'                        => 'Core::Time::Calendar7',
        'Core::Time::Calendar8'                        => 'Core::Time::Calendar8',
        'Core::Time::Calendar9'                        => 'Core::Time::Calendar9',
        'Core::Transition'                             => 'Core::ProcessManagement',
        'Core::Web'                                    => 'Frontend::Base',
        'Core::WebUserAgent'                           => 'Core::WebUserAgent',
        'Crypt::PGP'                                   => 'Core::Crypt::PGP',
        'Crypt::SMIME'                                 => 'Core::Crypt::SMIME',
        'CustomerInformationCenter'                    => 'Frontend::Agent::View::CustomerInformationCenter',
        'Daemon::SchedulerCronTaskManager::Task'       => 'Daemon::SchedulerCronTaskManager::Task',
        'Daemon::SchedulerGenericAgentTaskManager'     => 'Daemon::SchedulerGenericAgentTaskManager',
        'Daemon::SchedulerGenericInterfaceTaskManager' => 'Daemon::SchedulerGenericInterfaceTaskManager',
        'Daemon::SchedulerTaskWorker'                  => 'Daemon::SchedulerTaskWorker',
        'DynamicFields::Driver::Registration'          => 'Core::DynamicFields::DriverRegistration',
        'DynamicFields::ObjectType::Registration'      => 'Core::DynamicFields::ObjectTypeRegistration',

        # 'Frontend::Admin'                                  => 'Frontend::Admin',
        'Frontend::Admin::AdminCustomerCompany'   => 'Frontend::Admin::View::CustomerCompany',
        'Frontend::Admin::AdminCustomerUser'      => 'Frontend::Admin::View::CustomerUser',
        'Frontend::Admin::AdminNotificationEvent' => 'Frontend::Admin::View::NotificationEvent',
        'Frontend::Admin::AdminSelectBox'         => 'Frontend::Admin::View::SelectBox',

        # 'Frontend::Admin::ModuleRegistration'              => 'Frontend::Admin::ModuleRegistration',
        'Frontend::Admin::SearchRouter'                    => 'Frontend::Admin::ModuleRegistration::MainMenu::Search',
        'Frontend::Agent'                                  => 'Frontend::Agent',
        'Frontend::Agent::Auth::TwoFactor'                 => 'Core::Auth::Agent::TwoFactor',
        'Frontend::Agent::Dashboard'                       => 'Frontend::Agent::View::Dashboard',
        'Frontend::Agent::Dashboard::EventsTicketCalendar' => 'Frontend::Agent::View::Dashboard::EventsTicketCalendar',
        'Frontend::Agent::Dashboard::TicketFilters'        => 'Frontend::Agent::View::Dashboard::TicketFilters',
        'Frontend::Agent::LinkObject'                      => 'Frontend::Agent::LinkObject',
        'Frontend::Agent::ModuleMetaHead'                  => 'Frontend::Agent',
        'Frontend::Agent::ModuleNotify'                    => 'Frontend::Agent::FrontendNotification',
        'Frontend::Agent::NavBarModule'                    => 'Frontend::Agent::ModuleRegistration',
        'Frontend::Agent::Preferences'                     => 'Frontend::Agent::View::Preferences',
        'Frontend::Agent::SearchRouter'                    => 'Frontend::Agent::ModuleRegistration::MainMenu::Search',
        'Frontend::Agent::Stats'                           => 'Frontend::Agent::Stats',
        'Frontend::Agent::Ticket::ArticleAttachmentModule' => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::Ticket::ArticleComposeModule'    => 'Frontend::Agent::ArticleComposeModule',
        'Frontend::Agent::Ticket::ArticleViewModule'       => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::Ticket::ArticleViewModulePre'    => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::Ticket::MenuModule'              => 'Frontend::Agent::View::TicketZoom::MenuModule',
        'Frontend::Agent::Ticket::MenuModulePre'           => 'Frontend::Agent::TicketOverview::MenuModule',
        'Frontend::Agent::Ticket::OverviewMenuModule'      => 'Frontend::Agent::TicketOverview::MenuModule',
        'Frontend::Agent::Ticket::ViewBounce'              => 'Frontend::Agent::View::TicketBounce',
        'Frontend::Agent::Ticket::ViewBulk'                => 'Frontend::Agent::View::TicketBulk',
        'Frontend::Agent::Ticket::ViewClose'               => 'Frontend::Agent::View::TicketClose',
        'Frontend::Agent::Ticket::ViewCompose'             => 'Frontend::Agent::View::TicketCompose',
        'Frontend::Agent::Ticket::ViewCustomer'            => 'Frontend::Agent::View::TicketCustomer',
        'Frontend::Agent::Ticket::ViewEmailNew'            => 'Frontend::Agent::View::TicketEmailNew',
        'Frontend::Agent::Ticket::ViewEmailOutbound'       => 'Frontend::Agent::View::TicketEmailOutbound',
        'Frontend::Agent::Ticket::ViewEscalation'          => 'Frontend::Agent::View::TicketEscalation',
        'Frontend::Agent::Ticket::ViewForward'             => 'Frontend::Agent::View::TicketForward',
        'Frontend::Agent::Ticket::ViewFreeText'            => 'Frontend::Agent::View::TicketFreeText',
        'Frontend::Agent::Ticket::ViewHistory'             => 'Frontend::Agent::View::TicketHistory',
        'Frontend::Agent::Ticket::ViewLocked'              => 'Frontend::Agent::View::TicketLocked',
        'Frontend::Agent::Ticket::ViewMerge'               => 'Frontend::Agent::View::TicketMerge',
        'Frontend::Agent::Ticket::ViewMove'                => 'Frontend::Agent::View::TicketMove',
        'Frontend::Agent::Ticket::ViewNote'                => 'Frontend::Agent::View::TicketNote',
        'Frontend::Agent::Ticket::ViewOwner'               => 'Frontend::Agent::View::TicketOwner',
        'Frontend::Agent::Ticket::ViewPending'             => 'Frontend::Agent::View::TicketPending',
        'Frontend::Agent::Ticket::ViewPhoneInbound'        => 'Frontend::Agent::View::TicketPhoneInbound',
        'Frontend::Agent::Ticket::ViewPhoneNew'            => 'Frontend::Agent::View::TicketPhoneNew',
        'Frontend::Agent::Ticket::ViewPhoneOutbound'       => 'Frontend::Agent::View::TicketPhoneOutbound',
        'Frontend::Agent::Ticket::ViewPrint'               => 'Frontend::Agent::View::TicketPrint',
        'Frontend::Agent::Ticket::ViewPriority'            => 'Frontend::Agent::View::TicketPriority',
        'Frontend::Agent::Ticket::ViewProcess'             => 'Frontend::Agent::View::TicketProcess',
        'Frontend::Agent::Ticket::ViewQueue'               => 'Frontend::Agent::View::TicketQueue',
        'Frontend::Agent::Ticket::ViewResponsible'         => 'Frontend::Agent::View::TicketResponsible',
        'Frontend::Agent::Ticket::ViewSearch'              => 'Frontend::Agent::View::TicketSearch',
        'Frontend::Agent::Ticket::ViewService'             => 'Frontend::Agent::View::TicketService',
        'Frontend::Agent::Ticket::ViewStatus'              => 'Frontend::Agent::View::TicketStatus',
        'Frontend::Agent::Ticket::ViewWatch'               => 'Frontend::Agent::View::TicketWatch',
        'Frontend::Agent::Ticket::ViewZoom'                => 'Frontend::Agent::View::TicketZoom',
        'Frontend::Agent::TicketOverview'                  => 'Frontend::Agent::TicketOverview',
        'Frontend::Agent::ToolBarModule'                   => 'Frontend::Agent::ToolBar',
        'Frontend::Agent::ViewCustomerUserSearch'          => 'Frontend::Agent::View::CustomerUserAddressBook',
        'Frontend::Agent::CustomerInformationCenter'       => 'Frontend::Agent::View::CustomerInformationCenter',
        'Frontend::Agent::Stats'                           => 'Frontend::Agent::View::Stats',
        'Frontend::Customer'                               => 'Frontend::Customer',
        'Frontend::Customer::Auth'                         => 'Core::Auth::Customer',
        'Frontend::Customer::Auth::TwoFactor'              => 'Core::Auth::Customer::TwoFactor',
        'Frontend::Customer::ModuleMetaHead'               => 'Frontend::Customer',
        'Frontend::Customer::ModuleNotify'                 => 'Frontend::Customer::FrontendNotification',
        'Frontend::Customer::ModuleRegistration'           => 'Frontend::Customer::ModuleRegistration',
        'Frontend::Customer::NavBarModule'                 => 'Frontend::Customer::ModuleRegistration',
        'Frontend::Customer::Preferences'                  => 'Frontend::Customer::View::Preferences',
        'Frontend::Customer::Ticket::ViewNew'              => 'Frontend::Customer::View::TicketMessage',
        'Frontend::Customer::Ticket::ViewPrint'            => 'Frontend::Customer::View::TicketPrint',
        'Frontend::Customer::Ticket::ViewSearch'           => 'Frontend::Customer::View::TicketSearch',
        'Frontend::Customer::Ticket::ViewZoom'             => 'Frontend::Customer::View::TicketZoom',
        'Frontend::Customer::TicketOverview'               => 'Frontend::Customer::View::TicketOverview',
        'Frontend::Public'                                 => 'Frontend::Public',
        'Frontend::Public::ModuleRegistration'             => 'Frontend::Public::ModuleRegistration',
        'Frontend::Queue::Preferences'                     => 'Core::Queue',
        'Frontend::Service::Preferences'                   => 'Core::Service',
        'Frontend::SLA::Preferences'                       => 'Core::SLA',
        'GenericInterface::Invoker::ModuleRegistration'    => 'GenericInterface::Invoker::ModuleRegistration',
        'GenericInterface::Mapping::ModuleRegistration'    => 'GenericInterface::Mapping::ModuleRegistration',
        'GenericInterface::Operation::ModuleRegistration'  => 'GenericInterface::Operation::ModuleRegistration',
        'GenericInterface::Operation::ResponseLoggingMaxSize' => 'GenericInterface::Operation::ResponseLoggingMaxSize',
        'GenericInterface::Operation::TicketCreate'           => 'GenericInterface::Operation::TicketCreate',
        'GenericInterface::Operation::TicketSearch'           => 'GenericInterface::Operation::TicketSearch',
        'GenericInterface::Operation::TicketUpdate'           => 'GenericInterface::Operation::TicketUpdate',
        'GenericInterface::Transport::ModuleRegistration'     => 'GenericInterface::Transport::ModuleRegistration',
        'GenericInterface::Webservice'                        => 'GenericInterface::Webservice',
        'SystemMaintenance'                                   => 'Core::SystemMaintenance',

        # Packages
        'OutputFilter' => 'Frontend::Base::OutputFilter',

        # OTRSBusiness
        'Core::NotificationEvent'               => 'Frontend::Agent::View::NotificationView',
        'Core::NotificationView'                => 'Frontend::Agent::View::NotificationView',
        'Core::NotificationView::BulkAction'    => 'Frontend::Agent::View::NotificationView',
        'Frontend::Agent::NotificationView'     => 'Frontend::Agent::View::NotificationView',
        'Frontend'                              => 'Frontend::Base',
        'Frontend::Admin::AdminContactWithData' => 'Frontend::Admin::View::ContactWithData',
    );
}

=head1 PRIVATE INTERFACE

=head2 _LookupNewConfigName()

Helper function to lookup new config names for configuration settings
where the name has been changed from OTRS 5 to OTRS 6.

    my $NewName = $SysConfigMigrationObject->_LookupNewConfigName(
        OldName => 'CustomerCompany::EventModulePost###100-UpdateCustomerUsers',
    );

Returns:

    True on success or false on error.

=cut

sub _LookupNewConfigName {
    my (%Param) = @_;

    # check needed stuff
    if ( !$Param{OldName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OldName!",
        );
        return;
    }

    # mapping table: old name -> new name
    my %Old2NewName = (
        'CustomerCompany::EventModulePost###100-UpdateCustomerUsers' =>
            'CustomerCompany::EventModulePost###2000-UpdateCustomerUsers',

        'CustomerCompany::EventModulePost###1000-GenericInterface' =>
            'CustomerCompany::EventModulePost###9900-GenericInterface',

        'CustomerCompany::EventModulePost###110-UpdateTickets' =>
            'CustomerCompany::EventModulePost###2300-UpdateTickets',

        'CustomerUser::EventModulePost###100-UpdateSearchProfiles' =>
            'CustomerUser::EventModulePost###2100-UpdateSearchProfiles',

        'CustomerUser::EventModulePost###100-UpdateServiceMembership' =>
            'CustomerUser::EventModulePost###2200-UpdateServiceMembership',

        'CustomerUser::EventModulePost###1000-GenericInterface' =>
            'CustomerUser::EventModulePost###9900-GenericInterface',

        'CustomerUser::EventModulePost###120-UpdateTickets' =>
            'CustomerUser::EventModulePost###2300-UpdateTickets',

        'DynamicField::EventModulePost###1000-GenericInterface' =>
            'DynamicField::EventModulePost###9900-GenericInterface',

        'Frontend::NotifyModule###100-CloudServicesDisabled' =>
            'Frontend::NotifyModule###1000-CloudServicesDisabled',

        'Frontend::NotifyModule###100-OTRSBusiness' =>
            'Frontend::NotifyModule###1100-OTRSBusiness',

        'Frontend::NotifyModule###200-UID-Check' =>
            'Frontend::NotifyModule###2000-UID-Check',

        'Frontend::NotifyModule###250-AgentSessionLimit' =>
            'Frontend::NotifyModule###2500-AgentSessionLimit',

        'Frontend::NotifyModule###500-OutofOffice-Check' =>
            'Frontend::NotifyModule###5500-OutofOffice-Check',

        'Frontend::NotifyModule###600-SystemMaintenance-Check' =>
            'Frontend::NotifyModule###6000-SystemMaintenance-Check',

        'Frontend::NotifyModule###800-Daemon-Check' =>
            'Frontend::NotifyModule###8000-Daemon-Check',

        'Frontend::ToolBarModule###7-Ticket::TicketResponsible' =>
            'Frontend::ToolBarModule###170-Ticket::TicketResponsible',

        'Frontend::ToolBarModule###8-Ticket::TicketWatcher' =>
            'Frontend::ToolBarModule###180-Ticket::TicketWatcher',

        'Frontend::ToolBarModule###9-Ticket::TicketLocked' =>
            'Frontend::ToolBarModule###190-Ticket::TicketLocked',

        'Package::EventModulePost###1000-GenericInterface' =>
            'Package::EventModulePost###9900-GenericInterface',

        'Package::EventModulePost###99-SupportDataSend' =>
            'Package::EventModulePost###9000-SupportDataSend',

        'Queue::EventModulePost###1000-GenericInterface' =>
            'Queue::EventModulePost###9900-GenericInterface',

        'Queue::EventModulePost###130-UpdateQueue' =>
            'Queue::EventModulePost###2300-UpdateQueue',

        'Ticket::EventModulePost###098-ArticleSearchIndex' =>
            'Ticket::EventModulePost###2000-ArticleSearchIndex',

        'Ticket::EventModulePost###100-ArchiveRestore' =>
            'Ticket::EventModulePost###2300-ArchiveRestore',

        'Ticket::EventModulePost###110-AcceleratorUpdate' =>
            'Ticket::EventModulePost###2600-AcceleratorUpdate',

        'Ticket::EventModulePost###140-ResponsibleAutoSet' =>
            'Ticket::EventModulePost###3000-ResponsibleAutoSet',

        'Ticket::EventModulePost###150-TicketPendingTimeReset' =>
            'Ticket::EventModulePost###3300-TicketPendingTimeReset',

        'Ticket::EventModulePost###500-NotificationEvent' =>
            'Ticket::EventModulePost###7000-NotificationEvent',

        'Ticket::EventModulePost###900-GenericAgent' =>
            'Ticket::EventModulePost###9700-GenericAgent',

        'Ticket::EventModulePost###910-EscalationIndex' =>
            'Ticket::EventModulePost###6000-EscalationIndex',

        'Ticket::EventModulePost###920-EscalationStopEvents' =>
            'Ticket::EventModulePost###4300-EscalationStopEvents',

        'Ticket::EventModulePost###930-ForceUnlockOnMove' =>
            'Ticket::EventModulePost###3600-ForceUnlockOnMove',

        'Ticket::EventModulePost###940-TicketArticleNewMessageUpdate' =>
            'Ticket::EventModulePost###4000-TicketArticleNewMessageUpdate',

        'Ticket::EventModulePost###998-TicketProcessTransitions' =>
            'Ticket::EventModulePost###9800-TicketProcessTransitions',

        'Ticket::EventModulePost###999-GenericInterface' =>
            'Ticket::EventModulePost###9900-GenericInterface',

        'Ticket::Frontend::ArticleComposeModule###1-SignEmail' =>
            'Ticket::Frontend::ArticleComposeModule###2-SignEmail',

        'Ticket::Frontend::ArticleComposeModule###2-CryptEmail' =>
            'Ticket::Frontend::ArticleComposeModule###3-CryptEmail',

        'Ticket::Frontend::ArticlePreViewModule###1-SMIME' =>
            'Ticket::Frontend::ArticlePreViewModule###2-SMIME',
    );

    # get the new name if found, otherwise use the given old name
    my $NewName = $Old2NewName{ $Param{OldName} } || $Param{OldName};

    return $NewName;
}

=head2 _MigrateFrontendModuleSetting()

Helper function to migrate a frontend module setting from OTRS 5 to OTRS 6.

    my $NewName = $SysConfigMigrationObject->_MigrateFrontendModuleSetting(
        FrontendModuleName  => 'AgentTicketQueue',
        OTRS5EffectiveValue => {
            'Description' => 'Overview of all open Tickets.',
            'Group' => [ 'users', 'admin' ],
            'GroupRo' => [ 'stats' ],
            'Loader' => {
                'CSS' => [
                    'Core.AgentTicketQueue.css',
                    'Core.AllocationList.css'
                ],
                'JavaScript' => [
                  'Core.UI.AllocationList.js',
                  'Core.Agent.TableFilters.js'
                ],
            },
            'NavBar' => [
                {
                  'AccessKey' => 'o',
                  'Block' => '',
                  'Description' => 'Overview of all open Tickets. xxx xxx',
                  'Link' => 'Action=AgentTicketQueue',
                  'LinkOption' => '',
                  'Name' => 'Queue view',
                  'NavBar' => 'Ticket',
                  'Prio' => '100',
                  'Type' => ''
                },
                {
                  'AccessKey' => 't',
                  'Block' => 'ItemArea',
                  'Description' => 'xxx',
                  'Link' => 'Action=AgentTicketQueue',
                  'LinkOption' => '',
                  'Name' => 'Tickets',
                  'NavBar' => 'Ticket',
                  'Prio' => '200',
                  'Type' => 'Menu'
                }
              ],
            'NavBarName' => 'Ticket',
            'Title' => 'QueueView',
        },
        OTRS6Setting => \%OTRS6Setting,
    );

Returns:

    True on success or false on error.

=cut

sub _MigrateFrontendModuleSetting {
    my (%Param) = @_;

    # check needed stuff
    for my $Needed (qw(FrontendModuleName OTRS5EffectiveValue OTRS6Setting)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get the group settings from OTRS 5 config
    my @Group   = @{ $Param{OTRS5EffectiveValue}->{Group}   || [] };
    my @GroupRo = @{ $Param{OTRS5EffectiveValue}->{GroupRo} || [] };

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # ###########################################################################
    # migrate the frontend module setting
    # (it will contain only the registration,
    # loader and navigation settings will be separate settings now)
    # ###########################################################################

    # set some attributes from OTRS 5
    ATTRIBUTE:
    for my $Attribute (qw(Description Title NavBarName)) {
        next ATTRIBUTE if !$Param{OTRS5EffectiveValue}->{$Attribute};
        $Param{OTRS6Setting}->{EffectiveValue}->{$Attribute} = $Param{OTRS5EffectiveValue}->{$Attribute};
    }

    # set group settings from OTRS 5
    $Param{OTRS6Setting}->{EffectiveValue}->{Group}   = \@Group;
    $Param{OTRS6Setting}->{EffectiveValue}->{GroupRo} = \@GroupRo;

    # check if the setting value structure from OTRS 5 is still valid on OTRS 6
    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
        EffectiveValue   => $Param{OTRS5EffectiveValue},
        XMLContentParsed => $Param{OTRS6Setting}->{XMLContentParsed},
        NoValidation     => 1,
        UserID           => 1,
    );

    return if !$Result{Success};

    # lock the setting
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $Param{OTRS6Setting}->{Name},
        Force  => 1,
        UserID => 1,
    );

    # update the setting
    %Result = $SysConfigObject->SettingUpdate(
        Name              => $Param{OTRS6Setting}->{Name},
        IsValid           => 1,
        EffectiveValue    => $Param{OTRS6Setting}->{EffectiveValue},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        NoValidation      => 1,
        UserID            => 1,
    );

    # unlock the setting again
    $SysConfigObject->SettingUnlock(
        Name => $Param{OTRS6Setting}->{Name},
    );

    return if !$Result{Success};

    # ###########################################################################
    # migrate the NavBar settings
    # ###########################################################################
    if ( $Param{OTRS5EffectiveValue}->{NavBar} ) {

        # get all OTRS 6 default settings
        my @DefaultSettings = $SysConfigObject->ConfigurationList();

        # search for OTRS 6 NavBar settings
        #
        # this will find settings like:
        #            Frontend::Navigation###
        #    CustomerFrontend::Navigation###
        #      PublicFrontend::Navigation###
        #
        my $Search = 'Frontend::Navigation###' . $Param{FrontendModuleName} . '###';
        my @SearchResult = grep { $_->{Name} =~ m{$Search} } @DefaultSettings;

        # check that the number of navbar settings is the same in OTRS 5 and 6 for this frontend module
        if ( @SearchResult && scalar @SearchResult == scalar @{ $Param{OTRS5EffectiveValue}->{NavBar} } ) {

            my $Counter = 0;
            for my $NavBarSetting (@SearchResult) {
                my $NavBarSettingName = $NavBarSetting->{Name};

                # try to get the (default) setting from OTRS 6 for the NavBar setting
                my %OTRS6NavBarSetting = $SysConfigObject->SettingGet(
                    Name  => $NavBarSettingName,
                    NoLog => 1,
                );

                return if !%OTRS6NavBarSetting;

                # skip this setting if it has already been modified in the meantime
                return 1 if $OTRS6NavBarSetting{ModifiedID};

                # skip this setting if it is a readonly setting
                return 1 if $OTRS6NavBarSetting{IsReadonly};

                # set group settings from OTRS 5
                $OTRS6NavBarSetting{EffectiveValue}->{Group}   = \@Group;
                $OTRS6NavBarSetting{EffectiveValue}->{GroupRo} = \@GroupRo;

                # take NavBar settings from OTRS 5
                for my $Attribute ( sort keys %{ $Param{OTRS5EffectiveValue}->{NavBar}->[$Counter] } ) {
                    $OTRS6NavBarSetting{EffectiveValue}->{$Attribute}
                        = $Param{OTRS5EffectiveValue}->{NavBar}->[$Counter]->{$Attribute};
                }

                # lock the setting
                my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                    Name   => $NavBarSettingName,
                    Force  => 1,
                    UserID => 1,
                );

                # update the setting
                my %Result = $SysConfigObject->SettingUpdate(
                    Name              => $NavBarSettingName,
                    IsValid           => 1,
                    EffectiveValue    => $OTRS6NavBarSetting{EffectiveValue},
                    ExclusiveLockGUID => $ExclusiveLockGUID,
                    NoValidation      => 1,
                    UserID            => 1,
                );

                # unlock the setting again
                $SysConfigObject->SettingUnlock(
                    Name => $NavBarSettingName,
                );

                return if !$Result{Success};

                # increase counter
                $Counter++;
            }
        }

        # log error
        else {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    'Different number of navbar settings in OTRS 5 and OTRS 6 for setting Frontend::Navigation###'
                    . $Param{FrontendModuleName}
                    . '###...',
            );
            return;
        }
    }

    # ###########################################################################
    # migrate the NavBarModule settings
    # ###########################################################################
    if ( $Param{OTRS5EffectiveValue}->{NavBarModule} ) {

        my $NavBarModuleSettingName = 'Frontend::NavigationModule###' . $Param{FrontendModuleName};

        # try to get the (default) setting from OTRS 6 for the NavBarModule setting
        my %OTRS6NavBarModuleSetting = $SysConfigObject->SettingGet(
            Name  => $NavBarModuleSettingName,
            NoLog => 1,
        );

        return if !%OTRS6NavBarModuleSetting;

        # skip this setting if it has already been modified in the meantime
        return 1 if $OTRS6NavBarModuleSetting{ModifiedID};

        # skip this setting if it is a readonly setting
        return 1 if $OTRS6NavBarModuleSetting{IsReadonly};

        # set group settings from OTRS 5
        $OTRS6NavBarModuleSetting{EffectiveValue}->{Group}   = \@Group;
        $OTRS6NavBarModuleSetting{EffectiveValue}->{GroupRo} = \@GroupRo;

        # take NavBarModule settings from OTRS 5
        for my $Attribute ( sort keys %{ $Param{OTRS5EffectiveValue}->{NavBarModule} } ) {
            $OTRS6NavBarModuleSetting{EffectiveValue}->{$Attribute}
                = $Param{OTRS5EffectiveValue}->{NavBarModule}->{$Attribute};
        }

        # lock the setting
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $NavBarModuleSettingName,
            Force  => 1,
            UserID => 1,
        );

        # update the setting
        my %Result = $SysConfigObject->SettingUpdate(
            Name              => $NavBarModuleSettingName,
            IsValid           => 1,
            EffectiveValue    => $OTRS6NavBarModuleSetting{EffectiveValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            NoValidation      => 1,
            UserID            => 1,
        );

        # unlock the setting again
        $SysConfigObject->SettingUnlock(
            Name => $NavBarModuleSettingName,
        );

        return if !$Result{Success};
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
