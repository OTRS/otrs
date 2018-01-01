# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        # RestoreDatabase => 1,
    },
);
my $HelperObject        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigHTMLObject = $Kernel::OM->Get('Kernel::Output::HTML::SysConfig');
my $SysConfigObject     = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');

# Basic tests
my @Tests = (
    {
        Name  => 'TestCheckbox1',
        Value => [
            {
                'Item' => [
                    {
                        'Content'   => '0',
                        'ValueType' => 'Checkbox',
                    },
                ],
            },
        ],
        ExpectedResult => '                        <div class="Setting" data-change-time="">
                            <div class=\'SettingContent\'>
<input class="" type="checkbox" id="Checkbox_TestCheckbox1" value="1" checked=\'checked\' disabled=\'disabled\' ><input type=\'hidden\' name=\'TestCheckbox1\' id="TestCheckbox1" value=\'1\' />
<label for=\'Checkbox_TestCheckbox1\' class=\'CheckboxLabel\'>Enabled</label>
</div>
                                <div class="WidgetMessage Bottom">
                                    Default: Disabled
                                </div>

                        </div>
',
    },

    # {
    #     Name  => 'TestArrayCheckbox',
    #     Value => [
    #         {
    #             'Array' => [
    #                 {
    #                     'DefaultItem' => [
    #                         {
    #                             'Content'   => '1',
    #                             'ValueType' => 'Checkbox',
    #                         },
    #                     ],
    #                     'Item' => [
    #                         {
    #                             'ValueType' => 'Checkbox',
    #                             'Content'   => '0',
    #                         },
    #                         {
    #                             'Content'   => '0',
    #                             'ValueType' => 'Checkbox',
    #                         },
    #                     ],
    #                 },
    #             ],
    #         },
    #     ],
    #     ExpectedResult => '',
    # },
);

for my $Test (@Tests) {

    my $HTMLStr = $SysConfigHTMLObject->SettingRender(
        Setting => {
            Name             => $Test->{Name},
            XMLContentParsed => {
                Value => $Test->{Value},
            },
            EffectiveValue => 1,
            DefaultValue   => 0,
        },
        UserID => 1,
    );

    $Self->Is(
        $HTMLStr,
        $Test->{ExpectedResult},
        'SettingRender() is same',
    );

}

1;
