# --
# AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSelectBox.pm,v 1.1 2001-12-23 13:27:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    foreach ('ParamObject', 'DBObject', 'PermissionObject', 'LayoutObject', 'LogObject', 'ConfigObject') {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Subaction = $Self->{Subaction}; 

    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    # print form
    if ($Subaction eq '' || !$Subaction) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminSelectBoxForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # do select
    elsif ($Subaction eq 'Select') {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my $SQL = $Self->{ParamObject}->GetParam(Param => 'SQL') || '';
        my $Max = $Self->{ParamObject}->GetParam(Param => 'Max') || '';
        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Max);
        my @Data = ();
        while (my $Row = $Self->{DBObject}->FetchrowHashref() ){
             push (@Data, $Row);
        }
        $Output .= $Self->{LayoutObject}->AdminSelectBoxResult(Data => \@Data, SQL => $SQL, Limit => $Max);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # else! error!
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No Subaction!!',
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

