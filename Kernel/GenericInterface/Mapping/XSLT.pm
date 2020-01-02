# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Mapping::XSLT;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Storable;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Mapping::XSLT - GenericInterface C<XSLT> data mapping backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Mapping->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Check needed params.
    for my $Needed (qw(DebuggerObject MappingConfig)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    # Check mapping config.
    if ( !IsHashRefWithData( $Param{MappingConfig} ) ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no MappingConfig as hash ref with content!',
        );
    }

    # Check config - if we have a map config, it has to be a non-empty hash ref.
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

=head2 Map()

Provides mapping based on C<XSLT> style sheets.
Additional data is provided by the function results from various stages in requester and provider.
This data can be included in the C<XSLT> mapping as 'DataInclude' structure via configuration.

    my $ReturnData = $MappingObject->Map(
        Data => {
            'original_key' => 'original_value',
            'another_key'  => 'next_value',
        },
        DataInclude => {
            RequesterRequestInput => { ... },
            RequesterRequestPrepareOutput => { ... },
            RequesterRequestMapOutput => { ... },
            RequesterResponseInput => { ... },
            RequesterResponseMapOutput => { ... },
            RequesterErrorHandlingOutput => { ... },
            ProviderRequestInput => { ... },
            ProviderRequestMapOutput => { ... },
            ProviderResponseInput => { ... },
            ProviderResponseMapOutput => { ... },
            ProviderErrorHandlingOutput => { ... },
        },
    }
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

    # Check data - only accept undef or hash ref or array ref.
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' && ref $Param{Data} ne 'ARRAY' ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash or array ref in Mapping XSLT backend!'
        );
    }

    # Check included data - only accept undef or hash ref.
    if ( defined $Param{DataInclude} && !IsHashRefWithData( $Param{DataInclude} ) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got DataInclude but it is not a hash ref in Mapping XSLT backend!'
        );
    }

    # Return if data is empty.
    if ( !defined $Param{Data} || !%{ $Param{Data} } ) {
        return {
            Success => 1,
            Data    => {},
        };
    }

    # Prepare short config variable.
    my $Config = $Self->{MappingConfig}->{Config};

    # No config means we just return input data.
    if ( !$Config || !$Config->{Template} ) {
        return {
            Success => 1,
            Data    => $Param{Data},
        };
    }

    # Load required libraries (XML::LibXML and XML::LibXSLT).
    LIBREQUIRED:
    for my $LibRequired (qw(XML::LibXML XML::LibXSLT)) {
        my $LibFound = $Kernel::OM->Get('Kernel::System::Main')->Require($LibRequired);
        next LIBREQUIRED if $LibFound;

        return $Self->{DebuggerObject}->Error(
            Summary => "Could not find required library $LibRequired",
        );
    }

    # Prepare style sheet.
    my $LibXSLT = XML::LibXSLT->new();

    # Remove template line breaks and white spaces to plain text lines on the fly, see bug# 14106.
    my $Template =
        $Config->{Template}
        =~ s{ > [ \t\n]+ (?= [^< \t\n] ) }{>}xmsgr
        =~ s{ (?<! [> \t\n] ) [ \t\n]+ < }{<}xmsgr;

    my ( $StyleDoc, $StyleSheet );
    eval {
        $StyleDoc = XML::LibXML->load_xml(
            string   => $Template,
            no_cdata => 1,
        );
    };
    if ( !$StyleDoc ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not load configured XSLT template',
            Data    => $Template,
        );
    }
    eval {
        $StyleSheet = $LibXSLT->parse_stylesheet($StyleDoc);
    };
    if ( !$StyleSheet ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not parse configured XSLT template',
            Data    => $@,
        );
    }

    # Append the configured include data to the normal data structure.
    if (
        IsHashRefWithData( $Param{DataInclude} )
        && IsArrayRefWithData( $Config->{DataInclude} )
        )
    {
        my $MergedData = Storable::dclone( $Param{Data} );
        DATAINCLUDEMODULE:
        for my $DataIncludeModule ( @{ $Config->{DataInclude} } ) {
            next DATAINCLUDEMODULE if !$Param{DataInclude}->{$DataIncludeModule};

            # Clone the data include hash to prevent circular data structure references
            $MergedData->{DataInclude}->{$DataIncludeModule}
                = Storable::dclone( $Param{DataInclude}->{$DataIncludeModule} );
        }

        $Self->{DebuggerObject}->Debug(
            Summary => 'Data merged with DataInclude before mapping',
            Data    => $MergedData,
        );

        $Param{Data} = $MergedData;
    }

    # Note: XML::Simple was chosen over alternatives like XML::LibXML and XML::Dumper
    #   due to its simplicity and because we just require a straightforward conversion.
    # Other modules provide more possibilities but don't allow directly exporting a complete
    #   and clean structure.
    # Reference:
    #   http://www.perlmonks.org/?node_id=490846
    #   http://stackoverflow.com/questions/12182129/convert-string-to-hash-using-libxml-in-perl

    # XSTL regex recursion.
    if ( IsArrayRefWithData( $Config->{PreRegExFilter} ) ) {
        $Self->_RegExRecursion(
            Data   => $Param{Data},
            Config => $Config->{PreRegExFilter},
        );
        $Self->{DebuggerObject}->Debug(
            Summary => 'Data before mapping after Pre RegExFilter',
            Data    => $Param{Data},
        );
    }

    # Convert data to xml structure.
    $Kernel::OM->Get('Kernel::System::Main')->Require('XML::Simple');
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
            Summary => 'Could not convert data from Perl to XML before mapping',
            Data    => $@,
        );
    }

    # Transform xml data.
    my ( $XMLSource, $Result );
    eval {
        $XMLSource = XML::LibXML->load_xml(
            string   => $XMLPre,
            no_cdata => 1,
        );
    };
    if ( !$XMLSource ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not load data after conversion from Perl to XML',
            Data    => $XMLPre,
        );
    }
    eval {
        $Result = $StyleSheet->transform($XMLSource);
    };
    if ( !$Result ) {
        return $Self->{DebuggerObject}->Error(
            Summary => 'Could not map data',
            Data    => $@,
        );
    }
    my $XMLPost = $StyleSheet->output_as_bytes($Result);
    if ( !$XMLPost ) {
        return $Self->{DebuggerObject}->Error(
            Summary => "Could not write mapped data",
        );
    }

    # Convert data back to perl structure.
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
            Summary => 'Could not convert data from XML to Perl after mapping',
            Data    => [ $@, $XMLPost ],
        );
    }

    # XST regex recursion.
    if ( IsArrayRefWithData( $Config->{PostRegExFilter} ) ) {
        $Self->{DebuggerObject}->Debug(
            Summary => 'Data after mapping before Post RegExFilter',
            Data    => $ReturnData,
        );
        $Self->_RegExRecursion(
            Data   => $ReturnData,
            Config => $Config->{PostRegExFilter},
        );
    }

    return {
        Success => 1,
        Data    => $ReturnData,
    };
}

