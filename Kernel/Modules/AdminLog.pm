# --
# Kernel/Modules/AdminLog.pm - provides a log view for admins
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminLog.pm,v 1.4.2.1 2003-05-01 20:58:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminLog;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4.2.1 $';
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
    foreach (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # --
    # print form
    # --
    my $Output = $Self->{LayoutObject}->Header(Title => 'System Log');
    $Output .= $Self->{LayoutObject}->AdminNavigationBar();
    my $LogData = $Self->{LogObject}->GetLog(Limit => 400);
    $Output .= $Self->{LayoutObject}->AdminLog(Log => $LogData);
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --

1;
