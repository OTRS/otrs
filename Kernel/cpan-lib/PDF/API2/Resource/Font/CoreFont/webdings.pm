package PDF::API2::Resource::Font::CoreFont::webdings;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub data { return {
    'fontname' => 'Webdings',
    'type' => 'TrueType',
    'apiname' => 'Web',
    'ascender' => '799',
    'capheight' => '604',
    'descender' => '-200',
    'isfixedpitch' => '0',
    'issymbol' => '1',
    'italicangle' => '0',
    'underlineposition' => '-273',
    'underlinethickness' => '100',
    'xheight' => '604',
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
        'spider',                                # C+0x21 # U+0xF021
        'web',                                   # C+0x22 # U+0xF022
        'nopiracy',                              # C+0x23 # U+0xF023
        'cool',                                  # C+0x24 # U+0xF024
        'trophy',                                # C+0x25 # U+0xF025
        'award',                                 # C+0x26 # U+0xF026
        'links',                                 # C+0x27 # U+0xF027
        'talkleft',                              # C+0x28 # U+0xF028
        'talkright',                             # C+0x29 # U+0xF029
        'new',                                   # C+0x2A # U+0xF02A
        'updated',                               # C+0x2B # U+0xF02B
        'hot',                                   # C+0x2C # U+0xF02C
        'ribbon',                                # C+0x2D # U+0xF02D
        'checkerboard',                          # C+0x2E # U+0xF02E
        'slash',                                 # C+0x2F # U+0xF02F
        'UIminimize',                            # C+0x30 # U+0xF030
        'UImaximize',                            # C+0x31 # U+0xF031
        'UItile',                                # C+0x32 # U+0xF032
        'UIback',                                # C+0x33 # U+0xF033
        'UIforward',                             # C+0x34 # U+0xF034
        'UIup',                                  # C+0x35 # U+0xF035
        'UIdown',                                # C+0x36 # U+0xF036
        'UIreverse',                             # C+0x37 # U+0xF037
        'UIfastforward',                         # C+0x38 # U+0xF038
        'UIbegin',                               # C+0x39 # U+0xF039
        'UIend',                                 # C+0x3A # U+0xF03A
        'UIpause',                               # C+0x3B # U+0xF03B
        'UIstop',                                # C+0x3C # U+0xF03C
        'UIrecord',                              # C+0x3D # U+0xF03D
        'fontsize',                              # C+0x3E # U+0xF03E
        'vote',                                  # C+0x3F # U+0xF03F
        'tools',                                 # C+0x40 # U+0xF040
        'underconstruction',                     # C+0x41 # U+0xF041
        'town',                                  # C+0x42 # U+0xF042
        'city',                                  # C+0x43 # U+0xF043
        'derelictsite',                          # C+0x44 # U+0xF044
        'desert',                                # C+0x45 # U+0xF045
        'factory',                               # C+0x46 # U+0xF046
        'publicbuilding',                        # C+0x47 # U+0xF047
        'home',                                  # C+0x48 # U+0xF048
        'beach',                                 # C+0x49 # U+0xF049
        'island',                                # C+0x4A # U+0xF04A
        'motorway',                              # C+0x4B # U+0xF04B
        'search',                                # C+0x4C # U+0xF04C
        'mountain',                              # C+0x4D # U+0xF04D
        'sight',                                 # C+0x4E # U+0xF04E
        'hearing',                               # C+0x4F # U+0xF04F
        'park',                                  # C+0x50 # U+0xF050
        'camping',                               # C+0x51 # U+0xF051
        'railroad',                              # C+0x52 # U+0xF052
        'stadium',                               # C+0x53 # U+0xF053
        'ship',                                  # C+0x54 # U+0xF054
        'soundon',                               # C+0x55 # U+0xF055
        'soundoff',                              # C+0x56 # U+0xF056
        'soundleft',                             # C+0x57 # U+0xF057
        'soundright',                            # C+0x58 # U+0xF058
        'favorite',                              # C+0x59 # U+0xF059
        'occasion',                              # C+0x5A # U+0xF05A
        'thoughtleft',                           # C+0x5B # U+0xF05B
        'backslash',                             # C+0x5C # U+0xF05C
        'thoughtright',                          # C+0x5D # U+0xF05D
        'chat',                                  # C+0x5E # U+0xF05E
        'conference',                            # C+0x5F # U+0xF05F
        'loop',                                  # C+0x60 # U+0xF060
        'UIcheck',                               # C+0x61 # U+0xF061
        'bicycle',                               # C+0x62 # U+0xF062
        'boxopen',                               # C+0x63 # U+0xF063
        'sheild',                                # C+0x64 # U+0xF064
        'package',                               # C+0x65 # U+0xF065
        'fire',                                  # C+0x66 # U+0xF066
        'boxsolid',                              # C+0x67 # U+0xF067
        'medical',                               # C+0x68 # U+0xF068
        'information',                           # C+0x69 # U+0xF069
        'planesmall',                            # C+0x6A # U+0xF06A
        'satellite',                             # C+0x6B # U+0xF06B
        'navigate',                              # C+0x6C # U+0xF06C
        'jump',                                  # C+0x6D # U+0xF06D
        'circlesolid',                           # C+0x6E # U+0xF06E
        'boat',                                  # C+0x6F # U+0xF06F
        'police',                                # C+0x70 # U+0xF070
        'UIrefresh',                             # C+0x71 # U+0xF071
        'UIclose',                               # C+0x72 # U+0xF072
        'UIhelp',                                # C+0x73 # U+0xF073
        'train',                                 # C+0x74 # U+0xF074
        'metro',                                 # C+0x75 # U+0xF075
        'bus',                                   # C+0x76 # U+0xF076
        'flag',                                  # C+0x77 # U+0xF077
        'not',                                   # C+0x78 # U+0xF078
        'noentry',                               # C+0x79 # U+0xF079
        'nosmoking',                             # C+0x7A # U+0xF07A
        'shoutleft',                             # C+0x7B # U+0xF07B
        'bar',                                   # C+0x7C # U+0xF07C
        'shoutright',                            # C+0x7D # U+0xF07D
        'lightningbolt',                         # C+0x7E # U+0xF07E
        '.notdef',                               # C+0x7F # U+0x0000
        'man',                                   # C+0x80 # U+0xF080
        'woman',                                 # C+0x81 # U+0xF081
        'boy',                                   # C+0x82 # U+0xF082
        'girl',                                  # C+0x83 # U+0xF083
        'baby',                                  # C+0x84 # U+0xF084
        'scifi',                                 # C+0x85 # U+0xF085
        'health',                                # C+0x86 # U+0xF086
        'skier',                                 # C+0x87 # U+0xF087
        'hobby',                                 # C+0x88 # U+0xF088
        'golfer',                                # C+0x89 # U+0xF089
        'pool',                                  # C+0x8A # U+0xF08A
        'surf',                                  # C+0x8B # U+0xF08B
        'motorcycle',                            # C+0x8C # U+0xF08C
        'racecar',                               # C+0x8D # U+0xF08D
        'auto',                                  # C+0x8E # U+0xF08E
        'finance',                               # C+0x8F # U+0xF08F
        'commodities',                           # C+0x90 # U+0xF090
        'money',                                 # C+0x91 # U+0xF091
        'price',                                 # C+0x92 # U+0xF092
        'creditcard',                            # C+0x93 # U+0xF093
        'ratingfamily',                          # C+0x94 # U+0xF094
        'ratingviolence',                        # C+0x95 # U+0xF095
        'ratingsex',                             # C+0x96 # U+0xF096
        'ratinglanguage',                        # C+0x97 # U+0xF097
        'ratingquality',                         # C+0x98 # U+0xF098
        'email',                                 # C+0x99 # U+0xF099
        'send',                                  # C+0x9A # U+0xF09A
        'mail',                                  # C+0x9B # U+0xF09B
        'write',                                 # C+0x9C # U+0xF09C
        'textdoc',                               # C+0x9D # U+0xF09D
        'textgraphicdoc',                        # C+0x9E # U+0xF09E
        'graphicdoc',                            # C+0x9F # U+0xF09F
        'investigate',                           # C+0xA0 # U+0xF0A0
        'clock',                                 # C+0xA1 # U+0xF0A1
        'frames',                                # C+0xA2 # U+0xF0A2
        'noframes',                              # C+0xA3 # U+0xF0A3
        'clipboard',                             # C+0xA4 # U+0xF0A4
        'note',                                  # C+0xA5 # U+0xF0A5
        'calender',                              # C+0xA6 # U+0xF0A6
        'book',                                  # C+0xA7 # U+0xF0A7
        'reference',                             # C+0xA8 # U+0xF0A8
        'news',                                  # C+0xA9 # U+0xF0A9
        'classified',                            # C+0xAA # U+0xF0AA
        'archive',                               # C+0xAB # U+0xF0AB
        'index',                                 # C+0xAC # U+0xF0AC
        'art',                                   # C+0xAD # U+0xF0AD
        'theatre',                               # C+0xAE # U+0xF0AE
        'music',                                 # C+0xAF # U+0xF0AF
        'MIDI',                                  # C+0xB0 # U+0xF0B0
        'microphone',                            # C+0xB1 # U+0xF0B1
        'headphones',                            # C+0xB2 # U+0xF0B2
        'CDROM',                                 # C+0xB3 # U+0xF0B3
        'filmclip',                              # C+0xB4 # U+0xF0B4
        'pointofinterest',                       # C+0xB5 # U+0xF0B5
        'ticket',                                # C+0xB6 # U+0xF0B6
        'film',                                  # C+0xB7 # U+0xF0B7
        'movies',                                # C+0xB8 # U+0xF0B8
        'video',                                 # C+0xB9 # U+0xF0B9
        'stereo',                                # C+0xBA # U+0xF0BA
        'radio',                                 # C+0xBB # U+0xF0BB
        'levelcontrol',                          # C+0xBC # U+0xF0BC
        'audiocontrol',                          # C+0xBD # U+0xF0BD
        'television',                            # C+0xBE # U+0xF0BE
        'computers1',                            # C+0xBF # U+0xF0BF
        'computers2',                            # C+0xC0 # U+0xF0C0
        'computers3',                            # C+0xC1 # U+0xF0C1
        'computers4',                            # C+0xC2 # U+0xF0C2
        'joystick',                              # C+0xC3 # U+0xF0C3
        'gamepad',                               # C+0xC4 # U+0xF0C4
        'phone',                                 # C+0xC5 # U+0xF0C5
        'fax',                                   # C+0xC6 # U+0xF0C6
        'pager',                                 # C+0xC7 # U+0xF0C7
        'cellularphone',                         # C+0xC8 # U+0xF0C8
        'modem',                                 # C+0xC9 # U+0xF0C9
        'printer',                               # C+0xCA # U+0xF0CA
        'calculator',                            # C+0xCB # U+0xF0CB
        'folder',                                # C+0xCC # U+0xF0CC
        'disk',                                  # C+0xCD # U+0xF0CD
        'compression',                           # C+0xCE # U+0xF0CE
        'locked',                                # C+0xCF # U+0xF0CF
        'unlocked',                              # C+0xD0 # U+0xF0D0
        'encryption',                            # C+0xD1 # U+0xF0D1
        'inbox',                                 # C+0xD2 # U+0xF0D2
        'outbox',                                # C+0xD3 # U+0xF0D3
        'ovalshape',                             # C+0xD4 # U+0xF0D4
        'sunny',                                 # C+0xD5 # U+0xF0D5
        'mostlysunny',                           # C+0xD6 # U+0xF0D6
        'mostlycloudy',                          # C+0xD7 # U+0xF0D7
        'showers',                               # C+0xD8 # U+0xF0D8
        'cloudy',                                # C+0xD9 # U+0xF0D9
        'snow',                                  # C+0xDA # U+0xF0DA
        'rain',                                  # C+0xDB # U+0xF0DB
        'lightning',                             # C+0xDC # U+0xF0DC
        'twister',                               # C+0xDD # U+0xF0DD
        'wind',                                  # C+0xDE # U+0xF0DE
        'fog',                                   # C+0xDF # U+0xF0DF
        'moon',                                  # C+0xE0 # U+0xF0E0
        'temperature',                           # C+0xE1 # U+0xF0E1
        'lifestyles',                            # C+0xE2 # U+0xF0E2
        'guestrooms',                            # C+0xE3 # U+0xF0E3
        'dining',                                # C+0xE4 # U+0xF0E4
        'lounge',                                # C+0xE5 # U+0xF0E5
        'services',                              # C+0xE6 # U+0xF0E6
        'shopping',                              # C+0xE7 # U+0xF0E7
        'parking',                               # C+0xE8 # U+0xF0E8
        'handycap',                              # C+0xE9 # U+0xF0E9
        'caution',                               # C+0xEA # U+0xF0EA
        'marker',                                # C+0xEB # U+0xF0EB
        'education',                             # C+0xEC # U+0xF0EC
        'raysabove',                             # C+0xED # U+0xF0ED
        'raysbelow',                             # C+0xEE # U+0xF0EE
        'raysleft',                              # C+0xEF # U+0xF0EF
        'raysright',                             # C+0xF0 # U+0xF0F0
        'airplane',                              # C+0xF1 # U+0xF0F1
        'animal1',                               # C+0xF2 # U+0xF0F2
        'bird',                                  # C+0xF3 # U+0xF0F3
        'fish',                                  # C+0xF4 # U+0xF0F4
        'dog',                                   # C+0xF5 # U+0xF0F5
        'cat',                                   # C+0xF6 # U+0xF0F6
        'rocketleft',                            # C+0xF7 # U+0xF0F7
        'rocketright',                           # C+0xF8 # U+0xF0F8
        'rocketup',                              # C+0xF9 # U+0xF0F9
        'rocketdown',                            # C+0xFA # U+0xF0FA
        'worldmap',                              # C+0xFB # U+0xF0FB
        'globe1',                                # C+0xFC # U+0xF0FC
        'globe2',                                # C+0xFD # U+0xF0FD
        'globe3',                                # C+0xFE # U+0xF0FE
        'peace',                                 # C+0xFF # U+0xF0FF
    ], # DEF. ENCODING GLYPH TABLE
    'fontbbox' => [ -1, -200, 4000, 799 ],
    'wx' => { # HORIZ. WIDTH TABLE
        'space' => '500',                        # C+0x20 # U+0xF020
        'spider' => '1000',                      # C+0x21 # U+0xF021
        'web' => '1000',                         # C+0x22 # U+0xF022
        'nopiracy' => '1000',                    # C+0x23 # U+0xF023
        'cool' => '1000',                        # C+0x24 # U+0xF024
        'trophy' => '990',                       # C+0x25 # U+0xF025
        'award' => '1000',                       # C+0x26 # U+0xF026
        'links' => '1000',                       # C+0x27 # U+0xF027
        'talkleft' => '1000',                    # C+0x28 # U+0xF028
        'talkright' => '1000',                   # C+0x29 # U+0xF029
        'new' => '1000',                         # C+0x2A # U+0xF02A
        'updated' => '1000',                     # C+0x2B # U+0xF02B
        'hot' => '1000',                         # C+0x2C # U+0xF02C
        'ribbon' => '1000',                      # C+0x2D # U+0xF02D
        'checkerboard' => '1000',                # C+0x2E # U+0xF02E
        'slash' => '1000',                       # C+0x2F # U+0xF02F
        'UIminimize' => '1000',                  # C+0x30 # U+0xF030
        'UImaximize' => '1000',                  # C+0x31 # U+0xF031
        'UItile' => '1000',                      # C+0x32 # U+0xF032
        'UIback' => '1000',                      # C+0x33 # U+0xF033
        'UIforward' => '1000',                   # C+0x34 # U+0xF034
        'UIup' => '1000',                        # C+0x35 # U+0xF035
        'UIdown' => '1000',                      # C+0x36 # U+0xF036
        'UIreverse' => '1000',                   # C+0x37 # U+0xF037
        'UIfastforward' => '1000',               # C+0x38 # U+0xF038
        'UIbegin' => '1000',                     # C+0x39 # U+0xF039
        'UIend' => '1000',                       # C+0x3A # U+0xF03A
        'UIpause' => '1000',                     # C+0x3B # U+0xF03B
        'UIstop' => '1000',                      # C+0x3C # U+0xF03C
        'UIrecord' => '1000',                    # C+0x3D # U+0xF03D
        'fontsize' => '1000',                    # C+0x3E # U+0xF03E
        'vote' => '1000',                        # C+0x3F # U+0xF03F
        'tools' => '1000',                       # C+0x40 # U+0xF040
        'underconstruction' => '1000',           # C+0x41 # U+0xF041
        'town' => '1000',                        # C+0x42 # U+0xF042
        'city' => '1000',                        # C+0x43 # U+0xF043
        'derelictsite' => '1000',                # C+0x44 # U+0xF044
        'desert' => '1000',                      # C+0x45 # U+0xF045
        'factory' => '1000',                     # C+0x46 # U+0xF046
        'publicbuilding' => '1000',              # C+0x47 # U+0xF047
        'home' => '1000',                        # C+0x48 # U+0xF048
        'beach' => '1000',                       # C+0x49 # U+0xF049
        'island' => '1000',                      # C+0x4A # U+0xF04A
        'motorway' => '1000',                    # C+0x4B # U+0xF04B
        'search' => '1000',                      # C+0x4C # U+0xF04C
        'mountain' => '1000',                    # C+0x4D # U+0xF04D
        'sight' => '1000',                       # C+0x4E # U+0xF04E
        'hearing' => '1000',                     # C+0x4F # U+0xF04F
        'park' => '1000',                        # C+0x50 # U+0xF050
        'camping' => '1000',                     # C+0x51 # U+0xF051
        'railroad' => '1000',                    # C+0x52 # U+0xF052
        'stadium' => '1000',                     # C+0x53 # U+0xF053
        'ship' => '1000',                        # C+0x54 # U+0xF054
        'soundon' => '1000',                     # C+0x55 # U+0xF055
        'soundoff' => '1000',                    # C+0x56 # U+0xF056
        'soundleft' => '537',                    # C+0x57 # U+0xF057
        'soundright' => '537',                   # C+0x58 # U+0xF058
        'favorite' => '1000',                    # C+0x59 # U+0xF059
        'occasion' => '1000',                    # C+0x5A # U+0xF05A
        'thoughtleft' => '1000',                 # C+0x5B # U+0xF05B
        'backslash' => '1000',                   # C+0x5C # U+0xF05C
        'thoughtright' => '1000',                # C+0x5D # U+0xF05D
        'chat' => '1000',                        # C+0x5E # U+0xF05E
        'conference' => '1000',                  # C+0x5F # U+0xF05F
        'loop' => '1000',                        # C+0x60 # U+0xF060
        'UIcheck' => '1000',                     # C+0x61 # U+0xF061
        'bicycle' => '1000',                     # C+0x62 # U+0xF062
        'boxopen' => '1000',                     # C+0x63 # U+0xF063
        'sheild' => '1000',                      # C+0x64 # U+0xF064
        'package' => '1000',                     # C+0x65 # U+0xF065
        'fire' => '1000',                        # C+0x66 # U+0xF066
        'boxsolid' => '1000',                    # C+0x67 # U+0xF067
        'medical' => '1000',                     # C+0x68 # U+0xF068
        'information' => '1000',                 # C+0x69 # U+0xF069
        'planesmall' => '1000',                  # C+0x6A # U+0xF06A
        'satellite' => '1000',                   # C+0x6B # U+0xF06B
        'navigate' => '1000',                    # C+0x6C # U+0xF06C
        'jump' => '558',                         # C+0x6D # U+0xF06D
        'circlesolid' => '1000',                 # C+0x6E # U+0xF06E
        'boat' => '1000',                        # C+0x6F # U+0xF06F
        'police' => '1000',                      # C+0x70 # U+0xF070
        'UIrefresh' => '1000',                   # C+0x71 # U+0xF071
        'UIclose' => '1000',                     # C+0x72 # U+0xF072
        'UIhelp' => '1000',                      # C+0x73 # U+0xF073
        'train' => '1000',                       # C+0x74 # U+0xF074
        'metro' => '1000',                       # C+0x75 # U+0xF075
        'bus' => '1000',                         # C+0x76 # U+0xF076
        'flag' => '1000',                        # C+0x77 # U+0xF077
        'not' => '1000',                         # C+0x78 # U+0xF078
        'noentry' => '1000',                     # C+0x79 # U+0xF079
        'nosmoking' => '1000',                   # C+0x7A # U+0xF07A
        'shoutleft' => '1000',                   # C+0x7B # U+0xF07B
        'bar' => '1000',                         # C+0x7C # U+0xF07C
        'shoutright' => '1000',                  # C+0x7D # U+0xF07D
        'lightningbolt' => '1000',               # C+0x7E # U+0xF07E
        'man' => '1000',                         # C+0x80 # U+0xF080
        'woman' => '1000',                       # C+0x81 # U+0xF081
        'boy' => '1000',                         # C+0x82 # U+0xF082
        'girl' => '1000',                        # C+0x83 # U+0xF083
        'baby' => '1000',                        # C+0x84 # U+0xF084
        'scifi' => '1000',                       # C+0x85 # U+0xF085
        'health' => '1000',                      # C+0x86 # U+0xF086
        'skier' => '1000',                       # C+0x87 # U+0xF087
        'hobby' => '1000',                       # C+0x88 # U+0xF088
        'golfer' => '1000',                      # C+0x89 # U+0xF089
        'pool' => '1000',                        # C+0x8A # U+0xF08A
        'surf' => '1000',                        # C+0x8B # U+0xF08B
        'motorcycle' => '1000',                  # C+0x8C # U+0xF08C
        'racecar' => '1220',                     # C+0x8D # U+0xF08D
        'auto' => '1000',                        # C+0x8E # U+0xF08E
        'finance' => '1000',                     # C+0x8F # U+0xF08F
        'commodities' => '1000',                 # C+0x90 # U+0xF090
        'money' => '1000',                       # C+0x91 # U+0xF091
        'price' => '1000',                       # C+0x92 # U+0xF092
        'creditcard' => '1000',                  # C+0x93 # U+0xF093
        'ratingfamily' => '1000',                # C+0x94 # U+0xF094
        'ratingviolence' => '1000',              # C+0x95 # U+0xF095
        'ratingsex' => '1000',                   # C+0x96 # U+0xF096
        'ratinglanguage' => '1000',              # C+0x97 # U+0xF097
        'ratingquality' => '1000',               # C+0x98 # U+0xF098
        'email' => '1000',                       # C+0x99 # U+0xF099
        'send' => '1000',                        # C+0x9A # U+0xF09A
        'mail' => '1000',                        # C+0x9B # U+0xF09B
        'write' => '1000',                       # C+0x9C # U+0xF09C
        'textdoc' => '1000',                     # C+0x9D # U+0xF09D
        'textgraphicdoc' => '1000',              # C+0x9E # U+0xF09E
        'graphicdoc' => '1000',                  # C+0x9F # U+0xF09F
        'investigate' => '1000',                 # C+0xA0 # U+0xF0A0
        'clock' => '1000',                       # C+0xA1 # U+0xF0A1
        'frames' => '1000',                      # C+0xA2 # U+0xF0A2
        'noframes' => '1000',                    # C+0xA3 # U+0xF0A3
        'clipboard' => '1000',                   # C+0xA4 # U+0xF0A4
        'note' => '1000',                        # C+0xA5 # U+0xF0A5
        'calender' => '1000',                    # C+0xA6 # U+0xF0A6
        'book' => '1000',                        # C+0xA7 # U+0xF0A7
        'reference' => '1000',                   # C+0xA8 # U+0xF0A8
        'news' => '1000',                        # C+0xA9 # U+0xF0A9
        'classified' => '1000',                  # C+0xAA # U+0xF0AA
        'archive' => '1000',                     # C+0xAB # U+0xF0AB
        'index' => '1000',                       # C+0xAC # U+0xF0AC
        'art' => '1000',                         # C+0xAD # U+0xF0AD
        'theatre' => '1000',                     # C+0xAE # U+0xF0AE
        'music' => '1000',                       # C+0xAF # U+0xF0AF
        'MIDI' => '1000',                        # C+0xB0 # U+0xF0B0
        'microphone' => '1000',                  # C+0xB1 # U+0xF0B1
        'headphones' => '1000',                  # C+0xB2 # U+0xF0B2
        'CDROM' => '1000',                       # C+0xB3 # U+0xF0B3
        'filmclip' => '1000',                    # C+0xB4 # U+0xF0B4
        'pointofinterest' => '1000',             # C+0xB5 # U+0xF0B5
        'ticket' => '1000',                      # C+0xB6 # U+0xF0B6
        'film' => '1000',                        # C+0xB7 # U+0xF0B7
        'movies' => '1000',                      # C+0xB8 # U+0xF0B8
        'video' => '1000',                       # C+0xB9 # U+0xF0B9
        'stereo' => '1000',                      # C+0xBA # U+0xF0BA
        'radio' => '1000',                       # C+0xBB # U+0xF0BB
        'levelcontrol' => '672',                 # C+0xBC # U+0xF0BC
        'audiocontrol' => '672',                 # C+0xBD # U+0xF0BD
        'television' => '1000',                  # C+0xBE # U+0xF0BE
        'computers1' => '842',                   # C+0xBF # U+0xF0BF
        'computers2' => '516',                   # C+0xC0 # U+0xF0C0
        'computers3' => '1000',                  # C+0xC1 # U+0xF0C1
        'computers4' => '1000',                  # C+0xC2 # U+0xF0C2
        'joystick' => '1000',                    # C+0xC3 # U+0xF0C3
        'gamepad' => '1000',                     # C+0xC4 # U+0xF0C4
        'phone' => '428',                        # C+0xC5 # U+0xF0C5
        'fax' => '605',                          # C+0xC6 # U+0xF0C6
        'pager' => '1000',                       # C+0xC7 # U+0xF0C7
        'cellularphone' => '1000',               # C+0xC8 # U+0xF0C8
        'modem' => '1000',                       # C+0xC9 # U+0xF0C9
        'printer' => '1000',                     # C+0xCA # U+0xF0CA
        'calculator' => '662',                   # C+0xCB # U+0xF0CB
        'folder' => '1000',                      # C+0xCC # U+0xF0CC
        'disk' => '1000',                        # C+0xCD # U+0xF0CD
        'compression' => '1000',                 # C+0xCE # U+0xF0CE
        'locked' => '1000',                      # C+0xCF # U+0xF0CF
        'unlocked' => '1000',                    # C+0xD0 # U+0xF0D0
        'encryption' => '1000',                  # C+0xD1 # U+0xF0D1
        'inbox' => '1000',                       # C+0xD2 # U+0xF0D2
        'outbox' => '1000',                      # C+0xD3 # U+0xF0D3
        'ovalshape' => '1000',                   # C+0xD4 # U+0xF0D4
        'sunny' => '1000',                       # C+0xD5 # U+0xF0D5
        'mostlysunny' => '1000',                 # C+0xD6 # U+0xF0D6
        'mostlycloudy' => '1000',                # C+0xD7 # U+0xF0D7
        'showers' => '1000',                     # C+0xD8 # U+0xF0D8
        'cloudy' => '1000',                      # C+0xD9 # U+0xF0D9
        'snow' => '1000',                        # C+0xDA # U+0xF0DA
        'rain' => '1000',                        # C+0xDB # U+0xF0DB
        'lightning' => '1000',                   # C+0xDC # U+0xF0DC
        'twister' => '1000',                     # C+0xDD # U+0xF0DD
        'wind' => '1000',                        # C+0xDE # U+0xF0DE
        'fog' => '1000',                         # C+0xDF # U+0xF0DF
        'moon' => '1000',                        # C+0xE0 # U+0xF0E0
        'temperature' => '1000',                 # C+0xE1 # U+0xF0E1
        'lifestyles' => '1000',                  # C+0xE2 # U+0xF0E2
        'guestrooms' => '1000',                  # C+0xE3 # U+0xF0E3
        'dining' => '1000',                      # C+0xE4 # U+0xF0E4
        'lounge' => '1000',                      # C+0xE5 # U+0xF0E5
        'services' => '1000',                    # C+0xE6 # U+0xF0E6
        'shopping' => '1000',                    # C+0xE7 # U+0xF0E7
        'parking' => '1000',                     # C+0xE8 # U+0xF0E8
        'handycap' => '1000',                    # C+0xE9 # U+0xF0E9
        'caution' => '1000',                     # C+0xEA # U+0xF0EA
        'marker' => '1000',                      # C+0xEB # U+0xF0EB
        'education' => '1000',                   # C+0xEC # U+0xF0EC
        'raysabove' => '1000',                   # C+0xED # U+0xF0ED
        'raysbelow' => '1000',                   # C+0xEE # U+0xF0EE
        'raysleft' => '1000',                    # C+0xEF # U+0xF0EF
        'raysright' => '1000',                   # C+0xF0 # U+0xF0F0
        'airplane' => '1000',                    # C+0xF1 # U+0xF0F1
        'animal1' => '1000',                     # C+0xF2 # U+0xF0F2
        'bird' => '1000',                        # C+0xF3 # U+0xF0F3
        'fish' => '1000',                        # C+0xF4 # U+0xF0F4
        'dog' => '1000',                         # C+0xF5 # U+0xF0F5
        'cat' => '1000',                         # C+0xF6 # U+0xF0F6
        'rocketleft' => '1000',                  # C+0xF7 # U+0xF0F7
        'rocketright' => '1000',                 # C+0xF8 # U+0xF0F8
        'rocketup' => '1000',                    # C+0xF9 # U+0xF0F9
        'rocketdown' => '1000',                  # C+0xFA # U+0xF0FA
        'worldmap' => '1291',                    # C+0xFB # U+0xF0FB
        'globe1' => '1000',                      # C+0xFC # U+0xF0FC
        'globe2' => '1000',                      # C+0xFD # U+0xF0FD
        'globe3' => '1000',                      # C+0xFE # U+0xF0FE
        'peace' => '1000',                       # C+0xFF # U+0xF0FF
    }, # UNICODE COMPAT TABLE
    'uni' => [
        0xF000,
        0xF001,
        0xF002,
        0xF003,
        0xF004,
        0xF005,
        0xF006,
        0xF007,
        0xF008,
        0xF009,
        0xF00A,
        0xF00B,
        0xF00C,
        0xF00D,
        0xF00E,
        0xF00F,
        0xF010,
        0xF011,
        0xF012,
        0xF013,
        0xF014,
        0xF015,
        0xF016,
        0xF017,
        0xF018,
        0xF019,
        0xF01A,
        0xF01B,
        0xF01C,
        0xF01D,
        0xF01E,
        0xF01F,
        0xF020,
        0xF021,
        0xF022,
        0xF023,
        0xF024,
        0xF025,
        0xF026,
        0xF027,
        0xF028,
        0xF029,
        0xF02A,
        0xF02B,
        0xF02C,
        0xF02D,
        0xF02E,
        0xF02F,
        0xF030,
        0xF031,
        0xF032,
        0xF033,
        0xF034,
        0xF035,
        0xF036,
        0xF037,
        0xF038,
        0xF039,
        0xF03A,
        0xF03B,
        0xF03C,
        0xF03D,
        0xF03E,
        0xF03F,
        0xF040,
        0xF041,
        0xF042,
        0xF043,
        0xF044,
        0xF045,
        0xF046,
        0xF047,
        0xF048,
        0xF049,
        0xF04A,
        0xF04B,
        0xF04C,
        0xF04D,
        0xF04E,
        0xF04F,
        0xF050,
        0xF051,
        0xF052,
        0xF053,
        0xF054,
        0xF055,
        0xF056,
        0xF057,
        0xF058,
        0xF059,
        0xF05A,
        0xF05B,
        0xF05C,
        0xF05D,
        0xF05E,
        0xF05F,
        0xF060,
        0xF061,
        0xF062,
        0xF063,
        0xF064,
        0xF065,
        0xF066,
        0xF067,
        0xF068,
        0xF069,
        0xF06A,
        0xF06B,
        0xF06C,
        0xF06D,
        0xF06E,
        0xF06F,
        0xF070,
        0xF071,
        0xF072,
        0xF073,
        0xF074,
        0xF075,
        0xF076,
        0xF077,
        0xF078,
        0xF079,
        0xF07A,
        0xF07B,
        0xF07C,
        0xF07D,
        0xF07E,
        0xF07F,
        0xF080,
        0xF081,
        0xF082,
        0xF083,
        0xF084,
        0xF085,
        0xF086,
        0xF087,
        0xF088,
        0xF089,
        0xF08A,
        0xF08B,
        0xF08C,
        0xF08D,
        0xF08E,
        0xF08F,
        0xF090,
        0xF091,
        0xF092,
        0xF093,
        0xF094,
        0xF095,
        0xF096,
        0xF097,
        0xF098,
        0xF099,
        0xF09A,
        0xF09B,
        0xF09C,
        0xF09D,
        0xF09E,
        0xF09F,
        0xF0A0,
        0xF0A1,
        0xF0A2,
        0xF0A3,
        0xF0A4,
        0xF0A5,
        0xF0A6,
        0xF0A7,
        0xF0A8,
        0xF0A9,
        0xF0AA,
        0xF0AB,
        0xF0AC,
        0xF0AD,
        0xF0AE,
        0xF0AF,
        0xF0B0,
        0xF0B1,
        0xF0B2,
        0xF0B3,
        0xF0B4,
        0xF0B5,
        0xF0B6,
        0xF0B7,
        0xF0B8,
        0xF0B9,
        0xF0BA,
        0xF0BB,
        0xF0BC,
        0xF0BD,
        0xF0BE,
        0xF0BF,
        0xF0C0,
        0xF0C1,
        0xF0C2,
        0xF0C3,
        0xF0C4,
        0xF0C5,
        0xF0C6,
        0xF0C7,
        0xF0C8,
        0xF0C9,
        0xF0CA,
        0xF0CB,
        0xF0CC,
        0xF0CD,
        0xF0CE,
        0xF0CF,
        0xF0D0,
        0xF0D1,
        0xF0D2,
        0xF0D3,
        0xF0D4,
        0xF0D5,
        0xF0D6,
        0xF0D7,
        0xF0D8,
        0xF0D9,
        0xF0DA,
        0xF0DB,
        0xF0DC,
        0xF0DD,
        0xF0DE,
        0xF0DF,
        0xF0E0,
        0xF0E1,
        0xF0E2,
        0xF0E3,
        0xF0E4,
        0xF0E5,
        0xF0E6,
        0xF0E7,
        0xF0E8,
        0xF0E9,
        0xF0EA,
        0xF0EB,
        0xF0EC,
        0xF0ED,
        0xF0EE,
        0xF0EF,
        0xF0F0,
        0xF0F1,
        0xF0F2,
        0xF0F3,
        0xF0F4,
        0xF0F5,
        0xF0F6,
        0xF0F7,
        0xF0F8,
        0xF0F9,
        0xF0FA,
        0xF0FB,
        0xF0FC,
        0xF0FD,
        0xF0FE,
        0xF0FF,
    ],
} };

1;
