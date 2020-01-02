# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::ErrorHandling::RequestRetry;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::GenericInterface::ErrorHandling::RequestRetry - Module do decide about rescheduling for failed requests

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not create it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ErrorObject = $Kernel::OM->Get('Kernel::GenericInterface::ErrorHandling');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

Decides if a non-successful request should be retried, based on the configuration.
Relevant module configuration variables are:
- ScheduleRetry         # enable or disable retry for request
- RetryIntervalStart    # time in seconds for first retry after initial request
- RetryIntervalFactor   # send further retries after the same interval as the first or in increasing intervals
- RetryIntervalMax      # maximum allowed interval between retries
- RetryCountMax         # maximum allowed number of retries
- RetryPeriodMax        # maximum time allowed for retries after initial request

    my $Result = $ErrorObject->Run(
        PastExecutionData => $PastExecutionDataStructure,   # optional
        ModuleConfig      => $ModuleConfig,
    );

    $Result = {
        Success       => 1,          # 0 or 1
        ErrorMessage  => '',         # if an error occurred
        Data          => { ... },    # result payload
        ReScheduleData => { ... },   # reschedule information
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Module config parameter validity check.
    if ( !IsHashRefWithData( $Param{ModuleConfig} ) ) {
        return $Self->_LogAndReturn( ErrorMessage => 'Got no ModuleConfig!' );
    }
    my $ModuleConfigCheck = $Self->_ModuleConfigCheck( %{ $Param{ModuleConfig} } );
    return $ModuleConfigCheck if !$ModuleConfigCheck->{Success};

    # Set basic information including possibly existing past execution data.
    my $RetryCount      = $Param{PastExecutionData}->{RetryCount} // 0;
    my $CurrentDateTime = $Kernel::OM->Create('Kernel::System::DateTime');

    # Get date-time of last (=this) request. If we are not in a retry, use current date-time.
    # This is used to properly calculate time based intervals.
    my $CurrentRequestDateTime;
    if ( IsStringWithData( $Param{PastExecutionData}->{RetryDateTime} ) ) {
        $CurrentRequestDateTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{PastExecutionData}->{RetryDateTime},
            },
        );
        return $Self->_LogAndReturn( ErrorMessage => 'RetryDateTime is invalid!' ) if !$CurrentRequestDateTime;
    }
    else {
        $CurrentRequestDateTime = $CurrentDateTime->Clone();
    }

    # Get date-time of first request. If we are not in a retry, use current date-time.
    my $InitialRequestDateTime;
    if ( IsStringWithData( $Param{PastExecutionData}->{InitialRequestDateTime} ) ) {
        $InitialRequestDateTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{PastExecutionData}->{InitialRequestDateTime},
            },
        );
        return $Self->_LogAndReturn( ErrorMessage => 'InitialRequestDateTime is invalid!' ) if !$InitialRequestDateTime;
    }
    else {
        $InitialRequestDateTime = $CurrentDateTime->Clone();
    }

    # Prepare default set of return data.
    my %ReturnData = (
        Success => 1,
        Data    => {
            ReSchedule                => 0,
            InitialRequestDateTime    => $InitialRequestDateTime->ToString(),
            CurrentRequestDateTime    => $CurrentRequestDateTime->ToString(),
            CurrentRetryCount         => $RetryCount,
            MaximumRetryCountReached  => 0,
            MaximumRetryPeriodReached => 0,
        },
        ReScheduleData => {
            ReSchedule => 0,
        },
    );

    # Retries are completely disabled.
    if ( !$Param{ModuleConfig}->{ScheduleRetry} ) {
        return \%ReturnData;
    }

    # No retry if maximum retry count has been reached.
    if (
        $Param{ModuleConfig}->{RetryCountMax}
        && $RetryCount >= $Param{ModuleConfig}->{RetryCountMax}
        )
    {
        $ReturnData{Data}->{MaximumRetryCountReached} = 1;
        return \%ReturnData;
    }

    # No retry if maximum retry period has been reached.
    my $DeltaInitialToCurrentRequest;
    if ( $Param{ModuleConfig}->{RetryPeriodMax} ) {
        $DeltaInitialToCurrentRequest = $InitialRequestDateTime->Delta( DateTimeObject => $CurrentRequestDateTime );
        if ( $DeltaInitialToCurrentRequest->{AbsoluteSeconds} >= $Param{ModuleConfig}->{RetryPeriodMax} ) {
            $ReturnData{Data}->{MaximumRetryPeriodReached} = 1;
            return \%ReturnData;
        }
    }

    # Calculate interval for next execution.
    my $RetryInterval;
    if ( IsStringWithData( $Param{PastExecutionData}->{RetryInterval} ) ) {
        $RetryInterval
            = int( $Param{PastExecutionData}->{RetryInterval} * $Param{ModuleConfig}->{RetryIntervalFactor} );
        if (
            IsStringWithData( $Param{ModuleConfig}->{RetryIntervalMax} )
            && $RetryInterval > $Param{ModuleConfig}->{RetryIntervalMax}
            )
        {
            $RetryInterval = $Param{ModuleConfig}->{RetryIntervalMax};
        }
    }
    else {
        $RetryInterval = $Param{ModuleConfig}->{RetryIntervalStart};
    }

    # Calculate next execution timestamp.
    my $TargetDateTime;
    if ( $Param{ModuleConfig}->{RetryPeriodMax} ) {
        if ( !$DeltaInitialToCurrentRequest ) {
            $DeltaInitialToCurrentRequest = $InitialRequestDateTime->Delta( DateTimeObject => $CurrentRequestDateTime );
        }
        if (
            $DeltaInitialToCurrentRequest->{AbsoluteSeconds} + $RetryInterval
            >= $Param{ModuleConfig}->{RetryPeriodMax}
            )
        {
            $TargetDateTime = $InitialRequestDateTime->Clone();
            $TargetDateTime->Add( Seconds => $Param{ModuleConfig}->{RetryPeriodMax} );
        }
    }
    if ( !$TargetDateTime ) {
        $TargetDateTime = $CurrentRequestDateTime->Clone();
        $TargetDateTime->Add( Seconds => $RetryInterval );
    }

    # Even after delayed executions, minimum wait time after requests is 1 second to prevent possible DoS.
    if ( $TargetDateTime->Compare( DateTimeObject => $CurrentDateTime ) != 1 ) {
        $TargetDateTime = $CurrentDateTime->Clone();
        $TargetDateTime->Add( Seconds => 1 );
    }

    # Schedule retry and set appropriate past execution data.
    $ReturnData{Data}->{ReSchedule} = 1;
    return {
        %ReturnData,
        ReScheduleData => {
            ReSchedule        => 1,
            ExecutionTime     => $TargetDateTime->ToString(),
            PastExecutionData => {
                InitialRequestDateTime => $InitialRequestDateTime->ToString(),
                RetryCount             => ++$RetryCount,
                RetryInterval          => $RetryInterval,
                RetryDateTime          => $TargetDateTime->ToString(),
            },
        },
    };
}

