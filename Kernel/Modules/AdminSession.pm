# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSession.pm,v 1.15 2004-04-05 11:57:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $WantSessionID = $Self->{ParamObject}->GetParam(Param => 'WantSessionID') || '';

    # kill session id
    if ($Self->{Subaction} eq 'Kill') {
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");    
        $Self->{SessionObject}->RemoveSessionID(SessionID => $WantSessionID);    
    }
    # kill all session id
    elsif ($Self->{Subaction} eq 'KillAll') {
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");    
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        foreach my $SessionID (@List) {
            # killall sessions but not the own one!
            if ($WantSessionID ne $SessionID) {
                $Self->{SessionObject}->RemoveSessionID(SessionID => $SessionID);    
            }
        }
    }
    # else, show session list 
    else {
        $Output .= $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Session Management');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        my $Table = '';
        my $Counter = @List;
        my %MetaData = ();
        $MetaData{UserSession} = 0;
        $MetaData{CustomerSession} = 0;
        $MetaData{UserSessionUniq} = 0;
        $MetaData{CustomerSessionUniq} = 0;
        foreach my $SessionID (@List) {
            my %Data = $Self->{SessionObject}->GetSessionIDData(SessionID => $SessionID);
            $MetaData{"$Data{UserType}Session"}++;
            if (!$MetaData{"$Data{UserLogin}"}) {
                $MetaData{"$Data{UserType}SessionUniq"}++;
                $MetaData{"$Data{UserLogin}"} = 1;
            }
            $Table .= $Self->MaskSessionTable(SessionID => $SessionID, %Data);
        }
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSession', 
            Data => {
                Counter => $Counter, 
                %MetaData
            }
        );
        $Output .= $Table;
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub MaskSessionTable {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    foreach (sort keys %Param) {
      if (($_) && (defined($Param{$_})) && $_ ne 'SessionID') {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_});
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
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSessionTable', 
        Data => \%Param,
    );
}
# --
1;
