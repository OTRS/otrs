# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSession.pm,v 1.17 2004-09-16 22:04:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.17 $';
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
        $Output .= $Self->{LayoutObject}->NavigationBar(Type => 'Admin');
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        my $Table = '';
        my $Counter = @List;
        my %MetaData = ();
        $MetaData{UserSession} = 0;
        $MetaData{CustomerSession} = 0;
        $MetaData{UserSessionUniq} = 0;
        $MetaData{CustomerSessionUniq} = 0;
        foreach my $SessionID (@List) {
            my $List = '';
            my %Data = $Self->{SessionObject}->GetSessionIDData(SessionID => $SessionID);
            $MetaData{"$Data{UserType}Session"}++;
            if (!$MetaData{"$Data{UserLogin}"}) {
                $MetaData{"$Data{UserType}SessionUniq"}++;
                $MetaData{"$Data{UserLogin}"} = 1;
            }
            foreach (sort keys %Data) {
                if (($_) && (defined($Data{$_})) && $_ ne 'SessionID') {
                    $Data{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Data{$_});
                    if ($_  eq 'UserSessionStart') {
                        my $Age = int((time() - $Data{UserSessionStart}) / 3600);
                        $Data{UserSessionStart} = scalar localtime ($Data{UserSessionStart});
                        $List .= "[ " . $_ . " = $Data{$_} / $Age h ]<br>";
                    }
                    else {
                        $List .= "[ " . $_ . " = $Data{$_} ]<br>";
                    }
                }
            }
            # create blocks
            $Self->{LayoutObject}->Block(
                Name => 'Session',
                Data => {
                    SessionID => $SessionID,
                    Output => $List,
                    %Data,
                },
            ); 
        }
        # get real template
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSession', 
            Data => {
                Counter => $Counter, 
                %MetaData
            }
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
1;
