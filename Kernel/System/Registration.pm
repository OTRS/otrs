# --
# Kernel/System/Registration.pm - All Registration functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Registration;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::Environment;
use Kernel::System::JSON;
use Kernel::System::Scheduler::TaskManager;
use Kernel::System::SystemData;
use Kernel::System::WebUserAgent;

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

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Registration;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $RegistrationObject = Kernel::System::Registration->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject EncodeObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{EnvironmentObject} = Kernel::System::Environment->new( %{$Self} );
    $Self->{JSONObject}        = Kernel::System::JSON->new( %{$Self} );
    $Self->{SystemDataObject}  = Kernel::System::SystemData->new( %{$Self} );
    $Self->{TaskObject}        = Kernel::System::Scheduler::TaskManager->new( %{$Self} );

    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Registration',
        TTL  => 60 * 60 * 24 * 20,
    );

    $Self->{RegistrationURL} = 'https://cloud.otrs.com/otrs/public.pl';

    $Self->{APIVersion} = 1;

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # create webuseragent object
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject    => $Self->{LogObject},
        MainObject   => $Self->{MainObject},
        Timeout      => 10,
    );

    # get token
    my %Response = $WebUserAgentObject->Request(
        Type => 'POST',
        URL  => $Self->{RegistrationURL},
        Data => {
            Action     => 'PublicRegistration',
            Subaction  => 'GetToken',
            Subaction  => 'TokenGet',
            APIVersion => $Self->{APIVersion},
            OTRSID     => $Param{OTRSID},
            Password   => $Param{Password},
        },
    );

    # initiate result hash
    my %Result = (
        Success => 0,
    );

    # test if the web response was successful
    if ( $Response{Status} ne '200 OK' ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Registration - Can't contact server - $Response{Status}",
        );
        $Result{Reason} = "Can't contact registration server, please try again later.";
        return %Result;
    }

    # make sure we have content as a scalar ref
    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Registration - No content received from server",
        );
        $Result{Reason} = "No content received from registration server, please try again later.";
        return %Result;
    }

    # decode JSON data
    my $ResponseData = $Self->{JSONObject}->Decode(
        Data => ${ $Response{Content} },
    );
    if ( !$ResponseData || ref $ResponseData ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Registration - Can't decode JSON",
        );
        $Result{Reason} = "Problems processing server result, please try again later.";
        return %Result;
    }

    # if auth is incorrect
    if ( !defined $ResponseData->{Auth} || $ResponseData->{Auth} ne 'ok' ) {
        $Result{Reason} = "Username and password do not match.";
        return %Result;
    }

    # check if token exists in data
    if ( !$ResponseData->{Token} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Registration - received no Token!",
        );
        $Result{Reason} = "Problems processing server result, please try again later.";
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
        Token  => '8a85ad4c-e5ff-4b91-a4b3-0b9ea8e2a3dc'
        OTRSID => 'myname@example.com'
        Type   => 'production',
    );

=cut

