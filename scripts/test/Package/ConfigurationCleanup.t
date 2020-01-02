# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Cleanup = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE from package_repository',
);

$Self->True(
    $Cleanup,
    "Removed possibly pre-existing packages from the database (transaction)."
);

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $CheckSettingValue = sub {
    my %Param = @_;

    my %Result = $SysConfigDBObject->DefaultSettingLookup(
        Name => "Test1",
    );

    my %Setting;
    if (%Result) {
        %Setting = $SysConfigObject->SettingGet(
            Name   => 'Test1',
            UserID => 1,
        );
    }
    $Self->Is(
        $Setting{EffectiveValue} // '',
        $Param{Value},
        $Param{Message},
    );
};

my $AddSetting = sub {

    # Add a setting without an XML counterpart
    my $ValidSettingXML = <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

        my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

    my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
        XMLInput => $ValidSettingXML,
    );

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $DateTimeObject->Add( Minutes => 30 );

    my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
        Name                     => 'Test1',
        Description              => 'Test 1.',
        Navigation               => 'Core::Ticket',
        IsInvisible              => 0,
        IsReadonly               => 0,
        IsRequired               => 1,
        IsValid                  => 1,
        HasConfigLevel           => 200,
        UserModificationPossible => 0,
        UserModificationActive   => 0,
        UserPreferencesGroup     => 'Test',
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 1',
        UserModificationActive   => 0,
        UserID                   => 1,
    );

    $CheckSettingValue->(
        Value   => 'Test setting 1',
        Message => 'DefaultSettingAdd() Value',
    );

    # Modify Setting value
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        DefaultID => $DefaultID,
        Name      => 'Test1',
        LockAll   => 1,
        Force     => 1,
        UserID    => 1,
    );

    my %Result = $SysConfigObject->SettingUpdate(
        Name                   => 'Test1',
        IsValid                => 1,
        EffectiveValue         => 'Updated setting 1',
        UserModificationActive => 0,
        ExclusiveLockGUID      => $ExclusiveLockGUID,
        UserID                 => 1,
        NoValidation           => 1,
    );

    $CheckSettingValue->(
        Value   => 'Updated setting 1',
        Message => 'SettingUpdate() Value',
    );
};

my $Version = $Kernel::OM->Get('Kernel::Config')->Get('Version');
($Version) = $Version =~ m{^(\d+\.\d+)};
$Version .= '.x';

# Define test packages
my $String1 = qq|<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage1</Name>
    <Version>0.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage1.</Description>
    <Framework>$Version</Framework>
    <BuildDate>2016-10-11 02:35:46</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMTo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+IAogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxLZXl3b3Jkcz5UZXN0UGFja2FnZTwvS2V5d29yZHM+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgICAgIDxJdGVtIFZhbHVlVHlwZT0iU3RyaW5nIj48L0l0ZW0+CiAgICAgICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+Cjwvb3Ryc19jb25maWc+Cg==</File>
    </Filelist>
</otrs_package>
|;

my $String2 = qq|<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage2</Name>
    <Version>0.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage2.</Description>
    <Framework>$Version</Framework>
    <BuildDate>2016-10-11 02:36:29</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage2.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMjo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+CiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgPFZhbHVlPgogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPgogICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+CiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTI6OlNldHRpbmcyIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPgogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPgogICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4KICAgICAgICA8L1ZhbHVlPgogICAgPC9TZXR0aW5nPgo8L290cnNfY29uZmlnPg==</File>
    </Filelist>
</otrs_package>
|;

my $String3 = qq|<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage2</Name>
    <Version>0.0.2</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage2.</Description>
    <Framework>$Version</Framework>
    <BuildDate>2016-10-11 02:36:29</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage2.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMjo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+CiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgPFZhbHVlPgogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPgogICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+CiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTI6OlNldHRpbmcyIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPgogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPgogICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4KICAgICAgICA8L1ZhbHVlPgogICAgPC9TZXR0aW5nPgo8L290cnNfY29uZmlnPg==</File>
    </Filelist>
