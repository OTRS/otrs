# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Event::Handler;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use Storable;

our @ObjectDependencies = (
    'Kernel::GenericInterface::Requester',
    'Kernel::System::Scheduler',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Log',
    'Kernel::System::Event',
    'Kernel::System::Main',
    'Kernel::Config',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::GenericInterface::Event::Handler - GenericInterface event handler

=head1 DESCRIPTION

This event handler intercepts all system events and fires connected GenericInterface
invokers.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $SchedulerObject  = $Kernel::OM->Get('Kernel::System::Scheduler');
    my $MainObject       = $Kernel::OM->Get('Kernel::System::Main');
    my $RequesterObject  = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
    my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');

    my %WebserviceList   = %{ $WebserviceObject->WebserviceList( Valid => 1 ) };
    my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList();

    # Loop over web services.
    WEBSERVICEID:
    for my $WebserviceID ( sort keys %WebserviceList ) {

        my $WebserviceData = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        next WEBSERVICEID if !IsHashRefWithData( $WebserviceData->{Config} );
        next WEBSERVICEID if !IsHashRefWithData( $WebserviceData->{Config}->{Requester} );
        next WEBSERVICEID if !IsHashRefWithData( $WebserviceData->{Config}->{Requester}->{Invoker} );

        # Check invokers of the web service, to see if some might be connected to this event.
        INVOKER:
        for my $Invoker ( sort keys %{ $WebserviceData->{Config}->{Requester}->{Invoker} } ) {

            my $InvokerConfig = $WebserviceData->{Config}->{Requester}->{Invoker}->{$Invoker};

            next INVOKER if ref $InvokerConfig->{Events} ne 'ARRAY';

            INVOKEREVENT:
            for my $InvokerEvent ( @{ $InvokerConfig->{Events} } ) {

                # Check if the invoker is connected to this event.
                next INVOKEREVENT if !IsHashRefWithData($InvokerEvent);
                next INVOKEREVENT if !IsStringWithData( $InvokerEvent->{Event} );
                next INVOKEREVENT if $InvokerEvent->{Event} ne $Param{Event};

                # Prepare event type.
                my $EventType;

                # Set the event type (event object like Article or Ticket) and event condition
                EVENTTYPE:
                for my $Type ( sort keys %RegisteredEvents ) {
                    my $EventFound = grep { $_ eq $InvokerEvent->{Event} } @{ $RegisteredEvents{$Type} || [] };

                    next EVENTTYPE if !$EventFound;

                    $EventType = $Type;
                    last EVENTTYPE;
                }

                if (
                    $EventType
                    && IsHashRefWithData( $InvokerEvent->{Condition} )
                    && IsHashRefWithData( $InvokerEvent->{Condition}->{Condition} )
                    )
                {

                    my $BackendObject = $Self->{EventTypeBackendObject}->{$EventType};

                    if ( !$BackendObject ) {

                        my $ObjectClass = "Kernel::GenericInterface::Event::ObjectType::$EventType";

                        my $Loaded = $MainObject->Require(
                            $ObjectClass,
                        );

                        if ( !$Loaded ) {
                            $LogObject->Log(
                                Priority => 'error',
                                Message =>
                                    "Could not load $ObjectClass, skipping condition checks for event $InvokerEvent->{Event}!",
                            );
                            next INVOKEREVENT;
                        }

                        $BackendObject = $Kernel::OM->Get($ObjectClass);

                        $Self->{EventTypeBackendObject}->{$EventType} = $BackendObject;
                    }

                    # Get object data
                    my %EventData = $BackendObject->DataGet(
                        Data => $Param{Data},
                    );

                    if ( IsHashRefWithData( \%EventData ) ) {
                        my %ObjectData;

                        $Self->_SerializeConfig(
                            Data  => \%EventData,
                            SHash => \%ObjectData,
                        );

                        # Check if the event condition matches.
                        my $ConditionCheckResult = $Self->_ConditionCheck(
                            %{ $InvokerEvent->{Condition} },
                            Data => \%ObjectData,
                        );

                        next INVOKEREVENT if !$ConditionCheckResult;
                    }
                }

                # create scheduler task for asynchronous tasks
                if ( $InvokerEvent->{Asynchronous} ) {

                    my $Success = $SchedulerObject->TaskAdd(
                        Type     => 'GenericInterface',
                        Name     => 'Invoker-' . $Invoker,
                        Attempts => 10,
                        Data     => {
                            WebserviceID => $WebserviceID,
                            Invoker      => $Invoker,
                            Data         => $Param{Data},
                        },
                    );
                    if ( !$Success ) {
                        $LogObject->Log(
                            Priority => 'error',
                            Message  => 'Could not schedule task for Invoker-' . $Invoker,
                        );
                    }

                    next INVOKEREVENT;

                }

                # execute synchronous tasks directly
                my $Result = $RequesterObject->Run(
                    WebserviceID => $WebserviceID,
                    Invoker      => $Invoker,
                    Data         => Storable::dclone( $Param{Data} ),
                );
                next INVOKEREVENT if $Result->{Success};

                # check if rescheduling is requested on errors
                next INVOKEREVENT if !IsHashRefWithData( $Result->{Data} );
                next INVOKEREVENT if !$Result->{Data}->{ReSchedule};

                # Use the execution time from the return data
                my $ExecutionTime = $Result->{Data}->{ExecutionTime};
                my $ExecutionDateTime;

                # Check if execution time is valid.
                if ( IsStringWithData($ExecutionTime) ) {

                    $ExecutionDateTime = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $ExecutionTime,
                        },
                    );
                    if ( !$ExecutionDateTime ) {
                        my $WebServiceName = $WebserviceData->{Name} // 'N/A';
                        $LogObject->Log(
                            Priority => 'error',
                            Message =>
                                "WebService $WebServiceName, Invoker $Invoker returned invalid execution time $ExecutionTime. Falling back to default!",
                        );
                    }
                }

                # Set default execution time.
                if ( !$ExecutionTime || !$ExecutionDateTime ) {

                    # Get default time difference from config.
                    my $FutureTaskTimeDiff
                        = int( $ConfigObject->Get('Daemon::SchedulerGenericInterfaceTaskManager::FutureTaskTimeDiff') )
                        || 300;

                    $ExecutionDateTime = $Kernel::OM->Create('Kernel::System::DateTime');
                    $ExecutionDateTime->Add( Seconds => $FutureTaskTimeDiff );
                }

                # Create a new task that will be executed in the future.
                my $Success = $SchedulerObject->TaskAdd(
                    ExecutionTime => $ExecutionDateTime->ToString(),
                    Type          => 'GenericInterface',
                    Name          => 'Invoker-' . $Invoker,
                    Attempts      => 10,
                    Data          => {
                        Data              => $Param{Data},
                        PastExecutionData => $Result->{Data}->{PastExecutionData},
                        WebserviceID      => $WebserviceID,
                        Invoker           => $Invoker,
                    },
                );
                if ( !$Success ) {
                    $LogObject->Log(
                        Priority => 'error',
                        Message  => 'Could not re-schedule a task in future for Invoker ' . $Invoker,
                    );
                }
            }
        }
    }

    return 1;
}

