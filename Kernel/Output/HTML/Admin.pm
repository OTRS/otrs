# --
# HTML/Admin.pm - provides generic admin HTML output
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Admin.pm,v 1.16 2002-10-15 09:30:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Admin;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    my $Output = '';

    # create & return output
    return $Self->Output(TemplateFile => 'AdminSession', Data => \%Param);
}
# --
sub AdminEmail {
    my $Self = shift;
    my %Param = @_;

    $Param{'UserOption'} = $Self->OptionStrgHashRef(
        Data => $Param{UserList},
        Name => 'UserIDs', 
        Size => 8,
        SelectedID => $Param{ID},
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
      if (($_) && ($Param{$_}) && $_ ne 'SessionID') {
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

    $Param{'Subaction'} = "Add" if (!$Param{'Subaction'});

    return $Self->Output(TemplateFile => 'AdminResponseForm', Data => \%Param);
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

    $Param{'QueueOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Clamp => 1,
            Table => 'queue',
          )
        },
        Name => 'QueueID',
        Size => 15,
        SelectedID => $Param{QueueID},
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
            What => 'id, name, id',
            Valid => 1,
            Clamp => 1,
            Table => 'follow_up_possible',
          )
        },
        Name => 'FollowUpID',
        SelectedID => $Param{FollowUpID},
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
            What => "id, login, id",
            Valid => 0,
            Clamp => 1,
            Table => 'customer_user',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

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

    $Param{'CharsetOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'charset, charset',
            Table => 'charset',
            Valid => 1,
          )
        },
        Name => 'Charset',
        Selected => $Param{UserCharset},
    );

    $Param{'ThemeOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'theme, theme',
            Table => 'theme',
            Valid => 1,
          )
        },
        Name => 'Theme',
        Selected => $Param{UserTheme},
    );

    $Param{'LanguageOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'language, language',
            Table => 'language',
            Valid => 1,
          )
        },
        Name => 'Language',
        Selected => $Param{UserLanguage},
    );

    $Param{'SendFollowUpNotificationYesNoOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'UserSendFollowUpNotification',
        SelectedID => $Param{UserSendFollowUpNotification},
    );

    $Param{'SendNewTicketNotificationYesNoOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'UserSendNewTicketNotification',
        SelectedID => $Param{UserSendNewTicketNotification},
    );


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
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 0,
            Clamp => 1,
            Table => 'groups',
          )
        },
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

    foreach (sort {$UserDataTmp{$a} cmp $UserDataTmp{$b}} keys %UserDataTmp){
      $Param{UserStrg} .= "<A HREF=\"$BaseLink"."Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    foreach (sort {$GroupDataTmp{$a} cmp $GroupDataTmp{$b}} keys %GroupDataTmp){
      $Param{GroupStrg} .= "<A HREF=\"$BaseLink"."Subaction=Group&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }
    # return output
    return $Self->Output(TemplateFile => 'AdminUserGroupForm', Data => \%Param);
}
# --
sub AdminUserGroupChangeForm {
    my $Self = shift;
    my %Param = @_;
    my $FirstData = $Param{FirstData};
    my %FirstDataTmp = %$FirstData;
    my $SecondData = $Param{SecondData};
    my %SecondDataTmp = %$SecondData;
    my $Data = $Param{Data};
    my %DataTmp = %$Data;
    my $BaseLink = $Self->{Baselink};
    my $Type = $Param{Type} || 'User';
    my $NeType = 'Group';
    $NeType = 'User' if ($Type eq 'Group');


    foreach (sort keys %FirstDataTmp){
        $Param{OptionStrg0} .= "<B>\$Text{\"$Type\"}:</B> <A HREF=\"$BaseLink"."Action=Admin$Type&Subaction=Change&ID=$_\">" .
          "$FirstDataTmp{$_}</A> (id=$_)<BR>";
        $Param{OptionStrg0} .= "<INPUT TYPE=\"hidden\" NAME=\"ID\" VALUE=\"$_\"><BR>\n";
    }

    $Param{OptionStrg0} .= "<B>\$Text{\"$NeType:\"}</B><BR> <SELECT NAME=\"IDs\" SIZE=10 multiple>\n";
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


    return $Self->Output(TemplateFile => 'AdminUserGroupChangeForm', Data => \%Param);
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

    $Param{'QueueOption'} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 1,
            Clamp => 1,
            Table => 'queue',
          )
        },
        Name => 'QueueID',
        SelectedID => $Param{QueueID},
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
sub AdminLanguageForm {
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

    $Param{LanguageOption} = $Self->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, language, id',
            Valid => 0,
            Clamp => 1,
            Table => 'language',
          )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{ID},
    );

    return $Self->Output(TemplateFile => 'AdminLanguageForm', Data => \%Param);
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

    return $Self->Output(TemplateFile => 'AdminStateForm', Data => \%Param);
}
# --

1;
 
