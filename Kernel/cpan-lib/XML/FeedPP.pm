=head1 NAME

XML::FeedPP -- Parse/write/merge/edit RSS/RDF/Atom syndication feeds

=head1 SYNOPSIS

Get an RSS file and parse it:

    my $source = 'http://use.perl.org/index.rss';
    my $feed = XML::FeedPP->new( $source );
    print "Title: ", $feed->title(), "\n";
    print "Date: ", $feed->pubDate(), "\n";
    foreach my $item ( $feed->get_item() ) {
        print "URL: ", $item->link(), "\n";
        print "Title: ", $item->title(), "\n";
    }

Generate an RDF file and save it:

    my $feed = XML::FeedPP::RDF->new();
    $feed->title( "use Perl" );
    $feed->link( "http://use.perl.org/" );
    $feed->pubDate( "Thu, 23 Feb 2006 14:43:43 +0900" );
    my $item = $feed->add_item( "http://search.cpan.org/~kawasaki/XML-TreePP-0.02" );
    $item->title( "Pure Perl implementation for parsing/writing xml file" );
    $item->pubDate( "2006-02-23T14:43:43+09:00" );
    $feed->to_file( "index.rdf" );

Convert some RSS/RDF files to Atom format:

    my $feed = XML::FeedPP::Atom::Atom10->new();        # create empty atom file
    $feed->merge( "rss.xml" );                          # load local RSS file
    $feed->merge( "http://www.kawa.net/index.rdf" );    # load remote RDF file
    my $now = time();
    $feed->pubDate( $now );                             # touch date
    my $atom = $feed->to_string();                      # get Atom source code

=head1 DESCRIPTION

C<XML::FeedPP> is an all-purpose syndication utility that parses and
publishes RSS 2.0, RSS 1.0 (RDF), Atom 0.3 and 1.0 feeds.
It allows you to add new content, merge feeds, and convert among
these various formats.
It is a pure Perl implementation and does not require any other
module except for XML::TreePP.

=head1 METHODS FOR FEED

=head2  $feed = XML::FeedPP->new( "index.rss" );

This constructor method creates an C<XML::FeedPP> feed instance. The only
argument is the local filename.  The format of $source must be one of
the supported feed formats -- RSS, RDF or Atom -- or execution is
halted.

=head2  $feed = XML::FeedPP->new( "http://use.perl.org/index.rss" );

The URL on the remote web server is also available as the first argument.
L<LWP::UserAgent> is required to download it.

=head2  $feed = XML::FeedPP->new( '<rss version="2.0">...' );

The XML source code is also available as the first argument.

=head2  $feed = XML::FeedPP->new( $source, -type => $type );

The C<-type> argument allows you to specify type of $source
from choice of C<'file'>, C<'url'> or C<'string'>.

=head2  $feed = XML::FeedPP->new( $source, utf8_flag => 1 );

This makes utf8 flag on for every feed elements.
Perl 5.8.1 or later is required to use this.

Note that any other options for C<XML::TreePP> constructor are also
allowed like this. See more detail on L<XML::TreePP>.

=head2  $feed = XML::FeedPP::RSS->new( $source );

This constructor method creates an instance for an RSS 2.0 feed.
The first argument is optional, but must be valid an RSS source if specified.
This method returns an empty instance when $source is undefined.

=head2  $feed = XML::FeedPP::RDF->new( $source );

This constructor method creates an instance for RSS 1.0 (RDF) feed.
The first argument is optional, but must be an RDF source if specified.
This method returns an empty instance when $source is undefined.

=head2  $feed = XML::FeedPP::Atom->new( $source );

This constructor method creates an instance for an Atom 0.3/1.0 feed.
The first argument is optional, but must be an Atom source if specified.
This method returns an empty instance when $source is undefined.

Atom 1.0 feed is also supported since C<XML::FeedPP> version 0.30.
Atom 0.3 is still default, however, future version of this module
would create Atom 1.0 as default.

=head2  $feed = XML::FeedPP::Atom::Atom03->new();

This creates an empty Atom 0.3 instance obviously.

=head2  $feed = XML::FeedPP::Atom::Atom10->new();

This creates an empty Atom 1.0 instance intended.

=head2  $feed = XML::FeedPP::RSS->new( link => $link, title => $tile, ... );

This creates a RSS instance which has C<link>, C<title> elements etc.

=head2  $feed->load( $source );

This method loads an RSS/RDF/Atom file,
much like C<new()> method does.

=head2  $feed->merge( $source );

This method merges an RSS/RDF/Atom file into the existing $feed
instance. Top-level metadata from the imported feed is incorporated
only if missing from the present feed.

=head2  $string = $feed->to_string( $encoding );

This method generates XML source as string and returns it.  The output
$encoding is optional, and the default encoding is 'UTF-8'.  On Perl
5.8 and later, any encodings supported by the Encode module are
available.  On Perl 5.005 and 5.6.1, only four encodings supported by
the Jcode module are available: 'UTF-8', 'Shift_JIS', 'EUC-JP' and
'ISO-2022-JP'.  'UTF-8' is recommended for overall compatibility.

=head2  $string = $feed->to_string( indent => 4 );

This makes the output more human readable by indenting appropriately.
This does not strictly follow the XML specification but does looks nice.

Note that any other options for C<XML::TreePP> constructor are also
allowed like this. See more detail on L<XML::TreePP>.

=head2  $feed->to_file( $filename, $encoding );

This method generate an XML file.  The output $encoding is optional,
and the default is 'UTF-8'.

=head2  $item = $feed->add_item( $link );

This method creates a new item/entry and returns its instance.
A mandatory $link argument is the URL of the new item/entry.

=head2  $item = $feed->add_item( $srcitem );

This method duplicates an item/entry and adds it to $feed.
$srcitem is a C<XML::FeedPP::*::Item> class's instance
which is returned by C<get_item()> method, as described above.

=head2  $item = $feed->add_item( link => $link, title => $tile, ... );

This method creates an new item/entry
which has C<link>, C<title> elements etc.

=head2  $item = $feed->get_item( $index );

This method returns item(s) in a $feed.
A valid zero-based array $index returns the corresponding item in the feed.
An invalid $index yields undef.
If $index is undefined in array context, it returns an array of all items.
If $index is undefined in scalar context, it returns the number of items.

=head2  @items = $feed->match_item( link => qr/.../, title => qr/.../, ... );

This method finds item(s) which match all regular expressions given.
This method returns an array of all matched items in array context.
This method returns the first matched item in scalar context.

=head2  $feed->remove_item( $index or $link );

This method removes an item/entry specified by zero-based array index or
link URL.

=head2  $feed->clear_item();

This method removes all items/entries from the $feed.

=head2  $feed->sort_item();

This method sorts the order of items in $feed by C<pubDate>.

=head2  $feed->uniq_item();

This method makes items unique. The second and succeeding items
that have the same link URL are removed.

=head2  $feed->normalize();

This method calls both the C<sort_item()> and C<uniq_item()> methods.

=head2  $feed->limit_item( $num );

Removes items in excess of the specified numeric limit. Items at the
end of the list are removed. When preceded by C<sort_item()> or
C<normalize()>, this deletes more recent items.

=head2  $feed->xmlns( "xmlns:media" => "http://search.yahoo.com/mrss" );

Adds an XML namespace at the document root of the feed.

=head2  $url = $feed->xmlns( "xmlns:media" );

Returns the URL of the specified XML namespace.

=head2  @list = $feed->xmlns();

Returns the list of all XML namespaces used in $feed.

=head1  METHODS FOR CHANNEL

=head2  $feed->title( $text );

This method sets/gets the feed's C<title> element,
returning its current value when $title is undefined.

=head2  $feed->description( $html );

This method sets/gets the feed's C<description> element in plain text or HTML,
returning its current value when $html is undefined.
It is mapped to C<content> element for Atom 0.3/1.0.

=head2  $feed->pubDate( $date );

This method sets/gets the feed's C<pubDate> element for RSS,
returning its current value when $date is undefined.
It is mapped to C<dc:date> element for RDF,
C<modified> for Atom 0.3, and C<updated> for Atom 1.0.
See also L</DATE AND TIME FORMATS> section below.

=head2  $feed->copyright( $text );

This method sets/gets the feed's C<copyright> element for RSS,
returning its current value when $text is undefined.
It is mapped to C<dc:rights> element for RDF,
C<copyright> for Atom 0.3, and C<rights> for Atom 1.0.

=head2  $feed->link( $url );

This method sets/gets the URL of the web site as the feed's C<link> element,
returning its current value when the $url is undefined.

=head2  $feed->language( $lang );

This method sets/gets the feed's C<language> element for RSS,
returning its current value when the $lang is undefined.
It is mapped to C<dc:language> element for RDF,
C<feed xml:lang=""> for Atom 0.3/1.0.

=head2  $feed->image( $url, $title, $link, $description, $width, $height )

This method sets/gets the feed's C<image> element and its child nodes,
returning a list of current values when any arguments are undefined.

=head1  METHODS FOR ITEM

=head2  $item->title( $text );

This method sets/gets the item's C<title> element,
returning its current value when the $text is undefined.

=head2  $item->description( $html );

This method sets/gets the item's C<description> element in HTML or plain text,
returning its current value when $text is undefined.
It is mapped to C<content> element for Atom 0.3/1.0.

=head2  $item->pubDate( $date );

This method sets/gets the item's C<pubDate> element,
returning its current value when $date is undefined.
It is mapped to C<dc:date> element for RDF,
C<modified> for Atom 0.3, and C<updated> for Atom 1.0.
See also L</DATE AND TIME FORMATS> section below.

=head2  $item->category( $text );

This method sets/gets the item's C<category> element.
returning its current value when $text is undefined.
It is mapped to C<dc:subject> element for RDF, and ignored for Atom 0.3.

=head2  $item->author( $name );

