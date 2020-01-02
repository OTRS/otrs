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

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get all frontend modules with access key definitions.
my @Modules = $SysConfigObject->ConfigurationSearch(
    Search           => 'AccessKey',
    Category         => 'All',
    IncludeInvisible => 1,
);

# Check used access keys.
my %UsedAccessKeys;

my $Error;

MODULE:
for my $Module (@Modules) {
    my %SysConfig = $SysConfigObject->SettingGet(
        Name => $Module,
    );

    next MODULE if !IsHashRefWithData( $SysConfig{DefaultValue} );
    next MODULE if !defined $SysConfig{DefaultValue}->{AccessKey};
    next MODULE if !length $SysConfig{DefaultValue}->{AccessKey};

    my $AccessKey      = $SysConfig{DefaultValue}->{AccessKey};
    my $AccessKeyLower = lc $AccessKey;

    my $Name = $SysConfig{DefaultValue}->{Link} || $SysConfig{DefaultValue}->{Module} || '';
    my $Frontend;

    if ( $Module =~ /CustomerFrontend/i ) {
        $Frontend = 'CUSTOMER FRONTEND';
    }
    elsif ( $Module =~ /PublicFrontend/i ) {
        $Frontend = 'PUBLIC FRONTEND';
    }
    else {
        $Frontend = 'AGENT FRONTEND';
    }

    $Self->False(
        $UsedAccessKeys{$Frontend}->{$AccessKeyLower},
        "[$Frontend] Check if access key '$AccessKey' already exists ($Name)",
    );

    if ( !$Error && $UsedAccessKeys{$Frontend}->{$AccessKeyLower} ) {
        if ( !$Error ) {
            $Error = 1;
        }

        next MODULE;
    }

    $UsedAccessKeys{$Frontend}->{$AccessKeyLower} = $Name;
}

$Self->False(
    $Error,
    "List of all defined access keys: \n"
        . $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => \%UsedAccessKeys )
);

1;
