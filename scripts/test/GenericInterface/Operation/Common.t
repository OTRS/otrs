# --
# Common.t - Tests for common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.t,v 1.1 2011-03-03 12:54:50 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::GenericInterface::Operation::Common;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Cache;

my $OperationCommonObject = Kernel::GenericInterface::Operation::Common->new(%{$Self});
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
);
my $Result;

# empty the cache first
my $CacheObject = Kernel::System::Cache->new( %{$Self} );
$CacheObject->CleanUp();

$Self->Is(
    ref $OperationCommonObject,
    'Kernel::GenericInterface::Operation::Common',
    'Constructor success',
);

$Result = $OperationCommonObject->CachedAuth(
    Type => 'Agent',
    Username => 'nonexisting',
    Password => 'false.password',
);

$Self->False(
    $Result,
    'CachedAuth() for nonexisting user',
);

my $TestUserLogin = $HelperObject->TestUserCreate();

$Result = $OperationCommonObject->CachedAuth(
    Type => 'Agent',
    Username => $TestUserLogin,
    Password => $TestUserLogin,
);

$Self->True(
    $Result,
    'CachedAuth() for existing user',
);

my $CachedResult = $OperationCommonObject->CachedAuth(
    Type => 'Agent',
    Username => $TestUserLogin,
    Password => $TestUserLogin,
);

$Self->Is(
    $CachedResult,
    $Result,
    'CachedAuth() for existing user (cached)',
);

my $TestCustomerUserLogin = $HelperObject->TestCustomerUserCreate();

$Result = $OperationCommonObject->CachedAuth(
    Type => 'Customer',
    Username => 'nonexisting',
    Password => 'false.password',
);

$Self->False(
    $Result,
    'CachedAuth() for nonexisting customer user',
);

$Result = $OperationCommonObject->CachedAuth(
    Type => 'Customer',
    Username => $TestCustomerUserLogin,
    Password => $TestCustomerUserLogin,
);

$Self->True(
    $Result,
    'CachedAuth() for existing customer user',
);

$CachedResult = $OperationCommonObject->CachedAuth(
    Type => 'Customer',
    Username => $TestCustomerUserLogin,
    Password => $TestCustomerUserLogin,
);

$Self->Is(
    $CachedResult,
    $Result,
    'CachedAuth() for existing customer user (cached)',
);

1;
