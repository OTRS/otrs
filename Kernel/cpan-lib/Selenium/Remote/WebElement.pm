package Selenium::Remote::WebElement;
$Selenium::Remote::WebElement::VERSION = '0.26';
# ABSTRACT: Representation of an HTML Element used by Selenium Remote Driver

use Moo;
use Carp qw(carp croak);



has 'id' => (
    is => 'rw',
);

has 'driver' => (
    is => 'rw',
    handles => [qw(_execute_command)],
);




sub click {
    my ($self) = @_;
    my $res = { 'command' => 'clickElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub submit {
    my ($self) = @_;
    my $res = { 'command' => 'submitElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub send_keys {
    my ( $self, @strings ) = @_;
    croak "no keys to send" unless scalar @strings >= 1;
    my $res = { 'command' => 'sendKeysToElement', 'id' => $self->id };
    map { $_ .= "" } @strings;
    my $params = {
        'value' => \@strings,
    };
    return $self->_execute_command( $res, $params );
}


sub is_selected {
    my ($self) = @_;
    my $res = { 'command' => 'isElementSelected', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub set_selected {
    my ($self) = @_;
    my $res = { 'command' => 'setElementSelected', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub toggle {
    my ($self) = @_;
    my $res = { 'command' => 'toggleElement', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub is_enabled {
    my ($self) = @_;
    my $res = { 'command' => 'isElementEnabled', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_element_location {
    my ($self) = @_;
    my $res = { 'command' => 'getElementLocation', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub get_element_location_in_view {
    my ($self) = @_;
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
    my ( $self, $attr_name ) = @_;
    if ( not defined $attr_name ) {
        croak 'Attribute name not provided';
    }
    my $res = {
        'command' => 'getElementAttribute',
        'id'      => $self->id,
        'name'    => $attr_name,
    };
    return $self->_execute_command($res);
}


sub get_value {
    my ($self) = @_;
    return $self->get_attribute('value');
}


sub is_displayed {
    my ($self) = @_;
    my $res = { 'command' => 'isElementDisplayed', 'id' => $self->id };
    return $self->_execute_command($res);
}


sub is_hidden {
    my ($self) = @_;
    return ! $self->is_displayed();
}


sub drag {
    carp 'drag is no longer available in the JSONWireProtocol and will be removed in the next version of this module';
}


sub get_size {
    my ($self) = @_;
    my $res = { 'command' => 'getElementSize', 'id' => $self->id };
    return $self->_execute_command($res);
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

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::WebElement - Representation of an HTML Element used by Selenium Remote Driver

=head1 VERSION

version 0.26

=head1 DESCRIPTION

Selenium Webdriver represents all the HTML elements as WebElement. This module
provides a mechanism to represent them as objects & perform various actions on
the related elements. This module should not be instantiated directly by the end
user. Selenium::Remote::Driver instantiates this module when required. Typically,
the find_element method in Selenium::Remote::Driver returns this object on which
various element related operations can be carried out.

=head1 FUNCTIONS

=head2 click

 Description:
    Click the element.

 Usage:
    $elem->click();

=head2 submit

 Description:
    Submit a FORM element. The submit command may also be applied to any element
    that is a descendant of a FORM element.

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

 Usage:
    $elem->set_selected();

 Note: DEPRECATED -- use click instead

=head2 toggle

 Description:
    Toggle whether an OPTION element, or an INPUT element of type checkbox or
    radiobutton is currently selected.

 Output:
    BOOLEAN - Whether the element is selected after toggling its state.

 Usage:
    $elem->toggle();

 Note: DEPRECATED -- use click instead

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

 Output:
    HASH - The X and Y coordinates for the element on the page.

 Usage:
    $elem->get_element_location();

=head2 get_element_location_in_view

 Description:
    Determine an element's location on the screen once it has been scrolled
    into view.

    Note: This is considered an internal command and should only be used to
    determine an element's location for correctly generating native events.

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

 Input: 1
    Required:
        STRING - name of the attribute of the element

 Output:
    {STRING | NULL} The value of the attribute, or null if it is not set on the element.

 Usage:
    $elem->get_attribute('name');

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

 Description:
    Drag and drop an element. The distance to drag an element should be
    specified relative to the upper-left corner of the page and it starts at 0,0

 Input: 2
    Required:
        NUMBER - X axis distance in pixels
        NUMBER - Y axis distance in pixels

 Usage:
    $elem->drag(216,158);

 Note: DEPRECATED - drag is no longer available in the
 JSONWireProtocol. We are working on an ActionsChains implementation,
 but drag and drop doesn't currently work on the Webdriver side for
 HTML5 pages. For reference, see:

 http://elementalselenium.com/tips/39-drag-and-drop
 https://gist.github.com/rcorreia/2362544

 Check out the mouse_move_to_location, button_down, and button_up
 functions on Selenium::Remote::Driver.

 https://metacpan.org/pod/Selenium::Remote::Driver#mouse_move_to_location
 https://metacpan.org/pod/Selenium::Remote::Driver#button_down
 https://metacpan.org/pod/Selenium::Remote::Driver#button_up

=head2 get_size

 Description:
    Determine an element's size in pixels. The size will be returned with width
    and height properties.

 Output:
    HASH - The width and height of the element, in pixels.

 Usage:
    $elem->get_size();

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

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/gempesaw/Selenium-Remote-Driver/issues

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

Copyright (c) 2014-2015 Daniel Gempesaw

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
