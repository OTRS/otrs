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

my @Tests = (
    {
        Name   => 'Empty request',
        Config => {},
        Result => 'O',
    },
    {
        Name   => 'Invalid name',
        Config => {
            Fullname => '~!@#$%^ &*()_+=',    # non-word characters only
        },
        Result => 'O',
    },
    {
        Name   => 'Generic - John Doe',
        Config => {
            Fullname => 'John Doe',
        },
        Result => 'JD',
    },
    {
        Name   => 'Capitalization - jOhN dOe',
        Config => {
            Fullname => 'John Doe',
        },
        Result => 'JD',
    },
    {
        Name   => 'Mixed - "John Doe"',
        Config => {
            Fullname => '"John Doe"',
        },
        Result => 'JD',
    },
    {
        Name   => 'With email - "John Doe" <jdoe@example.com>',
        Config => {
            Fullname => '"John Doe" <jdoe@example.com>',
        },
        Result => 'JD',
    },
    {
        Name   => 'With something in brackets - John Doe (jdoe)',
        Config => {
            Fullname => 'John Doe (jdoe)',
        },
        Result => 'JD',
    },
    {
        Name   => 'Only one name - Joe',
        Config => {
            Fullname => 'Joe',
        },
        Result => 'J',
    },
    {
        Name   => 'Cyrillic - Петар Петровић',
        Config => {
            Fullname => 'Петар Петровић',
        },
        Result => 'ПП',
    },
    {
        Name   => 'Chinese - 约翰·多伊',
        Config => {
            Fullname => '约翰·多伊',
        },
        Result => '约',
    },
);

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

for my $Test (@Tests) {
    my $Result = $LayoutObject->UserInitialsGet(
        %{ $Test->{Config} },
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - Result"
    );
}

1;
