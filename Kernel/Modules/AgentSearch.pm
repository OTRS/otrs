# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentSearch;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $Referrer    = $ParamObject->GetParam( Param => 'Referrer' );
    my $Profile     = $ParamObject->GetParam( Param => 'Profile' );

    # set default backend
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $DefaultBackend = $ConfigObject->Get('Frontend::SearchDefault');

    # config
    my $Config = $ConfigObject->Get('Frontend::Search');

    # get target backend
    my $Redirect = $DefaultBackend;
    if ( $Config && $Referrer ) {
        for my $Group ( sort keys %{$Config} ) {
            REGEXP:
            for my $RegExp ( sort keys %{ $Config->{$Group} } ) {
                if ( $Referrer =~ /$RegExp/ ) {
                    $Redirect = $Config->{$Group}->{$RegExp};
                    last REGEXP;
                }
            }
        }
    }

    # add profile
    if ($Profile) {
        $Redirect .= ';Profile=' . $Profile;
    }

    # redirect to new backend
    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect( OP => $Redirect );
}

1;
