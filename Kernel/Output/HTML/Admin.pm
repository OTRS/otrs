# --
# Kernel/Output/HTML/Admin.pm - provides generic admin HTML output
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Admin.pm,v 1.57 2004-09-16 22:03:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Admin;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.57 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub AdminCustomerUserForm {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    # build source string
    $Param{'SourceOption'} = $Self->OptionStrgHashRef(
        Data => $Param{SourceList},
        Name => 'Source',
        SelectedID => $Param{Source},
    );

    foreach my $Entry (@{$Self->{ConfigObject}->Get($Param{Source})->{Map}}) {
      if ($Entry->[0]) {
          # check input type
          if ($Entry->[0] =~ /^UserPasswor/i) {
              $Param{Type} = 'password';
          }
          else {
              $Param{Type} = 'text';
          }
          # check if login auto creation
          if ($Self->{ConfigObject}->Get($Param{Source})->{AutoLoginCreation} && $Entry->[0] =~ /^UserLogin$/) {
              $Param{Type} = 'hidden';
          }
          if ($Entry->[7]) {
              $Param{ReadOnlyType} = 'readonly';
              $Param{ReadOnly} = '*';
          }
          else {
              $Param{ReadOnlyType} = '';
              $Param{ReadOnly} = '';
          }
          # build selections or input fields
          if ($Self->{ConfigObject}->Get($Param{Source})->{Selections}->{$Entry->[0]}) {
              # build ValidID string
              $Param{Value} = $Self->OptionStrgHashRef(
                  Data => $Self->{ConfigObject}->Get($Param{Source})->{Selections}->{$Entry->[0]},
                  Name => $Entry->[0],
                  SelectedID => $Param{$Entry->[0]},
              );

          }
          elsif ($Entry->[0] =~ /^ValidID/i) {
              # build ValidID string
              $Param{Value} = $Self->OptionStrgHashRef(
                  Data => {
                      $Self->{DBObject}->GetTableData(
                          What => 'id, name',
                          Table => 'valid',
                          Valid => 0,
                      )
                  },
                  Name => $Entry->[0],
                  SelectedID => $Param{$Entry->[0]},
              );
          }
          else {
             my $Value = $Self->{LayoutObject}->Ascii2Html(
                 Text => $Param{$Entry->[0]} || '',
                 HTMLQuote => 1,
                 LanguageTranslation => 0,
             ) || '';
             $Param{Value} = "<input type=\"$Param{Type}\" name=\"$Entry->[0]\" value=\"$Value\" size=\"35\" maxlength=\"50\" $Param{ReadOnlyType}>";
          }
          # show required flag
          if ($Entry->[4]) {
              $Param{Required} = '*';
          }
          else {
              $Param{Required} = '';
          }
          # add form option
          if ($Param{Type} eq 'hidden') {
              $Param{Preferences} .= $Param{Value};
          }
          else {
              $Self->Block(
                  Name => 'Generic',
                  Data => { Item => $Entry->[1], %Param},
              );
          }
      }
    }
   my $PreferencesUsed = $Self->{ConfigObject}->Get($Param{Source})->{AdminSetPreferences};
   if ((defined($PreferencesUsed) && $PreferencesUsed != 0) || !defined($PreferencesUsed)) { 
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
          elsif ($Type eq 'Upload') {
              $Self->Block(
                  Name => "Preferences$Type",
                  Data => {%Param, Filename => $Param{$PrefKey."::Filename"}, %PrefItem},
              );
          }
          else {
              $Self->Block(
                  Name => "Preferences$Type",
                  Data => \%PrefItem,
              );
          }
#        }
      }
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
          elsif ($Type eq 'Upload') {
              $Self->Block(
                  Name => "Preferences$Type",
                  Data => {Filename => $Param{$PrefKey."::Filename"}, %PrefItem},
              );
          }
          else {
              $Self->Block(
                  Name => "Preferences$Type",
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