=head2 _SerializeConfig()

    returns a serialized hash/array of a given hash/array

    my $ConditionCheck = $Self->_SerializeConfig(
        Data => \%OldHash,
        SHash => \%NewHash,
    );

    Modifies NewHash (SHash):

    my %OldHash = (
        Config => {
            A => 1,
            B => 2,
            C => 3,
        },
        Config2 => 1
    );

    my %NewHash = (
        Config_A => 1,
        Config_B => 1,
        Config_C => 1,
        Config2  => 1,
    );

=cut

sub _SerializeConfig {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data SHash)) {
        if ( !$Param{$Needed} ) {
            print "Got no $Needed!\n";
            return;
        }
    }

    my @ConfigContainer;
    my $DataType = 'Hash';

    if ( IsHashRefWithData( $Param{Data} ) ) {
        @ConfigContainer = sort keys %{ $Param{Data} };
    }
    else {
        @ConfigContainer = @{ $Param{Data} };
        $DataType        = 'Array';
    }

    # Prepare prefix.
    my $Prefix = $Param{Prefix} || '';

    my $ArrayCount = 0;

    CONFIGITEM:
    for my $ConfigItem (@ConfigContainer) {

        next CONFIGITEM if !$ConfigItem;

        # Check if param data is a hash or an array ref.
        if ( $DataType eq 'Hash' ) {

            # We got a hash ref.
            if (
                IsHashRefWithData( $Param{Data}->{$ConfigItem} )
                || IsArrayRefWithData( $Param{Data}->{$ConfigItem} )
                )
            {
                $Self->_SerializeConfig(
                    Data   => $Param{Data}->{$ConfigItem},
                    SHash  => $Param{SHash},
                    Prefix => $Prefix . $ConfigItem . '_',
                );
            }
            else {

                $Prefix                  = $Prefix . $ConfigItem;
                $Param{SHash}->{$Prefix} = $Param{Data}->{$ConfigItem};
                $Prefix                  = $Param{Prefix} || '';
            }
        }

        # We got an array ref
        else {

            if ( IsHashRefWithData($ConfigItem) || IsArrayRefWithData($ConfigItem) ) {

                $Self->_SerializeConfig(
                    Data   => $ConfigItem,
                    SHash  => $Param{SHash},
                    Prefix => $Prefix . $ConfigItem . '_',
                );
            }
            else {

                $Prefix                  = $Prefix . $ArrayCount;
                $Param{SHash}->{$Prefix} = $ConfigItem;
                $Prefix                  = $Param{Prefix} || '';
            }

            $ArrayCount++;
        }
    }

    return 1;
}

