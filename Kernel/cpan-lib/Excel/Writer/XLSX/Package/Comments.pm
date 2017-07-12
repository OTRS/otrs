package Excel::Writer::XLSX::Package::Comments;

###############################################################################
#
# Comments - A class for writing the Excel XLSX Comments files.
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2016, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.008002;
use strict;
use warnings;
use Carp;
use Excel::Writer::XLSX::Package::XMLwriter;
use Excel::Writer::XLSX::Utility qw(xl_rowcol_to_cell);


our @ISA     = qw(Excel::Writer::XLSX::Package::XMLwriter);
our $VERSION = '0.95';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $fh    = shift;
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new( $fh );

    $self->{_author_ids} = {};

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self          = shift;
    my $comments_data = shift;

    $self->xml_declaration;

    # Write the comments element.
    $self->_write_comments();

    # Write the authors element.
    $self->_write_authors( $comments_data );

    # Write the commentList element.
    $self->_write_comment_list( $comments_data );

    $self->xml_end_tag( 'comments' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# XML writing methods.
#
###############################################################################


##############################################################################
#
# _write_comments()
#
# Write the <comments> element.
#
sub _write_comments {

    my $self  = shift;
    my $xmlns = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';

    my @attributes = ( 'xmlns' => $xmlns );

    $self->xml_start_tag( 'comments', @attributes );
}


##############################################################################
#
# _write_authors()
#
# Write the <authors> element.
#
sub _write_authors {

    my $self         = shift;
    my $comment_data = shift;
    my $author_count = 0;

    $self->xml_start_tag( 'authors' );

    for my $comment ( @$comment_data ) {
        my $author = $comment->[3];

        if ( defined $author && !exists $self->{_author_ids}->{$author} ) {

            # Store the author id.
            $self->{_author_ids}->{$author} = $author_count++;

            # Write the author element.
            $self->_write_author( $author );
        }
    }

    $self->xml_end_tag( 'authors' );
}


##############################################################################
#
# _write_author()
#
# Write the <author> element.
#
sub _write_author {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'author', $data );
}


##############################################################################
#
# _write_comment_list()
#
# Write the <commentList> element.
#
sub _write_comment_list {

    my $self         = shift;
    my $comment_data = shift;

    $self->xml_start_tag( 'commentList' );

    for my $comment ( @$comment_data ) {
        my $row    = $comment->[0];
        my $col    = $comment->[1];
        my $text   = $comment->[2];
        my $author = $comment->[3];

        # Look up the author id.
        my $author_id = undef;
        $author_id = $self->{_author_ids}->{$author} if defined $author;

        # Write the comment element.
        $self->_write_comment( $row, $col, $text, $author_id );
    }

    $self->xml_end_tag( 'commentList' );
}


##############################################################################
#
# _write_comment()
#
# Write the <comment> element.
#
sub _write_comment {

    my $self      = shift;
    my $row       = shift;
    my $col       = shift;
    my $text      = shift;
    my $author_id = shift;
    my $ref       = xl_rowcol_to_cell( $row, $col );

    my @attributes = ( 'ref' => $ref );

    push @attributes, ( 'authorId' => $author_id ) if defined $author_id;


    $self->xml_start_tag( 'comment', @attributes );

    # Write the text element.
    $self->_write_text( $text );


    $self->xml_end_tag( 'comment' );
}


##############################################################################
#
# _write_text()
#
# Write the <text> element.
#
sub _write_text {

    my $self = shift;
    my $text = shift;

    $self->xml_start_tag( 'text' );

    # Write the text r element.
    $self->_write_text_r( $text );

    $self->xml_end_tag( 'text' );
}


##############################################################################
#
# _write_text_r()
#
# Write the <r> element.
#
sub _write_text_r {

    my $self = shift;
    my $text = shift;

    $self->xml_start_tag( 'r' );

    # Write the rPr element.
    $self->_write_r_pr();

    # Write the text r element.
    $self->_write_text_t( $text );

    $self->xml_end_tag( 'r' );
}


##############################################################################
#
# _write_text_t()
#
# Write the text <t> element.
#
sub _write_text_t {

    my $self = shift;
    my $text = shift;

    my @attributes = ();

    if ( $text =~ /^\s/ || $text =~ /\s$/ ) {
        push @attributes, ( 'xml:space' => 'preserve' );
    }

    $self->xml_data_element( 't', $text, @attributes );
}


##############################################################################
#
# _write_r_pr()
#
# Write the <rPr> element.
#
sub _write_r_pr {

    my $self = shift;

    $self->xml_start_tag( 'rPr' );

    # Write the sz element.
    $self->_write_sz();

    # Write the color element.
    $self->_write_color();

    # Write the rFont element.
    $self->_write_r_font();

    # Write the family element.
    $self->_write_family();

    $self->xml_end_tag( 'rPr' );
}


##############################################################################
#
# _write_sz()
#
# Write the <sz> element.
#
sub _write_sz {

    my $self = shift;
    my $val  = 8;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'sz', @attributes );
}


##############################################################################
#
# _write_color()
#
# Write the <color> element.
#
sub _write_color {

    my $self    = shift;
    my $indexed = 81;

    my @attributes = ( 'indexed' => $indexed );

    $self->xml_empty_tag( 'color', @attributes );
}


##############################################################################
#
# _write_r_font()
#
# Write the <rFont> element.
#
sub _write_r_font {

    my $self = shift;
    my $val  = 'Tahoma';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'rFont', @attributes );
}


##############################################################################
#
# _write_family()
#
# Write the <family> element.
#
sub _write_family {

    my $self = shift;
    my $val  = 2;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'family', @attributes );
}


1;


__END__

=pod

=head1 NAME

Comments - A class for writing the Excel XLSX Comments files.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut
