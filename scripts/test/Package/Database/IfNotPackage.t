# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

# Do not use RestoreDatabae here, in our tests the first contained package remains installed
#   with this option.
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $PackageAction = sub {
    my %Param = @_;

    my $FileString = $Param{FileString};

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my $Success;
    if ( $Param{Action} eq 'Install' ) {
        $Success = $PackageObject->PackageInstall(
            String => $FileString,
            Force  => 1,
        );

        $Self->True(
            $Success,
            "$Param{TestName} PackageInstall()"
        );
    }
    elsif ( $Param{Action} eq 'Uninstall' ) {
        $Success = $PackageObject->PackageUninstall(
            String => $FileString,
            Force  => 1,
        );

        $Self->True(
            $Success,
            "$Param{TestName} PackageUninstall()"
        );
    }

    return $Success;
};

my $TableExists = sub {
    my %Param = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TableNames = map { lc $_ => 1 } $DBObject->ListTables();

    return 0 if !$TableNames{ lc $Param{Table} };

    return 1;
};

my $ExecuteXMLDBString = sub {
    my %Param = @_;

    my $XMLString = $Param{XMLString};

    my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XMLString );

    my @SQL;
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Create database specific SQL.
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    return $DBObject->Do( SQL => $SQL[0] );
};

# get OTRS Version
my $OTRSVersion = $Kernel::OM->Get('Kernel::Config')->Get('Version');

# leave only major and minor level versions
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTRSVersion .= '.x';

my $RandomID = $Helper->GetRandomID();

my %Packages = (
    'Package1' => << "EOF",
<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>Package1$RandomID</Name>
    <Version>1.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">OTRS Business Solution. For more information, please have a look at the official documentation at http://otrs.github.io/doc/manual/otrs-business-solution/stable/en/html/.</Description>
    <Framework>$OTRSVersion</Framework>
    <PackageIsVisible>1</PackageIsVisible>
    <PackageIsDownloadable>1</PackageIsDownloadable>
    <PackageIsRemovable>1</PackageIsRemovable>
    <BuildDate>2016-03-04 18:02:26</BuildDate>
    <BuildHost>otrs.master.mandalore.com</BuildHost>
    <DatabaseInstall Type="post" IfNotPackage="Package2$RandomID">
        <TableCreate Type="post" Name="$RandomID">
            <Column AutoIncrement="true" Name="id" PrimaryKey="true" Required="true" Type="BIGINT"></Column>
            <Column Name="name" Required="true" Size="200" Type="VARCHAR"></Column>
        </TableCreate>
    </DatabaseInstall>
</otrs_package>
EOF

    'Package2' => << "EOF",
<?xml version="1.0" encoding="utf-8" ?>
<otrs_package version="1.1">
    <Name>Package2$RandomID</Name>
    <Version>1.0.1</Version>
    <Vendor>OTRS AG</Vendor>
    <URL>https://otrs.com/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">OTRS Business Solution. For more information, please have a look at the official documentation at http://otrs.github.io/doc/manual/otrs-business-solution/stable/en/html/.</Description>
    <Framework>$OTRSVersion</Framework>
    <PackageIsVisible>1</PackageIsVisible>
    <PackageIsDownloadable>1</PackageIsDownloadable>
    <PackageIsRemovable>1</PackageIsRemovable>
    <BuildDate>2016-03-04 18:02:26</BuildDate>
    <BuildHost>otrs.master.mandalore.com</BuildHost>
</otrs_package>
EOF
);

my @Tests = (
    {
        Name            => 'Clean System',
        PackageInstall  => [ $Packages{Package1} ],
        ExpectedResults => 1,
    },
    {
        Name            => 'Installed Package',
        PackageInstall  => [ $Packages{Package2}, $Packages{Package1} ],
        ExpectedResults => 0,
    },
);

for my $Test (@Tests) {

    if ( $Test->{PackageInstall} ) {
        for my $Package ( @{ $Test->{PackageInstall} } ) {
            $PackageAction->(
                Action     => 'Install',
                TestName   => $Test->{Name},
                FileString => $Package,
            );
        }
    }

    my $Result = $TableExists->( Table => $RandomID );
    $Self->Is(
        $Result,
        $Test->{ExpectedResults},
        "$Test->{Name} TableExists "
    );

    if ($Result) {
        $ExecuteXMLDBString->( XMLString => "<TableDrop Name=\"$RandomID\" />" );
    }

    if ( $Test->{PackageInstall} ) {
        for my $Package ( @{ $Test->{PackageInstall} } ) {
            $PackageAction->(
                Action     => 'Uninstall',
                TestName   => $Test->{Name},
                FileString => $Package,
            );
        }
    }
}

1;
