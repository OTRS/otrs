# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

=head2 SettingParse()

Parses XML Setting into Perl structure.

    my $PerlStructure = $SysConfigXMLObject->SettingParse(
        SettingXML => '
            <Setting Name="Test" Required="1" Valid="1">
                <Description Translatable="1">Test.</Description>
                <Navigation>Core::Ticket</Navigation>
                <Value>
                    <Item ValueType="String" ValueRegex=".*">123</Item>
                </Value>
            </Setting>
        ',
    );

Returns:

    my $PerlStructure = {
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
    };

=cut

sub SettingParse {
    my ( $Type, %Param ) = @_;

    if ( !defined $Param{SettingXML} || !length $Param{SettingXML} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need parameter SettingXML!",
        );
        return;
    }

    if ( !IsString( $Param{SettingXML} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter SettingXML needs to be a string!",
        );
        return;
    }

    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');
    my $PerlStructure   = $XMLSimpleObject->XMLIn(
        XMLInput => $Param{SettingXML},
        Options  => {
            KeepRoot     => 1,
            ForceArray   => 1,
            ForceContent => 1,
            ContentKey   => 'Content',
        },
    );

    if (
        !IsHashRefWithData($PerlStructure)
        || keys %{$PerlStructure} != 1
        || !exists $PerlStructure->{Setting}
        || !IsArrayRefWithData( $PerlStructure->{Setting} )
        || @{ $PerlStructure->{Setting} } != 1
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid SettingXML: must contain exactly one Setting element!",
        );
        return;
    }

    $PerlStructure = shift @{ $PerlStructure->{Setting} };

    return $PerlStructure;
}

=head2 SettingListGet()

Fetches Setting list from XML.

    my $SettingList = $SysConfigXMLObject->SettingListGet(
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
    );

Returns:

    my $SettingList = {
        Test1 => '<Setting...>...</Setting>',
        Test2 => '<Setting...>...</Setting>',
    };

=cut

sub SettingListGet {
    my ( $Type, %Param ) = @_;

    if ( !defined $Param{XMLInput} || !length $Param{XMLInput} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need parameter XMLInput!",
        );
        return;
    }

    if ( !IsString( $Param{XMLInput} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Parameter XMLInput needs to be a string!",
        );
        return;
    }

    # Check if XML is valid.
    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');
    my $PerlStructure   = $XMLSimpleObject->XMLIn(
        XMLInput => $Param{XMLInput},
        Options  => {
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
        return;
    }

    if ( !IsArrayRefWithData( $PerlStructure->{Setting} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Resulting Perl structure must have Setting elements!",
        );
        return;
    }

    my %SettingNamesLookup;

    # Check that all Setting elements have a Name attribute.
    SETTING:
    for my $Setting ( @{ $PerlStructure->{Setting} } ) {
        if ( defined $Setting->{Name} && length $Setting->{Name} ) {

            # Remember the setting name (commented settings should not be returned later)
            $SettingNamesLookup{ $Setting->{Name} } = 1;
            next SETTING;
        }

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "At least one Setting element has no Name attribute!",
        );
        return;
    }

    # Fetch XML of Setting elements.
    my %List;
    SETTING:
    while ( $Param{XMLInput} =~ m{(<Setting\s.*?Name="(.*?)".*?>.*?</Setting>)}smg ) {
        next SETTING if !$SettingNamesLookup{$2};
        $List{$2} = $1;
    }

    return \%List;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
