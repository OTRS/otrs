package PDF::API2::Resource::Font::CoreFont::timesroman;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub data { return {
    'fontname' => 'Times-Roman',
    'type' => 'Type1',
    'apiname' => 'TiRo',
    'ascender' => '683',
    'capheight' => '662',
    'descender' => '-217',
    'iscore' => '1',
    'isfixedpitch' => '0',
    'italicangle' => '0',
    'missingwidth' => '250',
    'stdhw' => '28',
    'stdvw' => '84',
    'underlineposition' => '-100',
    'underlinethickness' => '50',
    'xheight' => '450',
    'firstchar' => '32',
    'lastchar' => '255',
    'fontbbox' => [-168, -218, 1000, 898],
    'char' => [ # DEF. ENCODING GLYPH TABLE
        '.notdef',                               # C+0x00 # U+0x0000
        '.notdef',                               # C+0x01 # U+0x0000
        '.notdef',                               # C+0x02 # U+0x0000
        '.notdef',                               # C+0x03 # U+0x0000
        '.notdef',                               # C+0x04 # U+0x0000
        '.notdef',                               # C+0x05 # U+0x0000
        '.notdef',                               # C+0x06 # U+0x0000
        '.notdef',                               # C+0x07 # U+0x0000
        '.notdef',                               # C+0x08 # U+0x0000
        '.notdef',                               # C+0x09 # U+0x0000
        '.notdef',                               # C+0x0A # U+0x0000
        '.notdef',                               # C+0x0B # U+0x0000
        '.notdef',                               # C+0x0C # U+0x0000
        '.notdef',                               # C+0x0D # U+0x0000
        '.notdef',                               # C+0x0E # U+0x0000
        '.notdef',                               # C+0x0F # U+0x0000
        '.notdef',                               # C+0x10 # U+0x0000
        '.notdef',                               # C+0x11 # U+0x0000
        '.notdef',                               # C+0x12 # U+0x0000
        '.notdef',                               # C+0x13 # U+0x0000
        '.notdef',                               # C+0x14 # U+0x0000
        '.notdef',                               # C+0x15 # U+0x0000
        '.notdef',                               # C+0x16 # U+0x0000
        '.notdef',                               # C+0x17 # U+0x0000
        '.notdef',                               # C+0x18 # U+0x0000
        '.notdef',                               # C+0x19 # U+0x0000
        '.notdef',                               # C+0x1A # U+0x0000
        '.notdef',                               # C+0x1B # U+0x0000
        '.notdef',                               # C+0x1C # U+0x0000
        '.notdef',                               # C+0x1D # U+0x0000
        '.notdef',                               # C+0x1E # U+0x0000
        '.notdef',                               # C+0x1F # U+0x0000
        'space',                                 # C+0x20 # U+0x0020
        'exclam',                                # C+0x21 # U+0x0021
        'quotedbl',                              # C+0x22 # U+0x0022
        'numbersign',                            # C+0x23 # U+0x0023
        'dollar',                                # C+0x24 # U+0x0024
        'percent',                               # C+0x25 # U+0x0025
        'ampersand',                             # C+0x26 # U+0x0026
        'quotesingle',                           # C+0x27 # U+0x0027
        'parenleft',                             # C+0x28 # U+0x0028
        'parenright',                            # C+0x29 # U+0x0029
        'asterisk',                              # C+0x2A # U+0x002A
        'plus',                                  # C+0x2B # U+0x002B
        'comma',                                 # C+0x2C # U+0x002C
        'hyphen',                                # C+0x2D # U+0x002D
        'period',                                # C+0x2E # U+0x002E
        'slash',                                 # C+0x2F # U+0x002F
        'zero',                                  # C+0x30 # U+0x0030
        'one',                                   # C+0x31 # U+0x0031
        'two',                                   # C+0x32 # U+0x0032
        'three',                                 # C+0x33 # U+0x0033
        'four',                                  # C+0x34 # U+0x0034
        'five',                                  # C+0x35 # U+0x0035
        'six',                                   # C+0x36 # U+0x0036
        'seven',                                 # C+0x37 # U+0x0037
        'eight',                                 # C+0x38 # U+0x0038
        'nine',                                  # C+0x39 # U+0x0039
        'colon',                                 # C+0x3A # U+0x003A
        'semicolon',                             # C+0x3B # U+0x003B
        'less',                                  # C+0x3C # U+0x003C
        'equal',                                 # C+0x3D # U+0x003D
        'greater',                               # C+0x3E # U+0x003E
        'question',                              # C+0x3F # U+0x003F
        'at',                                    # C+0x40 # U+0x0040
        'A',                                     # C+0x41 # U+0x0041
        'B',                                     # C+0x42 # U+0x0042
        'C',                                     # C+0x43 # U+0x0043
        'D',                                     # C+0x44 # U+0x0044
        'E',                                     # C+0x45 # U+0x0045
        'F',                                     # C+0x46 # U+0x0046
        'G',                                     # C+0x47 # U+0x0047
        'H',                                     # C+0x48 # U+0x0048
        'I',                                     # C+0x49 # U+0x0049
        'J',                                     # C+0x4A # U+0x004A
        'K',                                     # C+0x4B # U+0x004B
        'L',                                     # C+0x4C # U+0x004C
        'M',                                     # C+0x4D # U+0x004D
        'N',                                     # C+0x4E # U+0x004E
        'O',                                     # C+0x4F # U+0x004F
        'P',                                     # C+0x50 # U+0x0050
        'Q',                                     # C+0x51 # U+0x0051
        'R',                                     # C+0x52 # U+0x0052
        'S',                                     # C+0x53 # U+0x0053
        'T',                                     # C+0x54 # U+0x0054
        'U',                                     # C+0x55 # U+0x0055
        'V',                                     # C+0x56 # U+0x0056
        'W',                                     # C+0x57 # U+0x0057
        'X',                                     # C+0x58 # U+0x0058
        'Y',                                     # C+0x59 # U+0x0059
        'Z',                                     # C+0x5A # U+0x005A
        'bracketleft',                           # C+0x5B # U+0x005B
        'backslash',                             # C+0x5C # U+0x005C
        'bracketright',                          # C+0x5D # U+0x005D
        'asciicircum',                           # C+0x5E # U+0x005E
        'underscore',                            # C+0x5F # U+0x005F
        'grave',                                 # C+0x60 # U+0x0060
        'a',                                     # C+0x61 # U+0x0061
        'b',                                     # C+0x62 # U+0x0062
        'c',                                     # C+0x63 # U+0x0063
        'd',                                     # C+0x64 # U+0x0064
        'e',                                     # C+0x65 # U+0x0065
        'f',                                     # C+0x66 # U+0x0066
        'g',                                     # C+0x67 # U+0x0067
        'h',                                     # C+0x68 # U+0x0068
        'i',                                     # C+0x69 # U+0x0069
        'j',                                     # C+0x6A # U+0x006A
        'k',                                     # C+0x6B # U+0x006B
        'l',                                     # C+0x6C # U+0x006C
        'm',                                     # C+0x6D # U+0x006D
        'n',                                     # C+0x6E # U+0x006E
        'o',                                     # C+0x6F # U+0x006F
        'p',                                     # C+0x70 # U+0x0070
        'q',                                     # C+0x71 # U+0x0071
        'r',                                     # C+0x72 # U+0x0072
        's',                                     # C+0x73 # U+0x0073
        't',                                     # C+0x74 # U+0x0074
        'u',                                     # C+0x75 # U+0x0075
        'v',                                     # C+0x76 # U+0x0076
        'w',                                     # C+0x77 # U+0x0077
        'x',                                     # C+0x78 # U+0x0078
        'y',                                     # C+0x79 # U+0x0079
        'z',                                     # C+0x7A # U+0x007A
        'braceleft',                             # C+0x7B # U+0x007B
        'bar',                                   # C+0x7C # U+0x007C
        'braceright',                            # C+0x7D # U+0x007D
        'asciitilde',                            # C+0x7E # U+0x007E
        'bullet',                                # C+0x7F # U+0x2022
        'Euro',                                  # C+0x80 # U+0x20AC
        'bullet',                                # C+0x81 # U+0x2022
        'quotesinglbase',                        # C+0x82 # U+0x201A
        'florin',                                # C+0x83 # U+0x0192
        'quotedblbase',                          # C+0x84 # U+0x201E
        'ellipsis',                              # C+0x85 # U+0x2026
        'dagger',                                # C+0x86 # U+0x2020
        'daggerdbl',                             # C+0x87 # U+0x2021
        'circumflex',                            # C+0x88 # U+0x02C6
        'perthousand',                           # C+0x89 # U+0x2030
        'Scaron',                                # C+0x8A # U+0x0160
        'guilsinglleft',                         # C+0x8B # U+0x2039
        'OE',                                    # C+0x8C # U+0x0152
        'bullet',                                # C+0x8D # U+0x2022
        'Zcaron',                                # C+0x8E # U+0x017D
        'bullet',                                # C+0x8F # U+0x2022
        'bullet',                                # C+0x90 # U+0x2022
        'quoteleft',                             # C+0x91 # U+0x2018
        'quoteright',                            # C+0x92 # U+0x2019
        'quotedblleft',                          # C+0x93 # U+0x201C
        'quotedblright',                         # C+0x94 # U+0x201D
        'bullet',                                # C+0x95 # U+0x2022
        'endash',                                # C+0x96 # U+0x2013
        'emdash',                                # C+0x97 # U+0x2014
        'tilde',                                 # C+0x98 # U+0x02DC
        'trademark',                             # C+0x99 # U+0x2122
        'scaron',                                # C+0x9A # U+0x0161
        'guilsinglright',                        # C+0x9B # U+0x203A
        'oe',                                    # C+0x9C # U+0x0153
        'bullet',                                # C+0x9D # U+0x2022
        'zcaron',                                # C+0x9E # U+0x017E
        'Ydieresis',                             # C+0x9F # U+0x0178
        'space',                                 # C+0xA0 # U+0x0020
        'exclamdown',                            # C+0xA1 # U+0x00A1
        'cent',                                  # C+0xA2 # U+0x00A2
        'sterling',                              # C+0xA3 # U+0x00A3
        'currency',                              # C+0xA4 # U+0x00A4
        'yen',                                   # C+0xA5 # U+0x00A5
        'brokenbar',                             # C+0xA6 # U+0x00A6
        'section',                               # C+0xA7 # U+0x00A7
        'dieresis',                              # C+0xA8 # U+0x00A8
        'copyright',                             # C+0xA9 # U+0x00A9
        'ordfeminine',                           # C+0xAA # U+0x00AA
        'guillemotleft',                         # C+0xAB # U+0x00AB
        'logicalnot',                            # C+0xAC # U+0x00AC
        'hyphen',                                # C+0xAD # U+0x002D
        'registered',                            # C+0xAE # U+0x00AE
        'macron',                                # C+0xAF # U+0x00AF
        'degree',                                # C+0xB0 # U+0x00B0
        'plusminus',                             # C+0xB1 # U+0x00B1
        'twosuperior',                           # C+0xB2 # U+0x00B2
        'threesuperior',                         # C+0xB3 # U+0x00B3
        'acute',                                 # C+0xB4 # U+0x00B4
        'mu',                                    # C+0xB5 # U+0x00B5
        'paragraph',                             # C+0xB6 # U+0x00B6
        'periodcentered',                        # C+0xB7 # U+0x00B7
        'cedilla',                               # C+0xB8 # U+0x00B8
        'onesuperior',                           # C+0xB9 # U+0x00B9
        'ordmasculine',                          # C+0xBA # U+0x00BA
        'guillemotright',                        # C+0xBB # U+0x00BB
        'onequarter',                            # C+0xBC # U+0x00BC
        'onehalf',                               # C+0xBD # U+0x00BD
        'threequarters',                         # C+0xBE # U+0x00BE
        'questiondown',                          # C+0xBF # U+0x00BF
        'Agrave',                                # C+0xC0 # U+0x00C0
        'Aacute',                                # C+0xC1 # U+0x00C1
        'Acircumflex',                           # C+0xC2 # U+0x00C2
        'Atilde',                                # C+0xC3 # U+0x00C3
        'Adieresis',                             # C+0xC4 # U+0x00C4
        'Aring',                                 # C+0xC5 # U+0x00C5
        'AE',                                    # C+0xC6 # U+0x00C6
        'Ccedilla',                              # C+0xC7 # U+0x00C7
        'Egrave',                                # C+0xC8 # U+0x00C8
        'Eacute',                                # C+0xC9 # U+0x00C9
        'Ecircumflex',                           # C+0xCA # U+0x00CA
        'Edieresis',                             # C+0xCB # U+0x00CB
        'Igrave',                                # C+0xCC # U+0x00CC
        'Iacute',                                # C+0xCD # U+0x00CD
        'Icircumflex',                           # C+0xCE # U+0x00CE
        'Idieresis',                             # C+0xCF # U+0x00CF
        'Eth',                                   # C+0xD0 # U+0x00D0
        'Ntilde',                                # C+0xD1 # U+0x00D1
        'Ograve',                                # C+0xD2 # U+0x00D2
        'Oacute',                                # C+0xD3 # U+0x00D3
        'Ocircumflex',                           # C+0xD4 # U+0x00D4
        'Otilde',                                # C+0xD5 # U+0x00D5
        'Odieresis',                             # C+0xD6 # U+0x00D6
        'multiply',                              # C+0xD7 # U+0x00D7
        'Oslash',                                # C+0xD8 # U+0x00D8
        'Ugrave',                                # C+0xD9 # U+0x00D9
        'Uacute',                                # C+0xDA # U+0x00DA
        'Ucircumflex',                           # C+0xDB # U+0x00DB
        'Udieresis',                             # C+0xDC # U+0x00DC
        'Yacute',                                # C+0xDD # U+0x00DD
        'Thorn',                                 # C+0xDE # U+0x00DE
        'germandbls',                            # C+0xDF # U+0x00DF
        'agrave',                                # C+0xE0 # U+0x00E0
        'aacute',                                # C+0xE1 # U+0x00E1
        'acircumflex',                           # C+0xE2 # U+0x00E2
        'atilde',                                # C+0xE3 # U+0x00E3
        'adieresis',                             # C+0xE4 # U+0x00E4
        'aring',                                 # C+0xE5 # U+0x00E5
        'ae',                                    # C+0xE6 # U+0x00E6
        'ccedilla',                              # C+0xE7 # U+0x00E7
        'egrave',                                # C+0xE8 # U+0x00E8
        'eacute',                                # C+0xE9 # U+0x00E9
        'ecircumflex',                           # C+0xEA # U+0x00EA
        'edieresis',                             # C+0xEB # U+0x00EB
        'igrave',                                # C+0xEC # U+0x00EC
        'iacute',                                # C+0xED # U+0x00ED
        'icircumflex',                           # C+0xEE # U+0x00EE
        'idieresis',                             # C+0xEF # U+0x00EF
        'eth',                                   # C+0xF0 # U+0x00F0
        'ntilde',                                # C+0xF1 # U+0x00F1
        'ograve',                                # C+0xF2 # U+0x00F2
        'oacute',                                # C+0xF3 # U+0x00F3
        'ocircumflex',                           # C+0xF4 # U+0x00F4
        'otilde',                                # C+0xF5 # U+0x00F5
        'odieresis',                             # C+0xF6 # U+0x00F6
        'divide',                                # C+0xF7 # U+0x00F7
        'oslash',                                # C+0xF8 # U+0x00F8
        'ugrave',                                # C+0xF9 # U+0x00F9
        'uacute',                                # C+0xFA # U+0x00FA
        'ucircumflex',                           # C+0xFB # U+0x00FB
        'udieresis',                             # C+0xFC # U+0x00FC
        'yacute',                                # C+0xFD # U+0x00FD
        'thorn',                                 # C+0xFE # U+0x00FE
        'ydieresis',                             # C+0xFF # U+0x00FF
    ], # DEF. ENCODING GLYPH TABLE
    'wx' => {
        'a'                  => 444,
        'A'                  => 722,
        'Aacute'             => 722,
        'aacute'             => 444,
        'abreve'             => 444,
        'Abreve'             => 722,
        'acircumflex'        => 444,
        'Acircumflex'        => 722,
        'acute'              => 333,
        'adieresis'          => 444,
        'Adieresis'          => 722,
        'AE'                 => 889,
        'ae'                 => 667,
        'agrave'             => 444,
        'Agrave'             => 722,
        'amacron'            => 444,
        'Amacron'            => 722,
        'ampersand'          => 778,
        'Aogonek'            => 722,
        'aogonek'            => 444,
        'aring'              => 444,
        'Aring'              => 722,
        'asciicircum'        => 469,
        'asciitilde'         => 541,
        'asterisk'           => 500,
        'at'                 => 921,
        'atilde'             => 444,
        'Atilde'             => 722,
        'B'                  => 667,
        'b'                  => 500,
        'backslash'          => 278,
        'bar'                => 200,
        'braceleft'          => 480,
        'braceright'         => 480,
        'bracketleft'        => 333,
        'bracketright'       => 333,
        'breve'              => 333,
        'brokenbar'          => 200,
        'bullet'             => 350,
        'C'                  => 667,
        'c'                  => 444,
        'cacute'             => 444,
        'Cacute'             => 667,
        'caron'              => 333,
        'Ccaron'             => 667,
        'ccaron'             => 444,
        'ccedilla'           => 444,
        'Ccedilla'           => 667,
        'cedilla'            => 333,
        'cent'               => 500,
        'circumflex'         => 333,
        'colon'              => 278,
        'comma'              => 250,
        'commaaccent'        => 250,
        'copyright'          => 760,
        'currency'           => 500,
        'd'                  => 500,
        'D'                  => 722,
        'dagger'             => 500,
        'daggerdbl'          => 500,
        'dcaron'             => 588,
        'Dcaron'             => 722,
        'dcroat'             => 500,
        'Dcroat'             => 722,
        'degree'             => 400,
        'Delta'              => 612,
        'dieresis'           => 333,
        'divide'             => 564,
        'dollar'             => 500,
        'dotaccent'          => 333,
        'dotlessi'           => 278,
        'e'                  => 444,
        'E'                  => 611,
        'eacute'             => 444,
        'Eacute'             => 611,
        'ecaron'             => 444,
        'Ecaron'             => 611,
        'ecircumflex'        => 444,
        'Ecircumflex'        => 611,
        'edieresis'          => 444,
        'Edieresis'          => 611,
        'Edotaccent'         => 611,
        'edotaccent'         => 444,
        'egrave'             => 444,
        'Egrave'             => 611,
        'eight'              => 500,
        'ellipsis'           => 1000,
        'Emacron'            => 611,
        'emacron'            => 444,
        'emdash'             => 1000,
        'endash'             => 500,
        'eogonek'            => 444,
        'Eogonek'            => 611,
        'equal'              => 564,
        'Eth'                => 722,
        'eth'                => 500,
        'Euro'               => 500,
        'exclam'             => 333,
        'exclamdown'         => 333,
        'F'                  => 556,
        'f'                  => 333,
        'fi'                 => 556,
        'five'               => 500,
        'fl'                 => 556,
        'florin'             => 500,
        'four'               => 500,
        'fraction'           => 167,
        'G'                  => 722,
        'g'                  => 500,
        'Gbreve'             => 722,
        'gbreve'             => 500,
        'gcommaaccent'       => 500,
        'Gcommaaccent'       => 722,
        'germandbls'         => 500,
        'grave'              => 333,
        'greater'            => 564,
        'greaterequal'       => 549,
        'guillemotleft'      => 500,
        'guillemotright'     => 500,
        'guilsinglleft'      => 333,
        'guilsinglright'     => 333,
        'H'                  => 722,
        'h'                  => 500,
        'hungarumlaut'       => 333,
        'hyphen'             => 333,
        'I'                  => 333,
        'i'                  => 278,
        'Iacute'             => 333,
        'iacute'             => 278,
        'Icircumflex'        => 333,
        'icircumflex'        => 278,
        'idieresis'          => 278,
        'Idieresis'          => 333,
        'Idotaccent'         => 333,
        'igrave'             => 278,
        'Igrave'             => 333,
        'Imacron'            => 333,
        'imacron'            => 278,
        'Iogonek'            => 333,
        'iogonek'            => 278,
        'j'                  => 278,
        'J'                  => 389,
        'k'                  => 500,
        'K'                  => 722,
        'Kcommaaccent'       => 722,
        'kcommaaccent'       => 500,
        'L'                  => 611,
        'l'                  => 278,
        'lacute'             => 278,
        'Lacute'             => 611,
        'lcaron'             => 344,
        'Lcaron'             => 611,
        'lcommaaccent'       => 278,
        'Lcommaaccent'       => 611,
        'less'               => 564,
        'lessequal'          => 549,
        'logicalnot'         => 564,
        'lozenge'            => 471,
        'Lslash'             => 611,
        'lslash'             => 278,
        'M'                  => 889,
        'm'                  => 778,
        'macron'             => 333,
        'minus'              => 564,
        'mu'                 => 500,
        'multiply'           => 564,
        'n'                  => 500,
        'N'                  => 722,
        'nacute'             => 500,
        'Nacute'             => 722,
        'ncaron'             => 500,
        'Ncaron'             => 722,
        'ncommaaccent'       => 500,
        'Ncommaaccent'       => 722,
        'nine'               => 500,
        'notequal'           => 549,
        'ntilde'             => 500,
        'Ntilde'             => 722,
        'numbersign'         => 500,
        'o'                  => 500,
        'O'                  => 722,
        'oacute'             => 500,
        'Oacute'             => 722,
        'Ocircumflex'        => 722,
        'ocircumflex'        => 500,
        'Odieresis'          => 722,
        'odieresis'          => 500,
        'oe'                 => 722,
        'OE'                 => 889,
        'ogonek'             => 333,
        'ograve'             => 500,
        'Ograve'             => 722,
        'ohungarumlaut'      => 500,
        'Ohungarumlaut'      => 722,
        'Omacron'            => 722,
        'omacron'            => 500,
        'one'                => 500,
        'onehalf'            => 750,
        'onequarter'         => 750,
        'onesuperior'        => 300,
        'ordfeminine'        => 276,
        'ordmasculine'       => 310,
        'Oslash'             => 722,
        'oslash'             => 500,
        'Otilde'             => 722,
        'otilde'             => 500,
        'P'                  => 556,
        'p'                  => 500,
        'paragraph'          => 453,
        'parenleft'          => 333,
        'parenright'         => 333,
        'partialdiff'        => 476,
        'percent'            => 833,
        'period'             => 250,
        'periodcentered'     => 250,
        'perthousand'        => 1000,
        'plus'               => 564,
        'plusminus'          => 564,
        'Q'                  => 722,
        'q'                  => 500,
        'question'           => 444,
        'questiondown'       => 444,
        'quotedbl'           => 408,
        'quotedblbase'       => 444,
        'quotedblleft'       => 444,
        'quotedblright'      => 444,
        'quoteleft'          => 333,
        'quoteright'         => 333,
        'quotesinglbase'     => 333,
        'quotesingle'        => 180,
        'R'                  => 667,
        'r'                  => 333,
        'racute'             => 333,
        'Racute'             => 667,
        'radical'            => 453,
        'rcaron'             => 333,
        'Rcaron'             => 667,
        'rcommaaccent'       => 333,
        'Rcommaaccent'       => 667,
        'registered'         => 760,
        'ring'               => 333,
        'S'                  => 556,
        's'                  => 389,
        'Sacute'             => 556,
        'sacute'             => 389,
        'Scaron'             => 556,
        'scaron'             => 389,
        'Scedilla'           => 556,
        'scedilla'           => 389,
        'Scommaaccent'       => 556,
        'scommaaccent'       => 389,
        'section'            => 500,
        'semicolon'          => 278,
        'seven'              => 500,
        'six'                => 500,
        'slash'              => 278,
        'space'              => 250,
        'sterling'           => 500,
        'summation'          => 600,
        'T'                  => 611,
        't'                  => 278,
        'Tcaron'             => 611,
        'tcaron'             => 326,
        'tcommaaccent'       => 278,
        'Tcommaaccent'       => 611,
        'Thorn'              => 556,
        'thorn'              => 500,
        'three'              => 500,
        'threequarters'      => 750,
        'threesuperior'      => 300,
        'tilde'              => 333,
        'trademark'          => 980,
        'two'                => 500,
        'twosuperior'        => 300,
        'u'                  => 500,
        'U'                  => 722,
        'Uacute'             => 722,
        'uacute'             => 500,
        'ucircumflex'        => 500,
        'Ucircumflex'        => 722,
        'udieresis'          => 500,
        'Udieresis'          => 722,
        'Ugrave'             => 722,
        'ugrave'             => 500,
        'uhungarumlaut'      => 500,
        'Uhungarumlaut'      => 722,
        'umacron'            => 500,
        'Umacron'            => 722,
        'underscore'         => 500,
        'Uogonek'            => 722,
        'uogonek'            => 500,
        'Uring'              => 722,
        'uring'              => 500,
        'V'                  => 722,
        'v'                  => 500,
        'w'                  => 722,
        'W'                  => 944,
        'X'                  => 722,
        'x'                  => 500,
        'y'                  => 500,
        'Y'                  => 722,
        'yacute'             => 500,
        'Yacute'             => 722,
        'Ydieresis'          => 722,
        'ydieresis'          => 500,
        'yen'                => 500,
        'Z'                  => 611,
        'z'                  => 444,
        'zacute'             => 444,
        'Zacute'             => 611,
        'Zcaron'             => 611,
        'zcaron'             => 444,
        'Zdotaccent'         => 611,
        'zdotaccent'         => 444,
        'zero'               => 500,
    },
} };

1;
