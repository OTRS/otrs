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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Description => 'Commented XML, options ForceArray, ForceContent and Content',
        Config      => {
            XMLInput => '
                <MyXML>
                    <!-- <Item Type="String">My content</Item> -->
                </MyXML>
            ',
            Options => {
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        },
        ExpectedResult => {
            Content => "\n                     <Item Type=\"String\">My content</Item> \n                ",
        },
    },
    {
        Description => 'Valid XML from string, options ForceArray, ForceContent and Content',
        Config      => {
            XMLInput => '
                <MyXML>
                    <Item Type="String">My content</Item>
                    <Item Type="Number">23</Item>
                    <Item Key="Transaction">0</Item>
                </MyXML>
            ',
            Options => {
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        },
        ExpectedResult => {
            Item => [
                {
                    Type    => 'String',
                    Content => 'My content',
                },
                {
                    Type    => 'Number',
                    Content => '23',
                },
                {
                    Key     => 'Transaction',
                    Content => '0',
                },
            ],
        },
    },
    {
        Description => 'Valid XML from file, options ForceArray, ForceContent and Content',
        Config      => {
            XMLInput => $ConfigObject->Get('Home') . '/scripts/test/sample/XML/XMLSimple-Test-file.xml',
            Options  => {
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        },
        ExpectedResult => {
            Item => [
                {
                    Type    => 'String',
                    Content => 'My content',
                },
                {
                    Type    => 'Number',
                    Content => '23',
                },
            ],
        },
    },
    {
        Description => 'Invalid XML from string, options ForceArray, ForceContent and Content',
        Config      => {
            XMLInput => '
                <MyXML1>
                    <Item Type="String">My content</Item>
                    <Item Type="Number">23</Item>
                </MyXML2>
            ',
            Options => {
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Non-existing XML file, options ForceArray, ForceContent and Content',
        Config      => {
            XMLInput => $ConfigObject->Get('Home') . '/scripts/test/sample/XML/XMLSimple-Test-file-non-existing.xml',
            Options  => {
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Valid XML from string, invalid option NonExistingOption',
        Config      => {
            XMLInput => '
                <MyXML>
                    <Item Type="String">My content</Item>
                    <Item Type="Number">23</Item>
                </MyXML>
            ',
            Options => {
                NonExistingOption => 1,
            },
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Valid XML from string, no options',
        Config      => {
            XMLInput => '
                <MyXML>
                    <Item Type="String">My content</Item>
                    <Item Type="Number">23</Item>
                </MyXML>
            ',
        },
        ExpectedResult => {
            Item => [
                {
                    Type    => 'String',
                    content => 'My content',
                },
                {
                    Type    => 'Number',
                    content => '23',
                },
            ],
        },
    },
    {
        Description => 'Valid XML from string, comply XML, ForceArray enabled, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                ForceArray => 1,
            },
        },
        ExpectedResult => {
            'Description' => [
                {
                    'Translatable' => '1',
                    'content'      => "Test ščćžç∂ßâ¢."
                },
            ],
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => 'Frontend::Agent::ModuleRegistration',
            'Required'   => '0',
            'Valid'      => '1',
            'Value'      => [
                {
                    'Hash' => [
                        {
                            'Item' => [
                                {
                                    'Key'          => 'Description',
                                    'Translatable' => '1',
                                    'content'      => 'Overview of all open Tickets.'
                                },
                                {
                                    'Array' => [
                                        {
                                            'Item' => [
                                                {
                                                    'Hash' => [
                                                        {
                                                            'Item' => [
                                                                {
                                                                    'Key'          => 'Description',
                                                                    'Translatable' => '1',
                                                                    'content'      => 'Overview of all open Tickets.'
                                                                },
                                                                {
                                                                    'Key'     => 'NavBar',
                                                                    'content' => 'Ticket'
                                                                }
                                                            ]
                                                        }
                                                    ],
                                                },
                                            ]
                                        },
                                    ],
                                    'Key' => 'NavBar',
                                },
                            ],
                        },
                    ],
                },
            ],
        },
    },
    {
        Description => 'Valid XML from string, comply XML, ForceArray specific ("Item") enabled, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                ForceArray => ["Item"],
            },
        },
        ExpectedResult => {
            'Description' => {
                'Translatable' => '1',
                'content'      => "Test ščćžç∂ßâ¢."
            },
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => 'Frontend::Agent::ModuleRegistration',
            'Required'   => '0',
            'Valid'      => '1',
            'Value'      => {
                'Hash' => {
                    'Item' => [
                        {
                            'Key'          => 'Description',
                            'Translatable' => '1',
                            'content'      => 'Overview of all open Tickets.'
                        },
                        {
                            'Array' => {
                                'Item' => [
                                    {
                                        'Hash' => {
                                            'Item' => [
                                                {
                                                    'Key'          => 'Description',
                                                    'Translatable' => '1',
                                                    'content'      => 'Overview of all open Tickets.'
                                                },
                                                {
                                                    'Key'     => 'NavBar',
                                                    'content' => 'Ticket'
                                                }
                                            ]
                                        }
                                    },
                                ]
                            },
                            'Key' => 'NavBar',
                        },
                    ],
                },
            },
        },
    },
    {
        Description => 'Valid XML from string, comply XML, ForceContent enabled, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                ForceContent => 1,
            },
        },
        ExpectedResult => {
            'Description' => {
                'Translatable' => '1',
                'content'      => "Test ščćžç∂ßâ¢."
            },
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => {
                content => 'Frontend::Agent::ModuleRegistration',
            },
            'Required' => '0',
            'Valid'    => '1',
            'Value'    => {
                'Hash' => {
                    'Item' => [
                        {
                            'Key'          => 'Description',
                            'Translatable' => '1',
                            'content'      => 'Overview of all open Tickets.'
                        },
                        {
                            'Array' => {
                                'Item' => {
                                    'Hash' => {
                                        'Item' => [
                                            {
                                                'Key'          => 'Description',
                                                'Translatable' => '1',
                                                'content'      => 'Overview of all open Tickets.'
                                            },
                                            {
                                                'Key'     => 'NavBar',
                                                'content' => 'Ticket'
                                            }
                                        ]
                                    }
                                },
                            },
                            'Key' => 'NavBar',
                        },
                    ],
                },
            },
        },
    },
    {
        Description => 'Valid XML from string, comply XML, KeepRoot enabled, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                KeepRoot => 1,
            },
        },
        ExpectedResult => {
            'ConfigItem' => {
                'Description' => {
                    'Translatable' => '1',
                    'content'      => "Test ščćžç∂ßâ¢."
                },
                'Name'       => 'Frontend::Module###Dummy',
                'Navigation' => 'Frontend::Agent::ModuleRegistration',
                'Required'   => '0',
                'Valid'      => '1',
                'Value'      => {
                    'Hash' => {
                        'Item' => [
                            {
                                'Key'          => 'Description',
                                'Translatable' => '1',
                                'content'      => 'Overview of all open Tickets.'
                            },
                            {
                                'Array' => {
                                    'Item' => {
                                        'Hash' => {
                                            'Item' => [
                                                {
                                                    'Key'          => 'Description',
                                                    'Translatable' => '1',
                                                    'content'      => 'Overview of all open Tickets.'
                                                },
                                                {
                                                    'Key'     => 'NavBar',
                                                    'content' => 'Ticket'
                                                }
                                            ]
                                        }
                                    },
                                },
                                'Key' => 'NavBar',
                            },
                        ],
                    },
                },
            },
        },
    },
    {
        Description => 'Valid XML from string, comply XML, ContentKey, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                ContentKey => 'Valueß',
            },
        },
        ExpectedResult => {
            'Description' => {
                'Translatable' => '1',
                'Valueß'      => "Test ščćžç∂ßâ¢."
            },
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => 'Frontend::Agent::ModuleRegistration',
            'Required'   => '0',
            'Valid'      => '1',
            'Value'      => {
                'Hash' => {
                    'Item' => [
                        {
                            'Key'          => 'Description',
                            'Translatable' => '1',
                            'Valueß'      => 'Overview of all open Tickets.'
                        },
                        {
                            'Array' => {
                                'Item' => {
                                    'Hash' => {
                                        'Item' => [
                                            {
                                                'Key'          => 'Description',
                                                'Translatable' => '1',
                                                'Valueß'      => 'Overview of all open Tickets.'
                                            },
                                            {
                                                'Key'     => 'NavBar',
                                                'Valueß' => 'Ticket'
                                            }
                                        ]
                                    }
                                },
                            },
                            'Key' => 'NavBar',
                        },
                    ],
                },
            },
        },
    },
    {
        Description => 'Valid XML from string, comply XML, GroupTags, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                GroupTags => { Hash => 'Item' },
            },
        },
        ExpectedResult => {
            'Description' => {
                'Translatable' => '1',
                'content'      => "Test ščćžç∂ßâ¢."
            },
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => 'Frontend::Agent::ModuleRegistration',
            'Required'   => '0',
            'Valid'      => '1',
            'Value'      => {
                'Hash' => [
                    {
                        'Key'          => 'Description',
                        'Translatable' => '1',
                        'content'      => 'Overview of all open Tickets.'
                    },
                    {
                        'Array' => {
                            'Item' => {
                                'Hash' => [
                                    {
                                        'Key'          => 'Description',
                                        'Translatable' => '1',
                                        'content'      => 'Overview of all open Tickets.'
                                    },
                                    {
                                        'Key'     => 'NavBar',
                                        'content' => 'Ticket'
                                    }
                                ]
                            },
                        },
                        'Key' => 'NavBar',
                    },
                ],
            },
        },
    },
    {
        Description => 'Valid XML from string, comply XML, KeyAttr, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1">Test ščćžç∂ßâ¢.</Description>
                    <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                            <Item Key="NavBar">Ticket</Item>
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                KeyAttr => 'Key',
            },
        },
        ExpectedResult => {
            'Description' => {
                'Translatable' => '1',
                'content'      => "Test ščćžç∂ßâ¢."
            },
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => 'Frontend::Agent::ModuleRegistration',
            'Required'   => '0',
            'Valid'      => '1',
            'Value'      => {
                'Hash' => {
                    'Item' => {
                        'Description' => {
                            'Translatable' => '1',
                            'content'      => 'Overview of all open Tickets.'
                        },
                        'NavBar' => {
                            'Array' => {
                                'Item' => {
                                    'Hash' => {
                                        'Item' => {
                                            'Description' => {
                                                'Translatable' => '1',
                                                'content'      => 'Overview of all open Tickets.'
                                            },
                                            'NavBar' => {
                                                'content' => 'Ticket'
                                            },
                                        }
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    },
    {
        Description => 'Valid XML from string, comply XML, ValueAttr, Unicode',
        Config      => {
            XMLInput => '
                <ConfigItem Name="Frontend::Module###Dummy" Required="0" Valid="1">
                    <Description Translatable="1" ValueContent="Test ščćžç∂ßâ¢." />
                    <Navigation ValueContent="Frontend::Agent::ModuleRegistration" />
                    <Value>
                        <Hash>
                            <Item Key="Description" Translatable="1" ValueContent="Overview of all open Tickets." />
                            <Item Key="NavBar">
                                <Array>
                                    <Item>
                                        <Hash>
                                            <Item Key="Description" Translatable="1" ValueContent="Overview of all open Tickets." />
                                            <Item Key="NavBar" ValueContent="Ticket" />
                                        </Hash>
                                    </Item>
                                </Array>
                            </Item>
                        </Hash>
                    </Value>
                </ConfigItem>
            ',
            Options => {
                ValueAttr => ["ValueContent"],
            },
        },
        ExpectedResult => {
            'Description' => {
                'Translatable' => '1',
                'ValueContent' => "Test ščćžç∂ßâ¢."    # There are more than 1 attributes
            },
            'Name'       => 'Frontend::Module###Dummy',
            'Navigation' => 'Frontend::Agent::ModuleRegistration',    # There is only 1 attribute
            'Required'   => '0',
            'Valid'      => '1',
            'Value'      => {
                'Hash' => {
                    'Item' => [
                        {
                            'Key'          => 'Description',
                            'Translatable' => '1',
                            'ValueContent' => 'Overview of all open Tickets.'    # There are more than 1 attributes
                        },
                        {
                            'Array' => {
                                'Item' => {
                                    'Hash' => {
                                        'Item' => [
                                            {
                                                'Key'          => 'Description',
                                                'Translatable' => '1',
                                                'ValueContent' =>
                                                    'Overview of all open Tickets.'   # There are more than 1 attributes
                                            },
                                            {
                                                'Key'          => 'NavBar',
                                                'ValueContent' => 'Ticket'            # There are more than 1 attributes
                                            }
                                        ]
                                    }
                                },
                            },
                            'Key' => 'NavBar',
                        },
                    ],
                },
            },
        },
    },
);

my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

$Self->True(
    $XMLSimpleObject,
    'Creation of Kernel::System::XML::Simple object must succeed.',
);

for my $Test (@Tests) {
    my $Result = $XMLSimpleObject->XMLIn( %{ $Test->{Config} } );
    if ( defined $Result && ref $Result ) {
        $Self->IsDeeply(
            $Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': Resulting Perl structure must match expected one.',
        );
    }
    else {
        $Self->Is(
            $Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': Result must match expected one.',
        );
    }
}

1;
