package Selenium::Remote::WDKeys;
{
  $Selenium::Remote::WDKeys::VERSION = '0.17';
}

=head1 NAME

Selenium::Remote::WDKeys - Representation of keystrokes used by Selenium::Remote::WebDriver

=head1 VERSION

version 0.17

=cut

=head1 DESCRIPTION

The constant KEYS is defined here.

=cut


use strict;
use warnings;

use base 'Exporter';

# http://code.google.com/p/selenium/wiki/JsonWireProtocol#/session/:sessionId/element/:id/value
use constant KEYS => {
    'null'	 => "\N{U+E000}",
    'cancel'	 => "\N{U+E001}",
    'help'	 => "\N{U+E002}",
    'backspace'	 => "\N{U+E003}",
    'tab'	 => "\N{U+E004}",
    'clear'	 => "\N{U+E005}",
    'return'	 => "\N{U+E006}",
    'enter'	 => "\N{U+E007}",
    'shift'	 => "\N{U+E008}",
    'control'	 => "\N{U+E009}",
    'alt'	 => "\N{U+E00A}",
    'pause'	 => "\N{U+E00B}",
    'escape'	 => "\N{U+E00C}",
    'space'	 => "\N{U+E00D}",
    'page_up'	 => "\N{U+E00E}",
    'page_down'	 => "\N{U+E00f}",
    'end'	 => "\N{U+E010}",
    'home'	 => "\N{U+E011}",
    'left_arrow'	 => "\N{U+E012}",
    'up_arrow'	 => "\N{U+E013}",
    'right_arrow'	 => "\N{U+E014}",
    'down_arrow'	 => "\N{U+E015}",
    'insert'	 => "\N{U+E016}",
    'delete'	 => "\N{U+E017}",
    'semicolon'	 => "\N{U+E018}",
    'equals'	 => "\N{U+E019}",
    'numpad_0'	 => "\N{U+E01A}",
    'numpad_1'	 => "\N{U+E01B}",
    'numpad_2'	 => "\N{U+E01C}",
    'numpad_3'	 => "\N{U+E01D}",
    'numpad_4'	 => "\N{U+E01E}",
    'numpad_5'	 => "\N{U+E01f}",
    'numpad_6'	 => "\N{U+E020}",
    'numpad_7'	 => "\N{U+E021}",
    'numpad_8'	 => "\N{U+E022}",
    'numpad_9'	 => "\N{U+E023}",
    'multiply'	 => "\N{U+E024}",
    'add'	 => "\N{U+E025}",
    'separator'	 => "\N{U+E026}",
    'subtract'	 => "\N{U+E027}",
    'decimal'	 => "\N{U+E028}",
    'divide'	 => "\N{U+E029}",
    'f1'	 => "\N{U+E031}",
    'f2'	 => "\N{U+E032}",
    'f3'	 => "\N{U+E033}",
    'f4'	 => "\N{U+E034}",
    'f5'	 => "\N{U+E035}",
    'f6'	 => "\N{U+E036}",
    'f7'	 => "\N{U+E037}",
    'f8'	 => "\N{U+E038}",
    'f9'	 => "\N{U+E039}",
    'f10'	 => "\N{U+E03A}",
    'f11'	 => "\N{U+E03B}",
    'f12'	 => "\N{U+E03C}",
    'command_meta'  => "\N{U+E03D}",
};

our @EXPORT = ('KEYS');

1;
