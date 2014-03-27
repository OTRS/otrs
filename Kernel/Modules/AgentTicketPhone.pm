# --
# Kernel/Modules/AgentTicketPhone.pm - to handle phone calls
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketPhone.pm,v 1.178.2.7 2012-03-05 09:48:08 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
$VERSION = qw($Revision: 1.178.2.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam;
    for my $Key (
        qw(ArticleID LinkTicketID PriorityID NewUserID
        From Subject Body NextStateID TimeUnits
        Year Month Day Hour Minute
        NewResponsibleID ResponsibleAll OwnerAll TypeID ServiceID SLAID
        )
        )
    {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # get ticket free time params
    for my $Count ( 1 .. 6 ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ "TicketFreeTime" . $Count . $Type } = $Self->{ParamObject}->GetParam(
                Param => "TicketFreeTime" . $Count . $Type,
            );
        }
        $GetParam{ 'TicketFreeTime' . $Count . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Used' } = 1;
        }

        if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Required' } = 1;
        }
    }

    # get article free text params
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
        );
    }

    # transform free time, time stamp based on user time zone
    for my $Count ( 1 .. 6 ) {
        my $Prefix = 'TicketFreeTime' . $Count;
        next if !$GetParam{ $Prefix . 'Year' };
        next if !$GetParam{ $Prefix . 'Month' };
        next if !$GetParam{ $Prefix . 'Day' };
        next if !$GetParam{ $Prefix . 'Hour' };
        next if !$GetParam{ $Prefix . 'Minute' };
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
            Prefix => $Prefix
        );
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
                Link => '$Env{"Baselink"}Action=AgentTicketZoom;TicketID=' . $Ticket{TicketID},
            );
        }

        # store last queue screen
        if (
            $Self->{LastScreenOverview} !~ /Action=AgentTicketPhone/
            && $Self->{RequestedURL} !~ /Action=AgentTicketPhone.*LinkTicketID=/
            )
        {
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenOverview',
                Value     => $Self->{RequestedURL},
            );
        }

        # get split article if given
        # get ArticleID
        my %Article;
        my %CustomerData;
        if ( $GetParam{ArticleID} ) {

            my $Access = $Self->{TicketObject}->TicketPermission(
                Type     => 'ro',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $Self->{LayoutObject}->NoPermission(
                    Message    => "You need ro permission!",
                    WithHeader => 'yes',
                );
            }

            %Article = $Self->{TicketObject}->ArticleGet(
                ArticleID => $GetParam{ArticleID},
            );

            # Check if article is from the same TicketID as we checked permissions for.
            if ( $Article{TicketID} ne $Self->{TicketID} ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Article does not belong to ticket $Self->{TicketID}!",
                );
            }

            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );

            # fill free text fields
            for my $Count ( 1 .. 16 ) {
                my $Key  = 'TicketFreeKey' . $Count;
                my $Text = 'TicketFreeText' . $Count;
                if ( defined $Article{$Key} ) {
                    $GetParam{$Key} = $Article{$Key};
                }
                if ( defined $Article{$Text} ) {
                    $GetParam{$Text} = $Article{$Text};
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
                }
            }

            # body preparation for plain text processing
            $Article{Body} = $Self->{LayoutObject}->ArticleQuote(
                TicketID           => $Article{TicketID},
                ArticleID          => $GetParam{ArticleID},
                FormID             => $Self->{FormID},
                UploadCacheObject  => $Self->{UploadCacheObject},
                AttachmentsInclude => 1,
            );
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $Article{ContentType} = 'text/html';
            }
            else {
                $Article{ContentType} = 'text/plain';
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
                for my $KeyCustomerUserList ( sort keys %CustomerUserList ) {
                    $Article{From} = $CustomerUserList{$KeyCustomerUserList};
                }
            }
        }

        # get default selections
        my %TicketFreeDefault;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;

            $TicketFreeDefault{$Key} = $GetParam{$Key}
                || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $TicketFreeDefault{$Text} = $GetParam{$Text}
                || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

        # get free text config options
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Key,
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerData{UserLogin} || '',
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Text,
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerData{UserLogin} || '',
            );

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                $TicketFreeText{Required}->{$Count} = 1;
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => {
                %TicketFreeDefault,
                $Self->{UserObject}->GetUserData(
                    UserID => $Self->{UserID},
                ),
            },
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            %Param,
            Ticket => \%GetParam,
        );

        # get article free text default selections
        my %ArticleFreeDefault;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeDefault{$Key} = $GetParam{$Key}
                || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $ArticleFreeDefault{$Text} = $GetParam{$Text}
                || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

        # article free text
        my %ArticleFreeText;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Key,
                Action         => $Self->{Action},
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerData{UserLogin} || '',
            );
            $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Text,
                Action         => $Self->{Action},
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerData{UserLogin} || '',
            );

            # If Key has value 2, this means that the field is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config => \%ArticleFreeText,
            Article => { %GetParam, %ArticleFreeDefault, },
        );

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get and format default subject and body
        my $Subject = $Article{Subject};
        if ( !$Subject ) {
            $Subject = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Subject} || '',
            );
        }
        my $Body = $Article{Body} || '';
        if ( !$Body ) {
            $Body = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Body} || '',
            );
        }

        # make sure body is rich text (if body is based on config)
        if ( !$GetParam{ArticleID} && $Self->{LayoutObject}->{BrowserRichText} ) {
            $Body = $Self->{LayoutObject}->Ascii2RichText(
                String => $Body,
            );
        }

        # html output
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerData{UserLogin} || '',
            QueueID        => $Self->{QueueID}         || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerData{UserLogin} || '',
            QueueID        => $Self->{QueueID}         || 1,
            Services       => $Services,
        );
        $Output .= $Self->_MaskPhoneNew(
            QueueID    => $Self->{QueueID},
            NextStates => $Self->_GetNextStates(
                %GetParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1,
            ),
            Priorities => $Self->_GetPriorities(
                %GetParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1,
            ),
            Types => $Self->_GetTypes(
                %GetParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1,
            ),
            Services         => $Services,
            SLAs             => $SLAs,
            Users            => $Self->_GetUsers( QueueID => $Self->{QueueID} ),
            ResponsibleUsers => $Self->_GetUsers( QueueID => $Self->{QueueID} ),
            To               => $Self->_GetTos(
                %GetParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID => $Self->{QueueID},
            ),
            From         => $Article{From},
            Subject      => $Subject,
            Body         => $Body,
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

        my %Error;
        my %StateData;
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
        for my $Count ( 1 .. 2 ) {
            my $Item = $Self->{ParamObject}->GetParam( Param => "ExpandCustomerName$Count" ) || 0;
            if ( $Count == 1 && $Item ) {
                $ExpandCustomerName = 1;
            }
            elsif ( $Count == 2 && $Item ) {
                $ExpandCustomerName = 2;
            }
        }

        # rewrap body if exists
        if ( $Self->{LayoutObject}->{BrowserRichText} && $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }

        # If is an action about attachments
        my $IsUpload = 0;

        # attachment delete
        for my $Count ( 1 .. 16 ) {
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
            next if !$Delete;
            $Error{AttachmentDelete} = 1;
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Count,
            );
            $IsUpload = 1;
        }

        # attachment upload
        if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
            $IsUpload                = 1;
            %Error                   = ();
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'FileUpload',
                Source => 'string',
            );
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check pending date
        if ( !$ExpandCustomerName && $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                if ( $IsUpload == 0 ) {
                    $Error{DateInvalid} = ' ServerError';
                }
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                if ( $IsUpload == 0 ) {
                    $Error{DateInvalid} = ' ServerError';
                }
            }
        }

        # get free text config options
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Key,
                Action         => $Self->{Action},
                QueueID        => $NewQueueID || 0,
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Text,
                Action         => $Self->{Action},
                QueueID        => $NewQueueID || 0,
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                $TicketFreeText{Required}->{$Count} = 1;
            }

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}->{TicketFreeText}->{$Count} == 2
                && $GetParam{$Text} eq ''
                && $ExpandCustomerName == 0
                && $IsUpload == 0
                )
            {
                $TicketFreeText{Error}->{$Count} = 1;
                $Error{$Text} = 'ServerError';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam, );

        # article free text
        my %ArticleFreeText;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Key,
                Action         => $Self->{Action},
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );
            $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Text,
                Action         => $Self->{Action},
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
            );

            # If Key has value 2, this means that the field is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }

            # check required ArticleTextField (if configured)
            if (
                $Self->{Config}->{ArticleFreeText}->{$Count} == 2
                && $GetParam{$Text} eq ''
                && $ExpandCustomerName == 0
                && $IsUpload == 0
                )
            {
                $ArticleFreeText{Error}->{$Count} = 1;
                $Error{$Text} = 'ServerError';
            }
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => \%GetParam,
        );

        # expand customer name
        my %CustomerUserData;
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList;
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $GetParam{From},
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for my $KeyCustomerUser ( keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$KeyCustomerUser};
                $Param{CustomerUserListLastUser} = $KeyCustomerUser;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $GetParam{From}            = $Param{CustomerUserListLast};
                $Error{ExpandCustomerName} = 1;
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

                # clear from if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{From} = '';
                }
                $Error{ExpandCustomerName} = 1;
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
            for my $KeyCustomerUser ( keys %CustomerUserList ) {
                $GetParam{From} = $CustomerUserList{$KeyCustomerUser};
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
        my %CustomerData;
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
                $Error{ErrorType}   = $Self->{CheckItemObject}->CheckErrorType() . 'ServerErrorMsg';
                $Error{FromInvalid} = ' ServerError';
            }
        }

        if ( !$IsUpload && !$ExpandCustomerName ) {
            if ( !$GetParam{From} )
            {
                $Error{'FromInvalid'} = ' ServerError';
            }
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = ' ServerError';
            }
            if ( !$NewQueueID ) {
                $Error{'DestinationInvalid'} = ' ServerError';
            }
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $GetParam{SLAID}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }
            if ( ( !$GetParam{TypeID} ) && ( $Self->{ConfigObject}->Get('Ticket::Type') ) ) {
                $Error{'TypeIDInvalid'} = ' ServerError';
            }
            if ( !$GetParam{Body} ) {
                $Error{'RichTextInvalid'} = ' ServerError';
            }
            if (
                $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
                && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                && $GetParam{TimeUnits} eq ''
                )
            {
                $Error{'TimeUnitsInvalid'} = ' ServerError';
            }
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

            my $SLAs = $Self->_GetSLAs(
                %GetParam,
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                QueueID        => $NewQueueID   || 1,
                Services       => $Services,
            );

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
                NextState  => $NextState,
                Priorities => $Self->_GetPriorities(
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Types => $Self->_GetTypes(
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Services     => $Services,
                SLAs         => $SLAs,
                CustomerID   => $Self->{LayoutObject}->Ascii2Html( Text => $CustomerID ),
                CustomerUser => $CustomerUser,
                CustomerData => \%CustomerData,
                To           => $Self->_GetTos( QueueID => $NewQueueID ),
                ToSelected   => $Dest,
                Errors       => \%Error,
                Attachments  => \@Attachments,
                %GetParam,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );

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
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $GetParam{$Key},
                    Value    => $GetParam{$Text},
                    Counter  => $Count,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set ticket free time
        for my $Count ( 1 .. 6 ) {
            my $Prefix = 'TicketFreeTime' . $Count;
            next if !defined $GetParam{ $Prefix . 'Year' };
            next if !defined $GetParam{ $Prefix . 'Month' };
            next if !defined $GetParam{ $Prefix . 'Day' };
            next if !defined $GetParam{ $Prefix . 'Hour' };
            next if !defined $GetParam{ $Prefix . 'Minute' };

            # set time stamp to NULL if field is not used/checked
            if ( !$GetParam{ $Prefix . 'Used' } ) {
                $GetParam{ $Prefix . 'Year' }   = 0;
                $GetParam{ $Prefix . 'Month' }  = 0;
                $GetParam{ $Prefix . 'Day' }    = 0;
                $GetParam{ $Prefix . 'Hour' }   = 0;
                $GetParam{ $Prefix . 'Minute' } = 0;
            }

            # set free time
            $Self->{TicketObject}->TicketFreeTimeSet(
                %GetParam,
                Prefix   => 'TicketFreeTime',
                TicketID => $TicketID,
                Counter  => $Count,
                UserID   => $Self->{UserID},
            );
        }

        # get pre loaded attachment
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # remove unused inline images
            my @NewAttachmentData;
            for my $Attachment (@AttachmentData) {
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                        Text => $ContentID,
                    );

                    # workaround for link encode of rich text editor, see bug#5053
                    my $ContentIDLinkEncode = $Self->{LayoutObject}->LinkEncode($ContentID);
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # ignore attachment if not linked in body
                    next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @AttachmentData = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ( $GetParam{NewUserID} ) {
            $NoAgentNotify = 1;
        }
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            NoAgentNotify    => $NoAgentNotify,
            TicketID         => $TicketID,
            ArticleType      => $Self->{Config}->{ArticleType},
            SenderType       => $Self->{Config}->{SenderType},
            From             => $GetParam{From},
            To               => $To,
            Subject          => $GetParam{Subject},
            Body             => $GetParam{Body},
            MimeType         => $MimeType,
            Charset          => $Self->{LayoutObject}->{UserCharset},
            UserID           => $Self->{UserID},
            HistoryType      => $Self->{Config}->{HistoryType},
            HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader       => {
                From    => $GetParam{From},
                To      => $GetParam{To},
                Subject => $GetParam{Subject},
                Body    => $Self->{LayoutObject}->RichText2Ascii( String => $GetParam{Body} ),

            },
            Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
        );
        if ( !$ArticleID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set article free text
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->ArticleFreeTextSet(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    Key       => $GetParam{$Key},
                    Value     => $GetParam{$Text},
                    Counter   => $Count,
                    UserID    => $Self->{UserID},
                );
            }
        }

        # set owner (if new user id is given)
        if ( $GetParam{NewUserID} ) {
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $TicketID,
                NewUserID => $GetParam{NewUserID},
                UserID    => $Self->{UserID},
            );

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );
        }

        # else set owner to current agent but do not lock it
        else {
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID           => $TicketID,
                NewUserID          => $Self->{UserID},
                SendNoNotification => 1,
                UserID             => $Self->{UserID},
            );
        }

        # set responsible (if new user id is given)
        if ( $GetParam{NewResponsibleID} ) {
            $Self->{TicketObject}->TicketResponsibleSet(
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

        # write attachments
        for my $Attachment (@AttachmentData) {
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{UserID},
            );
        }

        # remove pre submited attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # link tickets
        if (
            $GetParam{LinkTicketID}
            && $Self->{Config}->{SplitLinkType}
            && $Self->{Config}->{SplitLinkType}->{LinkType}
            && $Self->{Config}->{SplitLinkType}->{Direction}
            )
        {
            my $Access = $Self->{TicketObject}->TicketPermission(
                Type     => 'ro',
                TicketID => $GetParam{LinkTicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $Self->{LayoutObject}->NoPermission(
                    Message    => "You need ro permission!",
                    WithHeader => 'yes',
                );
            }

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
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $Self->{TicketObject}->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $TicketID,
                %GetParam,
            );
        }

        # get redirect screen
        my $NextScreen = $Self->{UserCreateNextMask} || 'AgentTicketPhone';

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen;Subaction=Created;TicketID=$TicketID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest         = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' );
        my $QueueID      = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
        }

        # get list type
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
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
            QueueID        => $QueueID      || 1,
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
            Services       => $Services,
        );

        # get free text config options
        my @TicketFreeTextConfig;
        for my $Count ( 1 .. 16 ) {
            my $Key       = 'TicketFreeKey' . $Count;
            my $Text      = 'TicketFreeText' . $Count;
            my $ConfigKey = $Self->{TicketObject}->TicketFreeTextGet(
                %GetParam,
                TicketID       => $Self->{TicketID},
                Type           => $Key,
                Action         => $Self->{Action},
                QueueID        => $QueueID || 0,
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerUser || '',
            );
            if ($ConfigKey) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => $Key,
                        Data        => $ConfigKey,
                        SelectedID  => $GetParam{$Key},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
            my $ConfigValue = $Self->{TicketObject}->TicketFreeTextGet(
                %GetParam,
                TicketID       => $Self->{TicketID},
                Type           => $Text,
                Action         => $Self->{Action},
                QueueID        => $QueueID || 0,
                UserID         => $Self->{UserID},
                CustomerUserID => $CustomerUser || '',
            );
            if ($ConfigValue) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => $Text,
                        Data        => $ConfigValue,
                        SelectedID  => $GetParam{$Text},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
        }
        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name         => 'NewUserID',
                    Data         => $Users,
                    SelectedID   => $GetParam{NewUserID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 0,
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
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                @TicketFreeTextConfig,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your administrator',
        );
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->TicketStateList(
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
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for my $KeyGroupMember ( keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $KeyGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$KeyGroupMember};
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
        );
        for my $KeyMember ( keys %MemberList ) {
            if ( $AllGroupsMembers{$KeyMember} ) {
                $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
            }
        }
    }
    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
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

    # get service
    my %Service;
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

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Self->{TicketObject}->TicketSLAList(
                %Param,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # check own selection
    my %NewTos;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewTos = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
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
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
        Data => {
            ActiveAutoComplete  => $AutoCompleteConfig->{Active},
            minQueryLength      => $AutoCompleteConfig->{MinQueryLength} || 2,
            queryDelay          => $AutoCompleteConfig->{QueryDelay} || 100,
            typeAhead           => $AutoCompleteConfig->{TypeAhead} || 'false',
            maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
        },
    );

    # build string
    $Param{OptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{Users},
        SelectedID   => $Param{UserSelected},
        Translation  => 0,
        Name         => 'NewUserID',
        PossibleNone => 1,
    );

    # build next states string
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{NextStates},
        Name          => 'NextStateID',
        Translation   => 1,
        SelectedValue => $Param{NextState} || $Self->{Config}->{StateDefault},
    );

    # build to string
    my %NewTo;
    if ( $Param{To} ) {
        for my $KeyTo ( keys %{ $Param{To} } ) {
            $NewTo{"$KeyTo||$Param{To}->{$KeyTo}"} = $Param{To}->{$KeyTo};
        }
    }
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{ToStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Class          => 'Validate_Required',
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Name           => 'Dest',
            SelectedID     => $Param{ToSelected},
            OnChangeSubmit => 0,
        );
    }
    else {
        $Param{ToStrg} = $Self->{LayoutObject}->BuildSelection(
            Class       => 'Validate_Required',
            Data        => \%NewTo,
            Name        => 'Dest',
            SelectedID  => $Param{ToSelected},
            Translation => 0,
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
        for my $KeyError ( keys %{ $Param{Errors} } ) {
            $Param{$KeyError}
                = '* ' . $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    # display server error msg according with the occurred email (from) error type
    if ( $Param{Errors} && $Param{Errors}->{ErrorType} ) {
        $Self->{LayoutObject}->Block( Name => 'Email' . $Param{Errors}->{ErrorType} );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'GenericServerErrorMsg' );
    }

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Class => 'Validate_Required' . ( $Param{Errors}->{TypeIDInvalid} || ' ' ),
            Data  => $Param{Types},
            Name  => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
        $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{Services},
            Name         => 'ServiceID',
            Class        => $Param{Errors}->{ServiceInvalid} || ' ',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%Param},
        );
        $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => $Param{SLAs},
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
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
    $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{Priorities},
        Name          => 'PriorityID',
        SelectedID    => $Param{PriorityID},
        SelectedValue => $Param{Priority},
        Translation   => 1,
    );

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class            => $Param{Errors}->{DateInvalid},
        Validate         => 1,
        ValidateDateInFuture => 1,
    );

    # show owner selection
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
    }

    # show responsible selection
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        && $Self->{ConfigObject}->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{ResponsibleOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUserSelected},
            Name       => 'NewResponsibleID',
        );
        $Self->{LayoutObject}->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Self->{Config}->{TicketFreeText}->{$Count};
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
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{TicketFreeTime}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime',
            Data => {
                TicketFreeTimeKey => $Param{ 'TicketFreeTimeKey' . $Count },
                TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                Count             => $Count,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTime' . $Count,
            Data => { %Param, Count => $Count, },
        );
    }

    # article free text
    for my $Count ( 1 .. 3 ) {
        next if !$Self->{Config}->{ArticleFreeText}->{$Count};
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

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = 'Validate_Required';
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = '';
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    my $ShownOptionsBlock;

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {
                    %Param,
                },
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {
                %Param,
            },
        );
    }

    # show customer edit link
    my $OptionCustomer = $Self->{LayoutObject}->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw',
    );
    if ($OptionCustomer) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {
                    %Param,
                },
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'OptionCustomer',
            Data => {
                %Param,
            },
        );
    }

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketPhone', Data => \%Param );
}

1;