sub _ModuleConfigCheck {
    my ( $Self, %Param ) = @_;

    # Allowed Values:
    # ScheduleRetry       => [            0, 1 ],
    # RetryIntervalFactor => [               1, 1.5, 2 ],
    # RetryIntervalStart  => [            0, 1 .. 999999 ],
    # RetryIntervalMax    => [ undef, '', 0, 1 .. 999999 ],
    # RetryCountMax       => [ undef, '',    1 .. 999999 ],
    # RetryPeriodMax      => [ undef, '',    1 .. 999999 ],

    STRINGWITHDATA:
    for my $StringWithData (qw(ScheduleRetry RetryIntervalStart RetryIntervalFactor)) {
        next STRINGWITHDATA if IsStringWithData( $Param{$StringWithData} );

        return $Self->_LogAndReturn( ErrorMessage => "Config param '$StringWithData' is not a non-empty string!" );
    }

    STRING:
    for my $String (qw(RetryIntervalMax RetryCountMax RetryPeriodMax)) {

        # Set fall-back for optional parameters.
        $Param{$String} //= '';

        next STRING if IsString( $Param{$String} );

        return $Self->_LogAndReturn( ErrorMessage => "Config param '$String' is not a string!" );
    }

    if (
        $Param{ScheduleRetry} ne '0'
        && $Param{ScheduleRetry} ne '1'
        )
    {
        return $Self->_LogAndReturn( ErrorMessage => "Config param 'ScheduleRetry' is not '0' or '1'!" );
    }

    if (
        $Param{RetryIntervalFactor} ne '1'
        && $Param{RetryIntervalFactor} ne '1.5'
        && $Param{RetryIntervalFactor} ne '2'
        )
    {
        return $Self->_LogAndReturn( ErrorMessage => "Config param 'RetryIntervalFactor' is not '1', '1.5' or '2'!" );
    }

    my %ParamToMessage = (
        RetryIntervalStart => "Config param 'RetryIntervalStart' is not '0' or a positive integer!",
        RetryIntervalMax   => "Config param 'RetryIntervalMax' is not empty, '0' or a positive integer!",
        RetryCountMax      => "Config param 'RetryCountMax' is not empty or a positive integer!",
        RetryPeriodMax     => "Config param 'RetryPeriodMax' is not empty or a positive integer!",
    );
    INTEGER:
    for my $Integer (qw(RetryIntervalStart RetryIntervalMax RetryCountMax RetryPeriodMax)) {

        # RetryIntervalStart is not optional but string length >0 has been checked already.
        next INTEGER if $Param{$Integer} eq '';

        next INTEGER if IsPositiveInteger( $Param{$Integer} );

        # RetryIntervalStart and RetryIntervalMax may also contain '0'.
        if ( $Integer eq 'RetryIntervalStart' || $Integer eq 'RetryIntervalMax' ) {
            next INTEGER if $Param{$Integer} eq '0';
        }

        return $Self->_LogAndReturn( ErrorMessage => $ParamToMessage{$Integer} );
    }

    return {
        Success => 1,
    };
}

sub _LogAndReturn {
    my ( $Self, %Param ) = @_;

    my $ErrorMessage = $Param{ErrorMessage} || 'No error message provided!';

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $ErrorMessage,
    );

    return {
        Success      => 0,
        ErrorMessage => $ErrorMessage,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
