# --
# Kernel/GenericInterface/Invoker/Test.pm - GenericInterface test data Invoker backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.9 2011-02-15 09:37:03 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Invoker::Test::Test;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsString IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

=head1 NAME

Kernel::GenericInterface::Invoker::Test::Test

=head1 SYNOPSIS

GenericInterface test Invoker backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Invoker::Test::Test;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
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
    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        EncodeObject => $EncodeObject,
    );
    my $InvokerObject = Kernel::GenericInterface::Invoker::Test::Test->new(
        ConfigObject   => $ConfigObject,
        LogObject      => $LogObject,
        DBObject       => $DBObject,
        MainObject     => $MainObject,
        TimeObject     => $TimeObject,
        EncodeObject   => $EncodeObject,
        DebuggerObject => $DebuggerObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    for my $Needed (qw(DebuggerObject MainObject TimeObject)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    # we need a TicketID
    if ( !IsStringWithData( $Param{Data}->{TicketID} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no TicketID' );
    }

    # generate TicketNumber
    my %ReturnData;
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $Sec   = sprintf "%02d", '00';
    $Min   = sprintf "%02d", $Min;
    $Hour  = sprintf "%02d", $Hour;
    $Day   = sprintf "%02d", $Day;
    $Month = sprintf "%02d", $Month;
    $ReturnData{TicketNumber} = "$Year$Month$Day$Hour$Min$Sec$Param{Data}->{TicketID}";

    # check Action
    if ( IsStringWithData( $Param{Data}->{Action} ) ) {
        $ReturnData{Action} = $Param{Data}->{Action} . 'Test';
    }

    # check request for system time
    if ( IsStringWithData( $Param{Data}->{GetSystemTime} ) && $Param{Data}->{GetSystemTime} ) {
        $ReturnData{SystemTime} = $Self->{TimeObject}->SystemTime();
    }

    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # if there was an error in the response, forward it
    if ( !$Param{ResponseSuccess} ) {
        if ( !IsStringWithData( $Param{ResponseErrorMessage} ) ) {
            return $Self->{DebuggerObject}->Error(
                Summary => 'Got response error, but no response error message!',
            );
        }
        return {
            Success      => 0,
            ErrorMessage => $Param{ResponseErrorMessage},
        };
    }

    # we need a TicketNumber
    if ( !IsStringWithData( $Param{Data}->{TicketNumber} ) ) {
        return $Self->{DebuggerObject}->Error( Summary => 'Got no TicketNumber!' );
    }

    # test TicketNumberValue
    if (
        $Param{Data}->{TicketNumber} !~ m{
            \A ( \d{4} ) ( \d{2} ) ( \d{2} ) ( \d{2} ) ( \d{2} ) ( \d{2} ) ( \d+ ) \z
        }xms
        )
    {
        $Self->{DebuggerObject}->Info(
            Summary => 'Got TicketNumber, but it is not in required format!',
        );
    }
    my ( $Year, $Month, $Day, $Hour, $Minute, $Second, $TicketID ) = ( $1, $2, $3, $4, $5, $6, $7 );
    my $SystemTime      = $Self->{TimeObject}->SystemTime();
    my $InputSystemTime = $Self->{TimeObject}->Date2SystemTime(
        Year   => $Year,
        Month  => $Month,
        Day    => $Day,
        Hour   => $Hour,
        Minute => $Minute,
        Second => $Second,
    );

    # prepare TicketID
    my %ReturnData = (
        TicketID => $TicketID,
    );

    # check Action
    if ( IsStringWithData( $Param{Data}->{Action} ) ) {
        if ( $Param{Data}->{Action} !~ m{ \A ( .*? ) Test \z }xms ) {
            return $Self->{DebuggerObject}->Error(
                Summary => 'Got Action but it is not in required format!',
            );
        }
        $ReturnData{Action} = $1;
    }

    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.9 $ $Date: 2011-02-15 09:37:03 $

=cut
