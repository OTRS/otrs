# --
# Kernel/System/Registration.pm - All Registration functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Registration;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CloudService',
    'Kernel::System::DB',
    'Kernel::System::Environment',
    'Kernel::System::Log',
    'Kernel::System::Scheduler::TaskManager',
    'Kernel::System::SupportDataCollector',
    'Kernel::System::SystemData',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::Registration - Registration lib

=head1 SYNOPSIS

All Registration functions.

The Registration API contains calls needed to communicate with the OTRS Group Portal.
The steps to register are:

 - Validate OTRS-ID (this results in a token)
 - Register the system - this requires the token.

This assures that all registered systems are registered against an existing OTRS-ID.

After registration a registration key is stored in the OTRS System. This key is,
along with system attributes such as OTRS version and Perl version, sent to OTRS in a
weekly update. This ensures the OTRS Group Portal contains up-to-date information on
the current state of the OTRS System.

In order to make sure that registration keys are not used on multiple systems -
something that can happen quite easily when copying a database to a different system -
every update will retrieve a new UpdateID from the OTRS Group Portal. This is used
when communicating the next update; if the received update would not contain the correct
UpdateID the Portal refuses the update and an updated registration is required.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');


=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{APIVersion} = 2;

    return $Self;
}

=item TokenGet()

Get a token needed for system registration.
To obtain this token, you need to pass a valid OTRS ID and password.

    my %Result = $RegistrationObject->TokenGet(
        OTRSID   => 'myname@example.com',
        Password => 'mysecretpass',
    );

    returns:

    %Result = (
        Success => 1,
        Token   => 'ase1zfa234asfd234afsd1243',
    );

    or, on failure:

    %Result = (
        Success => 0,
        Reason  => "Can't connect to server",
    );

    or

    %Result = (
        Success => 0,
        Reason  => "Username unknown or password incorrect.",
    );

=cut

sub TokenGet {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(OTRSID Password)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # initiate result hash
    my %Result = (
        Success => 0,
    );

    my $CloudService = 'SystemRegistration';
    my $Operation    = 'TokenGet';

    # prepare cloud service request
    my %RequestParams = (
        %Param,
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {},
                },
            ],
        },
    );

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Registration - Can't contact server",
        );
        $Result{Reason} = "Can't contact registration server. Please try again later.";

        return %Result;
    }
    elsif ( !$RequestResult->{Success} && $RequestResult->{ErrorMessage} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Registration - Request Failed ($RequestResult->{ErrorMessage})",
        );
        $Result{Reason} = "Can't contact registration server. Please try again later.";

        return %Result;
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Registration - No content received from server",
        );
        $Result{Reason} = "No content received from registration server. Please try again later.";

        return %Result;
    }
    elsif ( !$OperationResult->{Success} ) {
        $Result{Reason} = $OperationResult->{ErrorMessage} || "Can't get Token from sever";

        return %Result;
    }

    my $ResponseData = $OperationResult->{Data};

    # if auth is incorrect
    if ( !defined $ResponseData->{Auth} || $ResponseData->{Auth} ne 'ok' ) {
        $Result{Reason} = 'Username and password do not match. Please try again.';
        return %Result;
    }

    # check if token exists in data
    if ( !$ResponseData->{Token} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Registration - received no Token!",
        );
        $Result{Reason} = 'Problems processing server result. Please try again later.';
        return %Result;
    }

    # return success and token
    $Result{Token}   = $ResponseData->{Token};
    $Result{Success} = 1;

    return %Result;
}

=item Register()

Register the system;

    my $Success = $RegistrationObject->Register(
        Token       => '8a85ad4c-e5ff-4b91-a4b3-0b9ea8e2a3dc'
        OTRSID      => 'myname@example.com'
        Type        => 'production',
        Description => 'Main ticketing system',  # optional
    );

=cut

