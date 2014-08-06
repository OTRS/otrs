# --
# Kernel/System/ProcessManagement/TransitionAction/TicketCreate.pm - A Module to create a ticket
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketCreate;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketCreate - A module to create a ticket

=head1 SYNOPSIS

All TicketArticleCreate functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketCreateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketCreate');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

    Run Data

    my $TicketArticleCreateResult = $TicketArticleCreateActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            # ticket required:
            Title         => 'Some Ticket Title',
            Queue         => 'Raw',              # or QueueID => 123,
            Lock          => 'unlock',
            Priority      => '3 normal',         # or PriorityID => 2,
            State         => 'new',              # or StateID => 5,
            CustomerID    => '123465',
            CustomerUser  => 'customer@example.com',
            OwnerID       => 123,

            # ticket optional:
            TN              => $TicketObject->TicketCreateNumber(), # optional
            Type            => 'Incident',            # or TypeID => 1, not required
            Service         => 'Service A',           # or ServiceID => 1, not required
            SLA             => 'SLA A',               # or SLAID => 1, not required
            ResponsibleID   => 123,                   # not required
            ArchiveFlag     => 'y',                   # (y|n) not required
            PendingTime     => '2011-12-23 23:05:00', # optional (for pending states)
            PendingTimeDiff => 123 ,                  # optional (for pending states)

            # article required:
            ArticleType      => 'note-internal',                        # note-external|phone|fax|sms|...
                                                                        #   excluding any email type
            SenderType       => 'agent',                                # agent|system|customer
            ContentType      => 'text/plain; charset=ISO-8859-15',      # or optional Charset & MimeType
            Subject          => 'some short description',               # required
            Body             => 'the message text',                     # required
            HistoryType      => 'OwnerUpdate',                          # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
            HistoryComment   => 'Some free text!',

            # article optional:
            From             => 'Some Agent <email@example.com>',       # not required but useful
            To               => 'Some Customer A <customer-a@example.com>', # not required but useful
            Cc               => 'Some Customer B <customer-b@example.com>', # not required but useful
            ReplyTo          => 'Some Customer B <customer-b@example.com>', # not required
            MessageID        => '<asdasdasd.123@example.com>',          # not required but useful
            InReplyTo        => '<asdasdasd.12@example.com>',           # not required but useful
            References       => '<asdasdasd.1@example.com> <asdasdasd.12@example.com>', # not required but useful
            NoAgentNotify    => 0,                                      # if you don't want to send agent notifications
            AutoResponseType => 'auto reply'                            # auto reject|auto follow up|auto reply/new ticket|auto remove

            ForceNotificationToUserID   => [ 1, 43, 56 ],               # if you want to force somebody
            ExcludeNotificationToUserID => [ 43,56 ],                   # if you want full exclude somebody from notifications,
                                                                        # will also be removed in To: line of article,
                                                                        # higher prio as ForceNotificationToUserID
            ExcludeMuteNotificationToUserID => [ 43,56 ],               # the same as ExcludeNotificationToUserID but only the
                                                                        # sending gets muted, agent will still shown in To:
                                                                        # line of article
            TimeUnit                        => 123

            # other:
            DynamicField_NameX => $Value,
            LinkAs => $LinkType,                                        # Normal, Parent, Child, etc. (respective original ticket)
            UserID => 123,                                              # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketCreateResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # check for missing or wrong params
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    # override UserID if specified as a parameter in the TA config
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # use ticket attributes if needed
    $Self->_ReplaceTicketAttributes(%Param);

    # convert scalar items into array references
    for my $Attribute (
        qw(ForceNotificationToUserID ExcludeNotificationToUserID
        ExcludeMuteNotificationToUserID
        )
        )
    {
        if ( IsStringWithData( $Param{Config}->{$Attribute} ) ) {
            $Param{Config}->{$Attribute} = $Self->_ConvertScalar2ArrayRef(
                Data => $Param{Config}->{$Attribute},
            );
        }
    }

    # collect ticket params
    my %TicketParam;
    for my $Attribute (
        qw( Title Queue QueueID Lock LockID Priority PriorityID State StateID
        CustomerID CustomerUser Owner OwnerID TN Type TypeID Service ServiceID SLA SLAID
        Responsible ResponsibleID ArchiveFlag
        )
        )
    {
        if ( defined $Param{Config}->{$Attribute} ) {
            $TicketParam{$Attribute} = $Param{Config}->{$Attribute}
        }
    }

    # get default values from system configuration
    for my $Attribute (qw(Queue State Lock Priority)) {

        if ( !$TicketParam{$Attribute} && !$TicketParam{ $Attribute . "ID" } ) {
            $TicketParam{$Attribute} = $Kernel::OM->Get('Kernel::Config')->Get("Process::Default$Attribute") || '';
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # create ticket
    my $TicketID = $TicketObject->TicketCreate(
        %TicketParam,
        UserID => $Param{UserID},
    );
    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't create New Ticket from Ticket: "
                . $Param{Ticket}->{TicketID} . '!',
        );
        return;
    }

    # get state information
    my %StateData;
    if ( $TicketParam{StateID} ) {
        %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            ID => $TicketParam{StateID},
        );
    }
    else {
        %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            Name => $TicketParam{State},
        );
    }

    # closed tickets get unlocked
    if ( $StateData{TypeName} =~ /^close/i ) {

        # set lock
        $TicketObject->TicketLockSet(
            TicketID => $TicketID,
            Lock     => 'unlock',
            UserID   => $Param{UserID},
        );
    }

    # set pending time
    elsif ( $StateData{TypeName} =~ /^pending/i ) {

        if ( $Param{Config}->{PendingTime} ) {

            # get time object
            my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

            # convert pending time to system time
            my $SystemTime = $TimeObject->TimeStamp2SystemTime(
                String => $Param{Config}->{PendingTime},
            );

            # convert it back again so we are sure the sting is correct
            my $TimeStamp = $TimeObject->SystemTime2TimeStamp(
                SystemTime => $SystemTime,
            );

            # set pending time
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Param{UserID},
                TicketID => $TicketID,
                String   => $TimeStamp,
            );
        }
        elsif ( $Param{Config}->{PendingTimeDiff} ) {

            # set pending time
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Param{UserID},
                TicketID => $TicketID,
                Diff     => $Param{Config}->{PendingTimeDiff},
            );
        }
    }

    # extract the article params
    my %ArticleParam;
    for my $Attribute (
        qw( ArticleType SenderType ContentType Subject Body HistoryType
        HistoryComment From To Cc ReplyTo MessageID InReplyTo References NoAgentNotify
        AutoResponseType ForceNotificationToUserID ExcludeNotificationToUserID
        ExcludeMuteNotificationToUserID
        )
        )
    {
        if ( defined $Param{Config}->{$Attribute} ) {
            $ArticleParam{$Attribute} = $Param{Config}->{$Attribute}
        }
    }

    # check ArticleType
    if ( $ArticleParam{ArticleType} =~ m{\A email }msxi ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "ArticleType $Param{Config}->{ArticleType} is not supported",
        );
        return;
    }

    # create article for the new ticket
    my $ArticleID = $TicketObject->ArticleCreate(
        %ArticleParam,
        TicketID => $TicketID,
        UserID   => $Param{UserID},
    );
    if ( !$ArticleID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't create Article on Ticket: $TicketID from Ticket: "
                . $Param{Ticket}->{TicketID} . '!',
        );
        return;
    }

    # set time units
    if ( $Param{Config}->{TimeUnit} ) {
        $TicketObject->TicketAccountTime(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            TimeUnit  => $Param{Config}->{TimeUnit},
            UserID    => $Param{UserID},
        );
    }

    # set dynamic fields for ticket and article

    # set a field filter (all valid dynamic fields have to have set to 1 like NameX => 1)
    my %FieldFilter;
    for my $Attribute ( sort keys %{ $Param{Config} } ) {
        if ( $Attribute =~ m{\A DynamicField_ ( [a-zA-Z0-9]+ ) \z}msx ) {
            $FieldFilter{$1} = 1;
        }
    }

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get the dynamic fields for ticket
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => \%FieldFilter,
    );

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $ObjectID = $TicketID;
        if ( $DynamicFieldConfig->{ObjectType} ne 'Ticket' ) {
            $ObjectID = $ArticleID;
        }

        # set the value
        my $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $ObjectID,
            Value              => $Param{Config}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            UserID             => $Param{UserID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't set DynamicField Value on $DynamicFieldConfig->{ObjectType}:"
                    . " $ObjectID from Ticket: "
                    . $Param{Ticket}->{TicketID} . '!',
            );
            return;
        }
    }

    # link ticket
    if ( $Param{Config}->{LinkAs} ) {

        # get link object
        my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

        # get config of all types
        my %ConfiguredTypes = $LinkObject->TypeList(
            UserID => 1,
        );

        my $SelectedType;
        my $SelectedDirection;

        TYPE:
        for my $Type ( sort keys %ConfiguredTypes ) {
            if (
                $Param{Config}->{LinkAs} ne $ConfiguredTypes{$Type}->{SourceName}
                && $Param{Config}->{LinkAs} ne $ConfiguredTypes{$Type}->{TargetName}
                )
            {
                next TYPE;
            }
            $SelectedType      = $Type;
            $SelectedDirection = 'Source';
            if ( $Param{Config}->{LinkAs} eq $ConfiguredTypes{$Type}->{TargetName} ) {
                $SelectedDirection = 'Target';
            }
            last TYPE;
        }

        if ( !$SelectedType ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "LinkAs $Param{LinkAs} is invalid!"
            );
            return;
        }

        my $SourceObjectID = $TicketID;
        my $TargetObjectID = $Param{Ticket}->{TicketID};
        if ( $SelectedDirection eq 'Target' ) {
            $SourceObjectID = $Param{Ticket}->{TicketID};
            $TargetObjectID = $TicketID;
        }

        my $Success = $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceObjectID,
            TargetObject => 'Ticket',
            TargetKey    => $TargetObjectID,
            Type         => $SelectedType,
            State        => 'Valid',
            UserID       => $Param{UserID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't Link Tickets $SourceObjectID with $TargetObjectID as $Param{LinkAs}!",
            );
            return;
        }
    }

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
