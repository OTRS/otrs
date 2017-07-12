package Excel::Writer::XLSX::Format;

###############################################################################
#
# Format - A class for defining Excel formatting.
#
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2016, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

use 5.008002;
use Exporter;
use strict;
use warnings;
use Carp;


our @ISA     = qw(Exporter);
our $VERSION = '0.95';
our $AUTOLOAD;


###############################################################################
#
# new()
#
# Constructor
#
sub new {

    my $class = shift;

    my $self = {
        _xf_format_indices  => shift,
        _dxf_format_indices => shift,
        _xf_index           => undef,
        _dxf_index          => undef,

        _num_format       => 0,
        _num_format_index => 0,
        _font_index       => 0,
        _has_font         => 0,
        _has_dxf_font     => 0,
        _font             => 'Calibri',
        _size             => 11,
        _bold             => 0,
        _italic           => 0,
        _color            => 0x0,
        _underline        => 0,
        _font_strikeout   => 0,
        _font_outline     => 0,
        _font_shadow      => 0,
        _font_script      => 0,
        _font_family      => 2,
        _font_charset     => 0,
        _font_scheme      => 'minor',
        _font_condense    => 0,
        _font_extend      => 0,
        _theme            => 0,
        _hyperlink        => 0,

        _hidden => 0,
        _locked => 1,

        _text_h_align  => 0,
        _text_wrap     => 0,
        _text_v_align  => 0,
        _text_justlast => 0,
        _rotation      => 0,

        _fg_color     => 0x00,
        _bg_color     => 0x00,
        _pattern      => 0,
        _has_fill     => 0,
        _has_dxf_fill => 0,
        _fill_index   => 0,
        _fill_count   => 0,

        _border_index   => 0,
        _has_border     => 0,
        _has_dxf_border => 0,
        _border_count   => 0,

        _bottom       => 0,
        _bottom_color => 0x0,
        _diag_border  => 0,
        _diag_color   => 0x0,
        _diag_type    => 0,
        _left         => 0,
        _left_color   => 0x0,
        _right        => 0,
        _right_color  => 0x0,
        _top          => 0,
        _top_color    => 0x0,

        _indent        => 0,
        _shrink        => 0,
        _merge_range   => 0,
        _reading_order => 0,
        _just_distrib  => 0,
        _color_indexed => 0,
        _font_only     => 0,

    };

    bless $self, $class;

    # Set properties passed to Workbook::add_format()
    $self->set_format_properties(@_) if @_;

    return $self;
}


###############################################################################
#
# copy($format)
#
# Copy the attributes of another Excel::Writer::XLSX::Format object.
#
sub copy {
    my $self  = shift;
    my $other = $_[0];


    return unless defined $other;
    return unless ( ref( $self ) eq ref( $other ) );

    # Store properties that we don't want over-ridden.
    my $xf_index           = $self->{_xf_index};
    my $dxf_index          = $self->{_dxf_index};
    my $xf_format_indices  = $self->{_xf_format_indices};
    my $dxf_format_indices = $self->{_dxf_format_indices};
    my $palette            = $self->{_palette};

    # Copy properties.
    %$self             = %$other;

    # Restore original properties.
    $self->{_xf_index}           = $xf_index;
    $self->{_dxf_index}          = $dxf_index;
    $self->{_xf_format_indices}  = $xf_format_indices;
    $self->{_dxf_format_indices} = $dxf_format_indices;
    $self->{_palette}            = $palette;
}


