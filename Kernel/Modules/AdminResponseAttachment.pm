# --
# Kernel/Modules/AdminResponseAttachment.pm - queue <-> responses
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminResponseAttachment.pm,v 1.1 2003-01-03 00:13:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminResponseAttachment;

use strict;
use Kernel::System::StdAttachment;
use Kernel::System::StdResponse;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject PermissionObject)) {
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
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    my $NextScreen = 'AdminResponseAttachment';

    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    # get StdResponses data 
    my %StdResponses = $Self->{StdResponseObject}->GetAllStdResponses(Valid => 1);
    # get queue data
    my %StdAttachments = $Self->{StdAttachmentObject}->GetAllStdAttachments(Valid => 1);

    # user <-> group 1:n
    if ($Self->{Subaction} eq 'Response') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Response <-> Queue');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get StdResponses data 
        my %StdResponsesData = $Self->{DBObject}->GetTableData(
            Table => 'standard_response',
            What => 'id, name',
            Where => "id = $ID",
        );
        my %Data = $Self->{DBObject}->GetTableData(
            Table => 'standard_response_attachment',
            What => 'standard_attachment_id, standard_response_id',
            Where => "standard_response_id = $ID",
        );
        $Output .= $Self->{LayoutObject}->AdminResponseAttachmentChangeForm(
            FirstData => \%StdResponsesData,
            SecondData => \%StdAttachments,
            Data => \%Data,	 
            Type => 'Response',
        );

        $Output .= $Self->{LayoutObject}->Footer();
    }
    # group <-> user n:1
    elsif ($Self->{Subaction} eq 'Attachment') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Response <-> Queue');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get queue data
        my %AttachmentData = $Self->{DBObject}->GetTableData(
                Table => 'standard_attachment',
                What => 'id, name, filename',
                Clamp => 1,
                Where => "id = $ID",);

        my %Data = $Self->{DBObject}->GetTableData(
                Table => 'standard_response_attachment',
                What => 'standard_response_id, standard_attachment_id',
                Where => "standard_attachment_id = $ID");
        $Output .= $Self->{LayoutObject}->AdminResponseAttachmentChangeForm(
                FirstData => \%AttachmentData,
                SecondData => \%StdResponses,
                Data => \%Data,
                Type => 'Attachment',
            );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # --
    # update responses of attachment
    # --
    elsif ($Self->{Subaction} eq 'ChangeAttachment') {
        my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
        $Self->{DBObject}->Do(
          SQL => "DELETE FROM standard_response_attachment WHERE standard_attachment_id = $ID",
        );
        foreach (@NewIDs) {
            my $SQL = "INSERT INTO standard_response_attachment (standard_attachment_id, ".
              "standard_response_id, create_time, create_by, " .
	          " change_time, change_by)" .
              " VALUES " .
              " ($ID, $_, current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
            $Self->{DBObject}->Do(SQL => $SQL);
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");    

    }
    # --
    # update attachments of response
    # --
    elsif ($Self->{Subaction} eq 'ChangeResponse') {
        my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
        $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
            AttachmentIDsRef => \@NewIDs,
            ID => $ID,
            UserID => $Self->{UserID},
        );
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$NextScreen");

    }
    # else ! print form 
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Response <-> Attachment');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminResponseAttachmentForm(
            FirstData => \%StdResponses, 
            SecondData => \%StdAttachments,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
