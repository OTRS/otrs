# --
# SysConfig.t - SysConfig tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: SysConfig.t,v 1.11 2010-10-29 22:16:59 en Exp $
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

my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );

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
%Bh = ( 'Test' => 123, '' => '' );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->True(
    $Diff,
    'DataDiff() HASH',
);

%Ah = ( 'Test' => 123, A => [ 1, 3, 4 ] );
%Bh = ( 'Test' => 123, A => [ 1, 3, 4 ] );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->False(
    $Diff,
    'DataDiff() HASH',
);

%Ah = ( 'Test' => 123, A => [ 1, 3, 4 ] );
%Bh = ( 'Test' => 123, A => [ 1, 4, 4 ] );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->True(
    $Diff,
    'DataDiff() HASH',
);

%Ah = ( 'Test' => 123, A => [ 1, 3, 4 ], B => { a => 1 }, );
%Bh = ( 'Test' => 123, A => [ 1, 3, 4 ], B => { a => 1 }, );
$Diff = $SysConfigObject->_DataDiff(
    Data1 => \%Ah,
    Data2 => \%Bh,
);
$Self->False(
    $Diff,
    'DataDiff() HASH',
);

%Ah = ( 'Test' => 123, A => [ 1, 3, 4 ], B => { a => 1 }, );
%Bh = ( 'Test' => 123, A => [ 1, 3, 4 ], B => { a => 1, '' => undef, }, );
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
