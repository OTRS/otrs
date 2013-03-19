# --
# Kernel/GenericInterface/Debugger.pm - GenericInterface data debugger interface
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Debugger;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsString IsStringWithData IsHashRefWithData);

use Kernel::System::GenericInterface::DebugLog;

use vars qw(@ISA);

=head1 NAME

Kernel::GenericInterface::Debugger

=head1 SYNOPSIS

GenericInterface data debugger interface.

For every communication process, one Kernel::GenericInterface::Debugger object
should be constructed and fed with data at the various stages
of the process. It will collect the data and write it into the database,
based on the configured debug level.

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
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,

        DebuggerConfig   => {
            DebugThreshold  => 'debug',
            TestMode        => 0,           # optional, in testing mode the data will not be written to the DB
            ...
        },

        WebserviceID        => 12,
        CommunicationType   => Requester, # Requester or Provider

        RemoteIP        => 192.168.1.1, # optional
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check for needed object
    for my $Needed (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # check DebuggerConfig - we need a hash ref with at least one entry
    if ( !IsHashRefWithData( $Param{DebuggerConfig} ) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need DebuggerConfig!' );
        return;
    }

    # DebugThreshold
    $Param{DebugThreshold} = $Param{DebuggerConfig}->{DebugThreshold} || 'error';

    # check for mandatory values
    for my $Needed (qw(WebserviceID CommunicationType DebugThreshold)) {
        if ( !IsStringWithData( $Param{$Needed} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    # check correct DebugThreshold
    if ( $Self->{DebugThreshold} !~ /^(debug|info|notice|error)/i ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'DebugThreshold is not allowed.' );
        return;
    }

    # check correct CommunicationType
    if ( lc $Self->{CommunicationType} !~ /^(provider|requester)/i ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'CommunicationType is not allowed.',
        );
        return;
    }

    # TestMode
    $Self->{TestMode} = $Param{DebuggerConfig}->{TestMode} || 0;

    # remote ip optional
    if ( defined $Param{RemoteIP} && !IsStringWithData( $Param{RemoteIP} ) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need RemoteIP address!' );
        return;
    }
    $Self->{RemoteIP} = $Param{RemoteIP};

    # comminication ID md5 (system time + random #)
    my $CurrentTime = $Self->{TimeObject}->SystemTime();
    my $MD5String   = $Self->{MainObject}->MD5sum(
        String => $CurrentTime . int( rand(1000000) ),
    );
    $Self->{CommunicationID} = $MD5String;

    # create DebugLog object
    $Self->{DebugLogObject} = Kernel::System::GenericInterface::DebugLog->new( %{$Self} );

    return $Self;
}

=item DebugLog()

add one piece of data to the logging of this communication process.

    $DebuggerObject->DebugLog(
        DebugLevel => 'debug',
        Summary    => 'Short summary, one line',
        Data       => $Data, # optional, $Data can be a string or a scalar reference
    );

Available debug levels are: 'debug', 'info', 'notice' and 'error'.
Any messages with 'error' priority will also be written to Kernel::System::Log.

=cut

sub DebugLog {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Summary} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Summary!' );
        return;
    }

    # if DebugLevel is not set DebugLevel from constructor is used
    $Param{DebugLevel} = $Param{DebugLevel} || $Self->{DebugLevel};

    # check correct DebugLevel
    if ( $Param{DebugLevel} !~ /^(debug|info|notice|error)/i ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'DebugLevel is not allowed.' );
        return;
    }
    my %DebugLevels = (
        debug  => 1,
        info   => 2,
        notice => 3,
        error  => 4
    );

    # create log message
    my $DataString = '';
    if ( IsHashRefWithData( $Param{Data} ) ) {
        $DataString = $Self->{MainObject}->Dump( $Param{Data} );
    }
    elsif ( IsStringWithData( $Param{Data} ) ) {
        $DataString = $Param{Data};
    }
    else {
        $DataString = 'No data provided';
    }

    if ( !$Self->{TestMode} ) {

        if ( $DebugLevels{ $Param{DebugLevel} } >= $DebugLevels{ $Self->{DebugThreshold} } ) {

            # call AddLog function
            $Self->{DebugLogObject}->LogAdd(
                CommunicationID   => $Self->{CommunicationID},
                CommunicationType => $Self->{CommunicationType},
                RemoteIP          => $Self->{RemoteIP},
                Summary           => $Param{Summary},
                WebserviceID      => $Self->{WebserviceID},
                DebugLevel        => $Param{DebugLevel},
                Data              => $DataString,
            );
        }
        return 1 if $Param{DebugLevel} ne 'error';
    }

    my $LogMessage = <<"EOF";
DebugLog $Param{DebugLevel}:
  Summary: $Param{Summary}
  Data   : $DataString.
EOF

    if ( $Param{DebugLevel} eq 'error' ) {
        $LogMessage =~ s/\n//g;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $LogMessage,
        );
        return 1 if !$Self->{TestMode};
        $LogMessage .= "\n";
    }

    print STDERR $LogMessage;

    return 1;
}

=item Debug()

passes data to DebugLog with debug level 'debug'

    $DebuggerObject->Debug(
        Summary => 'Short summary, one line',
        Data    => $Data, # optional, $Data can be a string or a scalar reference
    );

=cut

sub Debug {
    my ( $Self, %Param ) = @_;

    return if !$Self->DebugLog(
        %Param,
        DebugLevel => 'debug',
    );

    return 1;
}

=item Info()

passes data to DebugLog with debug level 'info'

    $DebuggerObject->Info(
        Summary => 'Short summary, one line',
        Data    => $Data, # optional, $Data can be a string or a scalar reference
    );

=cut

sub Info {
    my ( $Self, %Param ) = @_;

    return if !$Self->DebugLog(
        %Param,
        DebugLevel => 'info',
    );

    return 1;
}

=item Notice()

passes data to DebugLog with debug level 'notice'

    $DebuggerObject->Notice(
        Summary => 'Short summary, one line',
        Data    => $Data, # optional, $Data can be a string or a scalar reference
    );

=cut

sub Notice {
    my ( $Self, %Param ) = @_;

    return if !$Self->DebugLog(
        %Param,
        DebugLevel => 'notice',
    );

    return 1;
}

=item Error()

passes data to DebugLog with debug level 'error'
then returns data structure to be used as return value in calling function

    $DebuggerObject->Error(
        Summary => 'Short summary, one line',
        Data    => $Data, # optional, $Data can be a string or a scalar reference
    );

=cut

sub Error {
    my ( $Self, %Param ) = @_;

    return if !$Self->DebugLog(
        %Param,
        DebugLevel => 'error',
    );

    return {
        Success      => 0,
        ErrorMessage => $Param{Summary},
    };
}

=begin Internal:

=cut

=item DESTROY()

destructor, this will write the log entries to the database.

=cut

sub DESTROY {
    my $Self = shift;

    #TODO: implement storing of the debug messages

}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