sub Register {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(Token OTRSID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # create webuseragent object
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject    => $Self->{LogObject},
        MainObject   => $Self->{MainObject},
        Timeout      => 10,
    );

    # load operating system info from environment object
    my %OSInfo = $Self->{EnvironmentObject}->OSInfoGet();
    my %System = (
        PerlVersion => sprintf( "%vd", $^V ),
        OSType      => $OSInfo{OS},
        OSVersion   => $OSInfo{OSName},
        OTRSVersion => $Self->{ConfigObject}->Get('Version'),
        FQDN        => $Self->{ConfigObject}->Get('FQDN'),
        DatabaseVersion => $Self->{DBObject}->Version(),
    );

    # load old registration data if we have this
    my %OldRegistration = $Self->RegistrationDataGet();

    my %Response = $WebUserAgentObject->Request(
        Type => 'POST',
        URL  => $Self->{RegistrationURL},
        Data => {
            %System,
            Action      => 'PublicRegistration',
            Subaction   => 'Register',
            APIVersion  => $Self->{APIVersion},
            State       => 'active',
            OldUniqueID => $OldRegistration{UniqueID} || '',
            Token       => $Param{Token},
            OTRSID      => $Param{OTRSID},
            Type        => $Param{Type},
            Description => $Param{Description},
        },
    );

    # test if the web response was successful
    if ( $Response{Status} ne '200 OK' ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Registration - Can't contact server - $Response{Status}",
        );
        return;
    }

    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Registration - No content received from server",
        );
        return;
    }

    # decode JSON data
    my $ResponseData = $Self->{JSONObject}->Decode(
        Data => ${ $Response{Content} },
    );
    if ( !$ResponseData || ref $ResponseData ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Registration - Can't decode JSON",
        );
        return;
    }

    # check if data exists
    for my $Key (qw(UniqueID APIKey LastUpdateID NextUpdate)) {
        if ( !$ResponseData->{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Registration - received no $Key!: " . ${ $Response{Content} },
            );
            return;
        }
    }

    # log response, add data to system
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message  => "Registration - received UniqueID '$ResponseData->{UniqueID}'.",
    );

    my %RegistrationData = (
        State          => 'registered',
        UniqueID       => $ResponseData->{UniqueID},
        APIKey         => $ResponseData->{APIKey},
        LastUpdateID   => $ResponseData->{LastUpdateID},
        LastUpdateTime => $Self->{TimeObject}->CurrentTimestamp(),
    );

    # only add keys if the system has never been registered before
    # otherwise we should store the original unique ID for future reference
    # so we can keep an overview of all previously registered unique IDs

    if ( !$OldRegistration{UniqueID} ) {

        for my $Key (qw(State UniqueID APIKey LastUpdateID LastUpdateTime)) {
            $Self->{SystemDataObject}->SystemDataAdd(
                Key    => 'Registration::' . $Key,
                Value  => $RegistrationData{$Key} || '',
                UserID => 1,
            );
        }
    }
    else {

        # store original UniqueID, but only if we get back a new one
        if ( $OldRegistration{UniqueID} ne $RegistrationData{UniqueID} ) {

            $Self->{SystemDataObject}->SystemDataAdd(
                Key    => 'RegistrationUniqueIDs::' . $OldRegistration{UniqueID},
                Value  => $OldRegistration{UniqueID},
                UserID => 1,
            );
        }

        # update registration information
        for my $Key (qw(State UniqueID APIKey LastUpdateID LastUpdateTime)) {
            $Self->{SystemDataObject}->SystemDataUpdate(
                Key    => 'Registration::' . $Key,
                Value  => $RegistrationData{$Key} || '',
                UserID => 1,
            );
        }
    }

    # calculate due date for next update, fall back to 24h
    my $NextUpdateSeconds = int $ResponseData->{NextUpdate} || ( 3600 * 24 );
    my $DueTime = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime() + $NextUpdateSeconds,
    );

    # schedule update in scheduler
    # after first update the updates will reschedule itself
    my $Result = $Self->{TaskObject}->TaskAdd(
        Type    => 'RegistrationUpdate',
        DueTime => $DueTime,
        Data    => {
            ReSchedule => 1,
        },
    );

    return 1;
}

=item RegistrationDataGet()

Get the registration data from the system.

    my %RegistrationInfo = $RegistrationObject->RegistrationDataGet();

=cut

sub RegistrationDataGet {
    my ( $Self, %Param ) = @_;

    my %RegistrationData = $Self->{SystemDataObject}->SystemDataGroupGet(
        Group  => 'Registration',
        UserID => 1,
    );

    # return empty hash if no UniqueID is found
    return () if !$RegistrationData{UniqueID};

    return %RegistrationData;
}

=item RegistrationUpdateSend()

