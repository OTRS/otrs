# --
# Kernel/Output/HTML/Admin.pm - provides generic admin HTML output
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Admin.pm,v 1.47 2004-02-03 23:07:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Admin;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.47 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub AdminNavigationBar {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
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
        Max => 55,
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
          if ($PrefKey eq 'UserLanguage') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
                  Name => "GenericTopic::$PrefKey",
                  SelectedID => $Param{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage'),
                  HTMLQuote => 0,
              );
          }
          elsif ($Data) {
            $PrefItem{'Option'} = $Self->OptionStrgHashRef(
              Data => $Data,
              Name => "GenericTopic::$PrefKey",
              SelectedID => defined ($Param{$PrefKey}) ? $Param{$PrefKey} : $DataSelected,
              HTMLQuote => 0,
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
                  HTMLQuote => 0,
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

1;
