# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Preferences::AppointmentNotificationEvent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get all notification transports
    my $TransportConfigRaw = $Kernel::OM->Get('Kernel::Config')->Get('AppointmentNotification::Transport') || {};

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

    my %NotificationList = $NotificationEventObject->NotificationList( Type => 'Appointment' );

    my $NotificationConfig
        = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::Admin::AdminAppointmentNotificationEvent');

    # get valid object
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    NOTIFICATION:
    for my $NotificationID ( sort keys %NotificationList ) {

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
            Data => $Param{UserData}->{AppointmentNotificationTransport},
        );

        NOTIFICATION:
        for my $NotificationID (
            sort { $Self->{NotificationList}->{$a}->{Name} cmp $Self->{NotificationList}->{$b}->{Name} }
            keys %{ $Self->{NotificationList} }
            )
        {

            next NOTIFICATION if !$Self->{NotificationList}->{$NotificationID};

            my $Notification = $Self->{NotificationList}->{$NotificationID};

            # fill notification column block
            $LayoutObject->Block(
                Name => 'BodyRow',
                Data => {
                    NotificationName  => $Notification->{Name},
                    NotificationTitle => $Notification->{Data}->{VisibleForAgentTooltip}->[0] || '',
                    VisibleForAgent   => $Notification->{Data}->{VisibleForAgent}->[0],
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

                my $AgentEnabledByDefault
                    = grep { $_ eq $TransportName } @{ $Notification->{Data}->{AgentEnabledByDefault} };

                # get user preference for this transport and notification or fall back to
                #   notification default if there is no user preference
                my $Use = $UserNotificationTransport->{$Identifier} // $AgentEnabledByDefault;

                my $Checked     = 'checked="checked"';
                my $HiddenValue = 1;
                if ( !$Use ) {
                    $Checked     = '';
                    $HiddenValue = 0;
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
                            HiddenValue      => $HiddenValue,
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
    my @MandatoryNotificationIDs;

    NOTIFICATION:
    for my $NotificationID ( sort keys %{ $Self->{NotificationList} } ) {

        next NOTIFICATION if !$Self->{NotificationList}->{$NotificationID};

        my $Notification          = $Self->{NotificationList}->{$NotificationID};
        my $NotificationMandatory = 0;
        if ( $Notification->{Data}->{VisibleForAgent} && $Notification->{Data}->{VisibleForAgent}->[0] == 2 ) {
            $NotificationMandatory = 1;
            push @MandatoryNotificationIDs, $NotificationID;
        }

        TRANSPORT:
        for my $TransportName ( sort keys %{ $Self->{TransportConfig} } ) {
            next TRANSPORT if !grep { $_ eq $TransportName } @{ $Notification->{Data}->{Transports} };
            push @IdentifierList, {
                Name           => "Notification-$NotificationID-$TransportName",
                NotificationID => $NotificationID,
                IsMandatory    => $NotificationMandatory,
            };
        }
    }

    my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    my %UserNotificationTransport;
    my %MandatoryFulfilled;
    for my $Identifier (@IdentifierList) {
        $UserNotificationTransport{ $Identifier->{Name} } = $ParamObject->GetParam( Param => $Identifier->{Name} ) || 0;

        # check if this is a mandatory notification and this transport is selected
        if ( $UserNotificationTransport{ $Identifier->{Name} } == 1 ) {
            $MandatoryFulfilled{ $Identifier->{NotificationID} } = 1;
        }
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # now check if there are notifications for which no transport has been selected
    for my $NotificationID (@MandatoryNotificationIDs) {
        if ( $MandatoryFulfilled{$NotificationID} != 1 ) {
            $Self->{Error} = $LanguageObject->Translate(
                "Please make sure you've chosen at least one transport method for mandatory notifications."
            );
            return;
        }
    }

    my $Value = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => \%UserNotificationTransport,
    );

    # update user preferences
    if ( !$ConfigObject->Get('DemoSystem') ) {
        $UserObject->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => 'AppointmentNotificationTransport',
            Value  => $Value // '',
        );
    }

    $Self->{Message} = Translatable('Preferences updated successfully!');

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
