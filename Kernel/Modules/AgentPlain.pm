# --
# Kernel/Modules/AgentPlain.pm - to get a plain view
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPlain.pm,v 1.7 2002-07-13 12:21:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPlain;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    foreach (
      'ParamObject', 
      'DBObject', 
      'TicketObject', 
      'LayoutObject', 
      'LogObject', 
      'ConfigObject',
      'UserObject',
      'ArticleObject',
    ) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $Limit = 50;
    my $QueueID = $Self->{QueueID};
    my $UserID = $Self->{UserID};
    my $ArticleID = $Self->{ArticleID};

    if (!$ArticleID) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No ArticleID!",
            Comment => 'Please contact your admin'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{TicketObject}->Permission(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {

        my $Text = $Self->{ArticleObject}->GetPlain(ArticleID => $ArticleID) || '';
        $Output .= $Self->{LayoutObject}->Header(Title => "Plain Article");
        my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

        if ($Text) {
            $Output .= $Self->{LayoutObject}->ArticlePlain(
                Backscreen => $Self->{BackScreen},
                Text => $Text,
                TicketID => $Self->{TicketID},
                ArticleID => $ArticleID,
            );
        }
        else {
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Can't read plain article! Maybe there is no plain email in filesystem! Read BackendMessage.",
                Comment => 'Please contact your admin!',
            );
        }
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    else {
        # --
        # error screen
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
}
# --

1;

