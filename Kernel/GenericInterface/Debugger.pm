# --
# Kernel/GenericInterface/Debugger.pm - GenericInterface data debugger interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Debugger.pm,v 1.3 2011-02-08 13:49:02 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Debugger;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
        DebugLevel  => 'debug',
        Title       => 'Short summary, one line',
        Data        => $Data,
    );

Available debug levels are: 'debug', 'info', 'notice' and 'error'.
Any messages with 'error' priority will also be written to Kernel::System::Log.

=cut

sub DebugLog {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DebugLevel Title Data)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    #TODO: implement

    print STDERR "DebugLog ($Param{DebugLevel}): Title '$Param{Title}', Data '$Param{Data}'\n";
}

sub DESTROY {
    my ($Self) = @_;

    #TODO: implement storing of the debug messages

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

$Revision: 1.3 $ $Date: 2011-02-08 13:49:02 $

=cut