sub Register {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(Token OTRSID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SupportDataSending = $Param{SupportDataSending} || 'No';

    # load operating system info from environment object
    my %OSInfo = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();
    my %System = (
        PerlVersion => sprintf( "%vd", $^V ),
        OSType      => $OSInfo{OS},
        OSVersion   => $OSInfo{OSName},
        OTRSVersion => $ConfigObject->Get('Version'),
        FQDN        => $ConfigObject->Get('FQDN'),
        DatabaseVersion    => $Kernel::OM->Get('Kernel::System::DB')->Version(),
        SupportDataSending => $SupportDataSending,
    );

    my $SupportData;

    # send SupportData if sending is activated
    if ( $SupportDataSending eq 'Yes' ) {

        my %CollectResult = eval {
            $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
        };
        if ( !$CollectResult{Success} ) {
            my $ErrorMessage = $CollectResult{ErrorMessage} || $@ || 'unknown error';
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "SupportData could not be collected ($ErrorMessage)"
            );
        }

        $SupportData = $CollectResult{Result};
    }

    # load old registration data if we have this
    my %OldRegistration = $Self->RegistrationDataGet();

    my $CloudService = 'SystemRegistration';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => 'Register',
                    Data      => {
                        %System,
                        APIVersion  => $Self->{APIVersion},
                        State       => 'active',
                        OldUniqueID => $OldRegistration{UniqueID} || '',
                        OldAPIKey   => $OldRegistration{APIKey} || '',
                        Token       => $Param{Token},
                        OTRSID      => $Param{OTRSID},
                        Type        => $Param{Type},
                        Description => $Param{Description},
                    },
                },
            ],
        },
    );

    # if we have SupportData, call SupportDataAdd on the same request
    if ($SupportData) {
        push @{ $RequestParams{RequestData}->{$CloudService} }, {
            Operation => 'SupportDataAdd',
            Data      => {
                SupportData => $SupportData,
            },
        };
    }

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Registration - Can't contact registration server",
        );

        return;
    }
    elsif ( !$RequestResult->{Success} && $RequestResult->{ErrorMessage} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Registration - Request Failed ($RequestResult->{ErrorMessage})",
        );

        return;
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => 'Register',
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Registration - No content received from server",
        );

        return;
    }
    elsif ( !$OperationResult->{Success} ) {
        my $Reason = $OperationResult->{ErrorMessage} || $OperationResult->{Data}->{Reason} || '';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Registration - Can not register system " . $Reason,
        );

        return;
    }

    my $ResponseData = $OperationResult->{Data};

    # check if data exists
    for my $Key (qw(UniqueID APIKey LastUpdateID NextUpdate)) {
        if ( !$ResponseData->{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Registration - received no $Key!: ",
            );
            return;
        }
    }

    # log response, add data to system
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Registration - received UniqueID '$ResponseData->{UniqueID}'.",
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my %RegistrationData = (
        State              => 'registered',
        UniqueID           => $ResponseData->{UniqueID},
        APIKey             => $ResponseData->{APIKey},
        LastUpdateID       => $ResponseData->{LastUpdateID},
        LastUpdateTime     => $TimeObject->CurrentTimestamp(),
        Type               => $ResponseData->{Type} || $Param{Type},
        Description        => $ResponseData->{Description} || $Param{Description},
        SupportDataSending => $ResponseData->{SupportDataSending} || $SupportDataSending,
    );

    # only add keys if the system has never been registered before
    # otherwise we should store the original unique ID for future reference
    # so we can keep an overview of all previously registered unique IDs

    # get system data object
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    if ( !$OldRegistration{UniqueID} ) {

        for my $Key (
            qw(State UniqueID APIKey LastUpdateID LastUpdateTime Description SupportDataSending Type)
            )
        {
            $SystemDataObject->SystemDataAdd(
                Key    => 'Registration::' . $Key,
                Value  => $RegistrationData{$Key} || '',
                UserID => 1,
            );
        }
    }
    else {

        # store original UniqueID, but only if we get back a new one
        if ( $OldRegistration{UniqueID} ne $RegistrationData{UniqueID} ) {

            $SystemDataObject->SystemDataAdd(
                Key    => 'RegistrationUniqueIDs::' . $OldRegistration{UniqueID},
                Value  => $OldRegistration{UniqueID},
                UserID => 1,
            );
        }

        # update registration information
        for my $Key (
            qw(State UniqueID APIKey LastUpdateID LastUpdateTime Description SupportDataSending Type)
            )
        {
            if ( defined $OldRegistration{$Key} ) {

                $SystemDataObject->SystemDataUpdate(
                    Key    => 'Registration::' . $Key,
                    Value  => $RegistrationData{$Key} || '',
                    UserID => 1,
                );
            }
            else {

                $SystemDataObject->SystemDataAdd(
                    Key    => 'Registration::' . $Key,
                    Value  => $RegistrationData{$Key},
                    UserID => 1,
                );
            }
        }
    }

    # calculate due date for next update, fall back to 24h
    my $NextUpdateSeconds = int $ResponseData->{NextUpdate} || ( 3600 * 24 );
    my $DueTime = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $TimeObject->SystemTime() + $NextUpdateSeconds,
    );

    # get task object
    my $TaskObject = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager');

    # remove all existing RegistrationUpdate scheduler task
    my @TaskList = $TaskObject->TaskList();

    TASK:
    for my $Task (@TaskList) {

        next TASK if $Task->{Type} ne 'RegistrationUpdate';

        $TaskObject->TaskDelete( ID => $Task->{ID} );
    }

    # schedule update in scheduler
    # after first update the updates will reschedule itself
    my $Result = $TaskObject->TaskAdd(
        Type    => 'RegistrationUpdate',
        DueTime => $DueTime,
        Data    => {
            ReSchedule => 1,
        },
    );

    # check if Support Data could be added
    if ($SupportData) {
        my $OperationResult = $CloudServiceObject->OperationResultGet(
            RequestResult => $RequestResult,
            CloudService  => $CloudService,
            Operation     => 'SupportDataAdd',
        );

        if ( !IsHashRefWithData($OperationResult) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Registration - Can not add Support Data",
            );
        }
        elsif ( !$OperationResult->{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Registration - Can not add Support Data",
            );
        }
    }

    return 1;
}

