package Selenium::Remote::WebElement;
$Selenium::Remote::WebElement::VERSION = '1.39';
# ABSTRACT: Representation of an HTML Element used by Selenium Remote Driver

use strict;
use warnings;

use Moo;
use Carp qw(carp croak);


has 'id' => (
    is       => 'ro',
    required => 1,
    coerce   => sub {
        my ($value) = @_;
        if ( ref($value) eq 'HASH' ) {
            if ( exists $value->{ELEMENT} ) {

                # The JSONWireProtocol web element object looks like
                #
                #     { "ELEMENT": $INTEGER_ID }
                return $value->{ELEMENT};
            }
            elsif ( exists $value->{'element-6066-11e4-a52e-4f735466cecf'} ) {

                # but the WebDriver spec web element uses a magic
                # string. See the spec for more information:
                #
                # https://www.w3.org/TR/webdriver/#elements
                return $value->{'element-6066-11e4-a52e-4f735466cecf'};
            }
            else {
                croak
'When passing in an object to the WebElement id attribute, it must have at least one of the ELEMENT or element-6066-11e4-a52e-4f735466cecf keys.';
            }
        }
        else {
            return $value;
        }
    }
);

has 'driver' => (
    is       => 'ro',
    required => 1,
    handles  => [qw(_execute_command)],
);


sub child {
    return $_[0]->{driver}->find_child_element(@_);
}

sub children {
    return $_[0]->{driver}->find_child_elements(@_);
}


sub click {
    my ($self) = @_;
    my $res = { 'command' => 'clickElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub execute_script {
    my ($self, $script, @args) = @_;
    return $self->driver->execute_script(
        $script,
        { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} },
        @args );
}

sub execute_async_script {
    my ($self, $script, @args) = @_;
    return $self->driver->execute_async_script(
        $script,
        { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} },
        @args );
}



sub submit {
    my ($self) = @_;
    if (
        $self->driver->{is_wd3}
        && !(
            grep { $self->driver->browser_name eq $_ } qw{MicrosoftEdge}
        )
      )
    {
        if ( $self->get_tag_name() ne 'form' ) {
            return $self->driver->execute_script(
                "return arguments[0].form.submit();",
                { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} } );
        }
        else {
            return $self->driver->execute_script(
                "return arguments[0].submit();",
                { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} } );
        }
    }
    my $res = { 'command' => 'submitElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub send_keys {
    my ( $self, @strings ) = @_;
    croak "no keys to send" unless scalar @strings >= 1;
    my $res = { 'command' => 'sendKeysToElement', 'id' => $self->id };

    # We need to send an array of single characters to be WebDriver
    # spec compatible. That is, for @strings = ('hel', 'lo'), the
    # corresponding value must be ('h', 'e', 'l', 'l', 'o' ). This
    # format conforms with the Spec AND works with the Selenium
    # standalone server.
    my $strings = join( '', map { $_ . "" } @strings );
    my $params = {
        'value' => [ split( '', $strings ) ],
        text    => $strings,
    };
    return $self->_execute_command( $res, $params );
}


