# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $RandomID = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();

my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');

my @ArticleSearchKeys = qw(Body Cc Bcc From Subject To AttachmentName);
my @ShownAttributes;
for my $Key (@ArticleSearchKeys) {

    # Create search profile value for each article field key.
    my $Value = "$Key $RandomID";
    $SearchProfileObject->SearchProfileAdd(
        Base      => 'TicketSearch',
        Name      => $RandomID,
        Key       => $Key,
        Value     => $Value,
        UserLogin => $RandomID,
    );
    push @ShownAttributes, 'Label' . $Key;
}

# Create article field for ShownAttributes search profile values.
$SearchProfileObject->SearchProfileAdd(
    Base      => 'TicketSearch',
    Name      => $RandomID,
    Key       => 'ShownAttributes',
    Value     => \@ShownAttributes,
    UserLogin => $RandomID,
);

# Verify created search profile test values.
my %SearchProfileData = $SearchProfileObject->SearchProfileGet(
    Base      => 'TicketSearch',
    Name      => $RandomID,
    UserLogin => $RandomID,
);

for my $Key (@ArticleSearchKeys) {
    $Self->Is(
        $SearchProfileData{$Key},
        $Key . ' ' . $RandomID,
        "Initial search profile value for $Key is OK"
    );
}

# Run MigrateTicketSearchProfiles migration script.
my $UpgradeSuccess = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateTicketSearchProfiles')->Run();
$Self->Is(
    1,
    $UpgradeSuccess,
    'Migrated article search profile values to latest version.',
);

# Clean search profile cache to get fresh values.
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->CleanUp( Type => 'SearchProfile' );

# Verify migrated search profile test values.
my %MigratedSearchProfileData = $SearchProfileObject->SearchProfileGet(
    Base      => 'TicketSearch',
    Name      => $RandomID,
    UserLogin => $RandomID,
);

for my $Key (@ArticleSearchKeys) {
    my $ArticleKey = 'MIMEBase_' . $Key;
    $Self->Is(
        $MigratedSearchProfileData{$ArticleKey},
        $Key . ' ' . $RandomID,
        "Migrated search profile value for $ArticleKey is OK"
    );
}

1;
