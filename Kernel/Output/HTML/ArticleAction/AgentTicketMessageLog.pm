# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleAction::AgentTicketMessageLog;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::Log',
    'Kernel::System::Group',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub CheckAccess {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check basic conditions.
    if ( $Param{ChannelName} ne 'Email' ) {
        return;
    }

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{AdminCommunicationLog};

    # Check if module is registered.
    return if !$Config;

    # If no group or RO group is specified, always allow access.
    return 1 if !@{ $Config->{Group} || [] } && !@{ $Config->{GroupRo} || [] };

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # Check group access for frontend module.
    my $Permission;

    TYPE:
    for my $Type (qw(Group GroupRo)) {
        GROUP:
        for my $Group ( @{ $Config->{$Type} || [] } ) {
            $Permission = $GroupObject->PermissionCheck(
                UserID    => $Param{UserID},
                GroupName => $Group,
                Type      => 'rw',
            );
            last GROUP if $Permission;
        }
        last TYPE if $Permission;
    }

    return $Permission;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );

    my $Result = $CommunicationLogObject->ObjectLookupGet(
        TargetObjectID   => $Param{Article}->{ArticleID},
        TargetObjectType => 'Article',
    );

    return if !$Result || !%{$Result};

    my %CommunicationData = $CommunicationLogObject->CommunicationGetByObjectID(
        ObjectID => $Result->{ObjectID},
    );

    my $ObjectID        = $Result->{ObjectID};
    my $CommunicationID = $CommunicationData{CommunicationID};

    my %MenuItem = (
        ItemType    => 'Link',
        Description => Translatable('View message log details for this article'),
        Name        => Translatable('Message Log'),
        Link =>
            "Action=AdminCommunicationLog;Subaction=Zoom;CommunicationID=$CommunicationID;ObjectID=$ObjectID"
    );

    return ( \%MenuItem );
}

1;