=item RegistrationDataGet()

Get the registration data from the system.

    my %RegistrationInfo = $RegistrationObject->RegistrationDataGet(
        Extended => 1,              # optional, to also get basic system data
    );

=cut

sub RegistrationDataGet {
    my ( $Self, %Param ) = @_;

    my %RegistrationData =
        $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataGroupGet(
        Group  => 'Registration',
        UserID => 1,
        );

    # return empty hash if no UniqueID is found
    return () if !$RegistrationData{UniqueID};

    if ( $Param{Extended} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        $RegistrationData{SupportDataSending} //= 'No';
        $RegistrationData{APIVersion} = $Self->{APIVersion};

        # read data from environment object
        my %OSInfo = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();
        $RegistrationData{System} = {
            PerlVersion => sprintf( "%vd", $^V ),
            OSType      => $OSInfo{OS},
            OSVersion   => $OSInfo{OSName},
            OTRSVersion => $ConfigObject->Get('Version'),
            FQDN        => $ConfigObject->Get('FQDN'),
            DatabaseVersion => $Kernel::OM->Get('Kernel::System::DB')->Version(),
        };
    }

    return %RegistrationData;
}

=item RegistrationUpdateSend()

Register the system as Active.
This also updates any information on Database, OTRS Version and Perl version that
might have changed.

If you provide Type and Description, these will be sent to the registration server.

    my %Result = $RegistrationObject->RegistrationUpdateSend();

    my %Result = $RegistrationObject->RegistrationUpdateSend(
        Type        => 'test',
        Description => 'new test system',
    );

returns

    %Result = (
        Success      => 1,
        ReScheduleIn => 604800, # number of seconds for next update
    );

or

    %Result = (
        Success => 0,
        Reason  => 'Could not reach server',  # or other
    );

=cut

