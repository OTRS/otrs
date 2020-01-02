# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use CGI;

{
    local $ENV{REQUEST_METHOD} = 'GET';
    local $ENV{QUERY_STRING}   = 'a=4;b=5';

    my $Request = $Kernel::OM->Get('Kernel::System::Web::Request');

    my @ParamNames = $Request->GetParamNames();
    $Self->IsDeeply(
        [ sort @ParamNames ],
        [qw/a b/],
        'ParamNames',
    );

    $Self->Is(
        $Request->GetParam( Param => 'a' ),
        4,
        'SingleParam',
    );

    $Self->Is(
        $Request->GetParam( Param => 'aia' ),
        undef,
        'SingleParam - not defined',
    );
}

{
    local $CGI::POST_MAX = 1024;    ## no critic

    my $Request = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Request->{Query}->{'.cgi_error'} = 'Unittest failed ;-)';

    $Self->Is(
        $Request->Error(),
        'Unittest failed ;-) - POST_MAX=1KB',
        'Error()',
    );
}

1;
