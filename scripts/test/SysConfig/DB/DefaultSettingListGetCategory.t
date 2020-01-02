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

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage1</Name>
    <Version>0.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage1.</Description>
    <Framework>6.0.x</Framework>
    <BuildDate>2016-10-11 02:35:46</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMTo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+IAogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxLZXl3b3Jkcz5UZXN0UGFja2FnZTwvS2V5d29yZHM+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgICAgIDxJdGVtIFZhbHVlVHlwZT0iU3RyaW5nIj48L0l0ZW0+CiAgICAgICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+Cjwvb3Ryc19jb25maWc+Cg==</File>
    </Filelist>
</otrs_package>
';

my $String2 = '<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>TestPackage2</Name>
    <Version>0.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">TestPackage2.</Description>
    <Framework>6.0.x</Framework>
    <BuildDate>2016-10-11 02:36:29</BuildDate>
    <BuildHost>yourhost.example.com</BuildHost>
    <Filelist>
        <File Location="Kernel/Config/Files/XML/TestPackage2.xml" Permission="660" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+CjxvdHJzX2NvbmZpZyB2ZXJzaW9uPSIyLjAiIGluaXQ9IkFwcGxpY2F0aW9uIj4KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMjo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+CiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+CiAgICAgICAgPE5hdmlnYXRpb24+Q29yZTo6VGVzdFBhY2thZ2U8L05hdmlnYXRpb24+CiAgICAgICAgPFZhbHVlPgogICAgICAgICAgICA8SXRlbSBWYWx1ZVR5cGU9IlN0cmluZyI+PC9JdGVtPgogICAgICAgIDwvVmFsdWU+CiAgICA8L1NldHRpbmc+CiAgICA8U2V0dGluZyBOYW1lPSJUZXN0UGFja2FnZTI6OlNldHRpbmcyIiBSZXF1aXJlZD0iMCIgVmFsaWQ9IjEiPgogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPgogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlPC9OYXZpZ2F0aW9uPgogICAgICAgIDxWYWx1ZT4KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4KICAgICAgICA8L1ZhbHVlPgogICAgPC9TZXR0aW5nPgo8L290cnNfY29uZmlnPg==</File>
    </Filelist>
</otrs_package>
';

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
my $Counter = 0;
for my $PackageString ( $String, $String2 ) {
    $Counter++;
    my $PackageName = "TestPackage$Counter";
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackagUninstall = $PackageObject->PackageUninstall( String => $PackageString );

        $Self->True(
            $PackagUninstall,
            "PackageUninstall() $PackageName",
        );
    }

    my $PackageInstall = $PackageObject->PackageInstall( String => $PackageString );
    $Self->True(
        $PackageInstall,
        "PackageInstall() $PackageName",
    );
}

my @Tests = (
    {
        Name   => 'TestPackage1',
        Config => {
            Category      => 'TestPackage1',
            CategoryFiles => ['TestPackage1.xml'],
        },
        ExpectedResults => {
            'TestPackage1::Setting1' => 1,
        },
    },
    {
        Name   => 'TestPackage2',
        Config => {
            Category      => 'TestPackage2',
            CategoryFiles => ['TestPackage2.xml'],
        },
        ExpectedResults => {
            'TestPackage2::Setting1' => 1,
            'TestPackage2::Setting2' => 1,
        },
    },
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

for my $Test (@Tests) {
    my @List = $SysConfigDBObject->DefaultSettingListGet( %{ $Test->{Config} } );

    my %Results = map { $_->{Name} => 1 } @List;

    $Self->IsDeeply(
        \%Results,
        $Test->{ExpectedResults},
        "$Test->{Name} DefaultSettingListGet() Category Search",
    );
}

my @List2 = $SysConfigDBObject->DefaultSettingList();
$Self->True(
    scalar @List2,
    'DefaultSettingList() returned some value.'
);
for my $Item (@List2) {
    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        DefaultID => $Item->{DefaultID},
    );
    if ( $DefaultSetting{Name} ne $Item->{Name} ) {
        $Self->Is(
            $Item->{Name},
            $DefaultSetting{Name},
            "DefaultSettingList() is DIFFERENT from DefaultSettingGet() for ID $Item->{DefaultID} .",
        );
    }

    # would produce +1000 tests - that would be alsways OK
    # else {
    #     $Self->Is(
    #         $List2{$ID},
    #         $DefaultSetting{Name},
    #         "DefaultSettingList() has same data as DefaultSettingGet() for $ID .",
    #     );
    # }
}

# Cleanup the system.
$Counter = 0;
for my $PackageString ( $String, $String2 ) {
    $Counter++;
    my $PackageName = "TestPackage$Counter";
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackagUninstall = $PackageObject->PackageUninstall( String => $PackageString );

        $Self->True(
            $PackagUninstall,
            "PackagUninstall() $PackageName",
        );
    }
}

1;
