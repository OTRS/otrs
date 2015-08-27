# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketBulk;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if ( $Self->{Subaction} eq 'CancelAndUnlockTickets' ) {

        my @TicketIDs = grep {$_}
            $ParamObject->GetArray( Param => 'LockedTicketID' );

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check needed stuff
        if ( !@TicketIDs ) {
            return $LayoutObject->ErrorScreen(
                Message => 'Can\'t lock Tickets, no TicketIDs are given!',
                Comment => 'Please contact the admin.',
            );
        }

        my $Message = '';

        TICKET_ID:
        for my $TicketID (@TicketIDs) {

            my $Access = $TicketObject->TicketPermission(
                Type     => 'lock',
                TicketID => $TicketID,
                UserID   => $Self->{UserID}
            );

            # error screen, don't show ticket
            if ( !$Access ) {
                return $LayoutObject->NoPermission( WithHeader => 'yes' );
            }

            # set unlock
            my $Lock = $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
            if ( !$Lock ) {
                $Message .= "$TicketID,";
            }
        }

        if ( $Message ne '' ) {
            return $LayoutObject->ErrorScreen(
                Message => "Ticket ($Message) is not unlocked!",
            );
        }

        return $LayoutObject->Redirect(
            OP => $Self->{LastScreenOverview},
        );

    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if bulk feature is enabled
    if ( !$ConfigObject->Get('Ticket::Frontend::BulkFeature') ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Bulk feature is not enabled!',
        );
    }

    # get involved tickets, filtering empty TicketIDs
    my @ValidTicketIDs;
    my @IgnoreLockedTicketIDs;
    my @TicketIDs = grep {$_}
        $ParamObject->GetArray( Param => 'TicketID' );

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # check if only locked tickets have been selected
    if ( $Config->{RequiredLock} ) {
        for my $TicketID (@TicketIDs) {
            if ( $TicketObject->TicketLockGet( TicketID => $TicketID ) ) {
                my $AccessOk = $TicketObject->OwnerCheck(
                    TicketID => $TicketID,
                    OwnerID  => $Self->{UserID},
                );
                if ($AccessOk) {
                    push @ValidTicketIDs, $TicketID;
                }
                else {
                    push @IgnoreLockedTicketIDs, $TicketID;
                }
            }
            else {
                push @ValidTicketIDs, $TicketID;
            }
        }
    }
    else {
        @ValidTicketIDs = @TicketIDs;
    }

    # check needed stuff
    if ( !@ValidTicketIDs ) {
        if ( $Config->{RequiredLock} ) {
            return $LayoutObject->ErrorScreen(
                Message => 'No selectable TicketID is given!',
                Comment =>
                    'You either selected no ticket or only tickets which are locked by other agents',
            );
        }
        else {
            return $LayoutObject->ErrorScreen(
                Message => 'No TicketID is given!',
                Comment => 'You need to select at least one ticket',
            );
        }
    }

    my $Output = $LayoutObject->Header(
        Type => 'Small',
    );

    # declare the variables for all the parameters
    my %Error;
    my %Time;
    my %GetParam;

    # get bulk modules from SysConfig
    my $BulkModuleConfig = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::BulkModule') || {};

    # create bulk module objects
    my @BulkModules;
    MODULECONFIG:
    for my $ModuleConfig ( sort keys %{$BulkModuleConfig} ) {

        next MODULECONFIG if !$ModuleConfig;
        next MODULECONFIG if !$BulkModuleConfig->{$ModuleConfig};
        next MODULECONFIG if ref $BulkModuleConfig->{$ModuleConfig} ne 'HASH';
        next MODULECONFIG if !$BulkModuleConfig->{$ModuleConfig}->{Module};

        my $Module = $BulkModuleConfig->{$ModuleConfig}->{Module};

        my $ModuleObject;
        eval {
            $ModuleObject = $Kernel::OM->Get($Module);
        };

        if ( !$ModuleObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create a new object for $Module!",
            );
            next MODULECONFIG;
        }

        if ( ref $ModuleObject ne $Module ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Object for $Module is invalid!",
            );
            next MODULECONFIG;
        }

        push @BulkModules, $ModuleObject;
    }

    # get needed objects
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    # get all parameters and check for errors
    if ( $Self->{Subaction} eq 'Do' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get all parameters
        for my $Key (
            qw(OwnerID Owner ResponsibleID Responsible PriorityID Priority QueueID Queue Subject
            Body ArticleTypeID ArticleType TypeID StateID State MergeToSelection MergeTo LinkTogether
            EmailSubject EmailBody EmailTimeUnits
            LinkTogetherParent Unlock MergeToChecked MergeToOldestChecked)
            )
        {
            $GetParam{$Key} = $ParamObject->GetParam( Param => $Key ) || '';
        }

        for my $Key (qw(TimeUnits)) {
            $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
        }

        # get time stamp based on user time zone
        %Time = $LayoutObject->TransfromDateSelection(
            Year   => $ParamObject->GetParam( Param => 'Year' ),
            Month  => $ParamObject->GetParam( Param => 'Month' ),
            Day    => $ParamObject->GetParam( Param => 'Day' ),
            Hour   => $ParamObject->GetParam( Param => 'Hour' ),
            Minute => $ParamObject->GetParam( Param => 'Minute' ),
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
            $ConfigObject->Get('Ticket::Frontend::AccountTime')
            && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{'TimeUnitsInvalid'} = 'ServerError';
        }

        if (
            $GetParam{EmailSubject}
            &&
            $ConfigObject->Get('Ticket::Frontend::AccountTime')
            && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
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
                %StateData = $StateObject->StateGet(
                    ID => $GetParam{StateID},
                );
            }
            else {
                %StateData = $StateObject->StateGet(
                    Name => $GetParam{State},
                );
            }

            # get time object
            my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

            if ( $StateData{TypeName} =~ /^pending/i ) {
                if ( !$TimeObject->Date2SystemTime( %Time, Second => 0 ) ) {
                    $Error{'DateInvalid'} = 'ServerError';
                }
                if (
                    $TimeObject->Date2SystemTime( %Time, Second => 0 )
                    < $TimeObject->SystemTime()
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        if ( $GetParam{'MergeToSelection'} eq 'OptionMergeTo' && $GetParam{'MergeTo'} ) {
            $CheckItemObject->StringClean(
                StringRef => \$GetParam{'MergeTo'},
                TrimLeft  => 1,
                TrimRight => 1,
            );
            my $TicketID = $TicketObject->TicketCheckNumber(
                Tn => $GetParam{'MergeTo'},
            );
            if ( !$TicketID ) {
                $Error{'MergeToInvalid'} = 'ServerError';
            }
        }
        if ( $GetParam{'LinkTogetherParent'} ) {
            $CheckItemObject->StringClean(
                StringRef => \$GetParam{'LinkTogetherParent'},
                TrimLeft  => 1,
                TrimRight => 1,
            );
            my $TicketID = $TicketObject->TicketCheckNumber(
                Tn => $GetParam{'LinkTogetherParent'},
            );
            if ( !$TicketID ) {
                $Error{'LinkTogetherParentInvalid'} = 'ServerError';
            }
        }

        # call Validate() in all ticket bulk modules
        if (@BulkModules) {
            MODULEOBJECT:
            for my $ModuleObject (@BulkModules) {
                next MODULEOBJECT if !$ModuleObject->can('Validate');

                my @Result = $ModuleObject->Validate(
                    UserID => $Self->{UserID},
                );

                next MODULEOBJECT if !@Result;

                # include all validation errors in the common error hash
                for my $ValidationError (@Result) {
                    $Error{ $ValidationError->{ErrorKey} } = $ValidationError->{ErrorValue};
                }
            }
        }
    }

    # process tickets
    my @TicketIDSelected;
    my $LockedTickets = '';
    my $ActionFlag    = 0;
    my $Counter       = 1;
    $Param{TicketsWereLocked} = 0;

    # if the tickets are to merged, precompute the ticket to merge to.
    # (it's the same for all tickets, so do it only once):
    my $MainTicketID;

    if ( ( $Self->{Subaction} eq 'Do' ) && ( !%Error ) ) {

        # merge to
        if ( $GetParam{'MergeToSelection'} eq 'OptionMergeTo' && $GetParam{'MergeTo'} ) {
            $MainTicketID = $TicketObject->TicketIDLookup(
                TicketNumber => $GetParam{'MergeTo'},
            );
        }

        # merge to oldest
        elsif ( $GetParam{'MergeToSelection'} eq 'OptionMergeToOldest' ) {

            # find oldest
            my $TicketIDOldest;
            my $TicketIDOldestID;
            for my $TicketIDCheck (@TicketIDs) {
                my %Ticket = $TicketObject->TicketGet(
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
            $MainTicketID = $TicketIDOldestID;
        }
    }

    TICKET_ID:
    for my $TicketID (@TicketIDs) {
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # check permissions
        my $Access = $TicketObject->TicketPermission(
            Type     => 'rw',
            TicketID => $TicketID,
            UserID   => $Self->{UserID}
        );
        if ( !$Access ) {

            # error screen, don't show ticket
            $Output .= $LayoutObject->Notify(
                Data => "$Ticket{TicketNumber}: "
                    . $LayoutObject->{LanguageObject}->Translate("You don't have write access to this ticket."),
            );
            next TICKET_ID;
        }

        # check if it's already locked by somebody else
        if ( !$Config->{RequiredLock} ) {
            $Output .= $LayoutObject->Notify(
                Data => "$Ticket{TicketNumber}: "
                    . $LayoutObject->{LanguageObject}->Translate("Ticket selected."),
            );
        }
        else {
            if ( grep ( { $_ eq $TicketID } @IgnoreLockedTicketIDs ) ) {
                $Output .= $LayoutObject->Notify(
                    Priority => 'Error',
                    Data     => "$Ticket{TicketNumber}: "
                        . $LayoutObject->{LanguageObject}->Translate(
                        "Ticket is locked by another agent and will be ignored!"
                        ),
                );
                next TICKET_ID;
            }
            else {
                $LockedTickets .= "LockedTicketID=" . $TicketID . ';';
                $Param{TicketsWereLocked} = 1;
            }

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );

            # set user id
            $TicketObject->TicketOwnerSet(
                TicketID  => $TicketID,
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );
            $Output .= $LayoutObject->Notify(
                Data => "$Ticket{TicketNumber}: "
                    . $LayoutObject->{LanguageObject}->Translate("Ticket locked."),
            );
        }

        # remember selected ticket ids
        push @TicketIDSelected, $TicketID;

        # do some actions on tickets
        if ( ( $Self->{Subaction} eq 'Do' ) && ( !%Error ) ) {

            # challenge token check for write action
            $LayoutObject->ChallengeTokenCheck();

            # set owner
            if ( $Config->{Owner} && ( $GetParam{'OwnerID'} || $GetParam{'Owner'} ) ) {
                $TicketObject->TicketOwnerSet(
                    TicketID  => $TicketID,
                    UserID    => $Self->{UserID},
                    NewUser   => $GetParam{'Owner'},
                    NewUserID => $GetParam{'OwnerID'},
                );
            }

            # set responsible
            if (
                $ConfigObject->Get('Ticket::Responsible')
                && $Config->{Responsible}
                && ( $GetParam{'ResponsibleID'} || $GetParam{'Responsible'} )
                )
            {
                $TicketObject->TicketResponsibleSet(
                    TicketID  => $TicketID,
                    UserID    => $Self->{UserID},
                    NewUser   => $GetParam{'Responsible'},
                    NewUserID => $GetParam{'ResponsibleID'},
                );
            }

            # set priority
            if (
                $Config->{Priority}
                && ( $GetParam{'PriorityID'} || $GetParam{'Priority'} )
                )
            {
                $TicketObject->TicketPrioritySet(
                    TicketID   => $TicketID,
                    UserID     => $Self->{UserID},
                    Priority   => $GetParam{'Priority'},
                    PriorityID => $GetParam{'PriorityID'},
                );
            }

            # set type
            if ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} ) {
                if ( $GetParam{'TypeID'} ) {
                    $TicketObject->TicketTypeSet(
                        TypeID   => $GetParam{'TypeID'},
                        TicketID => $TicketID,
                        UserID   => $Self->{UserID},
                    );
                }
            }

            # set queue
            if ( $GetParam{'QueueID'} || $GetParam{'Queue'} ) {
                $TicketObject->TicketQueueSet(
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
                if ( $LayoutObject->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $GetParam{'EmailBody'} = $LayoutObject->RichTextDocumentComplete(
                        String => $GetParam{'EmailBody'},
                    );
                }

                # get customer user object
                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

                # get customer email address
                my $Customer;
                if ( $Ticket{CustomerUserID} ) {
                    my %Customer = $CustomerUserObject->CustomerUserDataGet(
                        User => $Ticket{CustomerUserID}
                    );
                    if ( $Customer{UserEmail} ) {
                        $Customer = $Customer{UserEmail};
                    }
                }

                # check if we have an address, otherwise deduct it from the articles
                if ( !$Customer ) {
                    my %Data = $TicketObject->ArticleLastCustomerArticle(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                    );

                    # use ReplyTo if set, otherwise use From
                    $Customer = $Data{ReplyTo} ? $Data{ReplyTo} : $Data{From};

                    # check article type and replace To with From (in case)
                    if ( $Data{SenderType} !~ /customer/ ) {

                        # replace From/To, To/From because sender is agent
                        $Customer = $Data{To};
                    }

                }

                # get template generator object
                my $TemplateGeneratorObject = $Kernel::OM->ObjectParamAdd(
                    'Kernel::System::TemplateGenerator' => {
                        CustomerUserObject => $CustomerUserObject,
                        }
                );

                $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

                # generate sender name
                my $From = $TemplateGeneratorObject->Sender(
                    QueueID => $Ticket{QueueID},
                    UserID  => $Self->{UserID},
                );

                # generate subject
                my $TicketNumber = $TicketObject->TicketNumberLookup( TicketID => $TicketID );

                my $EmailSubject = $TicketObject->TicketSubjectBuild(
                    TicketNumber => $TicketNumber,
                    Subject      => $GetParam{EmailSubject} || '',
                );

                $EmailArticleID = $TicketObject->ArticleSend(
                    TicketID       => $TicketID,
                    ArticleType    => 'email-external',
                    SenderType     => 'agent',
                    From           => $From,
                    To             => $Customer,
                    Subject        => $EmailSubject,
                    Body           => $GetParam{EmailBody},
                    MimeType       => $MimeType,
                    Charset        => $LayoutObject->{UserCharset},
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
                if ( $LayoutObject->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $GetParam{'Body'} = $LayoutObject->RichTextDocumentComplete(
                        String => $GetParam{'Body'},
                    );
                }
                $ArticleID = $TicketObject->ArticleCreate(
                    TicketID       => $TicketID,
                    ArticleTypeID  => $GetParam{'ArticleTypeID'},
                    ArticleType    => $GetParam{'ArticleType'},
                    SenderType     => 'agent',
                    From           => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                    Subject        => $GetParam{'Subject'},
                    Body           => $GetParam{'Body'},
                    MimeType       => $MimeType,
                    Charset        => $LayoutObject->{UserCharset},
                    UserID         => $Self->{UserID},
                    HistoryType    => 'AddNote',
                    HistoryComment => '%%Bulk',
                );
            }

            # set state
            if ( $Config->{State} && ( $GetParam{'StateID'} || $GetParam{'State'} ) ) {
                $TicketObject->TicketStateSet(
                    TicketID => $TicketID,
                    StateID  => $GetParam{'StateID'},
                    State    => $GetParam{'State'},
                    UserID   => $Self->{UserID},
                );
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                my %StateData = $StateObject->StateGet(
                    ID => $Ticket{StateID},
                );

                # should i set the pending date?
                if ( $Ticket{StateType} =~ /^pending/i ) {

                    # set pending time
                    $TicketObject->TicketPendingTimeSet(
                        %Time,
                        TicketID => $TicketID,
                        UserID   => $Self->{UserID},
                    );
                }

                # should I set an unlock?
                if ( $Ticket{StateType} =~ /^close/i ) {
                    $TicketObject->TicketLockSet(
                        TicketID => $TicketID,
                        Lock     => 'unlock',
                        UserID   => $Self->{UserID},
                    );
                }
            }

            # time units for note
            if ( $GetParam{TimeUnits} && $ArticleID ) {
                if ( $ConfigObject->Get('Ticket::Frontend::BulkAccountedTime') ) {
                    $TicketObject->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $ArticleID,
                        TimeUnit  => $GetParam{'TimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
                elsif (
                    !$ConfigObject->Get('Ticket::Frontend::BulkAccountedTime')
                    && $Counter == 1
                    )
                {
                    $TicketObject->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $ArticleID,
                        TimeUnit  => $GetParam{'TimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
            }

            # time units for email
            if ( $GetParam{EmailTimeUnits} && $EmailArticleID ) {
                if ( $ConfigObject->Get('Ticket::Frontend::BulkAccountedTime') ) {
                    $TicketObject->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $EmailArticleID,
                        TimeUnit  => $GetParam{'EmailTimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
                elsif (
                    !$ConfigObject->Get('Ticket::Frontend::BulkAccountedTime')
                    && $Counter == 1
                    )
                {
                    $TicketObject->TicketAccountTime(
                        TicketID  => $TicketID,
                        ArticleID => $EmailArticleID,
                        TimeUnit  => $GetParam{'EmailTimeUnits'},
                        UserID    => $Self->{UserID},
                    );
                }
            }

            # merge
            if ( $MainTicketID && $MainTicketID ne $TicketID ) {
                $TicketObject->TicketMerge(
                    MainTicketID  => $MainTicketID,
                    MergeTicketID => $TicketID,
                    UserID        => $Self->{UserID},
                );
            }

            # get link object
            my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

            # link all tickets to a parent
            if ( $GetParam{'LinkTogetherParent'} ) {
                my $MainTicketID = $TicketObject->TicketIDLookup(
                    TicketNumber => $GetParam{'LinkTogetherParent'},
                );

                for my $TicketIDPartner (@TicketIDs) {
                    if ( $MainTicketID ne $TicketID ) {
                        $LinkObject->LinkAdd(
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
                        $LinkObject->LinkAdd(
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
                $TicketObject->TicketLockSet(
                    TicketID => $TicketID,
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # call Store() in all ticket bulk modules
            if (@BulkModules) {

                MODULEOBJECT:
                for my $ModuleObject (@BulkModules) {
                    next MODULEOBJECT if !$ModuleObject->can('Store');

                    $ModuleObject->Store(
                        TicketID => $TicketID,
                        UserID   => $Self->{UserID},
                    );
                }
            }

            $ActionFlag = 1;
        }
        $Counter++;
    }

    # redirect
    if ($ActionFlag) {
        my $DestURL = defined $MainTicketID
            ? "Action=AgentTicketZoom;TicketID=$MainTicketID"
            : ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' );

        return $LayoutObject->PopupClose(
            URL => $DestURL,
        );
    }

    $Output .= $Self->_Mask(
        %Param,
        %GetParam,
        %Time,
        TicketIDs     => \@TicketIDSelected,
        LockedTickets => $LockedTickets,
        Errors        => \%Error,
        BulkModules   => \@BulkModules,
    );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );
    return $Output;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( sort keys %{ $Param{Errors} } ) {
            $Param{$KeyError} = $LayoutObject->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    $LayoutObject->Block(
        Name => 'BulkAction',
        Data => \%Param,
    );

    # remember ticket ids
    if ( $Param{TicketIDs} ) {
        for my $TicketID ( @{ $Param{TicketIDs} } ) {
            $LayoutObject->Block(
                Name => 'UsedTicketID',
                Data => {
                    TicketID => $TicketID,
                },
            );
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # build ArticleTypeID string
    my %DefaultNoteTypes = %{ $Config->{ArticleTypes} };
    my %NoteTypes = $TicketObject->ArticleTypeList( Result => 'HASH' );
    for my $KeyNoteType ( sort keys %NoteTypes ) {
        if ( !$DefaultNoteTypes{ $NoteTypes{$KeyNoteType} } ) {
            delete $NoteTypes{$KeyNoteType};
        }
    }

    if ( $Param{ArticleTypeID} ) {
        $Param{NoteStrg} = $LayoutObject->BuildSelection(
            Data       => \%NoteTypes,
            Name       => 'ArticleTypeID',
            SelectedID => $Param{ArticleTypeID},
            Class      => 'Modernize',
        );
    }
    else {
        $Param{NoteStrg} = $LayoutObject->BuildSelection(
            Data          => \%NoteTypes,
            Name          => 'ArticleTypeID',
            SelectedValue => $Config->{ArticleTypeDefault},
            Class         => 'Modernize',
        );
    }

    # build next states string
    if ( $Config->{State} ) {
        my %State;

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        my %StateList = $StateObject->StateGetStatesByType(
            StateType => $Config->{StateType},
            Result    => 'HASH',
            Action    => $Self->{Action},
            UserID    => $Self->{UserID},
        );
        if ( !$Config->{StateDefault} ) {
            $StateList{''} = '-';
        }
        if ( !$Param{StateID} ) {
            if ( $Config->{StateDefault} ) {
                $State{SelectedValue} = $Config->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{StateID};
        }

        $Param{NextStatesStrg} = $LayoutObject->BuildSelection(
            Data => \%StateList,
            Name => 'StateID',
            %State,
            Class => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'State',
            Data => \%Param,
        );

        STATE_ID:
        for my $StateID ( sort keys %StateList ) {
            next STATE_ID if !$StateID;
            my %StateData = $StateObject->StateGet( ID => $StateID );
            next STATE_ID if $StateData{TypeName} !~ /pending/i;
            $Param{DateString} = $LayoutObject->BuildDateSelection(
                %Param,
                Format               => 'DateInputFormatLong',
                DiffTime             => $ConfigObject->Get('Ticket::Frontend::PendingDiffTime') || 0,
                Class                => $Param{Errors}->{DateInvalid} || '',
                Validate             => 1,
                ValidateDateInFuture => 1,
            );
            $LayoutObject->Block(
                Name => 'StatePending',
                Data => \%Param,
            );
            last STATE_ID;
        }
    }

    # types
    if ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} ) {
        my %Type = $TicketObject->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Data         => \%Type,
            PossibleNone => 1,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Class        => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # get needed objects
    my $UserObject  = $Kernel::OM->Get('Kernel::System::User');
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # owner list
    if ( $Config->{Owner} ) {
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1
        );

        # only put possible rw agents to possible owner list
        if ( !$ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            my %AllGroupsMembersNew;
            for my $TicketID ( @{ $Param{TicketIDs} } ) {
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                my $GroupID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
                my %GroupMember = $GroupObject->PermissionGroupGet(
                    GroupID => $GroupID,
                    Type    => 'rw',
                );
                USER_ID:
                for my $UserID ( sort keys %GroupMember ) {
                    next USER_ID if !$AllGroupsMembers{$UserID};
                    $AllGroupsMembersNew{$UserID} = $AllGroupsMembers{$UserID};
                }
                %AllGroupsMembers = %AllGroupsMembersNew;
            }
        }
        $Param{OwnerStrg} = $LayoutObject->BuildSelection(
            Data         => \%AllGroupsMembers,
            Name         => 'OwnerID',
            Translation  => 0,
            SelectedID   => $Param{OwnerID},
            PossibleNone => 1,
            Class        => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }

    # responsible list
    if ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) {
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1
        );

        # only put possible rw agents to possible owner list
        if ( !$ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            my %AllGroupsMembersNew;
            for my $TicketID ( @{ $Param{TicketIDs} } ) {
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                );
                my $GroupID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
                my %GroupMember = $GroupObject->PermissionGroupGet(
                    GroupID => $GroupID,
                    Type    => 'rw',
                );
                USER_ID:
                for my $UserID ( sort keys %GroupMember ) {
                    next USER_ID if !$AllGroupsMembers{$UserID};
                    $AllGroupsMembersNew{$UserID} = $AllGroupsMembers{$UserID};
                }
                %AllGroupsMembers = %AllGroupsMembersNew;
            }
        }
        $Param{ResponsibleStrg} = $LayoutObject->BuildSelection(
            Data => {
                '' => '-',
                %AllGroupsMembers
            },
            Name        => 'ResponsibleID',
            Translation => 0,
            SelectedID  => $Param{ResponsibleID},
            Class       => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
    }

    # build move queue string
    my %MoveQueues = $TicketObject->MoveList(
        UserID => $Self->{UserID},
        Action => $Self->{Action},
        Type   => 'move_into',
    );
    $Param{MoveQueuesStrg} = $LayoutObject->AgentQueueListOption(
        Data           => { %MoveQueues, '' => '-' },
        Multiple       => 0,
        Size           => 0,
        Name           => 'QueueID',
        OnChangeSubmit => 0,
        Class          => 'Modernize',
    );

    # get priority
    if ( $Config->{Priority} ) {
        my %Priority;
        my %PriorityList = $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
            Valid  => 1,
            UserID => $Self->{UserID},
        );
        if ( !$Config->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{PriorityID} ) {
            if ( $Config->{PriorityDefault} ) {
                $Priority{SelectedValue} = $Config->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{PriorityID};
        }
        $Param{PriorityStrg} = $LayoutObject->BuildSelection(
            Data => \%PriorityList,
            Name => 'PriorityID',
            %Priority,
            Class => 'Modernize',

        );
        $LayoutObject->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # show time accounting box
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        $Param{TimeUnitsRequired} = (
            $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            ? 'Validate_DependingRequiredAND Validate_Depending_Subject'
            : ''
        );
        $Param{TimeUnitsRequiredEmail} = (
            $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            ? 'Validate_DependingRequiredAND Validate_Depending_EmailSubject'
            : ''
        );

        if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => { TimeUnitsRequired => $Param{TimeUnitsRequired} },
            );
            $LayoutObject->Block(
                Name => 'TimeUnitsLabelMandatoryEmail',
                Data => { TimeUnitsRequired => $Param{TimeUnitsRequiredEmail} },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
            $LayoutObject->Block(
                Name => 'TimeUnitsLabelEmail',
                Data => \%Param,
            );
        }
        $LayoutObject->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'TimeUnitsEmail',
            Data => \%Param,
        );
    }

    $Param{LinkTogetherYesNoOption} = $LayoutObject->BuildSelection(
        Data       => $ConfigObject->Get('YesNoOptions'),
        Name       => 'LinkTogether',
        SelectedID => $Param{LinkTogether} || 0,
        Class      => 'Modernize',
    );

    $Param{UnlockYesNoOption} = $LayoutObject->BuildSelection(
        Data       => $ConfigObject->Get('YesNoOptions'),
        Name       => 'Unlock',
        SelectedID => $Param{Unlock} || 1,
        Class      => 'Modernize',
    );

    # show spell check
    if ( $LayoutObject->{BrowserSpellChecker} ) {
        $LayoutObject->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # add rich text editor for note & email
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # reload parent window
    if ( $Param{TicketsWereLocked} ) {

        my $URL = $Self->{LastScreenOverview};

        # add session if no cookies are enabled
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $URL .= ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
        }

        $LayoutObject->Block(
            Name => 'ParentReload',
            Data => {
                URL => $URL,
            },
        );

        # show undo&close link
        $LayoutObject->Block(
            Name => 'UndoClosePopup',
            Data => {%Param},
        );
    }
    else {

        # show cancel&close link
        $LayoutObject->Block(
            Name => 'CancelClosePopup',
            Data => {%Param},
        );
    }

    my @BulkModules = @{ $Param{BulkModules} };

    # call Display() in all ticket bulk modules
    if (@BulkModules) {

        my @BulkModuleContent;

        MODULEOBJECT:
        for my $ModuleObject (@BulkModules) {
            next MODULEOBJECT if !$ModuleObject->can('Display');

            my $ModuleContent = $ModuleObject->Display(
                Errors => $Param{Errors},
                UserID => $Self->{UserID},
            );

            push @BulkModuleContent, $ModuleContent;
        }

        $Param{BulkModuleContent} = \@BulkModuleContent;
    }

    # get output back
    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketBulk',
        Data         => \%Param
    );
}

1;
