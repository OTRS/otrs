# --
# Kernel/Modules/AdminResponse.pm - provides admin std response module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminResponse.pm,v 1.9 2003-03-23 21:34:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminResponse;

use strict;
use Kernel::System::StdResponse;
use Kernel::System::StdAttachment;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    # lib object
    $Self->{StdResponseObject} = Kernel::System::StdResponse->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction} || ''; 
    $Param{NextScreen} = 'AdminResponse';

    my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'Response');
    my %GetParam;
    foreach (@Params) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
    }

    # get response attachment data 
    my %AttachmentData = $Self->{StdAttachmentObject}->GetAllStdAttachments(Valid => 1);
    my %SelectedAttachmentData = ();
    if ($GetParam{ID}) { 
      %SelectedAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
        ID => $GetParam{ID},
      );
    }

    # --
    # get data 2 form
    # --
    if ($Param{Subaction} eq 'Change') {
        $Param{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %ResponseData = $Self->{StdResponseObject}->StdResponseGet(ID => $Param{ID});
        $Output = $Self->{LayoutObject}->Header(Title => 'Response change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminResponseForm(
            %ResponseData, 
            %Param,
            Attachments => \%AttachmentData,
            SelectedAttachments => \%SelectedAttachmentData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # update action
    # --
    elsif ($Param{Subaction} eq 'ChangeAction') {
        if ($Self->{StdResponseObject}->StdResponseUpdate(%GetParam, UserID => $Self->{UserID})) { 
            # --
            # update attachments to response
            # --
            my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
            $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
                AttachmentIDsRef => \@NewIDs,
                ID => $GetParam{ID},
                UserID => $Self->{UserID},
            );
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # add new response
    # --
    elsif ($Param{Subaction} eq 'AddAction') {
        if (my $Id = $Self->{StdResponseObject}->StdResponseAdd(%GetParam, UserID => $Self->{UserID})) {
            # --
            # add attachments to response
            # --
            my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
            $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
                AttachmentIDsRef => \@NewIDs,
                ID => $Id,
                UserID => $Self->{UserID},
            );
            # --
            # show next page
            # --
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminQueueResponses&Subaction=Response&ID=$Id",
            );
        }
        else {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # else ! print form 
    # --
    else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Response add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminResponseForm(
            Subaction => 'Add',
            Attachments => \%AttachmentData,
            SelectedAttachments => \%SelectedAttachmentData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
