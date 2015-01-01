# --
# SysConfig.t - SysConfig tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::SysConfig;
use Kernel::System::UnitTest::Helper;

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 1,
);

my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );

#
# ConfigItemUpdate
#

my @Tests = (
    {
        Value => 'some string',
        Name  => 'Simple string',
    },
    {
        Value => 'some unicode string Россия',
        Name  => 'String with unicode',
    },
    {
        Value => {
            String => 'Simple hash',
        },
        Name => 'Simple hash',
    },
    {
        Value => {
            String => 'some unicode string Россия',
            Hash   => {
                ''    => 'some unicode string Россия',
                Empty => undef,
                List  => [
                    Hash => {
                        Value => 123,
                    },
                    456,
                    ]
                }
        },
        Name => 'Complex structure with unicode data',
    }
);

for my $Test (@Tests) {

    # We 'abuse' the setting Frontend::DebugMode. It will be
    #   restored to the original value in the destructor by
    #   the HelperObject.

    $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Frontend::DebugMode',
        Value => $Test->{Value},
    );

    # Force a reload of ZZZAuto.pm to get the new value
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAuto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    my $ConfigObject = Kernel::Config->new();

    $Self->IsDeeply(
        $ConfigObject->Get('Frontend::DebugMode'),
        $Test->{Value},
        "ConfigItemUdpate() - $Test->{Name}",
    );
}

#
# _XML2Perl()
#
my %Config = $SysConfigObject->ConfigItemGet(
    Name    => 'FQDN',
    Default => 1,
);
my $FQDN = $SysConfigObject->_XML2Perl( Data => \%Config );
$Self->Is(
    $FQDN || '',
    " 'yourhost.example.com';\n",
    '_XML2Perl() SCALAR',
);

#
# _DataDiff()
#
my $A    = 'Test';
my $B    = 'Test';
my $Diff = $SysConfigObject->_DataDiff(
    Data1 => \$A,
    Data2 => \$B,
);
$Self->False(
    $Diff,
    'DataDiff() SCALAR',
);

$A    = 'Test';
$B    = 'Test2';
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \$A,
    Data2 => \$B,
);
$Self->True(
    $Diff,
    'DataDiff() SCALAR',
);

my @Ar = ('Test');
my @Br = ('Test');
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \@Ar,
    Data2 => \@Br,
);
$Self->False(
    $Diff,
    'DataDiff() ARRAY',
);

@Ar   = ('Test2');
@Br   = ('Test');
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \@Ar,
    Data2 => \@Br,
);
$Self->True(
    $Diff,
    'DataDiff() ARRAY',
);

my %Ah = ( 'Test' => 123 );
my %Bh = ( 'Test' => 123 );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->False(
    $Diff,
    'DataDiff() HASH',
);

%Ah = ( 'Test' => 123 );
%Bh = (
    'Test' => 123,
    ''     => ''
);
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->True(
    $Diff,
    'DataDiff() HASH',
);

%Ah = (
    'Test' => 123,
    A      => [ 1, 3, 4 ]
);
%Bh = (
    'Test' => 123,
    A      => [ 1, 3, 4 ]
);
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->False(
    $Diff,
    'DataDiff() HASH',
);

%Ah = (
    'Test' => 123,
    A      => [ 1, 3, 4 ]
);
%Bh = (
    'Test' => 123,
    A      => [ 1, 4, 4 ]
);
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->True(
    $Diff,
    'DataDiff() HASH',
);

%Ah = (
    'Test' => 123,
    A      => [ 1, 3, 4 ],
    B => { a => 1 },
    special => undef
);
%Bh = (
    'Test' => 123,
    A      => [ 1, 3, 4 ],
    B => { a => 1 },
    special => undef
);
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->False(
    $Diff,
    'DataDiff() HASH',
);

%Ah = (
    'Test' => 123,
    A      => [ 1, 3, 4 ],
    B => { a => 1 },
);
%Bh = (
    'Test' => 123,
    A      => [ 1, 3, 4 ],
    B      => {
        a  => 1,
        '' => undef,
    },
);
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->True(
    $Diff,
    'DataDiff() HASH',
);

@Ar = ( 'Test', { a => 1 } );
@Br = ( 'Test', { a => 1 } );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \@Ar,
    Data2 => \@Br,
);
$Self->False(
    $Diff,
    'DataDiff() ARRAY',
);

@Ar = ( 'Test', { a => 2 } );
@Br = ( 'Test', { a => 1 } );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \@Ar,
    Data2 => \@Br,
);
$Self->True(
    $Diff,
    'DataDiff() ARRAY',
);

@Ar = ( 'Test', { a => 1 }, [ 1, 3 ] );
@Br = ( 'Test', { a => 1 }, [ 1, 3 ] );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \@Ar,
    Data2 => \@Br,
);
$Self->False(
    $Diff,
    'DataDiff() ARRAY',
);

@Ar = ( 'Test', { a => 1 }, [ 1,     3 ] );
@Br = ( 'Test', { a => 1 }, [ undef, 3 ] );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \@Ar,
    Data2 => \@Br,
);
$Self->True(
    $Diff,
    'DataDiff() ARRAY',
);

$Diff = $SysConfigObject->_DataDiff(
    Data1 => \undef,
    Data2 => \undef,
);
$Self->False(
    $Diff,
    'DataDiff() undef/undef',
);

$Diff = $SysConfigObject->_DataDiff(
    Data1 => \undef,
    Data2 => \'String',
);
$Self->True(
    $Diff,
    'DataDiff() undef/Scalar',
);

$Diff = $SysConfigObject->_DataDiff(
    Data1 => \'String',
    Data2 => \undef,
);
$Self->True(
    $Diff,
    'DataDiff() Scalar/undef',
);

1;
