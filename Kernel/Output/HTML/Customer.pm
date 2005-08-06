# --
# Kernel/Output/HTML/Customer.pm - provides generic customer HTML output
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Customer.pm,v 1.43 2005-08-06 16:19:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Customer;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.43 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub CustomerLogin {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
        $Param{TitleArea} = " :: ".$Self->{LanguageObject}->Get('Login');
    # add cookies if exists
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
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
        $Self->Block(
            Name => 'LostPassword',
            Data => \%Param,
        );
    }
    # get lost password output
    if ($Self->{ConfigObject}->Get('CustomerPanelCreateAccount')
        && $Self->{ConfigObject}->Get('Customer::AuthModule') eq 'Kernel::System::CustomerAuth::DB') {
        $Self->Block(
            Name => 'CreateAccount',
            Data => \%Param,
        );
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
    my $Type = $Param{Type} || '';
    # add cookies if exists
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # area and title
    if (!$Param{Area}) {
        $Param{Area} = $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{$Self->{Action}}->{NavBarName} || '';
    }
    if (!$Param{Title}) {
        $Param{Title} = $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{$Self->{Action}}->{Title} || '';
    }
    if (!$Param{Area}) {
        $Param{Area} = $Self->{ConfigObject}->Get('PublicFrontend::Module')->{$Self->{Action}}->{NavBarName} || '';
    }
    if (!$Param{Title}) {
        $Param{Title} = $Self->{ConfigObject}->Get('PublicFrontend::Module')->{$Self->{Action}}->{Title} || '';
    }
    foreach (qw(Area Title Value)) {
        if ($Param{$_}) {
            $Param{TitleArea} .= " :: ".$Self->{LanguageObject}->Get($Param{$_});
        }
    }
    # create & return output
    $Output .= $Self->Output(TemplateFile => "CustomerHeader$Type", Data => \%Param);
    return $Output;
}
# --
sub CustomerFooter {
    my $Self = shift;
    my %Param = @_;
    my $Type = $Param{Type} || '';
    # create & return output
    return $Self->Output(TemplateFile => "CustomerFooter$Type", Data => \%Param);
}
# --
sub CustomerNavigationBar {
    my $Self = shift;
    my %Param = @_;
    # create menu items
    my %NavBarModule = ();
    foreach my $Module (sort keys %{$Self->{ConfigObject}->Get('CustomerFrontend::Module')}) {
        my %Hash = %{$Self->{ConfigObject}->Get('CustomerFrontend::Module')->{$Module}};
        if ($Hash{NavBar} && ref($Hash{NavBar}) eq 'ARRAY') {
            my @Items = @{$Hash{NavBar}};
            foreach my $Item (@Items) {
                foreach (1..51) {
                   if ($NavBarModule{sprintf("%07d", $Item->{Prio})}) {
                       $Item->{Prio}++;
                   }
                   if (!$NavBarModule{sprintf("%07d", $Item->{Prio})}) {
                        last;
                    }
                }
                $NavBarModule{sprintf("%07d", $Item->{Prio})} = $Item;
            }
        }
    }
    foreach (sort keys %NavBarModule) {
        $Self->Block(
            Name => $NavBarModule{$_}->{Block} || 'Item',
            Data => $NavBarModule{$_},
        );
    }
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
                    TimeObject => $Self->{TimeObject},
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
    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
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
sub CustomerFreeDate {
    my $Self = shift;
    my %Param = @_;
    my %NullOption = ();
    my %SelectData = ();
    my %Ticket = ();
    my %Config = ();
    if ($Param{NullOption}) {
#        $NullOption{''} = '-';
        $SelectData{Size} = 3;
        $SelectData{Multiple} = 1;
    }
    if ($Param{Ticket}) {
        %Ticket = %{$Param{Ticket}};
    }
    if ($Param{Config}) {
        %Config = %{$Param{Config}};
    }
    my %Data = ();
    foreach my $Count (1..2) {
        $Data{'TicketFreeTime'.$Count} = $Self->BuildDateSelection(
            Area => 'Customer',
            %Param,
            %Ticket,
            Prefix => 'TicketFreeTime'.$Count,
            Format => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get('TicketFreeTimeDiff'.$Count) || 0,
        );
    }
    return %Data;
}

1;