=head2 _ConditionCheck()

    Checks if one or more conditions are true

    my $ConditionCheck = $Self->_ConditionCheck(
        ConditionLinking => 'and',
        Condition => {
            1 => {
                Type   => 'and',
                Fields => {
                    DynamicField_Make    => [ '2' ],
                    DynamicField_VWModel => {
                        Type  => 'String',
                        Match => 'Golf',
                    },
                    DynamicField_A => {
                        Type  => 'Hash',
                        Match => {
                            Value  => 1,
                        },
                    },
                    DynamicField_B => {
                        Type  => 'Regexp',
                        Match => qr{ [\n\r\f] }xms
                    },
                    DynamicField_C => {
                        Type  => 'Module',
                        Match =>
                            'Kernel::GenericInterface::Event::Validation::MyModule',
                    },
                    Queue =>  {
                        Type  => 'Array',
                        Match => [ 'Raw' ],
                    },
                    # ...
                },
            },
            # ...
        },
        Data => {
            Queue         => 'Raw',
            DynamicField1 => 'Value',
            Subject       => 'Testsubject',
            # ...
        },
    );

    Returns:

    $CheckResult = 1;   # 1 = process with Scheduler or Requester
                        # 0 = stop processing

=cut

sub _ConditionCheck {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
    for my $Needed (qw(Condition Data)) {
        if ( !defined $Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # Check if we have Data to check against Condition.
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );

        return;
    }

    # Check if we have Condition to check against Data.
    if ( !IsHashRefWithData( $Param{Condition} ) ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Condition has no values!",
        );

        return;
    }

    my $ConditionLinking = $Param{ConditionLinking} || 'and';

    # If there is something else than 'and', 'or', 'xor' log defect condition configuration
    if (
        $ConditionLinking ne 'and'
        && $ConditionLinking ne 'or'
        && $ConditionLinking ne 'xor'
        )
    {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Invalid ConditionLinking!",
        );
        return;
    }
    my ( $ConditionSuccess, $ConditionFail ) = ( 0, 0 );

    # Loop through all submitted conditions
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    CONDITIONNAME:
    for my $ConditionName ( sort { $a cmp $b } keys %{ $Param{Condition} } ) {

        next CONDITIONNAME if $ConditionName eq 'ConditionLinking';

        # Get the condition data.
        my $ActualCondition = $Param{Condition}->{$ConditionName};

        # Check if we have Fields in our Condition
        if ( !IsHashRefWithData( $ActualCondition->{Fields} ) )
        {
            $LogObject->Log(
                Priority => 'error',
                Message  => "No Fields in Condition->$ConditionName found!",
            );
            return;
        }

        # If we don't have a Condition->$Condition->Type, set it to 'and' by default
        my $CondType = $ActualCondition->{Type} || 'and';

        # If there is something else than 'and', 'or', 'xor' log defect condition configuration
        if ( $CondType ne 'and' && $CondType ne 'or' && $CondType ne 'xor' ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Invalid Condition->$ConditionName->Type!",
            );
            return;
        }

        my ( $FieldSuccess, $FieldFail ) = ( 0, 0 );

        FIELDLNAME:
        for my $FieldName ( sort keys %{ $ActualCondition->{Fields} } ) {

            # If we have just a String transform it into string check condition.
            if ( ref $ActualCondition->{Fields}->{$FieldName} eq '' ) {
                $ActualCondition->{Fields}->{$FieldName} = {
                    Type  => 'String',
                    Match => $ActualCondition->{Fields}->{$FieldName},
                };
            }

            # If we have an Array ref in "Fields" we deal with just values
            #   -> transform it into a { Type => 'Array', Match => [1,2,3,4] } structure
            #   to unify testing later on.
            if ( ref $ActualCondition->{Fields}->{$FieldName} eq 'ARRAY' ) {
                $ActualCondition->{Fields}->{$FieldName} = {
                    Type  => 'Array',
                    Match => $ActualCondition->{Fields}->{$FieldName},
                };
            }

            # If we don't have a Condition->$ConditionName->Fields->Field->Type
            #   set it to 'String' by default.
            my $FieldType = $ActualCondition->{Fields}->{$FieldName}->{Type} || 'String';

            # If there is something else than 'String', 'Regexp', 'Hash', 'Array', 'Module' log
            #   defect config.
            if (
                $FieldType ne 'String'
                && $FieldType ne 'Hash'
                && $FieldType ne 'Array'
                && $FieldType ne 'Regexp'
                && $FieldType ne 'Module'
                )
            {
                $LogObject->Log(
                    Priority => 'error',
                    Message  => "Invalid Condition->Type!",
                );
                return;
            }

            if ( $ActualCondition->{Fields}->{$FieldName}->{Type} eq 'String' ) {

                # If our Check contains anything else than a string we can't check,
                #   Special Condition: if Match contains '0' we can check
                if (
                    (
                        !$ActualCondition->{Fields}->{$FieldName}->{Match}
                        && $ActualCondition->{Fields}->{$FieldName}->{Match} ne '0'
                    )
                    || ref $ActualCondition->{Fields}->{$FieldName}->{Match}
                    )
                {
                    $LogObject->Log(
                        Priority => 'error',
                        Message =>
                            "Condition->$ConditionName->Fields->$FieldName Match must"
                            . " be a String if Type is set to String!",
                    );
                    return;
                }

                # Make sure the data string is here and it isn't a ref (array or whatsoever)
                #   then compare it to our Condition configuration.
                if (
                    defined $Param{Data}->{$FieldName}
                    && defined $ActualCondition->{Fields}->{$FieldName}->{Match}
                    && ( $Param{Data}->{$FieldName} || $Param{Data}->{$FieldName} eq '0' )
                    )
                {

                    my $Match;

                    # Check if field data is a string and compare directly.
                    if (
                        ref $Param{Data}->{$FieldName} eq ''
                        && $ActualCondition->{Fields}->{$FieldName}->{Match} eq $Param{Data}->{$FieldName}
                        )
                    {
                        $Match = 1;
                    }

                    # Otherwise check if field data is and array and compare each element until
                    #   one match.
                    elsif ( ref $Param{Data}->{$FieldName} eq 'ARRAY' ) {

                        ITEM:
                        for my $Item ( @{ $Param{Data}->{$FieldName} } ) {
                            if ( $ActualCondition->{Fields}->{$FieldName}->{Match} eq $Item ) {
                                $Match = 1;
                                last ITEM;
                            }
                        }
                    }

                    if ($Match) {
                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition to make this Condition valid.
                        return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                        next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';
                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions.
                        return if $ConditionLinking eq 'and' && $CondType eq 'and';

                        # Try next Condition if all Condition Fields have to be true.
                        next CONDITIONNAME if $CondType eq 'and';
                    }
                    next FIELDLNAME;
                }

                my @ArrayFields = grep { $_ =~ m{ \A \Q$FieldName\E _ \d+ \z }xms } keys %{ $Param{Data} };

                if ( @ArrayFields && defined $ActualCondition->{Fields}->{$FieldName}->{Match} ) {
                    ARRAYFIELD:
                    for my $ArrayField (@ArrayFields) {
                        next ARRAYFIELD if ref $Param{Data}->{$ArrayField} ne '';
                        if ( $Param{Data}->{$ArrayField} ne $ActualCondition->{Fields}->{$FieldName}->{Match} ) {
                            next ARRAYFIELD;
                        }

                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition to make this Condition valid.
                        return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                        next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';
                        next FIELDLNAME;
                    }
                }

                # No match = fail.
                $FieldFail++;

                # Failed check if we have all 'and' conditions
                return if $ConditionLinking eq 'and' && $CondType eq 'and';

                # Try next Condition if all Condition Fields have to be true
                next CONDITIONNAME if $CondType eq 'and';
                next FIELDLNAME;
            }
            elsif ( $ActualCondition->{Fields}->{$FieldName}->{Type} eq 'Array' ) {

                # 1. Go through each Condition->$ConditionName->Fields->$Field->Value (map).
                # 2. Assign the value to $CheckValue.
                # 3. Grep through $Data->{$Field} to find the "toCheck" value inside the Data->{$Field} Array
                # 4. Assign all found Values to @CheckResults.
                my $CheckValue;
                my @CheckResults =
                    map {
                    $CheckValue = $_;
                    grep { $CheckValue eq $_ } @{ $Param{Data}->{$FieldName} }
                    }
                    @{ $ActualCondition->{Fields}->{$FieldName}->{Match} };

                # If the found amount is the same as the "toCheck" amount we succeeded
                if (
                    scalar @CheckResults
                    == scalar @{ $ActualCondition->{Fields}->{$FieldName}->{Match} }
                    )
                {
                    $FieldSuccess++;

                    # Successful check if we just need one matching Condition to make this Condition valid.
                    return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                    next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';
                }
                else {
                    $FieldFail++;

                    # Failed check if we have all 'and' conditions.
                    return if $ConditionLinking eq 'and' && $CondType eq 'and';

                    # Try next Condition if all Condition Fields have to be true.
                    next CONDITIONNAME if $CondType eq 'and';
                }
                next FIELDLNAME;
            }
            elsif ( $ActualCondition->{Fields}->{$FieldName}->{Type} eq 'Hash' ) {

                # if our Check doesn't contain a hash.
                if ( ref $ActualCondition->{Fields}->{$FieldName}->{Match} ne 'HASH' ) {
                    $LogObject->Log(
                        Priority => 'error',
                        Message =>
                            "Condition->$ConditionName->Fields->$FieldName Match must"
                            . " be a Hash!",
                    );
                    return;
                }

                # If we have no data or Data isn't a hash, test failed.
                if (
                    !$Param{Data}->{$FieldName}
                    || ref $Param{Data}->{$FieldName} ne 'HASH'
                    )
                {
                    $FieldFail++;
                    next FIELDLNAME;
                }

                # Find all Data Hash values that equal to the Condition Match Values.
                my @CheckResults =
                    grep {
                    $Param{Data}->{$FieldName}->{$_} eq
                        $ActualCondition->{Fields}->{$FieldName}->{Match}->{$_}
                    }
                    keys %{ $ActualCondition->{Fields}->{$FieldName}->{Match} };

                # If the amount of Results equals the amount of Keys in our hash this part matched.
                if (
                    scalar @CheckResults
                    == scalar keys %{ $ActualCondition->{Fields}->{$FieldName}->{Match} }
                    )
                {

                    $FieldSuccess++;

                    # Successful check if we just need one matching Condition to make this condition valid.
                    return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                    next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';

                }
                else {
                    $FieldFail++;

                    # Failed check if we have all 'and' conditions.
                    return if $ConditionLinking eq 'and' && $CondType eq 'and';

                    # Try next Condition if all Condition Fields have to be true.
                    next CONDITIONNAME if $CondType eq 'and';
                }
                next FIELDLNAME;
            }
            elsif ( $ActualCondition->{Fields}->{$FieldName}->{Type} eq 'Regexp' )
            {

                # If our Check contains anything else then a string we can't check.
                if (
                    !$ActualCondition->{Fields}->{$FieldName}->{Match}
                    ||
                    (
                        ref $ActualCondition->{Fields}->{$FieldName}->{Match} ne 'Regexp'
                        && ref $ActualCondition->{Fields}->{$FieldName}->{Match} ne ''
                    )
                    )
                {
                    $LogObject->Log(
                        Priority => 'error',
                        Message =>
                            "Condition->$ConditionName->Fields->$FieldName Match must"
                            . " be a Regular expression if Type is set to Regexp!",
                    );
                    return;
                }

                # Precompile Regexp if is a string.
                if ( ref $ActualCondition->{Fields}->{$FieldName}->{Match} eq '' ) {
                    my $Match = $ActualCondition->{Fields}->{$FieldName}->{Match};

                    eval {
                        $ActualCondition->{Fields}->{$FieldName}->{Match} = qr{$Match};
                    };
                    if ($@) {
                        $LogObject->Log(
                            Priority => 'error',
                            Message  => $@,
                        );
                        return;
                    }
                }

                # Make sure there is data to compare.
                if ( $Param{Data}->{$FieldName} ) {

                    my $Match;

                    # Check if field data is a string and compare directly.
                    if (
                        ref $Param{Data}->{$FieldName} eq ''
                        && $Param{Data}->{$FieldName} =~ $ActualCondition->{Fields}->{$FieldName}->{Match}
                        )
                    {
                        $Match = 1;
                    }

                    # Otherwise check if field data is and array and compare each element until one match.
                    elsif ( ref $Param{Data}->{$FieldName} eq 'ARRAY' ) {

                        ITEM:
                        for my $Item ( @{ $Param{Data}->{$FieldName} } ) {
                            if ( $Item =~ $ActualCondition->{Fields}->{$FieldName}->{Match} ) {
                                $Match = 1;
                                last ITEM;
                            }
                        }
                    }

                    if ($Match) {
                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition to make this Transition valid.
                        return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                        next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';
                    }
                    else {
                        $FieldFail++;

                        # Failed check if we have all 'and' conditions.
                        return if $ConditionLinking eq 'and' && $CondType eq 'and';

                        # Try next Condition if all Condition Fields have to be true.
                        next CONDITIONNAME if $CondType eq 'and';
                    }
                    next FIELDLNAME;
                }

                my @ArrayFields = grep { $_ =~ m{ \A \Q$FieldName\E _ \d+ \z }xms } keys %{ $Param{Data} };

                if ( @ArrayFields && defined $ActualCondition->{Fields}->{$FieldName}->{Match} ) {
                    ARRAYFIELD:
                    for my $ArrayField (@ArrayFields) {
                        next ARRAYFIELD if ref $Param{Data}->{$ArrayField} ne '';
                        if ( $Param{Data}->{$ArrayField} !~ $ActualCondition->{Fields}->{$FieldName}->{Match} ) {
                            next ARRAYFIELD;
                        }

                        $FieldSuccess++;

                        # Successful check if we just need one matching Condition to make this Condition valid.
                        return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                        next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';
                        next FIELDLNAME;
                    }
                }

                # No match = fail.
                $FieldFail++;

                # Failed check if we have all 'and' conditions
                return if $ConditionLinking eq 'and' && $CondType eq 'and';

                # Try next Condition if all Condition Fields have to be true
                next CONDITIONNAME if $CondType eq 'and';
                next FIELDLNAME;
            }
            elsif ( $ActualCondition->{Fields}->{$FieldName}->{Type} eq 'Module' ) {

                # Load Validation Modules. Default location for validation modules:
                #   Kernel/GenericInterface/Event/Validation/
                if (
                    !$MainObject->Require(
                        $ActualCondition->{Fields}->{$FieldName}->{Match}
                    )
                    )
                {
                    $LogObject->Log(
                        Priority => 'error',
                        Message  => "Can't load "
                            . $ActualCondition->{Fields}->{$FieldName}->{Type}
                            . "Module for Condition->$ConditionName->Fields->$FieldName validation!",
                    );
                    return;
                }

                # Create new ValidateModuleObject.
                my $ValidateModuleObject = $Kernel::OM->Get(
                    $ActualCondition->{Fields}->{$FieldName}->{Match}
                );

                # Handle "Data" Param to ValidateModule's "Validate" subroutine.
                if ( $ValidateModuleObject->Validate( Data => $Param{Data} ) ) {
                    $FieldSuccess++;

                    # Successful check if we just need one matching Condition to make this Condition valid.
                    return 1 if $ConditionLinking eq 'or' && $CondType eq 'or';

                    next CONDITIONNAME if $ConditionLinking ne 'or' && $CondType eq 'or';
                }
                else {
                    $FieldFail++;

                    # Failed check if we have all 'and' conditions.
                    return if $ConditionLinking eq 'and' && $CondType eq 'and';

                    # Try next Condition if all Condition Fields have to be true.
                    next CONDITIONNAME if $CondType eq 'and';
                }
                next FIELDLNAME;
            }
        }

        # FIELDLNAME end.
        if ( $CondType eq 'and' ) {

            # If we had no failing check this condition matched.
            if ( !$FieldFail ) {

                # Successful check if we just need one matching Condition to make this Condition valid.
                return 1 if $ConditionLinking eq 'or';
                $ConditionSuccess++;
            }
            else {
                $ConditionFail++;

                # Failed check if we have all 'and' condition.s
                return if $ConditionLinking eq 'and';
            }
        }
        elsif ( $CondType eq 'or' )
        {

            # If we had at least one successful check, this condition matched.
            if ( $FieldSuccess > 0 ) {

                # Successful check if we just need one matching Condition to make this Condition valid.
                return 1 if $ConditionLinking eq 'or';
                $ConditionSuccess++;
            }
            else {
                $ConditionFail++;

                # Failed check if we have all 'and' conditions.
                return if $ConditionLinking eq 'and';
            }
        }
        elsif ( $CondType eq 'xor' )
        {

            # If we had exactly one successful check, this condition matched.
            if ( $FieldSuccess == 1 ) {

                # Successful check if we just need one matching Condition to make this Condition valid.
                return 1 if $ConditionLinking eq 'or';
                $ConditionSuccess++;
            }
            else {
                $ConditionFail++;
            }
        }
    }

    # CONDITIONNAME end.
    if ( $ConditionLinking eq 'and' ) {

        # If we had no failing conditions this Condition matched.
        return 1 if !$ConditionFail;
    }
    elsif ( $ConditionLinking eq 'or' )
    {

        # If we had at least one successful condition, this condition matched.
        return 1 if $ConditionSuccess > 0;
    }
    elsif ( $ConditionLinking eq 'xor' )
    {

        # If we had exactly one successful condition, this condition matched.
        return 1 if $ConditionSuccess == 1;
    }

    # If no condition matched till here, we failed.
    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
