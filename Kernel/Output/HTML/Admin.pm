# --
# HTML/Admin.pm - provides generic admin HTML output
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Admin.pm,v 1.38.2.2 2003-05-19 15:56:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Admin;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.38.2.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub AdminNavigationBar {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
}
# --
sub AdminSession {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'AdminSession', Data => \%Param);
}
# --
sub AdminLog {
    my $Self = shift;
    my %Param = @_;
    # create table
    $Param{LogTable} = '<table border="0" width="100%">';
    $Param{LogTable} .= '<tr><th width="20%">$Text{"Time"}</th><th>$Text{"Priority"}</th><th>$Text{"Facility"}</th><th width="55%">$Text{"Message"}</th></tr>';
    my @Lines = split(/\n/, $Param{Log});
    foreach (@Lines) {
        my @Row = split(/;;/, $_);
        if ($Row[5]) {
            $Row[2] = $Self->Ascii2Html(Text => $Row[2], Max => 20);
            $Row[3] = $Self->Ascii2Html(Text => $Row[3], Max => 25);
            $Row[5] = $Self->Ascii2Html(Text => $Row[5], Max => 500);
            if ($Row[1] =~ /error/) {
                $Param{LogTable} .= "<tr><td><font color='red'>$Row[0]</font></td><td align='center'><font color='red'>$Row[1]</font></td><td><font color='red'>$Row[2]</font></td><td><font color='red'>$Row[5]</font></td></tr>"; 
            }
            else {
                $Param{LogTable} .= "<tr><td>$Row[0]</td><td align='center'>$Row[1]</td><td>$Row[2]</td><td>$Row[5]</td></tr>"; 
            }
        }
    }
    $Param{LogTable} .= '</table>';
    # create & return output
    return $Self->Output(TemplateFile => 'AdminLog', Data => \%Param);
}
# --
sub AdminEmail {
    my $Self = shift;
    my %Param = @_;

    $Param{'UserOption'} = $Self->OptionStrgHashRef(
        Data => $Param{UserList},
        Name => 'UserIDs', 
        Size => 8,
        Multiple => 1,
    );

    $Param{'GroupOption'} = $Self->OptionStrgHashRef(
        Data => $Param{GroupList},
        Size => 6,
        Name => 'GroupIDs',
        Multiple => 1,
    );

    # create & return output
    return $Self->Output(TemplateFile => 'AdminEmail', Data => \%Param);
}
# --
sub AdminEmailSent {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'AdminEmailSent', Data => \%Param);
}
# --
sub AdminSessionTable {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    foreach (sort keys %Param) {
      if (($_) && (defined($Param{$_})) && $_ ne 'SessionID') {
        if ($_  eq 'UserSessionStart') {
          my $Age = int((time() - $Param{UserSessionStart}) / 3600);
          $Param{UserSessionStart} = scalar localtime ($Param{UserSessionStart});
          $Output .= "[ " . $_ . " = $Param{$_} / $Age h ] <BR>\n";
        }
        else {
          $Output .= "[ " . $_ . " = $Param{$_} ] <BR>\n";
        }
      }
    }

    $Param{Output} = $Output;
    # create & return output
    return $Self->Output(TemplateFile => 'AdminSessionTable', Data => \%Param);
}
# --
sub AdminSelectBoxForm {
    my $Self = shift;
    my %Param = @_;

    return $Self->Output(TemplateFile => 'AdminSelectBoxForm', Data => \%Param);
} 
# --
sub AdminSelectBoxResult {
    my $Self = shift;
    my %Param = @_;
    my $DataTmp = $Param{Data};
    my @Datas = @$DataTmp;
    my $Output = '';
    foreach my $Data ( @Datas ) {
        $Output .= '<table cellspacing="0" cellpadding="3" border="0">';
        foreach (sort keys %$Data) {
            $$Data{$_} = $Self->Ascii2Html(Text => $$Data{$_}, Max => 200);
            $$Data{$_} = '<i>undef</i>' if (! defined $$Data{$_});
            $Output .= "<tr><td>$_:</td><td> = </td><td>$$Data{$_}</td></tr>\n";
        }
        $Output .= '</table>';
        $Output .= '<hr>';
   }

    $Param{Result} = $Output;
    # get output
    return $Self->Output(TemplateFile => 'AdminSelectBoxResult', Data => \%Param);
}
# --
sub AdminResponseForm {
    my $Self = shift;
    my %Param = @_;
    
    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => { 
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          ) 
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );
 
    # build ResponseOption string
    $Param{'ResponseOption'} = $Self->OptionStrgHashRef(
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
    foreach my $ID (sort keys %SecondDataTmp){
       $Param{AttachmentOption} .= "<OPTION ";
       foreach (sort keys %DataTmp){
         if ($_ eq $ID) {
               $Param{AttachmentOption} .= 'selected';
         }
       }
      $Param{AttachmentOption} .= " VALUE=\"$ID\">$SecondDataTmp{$ID}</OPTION>\n";
    }
    $Param{AttachmentOption} .= "</SELECT>\n";

    return $Self->Output(TemplateFile => 'AdminResponseForm', Data => \%Param);
}
# --
sub AdminAttachmentForm {
    my $Self = shift;
    my %Param = @_;
    
    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => { 
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          ) 
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );
 
    # build ResponseOption string
    $Param{'ResponseOption'} = $Self->OptionStrgHashRef(
        Data => $Param{AttachmentIndex},
        Name => 'ID', 
        Size => 15,
        SelectedID => $Param{ID},
    );

    $Param{'Subaction'} = "Add" if (!$Param{'Subaction'});

    return $Self->Output(TemplateFile => 'AdminAttachmentForm', Data => \%Param);
}
# --
sub AdminResponseAttachmentForm {
    my $Self = shift;
    my %Param = @_;
    my $UserData = $Param{FirstData};
    my %UserDataTmp = %$UserData;
    my $GroupData = $Param{SecondData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink = $Self->{Baselink} . "Action=AdminResponseAttachment&";

    foreach (sort {$UserDataTmp{$a} cmp $UserDataTmp{$b}} keys %UserDataTmp){
        $Param{AnswerQueueStrg} .= "<a href=\"$BaseLink"."Subaction=Response&ID=$_\">$UserDataTmp{$_}</a><br>";
    }
    foreach (sort {$GroupDataTmp{$a} cmp $GroupDataTmp{$b}} keys %GroupDataTmp){
        $Param{QueueAnswerStrg}.= "<a href=\"$BaseLink"."Subaction=Attachment&ID=$_\">$GroupDataTmp{$_}</a><br>";
    }

    return $Self->Output(TemplateFile => 'AdminResponseAttachmentForm', Data => \%Param);
}
# --
sub AdminResponseAttachmentChangeForm {
    my $Self = shift;
    my %Param = @_;
    my $FirstData = $Param{FirstData};
    my %FirstDataTmp = %$FirstData;
    my $SecondData = $Param{SecondData};
    my %SecondDataTmp = %$SecondData;
    my $Data = $Param{Data};
    my %DataTmp = %$Data;
    $Param{Type} = $Param{Type} || 'Response';
    my $NeType = 'Response';
    $NeType = 'Attachment' if ($Param{Type} eq 'Response');

    foreach (sort keys %FirstDataTmp){
        $Param{OptionStrg0} .= "<B>$Param{Type}:</B> <A HREF=\"$Self->{Baselink}Action=Admin$Param{Type}&Subaction=Change&ID=$_\">" .
        "$FirstDataTmp{$_}</A> (id=$_)<BR>";
        $Param{OptionStrg0} .= "<INPUT TYPE=\"hidden\" NAME=\"ID\" VALUE=\"$_\"><BR>\n";
    }

    $Param{OptionStrg0} .= "<B>$NeType:</B><BR> <SELECT NAME=\"IDs\" SIZE=10 multiple>\n";
    foreach my $ID (sort keys %SecondDataTmp){
       $Param{OptionStrg0} .= "<OPTION ";
       foreach (sort keys %DataTmp){
         if ($_ eq $ID) {
               $Param{OptionStrg0} .= 'selected';
         }
       }
      $Param{OptionStrg0} .= " VALUE=\"$ID\">$SecondDataTmp{$ID} (id=$ID)</OPTION>\n";
    }
    $Param{OptionStrg0} .= "</SELECT>\n";

    return $Self->Output(TemplateFile => 'AdminResponseAttachmentChangeForm', Data => \%Param);
}
# --
sub AdminQueueResponsesForm {
    my $Self = shift;
    my %Param = @_;
    my $UserData = $Param{FirstData};
    my %UserDataTmp = %$UserData;
    my $GroupData = $Param{SecondData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink = $Self->{Baselink} . "Action=AdminQueueResponses&";

    foreach (sort {$UserDataTmp{$a} cmp $UserDataTmp{$b}} keys %UserDataTmp){
        $Param{AnswerQueueStrg} .= "<a href=\"$BaseLink"."Subaction=Response&ID=$_\">$UserDataTmp{$_}</a><br>";
    }
    foreach (sort {$GroupDataTmp{$a} cmp $GroupDataTmp{$b}} keys %GroupDataTmp){
        $Param{QueueAnswerStrg}.= "<a href=\"$BaseLink"."Subaction=Queue&ID=$_\">$GroupDataTmp{$_}</a><br>";
    }

    return $Self->Output(TemplateFile => 'AdminQueueResponsesForm', Data => \%Param);
}
# --
sub AdminQueueResponsesChangeForm {
    my $Self = shift;
    my %Param = @_;
    my $FirstData = $Param{FirstData};
    my %FirstDataTmp = %$FirstData;
    my $SecondData = $Param{SecondData};
    my %SecondDataTmp = %$SecondData;
    my $Data = $Param{Data};
    my %DataTmp = %$Data;
    $Param{Type} = $Param{Type} || 'Response';
    my $NeType = 'Response';
    $NeType = 'Queue' if ($Param{Type} eq 'Response');

    foreach (sort keys %FirstDataTmp){
        $Param{OptionStrg0} .= "<B>$Param{Type}:</B> <A HREF=\"$Self->{Baselink}Action=Admin$Param{Type}&Subaction=Change&ID=$_\">" .
        "$FirstDataTmp{$_}</A> (id=$_)<BR>";
        $Param{OptionStrg0} .= "<INPUT TYPE=\"hidden\" NAME=\"ID\" VALUE=\"$_\"><BR>\n";
    }

    $Param{OptionStrg0} .= "<B>$NeType:</B><BR> <SELECT NAME=\"IDs\" SIZE=10 multiple>\n";
    foreach my $ID (sort keys %SecondDataTmp){
       $Param{OptionStrg0} .= "<OPTION ";
       foreach (sort keys %DataTmp){
         if ($_ eq $ID) {
               $Param{OptionStrg0} .= 'selected';
         }
       }
      $Param{OptionStrg0} .= " VALUE=\"$ID\">$SecondDataTmp{$ID} (id=$ID)</OPTION>\n";
    }
    $Param{OptionStrg0} .= "</SELECT>\n";

    return $Self->Output(TemplateFile => 'AdminQueueResponsesChangeForm', Data => \%Param);
}
# --
sub AdminQueueForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'GroupOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'groups',
            Valid => 1,
          )
        },
        Name => 'GroupID',
        SelectedID => $Param{GroupID},
    );
    my $ParentQueue = '';
    if ($Param{Name}) {
        my @Queue = split(/::/, $Param{Name});
        for (my $i = 0; $i < $#Queue; $i++) {
            if ($ParentQueue) {
                $ParentQueue .= '::';
            }
            $ParentQueue .= $Queue[$i];
        }
        $Param{Name} = $Queue[$#Queue];
    }
    $Param{'QueueOption'} = $Self->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue', 
            Valid => 1,
          ), 
          '' => '-',
        },
        Name => 'ParentQueueID',
        Selected => $ParentQueue,
        MaxLevel => 2,
        OnChangeSubmit => 0,
    );

    $Param{'QueueLongOption'} = $Self->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue', 
            Valid => 0,
          )
        },
        Name => 'QueueID',
        Size => 15,
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $Param{'SignatureOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 1,
            Clamp => 1,
            Table => 'signature',
          )
        },
        Name => 'SignatureID',
        SelectedID => $Param{SignatureID},
    );

    $Param{'FollowUpLockYesNoOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'FollowUpLock',
        SelectedID => $Param{FollowUpLock},
    );

    $Param{'SystemAddressOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, value0, value1',
            Valid => 1,
            Clamp => 1,
            Table => 'system_address',
          )
        },
        Name => 'SystemAddressID',
        SelectedID => $Param{SystemAddressID},
    );

    $Param{'SalutationOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 1,
            Clamp => 1,
            Table => 'salutation',
          )
        },
        Name => 'SalutationID',
        SelectedID => $Param{SalutationID},
    );

    $Param{'FollowUpOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 1,
            Table => 'follow_up_possible',
          )
        },
        Name => 'FollowUpID',
        SelectedID => $Param{FollowUpID} || $Self->{ConfigObject}->Get('AdminDefaultFollowUpID') || 1,
    );

    $Param{'MoveOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'MoveNotify',
        SelectedID => $Param{MoveNotify},
    );
    $Param{'StateOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'StateNotify',
        SelectedID => $Param{StateNotify},
    );
    $Param{'OwnerOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'OwnerNotify',
        SelectedID => $Param{OwnerNotify},
    );
    $Param{'LockOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'LockNotify',
        SelectedID => $Param{LockNotify},
    );
    $Param{'Subaction'} = "Add" if (!$Param{'Subaction'});

    return $Self->Output(TemplateFile => 'AdminQueueForm', Data => \%Param);
}
# --
sub AdminAutoResponseForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'CharsetOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, charset',
            Table => 'charset',
            Valid => 0,
          )
        },
        Name => 'CharsetID',
        SelectedID => $Param{CharsetID},
    );

    $Param{'AutoResponseOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 0,
            Clamp => 1,
            Table => 'auto_response',
          )
        },
        Name => 'ID',
        Size => 15,
        SelectedID => $Param{ID},
    );

    $Param{'TypeOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 1,
            Clamp => 1,
            Table => 'auto_response_type',
          )
        },
        Name => 'TypeID',
        SelectedID => $Param{TypeID},
    );

    $Param{'SystemAddressOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, value0, value1',
            Valid => 1,
            Clamp => 1,
            Table => 'system_address',
          )
        },
        Name => 'AddressID',
        SelectedID => $Param{AddressID},
    );

    $Param{'Subaction'} = "Add" if (!$Param{'Subaction'});

    return $Self->Output(TemplateFile => 'AdminAutoResponseForm', Data => \%Param);
}
# --
sub AdminQueueAutoResponseTable {
    my $Self = shift;
    my %Param = @_;
    my $DataTmp = $Param{Data};
    my @Data = @$DataTmp;
    my $BaseLink = $Self->{Baselink} . "Action=AdminQueueAutoResponse&";
    $Param{DataStrg} = '<br>';

    foreach (@Data){
      my %ResponseData = %$_;
      $Param{DataStrg} .= "<B>*</B> <A HREF=\"$Self->{Baselink}Action=AdminAutoResponse&Subaction=" .
        "Change&ID=$ResponseData{ID}\">$ResponseData{Name}</A> ($ResponseData{Type}) <BR>";
    }
    if (@Data == 0) {
      $Param{DataStrg}.= '$Text{"Sorry"}, <FONT COLOR="RED">$Text{"no"}</FONT> $Text{"auto responses set"}!';
    }

    return $Self->Output(TemplateFile => 'AdminQueueAutoResponseTable', Data => \%Param);
}
# --
sub AdminQueueAutoResponseChangeForm {
    my $Self = shift;
    my %Param = @_;

    return $Self->Output(TemplateFile => 'AdminQueueAutoResponseForm', Data => \%Param);
}
# --
sub AdminQueueAutoResponseChangeFormHits {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Self->{SessionID} || '';
    my $Type = $Param{Type} || '?';
    my $Data = $Param{Data};
    my $SelectedID = $Param{SelectedID} || -1;
    my $Output = '';
($Output .= <<EOF);
<BR>
  <B>${\$Self->{LanguageObject}->Get("Change")} 
    "${\$Self->{LanguageObject}->Get($Type)}" 
    ${\$Self->{LanguageObject}->Get("settings")}</B>: 
  <BR>

EOF

    $Output .= $Self->OptionStrgHashRef(
        Name => 'IDs',
        SelectedID => $SelectedID,
        Data => $Data,
        Size => 3,
        PossibleNone => 1,
    );

    return $Output;
}
# --
sub AdminSalutationForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{SalutationOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 0,
            Clamp => 0,
            Table => 'salutation',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );


    return $Self->Output(TemplateFile => 'AdminSalutationForm', Data => \%Param);
}
# --
sub AdminSignatureForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{SignatureOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 0,
            Clamp => 0,
            Table => 'signature',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->Output(TemplateFile => 'AdminSignatureForm', Data => \%Param);
}
# --
sub AdminCustomerUserForm {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{UserOption} = $Self->OptionStrgHashRef(
        Data => $Param{UserList},
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );
    foreach my $Entry (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
      if ($Entry->[0]) {
          if ($Entry->[0] =~ /^UserPasswor/i) {
              $Param{Type} = 'password';
          }
          else {
              $Param{Type} = 'text';
          }
          if ($Entry->[0] =~ /^ValidID/i) {
              $Param{Value} = $Param{'ValidOption'}; 
          }
          else {
             my $Value = $Param{$Entry->[0]} || '';
             $Param{Value} = "<input type=\"$Param{Type}\" name=\"$Entry->[0]\" value=\"$Value\" size=\"35\" maxlength=\"50\">";
          }
          $Param{Preferences} .= $Self->Output(
                TemplateFile => 'AdminCustomerUserGeneric',
                Data => { Item => $Entry->[1], %Param},
          );
      }
    }

    foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
      foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
#        if ($Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Activ}) {
          my $PrefKey = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{PrefKey} || '';
          my $Data = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Data};
          my $DataSelected = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{DataSelected} || '';
          my $Type = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Type} || '';
          my %PrefItem = %{$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}};
          if ($Data) {
            $PrefItem{'Option'} = $Self->OptionStrgHashRef(
              Data => $Data,
              Name => "GenericTopic::$PrefKey",
              SelectedID => defined ($Param{$PrefKey}) ? $Param{$PrefKey} : $DataSelected,
            );
          }
          elsif ($PrefKey eq 'UserLanguage') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
                  Name => "GenericTopic::$PrefKey",
                  Selected => $Param{UserLanguage},
              );
          }
          elsif ($PrefKey eq 'UserCharset') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'charset, charset',
                      Table => 'charset',
                      Valid => 1,
                    )
                  },
                  Name => "GenericTopic::$PrefKey",
                  Selected => $Param{UserCharset} || $Self->{ConfigObject}->Get('DefaultCharset'),
              );
          }
          elsif ($PrefKey eq 'UserTheme') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'theme, theme',
                      Table => 'theme',
                      Valid => 1,
                    )
                  },
                  Name => "GenericTopic::$PrefKey",
                  Selected => $Param{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme'),
              );
          }
          if ($Type eq 'Password' || $Type eq 'CustomQueue') {
              # do nothing if the auth! is not a preference!
          }
          else {
              $Param{Preferences} .= $Self->Output(
                TemplateFile => 'AdminCustomerUserPreferences'.$Type,
                Data => \%PrefItem,
              );
          }
