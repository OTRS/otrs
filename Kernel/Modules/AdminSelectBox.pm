# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSelectBox.pm,v 1.3 2002-07-21 17:29:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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
    foreach (qw(ParamObject DBObject PermissionObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Subaction = $Self->{Subaction}; 
    # --
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        return $Self->{LayoutObject}->NoPermission();
    }
    # --
    # print form
    # --
    if ($Subaction eq '' || !$Subaction) {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Select box');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminSelectBoxForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # do select
    # --
    elsif ($Subaction eq 'Select') {
        my $SQL = $Self->{ParamObject}->GetParam(Param => 'SQL') || '';
        my $Max = $Self->{ParamObject}->GetParam(Param => 'Max') || '';
        my $Output = $Self->{LayoutObject}->Header(Title => 'Select box');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        if ($Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Max)) {
          my @Data = ();
          while (my $Row = $Self->{DBObject}->FetchrowHashref() ){
             push (@Data, $Row);
          }
          $Output .= $Self->{LayoutObject}->AdminSelectBoxResult(
            Data => \@Data, 
            SQL => $SQL, 
            Limit => $Max,
          );
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
       }
       else {
         my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
         $Output .= $Self->{LayoutObject}->AdminNavigationBar();
         $Output .= $Self->{LayoutObject}->Error();
         $Output .= $Self->{LayoutObject}->Footer();
         return $Output;
       }
    } 
    # --
    # else! error!
    # --
    else {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No Subaction!!',
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;

