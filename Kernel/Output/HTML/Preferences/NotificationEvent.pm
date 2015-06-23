# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Preferences::NotificationEvent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get all notification transports
    my $TransportConfigRaw = $Kernel::OM->Get('Kernel::Config')->Get('Notification::Transport') || {};

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # skip all non executable transports
    TRANSPORT:
    for my $TransportName ( sort keys %{$TransportConfigRaw} ) {

        # discard non available transports
        my $TransportLoaded = $MainObject->Require(
            $TransportConfigRaw->{$TransportName}->{Module},
            Silent => 1,
        );

        # skip transport
        next TRANSPORT if !$TransportLoaded;

        $Self->{TransportConfig}->{$TransportName} = $TransportConfigRaw->{$TransportName};
    }

    # get NotificationEvent object
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    # get all notifications
    my %NotificationListRaw = $NotificationEventObject->NotificationList();

    # get valid object
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    NOTIFICATION:
    for my $NotificationID ( sort keys %NotificationListRaw ) {

        # get notification details
        my %Notification = $NotificationEventObject->NotificationGet(
            ID => $NotificationID,
        );

        # discard invalid notifications
        my @ValidIDs = $ValidObject->ValidIDsGet();
        next NOTIFICATION if !grep { $Notification{ValidID} == $_ } @ValidIDs;

        # discard all non customizable notifications
        next NOTIFICATION if !$Notification{Data}->{VisibleForAgent};
        next NOTIFICATION if !$Notification{Data}->{VisibleForAgent}->[0];

        # remember notification data
        $Self->{NotificationList}->{$NotificationID} = \%Notification;
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my @Params;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # print table header
    for my $Name (
        sort { $Self->{TransportConfig}->{$a}->{Prio} <=> $Self->{TransportConfig}->{$b}->{Prio} }
        keys %{ $Self->{TransportConfig} }
        )
    {

        my $TransportConfig = $Self->{TransportConfig}->{$Name};

        $LayoutObject->Block(
            Name => 'HeaderRow',
            Data => {
                TransportName => $TransportConfig->{Name},
                TransportIcon => $TransportConfig->{Icon},
            },
        );
    }

    # output table body
    if ( !IsHashRefWithData( $Self->{NotificationList} ) ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {
                ColSpan => ( scalar keys %{ $Self->{TransportConfig} } ) + 1,
            },
        );
    }
    else {

        # get the user preferences (this needs to be done only once)
        my $UserNotificationTransport = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $Param{UserData}->{NotificationTransport},
        );

        NOTIFICATION:
        for my $NotificationID ( sort keys %{ $Self->{NotificationList} } ) {

            next NOTIFICATION if !$Self->{NotificationList}->{$NotificationID};

            my $Notification = $Self->{NotificationList}->{$NotificationID};

            # fill notification column block
            $LayoutObject->Block(
                Name => 'BodyRow',
                Data => {
                    NotificationName  => $Notification->{Name},
                    NotificationTitle => $Notification->{Data}->{VisibleForAgentTooltip}->[0] || '',
                },
            );

            TRANSPORT:
            for my $TransportName (
                sort { $Self->{TransportConfig}->{$a}->{Prio} <=> $Self->{TransportConfig}->{$b}->{Prio} }
                keys %{ $Self->{TransportConfig} }
                )
            {

                my $Identifier = "Notification-$NotificationID-$TransportName";

                my $TransportEnabled = grep { $_ eq $TransportName } @{ $Notification->{Data}->{Transports} };

                # get user preference for this transport and notification or fall back to
                #   notification default if there is no user preference
                my $Use = $UserNotificationTransport->{$Identifier} // $TransportEnabled;

                my $Checked = 'checked="checked"';
                if ( !$Use ) {
                    $Checked = '';
                }

                # fill each transport column
                $LayoutObject->Block(
                    Name => 'BodyTransportColumn',
                    Data => {},
                );
                if ($TransportEnabled) {
                    $LayoutObject->Block(
                        Name => 'BodyTransportColumnEnabled',
                        Data => {
                            NotificationName => $Notification->{Name},
                            TransportName    => $TransportName,
                            Identifier       => $Identifier,
                            Checked          => $Checked,
                        },
                    );
                }
            }
        }
    }

    # generate HTML
    my $Output = $LayoutObject->Output(
        TemplateFile => 'PreferencesNotificationEvent',
        Data         => \%Param,
    );

    # generate return structure for generic "Option" block in AgentPreferences
    push(
        @Params,
        {
            %Param,
            Block => 'RawHTML',
            HTML  => $Output,
            Name  => 'NotificationEventTransport',
        },
    );

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @IdentifierList;

    NOTIFICATION:
    for my $NotificationID ( sort keys %{ $Self->{NotificationList} } ) {

        next NOTIFICATION if !$Self->{NotificationList}->{$NotificationID};

        my $Notification = $Self->{NotificationList}->{$NotificationID};

        TRANSPORT:
        for my $TransportName ( sort keys %{ $Self->{TransportConfig} } ) {

            next TRANSPORT if !grep { $_ eq $TransportName } @{ $Notification->{Data}->{Transports} };

            push @IdentifierList, "Notification-$NotificationID-$TransportName";
        }
    }

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %UserNotificationTransport;
    for my $Identifier (@IdentifierList) {
        $UserNotificationTransport{$Identifier} = $ParamObject->GetParam( Param => $Identifier ) || 0;
    }

    my $Value = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => \%UserNotificationTransport,
    );

    # update user preferences
    if ( !$ConfigObject->Get('DemoSystem') ) {
        $UserObject->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'NotificationTransport',
            Value  => $Value // '',
        );
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