#        }
      }
    }

    return $Self->Output(TemplateFile => 'AdminCustomerUserForm', Data => \%Param);
}
# --
sub AdminUserForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{UserOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
                    " $Self->{ConfigObject}->{DatabaseUserTableUser}, ".
                    "$Self->{ConfigObject}->{DatabaseUserTableUserID}",
            Valid => 0,
            Clamp => 1,
            Table => $Self->{ConfigObject}->{DatabaseUserTable},
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('PreferencesView')}) {
      foreach my $Group (@{$Self->{ConfigObject}->Get('PreferencesView')->{$Pref}}) {
        if ($Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type}) {
#        if ($Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Activ}) {
          my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
          my $Data = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Data};
          my $DataSelected = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{DataSelected} || '';
          my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
          my %PrefItem = %{$Self->{ConfigObject}->{PreferencesGroups}->{$Group}};

          if ($Data) {
            if (ref($Data) eq 'HASH') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                Data => $Data,
                Name => "GenericTopic::$PrefKey",
                SelectedID => $Param{$PrefKey} || $DataSelected,
              );
            }
            else {
                $PrefItem{'Option'} = "<input type=\"text\" name=\"GenericTopic::$PrefKey\" ".
                     "value=\"". $Self->Ascii2Html(Text => $Param{$PrefKey}) .'">';
            }
          } 
          elsif ($PrefKey eq 'UserLanguage') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'), 
                  Name => "GenericTopic::$PrefKey",
                  SelectedID => $Param{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage'),
              );
          }
          elsif ($PrefKey eq 'UserCharset') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'charset, charset',
                      Table => 'charset',
                      Valid => 1,
                    )
                  },
                  Name => "GenericTopic::$PrefKey",
                  Selected => $Param{UserCharset} || $Self->{ConfigObject}->Get('DefaultCharset'),
              );
          }
          elsif ($PrefKey eq 'UserTheme') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'theme, theme',
                      Table => 'theme',
                      Valid => 1,
                    )
                  },
                  Name => "GenericTopic::$PrefKey",
                  Selected => $Param{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme'),
              );
          }
          if ($Type eq 'Password' || $Type eq 'CustomQueue') {
              # do nothing if the auth! is not a preference!
          }
          else {
              $Param{Preferences} .= $Self->Output(
                TemplateFile => 'AdminUserPreferences'.$Type,
                Data => \%PrefItem,
              );
          }
