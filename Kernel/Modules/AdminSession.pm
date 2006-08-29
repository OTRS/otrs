# --
# Kernel/Modules/AdminSession.pm - to control all session ids
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminSession.pm,v 1.25 2006-08-29 17:17:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSession;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.25 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $WantSessionID = $Self->{ParamObject}->GetParam(Param => 'WantSessionID') || '';

    # ------------------------------------------------------------ #
    # kill session id
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'Kill') {
        $Self->{SessionObject}->RemoveSessionID(SessionID => $WantSessionID);
        return $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");
    }
    # ------------------------------------------------------------ #
    # kill all session id
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'KillAll') {
        my @List = $Self->{SessionObject}->GetAllSessionIDs();
        foreach my $SessionID (@List) {
            # killall sessions but not the own one!
            if ($WantSessionID ne $SessionID) {
                $Self->{SessionObject}->RemoveSessionID(SessionID => $SessionID);
            }
        }
        return $Self->{LayoutObject}->Redirect(OP => "Action=AdminSession");
    }
    # ------------------------------------------------------------ #
    # else, show session list
    # ------------------------------------------------------------ #
    else {
        # get all sessions
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
                    if ($_ =~ /^_/) {
                        next;
                    }
                    if ($_ =~ /Password|Pw/) {
                        $Data{$_} = 'xxxxxxxx';
                    }
                    else {
                        $Data{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Data{$_});
                    }
                    if ($_  eq 'UserSessionStart') {
                        my $Age = int((time() - $Data{UserSessionStart}) / 3600);
                        $Data{UserSessionStart} = scalar localtime ($Data{UserSessionStart});
                        $List .= "" . $_ . "=$Data{$_} / $Age h; ";
                    }
                    else {
                        $List .= "" . $_ . "=$Data{$_}; ";
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
        # generate output
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSession',
            Data => {
                Counter => $Counter,
                %MetaData
            }
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
1;
