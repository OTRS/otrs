# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::UI::AgentSkinUsage;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::User',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('UI - Agent Skin Usage');
}

sub Run {
    my $Self = shift;

    # First get count of all agents. We avoid checking for Valid for performance reasons, as this
    #   would require fetching of all agent data to check for the preferences.
    my $DBObject              = $Kernel::OM->Get('Kernel::System::DB');
    my $AgentsWithDefaultSkin = 1;
    $DBObject->Prepare( SQL => 'SELECT count(*) FROM users' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $AgentsWithDefaultSkin = $Row[0];
    }

    my $DefaultSkin = $Kernel::OM->Get('Kernel::Config')->Get('Loader::Agent::DefaultSelectedSkin');

    my %SkinPreferences = $Kernel::OM->Get('Kernel::System::User')->SearchPreferences(
        Key => 'UserSkin',
    );

    my %SkinUsage;

    # Check how many agents have a skin preference configured, assume default skin for the rest.
    for my $UserID ( sort keys %SkinPreferences ) {
        $SkinUsage{ $SkinPreferences{$UserID} }++;
        $AgentsWithDefaultSkin--;
    }
    $SkinUsage{$DefaultSkin} += $AgentsWithDefaultSkin;

    for my $Skin ( sort keys %SkinUsage ) {

        $Self->AddResultInformation(
            Identifier => $Skin,
            Label      => $Skin,
            Value      => $SkinUsage{$Skin},
        );
    }

    return $Self->GetResults();
}

1;