sub _RegExRecursion {
    my ( $Self, %Param ) = @_;

    # Data must be hash ref.
    return 1 if !IsHashRefWithData( $Param{Data} );

    KEY:
    for my $Key ( sort keys %{ $Param{Data} } ) {

        # Recurse for array data in value.
        if ( IsArrayRefWithData( $Param{Data}->{$Key} ) ) {

            ARRAYENTRY:
            for my $ArrayEntry ( @{ $Param{Data}->{$Key} } ) {
                $Self->_RegExRecursion(
                    Data   => $ArrayEntry,
                    Config => $Param{Config},
                );
            }
        }

        # Recurse directly otherwise (assume hash reference).
        else {
            $Self->_RegExRecursion(
                Data   => $Param{Data}->{$Key},
                Config => $Param{Config},
            );
        }

        # Apply configured RegEx to key.
        REGEX:
        for my $RegEx ( @{ $Param{Config} } ) {
            next REGEX if $Key !~ m{$RegEx->{Search}};

            # Double-eval the replacement string to allow embedded capturing group replacements,
            #   e.g. Search = '(foo|bar)bar', Replace = '$1foo'
            #   turns 'foobar' into 'foofoo' and 'barbar' into 'barfoo'.
            my $NewKey = $Key =~ s{$RegEx->{Search}}{ '"' . $RegEx->{Replace} . '"' }eer;

            # Skip if new key is equivalent to old key.
            next KEY if $NewKey eq $Key;

            # Replace matched key with new one.
            $Param{Data}->{$NewKey} = delete $Param{Data}->{$Key};
        }

    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
