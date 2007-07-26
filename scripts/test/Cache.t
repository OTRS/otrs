# --
# Cache.t - Cache tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Cache.t,v 1.1 2007-07-26 14:11:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use utf8;
use Kernel::System::Cache;

$Self->{CacheObject} = Kernel::System::Cache->new(%{$Self});

my $CacheSet = $Self->{CacheObject}->Set(
    Key => 'Test',
    Value => '1234',
    TTL => 24*60*60,
);

$Self->True(
    $CacheSet,
    '#1 CacheSet(), TTL 24*60*60',
);

my $CacheGet = $Self->{CacheObject}->Get(
    Key => 'Test',
);

$Self->Is(
    $CacheGet || '',
    '1234',
    '#1 CacheGet()',
);

$CacheSet = $Self->{CacheObject}->Set(
    Key => 'Test',
    Value => {
        Key1 => 'Value1',
        Key2 => 'Value2äöüß',
        Key3 => 'Value3',
    },
    TTL => 24*60*60,
);

$Self->True(
    $CacheSet,
    '#2 CacheSet()',
);

$CacheGet = $Self->{CacheObject}->Get(
    Key => 'Test',
);

$Self->Is(
    $CacheGet->{Key2} || '',
    'Value2äöüß',
    '#2 CacheGet()',
);

$CacheSet = $Self->{CacheObject}->Set(
    Key => 'Test',
    Value => '9ßüß-カスタ1234',
    TTL => 2,
);

$Self->True(
    $CacheSet,
    '#3 CacheSet(), TTL 2',
);

$CacheGet = $Self->{CacheObject}->Get(
    Key => 'Test',
);

$Self->Is(
    $CacheGet || '',
    '9ßüß-カスタ1234',
    '#3 CacheGet()',
);
sleep 4;

$CacheGet = $Self->{CacheObject}->Get(
    Key => 'Test',
);

$Self->True(
    !$CacheGet || '',
    '#3 CacheGet() - sleep6 - TTL of 5 expired',
);

$CacheSet = $Self->{CacheObject}->Set(
    Key => 'Test',
    Value => '123456',
    TTL => 60*60,
);

$Self->True(
    $CacheSet,
    '#4 CacheSet()',
);

$CacheGet = $Self->{CacheObject}->Get(
    Key => 'Test',
);

$Self->Is(
    $CacheGet || '',
    '123456',
    '#4 CacheGet()',
);
my $CacheDelete = $Self->{CacheObject}->Delete(
    Key => 'Test',
);

$Self->True(
    $CacheDelete,
    '#4 CacheDelete()',
);

1;
