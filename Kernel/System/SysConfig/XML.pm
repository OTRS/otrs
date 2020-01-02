# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::XML;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::XML::Simple',
);

use Kernel::System::VariableCheck qw( :all );

=head1 NAME

Kernel::System::SysConfig::XML - Manage system configuration settings in XML.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 SettingListParse()

Parses XML files into a list of perl structures and meta data.

    my $PerlStructure = $SysConfigXMLObject->SettingListParse(
        XMLInput => '
            <?xml version="1.0" encoding="utf-8"?>
            <otrs_config version="2.0" init="Application">
                <Setting Name="Test1" Required="1" Valid="1">
                    <Description Translatable="1">Test 1.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">123</Item>
                    </Value>
                </Setting>
                <Setting Name="Test2" Required="1" Valid="1">
                    <Description Translatable="1">Test 2.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="File">/usr/bin/gpg</Item>
                    </Value>
                </Setting>
            </otrs_config>
        ',
        XMLFilename => 'Test.xml'
    );

Returns:

    [
        {
            XMLContentParsed => {
                Description => [
                    {
                        Content      => 'Test.',
                        Translatable => '1',
                    },
                ],
                Name  => 'Test',
                Required => '1',
                Value => [
                    {
                        Item => [
                            {
                                ValueRegex => '.*',
                                ValueType  => 'String',
                                Content    => '123',
                            },
                        ],
                    },
                ],
                Navigation => [
                    {
                        Content => 'Core::Ticket',
                    },
                ],
                Valid => '1',
            },
            XMLContentRaw => '<Setting Name="Test1" Required="1" Valid="1">
                <Description Translatable="1">Test 1.</Description>
                <Navigation>Core::Ticket</Navigation>
                <Value>
                    <Item ValueType="String" ValueRegex=".*">123</Item>
                </Value>
            </Setting>',
            XMLFilename => 'Test.xml'
        },
    ]

=cut

sub SettingListParse {
    my ( $Type, %Param ) = @_;

    if ( !IsStringWithData( $Param{XMLInput} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter XMLInput needs to be a string!",
        );
        return;
    }

    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');

    my $XMLContent = $Param{XMLInput};

    # Remove all lines that starts with comment (#).
    $XMLContent =~ s{^#.*?$}{}gm;

    # Remove comments <!-- ... -->.
    $XMLContent =~ s{<!--.*?-->}{}gsm;

    $XMLContent =~ m{otrs_config.*?version="(.*?)"};
    my $ConfigVersion = $1;

    if ( $ConfigVersion ne '2.0' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid XML format found in $Param{XMLFilename} (version must be 2.0)! File skipped.",
        );
        return;
    }

    while ( $XMLContent =~ m{<ConfigItem.*?Name="(.*?)"}smxg ) {

        # Old style ConfigItem detected.
        my $SettingName = $1;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Old ConfigItem $SettingName detected in $Param{XMLFilename}!"
        );
    }

    # Fetch XML of Setting elements.
    my @ParsedSettings;

    SETTING:
    while (
        $XMLContent =~ m{(?<RawSetting> <Setting[ ]+ .*? Name="(?<SettingName> .*? )" .*? > .*? </Setting> )}smxg
        )
    {

        my $RawSetting  = $+{RawSetting};
        my $SettingName = $+{SettingName};

        next SETTING if !IsStringWithData($RawSetting);
        next SETTING if !IsStringWithData($SettingName);

        my $PerlStructure = $XMLSimpleObject->XMLIn(
            XMLInput => $RawSetting,
            Options  => {
                KeepRoot     => 1,
                ForceArray   => 1,
                ForceContent => 1,
                ContentKey   => 'Content',
            },
        );

        if ( !IsHashRefWithData($PerlStructure) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Resulting Perl structure must be a hash reference with data!",
            );
            next SETTING;
        }

        if ( !IsArrayRefWithData( $PerlStructure->{Setting} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Resulting Perl structure must have Setting elements!",
            );
            next SETTING;
        }

        push @ParsedSettings, {
            XMLContentParsed => $PerlStructure->{Setting}->[0],
            XMLContentRaw    => $RawSetting,
            XMLFilename      => $Param{XMLFilename},
        };
    }

    return @ParsedSettings;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
