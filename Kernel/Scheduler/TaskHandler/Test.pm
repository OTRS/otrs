# --
# Kernel/Scheduler/TaskHandler/Test.pm - Scheduler task handler test backend
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.8 2011-02-16 19:34:48 mg Exp $
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
$VERSION = qw($Revision: 1.8 $) [1];

=head1 NAME

Kernel::Scheduler::TaskHandler::Test - test backend of the TaskHandler for the Scheduler

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using L<Kernel::Scheduler::TaskHandler>->new();

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

returns

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

$Revision: 1.8 $ $Date: 2011-02-16 19:34:48 $

=cut
