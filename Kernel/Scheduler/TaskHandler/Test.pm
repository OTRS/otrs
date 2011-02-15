# --
# Kernel/Scheduler/TaskHandler/Test.pm - Scheduler task handler test backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.7 2011-02-15 19:39:02 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler::Test;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::Scheduler::TaskHandler::Test

=head1 SYNOPSIS

Scheduler Task Handler testing backend.

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
    use Kernel::Scheduler::TaskHandler::Test;

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
    my $OperationObject = Kernel::Scheduler::TaskHandler::Test->new(
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
    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );
        return;
    }

    # create tmp file
    if ( $Param{Data}->{File} ) {
        my $Content = 123;
        return if !$Self->{MainObject}->FileWrite(
            Location => $Param{Data}->{File},
            Content  => \$Content,
        );
    }

    if ( !$Param{Data}->{Success} ) {

        # log and exit succesfully
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'Test task execuded correctly with false!',
        );
        return;
    }

    # log and exit succesfully
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => 'Test task execuded correctly with true!',
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

$Revision: 1.7 $ $Date: 2011-02-15 19:39:02 $

=cut
