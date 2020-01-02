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

use vars (qw($Self));

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Timezones = ( 'UTC', 'Europe/Berlin' );

my @Tests = (
    {
        Title  => 'Current time',
        Params => {},
    },
    {
        Title  => 'For epoch 1414281600',
        Params => {
            Epoch => 1414281600,
        },
    },
);

for my $Timezone (@Timezones) {

    $ConfigObject->Set(
        Key   => 'OTRSTimeZone',
        Value => $Timezone,
    );

    for my $Test (@Tests) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                %{ $Test->{Params} },
            },
        );
        my $ClonedDateTimeObject = $DateTimeObject->Clone();

        $Self->IsDeeply(
            $ClonedDateTimeObject->Get(),
            $DateTimeObject->Get(),
            "$Test->{Title} ($Timezone) Values of cloned DateTime object must match those of original object."
        );

        $Self->Is(
            $ClonedDateTimeObject->ToEpoch(),
            $DateTimeObject->ToEpoch(),
            "$Test->{Title} ($Timezone) Compare unix epoch time",
        );
        $Self->Is(
            $ClonedDateTimeObject->ToString(),
            $DateTimeObject->ToString(),
            "$Test->{Title} ($Timezone) Compare timestamp",
        );

        # Change cloned DateTime object, must not influence original object
        $ClonedDateTimeObject->Add( Days => 10 );
        $Self->IsNotDeeply(
            $ClonedDateTimeObject->Get(),
            $DateTimeObject->Get(),
            "$Test->{Title} ($Timezone) Changed values of cloned DateTime object must not influence those of original object."
        );

        $Self->IsNot(
            $ClonedDateTimeObject->ToEpoch(),
            $DateTimeObject->ToEpoch(),
            "$Test->{Title} ($Timezone) Compare updated unix epoch time",
        );

        $Self->IsNot(
            $ClonedDateTimeObject->ToString(),
            $DateTimeObject->ToString(),
            "$Test->{Title} ($Timezone) Compare updated timestamp",
        );
    }
}
1;
