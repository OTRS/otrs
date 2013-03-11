# --
# Kernel/System/CSV.pm - all csv functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CSV;

use strict;
use warnings;
use Text::CSV;

use vars qw(@ISA $VERSION);

=head1 NAME

Kernel::System::CSV - CSV lib

=head1 SYNOPSIS

All csv functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::CSV;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $CSVObject = Kernel::System::CSV->new(
        LogObject => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item Array2CSV()

Returns a csv formatted string based on a array with head data.

    $CSV = $CSVObject->Array2CSV(
        Head => [ 'RowA', 'RowB', ],   # optional
        Data => [
            [ 1, 4 ],
            [ 7, 3 ],
            [ 1, 9 ],
            [ 34, 4 ],
        ],
        Separator => ';', # optional separator (default is ;)
        Quote     => '"', # optional quote (default is ")
    );

=cut

sub Array2CSV {
    my ( $Self, %Param ) = @_;

    # check required params
    for (qw(Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Got no $_ param!" );
            return;
        }
    }

    my @Head;
    my @Data = ( ['##No Data##'] );
    if ( $Param{Head} ) {
        @Head = @{ $Param{Head} };
    }
    if ( $Param{Data} ) {
        @Data = @{ $Param{Data} };
    }

    # get separator
    if ( !defined $Param{Separator} || $Param{Separator} eq '' ) {
        $Param{Separator} = ';';
    }

    # get separator
    if ( !defined $Param{Quote} ) {
        $Param{Quote} = '"';
    }

    # create new csv backend object
    my $CSV = Text::CSV->new(
        {
            quote_char          => $Param{Quote},
            escape_char         => $Param{Quote},
            sep_char            => $Param{Separator},
            eol                 => '',
            always_quote        => 1,
            binary              => 1,
            keep_meta_info      => 0,
            allow_loose_quotes  => 0,
            allow_loose_escapes => 0,
            allow_whitespace    => 0,
            verbatim            => 0,
        }
    );

    my $Output = '';

    # if we have head param fill in header
    if (@Head) {
        my $Status = $CSV->combine(@Head);
        $Output .= $CSV->string() . "\n";
    }

    # fill in data
    for my $Row (@Data) {
        my $Status = $CSV->combine( @{$Row} );
        if ($Status) {
            $Output .= $CSV->string() . "\n";
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Failed to build line: ' . $CSV->error_input(),
            );
        }
    }
    return $Output;
}

=item CSV2Array()

Returns an array with parsed csv data.

    my $RefArray = $CSVObject->CSV2Array(
        String    => $CSVString,
        Separator => ';', # optional separator (default is ;)
        Quote     => '"', # optional quote (default is ")
    );

=cut

sub CSV2Array {
    my ( $Self, %Param ) = @_;

    # get separator
    if ( !defined $Param{Separator} || $Param{Separator} eq '' ) {
        $Param{Separator} = ';';
    }

    # get separator
    if ( !defined $Param{Quote} ) {
        $Param{Quote} = '"';
    }

    # create new csv backend object
    my $CSV = Text::CSV->new(
        {

            #            quote_char          => $Param{Quote},
            #            escape_char         => $Param{Quote},
            sep_char            => $Param{Separator},
            eol                 => '',
            always_quote        => 0,
            binary              => 1,
            keep_meta_info      => 0,
            allow_loose_quotes  => 0,
            allow_loose_escapes => 0,
            allow_whitespace    => 0,
            verbatim            => 0,
        }
    );

    # do some dos/unix file conversions
    $Param{String} =~ s/(\n\r|\r\r\n|\r\n|\r)/\n/g;

    # if you change the split options, remember that each value can include \n
    my @Array;
    my @Lines = split /$Param{Quote}\n/, $Param{String};
    for my $Line (@Lines) {
        if ( $CSV->parse( $Line . $Param{Quote} ) ) {
            my @Fields = $CSV->fields();
            push @Array, \@Fields;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Failed to parse line: ' . $CSV->error_input(),
            );
        }
    }

    return \@Array;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
