# --
# Kernel/Modules/AgentTicketBulk.pm - to do bulk actions on tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketBulk;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Priority;
use Kernel::System::LinkObject;
use Kernel::System::Web::UploadCache;
use Kernel::System::CustomerUser;
use Kernel::System::TemplateGenerator;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{StateObject}             = Kernel::System::State->new(%Param);
    $Self->{PriorityObject}          = Kernel::System::Priority->new(%Param);
    $Self->{LinkObject}              = Kernel::System::LinkObject->new(%Param);
    $Self->{CheckItemObject}         = Kernel::System::CheckItem->new(%Param);
    $Self->{UploadCacheObject}       = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{CustomerUserObject}      = Kernel::System::CustomerUser->new(%Param);
    $Self->{TemplateGeneratorObject} = Kernel::System::TemplateGenerator->new(
        %Param,
        CustomerUserObject => $Self->{CustomerUserObject},
    );
    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # get form id for note
    $Self->{NoteFormID} = $Self->{ParamObject}->GetParam( Param => 'NoteFormID' );

    # create form id for note
    if ( !$Self->{NoteFormID} ) {
        $Self->{NoteFormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    # get form id for email
    $Self->{EmailFormID} = $Self->{ParamObject}->GetParam( Param => 'EmailFormID' );

    # create form id for email
    if ( !$Self->{EmailFormID} ) {
        $Self->{EmailFormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if bulk feature is enabled
    if ( !$Self->{ConfigObject}->Get('Ticket::Frontend::BulkFeature') ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Bulk feature is not enabled!',
        );
    }

    # get involved tickets, filtering empty TicketIDs
    my @TicketIDs
        = grep {$_}
        $Self->{ParamObject}->GetArray( Param => 'TicketID' );

    # check needed stuff
    if ( !@TicketIDs ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'You need at least one selected ticket!',
        );
    }
    my $Output .= $Self->{LayoutObject}->Header(
        Type => 'Small',
    );

    # declare the variables for all the parameters
    my %Error;
    my %Time;
    my %GetParam;

    # get all parameters and check for errors
    if ( $Self->{Subaction} eq 'Do' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get all parameters
        for my $Key (
            qw(OwnerID Owner ResponsibleID Responsible PriorityID Priority QueueID Queue Subject
            Body ArticleTypeID ArticleType TypeID StateID State MergeToSelection MergeTo LinkTogether
            EmailSubject EmailBody EmailTimeUnits
            LinkTogetherParent Unlock MergeToChecked MergeToOldestChecked TimeUnits)
            )
        {
            $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key ) || '';
        }

        # get time stamp based on user time zone
        %Time = $Self->{LayoutObject}->TransfromDateSelection(
            Year   => $Self->{ParamObject}->GetParam( Param => 'Year' ),
            Month  => $Self->{ParamObject}->GetParam( Param => 'Month' ),
            Day    => $Self->{ParamObject}->GetParam( Param => 'Day' ),
            Hour   => $Self->{ParamObject}->GetParam( Param => 'Hour' ),
            Minute => $Self->{ParamObject}->GetParam( Param => 'Minute' ),
        );

        if ( $GetParam{'MergeToSelection'} eq 'OptionMergeTo' ) {
            $GetParam{'MergeToChecked'} = 'checked';
        }
        elsif ( $GetParam{'MergeToSelection'} eq 'OptionMergeToOldest' ) {
            $GetParam{'MergeToOldestChecked'} = 'checked';
        }

        # check some stuff
        if (
            $GetParam{Subject}
            &&
            $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
            && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{'TimeUnitsInvalid'} = 'ServerError';
        }

        if (
            $GetParam{EmailSubject}
            &&
            $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
            && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{EmailTimeUnits} eq ''
            )
        {
            $Error{'EmailTimeUnitsInvalid'} = 'ServerError';
        }

        # Body and Subject must both be filled in or both be empty
        if ( $GetParam{Subject} eq '' && $GetParam{Body} ne '' ) {
            $Error{'SubjectInvalid'} = 'ServerError';
        }
        if ( $GetParam{Subject} ne '' && $GetParam{Body} eq '' ) {
            $Error{'BodyInvalid'} = 'ServerError';
        }

        # Email Body and Email Subject must both be filled in or both be empty
        if ( $GetParam{EmailSubject} eq '' && $GetParam{EmailBody} ne '' ) {
            $Error{'EmailSubjectInvalid'} = 'ServerError';
        }
        if ( $GetParam{EmailSubject} ne '' && $GetParam{EmailBody} eq '' ) {
            $Error{'EmailBodyInvalid'} = 'ServerError';
        }

        # check if pending date must be validated
        if ( $GetParam{StateID} || $GetParam{State} ) {
            my %StateData;
            if ( $GetParam{StateID} ) {
                %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                    ID => $GetParam{StateID},
                );
            }
            else {
                %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                    Name => $GetParam{State},
                );
            }
            if ( $StateData{TypeName} =~ /^pending/i ) {
                if ( !$Self->{TimeObject}->Date2SystemTime( %Time, Second => 0 ) ) {
                    $Error{'DateInvalid'} = 'ServerError';
                }
                if (
                    $Self->{TimeObject}->Date2SystemTime( %Time, Second => 0 )
                    < $Self->{TimeObject}->SystemTime()
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }
        if ( $GetParam{'MergeToSelection'} eq 'OptionMergeTo' && $GetParam{'MergeTo'} ) {
            $Self->{CheckItemObject}->StringClean(
                StringRef => \$GetParam{'MergeTo'},
                TrimLeft  => 1,
                TrimRight => 1,
            );
            my $TicketID = $Self->{TicketObject}->TicketCheckNumber(
                Tn => $GetParam{'MergeTo'},
            );
            if ( !$TicketID ) {
                $Error{'MergeToInvalid'} = 'ServerError';
            }
        }
        if ( $GetParam{'LinkTogetherParent'} ) {
            $Self->{CheckItemObject}->StringClean(
                StringRef => \$GetParam{'LinkTogetherParent'},
                TrimLeft  => 1,
                TrimRight => 1,
            );
            my $TicketID = $Self->{TicketObject}->TicketCheckNumber(
                Tn => $GetParam{'LinkTogetherParent'},
            );
            if ( !$TicketID ) {
                $Error{'LinkTogetherParentInvalid'} = 'ServerError';
            }
        }
    }

    # process tickets
    my @TicketIDSelected;
    my $ActionFlag = 0;
    my $Counter    = 1;

    TICKET_ID:
    for my $TicketID (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # check permissions
        my $Access = $Self->{TicketObject}->TicketPermission(
            Type     => 'rw',
            TicketID => $TicketID,
            UserID   => $Self->{UserID}
        );
        if ( !$Access ) {

            # error screen, don't show ticket
            $Output .= $Self->{LayoutObject}->Notify(
                Data => $Ticket{TicketNumber}
                    . ': $Text{"You don\'t have write access to this ticket."}',
            );
            next TICKET_ID;
        }

        $Param{TicketsWereLocked} = 0;

        # check if it's already locked by somebody else
        if ( !$Self->{Config}->{RequiredLock} ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Data => $Ticket{TicketNumber} . ': $Text{"Ticket selected."}',
            );
        }
        else {
            if ( $Self->{TicketObject}->TicketLockGet( TicketID => $TicketID ) ) {
                my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                    TicketID => $TicketID,
                    OwnerID  => $Self->{UserID},
                );
                if ( !$AccessOk ) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Data => $Ticket{TicketNumber}
                            . ': $Text{"Ticket is locked by another agent."}',
                    );
                    next TICKET_ID;
                }
            }
            else {
                $Param{TicketsWereLocked} = 1;
            }

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );

            # set user id
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $TicketID,
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );
            $Output .= $Self->{LayoutObject}->Notify(
                Data => $Ticket{TicketNumber} . ': $Text{"Ticket locked."}',
            );
        }

        # remember selected ticket ids
        push @TicketIDSelected, $TicketID;

        # do some actions on tickets
        if ( ( $Self->{Subaction} eq 'Do' ) && ( !%Error ) ) {

            # challenge token check for write action
            $Self->{LayoutObject}->ChallengeTokenCheck();

            # set owner
            if ( $Self->{Config}->{Owner} && ( $GetParam{'OwnerID'} || $GetParam{'Owner'} ) ) {
                $Self->{TicketObject}->TicketOwnerSet(
                    TicketID  => $TicketID,
                    UserID    => $Self->{UserID},
                    NewUser   => $GetParam{'Owner'},
                    NewUserID => $GetParam{'OwnerID'},
                );
            }

            # set responsible
            if (
                $Self->{ConfigObject}->Get('Ticket::Responsible')
                && $Self->{Config}->{Responsible}
                && ( $GetParam{'ResponsibleID'} || $GetParam{'Responsible'} )
                )
            {
                $Self->{TicketObject}->TicketResponsibleSet(
                    TicketID  => $TicketID,
                    UserID    => $Self->{UserID},
                    NewUser   => $GetParam{'Responsible'},
                    NewUserID => $GetParam{'ResponsibleID'},
                );
            }

            # set priority
            if (
                $Self->{Config}->{Priority}
                && ( $GetParam{'PriorityID'} || $GetParam{'Priority'} )
                )
            {
                $Self->{TicketObject}->TicketPrioritySet(
                    TicketID   => $TicketID,
                    UserID     => $Self->{UserID},
                    Priority   => $GetParam{'Priority'},
                    PriorityID => $GetParam{'PriorityID'},
                );
            }

            # set type
            if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
                if ( $GetParam{'TypeID'} ) {
                    $Self->{TicketObject}->TicketTypeSet(
                        TypeID   => $GetParam{'TypeID'},
                        TicketID => $TicketID,
                        UserID   => $Self->{UserID},
                    );
                }
            }

            # set queue
            if ( $GetParam{'QueueID'} || $GetParam{'Queue'} ) {
                $Self->{TicketObject}->TicketQueueSet(
                    QueueID  => $GetParam{'QueueID'},
                    Queue    => $GetParam{'Queue'},
                    TicketID => $TicketID,
                    UserID   => $Self->{UserID},
                );
            }

            # send email
            my $EmailArticleID;
            if (
                $GetParam{'EmailSubject'}
                && $GetParam{'EmailBody'}
                )
            {
                my $MimeType = 'text/plain';
                if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $GetParam{'EmailBody'} = $Self->{LayoutObject}->RichTextDocumentComplete(
                        String => $GetParam{'EmailBody'},
                    );
                }

                # get customer email address
                my $Customer;
                if ( $Ticket{CustomerUserID} ) {
                    my %Customer = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Ticket{CustomerUserID}
                    );
                    if ( $Customer{UserEmail} ) {
                        $Customer = $Customer{UserEmail};
                    }
                }

                # check if we have an address, otherwise deduct it from the articles
                if ( !$Customer ) {
                    my %Data = $Self->{TicketObject}->ArticleLastCustomerArticle(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                    );

                    # check article type and replace To with From (in case)
                    if ( $Data{SenderType} !~ /customer/ ) {

                        # replace From/To, To/From because sender is agent
                        $Data{From} = $Data{To};
                    }
                    $Customer = $Data{From};
                }

                # generate sender name
                my $From = $Self->{TemplateGeneratorObject}->Sender(
                    QueueID => $Ticket{QueueID},
                    UserID  => $Self->{UserID},
                );

                # generate subject
                my $TicketNumber
                    = $Self->{TicketObject}->TicketNumberLookup( TicketID => $TicketID );

                my $EmailSubject = $Self->{TicketObject}->TicketSubjectBuild(
                    TicketNumber => $TicketNumber,
                    Subject => $GetParam{EmailSubject} || '',
                );

                $EmailArticleID = $Self->{TicketObject}->ArticleSend(
                    TicketID       => $TicketID,
                    ArticleType    => 'email-external',
                    SenderType     => 'agent',
                    From           => $From,
                    To             => $Customer,
                    Subject        => $EmailSubject,
                    Body           => $GetParam{EmailBody},
                    MimeType       => $MimeType,
                    Charset        => $Self->{LayoutObject}->{UserCharset},
                    UserID         => $Self->{UserID},
                    HistoryType    => 'SendAnswer',
                    HistoryComment => '%%' . $Customer,
                );
            }

            # add note
            my $ArticleID;
            if (
                $GetParam{'Subject'}
                && $GetParam{'Body'}
                && ( $GetParam{'ArticleTypeID'} || $GetParam{'ArticleType'} )
                )
            {
                my $MimeType = 'text/plain';
                if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $GetParam{'Body'} = $Self->{LayoutObject}->RichTextDocumentComplete(
                        String => $GetParam{'Body'},
                    );
                }
                $ArticleID = $Self->{TicketObject}->ArticleCreate(
                    TicketID      => $TicketID,
                    ArticleTypeID => $GetParam{'ArticleTypeID'},
                    ArticleType   => $GetParam{'ArticleType'},
                    SenderType    => 'agent',
                    From     => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                    Subject  => $GetParam{'Subject'},
                    Body     => $GetParam{'Body'},
                    MimeType => $MimeType,
                    Charset  => $Self->{LayoutObject}->{UserCharset},
                    UserID   => $Self->{UserID},
                    HistoryType    => 'AddNote',
                    HistoryComment => '%%Bulk',
                );
            }

            # set state
            if ( $Self->{Config}->{State} && ( $GetParam{'StateID'} || $GetParam{'State'} ) ) {
                $Self->{TicketObject}->TicketStateSet(
                    TicketID => $TicketID,
                    StateID  => $GetParam{'StateID'},
                    State    => $GetParam{'State'},
                    UserID   => $Self->{UserID},
                );
                my %Ticket = $Self->{TicketObject}->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                    ID => $Ticket{StateID},
                );

                # should i set the pending date?
                if ( $Ticket{StateType} =~ /^pending/i ) {

                    # set pending time
                    $Self->{TicketObject}->TicketPendingTimeSet(
                        %Time,
                        TicketID => $TicketID,
                        UserID   => $Self->{UserID},
                    );
                }

                # should I set an unlock?
                if ( $Ticket{StateType} =~ /^close/i ) {
                    $Self->{TicketObject}->TicketLockSet(
                        TicketID => $TicketID,
                        Lock     => 'unlock',
                        UserID   => $Self->{UserID},
                    );
                }
            }

            # time units for note
            if ( $GetParam{'TimeUnits'} && $ArticleID ) {
                if ( $Self->{ConfigObject}->Get('Ticket::Frontend::BulkAccountedTime') ) {
                    $Self->{TicketObject}->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $ArticleID,
                        TimeUnit  => $GetParam{'TimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
                elsif (
                    !$Self->{ConfigObject}->Get('Ticket::Frontend::BulkAccountedTime')
                    && $Counter == 1
                    )
                {
                    $Self->{TicketObject}->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $ArticleID,
                        TimeUnit  => $GetParam{'TimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
            }

            # time units for email
            if ( $GetParam{ 'EmailTimeUnits' && $EmailArticleID } ) {
                if ( $Self->{ConfigObject}->Get('Ticket::Frontend::BulkAccountedTime') ) {
                    $Self->{TicketObject}->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $EmailArticleID,
                        TimeUnit  => $GetParam{'EmailTimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
                elsif (
                    !$Self->{ConfigObject}->Get('Ticket::Frontend::BulkAccountedTime')
                    && $Counter == 1
                    )
                {
                    $Self->{TicketObject}->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $EmailArticleID,
                        TimeUnit  => $GetParam{'EmailTimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
            }

            # merge to
            if ( $GetParam{'MergeToSelection'} eq 'OptionMergeTo' && $GetParam{'MergeTo'} ) {
                my $MainTicketID = $Self->{TicketObject}->TicketIDLookup(
                    TicketNumber => $GetParam{'MergeTo'},
                );
                if ( $MainTicketID ne $TicketID ) {
                    $Self->{TicketObject}->TicketMerge(
                        MainTicketID  => $MainTicketID,
                        MergeTicketID => $TicketID,
                        UserID        => $Self->{UserID},
                    );
                }
            }

            # merge to oldest
            if ( $GetParam{'MergeToSelection'} eq 'OptionMergeToOldest' ) {

                # find oldest
                my $TicketIDOldest;
                my $TicketIDOldestID;
                for my $TicketIDCheck (@TicketIDs) {
                    my %Ticket = $Self->{TicketObject}->TicketGet(
                        TicketID      => $TicketIDCheck,
                        DynamicFields => 0,
                    );
                    if ( !defined $TicketIDOldest ) {
                        $TicketIDOldest   = $Ticket{CreateTimeUnix};
                        $TicketIDOldestID = $TicketIDCheck;
                    }
                    if ( $TicketIDOldest > $Ticket{CreateTimeUnix} ) {
                        $TicketIDOldest   = $Ticket{CreateTimeUnix};
                        $TicketIDOldestID = $TicketIDCheck;
                    }
                }

                # merge
                if ( $TicketIDOldestID ne $TicketID ) {
                    $Self->{TicketObject}->TicketMerge(
                        MainTicketID  => $TicketIDOldestID,
                        MergeTicketID => $TicketID,
                        UserID        => $Self->{UserID},
                    );
                }
            }

            # link all tickets to a parent
            if ( $GetParam{'LinkTogetherParent'} ) {
                my $MainTicketID = $Self->{TicketObject}->TicketIDLookup(
                    TicketNumber => $GetParam{'LinkTogetherParent'},
                );

                for my $TicketIDPartner (@TicketIDs) {
                    if ( $MainTicketID ne $TicketID ) {
                        $Self->{LinkObject}->LinkAdd(
                            SourceObject => 'Ticket',
                            SourceKey    => $MainTicketID,
                            TargetObject => 'Ticket',
                            TargetKey    => $TicketID,
                            Type         => 'ParentChild',
                            State        => 'Valid',
                            UserID       => $Self->{UserID},
                        );
                    }
                }
            }

            # link together
            if ( $GetParam{'LinkTogether'} ) {
                for my $TicketIDPartner (@TicketIDs) {
                    if ( $TicketID ne $TicketIDPartner ) {
                        $Self->{LinkObject}->LinkAdd(
                            SourceObject => 'Ticket',
                            SourceKey    => $TicketID,
                            TargetObject => 'Ticket',
                            TargetKey    => $TicketIDPartner,
                            Type         => 'Normal',
                            State        => 'Valid',
                            UserID       => $Self->{UserID},
                        );
                    }
                }
            }

            # should I unlock tickets at user request?
            if ( $GetParam{'Unlock'} ) {
                $Self->{TicketObject}->TicketLockSet(
                    TicketID => $TicketID,
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }
            $ActionFlag = 1;
        }
        $Counter++;
    }

    # redirect
    if ($ActionFlag) {
        return $Self->{LayoutObject}->PopupClose(
            URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
        );
    }

    $Output .= $Self->_Mask(
        %Param,
        %GetParam,
        %Time,
        TicketIDs => \@TicketIDSelected,
        Errors    => \%Error,
    );
    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );
    return $Output;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( sort keys %{ $Param{Errors} } ) {
            $Param{$KeyError}
                = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    $Self->{LayoutObject}->Block(
        Name => 'BulkAction',
        Data => \%Param,
    );

    # remember ticket ids
    if ( $Param{TicketIDs} ) {
        for my $TicketID ( @{ $Param{TicketIDs} } ) {
            $Self->{LayoutObject}->Block(
                Name => 'UsedTicketID',
                Data => {
                    TicketID => $TicketID,
                },
            );
        }
    }

    # build ArticleTypeID string
    my %DefaultNoteTypes = %{ $Self->{Config}->{ArticleTypes} };
    my %NoteTypes = $Self->{TicketObject}->ArticleTypeList( Result => 'HASH' );
    for my $KeyNoteType ( sort keys %NoteTypes ) {
        if ( !$DefaultNoteTypes{ $NoteTypes{$KeyNoteType} } ) {
            delete $NoteTypes{$KeyNoteType};
        }
    }

    if ( $Param{ArticleTypeID} ) {
        $Param{NoteStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%NoteTypes,
            Name       => 'ArticleTypeID',
            SelectedID => $Param{ArticleTypeID},
        );
    }
    else {
        $Param{NoteStrg} = $Self->{LayoutObject}->BuildSelection(
            Data          => \%NoteTypes,
            Name          => 'ArticleTypeID',
            SelectedValue => $Self->{Config}->{ArticleTypeDefault},
        );
    }

    # build next states string
    if ( $Self->{Config}->{State} ) {
        my %State;
        my %StateList = $Self->{StateObject}->StateGetStatesByType(
            StateType => $Self->{Config}->{StateType},
            Result    => 'HASH',
            Action    => $Self->{Action},
            UserID    => $Self->{UserID},
        );
        if ( !$Self->{Config}->{StateDefault} ) {
            $StateList{''} = '-';
        }
        if ( !$Param{StateID} ) {
            if ( $Self->{Config}->{StateDefault} ) {
                $State{SelectedValue} = $Self->{Config}->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{StateID};
        }

        $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%StateList,
            Name => 'StateID',
            %State,
        );
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => \%Param,
        );

        STATE_ID:
        for my $StateID ( sort keys %StateList ) {
            next STATE_ID if !$StateID;
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $StateID );
            next STATE_ID if $StateData{TypeName} !~ /pending/i;
            $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
                %Param,
                Format   => 'DateInputFormatLong',
                DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
                Class    => $Param{Errors}->{DateInvalid} || '',
                Validate => 1,
                ValidateDateInFuture => 1,
            );
            $Self->{LayoutObject}->Block(
                Name => 'StatePending',
                Data => \%Param,
            );
            last;
        }
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Type,
            PossibleNone => 1,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # owner list
    if ( $Self->{Config}->{Owner} ) {
        my %AllGroupsMembers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 1 );

        # only put possible rw agents to possible owner list
        if ( !$Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            my %AllGroupsMembersNew;
            for my $TicketID ( @{ $Param{TicketIDs} } ) {
                my %Ticket = $Self->{TicketObject}->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                my $GroupID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
                my %GroupMember = $Self->{GroupObject}->GroupMemberList(
                    GroupID => $GroupID,
                    Type    => 'rw',
                    Result  => 'HASH',
                );
                USER_ID:
                for my $UserID ( sort keys %GroupMember ) {
                    next USER_ID if !$AllGroupsMembers{$UserID};
                    $AllGroupsMembersNew{$UserID} = $AllGroupsMembers{$UserID};
                }
                %AllGroupsMembers = %AllGroupsMembersNew;
            }
        }
        $Param{OwnerStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%AllGroupsMembers,
            Name         => 'OwnerID',
            Translation  => 0,
            SelectedID   => $Param{OwnerID},
            PossibleNone => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }

    # responsible list
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') && $Self->{Config}->{Responsible} ) {
        my %AllGroupsMembers = $Self->{UserObject}->UserList( Type => 'Long', Valid => 1 );

        # only put possible rw agents to possible owner list
        if ( !$Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            my %AllGroupsMembersNew;
            for my $TicketID ( @{ $Param{TicketIDs} } ) {
                my %Ticket = $Self->{TicketObject}->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                my $GroupID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
                my %GroupMember = $Self->{GroupObject}->GroupMemberList(
                    GroupID => $GroupID,
                    Type    => 'rw',
                    Result  => 'HASH',
                );
                USER_ID:
                for my $UserID ( sort keys %GroupMember ) {
                    next USER_ID if !$AllGroupsMembers{$UserID};
                    $AllGroupsMembersNew{$UserID} = $AllGroupsMembers{$UserID};
                }
                %AllGroupsMembers = %AllGroupsMembersNew;
            }
        }
        $Param{ResponsibleStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => { '' => '-', %AllGroupsMembers },
            Name => 'ResponsibleID',
            Translation => 0,
            SelectedID  => $Param{ResponsibleID},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
    }

    # build move queue string
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        UserID => $Self->{UserID},
        Action => $Self->{Action},
        Type   => 'move_into',
    );
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { %MoveQueues, '' => '-' },
        Multiple => 0,
        Size     => 0,
        Name     => 'QueueID',

        #       SelectedID => $Self->{DestQueueID},
        OnChangeSubmit => 0,
    );

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priority;
        my %PriorityList = $Self->{PriorityObject}->PriorityList(
            Valid  => 1,
            UserID => $Self->{UserID},
        );
        if ( !$Self->{Config}->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{PriorityID} ) {
            if ( $Self->{Config}->{PriorityDefault} ) {
                $Priority{SelectedValue} = $Self->{Config}->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{PriorityID};
        }
        $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%PriorityList,
            Name => 'PriorityID',
            %Priority,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        $Param{TimeUnitsRequired} = (
            $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            ? 'Validate_DependingRequiredAND Validate_Depending_Subject'
            : ''
        );
        $Param{TimeUnitsRequiredEmail} = (
            $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            ? 'Validate_DependingRequiredAND Validate_Depending_EmailSubject'
            : ''
        );

        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => { TimeUnitsRequired => $Param{TimeUnitsRequired} },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatoryEmail',
                Data => { TimeUnitsRequired => $Param{TimeUnitsRequiredEmail} },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelEmail',
                Data => \%Param,
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsEmail',
            Data => \%Param,
        );
    }

    $Param{LinkTogetherYesNoOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'LinkTogether',
        SelectedID => $Param{LinkTogether} || 0,
    );

    $Param{UnlockYesNoOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'Unlock',
        SelectedID => $Param{Unlock} || 1,
    );

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # add rich text editor for note & email
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'RichTextEmail',
            Data => \%Param,
        );
    }

    # reload parent window
    if ( $Param{TicketsWereLocked} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ParentReload',
            Data => {
                URL => $Self->{LastScreenOverview},
                }
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketBulk', Data => \%Param );
}

1;