Register the system as Active.
This also updates any information on Database, OTRS Version and Perl version that
might have changed.

    my %Result = $RegistrationObject->RegistrationUpdateSend();

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

    # create webuseragent object
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject    => $Self->{LogObject},
        MainObject   => $Self->{MainObject},
        Timeout      => 10,
    );

    # read data from environment object
    my %OSInfo = $Self->{EnvironmentObject}->OSInfoGet();
    my %System = (
        PerlVersion => sprintf( "%vd", $^V ),
        OSType      => $OSInfo{OS},
        OSVersion   => $OSInfo{OSName},
        OTRSVersion => $Self->{ConfigObject}->Get('Version'),
        FQDN        => $Self->{ConfigObject}->Get('FQDN'),
        DatabaseVersion => $Self->{DBObject}->Version(),
    );

    # define result
    my %Result = (
        Success => 0,
    );

    my %Response = $WebUserAgentObject->Request(
        Type => 'POST',
        URL  => $Self->{RegistrationURL},
        Data => {
            %System,
            Action          => 'PublicRegistration',
            Subaction       => 'Update',
            APIVersion      => $Self->{APIVersion},
            State           => 'active',
            APIKey          => $RegistrationData{APIKey},
            LastUpdateID    => $RegistrationData{LastUpdateID},
            RegistrationKey => $RegistrationData{UniqueID},
        },
    );

    # test if the web response was successful
    if ( $Response{Status} ne '200 OK' ) {
        $Result{Reason} = "Can't connect to server - $Response{Status}";
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "RegistrationUpdate - $Result{Reason}",
        );

        return %Result;
    }

    # check if we have content as a scalar ref
    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Result{Reason} = "No content received from server";
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "RegistrationUpdate - $Result{Reason}",
        );
        return %Result;
    }

    # decode JSON data
    my $ResponseData = $Self->{JSONObject}->Decode(
        Data => ${ $Response{Content} },
    );
    if ( !$ResponseData || ref $ResponseData ne 'HASH' ) {
        $Result{Reason} = "Can't decode JSON: '" . ${ $Response{Content} } . "'!";
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "RegistrationUpdate - $Result{Reason}",
        );
        return %Result;
    }

    # check if data exists
    if ( !$ResponseData->{UpdateID} ) {
        $Result{Reason} = "Received no UpdateID: '" . ${ $Response{Content} } . "'!";
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "RegistrationUpdate - $Result{Reason}!",
        );
        return %Result;
    }

    # log response, write data.
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message  => "RegistrationUpdate - received UpdateID '$ResponseData->{UpdateID}'."
            . ${ $Response{Content} },
    );
    $Self->{SystemDataObject}->SystemDataUpdate(
        Key    => 'Registration::LastUpdateID',
        Value  => $ResponseData->{UpdateID},
        UserID => 1,
    );
    $Self->{SystemDataObject}->SystemDataUpdate(
        Key    => 'Registration::LastUpdateTime',
        Value  => $Self->{TimeObject}->CurrentTimestamp(),
        UserID => 1,
    );

    $Result{Success} = 1;
    $Result{ReScheduleIn} = $ResponseData->{NextUpdate} // ( 3600 * 7 * 24 );

    return %Result;
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # create webuseragent object
    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        DBObject     => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject    => $Self->{LogObject},
        MainObject   => $Self->{MainObject},
        Timeout      => 10,
    );

    my %RegistrationInfo = $Self->RegistrationDataGet();

    my %Response = $WebUserAgentObject->Request(
        Type => 'POST',
        URL  => $Self->{RegistrationURL},
        Data => {
            Action          => 'PublicRegistration',
            Subaction       => 'Deregister',
            APIVersion      => $Self->{APIVersion},
            OTRSID          => $Param{OTRSID},
            Token           => $Param{Token},
            APIKey          => $RegistrationInfo{APIKey},
            RegistrationKey => $RegistrationInfo{UniqueID},
        },
    );

    # test if the web response was successful
    if ( $Response{Status} ne '200 OK' ) {
        my $Result = "Can't contact server - $Response{Status}";
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Registration - $Result",
        );
        return $Result;
    }

    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        my $Result = 'No content received from server';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Registration - $Result",
        );
        return $Result;
    }

    # decode JSON data
    my $ResponseData = $Self->{JSONObject}->Decode(
        Data => ${ $Response{Content} },
    );
    if ( !$ResponseData || ref $ResponseData ne 'HASH' ) {
        my $Result = 'Can\'t decode JSON';
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Deregistration - $Result",
        );
        return $Result;
    }

    # check success
    if ( !$ResponseData->{Success} ) {

        my $Result = "Received no response";
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Deregistration $Result " . ${ $Response{Content} },
        );
        return $Result;
    }

    # log response, add data to system
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message  => "Registration - deregistered '$RegistrationInfo{UniqueID}'.",
    );

    $Self->{SystemDataObject}->SystemDataUpdate(
        Key    => 'Registration::State',
        Value  => 'deregistered',
        UserID => 1,
    );

    # remove RegistrationUpdate scheduler task
    my @TaskList = $Self->{TaskObject}->TaskList();

    TASK:
    for my $Task (@TaskList) {

        next TASK if $Task->{Type} ne 'RegistrationUpdate';

        $Self->{TaskObject}->TaskDelete( ID => $Task->{ID} );
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
