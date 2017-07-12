package PDF::API2::Resource::PaperSizes;

use strict;
use warnings;

our $VERSION = '2.033'; # VERSION

sub get_paper_sizes {
    return (
        # Metric sizes
        '4a'         => [ 4760, 6716 ], # deprecated, non-standard name
        '2a'         => [ 3368, 4760 ], # deprecated, non-standard name
        '4a0'        => [ 4760, 6716 ],
        '2a0'        => [ 3368, 4760 ],
        'a0'         => [ 2380, 3368 ],
        'a1'         => [ 1684, 2380 ],
        'a2'         => [ 1190, 1684 ],
        'a3'         => [  842, 1190 ],
        'a4'         => [  595,  842 ],
        'a5'         => [  421,  595 ],
        'a6'         => [  297,  421 ],
        '4b'         => [ 5656, 8000 ], # deprecated, non-standard name
        '2b'         => [ 4000, 5656 ], # deprecated, non-standard name
        '4b0'        => [ 5656, 8000 ],
        '2b0'        => [ 4000, 5656 ],
        'b0'         => [ 2828, 4000 ],
        'b1'         => [ 2000, 2828 ],
        'b2'         => [ 1414, 2000 ],
        'b3'         => [ 1000, 1414 ],
        'b4'         => [  707, 1000 ],
        'b5'         => [  500,  707 ],
        'b6'         => [  353,  500 ],

        # US sizes
        'letter'     => [  612,  792 ],
        'broadsheet' => [ 1296, 1584 ],
        'ledger'     => [ 1224,  792 ],
        'tabloid'    => [  792, 1224 ],
        'legal'      => [  612, 1008 ],
        'executive'  => [  522,  756 ],

        # Other
        '36x36'      => [ 2592, 2592 ],
    );
}

1;
