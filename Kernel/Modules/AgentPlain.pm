# --
# AgentPlain.pm - to get a plain view
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPlain.pm,v 1.2 2002-04-13 11:16:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPlain;

use strict;

use Kernel::System::Article;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    my $ArticleOjbect = Kernel::System::Article->new(
        DBObject => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject}, 
    );
    my $Text = $ArticleOjbect->GetPlain(ArticleID => $ArticleID);

    $Output .= $Self->{LayoutObject}->Header(Title => "Plain Article");
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    $Output .= $Self->{LayoutObject}->ArticlePlain(
                Backscreen => $Self->{BackScreen},
                Text => $Text,
                TicketID => $Self->{TicketID},
                ArticleID => $ArticleID,
			);
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;