###############################################################################
#
# get_align_properties()
#
# Return properties for an Style xf <alignment> sub-element.
#
sub get_align_properties {

    my $self = shift;

    my @align;    # Attributes to return

    # Check if any alignment options in the format have been changed.
    my $changed =
      (      $self->{_text_h_align} != 0
          || $self->{_text_v_align} != 0
          || $self->{_indent} != 0
          || $self->{_rotation} != 0
          || $self->{_text_wrap} != 0
          || $self->{_shrink} != 0
          || $self->{_reading_order} != 0 ) ? 1 : 0;

    return unless $changed;



    # Indent is only allowed for horizontal left, right and distributed. If it
    # is defined for any other alignment or no alignment has been set then
    # default to left alignment.
    if (   $self->{_indent}
        && $self->{_text_h_align} != 1
        && $self->{_text_h_align} != 3
        && $self->{_text_h_align} != 7 )
    {
        $self->{_text_h_align} = 1;
    }

    # Check for properties that are mutually exclusive.
    $self->{_shrink}       = 0 if $self->{_text_wrap};
    $self->{_shrink}       = 0 if $self->{_text_h_align} == 4;    # Fill
    $self->{_shrink}       = 0 if $self->{_text_h_align} == 5;    # Justify
    $self->{_shrink}       = 0 if $self->{_text_h_align} == 7;    # Distributed
    $self->{_just_distrib} = 0 if $self->{_text_h_align} != 7;    # Distributed
    $self->{_just_distrib} = 0 if $self->{_indent};

    my $continuous = 'centerContinuous';

    push @align, 'horizontal', 'left'        if $self->{_text_h_align} == 1;
    push @align, 'horizontal', 'center'      if $self->{_text_h_align} == 2;
    push @align, 'horizontal', 'right'       if $self->{_text_h_align} == 3;
    push @align, 'horizontal', 'fill'        if $self->{_text_h_align} == 4;
    push @align, 'horizontal', 'justify'     if $self->{_text_h_align} == 5;
    push @align, 'horizontal', $continuous   if $self->{_text_h_align} == 6;
    push @align, 'horizontal', 'distributed' if $self->{_text_h_align} == 7;

    push @align, 'justifyLastLine', 1 if $self->{_just_distrib};

    # Property 'vertical' => 'bottom' is a default. It sets applyAlignment
    # without an alignment sub-element.
    push @align, 'vertical', 'top'         if $self->{_text_v_align} == 1;
    push @align, 'vertical', 'center'      if $self->{_text_v_align} == 2;
    push @align, 'vertical', 'justify'     if $self->{_text_v_align} == 4;
    push @align, 'vertical', 'distributed' if $self->{_text_v_align} == 5;

    push @align, 'indent',       $self->{_indent}   if $self->{_indent};
    push @align, 'textRotation', $self->{_rotation} if $self->{_rotation};

    push @align, 'wrapText',     1 if $self->{_text_wrap};
    push @align, 'shrinkToFit',  1 if $self->{_shrink};

    push @align, 'readingOrder', 1 if $self->{_reading_order} == 1;
    push @align, 'readingOrder', 2 if $self->{_reading_order} == 2;

    return $changed, @align;
}


###############################################################################
#
# get_protection_properties()
#
# Return properties for an Excel XML <Protection> element.
#
sub get_protection_properties {

    my $self = shift;

    my @attribs;

    push @attribs, 'locked', 0 if !$self->{_locked};
    push @attribs, 'hidden', 1 if $self->{_hidden};

    return @attribs;
}


###############################################################################
#
# get_format_key()
#
# Returns a unique hash key for the Format object.
#
sub get_format_key {

    my $self = shift;

    my $key = join ':',
      (
        $self->get_font_key(), $self->get_border_key,
        $self->get_fill_key(), $self->get_alignment_key(),
        $self->{_num_format},  $self->{_locked},
        $self->{_hidden}
      );

    return $key;
}

###############################################################################
#
# get_font_key()
#
# Returns a unique hash key for a font. Used by Workbook.
#
sub get_font_key {

    my $self = shift;

    my $key = join ':', (
        $self->{_bold},
        $self->{_color},
        $self->{_font_charset},
        $self->{_font_family},
        $self->{_font_outline},
        $self->{_font_script},
        $self->{_font_shadow},
        $self->{_font_strikeout},
        $self->{_font},
        $self->{_italic},
        $self->{_size},
        $self->{_underline},

    );

    return $key;
}


###############################################################################
#
# get_border_key()
#
# Returns a unique hash key for a border style. Used by Workbook.
#
sub get_border_key {

    my $self = shift;

    my $key = join ':', (
        $self->{_bottom},
        $self->{_bottom_color},
        $self->{_diag_border},
        $self->{_diag_color},
        $self->{_diag_type},
        $self->{_left},
        $self->{_left_color},
        $self->{_right},
        $self->{_right_color},
        $self->{_top},
        $self->{_top_color},

    );

    return $key;
}


###############################################################################
#
# get_fill_key()
#
# Returns a unique hash key for a fill style. Used by Workbook.
#
sub get_fill_key {

    my $self = shift;

    my $key = join ':', (
        $self->{_pattern},
        $self->{_bg_color},
        $self->{_fg_color},

    );

    return $key;
}


###############################################################################
#
# get_alignment_key()
#
# Returns a unique hash key for alignment formats.
#
sub get_alignment_key {

    my $self = shift;

    my $key = join ':', (
        $self->{_text_h_align},
        $self->{_text_v_align},
        $self->{_indent},
        $self->{_rotation},
        $self->{_text_wrap},
        $self->{_shrink},
        $self->{_reading_order},

    );

    return $key;
}


###############################################################################
#
# get_xf_index()
#
# Returns the index used by Worksheet->_XF()
#
sub get_xf_index {
    my $self = shift;

    if ( defined $self->{_xf_index} ) {
        return $self->{_xf_index};
    }
    else {
        my $key  = $self->get_format_key();
        my $indices_href = ${ $self->{_xf_format_indices} };

        if ( exists $indices_href->{$key} ) {
            return $indices_href->{$key};
        }
        else {
            my $index = 1 + scalar keys %$indices_href;
            $indices_href->{$key} = $index;
            $self->{_xf_index} = $index;
            return $index;
        }
    }
}


