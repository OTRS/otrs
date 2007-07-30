# --
# CustomerUserService.t - CustomerUserService tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerUserService.t,v 1.1 2007-07-30 14:52:58 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Service;

$Self->{ServiceObject} = Kernel::System::Service->new(%{$Self});

# save all original default services
my @OriginalDefaultServices = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => '<DEFAULT>',
    Result => 'ID',
    DefaultServices => 0,
);

# delete all default services
foreach my $ServiceID (@OriginalDefaultServices) {
    $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
        CustomerUserLogin => '<DEFAULT>',
        ServiceID => $ServiceID,
        Active => 0,
        UserID => 1,
    );
}

# add service1
my $ServiceRand1 = 'SomeService'.int(rand(1000000));
my $ServiceID1 = $Self->{ServiceObject}->ServiceAdd(
    Name => $ServiceRand1,
    Comment => 'Some Comment',
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $ServiceID1,
    'ServiceAdd1()',
);

# add service2
my $ServiceRand2 = 'SomeService'.int(rand(1000000));
my $ServiceID2 = $Self->{ServiceObject}->ServiceAdd(
    Name => $ServiceRand2,
    Comment => 'Some Comment',
    ValidID => 1,
    UserID => 1,
);

$Self->True(
    $ServiceID2,
    'ServiceAdd2()',
);

my $CustomerUser1 = 'SomeUser'.int(rand(1000000));
my $CustomerUser2 = 'SomeUser'.int(rand(1000000));

# allocation test 1
my @Allocation1 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
    DefaultServices => 0,
);

$Self->False(
    scalar @Allocation1,
    'CustomerUserServiceMemberList1()',
);

# allocation test 2
my @Allocation2 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
);

$Self->False(
    scalar @Allocation2,
    'CustomerUserServiceMemberList2()',
);

# allocation test 3
my @Allocation3 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
    DefaultServices => 0,
);

$Self->False(
    scalar @Allocation3,
    'CustomerUserServiceMemberList3()',
);

# allocation test 4
my @Allocation4 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
);

$Self->False(
    scalar @Allocation4,
    'CustomerUserServiceMemberList4()',
);

# set allocation 1
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => '<DEFAULT>',
    ServiceID => $ServiceID1,
    Active => 1,
    UserID => 1,
);

# allocation test 5
my @Allocation5 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
    DefaultServices => 0,
);

$Self->False(
    scalar @Allocation5,
    'CustomerUserServiceMemberList5()',
);

# allocation test 6
my @Allocation6 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
);

my $Allocation6Count = @Allocation6;
my $Allocation6Ok = 0;
if ($Allocation6Count eq 1 && $Allocation6[0] eq $ServiceID1) {
    $Allocation6Ok = 1;
}

$Self->True(
    $Allocation6Ok,
    'CustomerUserServiceMemberList6()',
);

# allocation test 7
my @Allocation7 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
    DefaultServices => 0,
);

$Self->False(
    scalar @Allocation7,
    'CustomerUserServiceMemberList7()',
);

# allocation test 8
my @Allocation8 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
);

my $Allocation8Count = @Allocation8;
my $Allocation8Ok = 0;
if ($Allocation8Count eq 1 && $Allocation8[0] eq $ServiceID1) {
    $Allocation8Ok = 1;
}

$Self->True(
    $Allocation8Ok,
    'CustomerUserServiceMemberList8()',
);

# set allocation 2
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser1,
    ServiceID => $ServiceID2,
    Active => 1,
    UserID => 1,
);

# allocation test 9
my @Allocation9 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
    DefaultServices => 0,
);

my $Allocation9Count = @Allocation9;
my $Allocation9Ok = 0;
if ($Allocation9Count eq 1 && $Allocation9[0] eq $ServiceID2) {
    $Allocation9Ok = 1;
}

$Self->True(
    $Allocation9Ok,
    'CustomerUserServiceMemberList9()',
);

# allocation test 10
my @Allocation10 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
);

my $Allocation10Count = @Allocation10;
my $Allocation10Ok = 0;
if ($Allocation10Count eq 1 && $Allocation10[0] eq $ServiceID2) {
    $Allocation10Ok = 1;
}

$Self->True(
    $Allocation10Ok,
    'CustomerUserServiceMemberList10()',
);

# allocation test 11
my @Allocation11 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
    DefaultServices => 0,
);

