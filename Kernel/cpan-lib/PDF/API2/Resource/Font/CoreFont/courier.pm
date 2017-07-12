package PDF::API2::Resource::Font::CoreFont::courier;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub data { return {
    'fontname' => 'Courier',
    'type' => 'Type1',
    'apiname' => 'Cour',
    'ascender' => '629',
    'capheight' => '562',
    'descender' => '-157',
    'iscore' => '1',
    'isfixedpitch' => '1',
    'italicangle' => '0',
    'missingwidth' => '600',
    'underlineposition' => '-100',
    'underlinethickness' => '50',
    'xheight' => '426',
    'firstchar' => '32',
    'lastchar' => '255',
    'fontbbox' => [-23, -250, 715, 805],
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
        'A' => '600',   # U=0041
        'a' => '600',   # U=0061
        'Aacute' => '600',   # U=00C1
        'aacute' => '600',   # U=00E1
        'Abreve' => '600',   # U=0102
        'abreve' => '600',   # U=0103
        'Acircumflex' => '600',   # U=00C2
        'acircumflex' => '600',   # U=00E2
        'acute' => '600',   # U=00B4
        'Adieresis' => '600',   # U=00C4
        'adieresis' => '600',   # U=00E4
        'AE' => '600',   # U=00C6
        'ae' => '600',   # U=00E6
        'Agrave' => '600',   # U=00C0
        'agrave' => '600',   # U=00E0
        'Amacron' => '600',   # U=0100
        'amacron' => '600',   # U=0101
        'ampersand' => '600',   # U=0026
        'Aogonek' => '600',   # U=0104
        'aogonek' => '600',   # U=0105
        'Aring' => '600',   # U=00C5
        'aring' => '600',   # U=00E5
        'asciicircum' => '600',   # U=005E
        'asciitilde' => '600',   # U=007E
        'asterisk' => '600',   # U=002A
        'at' => '600',   # U=0040
        'Atilde' => '600',   # U=00C3
        'atilde' => '600',   # U=00E3
        'B' => '600',   # U=0042
        'b' => '600',   # U=0062
        'backslash' => '600',   # U=005C
        'bar' => '600',   # U=007C
        'braceleft' => '600',   # U=007B
        'braceright' => '600',   # U=007D
        'bracketleft' => '600',   # U=005B
        'bracketright' => '600',   # U=005D
        'breve' => '600',   # U=02D8
        'brokenbar' => '600',   # U=00A6
        'bullet' => '600',   # U=2022
        'C' => '600',   # U=0043
        'c' => '600',   # U=0063
        'Cacute' => '600',   # U=0106
        'cacute' => '600',   # U=0107
        'caron' => '600',   # U=02C7
        'Ccaron' => '600',   # U=010C
        'ccaron' => '600',   # U=010D
        'Ccedilla' => '600',   # U=00C7
        'ccedilla' => '600',   # U=00E7
        'cedilla' => '600',   # U=00B8
        'cent' => '600',   # U=00A2
        'circumflex' => '600',   # U=02C6
        'colon' => '600',   # U=003A
        'comma' => '600',   # U=002C
        'commaaccent' => '600',   # U=F6C3
        'copyright' => '600',   # U=00A9
        'currency' => '600',   # U=00A4
        'D' => '600',   # U=0044
        'd' => '600',   # U=0064
        'dagger' => '600',   # U=2020
        'daggerdbl' => '600',   # U=2021
        'Dcaron' => '600',   # U=010E
        'dcaron' => '600',   # U=010F
        'Dcroat' => '600',   # U=0110
        'dcroat' => '600',   # U=0111
        'degree' => '600',   # U=00B0
        'Delta' => '600',   # U=0394
        'dieresis' => '600',   # U=00A8
        'divide' => '600',   # U=00F7
        'dollar' => '600',   # U=0024
        'dotaccent' => '600',   # U=02D9
        'dotlessi' => '600',   # U=0131
        'E' => '600',   # U=0045
        'e' => '600',   # U=0065
        'Eacute' => '600',   # U=00C9
        'eacute' => '600',   # U=00E9
        'Ecaron' => '600',   # U=011A
        'ecaron' => '600',   # U=011B
        'Ecircumflex' => '600',   # U=00CA
        'ecircumflex' => '600',   # U=00EA
        'Edieresis' => '600',   # U=00CB
        'edieresis' => '600',   # U=00EB
        'Edotaccent' => '600',   # U=0116
        'edotaccent' => '600',   # U=0117
        'Egrave' => '600',   # U=00C8
        'egrave' => '600',   # U=00E8
        'eight' => '600',   # U=0038
        'ellipsis' => '600',   # U=2026
        'Emacron' => '600',   # U=0112
        'emacron' => '600',   # U=0113
        'emdash' => '600',   # U=2014
        'endash' => '600',   # U=2013
        'Eogonek' => '600',   # U=0118
        'eogonek' => '600',   # U=0119
        'equal' => '600',   # U=003D
        'Eth' => '600',   # U=00D0
        'eth' => '600',   # U=00F0
        'Euro' => '600',   # U=20AC
        'exclam' => '600',   # U=0021
        'exclamdown' => '600',   # U=00A1
        'F' => '600',   # U=0046
        'f' => '600',   # U=0066
        'fi' => '600',   # U=FB01
        'five' => '600',   # U=0035
        'fl' => '600',   # U=FB02
        'florin' => '600',   # U=0192
        'four' => '600',   # U=0034
        'fraction' => '600',   # U=2044
        'G' => '600',   # U=0047
        'g' => '600',   # U=0067
        'Gbreve' => '600',   # U=011E
        'gbreve' => '600',   # U=011F
        'Gcommaaccent' => '600',   # U=0122
        'gcommaaccent' => '600',   # U=0123
        'germandbls' => '600',   # U=00DF
        'grave' => '600',   # U=0060
        'greater' => '600',   # U=003E
        'greaterequal' => '600',   # U=2265
        'guillemotleft' => '600',   # U=00AB
        'guillemotright' => '600',   # U=00BB
        'guilsinglleft' => '600',   # U=2039
        'guilsinglright' => '600',   # U=203A
        'H' => '600',   # U=0048
        'h' => '600',   # U=0068
        'hungarumlaut' => '600',   # U=02DD
        'hyphen' => '600',   # U=002D
        'I' => '600',   # U=0049
        'i' => '600',   # U=0069
        'Iacute' => '600',   # U=00CD
        'iacute' => '600',   # U=00ED
        'Icircumflex' => '600',   # U=00CE
        'icircumflex' => '600',   # U=00EE
        'Idieresis' => '600',   # U=00CF
        'idieresis' => '600',   # U=00EF
        'Idotaccent' => '600',   # U=0130
        'Igrave' => '600',   # U=00CC
        'igrave' => '600',   # U=00EC
        'Imacron' => '600',   # U=012A
        'imacron' => '600',   # U=012B
        'Iogonek' => '600',   # U=012E
        'iogonek' => '600',   # U=012F
        'J' => '600',   # U=004A
        'j' => '600',   # U=006A
        'K' => '600',   # U=004B
        'k' => '600',   # U=006B
        'Kcommaaccent' => '600',   # U=0136
        'kcommaaccent' => '600',   # U=0137
        'L' => '600',   # U=004C
        'l' => '600',   # U=006C
        'Lacute' => '600',   # U=0139
        'lacute' => '600',   # U=013A
        'Lcaron' => '600',   # U=013D
        'lcaron' => '600',   # U=013E
        'Lcommaaccent' => '600',   # U=013B
        'lcommaaccent' => '600',   # U=013C
        'less' => '600',   # U=003C
        'lessequal' => '600',   # U=2264
        'logicalnot' => '600',   # U=00AC
        'lozenge' => '600',   # U=25CA
        'Lslash' => '600',   # U=0141
        'lslash' => '600',   # U=0142
        'M' => '600',   # U=004D
        'm' => '600',   # U=006D
        'macron' => '600',   # U=00AF
        'minus' => '600',   # U=2212
        'mu' => '600',   # U=00B5
        'multiply' => '600',   # U=00D7
        'N' => '600',   # U=004E
        'n' => '600',   # U=006E
        'Nacute' => '600',   # U=0143
        'nacute' => '600',   # U=0144
        'Ncaron' => '600',   # U=0147
        'ncaron' => '600',   # U=0148
        'Ncommaaccent' => '600',   # U=0145
        'ncommaaccent' => '600',   # U=0146
        'nine' => '600',   # U=0039
        'notequal' => '600',   # U=2260
        'Ntilde' => '600',   # U=00D1
        'ntilde' => '600',   # U=00F1
        'numbersign' => '600',   # U=0023
        'O' => '600',   # U=004F
        'o' => '600',   # U=006F
        'Oacute' => '600',   # U=00D3
        'oacute' => '600',   # U=00F3
        'Ocircumflex' => '600',   # U=00D4
        'ocircumflex' => '600',   # U=00F4
        'Odieresis' => '600',   # U=00D6
        'odieresis' => '600',   # U=00F6
        'OE' => '600',   # U=0152
        'oe' => '600',   # U=0153
        'ogonek' => '600',   # U=02DB
        'Ograve' => '600',   # U=00D2
        'ograve' => '600',   # U=00F2
        'Ohungarumlaut' => '600',   # U=0150
        'ohungarumlaut' => '600',   # U=0151
        'Omacron' => '600',   # U=014C
        'omacron' => '600',   # U=014D
        'one' => '600',   # U=0031
        'onehalf' => '600',   # U=00BD
        'onequarter' => '600',   # U=00BC
        'onesuperior' => '600',   # U=00B9
        'ordfeminine' => '600',   # U=00AA
        'ordmasculine' => '600',   # U=00BA
        'Oslash' => '600',   # U=00D8
        'oslash' => '600',   # U=00F8
        'Otilde' => '600',   # U=00D5
        'otilde' => '600',   # U=00F5
        'P' => '600',   # U=0050
        'p' => '600',   # U=0070
        'paragraph' => '600',   # U=00B6
        'parenleft' => '600',   # U=0028
        'parenright' => '600',   # U=0029
        'partialdiff' => '600',   # U=2202
        'percent' => '600',   # U=0025
        'period' => '600',   # U=002E
        'periodcentered' => '600',   # U=00B7
        'perthousand' => '600',   # U=2030
        'plus' => '600',   # U=002B
        'plusminus' => '600',   # U=00B1
        'Q' => '600',   # U=0051
        'q' => '600',   # U=0071
        'question' => '600',   # U=003F
        'questiondown' => '600',   # U=00BF
        'quotedbl' => '600',   # U=0022
        'quotedblbase' => '600',   # U=201E
        'quotedblleft' => '600',   # U=201C
        'quotedblright' => '600',   # U=201D
        'quoteleft' => '600',   # U=2018
        'quoteright' => '600',   # U=2019
        'quotesinglbase' => '600',   # U=201A
        'quotesingle' => '600',   # U=0027
        'R' => '600',   # U=0052
        'r' => '600',   # U=0072
        'Racute' => '600',   # U=0154
        'racute' => '600',   # U=0155
        'radical' => '600',   # U=221A
        'Rcaron' => '600',   # U=0158
        'rcaron' => '600',   # U=0159
        'Rcommaaccent' => '600',   # U=0156
        'rcommaaccent' => '600',   # U=0157
        'registered' => '600',   # U=00AE
        'ring' => '600',   # U=02DA
        'S' => '600',   # U=0053
        's' => '600',   # U=0073
        'Sacute' => '600',   # U=015A
        'sacute' => '600',   # U=015B
        'Scaron' => '600',   # U=0160
        'scaron' => '600',   # U=0161
        'Scedilla' => '600',   # U=015E
        'scedilla' => '600',   # U=015F
        'Scommaaccent' => '600',   # U=0218
        'scommaaccent' => '600',   # U=0219
        'section' => '600',   # U=00A7
        'semicolon' => '600',   # U=003B
        'seven' => '600',   # U=0037
        'six' => '600',   # U=0036
        'slash' => '600',   # U=002F
        'space' => '600',   # U=0020
        'sterling' => '600',   # U=00A3
        'summation' => '600',   # U=2211
        'T' => '600',   # U=0054
        't' => '600',   # U=0074
        'Tcaron' => '600',   # U=0164
        'tcaron' => '600',   # U=0165
        'Tcommaaccent' => '600',   # U=021A
        'tcommaaccent' => '600',   # U=021B
        'Thorn' => '600',   # U=00DE
        'thorn' => '600',   # U=00FE
        'three' => '600',   # U=0033
        'threequarters' => '600',   # U=00BE
        'threesuperior' => '600',   # U=00B3
        'tilde' => '600',   # U=02DC
        'trademark' => '600',   # U=2122
        'two' => '600',   # U=0032
        'twosuperior' => '600',   # U=00B2
        'U' => '600',   # U=0055
        'u' => '600',   # U=0075
        'Uacute' => '600',   # U=00DA
        'uacute' => '600',   # U=00FA
        'Ucircumflex' => '600',   # U=00DB
        'ucircumflex' => '600',   # U=00FB
        'Udieresis' => '600',   # U=00DC
        'udieresis' => '600',   # U=00FC
        'Ugrave' => '600',   # U=00D9
        'ugrave' => '600',   # U=00F9
        'Uhungarumlaut' => '600',   # U=0170
        'uhungarumlaut' => '600',   # U=0171
        'Umacron' => '600',   # U=016A
        'umacron' => '600',   # U=016B
        'underscore' => '600',   # U=005F
        'Uogonek' => '600',   # U=0172
        'uogonek' => '600',   # U=0173
        'Uring' => '600',   # U=016E
        'uring' => '600',   # U=016F
        'V' => '600',   # U=0056
        'v' => '600',   # U=0076
        'W' => '600',   # U=0057
        'w' => '600',   # U=0077
        'X' => '600',   # U=0058
        'x' => '600',   # U=0078
        'Y' => '600',   # U=0059
        'y' => '600',   # U=0079
        'Yacute' => '600',   # U=00DD
        'yacute' => '600',   # U=00FD
        'Ydieresis' => '600',   # U=0178
        'ydieresis' => '600',   # U=00FF
        'yen' => '600',   # U=00A5
        'Z' => '600',   # U=005A
        'z' => '600',   # U=007A
        'Zacute' => '600',   # U=0179
        'zacute' => '600',   # U=017A
        'Zcaron' => '600',   # U=017D
        'zcaron' => '600',   # U=017E
        'Zdotaccent' => '600',   # U=017B
        'zdotaccent' => '600',   # U=017C
        'zero' => '600',   # U=0030
    },
    'comps' => {
        'Abreve' => [ 'A', '0', '0', 'breve', '0', '130' ],   # U=0102
        'abreve' => [ 'A', '0', '0', 'breve', '0', '0' ],   # U=0103
        'Acaron' => [ 'A', '0', '0', 'caron', '0', '130' ],   # U=01CD
        'acaron' => [ 'A', '0', '0', 'caron', '0', '0' ],   # U=01CE
        'Amacron' => [ 'A', '0', '0', 'macron', '0', '130' ],   # U=0100
        'amacron' => [ 'A', '0', '0', 'macron', '0', '0' ],   # U=0101
        'Aogonek' => [ 'A', '0', '0', 'ogonek', '0', '0' ],   # U=0104
        'aogonek' => [ 'A', '0', '0', 'ogonek', '0', '0' ],   # U=0105
        'Bdotaccent' => [ 'B', '0', '0', 'dotaccent', '0', '130' ],   # U=1E02
        'bdotaccent' => [ 'B', '0', '0', 'dotaccent', '0', '0' ],   # U=1E03
        'Cacute' => [ 'C', '0', '0', 'acute', '0', '130' ],   # U=0106
        'cacute' => [ 'C', '0', '0', 'acute', '0', '0' ],   # U=0107
        'Ccaron' => [ 'C', '0', '0', 'caron', '0', '130' ],   # U=010C
        'ccaron' => [ 'C', '0', '0', 'caron', '0', '0' ],   # U=010D
        'Ccircumflex' => [ 'C', '0', '0', 'circumflex', '0', '130' ],   # U=0108
        'ccircumflex' => [ 'C', '0', '0', 'circumflex', '0', '0' ],   # U=0109
        'Cdotaccent' => [ 'C', '0', '0', 'dotaccent', '0', '130' ],   # U=010A
        'cdotaccent' => [ 'C', '0', '0', 'dotaccent', '0', '0' ],   # U=010B
        'Dcaron' => [ 'D', '0', '0', 'caron', '0', '130' ],   # U=010E
        'dcaron' => [ 'D', '0', '0', 'caron', '0', '0' ],   # U=010F
        'Dcedilla' => [ 'D', '0', '0', 'cedilla', '0', '130' ],   # U=1E10
        'dcedilla' => [ 'D', '0', '0', 'cedilla', '0', '0' ],   # U=1E11
        'Ddotaccent' => [ 'D', '0', '0', 'dotaccent', '0', '130' ],   # U=1E0A
        'ddotaccent' => [ 'D', '0', '0', 'dotaccent', '0', '0' ],   # U=1E0B
        'Ebreve' => [ 'E', '0', '0', 'breve', '0', '130' ],   # U=0114
        'ebreve' => [ 'E', '0', '0', 'breve', '0', '0' ],   # U=0115
        'Ecaron' => [ 'E', '0', '0', 'caron', '0', '130' ],   # U=011A
        'ecaron' => [ 'E', '0', '0', 'caron', '0', '0' ],   # U=011B
        'Edotaccent' => [ 'E', '0', '0', 'dotaccent', '0', '130' ],   # U=0116
        'edotaccent' => [ 'E', '0', '0', 'dotaccent', '0', '0' ],   # U=0117
        'Emacron' => [ 'E', '0', '0', 'macron', '0', '130' ],   # U=0112
        'emacron' => [ 'E', '0', '0', 'macron', '0', '0' ],   # U=0113
        'Eogonek' => [ 'E', '0', '0', 'ogonek', '0', '0' ],   # U=0118
        'eogonek' => [ 'E', '0', '0', 'ogonek', '0', '0' ],   # U=0119
        'Etilde' => [ 'E', '0', '0', 'tilde', '0', '130' ],   # U=1EBC
        'etilde' => [ 'E', '0', '0', 'tilde', '0', '0' ],   # U=1EBD
        'Fdotaccent' => [ 'F', '0', '0', 'dotaccent', '0', '130' ],   # U=1E1E
        'fdotaccent' => [ 'F', '0', '0', 'dotaccent', '0', '0' ],   # U=1E1F
        'Gacute' => [ 'G', '0', '0', 'acute', '0', '130' ],   # U=01F4
        'gacute' => [ 'G', '0', '0', 'acute', '0', '0' ],   # U=01F5
        'Gbreve' => [ 'G', '0', '0', 'breve', '0', '130' ],   # U=011E
        'gbreve' => [ 'G', '0', '0', 'breve', '0', '0' ],   # U=011F
        'Gcaron' => [ 'G', '0', '0', 'caron', '0', '136' ],   # U=01E6
        'gcaron' => [ 'g', '0', '0', 'caron', '-30', '0' ],   # U=01E7
        'Gcedilla' => [ 'G', '0', '0', 'cedilla', '0', '130' ],   # U=0122
        'gcedilla' => [ 'G', '0', '0', 'cedilla', '0', '0' ],   # U=0123
        'Gcircumflex' => [ 'G', '0', '0', 'circumflex', '0', '130' ],   # U=011C
        'gcircumflex' => [ 'G', '0', '0', 'circumflex', '0', '0' ],   # U=011D
        'Gdotaccent' => [ 'G', '0', '0', 'dotaccent', '0', '130' ],   # U=0120
        'gdotaccent' => [ 'G', '0', '0', 'dotaccent', '0', '0' ],   # U=0121
        'Gmacron' => [ 'G', '0', '0', 'macron', '0', '130' ],   # U=1E20
        'gmacron' => [ 'G', '0', '0', 'macron', '0', '0' ],   # U=1E21
        'Hcedilla' => [ 'H', '0', '0', 'cedilla', '0', '130' ],   # U=1E28
        'hcedilla' => [ 'H', '0', '0', 'cedilla', '0', '0' ],   # U=1E29
        'Hcircumflex' => [ 'H', '0', '0', 'circumflex', '0', '130' ],   # U=0124
        'hcircumflex' => [ 'H', '0', '0', 'circumflex', '0', '0' ],   # U=0125
        'Hdieresis' => [ 'H', '0', '0', 'dieresis', '0', '130' ],   # U=1E26
        'hdieresis' => [ 'H', '0', '0', 'dieresis', '0', '0' ],   # U=1E27
        'Hdotaccent' => [ 'H', '0', '0', 'dotaccent', '0', '130' ],   # U=1E22
        'hdotaccent' => [ 'H', '0', '0', 'dotaccent', '0', '0' ],   # U=1E23
        'Ibreve' => [ 'I', '0', '0', 'breve', '0', '130' ],   # U=012C
        'ibreve' => [ 'I', '0', '0', 'breve', '0', '0' ],   # U=012D
        'Icaron' => [ 'I', '0', '0', 'caron', '0', '130' ],   # U=01CF
        'icaron' => [ 'I', '0', '0', 'caron', '0', '0' ],   # U=01D0
        'Idotaccent' => [ 'I', '0', '0', 'dotaccent', '0', '130' ],   # U=0130
        'Imacron' => [ 'I', '0', '0', 'macron', '0', '130' ],   # U=012A
        'imacron' => [ 'I', '0', '0', 'macron', '0', '0' ],   # U=012B
        'Iogonek' => [ 'I', '0', '0', 'ogonek', '0', '0' ],   # U=012E
        'iogonek' => [ 'I', '0', '0', 'ogonek', '0', '0' ],   # U=012F
        'Itilde' => [ 'I', '0', '0', 'tilde', '0', '130' ],   # U=0128
        'itilde' => [ 'I', '0', '0', 'tilde', '0', '0' ],   # U=0129
        'Jcircumflex' => [ 'J', '0', '0', 'circumflex', '0', '130' ],   # U=0134
        'jcircumflex' => [ 'J', '0', '0', 'circumflex', '0', '0' ],   # U=0135
        'Kacute' => [ 'K', '0', '0', 'acute', '0', '130' ],   # U=1E30
        'kacute' => [ 'K', '0', '0', 'acute', '0', '0' ],   # U=1E31
        'Kcaron' => [ 'K', '0', '0', 'caron', '0', '130' ],   # U=01E8
        'kcaron' => [ 'K', '0', '0', 'caron', '0', '0' ],   # U=01E9
        'Kcedilla' => [ 'K', '0', '0', 'cedilla', '0', '130' ],   # U=0136
        'kcedilla' => [ 'K', '0', '0', 'cedilla', '0', '0' ],   # U=0137
        'Lacute' => [ 'L', '0', '0', 'acute', '0', '130' ],   # U=0139
        'lacute' => [ 'L', '0', '0', 'acute', '0', '0' ],   # U=013A
        'Lcaron' => [ 'L', '0', '0', 'caron', '0', '130' ],   # U=013D
        'lcaron' => [ 'L', '0', '0', 'caron', '0', '0' ],   # U=013E
        'Lcedilla' => [ 'L', '0', '0', 'cedilla', '0', '130' ],   # U=013B
        'lcedilla' => [ 'L', '0', '0', 'cedilla', '0', '0' ],   # U=013C
        'Ldotaccent' => [ 'L', '0', '0', 'dotaccent', '0', '130' ],   # U=013F
        'ldotaccent' => [ 'L', '0', '0', 'dotaccent', '0', '0' ],   # U=0140
        'Macute' => [ 'M', '0', '0', 'acute', '0', '130' ],   # U=1E3E
        'macute' => [ 'M', '0', '0', 'acute', '0', '0' ],   # U=1E3F
        'Mdotaccent' => [ 'M', '0', '0', 'dotaccent', '0', '130' ],   # U=1E40
        'mdotaccent' => [ 'M', '0', '0', 'dotaccent', '0', '0' ],   # U=1E41
        'Nacute' => [ 'N', '0', '0', 'acute', '0', '130' ],   # U=0143
        'nacute' => [ 'N', '0', '0', 'acute', '0', '0' ],   # U=0144
        'Ncaron' => [ 'N', '0', '0', 'caron', '0', '130' ],   # U=0147
        'ncaron' => [ 'N', '0', '0', 'caron', '0', '0' ],   # U=0148
        'Ncedilla' => [ 'N', '0', '0', 'cedilla', '0', '130' ],   # U=0145
        'ncedilla' => [ 'N', '0', '0', 'cedilla', '0', '0' ],   # U=0146
        'Ndotaccent' => [ 'N', '0', '0', 'dotaccent', '0', '130' ],   # U=1E44
        'ndotaccent' => [ 'N', '0', '0', 'dotaccent', '0', '0' ],   # U=1E45
        'Obreve' => [ 'O', '0', '0', 'breve', '0', '130' ],   # U=014E
        'obreve' => [ 'O', '0', '0', 'breve', '0', '0' ],   # U=014F
        'Ocaron' => [ 'O', '0', '0', 'caron', '0', '130' ],   # U=01D1
        'ocaron' => [ 'O', '0', '0', 'caron', '0', '0' ],   # U=01D2
        'Ohungarumlaut' => [ 'O', '0', '0', 'hungarumlaut', '0', '130' ],   # U=0150
        'ohungarumlaut' => [ 'O', '0', '0', 'hungarumlaut', '0', '0' ],   # U=0151
        'Omacron' => [ 'O', '0', '0', 'macron', '0', '130' ],   # U=014C
        'omacron' => [ 'O', '0', '0', 'macron', '0', '0' ],   # U=014D
        'Oogonek' => [ 'O', '0', '0', 'ogonek', '0', '0' ],   # U=01EA
        'oogonek' => [ 'O', '0', '0', 'ogonek', '0', '0' ],   # U=01EB
        'Pacute' => [ 'P', '0', '0', 'acute', '0', '130' ],   # U=1E54
        'pacute' => [ 'P', '0', '0', 'acute', '0', '0' ],   # U=1E55
        'Pdotaccent' => [ 'P', '0', '0', 'dotaccent', '0', '130' ],   # U=1E56
        'pdotaccent' => [ 'P', '0', '0', 'dotaccent', '0', '0' ],   # U=1E57
        'Racute' => [ 'R', '0', '0', 'acute', '0', '130' ],   # U=0154
        'racute' => [ 'R', '0', '0', 'acute', '0', '0' ],   # U=0155
        'Rcaron' => [ 'R', '0', '0', 'caron', '0', '130' ],   # U=0158
        'rcaron' => [ 'R', '0', '0', 'caron', '0', '0' ],   # U=0159
        'Rcedilla' => [ 'R', '0', '0', 'cedilla', '0', '130' ],   # U=0156
        'rcedilla' => [ 'R', '0', '0', 'cedilla', '0', '0' ],   # U=0157
        'Rdotaccent' => [ 'R', '0', '0', 'dotaccent', '0', '130' ],   # U=1E58
        'rdotaccent' => [ 'R', '0', '0', 'dotaccent', '0', '0' ],   # U=1E59
        'Sacute' => [ 'S', '0', '0', 'acute', '0', '130' ],   # U=015A
        'sacute' => [ 'S', '0', '0', 'acute', '0', '0' ],   # U=015B
        'Scaron' => [ 'S', '0', '0', 'caron', '30', '136' ],   # U=0160
        'scaron' => [ 's', '0', '0', 'caron', '0', '0' ],   # U=0161
        'Scedilla' => [ 'S', '0', '0', 'cedilla', '0', '130' ],   # U=015E
        'scedilla' => [ 'S', '0', '0', 'cedilla', '0', '0' ],   # U=015F
        'Scircumflex' => [ 'S', '0', '0', 'circumflex', '0', '130' ],   # U=015C
        'scircumflex' => [ 'S', '0', '0', 'circumflex', '0', '0' ],   # U=015D
        'Sdotaccent' => [ 'S', '0', '0', 'dotaccent', '0', '130' ],   # U=1E60
        'sdotaccent' => [ 'S', '0', '0', 'dotaccent', '0', '0' ],   # U=1E61
        'Tcaron' => [ 'T', '0', '0', 'caron', '0', '130' ],   # U=0164
        'tcaron' => [ 'T', '0', '0', 'caron', '0', '0' ],   # U=0165
        'Tcedilla' => [ 'T', '0', '0', 'cedilla', '0', '130' ],   # U=0162
        'tcedilla' => [ 'T', '0', '0', 'cedilla', '0', '0' ],   # U=0163
        'Tdotaccent' => [ 'T', '0', '0', 'dotaccent', '0', '130' ],   # U=1E6A
        'tdotaccent' => [ 'T', '0', '0', 'dotaccent', '0', '0' ],   # U=1E6B
        'Ubreve' => [ 'U', '0', '0', 'breve', '0', '130' ],   # U=016C
        'ubreve' => [ 'U', '0', '0', 'breve', '0', '0' ],   # U=016D
        'Ucaron' => [ 'U', '0', '0', 'caron', '0', '130' ],   # U=01D3
        'ucaron' => [ 'U', '0', '0', 'caron', '0', '0' ],   # U=01D4
        'Uhungarumlaut' => [ 'U', '0', '0', 'hungarumlaut', '0', '130' ],   # U=0170
        'uhungarumlaut' => [ 'U', '0', '0', 'hungarumlaut', '0', '0' ],   # U=0171
        'Umacron' => [ 'U', '0', '0', 'macron', '0', '130' ],   # U=016A
        'umacron' => [ 'U', '0', '0', 'macron', '0', '0' ],   # U=016B
        'Uogonek' => [ 'U', '0', '0', 'ogonek', '0', '0' ],   # U=0172
        'uogonek' => [ 'U', '0', '0', 'ogonek', '0', '0' ],   # U=0173
        'Uring' => [ 'U', '0', '0', 'ring', '0', '130' ],   # U=016E
        'uring' => [ 'U', '0', '0', 'ring', '0', '0' ],   # U=016F
        'Utilde' => [ 'U', '0', '0', 'tilde', '0', '130' ],   # U=0168
        'utilde' => [ 'U', '0', '0', 'tilde', '0', '0' ],   # U=0169
        'Vtilde' => [ 'V', '0', '0', 'tilde', '0', '130' ],   # U=1E7C
        'vtilde' => [ 'V', '0', '0', 'tilde', '0', '0' ],   # U=1E7D
        'Wacute' => [ 'W', '0', '0', 'acute', '0', '130' ],   # U=1E82
        'wacute' => [ 'W', '0', '0', 'acute', '0', '0' ],   # U=1E83
        'Wcircumflex' => [ 'W', '0', '0', 'circumflex', '0', '130' ],   # U=0174
        'wcircumflex' => [ 'W', '0', '0', 'circumflex', '0', '0' ],   # U=0175
        'Wdieresis' => [ 'W', '0', '0', 'dieresis', '0', '130' ],   # U=1E84
        'wdieresis' => [ 'W', '0', '0', 'dieresis', '0', '0' ],   # U=1E85
        'Wdotaccent' => [ 'W', '0', '0', 'dotaccent', '0', '130' ],   # U=1E86
        'wdotaccent' => [ 'W', '0', '0', 'dotaccent', '0', '0' ],   # U=1E87
        'Wgrave' => [ 'W', '0', '0', 'grave', '0', '130' ],   # U=1E80
        'wgrave' => [ 'W', '0', '0', 'grave', '0', '0' ],   # U=1E81
        'Xdieresis' => [ 'X', '0', '0', 'dieresis', '0', '130' ],   # U=1E8C
        'xdieresis' => [ 'X', '0', '0', 'dieresis', '0', '0' ],   # U=1E8D
        'Xdotaccent' => [ 'X', '0', '0', 'dotaccent', '0', '130' ],   # U=1E8A
        'xdotaccent' => [ 'X', '0', '0', 'dotaccent', '0', '0' ],   # U=1E8B
        'Ycircumflex' => [ 'Y', '0', '0', 'circumflex', '0', '130' ],   # U=0176
        'ycircumflex' => [ 'Y', '0', '0', 'circumflex', '0', '0' ],   # U=0177
        'Ydieresis' => [ 'Y', '0', '0', 'dieresis', '0', '136' ],   # U=0178
        'Ydotaccent' => [ 'Y', '0', '0', 'dotaccent', '0', '130' ],   # U=1E8E
        'ydotaccent' => [ 'Y', '0', '0', 'dotaccent', '0', '0' ],   # U=1E8F
        'Ygrave' => [ 'Y', '0', '0', 'grave', '0', '130' ],   # U=1EF2
        'ygrave' => [ 'Y', '0', '0', 'grave', '0', '0' ],   # U=1EF3
        'Ytilde' => [ 'Y', '0', '0', 'tilde', '0', '130' ],   # U=1EF8
        'ytilde' => [ 'Y', '0', '0', 'tilde', '0', '0' ],   # U=1EF9
        'Zacute' => [ 'Z', '0', '0', 'acute', '0', '130' ],   # U=0179
        'zacute' => [ 'Z', '0', '0', 'acute', '0', '0' ],   # U=017A
        'Zcaron' => [ 'Z', '0', '0', 'caron', '0', '136' ],   # U=017D
        'zcaron' => [ 'z', '0', '0', 'caron', '10', '0' ],   # U=017E
        'Zcircumflex' => [ 'Z', '0', '0', 'circumflex', '0', '130' ],   # U=1E90
        'zcircumflex' => [ 'Z', '0', '0', 'circumflex', '0', '0' ],   # U=1E91
        'Zdotaccent' => [ 'Z', '0', '0', 'dotaccent', '0', '130' ],   # U=017B
        'zdotaccent' => [ 'Z', '0', '0', 'dotaccent', '0', '0' ],   # U=017C
    },
} };

1;