</otrs_package>
|;

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->PackageUninstall(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "PackageUninstall() $PackageName",
        );
    }
}

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @Tests = (
    {
        Name           => 'Install Package 1 Clean',
        InstallPackage => {
            String       => $String1,
            Name         => 'TestPackage1',
            SettingValue => '',
        },
    },
    {
        Name       => 'Install Package 2 Dirty',
        RemoveFile => {
            Filename => ["${Home}/Kernel/Config/Files/XML/TestPackage1.xml"],    # remove file from package 1
        },
        InstallPackage => {
            String       => $String2,
            Name         => 'TestPackage2',
            SettingValue => 'Updated setting 1',
        },
    },
    {
        Name       => 'Re-Install Package 2 Dirty',
        RemoveFile => {
            Filename => [
                "${Home}/Kernel/Config/Files/XML/TestPackage1.xml",
                "${Home}/Kernel/Config/Files/XML/TestPackage2.xml",
            ],
        },
        ReInstallPackage => {
            String       => $String2,
            Name         => 'TestPackage2',
            SettingValue => 'Updated setting 1',
        },
    },
    {
        Name       => 'Upgrade Package 2 Dirty',
        RemoveFile => {
            Filename => ["${Home}/Kernel/Config/Files/XML/TestPackage1.xml"],
        },
        UpgradePackage => {
            String       => $String3,
            Name         => 'TestPackage2',
            SettingValue => 'Updated setting 1',
        },
    },
    {
        Name       => 'Uninstall Package 2 Dirty',
        RemoveFile => {
            Filename => ["${Home}/Kernel/Config/Files/XML/TestPackage1.xml"],
        },
        UninstallPackage => {
            String       => $String3,
            Name         => 'TestPackage2',
            SettingValue => 'Updated setting 1',
        },
    },
    {
        Name             => 'Re-Install Package 1 Dirty',
        ReInstallPackage => {
            String       => $String1,
            Name         => 'TestPackage1',
            SettingValue => '',
        },
    },
    {
        Name           => 'Install Package 2 Clean',
        InstallPackage => {
            String       => $String2,
            Name         => 'TestPackage2',
            SettingValue => '',
        },
    },
    {
        Name             => 'Re-Install Package 2 Clean',
        ReInstallPackage => {
            String       => $String2,
            Name         => 'TestPackage2',
            SettingValue => '',
        },
    },
    {
        Name           => 'Upgrade Package 2 Clean',
        UpgradePackage => {
            String       => $String3,
            Name         => 'TestPackage2',
            SettingValue => '',
        },
    },
    {
        Name             => 'Uninstall Package 2 Clean',
        UninstallPackage => {
            String       => $String3,
            Name         => 'TestPackage2',
            SettingValue => '',
        },
    },
    {
        Name             => 'Uninstall Package 1 Clean',
        UninstallPackage => {
            String       => $String1,
            Name         => 'TestPackage1',
            SettingValue => '',
        },
    },

);

for my $Test (@Tests) {

    $AddSetting->();

    if ( $Test->{RemoveFile} ) {
        for my $Filename ( @{ $Test->{RemoveFile}->{Filename} } ) {
            unlink $Filename;
            my $Exists = -e $Filename;
            $Self->False(
                $Exists,
                "Removed File $Filename",
            );
        }
    }

    if ( $Test->{InstallPackage} ) {
        my $PackageInstall = $PackageObject->PackageInstall( String => $Test->{InstallPackage}->{String} );
        $Self->True(
            $PackageInstall,
            "$Test->{Name} PackageInstall() $Test->{InstallPackage}->{Name}",
        );

        $CheckSettingValue->(
            Value   => $Test->{InstallPackage}->{SettingValue},
            Message => "$Test->{Name} After install",
        );
    }
    if ( $Test->{ReInstallPackage} ) {
        my $PackageReInstall = $PackageObject->PackageReinstall( String => $Test->{ReInstallPackage}->{String} );
        $Self->True(
            $PackageReInstall,
            "$Test->{Name} PackageReInstall() $Test->{ReInstallPackage}->{Name}",
        );

        $CheckSettingValue->(
            Value   => $Test->{ReInstallPackage}->{SettingValue},
            Message => "$Test->{Name} After re-install",
        );
    }
    if ( $Test->{UpgradePackage} ) {
        my $PackageUpgrade = $PackageObject->PackageUpgrade( String => $Test->{UpgradePackage}->{String} );
        $Self->True(
            $PackageUpgrade,
            "$Test->{Name} PackageUpgrade() $Test->{UpgradePackage}->{Name}",
        );

        $CheckSettingValue->(
            Value   => $Test->{UpgradePackage}->{SettingValue},
            Message => "$Test->{Name} After upgrade",
        );
    }
    if ( $Test->{UninstallPackage} ) {
        my $PackageUninstall = $PackageObject->PackageUninstall( String => $Test->{UninstallPackage}->{String} );
        $Self->True(
            $PackageUninstall,
            "$Test->{Name} PackageUninstall() $Test->{UninstallPackage}->{Name}",
        );

        $CheckSettingValue->(
            Value   => $Test->{UninstallPackage}->{SettingValue},
            Message => "$Test->{Name} After uninstall",
        );
    }

}
continue {
    my %Result = $SysConfigDBObject->DefaultSettingLookup(
        Name => "Test1",
    );

    if (%Result) {

        my %Setting = $SysConfigObject->SettingGet(
            Name   => 'Test1',
            UserID => 1,
        );

        my @ModifiedSettings = $SysConfigDBObject->ModifiedSettingListGet(
            Name => $Setting{Name},
        );

        for my $ModifiedSetting (@ModifiedSettings) {
            my $SuccessDeleteModified = $SysConfigDBObject->ModifiedSettingDelete(
                ModifiedID => $ModifiedSetting->{ModifiedID},
            );
        }

        my @ModifiedSettingVersions = $SysConfigDBObject->ModifiedSettingVersionListGet(
            Name => $Setting{Name},
        );

        for my $ModifiedSettingVersion (@ModifiedSettingVersions) {

            # Delete from modified table.
            my $SuccessDeleteModifiedVersion = $SysConfigDBObject->ModifiedSettingVersionDelete(
                ModifiedVersionID => $ModifiedSettingVersion->{ModifiedVersionID},
            );
        }

        my $SuccessDefaultSetting = $SysConfigDBObject->DefaultSettingDelete(
            Name => $Setting{Name},
        );
    }
}

1;