This method sets/gets the item's C<author> element,
returning its current value when $name is undefined.
It is mapped to C<dc:creator> element for RDF,
C<author> for Atom 0.3/1.0.

=head2  $item->guid( $guid, isPermaLink => $bool );

This method sets/gets the item's C<guid> element,
returning its current value when $guid is undefined.
It is mapped to C<id> element for Atom, and ignored for RDF.
The second argument is optional.

=head2  $item->set( $key => $value, ... );

This method sets customized node values or attributes.
See also L</ACCESSOR AND MUTATORS> section below.

=head2  $value = $item->get( $key );

This method returns the node value or attribute.
See also L</ACCESSOR AND MUTATORS> section below.

=head2  $link = $item->link();

This method returns the item's C<link> element.

=head1  ACCESSOR AND MUTATORS

This module understands only subset of C<rdf:*>, C<dc:*> modules
and RSS/RDF/Atom's default namespaces by itself.
There are NO native methods for any other external modules, such as C<media:*>.
But C<set()> and C<get()> methods are available to get/set
the value of any elements or attributes for these modules.

=head2  $item->set( "module:name" => $value );

This sets the value of the child node:

    <item><module:name>$value</module:name>...</item>

=head2  $item->set( "module:name@attr" => $value );

This sets the value of the child node's attribute:

    <item><module:name attr="$value" />...</item>

=head2  $item->set( "@attr" => $value );

This sets the value of the item's attribute:

    <item attr="$value">...</item>

=head2  $item->set( "hoge/pomu@hare" => $value );

This code sets the value of the child node's child node's attribute:

    <item><hoge><pomu attr="$value" /></hoge>...</item>

=head1  DATE AND TIME FORMATS

C<XML::FeedPP> allows you to describe date/time using any of the three
following formats:

=head2  $date = "Thu, 23 Feb 2006 14:43:43 +0900";

This is the HTTP protocol's preferred format and RSS 2.0's native
format, as defined by RFC 1123.

=head2  $date = "2006-02-23T14:43:43+09:00";

W3CDTF is the native format of RDF, as defined by ISO 8601.

=head2  $date = 1140705823;

The last format is the number of seconds since the epoch,
C<1970-01-01T00:00:00Z>.
You know, this is the native format of Perl's C<time()> function.

=head1 USING MEDIA RSS

To publish Media RSS, add the C<media> namespace then use C<set()>
setter method to manipulate C<media:content> element, etc.

    my $feed = XML::FeedPP::RSS->new();
    $feed->xmlns('xmlns:media' => 'http://search.yahoo.com/mrss/');
    my $item = $feed->add_item('http://www.example.com/index.html');
    $item->set('media:content@url' => 'http://www.example.com/image.jpg');
    $item->set('media:content@type' => 'image/jpeg');
    $item->set('media:content@width' => 640);
    $item->set('media:content@height' => 480);

=head1 MODULE DEPENDENCIES

C<XML::FeedPP> requires only L<XML::TreePP>
which likewise is a pure Perl implementation.
The standard L<LWP::UserAgent> is required
to download feeds from remote web servers.
C<Jcode.pm> is required to convert Japanese encodings on Perl 5.005
and 5.6.1, but is NOT required on Perl 5.8.x and later.

=head1 AUTHOR

Yusuke Kawasaki, http://www.kawa.net/

=head1 COPYRIGHT

The following copyright notice applies to all the files provided in
this distribution, including binary files, unless explicitly noted
otherwise.

Copyright 2006-2011 Yusuke Kawasaki

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# ----------------------------------------------------------------
package XML::FeedPP;
use strict;
use Carp;
use Time::Local;
use XML::TreePP;

use vars qw(
    $VERSION        $RSS20_VERSION  $ATOM03_VERSION
    $XMLNS_RDF      $XMLNS_RSS      $XMLNS_DC       $XMLNS_ATOM03
    $XMLNS_NOCOPY   $TREEPP_OPTIONS $MIME_TYPES
    $FEED_METHODS   $ITEM_METHODS
    $XMLNS_ATOM10
);

$VERSION = "0.43";

$RSS20_VERSION  = '2.0';
$ATOM03_VERSION = '0.3';

$XMLNS_RDF    = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
$XMLNS_RSS    = 'http://purl.org/rss/1.0/';
$XMLNS_DC     = 'http://purl.org/dc/elements/1.1/';
$XMLNS_ATOM03 = 'http://purl.org/atom/ns#';
$XMLNS_ATOM10 = 'http://www.w3.org/2005/Atom';
$XMLNS_NOCOPY = [qw( xmlns xmlns:rdf xmlns:dc xmlns:atom )];

$TREEPP_OPTIONS = {
    force_array => [qw( item rdf:li entry )],
    first_out   => [qw( -xmlns:rdf -xmlns -rel -type url title link )],
    last_out    => [qw( description image item items entry -width -height )],
    user_agent  => "XML-FeedPP/$VERSION ",
};

$MIME_TYPES = { reverse qw(
    image/bmp                       bmp
    image/gif                       gif
    image/jpeg                      jpeg
    image/jpeg                      jpg
    image/png                       png
    image/svg+xml                   svg
    image/x-icon                    ico
    image/x-xbitmap                 xbm
    image/x-xpixmap                 xpm
)};

$FEED_METHODS = [qw(
    title
    description
    language
    copyright
    link
    pubDate
    image
    set
)];

$ITEM_METHODS = [qw(
    title
    description
    category
    author
    link
    guid
    pubDate
    image
    set
)];

sub new {
    my $package = shift;
    my( $init, $source, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);
    Carp::croak "No feed source" unless defined $source;

    my $self  = {};
    bless $self, $package;
    $self->load($source, @rest);

    if ( exists $self->{rss} ) {
        XML::FeedPP::RSS->feed_bless($self);
    }
    elsif ( exists $self->{'rdf:RDF'} ) {
        XML::FeedPP::RDF->feed_bless($self);
    }
    elsif ( exists $self->{feed} ) {
        my $xmlns = $self->{feed}->{-xmlns} if exists $self->{feed}->{-xmlns};
        if ( $xmlns eq $XMLNS_ATOM10 ) {
            XML::FeedPP::Atom::Atom10->feed_bless($self);
        }
        elsif ( $xmlns eq $XMLNS_ATOM03 ) {
            XML::FeedPP::Atom::Atom03->feed_bless($self);
        }
        else {
            XML::FeedPP::Atom->feed_bless($self);
        }
    }
    else {
        my $root = join( " ", sort keys %$self );
        Carp::croak "Invalid feed format: $root";
    }

    $self->validate_feed($source);
    $self->init_feed();
    $self->elements(@$init) if ref $init;
    $self;
}

sub feed_bless {
    my $package = shift;
    my $self    = shift;
    bless $self, $package;
    $self;
}

sub load {
    my $self   = shift;
    my $source = shift;
    my $args   = { @_ };
    my $method = $args->{'-type'};
    Carp::croak "No feed source" unless defined $source;

    if ( ! $method ) {
        if ( $source =~ m#^https?://#s ) {
            $method = 'url';
        }
        elsif ( $source =~ m#(?:\s*\xEF\xBB\xBF)?\s*
                             (<(\?xml|!DOCTYPE|rdf:RDF|rss|feed)\W)#xis ) {
            $method = 'string';
        }
        elsif ( $source !~ /[\r\n]/ && -f $source ) {
            $method = 'file';
        }
        else {
            Carp::croak "Invalid feed source: $source";
        }
    }

    my $opts = { map { $_ => $args->{$_} } grep { ! /^-/ } keys %$args };
    my $tpp = XML::TreePP->new(%$TREEPP_OPTIONS, %$opts);

    my $tree;
    if ( $method eq 'url' ) {
        $tree = $tpp->parsehttp( GET => $source );
    }
    elsif ( $method eq 'string' ) {
        $tree = $tpp->parse($source);
    }
    elsif ( $method eq 'file' ) {
        $tree = $tpp->parsefile($source);
    }
    else {
        Carp::croak "Invalid load type: $method";
    }

    Carp::croak "Loading failed: $source" unless ref $tree;
    %$self = %$tree;    # override myself
    $self;
}

sub to_string {
    my $self = shift;
    my( $args, $encode, @rest ) = XML::FeedPP::Util::param_even_odd(@_);
    $args ||= \@rest;
    my @opts = ( output_encoding => $encode ) if $encode;
    my $tpp = XML::TreePP->new( %$TREEPP_OPTIONS, @opts, @$args );
    $tpp->write( $self, $encode );
}

sub to_file {
    my $self = shift;
    my $file = shift;
    my( $args, $encode, @rest ) = XML::FeedPP::Util::param_even_odd(@_);
    $args ||= \@rest;
    my @opts = ( output_encoding => $encode ) if $encode;
    my $tpp = XML::TreePP->new( %$TREEPP_OPTIONS, @opts, @$args );
    $tpp->writefile( $file, $self, $encode );
}

sub merge {
    my $self   = shift;
    my $source = shift;
    my $target = ref $source ? $source : XML::FeedPP->new($source);
    $self->merge_channel($target);
    $self->merge_item($target);
    $self->normalize();
    $self;
}

sub merge_channel {
    my $self   = shift;
    my $target = shift or return;
    if ( ref $self eq ref $target ) {
        $self->merge_native_channel($target);
    }
    else {
        $self->merge_common_channel($target);
    }
}

sub merge_item {
    my $self   = shift;
    my $target = shift or return;
    foreach my $item ( $target->get_item() ) {
        $self->add_item( $item );
    }
}

