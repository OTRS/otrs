# --
# Kernel/Modules/AdminAttachment.pm - provides admin std response module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminAttachment.pm,v 1.3 2003-03-23 21:34:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminAttachment;

use strict;
use Kernel::System::StdAttachment;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction} || ''; 
    $Param{NextScreen} = 'AdminAttachment';

    my %AttachmentIndex = $Self->{StdAttachmentObject}->GetAllStdAttachments(Valid => 0);
    my @Params = ('ID', 'Name', 'Comment', 'ValidID', 'Response');

    # --
    # get data 2 form
    # --
    if ($Param{Subaction} eq 'Change') {
        $Param{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %ResponseData = $Self->{StdAttachmentObject}->StdAttachmentGet(ID => $Param{ID});
        $Output = $Self->{LayoutObject}->Header(Title => 'Attachment change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminAttachmentForm(
            %ResponseData,  
            %Param,
            AttachmentIndex => \%AttachmentIndex,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # update action
    # --
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # get attachment
        # -- 
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'string',
        );
        $GetParam{Content} = $UploadStuff{UploadFilename};
        $GetParam{ContentType} = $UploadStuff{UploadContentType};
        $GetParam{Filename} = $UploadStuff{UploadRealFileName};


        if ($Self->{StdAttachmentObject}->StdAttachmentUpdate(%GetParam, UserID => $Self->{UserID})) { 
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
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # get attachment
        # -- 
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'string',
        );
        $GetParam{Content} = $UploadStuff{UploadFilename};
        $GetParam{ContentType} = $UploadStuff{UploadContentType};
        $GetParam{Filename} = $UploadStuff{UploadRealFileName};

        if (my $Id = $Self->{StdAttachmentObject}->StdAttachmentAdd(%GetParam, UserID => $Self->{UserID})) {
             return $Self->{LayoutObject}->Redirect(
                 OP => "Action=AdminResponseAttachment&Subaction=Attachment&ID=$Id",
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
        $Output = $Self->{LayoutObject}->Header(Title => 'Attachment add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminAttachmentForm(
            AttachmentIndex => \%AttachmentIndex,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
