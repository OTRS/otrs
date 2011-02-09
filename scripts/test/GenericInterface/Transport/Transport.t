# --
# Transport.t - GenericInterface transport interface tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Transport.t,v 1.4 2011-02-09 15:52:27 mg Exp $
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
# test backend
#

for my $Fail ( 0 .. 1 ) {
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        %$Self,
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => $Fail,
            },
        },
    );

    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        'TransportObject instantiated with testing backend (Fail $Fail)',
    );

    #
    # RequesterPerformRequest()
    #

    my @RPRTestData = (
        {
            Name      => "TransportObject (Fail $Fail) RequesterPerformRequest()",
            Operation => 'test_operation',
            Data      => {
                A => 'A',
                b => 'b',
            },
            ResultData => 'A=A&b=b',
            Success    => 1,
        },
        {
            Name => "TransportObject (Fail $Fail) RequesterPerformRequest() missing operation",
            Data => {
                A => 'A',
                b => 'b',
            },
            Success => 0,
        },
        {
            Name      => "TransportObject (Fail $Fail) RequesterPerformRequest() missing data",
            Operation => 'test_operation',
            Success   => 0,
        },
    );

    for my $TestEntry (@RPRTestData) {
        my $Result = $TransportObject->RequesterPerformRequest(
            Operation => $TestEntry->{Operation},
            Data      => $TestEntry->{Data},
        );

        if ( !$Fail && $TestEntry->{Success} ) {
            $Self->True(
                $Result->{Success},
                "$TestEntry->{Name} success",
            );

            $Self->Is(
                $Result->{Data}->{ResponseContent},
                $TestEntry->{ResultData},
                "$TestEntry->{Name} result",
            );
        }
        else {
            $Self->False(
                $Result->{Success},
                "$TestEntry->{Name} fail detected",
            );

            $Self->True(
                $Result->{ErrorMessage},
                "$TestEntry->{Name} error message found",
            );
        }

    }

    #
    # ProviderProcessRequest()
    #

    my @PPRTestData = (
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest()",
            RequestContent => 'A=A',
            ResultData     => {
                A => 'A',
            },
            Operation => 'test_operation',
            Success   => 1,
        },
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest()",
            RequestContent => 'A=A&b=b',
            ResultData     => {
                A => 'A',
                b => 'b',
            },
            Operation => 'test_operation',
            Success   => 1,
        },
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest() UTF-8 data",
            RequestContent => 'A=A&使用下列语言=معلومات',
            ResultData     => {
                A                    => 'A',
                '使用下列语言' => 'معلومات',
            },
            Operation => 'test_operation',
            Success   => 1,
        },
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest() empty request",
            RequestContent => '',
            Success        => 0,
        },
    );

    for my $TestEntry (@PPRTestData) {

        # prepare CGI environment variables
        local $ENV{REQUEST_METHOD} = 'POST';
        local $ENV{CONTENT_LENGTH} = length( $TestEntry->{RequestContent} );
        local $ENV{CONTENT_TYPE}
            = 'application/x-www-form-urlencoded; charset=utf-8;';

        # redirect STDIN from String so that the transport layer will use this data
        local *STDIN;
        open STDIN, '<:utf8', \$TestEntry->{RequestContent};

        # reset CGI object from previous runs
        CGI::initialize_globals();

        my $Result = $TransportObject->ProviderProcessRequest();

        if ( !$Fail && $TestEntry->{Success} ) {
            $Self->True(
                $Result->{Success},
                "$TestEntry->{Name} success",
            );

            $Self->Is(
                $Result->{Operation},
                $TestEntry->{Operation},
                "$TestEntry->{Name} operation",
            );

            $Self->IsDeeply(
                $Result->{Data},
                $TestEntry->{ResultData},
                "$TestEntry->{Name} data result",
            );
        }
        else {
            $Self->False(
                $Result->{Success},
                "$TestEntry->{Name} fail detected",
            );

            $Self->True(
                $Result->{ErrorMessage},
                "$TestEntry->{Name} error message found",
            );
        }
    }

}

1;