sub merge_common_channel {
    my $self   = shift;
    my $target = shift or return;

    my $title1 = $self->title();
    my $title2 = $target->title();
    $self->title($title2) if ( !defined $title1 && defined $title2 );

    my $desc1 = $self->description();
    my $desc2 = $target->description();
    $self->description($desc2) if ( !defined $desc1 && defined $desc2 );

    my $link1 = $self->link();
    my $link2 = $target->link();
    $self->link($link2) if ( !defined $link1 && defined $link2 );

    my $lang1 = $self->language();
    my $lang2 = $target->language();
    $self->language($lang2) if ( !defined $lang1 && defined $lang2 );

    my $right1 = $self->copyright();
    my $right2 = $target->copyright();
    $self->copyright($right2) if ( !defined $right1 && defined $right2 );

    my $pubDate1 = $self->pubDate();
    my $pubDate2 = $target->pubDate();
    $self->pubDate($pubDate2) if ( !defined $pubDate1 && defined $pubDate2 );

    my @image1 = $self->image();
    my @image2 = $target->image();
    $self->image(@image2) if ( !defined $image1[0] && defined $image2[0] );

    my @xmlns1 = $self->xmlns();
    my @xmlns2 = $target->xmlns();
    my $xmlchk = { map { $_ => 1 } @xmlns1, @$XML::FeedPP::XMLNS_NOCOPY };
    foreach my $ns (@xmlns2) {
        next if exists $xmlchk->{$ns};
        $self->xmlns( $ns, $target->xmlns($ns) );
    }

    $self->merge_module_nodes( $self->docroot, $target->docroot );

    $self;
}

sub add_clone_item {
    my $self = shift;
    my $srcitem = shift or return;
    my $link = $srcitem->link() or return;
    my $dstitem = $self->add_item( $link );

    if ( ref $dstitem eq ref $srcitem ) {
        XML::FeedPP::Util::merge_hash( $dstitem, $srcitem );
    }
    else {
#       my $link = $srcitem->link();
#       $dstitem->link($link) if defined $link;

        my $title = $srcitem->title();
        $dstitem->title($title) if defined $title;

        my $description = $srcitem->description();
        $dstitem->description($description) if defined $description;

        my $category = $srcitem->category();
        $dstitem->category($category) if defined $category;

        my $author = $srcitem->author();
        $dstitem->author($author) if defined $author;

        my $guid = $srcitem->guid();
        $dstitem->guid($guid) if defined $guid;

        my $pubDate = $srcitem->pubDate();
        $dstitem->pubDate($pubDate) if defined $pubDate;

        $self->merge_module_nodes( $dstitem, $srcitem );
    }

    $dstitem;
}

sub merge_module_nodes {
    my $self  = shift;
    my $item1 = shift;
    my $item2 = shift;
    foreach my $key ( grep { /:/ } keys %$item2 ) {
        next if ( $key =~ /^-?(dc|rdf|xmlns):/ );

        # deep copy would be better
        $item1->{$key} = $item2->{$key};
    }
}

sub normalize {
    my $self = shift;
    $self->normalize_pubDate();
    $self->sort_item();
    $self->uniq_item();
}

sub normalize_pubDate {
    my $self = shift;
    foreach my $item ( $self->get_item() ) {
        my $date = $item->get_pubDate_native() or next;
        $item->pubDate( $date );
    }
    my $date = $self->get_pubDate_native();
    $self->pubDate( $date ) if $date;
}

sub xmlns {
    my $self = shift;
    my $ns   = shift;
    my $url  = shift;
    my $root = $self->docroot;
    if ( !defined $ns ) {
        my $list = [ grep { /^-xmlns(:\S|$)/ } keys %$root ];
        return map { (/^-(.*)$/)[0] } @$list;
    }
    elsif ( !defined $url ) {
        return unless exists $root->{ '-' . $ns };
        return $root->{ '-' . $ns };
    }
    else {
        $root->{ '-' . $ns } = $url;
    }
}

sub get_pubDate_w3cdtf {
    my $self = shift;
    my $date = $self->get_pubDate_native();
    XML::FeedPP::Util::get_w3cdtf($date);
}

sub get_pubDate_rfc1123 {
    my $self = shift;
    my $date = $self->get_pubDate_native();
    XML::FeedPP::Util::get_rfc1123($date);
}

sub get_pubDate_epoch {
    my $self = shift;
    my $date = $self->get_pubDate_native();
    XML::FeedPP::Util::get_epoch($date);
}

sub call {
    my $self = shift;
    my $name = shift;
    my $class = __PACKAGE__."::Plugin::".$name;
    my $pmfile = $class;
    $pmfile =~ s#::#/#g;
    $pmfile .= ".pm";
    local $@;
    eval {
        require $pmfile;
    } unless defined $class->VERSION;
    Carp::croak "$class failed: $@" if $@;
    return $class->run( $self, @_ );
}

sub elements {
    my $self = shift;
    my $args = [ @_ ];
    my $methods = { map {$_=>1} @$FEED_METHODS };
    while ( my $key = shift @$args ) {
        my $val = shift @$args;
        if ( $methods->{$key} ) {
            $self->$key( $val );
        } else {
            $self->set( $key, $val );
        }
    }
}

sub match_item {
    my $self = shift;
    my @list = $self->get_item();
    return unless scalar @list;
    my $methods = { map {$_=>1} @$ITEM_METHODS };
    my $args = [ @_ ];
    my $out = [];
    foreach my $item ( @list ) {
        my $unmatch = 0;
        my $i = 0;
        while( 1 ) {
            my $key  = $args->[$i++] or last;
            my $test = $args->[$i++];
            my $got  = $methods->{$key} ? $item->$key() : $item->get( $key );
            unless ( $got =~ $test ) {
                $unmatch ++;
                last;
            }
        }
        unless ( $unmatch ) {
            return $item unless wantarray;
            push( @$out, $item );
        }
    }
    @$out;
}

# ----------------------------------------------------------------
package XML::FeedPP::Plugin;
use strict;

sub run {
    my $class = shift;
    my $feed = shift;
    my $ref = ref $class ? ref $class : $class;
    Carp::croak $ref."->run() is not implemented";
}

# ----------------------------------------------------------------
package XML::FeedPP::Item;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Element );

*get_pubDate_w3cdtf  = \&XML::FeedPP::get_pubDate_w3cdtf;   # import
*get_pubDate_rfc1123 = \&XML::FeedPP::get_pubDate_rfc1123;
*get_pubDate_epoch   = \&XML::FeedPP::get_pubDate_epoch;

sub elements {
    my $self = shift;
    my $args = [ @_ ];
    my $methods = { map {$_=>1} @$XML::FeedPP::ITEM_METHODS };
    while ( my $key = shift @$args ) {
        my $val = shift @$args;
        if ( $methods->{$key} ) {
            $self->$key( $val );
        } else {
            $self->set( $key, $val );
        }
    }
}

# ----------------------------------------------------------------
package XML::FeedPP::RSS;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP );

sub new {
    my $package = shift;
    my( $init, $source, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);

    my $self    = {};
    bless $self, $package;
    if ( defined $source ) {
        $self->load($source, @rest);
        $self->validate_feed($source);
    }
    $self->init_feed();
    $self->elements(@$init) if ref $init;
    $self;
}

sub channel_class {
    'XML::FeedPP::RSS::Channel';
}

sub item_class {
    'XML::FeedPP::RSS::Item';
}

sub validate_feed {
    my $self   = shift;
    my $source = shift || $self;
    if ( !ref $self || !ref $self->{rss} ) {
        Carp::croak "Invalid RSS format: $source";
    }
}

sub init_feed {
    my $self = shift or return;

    $self->{rss} ||= {};
    if ( ! UNIVERSAL::isa( $self->{rss}, 'HASH' ) ) {
        Carp::croak "Invalid RSS format: $self->{rss}";
    }
    $self->{rss}->{'-version'} ||= $XML::FeedPP::RSS20_VERSION;

    $self->{rss}->{channel} ||= $self->channel_class->new();
    $self->channel_class->ref_bless( $self->{rss}->{channel} );

    $self->{rss}->{channel}->{item} ||= [];
    if ( UNIVERSAL::isa( $self->{rss}->{channel}->{item}, 'HASH' ) ) {

        # only one item
        $self->{rss}->{channel}->{item} = [ $self->{rss}->{channel}->{item} ];
    }
    foreach my $item ( @{ $self->{rss}->{channel}->{item} } ) {
        $self->item_class->ref_bless($item);
    }

    $self;
}

sub merge_native_channel {
    my $self = shift;
    my $tree = shift or next;

    XML::FeedPP::Util::merge_hash( $self->{rss}, $tree->{rss}, qw( channel ) );
    XML::FeedPP::Util::merge_hash(
        $self->{rss}->{channel},
        $tree->{rss}->{channel},
        qw( item )
    );
}

sub add_item {
    my $self = shift;
    my( $init, $link, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);

    Carp::croak "add_item needs an argument" if ( ! ref $init && ! $link );
    if ( ref $link ) {
        return $self->add_clone_item( $link );
    }

    my $item = XML::FeedPP::RSS::Item->new(@rest);
    $item->link($link) if $link;
    $item->elements(@$init) if ref $init;
    push( @{ $self->{rss}->{channel}->{item} }, $item );
    $item;
}

sub clear_item {
    my $self = shift;
    $self->{rss}->{channel}->{item} = [];
}

sub remove_item {
    my $self   = shift;
    my $remove = shift;
    my $list   = $self->{rss}->{channel}->{item} or return;
    my @deleted;

    if ( $remove =~ /^-?\d+/ ) {
        @deleted = splice( @$list, $remove, 1 );
    }
    else {
        @deleted = grep { $_->link() eq $remove } @$list;
        @$list = grep { $_->link() ne $remove } @$list;
    }

    wantarray ? @deleted : shift @deleted;
}

sub get_item {
    my $self = shift;
    my $num  = shift;
    $self->{rss}->{channel}->{item} ||= [];
    if ( defined $num ) {
        return $self->{rss}->{channel}->{item}->[$num];
    }
    elsif (wantarray) {
        return @{ $self->{rss}->{channel}->{item} };
    }
    else {
        return scalar @{ $self->{rss}->{channel}->{item} };
    }
}