sub is_selected {
    my ($self) = @_;

    my $to_check = $self->get_tag_name() eq 'option' ? 'selected' : 'checked';
    return $self->get_property($to_check)
      if $self->driver->{is_wd3}
      && !( grep { $self->driver->browser_name eq $_ }
        qw{chrome MicrosoftEdge} );
    my $res = { 'command' => 'isElementSelected', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub set_selected {
    my ($self) = @_;
    if ( $self->driver->{is_wd3} ) {
        return if $self->is_selected();
        return $self->click();
    }
    my $res = { 'command' => 'setElementSelected', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub toggle {
    my ($self) = @_;
    if ( $self->driver->{is_wd3} ) {
        return $self->click() unless $self->is_selected();
        return $self->driver->execute_script(
qq/ if (arguments[0].checked) { arguments[0].checked = 0 }; return arguments[0].checked; /,
            { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} }
        );
    }
    my $res = { 'command' => 'toggleElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub is_enabled {
    my ($self) = @_;
    if (
        $self->driver->{is_wd3}
        && !(
            grep { $self->driver->browser_name eq $_ } qw{chrome MicrosoftEdge}
        )
      )
    {
        return 1 if $self->get_tag_name() ne 'input';
        return $self->get_property('disabled') ? 0 : 1;
    }
    my $res = { 'command' => 'isElementEnabled', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_element_location {
    my ($self) = @_;
    if (
        $self->driver->{is_wd3}
        && !(
            grep { $self->driver->browser_name eq $_ } qw{chrome MicrosoftEdge}
        )
      )
    {
        my $data = $self->get_element_rect();
        delete $data->{height};
        delete $data->{width};
        return $data;
    }
    my $res = { 'command' => 'getElementLocation', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_size {
    my ($self) = @_;
    if (
        $self->driver->{is_wd3}
        && !(
            grep { $self->driver->browser_name eq $_ } qw{chrome MicrosoftEdge}
        )
      )
    {
        my $data = $self->get_element_rect();
        delete $data->{x};
        delete $data->{y};
        return $data;
    }
    my $res = { 'command' => 'getElementSize', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_element_rect {
    my ($self) = @_;
    my $res = { 'command' => 'getElementRect', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_element_location_in_view {
    my ($self) = @_;

    #XXX chrome is dopey here
    return $self->driver->execute_script(
        qq{
        if (typeof(arguments[0]) !== 'undefined' && arguments[0].nodeType === Node.ELEMENT_NODE) {
            arguments[0].scrollIntoView();
            var pos = arguments[0].getBoundingClientRect();
            return {y:pos.top,x:pos.left};
        }
        return {};
    }, { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} }
      )
      if $self->driver->{is_wd3} && grep { $self->driver->browser_name eq $_ }
      ( 'firefox', 'internet explorer', 'chrome' );
    my $res = { 'command' => 'getElementLocationInView', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_tag_name {
    my ($self) = @_;
    my $res = { 'command' => 'getElementTagName', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub clear {
    my ($self) = @_;
    my $res = { 'command' => 'clearElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_attribute {
    my ( $self, $attr_name, $no_i_really_mean_it ) = @_;
    if ( not defined $attr_name ) {
        croak 'Attribute name not provided';
    }

    #Handle global JSONWire emulation flag
    $no_i_really_mean_it = 1 unless $self->{driver}->{emulate_jsonwire};

    return $self->get_property($attr_name)
      if $self->driver->{is_wd3}
      && !( grep { $self->driver->browser_name eq $_ }
        qw{chrome MicrosoftEdge} )
      && !$no_i_really_mean_it;

    my $res = {
        'command' => 'getElementAttribute',
        'id'      => $self->id,
        'name'    => $attr_name,
    };
    return $self->_execute_command($res);
}


sub get_property {
    my ( $self, $prop ) = @_;
    return $self->get_attribute($prop)
      if $self->driver->{is_wd3}
      && ( grep { $self->driver->browser_name eq $_ }
        qw{chrome MicrosoftEdge} );
    my $res =
      { 'command' => 'getElementProperty', id => $self->id, name => $prop };
    return $self->_execute_command($res);
}


sub get_value {
    my ($self) = @_;
    return $self->get_attribute('value');
}


sub is_displayed {
    my ($self) = @_;
    if (
        $self->driver->{is_wd3}
        && !(
            grep { $self->driver->browser_name eq $_ } qw{chrome MicrosoftEdge}
        )
      )
    {
        return 0
          if $self->get_tag_name() eq 'input'
          && $self->get_property('type') eq 'hidden';    #hidden type inputs
        return 0 unless $self->_is_in_viewport();
        return int( $self->get_css_attribute('display') ne 'none' );
    }
    my $res = { 'command' => 'isElementDisplayed', 'id' => $self->id };
    return $self->_execute_command($res);
}

sub _is_in_viewport {
    my ($self) = @_;
    return $self->driver->execute_script(
        qq{
        var rect = arguments[0].getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }, { 'element-6066-11e4-a52e-4f735466cecf' => $self->{id} }
    );
}


sub is_hidden {
    my ($self) = @_;
    return !$self->is_displayed();
}


sub drag {
    my ( $self, $target ) = @_;
    require Selenium::ActionChains;
    my $chain = Selenium::ActionChains->new( driver => $self->driver );
    return $chain->drag_and_drop( $self, $target )->perform();
}


sub get_text {
    my ($self) = @_;
    my $res = { 'command' => 'getElementText', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_css_attribute {
    my ( $self, $attr_name ) = @_;
    if ( not defined $attr_name ) {
        croak 'CSS attribute name not provided';
    }
    my $res = {
        'command'       => 'getElementValueOfCssProperty',
        'id'            => $self->id,
        'property_name' => $attr_name,
    };
    return $self->_execute_command($res);
}


sub describe {
    my ($self) = @_;
    my $res = { 'command' => 'describeElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub screenshot {
    my ( $self, $scroll ) = @_;
    $scroll //= 1;
    my $res = { 'command' => 'elementScreenshot', id => $self->id };
    my $input = { scroll => int($scroll) };
    return $self->_execute_command( $res, $input );
}


sub capture_screenshot {
    my ( $self, $filename, $scroll ) = @_;
    croak '$filename is required' unless $filename;

    open( my $fh, '>', $filename );
    binmode $fh;
    print $fh MIME::Base64::decode_base64( $self->screenshot($scroll) );
    CORE::close $fh;
    return 1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::WebElement - Representation of an HTML Element used by Selenium Remote Driver

=head1 VERSION

version 1.39

=head1 DESCRIPTION

Selenium Webdriver represents all the HTML elements as WebElements.
This module provides a mechanism to represent them as objects &
perform various actions on the related elements. This module should
not be instantiated directly by the end user. Selenium::Remote::Driver
instantiates this module when required. Typically, the find_element
method in Selenium::Remote::Driver returns this object on which
various element related operations can be carried out.

What is probably most useful on this page is the list of methods below
that you can perform on an element once you've found one and S::R::D
has made an instance of this for you.

=head1 CONSTRUCTOR

=head2 new

=over 4

=item B<id>

Required: Pass in a string representing the ID of the object. The
string should be obtained from the response object of making one of
the C<find_element> calls from L<Selenium::Remote::Driver>.

The attribute is also set up to handle spec compliant element response
objects via its `coerce` such that any of the following will work and
are all equivalent:

    my $old_elem = Selenium::Remote::WebElement->new(
        id => 1,
        driver => $driver
    );

    my $new_remote_elem = Selenium::Remote::WebElement->new(
        id => { ELEMENT => 1 },
        driver => $driver
    );

    my $new_spec_elem = Selenium::Remote::WebElement->new(
        id => { 'element-6066-11e4-a52e-4f735466cecf' => 1 },
        driver => $driver
    );

and then after instantiation, all three would give the following for
`id`:

    print $elem->id; # prints 1

=item B<driver>

Required: Pass in a Selenium::Remote::Driver instance or one of its
subclasses. The WebElement needs the appropriate Driver session to
execute its commands properly.

=back

For typical usage of S::R::D and this module, none of this
matters and it should Just Work without you having to worry about it
at all. For further reading, the L<W3C
spec|https://www.w3.org/TR/webdriver/#elements> strictly dictates the
exact behavior.

=head1 FUNCTIONS

=head2 child(selector, method)

=head2 children(selector, method)

Alias to Selenium::Remote::Driver::find_child_element and find_child_elements, respectively.

=head2 click

 Description:
    Click the element.

 Usage:
    $elem->click();

=head2 execute_script($script, @args), execute_async_script($script, @args)

Convenience method to execute a script with the element passed as the first argument to the script function, and the remaining args appended.
See the documentation for Selenium::Remote::Driver::execute_script for more information.

=head2 submit

 Description:
    Submit a FORM element. The submit command may also be applied to any element
    that is a descendant of a FORM element.

 Compatibility:
    On webdriver3 enabled servers, this uses a JS shim, which WILL NOT submit correctly unless your element is an <input>.
    Try clicking it if possible instead.

 Usage:
    $elem->submit();

=head2 send_keys

 Description:
    Send a sequence of key strokes to an element. If you want to send specific
    Keyboard events, then use the WDKeys module along with theis method. See e.g.
    for reference

 Input: 1
    Required:
        {ARRAY | STRING} - Array of strings or a string.

 Usage:
    $elem->send_keys('abcd', 'efg');
    $elem->send_keys('hijk');

    or

    # include the WDKeys module
    use Selenium::Remote::WDKeys;
    .
    .
    $elem->send_keys(KEYS->{'space'}, KEYS->{'enter'});

=head2 is_selected

 Description:
    Determine if an OPTION element, or an INPUT element of type checkbox or
    radiobutton is currently selected.

 Output:
    BOOLEAN - whether the element is selected

 Usage:
    $elem->is_selected();

=head2 set_selected

 Description:
    Select an OPTION element, or an INPUT element of type checkbox or radiobutton.
    Forces selected=1 on the element..

 Usage:
    $elem->set_selected();

=head2 toggle

 Description:
    Toggle whether an OPTION element, or an INPUT element of type checkbox or
    radiobutton is currently selected.

 Output:
    BOOLEAN - Whether the element is selected after toggling its state.

 Usage:
    $elem->toggle();

=head2 is_enabled

 Description:
    Determine if an element is currently enabled.

 Output:
    BOOLEAN - Whether the element is enabled.

 Usage:
    $elem->is_enabled();

=head2 get_element_location

 Description:
   Determine an element's location on the page. The point (0, 0) refers to the
   upper-left corner of the page.

 Compatibility:
    On WebDriver 3 enabled servers, this is an alias for get_element_rect().

 Output:
    HASH - The X and Y coordinates for the element on the page.

 Usage:
    $elem->get_element_location();

 This method is DEPRECATED on webdriver3 enabled servers.

=head2 get_size

 Description:
    Determine an element's size in pixels. The size will be returned with width
    and height properties.

 Compatibility:
    On WebDriver 3 enabled servers, this is an alias for get_element_rect().

 Output:
    HASH - The width and height of the element, in pixels.

 Usage:
    $elem->get_size();

 This method is DEPRECATED on webdriver3 enabled servers.

=head2 get_element_rect

Get the element's size AND location in a hash.

Example Output:

    { x => 0, y => 0, height => 10, width => 10 }

=head2 get_element_location_in_view

 Description:
    Determine an element's location on the screen once it has been scrolled
    into view.

    Note: This is considered an internal command and should only be used to
    determine an element's location for correctly generating native events.

 Compatibility:
    On Webdriver3 servers, we have to implement this with a JS shim.
    This means in some contexts, you won't get any position returned, as the element isn't considered an element internally.
    You may have to go up the element stack to find the element that actually has the bounding box.

 Output:
    {x:number, y:number} The X and Y coordinates for the element on the page.

 Usage:
    $elem->get_element_location_in_view();

=head2 get_tag_name

 Description:
    Query for an element's tag name.

 Output:
    STRING - The element's tag name, as a lowercase string.

 Usage:
    $elem->get_tag_name();

=head2 clear

 Description:
    Clear a TEXTAREA or text INPUT element's value.

 Usage:
    $elem->clear();

=head2 get_attribute

 Description:
    Get the value of an element's attribute.

 Compatibility:
    In older webDriver, this actually got the value of an element's property.
    If you want to get the initial condition (e.g. the values in the tag hardcoded in HTML), pass 1 as the second argument.

    Or, set $driver->{emulate_jsonwire} = 0 to not have to pass the extra arg.

    This can only done on WebDriver 3 enabled servers.

 Input: 2
    Required:
        STRING - name of the attribute of the element
    Optional:
        BOOLEAN - "I really mean that I want the initial condition, quit being so compatible!!!"


 Output:
    {STRING | NULL} The value of the attribute, or null if it is not set on the element.

 Usage:
    $elem->get_attribute('name',1);

=head2 get_property

Gets the C<Current Value> of an element's attribute.

Takes a named property as an argument.

Only available on WebDriver 3 enabled servers.

=head2 get_value

 Description:
    Query for the value of an element, as determined by its value attribute.

 Output:
    {STRING | NULL} The element's value, or null if it doesn't have a value attribute.

 Usage:
    $elem->get_value();

=head2 is_displayed

 Description:
    Determine if an element is currently displayed.
    Note: This does *not* tell you an element's 'visibility' property; as it still takes up space in the DOM and is therefore considered 'displayed'.

 WC3 Compatibility:
    On JSONWire this method really only checked to see whether the element's style was display:none, or whether it was a hidden input.
    This is because "displayedness" was pretty loosely defined until fairly late on into the process, and much grief resulted.
    In WC3 webdriver, it additionally does a viewport check, to account for the firmer definition of "displayedness":
    https://w3c.github.io/webdriver/#element-displayedness

 Output:
    BOOLEAN - Whether the element is displayed.

 Usage:
    $elem->is_displayed();

=head2 is_hidden

 Description:
    Determine if an element is currently hidden.

 Output:
    BOOLEAN - Whether the element is hidden.

 Usage:
    $elem->is_hidden();

=head2 drag

Alias for Selenium::ActionChains::drag_and_drop().

Provide element you wish to drag to as argument.

    my $target = $driver->find_element('receptacle','id');
    my $subject = $driver->find_element('thingy','id');
    $subject->drag($target);

=head2 get_text

 Description:
    Get the innerText of the element.

 Output:
    STRING - innerText of an element

 Usage:
    $elem->get_text();

=head2 get_css_attribute

 Description:
    Query the value of an element's computed CSS property. The CSS property to
    query should be specified using the CSS property name, not the JavaScript
    property name (e.g. background-color instead of backgroundColor).

 Input: 1
    Required:
        STRING - name of the css-attribute

 Output:
    STRING - Value of the css attribute

 Usage:
    $elem->get_css_attribute('background-color');

=head2 describe

 Description:
    Describe the identified element

 Usage:
    $elem->describe();

 Note: DEPRECATED as of 2.42.2 -- use get_text, get_value, is_displayed, or
 whatever appropriate WebElement function you need instead

 Entirely unsupported on WebDriver 3 enabled servers.

=head2 screenshot

 Description:
    Get a screenshot of the visible region that is a subset of the element's bounding box as a base64 encoded image.

 Compatibility:
    Only available on Webdriver3 enabled selenium servers.

 Input (optional):
    $scroll_into_view - BOOLEAN default true.  If false, will not scroll the element into the viewport first.
    Failing to do so may result in an image being cropped partially or entirely.

 Output:
    STRING - base64 encoded image

 Usage:
    print $element->screenshot();

To conveniently write the screenshot to a file, see L</capture_screenshot>.

=head2 capture_screenshot

 Description:
    Capture a screenshot of said element and save as a PNG to provided file name.

 Compatibility:
    Only available on Webdriver3 enabled selenium servers.

 Input (optional):
    $scroll_into_view - BOOLEAN default true.  If false, will not scroll the element into the viewport first.
    Failing to do so may result in an image being cropped partially or entirely.

 Output:
    TRUE - (Screenshot is written to file)

 Usage:
    $element->capture_screenshot($filename);

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/teodesian/Selenium-Remote-Driver/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHORS

Current Maintainers:

=over 4

=item *

Daniel Gempesaw <gempesaw@gmail.com>

=item *

Emmanuel Peroumalnaïk <peroumalnaik.emmanuel@gmail.com>

=back

Previous maintainers:

=over 4

=item *

Luke Closs <cpan@5thplane.com>

=item *

Mark Stosberg <mark@stosberg.com>

=back

Original authors:

=over 4

=item *

Aditya Ivaturi <ivaturi@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Copyright (c) 2014-2017 Daniel Gempesaw

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