#        }
        }
      }
    }


    return $Self->Output(TemplateFile => 'AdminUserForm', Data => \%Param);
}
# --
sub AdminGroupForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{GroupOption} = $Self->OptionStrgHashRef(
        Data => $Param{GroupList},
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->Output(TemplateFile => 'AdminGroupForm', Data => \%Param);
}
# --
sub AdminUserGroupForm {
    my $Self = shift;
    my %Param = @_;
    my $UserData = $Param{UserData};
    my %UserDataTmp = %$UserData;
    my $GroupData = $Param{GroupData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink = $Self->{Baselink} . "Action=AdminUserGroup&";

    foreach (sort {uc($UserDataTmp{$a}) cmp uc($UserDataTmp{$b})} keys %UserDataTmp){
      $Param{UserStrg} .= "<A HREF=\"$BaseLink"."Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    foreach (sort {uc($GroupDataTmp{$a}) cmp uc($GroupDataTmp{$b})} keys %GroupDataTmp){
      $Param{GroupStrg} .= "<A HREF=\"$BaseLink"."Subaction=Group&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }
    # return output
    return $Self->Output(TemplateFile => 'AdminUserGroupForm', Data => \%Param);
}
# --
sub AdminUserGroupChangeForm {
    my $Self = shift;
    my %Param = @_;
    my %Data = %{$Param{Data}};
    my $BaseLink = $Self->{Baselink};
    my $Type = $Param{Type} || 'User';
    my $NeType = 'Group';
    $NeType = 'User' if ($Type eq 'Group');


    $Param{OptionStrg0} .= "<B>\$Text{\"$Type\"}:</B> <A HREF=\"$BaseLink"."Action=Admin$Type&Subaction=Change&ID=$Param{ID}\">" .
    "$Param{Name}</A> (id=$Param{ID})<BR>";
    $Param{OptionStrg0} .= '<INPUT TYPE="hidden" NAME="ID" VALUE="'.$Param{ID}.'"><BR>';

    $Param{OptionStrg0} .= "<br>\n";
    $Param{OptionStrg0} .= "<table>\n";
    $Param{OptionStrg0} .= "<tr><th>\$Text{\"$NeType\"}</th><th>ro</th><th>rw</th></tr>\n";
    foreach (sort {uc($Data{$a}) cmp uc($Data{$b})} keys %Data){
        $Param{OptionStrg0} .= '<tr><td>';
        $Param{OptionStrg0} .= "<a href=\"$BaseLink"."Action=Admin$NeType&Subaction=Change&ID=$_\">$Param{Data}->{$_}</a>";
        my $RoSelected = '';
        if ($Param{Ro}->{$_}) {
            $RoSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td>';
        $Param{OptionStrg0} .= '<input type="checkbox" name="RoIDs" value="'.$_."\"$RoSelected>";
        my $RwSelected = '';
        if ($Param{Rw}->{$_}) {
            $RwSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td>';
        $Param{OptionStrg0} .= '<input type="checkbox" name="RwIDs" value="'.$_."\"$RwSelected>";
        $Param{OptionStrg0} .= '</td></tr>';
    }
    $Param{OptionStrg0} .= "</table>\n";

    return $Self->Output(TemplateFile => 'AdminUserGroupChangeForm', Data => \%Param);
}
# --
sub AdminPOP3Form {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'TrustedOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Trusted',
        SelectedID => $Param{Trusted},
    );

    $Param{'DispatchingOption'} = $Self->OptionStrgHashRef(
        Data => {
            From => 'Dispatching by email To: field.',
            Queue => 'Dispatching by selected Queue.',
        },
        Name => 'DispatchingBy',
        SelectedID => $Param{DispatchingBy},
    );

    $Param{'QueueOption'} = $Self->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          )
        },
        Name => 'QueueID',
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $Param{POP3AccountOption} = $Self->OptionStrgHashRef(
        Data => $Param{POP3AccountList},
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->Output(TemplateFile => 'AdminPOP3Form', Data => \%Param);
}
# --
sub AdminSystemAddressForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'QueueOption'} = $Self->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          )
        },
        Name => 'QueueID',
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $Param{SystemAddressOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, value1, value0',
            Valid => 0,
            Clamp => 1,
            Table => 'system_address',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->Output(TemplateFile => 'AdminSystemAddressForm', Data => \%Param);
}
# --
sub AdminCharsetForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{CharsetOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 0,
            Clamp => 1,
            Table => 'charset',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->Output(TemplateFile => 'AdminCharsetForm', Data => \%Param);
}
# --
sub AdminStateForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{StateOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 0,
            Clamp => 1,
            Table => 'ticket_state',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    $Param{StateTypeOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 0,
            Table => 'ticket_state_type',
          )
        },
        Name => 'TypeID',
        SelectedID => $Param{TypeID},
    );

    return $Self->Output(TemplateFile => 'AdminStateForm', Data => \%Param);
}
# --

1;
 
