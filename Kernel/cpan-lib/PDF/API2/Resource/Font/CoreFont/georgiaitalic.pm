package PDF::API2::Resource::Font::CoreFont::georgiaitalic;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub data { return {
    'fontname' => 'Georgia,Italic',
    'type' => 'TrueType',
    'apiname' => 'GeIt',
    'ascender' => '916',
    'capheight' => '692',
    'descender' => '-219',
    'isfixedpitch' => '0',
    'issymbol' => '0',
    'italicangle' => '-13',
    'underlineposition' => '-183',
    'underlinethickness' => '96',
    'xheight' => '488',
    'firstchar' => '32',
    'lastchar' => '255',
    'flags' => '98',
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
    'fontbbox' => [ -195, -216, 1196, 912 ],
    'wx' => { # HORIZ. WIDTH TABLE
        'space' => '241',                        # C+0x20 # U+0x0020
        'exclam' => '331',                       # C+0x21 # U+0x0021
        'quotedbl' => '411',                     # C+0x22 # U+0x0022
        'numbersign' => '643',                   # C+0x23 # U+0x0023
        'dollar' => '609',                       # C+0x24 # U+0x0024
        'percent' => '817',                      # C+0x25 # U+0x0025
        'ampersand' => '710',                    # C+0x26 # U+0x0026
        'quotesingle' => '215',                  # C+0x27 # U+0x0027
        'parenleft' => '375',                    # C+0x28 # U+0x0028
        'parenright' => '375',                   # C+0x29 # U+0x0029
        'asterisk' => '472',                     # C+0x2A # U+0x002A
        'plus' => '643',                         # C+0x2B # U+0x002B
        'comma' => '269',                        # C+0x2C # U+0x002C
        'hyphen' => '374',                       # C+0x2D # U+0x002D
        'period' => '269',                       # C+0x2E # U+0x002E
        'slash' => '468',                        # C+0x2F # U+0x002F
        'zero' => '613',                         # C+0x30 # U+0x0030
        'one' => '429',                          # C+0x31 # U+0x0031
        'two' => '558',                          # C+0x32 # U+0x0032
        'three' => '551',                        # C+0x33 # U+0x0033
        'four' => '564',                         # C+0x34 # U+0x0034
        'five' => '528',                         # C+0x35 # U+0x0035
        'six' => '565',                          # C+0x36 # U+0x0036
        'seven' => '496',                        # C+0x37 # U+0x0037
        'eight' => '596',                        # C+0x38 # U+0x0038
        'nine' => '565',                         # C+0x39 # U+0x0039
        'colon' => '383',                        # C+0x3A # U+0x003A
        'semicolon' => '383',                    # C+0x3B # U+0x003B
        'less' => '643',                         # C+0x3C # U+0x003C
        'equal' => '643',                        # C+0x3D # U+0x003D
        'greater' => '643',                      # C+0x3E # U+0x003E
        'question' => '478',                     # C+0x3F # U+0x003F
        'at' => '928',                           # C+0x40 # U+0x0040
        'A' => '670',                            # C+0x41 # U+0x0041
        'B' => '653',                            # C+0x42 # U+0x0042
        'C' => '642',                            # C+0x43 # U+0x0043
        'D' => '749',                            # C+0x44 # U+0x0044
        'E' => '653',                            # C+0x45 # U+0x0045
        'F' => '599',                            # C+0x46 # U+0x0046
        'G' => '725',                            # C+0x47 # U+0x0047
        'H' => '814',                            # C+0x48 # U+0x0048
        'I' => '389',                            # C+0x49 # U+0x0049
        'J' => '517',                            # C+0x4A # U+0x004A
        'K' => '694',                            # C+0x4B # U+0x004B
        'L' => '603',                            # C+0x4C # U+0x004C
        'M' => '927',                            # C+0x4D # U+0x004D
        'N' => '767',                            # C+0x4E # U+0x004E
        'O' => '730',                            # C+0x4F # U+0x004F
        'P' => '609',                            # C+0x50 # U+0x0050
        'Q' => '730',                            # C+0x51 # U+0x0051
        'R' => '701',                            # C+0x52 # U+0x0052
        'S' => '561',                            # C+0x53 # U+0x0053
        'T' => '618',                            # C+0x54 # U+0x0054
        'U' => '756',                            # C+0x55 # U+0x0055
        'V' => '666',                            # C+0x56 # U+0x0056
        'W' => '975',                            # C+0x57 # U+0x0057
        'X' => '710',                            # C+0x58 # U+0x0058
        'Y' => '615',                            # C+0x59 # U+0x0059
        'Z' => '601',                            # C+0x5A # U+0x005A
        'bracketleft' => '375',                  # C+0x5B # U+0x005B
        'backslash' => '468',                    # C+0x5C # U+0x005C
        'bracketright' => '375',                 # C+0x5D # U+0x005D
        'asciicircum' => '643',                  # C+0x5E # U+0x005E
        'underscore' => '643',                   # C+0x5F # U+0x005F
        'grave' => '500',                        # C+0x60 # U+0x0060
        'a' => '572',                            # C+0x61 # U+0x0061
        'b' => '553',                            # C+0x62 # U+0x0062
        'c' => '453',                            # C+0x63 # U+0x0063
        'd' => '575',                            # C+0x64 # U+0x0064
        'e' => '471',                            # C+0x65 # U+0x0065
        'f' => '328',                            # C+0x66 # U+0x0066
        'g' => '572',                            # C+0x67 # U+0x0067
        'h' => '562',                            # C+0x68 # U+0x0068
        'i' => '297',                            # C+0x69 # U+0x0069
        'j' => '291',                            # C+0x6A # U+0x006A
        'k' => '527',                            # C+0x6B # U+0x006B
        'l' => '285',                            # C+0x6C # U+0x006C
        'm' => '879',                            # C+0x6D # U+0x006D
        'n' => '589',                            # C+0x6E # U+0x006E
        'o' => '537',                            # C+0x6F # U+0x006F
        'p' => '578',                            # C+0x70 # U+0x0070
        'q' => '555',                            # C+0x71 # U+0x0071
        'r' => '461',                            # C+0x72 # U+0x0072
        's' => '431',                            # C+0x73 # U+0x0073
        't' => '347',                            # C+0x74 # U+0x0074
        'u' => '575',                            # C+0x75 # U+0x0075
        'v' => '538',                            # C+0x76 # U+0x0076
        'w' => '822',                            # C+0x77 # U+0x0077
        'x' => '500',                            # C+0x78 # U+0x0078
        'y' => '559',                            # C+0x79 # U+0x0079
        'z' => '443',                            # C+0x7A # U+0x007A
        'braceleft' => '430',                    # C+0x7B # U+0x007B
        'bar' => '375',                          # C+0x7C # U+0x007C
        'braceright' => '430',                   # C+0x7D # U+0x007D
        'asciitilde' => '643',                   # C+0x7E # U+0x007E
        'bullet' => '392',                       # C+0x7F # U+0x2022
        'Euro' => '642',                         # C+0x80 # U+0x20AC
        'quotesinglbase' => '195',               # C+0x82 # U+0x201A
        'florin' => '519',                       # C+0x83 # U+0x0192
        'quotedblbase' => '385',                 # C+0x84 # U+0x201E
        'ellipsis' => '807',                     # C+0x85 # U+0x2026
        'dagger' => '472',                       # C+0x86 # U+0x2020
        'daggerdbl' => '472',                    # C+0x87 # U+0x2021
        'circumflex' => '500',                   # C+0x88 # U+0x02C6
        'perthousand' => '1227',                 # C+0x89 # U+0x2030
        'Scaron' => '561',                       # C+0x8A # U+0x0160
        'guilsinglleft' => '415',                # C+0x8B # U+0x2039
        'OE' => '998',                           # C+0x8C # U+0x0152
        'Zcaron' => '601',                       # C+0x8E # U+0x017D
        'quoteleft' => '195',                    # C+0x91 # U+0x2018
        'quoteright' => '195',                   # C+0x92 # U+0x2019
        'quotedblleft' => '385',                 # C+0x93 # U+0x201C
        'quotedblright' => '385',                # C+0x94 # U+0x201D
        'endash' => '643',                       # C+0x96 # U+0x2013
        'emdash' => '856',                       # C+0x97 # U+0x2014
        'tilde' => '500',                        # C+0x98 # U+0x02DC
        'trademark' => '942',                    # C+0x99 # U+0x2122
        'scaron' => '431',                       # C+0x9A # U+0x0161
        'guilsinglright' => '415',               # C+0x9B # U+0x203A
        'oe' => '825',                           # C+0x9C # U+0x0153
        'zcaron' => '443',                       # C+0x9E # U+0x017E
        'Ydieresis' => '615',                    # C+0x9F # U+0x0178
        'exclamdown' => '331',                   # C+0xA1 # U+0x00A1
        'cent' => '555',                         # C+0xA2 # U+0x00A2
        'sterling' => '622',                     # C+0xA3 # U+0x00A3
        'currency' => '571',                     # C+0xA4 # U+0x00A4
        'yen' => '614',                          # C+0xA5 # U+0x00A5
        'brokenbar' => '375',                    # C+0xA6 # U+0x00A6
        'section' => '500',                      # C+0xA7 # U+0x00A7
        'dieresis' => '500',                     # C+0xA8 # U+0x00A8
        'copyright' => '941',                    # C+0xA9 # U+0x00A9
        'ordfeminine' => '500',                  # C+0xAA # U+0x00AA
        'guillemotleft' => '581',                # C+0xAB # U+0x00AB
        'logicalnot' => '643',                   # C+0xAC # U+0x00AC
        'registered' => '941',                   # C+0xAE # U+0x00AE
        'macron' => '500',                       # C+0xAF # U+0x00AF
        'degree' => '419',                       # C+0xB0 # U+0x00B0
        'plusminus' => '643',                    # C+0xB1 # U+0x00B1
        'twosuperior' => '500',                  # C+0xB2 # U+0x00B2
        'threesuperior' => '500',                # C+0xB3 # U+0x00B3
        'acute' => '500',                        # C+0xB4 # U+0x00B4
        'mu' => '575',                           # C+0xB5 # U+0x00B5
        'paragraph' => '500',                    # C+0xB6 # U+0x00B6
        'periodcentered' => '279',               # C+0xB7 # U+0x00B7
        'cedilla' => '500',                      # C+0xB8 # U+0x00B8
        'onesuperior' => '500',                  # C+0xB9 # U+0x00B9
        'ordmasculine' => '500',                 # C+0xBA # U+0x00BA
        'guillemotright' => '581',               # C+0xBB # U+0x00BB
        'onequarter' => '1049',                  # C+0xBC # U+0x00BC
        'onehalf' => '1049',                     # C+0xBD # U+0x00BD
        'threequarters' => '1049',               # C+0xBE # U+0x00BE
        'questiondown' => '478',                 # C+0xBF # U+0x00BF
        'Agrave' => '670',                       # C+0xC0 # U+0x00C0
        'Aacute' => '670',                       # C+0xC1 # U+0x00C1
        'Acircumflex' => '670',                  # C+0xC2 # U+0x00C2
        'Atilde' => '670',                       # C+0xC3 # U+0x00C3
        'Adieresis' => '670',                    # C+0xC4 # U+0x00C4
        'Aring' => '670',                        # C+0xC5 # U+0x00C5
        'AE' => '970',                           # C+0xC6 # U+0x00C6
        'Ccedilla' => '642',                     # C+0xC7 # U+0x00C7
        'Egrave' => '653',                       # C+0xC8 # U+0x00C8
        'Eacute' => '653',                       # C+0xC9 # U+0x00C9
        'Ecircumflex' => '653',                  # C+0xCA # U+0x00CA
        'Edieresis' => '653',                    # C+0xCB # U+0x00CB
        'Igrave' => '389',                       # C+0xCC # U+0x00CC
        'Iacute' => '389',                       # C+0xCD # U+0x00CD
        'Icircumflex' => '389',                  # C+0xCE # U+0x00CE
        'Idieresis' => '389',                    # C+0xCF # U+0x00CF
        'Eth' => '749',                          # C+0xD0 # U+0x00D0
        'Ntilde' => '767',                       # C+0xD1 # U+0x00D1
        'Ograve' => '744',                       # C+0xD2 # U+0x00D2
        'Oacute' => '744',                       # C+0xD3 # U+0x00D3
        'Ocircumflex' => '744',                  # C+0xD4 # U+0x00D4
        'Otilde' => '730',                       # C+0xD5 # U+0x00D5
        'Odieresis' => '744',                    # C+0xD6 # U+0x00D6
        'multiply' => '643',                     # C+0xD7 # U+0x00D7
        'Oslash' => '744',                       # C+0xD8 # U+0x00D8
        'Ugrave' => '756',                       # C+0xD9 # U+0x00D9
        'Uacute' => '756',                       # C+0xDA # U+0x00DA
        'Ucircumflex' => '756',                  # C+0xDB # U+0x00DB
        'Udieresis' => '756',                    # C+0xDC # U+0x00DC
        'Yacute' => '615',                       # C+0xDD # U+0x00DD
        'Thorn' => '614',                        # C+0xDE # U+0x00DE
        'germandbls' => '541',                   # C+0xDF # U+0x00DF
        'agrave' => '572',                       # C+0xE0 # U+0x00E0
        'aacute' => '572',                       # C+0xE1 # U+0x00E1
        'acircumflex' => '572',                  # C+0xE2 # U+0x00E2
        'atilde' => '572',                       # C+0xE3 # U+0x00E3
        'adieresis' => '572',                    # C+0xE4 # U+0x00E4
        'aring' => '572',                        # C+0xE5 # U+0x00E5
        'ae' => '764',                           # C+0xE6 # U+0x00E6
        'ccedilla' => '453',                     # C+0xE7 # U+0x00E7
        'egrave' => '471',                       # C+0xE8 # U+0x00E8
        'eacute' => '471',                       # C+0xE9 # U+0x00E9
        'ecircumflex' => '471',                  # C+0xEA # U+0x00EA
        'edieresis' => '471',                    # C+0xEB # U+0x00EB
        'igrave' => '297',                       # C+0xEC # U+0x00EC
        'iacute' => '297',                       # C+0xED # U+0x00ED
        'icircumflex' => '297',                  # C+0xEE # U+0x00EE
        'idieresis' => '297',                    # C+0xEF # U+0x00EF
        'eth' => '546',                          # C+0xF0 # U+0x00F0
        'ntilde' => '589',                       # C+0xF1 # U+0x00F1
        'ograve' => '537',                       # C+0xF2 # U+0x00F2
        'oacute' => '537',                       # C+0xF3 # U+0x00F3
        'ocircumflex' => '537',                  # C+0xF4 # U+0x00F4
        'otilde' => '537',                       # C+0xF5 # U+0x00F5
        'odieresis' => '537',                    # C+0xF6 # U+0x00F6
        'divide' => '643',                       # C+0xF7 # U+0x00F7
        'oslash' => '537',                       # C+0xF8 # U+0x00F8
        'ugrave' => '575',                       # C+0xF9 # U+0x00F9
        'uacute' => '575',                       # C+0xFA # U+0x00FA
        'ucircumflex' => '575',                  # C+0xFB # U+0x00FB
        'udieresis' => '575',                    # C+0xFC # U+0x00FC
        'yacute' => '559',                       # C+0xFD # U+0x00FD
        'thorn' => '552',                        # C+0xFE # U+0x00FE
        'ydieresis' => '559',                    # C+0xFF # U+0x00FF
        'middot' => '279',                       # U+0x00B7
        'Amacron' => '670',                      # U+0x0100
        'amacron' => '572',                      # U+0x0101
        'Abreve' => '670',                       # U+0x0102
        'abreve' => '572',                       # U+0x0103
        'Aogonek' => '670',                      # U+0x0104
        'aogonek' => '572',                      # U+0x0105
        'Cacute' => '642',                       # U+0x0106
        'cacute' => '453',                       # U+0x0107
        'Ccircumflex' => '642',                  # U+0x0108
        'ccircumflex' => '453',                  # U+0x0109
        'Cdotaccent' => '642',                   # U+0x010A
        'cdotaccent' => '453',                   # U+0x010B
        'Ccaron' => '642',                       # U+0x010C
        'ccaron' => '453',                       # U+0x010D
        'Dcaron' => '749',                       # U+0x010E
        'dcaron' => '686',                       # U+0x010F
        'Dcroat' => '749',                       # U+0x0110
        'dcroat' => '575',                       # U+0x0111
        'Emacron' => '653',                      # U+0x0112
        'emacron' => '471',                      # U+0x0113
        'Ebreve' => '653',                       # U+0x0114
        'ebreve' => '471',                       # U+0x0115
        'Edotaccent' => '653',                   # U+0x0116
        'edotaccent' => '471',                   # U+0x0117
        'Eogonek' => '653',                      # U+0x0118
        'eogonek' => '471',                      # U+0x0119
        'Ecaron' => '653',                       # U+0x011A
        'ecaron' => '471',                       # U+0x011B
        'Gcircumflex' => '725',                  # U+0x011C
        'gcircumflex' => '572',                  # U+0x011D
        'Gbreve' => '725',                       # U+0x011E
        'gbreve' => '572',                       # U+0x011F
        'Gdotaccent' => '725',                   # U+0x0120
        'gdotaccent' => '572',                   # U+0x0121
        'Gcommaaccent' => '725',                 # U+0x0122
        'gcommaaccent' => '572',                 # U+0x0123
        'Hcircumflex' => '814',                  # U+0x0124
        'hcircumflex' => '562',                  # U+0x0125
        'Hbar' => '814',                         # U+0x0126
        'hbar' => '562',                         # U+0x0127
        'Itilde' => '389',                       # U+0x0128
        'itilde' => '297',                       # U+0x0129
        'Imacron' => '389',                      # U+0x012A
        'imacron' => '297',                      # U+0x012B
        'Ibreve' => '389',                       # U+0x012C
        'ibreve' => '297',                       # U+0x012D
        'Iogonek' => '389',                      # U+0x012E
        'iogonek' => '297',                      # U+0x012F
        'Idotaccent' => '389',                   # U+0x0130
        'dotlessi' => '297',                     # U+0x0131
        'IJ' => '877',                           # U+0x0132
        'ij' => '576',                           # U+0x0133
        'Jcircumflex' => '517',                  # U+0x0134
        'jcircumflex' => '291',                  # U+0x0135
        'Kcommaaccent' => '694',                 # U+0x0136
        'kcommaaccent' => '527',                 # U+0x0137
        'kgreenlandic' => '555',                 # U+0x0138
        'Lacute' => '603',                       # U+0x0139
        'lacute' => '285',                       # U+0x013A
        'Lcommaaccent' => '603',                 # U+0x013B
        'lcommaaccent' => '285',                 # U+0x013C
        'Lcaron' => '603',                       # U+0x013D
        'lcaron' => '389',                       # U+0x013E
        'Ldot' => '603',                         # U+0x013F
        'ldot' => '420',                         # U+0x0140
        'Lslash' => '603',                       # U+0x0141
        'lslash' => '285',                       # U+0x0142
        'Nacute' => '767',                       # U+0x0143
        'nacute' => '589',                       # U+0x0144
        'Ncommaaccent' => '767',                 # U+0x0145
        'ncommaaccent' => '589',                 # U+0x0146
        'Ncaron' => '767',                       # U+0x0147
        'ncaron' => '589',                       # U+0x0148
        'napostrophe' => '628',                  # U+0x0149
        'Eng' => '767',                          # U+0x014A
        'eng' => '578',                          # U+0x014B
        'Omacron' => '730',                      # U+0x014C
        'omacron' => '537',                      # U+0x014D
        'Obreve' => '730',                       # U+0x014E
        'obreve' => '537',                       # U+0x014F
        'Ohungarumlaut' => '730',                # U+0x0150
        'ohungarumlaut' => '537',                # U+0x0151
        'Racute' => '701',                       # U+0x0154
        'racute' => '461',                       # U+0x0155
        'Rcommaaccent' => '701',                 # U+0x0156
        'rcommaaccent' => '461',                 # U+0x0157
        'Rcaron' => '701',                       # U+0x0158
        'rcaron' => '461',                       # U+0x0159
        'Sacute' => '561',                       # U+0x015A
        'sacute' => '431',                       # U+0x015B
        'Scircumflex' => '561',                  # U+0x015C
        'scircumflex' => '431',                  # U+0x015D
        'Scedilla' => '561',                     # U+0x015E
        'scedilla' => '431',                     # U+0x015F
        'Tcommaaccent' => '618',                 # U+0x0162
        'tcommaaccent' => '347',                 # U+0x0163
        'Tcaron' => '618',                       # U+0x0164
        'tcaron' => '347',                       # U+0x0165
        'Tbar' => '618',                         # U+0x0166
        'tbar' => '347',                         # U+0x0167
        'Utilde' => '756',                       # U+0x0168
        'utilde' => '575',                       # U+0x0169
        'Umacron' => '756',                      # U+0x016A
        'umacron' => '575',                      # U+0x016B
        'Ubreve' => '756',                       # U+0x016C
        'ubreve' => '575',                       # U+0x016D
        'Uring' => '756',                        # U+0x016E
        'uring' => '575',                        # U+0x016F
        'Uhungarumlaut' => '756',                # U+0x0170
        'uhungarumlaut' => '575',                # U+0x0171
        'Uogonek' => '756',                      # U+0x0172
        'uogonek' => '575',                      # U+0x0173
        'Wcircumflex' => '975',                  # U+0x0174
        'wcircumflex' => '822',                  # U+0x0175
        'Ycircumflex' => '615',                  # U+0x0176
        'ycircumflex' => '559',                  # U+0x0177
        'Zacute' => '601',                       # U+0x0179
        'zacute' => '443',                       # U+0x017A
        'Zdotaccent' => '601',                   # U+0x017B
        'zdotaccent' => '443',                   # U+0x017C
        'longs' => '294',                        # U+0x017F
        'Aringacute' => '670',                   # U+0x01FA
        'aringacute' => '572',                   # U+0x01FB
        'AEacute' => '970',                      # U+0x01FC
        'aeacute' => '764',                      # U+0x01FD
        'Oslashacute' => '744',                  # U+0x01FE
        'oslashacute' => '537',                  # U+0x01FF
        'Scommaaccent' => '561',                 # U+0x0218
        'scommaaccent' => '431',                 # U+0x0219
        'caron' => '500',                        # U+0x02C7
        'breve' => '500',                        # U+0x02D8
        'dotaccent' => '500',                    # U+0x02D9
        'ring' => '572',                         # U+0x02DA
        'ogonek' => '500',                       # U+0x02DB
        'hungarumlaut' => '500',                 # U+0x02DD
        'tonos' => '500',                        # U+0x0384
        'dieresistonos' => '500',                # U+0x0385
        'Alphatonos' => '675',                   # U+0x0386
        'anoteleia' => '383',                    # U+0x0387
        'Epsilontonos' => '798',                 # U+0x0388
        'Etatonos' => '959',                     # U+0x0389
        'Iotatonos' => '532',                    # U+0x038A
        'Omicrontonos' => '848',                 # U+0x038C
        'Upsilontonos' => '800',                 # U+0x038E
        'Omegatonos' => '885',                   # U+0x038F
        'iotadieresistonos' => '280',            # U+0x0390
        'Alpha' => '670',                        # U+0x0391
        'Beta' => '653',                         # U+0x0392
        'Gamma' => '583',                        # U+0x0393
        'Delta' => '668',                        # U+0x0394
        'Epsilon' => '653',                      # U+0x0395
        'Zeta' => '601',                         # U+0x0396
        'Eta' => '814',                          # U+0x0397
        'Theta' => '730',                        # U+0x0398
        'Iota' => '389',                         # U+0x0399
        'Kappa' => '694',                        # U+0x039A
        'Lambda' => '673',                       # U+0x039B
        'Mu' => '927',                           # U+0x039C
        'Nu' => '767',                           # U+0x039D
        'Xi' => '693',                           # U+0x039E
        'Omicron' => '730',                      # U+0x039F
        'Pi' => '808',                           # U+0x03A0
        'Rho' => '609',                          # U+0x03A1
        'Sigma' => '603',                        # U+0x03A3
        'Tau' => '618',                          # U+0x03A4
        'Upsilon' => '615',                      # U+0x03A5
        'Phi' => '766',                          # U+0x03A6
        'Chi' => '710',                          # U+0x03A7
        'Psi' => '874',                          # U+0x03A8
        'Omega' => '778',                        # U+0x03A9
        'Iotadieresis' => '389',                 # U+0x03AA
        'Upsilondieresis' => '615',              # U+0x03AB
        'alphatonos' => '598',                   # U+0x03AC
        'epsilontonos' => '463',                 # U+0x03AD
        'etatonos' => '578',                     # U+0x03AE
        'iotatonos' => '280',                    # U+0x03AF
        'upsilondieresistonos' => '538',         # U+0x03B0
        'alpha' => '598',                        # U+0x03B1
        'beta' => '566',                         # U+0x03B2
        'gamma' => '508',                        # U+0x03B3
        'delta' => '538',                        # U+0x03B4
        'epsilon' => '463',                      # U+0x03B5
        'zeta' => '401',                         # U+0x03B6
        'eta' => '578',                          # U+0x03B7
        'theta' => '551',                        # U+0x03B8
        'iota' => '280',                         # U+0x03B9
        'kappa' => '555',                        # U+0x03BA
        'lambda' => '487',                       # U+0x03BB
        'nu' => '501',                           # U+0x03BD
        'xi' => '438',                           # U+0x03BE
        'omicron' => '537',                      # U+0x03BF
        'pi' => '603',                           # U+0x03C0
        'rho' => '562',                          # U+0x03C1
        'sigma1' => '440',                       # U+0x03C2
        'sigma' => '569',                        # U+0x03C3
        'tau' => '449',                          # U+0x03C4
        'upsilon' => '538',                      # U+0x03C5
        'phi' => '708',                          # U+0x03C6
        'chi' => '506',                          # U+0x03C7
        'psi' => '735',                          # U+0x03C8
        'omega' => '725',                        # U+0x03C9
        'iotadieresis' => '280',                 # U+0x03CA
        'upsilondieresis' => '538',              # U+0x03CB
        'omicrontonos' => '537',                 # U+0x03CC
        'upsilontonos' => '538',                 # U+0x03CD
        'omegatonos' => '725',                   # U+0x03CE
        'afii10023' => '653',                    # U+0x0401
        'afii10051' => '785',                    # U+0x0402
        'afii10052' => '583',                    # U+0x0403
        'afii10053' => '656',                    # U+0x0404
        'afii10054' => '561',                    # U+0x0405
        'afii10055' => '389',                    # U+0x0406
        'afii10056' => '389',                    # U+0x0407
        'afii10057' => '517',                    # U+0x0408
        'afii10058' => '1013',                   # U+0x0409
        'afii10059' => '1066',                   # U+0x040A
        'afii10060' => '839',                    # U+0x040B
        'afii10061' => '694',                    # U+0x040C
        'afii10062' => '656',                    # U+0x040E
        'afii10145' => '810',                    # U+0x040F
        'afii10017' => '670',                    # U+0x0410
        'afii10018' => '655',                    # U+0x0411
        'afii10019' => '653',                    # U+0x0412
        'afii10020' => '583',                    # U+0x0413
        'afii10021' => '722',                    # U+0x0414
        'afii10022' => '653',                    # U+0x0415
        'afii10024' => '983',                    # U+0x0416
        'afii10025' => '609',                    # U+0x0417
        'afii10026' => '818',                    # U+0x0418
        'afii10027' => '818',                    # U+0x0419
        'afii10028' => '694',                    # U+0x041A
        'afii10029' => '756',                    # U+0x041B
        'afii10030' => '927',                    # U+0x041C
        'afii10031' => '814',                    # U+0x041D
        'afii10032' => '730',                    # U+0x041E
        'afii10033' => '808',                    # U+0x041F
        'afii10034' => '609',                    # U+0x0420
        'afii10035' => '642',                    # U+0x0421
        'afii10036' => '618',                    # U+0x0422
        'afii10037' => '656',                    # U+0x0423
        'afii10038' => '766',                    # U+0x0424
        'afii10039' => '710',                    # U+0x0425
        'afii10040' => '808',                    # U+0x0426
        'afii10041' => '748',                    # U+0x0427
        'afii10042' => '1088',                   # U+0x0428
        'afii10043' => '1088',                   # U+0x0429
        'afii10044' => '763',                    # U+0x042A
        'afii10045' => '970',                    # U+0x042B
        'afii10046' => '642',                    # U+0x042C
        'afii10047' => '657',                    # U+0x042D
        'afii10048' => '1065',                   # U+0x042E
        'afii10049' => '696',                    # U+0x042F
        'afii10065' => '572',                    # U+0x0430
        'afii10066' => '537',                    # U+0x0431
        'afii10067' => '515',                    # U+0x0432
        'afii10068' => '458',                    # U+0x0433
        'afii10069' => '532',                    # U+0x0434
        'afii10070' => '471',                    # U+0x0435
        'afii10072' => '893',                    # U+0x0436
        'afii10073' => '473',                    # U+0x0437
        'afii10074' => '575',                    # U+0x0438
        'afii10075' => '575',                    # U+0x0439
        'afii10076' => '539',                    # U+0x043A
        'afii10077' => '564',                    # U+0x043B
        'afii10078' => '739',                    # U+0x043C
        'afii10079' => '588',                    # U+0x043D
        'afii10080' => '537',                    # U+0x043E
        'afii10081' => '589',                    # U+0x043F
        'afii10082' => '578',                    # U+0x0440
        'afii10083' => '453',                    # U+0x0441
        'afii10084' => '879',                    # U+0x0442
        'afii10085' => '559',                    # U+0x0443
        'afii10086' => '740',                    # U+0x0444
        'afii10087' => '500',                    # U+0x0445
        'afii10088' => '575',                    # U+0x0446
        'afii10089' => '558',                    # U+0x0447
        'afii10090' => '856',                    # U+0x0448
        'afii10091' => '856',                    # U+0x0449
        'afii10092' => '537',                    # U+0x044A
        'afii10093' => '736',                    # U+0x044B
        'afii10094' => '486',                    # U+0x044C
        'afii10095' => '486',                    # U+0x044D
        'afii10096' => '791',                    # U+0x044E
        'afii10097' => '546',                    # U+0x044F
        'afii10071' => '471',                    # U+0x0451
        'afii10099' => '551',                    # U+0x0452
        'afii10100' => '458',                    # U+0x0453
        'afii10101' => '488',                    # U+0x0454
        'afii10102' => '431',                    # U+0x0455
        'afii10103' => '297',                    # U+0x0456
        'afii10104' => '297',                    # U+0x0457
        'afii10105' => '291',                    # U+0x0458
        'afii10106' => '762',                    # U+0x0459
        'afii10107' => '783',                    # U+0x045A
        'afii10108' => '562',                    # U+0x045B
        'afii10109' => '539',                    # U+0x045C
        'afii10110' => '559',                    # U+0x045E
        'afii10193' => '575',                    # U+0x045F
        'afii10050' => '576',                    # U+0x0490
        'afii10098' => '430',                    # U+0x0491
        'Wgrave' => '975',                       # U+0x1E80
        'wgrave' => '822',                       # U+0x1E81
        'Wacute' => '975',                       # U+0x1E82
        'wacute' => '822',                       # U+0x1E83
        'Wdieresis' => '975',                    # U+0x1E84
        'wdieresis' => '822',                    # U+0x1E85
        'Ygrave' => '615',                       # U+0x1EF2
        'ygrave' => '559',                       # U+0x1EF3
        'afii00208' => '856',                    # U+0x2015
        'underscoredbl' => '643',                # U+0x2017
        'quotereversed' => '195',                # U+0x201B
        'minute' => '321',                       # U+0x2032
        'second' => '517',                       # U+0x2033
        'exclamdbl' => '575',                    # U+0x203C
        'fraction' => '143',                     # U+0x2044
        'foursuperior' => '500',                 # U+0x2074
        'fivesuperior' => '500',                 # U+0x2075
        'sevensuperior' => '500',                # U+0x2077
        'eightsuperior' => '500',                # U+0x2078
        'nsuperior' => '500',                    # U+0x207F
        'franc' => '599',                        # U+0x20A3
        'lira' => '622',                         # U+0x20A4
        'peseta' => '1204',                      # U+0x20A7
        'afii61248' => '817',                    # U+0x2105
        'afii61289' => '323',                    # U+0x2113
        'afii61352' => '1220',                   # U+0x2116
        'estimated' => '615',                    # U+0x212E
        'oneeighth' => '1049',                   # U+0x215B
        'threeeighths' => '1049',                # U+0x215C
        'fiveeighths' => '1049',                 # U+0x215D
        'seveneighths' => '1049',                # U+0x215E
        'partialdiff' => '576',                  # U+0x2202
        'product' => '834',                      # U+0x220F
        'summation' => '705',                    # U+0x2211
        'minus' => '643',                        # U+0x2212
        'radical' => '668',                      # U+0x221A
        'infinity' => '716',                     # U+0x221E
        'integral' => '499',                     # U+0x222B
        'approxequal' => '643',                  # U+0x2248
        'notequal' => '643',                     # U+0x2260
        'lessequal' => '643',                    # U+0x2264
        'greaterequal' => '643',                 # U+0x2265
        'H22073' => '604',                       # U+0x25A1
        'H18543' => '354',                       # U+0x25AA
        'H18551' => '354',                       # U+0x25AB
        'lozenge' => '561',                      # U+0x25CA
        'H18533' => '604',                       # U+0x25CF
        'openbullet' => '354',                   # U+0x25E6
        'commaaccent' => '604',                  # U+0xF6C3
        'Acute' => '500',                        # U+0xF6C9
        'Caron' => '500',                        # U+0xF6CA
        'Dieresis' => '500',                     # U+0xF6CB
        'Grave' => '500',                        # U+0xF6CE
        'Hungarumlaut' => '500',                 # U+0xF6CF
        'radicalex' => '596',                    # U+0xF8E5
        'fi' => '583',                           # U+0xFB01
        'fl' => '602',                           # U+0xFB02
    }, # HORIZ. WIDTH TABLE
} };

1;
