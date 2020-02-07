# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Ticket::TicketGet;

use strict;
use warnings;

use MIME::Base64;

use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use parent qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Ticket::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketGet - GenericInterface Ticket Get Operation backend

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=head2 Run()

perform TicketGet Operation. This function is able to return
one or more ticket entries in one call.

    my $Result = $OperationObject->Run(
        Data => {
            UserLogin            => 'some agent login',                            # UserLogin or CustomerUserLogin or SessionID is
                                                                                   #   required
            CustomerUserLogin    => 'some customer login',
            SessionID            => 123,

            Password             => 'some password',                               # if UserLogin or customerUserLogin is sent then
                                                                                   #   Password is required
            TicketID             => '32,33',                                       # required, could be coma separated IDs or an Array
            DynamicFields        => 0,                                             # Optional, 0 as default. Indicate if Dynamic Fields
                                                                                   #     should be included or not on the ticket content.
            Extended             => 1,                                             # Optional, 0 as default
            AllArticles          => 1,                                             # Optional, 0 as default. Set as 1 will include articles
                                                                                   #     for tickets.
            ArticleSenderType    => [ $ArticleSenderType1, $ArticleSenderType2 ],  # Optional, only requested article sender types
            ArticleOrder         => 'DESC',                                        # Optional, DESC,ASC - default is ASC
            ArticleLimit         => 5,                                             # Optional
            Attachments          => 1,                                             # Optional, 0 as default. If it's set with the value 1,
                                                                                   # attachments for articles will be included on ticket data
            GetAttachmentContents = 1                                              # Optional, 1 as default. 0|1,
            HTMLBodyAsAttachment => 1                                              # Optional, If enabled the HTML body version of each article
                                                                                   #    is added to the attachments list
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
                    CreateBy           => 123,
                    Changed            => '2010-10-27 20:15:15',
                    ChangeBy           => 123,
                    ArchiveFlag        => 'y',
                    TimeUnit           => 123,

                    # If DynamicFields => 1 was passed, you'll get an entry like this for each dynamic field:
                    DynamicField => [
                        {
                            Name  => 'some name',
                            Value => 'some value',
                        },
                    ],

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
                            IsVisibleForCustomer
                            ContentType
                            Charset
                            MimeType
                            IncomingTime
                            TimeUnit

                            # If DynamicFields => 1 was passed, you'll get an entry like this for each dynamic field:
                            DynamicField => [
                                {
                                    Name  => 'some name',
                                    Value => 'some value',
                                },
                            ],

                            Attachment => [
                                {
                                    Content            => "xxxx",     # actual attachment contents, base64 enconded
                                    ContentAlternative => "",
                                    ContentID          => "",
                                    ContentType        => "application/pdf",
                                    FileID             => 34,
                                    Filename           => "StdAttachment-Test1.pdf",
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

    my $Result = $Self->Init(
        WebserviceID => $Self->{WebserviceID},
    );

    if ( !$Result->{Success} ) {
        return $Self->ReturnError(
            ErrorCode    => 'Webservice.InvalidConfiguration',
            ErrorMessage => $Result->{ErrorMessage},
        );
    }

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    return $Self->ReturnError(
        ErrorCode    => 'TicketGet.AuthFail',
        ErrorMessage => "TicketGet: Authorization failing!",
    ) if !$UserID;

    # check needed stuff
    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            return $Self->ReturnError(
                ErrorCode    => 'TicketGet.MissingParameter',
                ErrorMessage => "TicketGet: $Needed parameter is missing!",
            );
        }
    }
    my $ErrorMessage = '';

    # all needed variables
    my @TicketIDs;
    if ( IsStringWithData( $Param{Data}->{TicketID} ) ) {
        @TicketIDs = split( /,/, $Param{Data}->{TicketID} );
    }
    elsif ( IsArrayRefWithData( $Param{Data}->{TicketID} ) ) {
        @TicketIDs = @{ $Param{Data}->{TicketID} };
    }
    else {
        return $Self->ReturnError(
            ErrorCode    => 'TicketGet.WrongStructure',
            ErrorMessage => "TicketGet: Structure for TicketID is not correct!",
        );
    }

    # Get the list of article dynamic fields
    my $ArticleDynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        ObjectType => 'Article',
        ResultType => 'HASH',
    );

    # Crate a lookup list for easy search
    my %ArticleDynamicFieldLookup = reverse %{$ArticleDynamicFieldList};

    TICKET:
    for my $TicketID (@TicketIDs) {

        my $Access = $Self->CheckAccessPermissions(
            TicketID => $TicketID,
            UserID   => $UserID,
            UserType => $UserType,
        );

        next TICKET if $Access;

        return $Self->ReturnError(
            ErrorCode    => 'TicketGet.AccessDenied',
            ErrorMessage => 'TicketGet: User does not have access to the ticket!',
        );
    }

    my $DynamicFields = $Param{Data}->{DynamicFields} || 0;
    my $Extended      = $Param{Data}->{Extended}      || 0;
    my $AllArticles   = $Param{Data}->{AllArticles}   || 0;
    my $ArticleOrder  = $Param{Data}->{ArticleOrder}  || 'ASC';
    my $ArticleLimit  = $Param{Data}->{ArticleLimit}  || 0;
    my $Attachments   = $Param{Data}->{Attachments}   || 0;
    my $GetAttachmentContents = $Param{Data}->{GetAttachmentContents} // 1;

    my $ReturnData = {
        Success => 1,
    };
    my @Item;

    my $ArticleSenderType = '';
    if ( IsArrayRefWithData( $Param{Data}->{ArticleSenderType} ) ) {
        $ArticleSenderType = $Param{Data}->{ArticleSenderType};
    }
    elsif ( IsStringWithData( $Param{Data}->{ArticleSenderType} ) ) {
        $ArticleSenderType = [ $Param{Data}->{ArticleSenderType} ];
    }

    # By default, do not include HTML body as attachment, unless it is explicitly requested.
    my %ExcludeAttachments = (
        ExcludePlainText => 1,
        ExcludeHTMLBody  => $Param{Data}->{HTMLBodyAsAttachment} ? 0 : 1,
    );

    # start ticket loop
    TICKET:
    for my $TicketID (@TicketIDs) {

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get the Ticket entry
        my %TicketEntryRaw = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => $DynamicFields,
            Extended      => $Extended,
            UserID        => $UserID,
        );

        if ( !IsHashRefWithData( \%TicketEntryRaw ) ) {

            $ErrorMessage = 'Could not get Ticket data'
                . ' in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()';

            return $Self->ReturnError(
                ErrorCode    => 'TicketGet.NotValidTicketID',
                ErrorMessage => "TicketGet: $ErrorMessage",
            );
        }

        my %TicketEntry;
        my @DynamicFields;

        # remove all dynamic fields from main ticket hash and set them into an array.
        ATTRIBUTE:
        for my $Attribute ( sort keys %TicketEntryRaw ) {

            if ( $Attribute =~ m{\A DynamicField_(.*) \z}msx ) {
                push @DynamicFields, {
                    Name  => $1,
                    Value => $TicketEntryRaw{$Attribute},
                };
                next ATTRIBUTE;
            }

            $TicketEntry{$Attribute} = $TicketEntryRaw{$Attribute};
        }

        $TicketEntry{TimeUnit} = $TicketObject->TicketAccountedTimeGet(
            TicketID => $TicketID,
        );

        # add dynamic fields array into 'DynamicField' hash key if any
        if (@DynamicFields) {
            $TicketEntry{DynamicField} = \@DynamicFields;
        }

        # set Ticket entry data
        my $TicketBundle = {
            %TicketEntry,
        };

        if ( !$AllArticles ) {
            push @Item, $TicketBundle;
            next TICKET;
        }

        my %ArticleListFilters;
        if ( $UserType eq 'Customer' ) {
            %ArticleListFilters = (
                IsVisibleForCustomer => 1,
            );
        }

        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        my @Articles;
        if ($ArticleSenderType) {
            for my $SenderType ( @{ $ArticleSenderType || [] } ) {
                my @ArticlesFiltered = $ArticleObject->ArticleList(
                    TicketID   => $TicketID,
                    SenderType => $SenderType,
                    %ArticleListFilters,
                );
                push @Articles, @ArticlesFiltered;
            }
        }
        else {
            @Articles = $ArticleObject->ArticleList(
                TicketID => $TicketID,
                %ArticleListFilters,
            );
        }

        # Modify ArticleLimit if it is greater then number of articles (see bug#14585).
        if ( $ArticleLimit > scalar @Articles ) {
            $ArticleLimit = scalar @Articles;
        }

        # Set number of articles by ArticleLimit and ArticleOrder parameters.
        if ( IsArrayRefWithData( \@Articles ) && $ArticleLimit ) {
            if ( $ArticleOrder eq 'DESC' ) {
                @Articles = reverse @Articles;
            }
            @Articles = @Articles[ 0 .. ( $ArticleLimit - 1 ) ];
        }

        # start article loop
        ARTICLE:
        for my $Article (@Articles) {

            my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$Article} );

            my %ArticleData = $ArticleBackendObject->ArticleGet(
                TicketID      => $TicketID,
                ArticleID     => $Article->{ArticleID},
                DynamicFields => $DynamicFields,
            );
            $Article = \%ArticleData;

            next ARTICLE if !$Attachments;

            # get attachment index (without attachments)
            my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID => $Article->{ArticleID},
                %ExcludeAttachments,
            );

            next ARTICLE if !IsHashRefWithData( \%AtmIndex );

            my @Attachments;
            ATTACHMENT:
            for my $FileID ( sort keys %AtmIndex ) {
                next ATTACHMENT if !$FileID;
                my %Attachment = $ArticleBackendObject->ArticleAttachment(
                    ArticleID => $Article->{ArticleID},
                    FileID    => $FileID,                 # as returned by ArticleAttachmentIndex
                );

                next ATTACHMENT if !IsHashRefWithData( \%Attachment );

                $Attachment{FileID} = $FileID;
                if ($GetAttachmentContents)
                {
                    # convert content to base64, but prevent 76 chars brake, see bug#14500.
                    $Attachment{Content} = encode_base64( $Attachment{Content}, '' );
                }
                else {
                    # unset content
                    $Attachment{Content}            = '';
                    $Attachment{ContentAlternative} = '';
                }
                push @Attachments, {%Attachment};
            }

            # set Attachments data
            $Article->{Attachment} = \@Attachments;

        }    # finish article loop

        # set Ticket entry data
        if (@Articles) {

            my @ArticleBox;

            for my $ArticleRaw (@Articles) {
                my %Article;
                my @ArticleDynamicFields;

                # remove all dynamic fields from main article hash and set them into an array.
                ATTRIBUTE:
                for my $Attribute ( sort keys %{$ArticleRaw} ) {

                    if ( $Attribute =~ m{\A DynamicField_(.*) \z}msx ) {

                        # skip dynamic fields that are not article related
                        # this is needed because ArticleGet() also returns ticket dynamic fields
                        next ATTRIBUTE if ( !$ArticleDynamicFieldLookup{$1} );

                        push @ArticleDynamicFields, {
                            Name  => $1,
                            Value => $ArticleRaw->{$Attribute},
                        };
                        next ATTRIBUTE;
                    }

                    $Article{$Attribute} = $ArticleRaw->{$Attribute};
                }

                $Article{TimeUnit} = $ArticleObject->ArticleAccountedTimeGet(
                    ArticleID => $ArticleRaw->{ArticleID}
                );

                # add dynamic fields array into 'DynamicField' hash key if any
                if (@ArticleDynamicFields) {
                    $Article{DynamicField} = \@ArticleDynamicFields;
                }

                push @ArticleBox, \%Article;
            }
            $TicketBundle->{Article} = \@ArticleBox;
        }

        # add
        push @Item, $TicketBundle;
    }    # finish ticket loop

    if ( !scalar @Item ) {
        $ErrorMessage = 'Could not get Ticket data'
            . ' in Kernel::GenericInterface::Operation::Ticket::TicketGet::Run()';

        return $Self->ReturnError(
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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
