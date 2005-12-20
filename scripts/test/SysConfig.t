# --
# SysConfig.t - SysConfig tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SysConfig.t,v 1.1 2005-12-20 22:53:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Config;

$Self->{SystemConfigObject} = Kernel::System::Config->new(%{$Self});

my $A = 'Test';
my $B = 'Test';
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \$A,
        Data2 => \$B,
    ),
    0,
    'DataDiff() SCALAR',
);

$A = 'Test';
$B = 'Test2';
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \$A,
        Data2 => \$B,
    ),
    1,
    'DataDiff() SCALAR',
);

my @Ar = ('Test');
my @Br = ('Test');
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \@Ar,
        Data2 => \@Br,
    ),
    0,
    'DataDiff() ARRAY',
);

@Ar = ('Test2');
@Br = ('Test');
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \@Ar,
        Data2 => \@Br,
    ),
    1,
    'DataDiff() ARRAY',
);

my %Ah = ('Test' => 123);
my %Bh = ('Test' => 123);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \%Ah,
        Data2 => \%Bh,
    ),
    0,
    'DataDiff() HASH',
);

%Ah = ('Test' => 123);
%Bh = ('Test' => 123, '' => '');
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \%Ah,
        Data2 => \%Bh,
    ),
    1,
    'DataDiff() HASH',
);

%Ah = ('Test' => 123, A => [1,3,4]);
%Bh = ('Test' => 123, A => [1,3,4]);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \%Ah,
        Data2 => \%Bh,
    ),
    0,
    'DataDiff() HASH',
);

%Ah = ('Test' => 123, A => [1,3,4]);
%Bh = ('Test' => 123, A => [1,4,4]);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \%Ah,
        Data2 => \%Bh,
    ),
    1,
    'DataDiff() HASH',
);

%Ah = ('Test' => 123, A => [1,3,4], B => { a => 1},);
%Bh = ('Test' => 123, A => [1,3,4], B => { a => 1},);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \%Ah,
        Data2 => \%Bh,
    ),
    0,
    'DataDiff() HASH',
);

%Ah = ('Test' => 123, A => [1,3,4], B => { a => 1}, );
%Bh = ('Test' => 123, A => [1,3,4], B => { a => 1, '' => undef, },);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \%Ah,
        Data2 => \%Bh,
    ),
    1,
    'DataDiff() HASH',
);

@Ar = ('Test', {a => 1});
@Br = ('Test', {a => 1});
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \@Ar,
        Data2 => \@Br,
    ),
    0,
    'DataDiff() ARRAY',
);

@Ar = ('Test', {a => 2});
@Br = ('Test', {a => 1});
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \@Ar,
        Data2 => \@Br,
    ),
    1,
    'DataDiff() ARRAY',
);

@Ar = ('Test', {a => 1}, [1,3]);
@Br = ('Test', {a => 1}, [1,3]);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \@Ar,
        Data2 => \@Br,
    ),
    0,
    'DataDiff() ARRAY',
);

@Ar = ('Test', {a => 1}, [1,3]);
@Br = ('Test', {a => 1}, [undef,3]);
$Self->Is(
    $Self->{SystemConfigObject}->DataDiff(
        Data1 => \@Ar,
        Data2 => \@Br,
    ),
    1,
    'DataDiff() ARRAY',
);


1;
