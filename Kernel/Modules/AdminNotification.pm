# --
# Kernel/Modules/AdminNotification.pm - provides admin notification translations
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminNotification.pm,v 1.13 2008-06-19 22:21:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminNotification;

use strict;
use warnings;

use Kernel::System::Notification;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

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

    # lib object
    $Self->{NotificationObject} = Kernel::System::Notification->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

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

    # get data 2 form
    if ( $Self->{Subaction} eq 'Change' ) {
        my %Notification = $Self->{NotificationObject}->NotificationGet(%GetParam);
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskNotificationForm( %GetParam, %Param, %Notification, );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # update action
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {
        if (
            $Self->{NotificationObject}->NotificationUpdate( %GetParam, UserID => $Self->{UserID} )
            )
        {
            return $Self->{LayoutObject}->Redirect( OP => "Action=AdminNotification" );
        }
        else {
            return $Self->{LayoutObject}->Error();
        }
    }

    # add new response
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        if (
            my $Id
            = $Self->{StdNotificationObject}->StdNotificationAdd(
                %GetParam, UserID => $Self->{UserID}
            )
            )
        {

            # add attachments to response
            my @NewIDs = $Self->{ParamObject}->GetArray( Param => 'IDs' );
            $Self->{StdAttachmentObject}->SetStdAttachmentsOfNotificationID(
                AttachmentIDsRef => \@NewIDs,
                ID               => $Id,
                UserID           => $Self->{UserID},
            );

            # show next page
            return $Self->{LayoutObject}->Redirect( OP => "Action=AdminNotifications", );
        }
        else {
            return $Self->{LayoutObject}->Error();
        }
    }

    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskNotificationForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MaskNotificationForm {
    my ( $Self, %Param ) = @_;

    # build NotificationOption string
    $Param{'NotificationOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{NotificationObject}->NotificationList() },
        Name       => 'Name',
        Size       => 15,
        SelectedID => $Param{Name},
        HTMLQuote  => 1,
    );

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminNotificationForm',
        Data         => \%Param
    );
}

1;
