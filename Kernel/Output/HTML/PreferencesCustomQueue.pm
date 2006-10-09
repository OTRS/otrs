# --
# Kernel/Output/HTML/PreferencesCustomQueue.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: PreferencesCustomQueue.pm,v 1.5 2006-10-09 15:42:14 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::PreferencesCustomQueue;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get env
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject QueueObject ConfigItem)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}

sub Param {
    my $Self = shift;
    my %Param = @_;
    my @Params = ();
    my %QueueData = ();
    my @CustomQueueIDs = ();
    if (!$Param{UserData}->{UserID}) {
        return ();
    }
    if ($Param{UserData}->{UserID}) {
        %QueueData = $Self->{QueueObject}->GetAllQueues(
            UserID => $Param{UserData}->{UserID},
            Type => 'ro',
        );
    }
    if ($Param{UserData}->{UserID}) {
        @CustomQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(UserID => $Param{UserData}->{UserID});
    }

    push (@Params, {
            %Param,
            Option => $Self->{LayoutObject}->AgentQueueListOption(
                Data => \%QueueData,
                Size => 10,
                Name => 'QueueID',
                SelectedIDRefArray => \@CustomQueueIDs,
                Multiple => 1,
                LanguageTranslation => 0,
                OnChangeSubmit => 0,
            ),
            Name => 'QueueID',
        },
    );
    return @Params;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # delete old custom queues
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM personal_queues WHERE user_id = $Param{UserData}->{UserID}",
    );
    # get ro groups of agent
    my %GroupMember = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserData}->{UserID},
        Type => 'ro',
        Result => 'HASH',
    );
    # add new custom queues
    foreach my $Key (keys %{$Param{GetParam}}) {
        my @Array = @{$Param{GetParam}->{$Key}};
        foreach my $ID (@Array) {
            # get group of queue
            my %Queue = $Self->{QueueObject}->QueueGet(ID => $ID);
            # check permissions
            if ($GroupMember{$Queue{GroupID}}) {
                # db quote
                $ID = $Self->{DBObject}->Quote($ID);
                $Self->{DBObject}->Do(
                    SQL => "INSERT INTO personal_queues (queue_id, user_id) " .
                        " VALUES ($ID, $Param{UserData}->{UserID})",
                );
            }
        }
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Error} || '';
}

sub Message {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Message} || '';
}

1;
