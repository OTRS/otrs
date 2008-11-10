# --
# Kernel/Modules/AgentTicketPhone.pm - to handle phone calls
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketPhone.pm,v 1.81 2008-11-10 10:34:39 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketPhone;

use strict;
use warnings;

use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Kernel::System::LinkObject;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.81 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject}   = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam = ();
    for (
        qw(AttachmentUpload ArticleID LinkTicketID PriorityID NewUserID
        From Subject Body NextStateID TimeUnits
        Year Month Day Hour Minute
        NewResponsibleID ResponsibleAll OwnerAll TypeID ServiceID SLAID
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
        AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16
        )
        )
    {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # get ticket free text params
    for ( 1 .. 16 ) {
        $GetParam{"TicketFreeKey$_"} = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$_" );
        $GetParam{"TicketFreeText$_"}
            = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$_" );
    }

    # get ticket free time params
    for ( 1 .. 6 ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ "TicketFreeTime" . $_ . $Type } = $Self->{ParamObject}->GetParam(
                Param => "TicketFreeTime" . $_ . $Type,
            );
        }
        $GetParam{ 'TicketFreeTime' . $_ . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $_ ) ) {
            $GetParam{ 'TicketFreeTime' . $_ . 'Used' } = 1;
        }
    }

    # get article free text params
    for ( 1 .. 3 ) {
        $GetParam{"ArticleFreeKey$_"}
            = $Self->{ParamObject}->GetParam( Param => "ArticleFreeKey$_" );
        $GetParam{"ArticleFreeText$_"}
            = $Self->{ParamObject}->GetParam( Param => "ArticleFreeText$_" );
    }

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # if there is no ticket id!
        if ( $Self->{TicketID} && $Self->{Subaction} eq 'Created' ) {

            # notify info
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
            $Output .= $Self->{LayoutObject}->Notify(
                Info => 'Ticket "%s" created!", "' . $Ticket{TicketNumber},
                Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $Ticket{TicketID},
            );
        }

        # store last queue screen
        if ( $Self->{LastScreenOverview} !~ /Action=AgentTicketPhone/ ) {
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenOverview',
                Value     => $Self->{RequestedURL},
            );
        }

        # get split article if given
        # get ArticleID
        my %Article      = ();
        my %CustomerData = ();
        if ( $GetParam{ArticleID} ) {
            %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $GetParam{ArticleID} );
            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );

            # fill free text fields
            for my $Count ( 1 .. 16 ) {
                if ( defined $Article{ 'TicketFreeKey' . $Count } ) {
                    $GetParam{ 'TicketFreeKey' . $Count } = $Article{ 'TicketFreeKey' . $Count };
                }
                if ( defined $Article{ 'TicketFreeText' . $Count } ) {
                    $GetParam{ 'TicketFreeText' . $Count } = $Article{ 'TicketFreeText' . $Count };
                }
            }

            # fill free time fields
            for my $Count ( 1 .. 6 ) {
                if ( defined $Article{ 'TicketFreeTime' . $Count } ) {
                    $GetParam{ 'TicketFreeTime' . $Count . 'Used' } = 1;
                    my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $Article{ 'TicketFreeTime' . $Count },
                    );
                    my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
                        = $Self->{TimeObject}->SystemTime2Date(
                        SystemTime => $SystemTime,
                        );
                    $GetParam{ 'TicketFreeTime' . $Count . 'Year' }   = $Year;
                    $GetParam{ 'TicketFreeTime' . $Count . 'Month' }  = $Month;
                    $GetParam{ 'TicketFreeTime' . $Count . 'Day' }    = $Day;
                    $GetParam{ 'TicketFreeTime' . $Count . 'Hour' }   = $Hour;
                    $GetParam{ 'TicketFreeTime' . $Count . 'Minute' } = $Min;

                    # do agent time zone translation
                    %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
                        %GetParam,
                        Prefix => 'TicketFreeTime' . $Count,
                    );
                }
            }

            # get attachments
            my %ArticleIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
                ArticleID => $GetParam{ArticleID},
                UserID    => $Self->{UserID},
            );
            for my $Index ( keys %ArticleIndex ) {
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $GetParam{ArticleID},
                    FileID    => $Index,
                    UserID    => $Self->{UserID},
                );
                $Self->{UploadCachObject}->FormIDAddFile(
                    FormID => $Self->{FormID},
                    %Attachment,
                );
            }

            # check if original content isn't text/plain or text/html, don't use it
            if ( $Article{'ContentType'} ) {
                if ( $Article{'ContentType'} =~ /text\/html/i ) {
                    $Article{Body} =~ s/\<.+?\>//gs;
                }
                elsif ( $Article{'ContentType'} !~ /text\/plain/i ) {
                    $Article{Body} = '-> no quotable message <-';
                }
            }

            # show customer info
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
                if ( $Article{CustomerUserID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                }
                elsif ( $Article{CustomerID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Article{CustomerID},
                    );
                }
            }
            if ( $Article{CustomerUserID} ) {
                my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                    UserLogin => $Article{CustomerUserID},
                );
                for ( sort keys %CustomerUserList ) {
                    $Article{From} = $CustomerUserList{$_};
                }
            }
        }

        # get default selections
        my %TicketFreeDefault = ();
        for ( 1 .. 16 ) {
            $TicketFreeDefault{ 'TicketFreeKey' . $_ } = $GetParam{ 'TicketFreeKey' . $_ }
                || $Self->{ConfigObject}->Get( 'TicketFreeKey' . $_ . '::DefaultSelection' );
            $TicketFreeDefault{ 'TicketFreeText' . $_ } = $GetParam{ 'TicketFreeText' . $_ }
                || $Self->{ConfigObject}->Get( 'TicketFreeText' . $_ . '::DefaultSelection' );
        }

        # get free text config options
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Action   => $Self->{Action},
                Type     => "TicketFreeKey$_",
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Action   => $Self->{Action},
                Type     => "TicketFreeText$_",
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => {
                %TicketFreeDefault,
                $Self->{UserObject}->GetUserData(
                    UserID => $Self->{UserID},
                    Cached => 1,
                ),
            },
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            %Param,
            Ticket => \%GetParam,
        );

        # get article free text default selections
        my %ArticleFreeDefault = ();
        for ( 1 .. 3 ) {
            $ArticleFreeDefault{ 'ArticleFreeKey' . $_ } = $GetParam{ 'ArticleFreeKey' . $_ }
                || $Self->{ConfigObject}->Get( 'ArticleFreeKey' . $_ . '::DefaultSelection' );
            $ArticleFreeDefault{ 'ArticleFreeText' . $_ } = $GetParam{ 'ArticleFreeText' . $_ }
                || $Self->{ConfigObject}->Get( 'ArticleFreeText' . $_ . '::DefaultSelection' );
        }

        # article free text
        my %ArticleFreeText = ();
        for ( 1 .. 3 ) {
            $ArticleFreeText{"ArticleFreeKey$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "ArticleFreeKey$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
            );
            $ArticleFreeText{"ArticleFreeText$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "ArticleFreeText$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
            );
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config => \%ArticleFreeText,
            Article => { %GetParam, %ArticleFreeDefault, },
        );

        # get all attachments meta data
        my @Attachments
            = $Self->{UploadCachObject}->FormIDGetAllFilesMeta( FormID => $Self->{FormID} );

        # html output
        $Output .= $Self->_MaskPhoneNew(
            QueueID    => $Self->{QueueID},
            NextStates => $Self->_GetNextStates(
                %GetParam,
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
                QueueID => $Self->{QueueID} || 1,
            ),
            Priorities => $Self->_GetPriorities(
                %GetParam,
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
                QueueID => $Self->{QueueID} || 1,
            ),
            Types      => $Self->_GetTypes(
                %GetParam,
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
                QueueID => $Self->{QueueID} || 1,
            ),
            Services   => $Self->_GetServices(
                %GetParam,
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
                QueueID => $Self->{QueueID} || 1,
            ),
            SLAs => $Self->_GetSLAs(
                %GetParam,
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
                QueueID => $Self->{QueueID} || 1,
            ),
            Users            => $Self->_GetUsers( QueueID => $Self->{QueueID} ),
            ResponsibleUsers => $Self->_GetUsers( QueueID => $Self->{QueueID} ),
            To => $Self->_GetTos(
                %GetParam,
                CustomerUserID => $CustomerData{CustomerUserLogin} || '',
                QueueID => $Self->{QueueID},
            ),
            From    => $Article{From},
            Subject => $Article{Subject}
                || $Self->{LayoutObject}->Output( Template => $Self->{Config}->{Subject} ),
            Body => $Article{Body}
                || $Self->{LayoutObject}->Output( Template => $Self->{Config}->{Body} ),
            CustomerID   => $Article{CustomerID},
            CustomerUser => $Article{CustomerUserID},
            CustomerData => \%CustomerData,
            Attachments  => \@Attachments,
            LinkTicketID => $GetParam{LinkTicketID} || '',

            #            %GetParam,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # create new ticket and article
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {
        my %Error     = ();
        my %StateData = ();
        if ( $GetParam{NextStateID} ) {
            %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NextStateID},
            );
        }
        my $NextState = $StateData{Name} || '';
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'CustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'PreSelectedCustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $CustomerID = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName' )
            || 0;

        if ( $Self->{ParamObject}->GetParam( Param => 'OwnerAllRefresh' ) ) {
            $GetParam{OwnerAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $Self->{ParamObject}->GetParam( Param => 'ResponsibleAllRefresh' ) ) {
            $GetParam{ResponsibleAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $Self->{ParamObject}->GetParam( Param => 'ClearFrom' ) ) {
            $GetParam{From} = '';
            $ExpandCustomerName = 3;
        }
        for ( 1 .. 2 ) {
            my $Item = $Self->{ParamObject}->GetParam( Param => "ExpandCustomerName$_" ) || 0;
            if ( $_ == 1 && $Item ) {
                $ExpandCustomerName = 1;
            }
            elsif ( $_ == 2 && $Item ) {
                $ExpandCustomerName = 2;
            }
        }

        # rewrap body if exists
        if ( $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }

        # check pending date
        if ( $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                $Error{"Date invalid"} = 'invalid';
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                $Error{"Date invalid"} = 'invalid';
            }
        }

        # attachment delete
        for ( 1 .. 16 ) {
            if ( $GetParam{"AttachmentDelete$_"} ) {
                $Error{AttachmentDelete} = 1;
                $Self->{UploadCachObject}->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $_,
                );
            }
        }

        # attachment upload
        if ( $GetParam{AttachmentUpload} ) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => "file_upload",
                Source => 'string',
            );
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get free text config options
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeKey$_",
                Action   => $Self->{Action},
                QueueID  => $NewQueueID || 0,
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeText$_",
                Action   => $Self->{Action},
                QueueID  => $NewQueueID || 0,
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}{'TicketFreeText'}->{$_} == 2
                && $GetParam{"TicketFreeText$_"} eq ''
                && $ExpandCustomerName == 0
                )
            {
                $Error{"TicketFreeTextField$_ invalid"} = 'invalid';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam, );

        # article free text
        my %ArticleFreeText = ();
        for ( 1 .. 3 ) {
            $ArticleFreeText{"ArticleFreeKey$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "ArticleFreeKey$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );
            $ArticleFreeText{"ArticleFreeText$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "ArticleFreeText$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => \%GetParam,
        );

        # expand customer name
        my %CustomerUserData = ();
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList = ();
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $GetParam{From},
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for ( keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$_};
                $Param{CustomerUserListLastUser} = $_;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $GetParam{From} = $Param{CustomerUserListLast};
                $Error{"ExpandCustomerName"} = 1;
                my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                }
                if ( $CustomerUserData{UserLogin} ) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                }
            }

            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {

                # don't check email syntax on multi customer select
                $Self->{ConfigObject}->Set( Key => 'CheckEmailAddresses', Value => 0 );
                $CustomerID = '';
                $Param{"FromOptions"} = \%CustomerUserList;

                # clear from if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{From} = '';
                }
                $Error{"ExpandCustomerName"} = 1;
            }
        }

        # get from and customer id if customer user is given
        elsif ( $ExpandCustomerName == 2 ) {
            %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            for ( keys %CustomerUserList ) {
                $GetParam{From} = $CustomerUserList{$_};
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            }
            if ( $CustomerUserData{UserLogin} ) {
                $CustomerUser = $CustomerUserData{UserLogin};
            }
            $Error{ExpandCustomerName} = 1;
        }

        # if a new destination queue is selected
        elsif ( $ExpandCustomerName == 3 ) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }

        # 'just' no submit
        elsif ( $ExpandCustomerName == 4 ) {
            $Error{NoSubmit} = 1;
        }

        # show customer info
        my %CustomerData = ();
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
            if ( $CustomerUser || $SelectedCustomerUser ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser || $SelectedCustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }

        # check email address
        for my $Email ( Mail::Address->parse( $GetParam{From} ) ) {
            if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                $Error{'From invalid'} .= $Self->{CheckItemObject}->CheckError();
            }
        }
        if ( !$GetParam{From} && $ExpandCustomerName != 1 && $ExpandCustomerName == 0 ) {
            $Error{'From invalid'} = 'invalid';
        }
        if ( !$GetParam{Subject} && $ExpandCustomerName == 0 ) {
            $Error{'Subject invalid'} = 'invalid';
        }
        if ( !$NewQueueID && $ExpandCustomerName == 0 ) {
            $Error{'Destination invalid'} = 'invalid';
        }
        if (
            $Self->{ConfigObject}->Get('Ticket::Service')
            && $GetParam{SLAID}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'Service invalid'} = 'invalid';
        }

        if (%Error) {

            # get services
            my $Services = $Self->_GetServices(
                CustomerUserID => $CustomerUser || '',
                QueueID        => $NewQueueID   || 1,
            );

            # reset previous ServiceID to reset SLA-List if no service is selected
            if ( !$GetParam{ServiceID} || !$Services->{ $GetParam{ServiceID} } ) {
                $GetParam{ServiceID} = '';
            }

            # header
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            # html output
            $Output .= $Self->_MaskPhoneNew(
                QueueID => $Self->{QueueID},
                Users =>
                    $Self->_GetUsers( QueueID => $NewQueueID, AllUsers => $GetParam{OwnerAll} ),
                UserSelected     => $GetParam{NewUserID},
                ResponsibleUsers => $Self->_GetUsers(
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{ResponsibleAll}
                ),
                ResponsibleUserSelected => $GetParam{NewResponsibleID},
                NextStates              => $Self->_GetNextStates(
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                NextState               => $NextState,
                Priorities              => $Self->_GetPriorities(
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Types                   => $Self->_GetTypes(
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Services                => $Services,
                SLAs => $Self->_GetSLAs(
                    %GetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                CustomerID => $Self->{LayoutObject}->Ascii2Html( Text => $CustomerID ),
                CustomerUser => $CustomerUser,
                CustomerData => \%CustomerData,
                FromOptions  => $Param{FromOptions},
                To           => $Self->_GetTos( QueueID => $NewQueueID ),
                ToSelected   => $Dest,
                Errors       => \%Error,
                Attachments  => \@Attachments,
                %GetParam,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );

            # show customer tickets
            my @TicketIDs = ();
            if ( $CustomerUser && $Self->{Config}->{ShownCustomerTickets} ) {

                # get secondary customer ids
                my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(
                    User => $CustomerUser,
                );

                # get own customer id
                my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser,
                );
                if ( $CustomerData{UserCustomerID} ) {
                    push( @CustomerIDs, $CustomerData{UserCustomerID} );
                }

                if (@CustomerIDs) {
                    @TicketIDs = $Self->{TicketObject}->TicketSearch(
                        Result     => 'ARRAY',
                        Limit      => $Self->{Config}->{ShownCustomerTickets},
                        CustomerID => \@CustomerIDs,
                        UserID     => $Self->{UserID},
                        Permission => 'ro',
                    );
                }
            }
            for my $TicketID (@TicketIDs) {
                my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                    TicketID => $TicketID,
                );

                # get acl actions
                $Self->{TicketObject}->TicketAcl(
                    Data          => '-',
                    Action        => $Self->{Action},
                    TicketID      => $TicketID,
                    ReturnType    => 'Action',
                    ReturnSubType => '-',
                    UserID        => $Self->{UserID},
                );
                my %AclAction = $Self->{TicketObject}->TicketAclActionData();

                # ticket title
                if ( $Self->{ConfigObject}->Get('Ticket::Frontend::Title') ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'Title',
                        Data => { %Param, %Article },
                    );
                }

                # run ticket menu modules
                if (
                    ref( $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') ) eq 'HASH'
                    )
                {
                    my %Menus = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule') };
                    my $Counter = 0;
                    for my $Menu ( sort keys %Menus ) {

                        # load module
                        if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                            my $Object = $Menus{$Menu}->{Module}->new(
                                %{$Self},
                                TicketID => $TicketID,
                            );

                            # run module
                            $Counter = $Object->Run(
                                %Param,
                                TicketID => $TicketID,
                                Ticket   => \%Article,
                                Counter  => $Counter,
                                ACL      => \%AclAction,
                                Config   => $Menus{$Menu},
                            );
                        }
                        else {
                            return $Self->{LayoutObject}->FatalError();
                        }
                    }
                }
                for (qw(From To Cc Subject)) {
                    if ( $Article{$_} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Row',
                            Data => {
                                Key   => $_,
                                Value => $Article{$_},
                            },
                        );
                    }
                }
                for ( 1 .. 3 ) {
                    if ( $Article{"FreeText$_"} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'ArticleFreeText',
                            Data => {
                                Key   => $Article{"FreeKey$_"},
                                Value => $Article{"FreeText$_"},
                            },
                        );
                    }
                }
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketOverviewMedium',
                    Data         => {
                        %AclAction,
                        %Article,
                        Age =>
                            $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' )
                            || '',
                        }
                );
            }
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            Title        => $GetParam{Subject},
            QueueID      => $NewQueueID,
            Subject      => $GetParam{Subject},
            Lock         => 'unlock',
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            StateID      => $GetParam{NextStateID},
            PriorityID   => $GetParam{PriorityID},
            OwnerID      => 1,
            CustomerNo   => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            UserID       => $Self->{UserID},
        );

        # set ticket free text
        for ( 1 .. 16 ) {
            if ( defined( $GetParam{"TicketFreeKey$_"} ) ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $GetParam{"TicketFreeKey$_"},
                    Value    => $GetParam{"TicketFreeText$_"},
                    Counter  => $_,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set ticket free time
        for ( 1 .. 6 ) {
            if (
                defined( $GetParam{ 'TicketFreeTime' . $_ . 'Year' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Month' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Day' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Hour' } )
                && defined( $GetParam{ 'TicketFreeTime' . $_ . 'Minute' } )
                )
            {
                my %Time;
                $Time{ 'TicketFreeTime' . $_ . 'Year' }    = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Month' }   = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Day' }     = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Hour' }    = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Minute' }  = 0;
                $Time{ 'TicketFreeTime' . $_ . 'Secunde' } = 0;

                if ( $GetParam{ 'TicketFreeTime' . $_ . 'Used' } ) {
                    %Time = $Self->{LayoutObject}->TransfromDateSelection(
                        %GetParam,
                        Prefix => 'TicketFreeTime' . $_,
                    );
                }
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %Time,
                    Prefix   => 'TicketFreeTime',
                    TicketID => $TicketID,
                    Counter  => $_,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ( $GetParam{NewUserID} ) {
            $NoAgentNotify = 1;
        }
        if (
            my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                NoAgentNotify    => $NoAgentNotify,
                TicketID         => $TicketID,
                ArticleType      => $Self->{Config}->{ArticleType},
                SenderType       => $Self->{Config}->{SenderType},
                From             => $GetParam{From},
                To               => $To,
                Subject          => $GetParam{Subject},
                Body             => $GetParam{Body},
                ContentType      => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID           => $Self->{UserID},
                HistoryType      => $Self->{Config}->{HistoryType},
                HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
                AutoResponseType => 'auto reply',
                OrigHeader       => {
                    From    => $GetParam{From},
                    To      => $GetParam{To},
                    Subject => $GetParam{Subject},
                    Body    => $GetParam{Body},
                },
                Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
            )
            )
        {

            # set article free text
            for ( 1 .. 3 ) {
                if ( defined( $GetParam{"ArticleFreeKey$_"} ) ) {
                    $Self->{TicketObject}->ArticleFreeTextSet(
                        TicketID  => $TicketID,
                        ArticleID => $ArticleID,
                        Key       => $GetParam{"ArticleFreeKey$_"},
                        Value     => $GetParam{"ArticleFreeText$_"},
                        Counter   => $_,
                        UserID    => $Self->{UserID},
                    );
                }
            }

            # set owner (if new user id is given)
            if ( $GetParam{NewUserID} ) {
                $Self->{TicketObject}->OwnerSet(
                    TicketID  => $TicketID,
                    NewUserID => $GetParam{NewUserID},
                    UserID    => $Self->{UserID},
                );

                # set lock
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
            }

            # else set owner to current agent but do not lock it
            else {
                $Self->{TicketObject}->OwnerSet(
                    TicketID           => $TicketID,
                    NewUserID          => $Self->{UserID},
                    SendNoNotification => 1,
                    UserID             => $Self->{UserID},
                );
            }

            # set responsible (if new user id is given)
            if ( $GetParam{NewResponsibleID} ) {
                $Self->{TicketObject}->ResponsibleSet(
                    TicketID  => $TicketID,
                    NewUserID => $GetParam{NewResponsibleID},
                    UserID    => $Self->{UserID},
                );
            }

            # time accounting
            if ( $GetParam{TimeUnits} ) {
                $Self->{TicketObject}->TicketAccountTime(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    TimeUnit  => $GetParam{TimeUnits},
                    UserID    => $Self->{UserID},
                );
            }

            # get pre loaded attachment
            my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
                FormID => $Self->{FormID},
            );
            for my $Ref (@AttachmentData) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %{$Ref},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # get submit attachment
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'file_upload',
                Source => 'String',
            );
            if (%UploadStuff) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %UploadStuff,
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove( FormID => $Self->{FormID} );

            # link tickets
            if (
                $GetParam{LinkTicketID}
                && $Self->{Config}->{SplitLinkType}
                && $Self->{Config}->{SplitLinkType}->{LinkType}
                && $Self->{Config}->{SplitLinkType}->{Direction}
                )
            {

                my $SourceKey = $GetParam{LinkTicketID};
                my $TargetKey = $TicketID;

                if ( $Self->{Config}->{SplitLinkType}->{Direction} eq 'Source' ) {
                    $SourceKey = $TicketID;
                    $TargetKey = $GetParam{LinkTicketID};
                }

                # link the tickets
                $Self->{LinkObject}->LinkAdd(
                    SourceObject => 'Ticket',
                    SourceKey    => $SourceKey,
                    TargetObject => 'Ticket',
                    TargetKey    => $TargetKey,
                    Type         => $Self->{Config}->{SplitLinkType}->{LinkType} || 'Normal',
                    State        => 'Valid',
                    UserID       => $Self->{UserID},
                );
            }

            # should i set an unlock?
            my %StateData = $Self->{StateObject}->StateGet( ID => $GetParam{NextStateID} );
            if ( $StateData{TypeName} =~ /^close/i ) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time
            elsif ( $StateData{TypeName} =~ /^pending/i ) {
                $Self->{TicketObject}->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $TicketID,
                    %GetParam,
                );
            }

            # get redirect screen
            my $NextScreen = $Self->{UserCreateNextMask}
                || $Self->{ConfigObject}->Get('PreferencesGroups')->{CreateNextMask}->{DataSelected}
                || 'AgentTicketPhone';

            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$NextScreen&Subaction=Created&TicketID=$TicketID",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest         = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' );
        my $QueueID      = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
        }
        my $Users = $Self->_GetUsers(
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $ResponsibleUsers = $Self->_GetUsers(
            QueueID  => $QueueID,
            AllUsers => $GetParam{ResponsibleAll},
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID => $QueueID || 1,
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID => $QueueID || 1,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID => $QueueID || 1,
        );

        # get free text config options
        my @TicketFreeTextConfig = ();
        for ( 1 .. 16 ) {
            my $ConfigKey = $Self->{TicketObject}->TicketFreeTextGet(
                %GetParam,
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeKey$_",
                Action   => $Self->{Action},
                QueueID  => $QueueID || 0,
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerUser || '',
            );
            if ($ConfigKey) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => "TicketFreeKey$_",
                        Data        => $ConfigKey,
                        SelectedID  => $GetParam{"TicketFreeKey$_"},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
            my $ConfigValue = $Self->{TicketObject}->TicketFreeTextGet(
                %GetParam,
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeText$_",
                Action   => $Self->{Action},
                QueueID  => $QueueID || 0,
                UserID   => $Self->{UserID},
                CustomerUserID => $CustomerUser || '',
            );
            if ($ConfigValue) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => "TicketFreeText$_",
                        Data        => $ConfigValue,
                        SelectedID  => $GetParam{"TicketFreeText$_"},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
        }
        my $JSON = $Self->{LayoutObject}->BuildJSON(
            [
                {
                    Name         => 'NewUserID',
                    Data         => $Users,
                    SelectedID   => $GetParam{NewUserID},
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name        => 'NextStateID',
                    Data        => $NextStates,
                    SelectedID  => $GetParam{NextStateID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name        => 'PriorityID',
                    Data        => $Priorities,
                    SelectedID  => $GetParam{PriorityID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name         => 'ServiceID',
                    Data         => $Services,
                    SelectedID   => $GetParam{ServiceID},
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
                @TicketFreeTextConfig,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates = ();
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->StateList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers       = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for ( keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $_ ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$_};
            }
        }
    }

    # show all system users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'rw',
            Result  => 'HASH',
            Cached  => 1,
        );
        for ( keys %MemberList ) {
            if ( $AllGroupsMembers{$_} ) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
    }
    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities = ();

    # get priority
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->PriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    my %Type = ();

    # get type
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    my %Service = ();

    # get service
    if ( ( $Param{QueueID} || $Param{TicketID} ) && $Param{CustomerUserID} ) {
        %Service = $Self->{TicketObject}->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    my %SLA = ();

    # get sla
    if ( $Param{ServiceID} ) {
        %SLA = $Self->{TicketObject}->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # check own selection
    my %NewTos = ();
    if ( $Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'} ) {
        %NewTos = %{ $Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'} };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos = ();
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Tos = $Self->{TicketObject}->MoveList(
                Type    => 'create',
                Action  => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID  => $Self->{UserID},
            );
        }
        else {
            %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }

        # get create permission queues
        my %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'create',
            Result => 'HASH',
            Cached => 1,
        );

        # build selection string
        for my $QueueID ( keys %Tos ) {
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next if !$UserGroups{ $QueueData{GroupID} };

            my $String = $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(
                    ID => $Tos{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$QueueID} = $String;
        }
    }

    # add empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}

sub _MaskPhoneNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build customer search autocomplete field
    my $AutoCompleteConfig = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');
    if ( $AutoCompleteConfig->{Active} ) {
        $Self->{LayoutObject}->Block(
            Name => 'CustomerSearchAutoComplete',
            Data => {
                minQueryLength => $AutoCompleteConfig->{MinQueryLength} || 2,
                queryDelay     => $AutoCompleteConfig->{QueryDelay}     || 0.1,
                typeAhead      => $AutoCompleteConfig->{TypeAhead}      || 'false',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerSearchAutoCompleteDivStart',
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerSearchAutoCompleteDivEnd',
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'SearchCustomerButton',
        );
    }

    # build string
    $Param{'OptionStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{Users},
        SelectedID   => $Param{UserSelected},
        Translation  => 0,
        Name         => 'NewUserID',
        PossibleNone => 1,
    );

    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{NextStates},
        Name          => 'NextStateID',
        Translation   => 1,
        SelectedValue => $Param{NextState} || $Self->{Config}->{StateDefault},
    );

    # build from string
    if ( $Param{FromOptions} && %{ $Param{FromOptions} } ) {
        $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data        => $Param{FromOptions},
            Name        => 'CustomerUser',
            Translation => 0,
            Max         => 70,
        );
    }

    # build so string
    my %NewTo = ();
    if ( $Param{To} ) {
        for ( keys %{ $Param{To} } ) {
            $NewTo{"$_||$Param{To}->{$_}"} = $Param{To}->{$_};
        }
    }
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Name           => 'Dest',
            SelectedID     => $Param{ToSelected},
            OnChangeSubmit => 0,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
    }
    else {
        $Param{'ToStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%NewTo,
            Name        => 'Dest',
            SelectedID  => $Param{ToSelected},
            Translation => 0,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
    }

    # customer info string
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max  => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = '* ' . $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Param{'TypeStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Types},
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $Param{'ServiceStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Services},
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%Param},
        );
        $Param{'SLAStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{SLAs},
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewResponsibleID',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'Dest',
                    'SelectedCustomerUser',
                    'NextStateID',
                    'PriorityID',
                    'ServiceID',
                    'SLAID',
                    'OwnerAll',
                    'ResponsibleAll',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketSLA',
            Data => {%Param},
        );
    }

    # build priority string
    if ( !$Param{PriorityID} ) {
        $Param{Priority} = $Self->{Config}->{Priority};
    }
    $Param{'PriorityStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{Priorities},
        Name          => 'PriorityID',
        SelectedID    => $Param{PriorityID},
        SelectedValue => $Param{Priority},
        Translation   => 1,
    );

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
    );

    # to update
    if ( !$Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ToUpdateSubmit',
            Data => \%Param,
        );
    }

    # show owner selection
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
        if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
            $Self->{LayoutObject}->Block(
                Name => 'OwnerSelectionAllJS',
                Data => {},
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'OwnerSelectionAllSubmit',
                Data => {},
            );
        }
    }

    # show responsible selection
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        &&
        $Self->{ConfigObject}->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{'ResponsibleOptionStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{ResponsibleUsers},
            SelectedID   => $Param{ResponsibleUserSelected},
            Name         => 'NewResponsibleID',
            Translation  => 0,
            PossibleNone => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
        if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ResponsibleSelectionAllJS',
                Data => {},
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ResponsibleSelectionAllSubmit',
                Data => {},
            );
        }
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        if ( $Self->{Config}->{'TicketFreeText'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText',
                Data => {
                    TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                    TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                    Count               => $Count,
                    %Param,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }
    for my $Count ( 1 .. 6 ) {
        if ( $Self->{Config}->{'TicketFreeTime'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                    TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                    Count             => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }

    # article free text
    for my $Count ( 1 .. 3 ) {
        if ( $Self->{Config}->{'ArticleFreeText'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFreeText',
                Data => {
                    ArticleFreeKeyField  => $Param{ 'ArticleFreeKeyField' . $Count },
                    ArticleFreeTextField => $Param{ 'ArticleFreeTextField' . $Count },
                    Count                => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFreeText' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # show spell check
    if (
        $Self->{ConfigObject}->Get('SpellChecker')
        && $Self->{LayoutObject}->{BrowserJavaScriptSupport}
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show attachments
    for my $DataRef ( @{ $Param{Attachments} } ) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }

    # java script check for required free text fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeText} } ) {
        if ( $Self->{Config}->{TicketFreeText}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextCheckJs',
                Data => {
                    TicketFreeTextField => "TicketFreeText$Key",
                    TicketFreeKeyField  => "TicketFreeKey$Key",
                },
            );
        }
    }

    # java script check for required free time fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeTime} } ) {
        if ( $Self->{Config}->{TicketFreeTime}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTimeCheckJs',
                Data => {
                    TicketFreeTimeCheck => 'TicketFreeTime' . $Key . 'Used',
                    TicketFreeTimeField => 'TicketFreeTime' . $Key,
                    TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Key ),
                },
            );
        }
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketPhone', Data => \%Param );
}

1;
