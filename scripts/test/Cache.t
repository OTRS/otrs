# --
# Cache.t - Cache tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Data::Dumper;

use Kernel::System::Cache;
use Kernel::System::UnitTest::Helper;

# use local Config object because it will be modified
my $ConfigObject = Kernel::Config->new();

# get home directory
my $HomeDir = $ConfigObject->Get('Home');

# get all avaliable backend modules
my @BackendModuleFiles = $Self->{MainObject}->DirectoryRead(
    Directory => $HomeDir . '/Kernel/System/Cache/',
    Filter    => '*.pm',
    Silent    => 1,
);

MODULEFILE:
for my $ModuleFile (@BackendModuleFiles) {

    next MODULEFILE if !$ModuleFile;

    # extract module name
    my ($Module) = $ModuleFile =~ m{ \/+ ([a-zA-Z0-9]+) \.pm $ }xms;

    next MODULEFILE if !$Module;

    $ConfigObject->Set(
        Key   => 'Cache::Module',
        Value => "Kernel::System::Cache::$Module",
    );

    for my $SubdirLevels ( 0 .. 3 ) {

        $ConfigObject->Set(
            Key   => 'Cache::SubdirLevels',
            Value => $SubdirLevels,
        );

        # creates a local helper object
        my $HelperObject = Kernel::System::UnitTest::Helper->new(
            %{$Self},
            ConfigObject   => $ConfigObject,
            UnitTestObject => $Self,
        );

        # create a local cache object
        my $CacheObject = Kernel::System::Cache->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        next MODULEFILE if !$CacheObject;

        # flush the cache to have a clear test enviroment
        $CacheObject->CleanUp();

        # set fixed time
        $HelperObject->FixedTimeSet();

        my $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2',
            Key   => 'Test',
            Value => '1234',
            TTL   => 60 * 24 * 60 * 60,
        );
        $Self->True(
            $CacheSet,
            "#1 - $Module - $SubdirLevels - CacheSet(), TTL 60*24*60*60",
        );

        my $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->Is(
            $CacheGet || '',
            '1234',
            "#1 - $Module - $SubdirLevels - CacheGet()",
        );

        my $CacheDelete = $CacheObject->Delete(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->True(
            $CacheDelete,
            "#1 - $Module - $SubdirLevels - CacheDelete()",
        );

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->False(
            $CacheGet || '',
            "#1 - $Module - $SubdirLevels - CacheGet()",
        );

        # invalid keys
        $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2::invalid::type',
            Key   => 'Test',
            Value => '1234',
            TTL   => 60 * 24 * 60 * 60,
        );
        $Self->False(
            scalar $CacheSet,
            "#1 - $Module - $SubdirLevels - CacheSet() for invalid type",
        );

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2::invalid::type',
            Key  => 'Test',
        );
        $Self->False(
            scalar $CacheGet,
            "#1 - $Module - $SubdirLevels - CacheGet() for invalid type",
        );

        # test charset specific situations
        $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2',
            Key   => 'Test',
            Value => {
                Key1 => 'Value1',
                Key2 => 'Value2äöüß',
                Key3 => 'Value3',
                Key4 => [
                    'äöüß',
                    '123456789',
                    'ÄÖÜß',
                    {
                        KeyA  => 'ValueA',
                        KeyB  => 'ValueBäöüßタ',
                        KeyC  => 'ValueC',
                        Value => '9ßüß-カスタ1234',
                    },
                ],
            },
            TTL => 60 * 24 * 60 * 60,
        );

        $Self->True(
            $CacheSet,
            "#2 - $Module - $SubdirLevels - CacheSet()",
        );

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );

        $Self->Is(
            $CacheGet->{Key2} || '',
            'Value2äöüß',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key2}",
        );
        $Self->True(
            Encode::is_utf8( $CacheGet->{Key2} ) || '',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key2} Encode::is_utf8",
        );
        $Self->Is(
            $CacheGet->{Key4}->[0] || '',
            'äöüß',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key4}->[0]",
        );
        $Self->True(
            Encode::is_utf8( $CacheGet->{Key4}->[0] ) || '',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key4}->[0] Encode::is_utf8",
        );
        $Self->Is(
            $CacheGet->{Key4}->[3]->{KeyA} || '',
            'ValueA',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key4}->[3]->{KeyA}",
        );
        $Self->Is(
            $CacheGet->{Key4}->[3]->{KeyB} || '',
            'ValueBäöüßタ',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key4}->[3]->{KeyB}",
        );
        $Self->True(
            Encode::is_utf8( $CacheGet->{Key4}->[3]->{KeyB} ) || '',
            "#2 - $Module - $SubdirLevels - CacheGet() - {Key4}->[3]->{KeyB} Encode::is_utf8",
        );

        $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2',
            Key   => 'Test',
            Value => 'ü',
            TTL   => 8,
        );

        $Self->True(
            $CacheSet,
            "#3 - $Module - $SubdirLevels - CacheSet(), TTL 8",
        );

        # wait 7 seconds
        $HelperObject->FixedTimeAddSeconds(7);

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );

        $Self->Is(
            $CacheGet || '',
            'ü',
            "#3 - $Module - $SubdirLevels - CacheGet()",
        );

        $Self->True(
            Encode::is_utf8($CacheGet) || '',
            "#3 - $Module - $SubdirLevels - CacheGet() - Encode::is_utf8",
        );

        $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2',
            Key   => 'Test',
            Value => '9ßüß-カスタ1234',
            TTL   => 4,
        );

        $Self->True(
            $CacheSet,
            "#4 - $Module - $SubdirLevels - CacheSet(), TTL 4",
        );

        # wait 3 seconds
        $HelperObject->FixedTimeAddSeconds(3);

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );

        $Self->Is(
            $CacheGet || '',
            '9ßüß-カスタ1234',
            "#4 - $Module - $SubdirLevels - CacheGet()",
        );
        $Self->True(
            Encode::is_utf8($CacheGet) || '',
            "#4 - $Module - $SubdirLevels - CacheGet() - Encode::is_utf8",
        );

        # wait 3 seconds
        $HelperObject->FixedTimeAddSeconds(3);

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );

        $Self->True(
            !$CacheGet || '',
            "#4 - $Module - $SubdirLevels - CacheGet() - wait 6 seconds - TTL expires after 4 seconds",
        );

        $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2',
            Key   => 'Test',
            Value => '123456',
            TTL   => 60 * 60,
        );

        $Self->True(
            $CacheSet,
            "#5 - $Module - $SubdirLevels - CacheSet()",
        );

        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );

        $Self->Is(
            $CacheGet || '',
            '123456',
            "#5 - $Module - $SubdirLevels - CacheGet()",
        );
        $CacheDelete = $CacheObject->Delete(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->True(
            $CacheDelete,
            "#5 - $Module - $SubdirLevels - CacheDelete()",
        );

        # A-z char type test
        $CacheSet = $CacheObject->Set(
            Type  => 'Value2äöüß',
            Key   => 'Test',
            Value => '1',
            TTL   => 60,
        );
        $Self->True(
            !$CacheSet || '',
            "#6 - $Module - $SubdirLevels - Set() - A-z type check",
        );

        $CacheDelete = $CacheObject->Delete(
            Type => 'Value2äöüß',
            Key  => 'Test',
        );
        $Self->True(
            !$CacheDelete || 0,
            "#6 - $Module - $SubdirLevels - CacheDelete() - A-z type check",
        );

        # create new cache files
        $CacheSet = $CacheObject->Set(
            Type  => 'CacheTest2',
            Key   => 'Test',
            Value => '1234',
            TTL   => 24 * 60 * 60,
        );
        $Self->True(
            $CacheSet,
            "#7 - $Module - $SubdirLevels - CacheSet(), TTL 24*60*60",
        );

        # check get
        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->Is(
            $CacheGet || '',
            '1234',
            "#7 - $Module - $SubdirLevels - CacheGet()",
        );

        # cleanup (expired)
        my $CacheCleanUp = $CacheObject->CleanUp( Expired => 1 );
        $Self->True(
            $CacheCleanUp,
            "#7 - $Module - $SubdirLevels - CleanUp( Expired => 1 )",
        );

        # check get
        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->True(
            $CacheGet,
            "#7 - $Module - $SubdirLevels - CacheGet() - Expired",
        );

        # cleanup
        $CacheCleanUp = $CacheObject->CleanUp();
        $Self->True(
            $CacheCleanUp,
            "#7 - $Module - $SubdirLevels - CleanUp()",
        );

        # check get
        $CacheGet = $CacheObject->Get(
            Type => 'CacheTest2',
            Key  => 'Test',
        );
        $Self->False(
            $CacheGet,
            "#7 - $Module - $SubdirLevels - CacheGet()",
        );

        # unset fixed time
        $HelperObject->FixedTimeUnset();

        my $String1 = '';
        my $String2 = '';
        my %KeyList;
        COUNT:
        for my $Count ( 1 .. 16 ) {

            $String1
                .= $String1
                . $Count
                . "abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyzöäüßЖЛЮѬ ";
            $String2
                .= $String2
                . $Count
                . "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZöäüßЖЛЮѬ ";
            my $Size = length $String1;

            if ( $Size > ( 1024 * 1024 ) ) {
                $Size = sprintf "%.1f MBytes", ( $Size / ( 1024 * 1024 ) );
            }
            elsif ( $Size > 1024 ) {
                $Size = sprintf "%.1f KBytes", ( ( $Size / 1024 ) );
            }
            else {
                $Size = $Size . ' Bytes';
            }

            # create key
            my $Key = 'Unittest' . rand 999_999_999;

            # copy strings to safe the reference
            my $StringRef1 = $String1;
            my $StringRef2 = $String2;

            # define cachetests 1
            my %CacheTests1 = (

                HASH => {
                    Test  => 'ABC',
                    Test2 => $String1,
                    Test3 => [ 'AAA', 'BBB' ],
                },

                ARRAY => [
                    'ABC',
                    $String1,
                    [ 'AAA', 'BBB' ],
                ],

                SCALAR => \$StringRef1,

                String => $String1,
            );

            # define cachetests 2
            my %CacheTests2 = (

                HashRef => {
                    Test  => 'XYZ',
                    Test2 => $String2,
                    Test3 => [ 'CCC', 'DDD' ],
                },

                ArrayRef => [
                    'XYZ',
                    $String2,
                    [ 'EEE', 'FFF' ],
                ],

                ScalarRef => \$StringRef2,

                String => $String2,
            );

            TYPE:
            for my $Type ( sort keys %CacheTests1 ) {

                # set cache
                my $CacheSet = $CacheObject->Set(
                    Type  => 'CacheTestLong1',
                    Key   => $Type . $Key,
                    Value => $CacheTests1{$Type},
                    TTL   => 24 * 60 * 60,
                );

                $Self->True(
                    $CacheSet,
                    "#8 - $Module - $SubdirLevels - CacheSet1() Size $Size",
                );

                next TYPE if !$CacheSet;

                $KeyList{1}->{ $Type . $Key } = $CacheTests1{$Type};
            }

            TYPE:
            for my $Type ( sort keys %CacheTests2 ) {

                # set cache
                my $CacheSet = $CacheObject->Set(
                    Type  => 'CacheTestLong2',
                    Key   => $Type . $Key,
                    Value => $CacheTests2{$Type},
                    TTL   => 24 * 60 * 60,
                );

                $Self->True(
                    $CacheSet,
                    "#8 - $Module - $SubdirLevels - CacheSet2() Size $Size",
                );

                next TYPE if !$CacheSet;

                $KeyList{2}->{ $Type . $Key } = $CacheTests2{$Type};
            }
        }

        for my $Mode ( 'All', 'One', 'None' ) {

            if ( $Mode eq 'One' ) {

                # invalidate all values of CacheTestLong1
                my $CleanUp1 = $CacheObject->CleanUp(
                    Type => 'CacheTestLong1',
                );

                $Self->True(
                    $CleanUp1,
                    "#8 - $Module - $SubdirLevels - CleanUp() - invalidate all values of CacheTestLong1",
                );

                # unset all values of CacheTestLong1
                for my $Key ( sort keys %{ $KeyList{1} } ) {
                    $KeyList{1}->{$Key} = '';
                }
            }
            elsif ( $Mode eq 'None' ) {

                # invalidate all values of CacheTestLong2
                my $CleanUp2 = $CacheObject->CleanUp(
                    Type => 'CacheTestLong2',
                );

                $Self->True(
                    $CleanUp2,
                    "#8 - $Module - $SubdirLevels - CleanUp() - invalidate all values of CacheTestLong2",
                );

                # unset all values of CacheTestLong2
                for my $Key ( sort keys %{ $KeyList{2} } ) {
                    $KeyList{2}->{$Key} = '';
                }
            }

            for my $Count ( sort keys %KeyList ) {

                for my $Key ( sort keys %{ $KeyList{$Count} } ) {

                    # extract cache item
                    my $CacheItem = $KeyList{$Count}->{$Key};

                    # check get
                    my $CacheGet = $CacheObject->Get(
                        Type => 'CacheTestLong' . $Count,
                        Key  => $Key,
                    ) || '';

                    if (
                        ref $CacheItem eq 'HASH'
                        || ref $CacheItem eq 'ARRAY'
                        || ref $CacheItem eq 'SCALAR'
                        )
                    {

                        $Self->True(
                            ref $CacheGet eq ref $CacheItem,
                            "CacheGet$Count() - Reference Test",
                        );

                        # turn off all pretty print
                        $Data::Dumper::Indent = 0;

                        # dump the cached value
                        my $CachedValue = Data::Dumper::Dumper($CacheGet);    ## no critic

                        # dump the reference attribute
                        my $OriginValue = Data::Dumper::Dumper($CacheItem);    ## no critic

                        # Don't use Is(), produces too much output.
                        $Self->True(
                            $CachedValue eq $OriginValue,
                            "#8 - $Module - $SubdirLevels - CacheGet$Count() - Content Test",
                        );
                    }
                    else {

                        # Don't use Is(), produces too much output.
                        $Self->True(
                            $CacheGet eq $CacheItem,
                            "#8 - $Module - $SubdirLevels - CacheGet$Count() - Content Test",
                        );
                    }
                }
            }
        }

        # flush the cache
        $CacheObject->CleanUp();
    }
}

1;
