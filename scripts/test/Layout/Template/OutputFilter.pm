# --
# scripts/test/Layout/Template/OutputFilter.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::Layout::Template::OutputFilter;    ## no critic

use strict;
use warnings;

use Cwd;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(MainObject ConfigObject ParamObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $Needed!",
            );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Prefix = $Param{Prefix};
    ${ $Param{Data} } = $Prefix . ${ $Param{Data} };

    return 1;
}

1;
