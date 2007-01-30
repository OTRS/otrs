# --
# Kernel/Modules/AdminResponse.pm - provides admin std response module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminResponse.pm,v 1.22 2007-01-30 14:31:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminResponse;

use strict;
use Kernel::System::StdResponse;
use Kernel::System::StdAttachment;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{StdResponseObject} = Kernel::System::StdResponse->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

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

    # get data 2 form
    if ($Param{Subaction} eq 'Change') {
        $Param{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %ResponseData = $Self->{StdResponseObject}->StdResponseGet(ID => $Param{ID});
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            %ResponseData,
            %Param,
            Attachments => \%AttachmentData,
            SelectedAttachments => \%SelectedAttachmentData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
    elsif ($Param{Subaction} eq 'ChangeAction') {
        if ($Self->{StdResponseObject}->StdResponseUpdate(%GetParam, UserID => $Self->{UserID})) {
            # update attachments to response
            my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
            $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
                AttachmentIDsRef => \@NewIDs,
                ID => $GetParam{ID},
                UserID => $Self->{UserID},
            );
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add new response
    elsif ($Param{Subaction} eq 'AddAction') {
        if (my $Id = $Self->{StdResponseObject}->StdResponseAdd(%GetParam, UserID => $Self->{UserID})) {
            # add attachments to response
            my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
            $Self->{StdAttachmentObject}->SetStdAttachmentsOfResponseID(
                AttachmentIDsRef => \@NewIDs,
                ID => $Id,
                UserID => $Self->{UserID},
            );
            # show next page
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminQueueResponses&Subaction=Response&ID=$Id",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # delete response
    elsif ($Param{Subaction} eq 'Delete') {
        if ($Self->{StdResponseObject}->StdResponseDelete(ID => $GetParam{ID})) {
            # show next page
            return $Self->{LayoutObject}->Redirect(OP => "Action=AdminResponse");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            Subaction => 'Add',
            Attachments => \%AttachmentData,
            SelectedAttachments => \%SelectedAttachmentData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Mask {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{ValidObject}->ValidList(),
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    # build ResponseOption string
    $Param{'ResponseOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => 'id, name, id',
                Valid => 0,
                Clamp => 1,
                Table => 'standard_response',
            )
        },
        Name => 'ID',
        Size => 15,
        SelectedID => $Param{ID},
    );

    my %SecondDataTmp = %{$Param{Attachments}};
    my %DataTmp = %{$Param{SelectedAttachments}};
    $Param{AttachmentOption} .= "<SELECT NAME=\"IDs\" SIZE=3 multiple>\n";
    foreach my $ID (sort keys %SecondDataTmp) {
        $Param{AttachmentOption} .= "<OPTION ";
        foreach (sort keys %DataTmp) {
            if ($_ eq $ID) {
                $Param{AttachmentOption} .= 'selected';
            }
        }
        $Param{AttachmentOption} .= " VALUE=\"$ID\">$SecondDataTmp{$ID}</OPTION>\n";
    }
    $Param{AttachmentOption} .= "</SELECT>\n";

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminResponseForm', Data => \%Param);
}

1;
