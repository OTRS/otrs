# --
# Kernel/Output/HTML/Customer.pm - provides generic customer HTML output
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Customer.pm,v 1.36 2004-06-22 11:44:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Customer;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.36 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub CustomerLogin {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # add cookies if exists
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    $Self->Output(TemplateFile => 'CustomerLogin', Data => \%Param);
    # get language options
    $Param{Language} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
        Name => 'Lang',
        SelectedID => $Self->{UserLanguage},
        OnChange => 'submit()',
        HTMLQuote => 0,
        LanguageTranslation => 0,
    );
    # get lost password output
    if ($Self->{ConfigObject}->Get('CustomerPanelLostPassword')
        && $Self->{ConfigObject}->Get('Customer::AuthModule') eq 'Kernel::System::CustomerAuth::DB') {
        $Param{LostPassword} = $Self->Output(TemplateFile => 'CustomerLostPassword', Data => \%Param);
    }
    # get lost password output
    if ($Self->{ConfigObject}->Get('CustomerPanelCreateAccount') 
        && $Self->{ConfigObject}->Get('Customer::AuthModule') eq 'Kernel::System::CustomerAuth::DB') {
        $Param{CreateAccount} = $Self->Output(TemplateFile => 'CustomerCreateAccount', Data => \%Param);
    }
    # create & return output
    $Output .= $Self->Output(TemplateFile => 'CustomerLogin', Data => \%Param);
    return $Output;
}
# --
sub CustomerHeader {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # add cookies if exists
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # create & return output
    $Output .= $Self->Output(TemplateFile => 'CustomerHeader', Data => \%Param);
    return $Output;
}
# --
sub CustomerFooter {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'CustomerFooter', Data => \%Param);
}
# --
sub CustomerNavigationBar {
    my $Self = shift;
    my %Param = @_;
    # run notification modules 
    if (ref($Self->{ConfigObject}->Get('CustomerFrontend::NotifyModule')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('CustomerFrontend::NotifyModule')};
        foreach my $Job (sort keys %Jobs) {
            # log try of load module
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Try to load module: $Jobs{$Job}->{Module}!",
                );
            }
            if (eval "require $Jobs{$Job}->{Module}") {
                my $Object = $Jobs{$Job}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    LayoutObject => $Self,
                    UserID => $Self->{UserID},
                    Debug => $Self->{Debug},
                );
                # log loaded module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Module: $Jobs{$Job}->{Module} loaded!",
                    );
                }
                # run module 
                $Param{Notification} .= $Object->Run(%Param, Config => $Jobs{$Job});
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't load module $Jobs{$Job}->{Module}!",
                );
            }
        }
    }
    if ($Self->{UserEmail} ne $Self->{UserCustomerID}) {
        $Param{UserLoginTop} = "$Self->{UserEmail}/$Self->{UserCustomerID}";
    }
    else {
        $Param{UserLoginTop} = $Self->{UserEmail};
    }
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerNavigationBar', Data => \%Param);
}
# --
sub CustomerError {
    my $Self = shift;
    my %Param = @_;

    # get backend error messages
    foreach (qw(Message Traceback)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->GetLogEntry(
          Type => 'Error', 
          What => $_
      ) || '';
      $Param{'Backend'.$_} = $Self->Ascii2Html(
          Text => $Param{'Backend'.$_},
          HTMLResultMode => 1,
      );
    }

    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
    } 

    # create & return output
    return $Self->Output(TemplateFile => 'CustomerError', Data => \%Param);
}
# --
sub CustomerPreferencesForm {
    my $Self = shift;
    my %Param = @_;

    foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
      foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
        if ($Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Activ}) {
          my $PrefKey = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{PrefKey} || '';
          my $Data = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Data};
          my $Type = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Type} || '';
          my $DataSelected = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{DataSelected} || '';

          my %PrefItem = %{$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}};
          my $HTMLQuote = 1;
          if ($PrefKey eq 'UserLanguage') {
              $HTMLQuote = 0;
          }
          if ($Data) { 
            $PrefItem{'Option'} = $Self->OptionStrgHashRef(
              Data => $Data, 
              Name => 'GenericTopic',
              SelectedID => defined ($Self->{$PrefKey}) ? $Self->{$PrefKey} : $DataSelected,
              HTMLQuote => $HTMLQuote,
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
                  Name => 'GenericTopic',
                  Selected => $Self->{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme'),
              );
          }
          if ($Type eq 'Password' && $Self->{ConfigObject}->Get('Customer::AuthModule') =~ /ldap/i) {
              # do nothing if the auth module is ldap
          }
          else {
              $Param{$Pref} .= $Self->Output(
                TemplateFile => 'CustomerPreferences'.$Type,
                Data => \%PrefItem,
              );
          }
        }
      }
    }
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerPreferencesForm', Data => \%Param);
}
# --
sub CustomerWarning {
    my $Self = shift;
    my %Param = @_;

    # get backend error messages
    foreach (qw(Message)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->GetLogEntry(
          Type => 'Notice',
          What => $_
      ) || $Self->{LogObject}->GetLogEntry(
          Type => 'Error',
          What => $_
      ) || '';
      $Param{'Backend'.$_} = $Self->Ascii2Html(
          Text => $Param{'Backend'.$_},
          HTMLResultMode => 1,
      );
    }
    # create & return output
    return $Self->Output(TemplateFile => 'CustomerWarning', Data => \%Param);
}
# --
sub CustomerNoPermission {
    my $Self = shift;
    my %Param = @_;
    my $WithHeader = $Param{WithHeader} || 'yes';
    my $Output = '';
    $Param{Message} = 'No Permission!' if (!$Param{Message});
    # create output
    $Output = $Self->CustomerHeader(Title => 'No Permission') if ($WithHeader eq 'yes');
    $Output .= $Self->Output(TemplateFile => 'NoPermission', Data => \%Param);
    $Output .= $Self->CustomerFooter() if ($WithHeader eq 'yes');
    # return output
    return $Output;
}
# --

1;
