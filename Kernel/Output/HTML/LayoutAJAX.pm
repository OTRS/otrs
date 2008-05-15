# --
# Kernel/Output/HTML/LayoutAJAX.pm - provides generic HTML output
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LayoutAJAX.pm,v 1.8 2008-05-15 22:05:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutAJAX;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

=item BuildJSON()

build a JSON output js witch can be used for e. g. data for pull downs

    my $JSON = $LayoutObject->BuildJSON(
        [
            Data => $ArrayRef,           # use $HashRef, $ArrayRef or $ArrayHashRef (see below)
            Name => 'TheName',           # name of element
            SelectedID => [1, 5, 3],     # (optional) use integer or arrayref (unable to use with ArrayHashRef)
            SelectedValue => 'test',     # (optional) use string or arrayref (unable to use with ArrayHashRef)
            Sort => 'NumericValue',      # (optional) (AlphanumericValue|NumericValue|AlphanumericKey|NumericKey|TreeView) unable to use with ArrayHashRef
            SortReverse => 0,            # (optional) reverse the list
            Translation => 1,            # (optional) default 1 (0|1) translate value
            PossibleNone => 0,           # (optional) default 0 (0|1) add a leading empty selection
            Max => 100,                  # (optional) default 100 max size of the shown value
        ],
        [
            # ...
        ]
    );

=cut

sub BuildJSON {
    my ( $Self, $Array ) = @_;

    my $JSON  = '{';
    my $Count = 0;
    for my $Data ( @{$Array} ) {
        my %Param = %{$Data};

        # check needed stuff
        for (qw(Name Data)) {
            if ( !$Param{$_} ) {
                $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
                return;
            }
        }
        if ( ref( $Param{Data} ) eq '' ) {

            # quote
            my %Quote = (
                "\n" => '\n',
                "\r" => '\r',
                "\t" => '\t',
                "\f" => '\f',
                "\b" => '\b',
                "\"" => '\"',
                "\\" => '\\\\',
                "\'" => '\\\'',
            );
            $Param{Data} =~ s/([\\"\n\r\t\f\b])/$Quote{$1}/eg;
            $JSON .= "'$Param{Name}': [";
            $JSON .= "'$Param{Data}'";
            $JSON .= "]";
        }
        else {

            # create OptionRef
            my $OptionRef = $Self->_BuildSelectionOptionRefCreate(
                %Param,
                HTMLQuote => 0,
            );

            # create AttributeRef
            my $AttributeRef = $Self->_BuildSelectionAttributeRefCreate(%Param);

            # create DataRef
            my $DataRef = $Self->_BuildSelectionDataRefCreate(
                Data         => $Param{Data},
                AttributeRef => $AttributeRef,
                OptionRef    => $OptionRef,
            );
            if ($Count) {
                $JSON .= ",";
            }

            # generate output
            $JSON .= ${
                $Self->_BuildJSONOutput(
                    AttributeRef => $AttributeRef,
                    DataRef      => $DataRef,
                    )
                };
        }
        $Count++;
    }
    return $JSON . '}';
}

sub _BuildJSONOutput {
    my ( $Self, %Param ) = @_;

    my $String;

    # start generation, if AttributeRef and DataRef was found
    if ( $Param{AttributeRef} && $Param{DataRef} ) {
        $String = "'$Param{AttributeRef}->{name}':[";
        my $Count = 0;
        for my $Row ( @{ $Param{DataRef} } ) {
            if ($Count) {
                $String .= ",";
            }
            my $Key = '';
            if ( defined( $Row->{Key} ) ) {
                $Key = $Row->{Key};
            }
            my $Value = '';
            if ( defined( $Row->{Value} ) ) {
                $Value = $Row->{Value};
            }
            my $SelectedDisabled = 'false';
            if ( $Row->{Selected} ) {
                $SelectedDisabled = 'true';
            }
            elsif ( $Row->{Disabled} ) {
                $SelectedDisabled = 'false';
            }

            # quote
            my %Quote = (
                "\n" => '\n',
                "\r" => '\r',
                "\t" => '\t',
                "\f" => '\f',
                "\b" => '\b',
                "\"" => '\"',
                "\\" => '\\\\',
                "\'" => '\\\'',
            );
            $Key   =~ s/([\\"\n\r\t\f\b])/$Quote{$1}/eg;
            $Value =~ s/([\\"\n\r\t\f\b])/$Quote{$1}/eg;
            $String .= "['$Key','$Value',$SelectedDisabled,$SelectedDisabled]";
            $Count++;
        }
        $String .= "]";
    }
    return \$String;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.8 $ $Date: 2008-05-15 22:05:46 $

=cut