sub sort_item {
    my $self = shift;
    my $list = $self->{rss}->{channel}->{item} or return;
    my $epoch = [ map { $_->get_pubDate_epoch() || 0 } @$list ];
    my $sorted = [ map { $list->[$_] } sort {
        $epoch->[$b] <=> $epoch->[$a]
    } 0 .. $#$list ];
    @$list = @$sorted;
    scalar @$list;
}

sub uniq_item {
    my $self  = shift;
    my $list  = $self->{rss}->{channel}->{item} or return;
    my $check = {};
    my $uniq  = [];
    foreach my $item (@$list) {
        my $link = $item->link();
        push( @$uniq, $item ) unless $check->{$link}++;
    }
    @$list = @$uniq;
    scalar @$list;
}

sub limit_item {
    my $self  = shift;
    my $limit = shift;
    my $list  = $self->{rss}->{channel}->{item} or return;
    if ( $limit > 0 && $limit < scalar @$list ) {
        @$list = splice( @$list, 0, $limit );   # remove from end
    }
    elsif ( $limit < 0 && -$limit < scalar @$list ) {
        @$list = splice( @$list, $limit );      # remove from start
    }
    scalar @$list;
}

sub docroot { shift->{rss}; }
sub channel { shift->{rss}->{channel}; }
sub set     { shift->{rss}->{channel}->set(@_); }
sub get     { shift->{rss}->{channel}->get(@_); }

sub title       { shift->{rss}->{channel}->get_or_set( "title",       @_ ); }
sub description { shift->{rss}->{channel}->get_or_set( "description", @_ ); }
sub link        { shift->{rss}->{channel}->get_or_set( "link",        @_ ); }
sub language    { shift->{rss}->{channel}->get_or_set( "language",    @_ ); }
sub copyright   { shift->{rss}->{channel}->get_or_set( "copyright",   @_ ); }

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_rfc1123($date);
    $self->{rss}->{channel}->set_value( "pubDate", $date );
}

sub get_pubDate_native {
    my $self = shift;
    $self->{rss}->{channel}->get_value("pubDate")       # normal RSS 2.0
    || $self->{rss}->{channel}->get_value("dc:date");   # strange
}

sub image {
    my $self = shift;
    my $url  = shift;
    if ( defined $url ) {
        my ( $title, $link, $desc, $width, $height ) = @_;
        $self->{rss}->{channel}->{image} ||= {};
        my $image = $self->{rss}->{channel}->{image};
        $image->{url}         = $url;
        $image->{title}       = $title if defined $title;
        $image->{link}        = $link if defined $link;
        $image->{description} = $desc if defined $desc;
        $image->{width}       = $width if defined $width;
        $image->{height}      = $height if defined $height;
    }
    elsif ( exists $self->{rss}->{channel}->{image} ) {
        my $image = $self->{rss}->{channel}->{image};
        my $array = [];
        foreach my $key (qw( url title link description width height )) {
            push( @$array, exists $image->{$key} ? $image->{$key} : undef );
        }
        return wantarray ? @$array : shift @$array;
    }
    undef;
}

# ----------------------------------------------------------------
package XML::FeedPP::RSS::Channel;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Element );

# ----------------------------------------------------------------
package XML::FeedPP::RSS::Item;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Item );

sub title       { shift->get_or_set( "title",       @_ ); }
sub description { shift->get_or_set( "description", @_ ); }
sub category    { shift->get_set_array( "category", @_ ); }

sub author {
    my $self = shift;
    if ( scalar @_ ) {
        $self->set_value( 'author', @_ );
    } else {
        $self->get_value('author') || $self->get_value('dc:creator');
    }
}

sub link {
    my $self = shift;
    my $link = shift;
    return $self->get_value("link") unless defined $link;
    $self->guid($link)              unless defined $self->guid();
    $self->set_value( link => $link );
}

sub guid {
    my $self = shift;
    my $guid = shift;
    return $self->get_value("guid") unless defined $guid;
    my @args = @_;
    if ( ! scalar @args ) {
        # default
        @args = ( 'isPermaLink' => 'true' );
    } elsif ( scalar @args == 1 ) {
        # XML::FeedPP 0.36's behavior
        unshift( @args, 'isPermaLink' );
    }
    $self->set_value( guid => $guid, @args );
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_rfc1123($date);
    $self->set_value( "pubDate", $date );
}

sub get_pubDate_native {
    my $self = shift;
    $self->get_value("pubDate")         # normal RSS 2.0
    || $self->get_value("dc:date");     # strange
}

sub image {
    my $self = shift;
    my $url  = shift;
    if ( defined $url ) {
        my ( $title, $link, $desc, $width, $height ) = @_;
        $self->{image} ||= {};
        my $image = $self->{image};
        $image->{url}         = $url;
        $image->{title}       = $title if defined $title;
        $image->{link}        = $link if defined $link;
        $image->{description} = $desc if defined $desc;
        $image->{width}       = $width if defined $width;
        $image->{height}      = $height if defined $height;
    }
    elsif ( exists $self->{image} ) {
        my $image = $self->{image};
        my $array = [];
        foreach my $key (qw( url title link description width height )) {
            push( @$array, exists $image->{$key} ? $image->{$key} : undef );
        }
        return wantarray ? @$array : shift @$array;
    }
    undef;
}

# ----------------------------------------------------------------
package XML::FeedPP::RDF;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP );

sub new {
    my $package = shift;
    my( $init, $source, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);

    my $self    = {};
    bless $self, $package;
    if ( defined $source ) {
        $self->load($source, @rest);
        $self->validate_feed($source);
    }
    $self->init_feed();
    $self->elements(@$init) if ref $init;
    $self;
}

sub channel_class {
    'XML::FeedPP::RDF::Channel';
}

sub item_class {
    'XML::FeedPP::RDF::Item';
}

sub validate_feed {
    my $self   = shift;
    my $source = shift || $self;
    if ( !ref $self || !ref $self->{'rdf:RDF'} ) {
        Carp::croak "Invalid RDF format: $source";
    }
}
sub init_feed {
    my $self = shift or return;

    $self->{'rdf:RDF'} ||= {};
    if ( ! UNIVERSAL::isa( $self->{'rdf:RDF'}, 'HASH' ) ) {
        Carp::croak "Invalid RDF format: $self->{'rdf:RDF'}";
    }
    $self->xmlns( 'xmlns'     => $XML::FeedPP::XMLNS_RSS );
    $self->xmlns( 'xmlns:rdf' => $XML::FeedPP::XMLNS_RDF );
    $self->xmlns( 'xmlns:dc'  => $XML::FeedPP::XMLNS_DC );

    $self->{'rdf:RDF'}->{channel} ||= $self->channel_class->new();
    $self->channel_class->ref_bless( $self->{'rdf:RDF'}->{channel} );

    $self->{'rdf:RDF'}->{channel}->{items}              ||= {};
    $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'} ||= {};

    my $rdfseq = $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'};

    # http://www.kawa.net/works/perl/feedpp/feedpp.html#com-2008-05-17T13:13:33Z
    if ( UNIVERSAL::isa( $rdfseq, 'ARRAY' ) ) {
        my $num1 = scalar @$rdfseq;
        my $num2 = scalar grep { ref $_ && exists $_->{'rdf:li'} && ref $_->{'rdf:li'} } @$rdfseq;
        my $num3 = scalar grep { ref $_ && keys %$_ == 1 } @$rdfseq;
        if ( $num1 && $num1 == $num2 && $num1 == $num3 ) {
            my $newli = [ map { @{$_->{'rdf:li'}} } @$rdfseq ];
            $rdfseq = { 'rdf:li' => $newli };
            $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'} = $rdfseq;
        }
    }

    $rdfseq->{'rdf:li'} ||= [];
    if ( UNIVERSAL::isa( $rdfseq->{'rdf:li'}, 'HASH' ) ) {
        $rdfseq->{'rdf:li'} = [ $rdfseq->{'rdf:li'} ];
    }
    $self->{'rdf:RDF'}->{item} ||= [];
    if ( UNIVERSAL::isa( $self->{'rdf:RDF'}->{item}, 'HASH' ) ) {

        # force array when only one item exist
        $self->{'rdf:RDF'}->{item} = [ $self->{'rdf:RDF'}->{item} ];
    }
    foreach my $item ( @{ $self->{'rdf:RDF'}->{item} } ) {
        $self->item_class->ref_bless($item);
    }

    $self;
}

sub merge_native_channel {
    my $self = shift;
    my $tree = shift or next;

    XML::FeedPP::Util::merge_hash( $self->{'rdf:RDF'}, $tree->{'rdf:RDF'},
        qw( channel item ) );
    XML::FeedPP::Util::merge_hash(
        $self->{'rdf:RDF'}->{channel},
        $tree->{'rdf:RDF'}->{channel},
        qw( items )
    );
}

