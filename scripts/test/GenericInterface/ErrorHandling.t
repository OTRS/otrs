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

# setup the object manager with helper configuration
# restore database and sysconfig modifications
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $ErrorObject  = $Kernel::OM->Get('Kernel::GenericInterface::ErrorHandling');

my %WebserviceConfig = (
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        ErrorHandling         => { 1 => undef },
        ErrorHandlingPriority => [undef],
        Transport             => { 1 => undef },
    },
    Requester => {
        ErrorHandling         => { 1 => undef },
        ErrorHandlingPriority => [undef],
        Transport             => { 1 => undef },
    },
);
my $WebserviceID = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceAdd(
    Name    => 'UnitTest ErrorHandler ' . $Helper->GetRandomID(),
    Config  => \%WebserviceConfig,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $WebserviceID,
    'create test web service',
);

# prepare test data
my $SummaryCount = 1;
my %TestParams   = (
    WebserviceID      => $WebserviceID,
    WebserviceConfig  => \%WebserviceConfig,
    CommunicationID   => 'b026324c6904b2a9cb4b88d6d61c81d1',
    CommunicationType => 'Requester',
    ErrorStage        => 'PrepareRequest',
    Summary           => 'Summary ',
    Data              => { 1 => undef },
);

# test definitions
my @Test = (
    {
        Name  => 'missing web service id',
        Param => {
        },
        ResultErrorMessage => 'Got no WebserviceID!',
    },
    {
        Name  => 'missing webservice configuration',
        Param => {
            %TestParams,
            WebserviceConfig => undef,
        },
        ResultErrorMessage => 'Got no WebserviceConfig!',
    },
    {
        Name  => 'missing communication id',
        Param => {
            %TestParams,
            CommunicationID => undef,
        },
        ResultErrorMessage => 'Got no CommunicationID!',
    },
    {
        Name  => 'missing communication type',
        Param => {
            %TestParams,
            CommunicationType => undef,
        },
        ResultErrorMessage => 'Got no CommunicationType!',
    },
    {
        Name  => 'missing error stage',
        Param => {
            %TestParams,
            ErrorStage => undef,
        },
        ResultErrorMessage => 'Got no ErrorStage!',
    },
    {
        Name  => 'missing summary',
        Param => {
            %TestParams,
            Summary => undef,
        },
        ResultErrorMessage => 'Got no Summary!',
    },
    {
        Name  => 'missing data',
        Param => {
            %TestParams,
            Data => undef,
        },
        ResultErrorMessage => 'Got no Data!',
    },
    {
        Name      => 'no error handling modules configured',
        ConfigSet => {
            'GenericInterface::ErrorHandling::Module' => undef,
        },
        Param => {
            %TestParams,
            WebserviceConfig => {
                %WebserviceConfig,
                Requester => undef,
            },
        },
        ResultErrorMessage => 'Summary ',
    },
    {
        Name      => 'no error handling configuration',
        ConfigSet => {
            'GenericInterface::ErrorHandling::Module' => { 1 => undef },
        },
        Param => {
            %TestParams,
            WebserviceConfig => {
                %WebserviceConfig,
                Requester => {
                    ErrorHandling => undef,
                },
            },
            Summary => $TestParams{Summary} . $SummaryCount,
        },
        Result => {
            Success => 1,
        },
    },
    {
        Name  => 'no error handling priority',
        Param => {
            %TestParams,
            WebserviceConfig => {
                %WebserviceConfig,
                Requester => {
                    ErrorHandling         => { 1 => undef },
                    ErrorHandlingPriority => undef,
                },
            },
            Summary => $TestParams{Summary} . $SummaryCount,
        },
        Result => {
            Success => 1,
        },
    },
);

# test execution
for my $Test (@Test) {

    if ( $Test->{ConfigSet} ) {
        for my $ConfigKey ( sort keys %{ $Test->{ConfigSet} } ) {
            $ConfigObject->Set(
                Key   => $ConfigKey,
                Value => $Test->{ConfigSet}->{$ConfigKey},
            );
        }
    }

    my $Result = $ErrorObject->HandleError( %{ $Test->{Param} } );

    if ( $Test->{ResultErrorMessage} ) {
        $Self->Is(
            $Result->{ErrorMessage},
            $Test->{ResultErrorMessage},
            'HandleError ErrorMessage - ' . $Test->{Name},
        );
    }
    else {
        $Self->IsDeeply(
            $Result,
            $Test->{Result},
            'HandleError ErrorMessage - ' . $Test->{Name},
        );
    }
}

1;
