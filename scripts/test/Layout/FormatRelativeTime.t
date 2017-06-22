# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Title    => '2 Seconds',
        Subtract => {
            Seconds => 2,
        },
        ExpectedResult => {
            Message => 'just now',
            Value   => '0',
        },
    },
    {
        Title    => '9 Seconds',
        Subtract => {
            Seconds => 9,
        },
        ExpectedResult => {
            Message => 'just now',
            Value   => '0',
        },
    },
    {
        Title    => '10 Seconds',
        Subtract => {
            Seconds => 10,
        },
        ExpectedResult => {
            Message => 'less than a minute ago',
            Value   => '1',
        },
    },
    {
        Title    => '29 Seconds',
        Subtract => {
            Seconds => 29,
        },
        ExpectedResult => {
            Message => 'less than a minute ago',
            Value   => '1',
        },
    },
    {
        Title    => '30 Seconds',
        Subtract => {
            Seconds => 30,

        },
        ExpectedResult => {
            Message => 'a minute ago',
            Value   => '1',
        },
    },
    {
        Title    => '1 Minute 29 Seconds',
        Subtract => {
            Seconds => 29,
            Minutes => 1,

        },
        ExpectedResult => {
            Message => 'a minute ago',
            Value   => '1',
        },
    },
    {
        Title    => '1 Minute 30 Seconds',
        Subtract => {
            Seconds => 30,
            Minutes => 1,

        },
        ExpectedResult => {
            Message => '%s minutes ago',
            Value   => '2',
        },
    },
    {
        Title    => '5 Minutes 29 Seconds',
        Subtract => {
            Seconds => 29,
            Minutes => 5,

        },
        ExpectedResult => {
            Message => '%s minutes ago',
            Value   => '5',
        },
    },
    {
        Title    => '5 Minutes 30 Seconds',
        Subtract => {
            Seconds => 30,
            Minutes => 5,

        },
        ExpectedResult => {
            Message => '%s minutes ago',
            Value   => '6',
        },
    },
    {
        Title    => '44 Minutes 29 Seconds',
        Subtract => {
            Seconds => 29,
            Minutes => 44,
        },
        ExpectedResult => {
            Message => '%s minutes ago',
            Value   => '44',
        },
    },
    {
        Title    => '44 Minutes 30 Seconds',
        Subtract => {
            Seconds => 30,
            Minutes => 44,
        },
        ExpectedResult => {
            Message => 'about an hour ago',
            Value   => '1',
        },
    },
    {
        Title    => '2 Hours 30 Minutes',
        Subtract => {
            Seconds => 0,
            Minutes => 30,
            Hours   => 2,
        },
        ExpectedResult => {
            Message => 'about %s hours ago',
            Value   => '2',
        },
    },
    {
        Title    => '2 Hours 30 Minutes 1 Second',
        Subtract => {
            Seconds => 1,
            Minutes => 30,
            Hours   => 2,
        },
        ExpectedResult => {
            Message => 'about %s hours ago',
            Value   => '3',
        },
    },
    {
        Title    => '23 Hours 59 Minutes 59 Seconds',
        Subtract => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
        },
        ExpectedResult => {
            Message => 'about %s hours ago',
            Value   => '24',
        },
    },
    {
        Title    => '24 Hours',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 24,
        },
        ExpectedResult => {
            Message => 'a day ago',
            Value   => '1',
        },
    },
    {
        Title    => '41 Hours, 59 Minutes, 59 Seconds',
        Subtract => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 41,
        },
        ExpectedResult => {
            Message => 'a day ago',
            Value   => '1',
        },
    },
    {
        Title    => '42 Hours',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 42,
        },
        ExpectedResult => {
            Message => '%s days ago',
            Value   => '2',
        },
    },
    {
        Title    => '13 Days 11 Hours 59 Minutes 59 Seconds',
        Subtract => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 11,
            Days    => 13,
        },
        ExpectedResult => {
            Message => '%s days ago',
            Value   => '13',
        },
    },
    {
        Title    => '13 Days 12 Hours',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 12,
            Days    => 13,
        },
        ExpectedResult => {
            Message => '%s days ago',
            Value   => '14',
        },
    },
    {
        Title    => '29 Days 23 Hours 59 Minutes 59 Seconds',
        Subtract => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
            Days    => 29,
        },
        ExpectedResult => {
            Message => '%s days ago',
            Value   => '30',
        },
    },
    {
        Title    => '30 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 30,
        },
        ExpectedResult => {
            Message => 'about a month ago',
            Value   => '1',
        },
    },
    {
        Title    => '44 Days 23 Hours 59 Minutes 59 Seconds',
        Subtract => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
            Days    => 44,
        },
        ExpectedResult => {
            Message => 'about a month ago',
            Value   => '1',
        },
    },
    {
        Title    => '45 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 45,
        },
        ExpectedResult => {
            Message => 'about %s months ago',
            Value   => '2',
        },
    },
    {
        Title    => '3 Months 15 Days 23 Hours 59 Minutes 59 Seconds',
        Subtract => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
            Days    => 12,
            Months  => 3,
        },
        ExpectedResult => {
            Message => 'about %s months ago',
            Value   => '3',
        },
    },
    {
        Title    => '3 Months 16 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 16,
            Months  => 3,
        },
        ExpectedResult => {
            Message => 'about %s months ago',
            Value   => '4',
        },
    },
    {
        Title    => '1 Year',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 0,
            Months  => 0,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'about a year ago',
            Value   => '1',
        },
    },
    {
        Title    => '1 Year 2 Months',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 2,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'about a year ago',
            Value   => '1',
        },
    },
    {
        Title    => '1 Year 3 Months 2 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 3,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'over a year ago',
            Value   => '1',
        },
    },
    {
        Title    => '1 Year 8 Months 28 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 8,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'over a year ago',
            Value   => '1',
        },
    },
    {
        Title    => '1 Year 9 Months 1 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 1,
            Months  => 9,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'almost %s years ago',
            Value   => '2',
        },
    },
    {
        Title    => '2 Years 2 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 0,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'about %s years ago',
            Value   => '2',
        },
    },
    {
        Title    => '2 Years 3 Months 2 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 3,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'over %s years ago',
            Value   => '2',
        },
    },
    {
        Title    => '2 Years 8 Months 28 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 8,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'over %s years ago',
            Value   => '2',
        },
    },
    {
        Title    => '2 Years 9 Months 2 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 9,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'almost %s years ago',
            Value   => '3',
        },
    },
    {
        Title    => '2 Years 11 Months 28 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 11,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'almost %s years ago',
            Value   => '3',
        },
    },
    {
        Title    => '3 Years 2 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 0,
            Years   => 3,
        },
        ExpectedResult => {
            Message => 'about %s years ago',
            Value   => '3',
        },
    },
    {
        Title    => '30 Years 2 Days',
        Subtract => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 0,
            Years   => 30,
        },
        ExpectedResult => {
            Message => 'about %s years ago',
            Value   => '30',
        },
    },
    {
        Title => '2 Seconds',
        Add   => {
            Seconds => 2,
        },
        ExpectedResult => {
            Message => 'just now',
            Value   => '0',
        },
    },
    {
        Title => '9 Seconds',
        Add   => {
            Seconds => 9,
        },
        ExpectedResult => {
            Message => 'just now',
            Value   => '0',
        },
    },
    {
        Title => '10 Seconds',
        Add   => {
            Seconds => 10,
        },
        ExpectedResult => {
            Message => 'in less than a minute',
            Value   => '1',
        },
    },
    {
        Title => '29 Seconds',
        Add   => {
            Seconds => 29,
        },
        ExpectedResult => {
            Message => 'in less than a minute',
            Value   => '1',
        },
    },
    {
        Title => '30 Seconds',
        Add   => {
            Seconds => 30,

        },
        ExpectedResult => {
            Message => 'in a minute',
            Value   => '1',
        },
    },
    {
        Title => '1 Minute 29 Seconds',
        Add   => {
            Seconds => 29,
            Minutes => 1,

        },
        ExpectedResult => {
            Message => 'in a minute',
            Value   => '1',
        },
    },
    {
        Title => '1 Minute 30 Seconds',
        Add   => {
            Seconds => 30,
            Minutes => 1,

        },
        ExpectedResult => {
            Message => 'in %s minutes',
            Value   => '2',
        },
    },
    {
        Title => '5 Minutes 29 Seconds',
        Add   => {
            Seconds => 29,
            Minutes => 5,

        },
        ExpectedResult => {
            Message => 'in %s minutes',
            Value   => '5',
        },
    },
    {
        Title => '5 Minutes 30 Seconds',
        Add   => {
            Seconds => 30,
            Minutes => 5,

        },
        ExpectedResult => {
            Message => 'in %s minutes',
            Value   => '6',
        },
    },
    {
        Title => '44 Minutes 29 Seconds',
        Add   => {
            Seconds => 29,
            Minutes => 44,
        },
        ExpectedResult => {
            Message => 'in %s minutes',
            Value   => '44',
        },
    },
    {
        Title => '44 Minutes 30 Seconds',
        Add   => {
            Seconds => 30,
            Minutes => 44,
        },
        ExpectedResult => {
            Message => 'in an hour',
            Value   => '1',
        },
    },
    {
        Title => '2 Hours 30 Minutes',
        Add   => {
            Seconds => 0,
            Minutes => 30,
            Hours   => 2,
        },
        ExpectedResult => {
            Message => 'in %s hours',
            Value   => '2',
        },
    },
    {
        Title => '2 Hours 30 Minutes 1 Second',
        Add   => {
            Seconds => 1,
            Minutes => 30,
            Hours   => 2,
        },
        ExpectedResult => {
            Message => 'in %s hours',
            Value   => '3',
        },
    },
    {
        Title => '23 Hours 59 Minutes 59 Seconds',
        Add   => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
        },
        ExpectedResult => {
            Message => 'in %s hours',
            Value   => '24',
        },
    },
    {
        Title => '24 Hours',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 24,
        },
        ExpectedResult => {
            Message => 'in a day',
            Value   => '1',
        },
    },
    {
        Title => '41 Hours, 59 Minutes, 59 Seconds',
        Add   => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 41,
        },
        ExpectedResult => {
            Message => 'in a day',
            Value   => '1',
        },
    },
    {
        Title => '42 Hours',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 42,
        },
        ExpectedResult => {
            Message => 'in %s days',
            Value   => '2',
        },
    },
    {
        Title => '13 Days 11 Hours 59 Minutes 59 Seconds',
        Add   => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 11,
            Days    => 13,
        },
        ExpectedResult => {
            Message => 'in %s days',
            Value   => '13',
        },
    },
    {
        Title => '13 Days 12 Hours',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 12,
            Days    => 13,
        },
        ExpectedResult => {
            Message => 'in %s days',
            Value   => '14',
        },
    },
    {
        Title => '29 Days 23 Hours 59 Minutes 59 Seconds',
        Add   => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
            Days    => 29,
        },
        ExpectedResult => {
            Message => 'in %s days',
            Value   => '30',
        },
    },
    {
        Title => '30 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 30,
        },
        ExpectedResult => {
            Message => 'in a month',
            Value   => '1',
        },
    },
    {
        Title => '44 Days 23 Hours 59 Minutes 59 Seconds',
        Add   => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
            Days    => 44,
        },
        ExpectedResult => {
            Message => 'in a month',
            Value   => '1',
        },
    },
    {
        Title => '45 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 45,
        },
        ExpectedResult => {
            Message => 'in %s months',
            Value   => '2',
        },
    },
    {
        Title => '3 Months 15 Days 23 Hours 59 Minutes 59 Seconds',
        Add   => {
            Seconds => 59,
            Minutes => 59,
            Hours   => 23,
            Days    => 12,
            Months  => 3,
        },
        ExpectedResult => {
            Message => 'in %s months',
            Value   => '3',
        },
    },
    {
        Title => '3 Months 16 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 16,
            Months  => 3,
        },
        ExpectedResult => {
            Message => 'in %s months',
            Value   => '4',
        },
    },
    {
        Title => '1 Year',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 0,
            Months  => 0,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'in a year',
            Value   => '1',
        },
    },
    {
        Title => '1 Year 2 Months',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 2,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'in a year',
            Value   => '1',
        },
    },
    {
        Title => '1 Year 3 Months 2 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 3,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'in over a year',
            Value   => '1',
        },
    },
    {
        Title => '1 Year 8 Months 28 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 8,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'in over a year',
            Value   => '1',
        },
    },
    {
        Title => '1 Year 9 Months 1 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 1,
            Months  => 9,
            Years   => 1,
        },
        ExpectedResult => {
            Message => 'in almost %s years',
            Value   => '2',
        },
    },
    {
        Title => '2 Years 2 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 0,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'in %s years',
            Value   => '2',
        },
    },
    {
        Title => '2 Years 3 Months 2 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 3,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'in over %s years',
            Value   => '2',
        },
    },
    {
        Title => '2 Years 8 Months 28 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 8,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'in over %s years',
            Value   => '2',
        },
    },
    {
        Title => '2 Years 9 Months 2 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 9,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'in almost %s years',
            Value   => '3',
        },
    },
    {
        Title => '2 Years 11 Months 28 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 28,
            Months  => 11,
            Years   => 2,
        },
        ExpectedResult => {
            Message => 'in almost %s years',
            Value   => '3',
        },
    },
    {
        Title => '3 Years 2 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 0,
            Years   => 3,
        },
        ExpectedResult => {
            Message => 'in %s years',
            Value   => '3',
        },
    },
    {
        Title => '30 Years 2 Days',
        Add   => {
            Seconds => 0,
            Minutes => 0,
            Hours   => 0,
            Days    => 2,
            Months  => 0,
            Years   => 30,
        },
        ExpectedResult => {
            Message => 'in %s years',
            Value   => '30',
        },
    },
);

for my $Test (@Tests) {

    # Get current DateTime object.
    my $CurrentDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );

    if ( $Test->{Add} ) {
        $CurrentDateTimeObject->Add(
            %{ $Test->{Add} },
        );
    }
    elsif ( $Test->{Subtract} ) {
        $CurrentDateTimeObject->Subtract(
            %{ $Test->{Subtract} },
        );
    }

    my %Result = $LayoutObject->FormatRelativeTime(
        DateTimeObject => $CurrentDateTimeObject,
    );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        "Check FormatRelativeTime() result - $Test->{Title}."
    );
}

1;
