# --
# Cache.t - Cache tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: Cache.t,v 1.23.2.2 2012-11-28 11:04:49 mh Exp $
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

my $ConfigObject = Kernel::Config->new();

MODULE:
for my $Module (qw(FileStorable FileRaw)) {

    $ConfigObject->Set(
        Key   => 'Cache::Module',
        Value => "Kernel::System::Cache::$Module"
    );

    my $CacheObject = Kernel::System::Cache->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    next MODULE if !$CacheObject;

    # flush the cache to have a clear test enviroment
    $CacheObject->CleanUp();

    my $CacheSet = $CacheObject->Set(
        Type  => 'CacheTest2',
        Key   => 'Test',
        Value => '1234',
        TTL   => 60 * 24 * 60 * 60,
    );
    $Self->True(
        $CacheSet,
        "#1 - $Module - CacheSet(), TTL 60*24*60*60",
    );

    my $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->Is(
        $CacheGet || '',
        '1234',
        "#1 - $Module - CacheGet()",
    );

    my $CacheDelete = $CacheObject->Delete(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->True(
        $CacheDelete,
        "#1 - $Module - CacheDelete()",
    );

    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->False(
        $CacheGet || '',
        "#1 - $Module - CacheGet()",
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
        "#2 - $Module - CacheSet()",
    );

    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );

    $Self->Is(
        $CacheGet->{Key2} || '',
        'Value2äöüß',
        "#2 - $Module - CacheGet() - {Key2}",
    );
    $Self->True(
        Encode::is_utf8( $CacheGet->{Key2} ) || '',
        "#2 - $Module - CacheGet() - {Key2} Encode::is_utf8",
    );
    $Self->Is(
        $CacheGet->{Key4}->[0] || '',
        'äöüß',
        "#2 - $Module - CacheGet() - {Key4}->[0]",
    );
    $Self->True(
        Encode::is_utf8( $CacheGet->{Key4}->[0] ) || '',
        "#2 - $Module - CacheGet() - {Key4}->[0] Encode::is_utf8",
    );
    $Self->Is(
        $CacheGet->{Key4}->[3]->{KeyA} || '',
        'ValueA',
        "#2 - $Module - CacheGet() - {Key4}->[3]->{KeyA}",
    );
    $Self->Is(
        $CacheGet->{Key4}->[3]->{KeyB} || '',
        'ValueBäöüßタ',
        "#2 - $Module - CacheGet() - {Key4}->[3]->{KeyB}",
    );
    $Self->True(
        Encode::is_utf8( $CacheGet->{Key4}->[3]->{KeyB} ) || '',
        "#2 - $Module - CacheGet() - {Key4}->[3]->{KeyB} Encode::is_utf8",
    );

    $CacheSet = $CacheObject->Set(
        Type  => 'CacheTest2',
        Key   => 'Test',
        Value => 'ü',
        TTL   => 60,
    );

    $Self->True(
        $CacheSet,
        "#3 - $Module - CacheSet(), TTL 60",
    );

    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );

    $Self->Is(
        $CacheGet || '',
        'ü',
        "#3 - $Module - CacheGet()",
    );

    $Self->True(
        Encode::is_utf8($CacheGet) || '',
        "#3 - $Module - CacheGet() - Encode::is_utf8",
    );

    $CacheSet = $CacheObject->Set(
        Type  => 'CacheTest2',
        Key   => 'Test',
        Value => '9ßüß-カスタ1234',
        TTL   => 60,
    );

    $Self->True(
        $CacheSet,
        "#4 - $Module - CacheSet(), TTL 60",
    );

    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );

    $Self->Is(
        $CacheGet || '',
        '9ßüß-カスタ1234',
        "#4 - $Module - CacheGet()",
    );
    $Self->True(
        Encode::is_utf8($CacheGet) || '',
        "#4 - $Module - CacheGet() - Encode::is_utf8",
    );

    $CacheSet = $CacheObject->Set(
        Type  => 'CacheTest2',
        Key   => 'Test',
        Value => '123456',
        TTL   => 60 * 60,
    );

    $Self->True(
        $CacheSet,
        "#5 - $Module - CacheSet()",
    );

    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );

    $Self->Is(
        $CacheGet || '',
        '123456',
        "#5 - $Module - CacheGet()",
    );
    $CacheDelete = $CacheObject->Delete(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->True(
        $CacheDelete,
        "#5 - $Module - CacheDelete()",
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
        "#6 - $Module - Set() - A-z type check",
    );

    $CacheDelete = $CacheObject->Delete(
        Type => 'Value2äöüß',
        Key  => 'Test',
    );
    $Self->True(
        !$CacheDelete || 0,
        "#6 - $Module - CacheDelete() - A-z type check",
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
        "#7 - $Module - CacheSet(), TTL 24*60*60",
    );

    # check get
    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->Is(
        $CacheGet || '',
        '1234',
        "#7 - $Module - CacheGet()",
    );

    # cleanup (expired)
    my $CacheCleanUp = $CacheObject->CleanUp( Expired => 1 );
    $Self->True(
        $CacheCleanUp,
        "#7 - $Module - CleanUp( Expired => 1 )",
    );

    # check get
    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->True(
        $CacheGet,
        "#7 - $Module - CacheGet() - Expired",
    );

    # cleanup
    $CacheCleanUp = $CacheObject->CleanUp();
    $Self->True(
        $CacheCleanUp,
        "#7 - $Module - CleanUp()",
    );

    # check get
    $CacheGet = $CacheObject->Get(
        Type => 'CacheTest2',
        Key  => 'Test',
    );
    $Self->False(
        $CacheGet,
        "#7 - $Module - CacheGet()",
    );

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
        for my $Type ( keys %CacheTests1 ) {

            # set cache
            my $CacheSet = $CacheObject->Set(
                Type  => 'CacheTestLong1',
                Key   => $Type . $Key,
                Value => $CacheTests1{$Type},
                TTL   => 24 * 60 * 60,
            );

            $Self->True(
                $CacheSet,
                "#8 - $Module - CacheSet1() Size $Size",
            );

            next TYPE if !$CacheSet;

            $KeyList{1}->{ $Type . $Key } = $CacheTests1{$Type};
        }

        TYPE:
        for my $Type ( keys %CacheTests2 ) {

            # set cache
            my $CacheSet = $CacheObject->Set(
                Type  => 'CacheTestLong2',
                Key   => $Type . $Key,
                Value => $CacheTests2{$Type},
                TTL   => 24 * 60 * 60,
            );

            $Self->True(
                $CacheSet,
                "#8 - $Module - CacheSet2() Size $Size",
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
                "#8 - $Module - CleanUp() - invalidate all values of CacheTestLong1",
            );

            # unset all values of CacheTestLong1
            for my $Key ( keys %{ $KeyList{1} } ) {
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
                "#8 - $Module - CleanUp() - invalidate all values of CacheTestLong2",
            );

            # unset all values of CacheTestLong2
            for my $Key ( keys %{ $KeyList{2} } ) {
                $KeyList{2}->{$Key} = '';
            }
        }

        for my $Count ( sort keys %KeyList ) {

            for my $Key ( keys %{ $KeyList{$Count} } ) {

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
                    my $CachedValue = Data::Dumper::Dumper($CacheGet);

                    # dump the reference attribute
                    my $OriginValue = Data::Dumper::Dumper($CacheItem);

                    $Self->True(
                        $CachedValue eq $OriginValue,
                        "#8 - $Module - CacheGet$Count() - Content Test",
                    );
                }
                else {

                    $Self->True(
                        $CacheGet eq $CacheItem,
                        "#8 - $Module - CacheGet$Count() - Content Test",
                    );
                }
            }
        }
    }

    # flush the cache
    $CacheObject->CleanUp();
}

1;