sub add_item {
    my $self = shift;
    my( $init, $link, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);

    Carp::croak "add_item needs an argument" if ( ! ref $init && ! $link );
    if ( ref $link ) {
        return $self->add_clone_item( $link );
    }

    my $rdfli = $self->item_class->new();
    $rdfli->{'-rdf:resource'} = $link;
    $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'}->{'rdf:li'} ||= [];
    push(
        @{ $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'}->{'rdf:li'} },
        $rdfli
    );

    my $item = XML::FeedPP::RDF::Item->new(@rest);
    $item->link($link) if $link;
    $item->elements(@$init) if ref $init;
    push( @{ $self->{'rdf:RDF'}->{item} }, $item );

    $item;
}

sub clear_item {
    my $self = shift;
    $self->{'rdf:RDF'}->{item} = [];
    $self->__refresh_items();
}

sub remove_item {
    my $self   = shift;
    my $remove = shift;
    my $list   = $self->{'rdf:RDF'}->{item} or return;
    my @deleted;

    if ( $remove =~ /^-?\d+/ ) {
        @deleted = splice( @$list, $remove, 1 );
    }
    else {
        @deleted = grep { $_->link() eq $remove } @$list;
        @$list = grep { $_->link() ne $remove } @$list;
    }

    $self->__refresh_items();

    wantarray ? @deleted : shift @deleted;
}

sub get_item {
    my $self = shift;
    my $num  = shift;
    $self->{'rdf:RDF'}->{item} ||= [];
    if ( defined $num ) {
        return $self->{'rdf:RDF'}->{item}->[$num];
    }
    elsif (wantarray) {
        return @{ $self->{'rdf:RDF'}->{item} };
    }
    else {
        return scalar @{ $self->{'rdf:RDF'}->{item} };
    }
}

sub sort_item {
    my $self = shift;
    my $list = $self->{'rdf:RDF'}->{item} or return;
    my $epoch = [ map { $_->get_pubDate_epoch() || 0 } @$list ];
    my $sorted = [ map { $list->[$_] } sort {
        $epoch->[$b] <=> $epoch->[$a]
    } 0 .. $#$list ];
    @$list = @$sorted;
    $self->__refresh_items();
}

sub uniq_item {
    my $self  = shift;
    my $list  = $self->{'rdf:RDF'}->{item} or return;
    my $check = {};
    my $uniq  = [];
    foreach my $item (@$list) {
        my $link = $item->link();
        push( @$uniq, $item ) unless $check->{$link}++;
    }
    $self->{'rdf:RDF'}->{item} = $uniq;
    $self->__refresh_items();
}

sub limit_item {
    my $self  = shift;
    my $limit = shift;
    my $list  = $self->{'rdf:RDF'}->{item} or return;
    if ( $limit > 0 && $limit < scalar @$list ) {
        @$list = splice( @$list, 0, $limit );   # remove from end
    }
    elsif ( $limit < 0 && -$limit < scalar @$list ) {
        @$list = splice( @$list, $limit );      # remove from start
    }
    $self->__refresh_items();
}

sub __refresh_items {
    my $self = shift;
    my $list = $self->{'rdf:RDF'}->{item} or return;
    $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'}->{'rdf:li'} = [];
    my $dest = $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'}->{'rdf:li'};
    foreach my $item (@$list) {
        my $rdfli = XML::FeedPP::Element->new();
        $rdfli->{'-rdf:resource'} = $item->link();
        push( @$dest, $rdfli );
    }
    scalar @$dest;
}

sub docroot { shift->{'rdf:RDF'}; }
sub channel { shift->{'rdf:RDF'}->{channel}; }
sub set     { shift->{'rdf:RDF'}->{channel}->set(@_); }
sub get     { shift->{'rdf:RDF'}->{channel}->get(@_); }
sub title       { shift->{'rdf:RDF'}->{channel}->get_or_set( "title", @_ ); }
sub description { shift->{'rdf:RDF'}->{channel}->get_or_set( "description", @_ ); }
sub language    { shift->{'rdf:RDF'}->{channel}->get_or_set( "dc:language", @_ ); }
sub copyright   { shift->{'rdf:RDF'}->{channel}->get_or_set( "dc:rights", @_ ); }

sub link {
    my $self = shift;
    my $link = shift;
    return $self->{'rdf:RDF'}->{channel}->get_value("link")
      unless defined $link;
    $self->{'rdf:RDF'}->{channel}->{'-rdf:about'} = $link;
    $self->{'rdf:RDF'}->{channel}->set_value( "link", $link, @_ );
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf($date);
    $self->{'rdf:RDF'}->{channel}->set_value( "dc:date", $date );
}

sub get_pubDate_native {
    shift->{'rdf:RDF'}->{channel}->get_value("dc:date");
}

*get_pubDate_w3cdtf = \&get_pubDate_native;

sub image {
    my $self = shift;
    my $url  = shift;
    if ( defined $url ) {
        my ( $title, $link ) = @_;
        $self->{'rdf:RDF'}->{channel}->{image} ||= {};
        $self->{'rdf:RDF'}->{channel}->{image}->{'-rdf:resource'} = $url;
        $self->{'rdf:RDF'}->{image} ||= {};
        $self->{'rdf:RDF'}->{image}->{'-rdf:about'} = $url; # fix
        my $image = $self->{'rdf:RDF'}->{image};
        $image->{url}   = $url;
        $image->{title} = $title if defined $title;
        $image->{link}  = $link if defined $link;
    }
    elsif ( exists $self->{'rdf:RDF'}->{image} ) {
        my $image = $self->{'rdf:RDF'}->{image};
        my $array = [];
        foreach my $key (qw( url title link )) {
            push( @$array, exists $image->{$key} ? $image->{$key} : undef );
        }
        return wantarray ? @$array : shift @$array;
    }
    elsif ( exists $self->{'rdf:RDF'}->{channel}->{image} ) {
        return $self->{'rdf:RDF'}->{channel}->{image}->{'-rdf:resource'};
    }
    undef;
}

# ----------------------------------------------------------------
package XML::FeedPP::RDF::Channel;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Element );

# ----------------------------------------------------------------
package XML::FeedPP::RDF::Item;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Item );

sub title       { shift->get_or_set( "title",       @_ ); }
sub description { shift->get_or_set( "description", @_ ); }
sub category    { shift->get_set_array( "dc:subject",  @_ ); }
sub guid { undef; }    # this element is NOT supported for RDF

sub author {
    my $self   = shift;
    my $author = shift;
    return $self->get_value('dc:creator')
        || $self->get_value('creator') unless defined $author;
    $self->set_value( 'dc:creator' => $author );
}

sub link {
    my $self = shift;
    my $link = shift;
    return $self->get_value("link") unless defined $link;
    $self->{'-rdf:about'} = $link;
    $self->set_value( "link", $link, @_ );
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf($date);
    $self->set_value( "dc:date", $date );
}

sub get_pubDate_native {
    shift->get_value("dc:date");
}

*get_pubDate_w3cdtf = \&get_pubDate_native;

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Common;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP );

sub new {
    my $package = shift;
    my( $init, $source, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);

    my $self    = {};
    bless $self, $package;
    if ( defined $source ) {
        $self->load($source, @rest);
        $self->validate_feed($source);
    }
    $self->init_feed();
    $self->elements(@$init) if ref $init;
    $self;
}

sub validate_feed {
    my $self   = shift;
    my $source = shift || $self;
    if ( !ref $self || !ref $self->{feed} ) {
        Carp::croak "Invalid Atom format: $source";
    }
}

sub merge_native_channel {
    my $self = shift;
    my $tree = shift or next;

    XML::FeedPP::Util::merge_hash( $self->{feed}, $tree->{feed}, qw( entry ) );
}

sub add_item {
    my $self = shift;
    my( $init, $link, @rest ) = &XML::FeedPP::Util::param_even_odd(@_);

    Carp::croak "add_item needs an argument" if ( ! ref $init && ! $link );
    if ( ref $link ) {
        return $self->add_clone_item( $link );
    }

    my $item = $self->item_class->new(@rest);
    $item->link($link) if $link;
    $item->elements(@$init) if ref $init;
    push( @{ $self->{feed}->{entry} }, $item );

    $item;
}

sub clear_item {
    my $self = shift;
    $self->{feed}->{entry} = [];
}

sub remove_item {
    my $self   = shift;
    my $remove = shift;
    my $list   = $self->{feed}->{entry} or return;
    my @deleted;

    if ( $remove =~ /^-?\d+/ ) {
        @deleted = splice( @$list, $remove, 1 );
    }
    else {
        @deleted = grep { $_->link() eq $remove } @$list;
        @$list = grep { $_->link() ne $remove } @$list;
    }

    wantarray ? @deleted : shift @deleted;
}

sub get_item {
    my $self = shift;
    my $num  = shift;
    $self->{feed}->{entry} ||= [];
    if ( defined $num ) {
        return $self->{feed}->{entry}->[$num];
    }
    elsif (wantarray) {
        return @{ $self->{feed}->{entry} };
    }
    else {
        return scalar @{ $self->{feed}->{entry} };
    }
}