###############################################################################
#
# get_dxf_index()
#
# Returns the index used by Worksheet->_XF()
#
sub get_dxf_index {
    my $self = shift;

    if ( defined $self->{_dxf_index} ) {
        return $self->{_dxf_index};
    }
    else {
        my $key  = $self->get_format_key();
        my $indices_href = ${ $self->{_dxf_format_indices} };

        if ( exists $indices_href->{$key} ) {
            return $indices_href->{$key};
        }
        else {
            my $index = scalar keys %$indices_href;
            $indices_href->{$key} = $index;
            $self->{_dxf_index} = $index;
            return $index;
        }
    }
}


###############################################################################
#
# _get_color()
#
# Used in conjunction with the set_xxx_color methods to convert a color
# string into a number. Color range is 0..63 but we will restrict it
# to 8..63 to comply with Gnumeric. Colors 0..7 are repeated in 8..15.
#
sub _get_color {

    my %colors = (
        aqua    => 0x0F,
        cyan    => 0x0F,
        black   => 0x08,
        blue    => 0x0C,
        brown   => 0x10,
        magenta => 0x0E,
        fuchsia => 0x0E,
        gray    => 0x17,
        grey    => 0x17,
        green   => 0x11,
        lime    => 0x0B,
        navy    => 0x12,
        orange  => 0x35,
        pink    => 0x21,
        purple  => 0x14,
        red     => 0x0A,
        silver  => 0x16,
        white   => 0x09,
        yellow  => 0x0D,
    );

    # Return RGB style colors for processing later.
    if ( $_[0] =~ m/^#[0-9A-F]{6}$/i ) {
        return $_[0];
    }

    # Return the default color if undef,
    return 0x00 unless defined $_[0];

    # or the color string converted to an integer,
    return $colors{ lc( $_[0] ) } if exists $colors{ lc( $_[0] ) };

    # or the default color if string is unrecognised,
    return 0x00 if ( $_[0] =~ m/\D/ );

    # or an index < 8 mapped into the correct range,
    return $_[0] + 8 if $_[0] < 8;

    # or the default color if arg is outside range,
    return 0x00 if $_[0] > 63;

    # or an integer in the valid range
    return $_[0];
}


###############################################################################
#
# set_type()
#
# Set the XF object type as 0 = cell XF or 0xFFF5 = style XF.
#
sub set_type {

    my $self = shift;
    my $type = $_[0];

    if (defined $_[0] and $_[0] eq 0) {
        $self->{_type} = 0x0000;
    }
    else {
        $self->{_type} = 0xFFF5;
    }
}


###############################################################################
#
# set_align()
#
# Set cell alignment.
#
sub set_align {

    my $self     = shift;
    my $location = $_[0];

    return if not defined $location;    # No default
    return if $location =~ m/\d/;       # Ignore numbers

    $location = lc( $location );

    $self->set_text_h_align( 1 ) if $location eq 'left';
    $self->set_text_h_align( 2 ) if $location eq 'centre';
    $self->set_text_h_align( 2 ) if $location eq 'center';
    $self->set_text_h_align( 3 ) if $location eq 'right';
    $self->set_text_h_align( 4 ) if $location eq 'fill';
    $self->set_text_h_align( 5 ) if $location eq 'justify';
    $self->set_text_h_align( 6 ) if $location eq 'center_across';
    $self->set_text_h_align( 6 ) if $location eq 'centre_across';
    $self->set_text_h_align( 6 ) if $location eq 'merge';              # Legacy.
    $self->set_text_h_align( 7 ) if $location eq 'distributed';
    $self->set_text_h_align( 7 ) if $location eq 'equal_space';        # S::PE.
    $self->set_text_h_align( 7 ) if $location eq 'justify_distributed';

    $self->{_just_distrib} = 1 if $location eq 'justify_distributed';

    $self->set_text_v_align( 1 ) if $location eq 'top';
    $self->set_text_v_align( 2 ) if $location eq 'vcentre';
    $self->set_text_v_align( 2 ) if $location eq 'vcenter';
    $self->set_text_v_align( 3 ) if $location eq 'bottom';
    $self->set_text_v_align( 4 ) if $location eq 'vjustify';
    $self->set_text_v_align( 5 ) if $location eq 'vdistributed';
    $self->set_text_v_align( 5 ) if $location eq 'vequal_space';    # S::PE.
}


###############################################################################
#
# set_valign()
#
# Set vertical cell alignment. This is required by the set_properties() method
# to differentiate between the vertical and horizontal properties.
#
sub set_valign {

    my $self = shift;
    $self->set_align( @_ );
}


