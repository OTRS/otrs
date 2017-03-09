# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::System::VariableCheck qw(:all);

# Get system home directory.
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Read Sample.xml
my $XMLImputRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => "$Home/scripts/test/sample/SysConfig/XML/Sample.xml",
    Mode     => 'utf8',
);
$Self->IsNot(
    $XMLImputRef,
    undef,
    "FileRead() for Sample.xml",
);

# Get SysConfig XML object.
my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

# Split XML content in different settings
my $SettingList = $SysConfigXMLObject->SettingListGet(
    XMLInput => ${$XMLImputRef},
);
$Self->Is(
    ref $SettingList,
    'HASH',
    "SettingListGet() structure",
);
$Self->IsNot(
    scalar keys %{$SettingList},
    0,
    "SettingListGet() cardinality",
);

# Get SysConfig object.
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

for my $SettingName ( sort keys %{$SettingList} ) {

    # Convert XML for each setting into a Perl structure
    my $ParsedSetting = $SysConfigXMLObject->SettingParse(
        SettingXML => $SettingList->{$SettingName},
    );
    $Self->Is(
        ref $ParsedSetting,
        'HASH',
        "SettingParse() for $SettingName structure"
    );
    $Self->IsNot(
        scalar keys %{$ParsedSetting},
        0,
        "SettingParse() for $SettingName cardinality"
    );

    # Extract translations for each parsed setting (results are saved in SysConfig object $Self)
    $SysConfigObject->_ConfigurationTranslatableStrings( Data => $ParsedSetting );
}

my %ExpectedResults = (
    'All tickets with reminder'                                               => 1,
    'Check UTF-8.'                                                            => 1,
    'Defines the next state of a ticket.'                                     => 1,
    'Event module that updates customer user object name for dynamic fields.' => 1,
    'Frontend module registration.'                                           => 1,
    'Left'                                                                    => 1,
    'Loader module registration for the agent interface.'                     => 1,
    'Overview of all open Tickets.'                                           => 1,
    'Parameters with UTF8 ∂ç≈ßčćđšžå'                             => 1,
    'Reminder Tickets'                                                        => 1,
    'Restores a ticket from the archive.'                                     => 1,
    'Right'                                                                   => 1,
    'Service view'                                                            => 1,
    'ServiceView'                                                             => 1,
    'Sets the default body text for notes.'                                   => 1,
    'Shows a list of all the involved agents.'                                => 1,
    'Specifies the available note types.'                                     => 1,
    'The format of the subject.'                                              => 1,
    'The identifier for a ticket.'                                            => 1,
);

# Get actual results from SysConfig object
my $Result = $SysConfigObject->{ConfigurationTranslatableStrings};
$Self->Is(
    ref $Result,
    'HASH',
    "\$SysConfigObject->{ConfigurationTranslatableStrings} structure",
);
$Self->IsNot(
    scalar keys %{$Result},
    0,
    "\$SysConfigObject->{ConfigurationTranslatableStrings} cardinality",
);

# Compare actual results with expected ones
$Self->IsDeeply(
    $Result,
    \%ExpectedResults,
    "\$SysConfigObject->{ConfigurationTranslatableStrings} result",
);

# Check full function
my @TranslatableStrings = $SysConfigObject->ConfigurationTranslatableStrings();
$Self->IsNot(
    scalar @TranslatableStrings,
    0,
    "ConfigurationTranslatableStrings() cardinality (Full)",
);

1;
