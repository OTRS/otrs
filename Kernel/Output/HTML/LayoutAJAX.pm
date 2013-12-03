# --
# Kernel/Output/HTML/LayoutAJAX.pm - provides generic HTML output
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutAJAX;

use strict;
use warnings;

=head1 NAME

Kernel::Output::HTML::LayoutAJAX - all AJAX-related HTML functions

=head1 SYNOPSIS

All AJAX-related HTML functions

=head1 PUBLIC INTERFACE

=over 4

=item BuildSelectionJSON()

build a JSON output js witch can be used for e. g. data for pull downs

    my $JSON = $LayoutObject->BuildSelectionJSON(
        [
            Data          => $ArrayRef,      # use $HashRef, $ArrayRef or $ArrayHashRef (see below)
            Name          => 'TheName',      # name of element
            SelectedID    => [1, 5, 3],      # (optional) use integer or arrayref (unable to use with ArrayHashRef)
            SelectedValue => 'test',         # (optional) use string or arrayref (unable to use with ArrayHashRef)
            Sort          => 'NumericValue', # (optional) (AlphanumericValue|NumericValue|AlphanumericKey|NumericKey|TreeView) unable to use with ArrayHashRef
            SortReverse   => 0,              # (optional) reverse the list
            Translation   => 1,              # (optional) default 1 (0|1) translate value
            PossibleNone  => 0,              # (optional) default 0 (0|1) add a leading empty selection
            Max => 100,                      # (optional) default 100 max size of the shown value
        ],
        [
            # ...
        ]
    );

=cut

sub BuildSelectionJSON {
    my ( $Self, $Array ) = @_;
    my %DataHash;

    for my $Data ( @{$Array} ) {
        my %Param = %{$Data};

        # check needed stuff
        for (qw(Name Data)) {
            if ( !defined $Param{$_} ) {
                $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
                return;
            }
        }

        if ( ref $Param{Data} eq '' ) {
            $DataHash{ $Param{Name} } = $Param{Data};
        }
        elsif ( defined $Param{KeepData} && $Param{KeepData} ) {
            $DataHash{ $Param{Name} } = $Param{Data};
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

            # create data structure
            if ( $AttributeRef && $DataRef ) {
                my @DataArray;
                for my $Row ( @{$DataRef} ) {
                    my $Key = '';
                    if ( defined $Row->{Key} ) {
                        $Key = $Row->{Key};
                    }
                    my $Value = '';
                    if ( defined $Row->{Value} ) {
                        $Value = $Row->{Value};
                    }

                    # DefaultSelected parameter for JavaScript New Option
                    my $DefaultSelected = Kernel::System::JSON::False();

                    # to set a disabled option (Disabled is not included in JavaScript New Option)
                    my $Disabled = Kernel::System::JSON::False();

                    if ( $Row->{Selected} ) {
                        $DefaultSelected = Kernel::System::JSON::True();
                    }
                    elsif ( $Row->{Disabled} ) {
                        $DefaultSelected = Kernel::System::JSON::False();
                        $Disabled        = Kernel::System::JSON::True();
                    }

                    # Selected parameter for JavaScript NewOption
                    my $Selected = $DefaultSelected;
                    push @DataArray, [ $Key, $Value, $DefaultSelected, $Selected, $Disabled ];
                }
                $DataHash{ $AttributeRef->{name} } = \@DataArray;
            }
        }
    }

    return $Self->JSONEncode(
        Data => \%DataHash,
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
