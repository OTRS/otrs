# --
# Kernel/Modules/AgentSearch.pm - provides global search
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentSearch;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $Referrer = $Self->{ParamObject}->GetParam( Param => 'Referrer' );
    my $Profile  = $Self->{ParamObject}->GetParam( Param => 'Profile' );

    # set default backend
    my $DefaultBackend = $Self->{ConfigObject}->Get('Frontend::SearchDefault');

    # config
    my $Config = $Self->{ConfigObject}->Get('Frontend::Search');

    # get target backend
    my $Redirect = $DefaultBackend;
    if ( $Config && $Referrer ) {
        for my $Group ( sort keys %{$Config} ) {
            for my $RegExp ( sort keys %{ $Config->{$Group} } ) {
                if ( $Referrer =~ /$RegExp/ ) {
                    $Redirect = $Config->{$Group}->{$RegExp};
                    last;
                }
            }
        }
    }

    # add profile
    if ($Profile) {
        $Redirect .= ';Profile=' . $Profile;
    }

    # redirect to new backend
    return $Self->{LayoutObject}->Redirect( OP => $Redirect );
}

1;