sub RegistrationUpdateSend {
    my ( $Self, %Param ) = @_;

    # get registration data
    my %RegistrationData = $Self->RegistrationDataGet();

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # read data from environment object
    my %OSInfo = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();
    my %System = (
        PerlVersion => sprintf( "%vd", $^V ),
        OSType      => $OSInfo{OS},
        OSVersion   => $OSInfo{OSName},
        OTRSVersion => $ConfigObject->Get('Version'),
        FQDN        => $ConfigObject->Get('FQDN'),
        DatabaseVersion => $Kernel::OM->Get('Kernel::System::DB')->Version(),
    );

    # add description and type if they are set
    KEY:
    for my $Key (qw(Type Description)) {
        next KEY if !defined $Param{$Key};
        $System{$Key} = $Param{$Key};
    }

    my $SupportDataSending
        = $Param{SupportDataSending} || $RegistrationData{SupportDataSending} || 'No';

    # add support data sending flag
    $System{SupportDataSending} = $SupportDataSending;

    my $SupportData;

    # send SupportData if sending is activated
    if ( $SupportDataSending eq 'Yes' ) {

        my %CollectResult = eval {
            $Kernel::OM->Get('Kernel::System::SupportDataCollector')->Collect();
        };
        if ( !$CollectResult{Success} ) {
            my $ErrorMessage = $CollectResult{ErrorMessage} || $@ || 'unknown error';
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "SupportData could not be collected ($ErrorMessage)"
            );
        }

        $SupportData = $CollectResult{Result};
    }

    my $CloudService = 'SystemRegistration';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => 'Update',
                    Data      => {
                        %System,
                        APIVersion   => $Self->{APIVersion},
                        State        => 'active',
                        LastUpdateID => $RegistrationData{LastUpdateID},
                    },
                },
            ],
        },
    );

    # if we have SupportData, call SupportDataAdd on the same request
    if ($SupportData) {
        push @{ $RequestParams{RequestData}->{$CloudService} }, {
            Operation => 'SupportDataAdd',
            Data      => {
                SupportData => $SupportData,
            },
        };
    }

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {

        my $Message = "RegistrationUpdate - Can't contact registration server";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => $Message
        );

        return {
            Success => 0,
            Reson   => $Message,
        };
    }
    elsif ( !$RequestResult->{Success} && $RequestResult->{ErrorMessage} ) {

        my $Message = "RegistrationUpdate - Request Failed ($RequestResult->{ErrorMessage})";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => $Message,
        );

        return (
            Success => 0,
            Reson   => $Message,
        );
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => 'Update',
    );

    if ( !IsHashRefWithData($OperationResult) ) {

        my $Message = "RegistrationUpdate - No content received from server";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return (
            Success => 0,
            Reson   => $Message,
        );
    }
    elsif ( !$OperationResult->{Success} ) {

        my $Reason = $OperationResult->{ErrorMessage} || $OperationResult->{Data}->{Reason} || '';
        my $Message = "RegistrationUpdate - Can not update system $Reason";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return (
            Success => 0,
            Reson   => $Message,
        );
    }

    my $ResponseData = $OperationResult->{Data};

    # check if data exists
    for my $Attribute (qw(UpdateID Type Description)) {

        if ( !defined $ResponseData->{$Attribute} ) {

            my $Message = "Received no '$Attribute'!";
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RegistrationUpdate - $Message!",
            );
            return (
                Success => 0,
                Reason  => $Message,
            );
        }
    }

    # log response, write data.
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "RegistrationUpdate - received UpdateID '$ResponseData->{UpdateID}'.",
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # gather and update provided data in SystemData table
    my %UpdateData = (
        LastUpdateID       => $ResponseData->{UpdateID},
        LastUpdateTime     => $TimeObject->CurrentTimestamp(),
        Type               => $ResponseData->{Type},
        Description        => $ResponseData->{Description},
        SupportDataSending => $ResponseData->{SupportDataSending} || $SupportDataSending,
    );

    # get system data object
    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    # if the registration server provided a new UniqueID and API key, use those.
    if ( $ResponseData->{UniqueID} && $ResponseData->{APIKey} ) {

        # add data to Update hash
        $UpdateData{UniqueID} = $ResponseData->{UniqueID};
        $UpdateData{APIKey}   = $ResponseData->{APIKey};

        # preserve old UniqueID
        $SystemDataObject->SystemDataAdd(
            Key    => 'RegistrationUniqueIDs::' . $RegistrationData{UniqueID},
            Value  => $RegistrationData{UniqueID},
            UserID => 1,
        );
    }

    for my $Key ( sort keys %UpdateData ) {

        if ( defined $RegistrationData{$Key} ) {
            $SystemDataObject->SystemDataUpdate(
                Key    => 'Registration::' . $Key,
                Value  => $UpdateData{$Key},
                UserID => 1,
            );
        }
        else {
            $SystemDataObject->SystemDataAdd(
                Key    => 'Registration::' . $Key,
                Value  => $UpdateData{$Key},
                UserID => 1,
            );
        }
    }

    # check if Support Data could be added
    if ($SupportData) {
        my $OperationResult = $CloudServiceObject->OperationResultGet(
            RequestResult => $RequestResult,
            CloudService  => $CloudService,
            Operation     => 'SupportDataAdd',
        );

        if ( !IsHashRefWithData($OperationResult) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RegistrationUpdate - Can not add Support Data",
            );
        }
        elsif ( !$OperationResult->{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "RegistrationUpdate - Can not add Support Data",
            );
        }
    }

    # if called from the scheduler process, to cleanup the redundant scheduler
    # registration update tasks
    if ( $Param{RegistrationUpdateTaskID} ) {

        # get task object
        my $TaskObject = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager');

        # remove all existing RegistrationUpdate scheduler task
        my @TaskList = $TaskObject->TaskList();

        # count the redundant task in the scheduler task table
        my @RegistrationUpdateTasks;

        TASK:
        for my $Task (@TaskList) {

            next TASK if $Task->{Type} ne 'RegistrationUpdate';

            next TASK if $Task->{ID} eq $Param{RegistrationUpdateTaskID};

            # add the redundant task to the registration update task list
            push @RegistrationUpdateTasks, $Task;
        }

        # delete all redundant registration update task, if some exists
        if (@RegistrationUpdateTasks) {

            for my $RegistrationUpdateTask (@RegistrationUpdateTasks) {
                $TaskObject->TaskDelete( ID => $RegistrationUpdateTask->{ID} );
            }
        }
    }

    return (
        Success => 1,
        ReScheduleIn => $ResponseData->{NextUpdate} // ( 3600 * 7 * 24 ),
    );
}

