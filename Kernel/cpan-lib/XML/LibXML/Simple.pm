# Copyrights 2008-2016 by [Mark Overmeer].
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 2.02.
package XML::LibXML::Simple;
use vars '$VERSION';
$VERSION = '0.97';

use base 'Exporter';

use strict;
use warnings;

our @EXPORT    = qw(XMLin);
our @EXPORT_OK = qw(xml_in);

use XML::LibXML       ();
use File::Slurp::Tiny qw/read_file/;
use File::Basename    qw/fileparse/;
use File::Spec        ();
use Carp;
use Scalar::Util      qw/blessed/;

use Data::Dumper;  #to be removed


my %known_opts = map +($_ => 1),
  qw(keyattr keeproot forcecontent contentkey noattr searchpath
     forcearray grouptags nsexpand normalisespace normalizespace
     valueattr nsstrip parser parseropts hooknodes);

my @default_attributes  = qw(name key id);
my $default_content_key = 'content';

#-------------

sub new(@)
{   my $class = shift;
    my $self  = bless {}, $class;
    my $opts  = $self->{opts} = $self->_take_opts(@_);

    # parser object cannot be reused
    !defined $opts->{parser}
        or error __x"parser option for XMLin only";

    $self;
}

#-------------

sub XMLin
{   my $self = @_ > 1 && blessed $_[0] && $_[0]->isa(__PACKAGE__) ? shift
      : __PACKAGE__->new;
    my $target = shift;

    my $this = $self->_take_opts(@_);
    my $opts = $self->_init($self->{opts}, $this);

    my $xml  = $self->_get_xml($target, $opts)
        or return;

    if(my $cb = $opts->{hooknodes})
    {   $self->{XCS_hooks} = $cb->($self, $xml);
    }

    my $top  = $self->collapse($xml, $opts);
    if($opts->{keeproot})
    {   my $subtop
          = $opts->{forcearray_always} && ref $top ne 'ARRAY' ? [$top] : $top;
        $top = +{ $xml->localName => $subtop };
    }

    $top;
}
*xml_in = \&XMLin;

sub _get_xml($$)
{   my ($self, $source, $opts) = @_;

    $source    = $self->default_data_source($opts)
        unless defined $source;

    $source    = \*STDIN
        if $source eq '-';

    my $parser = $opts->{parser}
              || $self->_create_parser($opts->{parseropts});

    my $xml
      = blessed $source &&
        (  $source->isa('XML::LibXML::Document')
        || $source->isa('XML::LibXML::Element' )) ? $source
      : ref $source eq 'SCALAR' ? $parser->parse_string($$source)
      : ref $source             ? $parser->parse_fh($source)
      : $source =~ m{^\s*\<.*?\>\s*$}s ? $parser->parse_string($source)
      :    $parser->parse_file
              ($self->find_xml_file($source, @{$opts->{searchpath}}));

    $xml = $xml->documentElement
         if $xml->isa('XML::LibXML::Document');

    $xml;
}

sub _create_parser(@)
{   my $self = shift;
    my @popt = @_ != 1 ? @_ : ref $_[0] eq 'HASH' ? %{$_[0]} : @{$_[0]};

    XML::LibXML->new
      ( line_numbers    => 1
      , no_network      => 1
      , expand_xinclude => 0
      , expand_entities => 1
      , load_ext_dtd    => 0
      , ext_ent_handler =>
           sub { alert __x"parsing external entities disabled"; '' }
      , @popt
      );
}

sub _take_opts(@)
{   my $self = shift;
   
    my %opts;
    @_ % 2==0
        or die "ERROR: odd number of options.\n";

    while(@_)
    {   my ($key, $val) = (shift, shift);
        my $lkey = lc $key;
        $lkey =~ s/_//g;
        $known_opts{$lkey} or croak "Unrecognised option: $key";
        $opts{$lkey} = $val;
    }

    \%opts;
}

# Returns the name of the XML file to parse if no filename or XML string 
# was provided explictly.

sub default_data_source($)
{   my ($self, $opts) = @_;

    my ($basename, $script_dir, $ext) = fileparse $0, qr[\.[^\.]+];

    # Add script directory to searchpath
    unshift @{$opts->{searchpath}}, $script_dir
        if $script_dir;

    "$basename.xml";
}

