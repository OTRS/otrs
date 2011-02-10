# --
# Kernel/GenericInterface/Debugger.pm - GenericInterface data debugger interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Debugger.pm,v 1.6 2011-02-10 10:40:35 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Debugger;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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
            DebugLevel => 'debug',
            ...
        },

        WebserviceID    => 12,

        TestMode        => 0,       # optional, in testing mode the data will not be written to the DB
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    for my $Needed (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    for my $Needed (qw(DebuggerConfig WebserviceID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # TODO: implement

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

    for my $Needed (qw(DebugLevel Summary)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    if ( $Param{DebugLevel} eq 'error' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => $Param{Summary},
        );
    }

    #TODO: implement
    if ( ref $Param{Data} ) {
        my $Data = $Self->{MainObject}->Dump( $Param{Data} );
        print STDERR "DebugLog ($Param{DebugLevel}): Summary '$Param{Summary}', Data '$Data'\n";
    }
    elsif ( $Param{Data} ) {
        print STDERR
            "DebugLog ($Param{DebugLevel}): Summary '$Param{Summary}', Data '$Param{Data}'\n";
    }
    else {
        print STDERR "DebugLog ($Param{DebugLevel}): Summary '$Param{Summary}', Data '-'\n";
    }
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
    my ($Self) = @_;

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

=head1 VERSION

$Revision: 1.6 $ $Date: 2011-02-10 10:40:35 $

=cut
