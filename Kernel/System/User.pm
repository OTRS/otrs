# --
# User.pm - some db functions fot user funktions
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: User.pm,v 1.1 2002-02-07 00:03:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::User;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID};
    my @LockIDs = (2);
    my %Data;

    $Self->Prepare(
       SQL => "SELECT ar.id as ca, st.name, ti.id, ar.create_by" .
              " FROM " .
              " ticket ti, article ar, article_sender_type st" .
              " WHERE " .
              " ti.user_id = $UserID " .
              " AND " .
              " ti.ticket_lock_id in ( ${\(join ', ', @LockIDs)} )" .
              " AND " .
              " ar.ticket_id = ti.id " .
              " AND " .
              " st.id = ar.article_sender_type_id " .
              " ORDER BY ar.create_time DESC",
    );

    while (my @RowTmp = $Self->FetchrowArray()) {
        if (!$Data{"ID$RowTmp[2]"}) {
          $Data{'Count'}++;
          if ($RowTmp[1] ne 'agent' || $RowTmp[3] ne $UserID) {
            $Data{'ToDo'}++;
          }
        }
        $Data{"ID$RowTmp[2]"} = 1;
    }
    return %Data;
}
# --
sub GetGroups {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my %Groups = ();

    my $SQL = "SELECT g.id, g.name " .
    " FROM " .
    " groups g, group_user gu".
    " WHERE " .
    " gu.user_id = $UserID".
    " AND " .
    " g.id = gu.group_id ";

    $Self->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->FetchrowArray()) {
         $Groups{$RowTmp[0]} = $RowTmp[1];
    }

    return %Groups;
} 
# --

1;
