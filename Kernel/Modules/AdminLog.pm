# --
# Kernel/Modules/AdminLog.pm - provides a log view for admins
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminLog.pm,v 1.2 2003-01-03 16:17:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminLog;

use strict;

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
    foreach (qw(ParamObject PermissionObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # --
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        return $Self->{LayoutObject}->NoPermission();
    }
    # --
    # print form
    # --
    my $Output = $Self->{LayoutObject}->Header(Title => 'Select box');
    $Output .= $Self->{LayoutObject}->AdminNavigationBar();
    my $LogData = $Self->{LogObject}->GetLog(Limit => 400);
    $Output .= $Self->{LayoutObject}->AdminLog(Log => $LogData);
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
