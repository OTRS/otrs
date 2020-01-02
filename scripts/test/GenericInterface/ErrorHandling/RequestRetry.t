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
use Kernel::System::VariableCheck qw(IsHashRefWithData);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $ErrorObject  = $Kernel::OM->Get('Kernel::GenericInterface::ErrorHandling::RequestRetry');

# set fixed time
my $CurrentDateTime       = $Kernel::OM->Create('Kernel::System::DateTime');
my $CurrentDateTimeString = $CurrentDateTime->ToString();
$HelperObject->FixedTimeSet($CurrentDateTime);

my $TimeDiff = sub {
    my ( $Self, $CurrentDateTime, $TimeDiff ) = @_;

    my $CloneDateTime = $CurrentDateTime->Clone();
    if ( $TimeDiff > 0 ) {
        $CloneDateTime->Add( Seconds => $TimeDiff );
    }
    else {
        $CloneDateTime->Subtract( Seconds => $TimeDiff * -1 );
    }

    return $CloneDateTime->ToString();
};

# test definition
my @Test = (
    {
        Name   => 'No ModuleConfig',
        Param  => {},
        Result => {
            Success      => 0,
            ErrorMessage => 'Got no ModuleConfig!',
        },
    },
    {
        Name  => 'Undefined ModuleConfig',
        Param => {
            ModuleConfig => undef,
        },
        Result => {
            Success      => 0,
            ErrorMessage => 'Got no ModuleConfig!',
        },
    },
    {
        Name  => 'Invalid ModuleConfig',
        Param => {
            ModuleConfig => [],
        },
        Result => {
            Success      => 0,
            ErrorMessage => 'Got no ModuleConfig!',
        },
    },
    {
        Name  => 'Empty ModuleConfig',
        Param => {
            ModuleConfig => {},
        },
        Result => {
            Success      => 0,
            ErrorMessage => 'Got no ModuleConfig!',
        },
    },
    {
        Name  => 'No ScheduleRetry in ModuleConfig',
        Param => {
            ModuleConfig => {
                1 => undef,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'ScheduleRetry' is not a non-empty string!",
        },
    },
    {
        Name  => 'Empty ScheduleRetry in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry => undef,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'ScheduleRetry' is not a non-empty string!",
        },
    },
    {
        Name  => 'Invalid ScheduleRetry in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry => {},
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'ScheduleRetry' is not a non-empty string!",
        },
    },
    {
        Name  => 'No RetryIntervalStart in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry => 0,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryIntervalStart' is not a non-empty string!",
        },
    },
    {
        Name  => 'No RetryIntervalFactor in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry      => 0,
                RetryIntervalStart => 0,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryIntervalFactor' is not a non-empty string!",
        },
    },
    {
        Name  => 'Invalid RetryIntervalMax in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryIntervalMax    => {},
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryIntervalMax' is not a string!",
        },
    },
    {
        Name  => 'Invalid RetryCountMax in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryCountMax       => {},
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryCountMax' is not a string!",
        },
    },
    {
        Name  => 'Invalid RetryPeriodMax in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryPeriodMax      => {},
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryPeriodMax' is not a string!",
        },
    },
    {
        Name  => 'Invalid ScheduleRetry in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 'a',
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'ScheduleRetry' is not '0' or '1'!",
        },
    },
    {
        Name  => 'Invalid RetryIntervalFactor in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 0,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryIntervalFactor' is not '1', '1.5' or '2'!",
        },
    },
    {
        Name  => 'Invalid RetryIntervalStart in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => -1,
                RetryIntervalFactor => 1,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryIntervalStart' is not '0' or a positive integer!",
        },
    },
    {
        Name  => 'Invalid RetryIntervalMax in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryIntervalMax    => 'a',
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryIntervalMax' is not empty, '0' or a positive integer!",
        },
    },
    {
        Name  => 'Invalid RetryCountMax in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryCountMax       => 0,
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryCountMax' is not empty or a positive integer!",
        },
    },
    {
        Name  => 'Invalid RetryPeriodMax in ModuleConfig',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryPeriodMax      => '1a',
            },
        },
        Result => {
            Success      => 0,
            ErrorMessage => "Config param 'RetryPeriodMax' is not empty or a positive integer!",
        },
    },
    {
        Name  => 'Invalid RetryDateTime',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
            },
            PastExecutionData => {
                RetryDateTime => 'blahfasel',
            }
        },
        Result => {
            Success      => 0,
            ErrorMessage => 'RetryDateTime is invalid!',
        },
    },
    {
        Name  => 'Invalid InitialRequestDateTime',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
            },
            PastExecutionData => {
                InitialRequestDateTime => 'blahfasel',
            }
        },
        Result => {
            Success      => 0,
            ErrorMessage => 'InitialRequestDateTime is invalid!',
        },
    },

    {
        Name  => 'Retry functionality disabled',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 0,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
            },
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 0,
                InitialRequestDateTime    => $CurrentDateTimeString,
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 0,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule => 0,
            },
        },
    },
    {
        Name  => 'Maximum retry count reached',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryCountMax       => 99,
                RetryPeriodMax      => 86401,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -86400 ),
                RetryCount             => 99,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 0,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -86400 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 99,
                MaximumRetryCountReached  => 1,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule => 0,
            },
        },
    },
    {
        Name  => 'Maximum retry period reached',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 0,
                RetryIntervalFactor => 1,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -86400 ),
                RetryCount             => 99,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 0,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -86400 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 99,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 1,
            },
            ReScheduleData => {
                ReSchedule => 0,
            },
        },
    },
    {
        Name  => 'Linear interval',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 1,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                RetryInterval          => 60,
                RetryCount             => 1,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 60 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                    RetryCount             => 2,
                    RetryInterval          => 60,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 60 ),
                },
            },
        },
    },
    {
        Name  => 'Linear interval, cutting to maximum period',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 1,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -86341 ),
                RetryInterval          => 60,
                RetryCount             => 1,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -86341 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 59 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -86341 ),
                    RetryCount             => 2,
                    RetryInterval          => 60,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 59 ),
                },
            },
        },
    },
    {
        Name  => 'Linear interval, execution time overdue (e.g. Daemon was down)',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 1,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -300 ),
                RetryInterval          => 60,
                RetryCount             => 1,
                RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, -240 ),
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -300 ),
                CurrentRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -240 ),
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 1 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -300 ),
                    RetryCount             => 2,
                    RetryInterval          => 60,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 1 ),
                },
            },
        },
    },
    {
        Name  => 'Increasing interval (1.5 times)',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 1.5,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                RetryInterval          => 60,
                RetryCount             => 1,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 90 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                    RetryCount             => 2,
                    RetryInterval          => 90,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 90 ),
                },
            },
        },
    },
    {
        Name  => 'Increasing interval (2 times)',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 2,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                RetryInterval          => 60,
                RetryCount             => 1,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 120 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                    RetryCount             => 2,
                    RetryInterval          => 120,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 120 ),
                },
            },
        },
    },
    {
        Name  => 'Increasing interval (2 times), max reached',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 2,
                RetryIntervalMax    => 100,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                RetryInterval          => 60,
                RetryCount             => 1,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 100 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -60 ),
                    RetryCount             => 2,
                    RetryInterval          => 100,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 100 ),
                },
            },
        },
    },
    {
        Name  => 'Increasing interval with rounding',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 60,
                RetryIntervalFactor => 1.5,
                RetryCountMax       => 100,
                RetryPeriodMax      => 86400,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -61 ),
                RetryInterval          => 61,
                RetryCount             => 1,
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -61 ),
                CurrentRequestDateTime    => $CurrentDateTimeString,
                CurrentRetryCount         => 1,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 91 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -61 ),
                    RetryCount             => 2,
                    RetryInterval          => 91,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 91 ),
                },
            },
        },
    },
    {
        Name  => 'Test with complete config and retry information',
        Param => {
            ModuleConfig => {
                ScheduleRetry       => 1,
                RetryIntervalStart  => 65,
                RetryIntervalFactor => 1.5,
                RetryIntervalMax    => 120,
                RetryCountMax       => 4,
                RetryPeriodMax      => 300,
            },
            PastExecutionData => {
                InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -123 ),
                RetryInterval          => 97,
                RetryCount             => 2,
                RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, -3 ),
            }
        },
        Result => {
            Success => 1,
            Data    => {
                ReSchedule                => 1,
                InitialRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -123 ),
                CurrentRequestDateTime    => $TimeDiff->( $Self, $CurrentDateTime, -3 ),
                CurrentRetryCount         => 2,
                MaximumRetryCountReached  => 0,
                MaximumRetryPeriodReached => 0,
            },
            ReScheduleData => {
                ReSchedule        => 1,
                ExecutionTime     => $TimeDiff->( $Self, $CurrentDateTime, 117 ),
                PastExecutionData => {
                    InitialRequestDateTime => $TimeDiff->( $Self, $CurrentDateTime, -123 ),
                    RetryCount             => 3,
                    RetryInterval          => 120,
                    RetryDateTime          => $TimeDiff->( $Self, $CurrentDateTime, 117 ),
                },
            },
        },
    },

);

# test execution
for my $Test (@Test) {

    my $Result = $ErrorObject->Run( %{ $Test->{Param} } );

    $Self->IsDeeply(
        $Result,
        $Test->{Result},
        'RequestRetry - ' . $Test->{Name},
    );
}

1;