sub sort_item {
    my $self = shift;
    my $list = $self->{feed}->{entry} or return;
    my $epoch = [ map { $_->get_pubDate_epoch() || 0 } @$list ];
    my $sorted = [ map { $list->[$_] } sort {
        $epoch->[$b] <=> $epoch->[$a]
    } 0 .. $#$list ];
    @$list = @$sorted;
    scalar @$list;
}

sub uniq_item {
    my $self  = shift;
    my $list  = $self->{feed}->{entry} or return;
    my $check = {};
    my $uniq  = [];
    foreach my $item (@$list) {
        my $link = $item->link();
        push( @$uniq, $item ) unless $check->{$link}++;
    }
    @$list = @$uniq;
}

sub limit_item {
    my $self  = shift;
    my $limit = shift;
    my $list  = $self->{feed}->{entry} or return;
    if ( $limit > 0 && $limit < scalar @$list ) {
        @$list = splice( @$list, 0, $limit );   # remove from end
    }
    elsif ( $limit < 0 && -$limit < scalar @$list ) {
        @$list = splice( @$list, $limit );      # remove from start
    }
    scalar @$list;
}

sub docroot { shift->{feed}; }
sub channel { shift->{feed}; }
sub set     { shift->{feed}->set(@_); }
sub get     { shift->{feed}->get(@_); }

sub language {
    my $self = shift;
    my $lang = shift;
    return $self->{feed}->{'-xml:lang'} unless defined $lang;
    $self->{feed}->{'-xml:lang'} = $lang;
}

sub image {
    my $self = shift;
    my $href = shift;
    my $title = shift;

    my $link = $self->{feed}->{link} || [];
    $link = [$link] if UNIVERSAL::isa( $link, 'HASH' );
    my $icon = (
        grep {
               ref $_
            && exists $_->{'-rel'}
            && ($_->{'-rel'} eq "icon" )
        } @$link
    )[0];

    my $rext = join( "|", map {"\Q$_\E"} keys %$XML::FeedPP::MIME_TYPES );

    if ( defined $href ) {
        my $ext = ( $href =~ m#[^/]\.($rext)(\W|$)#i )[0];
        my $type = $XML::FeedPP::MIME_TYPES->{$ext} if $ext;

        if ( ref $icon ) {
            $icon->{'-href'}  = $href;
            $icon->{'-type'}  = $type if $type;
            $icon->{'-title'} = $title if $title;
        }
        else {
            my $newicon = {};
            $newicon->{'-rel'}   = 'icon';
            $newicon->{'-href'}  = $href;
            $newicon->{'-type'}  = $type if $type;
            $newicon->{'-title'} = $title if $title;
            my $flink = $self->{feed}->{link};
            if ( UNIVERSAL::isa( $flink, 'ARRAY' )) {
                push( @$flink, $newicon );
            }
            elsif ( UNIVERSAL::isa( $flink, 'HASH' )) {
                $self->{feed}->{link} = [ $flink, $newicon ];
            }
            else {
                $self->{feed}->{link} = [ $newicon ];
            }
        }
    }
    elsif ( ref $icon ) {
        my $array = [ $icon->{'-href'} ];
        push( @$array, $icon->{'-title'} ) if exists $icon->{'-title'};
        return wantarray ? @$array : shift @$array;
    }
    undef;
}

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Atom03;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Common );

sub channel_class {
    'XML::FeedPP::Atom::Atom03::Feed';
}

sub item_class {
    'XML::FeedPP::Atom::Atom03::Entry';
}

sub init_feed {
    my $self = shift or return;

    $self->{feed} ||= $self->channel_class->new();
    $self->channel_class->ref_bless( $self->{feed} );

    if ( ! UNIVERSAL::isa( $self->{feed}, 'HASH' ) ) {
        Carp::croak "Invalid Atom 0.3 format: $self->{feed}";
    }

    $self->xmlns( 'xmlns' => $XML::FeedPP::XMLNS_ATOM03 );
    $self->{feed}->{'-version'} ||= $XML::FeedPP::ATOM03_VERSION;

    $self->{feed}->{entry} ||= [];
    if ( UNIVERSAL::isa( $self->{feed}->{entry}, 'HASH' ) ) {
        # if this feed has only one item
        $self->{feed}->{entry} = [ $self->{feed}->{entry} ];
    }
    foreach my $item ( @{ $self->{feed}->{entry} } ) {
        $self->item_class->ref_bless($item);
    }
    $self->{feed}->{author} ||= { name => '' };    # dummy for validation
    $self;
}

sub title {
    my $self  = shift;
    my $title = shift;
    return $self->{feed}->get_value('title') unless defined $title;
    $self->{feed}->set_value( 'title' => $title, type => 'text/plain' );
}

sub description {
    my $self = shift;
    my $desc = shift;
    return $self->{feed}->get_value('tagline')
        || $self->{feed}->get_value('subtitle') unless defined $desc;
    $self->{feed}->set_value( 'tagline' => $desc, type => 'text/html', mode => 'escaped' );
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf($date);
    $self->{feed}->set_value( 'modified', $date );
}

sub get_pubDate_native {
    my $self = shift;
    $self->{feed}->get_value('modified')        # Atom 0.3
    || $self->{feed}->get_value('updated');     # Atom 1.0
}

*get_pubDate_w3cdtf = \&get_pubDate_native;

sub copyright {
    my $self = shift;
    my $copy = shift;
    return $self->{feed}->get_value('copyright')
        || $self->{feed}->get_value('rights') unless defined $copy;
    $self->{feed}->set_value( 'copyright' => $copy );
}

sub link {
    my $self = shift;
    my $href = shift;

    my $link = $self->{feed}->{link} || [];
    $link = [$link] if UNIVERSAL::isa( $link, 'HASH' );
    $link = [ grep { ref $_ } @$link ];
    $link = [ grep {
        ! exists $_->{'-rel'} || $_->{'-rel'} eq 'alternate'
    } @$link ];
    $link = [ grep {
        ! exists $_->{'-type'} || $_->{'-type'} =~ m#^text/(x-)?html#i
    } @$link ];
    my $html = shift @$link;

    if ( defined $href ) {
        if ( ref $html ) {
            $html->{'-href'} = $href;
        }
        else {
            my $hash = {
                -rel    =>  'alternate',
                -type   =>  'text/html',
                -href   =>  $href,
            };
            my $flink = $self->{feed}->{link};
            if ( ! ref $flink ) {
                $self->{feed}->{link} = [ $hash ];
            }
            elsif ( UNIVERSAL::isa( $flink, 'ARRAY' )) {
                push( @$flink, $hash );
            }
            elsif ( UNIVERSAL::isa( $flink, 'HASH' )) {
                $self->{feed}->{link} = [ $flink, $hash ];
            }
        }
    }
    elsif ( ref $html ) {
        return $html->{'-href'};
    }
    return;
}

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Atom10;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Common );

sub channel_class {
    'XML::FeedPP::Atom::Atom10::Feed';
}

sub item_class {
    'XML::FeedPP::Atom::Atom10::Entry';
}

sub init_feed {
    my $self = shift or return;

    $self->{feed} ||= $self->channel_class->new();
    $self->channel_class->ref_bless( $self->{feed} );

    if ( ! UNIVERSAL::isa( $self->{feed}, 'HASH' ) ) {
        Carp::croak "Invalid Atom 1.0 format: $self->{feed}";
    }

    $self->xmlns( 'xmlns' => $XML::FeedPP::XMLNS_ATOM10 );
#   $self->{feed}->{'-version'} ||= $XML::FeedPP::ATOM10_VERSION;

    $self->{feed}->{entry} ||= [];
    if ( UNIVERSAL::isa( $self->{feed}->{entry}, 'HASH' ) ) {
        # if this feed has only one item
        $self->{feed}->{entry} = [ $self->{feed}->{entry} ];
    }
    foreach my $item ( @{ $self->{feed}->{entry} } ) {
        $self->item_class->ref_bless($item);
    }
#   $self->{feed}->{author} ||= { name => '' };    # dummy for validation
    $self;
}

sub title {
    my $self  = shift;
    my $title = shift;
    return $self->{feed}->get_value('title') unless defined $title;
    $self->{feed}->set_value( 'title' => $title, @_ );
}

sub description {
    my $self = shift;
    my $desc = shift;
    return $self->{feed}->get_value('content')
        || $self->{feed}->get_value('summary')
        || $self->{feed}->get_value('subtitle')
        || $self->{feed}->get_value('tagline') unless defined $desc;
    $self->{feed}->set_value( 'content' => $desc, @_ );     # type => 'text'
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf($date);
    $self->{feed}->set_value( 'updated', $date );
}

sub get_pubDate_native {
    my $self = shift;
    $self->{feed}->get_value('updated')         # Atom 1.0
    || $self->{feed}->get_value('modified')     # Atom 0.3
}

*get_pubDate_w3cdtf = \&get_pubDate_native;

sub copyright {
    my $self = shift;
    my $copy = shift;
    return $self->{feed}->get_value('rights')
        || $self->{feed}->get_value('copyright') unless defined $copy;
    $self->{feed}->set_value( 'rights' => $copy );
}

sub link {
    my $self = shift;
    my $href = shift;

    my $link = $self->{feed}->{link} || [];
    $link = [$link] if UNIVERSAL::isa( $link, 'HASH' );
    $link = [ grep { ref $_ } @$link ];
    $link = [ grep {
        ! exists $_->{'-rel'} || $_->{'-rel'} eq 'alternate'
    } @$link ];
    my $html = shift @$link;

    if ( defined $href ) {
        if ( ref $html ) {
            $html->{'-href'} = $href;
        }
        else {
            my $hash = {
                -rel    =>  'alternate',
                -href   =>  $href,
            };
            my $flink = $self->{feed}->{link};
            if ( ! ref $flink ) {
                $self->{feed}->{link} = [ $hash ];
            }
            elsif ( UNIVERSAL::isa( $flink, 'ARRAY' )) {
                push( @$flink, $hash );
            }
            elsif ( UNIVERSAL::isa( $flink, 'HASH' )) {
                $self->{feed}->{link} = [ $flink, $hash ];
            }
        }
    }
    elsif ( ref $html ) {
        return $html->{'-href'};
    }
    return;
}

# ----------------------------------------------------------------
package XML::FeedPP::Atom;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Atom03 );

# @ISA = qw( XML::FeedPP::Atom::Atom10 );   # if Atom 1.0 for default

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Common::Feed;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Element );

# <content type="xhtml"><div>...</div></content>
# http://www.ietf.org/rfc/rfc4287.txt
# 3. If the value of "type" is "xhtml", the content of atom:content
#    MUST be a single XHTML div element [XHTML] and SHOULD be suitable
#    for handling as XHTML. The XHTML div element itself MUST NOT be
#    considered part of the content.

sub _fetch_value {
    my $self  = shift;
    my $value = shift;

    if ( UNIVERSAL::isa( $value, 'HASH' )
        && exists $value->{'-type'}
        && ($value->{'-type'} eq "xhtml")) {
        my $child = [ grep { /^[^\-\#]/ } keys %$value ];
        if (scalar @$child == 1) {
            my $div = shift @$child;
            if ($div =~ /^([^:]+:)?div$/i) {
                return $value->{$div};
            }
        }
    }

    $self->SUPER::_fetch_value($value);
}

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Atom03::Feed;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Common::Feed );

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Atom10::Feed;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Common::Feed );

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Common::Entry;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Item );

sub author {
    my $self = shift;
    my $name = shift;
    unless ( defined $name ) {
        my $author = $self->{author}->{name} if ref $self->{author};
        return $author;
    }
    my $author = ref $name ? $name : { name => $name };
    $self->{author} = $author;
}

