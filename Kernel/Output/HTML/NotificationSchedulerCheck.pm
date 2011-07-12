# --
# Kernel/Output/HTML/NotificationSchedulerCheck.pm
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: NotificationSchedulerCheck.pm,v 1.1 2011-07-12 21:14:15 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationSchedulerCheck;

use strict;
use warnings;
use Kernel::System::Group;
use Kernel::System::PID;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject MainObject EncodeObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{GroupObject} = Kernel::System::Group->new( %{$Self} );
    $Self->{PIDObject}   = Kernel::System::PID->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # try to get scheduler PID
    my %PID = $Self->{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # return if shceduler is running
    if (%PID) {
        return '';
    }

    # otherwise check if user needs to be notified
    # get current user groups
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'move_into',
        Result => 'HASH',
    );

    # reverse groups hash for easy lookup
    %Groups = reverse %Groups;

    # cucle trough all registered groups
    GROUP:
    for my $Group ( keys %{ $Param{Config}->{NotifyGroups} } ) {
        next GROUP if !$Param{Config}->{NotifyGroups}->{$Group};

        # check if registered groups match one of the user groups
        if ( $Groups{$Group} ) {

            # show error notfy, if scheduler is not running
            return $Self->{LayoutObject}->Notify(
                Priority  => 'Error',
                Link      => '$Env{"Baselink"}Action=AdminUser',
                LinkClass => 'StartScheduler',
                Data      => '$Text{"Scheduler is not running!."}',
            );
            last GROUP;
        }
    }

    # return if no group match
    return '';

}

1;
