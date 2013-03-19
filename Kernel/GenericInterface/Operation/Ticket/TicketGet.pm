# --
# Kernel/GenericInterface/Operation/Ticket/TicketGet.pm - GenericInterface Ticket Get operation backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketGet;

use strict;
use warnings;

use MIME::Base64;
use Kernel::System::Ticket;
use Kernel::GenericInterface::Operation::Common;
use Kernel::GenericInterface::Operation::Ticket::Common;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use vars qw(@ISA);

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketGet - GenericInterface Ticket Get Operation backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(DebuggerObject ConfigObject MainObject LogObject TimeObject DBObject EncodeObject WebserviceID)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # create additional objects
    $Self->{CommonObject} = Kernel::GenericInterface::Operation::Common->new( %{$Self} );
    $Self->{TicketCommonObject}
        = Kernel::GenericInterface::Operation::Ticket::Common->new( %{$Self} );
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    return $Self;
}

=item Run()

perform TicketGet Operation. This function is able to return
one or more ticket entries in one call.

    my $Result = $OperationObject->Run(
        Data => {
            UserLogin         => 'some agent login',                            # UserLogin or CustomerUserLogin or SessionID is
                                                                                #   required
            CustomerUserLogin => 'some customer login',
            SessionID         => 123,

            Password          => 'some password',                                       # if UserLogin or customerUserLogin is sent then
                                                                                #   Password is required
            TicketID          => '32,33',                                       # required, could be coma separated IDs or an Array
            DynamicFields     => 0,                                             # Optional, 0 as default. Indicate if Dynamic Fields
                                                                                # should be included or not on the ticket content.
            Extended          => 1,                                             # Optional, 0 as default
            AllArticles       => 1,                                             # Optional, 0 as default. Set as 1 will include articles
                                                                                # for tickets.
            ArticleSenderType => [ $ArticleSenderType1, $ArticleSenderType2 ],  # Optional, only requested article sender types
            ArticleOrder      => 'DESC',                                        # Optional, DESC,ASC - default is ASC
            ArticleLimit      => 5,                                             # Optional
            Attachments       => 1,                                             # Optional, 1 as default. If it's set with the value 1,
                                                                                # attachments for articles will be included on ticket data
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            Ticket => [
                {
                    TicketNumber       => '20101027000001',
                    Title              => 'some title',
                    TicketID           => 123,
                    State              => 'some state',
                    StateID            => 123,
                    StateType          => 'some state type',
                    Priority           => 'some priority',
                    PriorityID         => 123,
                    Lock               => 'lock',
                    LockID             => 123,
                    Queue              => 'some queue',
                    QueueID            => 123,
                    CustomerID         => 'customer_id_123',
                    CustomerUserID     => 'customer_user_id_123',
                    Owner              => 'some_owner_login',
                    OwnerID            => 123,
                    Type               => 'some ticket type',
                    TypeID             => 123,
                    SLA                => 'some sla',
                    SLAID              => 123,
                    Service            => 'some service',
                    ServiceID          => 123,
                    Responsible        => 'some_responsible_login',
                    ResponsibleID      => 123,
                    Age                => 3456,
                    Created            => '2010-10-27 20:15:00'
                    CreateTimeUnix     => '1231414141',
                    CreateBy           => 123,
                    Changed            => '2010-10-27 20:15:15',
                    ChangeBy           => 123,
                    ArchiveFlag        => 'y',

                    # If DynamicFields => 1 was passed, you'll get an entry like this for each dynamic field:
                    DynamicField_X     => 'value_x',

                    # (time stamps of expected escalations)
                    EscalationResponseTime           (unix time stamp of response time escalation)
                    EscalationUpdateTime             (unix time stamp of update time escalation)
                    EscalationSolutionTime           (unix time stamp of solution time escalation)

                    # (general escalation info of nearest escalation type)
                    EscalationDestinationIn          (escalation in e. g. 1h 4m)
                    EscalationDestinationTime        (date of escalation in unix time, e. g. 72193292)
                    EscalationDestinationDate        (date of escalation, e. g. "2009-02-14 18:00:00")
                    EscalationTimeWorkingTime        (seconds of working/service time till escalation, e. g. "1800")
                    EscalationTime                   (seconds total till escalation of nearest escalation time type - response, update or solution time, e. g. "3600")

                    # (detailed escalation info about first response, update and solution time)
                    FirstResponseTimeEscalation      (if true, ticket is escalated)
                    FirstResponseTimeNotification    (if true, notify - x% of escalation has reached)
                    FirstResponseTimeDestinationTime (date of escalation in unix time, e. g. 72193292)
                    FirstResponseTimeDestinationDate (date of escalation, e. g. "2009-02-14 18:00:00")
                    FirstResponseTimeWorkingTime     (seconds of working/service time till escalation, e. g. "1800")
                    FirstResponseTime                (seconds total till escalation, e. g. "3600")

                    UpdateTimeEscalation             (if true, ticket is escalated)
                    UpdateTimeNotification           (if true, notify - x% of escalation has reached)
                    UpdateTimeDestinationTime        (date of escalation in unix time, e. g. 72193292)
                    UpdateTimeDestinationDate        (date of escalation, e. g. "2009-02-14 18:00:00")
                    UpdateTimeWorkingTime            (seconds of working/service time till escalation, e. g. "1800")
                    UpdateTime                       (seconds total till escalation, e. g. "3600")

                    SolutionTimeEscalation           (if true, ticket is escalated)
                    SolutionTimeNotification         (if true, notify - x% of escalation has reached)
                    SolutionTimeDestinationTime      (date of escalation in unix time, e. g. 72193292)
                    SolutionTimeDestinationDate      (date of escalation, e. g. "2009-02-14 18:00:00")
                    SolutionTimeWorkingTime          (seconds of working/service time till escalation, e. g. "1800")
                    SolutionTime                     (seconds total till escalation, e. g. "3600")

                    # if you use param Extended to get extended ticket attributes
                    FirstResponse                   (timestamp of first response, first contact with customer)
                    FirstResponseInMin              (minutes till first response)
                    FirstResponseDiffInMin          (minutes till or over first response)

                    SolutionTime                    (timestamp of solution time, also close time)
                    SolutionInMin                   (minutes till solution time)
                    SolutionDiffInMin               (minutes till or over solution time)

                    FirstLock                       (timestamp of first lock)

                    Article => [
                        {
                            ArticleID
                            From
                            To
                            Cc
                            Subject
                            Body
                            ReplyTo
                            MessageID
                            InReplyTo
                            References
                            SenderType
                            SenderTypeID
                            ArticleType
                            ArticleTypeID
                            ContentType
                            Charset
                            MimeType
                            IncomingTime

                            # If DynamicFields => 1 was passed, you'll get an entry like this for each dynamic field:
                            DynamicField_X     => 'value_x',

                            Attachment => [
                                {
                                    Content            => "xxxx",     # actual attachment contents, base64 enconded
                                    ContentAlternative => "",
                                    ContentID          => "",
                                    ContentType        => "application/pdf",
                                    Filename           => "StdAttachment-Test1.pdf",
                                    Filesize           => "4.6 KBytes",
                                    FilesizeRaw        => 4722,
                                },
                                {
                                   # . . .
                                },
                            ]
                        },
                        {
                            #. . .
                        },
                    ],
                },
                {
                    #. . .
                },
            ]
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my ( $UserID, $UserType ) = $Self->{CommonObject}->Auth(
        %Param
    );

    return $Self->{TicketCommonObject}->ReturnError(
        ErrorCode    => 'TicketGet.AuthFail',
        ErrorMessage => "TicketGet: Authorization failing!",
    ) if !$UserID;

    # check needed stuff
    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            return $Self->{TicketCommonObject}->ReturnError(
                ErrorCode    => 'TicketGet.MissingParameter',
                ErrorMessage => "TicketGet: $Needed parameter is missing!",
            );
        }
    }
    my $ErrorMessage = '';

    # all needed vairables
    my @TicketIDs;
    if ( IsStringWithData( $Param{Data}->{TicketID} ) ) {
        @TicketIDs = split( /,/, $Param{Data}->{TicketID} );
    }
    elsif ( IsArrayRefWithData( $Param{Data}->{TicketID} ) ) {
        @TicketIDs = @{ $Param{Data}->{TicketID} };
    }
    else {
        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketGet.WrongStructure',
            ErrorMessage => "TicketGet: Structure for TicketID is not correct!",
        );
    }
    my $DynamicFields     = $Param{Data}->{DynamicFields}     || 0;
    my $Extended          = $Param{Data}->{Extended}          || 0;
    my $AllArticles       = $Param{Data}->{AllArticles}       || 0;
    my $ArticleSenderType = $Param{Data}->{ArticleSenderType} || '';
    my $ArticleOrder      = $Param{Data}->{ArticleOrder}      || 'ASC';
    my $ArticleLimit      = $Param{Data}->{ArticleLimit}      || 0;
    my $Attachments       = $Param{Data}->{Attachments}       || 0;
    my $ReturnData        = {
        Success => 1,
    };
    my @Item;

    # start ticket loop
    TICKET:
    for my $TicketID (@TicketIDs) {

        # get the Ticket entry
        my %TicketEntry = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => $DynamicFields,
            Extended      => $Extended,
            UserID        => $UserID,
        );

        if ( !IsHashRefWithData( \%TicketEntry ) ) {

            $ErrorMessage = 'Could not get Ticket data'
                . ' in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()';

            return $Self->{TicketCommonObject}->ReturnError(
                ErrorCode    => 'TicketGet.NotValidTicketID',
                ErrorMessage => "TicketGet: $ErrorMessage",
            );
        }

        # set Ticket entry data
        my $TicketBundle = {
            %TicketEntry,
        };

        if ( !$AllArticles ) {
            push @Item, $TicketBundle;
            next TICKET;
        }

        my @ArticleBox = $Self->{TicketObject}->ArticleGet(
            TicketID          => $TicketID,
            ArticleSenderType => $ArticleSenderType,
            DynamicFields     => $DynamicFields,
            Extended          => $Extended,
            Order             => $ArticleOrder,
            Limit             => $ArticleLimit,
            UserID            => $UserID,
        );

        # start article loop
        ARTICLE:
        for my $Article (@ArticleBox) {

            # next if not attachments required
            next ARTICLE if !$Attachments;

            # get attachment index (without attachments)
            my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
                ContentPath                => $Article->{ContentPath},
                ArticleID                  => $Article->{ArticleID},
                StripPlainBodyAsAttachment => 3,
                Article                    => $Article,
                UserID                     => $UserID,
            );

            # next if not attachments
            next ARTICLE if !IsHashRefWithData( \%AtmIndex );

            my @Attachments;
            ATTACHMENT:
            for my $FileID ( sort keys %AtmIndex ) {
                next ATTACHMENT if !$FileID;
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Article->{ArticleID},
                    FileID    => $FileID,                 # as returned by ArticleAttachmentIndex
                    UserID    => $UserID,
                );

                # next if not attachment
                next ATTACHMENT if !IsHashRefWithData( \%Attachment );

                # convert content to base64
                $Attachment{Content} = encode_base64( $Attachment{Content} );
                push @Attachments, {%Attachment};
            }

            # set Attachments data
            $Article->{Attachment} = \@Attachments;

        }    # finish article loop

        # set Ticket entry data
        $TicketBundle->{Article} = \@ArticleBox;

        # add
        push @Item, $TicketBundle;
    }    # finish ticket loop

    if ( !scalar @Item ) {
        $ErrorMessage = 'Could not get Ticket data'
            . ' in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()';

        return $Self->{TicketCommonObject}->ReturnError(
            ErrorCode    => 'TicketGet.NotTicketData',
            ErrorMessage => "TicketGet: $ErrorMessage",
        );

    }

    # set ticket data into return structure
    $ReturnData->{Data}->{Ticket} = \@Item;

    # return result
    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
