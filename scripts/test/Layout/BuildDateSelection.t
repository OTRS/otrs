# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

local $ENV{TZ} = 'UTC';

use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::Output::HTML::Layout' => {
        Lang => 'en',
    },
);

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'TimeZone',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'TimeInputFormat',
    Value => 'Option',
);

$HelperObject->FixedTimeSet();

# get time object
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
    SystemTime => $TimeObject->SystemTime(),
);

my $MonthID  = int $Month;
my $DayID    = int $Day;
my $MinuteID = int $Min;
my $HourID   = int $Hour;

my $SetConfig = sub {
    my %Param = @_;

    my $Success = $ConfigObject->Set(
        Key   => $Param{Key},
        Value => $Param{Value},
    );
    $Self->True(
        $Success,
        ( $Param{Message} || "SysConfig Set() for key $Param{Key}" ) . "with true",
    );
};

my @Tests = (
    {
        Name          => 'No Options',
        Config        => {},
        ExpectedValue => "<select id=\"Month\" name=\"Month\" title=\"Month\">
  <option value=\"$MonthID\" selected=\"selected\">$Month</option>
</select>
<select class=\" \" id=\"Day\" name=\"Day\" title=\"Day\">
  <option value=\"$DayID\" selected=\"selected\">$Day</option>
</select>
<select id=\"Year\" name=\"Year\" title=\"Year\">
  <option value=\"$Year\" selected=\"selected\">$Year</option>
</select>",
    },
    {
        Name   => 'Long Format',
        Config => {
            Format => 'DateInputFormatLong',
        },
        ExpectedValue => "<select id=\"Month\" name=\"Month\" title=\"Month\">
  <option value=\"$MonthID\" selected=\"selected\">$Month</option>
</select>
<select class=\" \" id=\"Day\" name=\"Day\" title=\"Day\">
  <option value=\"$DayID\" selected=\"selected\">$Day</option>
</select>
<select id=\"Year\" name=\"Year\" title=\"Year\">
  <option value=\"$Year\" selected=\"selected\">$Year</option>
</select>
<select id=\"Hour\" name=\"Hour\" title=\"Hours\">
  <option value=\"$HourID\" selected=\"selected\">$Hour</option>
</select>
<select id=\"Minute\" name=\"Minute\" title=\"Minutes\">
  <option value=\"$MinuteID\" selected=\"selected\">$Min</option>
</select>",
    },
    {
        Name   => 'Optional',
        Config => {
            Prefix       => 'Test',
            TestOptional => 1,
        },
        ExpectedValue =>
            "<input type=\"checkbox\" name=\"TestUsed\" id=\"TestUsed\" value=\"1\" class=\"\" title=\"Check to activate this date\" />
<select id=\"TestMonth\" name=\"TestMonth\" title=\"Month\">
  <option value=\"$MonthID\" selected=\"selected\">$Month</option>
</select>
<select class=\" \" id=\"TestDay\" name=\"TestDay\" title=\"Day\">
  <option value=\"$DayID\" selected=\"selected\">$Day</option>
</select>
<select id=\"TestYear\" name=\"TestYear\" title=\"Year\">
  <option value=\"$Year\" selected=\"selected\">$Year</option>
</select>",
    },
    {
        Name      => 'No Options (Input)',
        Config    => {},
        SetConfig => {
            Key     => 'TimeInputFormat',
            Value   => 'Input',
            Message => 'Set TimeInputFormat to Input',
        },
        ExpectedValue =>
            "<input type=\"text\" class=\"\" name=\"Month\" id=\"Month\" size=\"2\" maxlength=\"2\" title=\"Month\" value=\"$Month\" />
<input type=\"text\" class=\" \" name=\"Day\" id=\"Day\" size=\"2\" maxlength=\"2\" title=\"Day\" value=\"$Day\" />
<input type=\"text\" class=\"\" name=\"Year\" id=\"Year\" size=\"4\" maxlength=\"4\" title=\"Year\" value=\"$Year\" />",
    },
    {
        Name   => 'Long Format (Input)',
        Config => {
            Format => 'DateInputFormatLong',
        },
        ExpectedValue =>
            "<input type=\"text\" class=\"\" name=\"Month\" id=\"Month\" size=\"2\" maxlength=\"2\" title=\"Month\" value=\"$Month\" />
<input type=\"text\" class=\" \" name=\"Day\" id=\"Day\" size=\"2\" maxlength=\"2\" title=\"Day\" value=\"$Day\" />
<input type=\"text\" class=\"\" name=\"Year\" id=\"Year\" size=\"4\" maxlength=\"4\" title=\"Year\" value=\"$Year\" />
<input type=\"text\" class=\"\" name=\"Hour\" id=\"Hour\" size=\"2\" maxlength=\"2\" title=\"Hours\" value=\"$Hour\" />
<input type=\"text\" class=\"\" name=\"Minute\" id=\"Minute\" size=\"2\" maxlength=\"2\" title=\"Minutes\" value=\"$Min\" />",
    },
    {
        Name   => 'Optional (Input)',
        Config => {
            Prefix       => 'Test',
            TestOptional => 1,
        },
        ExpectedValue =>
            "<input type=\"checkbox\" name=\"TestUsed\" id=\"TestUsed\" value=\"1\" class=\"\" title=\"Check to activate this date\" />
<input type=\"text\" class=\"\" name=\"TestMonth\" id=\"TestMonth\" size=\"2\" maxlength=\"2\" title=\"Month\" value=\"$Month\" />
<input type=\"text\" class=\" \" name=\"TestDay\" id=\"TestDay\" size=\"2\" maxlength=\"2\" title=\"Day\" value=\"$Day\" />
<input type=\"text\" class=\"\" name=\"TestYear\" id=\"TestYear\" size=\"4\" maxlength=\"4\" title=\"Year\" value=\"$Year\" />",
    },

    # TODO: add more tests for the different parameters here!
    {
        Name   => 'Disabled',
        Config => {
            Disabled => 1,
        },
        SetConfig => {
            Key     => 'TimeInputFormat',
            Value   => 'Option',
            Message => 'Set TimeInputFormat to Option',
        },
        ExpectedValue => "<select disabled=\"disabled\" id=\"Month\" name=\"Month\" title=\"Month\">
  <option value=\"$MonthID\" selected=\"selected\">$Month</option>
</select>
<select class=\" \" disabled=\"disabled\" id=\"Day\" name=\"Day\" title=\"Day\">
  <option value=\"$DayID\" selected=\"selected\">$Day</option>
</select>
<select disabled=\"disabled\" id=\"Year\" name=\"Year\" title=\"Year\">
  <option value=\"$Year\" selected=\"selected\">$Year</option>
</select>",
    },
    {
        Name   => 'Disabled Long Format',
        Config => {
            Format   => 'DateInputFormatLong',
            Disabled => 1,
        },
        ExpectedValue => "<select disabled=\"disabled\" id=\"Month\" name=\"Month\" title=\"Month\">
  <option value=\"$MonthID\" selected=\"selected\">$Month</option>
</select>
<select class=\" \" disabled=\"disabled\" id=\"Day\" name=\"Day\" title=\"Day\">
  <option value=\"$DayID\" selected=\"selected\">$Day</option>
</select>
<select disabled=\"disabled\" id=\"Year\" name=\"Year\" title=\"Year\">
  <option value=\"$Year\" selected=\"selected\">$Year</option>
</select>
<select disabled=\"disabled\" id=\"Hour\" name=\"Hour\" title=\"Hours\">
  <option value=\"$HourID\" selected=\"selected\">$Hour</option>
</select>
<select disabled=\"disabled\" id=\"Minute\" name=\"Minute\" title=\"Minutes\">
  <option value=\"$MinuteID\" selected=\"selected\">$Min</option>
</select>",
    },
    {
        Name   => 'Disabled Optional',
        Config => {
            Prefix       => 'Test',
            TestOptional => 1,
            Disabled     => 1,
        },
        ExpectedValue =>
            "<input type=\"checkbox\" name=\"TestUsed\" id=\"TestUsed\" value=\"1\" class=\"\" title=\"Check to activate this date\" disabled=\"disabled\"/>
<select disabled=\"disabled\" id=\"TestMonth\" name=\"TestMonth\" title=\"Month\">
  <option value=\"$MonthID\" selected=\"selected\">$Month</option>
</select>
<select class=\" \" disabled=\"disabled\" id=\"TestDay\" name=\"TestDay\" title=\"Day\">
  <option value=\"$DayID\" selected=\"selected\">$Day</option>
</select>
<select disabled=\"disabled\" id=\"TestYear\" name=\"TestYear\" title=\"Year\">
  <option value=\"$Year\" selected=\"selected\">$Year</option>
</select>",
    },

    {
        Name   => 'Disabled (Input)',
        Config => {
            Disabled => 1,
        },
        SetConfig => {
            Key     => 'TimeInputFormat',
            Value   => 'Input',
            Message => 'Set TimeInputFormat to Input',
        },
        ExpectedValue =>
            "<input type=\"text\" class=\"\" name=\"Month\" id=\"Month\" size=\"2\" maxlength=\"2\" title=\"Month\" value=\"$Month\" readonly=\"readonly\"/>
<input type=\"text\" class=\" \" name=\"Day\" id=\"Day\" size=\"2\" maxlength=\"2\" title=\"Day\" value=\"$Day\" readonly=\"readonly\"/>
<input type=\"text\" class=\"\" name=\"Year\" id=\"Year\" size=\"4\" maxlength=\"4\" title=\"Year\" value=\"$Year\" readonly=\"readonly\"/>",
    },
    {
        Name   => 'Disabled Long Format (Input)',
        Config => {
            Format   => 'DateInputFormatLong',
            Disabled => 1,
        },
        ExpectedValue =>
            "<input type=\"text\" class=\"\" name=\"Month\" id=\"Month\" size=\"2\" maxlength=\"2\" title=\"Month\" value=\"$Month\" readonly=\"readonly\"/>
<input type=\"text\" class=\" \" name=\"Day\" id=\"Day\" size=\"2\" maxlength=\"2\" title=\"Day\" value=\"$Day\" readonly=\"readonly\"/>
<input type=\"text\" class=\"\" name=\"Year\" id=\"Year\" size=\"4\" maxlength=\"4\" title=\"Year\" value=\"$Year\" readonly=\"readonly\"/>
<input type=\"text\" class=\"\" name=\"Hour\" id=\"Hour\" size=\"2\" maxlength=\"2\" title=\"Hours\" value=\"$Hour\" readonly=\"readonly\"/>
<input type=\"text\" class=\"\" name=\"Minute\" id=\"Minute\" size=\"2\" maxlength=\"2\" title=\"Minutes\" value=\"$Min\" readonly=\"readonly\"/>",
    },
    {
        Name   => 'Disabled Optional (Input)',
        Config => {
            Prefix       => 'Test',
            TestOptional => 1,
            Disabled     => 1,
        },
        ExpectedValue =>
            "<input type=\"checkbox\" name=\"TestUsed\" id=\"TestUsed\" value=\"1\" class=\"\" title=\"Check to activate this date\" disabled=\"disabled\"/>
<input type=\"text\" class=\"\" name=\"TestMonth\" id=\"TestMonth\" size=\"2\" maxlength=\"2\" title=\"Month\" value=\"$Month\" readonly=\"readonly\"/>
<input type=\"text\" class=\" \" name=\"TestDay\" id=\"TestDay\" size=\"2\" maxlength=\"2\" title=\"Day\" value=\"$Day\" readonly=\"readonly\"/>
<input type=\"text\" class=\"\" name=\"TestYear\" id=\"TestYear\" size=\"4\" maxlength=\"4\" title=\"Year\" value=\"$Year\" readonly=\"readonly\"/>",
    },
);

# get Layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

TESTCASE:
for my $Test (@Tests) {

    if ( $Test->{SetConfig} ) {
        $SetConfig->( %{ $Test->{SetConfig} } );
    }

    my $HTML = $LayoutObject->BuildDateSelection( %{ $Test->{Config} } );

    # remove non selected options for easy compare
    $HTML =~ s{\s+<option\s+value="\d+">\d+</option>}{}msxg;

    # remove /, : and - and convert them into new lines
    $HTML =~ s{</select>(?: / | : | \s-\s)<select}{</select>\n<select}msxg;
    $HTML =~ s{/>(?: / | : | \s-\s)<input}{/>\n<input}msxg;

    # remove checkbox space and convert it to new line
    $HTML =~ s{/>&nbsp;<}{/>\n<}msxg;

    $Self->Is(
        $HTML,
        $Test->{ExpectedValue},
        "$Test->{Name} BuildDateSelection() - result",
    );
}

1;
