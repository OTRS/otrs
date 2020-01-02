# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::TicketZoom::TicketInformation;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    my %Ticket    = %{ $Param{Ticket} };
    my %AclAction = %{ $Param{AclAction} };

    # Show created by name, if different then root user (ID=1).
    if ( $Ticket{CreateBy} > 1 ) {
        $Ticket{CreatedByUser} = $UserObject->UserName( UserID => $Ticket{CreateBy} );
        $LayoutObject->Block(
            Name => 'CreatedBy',
            Data => {%Ticket},
        );
    }

    if ( $Ticket{ArchiveFlag} eq 'y' ) {
        $LayoutObject->Block(
            Name => 'ArchiveFlag',
            Data => { %Ticket, %AclAction },
        );
    }

    # ticket type
    if ( $ConfigObject->Get('Ticket::Type') ) {

        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
            ID => $Ticket{TypeID},
        );

        $LayoutObject->Block(
            Name => 'Type',
            Data => {
                Valid => $Type{ValidID},
                %Ticket,
                %AclAction
            },
        );
    }

    # ticket service
    if ( $ConfigObject->Get('Ticket::Service') && $Ticket{Service} ) {
        $LayoutObject->Block(
            Name => 'Service',
            Data => { %Ticket, %AclAction },
        );
        if ( $Ticket{SLA} ) {
            $LayoutObject->Block(
                Name => 'SLA',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show first response time if needed
    if ( defined $Ticket{FirstResponseTime} ) {
        $Ticket{FirstResponseTimeHuman} = $LayoutObject->CustomerAge(
            Age                => $Ticket{FirstResponseTime},
            TimeShowAlwaysLong => 1,
            Space              => ' ',
        );
        $Ticket{FirstResponseTimeWorkingTime} = $LayoutObject->CustomerAge(
            Age                => $Ticket{FirstResponseTimeWorkingTime},
            TimeShowAlwaysLong => 1,
            Space              => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{FirstResponseTime} ) {
            $Ticket{FirstResponseTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'FirstResponseTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show update time if needed
    if ( defined $Ticket{UpdateTime} ) {
        $Ticket{UpdateTimeHuman} = $LayoutObject->CustomerAge(
            Age                => $Ticket{UpdateTime},
            TimeShowAlwaysLong => 1,
            Space              => ' ',
        );
        $Ticket{UpdateTimeWorkingTime} = $LayoutObject->CustomerAge(
            Age                => $Ticket{UpdateTimeWorkingTime},
            TimeShowAlwaysLong => 1,
            Space              => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{UpdateTime} ) {
            $Ticket{UpdateTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'UpdateTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show solution time if needed
    if ( defined $Ticket{SolutionTime} ) {
        $Ticket{SolutionTimeHuman} = $LayoutObject->CustomerAge(
            Age                => $Ticket{SolutionTime},
            TimeShowAlwaysLong => 1,
            Space              => ' ',
        );
        $Ticket{SolutionTimeWorkingTime} = $LayoutObject->CustomerAge(
            Age                => $Ticket{SolutionTimeWorkingTime},
            TimeShowAlwaysLong => 1,
            Space              => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{SolutionTime} ) {
            $Ticket{SolutionTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'SolutionTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show number of tickets with the same customer id if feature is active:
    if ( $ConfigObject->Get('Ticket::Frontend::ZoomCustomerTickets') ) {
        if ( $Ticket{CustomerID} ) {
            $Ticket{CustomerIDTickets} = $TicketObject->TicketSearch(
                CustomerID => $Ticket{CustomerID},
                Result     => 'COUNT',
                Permission => 'ro',
                UserID     => $Self->{UserID},
            );
            $LayoutObject->Block(
                Name => 'CustomerIDTickets',
                Data => \%Ticket,
            );
        }
    }

    # show total accounted time if feature is active:
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        $Ticket{TicketTimeUnits} = $TicketObject->TicketAccountedTimeGet(%Ticket);
        $LayoutObject->Block(
            Name => 'TotalAccountedTime',
            Data => \%Ticket,
        );
    }

    # show pending until, if set:
    if ( $Ticket{UntilTime} ) {
        if ( $Ticket{UntilTime} < -1 ) {
            $Ticket{PendingUntilClass} = 'Warning';
        }

        my $CurSysDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $Ticket{UntilTimeHuman} = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => ( $Ticket{UntilTime} + $CurSysDTObject->ToEpoch() ),
            },
        )->ToString();

        $Ticket{PendingUntil} .= $LayoutObject->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => ' '
        );
        $LayoutObject->Block(
            Name => 'PendingUntil',
            Data => \%Ticket,
        );
    }

    # Check if agent has permission to start chats with agents.
    my $EnableChat               = 1;
    my $ChatStartingAgentsGroup  = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatStartingAgents') || 'users';
    my $ChatReceivingAgentsGroup = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatReceivingAgents') || 'users';
    my $ChatStartingAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $ChatStartingAgentsGroup,
        Type      => 'rw',
    );

    if ( !$ConfigObject->Get('ChatEngine::Active') || !$ChatStartingAgentsGroupPermission ) {
        $EnableChat = 0;
    }
    if (
        $EnableChat
        && !$ConfigObject->Get('ChatEngine::ChatDirection::AgentToAgent')
        )
    {
        $EnableChat = 0;
    }

    my %OnlineData;
    if ($EnableChat) {
        my $VideoChatEnabled     = 0;
        my $VideoChatAgentsGroup = $ConfigObject->Get('ChatEngine::PermissionGroup::VideoChatAgents') || 'users';
        my $VideoChatAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
            UserID    => $Self->{UserID},
            GroupName => $VideoChatAgentsGroup,
            Type      => 'rw',
        );

        # Enable the video chat feature if system is entitled and agent is a member of configured group.
        if ( $ConfigObject->Get('ChatEngine::Active') && $VideoChatAgentsGroupPermission ) {
            if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::VideoChat', Silent => 1 ) ) {
                $VideoChatEnabled = $Kernel::OM->Get('Kernel::System::VideoChat')->IsEnabled();
            }
        }

        FIELD:
        for my $Field (qw(OwnerID ResponsibleID)) {
            next FIELD if !$Ticket{$Field};
            next FIELD if $Field eq 'ResponsibleID' && !$ConfigObject->Get('Ticket::Responsible');

            my $UserID = $Ticket{$Field};

            $OnlineData{$Field}->{EnableChat}         = $EnableChat;
            $OnlineData{$Field}->{AgentEnableChat}    = 0;
            $OnlineData{$Field}->{ChatAccess}         = 0;
            $OnlineData{$Field}->{VideoChatAvailable} = 0;
            $OnlineData{$Field}->{VideoChatSupport}   = 0;
            $OnlineData{$Field}->{VideoChatEnabled}   = $VideoChatEnabled;

            # Default status is offline.
            $OnlineData{$Field}->{UserState} = Translatable('Offline');
            $OnlineData{$Field}->{UserStateDescription}
                = $LayoutObject->{LanguageObject}->Translate('User is currently offline.');

            # We also need to check if the receiving agent has chat permissions.
            my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
                UserID => $UserID,
                Type   => 'rw',
            );

            my %UserGroupsReverse = reverse %UserGroups;
            $OnlineData{$Field}->{ChatAccess} = $UserGroupsReverse{$ChatReceivingAgentsGroup} ? 1 : 0;

            my %User = $UserObject->GetUserData(
                UserID => $UserID,
            );
            $OnlineData{$Field}->{VideoChatSupport} = $User{VideoChatHasWebRTC};

            # Check agent's availability.
            if ( $OnlineData{$Field}->{ChatAccess} ) {
                $OnlineData{$Field}->{AgentChatAvailability}
                    = $Kernel::OM->Get('Kernel::System::Chat')->AgentAvailabilityGet(
                    UserID   => $UserID,
                    External => 0,
                    );

                if ( $OnlineData{$Field}->{AgentChatAvailability} == 3 ) {
                    $OnlineData{$Field}->{UserState}       = Translatable('Active');
                    $OnlineData{$Field}->{AgentEnableChat} = 1;
                    $OnlineData{$Field}->{UserStateDescription}
                        = $LayoutObject->{LanguageObject}->Translate('User is currently active.');
                    $OnlineData{$Field}->{VideoChatAvailable} = 1;
                }
                elsif ( $OnlineData{$Field}->{AgentChatAvailability} == 2 ) {
                    $OnlineData{$Field}->{UserState}       = Translatable('Away');
                    $OnlineData{$Field}->{AgentEnableChat} = 1;
                    $OnlineData{$Field}->{UserStateDescription}
                        = $LayoutObject->{LanguageObject}->Translate('User was inactive for a while.');
                }
                elsif ( $OnlineData{$Field}->{AgentChatAvailability} == 1 ) {
                    $OnlineData{$Field}->{UserState} = Translatable('Unavailable');
                    $OnlineData{$Field}->{UserStateDescription}
                        = $LayoutObject->{LanguageObject}->Translate('User set their status to unavailable.');
                }
            }
        }
    }

    # owner info
    my %OwnerInfo = $UserObject->GetUserData(
        UserID => $Ticket{OwnerID},
    );
    $LayoutObject->Block(
        Name => 'Owner',
        Data => { %Ticket, %OwnerInfo, %AclAction, %{ $OnlineData{OwnerID} // {} } },
    );

    if ( $ConfigObject->Get('Ticket::Responsible') ) {

        # show responsible
        my %ResponsibleInfo = $UserObject->GetUserData(
            UserID => $Ticket{ResponsibleID} || 1,
        );

        $LayoutObject->Block(
            Name => 'Responsible',
            Data => { %Ticket, %ResponsibleInfo, %AclAction, %{ $OnlineData{ResponsibleID} // {} } },
        );
    }

    # set display options
    $Param{WidgetTitle} = Translatable('Ticket Information');
    $Param{Hook}        = $ConfigObject->Get('Ticket::Hook') || 'Ticket#';

    # check if ticket is normal or process ticket
    my $IsProcessTicket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCheckForProcessType(
        TicketID => $Ticket{TicketID}
    );

    # get zoom settings depending on ticket type
    $Self->{DisplaySettings} = $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom");

    # overwrite display options for process ticket
    if ($IsProcessTicket) {
        $Param{WidgetTitle} = $Self->{DisplaySettings}->{ProcessDisplay}->{WidgetTitle};

        # get the DF where the ProcessEntityID is stored
        my $ProcessEntityIDField = 'DynamicField_'
            . $ConfigObject->Get("Process::DynamicFieldProcessManagementProcessID");

        # get the DF where the AtivityEntityID is stored
        my $ActivityEntityIDField = 'DynamicField_'
            . $ConfigObject->Get("Process::DynamicFieldProcessManagementActivityID");

        my $ProcessData = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessGet(
            ProcessEntityID => $Ticket{$ProcessEntityIDField},
        );
        my $ActivityData = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity')->ActivityGet(
            Interface        => 'AgentInterface',
            ActivityEntityID => $Ticket{$ActivityEntityIDField},
        );

        # output process information in the sidebar
        $LayoutObject->Block(
            Name => 'ProcessData',
            Data => {
                Process  => $ProcessData->{Name}  || '',
                Activity => $ActivityData->{Name} || '',
            },
        );
    }

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")->{DynamicField} || {} },
        %{
            $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom")
                ->{ProcessWidgetDynamicField}
                || {}
        },
    };

    # get the dynamic fields for ticket object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );
    my $DynamicFieldBeckendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # to store dynamic fields to be displayed in the process widget and in the sidebar
    my (@FieldsSidebar);

    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        next DYNAMICFIELD if $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } eq '';

        # Check if this field is supposed to be hidden from the ticket information box.
        #   For example, it's displayed by a different mechanism (i.e. async widget).
        if (
            $DynamicFieldBeckendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsHiddenInTicketInformation',
            )
            )
        {
            next DYNAMICFIELD;
        }

        # use translation here to be able to reduce the character length in the template
        my $Label = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} );

        my $ValueStrg = $DynamicFieldBeckendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            LayoutObject       => $LayoutObject,
            ValueMaxChars      => $ConfigObject->
                Get('Ticket::Frontend::DynamicFieldsZoomMaxSizeSidebar')
                || 18,    # limit for sidebar display
        );

        if ( $Self->{DisplaySettings}->{DynamicField}->{ $DynamicFieldConfig->{Name} } ) {
            push @FieldsSidebar, {
                $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                Name                        => $DynamicFieldConfig->{Name},
                Title                       => $ValueStrg->{Title},
                Value                       => $ValueStrg->{Value},
                Label                       => $Label,
                Link                        => $ValueStrg->{Link},
                LinkPreview                 => $ValueStrg->{LinkPreview},

                # Include unique parameter with dynamic field name in case of collision with others.
                #   Please see bug#13362 for more information.
                "DynamicField_$DynamicFieldConfig->{Name}" => $ValueStrg->{Title},
            };
        }

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
            },
        );

        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
            Data => {
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    # output dynamic fields in the sidebar
    for my $Field (@FieldsSidebar) {

        $LayoutObject->Block(
            Name => 'TicketDynamicField',
            Data => {
                Label => $Field->{Label},
            },
        );

        if ( $Field->{Link} ) {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldLink',
                Data => {
                    $Field->{Name} => $Field->{Title},
                    %Ticket,

                    # alias for ticket title, Title will be overwritten
                    TicketTitle => $Ticket{Title},
                    Value       => $Field->{Value},
                    Title       => $Field->{Title},
                    Link        => $Field->{Link},
                    LinkPreview => $Field->{LinkPreview},

                    # Include unique parameter with dynamic field name in case of collision with others.
                    #   Please see bug#13362 for more information.
                    "DynamicField_$Field->{Name}" => $Field->{Title},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldPlain',
                Data => {
                    Value => $Field->{Value},
                    Title => $Field->{Title},
                },
            );
        }
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/TicketInformation',
        Data         => { %Param, %Ticket, %AclAction },
    );

    return {
        Output => $Output,
    };
}

1;