sub _init($$)
{   my ($self, $global, $this) = @_;
    my %opt = (%$global, %$this);

    if(defined $opt{contentkey})
         { $opt{collapseagain} = $opt{contentkey} =~ s/^\-// }
    else { $opt{contentkey} = $default_content_key }

    $opt{normalisespace} ||= $opt{normalizespace} || 0;

    $opt{searchpath} ||= [];
    ref $opt{searchpath} eq 'ARRAY'
        or $opt{searchpath} = [ $opt{searchpath} ];

    my $fa = delete $opt{forcearray} || 0;
    my (@fa_regex, %fa_elem);
    if(ref $fa)
     {   foreach (ref $fa eq 'ARRAY' ? @$fa : $fa)
         {   if(ref $_ eq 'Regexp') { push @fa_regex, $_ }
             else { $fa_elem{$_} = 1 }
         }
    }
    else { $opt{forcearray_always} = $fa }
    $opt{forcearray_regex} = \@fa_regex;
    $opt{forcearray_elem}  = \%fa_elem;

    # Special cleanup for {keyattr} which could be arrayref or hashref,
    # which behave differently.

    my $ka = $opt{keyattr} || \@default_attributes;
    $ka    = [ $ka ] unless ref $ka;
 
    if(ref $ka eq 'ARRAY')
    {   if(@$ka) { $opt{keyattr} = $ka }
        else { delete $opt{keyattr} }
    }
    elsif(ref $ka eq 'HASH')
    {   # Convert keyattr => { elem => '+attr' }
        # to keyattr => { elem => [ 'attr', '+' ] } 
        my %at;
        while(my($k,$v) = each %$ka)
        {   $v =~ /^(\+|-)?(.*)$/;
            $at{$k} = [ $2, $1 || '' ];
        }
        $opt{keyattr} = \%at;
    }

    # Special cleanup for {valueattr} which could be arrayref or hashref

    my $va = delete $opt{valueattr} || {};
    $va = +{ map +($_ => 1), @$va } if ref $va eq 'ARRAY';
    $opt{valueattrlist} = $va;

    # make sure there's nothing weird in {grouptags}

    !$opt{grouptags} || ref $opt{grouptags} eq 'HASH'
         or croak "Illegal value for 'GroupTags' option -expected a hashref";

    $opt{parseropts} ||= {};

    \%opt;
}

sub find_xml_file($@)
{   my ($self, $file) = (shift, shift);
    my @search_path = @_ ? @_ : '.';

    my ($filename, $filedir) = fileparse $file;

    if($filename eq $file)
    {   foreach my $path (@search_path)
        {   my $fullpath = File::Spec->catfile($path, $file);
            return $fullpath if -e $fullpath;
        }
    }
    elsif(-e $file)        # Ignore searchpath if dir component
    {   return $file;
    }

    local $" = ':';
    die "data source $file not found in @search_path\n";
}

sub _add_kv($$$$)
{   my ($d, $k, $v, $opts) = @_;

    if(defined $d->{$k})
    {   # Combine duplicate attributes into arrayref if required
        if(ref $d->{$k} eq 'ARRAY')   { push @{$d->{$k}}, $v }
        else                          { $d->{$k} = [ $d->{$k}, $v ] } }
    elsif(ref $v eq 'ARRAY')          { push @{$d->{$k}}, $v }
    elsif(ref $v eq 'HASH'
       && $k ne $opts->{contentkey} 
       && $opts->{forcearray_always}) { push @{$d->{$k}}, $v }
    elsif($opts->{forcearray_elem}{$k}
        || grep $k =~ $_, @{$opts->{forcearray_regex}}
         )                            { push @{$d->{$k}}, $v }
    else                              { $d->{$k} = $v }
    $d->{$k};
}

# Takes the parse tree that XML::LibXML::Parser produced from the supplied
# XML and recurse through it 'collapsing' unnecessary levels of indirection
# (nested arrays etc) to produce a data structure that is easier to work with.

sub _expand_name($)
{   my $node = shift;
    my $uri  = $node->namespaceURI || '';
    (length $uri ? "{$uri}" : '') . $node->localName;
}

sub collapse($$)
{   my ($self, $xml, $opts) = @_;
    $xml->isa('XML::LibXML::Element') or return;

    my (%data, $text);
    my $hooks = $self->{XCS_hooks};

    unless($opts->{noattr})
    {
      ATTR:
        foreach my $attr ($xml->attributes)
        {
            my $value;
            if($hooks && (my $hook = $hooks->{$attr->unique_key}))
            {   $value = $hook->($attr);
                defined $value or next ATTR;
            }
            else
            {   $value = $attr->value;
            }

            $value = $self->normalise_space($value)
                if !ref $value && $opts->{normalisespace}==2;

            my $name
              = !$attr->isa('XML::LibXML::Attr') ? $attr->nodeName
              : $opts->{nsexpand} ? _expand_name($attr)
              : $opts->{nsstrip}  ? $attr->localName
              :                     $attr->nodeName;

            _add_kv \%data, $name => $value, $opts;
        }
    }
    my $nr_attrs = keys %data;
    my $nr_elems = 0;

  CHILD:
    foreach my $child ($xml->childNodes)
    {
        if($child->isa('XML::LibXML::Text'))
        {   $text .= $child->data;
            next CHILD;
        }

        $child->isa('XML::LibXML::Element')
            or next CHILD;

        $nr_elems++;

        my $v;
        if($hooks && (my $hook = $hooks->{$child->unique_key}))
             { $v = $hook->($child) }
        else { $v = $self->collapse($child, $opts) }
        defined $v or next CHILD;

        my $name
          = $opts->{nsexpand} ? _expand_name($child)
          : $opts->{nsstrip}  ? $child->localName
          :                     $child->nodeName;

        _add_kv \%data, $name => $v, $opts;
    }

    $text = $self->normalise_space($text)
        if defined $text && $opts->{normalisespace}==2;

    return $opts->{forcecontent} ? { $opts->{contentkey} => $text } : $text
        if $nr_attrs+$nr_elems==0 && defined $text;

    $data{$opts->{contentkey}} = $text
        if defined $text && $nr_elems==0;

    # Roll up 'value' attributes (but only if no nested elements)

    if(keys %data==1)
    {   my ($k) = keys %data;
        return $data{$k} if $opts->{valueattrlist}{$k};
    }

    # Turn arrayrefs into hashrefs if key fields present

    if($opts->{keyattr})
    {   while(my ($key, $val) = each %data)
        {   $data{$key} = $self->array_to_hash($key, $val, $opts)
                if ref $val eq 'ARRAY';
        }
    }

    # disintermediate grouped tags

    if(my $gr = $opts->{grouptags})
    {
      ELEMENT:
        while(my ($key, $val) = each %data)
        {   my $sub = $gr->{$key} or next;
            if(ref $val eq 'ARRAY')
            {   next ELEMENT
                    if grep { keys %$_!=1 || !exists $_->{$sub} } @$val;
                $data{$key} = { map { %{$_->{$sub}} } @$val };
            }
            else
            {   ref $val eq 'HASH' && keys %$val==1 or next;
                my ($child_key, $child_val) = %$val;
                $data{$key} = $child_val
                   if $gr->{$key} eq $child_key;
            }
        }
    }

    # Fold hashes containing a single anonymous array up into just the array
    return $data{anon}
        if keys %data == 1
        && exists $data{anon}
        && ref $data{anon} eq 'ARRAY';

    # Roll up named elements with named nested 'value' attributes
    if(my $va = $opts->{valueattrlist})
    {   while(my($key, $val) = each %data)
        {   $va->{$key} && ref $val eq 'HASH' && keys %$val==1 or next;
            $data{$key} = $val->{$va->{$key}};
        }
    }

      $nr_elems+$nr_attrs    ? \%data
    : !defined $text         ? {}
    : $opts->{forcecontent}  ? { $opts->{contentkey} => $text }
    :                          $text;
}

sub normalise_space($)
{   my $self = shift;
    local $_ = shift;
    s/^\s+//s;
    s/\s+$//s;
    s/\s\s+/ /sg;
    $_;
}

# Attempts to 'fold' an array of hashes into an hash of hashes.  Returns a
# reference to the hash on success or the original array if folding is
# not possible.  Behaviour is controlled by 'keyattr' option.
#

sub array_to_hash($$$$)
{   my ($self, $name, $in, $opts) = @_;
    my %out;

    my $ka = $opts->{keyattr} or return $in;

    if(ref $ka eq 'HASH')
    {   my $newkey = $ka->{$name} or return $in;
        my ($key, $flag) = @$newkey;

        foreach my $h (@$in)
        {   unless(ref $h eq 'HASH' && defined $h->{$key})
            {   warn "<$name> element has no '$key' key attribute\n" if $^W;
                return $in;
            }

            my $val = $h->{$key};
            if(ref $val)
            {   warn "<$name> element has non-scalar '$key' key attribute\n" if $^W;
                return $in;
            }

            $val = $self->normalise_space($val)
                if $opts->{normalisespace}==1;

            warn "<$name> element has non-unique value in '$key' "
               . "key attribute: $val\n" if $^W && defined $out{$val};

            $out{$val} = { %$h };
            $out{$val}{"-$key"} = $out{$val}{$key} if $flag eq '-';
            delete $out{$val}{$key} if $flag ne '+';
        }
    }

    else  # Arrayref
    {   my $default_keys = "@default_attributes" eq "@$ka";

      ELEMENT:
        foreach my $h (@$in)
        {   ref $h eq 'HASH' or return $in;

            foreach my $key (@$ka)
            {   my $val = $h->{$key};
                defined $val or next;

                if(ref $val)
                {   warn "<$name> element has non-scalar '$key' key attribute"
                        if $^W && ! $default_keys;
                    return $in;
                }

                $val = $self->normalise_space($val)
                    if $opts->{normalisespace} == 1;

                warn "<$name> element has non-unique value in '$key' "
                   . "key attribute: $val" if $^W && $out{$val};

                $out{$val} = { %$h };
                delete $out{$val}{$key};
                next ELEMENT;
            }
            return $in;    # No keyfield matched
        }
    }

    $opts->{collapseagain}
        or return \%out;

    # avoid over-complicated structures like
    # dir => { libexecdir    => { content => '$exec_prefix/libexec' },
    #          localstatedir => { content => '$prefix' },
    #        }
    # into
    # dir => { libexecdir    => '$exec_prefix/libexec',
    #          localstatedir => '$prefix',
    #        }

    my $contentkey = $opts->{contentkey};

    # first go through the values, checking that they are fit to collapse
    foreach my $v (values %out)
    {   next if !defined $v;
        next if ref $v eq 'HASH' && keys %$v == 1 && exists $v->{$contentkey};
        next if ref $v eq 'HASH' && !keys %$v;
        return \%out;
    }

    $out{$_} = $out{$_}{$contentkey} for keys %out;
    \%out;
}
  
1;

__END__