$Self->False(
    scalar @Allocation11,
    'CustomerUserServiceMemberList11()',
);

# allocation test 12
my @Allocation12 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
);

my $Allocation12Count = @Allocation12;
my $Allocation12Ok = 0;
if ($Allocation12Count eq 1 && $Allocation12[0] eq $ServiceID1) {
    $Allocation12Ok = 1;
}

$Self->True(
    $Allocation12Ok,
    'CustomerUserServiceMemberList12()',
);

# set allocation 3
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser2,
    ServiceID => $ServiceID1,
    Active => 1,
    UserID => 1,
);
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser2,
    ServiceID => $ServiceID2,
    Active => 1,
    UserID => 1,
);

# allocation test 13
my @Allocation13 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
    DefaultServices => 0,
);

my $Allocation13Count = @Allocation13;
my $Allocation13Ok = 0;
if ($Allocation13Count eq 1 && $Allocation13[0] eq $ServiceID2) {
    $Allocation13Ok = 1;
}

$Self->True(
    $Allocation13Ok,
    'CustomerUserServiceMemberList13()',
);

# allocation test 14
my @Allocation14 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser1,
    Result => 'ID',
);

my $Allocation14Count = @Allocation14;
my $Allocation14Ok = 0;
if ($Allocation14Count eq 1 && $Allocation14[0] eq $ServiceID2) {
    $Allocation14Ok = 1;
}

$Self->True(
    $Allocation14Ok,
    'CustomerUserServiceMemberList14()',
);

# allocation test 15
my @Allocation15 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
    DefaultServices => 0,
);

my $Allocation15Count = @Allocation15;
my $Allocation15Ok = 0;
if ($Allocation15Count eq 2 && (
    ($Allocation15[0] eq $ServiceID1 && $Allocation15[1] eq $ServiceID2) ||
    ($Allocation15[0] eq $ServiceID2 && $Allocation15[1] eq $ServiceID1)
)) {
    $Allocation15Ok = 1;
}

$Self->True(
    $Allocation15Ok,
    'CustomerUserServiceMemberList15()',
);

# allocation test 16
my @Allocation16 = $Self->{ServiceObject}->CustomerUserServiceMemberList(
    CustomerUserLogin => $CustomerUser2,
    Result => 'ID',
);

my $Allocation16Count = @Allocation16;
my $Allocation16Ok = 0;
if ($Allocation16Count eq 2 && (
    ($Allocation16[0] eq $ServiceID1 && $Allocation16[1] eq $ServiceID2) ||
    ($Allocation16[0] eq $ServiceID2 && $Allocation16[1] eq $ServiceID1)
)) {
    $Allocation16Ok = 1;
}

$Self->True(
    $Allocation16Ok,
    'CustomerUserServiceMemberList16()',
);

# delete all test allocations to clean system
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => '<DEFAULT>',
    ServiceID => $ServiceID1,
    Active => 0,
    UserID => 1,
);
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => '<DEFAULT>',
    ServiceID => $ServiceID2,
    Active => 0,
    UserID => 1,
);
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser1,
    ServiceID => $ServiceID1,
    Active => 0,
    UserID => 1,
);
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser1,
    ServiceID => $ServiceID2,
    Active => 0,
    UserID => 1,
);
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser2,
    ServiceID => $ServiceID1,
    Active => 0,
    UserID => 1,
);
$Self->{ServiceObject}->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $CustomerUser2,
    ServiceID => $ServiceID2,
    Active => 0,
    UserID => 1,
);

# restore all original default services
foreach my $ServiceID (@OriginalDefaultServices) {
    $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
        CustomerUserLogin => '<DEFAULT>',
        ServiceID => $ServiceID,
        Active => 1,
        UserID => 1,
    );
}

# set service1 invalid
my $ServiceUpdate1 = $Self->{ServiceObject}->ServiceUpdate(
    ServiceID => $ServiceID1,
    Name => $ServiceRand1,
    ValidID => 2,
    UserID => 1,
);

$Self->True(
    $ServiceUpdate1,
    'ServiceUpdate1()',
);

# set service2 invalid
my $ServiceUpdate2 = $Self->{ServiceObject}->ServiceUpdate(
    ServiceID => $ServiceID2,
    Name => $ServiceRand2,
    ValidID => 2,
    UserID => 1,
);

$Self->True(
    $ServiceUpdate2,
    'ServiceUpdate2()',
);

1;