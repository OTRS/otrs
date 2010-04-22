# --
# Kernel/Modules/AdminNotification.pm - provides admin notification translations
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminNotification.pm,v 1.27 2010-04-22 17:40:40 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminNotification;

use strict;
use warnings;

use Kernel::System::Notification;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.27 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{NotificationObject} = Kernel::System::Notification->new(%Param);
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @Params = (qw(Name Type Charset Language Subject Body UserID));
    my %GetParam;
    for (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
    }
    if ( !$GetParam{Language} && $GetParam{Name} ) {
        if ( $GetParam{Name} =~ /^(.+?)(::.*)/ ) {
            $GetParam{Language} = $1;
        }
    }

    # get content type
    my $ContentType = 'text/plain';
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $ContentType = 'text/html';
    }

    # ------------------------------------------------------------ #
    # get data 2 form
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my %Notification = $Self->{NotificationObject}->NotificationGet(%GetParam);
        my $Output       = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskNotificationForm( %GetParam, %Param, %Notification, );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Update = $Self->{NotificationObject}->NotificationUpdate(
            %GetParam,
            ContentType => $ContentType,
            UserID      => $Self->{UserID},
        );
        if ( !$Update ) {
            return $Self->{LayoutObject}->Error();
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=AdminNotification" );
    }

    # ------------------------------------------------------------ #
    # else ! print form
    # ------------------------------------------------------------ #
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskNotificationForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MaskNotificationForm {
    my ( $Self, %Param ) = @_;

    # show update form
    if ( $Self->{Subaction} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ShowUpdateForm',
            Data => \%Param
        );
    }

    # show initial message
    else {
        $Self->{LayoutObject}->Block(
            Name => 'ShowInitialMessage',
        );
    }

    # build NotificationOption string
    $Param{NotificationOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => { $Self->{NotificationObject}->NotificationList() },
        Name       => 'Name',
        Size       => 15,
        SelectedID => $Param{Name},
        HTMLQuote  => 1,
    );

    #Show update form
    if ( $Self->{Subaction} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ShowUpdateForm',
            Data => \%Param
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'ShowInitialMessage'
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );

        # reformat from plain to html
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/plain/i ) {
            $Param{Body} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $Param{Body},
            );
        }
    }
    else {

        # reformat from html to plain
        if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
            $Param{Body} = $Self->{HTMLUtilsObject}->ToAscii(
                String => $Param{Body},
            );
        }
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminNotification',
        Data         => \%Param
    );
}

1;
