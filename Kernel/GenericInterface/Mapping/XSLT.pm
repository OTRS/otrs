# --
# Kernel/GenericInterface/Mapping/XSLT.pm - GenericInterface XSLT data mapping backend
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Mapping::XSLT;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Mapping::XSLT - GenericInterface XSLT data mapping backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Mapping->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MappingConfig)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    # check mapping config
    if ( !IsHashRefWithData( $Param{MappingConfig} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no MappingConfig as hash ref with content!',
        );
    }

    # check config - if we have a map config, it has to be a non-empty hash ref
    if (
        defined $Param{MappingConfig}->{Config}
        && !IsHashRefWithData( $Param{MappingConfig}->{Config} )
        )
    {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got MappingConfig with Data, but Data is no hash ref with content!',
        );
    }

    return $Self;
}

=item Map()

provides mapping based on XSLT stylesheets

    my $ReturnData = $MappingObject->Map(
        Data => {
            'original_key' => 'original_value',
            'another_key'  => 'next_value',
        },
    );

    my $ReturnData = {
        'changed_key'          => 'changed_value',
        'original_key'         => 'another_changed_value',
        'another_original_key' => 'default_value',
        'default_key'          => 'changed_value',
    };

=cut

sub Map {
    my ( $Self, %Param ) = @_;

    # check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash ref in Mapping XSLT backend!'
        );
    }

    # return if data is empty
    if ( !defined $Param{Data} || !%{ $Param{Data} } ) {
        return {
            Success => 1,
            Data    => {},
        };
    }

    # prepare short config variable
    my $Config = $Self->{MappingConfig}->{Config};

    # no config means we just return input data
    if ( !$Config || !$Config->{Template} ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # load required libraries (XML::Simple, XML::LibXML and XML::LibXSLT)
    LIBREQUIRED:
    for my $LibRequired (qw(XML::Simple XML::LibXML XML::LibXSLT)) {
        my $LibFound = $Kernel::OM->Get('Kernel::System::Main')->Require($LibRequired);
        next LIBREQUIRED if $LibFound;

        return $Self->{DebuggerObject}->Error(
            Summary => "Could not find required library $LibRequired",
        );
    }

    # prepare stylesheet
    my $LibXML  = XML::LibXML->new();
    my $LibXSLT = XML::LibXSLT->new();
    my ( $StyleDoc, $StyleSheet );
    eval {
        $StyleDoc = $LibXML->load_xml(
            string   => $Config->{Template},
            no_cdata => 1,
        );
    };
    if ( !$StyleDoc ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not load configured XSLT template: '$Config->{Template}'",
        );
    }
    eval {
        $StyleSheet = $LibXSLT->parse_stylesheet($StyleDoc);
    };
    if ( !$StyleSheet ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not parse configured XSLT template: '$@'",
        );
    }

    # convert data to xml structure
    my $XMLSimple = XML::Simple->new();
    my $XMLPre;
    eval {
        $XMLPre = $XMLSimple->XMLout(
            $Param{Data},
            AttrIndent => 1,
            ContentKey => '-content',
            NoAttr     => 1,
            KeyAttr    => [],
            RootName   => 'RootElement',
        );
    };
    if ( !$XMLPre ) {
        return $Self->{DebuggerObject}->Error(
            Summary =>
                "Could not convert data from Perl to XML before mapping: '$@'",
        );
    }

    # transform xml data
    my ( $XMLSource, $Result );
    eval {
        $XMLSource = $LibXML->load_xml(
            string   => $XMLPre,
            no_cdata => 1,
        );
    };
    if ( !$XMLSource ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not load data after conversion from Perl to XML: '$XMLPre'",
        );
    }
    eval {
        $Result = $StyleSheet->transform($XMLSource);
    };
    if ( !$Result ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not map data: '$@'",
        );
    }
    my $XMLPost = $StyleSheet->output_as_bytes($Result);
    if ( !$XMLPost ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not write mapped data",
        );
    }

    # convert data back to perl structure
    my $ReturnData;
    eval {
        $ReturnData = $XMLSimple->XMLin(
            $XMLPost,
            ForceArray => 0,
            ContentKey => '-content',
            NoAttr     => 1,
            KeyAttr    => [],
        );
    };
    if ( !$ReturnData ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not convert data from XML to Perl after mapping: '$@' / '$XMLPost'",
        );
    }

    return {
        Success => 1,
        Data    => $ReturnData,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
