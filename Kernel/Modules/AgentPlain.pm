# --
# Kernel/Modules/AgentPlain.pm - to get a plain view
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPlain.pm,v 1.12 2003-03-06 22:11:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPlain;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject 
      ConfigObject UserObject)) {
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

    # --
    # check needed stuff
    # --
    if (!$Self->{ArticleID}) {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No ArticleID!",
            Comment => 'Please contact your admin'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    my $Text = $Self->{TicketObject}->GetArticlePlain(ArticleID => $Self->{ArticleID}) || '';
    $Output .= $Self->{LayoutObject}->Header(Title => "Plain Article");
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    if ($Text) {
        $Output .= $Self->{LayoutObject}->ArticlePlain(
            Backscreen => $Self->{BackScreen},
            Text => $Text,
            TicketID => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
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
# --

1;