sub guid { shift->get_or_set( 'id', @_ ); }

*_fetch_value = \&XML::FeedPP::Atom::Common::Feed::_fetch_value;

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Atom03::Entry;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Common::Entry );

sub description {
    my $self = shift;
    my $desc = shift;
    return $self->get_value('content')
        || $self->get_value('summary') unless defined $desc;
    $self->set_value(
        'content' => $desc,
        type      => 'text/html',
        mode      => 'escaped'
    );
}

sub link {
    my $self = shift;
    my $href = shift;

    my $link = $self->{link} || [];
    $link = [$link] if UNIVERSAL::isa( $link, 'HASH' );
    $link = [ grep { ref $_ } @$link ];
    $link = [ grep {
        ! exists $_->{'-rel'} || $_->{'-rel'} eq 'alternate'
    } @$link ];
    $link = [ grep {
        ! exists $_->{'-type'} || $_->{'-type'} =~ m#^text/(x-)?html#i
    } @$link ];
    my $html = shift @$link;

    if ( defined $href ) {
        if ( ref $html ) {
            $html->{'-href'} = $href;
        }
        else {
            my $hash = {
                -rel    =>  'alternate',
                -type   =>  'text/html',
                -href   =>  $href,
            };
            my $flink = $self->{link};
            if ( ! ref $flink ) {
                $self->{link} = [ $hash ];
            }
            elsif ( ref $flink && UNIVERSAL::isa( $flink, 'ARRAY' )) {
                push( @$flink, $hash );
            }
            elsif ( ref $flink && UNIVERSAL::isa( $flink, 'HASH' )) {
                $self->{link} = [ $flink, $hash ];
            }
        }
        $self->guid( $href ) unless defined $self->guid();
    }
    elsif ( ref $html ) {
        return $html->{'-href'};
    }
    return;
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf($date);
    $self->set_value( 'issued',   $date );
    $self->set_value( 'modified', $date );
}

sub get_pubDate_native {
    my $self = shift;
    $self->get_value('modified')        # Atom 0.3
    || $self->get_value('issued')       # Atom 0.3
    || $self->get_value('updated')      # Atom 1.0
    || $self->get_value('published');   # Atom 1.0
}

*get_pubDate_w3cdtf = \&get_pubDate_native;

sub title {
    my $self  = shift;
    my $title = shift;
    return $self->get_value('title') unless defined $title;
    $self->set_value( 'title' => $title, type => 'text/plain' );
}

sub category { undef; }    # this element is NOT supported for Atom 0.3

# ----------------------------------------------------------------
package XML::FeedPP::Atom::Atom10::Entry;
use strict;
use vars qw( @ISA );
@ISA = qw( XML::FeedPP::Atom::Common::Entry );

sub description {
    my $self = shift;
    my $desc = shift;
    return $self->get_value('content')
        || $self->get_value('summary') unless defined $desc;
    $self->set_value( 'content' => $desc, @_ );
}

sub link {
    my $self = shift;
    my $href = shift;

    my $link = $self->{link} || [];
    $link = [$link] if UNIVERSAL::isa( $link, 'HASH' );
    $link = [ grep { ref $_ } @$link ];
    $link = [ grep {
        ! exists $_->{'-rel'} || $_->{'-rel'} eq 'alternate'
    } @$link ];
    my $html = shift @$link;

    if ( defined $href ) {
        if ( ref $html ) {
            $html->{'-href'} = $href;
        }
        else {
            my $hash = {
#               -rel    =>  'alternate',
                -href   =>  $href,
            };
            my $flink = $self->{link};
            if ( ! ref $flink ) {
                $self->{link} = [ $hash ];
            }
            elsif ( ref $flink && UNIVERSAL::isa( $flink, 'ARRAY' )) {
                push( @$flink, $hash );
            }
            elsif ( ref $flink && UNIVERSAL::isa( $flink, 'HASH' )) {
                $self->{link} = [ $flink, $hash ];
            }
        }
        $self->guid( $href ) unless defined $self->guid();
    }
    elsif ( ref $html ) {
        return $html->{'-href'};
    }
    return;
}

sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_pubDate_w3cdtf() unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf($date);
    $self->set_value( 'updated', $date );
}

sub get_pubDate_native {
    my $self = shift;
    $self->get_value('updated')         # Atom 1.0
    || $self->get_value('published')    # Atom 1.0
    || $self->get_value('issued')       # Atom 0.3
    || $self->get_value('modified');    # Atom 0.3
}

*get_pubDate_w3cdtf = \&get_pubDate_native;

sub title {
    my $self  = shift;
    my $title = shift;
    my $type  = shift || 'text';
    return $self->get_value('title') unless defined $title;
    $self->set_value( 'title' => $title, type => $type );
}

sub category {
    my $self = shift;
    if ( scalar @_ ) {
        my $cate = ref $_[0] ? $_[0] : \@_;
        my $list = [ map {+{-term=>$_}} @$cate ];
        $self->{category} = ( scalar @$list > 1 ) ? $list : shift @$list;
    }
    else {
        return unless exists $self->{category};
        my $list = $self->{category} || [];
        $list = [ $list ] if ( defined $list && ! UNIVERSAL::isa( $list, 'ARRAY' ));
        my $term = [ map {ref $_ && exists $_->{-term} && $_->{-term} } @$list ];
#       return wantarray ? @$term : shift @$term;
        return ( scalar @$term > 1 ) ? $term : shift @$term;
    }
}

# ----------------------------------------------------------------
package XML::FeedPP::Element;
use strict;

sub new {
    my $package = shift;
    my $self    = {@_};
    bless $self, $package;
    $self;
}

sub ref_bless {
    my $package = shift;
    my $self    = shift;
    bless $self, $package;
    $self;
}

sub set {
    my $self = shift;

    while ( scalar @_ ) {
        my $key  = shift @_;
        my $val  = shift @_;
        my $node = $self;
        while ( $key =~ s#^([^/]+)/##s ) {
            my $child = $1;
            if ( ref $node->{$child} ) {
                # ok
            }
            elsif ( defined $node->{$child} ) {
                $node->{$child} = { '#text' => $node->{$child} };
            }
            else {
                $node->{$child} = {};
            }
            $node = $node->{$child};
        }
        my ( $tagname, $attr ) = split( /\@/, $key, 2 );
        if ( $tagname eq "" && defined $attr ) {
            $node->{ '-' . $attr } = $val;
        }
        elsif ( defined $attr ) {
            if ( ref $node->{$tagname} &&
                 UNIVERSAL::isa( $node->{$tagname}, 'ARRAY' )) {
                $node->{$tagname} = shift @{$node->{$tagname}};
            }
            my $hkey = '-' . $attr;
            if ( ref $node->{$tagname} ) {
                $node->{$tagname}->{$hkey} = $val;
            }
            elsif ( defined $node->{$tagname} ) {
                $node->{$tagname} = {
                    '#text' => $node->{$tagname},
                    $hkey   => $val,
                };
            }
            else {
                $node->{$tagname} = { $hkey => $val };
            }
        }
        elsif ( defined $tagname ) {
            if ( ref $node->{$tagname} &&
                 UNIVERSAL::isa( $node->{$tagname}, 'ARRAY' )) {
                $node->{$tagname} = shift @{$node->{$tagname}};
            }
            if ( ref $node->{$tagname} ) {
                $node->{$tagname}->{'#text'} = $val;
            }
            else {
                $node->{$tagname} = $val;
            }
        }
    }
}

sub get {
    my $self = shift;
    my $key  = shift;
    my $node = $self;

    while ( $key =~ s#^([^/]+)/##s ) {
        my $child = $1;
        return unless ref $node;
        return unless exists $node->{$child};
        $node = $node->{$child};
    }
    my ( $tagname, $attr ) = split( /\@/, $key, 2 );
    return unless ref $node;
    # return unless exists $node->{$tagname};
    if ( $tagname eq "" && defined $attr ) {    # @attribute
        return unless exists $node->{ '-' . $attr };
        return $node->{ '-' . $attr };
    }
    elsif ( defined $attr ) {                   # node@attribute
        return unless ref $node->{$tagname};
        my $hkey = '-' . $attr;
        if ( UNIVERSAL::isa( $node->{$tagname}, 'ARRAY' )) {
            my $list = [
                map { ref $_ && exists $_->{$hkey} ? $_->{$hkey} : undef }
                @{$node->{$tagname}} ];
            return @$list if wantarray;
            return ( grep { defined $_ } @$list )[0];
        }
        return unless exists $node->{$tagname}->{$hkey};
        return $node->{$tagname}->{$hkey};
    }
    else {                                      # node
        return $node->{$tagname} unless ref $node->{$tagname};
        if ( UNIVERSAL::isa( $node->{$tagname}, 'ARRAY' )) {
            my $list = [
                map { ref $_ ? $_->{'#text'} : $_ }
                @{$node->{$tagname}} ];
            return @$list if wantarray;
            return ( grep { defined $_ } @$list )[0];
        }
        return $node->{$tagname}->{'#text'};
    }
}

sub get_set_array {
    my $self = shift;
    my $elem = shift;
    my $value = shift;
    if ( ref $value ) {
        $self->{$elem} = $value;
    } elsif ( defined $value ) {
        $value = [ $value, @_ ] if scalar @_;
        $self->{$elem} = $value;
    } else {
        my @ret = $self->get_value($elem);
        return scalar @ret > 1 ? \@ret : $ret[0];
    }
}

sub get_or_set {
    my $self = shift;
    my $elem = shift;
    return scalar @_
      ? $self->set_value( $elem, @_ )
      : $self->get_value($elem);
}

