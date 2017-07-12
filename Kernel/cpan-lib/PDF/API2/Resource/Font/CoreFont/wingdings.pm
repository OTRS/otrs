package PDF::API2::Resource::Font::CoreFont::wingdings;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub data { return {
    'fontname' => 'Wingdings',
    'type' => 'TrueType',
    'apiname' => 'WiDi',
    'ascender' => '898',
    'capheight' => '722',
    'descender' => '-210',
    'isfixedpitch' => '0',
    'issymbol' => '1',
    'italicangle' => '0',
    'underlineposition' => '-200',
    'underlinethickness' => '100',
    'xheight' => '722',
    'firstchar' => '32',
    'lastchar' => '255',
    'flags' => '4',
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
        'pencil',                                # C+0x21 # U+0xF021
        'scissors',                              # C+0x22 # U+0xF022
        'scissorscutting',                       # C+0x23 # U+0xF023
        'readingglasses',                        # C+0x24 # U+0xF024
        'bell',                                  # C+0x25 # U+0xF025
        'book',                                  # C+0x26 # U+0xF026
        'candle',                                # C+0x27 # U+0xF027
        'telephonesolid',                        # C+0x28 # U+0xF028
        'telhandsetcirc',                        # C+0x29 # U+0xF029
        'envelopeback',                          # C+0x2A # U+0xF02A
        'envelopefront',                         # C+0x2B # U+0xF02B
        'mailboxflagdwn',                        # C+0x2C # U+0xF02C
        'mailboxflagup',                         # C+0x2D # U+0xF02D
        'mailbxopnflgup',                        # C+0x2E # U+0xF02E
        'mailbxopnflgdwn',                       # C+0x2F # U+0xF02F
        'folder',                                # C+0x30 # U+0xF030
        'folderopen',                            # C+0x31 # U+0xF031
        'filetalltext1',                         # C+0x32 # U+0xF032
        'filetalltext',                          # C+0x33 # U+0xF033
        'filetalltext3',                         # C+0x34 # U+0xF034
        'filecabinet',                           # C+0x35 # U+0xF035
        'hourglass',                             # C+0x36 # U+0xF036
        'keyboard',                              # C+0x37 # U+0xF037
        'mouse2button',                          # C+0x38 # U+0xF038
        'ballpoint',                             # C+0x39 # U+0xF039
        'pc',                                    # C+0x3A # U+0xF03A
        'harddisk',                              # C+0x3B # U+0xF03B
        'floppy3',                               # C+0x3C # U+0xF03C
        'floppy5',                               # C+0x3D # U+0xF03D
        'tapereel',                              # C+0x3E # U+0xF03E
        'handwrite',                             # C+0x3F # U+0xF03F
        'handwriteleft',                         # C+0x40 # U+0xF040
        'handv',                                 # C+0x41 # U+0xF041
        'handok',                                # C+0x42 # U+0xF042
        'thumbup',                               # C+0x43 # U+0xF043
        'thumbdown',                             # C+0x44 # U+0xF044
        'handptleft',                            # C+0x45 # U+0xF045
        'handptright',                           # C+0x46 # U+0xF046
        'handptup',                              # C+0x47 # U+0xF047
        'handptdwn',                             # C+0x48 # U+0xF048
        'handhalt',                              # C+0x49 # U+0xF049
        'smileface',                             # C+0x4A # U+0xF04A
        'neutralface',                           # C+0x4B # U+0xF04B
        'frownface',                             # C+0x4C # U+0xF04C
        'bomb',                                  # C+0x4D # U+0xF04D
        'skullcrossbones',                       # C+0x4E # U+0xF04E
        'flag',                                  # C+0x4F # U+0xF04F
        'pennant',                               # C+0x50 # U+0xF050
        'airplane',                              # C+0x51 # U+0xF051
        'sunshine',                              # C+0x52 # U+0xF052
        'droplet',                               # C+0x53 # U+0xF053
        'snowflake',                             # C+0x54 # U+0xF054
        'crossoutline',                          # C+0x55 # U+0xF055
        'crossshadow',                           # C+0x56 # U+0xF056
        'crossceltic',                           # C+0x57 # U+0xF057
        'crossmaltese',                          # C+0x58 # U+0xF058
        'starofdavid',                           # C+0x59 # U+0xF059
        'crescentstar',                          # C+0x5A # U+0xF05A
        'yinyang',                               # C+0x5B # U+0xF05B
        'om',                                    # C+0x5C # U+0xF05C
        'wheel',                                 # C+0x5D # U+0xF05D
        'aries',                                 # C+0x5E # U+0xF05E
        'taurus',                                # C+0x5F # U+0xF05F
        'gemini',                                # C+0x60 # U+0xF060
        'cancer',                                # C+0x61 # U+0xF061
        'leo',                                   # C+0x62 # U+0xF062
        'virgo',                                 # C+0x63 # U+0xF063
        'libra',                                 # C+0x64 # U+0xF064
        'scorpio',                               # C+0x65 # U+0xF065
        'saggitarius',                           # C+0x66 # U+0xF066
        'capricorn',                             # C+0x67 # U+0xF067
        'aquarius',                              # C+0x68 # U+0xF068
        'pisces',                                # C+0x69 # U+0xF069
        'ampersanditlc',                         # C+0x6A # U+0xF06A
        'ampersandit',                           # C+0x6B # U+0xF06B
        'circle6',                               # C+0x6C # U+0xF06C
        'circleshadowdwn',                       # C+0x6D # U+0xF06D
        'square6',                               # C+0x6E # U+0xF06E
        'box3',                                  # C+0x6F # U+0xF06F
        'box4',                                  # C+0x70 # U+0xF070
        'boxshadowdwn',                          # C+0x71 # U+0xF071
        'boxshadowup',                           # C+0x72 # U+0xF072
        'lozenge4',                              # C+0x73 # U+0xF073
        'lozenge6',                              # C+0x74 # U+0xF074
        'rhombus6',                              # C+0x75 # U+0xF075
        'xrhombus',                              # C+0x76 # U+0xF076
        'rhombus4',                              # C+0x77 # U+0xF077
        'clear',                                 # C+0x78 # U+0xF078
        'escape',                                # C+0x79 # U+0xF079
        'command',                               # C+0x7A # U+0xF07A
        'rosette',                               # C+0x7B # U+0xF07B
        'rosettesolid',                          # C+0x7C # U+0xF07C
        'quotedbllftbld',                        # C+0x7D # U+0xF07D
        'quotedblrtbld',                         # C+0x7E # U+0xF07E
        '.notdef',                               # C+0x7F # U+0x0000
        'zerosans',                              # C+0x80 # U+0xF080
        'onesans',                               # C+0x81 # U+0xF081
        'twosans',                               # C+0x82 # U+0xF082
        'threesans',                             # C+0x83 # U+0xF083
        'foursans',                              # C+0x84 # U+0xF084
        'fivesans',                              # C+0x85 # U+0xF085
        'sixsans',                               # C+0x86 # U+0xF086
        'sevensans',                             # C+0x87 # U+0xF087
        'eightsans',                             # C+0x88 # U+0xF088
        'ninesans',                              # C+0x89 # U+0xF089
        'tensans',                               # C+0x8A # U+0xF08A
        'zerosansinv',                           # C+0x8B # U+0xF08B
        'onesansinv',                            # C+0x8C # U+0xF08C
        'twosansinv',                            # C+0x8D # U+0xF08D
        'threesansinv',                          # C+0x8E # U+0xF08E
        'foursansinv',                           # C+0x8F # U+0xF08F
        'fivesansinv',                           # C+0x90 # U+0xF090
        'sixsansinv',                            # C+0x91 # U+0xF091
        'sevensansinv',                          # C+0x92 # U+0xF092
        'eightsansinv',                          # C+0x93 # U+0xF093
        'ninesansinv',                           # C+0x94 # U+0xF094
        'tensansinv',                            # C+0x95 # U+0xF095
        'budleafne',                             # C+0x96 # U+0xF096
        'budleafnw',                             # C+0x97 # U+0xF097
        'budleafsw',                             # C+0x98 # U+0xF098
        'budleafse',                             # C+0x99 # U+0xF099
        'vineleafboldne',                        # C+0x9A # U+0xF09A
        'vineleafboldnw',                        # C+0x9B # U+0xF09B
        'vineleafboldsw',                        # C+0x9C # U+0xF09C
        'vineleafboldse',                        # C+0x9D # U+0xF09D
        'circle2',                               # C+0x9E # U+0xF09E
        'circle4',                               # C+0x9F # U+0xF09F
        'square2',                               # C+0xA0 # U+0xF0A0
        'ring2',                                 # C+0xA1 # U+0xF0A1
        'ring4',                                 # C+0xA2 # U+0xF0A2
        'ring6',                                 # C+0xA3 # U+0xF0A3
        'ringbutton2',                           # C+0xA4 # U+0xF0A4
        'target',                                # C+0xA5 # U+0xF0A5
        'circleshadowup',                        # C+0xA6 # U+0xF0A6
        'square4',                               # C+0xA7 # U+0xF0A7
        'box2',                                  # C+0xA8 # U+0xF0A8
        'tristar2',                              # C+0xA9 # U+0xF0A9
        'crosstar2',                             # C+0xAA # U+0xF0AA
        'pentastar2',                            # C+0xAB # U+0xF0AB
        'hexstar2',                              # C+0xAC # U+0xF0AC
        'octastar2',                             # C+0xAD # U+0xF0AD
        'dodecastar3',                           # C+0xAE # U+0xF0AE
        'octastar4',                             # C+0xAF # U+0xF0AF
        'registersquare',                        # C+0xB0 # U+0xF0B0
        'registercircle',                        # C+0xB1 # U+0xF0B1
        'cuspopen',                              # C+0xB2 # U+0xF0B2
        'cuspopen1',                             # C+0xB3 # U+0xF0B3
        'query',                                 # C+0xB4 # U+0xF0B4
        'circlestar',                            # C+0xB5 # U+0xF0B5
        'starshadow',                            # C+0xB6 # U+0xF0B6
        'oneoclock',                             # C+0xB7 # U+0xF0B7
        'twooclock',                             # C+0xB8 # U+0xF0B8
        'threeoclock',                           # C+0xB9 # U+0xF0B9
        'fouroclock',                            # C+0xBA # U+0xF0BA
        'fiveoclock',                            # C+0xBB # U+0xF0BB
        'sixoclock',                             # C+0xBC # U+0xF0BC
        'sevenoclock',                           # C+0xBD # U+0xF0BD
        'eightoclock',                           # C+0xBE # U+0xF0BE
        'nineoclock',                            # C+0xBF # U+0xF0BF
        'tenoclock',                             # C+0xC0 # U+0xF0C0
        'elevenoclock',                          # C+0xC1 # U+0xF0C1
        'twelveoclock',                          # C+0xC2 # U+0xF0C2
        'arrowdwnleft1',                         # C+0xC3 # U+0xF0C3
        'arrowdwnrt1',                           # C+0xC4 # U+0xF0C4
        'arrowupleft1',                          # C+0xC5 # U+0xF0C5
        'arrowuprt1',                            # C+0xC6 # U+0xF0C6
        'arrowleftup1',                          # C+0xC7 # U+0xF0C7
        'arrowrtup1',                            # C+0xC8 # U+0xF0C8
        'arrowleftdwn1',                         # C+0xC9 # U+0xF0C9
        'arrowrtdwn1',                           # C+0xCA # U+0xF0CA
        'quiltsquare2',                          # C+0xCB # U+0xF0CB
        'quiltsquare2inv',                       # C+0xCC # U+0xF0CC
        'leafccwsw',                             # C+0xCD # U+0xF0CD
        'leafccwnw',                             # C+0xCE # U+0xF0CE
        'leafccwse',                             # C+0xCF # U+0xF0CF
        'leafccwne',                             # C+0xD0 # U+0xF0D0
        'leafnw',                                # C+0xD1 # U+0xF0D1
        'leafsw',                                # C+0xD2 # U+0xF0D2
        'leafne',                                # C+0xD3 # U+0xF0D3
        'leafse',                                # C+0xD4 # U+0xF0D4
        'deleteleft',                            # C+0xD5 # U+0xF0D5
        'deleteright',                           # C+0xD6 # U+0xF0D6
        'head2left',                             # C+0xD7 # U+0xF0D7
        'head2right',                            # C+0xD8 # U+0xF0D8
        'head2up',                               # C+0xD9 # U+0xF0D9
        'head2down',                             # C+0xDA # U+0xF0DA
        'circleleft',                            # C+0xDB # U+0xF0DB
        'circleright',                           # C+0xDC # U+0xF0DC
        'circleup',                              # C+0xDD # U+0xF0DD
        'circledown',                            # C+0xDE # U+0xF0DE
        'barb2left',                             # C+0xDF # U+0xF0DF
        'barb2right',                            # C+0xE0 # U+0xF0E0
        'barb2up',                               # C+0xE1 # U+0xF0E1
        'barb2down',                             # C+0xE2 # U+0xF0E2
        'barb2nw',                               # C+0xE3 # U+0xF0E3
        'barb2ne',                               # C+0xE4 # U+0xF0E4
        'barb2sw',                               # C+0xE5 # U+0xF0E5
        'barb2se',                               # C+0xE6 # U+0xF0E6
        'barb4left',                             # C+0xE7 # U+0xF0E7
        'barb4right',                            # C+0xE8 # U+0xF0E8
        'barb4up',                               # C+0xE9 # U+0xF0E9
        'barb4down',                             # C+0xEA # U+0xF0EA
        'barb4nw',                               # C+0xEB # U+0xF0EB
        'barb4ne',                               # C+0xEC # U+0xF0EC
        'barb4sw',                               # C+0xED # U+0xF0ED
        'barb4se',                               # C+0xEE # U+0xF0EE
        'bleft',                                 # C+0xEF # U+0xF0EF
        'bright',                                # C+0xF0 # U+0xF0F0
        'bup',                                   # C+0xF1 # U+0xF0F1
        'bdown',                                 # C+0xF2 # U+0xF0F2
        'bleftright',                            # C+0xF3 # U+0xF0F3
        'bupdown',                               # C+0xF4 # U+0xF0F4
        'bnw',                                   # C+0xF5 # U+0xF0F5
        'bne',                                   # C+0xF6 # U+0xF0F6
        'bsw',                                   # C+0xF7 # U+0xF0F7
        'bse',                                   # C+0xF8 # U+0xF0F8
        'bdash1',                                # C+0xF9 # U+0xF0F9
        'bdash2',                                # C+0xFA # U+0xF0FA
        'xmarkbld',                              # C+0xFB # U+0xF0FB
        'checkbld',                              # C+0xFC # U+0xF0FC
        'boxxmarkbld',                           # C+0xFD # U+0xF0FD
        'boxcheckbld',                           # C+0xFE # U+0xF0FE
        'windowslogo',                           # C+0xFF # U+0xF0FF
    ], # DEF. ENCODING GLYPH TABLE
    'fontbbox' => [ 0, -210, 1358, 898 ],
    'wx' => { # HORIZ. WIDTH TABLE
        'space' => '1000',                       # C+0x20 # U+0xF020
        'pencil' => '1030',                      # C+0x21 # U+0xF021
        'scissors' => '1144',                    # C+0x22 # U+0xF022
        'scissorscutting' => '1301',             # C+0x23 # U+0xF023
        'readingglasses' => '1343',              # C+0x24 # U+0xF024
        'bell' => '893',                         # C+0x25 # U+0xF025
        'book' => '1216',                        # C+0x26 # U+0xF026
        'candle' => '458',                       # C+0x27 # U+0xF027
        'telephonesolid' => '1083',              # C+0x28 # U+0xF028
        'telhandsetcirc' => '891',               # C+0x29 # U+0xF029
        'envelopeback' => '1132',                # C+0x2A # U+0xF02A
        'envelopefront' => '1132',               # C+0x2B # U+0xF02B
        'mailboxflagdwn' => '1171',              # C+0x2C # U+0xF02C
        'mailboxflagup' => '1171',               # C+0x2D # U+0xF02D
        'mailbxopnflgup' => '1440',              # C+0x2E # U+0xF02E
        'mailbxopnflgdwn' => '1443',             # C+0x2F # U+0xF02F
        'folder' => '1096',                      # C+0x30 # U+0xF030
        'folderopen' => '1343',                  # C+0x31 # U+0xF031
        'filetalltext1' => '698',                # C+0x32 # U+0xF032
        'filetalltext' => '698',                 # C+0x33 # U+0xF033
        'filetalltext3' => '891',                # C+0x34 # U+0xF034
        'filecabinet' => '554',                  # C+0x35 # U+0xF035
        'hourglass' => '602',                    # C+0x36 # U+0xF036
        'keyboard' => '1072',                    # C+0x37 # U+0xF037
        'mouse2button' => '947',                 # C+0x38 # U+0xF038
        'ballpoint' => '1078',                   # C+0x39 # U+0xF039
        'pc' => '939',                           # C+0x3A # U+0xF03A
        'harddisk' => '891',                     # C+0x3B # U+0xF03B
        'floppy3' => '891',                      # C+0x3C # U+0xF03C
        'floppy5' => '891',                      # C+0x3D # U+0xF03D
        'tapereel' => '891',                     # C+0x3E # U+0xF03E
        'handwrite' => '909',                    # C+0x3F # U+0xF03F
        'handwriteleft' => '909',                # C+0x40 # U+0xF040
        'handv' => '587',                        # C+0x41 # U+0xF041
        'handok' => '792',                       # C+0x42 # U+0xF042
        'thumbup' => '674',                      # C+0x43 # U+0xF043
        'thumbdown' => '674',                    # C+0x44 # U+0xF044
        'handptleft' => '941',                   # C+0x45 # U+0xF045
        'handptright' => '941',                  # C+0x46 # U+0xF046
        'handptup' => '548',                     # C+0x47 # U+0xF047
        'handptdwn' => '548',                    # C+0x48 # U+0xF048
        'handhalt' => '891',                     # C+0x49 # U+0xF049
        'smileface' => '843',                    # C+0x4A # U+0xF04A
        'neutralface' => '843',                  # C+0x4B # U+0xF04B
        'frownface' => '843',                    # C+0x4C # U+0xF04C
        'bomb' => '1110',                        # C+0x4D # U+0xF04D
        'skullcrossbones' => '660',              # C+0x4E # U+0xF04E
        'flag' => '849',                         # C+0x4F # U+0xF04F
        'pennant' => '1088',                     # C+0x50 # U+0xF050
        'airplane' => '888',                     # C+0x51 # U+0xF051
        'sunshine' => '880',                     # C+0x52 # U+0xF052
        'droplet' => '650',                      # C+0x53 # U+0xF053
        'snowflake' => '812',                    # C+0x54 # U+0xF054
        'crossoutline' => '746',                 # C+0x55 # U+0xF055
        'crossshadow' => '746',                  # C+0x56 # U+0xF056
        'crossceltic' => '722',                  # C+0x57 # U+0xF057
        'crossmaltese' => '693',                 # C+0x58 # U+0xF058
        'starofdavid' => '794',                  # C+0x59 # U+0xF059
        'crescentstar' => '885',                 # C+0x5A # U+0xF05A
        'yinyang' => '891',                      # C+0x5B # U+0xF05B
        'om' => '895',                           # C+0x5C # U+0xF05C
        'wheel' => '891',                        # C+0x5D # U+0xF05D
        'aries' => '1156',                       # C+0x5E # U+0xF05E
        'taurus' => '1054',                      # C+0x5F # U+0xF05F
        'gemini' => '963',                       # C+0x60 # U+0xF060
        'cancer' => '1090',                      # C+0x61 # U+0xF061
        'leo' => '940',                          # C+0x62 # U+0xF062
        'virgo' => '933',                        # C+0x63 # U+0xF063
        'libra' => '945',                        # C+0x64 # U+0xF064
        'scorpio' => '1024',                     # C+0x65 # U+0xF065
        'saggitarius' => '928',                  # C+0x66 # U+0xF066
        'capricorn' => '1096',                   # C+0x67 # U+0xF067
        'aquarius' => '1064',                    # C+0x68 # U+0xF068
        'pisces' => '779',                       # C+0x69 # U+0xF069
        'ampersanditlc' => '1049',               # C+0x6A # U+0xF06A
        'ampersandit' => '1270',                 # C+0x6B # U+0xF06B
        'circle6' => '746',                      # C+0x6C # U+0xF06C
        'circleshadowdwn' => '952',              # C+0x6D # U+0xF06D
        'square6' => '746',                      # C+0x6E # U+0xF06E
        'box3' => '891',                         # C+0x6F # U+0xF06F
        'box4' => '891',                         # C+0x70 # U+0xF070
        'boxshadowdwn' => '891',                 # C+0x71 # U+0xF071
        'boxshadowup' => '891',                  # C+0x72 # U+0xF072
        'lozenge4' => '457',                     # C+0x73 # U+0xF073
        'lozenge6' => '746',                     # C+0x74 # U+0xF074
        'rhombus6' => '986',                     # C+0x75 # U+0xF075
        'xrhombus' => '891',                     # C+0x76 # U+0xF076
        'rhombus4' => '577',                     # C+0x77 # U+0xF077
        'clear' => '1060',                       # C+0x78 # U+0xF078
        'escape' => '1060',                      # C+0x79 # U+0xF079
        'command' => '891',                      # C+0x7A # U+0xF07A
        'rosette' => '891',                      # C+0x7B # U+0xF07B
        'rosettesolid' => '891',                 # C+0x7C # U+0xF07C
        'quotedbllftbld' => '530',               # C+0x7D # U+0xF07D
        'quotedblrtbld' => '530',                # C+0x7E # U+0xF07E
        'zerosans' => '891',                     # C+0x80 # U+0xF080
        'onesans' => '891',                      # C+0x81 # U+0xF081
        'twosans' => '891',                      # C+0x82 # U+0xF082
        'threesans' => '891',                    # C+0x83 # U+0xF083
        'foursans' => '891',                     # C+0x84 # U+0xF084
        'fivesans' => '891',                     # C+0x85 # U+0xF085
        'sixsans' => '891',                      # C+0x86 # U+0xF086
        'sevensans' => '891',                    # C+0x87 # U+0xF087
        'eightsans' => '891',                    # C+0x88 # U+0xF088
        'ninesans' => '891',                     # C+0x89 # U+0xF089
        'tensans' => '891',                      # C+0x8A # U+0xF08A
        'zerosansinv' => '891',                  # C+0x8B # U+0xF08B
        'onesansinv' => '891',                   # C+0x8C # U+0xF08C
        'twosansinv' => '891',                   # C+0x8D # U+0xF08D
        'threesansinv' => '891',                 # C+0x8E # U+0xF08E
        'foursansinv' => '891',                  # C+0x8F # U+0xF08F
        'fivesansinv' => '891',                  # C+0x90 # U+0xF090
        'sixsansinv' => '891',                   # C+0x91 # U+0xF091
        'sevensansinv' => '891',                 # C+0x92 # U+0xF092
        'eightsansinv' => '891',                 # C+0x93 # U+0xF093
        'ninesansinv' => '891',                  # C+0x94 # U+0xF094
        'tensansinv' => '891',                   # C+0x95 # U+0xF095
        'budleafne' => '1000',                   # C+0x96 # U+0xF096
        'budleafnw' => '1000',                   # C+0x97 # U+0xF097
        'budleafsw' => '1000',                   # C+0x98 # U+0xF098
        'budleafse' => '1000',                   # C+0x99 # U+0xF099
        'vineleafboldne' => '1000',              # C+0x9A # U+0xF09A
        'vineleafboldnw' => '1000',              # C+0x9B # U+0xF09B
        'vineleafboldsw' => '1000',              # C+0x9C # U+0xF09C
        'vineleafboldse' => '1000',              # C+0x9D # U+0xF09D
        'circle2' => '312',                      # C+0x9E # U+0xF09E
        'circle4' => '457',                      # C+0x9F # U+0xF09F
        'square2' => '312',                      # C+0xA0 # U+0xF0A0
        'ring2' => '891',                        # C+0xA1 # U+0xF0A1
        'ring4' => '891',                        # C+0xA2 # U+0xF0A2
        'ring6' => '891',                        # C+0xA3 # U+0xF0A3
        'ringbutton2' => '891',                  # C+0xA4 # U+0xF0A4
        'target' => '891',                       # C+0xA5 # U+0xF0A5
        'circleshadowup' => '952',               # C+0xA6 # U+0xF0A6
        'square4' => '457',                      # C+0xA7 # U+0xF0A7
        'box2' => '891',                         # C+0xA8 # U+0xF0A8
        'tristar2' => '891',                     # C+0xA9 # U+0xF0A9
        'crosstar2' => '891',                    # C+0xAA # U+0xF0AA
        'pentastar2' => '891',                   # C+0xAB # U+0xF0AB
        'hexstar2' => '891',                     # C+0xAC # U+0xF0AC
        'octastar2' => '891',                    # C+0xAD # U+0xF0AD
        'dodecastar3' => '891',                  # C+0xAE # U+0xF0AE
        'octastar4' => '891',                    # C+0xAF # U+0xF0AF
        'registersquare' => '891',               # C+0xB0 # U+0xF0B0
        'registercircle' => '891',               # C+0xB1 # U+0xF0B1
        'cuspopen' => '891',                     # C+0xB2 # U+0xF0B2
        'cuspopen1' => '891',                    # C+0xB3 # U+0xF0B3
        'query' => '891',                        # C+0xB4 # U+0xF0B4
        'circlestar' => '891',                   # C+0xB5 # U+0xF0B5
        'starshadow' => '891',                   # C+0xB6 # U+0xF0B6
        'oneoclock' => '891',                    # C+0xB7 # U+0xF0B7
        'twooclock' => '891',                    # C+0xB8 # U+0xF0B8
        'threeoclock' => '891',                  # C+0xB9 # U+0xF0B9
        'fouroclock' => '891',                   # C+0xBA # U+0xF0BA
        'fiveoclock' => '891',                   # C+0xBB # U+0xF0BB
        'sixoclock' => '891',                    # C+0xBC # U+0xF0BC
        'sevenoclock' => '891',                  # C+0xBD # U+0xF0BD
        'eightoclock' => '891',                  # C+0xBE # U+0xF0BE
        'nineoclock' => '891',                   # C+0xBF # U+0xF0BF
        'tenoclock' => '891',                    # C+0xC0 # U+0xF0C0
        'elevenoclock' => '891',                 # C+0xC1 # U+0xF0C1
        'twelveoclock' => '891',                 # C+0xC2 # U+0xF0C2
        'arrowdwnleft1' => '891',                # C+0xC3 # U+0xF0C3
        'arrowdwnrt1' => '891',                  # C+0xC4 # U+0xF0C4
        'arrowupleft1' => '891',                 # C+0xC5 # U+0xF0C5
        'arrowuprt1' => '891',                   # C+0xC6 # U+0xF0C6
        'arrowleftup1' => '1047',                # C+0xC7 # U+0xF0C7
        'arrowrtup1' => '1047',                  # C+0xC8 # U+0xF0C8
        'arrowleftdwn1' => '1047',               # C+0xC9 # U+0xF0C9
        'arrowrtdwn1' => '1047',                 # C+0xCA # U+0xF0CA
        'quiltsquare2' => '1000',                # C+0xCB # U+0xF0CB
        'quiltsquare2inv' => '1000',             # C+0xCC # U+0xF0CC
        'leafccwsw' => '1000',                   # C+0xCD # U+0xF0CD
        'leafccwnw' => '1000',                   # C+0xCE # U+0xF0CE
        'leafccwse' => '1000',                   # C+0xCF # U+0xF0CF
        'leafccwne' => '1000',                   # C+0xD0 # U+0xF0D0
        'leafnw' => '1000',                      # C+0xD1 # U+0xF0D1
        'leafsw' => '1000',                      # C+0xD2 # U+0xF0D2
        'leafne' => '1000',                      # C+0xD3 # U+0xF0D3
        'leafse' => '1000',                      # C+0xD4 # U+0xF0D4
        'deleteleft' => '1252',                  # C+0xD5 # U+0xF0D5
        'deleteright' => '1252',                 # C+0xD6 # U+0xF0D6
        'head2left' => '794',                    # C+0xD7 # U+0xF0D7
        'head2right' => '794',                   # C+0xD8 # U+0xF0D8
        'head2up' => '891',                      # C+0xD9 # U+0xF0D9
        'head2down' => '891',                    # C+0xDA # U+0xF0DA
        'circleleft' => '891',                   # C+0xDB # U+0xF0DB
        'circleright' => '891',                  # C+0xDC # U+0xF0DC
        'circleup' => '891',                     # C+0xDD # U+0xF0DD
        'circledown' => '891',                   # C+0xDE # U+0xF0DE
        'barb2left' => '979',                    # C+0xDF # U+0xF0DF
        'barb2right' => '979',                   # C+0xE0 # U+0xF0E0
        'barb2up' => '891',                      # C+0xE1 # U+0xF0E1
        'barb2down' => '891',                    # C+0xE2 # U+0xF0E2
        'barb2nw' => '775',                      # C+0xE3 # U+0xF0E3
        'barb2ne' => '775',                      # C+0xE4 # U+0xF0E4
        'barb2sw' => '775',                      # C+0xE5 # U+0xF0E5
        'barb2se' => '775',                      # C+0xE6 # U+0xF0E6
        'barb4left' => '1067',                   # C+0xE7 # U+0xF0E7
        'barb4right' => '1067',                  # C+0xE8 # U+0xF0E8
        'barb4up' => '891',                      # C+0xE9 # U+0xF0E9
        'barb4down' => '891',                    # C+0xEA # U+0xF0EA
        'barb4nw' => '872',                      # C+0xEB # U+0xF0EB
        'barb4ne' => '872',                      # C+0xEC # U+0xF0EC
        'barb4sw' => '872',                      # C+0xED # U+0xF0ED
        'barb4se' => '872',                      # C+0xEE # U+0xF0EE
        'bleft' => '891',                        # C+0xEF # U+0xF0EF
        'bright' => '891',                       # C+0xF0 # U+0xF0F0
        'bup' => '810',                          # C+0xF1 # U+0xF0F1
        'bdown' => '810',                        # C+0xF2 # U+0xF0F2
        'bleftright' => '1060',                  # C+0xF3 # U+0xF0F3
        'bupdown' => '810',                      # C+0xF4 # U+0xF0F4
        'bnw' => '781',                          # C+0xF5 # U+0xF0F5
        'bne' => '781',                          # C+0xF6 # U+0xF0F6
        'bsw' => '781',                          # C+0xF7 # U+0xF0F7
        'bse' => '781',                          # C+0xF8 # U+0xF0F8
        'bdash1' => '481',                       # C+0xF9 # U+0xF0F9
        'bdash2' => '385',                       # C+0xFA # U+0xF0FA
        'xmarkbld' => '635',                     # C+0xFB # U+0xF0FB
        'checkbld' => '785',                     # C+0xFC # U+0xF0FC
        'boxxmarkbld' => '891',                  # C+0xFD # U+0xF0FD
        'boxcheckbld' => '891',                  # C+0xFE # U+0xF0FE
        'windowslogo' => '1034',                 # C+0xFF # U+0xF0FF
    }, # HORIZ. WIDTH TABLE
} };

1;
