# --
# RequestSystemGuid.t - RequestSystemGuid Invoker tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: RequestSystemGuid.t,v 1.1 2011-03-31 18:26:02 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

my @Tests = (
    {
        Name           => 'Empty data',
        PrepareRequest => {
            Data    => {},
            Success => 1,
            }
    },
    {
        Name           => 'Undefined data',
        PrepareRequest => {
            Data    => undef,
            Success => 1,
            }
    },
    {
        Name           => 'With data',
        PrepareRequest => {
            Data => {
                Var1 => 1,
            },
            Success => 1,
            }
    },

    {
        Name           => 'Server Error',
        HandleResponse => {
            ResponseSuccess => 0,
            Data            => {},
            Success         => 0,
        },
    },
    {
        Name           => 'Empty Response Data',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {},
            Success         => 0,
        },
    },
    {
        Name           => 'No Errors parameter',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                SystemGuid => '',
            },
            Success => 0,
        },
    },
    {
        Name           => 'No SystemGuid',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors => '',
            },
            Success => 0,
        },
    },
    {
        Name           => 'Incomplete error parameter',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors => {
                    ErrorCode => '03',
                },
            },
            Success => 1,
        },
    },
    {
        Name           => 'Complete error parameter',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors => {
                    item => {
                        ErrorCode => '03',
                        Val1      => 'Description',
                        Val2      => 'Deatil1',
                        Val3      => 'Detail2',
                        Val4      => 'Detail3',
                        }
                },
            },
            Success      => 1,
            ErrorMessage => 'Error Code 03 Description Details: Detail1 Detail2 Detail3 |',
        },
    },
    {
        Name           => 'Correct SystemGuid',
        HandleResponse => {
            ResponseSuccess => 1,
            Data            => {
                Errors     => '',
                SystemGuid => '123ABC123ABC123'
            },
            Success    => 1,
            SystemGuid => '123ABC123ABC123',
        },
    },
);

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Invoker;
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    %{$Self},
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Requester',
);

# create object
my $InvokerObject = Kernel::GenericInterface::Invoker->new(
    %{$Self},
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    InvokerType    => 'SolMan::RequestSystemGuid',
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() success',
);

for my $Test (@Tests) {

    if ( $Test->{PrepareRequest} ) {

        my $ResponseData = {};

        my $Result = $InvokerObject->PrepareRequest(
            Data => $Test->{PrepareRequest}->{Data},
        );

        $Self->Is(
            ref $Result,
            'HASH',
            "Test $Test->{Name}: RequestSystemGuid PrepareRequest response",
        );

        $Self->True(
            $Result->{Success},
            "Test $Test->{Name}: RequestSystemGuid PrepareRequest",
        );

        $Self->Is(
            ref $Result->{Data},
            'HASH',
            "Test $Test->{Name}: RequestSystemGuid PrepareRequest Data",
        );

        $Self->IsDeeply(
            $Result->{Data},
            $ResponseData,
            "Test $Test->{Name}: RequestSystemGuid PrepareRequest Data",
        );

        $Self->Is(
            $Result->{ErrorMessage},
            undef,
            "Test $Test->{Name}: RequestSystemGuid PrepareRequest ErrorMessage",
        );
    }

    if ( $Test->{HandleResponse} ) {

        my $Result = $InvokerObject->HandleResponse(
            ResponseSuccess => $Test->{HandleResponse}->{ResponseSuccess},
            Data            => $Test->{HandleResponse}->{Data},
        );

        $Self->Is(
            ref $Result,
            'HASH',
            "Test $Test->{Name}: RequestSystemGuid HandleResponse response",
        );

        if ( $Test->{HandleResponse}->{Success} ) {
            $Self->Is(
                $Result->{Success},
                '1',
                "Test $Test->{Name}: RequestSystemGuid HandleResponse success",
            );

            if ( ref $Test->{HandleResponse}->{Data}->{Errors} eq 'HASH' ) {

                $Self->IsNot(
                    $Result->{ErrorMessage},
                    '',
                    "Test $Test->{Name}: RequestSystemGuid HandleResponse error message not empty",
                );

                if ( $Test->{HandleResponse}->{ErrorMessage} ) {
                    $Self->IsNot(
                        $Result->{ErrorMessage},
                        $Test->{HandleResponse}->{ErrorMessage},
                        "Test $Test->{Name}: RequestSystemGuid HandleResponse error message",
                    );
                }

                $Self->Is(
                    $Result->{SystemGuid},
                    undef,
                    "Test $Test->{Name}: RequestSystemGuid HandleResponse no SystemGuid",
                );

            }
            else {
                $Self->Is(
                    $Result->{ErrorMessage},
                    undef,
                    "Test $Test->{Name}: RequestSystemGuid HandleResponse error message not empty",
                );

                $Self->Is(
                    $Result->{Data}->{SystemGuid},
                    $Test->{HandleResponse}->{SystemGuid},
                    "Test $Test->{Name}: RequestSystemGuid HandleResponse SystemGuid",
                );
            }
        }
        else {
            $Self->Is(
                $Result->{Success},
                '0',
                "Test $Test->{Name}: RequestSystemGuid HandleResponse not success",
            );
        }
    }
}

1;