###############################################################################
#
# set_center_across()
#
# Implements the Excel5 style "merge".
#
sub set_center_across {

    my $self = shift;

    $self->set_text_h_align( 6 );
}


###############################################################################
#
# set_merge()
#
# This was the way to implement a merge in Excel5. However it should have been
# called "center_across" and not "merge".
# This is now deprecated. Use set_center_across() or better merge_range().
#
#
sub set_merge {

    my $self = shift;

    $self->set_text_h_align( 6 );
}


###############################################################################
#
# set_bold()
#
#
sub set_bold {

    my $self = shift;
    my $bold = defined $_[0] ? $_[0] : 1;

    $self->{_bold} = $bold ? 1 : 0;
}


###############################################################################
#
# set_border($style)
#
# Set cells borders to the same style
#
sub set_border {

    my $self  = shift;
    my $style = $_[0];

    $self->set_bottom( $style );
    $self->set_top( $style );
    $self->set_left( $style );
    $self->set_right( $style );
}


###############################################################################
#
# set_border_color($color)
#
# Set cells border to the same color
#
sub set_border_color {

    my $self  = shift;
    my $color = $_[0];

    $self->set_bottom_color( $color );
    $self->set_top_color( $color );
    $self->set_left_color( $color );
    $self->set_right_color( $color );
}


###############################################################################
#
# set_rotation($angle)
#
# Set the rotation angle of the text. An alignment property.
#
sub set_rotation {

    my $self     = shift;
    my $rotation = $_[0];

    # Argument should be a number
    return if $rotation !~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/;

    # The arg type can be a double but the Excel dialog only allows integers.
    $rotation = int $rotation;

    if ( $rotation == 270 ) {
        $rotation = 255;
    }
    elsif ( $rotation >= -90 and $rotation <= 90 ) {
        $rotation = -$rotation + 90 if $rotation < 0;
    }
    else {
        carp "Rotation $rotation outside range: -90 <= angle <= 90";
        $rotation = 0;
    }

    $self->{_rotation} = $rotation;
}


###############################################################################
#
# set_hyperlink()
#
# Set the properties for the hyperlink style. TODO. This doesn't currently
# work. Fix it when styles are supported.
#
sub set_hyperlink {

    my $self = shift;

    $self->{_hyperlink} = 1;

    $self->set_underline( 1 );
    $self->set_theme( 10 );
    $self->set_align( 'top' );
}


###############################################################################
#
# set_format_properties()
#
# Convert hashes of properties to method calls.
#
sub set_format_properties {

    my $self = shift;

    my %properties = @_;    # Merge multiple hashes into one

    while ( my ( $key, $value ) = each( %properties ) ) {

        # Strip leading "-" from Tk style properties e.g. -color => 'red'.
        $key =~ s/^-//;

        # Create a sub to set the property.
        my $sub = \&{"set_$key"};
        $sub->( $self, $value );
    }
}

# Renamed rarely used set_properties() to set_format_properties() to avoid
# confusion with Workbook method of the same name. The following acts as an
# alias for any code that uses the old name.
*set_properties = *set_format_properties;


###############################################################################
#
# AUTOLOAD. Deus ex machina.
#
# Dynamically create set methods that aren't already defined.
#
sub AUTOLOAD {

    my $self = shift;

    # Ignore calls to DESTROY
    return if $AUTOLOAD =~ /::DESTROY$/;

    # Check for a valid method names, i.e. "set_xxx_yyy".
    $AUTOLOAD =~ /.*::set(\w+)/ or die "Unknown method: $AUTOLOAD\n";

    # Match the attribute, i.e. "_xxx_yyy".
    my $attribute = $1;

    # Check that the attribute exists
    exists $self->{$attribute} or die "Unknown method: $AUTOLOAD\n";

    # The attribute value
    my $value;


    # There are two types of set methods: set_property() and
    # set_property_color(). When a method is AUTOLOADED we store a new anonymous
    # sub in the appropriate slot in the symbol table. The speeds up subsequent
    # calls to the same method.
    #
    no strict 'refs';    # To allow symbol table hackery

    if ( $AUTOLOAD =~ /.*::set\w+color$/ ) {

        # For "set_property_color" methods
        $value = _get_color( $_[0] );

        *{$AUTOLOAD} = sub {
            my $self = shift;

            $self->{$attribute} = _get_color( $_[0] );
        };
    }
    else {

        $value = $_[0];
        $value = 1 if not defined $value;    # The default value is always 1

        *{$AUTOLOAD} = sub {
            my $self  = shift;
            my $value = shift;

            $value = 1 if not defined $value;
            $self->{$attribute} = $value;
        };
    }


    $self->{$attribute} = $value;
}


1;


__END__


=head1 NAME

Format - A class for defining Excel formatting.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
