# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminEmail.pm,v 1.10 2003-04-12 23:41:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
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
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
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
    foreach (qw(From Subject Body Bcc GroupPermission)) {
        $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_) || $Param{$_} || '';
    }
    # --
    # send email(s)
    # --
    if ($Self->{Subaction} eq 'Send') {
        # --
        # check needed stuff
        # --
        foreach (qw(From Subject Body GroupPermission)) {
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
        my %Bcc = ();
        # --
        # get user recipients address
        # --
        foreach ($Self->{ParamObject}->GetArray(Param => 'UserIDs')) {
            my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
            if ($UserData{UserEmail}) {
                $Bcc{$UserData{UserLogin}} = $UserData{UserEmail};
            }
        }
        # --
        # get group recipients address
        # --
        foreach ($Self->{ParamObject}->GetArray(Param => 'GroupIDs')) {
            my @GroupMemberList = $Self->{GroupObject}->GroupMemberList(
                Result => 'ID',
                Type => $Param{GroupPermission},
                GroupID => $_,
            );
            foreach (@GroupMemberList) {
                my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
                if ($UserData{UserEmail}) {
                    $Bcc{$UserData{UserLogin}} = $UserData{UserEmail};
                }
            }
        }
        foreach (sort keys %Bcc) {
            $Param{Bcc} .= "$Bcc{$_},";
        }
        # --
        # check needed stuff
        # --
        foreach (qw(Bcc)) {
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
        my %Groups = $Self->{GroupObject}->GroupList(Valid => 1);
        $Output .= $Self->{LayoutObject}->AdminEmail(
            UserList => \%Users, 
            GroupList => \%Groups,
            %Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
