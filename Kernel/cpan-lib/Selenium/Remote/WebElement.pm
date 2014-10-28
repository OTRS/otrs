package Selenium::Remote::WebElement;
{
  $Selenium::Remote::WebElement::VERSION = '0.17';
}

use strict;
use warnings;

=head1 NAME

Selenium::Remote::WebElement - Representation of an HTML Element used by Selenium Remote Driver

=head1 VERSION

version 0.17

=cut

=head1 DESCRIPTION

Selenium Webdriver represents all the HTML elements as WebElement. This module
provides a mechanism to represent them as objects & perform various actions on
the related elements. This module should not be instantiated directly by the end
user. Selenium::Remote::Driver instantiates this module when required. Typically,
the find_element method in Selenium::Remote::Driver returns this object on which
various element related operations can be carried out. 

=cut

=head1 FUNCTIONS

=cut

sub new {
    my ($class, $id, $parent) = @_;
    my $self = {
        id => $id,
        driver => $parent,
    };
    bless $self, $class or die "Can't bless $class: $!";
    return $self;
}

sub _execute_command {
    my ($self) = shift;
    return $self->{driver}->_execute_command(@_);
}

=head2 click

 Description:
    Click the element.

 Usage:
    $elem->click();

=cut

sub click {
    my ($self) = @_;
    my $res = { 'command' => 'clickElement', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 submit

 Description:
    Submit a FORM element. The submit command may also be applied to any element
    that is a descendant of a FORM element.

 Usage:
    $elem->submit();

=cut

sub submit {
    my ($self) = @_;
    my $res = { 'command' => 'submitElement', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

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

=cut

sub send_keys {
    my ($self, @strings) = @_;
    my $res = { 'command' => 'sendKeysToElement', 'id' => $self->{id} };
    map { $_ .= "" } @strings;
    my $params = {
        'value' => \@strings,
    };
    return $self->_execute_command($res, $params);
}

=head2 is_selected

 Description:
    Determine if an OPTION element, or an INPUT element of type checkbox or
    radiobutton is currently selected.

 Output:
    BOOLEAN - whether the element is selected

 Usage:
    $elem->is_selected();

=cut

sub is_selected {
    my ($self) = @_;
    my $res = { 'command' => 'isElementSelected', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 set_selected

 Description:
    Select an OPTION element, or an INPUT element of type checkbox or radiobutton. 

 Usage:
    $elem->set_selected();

 Note: DEPRECATED -- use click instead

=cut

sub set_selected {
    my ($self) = @_;
    my $res = { 'command' => 'setElementSelected', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 toggle

 Description:
    Toggle whether an OPTION element, or an INPUT element of type checkbox or
    radiobutton is currently selected.
    
 Output:
    BOOLEAN - Whether the element is selected after toggling its state.

 Usage:
    $elem->toggle();

 Note: DEPRECATED -- use click instead

=cut

sub toggle {
    my ($self) = @_;
    my $res = { 'command' => 'toggleElement', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 is_enabled

 Description:
    Determine if an element is currently enabled.
    
 Output:
    BOOLEAN - Whether the element is enabled.

 Usage:
    $elem->is_enabled();

=cut

sub is_enabled {
    my ($self) = @_;
    my $res = { 'command' => 'isElementEnabled', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 get_element_location

 Description:
   Determine an element's location on the page. The point (0, 0) refers to the
   upper-left corner of the page.
    
 Output:
    HASH - The X and Y coordinates for the element on the page.

 Usage:
    $elem->get_element_location();

=cut

sub get_element_location {
    my ($self) = @_;
    my $res = { 'command' => 'getElementLocation', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

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

=cut

sub get_element_location_in_view {
    my ($self) = @_;
    my $res = { 'command' => 'getElementLocationInView', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 get_tag_name

 Description:
    Query for an element's tag name.
    
 Output:
    STRING - The element's tag name, as a lowercase string.

 Usage:
    $elem->get_tag_name();

=cut

sub get_tag_name {
    my ($self) = @_;
    my $res = { 'command' => 'getElementTagName', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 clear

 Description:
    Clear a TEXTAREA or text INPUT element's value.
    
 Usage:
    $elem->clear();

=cut

sub clear {
    my ($self) = @_;
    my $res = { 'command' => 'clearElement', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

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

=cut

sub get_attribute {
    my ($self, $attr_name) = @_;
    if (not defined $attr_name) {
        return 'Attribute name not provided';
    }
    my $res = {'command' => 'getElementAttribute',
               'id' => $self->{id},
               'name' => $attr_name,
               };
    return $self->_execute_command($res);
}

=head2 get_value

 Description:
    Query for the value of an element, as determined by its value attribute.

 Output:
    {STRING | NULL} The element's value, or null if it doesn't have a value attribute.

 Usage:
    $elem->get_value();

=cut

sub get_value {
    my ($self) = @_;
    return $self->get_attribute('value');
}

=head2 is_displayed

 Description:
    Determine if an element is currently displayed.
    
 Output:
    BOOLEAN - Whether the element is displayed.

 Usage:
    $elem->is_displayed();

=cut

sub is_displayed {
    my ($self) = @_;
    my $res = { 'command' => 'isElementDisplayed', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

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

=cut

sub drag {
    my ($self, $x, $y) = @_;
    if ((not defined $x) || (not defined $y)){
        return 'X & Y pixel coordinates not provided';
    }
    my $res = {'command' => 'dragElement','id' => $self->{id}};
    my $params = {
        'x' => $x,
        'y' => $y,
    };
    return $self->_execute_command($res, $params);
}

=head2 get_size

 Description:
    Determine an element's size in pixels. The size will be returned with width
    and height properties.

 Output:
    HASH - The width and height of the element, in pixels.
    
 Usage:
    $elem->get_size();

=cut

sub get_size {
    my ($self) = @_;
    my $res = { 'command' => 'getElementSize', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 get_text

 Description:
    Get the innerText of the element.

 Output:
    STRING - innerText of an element
    
 Usage:
    $elem->get_text();

=cut

sub get_text {
    my ($self) = @_;
    my $res = { 'command' => 'getElementText', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

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

=cut

sub get_css_attribute {
    my ($self, $attr_name) = @_;
    if (not defined $attr_name) {
        return 'CSS attribute name not provided';
    }
    my $res = {'command' => 'getElementValueOfCssProperty',
               'id' => $self->{id},
               'property_name' => $attr_name,
               };
    return $self->_execute_command($res);
}

=head2 hover

 Description:
    Move the mouse over an element.

 Usage:
    $elem->hover();

=cut

sub hover {
    my ($self) = @_;
    my $res = { 'command' => 'hoverOverElement', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

=head2 describe

 Description:
    Describe the identified element

 Usage:
    $elem->describe();

=cut
sub describe {
    my ($self) = @_;
    my $res = { 'command' => 'describeElement', 'id' => $self->{id} };
    return $self->_execute_command($res);
}

1;

=head1 SEE ALSO

For more information about Selenium , visit the website at
L<http://code.google.com/p/selenium/>.

=head1 BUGS

The Selenium issue tracking system is available online at
L<http://github.com/aivaturi/Selenium-Remote-Driver/issues>.

=head1 CURRENT MAINTAINER

Charles Howes C<< <chowes@cpan.org> >>

=head1 AUTHOR

Perl Bindings for Selenium Remote Driver by Aditya Ivaturi C<< <ivaturi@gmail.com> >>

=head1 LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
