# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
                Item => [
                    {
                        Content   => '0',
                        ValueType => 'Checkbox',
                    },
                ],
            },
        ],
        EffectiveValue => 1,
        ExpectedResult => '<div class="Setting" data-change-time=""><div class=\'SettingContent\'>
<input class="" type="checkbox" id="Checkbox_TestCheckbox1" value="1" checked=\'checked\' disabled=\'disabled\' ><input type=\'hidden\' name=\'TestCheckbox1\' id="TestCheckbox1" value=\'1\' />
<label for=\'Checkbox_TestCheckbox1\' class=\'CheckboxLabel\'>Enabled</label>
</div><div class="WidgetMessage Bottom">Default: Disabled</div></div>
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

    # Internal Server error if you remove some modules.
    # See bug#13952.
    {
        Name  => 'TestFrontendRegistration1',
        Value => [
            {
                Item => [
                    {
                        Hash => [
                            {
                                Item => [
                                    {
                                        Array => [
                                            {
                                                Content => ''
                                            }
                                        ],
                                        Key => 'GroupRo'
                                    },
                                ],
                            },
                        ],
                        ValueType => 'FrontendRegistration',
                    },

                ],
            },
        ],

        EffectiveValue => {
            GroupRo     => [],
            Description => 'Admin',
            Group       => [
                'admin'
            ],
            Title      => 'System Registration',
            NavBarName => 'Admin'
        },
        ExpectedResult => "<div class=\"Setting\" data-change-time=\"\"><div class='Hash'>
<div class='HashItem'>
<input type='text' value='Description' readonly='readonly' class='Key' />
<div class='SettingContent'>
<input type='text' value='Admin' id='TestFrontendRegistration1_Hash###Description' readonly='readonly' />
</div>
</div>
<div class='HashItem'>
<input type='text' value='Group' readonly='readonly' class='Key' />
<div class='SettingContent'>
<div class='Array'>
<div class='ArrayItem'>
<div class='SettingContent'>
<input type='text' value='admin' id='TestFrontendRegistration1_Hash###Group_Array1' readonly='readonly' />
</div>
</div><button data-suffix='TestFrontendRegistration1_Hash###Group_Array2' class='AddArrayItem Hidden' type='button' title='Add new entry' value='Add new entry'><i class='fa fa-plus-circle'></i><span class='InvisibleText'>Add new entry</span></button>
</div>
</div>
</div>
<div class='HashItem'>
<input type='text' value='GroupRo' readonly='readonly' class='Key' />
<div class='SettingContent'>
<div class='Array'><button data-suffix='TestFrontendRegistration1_Hash###GroupRo_Array1' class='AddArrayItem Hidden' type='button' title='Add new entry' value='Add new entry'><i class='fa fa-plus-circle'></i><span class='InvisibleText'>Add new entry</span></button>
</div>
</div>
</div>
<div class='HashItem'>
<input type='text' value='NavBarName' readonly='readonly' class='Key' />
<div class='SettingContent'>
<input type='text' value='Admin' id='TestFrontendRegistration1_Hash###NavBarName' readonly='readonly' />
</div>
</div>
<div class='HashItem'>
<input type='text' value='Title' readonly='readonly' class='Key' />
<div class='SettingContent'>
<input type='text' value='System Registration' id='TestFrontendRegistration1_Hash###Title' readonly='readonly' />
</div>
</div>
</div></div>
",
    },
    {
        Name  => 'TestFrontendRegistration2',
        Value => [
            {
                Item => [
                    {
                        Hash => [
                            {
                                Item => [
                                    {
                                        Array => [
                                            {
                                                Content => ''
                                            }
                                        ],
                                        Key => 'GroupRo'
                                    },
                                ],
                            },
                        ],
                        ValueType => 'FrontendRegistration',
                    },

                ],
            },
        ],

        EffectiveValue => '',
        ExpectedResult => '<div class="Setting" data-change-time=""></div>
'

    },

);

for my $Test (@Tests) {

    my $HTMLStr = $SysConfigHTMLObject->SettingRender(
        Setting => {
            Name             => $Test->{Name},
            XMLContentParsed => {
                Value => $Test->{Value},
            },
            EffectiveValue => $Test->{EffectiveValue},
            DefaultValue   => 0,
        },
        UserID => 1,
    );
    $HTMLStr =~ s{\s{2,}}{}xmsg;
    $Self->Is(
        $HTMLStr,
        $Test->{ExpectedResult},
        'SettingRender() is same',
    );

}

1;
