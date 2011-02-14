# --
# Kernel/Scheduler/TaskHandler/GenericInterface.pm - Scheduler task handler Generic Interface backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: GenericInterface.pm,v 1.3 2011-02-14 14:59:57 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler::GenericInterface;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::Scheduler::TaskHandler::GenericInterface

=head1 SYNOPSIS

Scheduler Task Handler Generic Interface backend.

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
    use Kernel::Scheduler::TaskHandler::GenericInterface;

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
    my $OperationObject = Kernel::Scheduler::TaskHandler::GenericInterface->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(MainObject ConfigObject LogObject DBObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

=item Run()

perform the selected Task

    my $Result = $TaskHandlerObject->Run(
        Data     => {                               # task data
            ...
        },
    );

    $Result = 1;                                    # 0 or 1

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref
    if ( $Param{Data} && ref $Param{Data} eq 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );
        return;
    }

    # log and exit succesfully
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => 'GenericInterface task execuded correctly!',
    );
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

=head1 VERSION

$Revision: 1.3 $ $Date: 2011-02-14 14:59:57 $

=cut
