# --
# Kernel/GI/Debugger.pm - GenericInterface data debugger interface
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Debugger.pm,v 1.1 2011-02-04 09:37:35 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GI::Debugger;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::GI::Debugger

=head1 SYNOPSIS

GenericInterface data debugger interface.

For every communication process, one Kernel::GI::Debugger object
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
    use Kernel::GI::Debugger;

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
    my $DebuggerObject = Kernel::GI::Debugger->new(
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
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # TODO: implement

    return;
}

=item DebugLog()

add one piece of data to the logging of this communication process

    $DebuggerObject->DebugLog(
        DebugLevel  => 'debug',
        Title       => 'Short summary, one line',
        Data        => $Data,
    );

=cut

sub DebugLog {
    my ( $Self, %Param ) = @_;

    #TODO: implement
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

$Revision: 1.1 $ $Date: 2011-02-04 09:37:35 $

=cut
