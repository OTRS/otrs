# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminEmail.pm,v 1.7 2003-03-06 22:11:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
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
    # --
    # check needed Opjects
    # --
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject PermissionObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        return $Self->{LayoutObject}->NoPermission();
    }
    # --
    # send email(s)
    # --
    if ($Self->{Subaction} eq 'Send') {
        # --
        # get recipients address
        # --
        foreach ($Self->{ParamObject}->GetArray(Param => 'UserIDs')) {
            my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
            if ($UserData{UserEmail}) {
                $Param{Bcc} .= "$UserData{UserEmail}, ";
            }
        }
        # --
        # check needed stuff
        # --
        foreach (qw(From Subject Body Bcc)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || $Param{$_} || '';
            if (!$Param{$_}) {
                $Output = $Self->{LayoutObject}->Header(Title => 'Warning');
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Need $_!",
                    Comment => 'Click back and check the needed value.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        # --
        # send mail
        # --
        $Output .= $Self->{LayoutObject}->Header(Title => 'Admin-Email');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        if ($Self->{SendmailObject}->Send(%Param)) {
            $Output .= $Self->{LayoutObject}->AdminEmailSent(%Param);
        }
        else {
            $Output .= $Self->{LayoutObject}->Error();
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Admin-Email');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my %Users = $Self->{UserObject}->UserList(Valid => 1);
        $Output .= $Self->{LayoutObject}->AdminEmail(UserList => \%Users);
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