sub get_value {
    my $self = shift;
    my $elem = shift;
    return unless exists $self->{$elem};
    my $value = $self->{$elem};
    return $value unless ref $value;

    # multiple elements
    if ( UNIVERSAL::isa( $value, 'ARRAY' )) {
        if ( wantarray ) {
            return map { $self->_fetch_value($_) } @$value;
        } else {
            return $self->_fetch_value($value->[0]);
        }
    }

    return $self->_fetch_value($value);
}

sub _fetch_value {
    my $self  = shift;
    my $value = shift;

    if ( UNIVERSAL::isa( $value, 'HASH' )) {
        # text node of an element with attributes
        if ( exists $value->{'#text'} ) {
            return $self->_fetch_value($value->{'#text'})
        }
    } elsif ( UNIVERSAL::isa( $value, 'SCALAR' )) {
        # CDATA section as a scalar reference
        return $$value;
    }

    return $value;
}

sub set_value {
    my $self = shift;
    my $elem = shift;
    my $text = shift;
    my $attr = \@_;
    if ( UNIVERSAL::isa( $self->{$elem}, 'HASH' )) {
        $self->{$elem}->{'#text'} = $text;
    }
    else {
        $self->{$elem} = $text;
    }
    $self->set_attr( $elem, @$attr ) if scalar @$attr;
    undef;
}

sub get_attr {
    my $self = shift;
    my $elem = shift;
    my $key  = shift;
    return unless exists $self->{$elem};
    return unless ref $self->{$elem};
    return unless exists $self->{$elem}->{ '-' . $key };
    $self->{$elem}->{ '-' . $key };
}

sub set_attr {
    my $self = shift;
    my $elem = shift;
    my $attr = \@_;
    if ( defined $self->{$elem} ) {
        my $scalar = ref $self->{$elem};
        $scalar = undef if ($scalar eq 'SCALAR');
        if (! $scalar) {
            $self->{$elem} = { '#text' => $self->{$elem} };
        }
    }
    else {
        $self->{$elem} = {};
    }
    while ( scalar @$attr ) {
        my $key = shift @$attr;
        my $val = shift @$attr;
        if ( defined $val ) {
#           $val = $$val if (ref $val eq 'SCALAR');
            $self->{$elem}->{ '-' . $key } = $val;
        }
        else {
            delete $self->{$elem}->{ '-' . $key };
        }
    }
    undef;
}

# ----------------------------------------------------------------
package XML::FeedPP::Util;
use strict;

my ( @DoW, @MoY, %MoY );
@DoW = qw(Sun Mon Tue Wed Thu Fri Sat);
@MoY = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
@MoY{ map { uc($_) } @MoY } = ( 1 .. 12 );
my $tz_now = time();
my $tz_offset = Time::Local::timegm( localtime($tz_now) ) -
                Time::Local::timegm( gmtime($tz_now) );
my $tz_hour = int( $tz_offset / 3600 );
my $tz_min  = int( $tz_offset / 60 ) % 60;
my $rfc1123_regexp = qr{
    ^(?:[A-Za-z]+,\s*)? (\d+)\s+ ([A-Za-z]+)\s+ (\d+)\s+
    (\d+):(\d+)(?::(\d+)(?:\.\d*)?)?\s*
    ([\+\-]\d+:?\d{2} | [ECMP][DS]T )?
}xi;
my $w3cdtf_regexp = qr{
    ^(\d+)-(\d+)-(\d+)
    (?:T(\d+):(\d+)(?::(\d+)(?:\.\d*)?\:?)?\s*
    ([\+\-]\d+:?\d{2})?|$)
}x;
my $tzmap = {qw(
    EDT -4  EST -5  CDT -5  CST -6
    MDT -6  MST -7  PDT -7  PST -8
)};

sub epoch_to_w3cdtf {
    my $epoch = shift;
    return unless defined $epoch;
    my ( $sec, $min, $hour, $day, $mon, $year ) = gmtime($epoch+$tz_offset);
    $year += 1900;
    $mon++;
    my $tz = $tz_offset ? sprintf( '%+03d:%02d', $tz_hour, $tz_min ) : 'Z';
    sprintf( '%04d-%02d-%02dT%02d:%02d:%02d%s',
        $year, $mon, $day, $hour, $min, $sec, $tz );
}

sub epoch_to_rfc1123 {
    my $epoch = shift;
    return unless defined $epoch;
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday ) = gmtime($epoch+$tz_offset);
    $year += 1900;
    my $tz = $tz_offset ? sprintf( '%+03d%02d', $tz_hour, $tz_min ) : 'GMT';
    sprintf( '%s, %02d %s %04d %02d:%02d:%02d %s',
        $DoW[$wday], $mday, $MoY[$mon], $year, $hour, $min, $sec, $tz );
}

sub rfc1123_to_w3cdtf {
    my $str = shift;
    return unless defined $str;
    my ( $mday, $mon, $year, $hour, $min, $sec, $tz ) = ( $str =~ $rfc1123_regexp );
    return unless ( $year && $mon && $mday );
    $year += 2000 if $year < 77;
    $year += 1900 if $year < 100;
    $mon = $MoY{ uc($mon) } or return;
    if ( defined $tz && $tz ne '' && $tz ne 'GMT' ) {
        my $off = &get_tz_offset($tz) / 60;
        $tz = sprintf( '%+03d:%02d', $off/60, $off%60 );
    }
    else {
        $tz = 'Z';
    }
    sprintf( '%04d-%02d-%02dT%02d:%02d:%02d%s',
        $year, $mon, $mday, $hour, $min, $sec, $tz );
}

sub w3cdtf_to_rfc1123 {
    my $str = shift;
    return unless defined $str;
    my ( $year, $mon, $mday, $hour, $min, $sec, $tz ) = ( $str =~ $w3cdtf_regexp );
    return unless ( $year > 1900 && $mon && $mday );
    $hour ||= 0;
    $min ||= 0;
    $sec ||= 0;
    my $epoch = Time::Local::timegm( $sec, $min, $hour, $mday, $mon-1, $year-1900 );
    my $wday = ( gmtime($epoch) )[6];
    if ( defined $tz && $tz ne '' && $tz ne 'Z' ) {
        my $off = &get_tz_offset($tz) / 60;
        $tz = sprintf( '%+03d%02d', $off/60, $off%60 );
    }
    else {
        $tz = 'GMT';
    }
    sprintf(
        '%s, %02d %s %04d %02d:%02d:%02d %s',
        $DoW[$wday], $mday, $MoY[ $mon - 1 ], $year, $hour, $min, $sec, $tz
    );
}

sub rfc1123_to_epoch {
    my $str = shift;
    return unless defined $str;
    my ( $mday, $mon, $year, $hour, $min, $sec, $tz ) = ( $str =~ $rfc1123_regexp );
    return unless ( $year && $mon && $mday );
    $year += 2000 if $year < 77;
    $year += 1900 if $year < 100;
    $mon = $MoY{ uc($mon) } or return;
    my $epoch = Time::Local::timegm( $sec, $min, $hour, $mday, $mon-1, $year-1900 );
    $epoch -= &get_tz_offset( $tz );
    $epoch;
}

sub w3cdtf_to_epoch {
    my $str = shift;
    return unless defined $str;
    my ( $year, $mon, $mday, $hour, $min, $sec, $tz ) = ( $str =~ $w3cdtf_regexp );
    return unless ( $year > 1900 && $mon && $mday );
    $hour ||= 0;
    $min ||= 0;
    $sec ||= 0;
    my $epoch = Time::Local::timegm( $sec, $min, $hour, $mday, $mon-1, $year-1900 );
    $epoch -= &get_tz_offset( $tz );
    $epoch;
}

sub get_tz_offset {
    my $tz = shift;
    return 0 unless defined $tz;
    return $tzmap->{$tz}*60*60 if exists $tzmap->{$tz};
    return 0 unless( $tz =~ m/^([\+\-]?)(\d+):?(\d{2})$/ );
    my( $pm, $ho, $mi ) = ( $1, $2, $3 );
    my $off = $ho * 60 + $mi;
    $off *= ( $pm eq "-" ) ? -60 : 60;
    $off;
}

sub get_w3cdtf {
    my $date = shift;
    return unless defined $date;
    if ( $date =~ /^\d+$/s ) {
        return &epoch_to_w3cdtf($date);
    }
    elsif ( $date =~ $rfc1123_regexp ) {
        return &rfc1123_to_w3cdtf($date);
    }
    elsif ( $date =~ $w3cdtf_regexp ) {
        return $date;
    }
    undef;
}

sub get_rfc1123 {
    my $date = shift;
    return unless defined $date;
    if ( $date =~ /^\d+$/s ) {
        return &epoch_to_rfc1123($date);
    }
    elsif ( $date =~ $rfc1123_regexp ) {
        return $date;
    }
    elsif ( $date =~ $w3cdtf_regexp ) {
        return &w3cdtf_to_rfc1123($date);
    }
    undef;
}

sub get_epoch {
    my $date = shift;
    return unless defined $date;
    if ( $date =~ /^\d+$/s ) {
        return $date;
    }
    elsif ( $date =~ $rfc1123_regexp ) {
        return &rfc1123_to_epoch($date);
    }
    elsif ( $date =~ $w3cdtf_regexp ) {
        return &w3cdtf_to_epoch($date);
    }
    undef;
}

sub merge_hash {
    my $base  = shift or return;
    my $merge = shift or return;
    my $map = { map { $_ => 1 } @_ };
    foreach my $key ( keys %$merge ) {
        next if exists $map->{$key};
        next if exists $base->{$key};
        $base->{$key} = $merge->{$key};
    }
}

sub param_even_odd {
    if ( (scalar @_) % 2 == 0 ) {
        # even num of args - new( key1 => val1, key2 => arg2 );
        my $array = [ @_ ];
        return $array;
    }
    else {
        # odd num of args - new( first, key1 => val1, key2 => arg2 );
        return ( undef, @_ );
    }
}

# ----------------------------------------------------------------
1;
# ----------------------------------------------------------------
