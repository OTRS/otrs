# --
# Transport.t - GenericInterface transport interface tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Transport.t,v 1.2 2011-02-08 20:01:28 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use CGI;
use HTTP::Request::Common;

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport;
use Kernel::System::FileTemp;

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %$Self,
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

#
# failing backend
#

{
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        %$Self,
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type => 'HTTP::Nonexisting',
        },
    );

    $Self->Is(
        ref $TransportObject,
        'HASH',
        'TransportObject instantiated with an incorrect backend',
    );

    $Self->False(
        $TransportObject->{Success},
        'TransportObject instantiated with an incorrect backend, failure detected',
    );

    $Self->True(
        $TransportObject->{ErrorMessage},
        'TransportObject instantiated with an incorrect backend, error message provided',
    );
}

#
# test backend, successful status
#

{
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        %$Self,
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => 0,
            },
        },
    );

    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        'TransportObject instantiated with testing backend (success status)',
    );

    #
    # RequesterPerformRequest()
    #

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation => 'test_operation',
        Data      => {
            A => 'A',
            b => 'b',
        },
    );

    $Self->True(
        $Result->{Success},
        'TransportObject RequesterPerformRequest() success',
    );

    $Self->Is(
        $Result->{Data}->{ResponseContent},
        'A=A&b=b',
        'TransportObject RequesterPerformRequest() result',
    );

    $Result = $TransportObject->RequesterPerformRequest(
        Data => {
            A => 'A',
            b => 'b',
        },
    );

    $Self->False(
        $Result->{Success},
        'TransportObject RequesterPerformRequest() fail detected (missing operation)',
    );

    $Self->True(
        $Result->{ErrorMessage},
        'TransportObject RequesterPerformRequest() error message found (missing operation)',
    );

    $Result = $TransportObject->RequesterPerformRequest(
        Operation => 'test_operation',
    );

    $Self->False(
        $Result->{Success},
        'TransportObject RequesterPerformRequest() fail detected (missing data)',
    );

    $Self->True(
        $Result->{ErrorMessage},
        'TransportObject RequesterPerformRequest() error message found (missing data)',
    );

    #
    # RequesterPerformRequest()
    #

    my $RequestContent = 'A=A&b=b';
    my $WebRequest     = new CGI($RequestContent);

    $TransportObject = Kernel::GenericInterface::Transport->new(
        %$Self,
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => 0,
            },
        },
        WebRequest => $WebRequest,
    );

    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        'TransportObject instantiated with testing backend (success status)',
    );

    $Result = $TransportObject->ProviderProcessRequest();

    $Self->IsDeeply(
        $Result->{Data},
        {
            A => 'A',
            b => 'b',
        },
        'TransportObject ProviderProcessRequest data result',
    );

}

#
# test backend, failing status
#

{
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        %$Self,
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => 1,
            },
        },
    );

    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        'TransportObject instantiated with testing backend (fail status)',
    );

    my $Result = $TransportObject->RequesterPerformRequest(
        Operation => 'test_operation',
        Data      => {
            A => 'A',
            b => 'b',
        },
    );

    $Self->False(
        $Result->{Success},
        'TransportObject RequesterPerformRequest() fail detected',
    );

    $Self->True(
        $Result->{ErrorMessage},
        'TransportObject RequesterPerformRequest() error message found',
    );
}

1;
