# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::CustomQueue;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Queue',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID ConfigItem)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
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
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    if ( $Param{UserData}->{UserID} ) {
        %QueueData = $QueueObject->GetAllQueues(
            UserID => $Param{UserData}->{UserID},
            Type   => $Self->{ConfigItem}->{Permission} || 'ro',
        );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    if ( $ParamObject->GetArray( Param => 'QueueID' ) ) {
        @CustomQueueIDs = $ParamObject->GetArray( Param => 'QueueID' );
    }
    elsif ( $Param{UserData}->{UserID} && !defined $CustomQueueIDs[0] ) {
        @CustomQueueIDs = $QueueObject->GetAllCustomQueues(
            UserID => $Param{UserData}->{UserID}
        );
    }
    push(
        @Params,
        {
            %Param,
            Option => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->AgentQueueListOption(
                Data               => \%QueueData,
                Size               => 10,
                Name               => 'QueueID',
                SelectedIDRefArray => \@CustomQueueIDs,
                Multiple           => 1,
                Translation        => 0,
                OnChangeSubmit     => 0,
                OptionTitle        => 1,
            ),
            Name => 'QueueID',
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get DB object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete old custom queues
    $DBObject->Do(
        SQL  => 'DELETE FROM personal_queues WHERE user_id = ?',
        Bind => [ \$Param{UserData}->{UserID} ],
    );

    # get ro groups of agent
    my %GroupMember = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
        UserID => $Param{UserData}->{UserID},
        Type   => 'ro',
    );

    # add new custom queues
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    for my $Key ( sort keys %{ $Param{GetParam} } ) {
        my @Array = @{ $Param{GetParam}->{$Key} };
        for my $ID (@Array) {

            # get group of queue
            my %Queue = $QueueObject->QueueGet( ID => $ID );

            # check permissions
            if ( $GroupMember{ $Queue{GroupID} } ) {

                $DBObject->Do(
                    SQL => "
                        INSERT INTO personal_queues (queue_id, user_id)
                        VALUES (?, ?)",
                    Bind => [ \$ID, \$Param{UserData}->{UserID} ]
                );
            }
        }
    }

    my $CacheKey = 'GetAllCustomQueues::' . $Param{UserData}->{UserID};
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'Queue',
        Key  => $CacheKey,
    );

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