=item Deregister()

Deregister the system. Deregistering also stops any update jobs.

    my $Success = $RegistrationObject->Deregister(
        Token  => '8a85ad4c-e5ff-4b91-a4b3-0b9ea8e2a3dc',
        OTRSID => 'myname@example.com',
    );

    returns '1' for success or a description if there was no success

=cut

sub Deregister {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(Token OTRSID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %RegistrationInfo = $Self->RegistrationDataGet();

    my $CloudService = 'SystemRegistration';
    my $Operation    = 'Deregister';

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        APIVersion => $Self->{APIVersion},
                        OTRSID     => $Param{OTRSID},
                        Token      => $Param{Token},
                        APIKey     => $RegistrationInfo{APIKey},
                        UniqueID   => $RegistrationInfo{UniqueID},
                    },
                },
            ],
        },
    );

    # get cloud service object
    my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

    # dispatch the cloud service request
    my $RequestResult = $CloudServiceObject->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {

        my $Message = "Deregistration - Can't contact registration server";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => $Message,
        );

        return $Message;
    }
    elsif ( !$RequestResult->{Success} && $RequestResult->{ErrorMessage} ) {

        my $Message = "Deregistration - Request Failed ($RequestResult->{ErrorMessage})";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => $Message,
        );

        return $Message;
    }

    my $OperationResult = $CloudServiceObject->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    if ( !IsHashRefWithData($OperationResult) ) {

        my $Message = "Deregistration - No content received from server";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return $Message;
    }
    elsif ( !$OperationResult->{Success} ) {

        my $Reason = $OperationResult->{ErrorMessage} || $OperationResult->{Data}->{Reason} || '';
        my $Message = "Deregistration - Can not deregister system: $Reason";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return $Message;
    }

    my $ResponseData = $OperationResult->{Data};

    # log response, add data to system
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Registration - deregistered '$RegistrationInfo{UniqueID}'.",
    );

    $Kernel::OM->Get('Kernel::System::SystemData')->SystemDataUpdate(
        Key    => 'Registration::State',
        Value  => 'deregistered',
        UserID => 1,
    );

    # get task object
    my $TaskObject = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager');

    # remove RegistrationUpdate scheduler task
    my @TaskList = $TaskObject->TaskList();

    TASK:
    for my $Task (@TaskList) {

        next TASK if $Task->{Type} ne 'RegistrationUpdate';

        $TaskObject->TaskDelete( ID => $Task->{ID} );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
