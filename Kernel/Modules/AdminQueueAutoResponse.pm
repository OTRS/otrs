# --
# Kernel/Modules/AdminQueueAutoResponse.pm - to add/update/delete QueueAutoResponses
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminQueueAutoResponse.pm,v 1.9 2003-12-07 23:56:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminQueueAutoResponse;

use strict;

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
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    $Param{NextScreen} = 'AdminQueueAutoResponse';
    
    if ($Self->{Subaction} eq 'Change') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Queue <-> Auto Response');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get Type Auto Responses data
        my %TypeResponsesData = $Self->{DBObject}->GetTableData(
            Table => 'auto_response_type',
            What => 'id, name',
        );
        # get queue data
        my %QueueData = $Self->{DBObject}->GetTableData(
            Table => 'queue',
            What => 'id, name',
            Where => "id = $Param{ID}",
        );

        foreach (keys %TypeResponsesData) {
            my %Data = $Self->{DBObject}->GetTableData(
                Table => 'auto_response ar, auto_response_type art',
                What => 'ar.id, ar.name',
                Where => " art.id = $_ AND ar.type_id = art.id",
            );
            my ($SelectedID, $Name) = $Self->{DBObject}->GetTableData(
                Table => 'auto_response ar, auto_response_type art, queue_auto_response qar',
                What => 'ar.id, ar.name',
                Where => " art.id = $_ AND ar.type_id = art.id AND qar.queue_id = $Param{ID} " .
					"AND qar.auto_response_id = ar.id",
            );
            $Param{DataStrg} .= $Self->_MaskHits(
                Type => $TypeResponsesData{$_},
		TypeID => $_,
                Data => \%Data,
		SelectedID => $SelectedID,
            );
        }
	# end with form
	$Output .= $Self->_Mask(
            Queue => $QueueData{$Param{ID}},
            QueueID => $Param{ID},
            %Param, 
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # queues to queue_auto_responses
    elsif ($Self->{Subaction} eq 'ChangeAction') {

        $Self->{DBObject}->Do(
            SQL => "DELETE FROM queue_auto_response WHERE queue_id = $Param{ID}",
        );
        my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
        foreach (@NewIDs) {
          if ($_) {
            my $SQL = "INSERT INTO queue_auto_response (queue_id, auto_response_id, " .
			" create_time, create_by, change_time, change_by)" .
            " VALUES " .
            " ( $Param{ID}, $_, current_timestamp, $Self->{UserID}, " .
            " current_timestamp, $Self->{UserID})";
            $Self->{DBObject}->Do(SQL => $SQL);
          }
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
    }
    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Queue <-> Auto Response');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get queue data
        my %QueueData = $Self->{DBObject}->GetTableData(
            Table => 'queue',
            What => 'id, name',
            Valid => 1,
        );
        
        foreach (sort {$QueueData{$a} cmp $QueueData{$b}} keys %QueueData) {
            my @Data;
            my $SQL = "SELECT ar.name, art.name, ar.id FROM " .
            " auto_response ar, auto_response_type art, queue_auto_response qar " .
            " WHERE " .
            " ar.type_id = art.id " .
            " AND " .
            " ar.id = qar.auto_response_id " .
            " AND ".
            " qar.queue_id = $_ ";
            
            $Self->{DBObject}->Prepare(SQL => $SQL);
            while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
                my %AutoResponseData;
                $AutoResponseData{Name}	= $RowTmp[0];
                $AutoResponseData{Type} = $RowTmp[1];
                $AutoResponseData{ID} = $RowTmp[2];
                push (@Data, \%AutoResponseData);
            }
            $Output .= $Self->_MaskQueueAutoResponseTable(
                Queue => $QueueData{$_},
                QueueID => $_,
                Data => \@Data,
            );
        }
        
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminQueueAutoResponseForm', Data => \%Param);
}
# --
sub _MaskHits {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Self->{SessionID} || '';
    my $Type = $Param{Type} || '?';
    my $Data = $Param{Data};
    my $SelectedID = $Param{SelectedID} || -1;
    my $Output = '';
($Output .= <<EOF);
<BR>
  <B>${\$Self->{LayoutObject}->{LanguageObject}->Get("Change")} 
    "${\$Self->{LayoutObject}->{LanguageObject}->Get($Type)}" 
    ${\$Self->{LayoutObject}->{LanguageObject}->Get("settings")}</B>: 
  <BR>

EOF

    $Output .= $Self->{LayoutObject}->OptionStrgHashRef(
        Name => 'IDs',
        SelectedID => $SelectedID,
        Data => $Data,
        Size => 3,
        PossibleNone => 1,
    );

    return $Output;
}
# --
sub _MaskQueueAutoResponseTable {
    my $Self = shift;
    my %Param = @_;
    my $DataTmp = $Param{Data};
    my @Data = @$DataTmp;
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "Action=AdminQueueAutoResponse&";
    $Param{DataStrg} = '<br>';
    
    foreach (@Data){
      my %ResponseData = %$_;
      $Param{DataStrg} .= "<B>*</B> <A HREF=\"$Self->{LayoutObject}->{Baselink}Action=AdminAutoResponse&Subaction=" .
        "Change&ID=$ResponseData{ID}\">$ResponseData{Name}</A> ($ResponseData{Type}) <BR>";
    }
    if (@Data == 0) {
      $Param{DataStrg}.= '$Text{"Sorry"}, <FONT COLOR="RED">$Text{"no"}</FONT> $Text{"auto responses set"}!';
    }
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminQueueAutoResponseTable', Data => \%Param);
}
# --
1;
