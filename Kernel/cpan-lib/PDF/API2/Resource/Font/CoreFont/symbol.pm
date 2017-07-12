package PDF::API2::Resource::Font::CoreFont::symbol;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub data { return {
    'fontname' => 'Symbol',
    'type' => 'Type1',
    'apiname' => 'Sym',
    'ascender' => '600',
    'capheight' => '600',
    'descender' => '-200',
    'iscore' => '1',
    'isfixedpitch' => '0',
    'issymbol' => '1',
    'italicangle' => '0',
    'stdhw' => '92',
    'stdvw' => '85',
    'underlineposition' => '-100',
    'underlinethickness' => '50',
    'xheight' => '450',
    'firstchar' => '32',
    'lastchar' => '255',
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
        'space',                                 # C+0x20 # U+0xF020
        'exclam',                                # C+0x21 # U+0xF021
        'universal',                             # C+0x22 # U+0xF022
        'numbersign',                            # C+0x23 # U+0xF023
        'existential',                           # C+0x24 # U+0xF024
        'percent',                               # C+0x25 # U+0xF025
        'ampersand',                             # C+0x26 # U+0xF026
        'suchthat',                              # C+0x27 # U+0xF027
        'parenleft',                             # C+0x28 # U+0xF028
        'parenright',                            # C+0x29 # U+0xF029
        'asteriskmath',                          # C+0x2A # U+0xF02A
        'plus',                                  # C+0x2B # U+0xF02B
        'comma',                                 # C+0x2C # U+0xF02C
        'minus',                                 # C+0x2D # U+0xF02D
        'period',                                # C+0x2E # U+0xF02E
        'slash',                                 # C+0x2F # U+0xF02F
        'zero',                                  # C+0x30 # U+0xF030
        'one',                                   # C+0x31 # U+0xF031
        'two',                                   # C+0x32 # U+0xF032
        'three',                                 # C+0x33 # U+0xF033
        'four',                                  # C+0x34 # U+0xF034
        'five',                                  # C+0x35 # U+0xF035
        'six',                                   # C+0x36 # U+0xF036
        'seven',                                 # C+0x37 # U+0xF037
        'eight',                                 # C+0x38 # U+0xF038
        'nine',                                  # C+0x39 # U+0xF039
        'colon',                                 # C+0x3A # U+0xF03A
        'semicolon',                             # C+0x3B # U+0xF03B
        'less',                                  # C+0x3C # U+0xF03C
        'equal',                                 # C+0x3D # U+0xF03D
        'greater',                               # C+0x3E # U+0xF03E
        'question',                              # C+0x3F # U+0xF03F
        'congruent',                             # C+0x40 # U+0xF040
        'Alpha',                                 # C+0x41 # U+0xF041
        'Beta',                                  # C+0x42 # U+0xF042
        'Chi',                                   # C+0x43 # U+0xF043
        'Delta',                                 # C+0x44 # U+0xF044
        'Epsilon',                               # C+0x45 # U+0xF045
        'Phi',                                   # C+0x46 # U+0xF046
        'Gamma',                                 # C+0x47 # U+0xF047
        'Eta',                                   # C+0x48 # U+0xF048
        'Iota',                                  # C+0x49 # U+0xF049
        'theta1',                                # C+0x4A # U+0xF04A
        'Kappa',                                 # C+0x4B # U+0xF04B
        'Lambda',                                # C+0x4C # U+0xF04C
        'Mu',                                    # C+0x4D # U+0xF04D
        'Nu',                                    # C+0x4E # U+0xF04E
        'Omicron',                               # C+0x4F # U+0xF04F
        'Pi',                                    # C+0x50 # U+0xF050
        'Theta',                                 # C+0x51 # U+0xF051
        'Rho',                                   # C+0x52 # U+0xF052
        'Sigma',                                 # C+0x53 # U+0xF053
        'Tau',                                   # C+0x54 # U+0xF054
        'Upsilon',                               # C+0x55 # U+0xF055
        'sigma1',                                # C+0x56 # U+0xF056
        'Omega',                                 # C+0x57 # U+0xF057
        'Xi',                                    # C+0x58 # U+0xF058
        'Psi',                                   # C+0x59 # U+0xF059
        'Zeta',                                  # C+0x5A # U+0xF05A
        'bracketleft',                           # C+0x5B # U+0xF05B
        'therefore',                             # C+0x5C # U+0xF05C
        'bracketright',                          # C+0x5D # U+0xF05D
        'perpendicular',                         # C+0x5E # U+0xF05E
        'underscore',                            # C+0x5F # U+0xF05F
        'radicalex',                             # C+0x60 # U+0xF060
        'alpha',                                 # C+0x61 # U+0xF061
        'beta',                                  # C+0x62 # U+0xF062
        'chi',                                   # C+0x63 # U+0xF063
        'delta',                                 # C+0x64 # U+0xF064
        'epsilon',                               # C+0x65 # U+0xF065
        'phi',                                   # C+0x66 # U+0xF066
        'gamma',                                 # C+0x67 # U+0xF067
        'eta',                                   # C+0x68 # U+0xF068
        'iota',                                  # C+0x69 # U+0xF069
        'phi1',                                  # C+0x6A # U+0xF06A
        'kappa',                                 # C+0x6B # U+0xF06B
        'lambda',                                # C+0x6C # U+0xF06C
        'mu',                                    # C+0x6D # U+0xF06D
        'nu',                                    # C+0x6E # U+0xF06E
        'omicron',                               # C+0x6F # U+0xF06F
        'pi',                                    # C+0x70 # U+0xF070
        'theta',                                 # C+0x71 # U+0xF071
        'rho',                                   # C+0x72 # U+0xF072
        'sigma',                                 # C+0x73 # U+0xF073
        'tau',                                   # C+0x74 # U+0xF074
        'upsilon',                               # C+0x75 # U+0xF075
        'omega1',                                # C+0x76 # U+0xF076
        'omega',                                 # C+0x77 # U+0xF077
        'xi',                                    # C+0x78 # U+0xF078
        'psi',                                   # C+0x79 # U+0xF079
        'zeta',                                  # C+0x7A # U+0xF07A
        'braceleft',                             # C+0x7B # U+0xF07B
        'bar',                                   # C+0x7C # U+0xF07C
        'braceright',                            # C+0x7D # U+0xF07D
        'similar',                               # C+0x7E # U+0xF07E
        '.notdef',                               # C+0x7F # U+0x0000
        '.notdef',                               # C+0x80 # U+0x0000
        '.notdef',                               # C+0x81 # U+0x0000
        '.notdef',                               # C+0x82 # U+0x0000
        '.notdef',                               # C+0x83 # U+0x0000
        '.notdef',                               # C+0x84 # U+0x0000
        '.notdef',                               # C+0x85 # U+0x0000
        '.notdef',                               # C+0x86 # U+0x0000
        '.notdef',                               # C+0x87 # U+0x0000
        '.notdef',                               # C+0x88 # U+0x0000
        '.notdef',                               # C+0x89 # U+0x0000
        '.notdef',                               # C+0x8A # U+0x0000
        '.notdef',                               # C+0x8B # U+0x0000
        '.notdef',                               # C+0x8C # U+0x0000
        '.notdef',                               # C+0x8D # U+0x0000
        '.notdef',                               # C+0x8E # U+0x0000
        '.notdef',                               # C+0x8F # U+0x0000
        '.notdef',                               # C+0x90 # U+0x0000
        '.notdef',                               # C+0x91 # U+0x0000
        '.notdef',                               # C+0x92 # U+0x0000
        '.notdef',                               # C+0x93 # U+0x0000
        '.notdef',                               # C+0x94 # U+0x0000
        '.notdef',                               # C+0x95 # U+0x0000
        '.notdef',                               # C+0x96 # U+0x0000
        '.notdef',                               # C+0x97 # U+0x0000
        '.notdef',                               # C+0x98 # U+0x0000
        '.notdef',                               # C+0x99 # U+0x0000
        '.notdef',                               # C+0x9A # U+0x0000
        '.notdef',                               # C+0x9B # U+0x0000
        '.notdef',                               # C+0x9C # U+0x0000
        '.notdef',                               # C+0x9D # U+0x0000
        '.notdef',                               # C+0x9E # U+0x0000
        '.notdef',                               # C+0x9F # U+0x0000
        'Euro',                                  # C+0xA0 # U+0xF0A0
        'Upsilon1',                              # C+0xA1 # U+0xF0A1
        'minute',                                # C+0xA2 # U+0xF0A2
        'lessequal',                             # C+0xA3 # U+0xF0A3
        'fraction',                              # C+0xA4 # U+0xF0A4
        'infinity',                              # C+0xA5 # U+0xF0A5
        'florin',                                # C+0xA6 # U+0xF0A6
        'club',                                  # C+0xA7 # U+0xF0A7
        'diamond',                               # C+0xA8 # U+0xF0A8
        'heart',                                 # C+0xA9 # U+0xF0A9
        'spade',                                 # C+0xAA # U+0xF0AA
        'arrowboth',                             # C+0xAB # U+0xF0AB
        'arrowleft',                             # C+0xAC # U+0xF0AC
        'arrowup',                               # C+0xAD # U+0xF0AD
        'arrowright',                            # C+0xAE # U+0xF0AE
        'arrowdown',                             # C+0xAF # U+0xF0AF
        'degree',                                # C+0xB0 # U+0xF0B0
        'plusminus',                             # C+0xB1 # U+0xF0B1
        'second',                                # C+0xB2 # U+0xF0B2
        'greaterequal',                          # C+0xB3 # U+0xF0B3
        'multiply',                              # C+0xB4 # U+0xF0B4
        'proportional',                          # C+0xB5 # U+0xF0B5
        'partialdiff',                           # C+0xB6 # U+0xF0B6
        'bullet',                                # C+0xB7 # U+0xF0B7
        'divide',                                # C+0xB8 # U+0xF0B8
        'notequal',                              # C+0xB9 # U+0xF0B9
        'equivalence',                           # C+0xBA # U+0xF0BA
        'approxequal',                           # C+0xBB # U+0xF0BB
        'ellipsis',                              # C+0xBC # U+0xF0BC
        'arrowvertex',                           # C+0xBD # U+0xF0BD
        'arrowhorizex',                          # C+0xBE # U+0xF0BE
        'carriagereturn',                        # C+0xBF # U+0xF0BF
        'aleph',                                 # C+0xC0 # U+0xF0C0
        'Ifraktur',                              # C+0xC1 # U+0xF0C1
        'Rfraktur',                              # C+0xC2 # U+0xF0C2
        'weierstrass',                           # C+0xC3 # U+0xF0C3
        'circlemultiply',                        # C+0xC4 # U+0xF0C4
        'circleplus',                            # C+0xC5 # U+0xF0C5
        'emptyset',                              # C+0xC6 # U+0xF0C6
        'intersection',                          # C+0xC7 # U+0xF0C7
        'union',                                 # C+0xC8 # U+0xF0C8
        'propersuperset',                        # C+0xC9 # U+0xF0C9
        'reflexsuperset',                        # C+0xCA # U+0xF0CA
        'notsubset',                             # C+0xCB # U+0xF0CB
        'propersubset',                          # C+0xCC # U+0xF0CC
        'reflexsubset',                          # C+0xCD # U+0xF0CD
        'element',                               # C+0xCE # U+0xF0CE
        'notelement',                            # C+0xCF # U+0xF0CF
        'angle',                                 # C+0xD0 # U+0xF0D0
        'gradient',                              # C+0xD1 # U+0xF0D1
        'registerserif',                         # C+0xD2 # U+0xF0D2
        'copyrightserif',                        # C+0xD3 # U+0xF0D3
        'trademarkserif',                        # C+0xD4 # U+0xF0D4
        'product',                               # C+0xD5 # U+0xF0D5
        'radical',                               # C+0xD6 # U+0xF0D6
        'dotmath',                               # C+0xD7 # U+0xF0D7
        'logicalnot',                            # C+0xD8 # U+0xF0D8
        'logicaland',                            # C+0xD9 # U+0xF0D9
        'logicalor',                             # C+0xDA # U+0xF0DA
        'arrowdblboth',                          # C+0xDB # U+0xF0DB
        'arrowdblleft',                          # C+0xDC # U+0xF0DC
        'arrowdblup',                            # C+0xDD # U+0xF0DD
        'arrowdblright',                         # C+0xDE # U+0xF0DE
        'arrowdbldown',                          # C+0xDF # U+0xF0DF
        'lozenge',                               # C+0xE0 # U+0xF0E0
        'angleleft',                             # C+0xE1 # U+0xF0E1
        'registersans',                          # C+0xE2 # U+0xF0E2
        'copyrightsans',                         # C+0xE3 # U+0xF0E3
        'trademarksans',                         # C+0xE4 # U+0xF0E4
        'summation',                             # C+0xE5 # U+0xF0E5
        'parenlefttp',                           # C+0xE6 # U+0xF0E6
        'parenleftex',                           # C+0xE7 # U+0xF0E7
        'parenleftbt',                           # C+0xE8 # U+0xF0E8
        'bracketlefttp',                         # C+0xE9 # U+0xF0E9
        'bracketleftex',                         # C+0xEA # U+0xF0EA
        'bracketleftbt',                         # C+0xEB # U+0xF0EB
        'bracelefttp',                           # C+0xEC # U+0xF0EC
        'braceleftmid',                          # C+0xED # U+0xF0ED
        'braceleftbt',                           # C+0xEE # U+0xF0EE
        'braceex',                               # C+0xEF # U+0xF0EF
        '.notdef',                               # C+0xF0 # U+0x0000
        'angleright',                            # C+0xF1 # U+0xF0F1
        'integral',                              # C+0xF2 # U+0xF0F2
        'integraltp',                            # C+0xF3 # U+0xF0F3
        'integralex',                            # C+0xF4 # U+0xF0F4
        'integralbt',                            # C+0xF5 # U+0xF0F5
        'parenrighttp',                          # C+0xF6 # U+0xF0F6
        'parenrightex',                          # C+0xF7 # U+0xF0F7
        'parenrightbt',                          # C+0xF8 # U+0xF0F8
        'bracketrighttp',                        # C+0xF9 # U+0xF0F9
        'bracketrightex',                        # C+0xFA # U+0xF0FA
        'bracketrightbt',                        # C+0xFB # U+0xF0FB
        'bracerighttp',                          # C+0xFC # U+0xF0FC
        'bracerightmid',                         # C+0xFD # U+0xF0FD
        'bracerightbt',                          # C+0xFE # U+0xF0FE
        'apple',                                 # C+0xFF # U+0xF0FF
    ], # DEF. ENCODING GLYPH TABLE
    'fontbbox' => [ -180, -293, 1090, 1010 ],
    'wx' => { # HORIZ. WIDTH TABLE
        'space' => '250',                        # C+0x20 # U+0xF020
        'exclam' => '333',                       # C+0x21 # U+0xF021
        'universal' => '713',                    # C+0x22 # U+0xF022
        'numbersign' => '500',                   # C+0x23 # U+0xF023
        'existential' => '549',                  # C+0x24 # U+0xF024
        'percent' => '833',                      # C+0x25 # U+0xF025
        'ampersand' => '778',                    # C+0x26 # U+0xF026
        'suchthat' => '439',                     # C+0x27 # U+0xF027
        'parenleft' => '333',                    # C+0x28 # U+0xF028
        'parenright' => '333',                   # C+0x29 # U+0xF029
        'asteriskmath' => '500',                 # C+0x2A # U+0xF02A
        'plus' => '549',                         # C+0x2B # U+0xF02B
        'comma' => '250',                        # C+0x2C # U+0xF02C
        'minus' => '549',                        # C+0x2D # U+0xF02D
        'period' => '250',                       # C+0x2E # U+0xF02E
        'slash' => '278',                        # C+0x2F # U+0xF02F
        'zero' => '500',                         # C+0x30 # U+0xF030
        'one' => '500',                          # C+0x31 # U+0xF031
        'two' => '500',                          # C+0x32 # U+0xF032
        'three' => '500',                        # C+0x33 # U+0xF033
        'four' => '500',                         # C+0x34 # U+0xF034
        'five' => '500',                         # C+0x35 # U+0xF035
        'six' => '500',                          # C+0x36 # U+0xF036
        'seven' => '500',                        # C+0x37 # U+0xF037
        'eight' => '500',                        # C+0x38 # U+0xF038
        'nine' => '500',                         # C+0x39 # U+0xF039
        'colon' => '278',                        # C+0x3A # U+0xF03A
        'semicolon' => '278',                    # C+0x3B # U+0xF03B
        'less' => '549',                         # C+0x3C # U+0xF03C
        'equal' => '549',                        # C+0x3D # U+0xF03D
        'greater' => '549',                      # C+0x3E # U+0xF03E
        'question' => '444',                     # C+0x3F # U+0xF03F
        'congruent' => '549',                    # C+0x40 # U+0xF040
        'Alpha' => '722',                        # C+0x41 # U+0xF041
        'Beta' => '667',                         # C+0x42 # U+0xF042
        'Chi' => '722',                          # C+0x43 # U+0xF043
        'Delta' => '612',                        # C+0x44 # U+0xF044
        'Epsilon' => '611',                      # C+0x45 # U+0xF045
        'Phi' => '763',                          # C+0x46 # U+0xF046
        'Gamma' => '603',                        # C+0x47 # U+0xF047
        'Eta' => '722',                          # C+0x48 # U+0xF048
        'Iota' => '333',                         # C+0x49 # U+0xF049
        'theta1' => '631',                       # C+0x4A # U+0xF04A
        'Kappa' => '722',                        # C+0x4B # U+0xF04B
        'Lambda' => '686',                       # C+0x4C # U+0xF04C
        'Mu' => '889',                           # C+0x4D # U+0xF04D
        'Nu' => '722',                           # C+0x4E # U+0xF04E
        'Omicron' => '722',                      # C+0x4F # U+0xF04F
        'Pi' => '768',                           # C+0x50 # U+0xF050
        'Theta' => '741',                        # C+0x51 # U+0xF051
        'Rho' => '556',                          # C+0x52 # U+0xF052
        'Sigma' => '592',                        # C+0x53 # U+0xF053
        'Tau' => '611',                          # C+0x54 # U+0xF054
        'Upsilon' => '690',                      # C+0x55 # U+0xF055
        'sigma1' => '439',                       # C+0x56 # U+0xF056
        'Omega' => '768',                        # C+0x57 # U+0xF057
        'Xi' => '645',                           # C+0x58 # U+0xF058
        'Psi' => '795',                          # C+0x59 # U+0xF059
        'Zeta' => '611',                         # C+0x5A # U+0xF05A
        'bracketleft' => '333',                  # C+0x5B # U+0xF05B
        'therefore' => '863',                    # C+0x5C # U+0xF05C
        'bracketright' => '333',                 # C+0x5D # U+0xF05D
        'perpendicular' => '658',                # C+0x5E # U+0xF05E
        'underscore' => '500',                   # C+0x5F # U+0xF05F
        'radicalex' => '500',                    # C+0x60 # U+0xF060
        'alpha' => '631',                        # C+0x61 # U+0xF061
        'beta' => '549',                         # C+0x62 # U+0xF062
        'chi' => '549',                          # C+0x63 # U+0xF063
        'delta' => '494',                        # C+0x64 # U+0xF064
        'epsilon' => '439',                      # C+0x65 # U+0xF065
        'phi' => '521',                          # C+0x66 # U+0xF066
        'gamma' => '411',                        # C+0x67 # U+0xF067
        'eta' => '603',                          # C+0x68 # U+0xF068
        'iota' => '329',                         # C+0x69 # U+0xF069
        'phi1' => '603',                         # C+0x6A # U+0xF06A
        'kappa' => '549',                        # C+0x6B # U+0xF06B
        'lambda' => '549',                       # C+0x6C # U+0xF06C
        'mu' => '576',                           # C+0x6D # U+0xF06D
        'nu' => '521',                           # C+0x6E # U+0xF06E
        'omicron' => '549',                      # C+0x6F # U+0xF06F
        'pi' => '549',                           # C+0x70 # U+0xF070
        'theta' => '521',                        # C+0x71 # U+0xF071
        'rho' => '549',                          # C+0x72 # U+0xF072
        'sigma' => '603',                        # C+0x73 # U+0xF073
        'tau' => '439',                          # C+0x74 # U+0xF074
        'upsilon' => '576',                      # C+0x75 # U+0xF075
        'omega1' => '713',                       # C+0x76 # U+0xF076
        'omega' => '686',                        # C+0x77 # U+0xF077
        'xi' => '493',                           # C+0x78 # U+0xF078
        'psi' => '686',                          # C+0x79 # U+0xF079
        'zeta' => '494',                         # C+0x7A # U+0xF07A
        'braceleft' => '480',                    # C+0x7B # U+0xF07B
        'bar' => '200',                          # C+0x7C # U+0xF07C
        'braceright' => '480',                   # C+0x7D # U+0xF07D
        'similar' => '549',                      # C+0x7E # U+0xF07E
        'Euro' => '750',                         # C+0xA0 # U+0xF0A0
        'Upsilon1' => '620',                     # C+0xA1 # U+0xF0A1
        'minute' => '247',                       # C+0xA2 # U+0xF0A2
        'lessequal' => '549',                    # C+0xA3 # U+0xF0A3
        'fraction' => '167',                     # C+0xA4 # U+0xF0A4
        'infinity' => '713',                     # C+0xA5 # U+0xF0A5
        'florin' => '500',                       # C+0xA6 # U+0xF0A6
        'club' => '753',                         # C+0xA7 # U+0xF0A7
        'diamond' => '753',                      # C+0xA8 # U+0xF0A8
        'heart' => '753',                        # C+0xA9 # U+0xF0A9
        'spade' => '753',                        # C+0xAA # U+0xF0AA
        'arrowboth' => '1042',                   # C+0xAB # U+0xF0AB
        'arrowleft' => '987',                    # C+0xAC # U+0xF0AC
        'arrowup' => '603',                      # C+0xAD # U+0xF0AD
        'arrowright' => '987',                   # C+0xAE # U+0xF0AE
        'arrowdown' => '603',                    # C+0xAF # U+0xF0AF
        'degree' => '400',                       # C+0xB0 # U+0xF0B0
        'plusminus' => '549',                    # C+0xB1 # U+0xF0B1
        'second' => '411',                       # C+0xB2 # U+0xF0B2
        'greaterequal' => '549',                 # C+0xB3 # U+0xF0B3
        'multiply' => '549',                     # C+0xB4 # U+0xF0B4
        'proportional' => '713',                 # C+0xB5 # U+0xF0B5
        'partialdiff' => '494',                  # C+0xB6 # U+0xF0B6
        'bullet' => '460',                       # C+0xB7 # U+0xF0B7
        'divide' => '549',                       # C+0xB8 # U+0xF0B8
        'notequal' => '549',                     # C+0xB9 # U+0xF0B9
        'equivalence' => '549',                  # C+0xBA # U+0xF0BA
        'approxequal' => '549',                  # C+0xBB # U+0xF0BB
        'ellipsis' => '1000',                    # C+0xBC # U+0xF0BC
        'arrowvertex' => '603',                  # C+0xBD # U+0xF0BD
        'arrowhorizex' => '1000',                # C+0xBE # U+0xF0BE
        'carriagereturn' => '658',               # C+0xBF # U+0xF0BF
        'aleph' => '823',                        # C+0xC0 # U+0xF0C0
        'Ifraktur' => '686',                     # C+0xC1 # U+0xF0C1
        'Rfraktur' => '795',                     # C+0xC2 # U+0xF0C2
        'weierstrass' => '987',                  # C+0xC3 # U+0xF0C3
        'circlemultiply' => '768',               # C+0xC4 # U+0xF0C4
        'circleplus' => '768',                   # C+0xC5 # U+0xF0C5
        'emptyset' => '823',                     # C+0xC6 # U+0xF0C6
        'intersection' => '768',                 # C+0xC7 # U+0xF0C7
        'union' => '768',                        # C+0xC8 # U+0xF0C8
        'propersuperset' => '713',               # C+0xC9 # U+0xF0C9
        'reflexsuperset' => '713',               # C+0xCA # U+0xF0CA
        'notsubset' => '713',                    # C+0xCB # U+0xF0CB
        'propersubset' => '713',                 # C+0xCC # U+0xF0CC
        'reflexsubset' => '713',                 # C+0xCD # U+0xF0CD
        'element' => '713',                      # C+0xCE # U+0xF0CE
        'notelement' => '713',                   # C+0xCF # U+0xF0CF
        'angle' => '768',                        # C+0xD0 # U+0xF0D0
        'gradient' => '713',                     # C+0xD1 # U+0xF0D1
        'registerserif' => '790',                # C+0xD2 # U+0xF0D2
        'copyrightserif' => '790',               # C+0xD3 # U+0xF0D3
        'trademarkserif' => '890',               # C+0xD4 # U+0xF0D4
        'product' => '823',                      # C+0xD5 # U+0xF0D5
        'radical' => '549',                      # C+0xD6 # U+0xF0D6
        'dotmath' => '250',                      # C+0xD7 # U+0xF0D7
        'logicalnot' => '713',                   # C+0xD8 # U+0xF0D8
        'logicaland' => '603',                   # C+0xD9 # U+0xF0D9
        'logicalor' => '603',                    # C+0xDA # U+0xF0DA
        'arrowdblboth' => '1042',                # C+0xDB # U+0xF0DB
        'arrowdblleft' => '987',                 # C+0xDC # U+0xF0DC
        'arrowdblup' => '603',                   # C+0xDD # U+0xF0DD
        'arrowdblright' => '987',                # C+0xDE # U+0xF0DE
        'arrowdbldown' => '603',                 # C+0xDF # U+0xF0DF
        'lozenge' => '494',                      # C+0xE0 # U+0xF0E0
        'angleleft' => '329',                    # C+0xE1 # U+0xF0E1
        'registersans' => '790',                 # C+0xE2 # U+0xF0E2
        'copyrightsans' => '790',                # C+0xE3 # U+0xF0E3
        'trademarksans' => '786',                # C+0xE4 # U+0xF0E4
        'summation' => '713',                    # C+0xE5 # U+0xF0E5
        'parenlefttp' => '384',                  # C+0xE6 # U+0xF0E6
        'parenleftex' => '384',                  # C+0xE7 # U+0xF0E7
        'parenleftbt' => '384',                  # C+0xE8 # U+0xF0E8
        'bracketlefttp' => '384',                # C+0xE9 # U+0xF0E9
        'bracketleftex' => '384',                # C+0xEA # U+0xF0EA
        'bracketleftbt' => '384',                # C+0xEB # U+0xF0EB
        'bracelefttp' => '494',                  # C+0xEC # U+0xF0EC
        'braceleftmid' => '494',                 # C+0xED # U+0xF0ED
        'braceleftbt' => '494',                  # C+0xEE # U+0xF0EE
        'braceex' => '494',                      # C+0xEF # U+0xF0EF
        'angleright' => '329',                   # C+0xF1 # U+0xF0F1
        'integral' => '274',                     # C+0xF2 # U+0xF0F2
        'integraltp' => '686',                   # C+0xF3 # U+0xF0F3
        'integralex' => '686',                   # C+0xF4 # U+0xF0F4
        'integralbt' => '686',                   # C+0xF5 # U+0xF0F5
        'parenrighttp' => '384',                 # C+0xF6 # U+0xF0F6
        'parenrightex' => '384',                 # C+0xF7 # U+0xF0F7
        'parenrightbt' => '384',                 # C+0xF8 # U+0xF0F8
        'bracketrighttp' => '384',               # C+0xF9 # U+0xF0F9
        'bracketrightex' => '384',               # C+0xFA # U+0xF0FA
        'bracketrightbt' => '384',               # C+0xFB # U+0xF0FB
        'bracerighttp' => '494',                 # C+0xFC # U+0xF0FC
        'bracerightmid' => '494',                # C+0xFD # U+0xF0FD
        'bracerightbt' => '494',                 # C+0xFE # U+0xF0FE
        'apple' => '790',                        # C+0xFF # U+0xF0FF
    }, # HORIZ. WIDTH TABLE
} };

1;
