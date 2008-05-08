# --
# Kernel/Output/HTML/PreferencesCustomQueue.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PreferencesCustomQueue.pm,v 1.12 2008-05-08 09:36:57 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::PreferencesCustomQueue;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject QueueObject ConfigItem))
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params    = ();
    my %QueueData = ();
    my @CustomQueueIDs;

    # check needed param, if no user id is given, do not show this box
    if ( !$Param{UserData}->{UserID} ) {
        return ();
    }
    if ( $Param{UserData}->{UserID} ) {
        %QueueData = $Self->{QueueObject}->GetAllQueues(
            UserID => $Param{UserData}->{UserID},
            Type => $Self->{ConfigItem}->{Permission} || 'ro',
        );
    }
    if ( $Self->{ParamObject}->GetArray( Param => 'QueueID' ) ) {
        @CustomQueueIDs = $Self->{ParamObject}->GetArray( Param => 'QueueID' );
    }
    elsif ( $Param{UserData}->{UserID} && !defined( $CustomQueueIDs[0] ) ) {
        @CustomQueueIDs
            = $Self->{QueueObject}->GetAllCustomQueues( UserID => $Param{UserData}->{UserID} );
    }
    push(
        @Params,
        {
            %Param,
            Option => $Self->{LayoutObject}->AgentQueueListOption(
                Data                => \%QueueData,
                Size                => 10,
                Name                => 'QueueID',
                SelectedIDRefArray  => \@CustomQueueIDs,
                Multiple            => 1,
                LanguageTranslation => 0,
                OnChangeSubmit      => 0,
            ),
            Name => 'QueueID',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # delete old custom queues
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM personal_queues WHERE user_id = $Param{UserData}->{UserID}",
    );

    # get ro groups of agent
    my %GroupMember = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserData}->{UserID},
        Type   => 'ro',
        Result => 'HASH',
    );

    # add new custom queues
    for my $Key ( keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for my $ID (@Array) {

            # get group of queue
            my %Queue = $Self->{QueueObject}->QueueGet( ID => $ID );

            # check permissions
            if ( $GroupMember{ $Queue{GroupID} } ) {

                # db quote
                $ID = $Self->{DBObject}->Quote($ID);
                $Self->{DBObject}->Do(
                    SQL => "INSERT INTO personal_queues (queue_id, user_id) "
                        . " VALUES ($ID, $Param{UserData}->{UserID})",
                );
            }
        }
    }
    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
