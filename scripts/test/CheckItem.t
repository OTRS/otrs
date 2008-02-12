# --
# CheckItem.t - check item tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CheckItem.t,v 1.5.2.3 2008-02-12 18:39:05 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::CheckItem;

# disable dns lookups
$Self->{ConfigObject}->Set( Key => 'CheckMXRecord', Value => 0 );
$Self->{ConfigObject}->Set( Key => 'CheckEmailAddresses', Value => 1 );

# create new object
$Self->{CheckItemObject} = Kernel::System::CheckItem->new(%{$Self});

# email address checks
my @EmailTests = (
    # Invalid
    {
        Email => 'somebody',
        Valid => 0,
    },
    {
        Email => 'somebod y@somehost.com',
        Valid => 0,
    },
    {
        Email => 'ä@somehost.com',
        Valid => 0,
    },
    {
        Email => '.somebody@somehost.com',
        Valid => 0,
    },
    {
        Email => 'somebody.@somehost.com',
        Valid => 0,
    },
    {
        Email => 'some..body@somehost.com',
        Valid => 0,
    },
    {
        Email => 'some@body@somehost.com',
        Valid => 0,
    },
    # Valid
    {
        Email => 'somebody@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some.body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some+body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some-body@somehost.com',
        Valid => 1,
    },
    {
        Email => 'some_b_o_d_y@somehost.com',
        Valid => 1,
    },
    {
        Email => 'Some.Bo_dY.test.TesT@somehost.com',
        Valid => 1,
    },
    {
        Email => '_some.name@somehost.com',
        Valid => 1,
    },
);

for my $Test ( @EmailTests ) {

    # check address
    my $Valid = $Self->{CheckItemObject}->CheckEmail(
        Address => $Test->{Email},
    );

    # execute unit test
    if ( $Test->{Valid} ) {
        $Self->True(
            $Valid,
            "CheckEmail() - $Test->{Email}",
        );
    }
    else {
        $Self->False(
            $Valid,
            "CheckEmail() - $Test->{Email}",
        );
    }
}

1;
