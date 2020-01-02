# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::CustomerTicketAttachment;

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

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    my $TicketID  = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );
    my $FileID    = $ParamObject->GetParam( Param => 'FileID' );

    # check params
    if ( !$FileID || !$ArticleID ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => Translatable('FileID and ArticleID are needed!'),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    if ( !$TicketID ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No TicketID for ArticleID (%s)!', $ArticleID ),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => "No TicketID for ArticleID ($ArticleID)!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my @ArticleList = $ArticleObject->ArticleList(
        TicketID             => $TicketID,
        ArticleID            => $ArticleID,
        IsVisibleForCustomer => 1,
    );

    my $ArticleBackendObject;
    my %Article;

    ARTICLEMETADATA:
    for my $ArticleMetaData (@ArticleList) {

        next ARTICLEMETADATA if !$ArticleMetaData;
        next ARTICLEMETADATA if !IsHashRefWithData($ArticleMetaData);

        $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$ArticleMetaData} );

        %Article = $ArticleBackendObject->ArticleGet(
            TicketID      => $TicketID,
            ArticleID     => $ArticleMetaData->{ArticleID},
            DynamicFields => 0,
        );
    }

    # check permission
    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCustomerPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
    }

    # get attachment
    my %Data = $ArticleBackendObject->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => $FileID,
    );

    if ( !%Data ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No such attachment (%s)!', $FileID ),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => "No such attachment ($FileID)! May be an attack!!!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # download it AttachmentDownloadType is configured
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
